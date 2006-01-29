From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [Bugme-new] [Bug 5974] New: if usb-storage atached - ps/2
 keyboard not working
Date: Sun, 29 Jan 2006 00:40:21 -0800
Message-ID: <20060129004021.1885e300.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:24040 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1750717AbWA2Iko (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Jan 2006 03:40:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-usb-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
Cc: "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>


usb-storage oopsed.  That killed keventd and the keyboard needs keventd
services.

Is this a scsi bug or a USB bug?

Begin forwarded message:

Date: Sun, 29 Jan 2006 00:28:36 -0800
From: bugme-daemon@bugzilla.kernel.org
To: bugme-new@lists.osdl.org
Subject: [Bugme-new] [Bug 5974] New: if usb-storage atached - ps/2 keyboard not working


http://bugzilla.kernel.org/show_bug.cgi?id=5974

           Summary: if usb-storage atached - ps/2 keyboard not working
    Kernel Version: 2.6.16-rc1-mm3
            Status: NEW
          Severity: high
             Owner: greg@kroah.com
         Submitter: bug-track@fisher-privat.net


Most recent kernel where this bug did not occur: 2.6.16-rc1 - 2.6.16-rc1-mm3
Distribution: ubuntu breezy x86-64
Problem Description:
it dasn't metter what kind of usb-storage but if it's attached in about 2 second
keyboard is dead. Other devices continuing to working.

[  339.051428] SCSI device sdb: 32000 512-byte hdwr sectors (16 MB)
[  339.056437] sdb: Write Protect is off
[  339.056442] sdb: Mode Sense: 0b 00 00 08
[  339.056445] sdb: assuming drive cache: write through
[  339.056454]  sdb: sdb1
[  339.091468] sd 2:0:0:0: Attached scsi removable disk sdb
[  339.092062] general protection fault: 0000 [1] 
[  339.092069] last sysfs file: /class/usb_device/usbdev3.3/dev
[  339.092072] CPU 0 
[  339.092074] Modules linked in: usb_storage binfmt_misc i915 fan container
af_packet piix snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm
snd_timer snd snd_page_alloc nls_cp437 vfat fat nls_utf8 ntfs unix
[  339.092089] Pid: 4, comm: events/0 Not tainted 2.6.16-rc1-mm3 #3
[  339.092093] RIP: 0010:[<ffffffff8024fe11>] <ffffffff8024fe11>{device_del+58}
[  339.092104] RSP: 0000:ffff810001ff9e28  EFLAGS: 00010202
[  339.092109] RAX: 001c200000000004 RBX: ffff81003c218028 RCX: ffffffff803178f9
[  339.092113] RDX: ffff81002be25e78 RSI: ffffffff801d1619 RDI: ffff81003c218028
[  339.092117] RBP: ffff81002be43178 R08: ffff81002be87fc0 R09: 0000000000000000
[  339.092122] R10: ffff810001ff9d78 R11: ffff81003c218028 R12: ffff81002be87f40
[  339.092125] R13: 00000000fffffffc R14: 0000000000000000 R15: 0000000000000000
[  339.092129] FS:  0000000000000000(0000) GS:ffffffff804eb000(0000)
knlGS:0000000000000000
[  339.092133] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  339.092137] CR2: 00002ae6d371d980 CR3: 000000002bd23000 CR4: 00000000000006e0
[  339.092142] Process events/0 (pid: 4, threadinfo ffff810001ff8000, task
ffff810001fc0060)
[  339.092144] Stack: ffff81002cbec520 ffff81003c218028 ffff81002be43178
ffffffff8027d000 
[  339.092152]        ffffffff8027cf6f 0000000000000282 ffff810001f96440
ffffffff801331e3 
[  339.092158]        ffff810001fc3da8 ffffffff801331b6 
[  339.092162] Call Trace: <ffffffff8027d000>{scsi_target_reap_work+145}
[  339.092171]        <ffffffff8027cf6f>{scsi_target_reap_work+0}
<ffffffff801331e3>{worker_thread+0}
[  339.092182]        <ffffffff801331b6>{run_workqueue+126}
<ffffffff801332e8>{worker_thread+261}
[  339.092191]        <ffffffff80122373>{default_wake_function+0}
<ffffffff80122373>{default_wake_function+0}
[  339.092202]        <ffffffff80135bb6>{kthread+207}
<ffffffff8010b122>{child_rip+8}
[  339.092215]        <ffffffff80135ae7>{kthread+0} <ffffffff8010b11a>{child_rip+0}
[  339.092223] 
[  339.092224] Code: ff d0 48 89 df e8 a9 0d 00 00 48 89 df 48 81 c3 d0 00 00 00 
[  339.092235] RIP <ffffffff8024fe11>{device_del+58} RSP <ffff810001ff9e28>
[  339.092241]  <7>usb-storage: device scan complete


Step to reproduse:
1. Plug usb storage device.

------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
