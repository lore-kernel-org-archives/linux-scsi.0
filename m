From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] sg: fix races during device removal
Date: Tue, 30 Dec 2008 12:53:46 -0500
Message-ID: <495A602A.10103@interlog.com>
References: <495A40D4.5030901@cybernetics.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:41685 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbYL3Rxw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Dec 2008 12:53:52 -0500
In-Reply-To: <495A40D4.5030901@cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Tony Battersby wrote:
> sg has the following races relating to device removal:
> 
> 1) It is not safe for sg_remove() to access sdp after setting
> sdp->detached = 1 and dropping sg_index_lock, since sg_release() or
> sg_cmd_done() may call sg_remove_sfp(), which may free sdp.  I have seen
> this race cause an oops.
> 
> 2) It is not safe for sg_open() to access sdp (especially after
> sleeping), since sg_remove() may free sdp anytime before sg_add_sfp() is
> called.  Similarly, sg_add_sfp() is unsafe because sg_remove() may free
> sdp anytime before the new sg_fd is linked into sdp->headfp.
> 
> 3) It is not safe for sg_release() or sg_cmd_done() to access sdp after
> calling sg_remove_sfp() (even if sg_remove_sfp() returns 0), because
> once sdp->headfp == NULL, sg_remove() may free sdp.
> 
> 4) It is not safe for sg_proc_* to access sdp, since sg_remove() may
> free it at any time.
> 
> 5) Various SCSI_LOG_TIMEOUT calls (e.g. in sg_release) use
> sdp->disk->disk_name after sg_remove may have set sdp->disk to NULL.
> 
> This patch fixes these problems by adding a reference count to
> sg_device.  If a function holds a pointer to a sg_device where the
> pointer is not associated with a sg_fd that remains linked into headfp
> for the entire duration of the function, then that function must
> increment refcount while holding a write lock on sg_index_lock.  When
> the function is done, sg_put_dev() decrements refcount and frees the
> sg_device if there are no remaining references or sg_fd's.  Functions
> like sg_read() and sg_write() do not need to increment the refcount
> because the corresponding sg_fd will prevent the sg_device from being
> freed.
> 
> When opening a fd, this patch moves the check for sdp->detached from
> sg_open() to sg_add_sfp() so that it can be done while holding a write
> lock on sg_index_lock.  This ensures that sg_open() doesn't succeed
> after sg_remove() has been called.  Since sg_add_sfp() can now fail in
> different ways, it returns an ERR_PTR() instead of NULL.  Also, if there
> are multiple processes waiting to open the same device with O_EXCL, and
> the device is deleted, then the error path in sg_open() that sets
> sdp->exclude = 0 needs to wake up other processes that might be waiting
> (this may not be a problem in practice due to lock_kernel() as long as
> sg_open() never sleeps in between setting exclude = 1 and exclude = 0,
> but it is better to be safe).
> 
> Since sg_remove_sfp()/__sg_remove_sfp() remove the sg_fd from sg_device,
> any caller of these functions must increment the reference count ahead
> of time and then call sg_put_dev() afterward.  This actually makes
> things simpler, since there is no longer a need for sg_remove_sfp() to
> return a value indicating if sg_device is still valid or not.
> 
> scsi_device_get()/scsi_device_put() usage is also simplified.
> scsi_device_get() is called only from sg_open(), and scsi_device_put()
> is called only from __sg_remove_sfp() and the error path in sg_open().
> 
> idr_remove() usage is also simplified; it is now called from
> sg_put_dev() just before freeing sg_device.
> 
> put_disk() is now called from sg_put_dev() when all fds are closed and
> the reference count drops to 0 instead of directly from sg_remove().
> This fixes all the places sdp->disk->disk_name might be used after
> sg_remove().
> 
> sg_get_dev() now uses a write lock on sg_index_lock instead of a read
> lock so that it is safe to increment sdp->refcount.  Also, sg_get_dev()
> must now be paired with sg_put_dev().
> 
> Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
> ---
> 
> I noticed these problems when running a test program that used the sg
> driver to access SAS devices with mptsas.  When the SAS cable is
> unplugged, mptsas automatically deletes the devices, and the test also
> fails at the same time and closes its sg file descriptors.  Depending
> on the timing, this would sometimes produce an oops due to the races
> between deleting the device, closing the fds, and commands completing.

<snip>

Tony,
Pretty impressive analysis! The disappearance of a device
while an application is actively using it has been a
concern of mine with the sg driver. It is some years since
I have looked at this area and lots of cooks/chefs have been
hacking the driver since then.

Testing for these races is also difficult and you seem to
have found a good approach to that as well **.

I have been looking at the patch (with a split screen
viewer (tkdiff) as the 'diff -du' output becomes hard to
follow) and your approach looks systematic and correct.

So I'm happy to go ahead with this patch. I'll cc this reply
to Tomo since he has done the bulk of the sg driver work
recently. It would be useful to read Tomo's opinion.


Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
   [My dougg@torque.net account is defunct so I'll use
    my interlog email account henceforth.]


** With SAS and a reasonable number of disks behind an expander,
    "pulling the cable" could be simulated by turning off the
    uplink phys on the expander (e.g. with smp_phy_control).

Doug Gilbert
