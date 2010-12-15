From: adam radford <aradford@gmail.com>
Subject: [PATCH 9/11]: megaraid_sas: Add MegaRAID 9265/9285 FastPath code.
Date: Tue, 14 Dec 2010 19:08:08 -0800
Message-ID: <AANLkTinjEnCmMhW9EeVmE1JchQBKUzEv_V5HxU5SBnSF@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=00163683204e29bc4004976a3fc6
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55853 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610Ab0LODIJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Dec 2010 22:08:09 -0500
Received: by qwa26 with SMTP id 26so1493483qwa.19
        for <linux-scsi@vger.kernel.org>; Tue, 14 Dec 2010 19:08:08 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--00163683204e29bc4004976a3fc6
Content-Type: text/plain; charset=ISO-8859-1

James/Linux-scsi,

The following patch adds the MegaRAID 9265/9285 fast path code in the
following file: megaraid_sas_fp.c.

Signed-off-by: Adam Radford <aradford@gmail.com>

Note: The patch has been included in-line below, and also as an
attachment in case Gmail hoses the patch.

diff -Naur linux-2.6.37-rc5.old/drivers/scsi/megaraid/Makefile
linux-2.6.37-rc5.new/drivers/scsi/megaraid/Makefile
--- linux-2.6.37-rc5.old/drivers/scsi/megaraid/Makefile	2010-12-14
15:53:14.000000000 -0800
+++ linux-2.6.37-rc5.new/drivers/scsi/megaraid/Makefile	2010-12-14
17:20:14.000000000 -0800
@@ -1,4 +1,5 @@
 obj-$(CONFIG_MEGARAID_MM)	+= megaraid_mm.o
 obj-$(CONFIG_MEGARAID_MAILBOX)	+= megaraid_mbox.o
 obj-$(CONFIG_MEGARAID_SAS)	+= megaraid_sas.o
