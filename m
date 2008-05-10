From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: PROBLEM: linux-2.6.25.3, aha152x'->init suspiciously returned
	1, it should follow 0/-E convention
Date: Sat, 10 May 2008 14:08:40 -0500
Message-ID: <1210446520.4002.58.camel@localhost.localdomain>
References: <20080510103040.C7E891D652BF@mx.drokz.nl>
	 <1210426438.4002.1.camel@localhost.localdomain>
	 <20080510175450.B1F521D27F4D@mx.drokz.nl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:58482 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756296AbYEJTIo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 May 2008 15:08:44 -0400
In-Reply-To: <20080510175450.B1F521D27F4D@mx.drokz.nl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Frank de Jong <frapex@xs4all.nl>
Cc: linux-scsi@vger.kernel.org, Juergen Fischer <fischer@norbit.de>

On Sat, 2008-05-10 at 19:54 +0200, Frank de Jong wrote:
> Hello James,
> 
> Thank you for your quick solution. I implemented the solution and the 
> driver loads fine. Unloading the module gives me a kernel Oops.
> dmesg after loading the module:
> 
> aha152x: BIOS test: passed, 1 controller(s) configured
> aha152x: resetting bus...
> aha152x2: vital data: rev=1, io=0x340 (0x340/0x340), irq=9, scsiid=7, 
> reconnect=enabled, parity=enabled, synchronous=enabled, delay=1000, 
> extended translation=disabled
> aha152x2: trying software interrupt, ok.
> scsi2 : Adaptec 152x SCSI driver; $Revision: 2.7 $
> (scsi2:6:0) message sent incompletely (2/6)
> (scsi2:6:0) Synchronous Data Transfer Request was rejected
> (scsi2:6:0) inbound message (MESSAGE REJECT)
> scsi 2:0:6:0: Direct-Access     IOMEGA   ZIP 100          J.02 PQ: 0 ANSI: 2
> sd 2:0:6:0: [sde] Attached SCSI removable disk
> sd 2:0:6:0: Attached scsi generic sg4 type 0
> 
> after trying to unload the module:
> BUG: unable to handle kernel paging request at 00100100
> IP: [<fb9ff667>] :aha152x:aha152x_exit+0x47/0x6a
> *pde = 00000000
> Oops: 0000 [#1] PREEMPT SMP
> Modules linked in: aha152x(-) w83781d hwmon_vid tun ne 8390 bonding 
> usb_storage snd_usb_audio snd_usb_lib snd_rawmidi pwc snd_seq_device 
> compat_ioctl32 snd_hwdep videodev v4l1_compat 3c59x mii intel_agp 
> agpgart snd_pcm_oss snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd
> 
> Pid: 2837, comm: rmmod Not tainted (2.6.25.3 #1)
> EIP: 0060:[<fb9ff667>] EFLAGS: 00210212 CPU: 0
> EIP is at aha152x_exit+0x47/0x6a [aha152x]
> EAX: 00000001 EBX: 000ffdc4 ECX: f7c517a8 EDX: 00000001
> ESI: 00000000 EDI: 00000003 EBP: e7880000 ESP: e7881f58
>   DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process rmmod (pid: 2837, ti=e7880000 task=f27eb580 task.ti=e7880000)
> Stack: fba03700 c01419d2 31616861 00783235 e795ee70 c0157709 b7f24000 e79ae000
>         c0158271 ffffffff b7f25000 e79ae004 e795e370 b7f25000 e795e37c e795e370
>         009ae000 fba03700 00000880 e7881fa8 00000000 bf93ec20 bf93ec20 c0102faa
> Call Trace:
>   [<c01419d2>] sys_delete_module+0x112/0x1a0
>   [<c0157709>] remove_vma+0x39/0x50
>   [<c0158271>] do_munmap+0x181/0x1f0
>   [<c0102faa>] sysenter_past_esp+0x5f/0x85
>   [<c0490000>] rsc_parse+0x0/0x3c0

Pretty much guess it's unsafe use of list since aha152x_release() does a
list_del().

Try this (in addition to the other patch).

James

---

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index f5215fd..8bbbcf9 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -3914,9 +3914,9 @@ static int __init aha152x_init(void)
 
 static void __exit aha152x_exit(void)
 {
-	struct aha152x_hostdata *hd;
+	struct aha152x_hostdata *hd, *tmp;
 
-	list_for_each_entry(hd, &aha152x_host_list, host_list) {
+	list_for_each_entry_safe(hd, tmp, &aha152x_host_list, host_list) {
 		struct Scsi_Host *shost = container_of((void *)hd, struct Scsi_Host, hostdata);
 
 		aha152x_release(shost);


