From: scameron@beardog.cce.hp.com
Subject: Re: HPSA related kernel panic on boot in 3.15 rc1 on Proliant with P420i
Date: Mon, 14 Apr 2014 08:03:31 -0500
Message-ID: <20140414130331.GA21686@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:15114 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbaDNNE6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Apr 2014 09:04:58 -0400
Received: from g2t2352.austin.hp.com (g2t2352.austin.hp.com [15.217.128.51])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id 59B1F1D49
	for <linux-scsi@vger.kernel.org>; Mon, 14 Apr 2014 13:04:46 +0000 (UTC)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: darius.ski@gmail.com
Cc: scameron@beardog.cce.hp.com, linux-scsi@vger.kernel.org

On Mon, Apr 14, 2014 at 2:33 PM, Darius D. <darius.ski@gmail.com> wrote:
> Hi,
>
> on P420i (2GB FBWC) with latest(5.22?) FW, and 2 SSD smart path
> enabled RAID0 arrays (1 and 3 SSD), i get panic on initialization.
> What is sad, i can't capture complete stack trace and it is deep in
> kernel worker, but top items are:
>
> SA5_performant_intr_mask+0x30/0x30
> spin_unlock_irqrestore
> hpsa_unit_one
> local_pci_probe
> ... kthread worker stuff
>
>
> RIP is calc_bucket_map+0x30/0x3a.
>
>
> Anyone got idea what is going on? 3.14 was working fine with exact
> config, so i suspect it could be HPSA smart path code related.

Try the patch below, and see also: http://marc.info/?t=139701135500001&r=1&w=2

-- steve


>From f6b44f25c451d32cca5cf2e9825e0636132e69cf Mon Sep 17 00:00:00 2001
From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Date: Thu, 10 Apr 2014 16:44:59 -0500
Subject: [PATCH] hpsa: fix uninitialized variable in hpsa_put_ctlr_into_performant_mode()

Without this, you'll see a null pointer dereference in
hpsa_enter_performant_mode().

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 8cf4a0c..ef4dfdd 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -7463,6 +7463,10 @@ static void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h)
 	if (hpsa_simple_mode)
 		return;
 
+	trans_support = readl(&(h->cfgtable->TransportSupport));
+	if (!(trans_support & PERFORMANT_MODE))
+		return;
+
 	/* Check for I/O accelerator mode support */
 	if (trans_support & CFGTBL_Trans_io_accel1) {
 		transMethod |= CFGTBL_Trans_io_accel1 |
-- 
1.7.1

