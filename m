From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [RFC] libata-scsi: introducing SANITIZE translation
Date: Mon, 11 Jul 2016 14:35:46 +0800
Message-ID: <CAGnHSEms1rwy7-+URRMrdggpk=_7YVijHwf1h93iBKW7zLxh8g@mail.gmail.com>
References: <577e843e.0a86620a.59167.ffffb899@mx.google.com>
 <1467910054.2322.7.camel@HansenPartnership.com> <CAGnHSE=8HEZ8AnDGjdOAhaA8f117GdbZZNhbQQOCYYM1b-8PvQ@mail.gmail.com>
 <1467998971.2343.10.camel@HansenPartnership.com> <CAGnHSEkLer=GRZxoc=AmS7J_oe945hSdUV2TisSuvfXdCPQ2Ow@mail.gmail.com>
 <1468025398.2390.24.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:34115 "EHLO
	mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbcGKGgS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jul 2016 02:36:18 -0400
In-Reply-To: <1468025398.2390.24.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Tejun Heo <tj@kernel.org>, martin.petersen@oracle.com, dgilbert@interlog.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

I don't suppose there would be any problem doing it in userspace /
with ATA PASS-THROUGH anyway. I just couldn't agree that it would be
the reason not to implement the translation (which covers the core
part of the feature set) in the kernel. But certainly I wouldn't keep
aruging on this.

I don't think we would really want to patch sg_sanitize the way you
proposed, otherwise we would have made the SCSI disk driver doing ATA
IDENTIFY DEVICE and issue TRIM commands directly, instead of relying
on a SATL. ATA PASS-THROUGH should never be "triggered" like that
anyway.

Well, it is alright to have an "sg_sat_sanitize" (which makes use of
ATA PASS-THROUGH like other sg_sat_*) though. I am just not sure if
sg3_utils should go on having more sg_sat_*...

On 9 July 2016 at 08:49, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Fri, 2016-07-08 at 19:38 +0000, Tom Yan wrote:
>> On 8 July 2016 at 17:29, James Bottomley
>> <James.Bottomley@hansenpartnership.com> wrote:
>> > Or we could simply patch sg_sanitze to issue the ATA_16 pass
>> > through when it sees a sata device ...
>> >
>>
>> Ugh that sounds ugly to me. Anyway that's off-topic.
>
> Not really.  The point is that you've proposed something as an addition
> to the kernel that can also be done in userspace.  Checking if it can
> work easily there is like a barrier to entry.  If it works, then fine,
> we're done.  If it throws up problems then we reconsider the kernel
> route.
>
> James
>
