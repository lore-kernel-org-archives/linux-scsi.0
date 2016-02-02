From: "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
Subject: RE: [Bug 111441] New: iscsi fails to attach to targets
Date: Tue, 2 Feb 2016 21:54:03 +0000
Message-ID: <4b7b0ac8976d491287801fe8330eddbb@XCH-ALN-006.cisco.com>
References: <bug-111441-11613@https.bugzilla.kernel.org/>
 <56AAC605.1080707@cs.wisc.edu>
 <9cf7d536fcc44d9d8f35d81503543497@XCH-ALN-006.cisco.com>
 <36266784-E570-406E-8C3A-56D0F728768B@cs.wisc.edu>
 <a331d83963b64d7da77352b01c1d10da@XCH-ALN-006.cisco.com>
 <01C3BBA0-3D1A-461A-9EEF-512A57707325@cs.wisc.edu>
 <4c4653b259cd4f1887505dfc61d500a8@XCH-ALN-006.cisco.com>
 <56ABBCFF.9060003@cs.wisc.edu>
 <26376c0ade5645cfac5cc248a97528ba@XCH-ALN-006.cisco.com>
 <56ABF6A6.8070506@cs.wisc.edu> <20160202180956.GB13880@infradead.org>
 <56B10D90.2010506@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alln-iport-6.cisco.com ([173.37.142.93]:22167 "EHLO
	alln-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763AbcBBVyG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Feb 2016 16:54:06 -0500
In-Reply-To: <56B10D90.2010506@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@infradead.org>
Cc: "bugzilla-daemon@bugzilla.kernel.org" <bugzilla-daemon@bugzilla.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>

HI Mike,

It is working now, it spits alua related error messages but it attaches=
 remote and local targets, so my OpenStack is back to life. Please let =
me know if you plan to commit this fix upstream.

[   27.579303] scsi 3:0:0:2: Direct-Access     LIO-ORG  san-disk-2     =
  4.0  PQ: 0 ANSI: 5
[   27.579797] sd 3:0:0:2: alua: supports implicit and explicit TPGS
[   27.579932] sd 3:0:0:2: [sdc] 20507809792 512-byte logical blocks: (=
10.4 TB/9.54 TiB)
[   27.579975] sd 3:0:0:2: alua: No target port descriptors found
[   27.579977] sd 3:0:0:2: alua: Attach failed (-22)
[   27.580640] sd 3:0:0:2: failed to add device handler: -22
[   27.580897] sd 3:0:0:2: [sdc] Write Protect is off
[   27.580899] sd 3:0:0:2: [sdc] Mode Sense: 43 00 10 08
[   27.580922] sd 3:0:0:2: Attached scsi generic sg3 type 0
[   27.581041] sd 3:0:0:2: [sdc] Write cache: enabled, read cache: enab=
led, supports DPO and FUA
[   27.630156] sd 3:0:0:2: [sdc] Attached SCSI disk

Thank you very much

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
=46rom: Mike Christie [mailto:michaelc@cs.wisc.edu]=20
Sent: Tuesday, February 02, 2016 3:12 PM
To: Christoph Hellwig <hch@infradead.org>
Cc: Serguei Bezverkhi (sbezverk) <sbezverk@cisco.com>; bugzilla-daemon@=
bugzilla.kernel.org; linux-scsi@vger.kernel.org; Hannes Reinecke <hare@=
suse.de>
Subject: Re: [Bug 111441] New: iscsi fails to attach to targets

On 02/02/2016 12:09 PM, Christoph Hellwig wrote:
> On Fri, Jan 29, 2016 at 05:32:54PM -0600, Mike Christie wrote:
>> Hey Christoph and Hannes,
>>
>> The dh/alua changes that added this:
>>
>>         error =3D scsi_dh_add_device(sdev);
>>         if (error) {
>>                 sdev_printk(KERN_INFO, sdev,
>>                                 "failed to add device handler: %d\n"=
,=20
>> error);
>>                 return error;
>>         }
>>
>> to scsi_sysfs_add_sdev are adding a regression.
>>
>> 1. If that fails, then we forget to do device_del before doing the=20
>> return. My patch in this thread added that back, so we do not see th=
e=20
>> sysfs oopses anymore. But.....
>=20
> Ok.
>=20
>> 2. It looks like in older kernels, we would allow misconfigured=20
>> targets like this one to still setup devices. Do we want that old be=
havior back?
>> Should we just ignore the return value from scsi_dh_add_device above=
?
>> Note that in this case, it is LIO so it can be easily fixed on the=20
>> target side by just setting it up properly. I do not think other=20
>> targets would hit this type of issue.
>=20
> Be liberal in what you accept..  I guess we need to continue allowing=
=20
> to connect to these broken targets, but a warning would be useful.
>=20
> Can you send a patch?

Serguei, can you try the attached patch? Drop the other one I sent.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
