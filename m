From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60758] module scsi_wait_scan not found kernel panic on boot
Date: Mon, 02 Sep 2013 14:48:57 +0000
Message-ID: <bug-60758-11613-dfxyohqrHk@https.bugzilla.kernel.org/>
References: <bug-60758-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:40583 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756533Ab3IBOtD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Sep 2013 10:49:03 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3615C2021E
	for <linux-scsi@vger.kernel.org>; Mon,  2 Sep 2013 14:49:01 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id C845B20334
	for <linux-scsi@vger.kernel.org>; Mon,  2 Sep 2013 14:48:57 +0000 (UTC)
In-Reply-To: <bug-60758-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60758

--- Comment #19 from zakrzewskim@wp.pl ---
1. All of them are separate. I just install kernel-ml via yum.

2. I can only show such log from kernel 3.10.4-1. I don't have KVM to see
what's going on. Since this is a production machine inside datacenter I can
only rent KVM for 2 hours.

3. I found another bug - server is freezing and load is getting higher than
100: 

BUG: unable to handle kernel paging request at 0000010600000032
IP: [<ffffffff811dcb85>] SyS_epoll_ctl+0x145/0x420
PGD 0
Oops: 0000 [#1] SMP
Modules linked in: nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack
xt_iprange iptable_filter ip_tables netconsole configfs nct6775 hwmon_vid ipv6
cpufreq_ondemand ppdev iTCO_wdt iTCO_vendor_support shpchp coretemp hwmon
acpi_cpufreq freq_table mperf kvm_intel kvm crc32_pclmul crc32c_intel
ghash_clmulni_intel aesni_intel ablk_helper cryptd lrw gf128mul glue_helper
aes_x86_64 microcode pcspkr i2c_i801 parport_pc parport r8169 mii sg lpc_ich
xhci_hcd snd_hda_codec_hdmi snd_hda_intel snd_hda_codec snd_hwdep snd_seq
snd_seq_device snd_pcm snd_timer snd soundcore snd_page_alloc ext4 jbd2 mbcache
raid1 sd_mod crc_t10dif mxm_wmi video ahci libahci wmi dm_mirror dm_region_hash
dm_log dm_mod
CPU: 0 PID: 3133 Comm: nginx Not tainted 3.10.4-1.el6.elrepo.x86_64 #1
Hardware name: MSI MS-7816/H87-G43 (MS-7816), BIOS V2.3 06/07/2013
task: ffff8807f18c0ac0 ti: ffff880753374000 task.ti: ffff880753374000
RIP: 0010:[<ffffffff811dcb85>]  [<ffffffff811dcb85>] SyS_epoll_ctl+0x145/0x420
RSP: 0018:ffff880753375f18  EFLAGS: 00010202
RAX: 0000010600000002 RBX: ffff8807f23125c0 RCX: 0000000000000001
RDX: 0000000000000000 RSI: ffff880650213bc0 RDI: ffff88076704b808
RBP: ffff880753375f78 R08: 0000000000000002 R09: 0101010101010101
R10: 00007fff52ea2220 R11: 0000000000000202 R12: ffff880773f15c80
R13: 0000000000000001 R14: 0000000000000045 R15: ffff88076704b800
FS:  00007f8451c707c0(0000) GS:ffff88081ea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000010600000032 CR3: 0000000771b3b000 CR4: 00000000001407f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Stack:
 ffff8807f445c648 0000000152ea22b0 ffff88076704b808 fffffff7810dfe46
 11b8144080000001 ffff880700000000 0000000001838b20 0000000000000001
 0000000011b81440 0000000011bd9288 0000000011b6f8c0 00007fff52ea22b0
Call Trace:
 [<ffffffff815fd319>] system_call_fastpath+0x16/0x1b
Code: 00 00 c7 45 ac 00 00 00 00 83 f8 01 0f 86 4d 01 00 00 49 8d 47 08 48 89
c7 48 89 45 b0 e8 44 4c 41 00 49 8b 47 70 48 85 c0 74 1f <48> 3b 58 30 48 89 c6
77 0d 72 68 44 89 f2 2b 50 38 83 fa 00 7e
RIP  [<ffffffff811dcb85>] SyS_epoll_ctl+0x145/0x420
 RSP <ffff880753375f18>
CR2: 0000010600000032
---[ end trace 3c47cb214b7f3743 ]---

-- 
You are receiving this mail because:
You are the assignee for the bug.
