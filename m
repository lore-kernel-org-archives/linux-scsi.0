Return-Path: <SRS0=ZPSI=2K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A12DC43603
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 14:36:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FBA0218AC
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 14:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576852590;
	bh=Y1uIUqGV/gU6SzNRPB7L721NVR+rAnUh4bOBc61BYC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=BWOZuw7/JP3g84ymZxKD3liiRsvjM+OvrxEBxIYMw6R0S04nH6XEP7PmMQEmUe0Jm
	 K8g4FCEiBxyEYGZApvy7Hk9EW+b3stBLFn86CPGoN7Ueq8KQzLL84m+Ozy2C489L/Y
	 fjHNfyftZ9HiiDsYMkcaSyCf//0BG5TjYFtvCNwk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbfLTOg0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Dec 2019 09:36:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:39276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728318AbfLTOe6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Dec 2019 09:34:58 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D24642465E;
        Fri, 20 Dec 2019 14:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576852497;
        bh=Y1uIUqGV/gU6SzNRPB7L721NVR+rAnUh4bOBc61BYC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RXw6Ic14RFcYGtsW8GFncp2CGvutn6m0HpMg/dJV/7Gj8VQ47dQpqLFRDZz7BhAKK
         uHnIPCVp3NTeccenV3Tjd8Lr1vQw3qTCBol14H4OeDo+DoCztBYD25FQcNeOyQfOBQ
         IjU+jHiG4Oz76DDi+PFiS99W4vDGXouqk6C7k4wg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roman Bolshakov <r.bolshakov@yadro.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 18/34] scsi: qla2xxx: Configure local loop for N2N target
Date:   Fri, 20 Dec 2019 09:34:17 -0500
Message-Id: <20191220143433.9922-18-sashal@kernel.org>
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

[ Upstream commit fd1de5830a5abaf444cc4312871e02c41e24fdc1 ]

qla2x00_configure_local_loop initializes PLOGI payload for PLOGI ELS using
Get Parameters mailbox command.

In the case when the driver is running in target mode, the topology is N2N
and the target port has higher WWPN, LOCAL_LOOP_UPDATE bit is cleared too
early and PLOGI payload is not initialized by the Get Parameters
command. That causes a failure of ELS IOCB carrying the PLOGI with 0x15 aka
Data Underrun error.

LOCAL_LOOP_UPDATE has to be set to initialize PLOGI payload.

Fixes: 48acad099074 ("scsi: qla2xxx: Fix N2N link re-connect")
Link: https://lore.kernel.org/r/20191125165702.1013-10-r.bolshakov@yadro.com
Acked-by: Quinn Tran <qutran@marvell.com>
Acked-by: Himanshu Madhani <hmadhani@marvell.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index d734dcf517b92..753338d5343b9 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4814,14 +4814,8 @@ qla2x00_configure_loop(scsi_qla_host_t *vha)
 		set_bit(RSCN_UPDATE, &flags);
 		clear_bit(LOCAL_LOOP_UPDATE, &flags);
 
-	} else if (ha->current_topology == ISP_CFG_N) {
-		clear_bit(RSCN_UPDATE, &flags);
-		if (qla_tgt_mode_enabled(vha)) {
-			/* allow the other side to start the login */
-			clear_bit(LOCAL_LOOP_UPDATE, &flags);
-			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
-		}
-	} else if (ha->current_topology == ISP_CFG_NL) {
+	} else if (ha->current_topology == ISP_CFG_NL ||
+		   ha->current_topology == ISP_CFG_N) {
 		clear_bit(RSCN_UPDATE, &flags);
 		set_bit(LOCAL_LOOP_UPDATE, &flags);
 	} else if (!vha->flags.online ||
-- 
2.20.1

