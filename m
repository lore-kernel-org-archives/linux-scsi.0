From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [Fwd: [RFT] major libata update]
Date: Wed, 17 May 2006 17:58:32 -0400
Message-ID: <446B9C88.4030005@garzik.org>
References: <4468B596.9090508@garzik.org> <1147789098.3505.19.camel@mulgrave.il.steeleye.com> <4469F2B2.703@garzik.org> <1147794708.3505.30.camel@mulgrave.il.steeleye.com> <4469F9FB.7020807@garzik.org> <1147797507.3505.52.camel@mulgrave.il.steeleye.com> <446A048B.6040703@garzik.org> <20060517073701.GE4197@suse.de> <446B3BE0.8040806@garzik.org> <20060517173729.GS4197@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:19402 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751170AbWEQV6g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 May 2006 17:58:36 -0400
In-Reply-To: <20060517173729.GS4197@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>

Jens Axboe wrote:
> I think we have a different opinion on what 'optional' is then - because
> things can certainly work just fine the way they current do. And it's
> faster, too.
> 
>> infrastructure, you inevitably wind up with the following code pattern:
>>
>> 	infrastructure code
>> 	send fully prepared request to hardware
>> 	infrastructure code
> 
> But yes, you can make the code nicer for _some_ things with a
> ->queueone() type setup.

That ->queueone() maps the closest to what most hardware appears to 
want: "attempt to push request onto an async hardware queue".

It also enables additional entry points for returning 'device busy' or 
(in SCSI lingo) 'host busy'.  The ability to signal and handle random 
transient conditions like that when hardware resources disappear is easy 
to overlook, but its really powerful.


>> At this point I should note that all of what I've been describing is
>> an _optional addition_ to the block layer.  Its all helpers and a few
>> new, optional structs.  This SHOULD NOT involve changing the core
>> block layer at all.  Well, maybe struct request would like the
>> addition of a timer.  But that's it, and such a mod is easy to do.
> 
> The timer is a given, we can't escape that. And the ->queueone() is
> basically hashed out above, no infrastructure changes needed.
> queuecommand_helper would be driver supplied, blk_queuecommand_helper()
> would be a block layer helper. With better names of course, I truly do
> suck at naming functions :-)

Likewise :)

	Jeff


