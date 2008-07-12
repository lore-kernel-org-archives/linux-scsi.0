From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [Bugme-new] [Bug 11072] New: scsi-layer crash after usb storage
 device unplug
Date: Sat, 12 Jul 2008 06:05:25 -0700
Message-ID: <20080712060525.07b718da.akpm@linux-foundation.org>
References: <bug-11072-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <bug-11072-10286-V0hAGp6uBxO456/isadD/XN4h3HLQggn@public.gmane.org/>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: bugme-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org, Johannes Berg <johannes-cdvu00un1VgdHxzADdlk8Q@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Sat, 12 Jul 2008 01:50:37 -0700 (PDT) bugme-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=11072
> 
>            Summary: scsi-layer crash after usb storage device unplug
>            Product: Drivers
>            Version: 2.5
>      KernelVersion: 2.6.26-rc9-wl-12766-ga0b2a63-dirty
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: USB
>         AssignedTo: greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org
>         ReportedBy: johannes-cdvu00un1VgdHxzADdlk8Q@public.gmane.org
> 
> 
> Latest working kernel version: no idea, never saw this problem before with the
> same device, but the memory card is new
> Earliest failing kernel version: no idea either, current kernel is
> 2.6.26-rc9-wl-12766-ga0b2a63-dirty
> Distribution: debian/unstable
> Hardware Environment: powerbook 5,6
> Software Environment:
> Problem Description: SDHC card in USB reader wasn't responding, so I unplugged
> and got a null pointer deref
> 
> Steps to reproduce:
> I have no idea if I can reproduce this.
> 
> What I was doing is that I was trying to access an SDHC card in what is
> probably just an SD card reader, and the device wasn't responding. I tried this
> a few times, unplugging and re-plugging with card in it and hot-plugging the
> card instead of the reader.
> 
> At the last attempt, I let it sit there for a while until it gave up (you can
> see that in the log below, look at the timestamps) and then unplugged it.
> 
> [33118.974296] usb 2-2: new high speed USB device using ehci_hcd and address 12
> [33119.128004] PM: Adding info for usb:2-2
> [33119.149666] usb 2-2: configuration #1 chosen from 1 choice
> [33119.150212] PM: Adding info for usb:2-2:1.0
> [33119.164343] scsi9 : SCSI emulation for USB Mass Storage devices
> [33119.164963] PM: Adding info for scsi:host9
> [33119.165151] PM: Adding info for No Bus:host9
> [33119.179385] PM: Adding info for No Bus:usbdev2.12_ep01
> [33119.179584] PM: Adding info for No Bus:usbdev2.12_ep82
> [33119.179752] PM: Adding info for No Bus:usbdev2.12
> [33119.179993] PM: Adding info for No Bus:usbdev2.12_ep00
> [33119.180102] usb 2-2: New USB device found, idVendor=058f, idProduct=6362
> [33119.180112] usb 2-2: New USB device strings: Mfr=1, Product=2,
> SerialNumber=3
> [33119.180120] usb 2-2: Product: Mass Storage Device
> [33119.180125] usb 2-2: Manufacturer: Generic
> [33119.180130] usb 2-2: SerialNumber: 058F312D81B
> [33119.182913] usb-storage: device found at 12
> [33119.182923] usb-storage: waiting for device to settle before scanning
> [33124.175752] scsi 9:0:0:0: Direct-Access     Generic  USB SD Reader    1.00
> PQ: 0 ANSI: 0
> [33124.175817] PM: Adding info for scsi:target9:0:0
> [33124.184591] PM: Adding info for scsi:9:0:0:0
> [33124.184798] PM: Adding info for No Bus:9:0:0:0
> [33154.304287] usb 2-2: reset high speed USB device using ehci_hcd and address
> 12
> [33164.574363] usb 2-2: reset high speed USB device using ehci_hcd and address
> 12
> [33178.804363] sd 9:0:0:0: Device offlined - not ready after error recovery
> [33178.804448] sd 9:0:0:0: rejecting I/O to offline device
> [33178.804490] sd 9:0:0:0: rejecting I/O to offline device
> [33178.804522] sd 9:0:0:0: rejecting I/O to offline device
> [33178.804543] sd 9:0:0:0: [sda] READ CAPACITY failed
> [33178.804548] sd 9:0:0:0: [sda] Result: hostbyte=0x01 driverbyte=0x00
> [33178.804558] sd 9:0:0:0: [sda] Sense not available.
> [33178.804578] sd 9:0:0:0: rejecting I/O to offline device
> [33178.804599] sd 9:0:0:0: [sda] Write Protect is off
> [33178.804605] sd 9:0:0:0: [sda] Mode Sense: 00 00 00 00
> [33178.804611] sd 9:0:0:0: [sda] Assuming drive cache: write through
> [33178.804719] PM: Adding info for No Bus:sda
> [33178.805011] PM: Adding info for No Bus:8:0
> [33178.805147] sd 9:0:0:0: [sda] Attached SCSI removable disk
> [33178.805197] PM: Adding info for No Bus:9:0:0:0
> [33178.805358] PM: Adding info for No Bus:9:0:0:0
> [33178.914595] usb 2-2: USB disconnect, address 12
> [33178.915152] PM: Removing info for usb:2-2:1.0
> [33178.916008] Unable to handle kernel paging request for data at address
> 0x00000004
> [33178.916023] Faulting instruction address: 0xf283185c
> [33178.916038] Oops: Kernel access of bad area, sig: 11 [#1]
> [33178.916043] PREEMPT PowerMac
> [33178.916050] Modules linked in: nls_iso8859_15 nls_cp850 vfat fat sd_mod
> usb_storage scsi_mod af_packet b43 mac80211 cfg80211 binfmt_misc radeon drm
> hci_usb rfcomm l2cap bluetooth nls_utf8 hfsplus nls_base fuse dm_snapshot
> dm_mirror dm_log sha256_generic joydev appletouch arc4 usbhid snd_aoa_codec_tas
> snd_aoa_fabric_layout snd_aoa evdev snd_aoa_i2sbus snd_pcm_oss snd_mixer_oss
> snd_pcm snd_timer snd_page_alloc snd soundcore ohci1394 snd_aoa_soundbus
> ieee1394 ehci_hcd ohci_hcd usbcore ssb pcmcia yenta_socket rsrc_nonstatic
> pcmcia_core firmware_class uninorth_agp agpgart unix [last unloaded: cfg80211]
> [33178.916180] NIP: f283185c LR: f262b594 CTR: f2831820
> [33178.916187] REGS: c5cebcf0 TRAP: 0300   Not tainted 
> (2.6.26-rc9-wl-12766-ga0b2a63-dirty)
> [33178.916194] MSR: 00009032 <EE,ME,IR,DR>  CR: 28002028  XER: 20000000
> [33178.916212] DAR: 00000004, DSISR: 40000000
> [33178.916218] TASK = ecc4dca0[685] 'usb-stor-scan' THREAD: c5cea000
> [33178.916224] GPR00: 00000008 c5cebda0 ecc4dca0 ef9a24c0 00009032 eec528f0
> c5df0008 fffffffd 
> [33178.916244] GPR08: fffffffc c5df25b8 c03bbdcc 00000000 28002022 00000000
> 017b7584 017b72f8 
> [33178.916264] GPR16: 41400000 00240e64 00000000 00000001 c0631d1c ef86ffac
> eec528f0 00000000 
> [33178.916283] GPR24: c0047a10 00000000 f2630058 eec528f0 c5d44b08 eec52d24
> c5d44af0 c5df29e0 
> [33178.916305] NIP [f283185c] slave_alloc+0x3c/0x84 [usb_storage]
> [33178.916343] LR [f262b594] scsi_alloc_sdev+0x194/0x210 [scsi_mod]
> [33178.916404] Call Trace:
> [33178.916409] [c5cebdc0] [f262b594] scsi_alloc_sdev+0x194/0x210 [scsi_mod]
> [33178.916436] [c5cebdf0] [f262ba10] scsi_probe_and_add_lun+0x24c/0x9a0
> [scsi_mod]
> [33178.916462] [c5cebe80] [f262c4d8] __scsi_scan_target+0xf4/0x5cc [scsi_mod]
> [33178.916488] [c5cebf30] [f262ca18] scsi_scan_channel+0x68/0xa4 [scsi_mod]
> [33178.916515] [c5cebf50] [f262cb18] scsi_scan_host_selected+0xc4/0x144
> [scsi_mod]
> [33178.916541] [c5cebf80] [f2833f08] usb_stor_scan_thread+0x14c/0x190
> [usb_storage]
> [33178.916562] [c5cebfd0] [c0047a60] kthread+0x50/0x88
> [33178.916576] [c5cebff0] [c0012500] kernel_thread+0x44/0x60
> [33178.916593] Instruction dump:
> [33178.916600] 7c7f1b78 90010024 38000024 98030067 83a30000 80630004 3bbd0434
> 801d003c 
> [33178.916620] 813d0028 54009eba 7d290214 816901fc <a00b0004> 5404c23e 5004442e
> 5484043e 
> [33178.916700] ---[ end trace 9617137d6c0f182d ]---
> 
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
