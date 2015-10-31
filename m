From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: IBM request to allow unprivledged ioctls [Was: Revert "dm mpath:
 fix stalls when handling invalid ioctls"]
Date: Sat, 31 Oct 2015 14:36:50 -0400
Message-ID: <20151031183650.GA3546@redhat.com>
References: <1446121463-17828-1-git-send-email-mauricfo@linux.vnet.ibm.com>
 <20151029131810.GA26841@redhat.com>
 <5634DF67.7060302@redhat.com>
 <20151031181312.GA11587@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478AbbJaSgw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 31 Oct 2015 14:36:52 -0400
Content-Disposition: inline
In-Reply-To: <20151031181312.GA11587@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@lst.de
Cc: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>, dm-devel@redhat.com, hare@suse.de, linux-scsi@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>

On Sat, Oct 31 2015 at  2:13P -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Sat, Oct 31 2015 at 11:33am -0400,
> Paolo Bonzini <pbonzini@redhat.com> wrote:
> 
> > 
> > 
> > On 29/10/2015 14:18, Mike Snitzer wrote:
> > > > 4) dmesg shows that scsi_verify_blk_ioctl() failed for SG_IO (0x2285);
> > > >    it returns -ENOIOCTLCMD, later replaced with -ENOTTY in vfs_ioctl().
> > > > 
> > > >     $ dmesg
> > > >     <...>
> > > >     [] device-mapper: multipath: Failing path 65:144.
> > > >     [] device-mapper: multipath: Failing path 67:144.
> > > >     [] device-mapper: multipath: Failing path 65:224.
> > > >     [] device-mapper: multipath: Failing path 68:32.
> > > >     [] sgio_inquiry: sending ioctl 2285 to a partition!
> > > 
> > > So scsi_verify_blk_ioctl() considers the ioctl invalid.
> > 
> > But that's wrong, I think.  It's a false positive in
> > scsi_verify_blk_ioctl().
> > 
> > If the ioctl is valid when bdev becomes non-NULL (and it will be if
> > ti->len becomes equal to i_size_read(bdev->bd_inode) >> SECTOR_SHIFT),
> > you should not return -ENOIOCTLCMD aka ENOTTY, because userspace doesn't
> > think the ioctls can go away and come back.  So Hannes's patch broke the
> > userspace ABI. :(
> 
> Huh?  All that Hannes' patch did was add early verification of the ioctl
> if there are no paths, since: there is no point queueing an ioctl that
> is invalid.
> 
> But looking just now, Christoph's recent ioctl refactoring that I staged
> for 4.4 does seem to subtley revert Hannes' change:
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.4&id=40cf639be1db8cc2b8183fe2ccd390ca77b90396
> With hch's change multipath_prepare_ioctl() will _not_ do early
> verification of the ioctl if no paths are available (and
> queue_if_no_path is configured).  Because the call to
> scsi_verify_blk_ioctl() was moved to dm_blk_ioctl() and is only called
> if the return is > 0 (again -ENOTCONN is being returned).
> 
> Not to mention hch's lifting of scsi_verify_blk_ioctl() into DM core's
> dm_blk_ioctl() -- likely motivated by not requiring all targets to do
> the call like they were doing -- should really be done as part of the
> new DM target .prepare_ioctl hook.
> 
> Christoph, I think your DM ioctl changes need more review/work.. which
> implies they'll very likely miss 4.4.. sorry.

This patch will maintain Hannes' commit a1989b3300935 (which I think is
correct!):

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index aaa6caa..ffea28f 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1562,6 +1562,16 @@ static int multipath_prepare_ioctl(struct dm_target *ti,
 
 	spin_unlock_irqrestore(&m->lock, flags);
 
+	/*
+	 * Only pass ioctls through if the device sizes match exactly.
+	 */
+	if (!*bdev || ti->len != i_size_read((*bdev)->bd_inode) >> SECTOR_SHIFT) {
+		/* not deferring to DM core to verify the ioctl */
+		int err = scsi_verify_blk_ioctl(NULL, cmd);
+		if (err)
+			r = err;
+	}
+
 	if (r == -ENOTCONN && !fatal_signal_pending(current)) {
 		spin_lock_irqsave(&m->lock, flags);
 		if (!m->current_pg) {
@@ -1574,11 +1584,6 @@ static int multipath_prepare_ioctl(struct dm_target *ti,
 		dm_table_run_md_queue_async(m->ti->table);
 	}
 
-	/*
-	 * Only pass ioctls through if the device sizes match exactly.
-	 */
-	if (!r && ti->len != i_size_read((*bdev)->bd_inode) >> SECTOR_SHIFT)
-		return 1;
 	return r;
 }
 
Christoph, I've folded this into your original commit 40cf639be1d I
referenced above, new commit is here:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.4&id=21a2807bc3ff0eec3e2ec35357a4c37d4bcbfd5b

But if you, Hannes or others disagree with this change I'll drop it for
4.4 and we'll have to revisit this later.
