From: "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
Subject: RE: [Bug 111441] New: iscsi fails to attach to targets
Date: Mon, 22 Feb 2016 11:36:04 +0000
Message-ID: <c9a966bc038a49cc9c78a88db432c39f@XCH-ALN-006.cisco.com>
References: <bug-111441-11613@https.bugzilla.kernel.org/>
 <56AAC605.1080707@cs.wisc.edu>
 <9cf7d536fcc44d9d8f35d81503543497@XCH-ALN-006.cisco.com>
 <36266784-E570-406E-8C3A-56D0F728768B@cs.wisc.edu>
 <a331d83963b64d7da77352b01c1d10da@XCH-ALN-006.cisco.com>
 <01C3BBA0-3D1A-461A-9EEF-512A57707325@cs.wisc.edu>
 <4c4653b259cd4f1887505dfc61d500a8@XCH-ALN-006.cisco.com>
 <56ABBCFF.9060003@cs.wisc.edu>
 <26376c0ade5645cfac5cc248a97528ba@XCH-ALN-006.cisco.com>
 <56ABF6A6.8070506@cs.wisc.edu>
 <8f6cc8ca33274ddaa9faf17f00caefdf@XCH-ALN-006.cisco.com>
 <56CAB3E4.4030902@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alln-iport-1.cisco.com ([173.37.142.88]:6921 "EHLO
	alln-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199AbcBVLgH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Feb 2016 06:36:07 -0500
In-Reply-To: <56CAB3E4.4030902@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>
Cc: "bugzilla-daemon@bugzilla.kernel.org" <bugzilla-daemon@bugzilla.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

Hello Hannes,

Thank you for your reply. I am on 4.4.2 kernel, is there any chance to =
commit it in 4.4 as well? If not, could you send me diff for 4.4 kernel=
=2E

Best regards

Serguei


Serguei Bezverkhi,
TECHNICAL LEADER.SERVICES
Global SP Services
sbezverk@cisco.com
Phone:=A0+1 416 306 7312
Mobile:=A0+1 514 234 7374

CCIE (R&S,SP,Sec) - #9527

Cisco.com



=A0Think before you print.
This email may contain confidential and privileged material for the sol=
e use of the intended recipient. Any review, use, distribution or discl=
osure by others is strictly prohibited. If you are not the intended rec=
ipient (or authorized to receive for the recipient), please contact the=
 sender by reply email and delete all copies of this message.
Please=A0click here=A0for Company Registration Information.




-----Original Message-----
=46rom: Hannes Reinecke [mailto:hare@suse.de]=20
Sent: Monday, February 22, 2016 2:08 AM
To: Serguei Bezverkhi (sbezverk) <sbezverk@cisco.com>; Mike Christie <m=
ichaelc@cs.wisc.edu>
Cc: bugzilla-daemon@bugzilla.kernel.org; linux-scsi@vger.kernel.org; Ch=
ristoph Hellwig <hch@infradead.org>
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
t notably the commit 'scsi: ignore errors from scsi_dh_add_device()' wh=
ich was included in 4.5.

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