-megaraid_sas-objs := megaraid_sas_base.o
+megaraid_sas-objs := megaraid_sas_base.o megaraid_sas_fusion.o \
+	megaraid_sas_fp.o
diff -Naur linux-2.6.37-rc5.old/drivers/scsi/megaraid/megaraid_sas_fp.c
linux-2.6.37-rc5.new/drivers/scsi/megaraid/megaraid_sas_fp.c
--- linux-2.6.37-rc5.old/drivers/scsi/megaraid/megaraid_sas_fp.c	1969-12-31
16:00:00.000000000 -0800
+++ linux-2.6.37-rc5.new/drivers/scsi/megaraid/megaraid_sas_fp.c	2010-12-14
17:19:02.000000000 -0800
@@ -0,0 +1,516 @@
+/*
+ *  Linux MegaRAID driver for SAS based RAID controllers
+ *
+ *  Copyright (c) 2009-2011  LSI Corporation.
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation; either version 2
+ *  of the License, or (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ *  FILE: megaraid_sas_fp.c
+ *
+ *  Authors: LSI Corporation
+ *           Sumant Patro
+ *           Varad Talamacki
+ *           Manoj Jose
+ *
+ *  Send feedback to: <megaraidlinux@lsi.com>
+ *
+ *  Mail to: LSI Corporation, 1621 Barber Lane, Milpitas, CA 95035
+ *     ATTN: Linuxraid
+ */
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/pci.h>
+#include <linux/list.h>
+#include <linux/moduleparam.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/smp_lock.h>
+#include <linux/uio.h>
+#include <linux/uaccess.h>
+#include <linux/fs.h>
+#include <linux/compat.h>
+#include <linux/blkdev.h>
+#include <linux/poll.h>
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
+
+#include "megaraid_sas_fusion.h"
+#include <asm/div64.h>
+
+#define ABS_DIFF(a, b)   (((a) > (b)) ? ((a) - (b)) : ((b) - (a)))
+#define MR_LD_STATE_OPTIMAL 3
+#define FALSE 0
+#define TRUE 1
+
+/* Prototypes */
+void
+mr_update_load_balance_params(struct MR_FW_RAID_MAP_ALL *map,
+			      struct LD_LOAD_BALANCE_INFO *lbInfo);
+
+u32 mega_mod64(u64 dividend, u32 divisor)
+{
+	u64 d;
+	u32 remainder;
+
+	if (!divisor)
+		printk(KERN_ERR "megasas : DIVISOR is zero, in div fn\n");
+	d = dividend;
+	remainder = do_div(d, divisor);
+	return remainder;
+}
+
+/**
+ * @param dividend    : Dividend
+ * @param divisor    : Divisor
+ *
+ * @return quotient
+ **/
+u64 mega_div64_32(uint64_t dividend, uint32_t divisor)
+{
+	u32 remainder;
+	u64 d;
+
+	if (!divisor)
+		printk(KERN_ERR "megasas : DIVISOR is zero in mod fn\n");
+
+	d = dividend;
+	remainder = do_div(d, divisor);
+
+	return d;
+}
+
+struct MR_LD_RAID *MR_LdRaidGet(u32 ld, struct MR_FW_RAID_MAP_ALL *map)
+{
+	return &map->raidMap.ldSpanMap[ld].ldRaid;
+}
+
+static struct MR_SPAN_BLOCK_INFO *MR_LdSpanInfoGet(u32 ld,
+						   struct MR_FW_RAID_MAP_ALL
+						   *map)
+{
+	return &map->raidMap.ldSpanMap[ld].spanBlock[0];
+}
+
+static u8 MR_LdDataArmGet(u32 ld, u32 armIdx, struct MR_FW_RAID_MAP_ALL *map)
+{
+	return map->raidMap.ldSpanMap[ld].dataArmMap[armIdx];
+}
+
+static u16 MR_ArPdGet(u32 ar, u32 arm, struct MR_FW_RAID_MAP_ALL *map)
+{
+	return map->raidMap.arMapInfo[ar].pd[arm];
+}
+
+static u16 MR_LdSpanArrayGet(u32 ld, u32 span, struct MR_FW_RAID_MAP_ALL *map)
+{
+	return map->raidMap.ldSpanMap[ld].spanBlock[span].span.arrayRef;
+}
+
+static u16 MR_PdDevHandleGet(u32 pd, struct MR_FW_RAID_MAP_ALL *map)
+{
+	return map->raidMap.devHndlInfo[pd].curDevHdl;
+}
+
+u16 MR_GetLDTgtId(u32 ld, struct MR_FW_RAID_MAP_ALL *map)
+{
+	return map->raidMap.ldSpanMap[ld].ldRaid.targetId;
+}
+
+u16 MR_TargetIdToLdGet(u32 ldTgtId, struct MR_FW_RAID_MAP_ALL *map)
+{
+	return map->raidMap.ldTgtIdToLd[ldTgtId];
+}
+
+static struct MR_LD_SPAN *MR_LdSpanPtrGet(u32 ld, u32 span,
+					  struct MR_FW_RAID_MAP_ALL *map)
+{
+	return &map->raidMap.ldSpanMap[ld].spanBlock[span].span;
+}
+
+/*
+ * This function will validate Map info data provided by FW
+ */
+u8 MR_ValidateMapInfo(struct MR_FW_RAID_MAP_ALL *map,
+		      struct LD_LOAD_BALANCE_INFO *lbInfo)
+{
+	struct MR_FW_RAID_MAP *pFwRaidMap = &map->raidMap;
+
+	if (pFwRaidMap->totalSize !=
+	    (sizeof(struct MR_FW_RAID_MAP) -sizeof(struct MR_LD_SPAN_MAP) +
+	     (sizeof(struct MR_LD_SPAN_MAP) *pFwRaidMap->ldCount))) {
+		printk(KERN_ERR "megasas: map info structure size 0x%x is not
matching with ld count\n",
+		       (unsigned int)((sizeof(struct MR_FW_RAID_MAP) -
+				       sizeof(struct MR_LD_SPAN_MAP)) +
+				      (sizeof(struct MR_LD_SPAN_MAP) *
+				       pFwRaidMap->ldCount)));
+		printk(KERN_ERR "megasas: span map %x, pFwRaidMap->totalSize "
+		       ": %x\n", (unsigned int)sizeof(struct MR_LD_SPAN_MAP),
+		       pFwRaidMap->totalSize);
+		return 0;
+	}
+
+	mr_update_load_balance_params(map, lbInfo);
+
+	return 1;
+}
+
+u32 MR_GetSpanBlock(u32 ld, u64 row, u64 *span_blk,
+		    struct MR_FW_RAID_MAP_ALL *map, int *div_error)
+{
+	struct MR_SPAN_BLOCK_INFO *pSpanBlock = MR_LdSpanInfoGet(ld, map);
+	struct MR_QUAD_ELEMENT    *quad;
+	struct MR_LD_RAID         *raid = MR_LdRaidGet(ld, map);
+	u32                span, j;
+
+	for (span = 0; span < raid->spanDepth; span++, pSpanBlock++) {
+
+		for (j = 0; j < pSpanBlock->block_span_info.noElements; j++) {
+			quad = &pSpanBlock->block_span_info.quad[j];
+
+			if (quad->diff == 0) {
+				*div_error = 1;
+				return span;
+			}
+			if (quad->logStart <= row  &&  row <= quad->logEnd  &&
+			    (mega_mod64(row-quad->logStart, quad->diff)) == 0) {
+				if (span_blk != NULL) {
+					u64  blk, debugBlk;
+					blk =
+						mega_div64_32(
+							(row-quad->logStart),
+							quad->diff);
+					debugBlk = blk;
+
+					blk = (blk + quad->offsetInSpan) <<
+						raid->stripeShift;
+					*span_blk = blk;
+				}
+				return span;
+			}
+		}
+	}
+	return span;
+}
+
+/*
+******************************************************************************
+*
+* This routine calculates the arm, span and block for the specified stripe and
+* reference in stripe.
+*
+* Inputs :
+*
+*    ld   - Logical drive number
+*    stripRow        - Stripe number
+*    stripRef    - Reference in stripe
+*
+* Outputs :
+*
+*    span          - Span number
+*    block         - Absolute Block number in the physical disk
+*/
+u8 MR_GetPhyParams(u32 ld, u64 stripRow, u16 stripRef, u64 *pdBlock,
+		   u16 *pDevHandle, struct RAID_CONTEXT *pRAID_Context,
+		   struct MR_FW_RAID_MAP_ALL *map)
+{
+	struct MR_LD_RAID  *raid = MR_LdRaidGet(ld, map);
+	u32         pd, arRef;
+	u8          physArm, span;
+	u64         row;
+	u8	    retval = TRUE;
+	int	    error_code = 0;
+
+	row =  mega_div64_32(stripRow, raid->rowDataSize);
+
+	if (raid->level == 6) {
+		/* logical arm within row */
+		u32 logArm =  mega_mod64(stripRow, raid->rowDataSize);
+		u32 rowMod, armQ, arm;
+
+		if (raid->rowSize == 0)
+			return FALSE;
+		/* get logical row mod */
+		rowMod = mega_mod64(row, raid->rowSize);
+		armQ = raid->rowSize-1-rowMod; /* index of Q drive */
+		arm = armQ+1+logArm; /* data always logically follows Q */
+		if (arm >= raid->rowSize) /* handle wrap condition */
+			arm -= raid->rowSize;
+		physArm = (u8)arm;
+	} else  {
+		if (raid->modFactor == 0)
+			return FALSE;
+		physArm = MR_LdDataArmGet(ld,  mega_mod64(stripRow,
+							  raid->modFactor),
+					  map);
+	}
+
+	if (raid->spanDepth == 1) {
+		span = 0;
+		*pdBlock = row << raid->stripeShift;
+	} else {
+		span = (u8)MR_GetSpanBlock(ld, row, pdBlock, map, &error_code);
+		if (error_code == 1)
+			return FALSE;
+	}
+
+	/* Get the array on which this span is present */
+	arRef       = MR_LdSpanArrayGet(ld, span, map);
+	pd          = MR_ArPdGet(arRef, physArm, map); /* Get the pd */
+
+	if (pd != MR_PD_INVALID)
+		/* Get dev handle from Pd. */
+		*pDevHandle = MR_PdDevHandleGet(pd, map);
+	else {
+		*pDevHandle = MR_PD_INVALID; /* set dev handle as invalid. */
+		if (raid->level >= 5)
+			pRAID_Context->regLockFlags = REGION_TYPE_EXCLUSIVE;
+		else if (raid->level == 1) {
+			/* Get alternate Pd. */
+			pd = MR_ArPdGet(arRef, physArm + 1, map);
+			if (pd != MR_PD_INVALID)
+				/* Get dev handle from Pd */
+				*pDevHandle = MR_PdDevHandleGet(pd, map);
+		}
+		retval = FALSE;
+	}
+
+	*pdBlock += stripRef + MR_LdSpanPtrGet(ld, span, map)->startBlk;
+	pRAID_Context->spanArm = (span << RAID_CTX_SPANARM_SPAN_SHIFT) |
+		physArm;
+	return retval;
+}
+
+/*
+******************************************************************************
+*
+* MR_BuildRaidContext function
+*
+* This function will initiate command processing.  The start/end row and strip
+* information is calculated then the lock is acquired.
+* This function will return 0 if region lock was acquired OR return num strips
+*/
+u8
+MR_BuildRaidContext(struct IO_REQUEST_INFO *io_info,
+		    struct RAID_CONTEXT *pRAID_Context,
+		    struct MR_FW_RAID_MAP_ALL *map)
+{
+	struct MR_LD_RAID  *raid;
+	u32         ld, stripSize, stripe_mask;
+	u64         endLba, endStrip, endRow, start_row, start_strip;
+	u64         regStart;
+	u32         regSize;
+	u8          num_strips, numRows;
+	u16         ref_in_start_stripe, ref_in_end_stripe;
+	u64         ldStartBlock;
+	u32         numBlocks, ldTgtId;
+	u8          isRead;
+	u8	    retval = 0;
+
+	ldStartBlock = io_info->ldStartBlock;
+	numBlocks = io_info->numBlocks;
+	ldTgtId = io_info->ldTgtId;
+	isRead = io_info->isRead;
+
+	ld = MR_TargetIdToLdGet(ldTgtId, map);
+	raid = MR_LdRaidGet(ld, map);
+
+	stripSize = 1 << raid->stripeShift;
+	stripe_mask = stripSize-1;
+	/*
+	 * calculate starting row and stripe, and number of strips and rows
+	 */
+	start_strip         = ldStartBlock >> raid->stripeShift;
+	ref_in_start_stripe = (u16)(ldStartBlock & stripe_mask);
+	endLba              = ldStartBlock + numBlocks - 1;
+	ref_in_end_stripe   = (u16)(endLba & stripe_mask);
+	endStrip            = endLba >> raid->stripeShift;
+	num_strips          = (u8)(endStrip - start_strip + 1); /* End strip */
+	if (raid->rowDataSize == 0)
+		return FALSE;
+	start_row           =  mega_div64_32(start_strip, raid->rowDataSize);
+	endRow              =  mega_div64_32(endStrip, raid->rowDataSize);
+	numRows             = (u8)(endRow - start_row + 1);
+
+	/*
+	 * calculate region info.
+	 */
+
+	/* assume region is at the start of the first row */
+	regStart            = start_row << raid->stripeShift;
+	/* assume this IO needs the full row - we'll adjust if not true */
+	regSize             = stripSize;
+
+	/* If IO spans more than 1 strip, fp is not possible
+	   FP is not possible for writes on non-0 raid levels
+	   FP is not possible if LD is not capable */
+	if (num_strips > 1 || (!isRead && raid->level != 0) ||
+	    !raid->capability.fpCapable) {
+		io_info->fpOkForIo = FALSE;
+	} else {
+		io_info->fpOkForIo = TRUE;
+	}
+
+	if (numRows == 1) {
+		/* single-strip IOs can always lock only the data needed */
+		if (num_strips == 1) {
+			regStart += ref_in_start_stripe;
+			regSize = numBlocks;
+		}
+		/* multi-strip IOs always need to full stripe locked */
+	} else {
+		if (start_strip == (start_row + 1) * raid->rowDataSize - 1) {
+			/* If the start strip is the last in the start row */
+			regStart += ref_in_start_stripe;
+			regSize = stripSize - ref_in_start_stripe;
+			/* initialize count to sectors from startref to end
+			   of strip */
+		}
+
+		if (numRows > 2)
+			/* Add complete rows in the middle of the transfer */
+			regSize += (numRows-2) << raid->stripeShift;
+
+		/* if IO ends within first strip of last row */
+		if (endStrip == endRow*raid->rowDataSize)
+			regSize += ref_in_end_stripe+1;
+		else
+			regSize += stripSize;
+	}
+
+	pRAID_Context->timeoutValue     = map->raidMap.fpPdIoTimeoutSec;
+	pRAID_Context->regLockFlags     = (isRead) ? REGION_TYPE_SHARED_READ :
+		raid->regTypeReqOnWrite;
+	pRAID_Context->VirtualDiskTgtId = raid->targetId;
+	pRAID_Context->regLockRowLBA    = regStart;
+	pRAID_Context->regLockLength    = regSize;
+	pRAID_Context->configSeqNum	= raid->seqNum;
+
+	/*Get Phy Params only if FP capable, or else leave it to MR firmware
+	  to do the calculation.*/
+	if (io_info->fpOkForIo) {
+		retval = MR_GetPhyParams(ld, start_strip, ref_in_start_stripe,
+					 &io_info->pdBlock,
+					 &io_info->devHandle, pRAID_Context,
+					 map);
+		/* If IO on an invalid Pd, then FP i snot possible */
+		if (io_info->devHandle == MR_PD_INVALID)
+			io_info->fpOkForIo = FALSE;
+		return retval;
+	} else if (isRead) {
+		uint stripIdx;
+		for (stripIdx = 0; stripIdx < num_strips; stripIdx++) {
+			if (!MR_GetPhyParams(ld, start_strip + stripIdx,
+					     ref_in_start_stripe,
+					     &io_info->pdBlock,
+					     &io_info->devHandle,
+					     pRAID_Context, map))
+				return TRUE;
+		}
+	}
+	return TRUE;
+}
+
+void
+mr_update_load_balance_params(struct MR_FW_RAID_MAP_ALL *map,
+			      struct LD_LOAD_BALANCE_INFO *lbInfo)
+{
+	int ldCount;
+	u16 ld;
+	struct MR_LD_RAID *raid;
+
+	for (ldCount = 0; ldCount < MAX_LOGICAL_DRIVES; ldCount++) {
+		ld = MR_TargetIdToLdGet(ldCount, map);
+		if (ld >= MAX_LOGICAL_DRIVES) {
+			lbInfo[ldCount].loadBalanceFlag = 0;
+			continue;
+		}
+
+		raid = MR_LdRaidGet(ld, map);
+
+		/* Two drive Optimal RAID 1 */
+		if ((raid->level == 1)  &&  (raid->rowSize == 2) &&
+		    (raid->spanDepth == 1) && raid->ldState ==
+		    MR_LD_STATE_OPTIMAL) {
+			u32 pd, arRef;
+
+			lbInfo[ldCount].loadBalanceFlag = 1;
+
+			/* Get the array on which this span is present */
+			arRef = MR_LdSpanArrayGet(ld, 0, map);
+
+			/* Get the Pd */
+			pd = MR_ArPdGet(arRef, 0, map);
+			/* Get dev handle from Pd */
+			lbInfo[ldCount].raid1DevHandle[0] =
+				MR_PdDevHandleGet(pd, map);
+			/* Get the Pd */
+			pd = MR_ArPdGet(arRef, 1, map);
+
+			/* Get the dev handle from Pd */
+			lbInfo[ldCount].raid1DevHandle[1] =
+				MR_PdDevHandleGet(pd, map);
+		} else
+			lbInfo[ldCount].loadBalanceFlag = 0;
+	}
+}
+
+u8 megasas_get_best_arm(struct LD_LOAD_BALANCE_INFO *lbInfo, u8 arm, u64 block,
+			u32 count)
+{
+	u16     pend0, pend1;
+	u64     diff0, diff1;
+	u8      bestArm;
+
+	/* get the pending cmds for the data and mirror arms */
+	pend0 = atomic_read(&lbInfo->scsi_pending_cmds[0]);
+	pend1 = atomic_read(&lbInfo->scsi_pending_cmds[1]);
+
+	/* Determine the disk whose head is nearer to the req. block */
+	diff0 = ABS_DIFF(block, lbInfo->last_accessed_block[0]);
+	diff1 = ABS_DIFF(block, lbInfo->last_accessed_block[1]);
+	bestArm = (diff0 <= diff1 ? 0 : 1);
+
+	if ((bestArm == arm && pend0 > pend1 + 16)  ||
+	    (bestArm != arm && pend1 > pend0 + 16))
+		bestArm ^= 1;
+
+	/* Update the last accessed block on the correct pd */
+	lbInfo->last_accessed_block[bestArm] = block + count - 1;
+
+	return bestArm;
+}
+
+u16 get_updated_dev_handle(struct LD_LOAD_BALANCE_INFO *lbInfo,
+			   struct IO_REQUEST_INFO *io_info)
+{
+	u8 arm, old_arm;
+	u16 devHandle;
+
+	old_arm = lbInfo->raid1DevHandle[0] == io_info->devHandle ? 0 : 1;
+
+	/* get best new arm */
+	arm  = megasas_get_best_arm(lbInfo, old_arm, io_info->ldStartBlock,
+				    io_info->numBlocks);
+	devHandle = lbInfo->raid1DevHandle[arm];
+	atomic_inc(&lbInfo->scsi_pending_cmds[arm]);
+
+	return devHandle;
+}

