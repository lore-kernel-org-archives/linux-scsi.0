Return-Path: <SRS0=OHhN=ZA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD3E0C5DF60
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 12:05:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1E8821D7E
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 12:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573214748;
	bh=NGdbHR2Y6ZJaJpbPKyIQqicj7ZPnG+k3WHelTDg6trs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=va3howBUDuFglVQaZI9YWjH+qM/6I6ODepn7vKQE3Qe8JGJtqXjyQidlmVnGfKTL2
	 sQCpWmo1dI7jQ9z9iKcJEUNQdRUv2sM+UpHm3uuL+vh+P4hCdZc73EeHKorCvFhAQ5
	 NZG95PmhSpiR5CqGPQg2W9yuWyUrny5wklWB7NRM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390146AbfKHMFo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Nov 2019 07:05:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:54806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389446AbfKHLl0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 8 Nov 2019 06:41:26 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4928921D82;
        Fri,  8 Nov 2019 11:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213286;
        bh=NGdbHR2Y6ZJaJpbPKyIQqicj7ZPnG+k3WHelTDg6trs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2mpRgeUtqheFsraWTonWwdKRWlZ4w6URtgMUOkk/1YiI8gIK2V+l5gvbOBrMFInpJ
         RoTvVhdU73ddOLoBK0UdUE3aycXul5WVDQLnvfpIin7RE3JEPDgxdaYmsVPPHg2sVS
         gSCobl2aFYsFnpRCt0hBZhSA96/7PLa+RkJ+dvKM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quinn Tran <quinn.tran@cavium.com>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 146/205] scsi: qla2xxx: Fix duplicate switch's Nport ID entries
Date:   Fri,  8 Nov 2019 06:36:53 -0500
Message-Id: <20191108113752.12502-146-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

[ Upstream commit f3a03ee1102a44ccbd2c5de80a6e862ba23e9b55 ]

Current code relies on switch to provide a unique combination of WWPN +
NPORTID to tract an FC port.  This patch tries to detect a case where switch
data base can get corrupted where multiple WWPNs can have the same Nport ID.
The 1st Nport ID on the list will be kept while the duplicate Nport ID will be
discarded.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_gs.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index d611cf722244c..b8d3403c3c85a 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3902,9 +3902,10 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t *vha, srb_t *sp)
 	fc_port_t *fcport;
 	u32 i, rc;
 	bool found;
-	struct fab_scan_rp *rp;
+	struct fab_scan_rp *rp, *trp;
 	unsigned long flags;
 	u8 recheck = 0;
+	u16 dup = 0, dup_cnt = 0;
 
 	ql_dbg(ql_dbg_disc, vha, 0xffff,
 	    "%s enter\n", __func__);
@@ -3935,6 +3936,7 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t *vha, srb_t *sp)
 
 	for (i = 0; i < vha->hw->max_fibre_devices; i++) {
 		u64 wwn;
+		int k;
 
 		rp = &vha->scan.l[i];
 		found = false;
@@ -3943,6 +3945,20 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t *vha, srb_t *sp)
 		if (wwn == 0)
 			continue;
 
+		/* Remove duplicate NPORT ID entries from switch data base */
+		for (k = i + 1; k < vha->hw->max_fibre_devices; k++) {
+			trp = &vha->scan.l[k];
+			if (rp->id.b24 == trp->id.b24) {
+				dup = 1;
+				dup_cnt++;
+				ql_dbg(ql_dbg_disc + ql_dbg_verbose,
+				    vha, 0xffff,
+				    "Detected duplicate NPORT ID from switch data base: ID %06x WWN %8phN WWN %8phN\n",
+				    rp->id.b24, rp->port_name, trp->port_name);
+				memset(trp, 0, sizeof(*trp));
+			}
+		}
+
 		if (!memcmp(rp->port_name, vha->port_name, WWN_SIZE))
 			continue;
 
@@ -3982,6 +3998,12 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t *vha, srb_t *sp)
 		}
 	}
 
+	if (dup) {
+		ql_log(ql_log_warn, vha, 0xffff,
+		    "Detected %d duplicate NPORT ID(s) from switch data base\n",
+		    dup_cnt);
+	}
+
 	/*
 	 * Logout all previous fabric dev marked lost, except FCP2 devices.
 	 */
-- 
2.20.1

