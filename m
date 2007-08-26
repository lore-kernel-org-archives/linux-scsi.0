From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 8940] New: BUG: unable to
 handle kernel NULL pointer dereference at virtual address 00000000
Date: Sun, 26 Aug 2007 00:52:07 -0700
Message-ID: <20070826005207.4f0b62ce.akpm@linux-foundation.org>
References: <bug-8940-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-bounces@lists.sourceforge.net>
In-Reply-To: <bug-8940-10286@http.bugzilla.kernel.org/>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-usb-devel>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-devel-bounces@lists.sourceforge.net
Errors-To: linux-usb-devel-bounces@lists.sourceforge.net
To: linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Cc: dchris@gmail.com, bugme-daemon@bugzilla.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 25 Aug 2007 09:47:40 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=8940
> 
>            Summary: BUG: unable to handle kernel NULL pointer dereference at
>                     virtual address 00000000
>            Product: Drivers
>            Version: 2.5
>      KernelVersion: 2.6.22.5
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: USB
>         AssignedTo: greg@kroah.com
>         ReportedBy: dchris@gmail.com
> 
> 
> Most recent kernel where this bug did not occur:
> Distribution: Kubuntu Gutsy
> Hardware Environment:
> Software Environment:
> Problem Description: I got this error message:
> BUG: unable to handle kernel NULL pointer dereference at virtual address
> 00000000
> in dmesg output when connecting a USB device. Turning off
> CONFIG_SCSI_SCAN_ASYNC fixed the problem. Apparently there is a bug in SCSI
> core code.
> 
> Steps to reproduce: I connected my MP4 player (which is not recognized) on USB.

The CONFIG_USB_DEBUG-enabled dmesg was attached to the report.

[  262.416000] usb-storage: scsi cmd done, result=0x70000
[  262.416000] usb-storage: *** thread sleeping.
[  262.416000] usb 5-3: USB disconnect, address 2
[  262.416000] PM: Removing info for No Bus:usbdev5.2_ep81
[  262.416000] PM: Removing info for No Bus:usbdev5.2_ep01
[  262.416000] usb-storage: storage_disconnect() called
[  262.416000] usb-storage: usb_stor_stop_transport called
[  262.416000] BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
[  262.416000]  printing eip:
[  262.416000] c025fec5
[  262.416000] *pde = 00000000
[  262.416000] Oops: 0000 [#1]
[  262.416000] SMP 
[  262.416000] Modules linked in: usb_storage ide_core libusual binfmt_misc rfcomm l2cap bluetooth capability commoncap radeon drm ipv6 acpi_cpufreq cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative video sbs button dock battery container ac af_packet fuse sbp2 parport_pc lp parport joydev snd_hda_intel snd_pcm_oss snd_pcm snd_mixer_oss snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event pcspkr ipw2200 ieee80211 ieee80211_crypt psmouse serio_raw snd_seq snd_timer snd_seq_device iTCO_wdt iTCO_vendor_support intel_agp snd soundcore snd_page_alloc shpchp pci_hotplug agpgart evdev ext3 jbd mbcache sg 8139too sr_mod cdrom sd_mod ata_piix ahci 8139cp mii ohci1394 ieee1394 ata_generic libata scsi_mod ehci_hcd uhci_hcd usbcore raid
 10 raid456 xor raid1 raid0 multipath linear md_mod dm_mirror dm_snapshot dm_mod thermal processor fan
[  262.416000] CPU:    0
[  262.416000] EIP:    0060:[<c025fec5>]    Not tainted VLI
[  262.416000] EFLAGS: 00010202   (2.6.22.1 #1)
[  262.416000] EIP is at make_class_name+0x35/0xa0
[  262.416000] eax: 00000000   ebx: ffffffff   ecx: ffffffff   edx: 0000000b
[  262.416000] esi: f88dd3c6   edi: 00000000   ebp: 00000000   esp: c1b9be58
[  262.416000] ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
[  262.416000] Process khubd (pid: 1971, ti=c1b9a000 task=dfc2b9a0 task.ti=c1b9a000)
[  262.416000] Stack: efedf208 f88f024c efedf200 efedf208 f88f01e0 c0260069 00000000 f88f02a8 
[  262.416000]        efedf200 eccce400 00000246 00000000 c02600f8 efedf000 f88d7180 efedf000 
[  262.416000]        eccce400 f88d46ab eccce430 eccce400 f88ce905 eccce6f8 ed541a18 f8c19540 
[  262.416000] Call Trace:
[  262.416000]  [<c0260069>] class_device_del+0x99/0x120
[  262.416000]  [<c02600f8>] class_device_unregister+0x8/0x10
[  262.416000]  [<f88d7180>] __scsi_remove_device+0x30/0x80 [scsi_mod]
[  262.416000]  [<f88d46ab>] scsi_forget_host+0x4b/0x60 [scsi_mod]
[  262.416000]  [<f88ce905>] scsi_remove_host+0x55/0xe0 [scsi_mod]
[  262.416000]  [<f8c024bd>] storage_disconnect+0x1d/0x30 [usb_storage]
[  262.416000]  [<f88b2ef0>] usb_unbind_interface+0x50/0xa0 [usbcore]
[  262.416000]  [<c025f538>] __device_release_driver+0x68/0xa0
[  262.416000]  [<c025f9a3>] device_release_driver+0x23/0x40
[  262.416000]  [<c025ee0c>] bus_remove_device+0x5c/0x90
[  262.416000]  [<c025cf70>] device_del+0x160/0x260
[  262.416000]  [<f88b018e>] usb_disable_device+0x7e/0xe0 [usbcore]
[  262.416000]  [<f88ac397>] usb_disconnect+0x97/0x130 [usbcore]
[  262.416000]  [<f88aca3f>] hub_thread+0x26f/0xc30 [usbcore]
[  262.416000]  [<c02f08da>] schedule+0x2ca/0x890
[  262.416000]  [<c013bcb0>] autoremove_wake_function+0x0/0x50
[  262.416000]  [<f88ac7d0>] hub_thread+0x0/0xc30 [usbcore]
[  262.416000]  [<c013b9f2>] kthread+0x42/0x70
[  262.416000]  [<c013b9b0>] kthread+0x0/0x70
[  262.416000]  [<c0105487>] kernel_thread_helper+0x7/0x10
[  262.416000]  =======================
[  262.416000] Code: ff ff 89 6c 24 10 31 ed 89 d9 89 74 24 08 89 c6 89 7c 24 0c 89 c7 89 e8 89 14 24 f2 ae f7 d1 49 8b 04 24 89 ca 89 d9 8b 38 89 e8 <f2> ae f7 d1 49 8d 44 0a 02 ba d0 00 00 00 e8 48 cf f1 ff 31 d2 
[  262.416000] EIP: [<c025fec5>] make_class_name+0x35/0xa0 SS:ESP 0068:c1b9be58

-------------------------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc.
Still grepping through log files to find problems?  Stop.
Now Search log events and configuration files using AJAX and a browser.
Download your FREE copy of Splunk now >>  http://get.splunk.com/
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
