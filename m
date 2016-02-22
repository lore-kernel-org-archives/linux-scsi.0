From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 111441] iscsi fails to attach to targets
Date: Mon, 22 Feb 2016 00:45:09 +0000
Message-ID: <bug-111441-11613-jgzH9tXlCR@https.bugzilla.kernel.org/>
References: <bug-111441-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:38387 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434AbcBVApQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Feb 2016 19:45:16 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C1B50203AA
	for <linux-scsi@vger.kernel.org>; Mon, 22 Feb 2016 00:45:14 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 6B9E4203AC
	for <linux-scsi@vger.kernel.org>; Mon, 22 Feb 2016 00:45:10 +0000 (UTC)
In-Reply-To: <bug-111441-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D111441

--- Comment #16 from Serguei Bezverkhi <sbezverk@cisco.com> ---
Hi Mike,

I just wanted to follow up with you to see if the patch got committed t=
o an
upstream kernel if yes, please let me into which version it went.

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
=46rom: Mike Christie [mailto:michaelc@cs.wisc.edu]=20
Sent: Friday, January 29, 2016 6:33 PM
To: Serguei Bezverkhi (sbezverk) <sbezverk@cisco.com>
Cc: bugzilla-daemon@bugzilla.kernel.org; linux-scsi@vger.kernel.org; Ch=
ristoph
Hellwig <hch@infradead.org>; Hannes Reinecke <hare@suse.de>
Subject: Re: [Bug 111441] New: iscsi fails to attach to targets

On 01/29/2016 04:21 PM, Serguei Bezverkhi (sbezverk) wrote:
> HI Mike,
>=20
> I tried your patch and it is has eliminated first traceback but I sti=
ll do not see my remote targets.
>=20

That is sort of expected. Your target is not setup for ALUA properly. I=
t says
it supports ALUA, but when scsi_dh_alua asks about the ports it is repo=
rting
there are none. Ccing the people that made the patch that added the iss=
ue and
own the code.

Hey Christoph and Hannes,

The dh/alua changes that added this:

        error =3D scsi_dh_add_device(sdev);
        if (error) {
                sdev_printk(KERN_INFO, sdev,
                                "failed to add device handler: %d\n", e=
rror);
                return error;
        }

to scsi_sysfs_add_sdev are adding a regression.

1. If that fails, then we forget to do device_del before doing the retu=
rn. My
patch in this thread added that back, so we do not see the sysfs oopses
anymore. But.....

2. It looks like in older kernels, we would allow misconfigured targets=
 like
this one to still setup devices. Do we want that old behavior back?
Should we just ignore the return value from scsi_dh_add_device above?
Note that in this case, it is LIO so it can be easily fixed on the targ=
et side
by just setting it up properly. I do not think other targets would hit =
this
type of issue.





>=20
> Here is dmesg
>=20
> [   26.103812] scsi 3:0:0:2: Direct-Access     LIO-ORG  san-disk-2   =
    4.0  PQ: 0 ANSI: 5
> [   26.104338] sd 3:0:0:2: alua: supports implicit and explicit TPGS
> [   26.104549] sd 3:0:0:2: alua: No target port descriptors found
> [   26.104552] sd 3:0:0:2: alua: Attach failed (-22)
> [   26.104554] sd 3:0:0:2: failed to add device handler: -22
> [   26.104578] sd 3:0:0:2: [sdc] 20507809792 512-byte logical blocks:=
 (10.4 TB/9.54 TiB)
> [   26.104905] sd 3:0:0:2: [sdc] Write Protect is off
> [   26.104908] sd 3:0:0:2: [sdc] Mode Sense: 43 00 10 08
> [   26.105036] sd 3:0:0:2: [sdc] Write cache: enabled, read cache: en=
abled, supports DPO and FUA
> [   26.112294] scsi host6: iSCSI Initiator over TCP/IP
> [   26.113279] scsi 4:0:0:3: Direct-Access     LIO-ORG  san-disk-3   =
    4.0  PQ: 0 ANSI: 5
> [   26.113690] sd 4:0:0:3: alua: supports implicit and explicit TPGS
> [   26.113877] sd 4:0:0:3: [sdd] 9765625856 512-byte logical blocks: =
(5.00 TB/4.54 TiB)
> [   26.113948] sd 4:0:0:3: alua: No target port descriptors found
> [   26.113951] sd 4:0:0:3: alua: Attach failed (-22)
> [   26.113953] sd 4:0:0:3: failed to add device handler: -22
> [   26.114292] sd 4:0:0:3: [sdd] Write Protect is off
> [   26.114295] sd 4:0:0:3: [sdd] Mode Sense: 43 00 10 08
> [   26.114503] sd 4:0:0:3: [sdd] Write cache: enabled, read cache: en=
abled, supports DPO and FUA
> [   26.123875] scsi 5:0:0:1: Direct-Access     LIO-ORG  san-disk-1   =
    4.0  PQ: 0 ANSI: 5
