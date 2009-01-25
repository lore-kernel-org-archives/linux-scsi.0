From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/2] sg: fix races during device removal (v6)
Date: Sun, 25 Jan 2009 21:46:21 +0900
Message-ID: <20090125214113Z.fujita.tomonori@lab.ntt.co.jp>
References: <20090120100451Q.fujita.tomonori@lab.ntt.co.jp>
	<49764920.30307@cybernetics.com>
	<49777B6E.1040805@cybernetics.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:46940 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753999AbZAYMqr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 25 Jan 2009 07:46:47 -0500
In-Reply-To: <49777B6E.1040805@cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tonyb@cybernetics.com
Cc: James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp, dgilbert@interlog.com, hch@infradead.org, linux-scsi@vger.kernel.org

On Wed, 21 Jan 2009 14:45:50 -0500
Tony Battersby <tonyb@cybernetics.com> wrote:

> sg has the following problems related to device removal:
> 
> * opening a sg fd races with removing a device
> * closing a sg fd races with removing a device
> * /proc/scsi/sg/* access races with removing a device
> * command completion races with removing a device
> * command completion races with closing a sg fd
> * can rmmod sg with active commands
> 
> These problems can cause kernel oopses, memory-use-after-free, or
> double-free errors.  This patch fixes these problems by using krefs
> to manage the lifetime of sg_device and sg_fd.
> 
> Each command submitted to the midlevel holds a reference to sg_fd
> until the completion callback.  This ensures that sg_fd doesn't go
> away if the fd is closed with commands still outstanding.
> 
> sg_fd gets the reference of sg_device (with scsi_device) and also
> makes sure that the sg module doesn't go away.
> 
> /proc/scsi/sg/* functions don't play nicely with krefs because they
> give information about sg_fds which have been closed but not yet
> freed due to still having outstanding commands and sg_devices which
> have been removed but not yet freed due to still being referenced
> by one or more sg_fds.  To deal with this safely without removing
> functionality, /proc functions now access sg_device and sg_fd while
> holding a lock instead of using kref_get()/kref_put().
> 
> Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
> ---
> 
> This version changes BUG_ON() to WARN_ON()/return as suggested by
> Stefan Richter.
> 
> The second patch "[PATCH 2/2] sg: fix races with ioctl(SG_IO) (v2)"
> is still the same as before, so I am not resending it.
> 
>  sg.c |  418 ++++++++++++++++++++++++++++++++-----------------------------------
>  1 file changed, 201 insertions(+), 217 deletions(-)

Looks good to me,

Thanks!
