From: Mike Snitzer <snitzer@redhat.com>
Subject: IBM request to allow unprivledged ioctls [Was: Revert "dm mpath: fix
 stalls when handling invalid ioctls"]
Date: Thu, 29 Oct 2015 09:18:10 -0400
Message-ID: <20151029131810.GA26841@redhat.com>
References: <1446121463-17828-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756733AbbJ2NSN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Oct 2015 09:18:13 -0400
Content-Disposition: inline
In-Reply-To: <1446121463-17828-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Cc: dm-devel@redhat.com, hare@suse.de, linux-scsi@vger.kernel.org

On Thu, Oct 29 2015 at  8:24am -0400,
Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com> wrote:

> This reverts commit a1989b330093578ea5470bea0a00f940c444c466.
> 
> That commit introduced a regression at least for the case of the SG_IO ioctl()
> running without CAP_SYS_RAWIO capability (e.g., unprivileged users) when there
> are no active paths: the ioctl() fails with the ENOTTY errno immediately rather
> than blocking due to queue_if_no_path until a path becomes active, for example.
> 
> That case happens to be exercised by QEMU KVM guests with 'scsi-block' devices
> (qemu "-device scsi-block" [1], libvirt "<disk type='block' device='lun'>" [2])
> from multipath devices; which leads to SCSI/filesystem errors in such a guest.
> 
> More general scenarios can hit that regression too. The following demonstration
> employs a SG_IO ioctl() with a standard SCSI INQUIRY command for this objective
> (some output & user changes omitted for brevity and comments added for clarity).
> 
> Reverting that commit restores normal operation (queueing) in failing scenarios;
> tested on linux-next (next-20151022).

Obviously !bdev is causing you to take the branch you'd like to change
via revert.  Once in that branch scsi_verify_blk_ioctl() is called.  If
the ioctl is valid the ioctl is allowed to carry on (regardless of
whether there are paths or not).
 
> 1) Test-case is based on sg_simple0 [3] (just SG_IO; remove SG_GET_VERSION_NUM)
> 
>     $ cat sg_simple0.c
>     ... see [3] ...
>     $ sed '/SG_GET_VERSION_NUM/,/}/d' sg_simple0.c > sgio_inquiry.c
>     $ gcc sgio_inquiry.c -o sgio_inquiry
> 
> 2) The ioctl() works fine with active paths present.
> 
>     # multipath -l 85ag56
>     85ag56 (...) dm-19 IBM     ,2145
>     size=60G features='1 queue_if_no_path' hwhandler='0' wp=rw
>     |-+- policy='service-time 0' prio=0 status=active
>     | |- 8:0:11:0  sdz  65:144  active undef running
>     | `- 9:0:9:0   sdbf 67:144  active undef running
>     `-+- policy='service-time 0' prio=0 status=enabled
>       |- 8:0:12:0  sdae 65:224  active undef running
>       `- 9:0:12:0  sdbo 68:32   active undef running
> 
>     $ ./sgio_inquiry /dev/mapper/85ag56
>     Some of the INQUIRY command's response:
>         IBM       2145              0000
>     INQUIRY duration=0 millisecs, resid=0
> 
> 3) The ioctl() fails with ENOTTY errno with _no_ active paths present,
>    for unprivileged users (rather than blocking due to queue_if_no_path).
> 
>     # for path in $(multipath -l 85ag56 | grep -o 'sd[a-z]\+'); \
>           do multipathd -k"fail path $path"; done
> 
>     # multipath -l 85ag56
>     85ag56 (...) dm-19 IBM     ,2145
>     size=60G features='1 queue_if_no_path' hwhandler='0' wp=rw
>     |-+- policy='service-time 0' prio=0 status=enabled
>     | |- 8:0:11:0  sdz  65:144  failed undef running
>     | `- 9:0:9:0   sdbf 67:144  failed undef running
>     `-+- policy='service-time 0' prio=0 status=enabled
>       |- 8:0:12:0  sdae 65:224  failed undef running
>       `- 9:0:12:0  sdbo 68:32   failed undef running
> 
>     $ ./sgio_inquiry /dev/mapper/85ag56
>     sg_simple0: Inquiry SG_IO ioctl error: Inappropriate ioctl for device
> 
> 4) dmesg shows that scsi_verify_blk_ioctl() failed for SG_IO (0x2285);
>    it returns -ENOIOCTLCMD, later replaced with -ENOTTY in vfs_ioctl().
> 
>     $ dmesg
>     <...>
>     [] device-mapper: multipath: Failing path 65:144.
>     [] device-mapper: multipath: Failing path 67:144.
>     [] device-mapper: multipath: Failing path 65:224.
>     [] device-mapper: multipath: Failing path 68:32.
>     [] sgio_inquiry: sending ioctl 2285 to a partition!