--00163683204e29bc4004976a3fc6
Content-Type: application/octet-stream; name="megaraid_sas.patch9"
Content-Disposition: attachment; filename="megaraid_sas.patch9"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ghpn0i5f0

ZGlmZiAtTmF1ciBsaW51eC0yLjYuMzctcmM1Lm9sZC9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvTWFr
ZWZpbGUgbGludXgtMi42LjM3LXJjNS5uZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL01ha2VmaWxl
Ci0tLSBsaW51eC0yLjYuMzctcmM1Lm9sZC9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvTWFrZWZpbGUJ
MjAxMC0xMi0xNCAxNTo1MzoxNC4wMDAwMDAwMDAgLTA4MDAKKysrIGxpbnV4LTIuNi4zNy1yYzUu
bmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9NYWtlZmlsZQkyMDEwLTEyLTE0IDE3OjIwOjE0LjAw
MDAwMDAwMCAtMDgwMApAQCAtMSw0ICsxLDUgQEAKIG9iai0kKENPTkZJR19NRUdBUkFJRF9NTSkJ
Kz0gbWVnYXJhaWRfbW0ubwogb2JqLSQoQ09ORklHX01FR0FSQUlEX01BSUxCT1gpCSs9IG1lZ2Fy
YWlkX21ib3gubwogb2JqLSQoQ09ORklHX01FR0FSQUlEX1NBUykJKz0gbWVnYXJhaWRfc2FzLm8K
LW1lZ2FyYWlkX3Nhcy1vYmpzIDo9IG1lZ2FyYWlkX3Nhc19iYXNlLm8KK21lZ2FyYWlkX3Nhcy1v
YmpzIDo9IG1lZ2FyYWlkX3Nhc19iYXNlLm8gbWVnYXJhaWRfc2FzX2Z1c2lvbi5vIFwKKwltZWdh
cmFpZF9zYXNfZnAubwpkaWZmIC1OYXVyIGxpbnV4LTIuNi4zNy1yYzUub2xkL2RyaXZlcnMvc2Nz
aS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfZnAuYyBsaW51eC0yLjYuMzctcmM1Lm5ldy9kcml2ZXJz
L3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2ZwLmMKLS0tIGxpbnV4LTIuNi4zNy1yYzUub2xk
L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfZnAuYwkxOTY5LTEyLTMxIDE2OjAw
OjAwLjAwMDAwMDAwMCAtMDgwMAorKysgbGludXgtMi42LjM3LXJjNS5uZXcvZHJpdmVycy9zY3Np
L21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19mcC5jCTIwMTAtMTItMTQgMTc6MTk6MDIuMDAwMDAwMDAw
IC0wODAwCkBAIC0wLDAgKzEsNTE2IEBACisvKgorICogIExpbnV4IE1lZ2FSQUlEIGRyaXZlciBm
b3IgU0FTIGJhc2VkIFJBSUQgY29udHJvbGxlcnMKKyAqCisgKiAgQ29weXJpZ2h0IChjKSAyMDA5
LTIwMTEgIExTSSBDb3Jwb3JhdGlvbi4KKyAqCisgKiAgVGhpcyBwcm9ncmFtIGlzIGZyZWUgc29m
dHdhcmU7IHlvdSBjYW4gcmVkaXN0cmlidXRlIGl0IGFuZC9vcgorICogIG1vZGlmeSBpdCB1bmRl
ciB0aGUgdGVybXMgb2YgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlCisgKiAgYXMgcHVi
bGlzaGVkIGJ5IHRoZSBGcmVlIFNvZnR3YXJlIEZvdW5kYXRpb247IGVpdGhlciB2ZXJzaW9uIDIK
KyAqICBvZiB0aGUgTGljZW5zZSwgb3IgKGF0IHlvdXIgb3B0aW9uKSBhbnkgbGF0ZXIgdmVyc2lv
bi4KKyAqCisgKiAgVGhpcyBwcm9ncmFtIGlzIGRpc3RyaWJ1dGVkIGluIHRoZSBob3BlIHRoYXQg
aXQgd2lsbCBiZSB1c2VmdWwsCisgKiAgYnV0IFdJVEhPVVQgQU5ZIFdBUlJBTlRZOyB3aXRob3V0
IGV2ZW4gdGhlIGltcGxpZWQgd2FycmFudHkgb2YKKyAqICBNRVJDSEFOVEFCSUxJVFkgb3IgRklU
TkVTUyBGT1IgQSBQQVJUSUNVTEFSIFBVUlBPU0UuICBTZWUgdGhlCisgKiAgR05VIEdlbmVyYWwg
UHVibGljIExpY2Vuc2UgZm9yIG1vcmUgZGV0YWlscy4KKyAqCisgKiAgWW91IHNob3VsZCBoYXZl
IHJlY2VpdmVkIGEgY29weSBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UKKyAqICBh
bG9uZyB3aXRoIHRoaXMgcHJvZ3JhbTsgaWYgbm90LCB3cml0ZSB0byB0aGUgRnJlZSBTb2Z0d2Fy
ZQorICogIEZvdW5kYXRpb24sIEluYy4sIDU5IFRlbXBsZSBQbGFjZSwgU3VpdGUgMzMwLCBCb3N0
b24sIE1BIDAyMTExLTEzMDcgVVNBCisgKgorICogIEZJTEU6IG1lZ2FyYWlkX3Nhc19mcC5jCisg
KgorICogIEF1dGhvcnM6IExTSSBDb3Jwb3JhdGlvbgorICogICAgICAgICAgIFN1bWFudCBQYXRy
bworICogICAgICAgICAgIFZhcmFkIFRhbGFtYWNraQorICogICAgICAgICAgIE1hbm9qIEpvc2UK
KyAqCisgKiAgU2VuZCBmZWVkYmFjayB0bzogPG1lZ2FyYWlkbGludXhAbHNpLmNvbT4KKyAqCisg
KiAgTWFpbCB0bzogTFNJIENvcnBvcmF0aW9uLCAxNjIxIEJhcmJlciBMYW5lLCBNaWxwaXRhcywg
Q0EgOTUwMzUKKyAqICAgICBBVFROOiBMaW51eHJhaWQKKyAqLworCisjaW5jbHVkZSA8bGludXgv
a2VybmVsLmg+CisjaW5jbHVkZSA8bGludXgvdHlwZXMuaD4KKyNpbmNsdWRlIDxsaW51eC9wY2ku
aD4KKyNpbmNsdWRlIDxsaW51eC9saXN0Lmg+CisjaW5jbHVkZSA8bGludXgvbW9kdWxlcGFyYW0u
aD4KKyNpbmNsdWRlIDxsaW51eC9tb2R1bGUuaD4KKyNpbmNsdWRlIDxsaW51eC9zcGlubG9jay5o
PgorI2luY2x1ZGUgPGxpbnV4L2ludGVycnVwdC5oPgorI2luY2x1ZGUgPGxpbnV4L2RlbGF5Lmg+
CisjaW5jbHVkZSA8bGludXgvc21wX2xvY2suaD4KKyNpbmNsdWRlIDxsaW51eC91aW8uaD4KKyNp
bmNsdWRlIDxsaW51eC91YWNjZXNzLmg+CisjaW5jbHVkZSA8bGludXgvZnMuaD4KKyNpbmNsdWRl
IDxsaW51eC9jb21wYXQuaD4KKyNpbmNsdWRlIDxsaW51eC9ibGtkZXYuaD4KKyNpbmNsdWRlIDxs
aW51eC9wb2xsLmg+CisKKyNpbmNsdWRlIDxzY3NpL3Njc2kuaD4KKyNpbmNsdWRlIDxzY3NpL3Nj
c2lfY21uZC5oPgorI2luY2x1ZGUgPHNjc2kvc2NzaV9kZXZpY2UuaD4KKyNpbmNsdWRlIDxzY3Np
L3Njc2lfaG9zdC5oPgorCisjaW5jbHVkZSAibWVnYXJhaWRfc2FzX2Z1c2lvbi5oIgorI2luY2x1
ZGUgPGFzbS9kaXY2NC5oPgorCisjZGVmaW5lIEFCU19ESUZGKGEsIGIpICAgKCgoYSkgPiAoYikp
ID8gKChhKSAtIChiKSkgOiAoKGIpIC0gKGEpKSkKKyNkZWZpbmUgTVJfTERfU1RBVEVfT1BUSU1B
TCAzCisjZGVmaW5lIEZBTFNFIDAKKyNkZWZpbmUgVFJVRSAxCisKKy8qIFByb3RvdHlwZXMgKi8K
K3ZvaWQKK21yX3VwZGF0ZV9sb2FkX2JhbGFuY2VfcGFyYW1zKHN0cnVjdCBNUl9GV19SQUlEX01B
UF9BTEwgKm1hcCwKKwkJCSAgICAgIHN0cnVjdCBMRF9MT0FEX0JBTEFOQ0VfSU5GTyAqbGJJbmZv
KTsKKwordTMyIG1lZ2FfbW9kNjQodTY0IGRpdmlkZW5kLCB1MzIgZGl2aXNvcikKK3sKKwl1NjQg
ZDsKKwl1MzIgcmVtYWluZGVyOworCisJaWYgKCFkaXZpc29yKQorCQlwcmludGsoS0VSTl9FUlIg
Im1lZ2FzYXMgOiBESVZJU09SIGlzIHplcm8sIGluIGRpdiBmblxuIik7CisJZCA9IGRpdmlkZW5k
OworCXJlbWFpbmRlciA9IGRvX2RpdihkLCBkaXZpc29yKTsKKwlyZXR1cm4gcmVtYWluZGVyOwor
fQorCisvKioKKyAqIEBwYXJhbSBkaXZpZGVuZCAgICA6IERpdmlkZW5kCisgKiBAcGFyYW0gZGl2
aXNvciAgICA6IERpdmlzb3IKKyAqCisgKiBAcmV0dXJuIHF1b3RpZW50CisgKiovCit1NjQgbWVn
YV9kaXY2NF8zMih1aW50NjRfdCBkaXZpZGVuZCwgdWludDMyX3QgZGl2aXNvcikKK3sKKwl1MzIg
cmVtYWluZGVyOworCXU2NCBkOworCisJaWYgKCFkaXZpc29yKQorCQlwcmludGsoS0VSTl9FUlIg
Im1lZ2FzYXMgOiBESVZJU09SIGlzIHplcm8gaW4gbW9kIGZuXG4iKTsKKworCWQgPSBkaXZpZGVu
ZDsKKwlyZW1haW5kZXIgPSBkb19kaXYoZCwgZGl2aXNvcik7CisKKwlyZXR1cm4gZDsKK30KKwor
c3RydWN0IE1SX0xEX1JBSUQgKk1SX0xkUmFpZEdldCh1MzIgbGQsIHN0cnVjdCBNUl9GV19SQUlE
X01BUF9BTEwgKm1hcCkKK3sKKwlyZXR1cm4gJm1hcC0+cmFpZE1hcC5sZFNwYW5NYXBbbGRdLmxk
UmFpZDsKK30KKworc3RhdGljIHN0cnVjdCBNUl9TUEFOX0JMT0NLX0lORk8gKk1SX0xkU3Bhbklu
Zm9HZXQodTMyIGxkLAorCQkJCQkJICAgc3RydWN0IE1SX0ZXX1JBSURfTUFQX0FMTAorCQkJCQkJ
ICAgKm1hcCkKK3sKKwlyZXR1cm4gJm1hcC0+cmFpZE1hcC5sZFNwYW5NYXBbbGRdLnNwYW5CbG9j
a1swXTsKK30KKworc3RhdGljIHU4IE1SX0xkRGF0YUFybUdldCh1MzIgbGQsIHUzMiBhcm1JZHgs
IHN0cnVjdCBNUl9GV19SQUlEX01BUF9BTEwgKm1hcCkKK3sKKwlyZXR1cm4gbWFwLT5yYWlkTWFw
LmxkU3Bhbk1hcFtsZF0uZGF0YUFybU1hcFthcm1JZHhdOworfQorCitzdGF0aWMgdTE2IE1SX0Fy
UGRHZXQodTMyIGFyLCB1MzIgYXJtLCBzdHJ1Y3QgTVJfRldfUkFJRF9NQVBfQUxMICptYXApCit7
CisJcmV0dXJuIG1hcC0+cmFpZE1hcC5hck1hcEluZm9bYXJdLnBkW2FybV07Cit9CisKK3N0YXRp
YyB1MTYgTVJfTGRTcGFuQXJyYXlHZXQodTMyIGxkLCB1MzIgc3Bhbiwgc3RydWN0IE1SX0ZXX1JB
SURfTUFQX0FMTCAqbWFwKQoreworCXJldHVybiBtYXAtPnJhaWRNYXAubGRTcGFuTWFwW2xkXS5z
cGFuQmxvY2tbc3Bhbl0uc3Bhbi5hcnJheVJlZjsKK30KKworc3RhdGljIHUxNiBNUl9QZERldkhh
bmRsZUdldCh1MzIgcGQsIHN0cnVjdCBNUl9GV19SQUlEX01BUF9BTEwgKm1hcCkKK3sKKwlyZXR1
cm4gbWFwLT5yYWlkTWFwLmRldkhuZGxJbmZvW3BkXS5jdXJEZXZIZGw7Cit9CisKK3UxNiBNUl9H
ZXRMRFRndElkKHUzMiBsZCwgc3RydWN0IE1SX0ZXX1JBSURfTUFQX0FMTCAqbWFwKQoreworCXJl
dHVybiBtYXAtPnJhaWRNYXAubGRTcGFuTWFwW2xkXS5sZFJhaWQudGFyZ2V0SWQ7Cit9CisKK3Ux
NiBNUl9UYXJnZXRJZFRvTGRHZXQodTMyIGxkVGd0SWQsIHN0cnVjdCBNUl9GV19SQUlEX01BUF9B
TEwgKm1hcCkKK3sKKwlyZXR1cm4gbWFwLT5yYWlkTWFwLmxkVGd0SWRUb0xkW2xkVGd0SWRdOwor
fQorCitzdGF0aWMgc3RydWN0IE1SX0xEX1NQQU4gKk1SX0xkU3BhblB0ckdldCh1MzIgbGQsIHUz
MiBzcGFuLAorCQkJCQkgIHN0cnVjdCBNUl9GV19SQUlEX01BUF9BTEwgKm1hcCkKK3sKKwlyZXR1
cm4gJm1hcC0+cmFpZE1hcC5sZFNwYW5NYXBbbGRdLnNwYW5CbG9ja1tzcGFuXS5zcGFuOworfQor
CisvKgorICogVGhpcyBmdW5jdGlvbiB3aWxsIHZhbGlkYXRlIE1hcCBpbmZvIGRhdGEgcHJvdmlk
ZWQgYnkgRlcKKyAqLwordTggTVJfVmFsaWRhdGVNYXBJbmZvKHN0cnVjdCBNUl9GV19SQUlEX01B
UF9BTEwgKm1hcCwKKwkJICAgICAgc3RydWN0IExEX0xPQURfQkFMQU5DRV9JTkZPICpsYkluZm8p
Cit7CisJc3RydWN0IE1SX0ZXX1JBSURfTUFQICpwRndSYWlkTWFwID0gJm1hcC0+cmFpZE1hcDsK
KworCWlmIChwRndSYWlkTWFwLT50b3RhbFNpemUgIT0KKwkgICAgKHNpemVvZihzdHJ1Y3QgTVJf
RldfUkFJRF9NQVApIC1zaXplb2Yoc3RydWN0IE1SX0xEX1NQQU5fTUFQKSArCisJICAgICAoc2l6
ZW9mKHN0cnVjdCBNUl9MRF9TUEFOX01BUCkgKnBGd1JhaWRNYXAtPmxkQ291bnQpKSkgeworCQlw
cmludGsoS0VSTl9FUlIgIm1lZ2FzYXM6IG1hcCBpbmZvIHN0cnVjdHVyZSBzaXplIDB4JXggaXMg
bm90IG1hdGNoaW5nIHdpdGggbGQgY291bnRcbiIsCisJCSAgICAgICAodW5zaWduZWQgaW50KSgo
c2l6ZW9mKHN0cnVjdCBNUl9GV19SQUlEX01BUCkgLQorCQkJCSAgICAgICBzaXplb2Yoc3RydWN0
IE1SX0xEX1NQQU5fTUFQKSkgKworCQkJCSAgICAgIChzaXplb2Yoc3RydWN0IE1SX0xEX1NQQU5f
TUFQKSAqCisJCQkJICAgICAgIHBGd1JhaWRNYXAtPmxkQ291bnQpKSk7CisJCXByaW50ayhLRVJO
X0VSUiAibWVnYXNhczogc3BhbiBtYXAgJXgsIHBGd1JhaWRNYXAtPnRvdGFsU2l6ZSAiCisJCSAg
ICAgICAiOiAleFxuIiwgKHVuc2lnbmVkIGludClzaXplb2Yoc3RydWN0IE1SX0xEX1NQQU5fTUFQ
KSwKKwkJICAgICAgIHBGd1JhaWRNYXAtPnRvdGFsU2l6ZSk7CisJCXJldHVybiAwOworCX0KKwor
CW1yX3VwZGF0ZV9sb2FkX2JhbGFuY2VfcGFyYW1zKG1hcCwgbGJJbmZvKTsKKworCXJldHVybiAx
OworfQorCit1MzIgTVJfR2V0U3BhbkJsb2NrKHUzMiBsZCwgdTY0IHJvdywgdTY0ICpzcGFuX2Js
aywKKwkJICAgIHN0cnVjdCBNUl9GV19SQUlEX01BUF9BTEwgKm1hcCwgaW50ICpkaXZfZXJyb3Ip
Cit7CisJc3RydWN0IE1SX1NQQU5fQkxPQ0tfSU5GTyAqcFNwYW5CbG9jayA9IE1SX0xkU3Bhbklu
Zm9HZXQobGQsIG1hcCk7CisJc3RydWN0IE1SX1FVQURfRUxFTUVOVCAgICAqcXVhZDsKKwlzdHJ1
Y3QgTVJfTERfUkFJRCAgICAgICAgICpyYWlkID0gTVJfTGRSYWlkR2V0KGxkLCBtYXApOworCXUz
MiAgICAgICAgICAgICAgICBzcGFuLCBqOworCisJZm9yIChzcGFuID0gMDsgc3BhbiA8IHJhaWQt
PnNwYW5EZXB0aDsgc3BhbisrLCBwU3BhbkJsb2NrKyspIHsKKworCQlmb3IgKGogPSAwOyBqIDwg
cFNwYW5CbG9jay0+YmxvY2tfc3Bhbl9pbmZvLm5vRWxlbWVudHM7IGorKykgeworCQkJcXVhZCA9
ICZwU3BhbkJsb2NrLT5ibG9ja19zcGFuX2luZm8ucXVhZFtqXTsKKworCQkJaWYgKHF1YWQtPmRp
ZmYgPT0gMCkgeworCQkJCSpkaXZfZXJyb3IgPSAxOworCQkJCXJldHVybiBzcGFuOworCQkJfQor
CQkJaWYgKHF1YWQtPmxvZ1N0YXJ0IDw9IHJvdyAgJiYgIHJvdyA8PSBxdWFkLT5sb2dFbmQgICYm
CisJCQkgICAgKG1lZ2FfbW9kNjQocm93LXF1YWQtPmxvZ1N0YXJ0LCBxdWFkLT5kaWZmKSkgPT0g
MCkgeworCQkJCWlmIChzcGFuX2JsayAhPSBOVUxMKSB7CisJCQkJCXU2NCAgYmxrLCBkZWJ1Z0Js
azsKKwkJCQkJYmxrID0KKwkJCQkJCW1lZ2FfZGl2NjRfMzIoCisJCQkJCQkJKHJvdy1xdWFkLT5s
b2dTdGFydCksCisJCQkJCQkJcXVhZC0+ZGlmZik7CisJCQkJCWRlYnVnQmxrID0gYmxrOworCisJ
CQkJCWJsayA9IChibGsgKyBxdWFkLT5vZmZzZXRJblNwYW4pIDw8CisJCQkJCQlyYWlkLT5zdHJp
cGVTaGlmdDsKKwkJCQkJKnNwYW5fYmxrID0gYmxrOworCQkJCX0KKwkJCQlyZXR1cm4gc3BhbjsK
KwkJCX0KKwkJfQorCX0KKwlyZXR1cm4gc3BhbjsKK30KKworLyoKKyoqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKgorKgorKiBUaGlzIHJvdXRpbmUgY2FsY3VsYXRlcyB0aGUgYXJtLCBzcGFuIGFuZCBibG9j
ayBmb3IgdGhlIHNwZWNpZmllZCBzdHJpcGUgYW5kCisqIHJlZmVyZW5jZSBpbiBzdHJpcGUuCisq
CisqIElucHV0cyA6CisqCisqICAgIGxkICAgLSBMb2dpY2FsIGRyaXZlIG51bWJlcgorKiAgICBz
dHJpcFJvdyAgICAgICAgLSBTdHJpcGUgbnVtYmVyCisqICAgIHN0cmlwUmVmICAgIC0gUmVmZXJl
bmNlIGluIHN0cmlwZQorKgorKiBPdXRwdXRzIDoKKyoKKyogICAgc3BhbiAgICAgICAgICAtIFNw
YW4gbnVtYmVyCisqICAgIGJsb2NrICAgICAgICAgLSBBYnNvbHV0ZSBCbG9jayBudW1iZXIgaW4g
dGhlIHBoeXNpY2FsIGRpc2sKKyovCit1OCBNUl9HZXRQaHlQYXJhbXModTMyIGxkLCB1NjQgc3Ry
aXBSb3csIHUxNiBzdHJpcFJlZiwgdTY0ICpwZEJsb2NrLAorCQkgICB1MTYgKnBEZXZIYW5kbGUs
IHN0cnVjdCBSQUlEX0NPTlRFWFQgKnBSQUlEX0NvbnRleHQsCisJCSAgIHN0cnVjdCBNUl9GV19S
QUlEX01BUF9BTEwgKm1hcCkKK3sKKwlzdHJ1Y3QgTVJfTERfUkFJRCAgKnJhaWQgPSBNUl9MZFJh
aWRHZXQobGQsIG1hcCk7CisJdTMyICAgICAgICAgcGQsIGFyUmVmOworCXU4ICAgICAgICAgIHBo
eXNBcm0sIHNwYW47CisJdTY0ICAgICAgICAgcm93OworCXU4CSAgICByZXR2YWwgPSBUUlVFOwor
CWludAkgICAgZXJyb3JfY29kZSA9IDA7CisKKwlyb3cgPSAgbWVnYV9kaXY2NF8zMihzdHJpcFJv
dywgcmFpZC0+cm93RGF0YVNpemUpOworCisJaWYgKHJhaWQtPmxldmVsID09IDYpIHsKKwkJLyog
bG9naWNhbCBhcm0gd2l0aGluIHJvdyAqLworCQl1MzIgbG9nQXJtID0gIG1lZ2FfbW9kNjQoc3Ry
aXBSb3csIHJhaWQtPnJvd0RhdGFTaXplKTsKKwkJdTMyIHJvd01vZCwgYXJtUSwgYXJtOworCisJ
CWlmIChyYWlkLT5yb3dTaXplID09IDApCisJCQlyZXR1cm4gRkFMU0U7CisJCS8qIGdldCBsb2dp
Y2FsIHJvdyBtb2QgKi8KKwkJcm93TW9kID0gbWVnYV9tb2Q2NChyb3csIHJhaWQtPnJvd1NpemUp
OworCQlhcm1RID0gcmFpZC0+cm93U2l6ZS0xLXJvd01vZDsgLyogaW5kZXggb2YgUSBkcml2ZSAq
LworCQlhcm0gPSBhcm1RKzErbG9nQXJtOyAvKiBkYXRhIGFsd2F5cyBsb2dpY2FsbHkgZm9sbG93
cyBRICovCisJCWlmIChhcm0gPj0gcmFpZC0+cm93U2l6ZSkgLyogaGFuZGxlIHdyYXAgY29uZGl0
aW9uICovCisJCQlhcm0gLT0gcmFpZC0+cm93U2l6ZTsKKwkJcGh5c0FybSA9ICh1OClhcm07CisJ
fSBlbHNlICB7CisJCWlmIChyYWlkLT5tb2RGYWN0b3IgPT0gMCkKKwkJCXJldHVybiBGQUxTRTsK
KwkJcGh5c0FybSA9IE1SX0xkRGF0YUFybUdldChsZCwgIG1lZ2FfbW9kNjQoc3RyaXBSb3csCisJ
CQkJCQkJICByYWlkLT5tb2RGYWN0b3IpLAorCQkJCQkgIG1hcCk7CisJfQorCisJaWYgKHJhaWQt
PnNwYW5EZXB0aCA9PSAxKSB7CisJCXNwYW4gPSAwOworCQkqcGRCbG9jayA9IHJvdyA8PCByYWlk
LT5zdHJpcGVTaGlmdDsKKwl9IGVsc2UgeworCQlzcGFuID0gKHU4KU1SX0dldFNwYW5CbG9jayhs
ZCwgcm93LCBwZEJsb2NrLCBtYXAsICZlcnJvcl9jb2RlKTsKKwkJaWYgKGVycm9yX2NvZGUgPT0g
MSkKKwkJCXJldHVybiBGQUxTRTsKKwl9CisKKwkvKiBHZXQgdGhlIGFycmF5IG9uIHdoaWNoIHRo
aXMgc3BhbiBpcyBwcmVzZW50ICovCisJYXJSZWYgICAgICAgPSBNUl9MZFNwYW5BcnJheUdldChs
ZCwgc3BhbiwgbWFwKTsKKwlwZCAgICAgICAgICA9IE1SX0FyUGRHZXQoYXJSZWYsIHBoeXNBcm0s
IG1hcCk7IC8qIEdldCB0aGUgcGQgKi8KKworCWlmIChwZCAhPSBNUl9QRF9JTlZBTElEKQorCQkv
KiBHZXQgZGV2IGhhbmRsZSBmcm9tIFBkLiAqLworCQkqcERldkhhbmRsZSA9IE1SX1BkRGV2SGFu
ZGxlR2V0KHBkLCBtYXApOworCWVsc2UgeworCQkqcERldkhhbmRsZSA9IE1SX1BEX0lOVkFMSUQ7
IC8qIHNldCBkZXYgaGFuZGxlIGFzIGludmFsaWQuICovCisJCWlmIChyYWlkLT5sZXZlbCA+PSA1
KQorCQkJcFJBSURfQ29udGV4dC0+cmVnTG9ja0ZsYWdzID0gUkVHSU9OX1RZUEVfRVhDTFVTSVZF
OworCQllbHNlIGlmIChyYWlkLT5sZXZlbCA9PSAxKSB7CisJCQkvKiBHZXQgYWx0ZXJuYXRlIFBk
LiAqLworCQkJcGQgPSBNUl9BclBkR2V0KGFyUmVmLCBwaHlzQXJtICsgMSwgbWFwKTsKKwkJCWlm
IChwZCAhPSBNUl9QRF9JTlZBTElEKQorCQkJCS8qIEdldCBkZXYgaGFuZGxlIGZyb20gUGQgKi8K
KwkJCQkqcERldkhhbmRsZSA9IE1SX1BkRGV2SGFuZGxlR2V0KHBkLCBtYXApOworCQl9CisJCXJl
dHZhbCA9IEZBTFNFOworCX0KKworCSpwZEJsb2NrICs9IHN0cmlwUmVmICsgTVJfTGRTcGFuUHRy
R2V0KGxkLCBzcGFuLCBtYXApLT5zdGFydEJsazsKKwlwUkFJRF9Db250ZXh0LT5zcGFuQXJtID0g
KHNwYW4gPDwgUkFJRF9DVFhfU1BBTkFSTV9TUEFOX1NISUZUKSB8CisJCXBoeXNBcm07CisJcmV0
dXJuIHJldHZhbDsKK30KKworLyoKKyoqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKgorKgorKiBNUl9CdWls
ZFJhaWRDb250ZXh0IGZ1bmN0aW9uCisqCisqIFRoaXMgZnVuY3Rpb24gd2lsbCBpbml0aWF0ZSBj
b21tYW5kIHByb2Nlc3NpbmcuICBUaGUgc3RhcnQvZW5kIHJvdyBhbmQgc3RyaXAKKyogaW5mb3Jt
YXRpb24gaXMgY2FsY3VsYXRlZCB0aGVuIHRoZSBsb2NrIGlzIGFjcXVpcmVkLgorKiBUaGlzIGZ1
bmN0aW9uIHdpbGwgcmV0dXJuIDAgaWYgcmVnaW9uIGxvY2sgd2FzIGFjcXVpcmVkIE9SIHJldHVy
biBudW0gc3RyaXBzCisqLwordTgKK01SX0J1aWxkUmFpZENvbnRleHQoc3RydWN0IElPX1JFUVVF
U1RfSU5GTyAqaW9faW5mbywKKwkJICAgIHN0cnVjdCBSQUlEX0NPTlRFWFQgKnBSQUlEX0NvbnRl
eHQsCisJCSAgICBzdHJ1Y3QgTVJfRldfUkFJRF9NQVBfQUxMICptYXApCit7CisJc3RydWN0IE1S
X0xEX1JBSUQgICpyYWlkOworCXUzMiAgICAgICAgIGxkLCBzdHJpcFNpemUsIHN0cmlwZV9tYXNr
OworCXU2NCAgICAgICAgIGVuZExiYSwgZW5kU3RyaXAsIGVuZFJvdywgc3RhcnRfcm93LCBzdGFy
dF9zdHJpcDsKKwl1NjQgICAgICAgICByZWdTdGFydDsKKwl1MzIgICAgICAgICByZWdTaXplOwor
CXU4ICAgICAgICAgIG51bV9zdHJpcHMsIG51bVJvd3M7CisJdTE2ICAgICAgICAgcmVmX2luX3N0
YXJ0X3N0cmlwZSwgcmVmX2luX2VuZF9zdHJpcGU7CisJdTY0ICAgICAgICAgbGRTdGFydEJsb2Nr
OworCXUzMiAgICAgICAgIG51bUJsb2NrcywgbGRUZ3RJZDsKKwl1OCAgICAgICAgICBpc1JlYWQ7
CisJdTgJICAgIHJldHZhbCA9IDA7CisKKwlsZFN0YXJ0QmxvY2sgPSBpb19pbmZvLT5sZFN0YXJ0
QmxvY2s7CisJbnVtQmxvY2tzID0gaW9faW5mby0+bnVtQmxvY2tzOworCWxkVGd0SWQgPSBpb19p
bmZvLT5sZFRndElkOworCWlzUmVhZCA9IGlvX2luZm8tPmlzUmVhZDsKKworCWxkID0gTVJfVGFy
Z2V0SWRUb0xkR2V0KGxkVGd0SWQsIG1hcCk7CisJcmFpZCA9IE1SX0xkUmFpZEdldChsZCwgbWFw
KTsKKworCXN0cmlwU2l6ZSA9IDEgPDwgcmFpZC0+c3RyaXBlU2hpZnQ7CisJc3RyaXBlX21hc2sg
PSBzdHJpcFNpemUtMTsKKwkvKgorCSAqIGNhbGN1bGF0ZSBzdGFydGluZyByb3cgYW5kIHN0cmlw
ZSwgYW5kIG51bWJlciBvZiBzdHJpcHMgYW5kIHJvd3MKKwkgKi8KKwlzdGFydF9zdHJpcCAgICAg
ICAgID0gbGRTdGFydEJsb2NrID4+IHJhaWQtPnN0cmlwZVNoaWZ0OworCXJlZl9pbl9zdGFydF9z
dHJpcGUgPSAodTE2KShsZFN0YXJ0QmxvY2sgJiBzdHJpcGVfbWFzayk7CisJZW5kTGJhICAgICAg
ICAgICAgICA9IGxkU3RhcnRCbG9jayArIG51bUJsb2NrcyAtIDE7CisJcmVmX2luX2VuZF9zdHJp
cGUgICA9ICh1MTYpKGVuZExiYSAmIHN0cmlwZV9tYXNrKTsKKwllbmRTdHJpcCAgICAgICAgICAg
ID0gZW5kTGJhID4+IHJhaWQtPnN0cmlwZVNoaWZ0OworCW51bV9zdHJpcHMgICAgICAgICAgPSAo
dTgpKGVuZFN0cmlwIC0gc3RhcnRfc3RyaXAgKyAxKTsgLyogRW5kIHN0cmlwICovCisJaWYgKHJh
aWQtPnJvd0RhdGFTaXplID09IDApCisJCXJldHVybiBGQUxTRTsKKwlzdGFydF9yb3cgICAgICAg
ICAgID0gIG1lZ2FfZGl2NjRfMzIoc3RhcnRfc3RyaXAsIHJhaWQtPnJvd0RhdGFTaXplKTsKKwll
bmRSb3cgICAgICAgICAgICAgID0gIG1lZ2FfZGl2NjRfMzIoZW5kU3RyaXAsIHJhaWQtPnJvd0Rh
dGFTaXplKTsKKwludW1Sb3dzICAgICAgICAgICAgID0gKHU4KShlbmRSb3cgLSBzdGFydF9yb3cg
KyAxKTsKKworCS8qCisJICogY2FsY3VsYXRlIHJlZ2lvbiBpbmZvLgorCSAqLworCisJLyogYXNz
dW1lIHJlZ2lvbiBpcyBhdCB0aGUgc3RhcnQgb2YgdGhlIGZpcnN0IHJvdyAqLworCXJlZ1N0YXJ0
ICAgICAgICAgICAgPSBzdGFydF9yb3cgPDwgcmFpZC0+c3RyaXBlU2hpZnQ7CisJLyogYXNzdW1l
IHRoaXMgSU8gbmVlZHMgdGhlIGZ1bGwgcm93IC0gd2UnbGwgYWRqdXN0IGlmIG5vdCB0cnVlICov
CisJcmVnU2l6ZSAgICAgICAgICAgICA9IHN0cmlwU2l6ZTsKKworCS8qIElmIElPIHNwYW5zIG1v
cmUgdGhhbiAxIHN0cmlwLCBmcCBpcyBub3QgcG9zc2libGUKKwkgICBGUCBpcyBub3QgcG9zc2li
bGUgZm9yIHdyaXRlcyBvbiBub24tMCByYWlkIGxldmVscworCSAgIEZQIGlzIG5vdCBwb3NzaWJs
ZSBpZiBMRCBpcyBub3QgY2FwYWJsZSAqLworCWlmIChudW1fc3RyaXBzID4gMSB8fCAoIWlzUmVh
ZCAmJiByYWlkLT5sZXZlbCAhPSAwKSB8fAorCSAgICAhcmFpZC0+Y2FwYWJpbGl0eS5mcENhcGFi
bGUpIHsKKwkJaW9faW5mby0+ZnBPa0ZvcklvID0gRkFMU0U7CisJfSBlbHNlIHsKKwkJaW9faW5m
by0+ZnBPa0ZvcklvID0gVFJVRTsKKwl9CisKKwlpZiAobnVtUm93cyA9PSAxKSB7CisJCS8qIHNp
bmdsZS1zdHJpcCBJT3MgY2FuIGFsd2F5cyBsb2NrIG9ubHkgdGhlIGRhdGEgbmVlZGVkICovCisJ
CWlmIChudW1fc3RyaXBzID09IDEpIHsKKwkJCXJlZ1N0YXJ0ICs9IHJlZl9pbl9zdGFydF9zdHJp
cGU7CisJCQlyZWdTaXplID0gbnVtQmxvY2tzOworCQl9CisJCS8qIG11bHRpLXN0cmlwIElPcyBh
bHdheXMgbmVlZCB0byBmdWxsIHN0cmlwZSBsb2NrZWQgKi8KKwl9IGVsc2UgeworCQlpZiAoc3Rh
cnRfc3RyaXAgPT0gKHN0YXJ0X3JvdyArIDEpICogcmFpZC0+cm93RGF0YVNpemUgLSAxKSB7CisJ
CQkvKiBJZiB0aGUgc3RhcnQgc3RyaXAgaXMgdGhlIGxhc3QgaW4gdGhlIHN0YXJ0IHJvdyAqLwor
CQkJcmVnU3RhcnQgKz0gcmVmX2luX3N0YXJ0X3N0cmlwZTsKKwkJCXJlZ1NpemUgPSBzdHJpcFNp
emUgLSByZWZfaW5fc3RhcnRfc3RyaXBlOworCQkJLyogaW5pdGlhbGl6ZSBjb3VudCB0byBzZWN0
b3JzIGZyb20gc3RhcnRyZWYgdG8gZW5kCisJCQkgICBvZiBzdHJpcCAqLworCQl9CisKKwkJaWYg
KG51bVJvd3MgPiAyKQorCQkJLyogQWRkIGNvbXBsZXRlIHJvd3MgaW4gdGhlIG1pZGRsZSBvZiB0
aGUgdHJhbnNmZXIgKi8KKwkJCXJlZ1NpemUgKz0gKG51bVJvd3MtMikgPDwgcmFpZC0+c3RyaXBl
U2hpZnQ7CisKKwkJLyogaWYgSU8gZW5kcyB3aXRoaW4gZmlyc3Qgc3RyaXAgb2YgbGFzdCByb3cg
Ki8KKwkJaWYgKGVuZFN0cmlwID09IGVuZFJvdypyYWlkLT5yb3dEYXRhU2l6ZSkKKwkJCXJlZ1Np
emUgKz0gcmVmX2luX2VuZF9zdHJpcGUrMTsKKwkJZWxzZQorCQkJcmVnU2l6ZSArPSBzdHJpcFNp
emU7CisJfQorCisJcFJBSURfQ29udGV4dC0+dGltZW91dFZhbHVlICAgICA9IG1hcC0+cmFpZE1h
cC5mcFBkSW9UaW1lb3V0U2VjOworCXBSQUlEX0NvbnRleHQtPnJlZ0xvY2tGbGFncyAgICAgPSAo
aXNSZWFkKSA/IFJFR0lPTl9UWVBFX1NIQVJFRF9SRUFEIDoKKwkJcmFpZC0+cmVnVHlwZVJlcU9u
V3JpdGU7CisJcFJBSURfQ29udGV4dC0+VmlydHVhbERpc2tUZ3RJZCA9IHJhaWQtPnRhcmdldElk
OworCXBSQUlEX0NvbnRleHQtPnJlZ0xvY2tSb3dMQkEgICAgPSByZWdTdGFydDsKKwlwUkFJRF9D
b250ZXh0LT5yZWdMb2NrTGVuZ3RoICAgID0gcmVnU2l6ZTsKKwlwUkFJRF9Db250ZXh0LT5jb25m
aWdTZXFOdW0JPSByYWlkLT5zZXFOdW07CisKKwkvKkdldCBQaHkgUGFyYW1zIG9ubHkgaWYgRlAg
Y2FwYWJsZSwgb3IgZWxzZSBsZWF2ZSBpdCB0byBNUiBmaXJtd2FyZQorCSAgdG8gZG8gdGhlIGNh
bGN1bGF0aW9uLiovCisJaWYgKGlvX2luZm8tPmZwT2tGb3JJbykgeworCQlyZXR2YWwgPSBNUl9H
ZXRQaHlQYXJhbXMobGQsIHN0YXJ0X3N0cmlwLCByZWZfaW5fc3RhcnRfc3RyaXBlLAorCQkJCQkg
JmlvX2luZm8tPnBkQmxvY2ssCisJCQkJCSAmaW9faW5mby0+ZGV2SGFuZGxlLCBwUkFJRF9Db250
ZXh0LAorCQkJCQkgbWFwKTsKKwkJLyogSWYgSU8gb24gYW4gaW52YWxpZCBQZCwgdGhlbiBGUCBp
IHNub3QgcG9zc2libGUgKi8KKwkJaWYgKGlvX2luZm8tPmRldkhhbmRsZSA9PSBNUl9QRF9JTlZB
TElEKQorCQkJaW9faW5mby0+ZnBPa0ZvcklvID0gRkFMU0U7CisJCXJldHVybiByZXR2YWw7CisJ
fSBlbHNlIGlmIChpc1JlYWQpIHsKKwkJdWludCBzdHJpcElkeDsKKwkJZm9yIChzdHJpcElkeCA9
IDA7IHN0cmlwSWR4IDwgbnVtX3N0cmlwczsgc3RyaXBJZHgrKykgeworCQkJaWYgKCFNUl9HZXRQ
aHlQYXJhbXMobGQsIHN0YXJ0X3N0cmlwICsgc3RyaXBJZHgsCisJCQkJCSAgICAgcmVmX2luX3N0
YXJ0X3N0cmlwZSwKKwkJCQkJICAgICAmaW9faW5mby0+cGRCbG9jaywKKwkJCQkJICAgICAmaW9f
aW5mby0+ZGV2SGFuZGxlLAorCQkJCQkgICAgIHBSQUlEX0NvbnRleHQsIG1hcCkpCisJCQkJcmV0
dXJuIFRSVUU7CisJCX0KKwl9CisJcmV0dXJuIFRSVUU7Cit9CisKK3ZvaWQKK21yX3VwZGF0ZV9s
b2FkX2JhbGFuY2VfcGFyYW1zKHN0cnVjdCBNUl9GV19SQUlEX01BUF9BTEwgKm1hcCwKKwkJCSAg
ICAgIHN0cnVjdCBMRF9MT0FEX0JBTEFOQ0VfSU5GTyAqbGJJbmZvKQoreworCWludCBsZENvdW50
OworCXUxNiBsZDsKKwlzdHJ1Y3QgTVJfTERfUkFJRCAqcmFpZDsKKworCWZvciAobGRDb3VudCA9
IDA7IGxkQ291bnQgPCBNQVhfTE9HSUNBTF9EUklWRVM7IGxkQ291bnQrKykgeworCQlsZCA9IE1S
X1RhcmdldElkVG9MZEdldChsZENvdW50LCBtYXApOworCQlpZiAobGQgPj0gTUFYX0xPR0lDQUxf
RFJJVkVTKSB7CisJCQlsYkluZm9bbGRDb3VudF0ubG9hZEJhbGFuY2VGbGFnID0gMDsKKwkJCWNv
bnRpbnVlOworCQl9CisKKwkJcmFpZCA9IE1SX0xkUmFpZEdldChsZCwgbWFwKTsKKworCQkvKiBU
d28gZHJpdmUgT3B0aW1hbCBSQUlEIDEgKi8KKwkJaWYgKChyYWlkLT5sZXZlbCA9PSAxKSAgJiYg
IChyYWlkLT5yb3dTaXplID09IDIpICYmCisJCSAgICAocmFpZC0+c3BhbkRlcHRoID09IDEpICYm
IHJhaWQtPmxkU3RhdGUgPT0KKwkJICAgIE1SX0xEX1NUQVRFX09QVElNQUwpIHsKKwkJCXUzMiBw
ZCwgYXJSZWY7CisKKwkJCWxiSW5mb1tsZENvdW50XS5sb2FkQmFsYW5jZUZsYWcgPSAxOworCisJ
CQkvKiBHZXQgdGhlIGFycmF5IG9uIHdoaWNoIHRoaXMgc3BhbiBpcyBwcmVzZW50ICovCisJCQlh
clJlZiA9IE1SX0xkU3BhbkFycmF5R2V0KGxkLCAwLCBtYXApOworCisJCQkvKiBHZXQgdGhlIFBk
ICovCisJCQlwZCA9IE1SX0FyUGRHZXQoYXJSZWYsIDAsIG1hcCk7CisJCQkvKiBHZXQgZGV2IGhh
bmRsZSBmcm9tIFBkICovCisJCQlsYkluZm9bbGRDb3VudF0ucmFpZDFEZXZIYW5kbGVbMF0gPQor
CQkJCU1SX1BkRGV2SGFuZGxlR2V0KHBkLCBtYXApOworCQkJLyogR2V0IHRoZSBQZCAqLworCQkJ
cGQgPSBNUl9BclBkR2V0KGFyUmVmLCAxLCBtYXApOworCisJCQkvKiBHZXQgdGhlIGRldiBoYW5k
bGUgZnJvbSBQZCAqLworCQkJbGJJbmZvW2xkQ291bnRdLnJhaWQxRGV2SGFuZGxlWzFdID0KKwkJ
CQlNUl9QZERldkhhbmRsZUdldChwZCwgbWFwKTsKKwkJfSBlbHNlCisJCQlsYkluZm9bbGRDb3Vu
dF0ubG9hZEJhbGFuY2VGbGFnID0gMDsKKwl9Cit9CisKK3U4IG1lZ2FzYXNfZ2V0X2Jlc3RfYXJt
KHN0cnVjdCBMRF9MT0FEX0JBTEFOQ0VfSU5GTyAqbGJJbmZvLCB1OCBhcm0sIHU2NCBibG9jaywK
KwkJCXUzMiBjb3VudCkKK3sKKwl1MTYgICAgIHBlbmQwLCBwZW5kMTsKKwl1NjQgICAgIGRpZmYw
LCBkaWZmMTsKKwl1OCAgICAgIGJlc3RBcm07CisKKwkvKiBnZXQgdGhlIHBlbmRpbmcgY21kcyBm
b3IgdGhlIGRhdGEgYW5kIG1pcnJvciBhcm1zICovCisJcGVuZDAgPSBhdG9taWNfcmVhZCgmbGJJ
bmZvLT5zY3NpX3BlbmRpbmdfY21kc1swXSk7CisJcGVuZDEgPSBhdG9taWNfcmVhZCgmbGJJbmZv
LT5zY3NpX3BlbmRpbmdfY21kc1sxXSk7CisKKwkvKiBEZXRlcm1pbmUgdGhlIGRpc2sgd2hvc2Ug
aGVhZCBpcyBuZWFyZXIgdG8gdGhlIHJlcS4gYmxvY2sgKi8KKwlkaWZmMCA9IEFCU19ESUZGKGJs
b2NrLCBsYkluZm8tPmxhc3RfYWNjZXNzZWRfYmxvY2tbMF0pOworCWRpZmYxID0gQUJTX0RJRkYo
YmxvY2ssIGxiSW5mby0+bGFzdF9hY2Nlc3NlZF9ibG9ja1sxXSk7CisJYmVzdEFybSA9IChkaWZm
MCA8PSBkaWZmMSA/IDAgOiAxKTsKKworCWlmICgoYmVzdEFybSA9PSBhcm0gJiYgcGVuZDAgPiBw
ZW5kMSArIDE2KSAgfHwKKwkgICAgKGJlc3RBcm0gIT0gYXJtICYmIHBlbmQxID4gcGVuZDAgKyAx
NikpCisJCWJlc3RBcm0gXj0gMTsKKworCS8qIFVwZGF0ZSB0aGUgbGFzdCBhY2Nlc3NlZCBibG9j
ayBvbiB0aGUgY29ycmVjdCBwZCAqLworCWxiSW5mby0+bGFzdF9hY2Nlc3NlZF9ibG9ja1tiZXN0
QXJtXSA9IGJsb2NrICsgY291bnQgLSAxOworCisJcmV0dXJuIGJlc3RBcm07Cit9CisKK3UxNiBn
ZXRfdXBkYXRlZF9kZXZfaGFuZGxlKHN0cnVjdCBMRF9MT0FEX0JBTEFOQ0VfSU5GTyAqbGJJbmZv
LAorCQkJICAgc3RydWN0IElPX1JFUVVFU1RfSU5GTyAqaW9faW5mbykKK3sKKwl1OCBhcm0sIG9s
ZF9hcm07CisJdTE2IGRldkhhbmRsZTsKKworCW9sZF9hcm0gPSBsYkluZm8tPnJhaWQxRGV2SGFu
ZGxlWzBdID09IGlvX2luZm8tPmRldkhhbmRsZSA/IDAgOiAxOworCisJLyogZ2V0IGJlc3QgbmV3
IGFybSAqLworCWFybSAgPSBtZWdhc2FzX2dldF9iZXN0X2FybShsYkluZm8sIG9sZF9hcm0sIGlv
X2luZm8tPmxkU3RhcnRCbG9jaywKKwkJCQkgICAgaW9faW5mby0+bnVtQmxvY2tzKTsKKwlkZXZI
YW5kbGUgPSBsYkluZm8tPnJhaWQxRGV2SGFuZGxlW2FybV07CisJYXRvbWljX2luYygmbGJJbmZv
LT5zY3NpX3BlbmRpbmdfY21kc1thcm1dKTsKKworCXJldHVybiBkZXZIYW5kbGU7Cit9Cg==
--00163683204e29bc4004976a3fc6--
