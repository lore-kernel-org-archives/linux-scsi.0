From: Michael Chapman <mike@very.puzzling.org>
Subject: megaraid_sas: Memory corruption with STP commands
Date: Sun, 13 Nov 2011 21:03:35 +1100 (EST)
Message-ID: <alpine.LFD.2.02.1111132100070.6318@beren.home>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fallbackmx10.syd.optusnet.com.au ([211.29.132.251]:57280 "EHLO
	fallbackmx10.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751844Ab1KMKEu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Nov 2011 05:04:50 -0500
Received: from mail36.syd.optusnet.com.au (mail36.syd.optusnet.com.au [211.29.133.76])
	by fallbackmx10.syd.optusnet.com.au (8.13.1/8.13.1) with ESMTP id pADA4nA5011566
	for <linux-scsi@vger.kernel.org>; Sun, 13 Nov 2011 21:04:49 +1100
Received: from very.puzzling.org (spdax1-123.dialup.optusnet.com.au [198.142.4.123])
	by mail36.syd.optusnet.com.au (8.13.1/8.13.1) with ESMTP id pADA3ZpK030320
	for <linux-scsi@vger.kernel.org>; Sun, 13 Nov 2011 21:03:36 +1100
Received: from localhost (localhost [127.0.0.1])
	by very.puzzling.org (Postfix) with ESMTP id 312C1408D0
	for <linux-scsi@vger.kernel.org>; Sun, 13 Nov 2011 21:03:35 +1100 (EST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all,

I've just spent some time tracking down a memory corruption issue on some 
Dell PowerEdge R510 servers. The corruption consisted of the first 20 
bytes of random kernel memory pages being overwritten with zeroes.

All of the affected servers contained PERC H700 Integrated RAID 
controllers. Significantly, these servers also had SATA SSDs for use with 
MegaRAID CacheCade. Other servers with the same controller but no 
CacheCade (and thus had only SAS drives attached) were not exhibiting the 
memory corruption.

I tracked down the problem to particular Serial Tunneling Protocol 
commands sent from MegaCli 8.01.06 through the megaraid_sas driver. 
MegaCli 8.02.16 does not send these commands, so it doesn't hit the bug.

It looks like for these commands only MegaCli sets the MFI_FRAME_IEEE flag 
in the STP command frame. however megasas_mgmt_fw_ioctl explicitly sets up 
a 32-bit scatter/gather list for the command. The card seemingly 
misinterprets the 32-bit DMA address and length of (at least) the first 
element of this list as a 64-bit address instead, and overwrites the wrong 
page in memory.

Since the driver is always using 32-bit DMA addresses for these commands, 
would it be a good idea to explicitly mask out the 64-bit address flags? I 
have run some tests with patch below, and no corruption has been seen 
since.

On a somewhat related note, this part of the megaraid_sas driver seems to 
make use of a few address offsets from userspace without any validation, 
e.g. ioc->sgl_off and ioc->sense_off. I suppose it's not too much of an 
issue as the device node is only usable by root, but should these 
offsets be checked nevertheless to make sure they're only pointing within 
the command frame?

- Michael


--- megaraid_sas-v00.00.05.40.orig/megaraid_sas_base.c	2011-07-16 08:01:59.000000000 +1000
+++ megaraid_sas-v00.00.05.40/megaraid_sas_base.c	2011-11-10 11:09:23.461592780 +1100
@@ -5994,6 +5994,7 @@ megasas_mgmt_fw_ioctl(struct megasas_ins
  	memcpy(cmd->frame, ioc->frame.raw, 2 * MEGAMFI_FRAME_SIZE);
  	cmd->frame->hdr.context = cmd->index;
  	cmd->frame->hdr.pad_0 = 0;
+	cmd->frame->hdr.flags &= ~(MFI_FRAME_SGL64 | MFI_FRAME_SENSE64 | MFI_FRAME_IEEE);

  	/*
  	 * The management interface between applications and the fw uses

