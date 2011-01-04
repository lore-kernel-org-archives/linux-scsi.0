From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: target: problems with Persistent reservations, iscsi
Date: Tue, 04 Jan 2011 15:43:45 -0800
Message-ID: <1294184625.29002.29.camel@haakon2.linux-iscsi.org>
References: <a17263ef-dd96-468e-ad85-0f987cdacb4f@j25g2000yqa.googlegroups.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:39722 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab1ADXto (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Jan 2011 18:49:44 -0500
In-Reply-To: <a17263ef-dd96-468e-ad85-0f987cdacb4f@j25g2000yqa.googlegroups.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-iscsi-target-dev@googlegroups.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>, gfaraway@gmail.com

On Sun, 2011-01-02 at 17:32 -0800, gustavo panizzo wrote:
> hello,
>     i'm trying to use lio (as iscsi target) in a veritas cluster
> environment (for
> training proposes).
> 

Hi Gustavo,

Thanks for your bug report and my apologies for the holiday delay.  My
comments are included below.

> my setup looks like
> 
> 2 machines (cluster1, cluster2) running red hat 5.5 up to date, amd64,
> running veritas
> cluster software version 5.0.40.00-MP4 (SFHA, SF)
> 1 machine running debian squeeze, up to date. running lio-utils
> version 3.2, kernel 2.6.37-rc7+, x86
> 
> when i run a veritas test for the storage (vxfentsthdw) it fails on
> 
> [snip]
> Preempt and abort key KeyA using key KeyB on node
> cluster2 ............. Passed
> Test to see if I/O on node cluster1
> terminated ......................... Passed
> RegisterIgnoreKeys on disk /dev/sdf from node
> cluster1 ................. Failed
> 
> one of the initiators (cluster1) issue a timeout, the other initiators
> works fine
> 

First lets verify that the PROUT Register into target_core_pr.c:
core_scsi3_emulate_pro_register() w/ ignore_key=1 is the SCSI packet
that is actually triggering the OOPs.  Please send along a wireshark
capture from the LIO target side and provide a brief layout of which IP
addresses correspond to which nodes, etc.

> [snip]
> connection1:0: ping timeout of 5 secs expired, recv timeout 5, last rx
> 4295=
> 373064, last ping 4295378064, now 4295383064
>  connection1:0: detected conn error (1011)
>  session1: session recovery timed out after 120 secs
> sd 1:0:0:0: SCSI error: return code =3D 0x000f0000
> end_request: I/O error, dev sdf, sector 65792
> 
> 
> the target machine issue an oops (non-fatal)
> 

For future reference, please include the PR related dmesg output before
the actual OOPsen to make debugging easier.  ;)

> [  152.435618] Oops: 0000 [#1] SMP20
> [  152.435803] last sysfs file: /sys/module/target_core_mod/initstate
> [  152.436649] Modules linked in: crc32c iscsi_target_mod
> target_core_stgt scsi_tgt target_core_pscsi target_core_file
> target_core_iblock target_core_mod configfs ext2 loop snd_pcm
> snd_timer snd tpm_tis soundcore parport_pc psmouse tpm i2c_piix4
> tpm_bios processor snd_page_alloc shpchp pcspkr serio_raw evdev
> i2c_core parport pci_hotplug thermal_sys ac container button ext3
>  jbd mbcache dm_mod sd_mod ide_cd_mod crc_t10dif cdrom ata_generic
> ata_piix
>  libata mptspi mptscsih mptbase scsi_transport_spi piix scsi_mod
> ide_core floppy pcnet32 mii [last unloaded: scsi_wait_scan]
> [  152.436880]=20
> [  152.436880] Pid: 1018, comm: iscsi_trx/3 Not tainted 2.6.37-rc7+ #1
> 440BX Desktop Reference Platform/VMware Virtual Platform
> [  152.436880] EIP: 0060:[<e112878c>] EFLAGS: 00010202 CPU: 0
> [  152.436880] EIP is at core_scsi3_ua_for_check_condition+0x129/0x190
> [target_core_mod]
> [  152.436880] EAX: 00000000 EBX: d78c4dc0 ECX: dd650003 EDX: dd7aa000
> [  152.436880] ESI: 0000002a EDI: de7c8c80 EBP: dd783f26 ESP: dd783ef0
> [  152.436880]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> [  152.436880] Process iscsi_trx/3 (pid: 1018, ti=3Ddd782000
> task=3Ddf2f0820 task.ti=3Ddd782000)
> [  152.436880] Stack:
> [  152.436880]  df2f38e0 df406180 dd650050 dd650003 dd783f27 dd7aa000
> dd650060 d78c4f80
> [  152.436880]  00000002 d78c4dc0 0000000e e11228a7 00024c00 2a03320b
> dd7fe000 d78c4c00
> [  152.436880]  00001412 dd783f90 e11db0dc d78c4c00 00000001 d78c4dc0
> e11e10fb dd783f4c
> [  152.436880] Call Trace:
> [  152.436880]  [<e11228a7>] ? transport_send_check_condition_and_sense
> +0x175/0x1d4 [target_core_mod]
> [  152.436880]  [<e11db0dc>] ? iscsi_check_received_cmdsn+0x6b/0x164
> [iscsi_target_mod]
> [  152.436880]  [<e11e10fb>] ? iscsi_target_rx_thread+0x72e/0xdeb
> [iscsi_target_mod]
> [  152.436880]  [<e11e09cd>] ? iscsi_target_rx_thread+0x0/0xdeb
> [iscsi_target_mod]
> [  152.436880]  [<c100353e>] ? kernel_thread_helper+0x6/0x10
> [  152.436880] Code: 4c 24 18 75 88 fe 46 50 fe 87 1c 01 00 00 fb 66
> 66 90 66 90 8a 4d 00 8b 44 24 10 8b 54 24 14 88 4c 24 0c 0f b6 30 8b
> 43 7c 8b 00 <8a> 00 88 44 24 08 8b 82 f4 01 00 00 8b 6b 34 bb 94 3b 13
> e1 8b
> [  152.436880] EIP: [<e112878c>] core_scsi3_ua_for_check_condition
> +0x129/0x190 [target_core_mod] SS:ESP 0068:dd783ef0

So this codepath from 

	transport_send_check_condition_and_sense() ->  
               core_scsi3_ua_for_check_condition()

is only called during the CHECK_CONDITION exception path, which would
seem to indicate from the above that the Veritas cluster code is hitting
an exception in Register w/ Ignore keys and then trigger a NULL pointer
dereference.

So that said, please send along a wireshark capture and PR dmesg output
and I will have a look.

Best Regards,

--nab