> [   26.123911] scsi 6:0:0:4: Direct-Access     LIO-ORG  san-disk-4   =
    4.0  PQ: 0 ANSI: 5
> [   26.124452] sd 6:0:0:4: alua: supports implicit and explicit TPGS
> [   26.124453] sd 5:0:0:1: alua: supports implicit and explicit TPGS
> [   26.124724] sd 5:0:0:1: alua: No target port descriptors found
> [   26.124727] sd 5:0:0:1: alua: Attach failed (-22)
> [   26.124728] sd 5:0:0:1: failed to add device handler: -22
> [   26.124736] sd 6:0:0:4: [sde] 10742171648 512-byte logical blocks:=
 (5.49 TB/5.00 TiB)
> [   26.124773] sd 5:0:0:1: [sdf] 7812499389 512-byte logical blocks: =
(3.99 TB/3.63 TiB)
> [   26.124777] sd 6:0:0:4: alua: No target port descriptors found
> [   26.124779] sd 6:0:0:4: alua: Attach failed (-22)
> [   26.124780] sd 6:0:0:4: failed to add device handler: -22
> [   26.125182] sd 5:0:0:1: [sdf] Write Protect is off
> [   26.125184] sd 5:0:0:1: [sdf] Mode Sense: 43 00 10 08
> [   26.125217] sd 6:0:0:4: [sde] Write Protect is off
> [   26.125220] sd 6:0:0:4: [sde] Mode Sense: 43 00 10 08
> [   26.125306] sd 5:0:0:1: [sdf] Write cache: enabled, read cache: en=
abled, supports DPO and FUA
> [   26.125512] sd 6:0:0:4: [sde] Write cache: enabled, read cache: en=
abled, supports DPO and FUA
> [   26.129633]  sdf: sdf1
> [   26.130637] sd 5:0:0:1: [sdf] Attached SCSI disk
> [   26.144377] ixgbe 0000:04:00.0: registered PHC device on enp4s0f0
> [   26.149072]  sdc: sdc1
> [   26.150434] sd 3:0:0:2: [sdc] Attached SCSI disk
> [   26.190709]  sdd: sdd1 sdd2
> [   26.193348] sd 4:0:0:3: [sdd] Attached SCSI disk
> [   26.230515]  sde: sde1
> [   26.231674] sd 6:0:0:4: [sde] Attached SCSI disk
> [   26.231987] sd 6:0:0:4: [sde] Synchronizing SCSI cache
> [   26.232021] sd 5:0:0:1: [sdf] Synchronizing SCSI cache
> [   26.233212] sd 3:0:0:2: [sdc] Synchronizing SCSI cache
> [   26.233440] sd 4:0:0:3: [sdd] Synchronizing SCSI cache
> [   26.236755] Buffer I/O error on dev sdc, logical block 2563476132,=
 async page read
> [   26.238897] Buffer I/O error on dev sdd, logical block 1220703182,=
 async page read
> [   26.245773] ixgbe 0000:04:00.1: SR-IOV enabled with 8 VFs
> [   26.245775] ixgbe 0000:04:00.1: configure port vlans to keep your =
VFs secure
> [   26.274544] scsi 6:0:0:0: Unexpected response from lun 4 while sca=
nning, scan aborted
> [   26.283173] scsi 3:0:0:0: Unexpected response from lun 2 while sca=
nning, scan aborted
> [   26.288571] scsi 4:0:0:0: Unexpected response from lun 3 while sca=
nning, scan aborted
> [   26.288618] scsi 5:0:0:0: Unexpected response from lun 1 while sca=
nning, scan aborted
>=20
>=20
> Second traceback is gone too, but still no luck attaching local iscsi=
 targets either.
>=20
>=20
> [  639.148875] TARGET_CORE[iSCSI]: Expected Transfer Length: 264 does=
=20
> not match SCSI CDB Length: 8 for SAM Opcode: 0x12 [  639.148911] sd=20
> 7:0:0:0: [sdc] 115343360 512-byte logical blocks: (59.0 GB/55.0 GiB) =
[ =20
> 639.148925] sd 7:0:0:0: alua: No target port descriptors found [ =20
> 639.148928] sd 7:0:0:0: alua: Attach failed (-22) [  639.149186] sd=20
> 7:0:0:0: [sdc] Write Protect is off [  639.149188] sd 7:0:0:0: [sdc]=20
> Mode Sense: 43 00 10 08 [  639.149279] sd 7:0:0:0: [sdc] Write cache:=
=20
> enabled, read cache: enabled, supports DPO and FUA [  639.149298] iSC=
SI/iqn.1994-05.com.redhat:cf7f1fafca4b: Unsupported SCSI Opcode 0xa3, s=
ending CHECK_CONDITION.
> [  639.149530] sd 7:0:0:0: failed to add device handler: -22 [ =20
> 639.154762] sd 7:0:0:0: [sdc] Attached SCSI disk [  639.154857] sd=20
> 7:0:0:0: [sdc] Synchronizing SCSI cache
> [  655.279047] scsi 7:0:0:0: Direct-Access     LIO-ORG  IBLOCK       =
    4.0  PQ: 0 ANSI: 5
