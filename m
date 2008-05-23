From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: 2.6.26-rc2-mm1 (SCSI_DH build errors)
Date: Fri, 23 May 2008 12:39:20 -0700
Message-ID: <1211571560.10532.7.camel@chandra-ubuntu>
References: <20080514010129.4f672378.akpm@linux-foundation.org>
	 <20080514141348.e71feed6.randy.dunlap@oracle.com>
	 <1210862779.15852.4.camel@localhost.localdomain>
	 <1210881374.21974.285.camel@chandra-ubuntu>
	 <20080522202543.d15e8c3b.akpm@linux-foundation.org>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:60397 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837AbYEWTjd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 May 2008 15:39:33 -0400
In-Reply-To: <20080522202543.d15e8c3b.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org, hare@suse.de, scsi <linux-scsi@vger.kernel.org>

Yikes.... Sorry again... Hopefully this attached patch work properly.

chandra
On Thu, 2008-05-22 at 20:25 -0700, Andrew Morton wrote:
> On Thu, 15 May 2008 12:56:14 -0700 Chandra Seetharaman <sekharan@us.ibm.com> wrote:
> 
> > Hi James, Andrew,
> > 
> > Here is a patch to remove the automatic "select" of scsi_dh for
> > dm-multipath.
> > 
> > Sorry about the mishap.
> >
> >
> 
> This is busted.
> 
-------------------------
Do not automatically "select" SCSI_DH for dm-multipath. If SCSI_DH
doesn't exist,just do not allow  hardware handlers to be used.

Handle SCSI_DH being a module also.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Reported-by: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Hannes Reinecke <hare@suse.de>
---

Index: scsi-misc-2.6/drivers/md/Kconfig
===================================================================
--- scsi-misc-2.6.orig/drivers/md/Kconfig
+++ scsi-misc-2.6/drivers/md/Kconfig
@@ -252,7 +252,6 @@ config DM_ZERO
 config DM_MULTIPATH
 	tristate "Multipath target"
 	depends on BLK_DEV_DM
-	select SCSI_DH
 	---help---
 	  Allow volume managers to support multipath hardware.
 
Index: scsi-misc-2.6/drivers/md/dm-mpath.c
===================================================================
--- scsi-misc-2.6.orig/drivers/md/dm-mpath.c
+++ scsi-misc-2.6/drivers/md/dm-mpath.c
@@ -664,6 +664,8 @@ static int parse_hw_handler(struct arg_s
 	request_module("scsi_dh_%s", m->hw_handler_name);
 	if (scsi_dh_handler_exist(m->hw_handler_name) == 0) {
 		ti->error = "unknown hardware handler type";
+		kfree(m->hw_handler_name);
+		m->hw_handler_name = NULL;
 		return -EINVAL;
 	}
 	consume(as, hw_argc - 1);
Index: scsi-misc-2.6/include/scsi/scsi_dh.h
===================================================================
--- scsi-misc-2.6.orig/include/scsi/scsi_dh.h
+++ scsi-misc-2.6/include/scsi/scsi_dh.h
@@ -54,6 +54,16 @@ enum {
 	SCSI_DH_NOSYS,
 	SCSI_DH_DRIVER_MAX,
 };
-
+#if defined(CONFIG_SCSI_DH) || defined(CONFIG_SCSI_DH_MODULE)
 extern int scsi_dh_activate(struct request_queue *);
 extern int scsi_dh_handler_exist(const char *);
+#else
+static inline int scsi_dh_activate(struct request_queue *req)
+{
+	return 0;
+}
+static inline int scsi_dh_handler_exist(const char *name)
+{
+	return 0;
+}
+#endif


