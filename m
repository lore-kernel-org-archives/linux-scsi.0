From: Andrew Morton <akpm@osdl.org>
Subject: Re: 2.6.19-rc5-mm1
Date: Wed, 8 Nov 2006 16:18:51 -0800
Message-ID: <20061108161851.59040a27.akpm@osdl.org>
References: <20061108015452.a2bb40d2.akpm@osdl.org>
	<f56c1ba00611081555t26820da8tf0132f0e5d325712@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:9426 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1161768AbWKIATK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Nov 2006 19:19:10 -0500
In-Reply-To: <f56c1ba00611081555t26820da8tf0132f0e5d325712@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q? C=E9dric?= Augonnet <cedric.augonnet@gmail.com>
Cc: linux-usb-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org


(added linux-scsi.  I think we had one such report against rc4-mm2 as well).

On Thu, 9 Nov 2006 00:55:43 +0100
"C__dric Augonnet" <cedric.augonnet@gmail.com> wrote:

> Hi,
> 
> I am having this oops each time I unplug my USB external hard drive.
> It only appeared on 2.6.19-rc5-mm1, and did not occured on
> 2.6.19-rc4-mm2. I am enclosing my .config and the dmesg output.
> 
> Regards,
> C__dric
> 
> usb 5-4: new high speed USB device using ehci_hcd and address 3
> usb 5-4: new device found, idVendor=067b, idProduct=2507
> usb 5-4: new device strings: Mfr=1, Product=2, SerialNumber=3
> usb 5-4: Product: Mass Storage Device
> usb 5-4: Manufacturer: Prolific Technology Inc.
> usb 5-4: SerialNumber: 0
> usb 5-4: configuration #1 chosen from 1 choice
> usbcore: registered new interface driver libusual
> Initializing USB Mass Storage driver...
> scsi2 : SCSI emulation for USB Mass Storage devices
> usb-storage: device found at 3
> usb-storage: waiting for device to settle before scanning
> usbcore: registered new interface driver usb-storage
> USB Mass Storage support registered.
> scsi 2:0:0:0: Direct-Access     SAMSUNG  SP2514N          VF10 PQ: 0 ANSI: 0
> SCSI device sdb: 488397167 512-byte hdwr sectors (250059 MB)
> sdb: Write Protect is off
> sdb: Mode Sense: 03 00 00 00
> sdb: assuming drive cache: write through
> SCSI device sdb: 488397167 512-byte hdwr sectors (250059 MB)
> sdb: Write Protect is off
> sdb: Mode Sense: 03 00 00 00
> sdb: assuming drive cache: write through
>  sdb: sdb1
> sd 2:0:0:0: Attached scsi disk sdb
> usb-storage: device scan complete
> usb 5-4: USB disconnect, address 3
> BUG: unable to handle kernel paging request at virtual address 00100104
>  printing eip:
> c021c8ef
> *pde = 00000000
> Oops: 0002 [#1]
> last sysfs file: /class/net/lan/carrier
> Modules linked in: nls_iso8859_15 nls_cp850 usb_storage libusual
> radeon drm cpufreq_ondemand thermal fan button processor ac battery
> af_packet vfat fat hdaps pcmcia crc32 irtty_sir sir_dev sr_mod
> nsc_ircc cdrom ipw2200 irda ieee80211 ieee80211_crypt crc_ccitt
> firmware_class snd_intel8x0m snd_intel8x0 snd_ac97_codec snd_ac97_bus
> ehci_hcd snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd yenta_socket
> rsrc_nonstatic pcmcia_core tg3 rtc uhci_hcd pcspkr i2c_i801 usbcore
> intel_agp agpgart soundcore snd_page_alloc unix
> CPU:    0
> EIP:    0060:[<c021c8ef>]    Not tainted VLI
> EFLAGS: 00010002   (2.6.19-rc5-mm1=porcinet #3)
> EIP is at scsi_device_dev_release_usercontext+0x2f/0xe0
> eax: 00200200   ebx: df970008   ecx: 00100100   edx: df970090
> esi: 00000286   edi: df970000   ebp: dfbe9414   esp: df64bde8
> ds: 007b   es: 007b   ss: 0068
> Process khubd (pid: 1128, ti=df64a000 task=df43fab0 task.ti=df64a000)
> Stack: 00000286 df970264 c03049dc c0304980 dfbe947c c012418b df970090 df9700f8
>        c021ba13 c021c8c0 df970090 df970264 c01ba0d9 df970090 df970110 c01ba100
>        df7fd028 c173ac58 c01bac71 df9700f8 c0212818 df970090 c021281b df970000
> Call Trace:
>  [<c012418b>] execute_in_process_context+0x25/0x55
>  [<c021ba13>] scsi_device_dev_release+0x21/0x25
>  [<c01ba0d9>] kobject_cleanup+0x45/0x6c
>  [<c01bac71>] kref_put+0x80/0x8f
>  [<c01ba091>] kobject_put+0x1e/0x21
>  [<c021b724>] scsi_forget_host+0x26/0x3f
>  [<c0214f94>] scsi_remove_host+0x5e/0xd6
>  [<e0a957b5>] quiesce_and_remove_host+0x75/0x78 [usb_storage]
>  [<e0a95897>] storage_disconnect+0x12/0x1a [usb_storage]
>  [<e08c8416>] usb_unbind_interface+0x35/0x74 [usbcore]
>  [<c020f988>] __device_release_driver+0x88/0xa0
>  [<c020fda3>] device_release_driver+0x24/0x39
>  [<c020f318>] bus_remove_device+0x86/0x9e
>  [<c020dc0e>] device_del+0x15b/0x1cb
>  [<e08c6113>] usb_disable_device+0x72/0xdd [usbcore]
>  [<e08c2ec7>] usb_disconnect+0x9c/0xee [usbcore]
>  [<e08c3af9>] hub_thread+0x30d/0xa13 [usbcore]
>  [<c0126ee3>] kthread+0xb8/0xe1
>  [<c0103873>] kernel_thread_helper+0x7/0x10
> DWARF2 unwinder stuck at kernel_thread_helper+0x7/0x10
> Leftover inexact backtrace:
>  =======================
> Code: 83 ec 04 8b 54 24 18 8b 6a 64 8d ba 70 ff ff ff 8d 45 ec 9c 5e
> fa ff 80 58 01 00 00 8d 9a 78 ff ff ff 8b 43 04 8b 8a 78 ff ff ff <89>
> 41 04 89 08 c7 43 04 00 02 20 00 8d 5a 80 8b 4a 80 8b 43 04
> EIP: [<c021c8ef>] scsi_device_dev_release_usercontext+0x2f/0xe0 SS:ESP
> 0068:df64bde8
> 
