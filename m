From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: scsi: Drivers not ready for sg-chaining
Date: Sun, 10 Feb 2008 10:16:49 -0600
Message-ID: <1202660210.3136.51.camel@localhost.localdomain>
References: <478F8435.5000907@panasas.com>  <478F878F.6040807@panasas.com>
	 <1202658166.3136.44.camel@localhost.localdomain>
	 <47AF2188.2030400@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:43126 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750862AbYBJQQw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Feb 2008 11:16:52 -0500
In-Reply-To: <47AF2188.2030400@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Sun, 2008-02-10 at 18:08 +0200, Boaz Harrosh wrote:
> My patches *do not* attempt to fix the sg_chaining support. They only
> make all the drivers that use SG_ALL to use SCSI_MAX_SG_SEGMENTS.
> One by One, and not globally as your suggestion.

Yes, I know ... but it does need fixing for the listed drivers.

> This is for two reasons.
> 1. So drivers can be individually fixed and in the patch that fixes them
>    they can go back to SG_ALL.

No, it's so SG_ALL can mean use chaining ... I'm not sure that's
desirable for the default value.  Particularly for devices that key
internal sglist arrays off SG_ALL

> 2. Those drivers that have been using SG_ALL correctly and were converted
>    to support sg-chaining are not penalized because of bad/old drivers

I don't see they're penalised this way either ... they just have to set
a higher value in their host template.

> 3. Some drivers in this patchset are converted to use a real internal
>    driver limit. That does not necessarily match SCSI_MAX_SG_SEGMENTS.
>    In the event that SCSI_MAX_SG_SEGMENTS wants to change.

Yes, I looked at those they're all either safe or currently (eventually)
do the right thing.

> The bulk of the patchset is very much mechanical and is not dangerous
> and was ACKed by the more important maintainers. (That is where the
> changes are more then trivial). So I don't see why they cannot get
> a proper review and be accepted. Instead of doing the safe but the
> wrong thing, cross tree.

What's wrong about this?

James


