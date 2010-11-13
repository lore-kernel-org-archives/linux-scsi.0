From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [GIT PULL] SCSI queuecommand API change for 2.6.37-rc1
Date: Fri, 12 Nov 2010 21:03:07 -0500
Message-ID: <4CDDF1DB.1020707@garzik.org>
References: <1289606118.3015.539.camel@mulgrave.site> <AANLkTinj2BM2eGo2yyfzs=t+nu79WLW_bGYota9sDZwH@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59857 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845Ab0KMCDM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Nov 2010 21:03:12 -0500
In-Reply-To: <AANLkTinj2BM2eGo2yyfzs=t+nu79WLW_bGYota9sDZwH@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@suse.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On 11/12/2010 08:42 PM, Linus Torvalds wrote:
> On Fri, Nov 12, 2010 at 3:55 PM, James Bottomley
> <James.Bottomley@suse.de>  wrote:
>>
>> This patch set contains a single patch modifying the SCSI queuecommand
>> host template API to go from being called with the host lock held to
>> being called locklessly.  The transformation is a directly equivalent
>> one (i.e. the locking is simply pushed into each HBA) but will form the
>> basis for optimising locking in the driver patch for the next merge
>> window.
>
> Ok, so we talked about this patch at the KS, but I never saw it.
>
> And now seeing it, I do detest it.
>
> Why? Because if some driver gets missed for any reason (notably if
> it's currently out of tree, and gets merged later), afaik there will
> be ABSOLUTELY ZERO compiler warnings or anything about it, because you
> kept the "queuecommand" function exactly the same. Whether it's a
> locked or non-locked one, it always is of type
[...]
> So please: when you change the semantics of a function, just change
> the function prototype (or function name) at the same time. Especially
> when it comes to a driver interface, so that the drivers don't get
> taken by surprise.
>
> Type safety and automatic compiler warnings really are our friends.
> Especially when the patch was presumably mostly auto-generated, and
> maybe the script missed something, and missing some conversion has
> such subtle effects.

That is precisely what I mentioned in the original patch:
http://marc.info/?l=linux-ide&m=128891665713984&w=2

And brought this up again when James merged my patch:
http://marc.info/?l=linux-scsi&m=128943169802009&w=2

I even volunteer[ed] to do the work to make it happen...

	Jeff


P.S.  My patch was not auto-generated.  One of the two previous attempts 
at this change was scripted w/ coccinelle, and it created obvious 
locking problems.

