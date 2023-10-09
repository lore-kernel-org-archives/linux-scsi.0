Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA5D0E95A9E
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Oct 2023 16:05:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377125AbjJIQFi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Oct 2023 12:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377115AbjJIQFg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Oct 2023 12:05:36 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D2CBB9
        for <linux-scsi@vger.kernel.org>; Mon,  9 Oct 2023 09:05:35 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1c72e235debso10391185ad.0
        for <linux-scsi@vger.kernel.org>; Mon, 09 Oct 2023 09:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696867534; x=1697472334; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RPQezVvb1qjUo9gKCLXjmW6CdbPrD/D3+FVg9MKqrGw=;
        b=Q2tIX6MYihVlwjuIZyEetRtLe2wnlm7zcY9fA9nDDndyNmIYStgZcue+qFeVsz2kop
         XqmxwupfVb5Ensu0vgcM6/FAWH5Gx539GRWZOoudRxyN9Zb4S05ccFRy4PK5H0Q95z6v
         WrfYwR9wyyMjAg00jvyaPFTFiVpvbQL1mOzY9bkOLJG5iirZ/gYx3/OuwLpCU1uLsWwn
         2P+aBi/5iKg5v2TUPPvkvdgNZgJyQ9oVV5g/fMreSefiIHadKoSQkfY0+0xRISmwgSK0
         s+8Ww3qu/F7choVoe/rZVklF1CIErNTA+2Xpm/yw+F5myXv5Tkqp8SRC+fwyC59uwfG0
         Gl2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696867534; x=1697472334;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RPQezVvb1qjUo9gKCLXjmW6CdbPrD/D3+FVg9MKqrGw=;
        b=flmr+vGKzx0jZMDh6vlumnecKbUI5pl6kilZGRnC1T++iYnKKHkcIkhjovpcyYKJrY
         ieiiHLlBFhf9YDjTRRszyFC7F1lKO/S5U0shB3GO1hRVLw4fiIdB+gKVXoRxKMidLaSj
         aFM1sgEQdlYuyz2PLIX+qW6pVYBZWh9bPuBrS8afE8otiZRH7IGK1PZz7kD6m7Q1o2U2
         lIBvMW6V/1zO3LQ4m84iP2bCdaH7wKnxpWQil6HOakawiwZEFKHYWhAvETmoevj7votV
         Y7wANEEE/YpBEtSuOgkrXRMu98qE14hy7hlmjye+oRMGYKQ1geTz+qmpvs4RZBnzFnEy
         gGcA==
X-Gm-Message-State: AOJu0YwycBz9nJZL2tO4XnD2xq08k0hHYIcD/8rwWWvJ8vL9H4L5vMsP
        VGOZhbfrBhGNkjVIpfcFCY2jKUtb+S8=
X-Google-Smtp-Source: AGHT+IGqpaiQfK3PLz4Bm5Q+tgKCOrNFu9KKUQNQOhXCW1MuJKUv4/236QXUR+YQBV1Y6uIMTSOTsA==
X-Received: by 2002:a17:902:f686:b0:1c7:5581:f9c with SMTP id l6-20020a170902f68600b001c755810f9cmr17536570plg.0.1696867534472;
        Mon, 09 Oct 2023 09:05:34 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l13-20020a170902d34d00b001bb9f104328sm9793418plk.146.2023.10.09.09.05.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Oct 2023 09:05:34 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 3/6] lpfc: Reject received PRLIs with only initiator fcn role for NPIV ports
Date:   Mon,  9 Oct 2023 09:18:09 -0700
Message-Id: <20231009161812.97232-4-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20231009161812.97232-1-justintee8345@gmail.com>
References: <20231009161812.97232-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently, NPIV ports send PRLI_ACC to all received unsolicited PRLI
requests.  For an NPIV port, there is no point to PRLI_ACC if the received
PRLI request has the initiator function bit set and the target function bit
unset.  Modify the lpfc_rcv_prli_support_check routine to send a PRLI_RJT
in such cases.  NPIV ports are expected to send PRLI_ACC only if the Target
function bit is set.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 1eb7f7e60bba..d9074929fbab 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -934,25 +934,35 @@ lpfc_rcv_prli_support_check(struct lpfc_vport *vport,
 	struct ls_rjt stat;
 	uint32_t *payload;
 	uint32_t cmd;
+	PRLI *npr;
 
 	payload = cmdiocb->cmd_dmabuf->virt;
 	cmd = *payload;
+	npr = (PRLI *)((uint8_t *)payload + sizeof(uint32_t));
+
 	if (vport->phba->nvmet_support) {
 		/* Must be a NVME PRLI */
-		if (cmd ==  ELS_CMD_PRLI)
+		if (cmd == ELS_CMD_PRLI)
 			goto out;
 	} else {
 		/* Initiator mode. */
 		if (!vport->nvmei_support && (cmd == ELS_CMD_NVMEPRLI))
 			goto out;
+
+		/* NPIV ports will RJT initiator only functions */
+		if (vport->port_type == LPFC_NPIV_PORT &&
+		    npr->initiatorFunc && !npr->targetFunc)
+			goto out;
 	}
 	return 1;
 out:
-	lpfc_printf_vlog(vport, KERN_WARNING, LOG_NVME_DISC,
+	lpfc_printf_vlog(vport, KERN_WARNING, LOG_DISCOVERY,
 			 "6115 Rcv PRLI (%x) check failed: ndlp rpi %d "
-			 "state x%x flags x%x\n",
+			 "state x%x flags x%x port_type: x%x "
+			 "npr->initfcn: x%x npr->tgtfcn: x%x\n",
 			 cmd, ndlp->nlp_rpi, ndlp->nlp_state,
-			 ndlp->nlp_flag);
+			 ndlp->nlp_flag, vport->port_type,
+			 npr->initiatorFunc, npr->targetFunc);
 	memset(&stat, 0, sizeof(struct ls_rjt));
 	stat.un.b.lsRjtRsnCode = LSRJT_CMD_UNSUPPORTED;
 	stat.un.b.lsRjtRsnCodeExp = LSEXP_REQ_UNSUPPORTED;
-- 
2.38.0

