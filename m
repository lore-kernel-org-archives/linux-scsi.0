From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/7] scsi: avoid ->change_queue_depth indirection for
 queue full tracking
Date: Fri, 21 Nov 2014 02:19:55 -0800
Message-ID: <20141121101955.GA3926@infradead.org>
References: <1415901546-8006-1-git-send-email-hch@lst.de>
 <1415901546-8006-3-git-send-email-hch@lst.de>
 <20141113194719.GA21540@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60851 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757407AbaKUKT5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Nov 2014 05:19:57 -0500
Content-Disposition: inline
In-Reply-To: <20141113194719.GA21540@google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: venkateshs@google.com
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, James Smart <james.smart@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>

On Thu, Nov 13, 2014 at 07:47:19PM +0000, venkateshs@google.com wrote:
> On Thu, Nov 13, 2014 at 06:59:01PM +0100, Christoph Hellwig wrote:
> >All drivers use the implementation for ramping the queue up and down, so
> >instead of overloading the change_queue_depth method call the
> >implementation diretly if the driver opts into it by setting the
> >track_queue_depth flag in the host template.
> >
> >Note that a few drivers validated the new queue depth in their
> >change_queue_depth method, but as we never go over the queue depth
> >set during slave_configure or the sysfs file this isn't nessecary
> >and can safely be removed.
> >
> >Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> This patch plus the change to remove the 'tagged' argument to
> scsi_adjust_queue_depth() form a nice cleanup.
> 
> Reviewed-by: Venkatesh Srinivas <venkateshs@google.com>

Any chance to get a review for the other patches in the series as well?
