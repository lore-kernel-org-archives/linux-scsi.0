From: Elric Fu <elricfu1@gmail.com>
Subject: An oops will occur while SCSI core is being used in 3.4-rc1
Date: Tue, 10 Apr 2012 09:22:06 +0800
Message-ID: <CAAxnys5O7PfWYv0q+BvhK2CP7X-_pNRa4j-Z1gSWHqLm8D8XmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55985 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758281Ab2DJBWH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Apr 2012 21:22:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <JBottomley@Parallels.com>, linux-scsi@vger.kernel.org
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, Felipe Balbi <balbi@ti.com>, Alex He <alex.he@amd.com>, Andiry Xu <andiry.xu@amd.com>, Greg KH <gregkh@linuxfoundation.org>, Linux USB Mailing List <linux-usb@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>

Hi Martin/James,

when I tested the xhci driver in 3.4-rc1, I found an oops about SCSI
core. The issue is very random. It only happened while the device
was reset by mass storage driver due to some scsi commands failed
and re-enumerated in device initialization process. And even if the
mass storage device is reset, the issue doesn't always occur.

the dmesg log:
[   37.544629] EXT4-fs (sda2): re-mounted. Opts: errors=remount-ro,commit=0
[   38.982306] PM: Marking nosave pages: [mem 0x0009f000-0x000fffff]
[   38.982339] PM: Basic memory bitmaps created
[   38.982361] PM: Syncing filesystems ... done.
[   39.108977] Freezing user space processes ...
[   48.032541] usb 10-3: reset SuperSpeed USB device number 4 using xhci_hcd
[   48.048560] xhci_hcd 0000:01:00.0: xHCI xhci_drop_endpoint called
with disabled ep edf4e540
[   48.048648] xhci_hcd 0000:01:00.0: xHCI xhci_drop_endpoint called
with disabled ep edf4e56c
[   48.048916] BUG: unable to handle kernel NULL pointer dereference at 000001fc
[   48.048968] IP: [<c0449b0d>] scsi_send_eh_cmnd+0x2d/0x300
[   48.049005] *pde = 00000000
[   48.049027] Oops: 0000 [#1] SMP
[   48.049058] Modules linked in: snd_hda_codec ppdev parport_pc
snd_hwdep snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event
usb_storage snd_seq snd_timer snd_seq_device i915 psmouse snd lp
parport serio_raw soundcore snd_page_alloc xhci_hcd drm_kms_helper drm
coretemp intel_agp i2c_algo_bit intel_gtt video agpgart crc32c_intel
microcode ehci_hcd uhci_hcd r8169 mii usbcore usb_common
[   48.049381]
[   48.049394] Pid: 727, comm: scsi_eh_5 Not tainted 3.4.0-rc1+ #4
Gigabyte Technology Co., Ltd. H55M-S2/H55M-S2
[   48.049451] EIP: 0060:[<c0449b0d>] EFLAGS: 00010246 CPU: 1
[   48.049480] EIP is at scsi_send_eh_cmnd+0x2d/0x300
[   48.049504] EAX: 00000000 EBX: ec5fe0c0 ECX: 00000006 EDX: ed5a5ea0
[   48.049534] ESI: 00000001 EDI: ed5a5e90 EBP: ed5a5f00 ESP: ed5a5e74
[   48.049564]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   48.049590] CR0: 8005003b CR2: 000001fc CR3: 00904000 CR4: 000007d0
[   48.049620] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   48.049650] DR6: ffff0ff0 DR7: 00000400
[   48.049671] Process scsi_eh_5 (pid: 727, ti=ed5a4000 task=ed6b3200
task.ti=ed5a4000)
[   48.049707] Stack:
[   48.049720]  ed5a5e98 00000000 00000000 ed702da8 ed6b3200 00000006
c098b4e8 ed5a5e98
[   48.049791]  c05e32e3 ed5a5ef8 c05e17cd ed5a5ef4 f8185813 00000000
1cc5fb08 ecc141c0
[   48.049862]  00000000 ed5a5f48 c05e2c0b ed59c144 ed59c000 00000002
00000082 f184c02c
[   48.049934] Call Trace:
[   48.049952]  [<c05e32e3>] ? schedule+0x23/0x60
[   48.049976]  [<c05e17cd>] ? schedule_timeout+0x19d/0x260
[   48.050006]  [<f8185813>] ? xhci_urb_dequeue+0x153/0x2f0 [xhci_hcd]
[   48.050037]  [<c05e2c0b>] ? __schedule+0x3ab/0x790
[   48.050063]  [<c0449e8b>] scsi_eh_tur+0x3b/0xa0
[   48.050087]  [<c0449f54>] scsi_eh_test_devices+0x64/0x140
[   48.050115]  [<f8136901>] ? device_reset+0x31/0x50 [usb_storage]
[   48.050145]  [<c044ae98>] scsi_error_handler+0x458/0x610
[   48.050173]  [<c044aa40>] ? scsi_eh_get_sense+0x1d0/0x1d0
[   48.050202]  [<c015028c>] kthread+0x7c/0x90
[   48.050225]  [<c0150210>] ? kthread_freezable_should_stop+0x60/0x60
[   48.050257]  [<c05eaf7e>] kernel_thread_helper+0x6/0x10
[   48.050282] Code: e5 57 56 53 83 c4 80 3e 8d 74 26 00 89 c3 65 a1
14 00 00 00 89 45 f0 31 c0 8b 43 54 8d 7d 90 89 55 8c 8d 55 a0 89 4d
88 8b 40 68 <8b> 80 fc 01 00 00 8b 00 89 45 84 8b 03 8b 30 8d 45 98 89
45 98
[   48.050720] EIP: [<c0449b0d>] scsi_send_eh_cmnd+0x2d/0x300 SS:ESP
0068:ed5a5e74
[   48.050765] CR2: 00000000000001fc
[   48.050785] ---[ end trace 504ae2599be7a5ef ]---
[   59.107714]
[   59.107742] Freezing of tasks failed after 20.01 seconds (3 tasks
refusing to freeze, wq_busy=0):
[   59.107794] modprobe        D ecc041ed     0   525    367 0x00000004
[   59.107835]  ecc0dec4 00000082 f12e9690 ecc041ed c05e2360 f183f080
ed7e2580 c08f8280
[   59.107906]  c08f8280 c08f8280 af75e7cd 00000004 c08f8280 f6607280
ed7e2580 ec69a580
[   59.107977]  f823160c 00000000 ecc0de94 c01a99a6 f8230444 ecc0de98
c05e1da9 f8231c60
[   59.108048] Call Trace:
[   59.108065]  [<c05e2360>] ? down_write+0x10/0x30
[   59.108092]  [<c01a99a6>] ? get_tracepoint+0x16/0x180
[   59.108118]  [<c05e1da9>] ? mutex_lock+0x19/0x40
[   59.108145]  [<c01c303f>] ? trace_module_notify+0x2f/0x260
[   59.108173]  [<c05e1da9>] ? mutex_lock+0x19/0x40
[   59.108198]  [<c05e32e3>] schedule+0x23/0x60
[   59.108223]  [<c0156fed>] async_synchronize_cookie_domain+0xbd/0x150
[   59.108255]  [<c01506b0>] ? wake_up_bit+0x70/0x70
[   59.108280]  [<c0157092>] async_synchronize_cookie+0x12/0x20
[   59.108308]  [<c01570b8>] async_synchronize_full+0x18/0x40
[   59.110234]  [<c01854f8>] sys_init_module+0x138/0x1460
[   59.112169]  [<c05ea9df>] sysenter_do_call+0x12/0x28
[   59.114088] modprobe        D c027484a     0  1005    950 0x00000004
[   59.116028]  ec667ec4 00000082 ec667e60 c027484a 00000000 ed7e2580
ec69a580 c08f8280
[   59.118003]  c08f8280 c08f8280 076afee3 00000004 c08f8280 f6607280
ec69a580 f5cb0000
[   59.119996]  00000000 00000000 00000080 00000000 f802ae70 ec667e98
c05e1da9 f802afc0
[   59.122013] Call Trace:
[   59.123978]  [<c027484a>] ? sysfs_addrm_finish+0x1a/0xa0
[   59.125946]  [<c05e1da9>] ? mutex_lock+0x19/0x40
[   59.127896]  [<c01c303f>] ? trace_module_notify+0x2f/0x260
[   59.129861]  [<c05e1da9>] ? mutex_lock+0x19/0x40
[   59.131792]  [<c05e32e3>] schedule+0x23/0x60
[   59.133684]  [<c0156fed>] async_synchronize_cookie_domain+0xbd/0x150
[   59.135545]  [<c01506b0>] ? wake_up_bit+0x70/0x70
[   59.137388]  [<c0157092>] async_synchronize_cookie+0x12/0x20
[   59.139219]  [<c01570b8>] async_synchronize_full+0x18/0x40
[   59.141008]  [<c01854f8>] sys_init_module+0x138/0x1460
[   59.142792]  [<c05e724f>] ? do_page_fault+0x1bf/0x410
[   59.144569]  [<c05ea9df>] sysenter_do_call+0x12/0x28
[   59.146340] modprobe        D 00000003     0  1016    354 0x00000004
[   59.148137]  ec687ec4 00000086 0000ca0a 00000003 c092ef0a ec1ba580
ec69cb00 c08f8280
[   59.149961]  c08f8280 c08f8280 af6aece7 00000004 c08f8280 f6407280
ec69cb00 ec1c2580
[   59.151788]  00000000 0000000f 0000003c 00000006 205b0000 ec687e98
c05e1da9 f8032040
[   59.153620] Call Trace:
[   59.155397]  [<c05e1da9>] ? mutex_lock+0x19/0x40
[   59.157172]  [<c01c303f>] ? trace_module_notify+0x2f/0x260
[   59.158932]  [<c05e1da9>] ? mutex_lock+0x19/0x40
[   59.160675]  [<c05e32e3>] schedule+0x23/0x60
[   59.162403]  [<c0156fed>] async_synchronize_cookie_domain+0xbd/0x150
[   59.164139]  [<c01506b0>] ? wake_up_bit+0x70/0x70
[   59.164141]  [<c0157092>] async_synchronize_cookie+0x12/0x20
[   59.164144]  [<c01570b8>] async_synchronize_full+0x18/0x40
[   59.164145]  [<c01854f8>] sys_init_module+0x138/0x1460
[   59.164148]  [<c05e724f>] ? do_page_fault+0x1bf/0x410
[   59.164152]  [<c05ea9df>] sysenter_do_call+0x12/0x28
[   59.164156]
[   59.164157] Restarting tasks ... done.
[   59.175603] PM: Basic memory bitmaps freed
[   59.251068] r8169 0000:03:00.0: eth0: link down
[   59.251078] r8169 0000:03:00.0: eth0: link down
[   59.251083] NOHZ: local_softirq_pending 08
[   59.251104] NOHZ: local_softirq_pending 08
[   59.251204] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   59.251220] NOHZ: local_softirq_pending 08
[   59.251335] NOHZ: local_softirq_pending 08
[   59.251429] NOHZ: local_softirq_pending 08
[   60.091784] EXT4-fs (sda2): re-mounted. Opts: errors=remount-ro,commit=0
[   61.025833] r8169 0000:03:00.0: eth0: link up
[   61.025989] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   66.994077] usb 10-1: reset SuperSpeed USB device number 3 using xhci_hcd
[   67.009978] xhci_hcd 0000:01:00.0: xHCI xhci_drop_endpoint called
with disabled ep ed781c00
[   67.009985] xhci_hcd 0000:01:00.0: xHCI xhci_drop_endpoint called
with disabled ep ed781c2c
[   71.885779] eth0: no IPv6 routers present


After debugging the code, I found the issue happened while the driver ran to
line 782 in scsi_send_eh_cmnd().

 778 static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 779                              int cmnd_size, int timeout, unsigned
sense_bytes)
 780 {
 781         struct scsi_device *sdev = scmd->device;
 782         struct scsi_driver *sdrv = scsi_cmd_to_driver(scmd);
 783         struct Scsi_Host *shost = sdev->host;
 784         DECLARE_COMPLETION_ONSTACK(done);
 785         unsigned long timeleft;
 786         struct scsi_eh_save ses;
 787         int rtn;

I know the code is submitted by you. I don't familiar with the scsi core.
It seems like the conversion process from scsi command to scsi driver
encounter a NULL pointer. Any idea?


Best Regards,
Elric Fu
