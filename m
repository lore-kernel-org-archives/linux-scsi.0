From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [Bugme-new] [Bug 3633] New: sr_mod crashes when unplugging
 external USB-DVD-recorder
Date: Mon, 25 Oct 2004 01:12:49 -0700
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <20041025011249.1f139c00.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org


This looks familiar...


Begin forwarded message:

Date: Mon, 25 Oct 2004 01:11:42 -0700
From: bugme-daemon@osdl.org
To: bugme-new@lists.osdl.org
Subject: [Bugme-new] [Bug 3633] New: sr_mod crashes when unplugging external USB-DVD-recorder


http://bugme.osdl.org/show_bug.cgi?id=3633

           Summary: sr_mod crashes when unplugging external USB-DVD-recorder
    Kernel Version: 2.6.9
            Status: NEW
          Severity: high
             Owner: andmike@us.ibm.com
         Submitter: bugzilla@bernd-wurst.de


I own an external DVD burner, connected via USB (high speed). 
Via udev & hotplug, evenrything is fine when connecting the device, cdrecord 
-scanbus shows it and I can also use it. 
 
But if I unplug the burner, the sr_mod (and most times all further I/O) 
crashes. I get a kernel oops and the whole system crashes sooner or later. If 
I re-plug the device, it's not accessibla any more. 
 
