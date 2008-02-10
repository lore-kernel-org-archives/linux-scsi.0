From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: scsi: Drivers not ready for sg-chaining
Date: Sun, 10 Feb 2008 10:53:48 -0600
Message-ID: <1202662428.3136.57.camel@localhost.localdomain>
References: <478F8435.5000907@panasas.com>  <478F878F.6040807@panasas.com>
	 <1202658166.3136.44.camel@localhost.localdomain>
	 <47AF2188.2030400@panasas.com>
	 <1202660210.3136.51.camel@localhost.localdomain>
	 <47AF2801.5060806@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60168 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751683AbYBJQxw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Feb 2008 11:53:52 -0500
In-Reply-To: <47AF2801.5060806@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Sun, 2008-02-10 at 18:36 +0200, Boaz Harrosh wrote:
> >> 2. Those drivers that have been using SG_ALL correctly and were converted
> >>    to support sg-chaining are not penalized because of bad/old drivers
> > 
> > I don't see they're penalised this way either ... they just have to set
> > a higher value in their host template.

> It was you who wanted that to be SG_ALL. I wanted just an hard coded = ~0.

Yes, I've changed my mind.  I think the best value for SG_ALL is the max
single table and we'll do a dynamic increase for drivers that really
have considered all the chaining implications.  That doesn't mean we
don't make the others chain ready ... we do ... we just don't force it
on them.

> I don't want to repeat myself. If it's fine with you, I trust your
> final judgment. You are welcome to submit a patch that fixes all the
> good drivers that are regressed by your suggestion.

Lowering the figure from current 255 to 128 isn't really going to cause
any regressions.  It will actually save a few unnecessary allocations
for some drivers.

James


