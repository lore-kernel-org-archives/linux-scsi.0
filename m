From: Erez Zilber <erezz@Voltaire.COM>
Subject: Re: [PATCH 1/3 v2] iscsi iser: remove DMA alignment restriction
Date: Mon, 05 May 2008 16:19:02 +0300
Message-ID: <481F0946.4020505@Voltaire.COM>
References: <20080214211029.GA21073@osc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fwil.voltaire.com ([193.47.165.2]:43341 "EHLO exil.voltaire.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754973AbYEENST (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 May 2008 09:18:19 -0400
In-Reply-To: <20080214211029.GA21073@osc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pete Wyckoff <pw@osc.edu>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Roland Dreier <rolandd@cisco.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>

Pete Wyckoff wrote:
> Thanks to James pointing out the problems with the BLK_BOUNCE_ANY
> for IB devices, this revised patch contains only the DMA alignment
> fix for iSER.
>
> Mike, can you take care of this and the other two patches in the
> series:
>
>     [PATCH 2/3] iscsi iser: increase max_sectors
>     [PATCH 3/3] iscsi iser: increase sg_tablesize
>
> 		-- Pete
>
>
> From 255e73b67ec1458af18395981fddebdc958e8fe9 Mon Sep 17 00:00:00 2001
> From: Pete Wyckoff <pw@osc.edu>
> Date: Thu, 14 Feb 2008 16:09:27 -0500
> Subject: [PATCH] iscsi iser: remove DMA alignment restriction
>
> iscsi_iser does not require any particular DMA aligement
> requirement.  Add a slave_configure function to set the alignment
> to zero, allowing the use of direct IO from arbitrary offsets
> within a page.
>   

We had a long discussion about it, and I'm ok with this patch. However,
I would change the description:

iSER has DMA alignment requirements that are too complex to express with
q->dma_alignment. Therefore, if necessary, bouncing should be done by
the iSER driver. Add a slave_configure function to set the alignment to
zero, allowing the use of direct IO from arbitrary offsets within a page.

Erez
