From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15503] insmod: error inserting '/lib/aic7xxx.ko': -1 Invalid
 modulkjournald starting
Date: Tue, 16 Mar 2010 17:58:09 GMT
Message-ID: <201003161758.o2GHw9PB022134@demeter.kernel.org>
References: <bug-15503-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:32858 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966173Ab0CPR6K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Mar 2010 13:58:10 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2GHw912022135
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 16 Mar 2010 17:58:09 GMT
In-Reply-To: <bug-15503-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15503





--- Comment #5 from Will L Givens <wlgivens@gmail.com>  2010-03-16 17:58:00 ---
In order to get around all the GPREL16 errors, I simply removed the offending
drives from the kernel and config'd them to be compile separately as modules.
Than after having to create a new init ram disk, I receive a slightly different
error in regards to the Adaptec (aic7xxx) driver:

usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
oprofile: using alpha/ev67 performance monitoring.
TCP cubic registered
rtc-test rtc-test.0: setting system clock to 2010-03-16 17:26:39 UTC
(1268760399)
Freeing unused kernel memory: 208k freed
Red Hat nash version 5.0.32 starting
Mounting proc filesystem
Mounting sysfs filesystem
Creating /dev
Creating initial device nodes
Setting up hotplug.
Creating block device nodes.
Loading aic7xxx.Unable to handle kernel paging request at virtual address
036b036903670360
ko module
insmod(375): Oops -1
pc = [<036b036903670360>]  ra = [<fffffffc0089c9d8>]  ps = 0000    Not
tainted
v0 = 0000000000000001  t0 = 0000000000000001  t1 = 00000000000003ff
t2 = 0000000000000000  t3 = 0000000000000000  t4 = fffffc007d9c7a20
t5 = fffffffc008acc70  t6 = 000000000000000f  t7 = fffffc007d9c4000
s0 = fffffffc008acc90  s1 = 000000000000036b  s2 = 000000000000036b
s3 = fffffc007d9c79f8  s4 = fffffc007d9c7a28  s5 = fffffc007da1bc00
s6 = fffffffc008ad930
a0 = fffffc007da1bc00  a1 = fffffc007d9c7a28  a2 = 000000000000036b
a3 = fffffc007d9c79f8  a4 = fffffc007d9c7b48  a5 = fffffffc0089b434
t8 = fffffc00009001d0  t9 = 0000000000000002  t10= 0000000000000000
t11= 0000000000000001  pv = 036b036903670361  at = 00000000ffffffff
gp = fffffffc008ad7e0  sp = fffffc007d9c78c8
Disabling lock debugging due to kernel taint
Trace:
[<fffffc0000539cec>]
[<fffffc0000520504>]
[<fffffc000059f264>]
[<fffffc0000539fac>]
[<fffffc000053a0d4>]
[<fffffc00005a3a48>]
[<fffffc00005a3cd4>]
[<fffffc00005a2070>]
[<fffffc00005a3c4c>]
[<fffffc00005a3d4c>]
[<fffffc00005a2b9c>]
[<fffffc00005a4568>]
[<fffffc00005a452c>]
[<fffffc0000539d94>]
[<fffffc00003100cc>]
[<fffffc0000351454>]
[<fffffc0000310bb4>]

Code:
Loading dm-log.ko module
Loading dm-region-hash.ko module
Loading dm-mirror.ko module
Loading dm-snapshot.ko module
Making device-mapper control node
Scanning logical volumes
  Reading all physical volumes.  This may take a while...
  No volume groups found
Activating logical volumes
  Unable to find volume group "VolGroup00"
Creating root device.
Mounting root filesystem.
mount: could not find filesystem '/dev/root'
Setting up other filesystems.
Setting up new root fs
setuproot: moving /dev failed: No such file or directory
no fstab.sys, mounting internal defaults
setuproot: error mounting /proc: No such file or directory
setuproot: error mounting /sys: No such file or directory
Switching to new root and running init.
unmounting old /dev
unmounting old /proc
unmounting old /sys
switchroot: mount failed: No such file or directory
Kernel panic - not syncing: Attempted to kill init!

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
