From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 1/4] aic79xx: Fixup external device reset
Date: Wed, 25 Oct 2006 08:14:56 -0700
Message-ID: <1161789296.3816.0.camel@mulgrave.il.steeleye.com>
References: <453CC21D.5030201@suse.de>
	 <1161733051.7104.37.camel@mulgrave.il.steeleye.com>
	 <453F0BB6.2020508@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:8659 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932458AbWJYPPJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Oct 2006 11:15:09 -0400
In-Reply-To: <453F0BB6.2020508@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, "Tarte, Robert" <Robert_Tarte@adaptec.com>

On Wed, 2006-10-25 at 09:01 +0200, Hannes Reinecke wrote:
> > What's the reason for having to have this hand crafted test unit ready?
> > 
> I asked myself the same question. It's actually from the original 
> adaptec sources, and i couldn't figure out why it was need, either.
> That's why I removed it initially when doing the first round of external 
> device reset patches.
> 
> Thing is whenever we send a SCB with the MK_MESSAGE flag set the 
> sequencer will interrupt normal SCB delivery and ensure that the 
> MK_MESSAGE SCB is sent immediately. Plus we can force the connection to 
> non-packetized transfer as the resetted target will start out with 
> normal transfers, too. And as we already have invalidated the 
> negotiation settings for all targets a renegotiation will happen when 
> this TUR is completed.
> So the normal flow of operation can continue and only one command will 
> have to be requeued from the midlayer.
> 
> I think. Or that's what I've glanced from the sequencer code. Maybe Rob 
> can give some more insight here.
> 
> Admittedly, this is really a nasty tweaking. In theory we should have a 
> proper error handler which handles this sort of thing. But the entire 
> code is littered with such tweakings so that's quite a vain hope.
> Unless someone passes me a theory of operation document for it.
> Having a register description is quite pointless.

Yes ... that's what I was wondering.  However, we can go with the "it's
magic" for the time being.

James


