From: Grant Grundler <grundler@google.com>
Subject: Re: [PATCH] Forcing capacity sizes for block devices
Date: Tue, 22 Dec 2009 12:15:55 -0800
Message-ID: <da824cf30912221215w5fb9bce4w4cd4165cd6f7a870@mail.gmail.com>
References: <2f83750a0912200405v77f39a7eifef024cc4cb10a20@mail.gmail.com>
	 <200912201843.40169.bzolnier@gmail.com>
	 <da824cf30912211204jc70fc10ta6f6de1208d2b364@mail.gmail.com>
	 <200912212259.34808.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:1968 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbZLVUQB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Dec 2009 15:16:01 -0500
Received: from wpaz29.hot.corp.google.com (wpaz29.hot.corp.google.com [172.24.198.93])
	by smtp-out.google.com with ESMTP id nBMKFwhB001950
	for <linux-scsi@vger.kernel.org>; Tue, 22 Dec 2009 20:15:59 GMT
Received: from ewy3 (ewy3.prod.google.com [10.241.103.3])
	by wpaz29.hot.corp.google.com with ESMTP id nBMKFuOv000360
	for <linux-scsi@vger.kernel.org>; Tue, 22 Dec 2009 12:15:57 -0800
Received: by ewy3 with SMTP id 3so7673454ewy.13
        for <linux-scsi@vger.kernel.org>; Tue, 22 Dec 2009 12:15:56 -0800 (PST)
In-Reply-To: <200912212259.34808.bzolnier@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Clemens Fruhwirth <clemens@endorphin.org>, linux-scsi@vger.kernel.org

On Mon, Dec 21, 2009 at 1:59 PM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
=2E..
>> > Just a wild idea but maybe the current block infrastructure for ha=
ndling
>> > ATA HPA (see commit db429e9 and e957b60 one) can be used to automa=
tically
>> > detect and workaround the issue?
>>
>> Are you referring to this change?
>> + =C2=A0 =C2=A0 =C2=A0 libata.ignore_hpa=3D =C2=A0 =C2=A0 =C2=A0[LIB=
ATA] Ignore HPA limit
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 libata.ignore_hpa=3D0 =C2=A0 =C2=A0 =C2=A0 keep BIOS limits =
(default)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 libata.ignore_hpa=3D1 =C2=A0 =C2=A0 =C2=A0 ignore limits, us=
ing full disk
>
> Nah.
>
>> My git-foo isn't very good...what command will display the two chang=
es
>> you refer to above?
>
> git log -p --color db429e9^1..e957b60

Perfect!

> We should be able to detect working SD reader/card combination in sd
> driver's ->set_capacity method implementation (i.e. by issuing read
> request for the last partitioned sector outside of the reported devic=
e
> capacity) during the initial partition table scan and at the same tim=
e
> adjust the device capacity used by the kernel if necessary.

Yup - I think you are right.

> New/empty cards would still need to be 'force partitioned' first usin=
g
> fdisk (or sfdisk if fdisk doesn't allow such operation) but after it'=
s
> done the partition rescan on fdisk's exit will recognize new device's
> capacity automatically..
>
>> about b0rked HW, the user (or udev maybe?) can workaround this issue=
=2E
>> Given how simple the patch, I don't see any reason to reject it.
>
> Simple to write or simple to maintain? ;)

Write of course. :)
And in retrospect, even that statement is wrong since nothing in the
storage stack is as simple as it looks.

> To be honest the patch looks like a gross and dangerous hack..

Agreed.  I expect there will always be some devices that will get the
partition/device size wrong and it would be expedient use this hack to
work around "non-compliant" devices. Clemens already proved it works
for him (even though it's not quite right).

> Firstly block layer needs to be properly informed about capacity chan=
ges
> (set_capacity() + request for partition rescan which the patch doesn'=
t do)
> and secondly fixing the problem at the sysfs block/partition layer se=
ems
> to be a layering violation (i.e. it also allows partition size change=
s).

It's the exported interface to user space. So while it's not
implemented correctly to deal with resizing (which I didn't realize,
Clemens will have to fix that), I don't consider it a layering
violation if there are APIs this code can call to notify of the
partition size change.

thanks!
grant


>
> --
> Bartlomiej Zolnierkiewicz
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
