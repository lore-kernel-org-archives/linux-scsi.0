From: Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH] fix vulnerability of the release method of file
 operations in Block layer SCSI generic driver
Date: Thu, 11 Nov 2010 21:43:36 +0800
Message-ID: <AANLkTin_ac34CT9gqSRfJm3qHG1NUjp=HC=G2ncVnAoL@mail.gmail.com>
References: <AANLkTikbkhHmsVAdGrY0OTnH=gUZW5igjsWSF9y=Ub1u@mail.gmail.com>
	<20101110151823.GC18258@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64619 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755774Ab0KKNni convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Nov 2010 08:43:38 -0500
In-Reply-To: <20101110151823.GC18258@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "Zou, Yi" <yi.zou@intel.com>, Joe Eykholt <jeykholt@cisco.com>

On Wed, Nov 10, 2010 at 11:18 PM, Matthew Wilcox <matthew@wil.cx> wrote=
:
> On Wed, Nov 10, 2010 at 10:08:37PM +0800, Hillf Danton wrote:
>> The computation context setup by previous opening the bsg file could
>> not survive following open/release operations upon the same file
>> object.
>
> Umm .. release is called on final close of a file, not on every close
> of a file.
>
right, thanks//Hillf

>> The vulnerability is fixed by deferring the cleanup operation until =
necessary.
>>
>> Signed-off-by: Hillf Danton <dhillf@gmail.com>
>> ---
>>
>> --- a/block/bsg.c =C2=A0 =C2=A0 2010-09-13 07:07:38.000000000 +0800
>> +++ b/block/bsg.c =C2=A0 =C2=A0 2010-11-10 21:43:58.000000000 +0800
>> @@ -858,7 +858,8 @@ static int bsg_release(struct inode *ino
>> =C2=A0{
>> =C2=A0 =C2=A0 =C2=A0 struct bsg_device *bd =3D file->private_data;
>>
>> - =C2=A0 =C2=A0 file->private_data =3D NULL;
>> + =C2=A0 =C2=A0 if (1 =3D=3D atomic_read(&bd->ref_count))
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 file->private_data =3D N=
ULL;
>> =C2=A0 =C2=A0 =C2=A0 return bsg_put_device(bd);
>> =C2=A0}
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>
> --
> Matthew Wilcox =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Intel Open Source Technology Centre
> "Bill, look, we understand that you're interested in selling us this
> operating system, but compare it to ours. =C2=A0We can't possibly tak=
e such
> a retrograde step."
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
