From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] block SG_IO: add SG_FLAG_Q_AT_HEAD flag
Date: Wed, 11 Jun 2014 16:33:21 -0500
Message-ID: <5398CB21.3000409@cs.wisc.edu>
References: <5390786E.8050601@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:39849 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572AbaFKVdx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jun 2014 17:33:53 -0400
In-Reply-To: <5390786E.8050601@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, James Bottomley <james.bottomley@hansenpartnership.com>

On 06/05/2014 09:02 AM, Douglas Gilbert wrote:
> After the SG_IO ioctl was copied into the block layer and
> later into the bsg driver, subtle differences emerged.
> 
> One difference is the way injected commands are queued through
> the block layer (i.e. this is not SCSI device queueing nor SATA
> NCQ). Summarizing:
>   - SG_IO on block layer device: blk_exec*(at_head=false)
>   - sg device SG_IO: at_head=true
>   - bsg device SG_IO: at_head=true
> 
> Some time ago Boaz Harrosh introduced a sg v4 flag called
> BSG_FLAG_Q_AT_TAIL to override the bsg driver default. A
> recent patch titled: "sg: add SG_FLAG_Q_AT_TAIL flag"
> allowed the sg driver default to be overridden. This patch
> allows a SG_IO ioctl sent to a block layer device to have
> its default overridden.
> 
> ChangeLog:
>     - introduce SG_FLAG_Q_AT_HEAD flag in sg.h to cause
>       commands that are injected via a block layer
>       device SG_IO ioctl to set at_head=true
>     - make comments clearer about queueing in sg.h since the
>       header is used both by the sg device and block layer
>       device implementations of the SG_IO ioctl.
>     - introduce BSG_FLAG_Q_AT_HEAD in bsg.h for compatibility
>       (it does nothing) and update comments.
> 
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

Looks ok to me.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
