From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: aha152x(_cs) oops
Date: Thu, 13 Apr 2006 09:36:15 -0700
Message-ID: <20060413093615.661b7018.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:26849 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S1751082AbWDMQds (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Apr 2006 12:33:48 -0400
Received: from midway.site ([71.111.157.99]) by xenotime.net for <linux-scsi@vger.kernel.org>; Thu, 13 Apr 2006 09:33:47 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>


Is aha152x(_cs) known not to work with highmem or is it just busted
in its use of s/g list handling?
This is 2.6.17-rc1-git7 on a Dell notebook with 2 GB RAM.

On all recent kernels, I get an Oops in aha152x.c:datao_run(),
where the SG_ADDRESS() macro uses page_address().

[42949628.890000] BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
[42949628.890000]  printing eip:
[42949628.890000] f8d033ea
[42949628.890000] *pde = 00000000
[42949628.890000] Oops: 0000 [#1]
[42949628.890000] SMP DEBUG_PAGEALLOC
[42949628.890000] Modules linked in: aha152x_cs snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device usbhid usbmouse pcmcia ipw2200 ieee80211 ieee80211_crypt snd_intel8x0 snd_ac97_codec snd_ac97_bus snd_pcm yenta_socket rsrc_nonstatic pcmcia_core snd_timer snd soundcore snd_page_alloc
[42949628.890000] CPU:    0
[42949628.890000] EIP:    0060:[<f8d033ea>]    Not tainted VLI
[42949628.890000] EFLAGS: 00010206   (2.6.17-rc1-git7 #1) 
[42949628.890000] EIP is at datao_run+0xc4/0x1dd [aha152x_cs]
[42949628.890000] eax: f1f7ceb4   ebx: f794db20   ecx: 00000040   edx: 00000356
[42949628.890000] esi: 00000000   edi: 00000040   ebp: c2569f28   esp: c2569f0c
[42949628.890000] ds: 007b   es: 007b   ss: 0068
[42949628.890000] Process events/0 (pid: 5, threadinfo=c2568000 task=c2556af0)
[42949628.890000] Stack: <0>00000000 00000282 00000282 00000340 f794db20 00000001 f794d7f8 c2569f58 
[42949628.890000]        f8d02e48 f794d7f8 0000034c f794db30 00000001 ffffeec9 00000042 f8d06730 
[42949628.890000]        f8d06700 f8d06704 c25234f0 c2569f7c c012611b 00000000 00000292 f8d02acd


The Oops disappears if I prevent the driver from using highmem (force
bounces to lowmem) the same way that the imm driver does it.  (patch below)
What is the correct way to fix this?

Thanks,
---
~Randy


From: Randy Dunlap <rdunlap@xenotime.net>

Prevent highmem usage, bounce all buffers to lowmem,
to prevent Oops in S/G list handling.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/scsi/aha152x.c |   11 +++++++++++
 1 files changed, 11 insertions(+)

--- linux-2617-rc1g7.orig/drivers/scsi/aha152x.c
+++ linux-2617-rc1g7/drivers/scsi/aha152x.c
@@ -3479,6 +3479,12 @@ static int aha152x_proc_info(struct Scsi
 	return thislength < length ? thislength : length;
 }
 
+static int aha152x_adjust_queue(struct scsi_device *device)
+{
+	blk_queue_bounce_limit(device->request_queue, BLK_BOUNCE_HIGH);
+	return 0;
+}
+
 static struct scsi_host_template aha152x_driver_template = {
 	.module				= THIS_MODULE,
 	.name				= AHA152X_REVID,
@@ -3495,6 +3501,11 @@ static struct scsi_host_template aha152x
 	.sg_tablesize			= SG_ALL,
 	.cmd_per_lun			= 1,
 	.use_clustering			= DISABLE_CLUSTERING,
+	.slave_alloc			= aha152x_adjust_queue,
+	.unchecked_isa_dma		= 1, /* driver cannot deal with
+					* highmem, so this is an easy trick
+					* to ensure all IO pages for this
+					* host reside in low memory */
 };
 
 #if !defined(PCMCIA)
