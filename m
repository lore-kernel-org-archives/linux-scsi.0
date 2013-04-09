From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/4] scsi: 64-bit LUN support
Date: Tue, 09 Apr 2013 09:38:04 +0200
Message-ID: <5163C55C.3020909@suse.de>
References: <1361261883-41467-1-git-send-email-hare@suse.de> <alpine.WNT.2.00.1303261354360.5004@N5102REMCQXM4BS.qlogic.org> <5152A19C.7010500@suse.de> <5155C235.40807@redhat.com> <515718A3.1080302@suse.de> <51587619.1060208@redhat.com> <515D533C.1070809@suse.de> <e585e906-5ada-4fe6-a21d-b735c42a51c1@CMEXHTCAS1.ad.emulex.com> <5162E426.40202@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40831 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935323Ab3DIHiH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Apr 2013 03:38:07 -0400
In-Reply-To: <5162E426.40202@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: James.Smart@emulex.com, Chad Dupuis <chad.dupuis@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Jeremy Linton <jlinton@tributary.com>, Robert Elliott <Elliott@hp.com>, Bart Van Assche <bvanassche@acm.org>, Bud Brown <bubrown@redhat.com>

On 04/08/2013 05:37 PM, Tomas Henzl wrote:
> On 04/05/2013 05:24 PM, James Smart wrote:
>>
>> On 4/4/2013 6:17 AM, Hannes Reinecke wrote:
>>> On 03/31/2013 07:44 PM, Tomas Henzl wrote:
>>>> What we can do is to decode the LUN and compare it to max_lun prov=
ided by the driver,
>>>> I think that sg_luns is able to do that, so what is needed is just=
 to follow the SAM.
>>>>
>>>> I have seen reports of problem on three different drivers connecte=
d to various
>>>> external storage, all of them having the same basic reason - the d=
river sets a max_lun
>>>> and then LUN comes encoded with a newer addressing method and some=
thing like this is shown
>>>> 'kernel: scsi: host 2 channel 0 id 2 lun16643 has a LUN larger tha=
n allowed by the host adapter'
>>>>
>>>> Decoding the real LUN value would fix this problem, by decoding is=
 only meant the use in
>>>> scsi_report_lun_scan. The LUN would be stored exactly the same way=
 as it is now.
>>>> I know we can patch the certain drivers too, but when max_lun were=
  what the name says
>>>> - max LU number, it would fix my problem very easy.
>>>>
>>> Errm.
>>>
>>> No. Decoding LUNs is _evil_. It has only a relevance on the target,
>>> and even then it might choose to ignore it.
>>> So we cannot try to out-guess the target here.
> OK, I can see the problems with decoding the LUN one of them is the n=
eed to
> again encode the LUN to address format + number. I'm not sure if the =
hw
> would work if another address mode were used.
>=20
> When we understand the LUN as a complex structure then it makes no se=
nse
> to compare to max_lun as a number - http://lxr.linux.no/#linux+v3.8.6=
/drivers/scsi/scsi_scan.c#L1471
>=20
Oh, but it does. See below.

>>> The error you're reporting is that lpfc is setting max_luns to
>>> '255', which of course is less than 16643. Increasing max_luns on
>>> lpfc to '0xFFFF' will fix your problem; nothing to do with 64-bit
>>> LUNs ...
> I think I haven't mentioned lpfc, but it doesn't matter.
> Fixing this in individual drivers by increasing the max_lun is not ea=
sy,
> because the firmware could have some reasons for the max lun (some ta=
bles, ...,=20
> fact is I have no idea how this is implemented in the hw).
> If the fix for this were just to set max_lun to 0xFFFF in every drive=
r
> it means that we could remove the max_lun and the test completely.=20
>=20
> A kernel option like 'ignore_max_lun' would help, but I somehow disli=
ke it,
> what do you think?
>=20
Well, I've thought about this, too.

You are right in the sense that 'max_lun' actually has a double meaning=
=2E

=46irst it's being used as the upper limit for sequential scan, where
is has a strictly sequential meaning. So any internal LUN structure
doesn't come into play here are we're just 'counting'.

Secondly it's being used as a simple validation for any LUN numbers
reported via REPORT LUNS.
Here it the max_lun value actually refers to the amount of _bits_ in
a LUN number the HBA can transfer. Again, the internal LUN structure
doesn't come into play here; this is purely a hardware limitation on
the HBA. Whether a LUN is valid or not is none of our concern; if
the target accepts the LUN is has to be valid. If it doesn't then we
don't care whether the LUN structure is valid or not; there is no
device to be had anyway.

However, after consulting SAM it is true that a plain 'max_lun' is
incorrect for any LUN value higher than 255.
LUN values higher than 255 should be represented with the 'flat
space addressing' model, ie bit 6 should be set.
Sadly, the various SAM revisions differ on how LUNs lower than
255 should be treated; they might or might not have set the flat
space addressing model.

So yeah, I guess we should be handling the HBA restriction different
from the max_lun setting.

I see to cook up a patch.

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
