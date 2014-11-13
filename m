From: venkateshs@google.com
Subject: Re: [PATCH 2/7] scsi: avoid ->change_queue_depth indirection for
 queue full tracking
Date: Thu, 13 Nov 2014 19:47:19 +0000
Message-ID: <20141113194719.GA21540@google.com>
References: <1415901546-8006-1-git-send-email-hch@lst.de>
 <1415901546-8006-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:33258 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933146AbaKMTrV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Nov 2014 14:47:21 -0500
Received: by mail-ig0-f177.google.com with SMTP id hl2so298039igb.10
        for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2014 11:47:20 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1415901546-8006-3-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, James Smart <james.smart@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>

On Thu, Nov 13, 2014 at 06:59:01PM +0100, Christoph Hellwig wrote:
>All drivers use the implementation for ramping the queue up and down, so
>instead of overloading the change_queue_depth method call the
>implementation diretly if the driver opts into it by setting the
>track_queue_depth flag in the host template.
>
>Note that a few drivers validated the new queue depth in their
>change_queue_depth method, but as we never go over the queue depth
>set during slave_configure or the sysfs file this isn't nessecary
>and can safely be removed.
>
>Signed-off-by: Christoph Hellwig <hch@lst.de>

This patch plus the change to remove the 'tagged' argument to
scsi_adjust_queue_depth() form a nice cleanup.

Reviewed-by: Venkatesh Srinivas <venkateshs@google.com>

-- vs;
