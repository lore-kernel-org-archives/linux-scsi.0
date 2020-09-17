Return-Path: <SRS0=qxeY=C2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CE19C43463
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Sep 2020 23:18:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25AF421734
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Sep 2020 23:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600384736;
	bh=tKQSOYjSGb/l16cUnGFYsJD8Lfi4s5G8oKpqAWkWXm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=sHoxyAVTFlpRhxCk0Cm2Yg/Dxd1WipP4K2l2Z0Cqvmjln3A0MT+R3EhDNYJ3P7fy0
	 4FE1wEsF/pZKRdEDuw+eonv5JeV+ZuuHDO5XZgrKmwlSruckbiXfRSReg3Cw3g9sm5
	 YASzC3Iz19aKu+/Z2qyiCNKimODI9Nf/Na8t+Dr0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbgIQXSz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Sep 2020 19:18:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:55870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726102AbgIQXSx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Sep 2020 19:18:53 -0400
Received: from dhcp-10-100-145-180.wdl.wdc.com (unknown [199.255.45.60])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5E1220853;
        Thu, 17 Sep 2020 23:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600384731;
        bh=tKQSOYjSGb/l16cUnGFYsJD8Lfi4s5G8oKpqAWkWXm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H4niwTaR4xAhfQ9M0hNyodkynAdh0cO2ahkI9zVSnnhedO6ldoNKT5mOiUTtBuORz
         7D1jxoSAdkHbgU+b1hFcnLyLfLwQzWXHFq9NOJyr+SuGh3SLX5SrTbMfMkgxWYR44W
         onJVO3rkM1uOmUp/U7qP/nU/ZijcZF2BgFMtZYok=
From:   Keith Busch <kbusch@kernel.org>
To:     linux-nvme@lists.infradead.org, sagi@grimberg.me, hch@lst.de,
        linux-block@vger.kernel.org
Cc:     axboe@kernel.dk, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCHv3 3/4] scsi: update additional sense codes list
Date:   Thu, 17 Sep 2020 16:18:40 -0700
Message-Id: <20200917231841.4029747-4-kbusch@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200917231841.4029747-1-kbusch@kernel.org>
References: <20200917231841.4029747-1-kbusch@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Damien Le Moal <damien.lemoal@wdc.com>

Add missing Additional Sense Codes listed in
http://www.t10.org/lists/asc-num.txt.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sense_codes.h | 54 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 53 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sense_codes.h b/drivers/scsi/sense_codes.h
index 201a536688de..805d4c13d070 100644
--- a/drivers/scsi/sense_codes.h
+++ b/drivers/scsi/sense_codes.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
  * The canonical list of T10 Additional Sense Codes is available at:
- * http://www.t10.org/lists/asc-num.txt [most recent: 20141221]
+ * http://www.t10.org/lists/asc-num.txt [most recent: 20200817]
  */
 
 SENSE_CODE(0x0000, "No additional sense information")
@@ -29,6 +29,7 @@ SENSE_CODE(0x001E, "Conflicting SA creation request")
 SENSE_CODE(0x001F, "Logical unit transitioning to another power condition")
 SENSE_CODE(0x0020, "Extended copy information available")
 SENSE_CODE(0x0021, "Atomic command aborted due to ACA")
+SENSE_CODE(0x0022, "Deferred microcode is pending")
 
 SENSE_CODE(0x0100, "No index/sector signal")
 
@@ -72,6 +73,9 @@ SENSE_CODE(0x041F, "Logical unit not ready, microcode download required")
 SENSE_CODE(0x0420, "Logical unit not ready, logical unit reset required")
 SENSE_CODE(0x0421, "Logical unit not ready, hard reset required")
 SENSE_CODE(0x0422, "Logical unit not ready, power cycle required")
+SENSE_CODE(0x0423, "Logical unit not ready, affiliation required")
+SENSE_CODE(0x0424, "Depopulation in progress")
+SENSE_CODE(0x0425, "Depopulation restoration in progress")
 
 SENSE_CODE(0x0500, "Logical unit does not respond to selection")
 
@@ -104,6 +108,17 @@ SENSE_CODE(0x0B06, "Warning - non-volatile cache now volatile")
 SENSE_CODE(0x0B07, "Warning - degraded power to non-volatile cache")
 SENSE_CODE(0x0B08, "Warning - power loss expected")
 SENSE_CODE(0x0B09, "Warning - device statistics notification active")
