From: James Smart <james.smart@emulex.com>
Subject: Re: [Bug 96921] New: NULL pointer dereference in lpfc_bus_reset_handler+0xd4/0x240
Date: Mon, 20 Apr 2015 10:54:45 -0400
Message-ID: <55351335.8040801@emulex.com>
References: <bug-96921-11613@https.bugzilla.kernel.org/>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.emulex.com ([138.239.224.100]:31605 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbbDTOzM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Apr 2015 10:55:12 -0400
In-Reply-To: <bug-96921-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

This is a rather old kernel, thus old driver. Lots of changes since the 
driver was put out in 3.11.
I recommend pulling down the source kits for RHEL7 (3.10 kernel):
http://www.emulex.com/downloads/emulex/drivers/linux/rhel-7-centos-7/drivers/
   Under FC/FCoE driver and install script - Source Driver Kit link

-- james s


On 4/20/2015 5:11 AM, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=96921
>
>              Bug ID: 96921
>             Summary: NULL pointer dereference in
>                      lpfc_bus_reset_handler+0xd4/0x240
>             Product: SCSI Drivers
>             Version: 2.5
>      Kernel Version: 3.11.10
>            Hardware: x86-64
>                  OS: Linux
>                Tree: Mainline
>              Status: NEW
>            Severity: high
>            Priority: P1
>           Component: Other
>            Assignee: scsi_drivers-other@kernel-bugs.osdl.org
>            Reporter: joachim.reichelt@helmholtz-hzi.de
>          Regression: No
>
> Server crashed. In messages.log I see:
>
> 2015-04-18T20:05:01.272964+02:00 nero /USR/SBIN/CRON[81116]:
> pam_unix(crond:session): session closed for user root
> 2015-04-18T20:05:07.198234+02:00 nero kernel: [1593664.788553] ch 8:0:5:2:
> timing out command, waited 120s
> 2015-04-18T20:05:14.296080+02:00 nero kernel: [1593671.881327] lpfc
> 0000:42:00.0: 2:(0):0713 SCSI layer issued Device Reset (8, 0) return x2002
> 2015-04-18T20:05:18.261089+02:00 nero kernel: [1593675.843025] lpfc
> 0000:42:00.0: 2:(0):0723 SCSI layer issued Target Reset (8, 0) return x2002
> 2015-04-18T20:05:18.310629+02:00 nero kernel: [1593675.845342] BUG: unable to
> handle kernel NULL pointer dereference at 000000000000003e
> 2015-04-18T20:05:18.310646+02:00 nero kernel: [1593675.845731] IP:
> [<ffffffffa006a624>] lpfc_bus_reset_handler+0xd4/0x240 [lpfc]
> 2015-04-18T20:05:18.310648+02:00 nero kernel: [1593675.846029] PGD 0
> 2015-04-18T20:05:18.310650+02:00 nero kernel: [1593675.846184] Oops: 0000 [#1]
> PREEMPT SMP
> 2015-04-18T20:05:18.310653+02:00 nero kernel: [1593675.846558] Modules linked
> in: efs loop binfmt_misc arc4 ecb md4 nls_utf8 cifs md5 nfsd nfs_acl
> auth_rpcgss oid_registry nfs fscache lockd sunrpc af_packet dcdbas iTCO_wdt
> gpio_ich iTCO_vendor_support xfs x86_pkg_temp_thermal intel_powerclamp coretemp
> kvm_intel kvm crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel
> ablk_helper cryptd lrw gf128mul glue_helper aes_x86_64 pcspkr osst joydev
> nls_iso8859_1 nls_cp437 vfat fat ch st sb_edac edac_core lpc_ich mfd_core
> mei_me mei ntb bnx2x libcrc32c mdio shpchp wmi acpi_power_meter button mperf sg
> dm_mod autofs4 efivarfs mgag200 ttm drm_kms_helper drm i2c_algo_bit sysimgblt
> sysfillrect syscopyarea megaraid_sas processor thermal_sys scsi_dh_hp_sw
> scsi_dh_emc scsi_dh_rdac scsi_dh_alua scsi_dh lpfc scsi_transport_fc scsi_tgt
> 2015-04-18T20:05:18.310655+02:00 nero kernel: [1593675.854837] CPU: 1 PID: 804
> Comm: scsi_eh_8 Not tainted 3.11.10-25-desktop #1
> 2015-04-18T20:05:18.310656+02:00 nero kernel: [1593675.854999] Hardware name:
> Dell Inc. PowerEdge R820/0YWR73, BIOS 2.0.20 01/16/2014
> 2015-04-18T20:05:18.310657+02:00 nero kernel: [1593675.855164] task:
> ffff883fa0edc580 ti: ffff883fa0ede000 task.ti: ffff883fa0ede000
> 2015-04-18T20:05:18.318691+02:00 nero kernel: [1593675.855323] RIP:
> 0010:[<ffffffffa006a624>]  [<ffffffffa006a624>]
> lpfc_bus_reset_handler+0xd4/0x240 [lpfc]
> 2015-04-18T20:05:18.318797+02:00 nero kernel: [1593675.855600] RSP:
> 0018:ffff883fa0edfd70  EFLAGS: 00010082
> 2015-04-18T20:05:18.318803+02:00 nero kernel: [1593675.855736] RAX:
> 0000000000000009 RBX: 0000000000000000 RCX: 00000000000075ed
> 2015-04-18T20:05:18.318804+02:00 nero kernel: [1593675.855891] RDX:
> 00000000000075ed RSI: 0000000000000282 RDI: ffff883fa31cb050
> 2015-04-18T20:05:18.318805+02:00 nero kernel: [1593675.856046] RBP:
> ffff883fa31cb708 R08: ffff883fa0ede000 R09: 0000000000000001
> 2015-04-18T20:05:18.318806+02:00 nero kernel: [1593675.856202] R10:
> 0000000000000001 R11: 0000000000000004 R12: 0000000000000005
> 2015-04-18T20:05:18.318807+02:00 nero kernel: [1593675.856359] R13:
> 0000000000002002 R14: ffff883fa31cb6d8 R15: ffff883fa31cb000
> 2015-04-18T20:05:18.318808+02:00 nero kernel: [1593675.856521] FS:
> 0000000000000000(0000) GS:ffff88403fa00000(0000) knlGS:0000000000000000
> 2015-04-18T20:05:18.318809+02:00 nero kernel: [1593675.856689] CS:  0010 DS:
> 0000 ES: 0000 CR0: 0000000080050033
> 2015-04-18T20:05:18.318810+02:00 nero kernel: [1593675.856830] CR2:
> 000000000000003e CR3: 0000000006c0e000 CR4: 00000000000407e0
> 2015-04-18T20:05:18.318812+02:00 nero kernel: [1593675.856994] Stack:
> 2015-04-18T20:05:18.318814+02:00 nero kernel: [1593675.857261]
> 0000020000000002 0000000000000020 a07d53fa90000010 a07d53fa90000020
> 2015-04-18T20:05:18.318816+02:00 nero kernel: [1593675.857690]
> 000000004d261684 ffff883fa31cb000 ffff8822d32818c0 ffffffffa00b1a00
> 2015-04-18T20:05:18.318817+02:00 nero kernel: [1593675.858125]
> ffff883fa0edca50 0000000000000000 ffff883fa0edfe78 ffffffff813d9a2a
> 2015-04-18T20:05:18.318818+02:00 nero kernel: [1593675.858542] Call Trace:
> 2015-04-18T20:05:18.318819+02:00 nero kernel: [1593675.858737]
> [<ffffffff813d9a2a>] scsi_try_bus_reset+0x3a/0x100
> 2015-04-18T20:05:18.318830+02:00 nero kernel: [1593675.858890]
> [<ffffffff813db2b1>] scsi_eh_ready_devs+0x4d1/0x8f0
> 2015-04-18T20:05:18.318833+02:00 nero kernel: [1593675.859040]
> [<ffffffff813dc5cd>] scsi_error_handler+0x53d/0x720
> 2015-04-18T20:05:18.318835+02:00 nero kernel: [1593675.859198]
> [<ffffffff81072c1f>] kthread+0xaf/0xc0
> 2015-04-18T20:05:18.318895+02:00 nero kernel: [1593675.859340]
> [<ffffffff815af3fc>] ret_from_fork+0x7c/0xb0
> 2015-04-18T20:05:18.318897+02:00 nero kernel: [1593675.859481] Code: 8b 7f 58
> e8 5f de 53 e1 49 8b 9f 08 07 00 00 48 39 dd 75 17 e9 56 01 00 00 66 0f 1f 44
> 00 00 48 8b 1b 48 39 dd 0f 84 44 01 00 00 <0f> b7 43 3e 83 e0 09 66 83 f8 01 75
> e7 49 8b 87 d8 06 00 00 8b
> 2015-04-18T20:05:18.318899+02:00 nero kernel: [1593675.865079] RIP
> [<ffffffffa006a624>] lpfc_bus_reset_handler+0xd4/0x240 [lpfc]
> 2015-04-18T20:05:18.323247+02:00 nero kernel: [1593675.865336]  RSP
> <ffff883fa0edfd70>
> 2015-04-18T20:05:18.323342+02:00 nero kernel: [1593675.865456] CR2:
> 000000000000003e
> 2015-04-18T20:05:18.323346+02:00 nero kernel: [1593675.889482] ---[ end trace
> ac970d32fddfb4ae ]---
> 2015-04-18T20:05:18.323348+02:00 nero kernel: [1593675.893079] note:
> scsi_eh_8[804] exited with preempt_count 1
>

