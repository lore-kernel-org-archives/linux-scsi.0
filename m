From: Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>
Subject: Re: [PATCH] fix dma mapping leak in fusion
Date: Thu, 19 Aug 2004 12:01:11 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200408190301.AA03490@fukuchi.jp.fujitsu.com>
References: <20040817161642.GA16509@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46467 "EHLO
	fgwmail5.fujitsu.co.jp") by vger.kernel.org with ESMTP
	id S267930AbUHSDBI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Aug 2004 23:01:08 -0400
Received: from m5.gw.fujitsu.co.jp ([10.0.50.75]) by fgwmail5.fujitsu.co.jp (8.12.10/Fujitsu Gateway)
	id i7J316JB010166 for <linux-scsi@vger.kernel.org>; Thu, 19 Aug 2004 12:01:06 +0900
	(envelope-from fukuchi.masao@jp.fujitsu.com)
Received: from s5.gw.fujitsu.co.jp by m5.gw.fujitsu.co.jp (8.12.10/Fujitsu Domain Master)
	id i7J315mZ002977 for <linux-scsi@vger.kernel.org>; Thu, 19 Aug 2004 12:01:05 +0900
	(envelope-from fukuchi.masao@jp.fujitsu.com)
Received: from fjmail503.fjmail.jp.fujitsu.com (fjmail503-0.fjmail.jp.fujitsu.com [10.59.80.100]) by s5.gw.fujitsu.co.jp (8.12.11)
	id i7J3151c017971 for <linux-scsi@vger.kernel.org>; Thu, 19 Aug 2004 12:01:05 +0900
	(envelope-from fukuchi.masao@jp.fujitsu.com)
Received: from fukuchi.jp.fujitsu.com
 (fjscan501-0.fjmail.jp.fujitsu.com [10.59.80.120])
 by fjmail503.fjmail.jp.fujitsu.com
 (Sun Internet Mail Server sims.4.0.2001.07.26.11.50.p9)
 with SMTP id <0I2O005Z8B1SE3@fjmail503.fjmail.jp.fujitsu.com> for
 linux-scsi@vger.kernel.org; Thu, 19 Aug 2004 12:01:04 +0900 (JST)
In-reply-to: <20040817161642.GA16509@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: moore@lsil.com, linux-scsi@vger.kernel.org

Hi Christoph,

I applyed attached patch into latest fusion MPT driver(3.01.15) and
tested it, but I still met Oops.
Then I also applyed your latest patch(it gets rid of the fusion pendingQ
in favour of using the scsi midlayer queuing), but I met Oops again.
 
Thanks,
Masao Fukuchi

///
Environment:
  Host: Intel Tiger4
  Kernel: 2.6.7
  Fusion MPT driver: 3.01.15 

Test:
  Fix ACK signal to low level and issuing read command from host.
  (this causes command timeout)

Oops message is:
 08:31:12 kernel: mptscsih: ioc3: >> Attempting task abort! (sc=e00000007c1c2480)
 08:31:12 kernel: mptscsih: ioc3: >> Attempting target reset! (sc=e00000007c1c2480)
 08:31:12 kernel: mptscsih: ioc3: >> Attempting bus reset! (sc=e00000007c1c2480)
 08:31:14 kernel: mptbase: Initiating ioc3 recovery
 08:31:39 kernel: mptscsih: ioc3: >> Attempting task abort! (sc=e00000007c1c2480)
 08:31:39 kernel: mptscsih: ioc3: >> Attempting host reset! (sc=e00000007c1c2480)
 08:31:39 kernel: mptbase: Initiating ioc3 recovery
 08:32:04 kernel: mptscsih: ioc3: >> Attempting task abort! (sc=e00000007c1c2480)
 08:32:04 kernel: scsi: Device offlined - not ready after error recovery: host 3 channel 0 id 1 lun 0
 08:32:04 kernel: scsi3 (1:0): rejecting I/O to offline device
 08:32:04 kernel: Buffer I/O error on device sdb, logical block 0
 08:32:04 kernel: Buffer I/O error on device sdb, logical block 1
 08:32:04 kernel: Buffer I/O error on device sdb, logical block 2
 08:32:04 kernel: Buffer I/O error on device sdb, logical block 3
 08:32:04 kernel: Buffer I/O error on device sdb, logical block 4
 08:32:04 kernel: Buffer I/O error on device sdb, logical block 5
 08:32:04 kernel: Buffer I/O error on device sdb, logical block 6
 08:32:04 kernel: Buffer I/O error on device sdb, logical block 7
 08:32:04 kernel: scsi3 (1:0): rejecting I/O to offline device
 08:32:04 kernel: Buffer I/O error on device sdb, logical block 0
 08:32:04 kernel: Buffer I/O error on device sdb, logical block 1
 08:32:06 kernel: mptbase: Initiating ioc3 recovery
 08:32:07 kernel: Unable to handle kernel NULL pointer dereference (address 0000000000000000)
 08:32:07 kernel: events/0[4]: Oops 8813272891392 [1]
 08:32:07 kernel: Modules linked in: ide_cd cdrom md5 ipv6 button autofs ohci1394 ieee1394 e1000 nls_iso8859_1 nls_cp437  
