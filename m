Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9E9EC0650F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:02:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A999F216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:02:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404940AbfHIDCk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:02:40 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:42426 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404679AbfHIDCk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:02:40 -0400
Received: by mail-pl1-f195.google.com with SMTP id ay6so44415999plb.9
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:02:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=62QU1tnRhR1eQH6A5yHkt7y0hNZ6FrvaK7bFOtYTNnw=;
        b=GDYiRn02kt+o/MkJJ87D1c1CckwXe4fEWmCHPnTrrkwOqt65l3MgUocN5cKKPVDnBJ
         inkeVS7ksep0UE4gx7aInaoKYMK0OWYYNbM5FLdq/YQkG6J3JF3ffQLYSwBcYQgzOMVB
         xTFt2Hc/98LqL5+BnAD12+mHKqcscMbE+vQLT8E1saHyPBHuOMMXUHY2BeCgtWQYuF35
         2B7bflmYvRHxOcijfLeGfgjQs/FoyXz6kB2NVwRxgznB9T67uTGmquZq6HUOhXMSQbyD
         NU6aTVIEEdafHU3d/yb1CTJXOtijTVr6TxRFV5Ry6BYVr3RSxsoAvF2TkjxgEixJxEva
         YG+g==
X-Gm-Message-State: APjAAAUMb/Pt5EjXVWvtnwZa5N5tK34bvb6D31oJN4+FiVk35eWTLmQa
        M3UaSCpaza5usVzUwtoIV44=
X-Google-Smtp-Source: APXvYqyHJV3G9ES+Gk8rHReC6ap4sXk4/5AxXG03/8dcrXiZJiYbTQwMPD9qAEEOpP1w+OpvkERuDA==
X-Received: by 2002:a17:902:7686:: with SMTP id m6mr16869135pll.239.1565319759374;
        Thu, 08 Aug 2019 20:02:39 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.02.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:02:38 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 02/58] qla2xxx: Really fix qla2xxx_eh_abort()
Date:   Thu,  8 Aug 2019 20:01:23 -0700
Message-Id: <20190809030219.11296-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

I'm not sure how this happened but the patch that was intended to fix
abort handling was incomplete. This patch fixes that patch as follows:
- If aborting the SCSI command failed, wait until the SCSI command
  completes.
- Return SUCCESS instead of FAILED if an abort attempt races with SCSI
  command completion.
- Since qla2xxx_eh_abort() increments the sp reference count by calling
  sp_get(), decrement the sp reference count before returning.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Fixes: 219d27d7147e ("scsi: qla2xxx: Fix race conditions in the code for aborting SCSI commands")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index b667f13b62df..db1f1aac79f2 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1269,6 +1269,7 @@ static int
 qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 {
 	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
+	DECLARE_COMPLETION_ONSTACK(comp);
 	srb_t *sp;
 	int ret;
 	unsigned int id;
@@ -1307,6 +1308,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 		return SUCCESS;
 	}
 
+	/* Get a reference to the sp and drop the lock. */
 	if (sp_get(sp)){
 		/* ref_count is already 0 */
 		spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
@@ -1334,6 +1336,23 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 		sp->done(sp, DID_ABORT << 16);
 		ret = SUCCESS;
 		break;
+	case QLA_FUNCTION_PARAMETER_ERROR: {
+		/* Wait for the command completion. */
+		uint32_t ratov = ha->r_a_tov/10;
+		uint32_t ratov_j = msecs_to_jiffies(4 * ratov * 1000);
+
+		WARN_ON_ONCE(sp->comp);
+		sp->comp = &comp;
+		if (!wait_for_completion_timeout(&comp, ratov_j)) {
+			ql_dbg(ql_dbg_taskm, vha, 0xffff,
+			    "%s: Abort wait timer (4 * R_A_TOV[%d]) expired\n",
+			    __func__, ha->r_a_tov);
+			ret = FAILED;
+		} else {
+			ret = SUCCESS;
+		}
+		break;
+	}
 	default:
 		/*
 		 * Either abort failed or abort and completion raced. Let
@@ -1343,6 +1362,8 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 		break;
 	}
 
+	sp->comp = NULL;
+	atomic_dec(&sp->ref_count);
 	ql_log(ql_log_info, vha, 0x801c,
 	    "Abort command issued nexus=%ld:%d:%llu -- %x.\n",
 	    vha->host_no, id, lun, ret);
-- 
2.22.0

