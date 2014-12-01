From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/4] scsi: remove MSG_*_TAG defines
Date: Mon, 1 Dec 2014 01:03:15 -0800
Message-ID: <20141201090315.GA4042@infradead.org>
References: <1416839781-26988-1-git-send-email-hch@lst.de>
 <20141124150725.GA23165@infradead.org>
 <54784762.8020304@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48920 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbaLAJDQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Dec 2014 04:03:16 -0500
Content-Disposition: inline
In-Reply-To: <54784762.8020304@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org, Doug Ledford <dledford@redhat.com>

On Fri, Nov 28, 2014 at 10:58:58AM +0100, Bart Van Assche wrote:
> >  	if (disable_syn_offset_one_fix) {
> >-		scsiq->q2.tag_code &= ~MSG_SIMPLE_TAG;
> >+		scsiq->q2.tag_code &= ~SIMPLE_QUEUE_TAG;
> >  		scsiq->q2.tag_code |= (ASC_TAG_FLAG_DISABLE_ASYN_USE_SYN_FIX |
> >  				       ASC_TAG_FLAG_DISABLE_DISCONNECT);
> >  	} else {
> 
> One of the statements in advansys.c (tag_code &= 0xDC) makes assumptions
> about the numeric value of MSG_SIMPLE_TAG. This makes me wonder whether it
> is safe to change MSG_SIMPLE_TAG into another value ?

MSG_SIMPLE_TAG and SIMPLE_QUEUE_TAG are two different symbolic names
for the 0x20 value assigned to the SCSI-2 protocol "SIMPLE QUEUE TAG"
message.  Having both is confusing, so I decided to only keep the one
that is named closer to the spec, and in the same namespace as the
symbolic names we use for other SCSI-2 messages.

