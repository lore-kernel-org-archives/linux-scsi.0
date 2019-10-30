Return-Path: <SRS0=//Xo=YX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 912BBCA9EC7
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 15:53:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F932208C0
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 15:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572450825;
	bh=WuQLmPEfBsjVnEpbu69Sp690ofNhB83WUOxpWR1JbBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=t00UX+82Hg8iO2aQPBkXqheWaODxqQ/Q5/16kMYngGfqnRhD29aEgn01tEkpxlAcG
	 i461oVHhm35MFrKbew8j/JkrdLRlbBop6Pdz3TO8eA/NJ0tX/vRAyb8cRgio0Z5NUM
	 nxHYfUutY6lGjjO0mYfShL/pSeces9ABFi7KMFUw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727641AbfJ3Pxh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Oct 2019 11:53:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:54874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728213AbfJ3Pxg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Oct 2019 11:53:36 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 860E4208E3;
        Wed, 30 Oct 2019 15:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572450815;
        bh=WuQLmPEfBsjVnEpbu69Sp690ofNhB83WUOxpWR1JbBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kD3H+j8oZxE44EUXrQB3KJiNtoDjWL3mB9XH1x9Dvig5+mlr2L7WYOLZQRcZMSE9R
         dDwcxHNeMXsg9KpwobX0O3W/1jMb90R6t2QI4Zu7EGKILQmF9a45/yG1idqzThHSp7
         VDhvKrkzpq2h68tgpldVQialYtcNWGeiZPh0SO6M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 57/81] scsi: target: core: Do not overwrite CDB byte 1
Date:   Wed, 30 Oct 2019 11:49:03 -0400
Message-Id: <20191030154928.9432-57-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030154928.9432-1-sashal@kernel.org>
References: <20191030154928.9432-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bodo Stroesser <bstroesser@ts.fujitsu.com>

[ Upstream commit 27e84243cb63601a10e366afe3e2d05bb03c1cb5 ]

passthrough_parse_cdb() - used by TCMU and PSCSI - attepts to reset the LUN
field of SCSI-2 CDBs (bits 5,6,7 of byte 1).  The current code is wrong as
for newer commands not having the LUN field it overwrites relevant command
bits (e.g. for SECURITY PROTOCOL IN / OUT). We think this code was
unnecessary from the beginning or at least it is no longer useful. So we
remove it entirely.

Link: https://lore.kernel.org/r/12498eab-76fd-eaad-1316-c2827badb76a@ts.fujitsu.com
Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_device.c | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 04bf2acd3800d..2d19f0e332b01 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1074,27 +1074,6 @@ passthrough_parse_cdb(struct se_cmd *cmd,
 	struct se_device *dev = cmd->se_dev;
 	unsigned int size;
 
-	/*
-	 * Clear a lun set in the cdb if the initiator talking to use spoke
-	 * and old standards version, as we can't assume the underlying device
-	 * won't choke up on it.
-	 */
-	switch (cdb[0]) {
-	case READ_10: /* SBC - RDProtect */
-	case READ_12: /* SBC - RDProtect */
-	case READ_16: /* SBC - RDProtect */
-	case SEND_DIAGNOSTIC: /* SPC - SELF-TEST Code */
-	case VERIFY: /* SBC - VRProtect */
-	case VERIFY_16: /* SBC - VRProtect */
-	case WRITE_VERIFY: /* SBC - VRProtect */
-	case WRITE_VERIFY_12: /* SBC - VRProtect */
-	case MAINTENANCE_IN: /* SPC - Parameter Data Format for SA RTPG */
-		break;
-	default:
-		cdb[1] &= 0x1f; /* clear logical unit number */
-		break;
-	}
-
 	/*
 	 * For REPORT LUNS we always need to emulate the response, for everything
 	 * else, pass it up.
-- 
2.20.1