> [  655.279397] sd 7:0:0:0: alua: supports implicit and explicit TPGS =
[ =20
> 655.279503] TARGET_CORE[iSCSI]: Expected Transfer Length: 264 does no=
t=20
> match SCSI CDB Length: 8 for SAM Opcode: 0x12 [  655.279533] sd=20
> 7:0:0:0: alua: No target port descriptors found [  655.279535] sd=20
> 7:0:0:0: alua: Attach failed (-22) [  655.279587] sd 7:0:0:0: [sdc]=20
> 115343360 512-byte logical blocks: (59.0 GB/55.0 GiB) [  655.279848]=20
> sd 7:0:0:0: [sdc] Write Protect is off [  655.279849] sd 7:0:0:0:=20
> [sdc] Mode Sense: 43 00 10 08 [  655.279981] sd 7:0:0:0: [sdc] Write=20
> cache: enabled, read cache: enabled, supports DPO and FUA [  655.2800=
34] iSCSI/iqn.1994-05.com.redhat:cf7f1fafca4b: Unsupported SCSI Opcode =
0xa3, sending CHECK_CONDITION.
> [  655.280171] sd 7:0:0:0: failed to add device handler: -22 [ =20
> 655.286008] sd 7:0:0:0: [sdc] Attached SCSI disk [  655.286132] sd=20
> 7:0:0:0: [sdc] Synchronizing SCSI cache
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
>=20
> -----Original Message-----
> From: Mike Christie [mailto:michaelc@cs.wisc.edu]
> Sent: Friday, January 29, 2016 2:27 PM
> To: Serguei Bezverkhi (sbezverk) <sbezverk@cisco.com>
> Cc: bugzilla-daemon@bugzilla.kernel.org; linux-scsi@vger.kernel.org
> Subject: Re: [Bug 111441] New: iscsi fails to attach to targets
>=20
>=20
>=20
> On 01/29/2016 01:11 PM, Serguei Bezverkhi (sbezverk) wrote:
>> If you send me the diff for your patch, I will build new kernel myse=
lf.
>>
>=20
> Bugzilla must be messing something up. I attached to one of the previ=
ous mails. Attaching it here again.
>=20
> Email me offlist and without bugzilla if you do not get it here.
>=20
> The patch will fix the syfs bug ons you are hitting.
>=20
> I am not sure if it will fix the genhd one. We can deal with that one=
 next if it is a different issue.
>=20
>=20
>> Serguei
>>
>>
>> Serguei Bezverkhi,
>> TECHNICAL LEADER.SERVICES
>> Global SP Services
>> sbezverk@cisco.com
>> Phone: +1 416 306 7312
>> Mobile: +1 514 234 7374
>>
>> CCIE (R&S,SP,Sec) - #9527
>>
>> Cisco.com
>>
>>
>>
>>  Think before you print.
>> This email may contain confidential and privileged material for the =
sole use of the intended recipient. Any review, use, distribution or di=
sclosure by others is strictly prohibited. If you are not the intended =
recipient (or authorized to receive for the recipient), please contact =
the sender by reply email and delete all copies of this message.
>> Please click here for Company Registration Information.
>>
>>
>>
>>
>> -----Original Message-----
>> From: Michael Christie [mailto:michaelc@cs.wisc.edu]
>> Sent: Friday, January 29, 2016 2:09 PM
>> To: Serguei Bezverkhi (sbezverk) <sbezverk@cisco.com>
>> Cc: bugzilla-daemon@bugzilla.kernel.org; linux-scsi@vger.kernel.org
>> Subject: Re: [Bug 111441] New: iscsi fails to attach to targets
>>
>>
>>> On Jan 29, 2016, at 6:04 AM, Serguei Bezverkhi (sbezverk) <sbezverk=
@cisco.com> wrote:
>>>
>>> Actually this server uses both cases: Local taregts (since it is Op=
enStack server) and remote targets as it tries to mount 4 remotefile sy=
stems. =20
>>>
>>> You are correct, I always use the same box I just change the kernel=
 it is using to boot. No other changes to the environment. I do not min=
d to load a test kernel without that suspected patch, just get me the R=
PM.
>>>
>>
>> I do not know what you mean. I think the patch I sent will fix the s=
ysfs errors caused due to alua not being setup properly on your system =
and scsi_dh_alua failing to attach. That patch should be applied to the=
 4.4 upstream kernel. Are you saying you want me to make you a kernel r=
pm?
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi=
"=20
>> in the body of a message to majordomo@vger.kernel.org More majordomo=
=20
>> info at  http://vger.kernel.org/majordomo-info.html
>>
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
=20
> in the body of a message to majordomo@vger.kernel.org More majordomo=20
> info at  http://vger.kernel.org/majordomo-info.html
>

--=20
You are receiving this mail because:
You are the assignee for the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
