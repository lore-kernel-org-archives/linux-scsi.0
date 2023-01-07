Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CAA5C46467
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Jan 2023 23:27:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232596AbjAGX14 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 7 Jan 2023 18:27:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjAGX1z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Jan 2023 18:27:55 -0500
Received: from msg-1.mailo.com (msg-1.mailo.com [213.182.54.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE1B8B29;
        Sat,  7 Jan 2023 15:27:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailo.com; s=mailo;
        t=1673134064; bh=243Y0TzJ2D908v665xahpwQFJSh6hNC7mDR/20UOnKs=;
        h=X-EA-Auth:Date:From:To:Cc:Subject:Message-ID:MIME-Version:
         Content-Type;
        b=MSojlK4Y3uTQeDIrPA85syXVgUiNaCPqOYoimBfHLPOKfoj1idE3cvx/akKaLLwAh
         imy9wU64dwn38JGEUCxihO/YJnTfK0nzPurH5ZTpPFqC422fsTQ0xrGCEZgdcsHFBU
         Sv4ksY5vZpMh2eal51n/YrkzX3pXLj1iK94YPH70=
Received: by b-3.in.mailobj.net [192.168.90.13] with ESMTP
        via ip-206.mailobj.net [213.182.55.206]
        Sun,  8 Jan 2023 00:27:44 +0100 (CET)
X-EA-Auth: UMiRvEteWx7loArsC6EMhcnhAXqKgsRmaWo8RYB7LYSw+k2e8VklI5XMtcUsExo8E3EuU7LzyqXlqLeh4MXK9JHdMWo16H6C
Date:   Sun, 8 Jan 2023 04:57:38 +0530
From:   Deepak R Varma <drv@mailo.com>
To:     James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Saurabh Singh Sengar <ssengar@microsoft.com>,
        Praveen Kumar <kumarpraveen@linux.microsoft.com>,
        Deepak R Varma <drv@mailo.com>
Subject: [PATCH] scsi: elx: libefc_sli: Optimize the same if/else blocks
Message-ID: <Y7n/6ls2xpUkiGQf@ubun2204.myguest.virtualbox.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The if and else branches have the exact same code, which then always
executes independent of the condition evaluation. Simplify the code by
removing the redundant branching.
Issue identified using the cond_no_effect Coccinelle semantic patch.

Signed-off-by: Deepak R Varma <drv@mailo.com>
---
 drivers/scsi/elx/libefc_sli/sli4.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/scsi/elx/libefc_sli/sli4.c b/drivers/scsi/elx/libefc_sli/sli4.c
index b8c048cdb17f..833fe4bd012e 100644
--- a/drivers/scsi/elx/libefc_sli/sli4.c
+++ b/drivers/scsi/elx/libefc_sli/sli4.c
@@ -2317,12 +2317,7 @@ sli_xmit_bls_rsp64_wqe(struct sli4 *sli, void *buf,
 		SLI4_GENERIC_CONTEXT_VPI << SLI4_BLS_RSP_WQE_CT_SHFT;
 		bls->context_tag = cpu_to_le16(params->vpi);

-		if (params->s_id != U32_MAX)
-			bls->local_n_port_id_dword |=
-				cpu_to_le32(params->s_id & 0x00ffffff);
-		else
-			bls->local_n_port_id_dword |=
-				cpu_to_le32(params->s_id & 0x00ffffff);
+		bls->local_n_port_id_dword |= cpu_to_le32(params->s_id & 0x00ffffff);

 		dw_ridflags = (dw_ridflags & ~SLI4_BLS_RSP_RID) |
 			       (params->d_id & SLI4_BLS_RSP_RID);
--
2.34.1



