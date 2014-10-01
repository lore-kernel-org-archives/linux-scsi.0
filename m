From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] megaraid_sas: Enable shared tag map
Date: Wed, 1 Oct 2014 14:10:03 -0700
Message-ID: <20141001211003.GA24820@infradead.org>
References: <1411991272-129962-1-git-send-email-hare@suse.de>
 <542C4D33.2030401@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52549 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbaJAVKG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2014 17:10:06 -0400
Content-Disposition: inline
In-Reply-To: <542C4D33.2030401@hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Webb Scales <webbnh@hp.com>
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Wed, Oct 01, 2014 at 02:51:31PM -0400, Webb Scales wrote:
> Hannes,
> 
> In megasas_change_queue_type(), is it possible for sdev->queue_depth to be
> greater than 256?
> 
> Unless I'm misunderstanding the SCSI code, we can request a
> queue-depth/tag-map-size which is greater than 256, but, since the
> scsi_cmnd::tag field is an unsigned char, depths greater than 256 may
> overflow the field when high-numbered tags are used...do I have that right?

Yes, we really need to increase the size of the tag field.  SAM allows
a transport specific limit of up to 64 _bytes_ for it, although I don't
know implementation that large.  Given that the block layer can generate
up to 32-bit tags both for the old blk-tag.c code and the new
blk-mq-tag.c version it would be good to use a u32 there.  Can you send
me a patch?