+SENSE_CODE(0x0B0A, "Warning - high critical temperature limit exceeded")
+SENSE_CODE(0x0B0B, "Warning - low critical temperature limit exceeded")
+SENSE_CODE(0x0B0C, "Warning - high operating temperature limit exceeded")
+SENSE_CODE(0x0B0D, "Warning - low operating temperature limit exceeded")
+SENSE_CODE(0x0B0E, "Warning - high critical humidity limit exceeded")
+SENSE_CODE(0x0B0F, "Warning - low critical humidity limit exceeded")
+SENSE_CODE(0x0B10, "Warning - high operating humidity limit exceeded")
+SENSE_CODE(0x0B11, "Warning - low operating humidity limit exceeded")
+SENSE_CODE(0x0B12, "Warning - microcode security at risk")
+SENSE_CODE(0x0B13, "Warning - microcode digital signature validation failure")
+SENSE_CODE(0x0B14, "Warning - physical element status change")
 
 SENSE_CODE(0x0C00, "Write error")
 SENSE_CODE(0x0C01, "Write error - recovered with auto reallocation")
@@ -122,6 +137,8 @@ SENSE_CODE(0x0C0D, "Write error - not enough unsolicited data")
 SENSE_CODE(0x0C0E, "Multiple write errors")
 SENSE_CODE(0x0C0F, "Defects in error window")
 SENSE_CODE(0x0C10, "Incomplete multiple atomic write operations")
+SENSE_CODE(0x0C11, "Write error - recovery scan needed")
+SENSE_CODE(0x0C12, "Write error - insufficient zone resources")
 
 SENSE_CODE(0x0D00, "Error detected by third party temporary initiator")
 SENSE_CODE(0x0D01, "Third party device failure")
@@ -242,6 +259,9 @@ SENSE_CODE(0x2009, "Access denied - invalid LU identifier")
 SENSE_CODE(0x200A, "Access denied - invalid proxy token")
 SENSE_CODE(0x200B, "Access denied - ACL LUN conflict")
 SENSE_CODE(0x200C, "Illegal command when not in append-only mode")
+SENSE_CODE(0x200D, "Not an administrative logical unit")
+SENSE_CODE(0x200E, "Not a subsidiary logical unit")
+SENSE_CODE(0x200F, "Not a conglomerate logical unit")
 
 SENSE_CODE(0x2100, "Logical block address out of range")
 SENSE_CODE(0x2101, "Invalid element address")
@@ -251,6 +271,8 @@ SENSE_CODE(0x2104, "Unaligned write command")
 SENSE_CODE(0x2105, "Write boundary violation")
 SENSE_CODE(0x2106, "Attempt to read invalid data")
 SENSE_CODE(0x2107, "Read boundary violation")
+SENSE_CODE(0x2108, "Misaligned write command")
+SENSE_CODE(0x2109, "Attempt to access gap zone")
 
 SENSE_CODE(0x2200, "Illegal function (use 20 00, 24 00, or 26 00)")
 
@@ -275,6 +297,7 @@ SENSE_CODE(0x2405, "Security working key frozen")
 SENSE_CODE(0x2406, "Nonce not unique")
 SENSE_CODE(0x2407, "Nonce timestamp out of range")
 SENSE_CODE(0x2408, "Invalid XCDB")
+SENSE_CODE(0x2409, "Invalid fast format")
 
 SENSE_CODE(0x2500, "Logical unit not supported")
 
@@ -297,6 +320,10 @@ SENSE_CODE(0x260F, "Invalid data-out buffer integrity check value")
 SENSE_CODE(0x2610, "Data decryption key fail limit reached")
 SENSE_CODE(0x2611, "Incomplete key-associated data set")
 SENSE_CODE(0x2612, "Vendor specific key reference not found")
+SENSE_CODE(0x2613, "Application tag mode page is invalid")
+SENSE_CODE(0x2614, "Tape stream mirroring prevented")
+SENSE_CODE(0x2615, "Copy source or copy destination not authorized")
+SENSE_CODE(0x2616, "Fast copy not possible")
 
 SENSE_CODE(0x2700, "Write protected")
 SENSE_CODE(0x2701, "Hardware write protected")
