Return-Path: <SRS0=ZPSI=2K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E86EBC43603
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 14:36:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE60F206CB
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 14:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576852586;
	bh=QffAXIO8wTj9TESbd4JgFXRKt1Sp4VQVkqLq8G2C0y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ho9gvlondortqlPWR5HoyYZdMbPvSl+35qKhU9rvEEuV2UJW6maPIr+R3Ieh+dph/
	 WmVB0tjZhtWH7Tf6Kbc6EkOV+hKKIPorup80sL0l9dxvqShVkyLeC9SLg4h7+pmcDz
	 PDmTPUCtGknMlCrLlyZoZRi3StEDWQ34rVznuf6w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728320AbfLTOe6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Dec 2019 09:34:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:39246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728293AbfLTOe5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Dec 2019 09:34:57 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 842F324688;
        Fri, 20 Dec 2019 14:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576852496;
        bh=QffAXIO8wTj9TESbd4JgFXRKt1Sp4VQVkqLq8G2C0y8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W5PEbGh1cYktLyxpr6EQCKa2Viv4bSFSIj1iq/PQ9a6O/vKBptgASHrmCBke/K1rt
         4+TAXD3bLADpQ4rilvltZK/r3D81h7vQq0GNc7Iuqe1431j/yi77FAO4Fh8yVxviHd
         l900RvZ5x+Lj1QaC3ABk266J29kSevwBKb08CYgA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roman Bolshakov <r.bolshakov@yadro.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 17/34] scsi: qla2xxx: Fix PLOGI payload and ELS IOCB dump length
Date:   Fri, 20 Dec 2019 09:34:16 -0500
Message-Id: <20191220143433.9922-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191220143433.9922-1-sashal@kernel.org>
References: <20191220143433.9922-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Roman Bolshakov <r.bolshakov@yadro.com>

[ Upstream commit 0334cdea1fba36fad8bdf9516f267ce01de625f7 ]

The size of the buffer is hardcoded as 0x70 or 112 bytes, while the size of
ELS IOCB is 0x40 and the size of PLOGI payload returned by Get Parameters
command is 0x74.

Cc: Quinn Tran <qutran@marvell.com>
Link: https://lore.kernel.org/r/20191125165702.1013-9-r.bolshakov@yadro.com
Acked-by: Himanshu Madhani <hmadhani@marvell.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index c699bbb8485bb..7e47321e003c8 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2537,7 +2537,8 @@ qla24xx_els_logo_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
 		ql_dbg(ql_dbg_io + ql_dbg_buffer, vha, 0x3073,
 		    "PLOGI ELS IOCB:\n");
 		ql_dump_buffer(ql_log_info, vha, 0x0109,
-		    (uint8_t *)els_iocb, 0x70);
+		    (uint8_t *)els_iocb,
+		    sizeof(*els_iocb));
 	} else {
 		els_iocb->tx_byte_count = sizeof(struct els_logo_payload);
 		els_iocb->tx_address[0] =
@@ -2703,7 +2704,8 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
 
 	ql_dbg(ql_dbg_disc + ql_dbg_buffer, vha, 0x3073, "PLOGI buffer:\n");
 	ql_dump_buffer(ql_dbg_disc + ql_dbg_buffer, vha, 0x0109,
-	    (uint8_t *)elsio->u.els_plogi.els_plogi_pyld, 0x70);
+	    (uint8_t *)elsio->u.els_plogi.els_plogi_pyld,
+	    sizeof(*elsio->u.els_plogi.els_plogi_pyld));
 
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS) {
-- 
2.20.1

