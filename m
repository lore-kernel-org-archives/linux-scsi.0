From: Andrew Morton <akpm@osdl.org>
Subject: Re: [BK PATCH] SCSI host num allocation improvement
Date: Fri, 27 Feb 2004 14:30:33 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040227143033.731e20df.akpm@osdl.org>
References: <20040226235412.GA819@phunnypharm.org>
	<20040226171928.750f5f6f.akpm@osdl.org>
	<20040226173743.2bf473b4.akpm@osdl.org>
	<20040227030428.GA707@phunnypharm.org>
	<20040227163341.GB1424@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:63127 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S263164AbUB0W2n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2004 17:28:43 -0500
In-Reply-To: <20040227163341.GB1424@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: bcollins@debian.org, James.Bottomley@steeleye.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Mike Anderson <andmike@us.ibm.com> wrote:
>
> Ben Collins [bcollins@debian.org] wrote:
> >  static void scsi_host_cls_release(struct class_device *class_dev)
> >  {
> > +	down(&host_num_lock);
> > +	idr_remove(&allocated_hosts, class_to_shost(class_dev)->host_no);
> > +	up(&host_num_lock);
> >  	put_device(&class_to_shost(class_dev)->shost_gendev);
> >  }
> >  
> 
> Should the idr_remove be done in scsi_host_dev_release instead? We
> really should not make this number available until everyone is done with
> this host.

Beats me.  If you're right, this is the patch.



diff -puN drivers/scsi/hosts.c~scsi-host-allocation-fix drivers/scsi/hosts.c
--- 25/drivers/scsi/hosts.c~scsi-host-allocation-fix	Fri Feb 27 14:11:47 2004
+++ 25-akpm/drivers/scsi/hosts.c	Fri Feb 27 14:29:01 2004
@@ -30,6 +30,7 @@
 #include <linux/list.h>
 #include <linux/completion.h>
 #include <linux/unistd.h>
+#include <linux/idr.h>
 
 #include <scsi/scsi_host.h>
 #include "scsi.h"
@@ -37,9 +38,26 @@
 #include "scsi_priv.h"
 #include "scsi_logging.h"
 
+static DECLARE_MUTEX(host_num_lock);
+static struct idr allocated_hosts;
 
-static int scsi_host_next_hn;		/* host_no for next new host */
+static int alloc_host_no(void)
+{
+	int ret = -ENOMEM;
+
+	down(&host_num_lock);
+	if (idr_pre_get(&allocated_hosts, GFP_KERNEL))
+		ret = idr_get_new(&allocated_hosts, NULL);
+	up(&host_num_lock);
+	return ret;
+}
 
+static void free_host_no(int host_no)
+{
+	down(&host_num_lock);
+	idr_remove(&allocated_hosts, host_no);
+	up(&host_num_lock);
+}
 
 static void scsi_host_cls_release(struct class_device *class_dev)
 {
@@ -163,9 +181,11 @@ static void scsi_host_dev_release(struct
 	 */
 	if (parent)
 		put_device(parent);
+	free_host_no(shost->host_no);
 	kfree(shost);
 }
 
+
 /**
  * scsi_host_alloc - register a scsi host adapter instance.
  * @sht:	pointer to scsi host template
@@ -184,6 +204,7 @@ struct Scsi_Host *scsi_host_alloc(struct
 	struct Scsi_Host *shost;
 	int gfp_mask = GFP_KERNEL, rval;
 	DECLARE_COMPLETION(complete);
+	int host_no;
 
 	if (sht->unchecked_isa_dma && privsize)
 		gfp_mask |= __GFP_DMA;
@@ -214,7 +235,6 @@ struct Scsi_Host *scsi_host_alloc(struct
 
 	init_MUTEX(&shost->scan_mutex);
 
-	shost->host_no = scsi_host_next_hn++; /* XXX(hch): still racy */
 	shost->dma_channel = 0xff;
 
 	/* These three are default values which can be overridden */
@@ -259,6 +279,11 @@ struct Scsi_Host *scsi_host_alloc(struct
 	else
 		shost->dma_boundary = 0xffffffff;
 
+	host_no = alloc_host_no();
+	if (host_no < 0)
+		goto fail_kfree;
+	shost->host_no = host_no;
+
 	rval = scsi_setup_command_freelist(shost);
 	if (rval)
 		goto fail_kfree;
@@ -361,6 +386,7 @@ void scsi_host_put(struct Scsi_Host *sho
 
 int scsi_init_hosts(void)
 {
+	idr_init(&allocated_hosts);
 	return class_register(&shost_class);
 }
 

_

