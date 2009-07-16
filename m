From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13311] mptsas: ioc0: removing ssp device, kernel oops
Date: Thu, 16 Jul 2009 21:41:41 GMT
Message-ID: <200907162141.n6GLffJH007212@demeter.kernel.org>
References: <bug-13311-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:42350 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932917AbZGPVll convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jul 2009 17:41:41 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n6GLffAf007213
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2009 21:41:41 GMT
In-Reply-To: <bug-13311-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=3D13311





--- Comment #6 from Mike Loseke <mike.tummy@gmail.com>  2009-07-16 21:4=
1:39 ---
Sorry for the delay in getting back on this.

On this system, the IO errors may not be completely unexpected.  The
disk is being made available via a Promise RAID and a few times now
we've had both controllers reset which seems to cause these kernel
Oops' in some cases (sometimes, not always, and not on two hosts
connected to the Promise like this during the same reset event).
We're actively working with Promise on the controller reset issue.

I do have some more dmesg/log output for another Oops that happened
today - what's the best way to present that information here?

Mike


On Tue, Jun 9, 2009 at 3:53 PM, <bugzilla-daemon@bugzilla.kernel.org> w=
rote:
> http://bugzilla.kernel.org/show_bug.cgi?id=3D13311
>
>
>
>
>
> --- Comment #5 from Andrew Morton <akpm@linux-foundation.org> =C2=A02=
009-06-09 21:53:09 ---
> On Tue, 9 Jun 2009 15:27:05 -0600
> Mike Loseke <mike.tummy@gmail.com> wrote:
>
>> On Thu, May 28, 2009 at 2:00 AM, Andrew Morton
>> <akpm@linux-foundation.org> wrote:
>> >
>> > (switched to email. __Please respond via emailed reply-to-all, not=
 via the
>> > bugzilla web interface).
>> >
>> > On Thu, 14 May 2009 18:17:10 GMT bugzilla-daemon@bugzilla.kernel.o=
rg wrote:
>> >
>> > > http://bugzilla.kernel.org/show_bug.cgi?id=3D13311
>> > >
>> > > __ __ __ __ __ __Summary: mptsas: ioc0: removing ssp device, ker=
nel oops
>> >
>> > I'd have thought that the severity of this problem is not matched =
by
>> > the response.
>> >
>> > > __ __ __ __ __ __Product: SCSI Drivers
>> > > __ __ __ __ __ __Version: 2.5
>> > > __ __ Kernel Version: 2.6.27.21
>> >
>> > Is it reproducible? __If so, is there any change that it can be re=
tested
>> > under a 2.6.29-based kernel?
>>
>> We've put a 2.6.29 kernel on these two systems and experienced anoth=
er
>> kernel oops yesterday. =C2=A0So far, we haven't been able to reprodu=
ce it
>> on demand, but it has occurred under a heavier system load each time
>> (load average of 16 with 2,000 blocks/sec every 5 seconds writes to
>> the devices attached using the mptsas driver.
>>
>> The oops from yesterday isn't identical to the previous oops, but th=
e
>> end result is the same where the system has to be rebooted. =C2=A0I'=
ve
>> attached that the log capture of the oops.
>>
>> The system is identical to the original specs, just the kernel has c=
hanged:
>>
>> # cat /proc/version
>> Linux version 2.6.29.4-0.1-default (root@tile01-primary) (gcc versio=
n
>> 4.3.2 [gcc-4_3-branch revision 141291] (SUSE Linux) ) #1 SMP Tue May
>> 26 22:50:58 CDT 2009
>>
>> Hopefully this is helpful.
>>
>
> So we have two issues here. =C2=A0One is the IO errors - are they une=
xpected?
>
> The other of course is that mptscsih_bus_reset() oopsed when trying t=
o
> handle those errors.
>
>
>> Jun =C2=A08 17:06:10 tile01-secondary kernel: mptbase: ioc0: LogInfo=
(0x31140000): Originator=3D{PL}, Code=3D{IO Executed}, SubCode(0x0000)
>> Jun =C2=A08 17:06:10 tile01-secondary kernel: sd 2:0:0:0: [sda] Unha=
ndled error code
>> Jun =C2=A08 17:06:10 tile01-secondary kernel: sd 2:0:0:0: [sda] Resu=
lt: hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK,SUGGEST_OK
>> Jun =C2=A08 17:06:10 tile01-secondary kernel: end_request: I/O error=
, dev sda, sector 207
>> Jun =C2=A08 17:06:10 tile01-secondary kernel: device-mapper: multipa=
th: Failing path 8:0.
>> Jun =C2=A08 17:06:10 tile01-secondary kernel: mptbase: ioc0: LogInfo=
(0x31140000): Originator=3D{PL}, Code=3D{IO Executed}, SubCode(0x0000)
>> Jun =C2=A08 17:06:10 tile01-secondary kernel: sd 2:0:0:0: [sda] Unha=
ndled error code
>> Jun =C2=A08 17:06:10 tile01-secondary kernel: sd 2:0:0:0: [sda] Resu=
lt: hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK,SUGGEST_OK
>> Jun =C2=A08 17:06:10 tile01-secondary kernel: end_request: I/O error=
, dev sda, sector 65679
>> Jun =C2=A08 17:06:10 tile01-secondary kernel: mptbase: ioc0: LogInfo=
(0x31140000): Originator=3D{PL}, Code=3D{IO Executed}, SubCode(0x0000)
>> Jun =C2=A08 17:06:10 tile01-secondary kernel: mptbase: ioc0: LogInfo=
(0x31140000): Originator=3D{PL}, Code=3D{IO Executed}, SubCode(0x0000)
>> Jun =C2=A08 17:06:10 tile01-secondary kernel: mptbase: ioc0: LogInfo=
(0x31140000): Originator=3D{PL}, Code=3D{IO Executed}, SubCode(0x0000)
>> Jun =C2=A08 17:06:10 tile01-secondary kernel: mptbase: ioc0: LogInfo=
(0x31140000): Originator=3D{PL}, Code=3D{IO Executed}, SubCode(0x0000)
>> Jun =C2=A08 17:06:10 tile01-secondary kernel: mptbase: ioc0: LogInfo=
(0x31140000): Originator=3D{PL}, Code=3D{IO Executed}, SubCode(0x0000)
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: mptscsih: ioc0: attemp=
ting task abort! (sc=3Dffff88021e08e880)
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: scsi 2:0:0:0: [sda] CD=
B: Write(10): 2a 00 00 00 f0 87 00 04 00 00
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: mptscsih: ioc0: task a=
bort: SUCCESS (sc=3Dffff88021e08e880)
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: mptscsih: ioc0: attemp=
ting task abort! (sc=3Dffff880106684dc0)
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: scsi 2:0:0:0: [sda] CD=
B: Write(10): 2a 00 00 00 f4 87 00 04 00 00
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: mptscsih: ioc0: task a=
bort: SUCCESS (sc=3Dffff880106684dc0)
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: mptscsih: ioc0: attemp=
ting task abort! (sc=3Dffff8803b0a131c0)
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: scsi 2:0:0:0: [sda] CD=
B: Write(10): 2a 00 00 00 f8 87 00 04 00 00
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: mptscsih: ioc0: task a=
bort: SUCCESS (sc=3Dffff8803b0a131c0)
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: mptscsih: ioc0: attemp=
ting task abort! (sc=3Dffff8803b0a13ec0)
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: scsi 2:0:0:0: [sda] CD=
B: Write(10): 2a 00 00 00 fc 87 00 00 08 00
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: mptscsih: ioc0: task a=
bort: SUCCESS (sc=3Dffff8803b0a13ec0)
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: mptscsih: ioc0: attemp=
ting task abort! (sc=3Dffff8803b0a13cc0)
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: scsi 2:0:0:0: [sda] CD=
B: Write(10): 2a 00 00 00 fc 8f 00 04 00 00
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: mptscsih: ioc0: task a=
bort: SUCCESS (sc=3Dffff8803b0a13cc0)
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: mptscsih: ioc0: attemp=
ting bus reset! (sc=3Dffff88021e08e880)
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: scsi 2:0:0:0: [sda] CD=
B: Write(10): 2a 00 00 00 f0 87 00 04 00 00
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: BUG: unable to handle =
kernel NULL pointer dereference at (null)
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: IP: [<ffffffffa008cc98=
>] mptscsih_bus_reset+0x97/0xfa [mptscsih]
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: PGD 82944c067 PUD 82e4=
e9067 PMD 0
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: Oops: 0000 [#1] SMP
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: last sysfs file: /sys/=
kernel/uevent_seqnum
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: CPU 1
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: Modules linked in: rei=
serfs dm_round_robin ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 xt_sta=
te nf_conntrack xt_tcpudp iptable_filter dm_multipath scsi_dh ip_tables=
 iscsi_trgt crc32c x_tables 8021q garp stp bonding ipv6 cpufreq_conserv=
ative cpufreq_userspace cpufreq_powersave powernow_k8 ext3 jbd mbcache =
loop dm_mod qla4xxx scsi_transport_iscsi qla3xxx rtc_cmos i2c_nforce2 r=
tc_core rtc_lib shpchp forcedeth pcspkr joydev serio_raw mptctl pci_hot=
plug i2c_core button sr_mod sg cdrom usbhid hid ohci_hcd ehci_hcd sd_mo=
d crc_t10dif usbcore edd xfs exportfs fan 3w_9xxx ide_pci_generic amd74=
xx ide_core ata_generic thermal processor thermal_sys hwmon sata_nv mpt=
sas mptscsih mptbase scsi_transport_sas pata_amd libata scsi_mod
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: Pid: 175, comm: scsi_e=
h_2 Not tainted 2.6.29.4-0.1-default #1 H8DM3-2
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: RIP: 0010:[<ffffffffa0=
08cc98>] =C2=A0[<ffffffffa008cc98>] mptscsih_bus_reset+0x97/0xfa [mptsc=
sih]
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: RSP: 0018:ffff88083354=
ddb0 =C2=A0EFLAGS: 00010203
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: RAX: ffff8804359cb002 =
RBX: ffff88043368a560 RCX: ffff88021e08e880
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: RDX: 0000000000000000 =
RSI: 0000000000000004 RDI: ffff88043368a560
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: RBP: ffff88083354dde0 =
R08: 0000000000000002 R09: 0000000000000000
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: R10: ffffffff80d7e600 =
R11: 0000000000000010 R12: ffff88021e08e880
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: R13: ffff8804335a3000 =
R14: ffff8804335a3008 R15: ffff88083354dee0
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: FS: =C2=A000007f66c712=
2740(0000) GS:ffff88043596edc0(0000) knlGS:0000000000000000
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: CS: =C2=A00010 DS: 001=
8 ES: 0018 CR0: 000000008005003b
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: CR2: 0000000000000000 =
CR3: 000000082d955000 CR4: 00000000000006e0
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: DR0: 0000000000000000 =
DR1: 0000000000000000 DR2: 0000000000000000
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: DR3: 0000000000000000 =
DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: Process scsi_eh_2 (pid=
: 175, threadinfo ffff88083354c000, task ffff8808331082c0)
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: Stack:
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: =C2=A0ffff8804337b4810=
 0000000000000000 ffff88021e08e880 0000000000002003
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: =C2=A0ffff8804359cb000=
 0000000000000000 ffff88083354de00 ffffffffa00034ee
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: =C2=A0ffff88021e08e880=
 0000000000000000 ffff88083354de60 ffffffffa000441f
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: Call Trace:
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: =C2=A0[<ffffffffa00034=
ee>] scsi_try_bus_reset+0x52/0xde [scsi_mod]
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: =C2=A0[<ffffffffa00044=
1f>] scsi_eh_ready_devs+0x4c3/0x737 [scsi_mod]
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: =C2=A0[<ffffffffa0004b=
fe>] scsi_error_handler+0x37d/0x51b [scsi_mod]
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: =C2=A0[<ffffffff8022f2=
ea>] ? __wake_up_common+0x46/0x76
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: =C2=A0[<ffffffffa00048=
81>] ? scsi_error_handler+0x0/0x51b [scsi_mod]
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: =C2=A0[<ffffffff802519=
52>] kthread+0x49/0x76
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: =C2=A0[<ffffffff8020d0=
3a>] child_rip+0xa/0x20
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: =C2=A0[<ffffffff802519=
09>] ? kthread+0x0/0x76
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: =C2=A0[<ffffffff8020d0=
30>] ? child_rip+0x0/0x20
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: Code: 00 48 83 f8 ff 7=
4 0a 48 ff c0 48 89 83 b0 00 00 00 49 8b 04 24 48 89 df be 04 00 00 00 =
48 8b 90 88 00 00 00 41 8a 85 98 00 00 00 <48> 8b 12 3c 01 19 c0 45 31 =
c9 45 31 c0 83 e0 1e 31 c9 0f b6 52
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: RIP =C2=A0[<ffffffffa0=
08cc98>] mptscsih_bus_reset+0x97/0xfa [mptscsih]
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: =C2=A0RSP <ffff8808335=
4ddb0>
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: CR2: 0000000000000000
>> Jun =C2=A08 17:06:11 tile01-secondary kernel: ---[ end trace 54f83dc=
c0f7b0b26 ]---
>>
>>
>
> --
> Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=3Dema=
il
> ------- You are receiving this mail because: -------
> You reported the bug.
>

--=20
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=3Demail
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
