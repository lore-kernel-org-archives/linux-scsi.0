From: Alan Stern <stern@rowland.harvard.edu>
Subject: BUG: CD driver sends command during host removal
Date: Mon, 27 Sep 2004 14:18:51 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0409271358300.1928-100000@ida.rowland.org>
References: <20040926082926.GA1944@uniball>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:29700 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S261232AbUI0SSw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Sep 2004 14:18:52 -0400
In-Reply-To: <20040926082926.GA1944@uniball>
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: Mohammed Sameer <uniball@gmx.net>, USB users list <linux-usb-users@lists.sourceforge.net>

I received the following error report, showing that something in the CD 
driver attempts to send a command to a USB CD-RW drive when the host is 
removed, leading to an oops.  This was on a 2.6.9-rc2 system (Mohammed 
please correct me if that's wrong).

The initial part of the log shows a perfectly normal probe and scan of the 
drive.  Here are the important bits:

On Sun, 26 Sep 2004, Mohammed Sameer wrote:

> Sep 26 11:20:48 localhost kernel: usb-storage: Command INQUIRY (6 bytes)
> Sep 26 11:20:48 localhost kernel: usb-storage:  12 00 00 00 24 00
> Sep 26 11:20:48 localhost kernel: usb-storage: scsi cmd done, result=0x0
> Sep 26 11:20:48 localhost kernel:   Vendor: MSI       Model: CD-RW CR52        Rev: 3.70
> Sep 26 11:20:48 localhost kernel:   Type:   CD-ROM                             ANSI SCSI revision: 02

> Sep 26 11:20:48 localhost kernel: usb-storage: Command TEST_UNIT_READY (6 bytes)
> Sep 26 11:20:48 localhost kernel: usb-storage:  00 00 00 00 00 00
> Sep 26 11:20:48 localhost kernel: usb-storage: -- transport indicates command failure
> Sep 26 11:20:48 localhost kernel: usb-storage: Issuing auto-REQUEST_SENSE
> Sep 26 11:20:48 localhost kernel: usb-storage: -- code: 0x70, key: 0x6, ASC: 0x29, ASCQ: 0x0
> Sep 26 11:20:48 localhost kernel: usb-storage: Unit Attention: Power on, reset, or bus device reset occurred
> Sep 26 11:20:48 localhost kernel: usb-storage: scsi cmd done, result=0x2

> Sep 26 11:20:48 localhost kernel: usb-storage: Command TEST_UNIT_READY (6 bytes)
> Sep 26 11:20:48 localhost kernel: usb-storage:  00 00 00 00 00 00
> Sep 26 11:20:48 localhost kernel: usb-storage: scsi cmd done, result=0x0

> Sep 26 11:20:48 localhost kernel: usb-storage: Command MODE_SENSE_10 (10 bytes)
> Sep 26 11:20:48 localhost kernel: usb-storage:  5a 00 2a 00 00 00 00 00 80 00
> Sep 26 11:20:48 localhost kernel: usb-storage: scsi cmd done, result=0x0
> Sep 26 11:20:48 localhost kernel: sr0: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
> Sep 26 11:20:48 localhost kernel: Attached scsi CD-ROM sr0 at scsi0, channel 0, id 0, lun 0Sep 26 11:20:54 localhost kernel: usb 1-2: USB disconnect, address 2

Up to here everything looks okay.  Then the user unplugged the USB cable:

> Sep 26 11:20:54 localhost kernel: usb-storage: storage_disconnect() called
> Sep 26 11:20:54 localhost kernel: usb-storage: usb_stor_stop_transport called

Next usb-storage called scsi_remove_host().  Apparently this caused some 
component of the CD driver to queue a command:

> Sep 26 11:20:54 localhost kernel: usb-storage: queuecommand called
> Sep 26 11:20:54 localhost kernel: usb-storage: *** thread awakened.
> Sep 26 11:20:54 localhost kernel: usb-storage: No command during disconnect
> Sep 26 11:20:54 localhost kernel: usb-storage: *** thread sleeping.

usb-storage accepted the command but then ignored it because the host was
in process of removal.  Should the queuecommand routine have rejected the
command?  This would involve a race, because it's possible for
queuecommand to accept a command and then scsi_remove_host() to be called
before the command is carried out.

After five seconds the command timed out:

> Sep 26 11:20:59 localhost kernel: usb-storage: command_abort called
> Sep 26 11:20:59 localhost kernel: usb-storage: -- nothing to abort

usb-storage ignored the request to abort the command (the command_abort
routine returned FAILED because no command was running).  So error
recovery proceeded to try a device reset and then a bus reset.  Neither 
one was allowed:

> Sep 26 11:20:59 localhost kernel: usb-storage: device_reset called
> Sep 26 11:20:59 localhost kernel: usb-storage: No reset during disconnect
> Sep 26 11:20:59 localhost kernel: usb-storage: bus_reset called
> Sep 26 11:20:59 localhost kernel: usb-storage: No reset during disconnect

usb-storage doesn't define a host reset, so error recovery gave up:

> Sep 26 11:20:59 localhost kernel: scsi: Device offlined - not ready after error recovery: host 0 channel 0 id 0 lun 0
> Sep 26 11:20:59 localhost kernel: Badness in scsi_device_set_state at drivers/scsi/scsi_lib.c:1688
> Sep 26 11:20:59 localhost kernel:  [<cf92d24f>] scsi_device_set_state+0xc4/0x112 [scsi_mod]Sep 26 11:20:59 localhost kernel:  [<cf92afa0>] scsi_eh_offline_sdevs+0x64/0x80 [scsi_mod]
> Sep 26 11:20:59 localhost kernel:  [<cf92b4b0>] scsi_unjam_host+0xb6/0x1eb [scsi_mod]
> Sep 26 11:20:59 localhost kernel:  [<c0115777>] default_wake_function+0x0/0x12
> Sep 26 11:20:59 localhost kernel:  [<cf92b6b4>] scsi_error_handler+0xcf/0x16b [scsi_mod]
> Sep 26 11:20:59 localhost kernel:  [<cf92b5e5>] scsi_error_handler+0x0/0x16b [scsi_mod]
> Sep 26 11:20:59 localhost kernel:  [<c010425d>] kernel_thread_helper+0x5/0xb
> Sep 26 11:20:59 localhost kernel: Badness in kref_get at lib/kref.c:32
> Sep 26 11:20:59 localhost kernel:  [<c01aa017>] kref_get+0x44/0x46
> Sep 26 11:20:59 localhost kernel:  [<c01a9c65>] kobject_get+0x1a/0x24
> Sep 26 11:20:59 localhost kernel:  [<c0218ec6>] get_device+0x18/0x21
> Sep 26 11:20:59 localhost kernel:  [<cf92c9c4>] scsi_request_fn+0x25/0x367 [scsi_mod]
> Sep 26 11:20:59 localhost kernel:  [<c021f1e2>] blk_insert_request+0xae/0xcc
> Sep 26 11:20:59 localhost kernel:  [<c0106428>] dump_stack+0x1c/0x20
> Sep 26 11:20:59 localhost kernel:  [<cf92ba11>] scsi_queue_insert+0x89/0xd0 [scsi_mod]
> Sep 26 11:20:59 localhost kernel:  [<cf92b381>] scsi_eh_flush_done_q+0x6f/0xe8 [scsi_mod]
> Sep 26 11:20:59 localhost kernel:  [<cf92b47c>] scsi_unjam_host+0x82/0x1eb [scsi_mod]
> Sep 26 11:20:59 localhost kernel:  [<c0115777>] default_wake_function+0x0/0x12
> Sep 26 11:20:59 localhost kernel:  [<cf92b6b4>] scsi_error_handler+0xcf/0x16b [scsi_mod]
> Sep 26 11:20:59 localhost kernel:  [<cf92b5e5>] scsi_error_handler+0x0/0x16b [scsi_mod]
> Sep 26 11:20:59 localhost kernel:  [<c010425d>] kernel_thread_helper+0x5/0xb
> Sep 26 11:20:59 localhost kernel: cf92ee79
> Sep 26 11:20:59 localhost kernel: Modules linked in: sr_mod usb_storage ipv6 thermal fan button processor ac battery microcode e100 yenta_socket pcmcia_core ehci_hcd usbcore ext2 dm_mod eepro100 mii toshiba_acpi psmouse pcspkr msr snd_seq_midi snd_intel8x0 snd_ac97_codec snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc gameport snd_mpu401_uart snd_rawmidi snd_seq_oss snd_seq_midi_event snd_seq snd_timer snd_seq_device snd soundcore ide_cd cdrom sd_mod scsi_mod rtc unix
> Sep 26 11:20:59 localhost kernel: CPU:    0
> Sep 26 11:20:59 localhost kernel: EIP:    0060:[<cf92ee79>]    Not tainted VLI
> Sep 26 11:20:59 localhost kernel: EFLAGS: 00010082   (2.6.9-rc2-Uniball-1) 
> Sep 26 11:20:59 localhost kernel: EIP is at scsi_device_dev_release+0x26/0xeb [scsi_mod]
> Sep 26 11:20:59 localhost kernel: eax: c974dd84   ebx: c974dc08   ecx: 00200200   edx: 00100100
> Sep 26 11:20:59 localhost kernel: esi: c974dc00   edi: 00000282   ebp: cef084b4   esp: c9091e80
> Sep 26 11:20:59 localhost kernel: ds: 007b   es: 007b   ss: 0068
> Sep 26 11:20:59 localhost kernel: Process scsi_eh_0 (pid: 2103, threadinfo=c9090000 task=cd2b8aa0)
> Sep 26 11:20:59 localhost kernel: Stack: 00000046 c974dda8 c0334488 c03344a0 cef084d8 c0218bf8 c974dd84 c974dda8 
> Sep 26 11:20:59 localhost kernel:        c0334488 c03344a0 c01a9d07 c974dda8 c974ddc0 c01a9d09 cef08400 cec76128 
> Sep 26 11:20:59 localhost kernel:        c01aa052 c974dda8 cef08400 cec76128 c974dd84 cef302b0 c974dc00 c01a9d31 
> Sep 26 11:20:59 localhost kernel: Call Trace:
> Sep 26 11:20:59 localhost kernel:  [<c0218bf8>] device_release+0x58/0x5c
> Sep 26 11:20:59 localhost kernel:  [<c01a9d07>] kobject_cleanup+0x98/0x9a
> Sep 26 11:20:59 localhost kernel:  [<c01a9d09>] kobject_release+0x0/0xa
> Sep 26 11:20:59 localhost kernel:  [<c01aa052>] kref_put+0x39/0x93
> Sep 26 11:20:59 localhost kernel:  [<c01a9d31>] kobject_put+0x1e/0x22
> Sep 26 11:20:59 localhost kernel:  [<c01a9d09>] kobject_release+0x0/0xa
> Sep 26 11:20:59 localhost kernel:  [<cf92cb82>] scsi_request_fn+0x1e3/0x367 [scsi_mod]
> Sep 26 11:20:59 localhost kernel:  [<c021f1e2>] blk_insert_request+0xae/0xcc
> Sep 26 11:20:59 localhost kernel:  [<c0106428>] dump_stack+0x1c/0x20
> Sep 26 11:20:59 localhost kernel:  [<cf92ba11>] scsi_queue_insert+0x89/0xd0 [scsi_mod]
> Sep 26 11:20:59 localhost kernel:  [<cf92b381>] scsi_eh_flush_done_q+0x6f/0xe8 [scsi_mod]
> Sep 26 11:20:59 localhost kernel:  [<cf92b47c>] scsi_unjam_host+0x82/0x1eb [scsi_mod]
> Sep 26 11:20:59 localhost kernel:  [<c0115777>] default_wake_function+0x0/0x12
> Sep 26 11:20:59 localhost kernel:  [<cf92b6b4>] scsi_error_handler+0xcf/0x16b [scsi_mod]
> Sep 26 11:20:59 localhost kernel:  [<cf92b5e5>] scsi_error_handler+0x0/0x16b [scsi_mod]
> Sep 26 11:20:59 localhost kernel:  [<c010425d>] kernel_thread_helper+0x5/0xb
> Sep 26 11:20:59 localhost kernel: Code: e9 7c a0 8e f0 55 57 56 53 83 ec 04 8b 44 24 18 8b 68 20 8d b0 7c fe ff ff 9c 5f fa 8d 98 84 fe ff ff 8b 90 84 fe ff ff 8b 4b 04 <89> 4a 04 89 11 c7 43 04 00 02 20 00 8d 98 8c fe ff ff 8b 90 8c 

I've omitted the remaining parts of the fault cascade.

Can anyone help?

Alan Stern

