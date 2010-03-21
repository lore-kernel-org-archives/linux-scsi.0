From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14831] mptsas - Use of ATA command pass-through results in
 unreliable operation - drive / controller resets
Date: Sun, 21 Mar 2010 11:34:46 GMT
Message-ID: <201003211134.o2LBYk0S011035@demeter.kernel.org>
References: <bug-14831-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:40031 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab0CULeq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Mar 2010 07:34:46 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2LBYkbh011036
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sun, 21 Mar 2010 11:34:46 GMT
In-Reply-To: <bug-14831-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=14831


Brian Sullivan <bexamous@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |bexamous@gmail.com




--- Comment #11 from Brian Sullivan <bexamous@gmail.com>  2010-03-21 11:34:37 ---
I too am running into this bug.

Here is firmware rev of the onboard LSI controller I am using:
Port Name         Chip Vendor/Type/Rev    MPT Rev  Firmware Rev  IOC
/proc/mpt/ioc0    LSI Logic SAS1068E B2     105      01160000     0

I tried 2.6.32 kernel from Ubuntu 10.04 and then tried updating to 2.6.33 from
mainline.  I also then tried updating the mptsas driver to the latest off LSI's
site, v4.18.00.00.  Nothing seemed to improve issue.

Problem is, for me has been, reading smart info fast enough, or long enough,
eventually the command will fail.  It tries aborting task, bus reset, and then
host reset.  This takes some amount of time.

The pause is what I believe causes drives to sometimes drop off the controller.
 I am not sure what is to blame, but at least a work around is to go in the LSI
controller's BIOS and set all the timeout values to 0.  The default timeout
value seems to vary depending on which 1068E card you have and which firmware
is installed.  After setting all timeout values to 0, I still have problem with
ATA pass-through, but the drives no longer drop off the controller when I hit
the pass-through bug.

Also I have both WDC and Hitatchi drives.  Both behave the same.

BTW here is errors I get when running hddtemp, basically same as OP:
[156291.890023] mptscsih: ioc0: attempting task abort! (sc=ffff880369e51000)
[156291.890028] sd 7:0:12:0: [sdo] CDB: ATA command pass through(16): 85 08 2e
00 00 00 00 00 00 00 00 00 00 00 ec 00
[156293.532938] mptbase: ioc0: LogInfo(0x31140000): Originator={PL}, Code={IO
Executed}, SubCode(0x0000)
[156293.533080] mptscsih: ioc0: task abort: SUCCESS (sc=ffff880369e51000)
[156303.531268] mptscsih: ioc0: attempting task abort! (sc=ffff880369e51000)
[156303.531274] sd 7:0:12:0: [sdo] CDB: Test Unit Ready: 00 00 00 00 00 00
[156303.531283] mptscsih: ioc0: task abort: SUCCESS (sc=ffff880369e51000)
[156303.531299] mptscsih: ioc0: attempting target reset! (sc=ffff880369e51000)
[156303.531302] sd 7:0:12:0: [sdo] CDB: ATA command pass through(16): 85 08 2e
00 00 00 00 00 00 00 00 00 00 00 ec 00
[156305.050176] mptscsih: ioc0: target reset: FAILED (sc=ffff880369e51000)
[156305.050185] mptscsih: ioc0: attempting bus reset! (sc=ffff880369e51000)
[156305.050189] sd 7:0:12:0: [sdo] CDB: ATA command pass through(16): 85 08 2e
00 00 00 00 00 00 00 00 00 00 00 ec 00
[156309.553552] mptscsih: ioc0: bus reset: SUCCESS (sc=ffff880369e51000)
[156329.560014] mptscsih: ioc0: attempting task abort! (sc=ffff880369e51000)
[156329.560020] sd 7:0:12:0: [sdo] CDB: Test Unit Ready: 00 00 00 00 00 00
[156331.297762] mptbase: ioc0: LogInfo(0x31130000): Originator={PL}, Code={IO
Not Yet Executed}, SubCode(0x0000)
[156331.297903] mptscsih: ioc0: task abort: SUCCESS (sc=ffff880369e51000)
[156331.297907] mptscsih: ioc0: attempting host reset! (sc=ffff880369e51000)
[156342.470033] mptscsih: ioc0: host reset: SUCCESS (sc=ffff880369e51000)

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
