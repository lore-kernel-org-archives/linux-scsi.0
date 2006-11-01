From: Andrew Morton <akpm@osdl.org>
Subject: Re: [Bugme-new] [Bug 7444] New: BUG on drive removal with
 pata_cmd64x
Date: Wed, 1 Nov 2006 12:02:58 -0800
Message-ID: <20061101120258.e7462f9f.akpm@osdl.org>
References: <200611011240.kA1Ceaj7025489@fire-2.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:15498 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S2992800AbWKAUDK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Nov 2006 15:03:10 -0500
In-Reply-To: <200611011240.kA1Ceaj7025489@fire-2.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>, jpw@wszib.edu.pl


Dunno if this is a scsi thing or an Alan thing.  But it is certainly a
thing!


On Wed, 1 Nov 2006 04:40:36 -0800
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=7444
> 
>            Summary: BUG on drive removal with pata_cmd64x
>     Kernel Version: 2.6.19-rc4-mm1
>             Status: NEW
>           Severity: normal
>              Owner: io_scsi@kernel-bugs.osdl.org
>          Submitter: jpw@wszib.edu.pl
> 
> 
> Most recent kernel where this bug did not occur: N/A
> Distribution: Ubuntu Dapper
> Hardware Environment: 
> IBM Thinkpad T40p + docking station mod. 2877. 
> The controller in question is located in the docking station
> 
> Software Environment:
> Ubuntu Dapper (reiserfs on /dev/sda3 + swap on /dev/sda2), kernel is compiled
> with pata_piix in, no 'old' ide drivers.
> Problem Description:
> The docking station I am using has a SiI (CMD) PCI0648 built in; it is used to
> drive a second CD drive that can be fitted into the dock. As the ultra-slim
> drives for ThinkPads are quite expensive and quite hard to get, ability to use a
> more standard drive (and therefore cheaper!) is most welcome.
> 
> As the previous ide driver for PCI0648 cannot be removed from the kernel in
> runtime, it makes the laptop impossible to undock without reboot.
> Current driver works well (I am able to read and burn DVDs at full speed);
> however it produces following BUG on remove:
> 
> ata5.00: disabled
> BUG: unable to handle kernel paging request at virtual address 00200200
>  printing eip:
> c02a1d56
> *pde = 00000000
> Oops: 0002 [#2]
> Modules linked in: pata_cmd64x nls_utf8 udf rfcomm l2cap bluetooth esp6 ah6
> michael_mic khazad wp512 arc4 tea sha512 md4 cast6 cast5 anubis tgr192 xt_limit
> xt_tcpudp iptable_mangle ipt_LOG ipt_MASQUERADE ip_nat ipt_TOS ipt_REJECT
> ip_conntrack_irc ip_conntrack_ftp xt_state ip_conntrack nfnetlink iptable_filter
> ip_tables x_tables capability commoncap ibm_acpi xfrm_user xfrm4_tunnel tunnel4
> ipcomp esp4 ah4 pcmcia deflate zlib_deflate zlib_inflate twofish twofish_common
> camellia serpent blowfish des cbc ecb blkcipher aes xcbc sha1 md5 crypto_null
> hmac crypto_hash cryptomgr crypto_algapi af_key ext3 jbd mbcache ipv6
> snd_intel8x0 snd_ac97_codec snd_ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm
> snd_timer ipw2100 yenta_socket snd snd_page_alloc ieee80211 ieee80211_crypt
> rsrc_nonstatic pcmcia_core e1000 sg sr_mod cdrom ehci_hcd uhci_hcd usbcore
> aic7xxx scsi_transport_spi sd_mod pata_oldpiix
> CPU:    0
> EIP:    0060:[<c02a1d56>]    Not tainted VLI
> EFLAGS: 00010002   (2.6.19-rc4-mm1 #1)
> EIP is at scsi_device_dev_release_usercontext+0x36/0x100
> eax: dffa8c90   ebx: dffa8c08   ecx: 00100100   edx: 00200200
> esi: 00000286   edi: dffa8c00   ebp: dffba414   esp: dff25d50
> ds: 007b   es: 007b   ss: 0068
> Process kacpi_notify (pid: 42, ti=dff24000 task=dffbd030 task.ti=dff24000)
> Stack: dffa8e64 c02a1d20 c03baaa0 dffba47c c012b7f2 dffa8cf8 c03bab08 c028d8b2
>        f88298ae dffa8cf8 c03bab08 c03baaa0 c01f18e9 dffa8d10 c01f1930 f7f50028
>        f76a9cb0 c01f1f45 dffa8c90 f7f50028 f76a9cb0 c02a137c 00000202 f7f50000
> Call Trace:
>  [<c012b7f2>] execute_in_process_context+0x22/0x70
>  [<c028d8b2>] device_release+0x12/0x70
>  [<c01f18e9>] kobject_cleanup+0x49/0x90
>  [<c01f1f45>] kref_put+0x35/0xa0
>  [<c029ea2f>] scsi_forget_host+0xf/0x50
>  [<c0298f72>] scsi_remove_host+0x32/0xb0
>  [<c02a5adc>] ata_host_remove+0x5c/0x110
>  [<c02a5baa>] ata_pci_remove_one+0x1a/0x40
>  [<c01fc8b6>] pci_device_remove+0x16/0x40
>  [<c028fdaf>] __device_release_driver+0x5f/0xc0
>  [<c02900a2>] device_release_driver+0x22/0x40
>  [<c028f6bb>] bus_remove_device+0x8b/0xa0
>  [<c028e146>] device_del+0x146/0x180
>  [<c028e188>] device_unregister+0x8/0x10
>  [<c01f9943>] pci_stop_dev+0x23/0x60
>  [<c01f99ac>] pci_stop_bus_device+0x2c/0x40
>  [<c0204473>] acpiphp_disable_slot+0x73/0x1a0
>  [<c020520c>] handle_hotplug_event_func+0xdc/0x1a0
>  [<c024c836>] hotplug_dock_devices+0x25/0xd1
>  [<c024cb19>] dock_notify+0xaf/0x139
>  [<c0236f28>] acpi_ev_notify_dispatch+0x49/0x52
>  [<c0231ea2>] acpi_os_execute_deferred+0x1c/0x25
>  [<c52bacc8>] 0xc52bacc8
> DWARF2 unwinder stuck at 0xc52bacc8
> Leftover inexact backtrace:
>  [<c012b4fa>] run_workqueue+0x5a/0xc0
>  [<c0231e86>] acpi_os_execute_deferred+0x0/0x25
>  [<c012b6de>] worker_thread+0xee/0x120
>  [<c0118e30>] default_wake_function+0x0/0x10
>  [<c012b5f0>] worker_thread+0x0/0x120
>  [<c012e5fc>] kthread+0xdc/0xe0
>  [<c012e520>] kthread+0x0/0xe0
>  [<c0103acf>] kernel_thread_helper+0x7/0x18
>  =======================
> Code: ff ff 89 1c 24 89 74 24 04 89 6c 24 0c 8b 68 64 8d 55 ec 9c 5e fa ff 82 58
> 01 00 00 8d 98 78 ff ff ff 8b 53 04 8b 88 78 ff ff ff <89> 0a 89 51 04 b9 00 01
> 10 00 c7 43 04 00 02 20 00 8d 58 80 8b
> EIP: [<c02a1d56>] scsi_device_dev_release_usercontext+0x36/0x100 SS:ESP
> 0068:dff25d50
> 
> and driver hangs in a non-functional state (neither removed nor active)
> HOWEVER,
> going to /sys/bus/scsi/devices/X:0:0:0/ and echo'ing 1 to delete triggers the
> same BUG; the drive disappears from the system correctly(!) and pata_cmd64x can
> be removed from system without further problems.
> 
> On a subsequent docking, the drive affected by the above bug appears to be
> confused and kernel complains about not being able to identify the drive,
> however, after a few attempts it manages to reset the drive.
> 


