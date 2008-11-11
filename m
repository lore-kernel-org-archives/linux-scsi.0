From: jim owens <jowens@hp.com>
Subject: Re: thin provisioned LUN support
Date: Tue, 11 Nov 2008 12:07:17 -0500
Message-ID: <4919BBC5.20809@hp.com>
References: <4913028B.6010405@redhat.com> <20081111164028.GA29902@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0027.austin.hp.com ([15.216.28.34]:6382 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbYKKRHV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Nov 2008 12:07:21 -0500
In-Reply-To: <20081111164028.GA29902@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Ric Wheeler <rwheeler@redhat.com>, David Woodhouse <dwmw2@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Tom Coughlan <coughlan@redhat.com>, Matthew Wilcox <matthew@wil.cx>, Jens Axboe <jens.axboe@oracle.com>

Christoph Hellwig wrote:

> Why do most people assume that sending unmap/trim commands for every
> deletet extent ASAP is a good idea? 

I agree with you. Thus my earlier assertion:

- trim/unmap for SSD garbage collection has a different goal
   than trim/unmap for thin provisioning.

In the SSD garbage collector mode, we want to send them as fast
as we can (per the Intel SSD architect).  This allows them to
do their optimizations.

In the Thin Provision mode, we want to delay them as you said:

> So I think not actually doing these on every alloc/free is a good idea.
> Instead the filesystem would free bits when big enough regions happen,

to be filesystem friendly.

But this won't change the block layer.  This is a per-filesystem
coding issue to decide when to send the discard.

jim
