Return-Path: <SRS0=k4K9=7A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABAB2C433E3
	for <linux-scsi@archiver.kernel.org>; Mon, 18 May 2020 21:17:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90023207F9
	for <linux-scsi@archiver.kernel.org>; Mon, 18 May 2020 21:17:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728136AbgERVRo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 May 2020 17:17:44 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35886 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgERVRn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 May 2020 17:17:43 -0400
Received: by mail-pf1-f195.google.com with SMTP id z1so5551863pfn.3
        for <linux-scsi@vger.kernel.org>; Mon, 18 May 2020 14:17:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7HIVxD+Aw6RgZS2W7oo5Od6SwEylfbCndCTSZkrdBNs=;
        b=ecW1Avftm/W1N4UtxpuNoGJ8ycjLaNSz3LQ1JS/BhMALhlsgGo+gNfiBBfwvxNDe5J
         vi78gX5dm+quOS7hD6+eQegiMtxAzZPTBPS6vLHxr1jCL0lZp8HnQ7/65fy+b/J5v/do
         3CwBjnW0WRvFGnw+Clo7m0CRpsl5xaHUS7kw3/IFXCLtFtEcU1iAu/AjD6IyfT0IcZD+
         +0hmPemmZdUiA7KYCT5JzXeql0kglT02hKvbW4eQOxI11IG5Ht3hjO/C2qlM3GaDEN2x
         qe2ovlLPhIMQUCvoxFbTKwijggfLEK4Ig9vfmO/YHEuuRYZZR6926NBnAI68ZdbWnIER
         rdCA==
X-Gm-Message-State: AOAM532pP2E2akeGPRi5yw2YpkLQb2kiSq3yyXmbCyetWZDsFpP7Ie5u
        b4Hj3Yxeekof9aR+8msVCxI=
X-Google-Smtp-Source: ABdhPJxhjm/EfbO6nnYSUtZwnOvQTiNsdEkOF3xZlNVCnzN87wqQiXjYy0kuc+srQsh3Ew74BW0vTw==
X-Received: by 2002:aa7:93b6:: with SMTP id x22mr4880348pff.263.1589836661583;
        Mon, 18 May 2020 14:17:41 -0700 (PDT)
Received: from localhost.localdomain ([2601:647:4000:d7:dc5d:b628:d57b:164])
        by smtp.gmail.com with ESMTPSA id i184sm8813123pgc.36.2020.05.18.14.17.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 14:17:40 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Arun Easi <aeasi@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Nilesh Javali <njavali@marvell.com>,
        Martin Wilck <mwilck@suse.com>
Subject: [PATCH v7 13/15] qla2xxx: Use make_handle() instead of open-coding it
Date:   Mon, 18 May 2020 14:17:10 -0700
Message-Id: <20200518211712.11395-14-bvanassche@acm.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518211712.11395-1-bvanassche@acm.org>
References: <20200518211712.11395-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
Cc: Arun Easi <aeasi@marvell.com>
Cc: Nilesh Javali <njavali@marvell.com>
Cc: Martin Wilck <mwilck@suse.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_isr.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 87d0f5e4d81a..0a9a838c7f20 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -819,7 +819,7 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 		goto skip_rio;
 	switch (mb[0]) {
 	case MBA_SCSI_COMPLETION:
-		handles[0] = le32_to_cpu((uint32_t)((mb[2] << 16) | mb[1]));
+		handles[0] = le32_to_cpu(make_handle(mb[2], mb[1]));
 		handle_cnt = 1;
 		break;
 	case MBA_CMPLT_1_16BIT:
@@ -858,10 +858,10 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 		mb[0] = MBA_SCSI_COMPLETION;
 		break;
 	case MBA_CMPLT_2_32BIT:
-		handles[0] = le32_to_cpu((uint32_t)((mb[2] << 16) | mb[1]));
-		handles[1] = le32_to_cpu(
-		    ((uint32_t)(RD_MAILBOX_REG(ha, reg, 7) << 16)) |
-		    RD_MAILBOX_REG(ha, reg, 6));
+		handles[0] = le32_to_cpu(make_handle(mb[2], mb[1]));
+		handles[1] =
+			le32_to_cpu(make_handle(RD_MAILBOX_REG(ha, reg, 7),
+						RD_MAILBOX_REG(ha, reg, 6)));
 		handle_cnt = 2;
 		mb[0] = MBA_SCSI_COMPLETION;
 		break;
