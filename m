From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 111441] iscsi fails to attach to targets
Date: Mon, 22 Feb 2016 11:36:09 +0000
Message-ID: <bug-111441-11613-IdSGohvHVe@https.bugzilla.kernel.org/>
References: <bug-111441-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:43361 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754199AbcBVLgO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Feb 2016 06:36:14 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3E96E2047D
	for <linux-scsi@vger.kernel.org>; Mon, 22 Feb 2016 11:36:13 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 425D7204B0
	for <linux-scsi@vger.kernel.org>; Mon, 22 Feb 2016 11:36:10 +0000 (UTC)
In-Reply-To: <bug-111441-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D111441

--- Comment #18 from Serguei Bezverkhi <sbezverk@cisco.com> ---
Hello Hannes,

Thank you for your reply. I am on 4.4.2 kernel, is there any chance to =
commit
it in 4.4 as well? If not, could you send me diff for 4.4 kernel.

Best regards

Serguei


Serguei Bezverkhi,
TECHNICAL LEADER.SERVICES
Global SP Services
sbezverk@cisco.com
Phone:=C2=A0+1 416 306 7312
Mobile:=C2=A0+1 514 234 7374

CCIE (R&S,SP,Sec) - #9527

Cisco.com



=C2=A0Think before you print.
This email may contain confidential and privileged material for the sol=
e use of
the intended recipient. Any review, use, distribution or disclosure by =
others
is strictly prohibited. If you are not the intended recipient (or autho=
rized to
receive for the recipient), please contact the sender by reply email an=
d delete
all copies of this message.
Please=C2=A0click here=C2=A0for Company Registration Information.




-----Original Message-----
=46rom: Hannes Reinecke [mailto:hare@suse.de]=20
Sent: Monday, February 22, 2016 2:08 AM
To: Serguei Bezverkhi (sbezverk) <sbezverk@cisco.com>; Mike Christie
<michaelc@cs.wisc.edu>
Cc: bugzilla-daemon@bugzilla.kernel.org; linux-scsi@vger.kernel.org; Ch=
ristoph
Hellwig <hch@infradead.org>
Subject: Re: [Bug 111441] New: iscsi fails to attach to targets

On 02/22/2016 01:45 AM, Serguei Bezverkhi (sbezverk) wrote:
> Hi Mike,
>=20
> I just wanted to follow up with you to see if the patch got committed=
 to an upstream kernel if yes, please let me into which version it went=
=2E
>=20
> Thank you
>=20
> Serguei
>=20
>=20
> Serguei Bezverkhi,
> TECHNICAL LEADER.SERVICES
> Global SP Services
> sbezverk@cisco.com
> Phone: +1 416 306 7312
> Mobile: +1 514 234 7374
>=20
> CCIE (R&S,SP,Sec) - #9527
>=20
> Cisco.com
>=20
>=20
>=20
>  Think before you print.
> This email may contain confidential and privileged material for the s=
ole use of the intended recipient. Any review, use, distribution or dis=
closure by others is strictly prohibited. If you are not the intended r=
ecipient (or authorized to receive for the recipient), please contact t=
he sender by reply email and delete all copies of this message.
> Please click here for Company Registration Information.
>=20
>=20
>=20
> -----Original Message-----
> From: Mike Christie [mailto:michaelc@cs.wisc.edu]
> Sent: Friday, January 29, 2016 6:33 PM
> To: Serguei Bezverkhi (sbezverk) <sbezverk@cisco.com>
> Cc: bugzilla-daemon@bugzilla.kernel.org; linux-scsi@vger.kernel.org;=20
> Christoph Hellwig <hch@infradead.org>; Hannes Reinecke <hare@suse.de>
> Subject: Re: [Bug 111441] New: iscsi fails to attach to targets
>=20
> On 01/29/2016 04:21 PM, Serguei Bezverkhi (sbezverk) wrote:
>> HI Mike,
>>
>> I tried your patch and it is has eliminated first traceback but I st=
ill do not see my remote targets.
>>
>=20
> That is sort of expected. Your target is not setup for ALUA properly.=
 It says it supports ALUA, but when scsi_dh_alua asks about the ports i=
t is reporting there are none. Ccing the people that made the patch tha=
t added the issue and own the code.
>=20
> Hey Christoph and Hannes,
>=20
> The dh/alua changes that added this:
>=20
>         error =3D scsi_dh_add_device(sdev);
>         if (error) {
>                 sdev_printk(KERN_INFO, sdev,
>                                 "failed to add device handler: %d\n",=
 error);
>                 return error;
>         }
>=20
> to scsi_sysfs_add_sdev are adding a regression.
>=20
> 1. If that fails, then we forget to do device_del before doing the re=
turn. My patch in this thread added that back, so we do not see the sys=
fs oopses anymore. But.....
>=20
> 2. It looks like in older kernels, we would allow misconfigured targe=
ts like this one to still setup devices. Do we want that old behavior b=
ack?
> Should we just ignore the return value from scsi_dh_add_device above?
> Note that in this case, it is LIO so it can be easily fixed on the ta=
rget side by just setting it up properly. I do not think other targets =
would hit this type of issue.
>=20
>=20
This has been fixed up with my patchset to update the ALUA handler, mos=
t
notably the commit 'scsi: ignore errors from scsi_dh_add_device()' whic=
h was
included in 4.5.

Cheers,

Hannes

--=20
You are receiving this mail because:
You are the assignee for the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