So scsi_verify_blk_ioctl() considers the ioctl invalid.

> 5) The ioctl() only works if the SYS_CAP_RAWIO capability is present
>    (then queueing happens -- in this example, queue_if_no_path is set);
>    this is due to a conditional check in scsi_verify_blk_ioctl().
> 
>     # capsh --drop=cap_sys_rawio -- -c './sgio_inquiry /dev/mapper/85ag56'
>     sg_simple0: Inquiry SG_IO ioctl error: Inappropriate ioctl for device
> 
>     # ./sgio_inquiry /dev/mapper/85ag56 &
>     [1] 72830

Sorry but I fail to see why your request to revert is viable.
Commit a1989b330093578ea5470bea0a00f940c444c466 fixes issues seen with
udevd (namely "udevd[]: worker [] unexpectedly returned with status 0x0100")

Wouldn't the correct fix be to train scsi_verify_blk_ioctl() to work
even without SYS_CAP_RAWIO?

I'm not doubting that the commit caused problems for the case you care
about (unprivledged users issueing ioctls) but that is an entirely
different issue that needs to be discussed more directly (with the
broader linux-scsi community, now cc'd).

Mike


p.s. leaving full context for linux-scsi so they don't need to track
down other mails (btw, thanks for the detailed patch header but it
enabled me to be skeptical of your request to revert):

> 6) This is the function call chain exercised in this analysis:
> 
> SYSCALL_DEFINE3(ioctl, <...>) @ fs/ioctl.c
>     -> do_vfs_ioctl()
>         -> vfs_ioctl()
>             ...
>             error = filp->f_op->unlocked_ioctl(filp, cmd, arg);
>             ...
>                 -> dm_blk_ioctl() @ drivers/md/dm.c
>                     -> multipath_ioctl() @ drivers/md/dm-mpath.c
>                         ...
>                         (bdev = NULL, due to no active paths)
>                         ...
>                         if (!bdev || <...>) {
>                             int err = scsi_verify_blk_ioctl(NULL, cmd);
>                             if (err)
>                                 r = err;
>                         }
>                         ...
>                             -> scsi_verify_blk_ioctl() @ block/scsi_ioctl.c
>                                 ...
>                                 if (bd && bd == bd->bd_contains) // not taken (bd = NULL)
>                                     return 0;
>                                 ...
>                                 if (capable(CAP_SYS_RAWIO)) // not taken (unprivileged user)
>                                     return 0;
>                                 ...
>                                 printk_ratelimited(KERN_WARNING
>                                            "%s: sending ioctl %x to a partition!\n" <...>);
> 
>                                 return -ENOIOCTLCMD;
>                             <-
>                         ...
>                         return r ? : <...>
>                     <-
>             ...
>             if (error == -ENOIOCTLCMD)
>                 error = -ENOTTY;
>              out:
>                 return error;
>             ...
> 
> Links:
> [1] http://git.qemu.org/?p=qemu.git;a=commit;h=336a6915bc7089fb20fea4ba99972ad9a97c5f52
> [2] https://libvirt.org/formatdomain.html#elementsDisks (see 'disk' -> 'device')
> [3] http://tldp.org/HOWTO/SCSI-Generic-HOWTO/pexample.html (Revision 1.2, 2002-05-03)
> 
> Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
> ---
>  drivers/md/dm-mpath.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index 5a67671..bdc96cd 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -1569,11 +1569,8 @@ static int multipath_ioctl(struct dm_target *ti, unsigned int cmd,
>  	/*
>  	 * Only pass ioctls through if the device sizes match exactly.
>  	 */
> -	if (!bdev || ti->len != i_size_read(bdev->bd_inode) >> SECTOR_SHIFT) {
> -		int err = scsi_verify_blk_ioctl(NULL, cmd);
> -		if (err)
> -			r = err;
> -	}
> +	if (!r && ti->len != i_size_read(bdev->bd_inode) >> SECTOR_SHIFT)
> +		r = scsi_verify_blk_ioctl(NULL, cmd);
>  
>  	if (r == -ENOTCONN && !fatal_signal_pending(current)) {
>  		spin_lock_irqsave(&m->lock, flags);
> -- 
> 1.9.1
> 
