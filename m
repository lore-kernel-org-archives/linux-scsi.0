From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [GIT PULL] SCSI bug fixes for 2.6.36-rc7
Date: Wed, 13 Oct 2010 17:29:06 -0700
Message-ID: <AANLkTi=YH_-Oar15Yd1jW0yz7SL3x=FQxMpZ+ppZx6D4@mail.gmail.com>
References: <1286977551.2969.22.camel@mulgrave.site>
	<AANLkTimUT37LfmnU8Rc0+K8r+owCp9e_VyriDHRyuuhr@mail.gmail.com>
	<1287015899.10264.394.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59073 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab0JNA3H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Oct 2010 20:29:07 -0400
In-Reply-To: <1287015899.10264.394.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Wed, Oct 13, 2010 at 5:24 PM, James Bottomley
<James.Bottomley@suse.de> wrote:
> On Wed, 2010-10-13 at 16:49 -0700, Linus Torvalds wrote:
>> On Wed, Oct 13, 2010 at 6:45 AM, James Bottomley
>> <James.Bottomley@suse.de> wrote:

>>
>> Umm. That other patch seems to be utter crap.
>>
>> > - =C2=A0 =C2=A0 =C2=A0 hdr->device_status =3D status_byte(rq->erro=
rs);
>> > + =C2=A0 =C2=A0 =C2=A0 hdr->device_status =3D rq->errors && 0xff;
>>
>> That's pure shit. Please look at it for one second, and don't send m=
e
>> crap like this.
>
> What's wrong with it? device_status() is an ancient SCSI-1 macro that
> dates from the time the status was left shifted by 1, which makes the
> value wrong according to the sg interface spec. =C2=A0We should reall=
y remove
> it, but there's still a few ancient drivers using it. =C2=A0the SG in=
terface
> requires the full status byte, which is what the bottom most byte of
> req_errors is ... hence the change.
>

How about & instead of &&

Harvey
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