vfat fat mptscsih mptbase sd_mod scsi_mod 
 08:32:07 kernel:
 08:32:07 kernel: Pid: 4, CPU 0, comm:             events/0
 08:32:07 kernel: psr : 0000101008026018 ifs : 800000000000050e ip  : [<a00000010023ffe0>]    Tainted: GF
 08:32:07 kernel: ip is at swiotlb_unmap_sg+0xa0/0x220
 08:32:07 kernel: unat: 0000000000000000 pfs : 0000000000000b1a rsc : 0000000000000003
 08:32:07 kernel: rnat: 0000000000000996 bsps: 0000000000000003 pr  : 00000000056aaa55
 08:32:07 kernel: ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c8a70433f
 08:32:07 kernel: csd : 0000000000000000 ssd : 0000000000000000
 08:32:07 kernel: b0  : a0000002000bdb20 b6  : a00000010023e040 b7  : a00000010023ff40
 08:32:07 kernel: f6  : 1003e0000000000000091 f7  : 0ffe8b9dd00ec00000000
 08:32:07 kernel: f8  : 1003e0000000000003660 f9  : 1003e0000000000000060
 08:32:07 kernel: f10 : 1003e000000000013c680 f11 : 1003e0000000000000510
 08:32:07 kernel: r1  : a0000001009d83f0 r2  : e00000007c847da0 r3  : a0000002000cfe80
 08:32:07 kernel: r8  : 0000000000000091 r9  : a000000100804200 r10 : 6db6db6db6db6db7
 08:32:07 kernel: r11 : e00000007c162000 r12 : e00000007c847d90 r13 : e00000007c840000
 08:32:07 kernel: r14 : a0007fffff900000 r15 : 0000000000003660 r16 : a0000001007f0788
 08:32:07 kernel: r17 : 0000000000000010 r18 : e00000007c1c2558 r19 : a00000010023ff40
 08:32:07 kernel: r20 : a000000100662a28 r21 : 0000000000000000 r22 : 0000000000000000
 08:32:07 kernel: r23 : 0000000000000000 r24 : 0000000000000000 r25 : 0000000000000000
 08:32:07 kernel: r26 : 0000000000000000 r27 : 0000001008026018 r28 : a0000002000a9150
 08:32:07 kernel: r29 : 0000000000000000 r30 : 0000000000000000 r31 : e0000000049018f4
 08:32:07 kernel:
 08:32:07 kernel: Call Trace:
 08:32:07 kernel:  [<a000000100019d20>] show_stack+0x80/0xa0
 08:32:07 kernel:                                 sp=e00000007c847960 bsp=e00000007c841430
 08:32:07 kernel:  [<a000000100040250>] die+0x1d0/0x280
 08:32:07 kernel:                                 sp=e00000007c847b30 bsp=e00000007c841408
 08:32:08 kernel:  [<a000000100062620>] ia64_do_page_fault+0x380/0x980
 08:32:08 kernel:                                 sp=e00000007c847b30 bsp=e00000007c8413a0
 08:32:08 kernel:  [<a000000100012380>] ia64_leave_kernel+0x0/0x260
 08:32:08 kernel:                                 sp=e00000007c847bc0 bsp=e00000007c8413a0
 08:32:08 kernel:  [<a00000010023ffe0>] swiotlb_unmap_sg+0xa0/0x220
 08:32:08 kernel:                                 sp=e00000007c847d90 bsp=e00000007c841330
 08:32:08 kernel:  [<a0000002000bdb20>] mptscsih_flush_running_cmds+0x180/0x440 [mptscsih]
 08:32:08 kernel:                                 sp=e00000007c847da0 bsp=e00000007c841280
 08:32:08 kernel:  [<a0000002000c2ad0>] mptscsih_ioc_reset+0x390/0x460 [mptscsih]
 08:32:08 kernel:                                 sp=e00000007c847da0 bsp=e00000007c841248
 08:32:08 kernel:  [<a0000002000a4300>] mpt_diag_reset+0xd20/0xe00 [mptbase]
 08:32:08 kernel:                                 sp=e00000007c847da0 bsp=e00000007c8411a8
 08:32:08 kernel:  [<a0000002000a3240>] KickStart+0x60/0x400 [mptbase]
 08:32:08 kernel:                                 sp=e00000007c847da0 bsp=e00000007c841140
 08:32:08 kernel:  [<a0000002000a1040>] MakeIocReady+0x1a0/0x660 [mptbase]
 08:32:08 kernel:                                 sp=e00000007c847da0 bsp=e00000007c8410c0
 08:32:08 kernel:  [<a00000020009f880>] mpt_do_ioc_recovery+0x140/0xbc0 [mptbase]
 08:32:08 kernel:                                 sp=e00000007c847db0 bsp=e00000007c841048
 08:32:08 kernel:  [<a0000002000aa960>] mpt_HardResetHandler+0x200/0x3c0 [mptbase]
 08:32:08 kernel:                                 sp=e00000007c847db0 bsp=e00000007c840ff0
 08:32:08 kernel:  [<a0000002000c4980>] mptscsih_schedule_reset+0x40/0xc0 [mptscsih]
 08:32:08 kernel:                                 sp=e00000007c847db0 bsp=e00000007c840fd0
 08:32:08 kernel:  [<a0000001000c3950>] worker_thread+0x410/0x5e0
 08:32:08 kernel:                                 sp=e00000007c847db0 bsp=e00000007c840f38
 08:32:08 kernel:  [<a0000001000cce40>] kthread+0x180/0x1a0
 08:32:08 kernel:                                 sp=e00000007c847e20 bsp=e00000007c840f08
 08:32:08 kernel:  [<a00000010001bcc0>] kernel_thread_helper+0xe0/0x100
 08:32:08 kernel:                                 sp=e00000007c847e30 bsp=e00000007c840ee0
 08:32:08 kernel:  [<a0000001000090a0>] start_kernel_thread+0x20/0x40
 08:32:08 kernel:                                 sp=e00000007c847e30 bsp=e00000007c840ee0


