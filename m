From: Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: Re: [PATCH 1/1] scsi: retrieve cache mode using ATA_16 if normal
 routine fails
Date: Fri, 27 Jan 2012 10:50:52 +0530
Message-ID: <CADDb1s1cGJTAQNMvSwpt15YiLiCo0JwAqW+V611e__v8gR4fFA@mail.gmail.com>
References: <1323688722-25400-1-git-send-email-amit.sahrawat83@gmail.com>
	<1323694267.20451.5.camel@dabdike>
	<CAKYAXd-3LYJUWbAqaT4XfbNXJ_F0L1Lxu1evUxLyu=poHLMFug@mail.gmail.com>
	<1323766382.8163.12.camel@dabdike>
	<4EE7B7B9.7060700@garzik.org>
	<CADDb1s1JwTbeFMsL4Vcz99PhgZKAMG05rgqankYCNeJLFRQSMg@mail.gmail.com>
	<1323848398.3063.12.camel@dabdike>
	<CAKYAXd9ncxETxTEP0Vy8CVyDJODsGuVT4jnpfQYCkcU8tXRtDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKYAXd9ncxETxTEP0Vy8CVyDJODsGuVT4jnpfQYCkcU8tXRtDA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jeff@garzik.org>, Nam-Jae Jeon <namjae.jeon@samsung.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, mdharm-usb@one-eyed-alien.net
List-Id: linux-scsi@vger.kernel.org

Dear James/Jeff,

I have few questions regarding the code changes which can be accepted
in this regards.

In our scenario we are not making use of CONFIG_ATA, but still if that
is the proper manner to bring out the changes =96 then we can enable an=
d
make changes in the respective file which seems to be libata-scsi.c

We need a mechanism wherein we can query and then get the response so
that we set the WCE bit accordingly. For that matter, I think we can
introduce some function in libata-scsi.c and then call that function
from either drivers/scsi/sd.c or drivers/usb/storage/scsiglue.c

Please share your valuable inputs on how and where actually these
changes should be done. Otherwise, there is again a chance that our
changes gets rejected.

Please help in this regards.

Thanks & Regards,
Amit Sahrawat



On Thu, Dec 15, 2011 at 5:55 AM, Namjae Jeon <linkinjeon@gmail.com> wro=
te:
> 2011/12/14 James Bottomley <James.Bottomley@hansenpartnership.com>:
>> On Wed, 2011-12-14 at 09:14 +0530, Amit Sahrawat wrote:
>>> Just to add a thought - this issues is not related with ATA, this i=
s
>>> primarily related with HDD's with a USB interface i.e., SCSI <-> US=
B.
>>> And, when I check my kernel config, CONFIG_ATA is not selected,
>>> libata-scsi - this gets compiled only in case CONFIG_ATA is on.
>>> Are these two things inter-related?
>>
> Hi. James.
>
>> OK, so what you're telling us is that you're trying to correct a
>> deficiency in a SATL inside a USB device? =A0The device itself is AT=
A but
>> it doesn't use our libata connectors.
>>
>> I think in that case, the best way forwards is a mini-SATL correctio=
n
>> layer within USB storage. =A0USB storage is certainly the place to
>> black/white list whether this should be done. =A0ATA_16 is a bit of =
a
>> dangerous command to be throwing around because it's known to crash
>> various USB devices (and some old SCSI ones might even choke on it).
> Okay, how about make some option in Kconfig of scsi or usb storage to
> protect from the a bit of risk ATA_16 ?
> The user can select this option to use stable filesystem on USB HDD.
>>
>> depending on how big this SATL ends up being we should consider whet=
her
>> it should share processing with the libata SATL. =A0If it's just a s=
ingle
>> mode sense, my instinct is that it's probably OK to implement separa=
tely
>> (however, you need to use the libata headers ... no duplication of
>> libata opcodes and status defines like you had in the original SCSI
>> patch). =A0If there are more commands to correct on the way, it migh=
t be
>> better as shared code.
> I agree. I and Amit will check the best way between SATL or miniSATL
> in usb_storage accoding to your advice.
>
>> James
>>
>>
