From: Hannes Reinecke <hare@suse.de>
Subject: Re: mpt2sas and mpt3sas merge (again)
Date: Mon, 14 Jul 2014 16:39:21 +0200
Message-ID: <53C3EB99.5040205@suse.de>
References: <20140714083547.GA6315@infradead.org> <53C3A170.1070101@suse.de> <1405347425.2395.5.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35079 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755638AbaGNOjX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jul 2014 10:39:23 -0400
In-Reply-To: <1405347425.2395.5.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Reddy, Sreekanth" <Sreekanth.Reddy@avagotech.com>, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-scsi@vger.kernel.org

On 07/14/2014 04:17 PM, James Bottomley wrote:
> On Mon, 2014-07-14 at 11:22 +0200, Hannes Reinecke wrote:
>> On 07/14/2014 10:35 AM, Christoph Hellwig wrote:
>>> Back when the mpt3sas driver was first posted I suggested that it s=
hould
>>> be merged into mpt2sas, but my proposal didn't get much traction.
>>>
>>> Illumos has now produced a shared driver and shown that the differe=
nce
>>> are basically limited to a different S/G list format [1], and a qui=
ck
>>> experiment on the Linux drivers confirms this mostly - the addition=
al
>>> differences are various smaller workarounds for specific hardware
>>> revisions.
>>>
>>> I think we'd all be served much better with a merged driver.
>>>
>>> [1] http://thread.gmane.org/gmane.os.illumos.devel/17341
>>
>> Please. Pretty please.
>
> I support the concept, since I think everyone told LSI at the time th=
at
> splitting the drivers would become a maintenance nightmare.
>
>> I've started a merge myself, but then never found time to finalize i=
t.
>>
>> Carrying three basically identical drivers just creates a
>> maintenance overhead for everyone involved.
>>
>> The original idea of splitting the driver and just maintaining the
>> latest has never really worked out; all fixes to the latest driver
>> turned out to be applicable to the others, too.
>> So it just increased the workload for the maintainer for no real
>> gain. I would _strongly_ vote for it.
>
> This isn't really a democracy; it's about who maintains the drivers a=
nd
> right now it's LSI (or whatever their new name is).
>
> One of the big reasons we don't have a lot of leverage with them is t=
hat
> they always seem to slide updates around upstream via the distros
> (often,  it has to be admitted the DKM route), so if Red Hat, SUSE,
> Oracle and Canonical can agree not to accept LSI updates until the
> driver is done this way, we'd have a lot more leverage.
>
Hmm. We (as SUSE) have been striving to have a 'upstream first'=20
policy. IE for any new release the drivers have to be upstream=20
before we consider including it in our release.
This is most certainly true for the upcoming SLE-12 release, and=20
also has been enforced for the current SLES11 SP3 release.

This is official company policy, and has been communicated to all=20
our partners.
We do accept driver updates (ie patches which are not upstream ATM),=20
but only on the understanding that the vendor will have to push the=20
patches upstream eventually.
If they don't the patches will be kicked out of the next release.
(Which is what happened to the mptsas v4 release; it never made it=20
upstream and so got dropped from SLE-12).

However, this cuts both ways; we cannot go and tell our partners to=20
change the driver if upstream hasn't done it first.

So the push has to come from us (as the linux kernel developers);=20
after all, we should make the decision what goes in and what=20
doesn't. If a driver is in a bad state (and it's actually us which=20
defines the 'bad state') we should be discussing on how we would=20
like to improve things.
If the maintainer proves unwilling to implement our suggestions we=20
can always go ahead and implement a separate driver.

Look what happened to hpsa; this was the pretty much the showcase on=20
how it should be done:
Tomo went ahead and re-implemented the cciss driver, and eventually=20
HP adopted it as their main driver.
I agree that was pretty much the optimal case, though:-)

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
