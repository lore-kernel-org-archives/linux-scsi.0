From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fix oops when removing scsi_host while IO is outstanding (and when using scsi_target patches)
Date: Sun, 10 Oct 2004 11:14:06 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041010101406.GB28456@infradead.org>
References: <416803A4.5000202@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baythorne.infradead.org ([81.187.226.107]:17924 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S268223AbUJJKOH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Oct 2004 06:14:07 -0400
Content-Disposition: inline
In-Reply-To: <416803A4.5000202@cs.wisc.edu>
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org

On Sat, Oct 09, 2004 at 08:28:36AM -0700, Mike Christie wrote:
> When trying to remove a host while IO is running I will get the folling 
> warning,
> and after these messages my log fills up with various oops.
> 
> Oct  9 04:54:44 mina kernel:  target0:0:0: Illegal state transition 
> <NULL>->cancel
> Oct  9 04:54:44 mina kernel: Badness in scsi_device_set_state at 
> drivers/scsi/scsi_lib.c:1713
> Oct  9 04:54:44 mina kernel:  [<c010585e>] dump_stack+0x1e/0x30
> Oct  9 04:54:44 mina kernel:  [<f8831316>] scsi_device_set_state+0xc6/0x130 
> [scsi_mod]
> Oct  9 04:54:44 mina kernel:  [<f88290fc>] scsi_device_cancel+0x3c/0x263 
> [scsi_mod]
> Oct  9 04:54:44 mina kernel:  [<c02c280d>] device_for_each_child+0x4d/0x80
> Oct  9 04:54:44 mina kernel:  [<f88293c2>] scsi_host_cancel+0x32/0xc0 
> [scsi_mod]
> Oct  9 04:54:44 mina kernel:  [<f8829472>] scsi_remove_host+0x22/0x70 
> [scsi_mod]
> 
> Note the target dev name and NULL state.
> 
> Basically, scsi_host_cancel is doing a device_for_each_child thinking it's
> children are scsi_devices, but in the scsi-target-2.6 tree they are now
> targets. The attached patch fixes this by just adding the extra
> device_for_each_child loop to get to the scsi device. It was built against
> the current scsi-target-2.6 tree.

What about using shost_for_each_device instead, so you don't have to care
about the extact implementation details?

