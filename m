Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDCC7C433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Jan 2021 16:55:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B408922B30
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Jan 2021 16:55:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbhAJQzy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Jan 2021 11:55:54 -0500
Received: from mxout02.lancloud.ru ([45.84.86.82]:43836 "EHLO
        mxout02.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbhAJQzx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Jan 2021 11:55:53 -0500
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout02.lancloud.ru 7502B2311A1D
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: [PATCH 3/3] aha1542: fix multi-line comment style
From:   Sergey Shtylyov <s.shtylyov@omprussia.ru>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
References: <2726d35a-ac66-fae9-51e7-ea4f13e89fd7@omprussia.ru>
Organization: Open Mobile Platform, LLC
Message-ID: <08c231e5-d86f-9d0b-19ac-ad46fa0c0b58@omprussia.ru>
Date:   Sun, 10 Jan 2021 19:49:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <2726d35a-ac66-fae9-51e7-ea4f13e89fd7@omprussia.ru>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1908.lancloud.ru (fd00:f066::208)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some comments in this driver don't comply with the preferred multi-line
comment style, as reported by 'scripts/checkpatch.pl':

WARNING: Block comments use * on subsequent lines
WARNING: Block comments use a trailing */ on a separate line

Fix those comments, along with the (unreported for some reason?) starts
of the multi-line comments not being /* on their own line... 

Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>

---
 drivers/scsi/aha1542.c |  119 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 75 insertions(+), 44 deletions(-)

Index: scsi/drivers/scsi/aha1542.c
===================================================================
--- scsi.orig/drivers/scsi/aha1542.c
+++ scsi/drivers/scsi/aha1542.c
@@ -119,8 +119,10 @@ static int aha1542_out(unsigned int base
 	return 0;
 }
 
-/* Only used at boot time, so we do not need to worry about latency as much
-   here */
+/*
+ * Only used at boot time, so we do not need to worry about latency as much
+ * here
+ */
 
 static int aha1542_in(unsigned int base, u8 *buf, int len, int timeout)
 {
@@ -142,35 +144,43 @@ static int makecode(unsigned hosterr, un
 		break;
 
 	case 0x11:		/* Selection time out-The initiator selection or target
-				   reselection was not complete within the SCSI Time out period */
+				 * reselection was not complete within the SCSI Time out period
+				 */
 		hosterr = DID_TIME_OUT;
 		break;
 
 	case 0x12:		/* Data overrun/underrun-The target attempted to transfer more data
-				   than was allocated by the Data Length field or the sum of the
-				   Scatter / Gather Data Length fields. */
+				 * than was allocated by the Data Length field or the sum of the
+				 * Scatter / Gather Data Length fields.
+				 */
 
 	case 0x13:		/* Unexpected bus free-The target dropped the SCSI BSY at an unexpected time. */
 
 	case 0x15:		/* MBO command was not 00, 01 or 02-The first byte of the CB was
-				   invalid. This usually indicates a software failure. */
+				 * invalid. This usually indicates a software failure.
+				 */
 
 	case 0x16:		/* Invalid CCB Operation Code-The first byte of the CCB was invalid.
-				   This usually indicates a software failure. */
+				 * This usually indicates a software failure.
+				 */
 
 	case 0x17:		/* Linked CCB does not have the same LUN-A subsequent CCB of a set
-				   of linked CCB's does not specify the same logical unit number as
-				   the first. */
+				 * of linked CCB's does not specify the same logical unit number as
+				 * the first.
+				 */
 	case 0x18:		/* Invalid Target Direction received from Host-The direction of a
-				   Target Mode CCB was invalid. */
+				 * Target Mode CCB was invalid.
+				 */
 
 	case 0x19:		/* Duplicate CCB Received in Target Mode-More than once CCB was
-				   received to service data transfer between the same target LUN
-				   and initiator SCSI ID in the same direction. */
+				 * received to service data transfer between the same target LUN
+				 * and initiator SCSI ID in the same direction.
+				 */
 
 	case 0x1a:		/* Invalid CCB or Segment List Parameter-A segment list with a zero
-				   length segment or invalid segment list boundaries was received.
-				   A CCB parameter was invalid. */
+				 * length segment or invalid segment list boundaries was received.
+				 * A CCB parameter was invalid.
+				 */
 #ifdef DEBUG
 		printk("Aha1542: %x %x\n", hosterr, scsierr);
 #endif
@@ -178,9 +188,10 @@ static int makecode(unsigned hosterr, un
 		break;
 
 	case 0x14:		/* Target bus phase sequence failure-An invalid bus phase or bus
-				   phase sequence was requested by the target. The host adapter
-				   will generate a SCSI Reset Condition, notifying the host with
-				   a SCRD interrupt */
+				 * phase sequence was requested by the target. The host adapter
+				 * will generate a SCSI Reset Condition, notifying the host with
+				 * a SCRD interrupt
+				 */
 		hosterr = DID_RESET;
 		break;
 	default:
@@ -216,8 +227,10 @@ static int aha1542_test_port(struct Scsi
 	if (inb(INTRFLAGS(sh->io_port)) & INTRMASK)
 		return 0;
 
-	/* Perform a host adapter inquiry instead so we do not need to set
-	   up the mailboxes ahead of time */
+	/*
+	 * Perform a host adapter inquiry instead so we do not need to set
+	 * up the mailboxes ahead of time
+	 */
 
 	aha1542_outb(sh->io_port, CMD_INQUIRY);
 
@@ -292,10 +305,12 @@ static irqreturn_t aha1542_interrupt(int
 	while (1) {
 		flag = inb(INTRFLAGS(sh->io_port));
 
-		/* Check for unusual interrupts.  If any of these happen, we should
-		   probably do something special, but for now just printing a message
-		   is sufficient.  A SCSI reset detected is something that we really
-		   need to deal with in some way. */
+		/*
+		 * Check for unusual interrupts.  If any of these happen, we should
+		 * probably do something special, but for now just printing a message
+		 * is sufficient.  A SCSI reset detected is something that we really
+		 * need to deal with in some way.
+		 */
 		if (flag & ~MBIF) {
 			if (flag & MBOA)
 				printk("MBOF ");
@@ -355,9 +370,11 @@ static irqreturn_t aha1542_interrupt(int
 		}
 		my_done = tmp_cmd->scsi_done;
 		aha1542_free_cmd(tmp_cmd);
-		/* Fetch the sense data, and tuck it away, in the required slot.  The
-		   Adaptec automatically fetches it, and there is no guarantee that
-		   we will still have it in the cdb when we come back */
+		/*
+		 * Fetch the sense data, and tuck it away, in the required slot.  The
+		 * Adaptec automatically fetches it, and there is no guarantee that
+		 * we will still have it in the cdb when we come back
+		 */
 		if (ccb[mbo].tarstat == 2)
 			memcpy(tmp_cmd->sense_buffer, &ccb[mbo].cdb[ccb[mbo].cdblen],
 			       SCSI_SENSE_BUFFERSIZE);
@@ -383,7 +400,8 @@ static irqreturn_t aha1542_interrupt(int
 #endif
 		tmp_cmd->result = errstatus;
 		aha1542->int_cmds[mbo] = NULL;	/* This effectively frees up the mailbox slot, as
-						   far as queuecommand is concerned */
+						 * far as queuecommand is concerned
+						 */
 		my_done(tmp_cmd);
 		number_serviced++;
 	};
@@ -433,8 +451,10 @@ static int aha1542_queuecommand(struct S
 			goto out_free_chain;
 	}
 
-	/* Use the outgoing mailboxes in a round-robin fashion, because this
-	   is how the host adapter will scan for them */
+	/*
+	 * Use the outgoing mailboxes in a round-robin fashion, because this
+	 * is how the host adapter will scan for them
+	 */
 
 	spin_lock_irqsave(sh->host_lock, flags);
 	mbo = aha1542->aha1542_last_mbo_used + 1;
@@ -453,7 +473,8 @@ static int aha1542_queuecommand(struct S
 		panic("Unable to find empty mailbox for aha1542.\n");
 
 	aha1542->int_cmds[mbo] = cmd;	/* This will effectively prevent someone else from
-					   screwing with this cdb. */
+					 * screwing with this cdb.
+					 */
 
 	aha1542->aha1542_last_mbo_used = mbo;
 
@@ -565,8 +586,10 @@ static int aha1542_getconfig(struct Scsi
 		sh->dma_channel = 0;
 		break;
 	case 0:
-		/* This means that the adapter, although Adaptec 1542 compatible, doesn't use a DMA channel.
-		   Currently only aware of the BusLogic BT-445S VL-Bus adapter which needs this. */
+		/*
+		 * This means that the adapter, although Adaptec 1542 compatible, doesn't use a DMA channel.
+		 * Currently only aware of the BusLogic BT-445S VL-Bus adapter which needs this.
+		 */
 		sh->dma_channel = 0xFF;
 		break;
 	default:
@@ -600,8 +623,10 @@ static int aha1542_getconfig(struct Scsi
 	return 0;
 }
 
-/* This function should only be called for 1542C boards - we can detect
-   the special firmware settings and unlock the board */
+/*
+ * This function should only be called for 1542C boards - we can detect
+ * the special firmware settings and unlock the board
+ */
 
 static int aha1542_mbenable(struct Scsi_Host *sh)
 {
@@ -655,10 +680,11 @@ static int aha1542_query(struct Scsi_Hos
 
 	aha1542->bios_translation = BIOS_TRANSLATION_6432;	/* Default case */
 
-	/* For an AHA1740 series board, we ignore the board since there is a
-	   hardware bug which can lead to wrong blocks being returned if the board
-	   is operating in the 1542 emulation mode.  Since there is an extended mode
-	   driver, we simply ignore the board and let the 1740 driver pick it up.
+	/*
+	 * For an AHA1740 series board, we ignore the board since there is a
+	 * hardware bug which can lead to wrong blocks being returned if the board
+	 * is operating in the 1542 emulation mode.  Since there is an extended mode
+	 * driver, we simply ignore the board and let the 1740 driver pick it up.
 	 */
 
 	if (inquiry_result[0] == 0x43) {
@@ -666,8 +692,10 @@ static int aha1542_query(struct Scsi_Hos
 		return 1;
 	};
 
-	/* Always call this - boards that do not support extended bios translation
-	   will ignore the command, and we will set the proper default */
+	/*
+	 * Always call this - boards that do not support extended bios translation
+	 * will ignore the command, and we will set the proper default
+	 */
 
 	aha1542->bios_translation = aha1542_mbenable(sh);
 
@@ -877,8 +905,9 @@ static int aha1542_dev_reset(struct scsi
 		panic("Unable to find empty mailbox for aha1542.\n");
 
 	aha1542->int_cmds[mbo] = cmd;	/* This will effectively
-					   prevent someone else from
-					   screwing with this cdb. */
+					 * prevent someone else from
+					 * screwing with this cdb.
+					 */
 
 	aha1542->aha1542_last_mbo_used = mbo;
 
@@ -1063,8 +1092,10 @@ static int aha1542_pnp_probe(struct pnp_
 
 		io[indx] = pnp_port_start(pdev, 0);
 
-		/* The card can be queried for its DMA, we have
-		   the DMA set up that is enough */
+		/*
+		 * The card can be queried for its DMA, we have
+		 * the DMA set up that is enough
+		 */
 
 		dev_info(&pdev->dev, "ISAPnP found an AHA1535 at I/O 0x%03X", io[indx]);
 	}
