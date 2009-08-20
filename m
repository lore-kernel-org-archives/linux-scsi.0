From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 14020] New: Stack trace when running smartctl
 on an USB disk
Date: Thu, 20 Aug 2009 14:58:30 -0700
Message-ID: <20090820145830.4f745fc3.akpm@linux-foundation.org>
References: <bug-14020-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35774 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754186AbZHTV6l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Aug 2009 17:58:41 -0400
In-Reply-To: <bug-14020-10286@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org, rbrito@ime.usp.br


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Thu, 20 Aug 2009 02:13:27 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=14020
> 
>            Summary: Stack trace when running smartctl on an USB disk
>            Product: Drivers
>            Version: 2.5
>     Kernel Version: 2.6.31-rc6
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: USB
>         AssignedTo: greg@kroah.com
>         ReportedBy: rbrito@ime.usp.br
>         Regression: No
> 
> 
> Hi.
> 
> Trying to see the status of a drive of mine that is in an USB enclosure, I
> issued the command:
> 
>   # smartctl -d usbcypress -a /dev/sda
> 
> What I got in return was:
> 
> "task smartctl:1513 blocked for more than 120 seconds" with a subsequent stack
> trace, listed below.

Yup, that's a bug.  I assume that smartctl never recovered?

I don't know if it's a scsi bug or a usb bug.  Probably the latter?

> 
> [66493.029171] usb-storage: device scan complete
> [66493.029657] scsi 4:0:0:0: Direct-Access     ST375064 0A                   
> PQ: 0 ANSI: 0
> [66493.032385] sd 4:0:0:0: [sda] 1465149168 512-byte logical blocks: (750
> GB/698 GiB)
> [66493.033515] sd 4:0:0:0: [sda] Write Protect is off
> [66493.033522] sd 4:0:0:0: [sda] Mode Sense: 33 00 00 00
> [66493.033526] sd 4:0:0:0: [sda] Assuming drive cache: write through
> [66493.035501] sd 4:0:0:0: [sda] Assuming drive cache: write through
> [66493.035508]  sda: sda1
> [66493.056139] sd 4:0:0:0: [sda] Assuming drive cache: write through
> [66493.056149] sd 4:0:0:0: [sda] Attached SCSI disk
> [66493.407349] EXT4-fs (sda1): barriers enabled
> [66493.436357] kjournald2 starting: pid 1407, dev sda1:8, commit interval 5
> seconds
> [66493.437049] EXT4-fs (sda1): internal journal on sda1:8
> [66493.437058] EXT4-fs (sda1): delayed allocation enabled
> [66493.437063] EXT4-fs: file extents enabled
> [66493.483105] EXT4-fs: mballoc enabled
> [66493.483135] EXT4-fs (sda1): mounted filesystem with ordered data mode
> [66696.806018] usb 1-1: reset high speed USB device using ehci_hcd and address
> 4
> [66714.806020] usb 1-1: reset high speed USB device using ehci_hcd and address
> 4
> [66714.920809] program smartctl is using a deprecated SCSI ioctl, please
> convert it to SG_IO
> [66775.806017] usb 1-1: reset high speed USB device using ehci_hcd and address
> 4
> [66836.806019] usb 1-1: reset high speed USB device using ehci_hcd and address
> 4
> [66840.171050] INFO: task smartctl:1513 blocked for more than 120 seconds.
> [66840.171055] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
> message.
> [66840.171060] smartctl      D ffff8800014a79c0     0  1513   1298 0x00000004
> [66840.171068]  ffff88006fa52120 0000000000000082 0000000000000001
> 0000000000000001
> [66840.171075]  00000000000109c0 000000000000c858 ffff88006fa54f80
> ffff88006fa552f8
> [66840.171083]  000000007c863500 ffff88005e15fd68 ffff88006fa552f8
> ffff88005e15fd70
> [66840.171090] Call Trace:
> [66840.171102]  [<ffffffff812571d6>] ? schedule_timeout+0x1e/0xb8
> [66840.171136]  [<ffffffffa006f2ca>] ? scsi_request_fn+0x355/0x423 [scsi_mod]
> [66840.171155]  [<ffffffff8103ecb7>] ? del_timer+0x59/0x62
> [66840.171165]  [<ffffffff812566c6>] ? wait_for_common+0xaa/0x10b
> [66840.171176]  [<ffffffff81030067>] ? default_wake_function+0x0/0x9
> [66840.171186]  [<ffffffff81107348>] ? __generic_unplug_device+0x12/0x2c
> [66840.171197]  [<ffffffff8110a6a4>] ? blk_execute_rq+0x93/0xab
> [66840.171205]  [<ffffffff8110a869>] ? blk_recount_segments+0x17/0x27
> [66840.171214]  [<ffffffff81105576>] ? blk_rq_bio_prep+0x39/0x69
> [66840.171224]  [<ffffffff8110d96e>] ? sg_scsi_ioctl+0x229/0x2ad
> [66840.171233]  [<ffffffff8110dd44>] ? scsi_cmd_ioctl+0x352/0x39e
> [66840.171242]  [<ffffffff8106991e>] ? filemap_fault+0x5e/0x36d
> [66840.171252]  [<ffffffff8107a2a8>] ? __do_fault+0x34b/0x386
> [66840.171261]  [<ffffffff81113c30>] ? kobject_get+0x12/0x17
> [66840.171275]  [<ffffffffa02337e0>] ? sd_ioctl+0x78/0xa6 [sd_mod]
> [66840.171284]  [<ffffffff8110b5b9>] ? __blkdev_driver_ioctl+0x69/0x7e
> [66840.171292]  [<ffffffff8110bdc4>] ? blkdev_ioctl+0x7d2/0x806
> [66840.171301]  [<ffffffff8106991e>] ? filemap_fault+0x5e/0x36d
> [66840.171309]  [<ffffffff8107a2a8>] ? __do_fault+0x34b/0x386
> [66840.171320]  [<ffffffff810b6c99>] ? block_ioctl+0x38/0x3c
> [66840.171329]  [<ffffffff810a020e>] ? vfs_ioctl+0x21/0x6c
> [66840.171338]  [<ffffffff810a0712>] ? do_vfs_ioctl+0x443/0x47b
> [66840.171347]  [<ffffffff81021e4c>] ? do_page_fault+0x1fe/0x212
> [66840.171356]  [<ffffffff810a0787>] ? sys_ioctl+0x3d/0x5c
> [66840.171366]  [<ffffffff8100b02b>] ? system_call_fastpath+0x16/0x1b
> [66855.596877] usb 1-1: USB disconnect, address 4
> 
> I am not sure if I can reproduce it, but I can try. If anything is needed,
> please, just let me know and I'll do my best to provide the necessary
> information.
> 

