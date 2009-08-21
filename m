From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: oops during scsi scanning disk setup
Date: Fri, 21 Aug 2009 09:47:54 -0600
Message-ID: <1250869674.7363.89.camel@mulgrave.site>
References: <20090820180549.GD7542@arachsys.com>
	 <1250807161.4302.167.camel@mulgrave.site>
	 <20090821081621.GB32115@arachsys.com> <20090821083356.GC32115@arachsys.com>
	 <20090821092326.GF32115@arachsys.com>
	 <1250863216.3844.1.camel@mulgrave.site>
	 <20090821145141.GR32115@arachsys.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45917 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187AbZHUPr6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Aug 2009 11:47:58 -0400
In-Reply-To: <20090821145141.GR32115@arachsys.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Webb <chris@arachsys.com>
Cc: linux-scsi@vger.kernel.org

On Fri, 2009-08-21 at 15:51 +0100, Chris Webb wrote:
> James Bottomley <James.Bottomley@suse.de> writes:
> 
> > On Fri, 2009-08-21 at 10:23 +0100, Chris Webb wrote:
> >
> > > Sorry to follow up a third time, but I can now confirm this. I slipped -g into
> > > CFLAGS in the kernel Makefile and rebuilt genhd.o and then the entire vmlinux.
> > 
> > I suppose it makes sense:  That was the only dereference at offset 16 I
> > could find in the code.  The thing which doesn't quite make sense is
> > that disk_part_iter_init() also dereferences the same pointer
> > successfully ... I suppose this could be a race with another thread to
> > null out the gendisk part_tbl ... I'll have to think about it some more.
> 
> Thanks! If it helps, I've only ever seen it following an iscsi login to a
> target machine which is heavy loaded (e.g. RAID resync in this case),
> presumably meaning that everything (including disk reads) happens a bit
> slowly. Perhaps this increases the window for a race in some way?
> 
> I've spent some time over the past week trying to reproduce it in a VM with
> magic sysrq enabled so I could find out a bit more, but it subbornly refuses
> to happen except on machines in a busy production cluster.

Actually, for that particular pointer to be NULL'd, I think the race
must be between add_disk and del_gendisk, implying that your iSCSI
cluster somehow shut down the link while it was busy.

I think that's an artifact of the fact that we don't get a reference to
the disk in these operations, and the race window is much longer now we
do sd async scanning.

Can you try this as a partial fix?  (It should prevent the oops, but
you'll still lose the disk).

James

---

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index b7b9fec..a89c421 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2021,6 +2021,7 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 
 	sd_printk(KERN_NOTICE, sdkp, "Attached SCSI %sdisk\n",
 		  sdp->removable ? "removable " : "");
+	put_device(&sdkp->dev);
 }
 
 /**
@@ -2106,6 +2107,7 @@ static int sd_probe(struct device *dev)
 
 	get_device(&sdp->sdev_gendev);
 
+	get_device(&sdkp->dev);	/* prevent release before async_schedule */
 	async_schedule(sd_probe_async, sdkp);
 
 	return 0;


