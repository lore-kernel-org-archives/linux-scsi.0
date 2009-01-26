From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 1/2] sg: fix races during device removal (v6)
Date: Mon, 26 Jan 2009 08:57:20 -0500
Message-ID: <497DC140.3070207@interlog.com>
References: <496E4B93.4000507@cybernetics.com>	<20090119155509Y.fujita.tomonori@lab.ntt.co.jp>	<497506AF.6040109@cybernetics.com> <20090120100451Q.fujita.tomonori@lab.ntt.co.jp> <49764920.30307@cybernetics.com> <49777B6E.1040805@cybernetics.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:39337 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbZAZN53 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jan 2009 08:57:29 -0500
In-Reply-To: <49777B6E.1040805@cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: James.Bottomley@HansenPartnership.com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, hch@infradead.org, linux-scsi@vger.kernel.org

Tony Battersby wrote:
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
> 
> --- linux-2.6.29-rc2/drivers/scsi/sg.c.orig	2009-01-21 14:34:05.000000000 -0500
> +++ linux-2.6.29-rc2/drivers/scsi/sg.c	2009-01-21 14:36:00.000000000 -0500

Tony,
We seem to have consensus on this version (v6 20090121).

Thanks for you work.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

