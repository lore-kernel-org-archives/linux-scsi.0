From: Richard Sharpe <realrichardsharpe@gmail.com>
Subject: Re: [PATCH 1/1] Remove LUNs that no longer exist when we scan a
 target with REPORT LUNS.
Date: Thu, 19 Aug 2010 19:59:21 -0700
Message-ID: <AANLkTikz21mH1dKxD-d6qm6Y-GeEfu6pC2ORob-=JnNt@mail.gmail.com>
References: <1281917313-1855-1-git-send-email-realrichardsharpe@gmail.com>
	<1281917313-1855-2-git-send-email-realrichardsharpe@gmail.com>
	<AANLkTi=LvbUnQjPjFrHFtszMkY526mu8X9vCrMDEBO5C@mail.gmail.com>
	<1282144397.3035.32.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62108 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab0HTC7W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2010 22:59:22 -0400
Received: by iwn5 with SMTP id 5so305969iwn.19
        for <linux-scsi@vger.kernel.org>; Thu, 19 Aug 2010 19:59:21 -0700 (PDT)
In-Reply-To: <1282144397.3035.32.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org

On Wed, Aug 18, 2010 at 8:13 AM, James Bottomley
<James.Bottomley@suse.de> wrote:
> On Wed, 2010-08-18 at 08:10 -0700, Richard Sharpe wrote:
>> On Sun, Aug 15, 2010 at 5:08 PM, =A0<realrichardsharpe@gmail.com> wr=
ote:
>> > From: Richard Sharpe <realrichardsharpe@gmail.com>
>> >
>> > If the target returns logical_unit_not_supported when we send REPO=
RT LUNS
>> > it means that it supports REPORT LUNS but there really are no LUNs=
 there.
>> > Delete LUN 0 in that case.
>> >
>> > Also, when parsing the LUNs reported, remove any LUNs that used to=
 exist
>> > in the gaps, and remove LUNs beyond the end of those reported. The=
y no
>> > longer exist.
>> >
>> > Also don't scan a target where the ID is too large or the channel =
is
>> > too large.
>> >
>> > Tested by adding four LUNs with scst_local and then deleting them =
in
>> > various combinations, including deleting from LUN 0, deleting from=
 last
>> > LUN and deleting in the middle out.
>>
>> Hmmm, before James responds, it turns out that I did not test as
>> carefully as I thought, and deleting LUNs in the order 0, 2, ... doe=
s
>> not produce the results I expected, so I will have to rework this.
>
> OK, so I think what I'd really like is an AEN notification
> infrastructure based on the unit attentions that bubbles this up to u=
ser
> space for a decision. =A0That way if user space does the removal, we'=
re
> not going to get into locking or other problems.

Having looked at this some more, I think that I chose the wrong way to
go about this. What I think should happen is that the target (in my
case scst_local, which is both a SCSI LLD and a SCSI target driver
that hooks into SCST) should establish a UNIT ATTENTION condition with
an ASC of REPORTED LUNS DATA HAS CHANGED (ASC =3D 3Fh ASCQ =3D 0Eh).

This should be detected by the SCSI stack which should then do a
REPORT LUNS scan and do the appropriate things (like cancel any
submitted requests for LUNs that no longer exist.

Does this sound reasonable?

--=20
Regards,
Richard Sharpe
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
