From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] megaraid_sas: Enable shared tag map
Date: Thu, 2 Oct 2014 02:19:16 -0700
Message-ID: <20141002091916.GA13227@infradead.org>
References: <1411991272-129962-1-git-send-email-hare@suse.de>
 <542C4D33.2030401@hp.com>
 <20141001211003.GA24820@infradead.org>
 <542CF5E8.3030601@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51506 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaJBJTV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2014 05:19:21 -0400
Content-Disposition: inline
In-Reply-To: <542CF5E8.3030601@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Webb Scales <webbnh@hp.com>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On Thu, Oct 02, 2014 at 08:51:20AM +0200, Hannes Reinecke wrote:
> 
> I'm afraid it's not _that_ easy.
> SCSI-II tagged queueing has some specific tag values:
> 
> #define SIMPLE_QUEUE_TAG    0x20
> #define HEAD_OF_QUEUE_TAG   0x21
> #define ORDERED_QUEUE_TAG   0x22

These are not tag values.  These are message codes set in the first byte
of the Queue tag message, the second byte is the actual tag.

> The recommendation here is to use 'scmd->request->tag' whenever
> you want to get to the tag number, and 'scmd->tag' if you have to
> play around with SCSI-II TCQ.
> But if not I would strongly advise to leave 'scmd->tag' alone.

Or kill off scmd->tag..  Let's see how feasible that is.

