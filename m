From: Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: [PATCH 1/1] scsi: retrieve cache mode using ATA_16 if normal
 routine fails
Date: Thu, 15 Dec 2011 09:25:51 +0900
Message-ID: <CAKYAXd9ncxETxTEP0Vy8CVyDJODsGuVT4jnpfQYCkcU8tXRtDA@mail.gmail.com>
References: <1323688722-25400-1-git-send-email-amit.sahrawat83@gmail.com>
	<1323694267.20451.5.camel@dabdike>
	<CAKYAXd-3LYJUWbAqaT4XfbNXJ_F0L1Lxu1evUxLyu=poHLMFug@mail.gmail.com>
	<1323766382.8163.12.camel@dabdike>
	<4EE7B7B9.7060700@garzik.org>
	<CADDb1s1JwTbeFMsL4Vcz99PhgZKAMG05rgqankYCNeJLFRQSMg@mail.gmail.com>
	<1323848398.3063.12.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43546 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403Ab1LOAZx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2011 19:25:53 -0500
In-Reply-To: <1323848398.3063.12.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Amit Sahrawat <amit.sahrawat83@gmail.com>, Jeff Garzik <jeff@garzik.org>, Nam-Jae Jeon <namjae.jeon@samsung.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, mdharm-usb@one-eyed-alien.net

2011/12/14 James Bottomley <James.Bottomley@hansenpartnership.com>:
> On Wed, 2011-12-14 at 09:14 +0530, Amit Sahrawat wrote:
>> Just to add a thought - this issues is not related with ATA, this is
>> primarily related with HDD's with a USB interface i.e., SCSI <-> USB=
=2E
>> And, when I check my kernel config, CONFIG_ATA is not selected,
>> libata-scsi - this gets compiled only in case CONFIG_ATA is on.
>> Are these two things inter-related?
>
Hi. James.

> OK, so what you're telling us is that you're trying to correct a
> deficiency in a SATL inside a USB device? =C2=A0The device itself is =
ATA but
> it doesn't use our libata connectors.
>
> I think in that case, the best way forwards is a mini-SATL correction
> layer within USB storage. =C2=A0USB storage is certainly the place to
> black/white list whether this should be done. =C2=A0ATA_16 is a bit o=
f a
> dangerous command to be throwing around because it's known to crash
> various USB devices (and some old SCSI ones might even choke on it).
Okay, how about make some option in Kconfig of scsi or usb storage to
protect from the a bit of risk ATA_16 ?
The user can select this option to use stable filesystem on USB HDD.
>
> depending on how big this SATL ends up being we should consider wheth=
er
> it should share processing with the libata SATL. =C2=A0If it's just a=
 single
> mode sense, my instinct is that it's probably OK to implement separat=
ely
> (however, you need to use the libata headers ... no duplication of
> libata opcodes and status defines like you had in the original SCSI
> patch). =C2=A0If there are more commands to correct on the way, it mi=
ght be
> better as shared code.
I agree. I and Amit will check the best way between SATL or miniSATL
in usb_storage accoding to your advice.

> James
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
