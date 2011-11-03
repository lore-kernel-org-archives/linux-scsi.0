From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: RE: Question about interface between scsi mid layer and lld
Date: Thu, 3 Nov 2011 21:26:38 +0000
Message-ID: <0F5B06BAB751E047AB5C87D1F77A77887D5D513DA2@GVW0547EXC.americas.hpqcorp.net>
References: <20111103134647.GC6635@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:14149 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab1KCVf6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Nov 2011 17:35:58 -0400
In-Reply-To: <20111103134647.GC6635@beardog.cce.hp.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "scameron@beardog.cce.hp.com" <scameron@beardog.cce.hp.com>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>
Cc: "Brace, Don" <dab@hp.com>, LKML-scsi <linux-scsi@vger.kernel.org>

Adding the linux-scsi list...

-- mikem

"If you don't read the newspaper, you are uninformed; if you do read the newspaper, you are misinformed." - Mark Twain


> -----Original Message-----
> From: scameron@beardog.cce.hp.com [mailto:scameron@beardog.cce.hp.com]
> Sent: Thursday, November 03, 2011 8:47 AM
> To: james.bottomley@hansenpartnership.com
> Cc: Brace, Don; Miller, Mike (OS Dev); scameron@beardog.cce.hp.com
> Subject: Question about interface between scsi mid layer and lld
> 
> 
> Hi James,
> 
> I had a question about the interface between the scsi mid layer
> and LLDs, esp. how commands are submitted to the LLD.  Suppose you
> have an HBA that might prefer to have a batch of commands submitted
> to it all at once rather than one by one.
> 
> With the block layer interface, the LLD has a function which the
> block layer calls to begin submitting requests, but then this function
> calls blk_peek_request() and blk_start_request to pull requests out
> of the block layer, and so it could pull as many as it could hold,
> or as many as the block layer had lying around for it to work on.
> 
> The scsi LLD interface, with the queuecommand function is different
> in that it gets called once for each SCSI command, and there's as far
> as I know no way for the LLD to kind of pull more commands out of the
> scsi mid layer.
> 
> First, am I correct in thinking that there's no way for the LLD to
> process more than one command per call to queuecommand?  Or am
> I missing some interface that's already there?
> 
> Second, if I am correct, are there any plans to provide an interface
> to do something like that?
> 
> I'm thinking with the existing interface, if I want to batch commands
> in SCSI a driver, I have to introduce latency, as the LLD has no idea
> how many commands the mid layer has to submit, or when it will submit
> them -- and introducing latency is probably not a good idea and likely
> will eat all the benefits that might be gained by batching submissions
> to the HBA.
> 
> Thanks,
> 
> -- steve
> 