Christoph Hellwig wrote:
>stop fusion from leaking dma maps when the device has been offlined
>
>
>--- 1.13/drivers/message/fusion/linux_compat.h	2004-06-23 16:48:43 +02:00
>+++ edited/drivers/message/fusion/linux_compat.h	2004-08-17 20:09:21 +02:00
>@@ -3,16 +3,4 @@
> #ifndef FUSION_LINUX_COMPAT_H
> #define FUSION_LINUX_COMPAT_H
> 
>-#include <linux/version.h>
>-#include <scsi/scsi_device.h>
>-
>-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,6))
>-static int inline scsi_device_online(struct scsi_device *sdev)
>-{
>-	return sdev->online;
>-}
>-#endif
>-
>-
>-/*}-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
> #endif /* _LINUX_COMPAT_H */
>===== drivers/message/fusion/mptscsih.c 1.45 vs edited =====
>--- 1.45/drivers/message/fusion/mptscsih.c	2004-08-03 01:01:01 +02:00
>+++ edited/drivers/message/fusion/mptscsih.c	2004-08-17 20:02:54 +02:00
>@@ -1019,19 +1019,18 @@
> 			 * Do OS callback
> 			 * Free driver resources (chain, msg buffers)
> 			 */
>-			if (scsi_device_online(SCpnt->device)) {
>-				if (SCpnt->use_sg) {
>-					pci_unmap_sg(ioc->pcidev,
>-						(struct scatterlist *) SCpnt->request_buffer,
>-						SCpnt->use_sg,
>-						SCpnt->sc_data_direction);
>-				} else if (SCpnt->request_bufflen) {
>-					pci_unmap_single(ioc->pcidev,
>-						SCpnt->SCp.dma_handle,
>-						SCpnt->request_bufflen,
>-						SCpnt->sc_data_direction);
>-				}
>+			if (SCpnt->use_sg) {
>+				pci_unmap_sg(ioc->pcidev,
>+					(struct scatterlist *) SCpnt->request_buffer,
>+					SCpnt->use_sg,
>+					SCpnt->sc_data_direction);
>+			} else if (SCpnt->request_bufflen) {
>+				pci_unmap_single(ioc->pcidev,
>+					SCpnt->SCp.dma_handle,
>+					SCpnt->request_bufflen,
>+					SCpnt->sc_data_direction);
> 			}
>+
> 			SCpnt->result = DID_RESET << 16;
> 			SCpnt->host_scribble = NULL;
> 
>-
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
