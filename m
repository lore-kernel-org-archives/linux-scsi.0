From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 111441] iscsi fails to attach to targets
Date: Mon, 01 Feb 2016 02:13:19 +0000
Message-ID: <bug-111441-11613-98XwK0TZxJ@https.bugzilla.kernel.org/>
References: <bug-111441-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:48942 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933513AbcBACNX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Jan 2016 21:13:23 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id EBDE6203F1
	for <linux-scsi@vger.kernel.org>; Mon,  1 Feb 2016 02:13:21 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 1C264203EC
	for <linux-scsi@vger.kernel.org>; Mon,  1 Feb 2016 02:13:20 +0000 (UTC)
In-Reply-To: <bug-111441-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D111441

--- Comment #9 from Serguei Bezverkhi <sbezverk@cisco.com> ---
Hi Mike,

I have built a new kernel with debug and collected dmesg, hopefully thi=
s log
has more info to understand why alua fails to attach remote targets wit=
h error
-22.

Please see attached log.

Thank you

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
=46rom: Nicholas A. Bellinger [mailto:nab@linux-iscsi.org]=20
Sent: Saturday, January 30, 2016 2:39 AM
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Serguei Bezverkhi (sbezverk) <sbezverk@cisco.com>;
bugzilla-daemon@bugzilla.kernel.org; linux-scsi@vger.kernel.org; Christ=
oph
Hellwig <hch@infradead.org>; Hannes Reinecke <hare@suse.de>
Subject: Re: [Bug 111441] New: iscsi fails to attach to targets

On Fri, 2016-01-29 at 17:32 -0600, Mike Christie wrote:
> On 01/29/2016 04:21 PM, Serguei Bezverkhi (sbezverk) wrote:
> > HI Mike,
> >=20
> > I tried your patch and it is has eliminated first traceback but I s=
till do not see my remote targets.
> >=20
>=20
> That is sort of expected. Your target is not setup for ALUA properly.=
=20
> It says it supports ALUA, but when scsi_dh_alua asks about the ports=20
> it is reporting there are none. Ccing the people that made the patch=20
> that added the issue and own the code.
>=20
> Hey Christoph and Hannes,
>=20
> The dh/alua changes that added this:
>=20
>         error =3D scsi_dh_add_device(sdev);
>         if (error) {
>                 sdev_printk(KERN_INFO, sdev,
>                                 "failed to add device handler: %d\n",=
=20
> error);
>                 return error;
>         }
>=20
> to scsi_sysfs_add_sdev are adding a regression.
>=20
> 1. If that fails, then we forget to do device_del before doing the=20
> return. My patch in this thread added that back, so we do not see the=
=20
> sysfs oopses anymore. But.....
>=20
> 2. It looks like in older kernels, we would allow misconfigured=20
> targets like this one to still setup devices. Do we want that old beh=
avior back?
> Should we just ignore the return value from scsi_dh_add_device above?
> Note that in this case, it is LIO so it can be easily fixed on the=20
> target side by just setting it up properly. I do not think other=20
> targets would hit this type of issue.
>=20

Btw, what does misconfigured mean here wrt target ALUA..?

--=20
You are receiving this mail because:
You are the assignee for the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
