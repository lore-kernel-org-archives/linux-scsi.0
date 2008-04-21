From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [bug] SCSI/SLUB - latest -git: WARNING: at mm/slub.c:2443
	kmem_cache_destroy, scsi_put_host_cmd_pool()
Date: Mon, 21 Apr 2008 10:57:20 -0500
Message-ID: <1208793440.3640.22.camel@localhost.localdomain>
References: <20080419085758.GA18612@elte.hu>
	 <1208611357.3280.5.camel@localhost.localdomain>
	 <20080421134925.GK9554@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:58668 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762151AbYDUP5Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Apr 2008 11:57:24 -0400
In-Reply-To: <20080421134925.GK9554@elte.hu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>, Christoph Lameter <clameter@sgi.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2008-04-21 at 15:49 +0200, Ingo Molnar wrote:
> * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > > x86.git allyesconfig bootup test produced the following warning in 
> > > slub.c (and a stream of similar warnings later on):
> [...]
> 
> > > config and bootlog at:
> > > 
> > >  http://redhat.com/~mingo/misc/config-Sat_Apr_19_10_28_28_CEST_2008.bad
> > >  http://redhat.com/~mingo/misc/log-Sat_Apr_19_10_28_28_CEST_2008.bad
> > > 
> > > [a few .config options were turned off: just accept all the defaults 
> > >  after 'make oldconfig']
> > 
> > The WARN_ON is caused by kmem_cache_destroy() with apparently 
> > outstanding objects, isn't it?
> > 
> > The most significant piece of the log seems to be before with all 
> > those isa SCSI drivers ... I assume you don't actually have any of the 
> > hardware, you're just randomly inserting the modules?
> 
> correct. As i mentioned it in the first sentence this is an allyesconfig 
> bzImage bootup. I.e. this is the bootup log of a "make allyesconfig" 
> kernel - roughly analogous to (trying to) insert every module in 
> existence. In the boot log you'll find 4871 initcalls, done by over 3000 
> drivers that each is attempted to be loaded by the kernel (!).
> 
> I do those bootups to "run as much as possible" kernel code and to make 
> sure that the maximum combination of debug and other features still 
> produces a working kernel.
> 
> I had to work half a year to gradually get the kernel to that stage 
> (started with it more than a year ago, as part of the -rt kernel) but 
> these days i'm booting a 32-bit and a 64-bit allyesconfig bzImage kernel 
> almost daily :) These bootups already caught a healthy amount of bugs in 
> the kernel, both important and unimportant ones. Recently the size of 
> the allyesconfig bzImage kernel surpassed 42MB, so it's massive.
> 
> Btw., i also boot "allnoconfig" kernels. [with just the minimal set of 
> features turned on to make the kernel minimally boot up and report back 
> via networking.]

Thanks ... it looks like we may have trouble from devices that alter the
unchecked isa dma flag after scsi_host_alloc.  The guilty parties appear
to be gdth, eata, u14-34f, ultrastor, BusLogic and advansys.

The trouble is that if you alloc the host with it one way and free it
with it the other, the wrong freelist is used and the ref counts are
invalid.

Try this pseudo fix: it avoids allocating the freelist until add time
(by which time they should all have fixed the flag).  It still doesn't
change the fact that the host is allocated in the wrong region, but that
shouldn't matter too much.

James

---

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 1592640..75af254 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -199,9 +199,13 @@ int scsi_add_host(struct Scsi_Host *shost, struct device *dev)
 	if (!shost->can_queue) {
 		printk(KERN_ERR "%s: can_queue = 0 no longer supported\n",
 				sht->name);
-		goto out;
+		goto fail;
 	}
 
+	error = scsi_setup_command_freelist(shost);
+	if (error)
+		goto fail;
+
 	if (!shost->shost_gendev.parent)
 		shost->shost_gendev.parent = dev ? dev : &platform_bus;
 
@@ -255,6 +259,8 @@ int scsi_add_host(struct Scsi_Host *shost, struct device *dev)
  out_del_gendev:
 	device_del(&shost->shost_gendev);
  out:
+	scsi_destroy_command_freelist(shost);
+ fail:
 	return error;
 }
 EXPORT_SYMBOL(scsi_add_host);
@@ -376,10 +382,6 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	else
 		shost->dma_boundary = 0xffffffff;
 
-	rval = scsi_setup_command_freelist(shost);
-	if (rval)
-		goto fail_kfree;
-
 	device_initialize(&shost->shost_gendev);
 	snprintf(shost->shost_gendev.bus_id, BUS_ID_SIZE, "host%d",
 		shost->host_no);
@@ -395,14 +397,12 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 			"scsi_eh_%d", shost->host_no);
 	if (IS_ERR(shost->ehandler)) {
 		rval = PTR_ERR(shost->ehandler);
-		goto fail_destroy_freelist;
+		goto fail_kfree;
 	}
 
 	scsi_proc_hostdir_add(shost->hostt);
 	return shost;
 
- fail_destroy_freelist:
-	scsi_destroy_command_freelist(shost);
  fail_kfree:
 	kfree(shost);
 	return NULL;