@@ -342,6 +369,7 @@ SENSE_CODE(0x2A12, "Data encryption parameters changed by vendor specific event"
 SENSE_CODE(0x2A13, "Data encryption key instance counter has changed")
 SENSE_CODE(0x2A14, "SA creation capabilities data has changed")
 SENSE_CODE(0x2A15, "Medium removal prevention preempted")
+SENSE_CODE(0x2A16, "Zone reset write pointer recommended")
 
 SENSE_CODE(0x2B00, "Copy cannot execute since host cannot disconnect")
 
@@ -360,6 +388,11 @@ SENSE_CODE(0x2C0B, "Not reserved")
 SENSE_CODE(0x2C0C, "Orwrite generation does not match")
 SENSE_CODE(0x2C0D, "Reset write pointer not allowed")
 SENSE_CODE(0x2C0E, "Zone is offline")
+SENSE_CODE(0x2C0F, "Stream not open")
+SENSE_CODE(0x2C10, "Unwritten data in zone")
+SENSE_CODE(0x2C11, "Descriptor format sense data required")
+SENSE_CODE(0x2C12, "Zone is inactive")
+SENSE_CODE(0x2C13, "Well known logical unit access required")
 
 SENSE_CODE(0x2D00, "Overwrite error on update in place")
 
@@ -395,6 +428,8 @@ SENSE_CODE(0x3100, "Medium format corrupted")
 SENSE_CODE(0x3101, "Format command failed")
 SENSE_CODE(0x3102, "Zoned formatting failed due to spare linking")
 SENSE_CODE(0x3103, "Sanitize command failed")
+SENSE_CODE(0x3104, "Depopulation failed")
+SENSE_CODE(0x3105, "Depopulation restoration failed")
 
 SENSE_CODE(0x3200, "No defect spare location available")
 SENSE_CODE(0x3201, "Defect list update failure")
@@ -419,6 +454,7 @@ SENSE_CODE(0x3802, "Esn - power management class event")
 SENSE_CODE(0x3804, "Esn - media class event")
 SENSE_CODE(0x3806, "Esn - device busy class event")
 SENSE_CODE(0x3807, "Thin Provisioning soft threshold reached")
+SENSE_CODE(0x3808, "Depopulation interrupted")
 
 SENSE_CODE(0x3900, "Saving parameters not supported")
 
@@ -456,6 +492,7 @@ SENSE_CODE(0x3B19, "Element enabled")
 SENSE_CODE(0x3B1A, "Data transfer device removed")
 SENSE_CODE(0x3B1B, "Data transfer device inserted")
 SENSE_CODE(0x3B1C, "Too many logical objects on partition to support operation")
+SENSE_CODE(0x3B20, "Element static information changed")
 
 SENSE_CODE(0x3D00, "Invalid bits in identify message")
 
@@ -488,6 +525,11 @@ SENSE_CODE(0x3F13, "iSCSI IP address removed")
 SENSE_CODE(0x3F14, "iSCSI IP address changed")
 SENSE_CODE(0x3F15, "Inspect referrals sense descriptors")
 SENSE_CODE(0x3F16, "Microcode has been changed without reset")
+SENSE_CODE(0x3F17, "Zone transition to full")
+SENSE_CODE(0x3F18, "Bind completed")
+SENSE_CODE(0x3F19, "Bind redirected")
+SENSE_CODE(0x3F1A, "Subsidiary binding changed")
+
 /*
  *	SENSE_CODE(0x40NN, "Ram failure")
  *	SENSE_CODE(0x40NN, "Diagnostic failure on component nn")
@@ -589,6 +631,9 @@ SENSE_CODE(0x550B, "Insufficient power for operation")
 SENSE_CODE(0x550C, "Insufficient resources to create rod")
 SENSE_CODE(0x550D, "Insufficient resources to create rod token")
 SENSE_CODE(0x550E, "Insufficient zone resources")
+SENSE_CODE(0x550F, "Insufficient zone resources to complete write")
+SENSE_CODE(0x5510, "Maximum number of streams open")
+SENSE_CODE(0x5511, "Insufficient resources to bind")
 
 SENSE_CODE(0x5700, "Unable to recover table-of-contents")
 
@@ -692,6 +737,7 @@ SENSE_CODE(0x5D69, "Firmware impending failure throughput performance")
 SENSE_CODE(0x5D6A, "Firmware impending failure seek time performance")
 SENSE_CODE(0x5D6B, "Firmware impending failure spin-up retry count")
 SENSE_CODE(0x5D6C, "Firmware impending failure drive calibration retry count")
+SENSE_CODE(0x5D73, "Media impending failure endurance limit met")
 SENSE_CODE(0x5DFF, "Failure prediction threshold exceeded (false)")
 
 SENSE_CODE(0x5E00, "Low power condition on")
@@ -744,6 +790,8 @@ SENSE_CODE(0x6708, "Assign failure occurred")
 SENSE_CODE(0x6709, "Multiply assigned logical unit")
 SENSE_CODE(0x670A, "Set target port groups command failed")
 SENSE_CODE(0x670B, "ATA device feature not enabled")
+SENSE_CODE(0x670C, "Command rejected")
+SENSE_CODE(0x670D, "Explicit bind not allowed")
 
 SENSE_CODE(0x6800, "Logical unit not configured")
 SENSE_CODE(0x6801, "Subsidiary logical unit not configured")
@@ -772,6 +820,10 @@ SENSE_CODE(0x6F04, "Media region code is mismatched to logical unit region")
 SENSE_CODE(0x6F05, "Drive region must be permanent/region reset count error")
 SENSE_CODE(0x6F06, "Insufficient block count for binding nonce recording")
 SENSE_CODE(0x6F07, "Conflict in binding nonce recording")
+SENSE_CODE(0x6F08, "Insufficient permission")
+SENSE_CODE(0x6F09, "Invalid drive-host pairing server")
+SENSE_CODE(0x6F0A, "Drive-host pairing suspended")
+
 /*
  *	SENSE_CODE(0x70NN, "Decompression exception short algorithm id of nn")
  */
-- 
2.24.1

