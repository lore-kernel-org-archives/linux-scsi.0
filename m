From: Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH 90/91] block: fail SCSI passthrough ioctls on partition devices
Date: Sun, 5 Feb 2012 23:53:14 +0100
Message-ID: <20120205225314.GF8334@1wt.eu>
References: <0635750f5f06ed2ca212b91fcb5c4483@local> <20120205220953.312427771@pcw.home.local> <4F2F0669.3000601@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 1wt.eu ([62.212.114.60]:62232 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339Ab2BEWxY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 5 Feb 2012 17:53:24 -0500
Content-Disposition: inline
In-Reply-To: <4F2F0669.3000601@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@parallels.com>, Linus Torvalds <torvalds@linux-foundation.org>, Ben Hutchings <ben@decadent.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Hi Paolo,

On Sun, Feb 05, 2012 at 11:44:57PM +0100, Paolo Bonzini wrote:
> On 02/05/2012 11:11 PM, Willy Tarreau wrote:
> >Signed-off-by: Ben Hutchings<ben@decadent.org.uk>
> >Signed-off-by: Greg Kroah-Hartman<gregkh@linuxfoundation.org>
> >[wt: no scsi_cmd_blk_ioctl in 2.6.27, change callers instead. cciss is OK,
> >  ub,virtio_blk,ide-floppy,sd need fixing, cdrom&st can be ignored ]
> 
> NACK, you aren't fixing virtio-blk to call scsi_verify_blk_ioctl, are you?
> 
> You need to backport the patch that introduced scsi_cmd_blk_ioctl, 
> which, in fact was in the same patch series as this one.

Thanks for this report, I missed this patch. I thought the reason for the lack
of scsi_cmd_blk_ioctl() it was one of the differences between 2.6.27 and 2.6.32,
so I have adapted the callers I identified to perform the same test as what's
in scsi_cmd_blk_ioctl(). I *think* I did it correctly, but it would be safer
to apply the original patch, of course. Now I see the patch (618 in my queue).
 I'll merge it and it will simplify the backport.

Thank you,
Willy