The log output when I unplug the device is: 
Oct 25 09:49:40 aragorn usb 1-1: USB disconnect, address 3 
Oct 25 09:49:45 aragorn scsi: Device offlined - not ready after error 
recovery: host 0 channel 0 id 0 lun 0 
Oct 25 09:49:45 aragorn sr 0:0:0:0: Illegal state transition cancel->offline 
Oct 25 09:49:45 aragorn Badness in scsi_device_set_state at 
drivers/scsi/scsi_lib.c:1688 
Oct 25 09:49:45 aragorn [<e1994d59>] scsi_device_set_state+0xc9/0x120 
[scsi_mod] 
Oct 25 09:49:45 aragorn [<e1992a3e>] scsi_eh_offline_sdevs+0x6e/0x90 
[scsi_mod] 
Oct 25 09:49:45 aragorn [<e1992f13>] scsi_unjam_host+0xc3/0xd0 [scsi_mod] 
Oct 25 09:49:45 aragorn [<e1992fc8>] scsi_error_handler+0xa8/0xd0 [scsi_mod] 
Oct 25 09:49:45 aragorn [<e1992f20>] scsi_error_handler+0x0/0xd0 [scsi_mod] 
Oct 25 09:49:45 aragorn [<c01042cd>] kernel_thread_helper+0x5/0x18 
Oct 25 09:49:45 aragorn Badness in kref_get at lib/kref.c:32 
Oct 25 09:49:45 aragorn [<c0281ba7>] kref_get+0x47/0x50 
Oct 25 09:49:45 aragorn [<c028176a>] kobject_get+0x1a/0x30 
Oct 25 09:49:45 aragorn [<c030b348>] get_device+0x18/0x20 
Oct 25 09:49:45 aragorn [<e1994415>] scsi_request_fn+0x25/0x3c0 [scsi_mod] 
Oct 25 09:49:45 aragorn [<c0312e4c>] blk_insert_request+0xbc/0xe0 
Oct 25 09:49:45 aragorn [<e19932d7>] scsi_queue_insert+0x77/0xb0 [scsi_mod] 
Oct 25 09:49:45 aragorn [<e1992e3f>] scsi_eh_flush_done_q+0x9f/0xb0 [scsi_mod] 
Oct 25 09:49:45 aragorn [<e1992edf>] scsi_unjam_host+0x8f/0xd0 [scsi_mod] 
Oct 25 09:49:45 aragorn [<e1992fc8>] scsi_error_handler+0xa8/0xd0 [scsi_mod] 
Oct 25 09:49:45 aragorn [<e1992f20>] scsi_error_handler+0x0/0xd0 [scsi_mod] 
Oct 25 09:49:45 aragorn [<c01042cd>] kernel_thread_helper+0x5/0x18 
Oct 25 09:49:45 aragorn Unable to handle kernel paging request at virtual 
address 00200200 
Oct 25 09:49:45 aragorn printing eip: 
Oct 25 09:49:45 aragorn e19969f0 
Oct 25 09:49:45 aragorn *pde = 00000000 
Oct 25 09:49:45 aragorn Oops: 0002 [#1] 
Oct 25 09:49:45 aragorn PREEMPT 
Oct 25 09:49:45 aragorn Modules linked in: sr_mod usb_storage sg scsi_mod vfat 
fat usbhid eth1394 ohci1394 ieee1394 yenta_socket pcmcia_core 
Oct 25 09:49:45 aragorn CPU:    0 
Oct 25 09:49:45 aragorn EIP:    0060:[<e19969f0>]    Not tainted VLI 
Oct 25 09:49:45 aragorn EFLAGS: 00010002   (2.6.9-rc4-aragorn-1) 
Oct 25 09:49:45 aragorn EIP is at scsi_device_dev_release+0x30/0x120 
[scsi_mod] 
Oct 25 09:49:45 aragorn eax: 00100100   ebx: df205408   ecx: 00200200   edx: 
df205584 
Oct 25 09:49:45 aragorn esi: df205400   edi: 00000282   ebp: c14f4eb4   esp: 
ddc57ea4 
Oct 25 09:49:45 aragorn ds: 007b   es: 007b   ss: 0068 
Oct 25 09:49:45 aragorn Process scsi_eh_0 (pid: 8643, threadinfo=ddc56000 
task=dec6a020) 
Oct 25 09:49:45 aragorn Stack: dec6a020 df2055a8 c0548168 c0548180 c14f4ed8 
c030b02b df205584 df2055a8 
Oct 25 09:49:45 aragorn c0548168 c0548180 c0281818 df2055a8 df2055c0 c0281820 
ddc56000 ddc56000 
Oct 25 09:49:45 aragorn c0281be9 df2055a8 ddc56000 ddc56000 c03122e6 ddc56000 
df205400 c028184f 
Oct 25 09:49:45 aragorn Call Trace: 
Oct 25 09:49:45 aragorn [<c030b02b>] device_release+0x5b/0x60 
Oct 25 09:49:45 aragorn [<c0281818>] kobject_cleanup+0x98/0xa0 
Oct 25 09:49:45 aragorn [<c0281820>] kobject_release+0x0/0x10 
Oct 25 09:49:45 aragorn [<c0281be9>] kref_put+0x39/0xa0 
Oct 25 09:49:45 aragorn [<c03122e6>] blk_plug_device+0x56/0x90 
Oct 25 09:49:45 aragorn [<c028184f>] kobject_put+0x1f/0x30 
Oct 25 09:49:45 aragorn [<c0281820>] kobject_release+0x0/0x10 
Oct 25 09:49:45 aragorn [<c0281be9>] kref_put+0x39/0xa0 
Oct 25 09:49:45 aragorn [<c03122e6>] blk_plug_device+0x56/0x90 
Oct 25 09:49:45 aragorn [<c028184f>] kobject_put+0x1f/0x30 
Oct 25 09:49:45 aragorn [<c0281820>] kobject_release+0x0/0x10 
Oct 25 09:49:45 aragorn [<e1994605>] scsi_request_fn+0x215/0x3c0 [scsi_mod] 
Oct 25 09:49:45 aragorn [<c0312e4c>] blk_insert_request+0xbc/0xe0 
Oct 25 09:49:45 aragorn [<e19932d7>] scsi_queue_insert+0x77/0xb0 [scsi_mod] 
Oct 25 09:49:45 aragorn [<e1992e3f>] scsi_eh_flush_done_q+0x9f/0xb0 [scsi_mod] 
Oct 25 09:49:45 aragorn [<e1992edf>] scsi_unjam_host+0x8f/0xd0 [scsi_mod] 
Oct 25 09:49:45 aragorn [<e1992fc8>] scsi_error_handler+0xa8/0xd0 [scsi_mod] 
Oct 25 09:49:45 aragorn [<e1992f20>] scsi_error_handler+0x0/0xd0 [scsi_mod] 
Oct 25 09:49:45 aragorn [<c01042cd>] kernel_thread_helper+0x5/0x18 
Oct 25 09:49:45 aragorn Code: ec 04 8b 54 24 18 8b 6a 20 8d b2 7c fe ff ff 9c 
5f fa b8 00 e0 ff ff 21 e0 ff 40 14 8d 9a 84 fe ff ff 8b 82 84 fe ff ff 8b 4b 
04 <89> 01 89 48 04 b8 00 01 10 00 c7 43 04 00 02 20 00 8d 9a 8c fe 
Oct 25 09:49:45 aragorn <6>note: scsi_eh_0[8643] exited with preempt_count 1 
Oct 25 09:49:45 aragorn Badness in kref_get at lib/kref.c:32 
Oct 25 09:49:45 aragorn [<c0281ba7>] kref_get+0x47/0x50 
Oct 25 09:49:45 aragorn [<c028176a>] kobject_get+0x1a/0x30 
Oct 25 09:49:45 aragorn [<c030b348>] get_device+0x18/0x20 
Oct 25 09:49:45 aragorn [<e1994415>] scsi_request_fn+0x25/0x3c0 [scsi_mod] 
Oct 25 09:49:45 aragorn [<c0310656>] elv_next_request+0x16/0x110 
Oct 25 09:49:45 aragorn [<c03123e1>] __generic_unplug_device+0x41/0x50 
Oct 25 09:49:45 aragorn [<c031240e>] generic_unplug_device+0x1e/0x40 
Oct 25 09:49:45 aragorn [<c0312470>] blk_unplug_work+0x10/0x20 
Oct 25 09:49:45 aragorn [<c012e099>] worker_thread+0x1d9/0x2a0 
Oct 25 09:49:45 aragorn [<c0312460>] blk_unplug_work+0x0/0x20 
Oct 25 09:49:45 aragorn [<c011b0b0>] default_wake_function+0x0/0x20 
Oct 25 09:49:45 aragorn [<c011b0b0>] default_wake_function+0x0/0x20 
Oct 25 09:49:45 aragorn [<c012dec0>] worker_thread+0x0/0x2a0 
Oct 25 09:49:45 aragorn [<c013221a>] kthread+0xaa/0xb0 
Oct 25 09:49:45 aragorn [<c0132170>] kthread+0x0/0xb0 
Oct 25 09:49:45 aragorn [<c01042cd>] kernel_thread_helper+0x5/0x18 
Oct 25 09:49:45 aragorn Unable to handle kernel paging request at virtual 
address 00200200 
Oct 25 09:49:45 aragorn printing eip: 
Oct 25 09:49:45 aragorn e19969f0 
Oct 25 09:49:45 aragorn *pde = 00000000 
Oct 25 09:49:45 aragorn Oops: 0002 [#2] 
Oct 25 09:49:45 aragorn PREEMPT 
Oct 25 09:49:45 aragorn Modules linked in: sr_mod usb_storage sg scsi_mod vfat 
fat usbhid eth1394 ohci1394 ieee1394 yenta_socket pcmcia_core 
Oct 25 09:49:45 aragorn CPU:    0 
Oct 25 09:49:45 aragorn EIP:    0060:[<e19969f0>]    Not tainted VLI 
Oct 25 09:49:45 aragorn EFLAGS: 00010002   (2.6.9-rc4-aragorn-1) 
Oct 25 09:49:45 aragorn EIP is at scsi_device_dev_release+0x30/0x120 
[scsi_mod] 
Oct 25 09:49:45 aragorn eax: 00100100   ebx: df205408   ecx: 00200200   edx: 
df205584 
Oct 25 09:49:45 aragorn esi: df205400   edi: 00000282   ebp: c14f4eb4   esp: 
c15bfe98 
Oct 25 09:49:45 aragorn ds: 007b   es: 007b   ss: 0068 
Oct 25 09:49:45 aragorn Process kblockd/0 (pid: 30, threadinfo=c15be000 
task=c14f1020) 
Oct 25 09:49:45 aragorn Stack: 00000000 df2055a8 c0548168 c0548180 c14f4ed8 
c030b02b df205584 df2055a8 
Oct 25 09:49:45 aragorn c0548168 c0548180 c0281818 df2055a8 df2055c0 c0281820 
c15be000 c15be000 
Oct 25 09:49:45 aragorn c0281be9 df2055a8 c15be000 c15be000 c03122e6 c15be000 
df205400 c028184f 
Oct 25 09:49:45 aragorn Call Trace: 
Oct 25 09:49:45 aragorn [<c030b02b>] device_release+0x5b/0x60 
Oct 25 09:49:45 aragorn [<c0281818>] kobject_cleanup+0x98/0xa0 
Oct 25 09:49:45 aragorn [<c0281820>] kobject_release+0x0/0x10 
Oct 25 09:49:45 aragorn [<c0281be9>] kref_put+0x39/0xa0 
Oct 25 09:49:45 aragorn [<c03122e6>] blk_plug_device+0x56/0x90 
Oct 25 09:49:45 aragorn [<c028184f>] kobject_put+0x1f/0x30 
Oct 25 09:49:45 aragorn [<c0281820>] kobject_release+0x0/0x10 
Oct 25 09:49:45 aragorn [<e1994605>] scsi_request_fn+0x215/0x3c0 [scsi_mod] 
Oct 25 09:49:45 aragorn [<c0310656>] elv_next_request+0x16/0x110 
Oct 25 09:49:45 aragorn [<c03123e1>] __generic_unplug_device+0x41/0x50 
Oct 25 09:49:45 aragorn [<c031240e>] generic_unplug_device+0x1e/0x40 
Oct 25 09:49:45 aragorn [<c0312470>] blk_unplug_work+0x10/0x20 
Oct 25 09:49:45 aragorn [<c012e099>] worker_thread+0x1d9/0x2a0 
Oct 25 09:49:45 aragorn [<c0312460>] blk_unplug_work+0x0/0x20 
Oct 25 09:49:45 aragorn [<c011b0b0>] default_wake_function+0x0/0x20 
Oct 25 09:49:45 aragorn [<c011b0b0>] default_wake_function+0x0/0x20 
Oct 25 09:49:45 aragorn [<c012dec0>] worker_thread+0x0/0x2a0 
Oct 25 09:49:45 aragorn [<c013221a>] kthread+0xaa/0xb0 
Oct 25 09:49:45 aragorn [<c0132170>] kthread+0x0/0xb0 
Oct 25 09:49:45 aragorn [<c01042cd>] kernel_thread_helper+0x5/0x18 
Oct 25 09:49:45 aragorn Code: ec 04 8b 54 24 18 8b 6a 20 8d b2 7c fe ff ff 9c 
5f fa b8 00 e0 ff ff 21 e0 ff 40 14 8d 9a 84 fe ff ff 8b 82 84 fe ff ff 8b 4b 
04 <89> 01 89 48 04 b8 00 01 10 00 c7 43 04 00 02 20 00 8d 9a 8c fe 
Oct 25 09:49:45 aragorn <6>note: kblockd/0[30] exited with preempt_count 1 
 
With kernel 2.6.5 & devfs, I did not get any problem, I can plug and unplug 
the device as often as I want. 
Now, I'm gonna do some debuggin with 2.6.7, 2.6.9&devfs and so on, but it IS a 
bug. ;-)

------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.


-------------------------------------------------------
This SF.net email is sponsored by: IT Product Guide on ITManagersJournal
Use IT products in your business? Tell us what you think of them. Give us
Your Opinions, Get Free ThinkGeek Gift Certificates! Click to find out more
http://productguide.itmanagersjournal.com/guidepromo.tmpl
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
