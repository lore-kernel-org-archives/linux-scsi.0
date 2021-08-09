Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB83AC4338F
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:05:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D5A861004
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:05:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237062AbhHIXFb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:05:31 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:44584 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237022AbhHIXF0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:05:26 -0400
Received: by mail-pj1-f51.google.com with SMTP id hv22-20020a17090ae416b0290178c579e424so2396082pjb.3
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:05:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nOVo62aD3xBlvWPJJ5wlCyfpxi8Hex+qVuCS0WhbLxU=;
        b=imlOvFX2ReIl0lmUihkjMz0mQwf7nm5kk1/5cjw8q0hAejyKcEbXHx1rFP81zku3V6
         lyJhugSMSfx3+K92MV6oQiCEqTdo/l93+zPp0i/w/ylOm8n7bUj9KjdXAvwa7utlmpQf
         BWWWitbmYa6emIHHRBTVp9vr8WSFzAxf//YZ6UwvzltYWyt5pj8XnVYdwxLqRMtdmOCW
         xuJIdATDe+eQe0BlgS0vZzC548zYLTt7zdiSGg7Gm8kzBHTSkKsBd9MVMThWnobOz4BS
         JySuP7fpi9U4VxQ+UVk8jPuY3etfsA3sQVTNsV92Wt+HRPsfovYLzx2cW+VALZtPbLOZ
         iXFw==
X-Gm-Message-State: AOAM531sYHxabHokcrodB/AvTkm16kmHwjlWT8hJyEWuDO7SUA/OIEeP
        rrv1IWZn6Fz4KcDFcElnUMA=
X-Google-Smtp-Source: ABdhPJw7JEQ/wPpolRhZEwLIu2mYVENAF7EFzXg/juK3b1Z612B+QnUEyY+4mjrkcs7li+uEudEbtQ==
X-Received: by 2002:a17:902:b10d:b029:12d:3cec:40bb with SMTP id q13-20020a170902b10db029012d3cec40bbmr3400000plr.60.1628550305106;
        Mon, 09 Aug 2021 16:05:05 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.05.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:05:04 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 40/52] qlogicpti: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Mon,  9 Aug 2021 16:03:43 -0700
Message-Id: <20210809230355.8186-41-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210809230355.8186-1-bvanassche@acm.org>
References: <20210809230355.8186-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qlogicpti.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index d84e218d32cb..8e7e833a36cc 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -890,7 +890,7 @@ static inline void cmd_frob(struct Command_Entry *cmd, struct scsi_cmnd *Cmnd,
 		cmd->control_flags |= CFLAG_WRITE;
 	else
 		cmd->control_flags |= CFLAG_READ;
-	cmd->time_out = Cmnd->request->timeout/HZ;
+	cmd->time_out = scsi_cmd_to_rq(Cmnd)->timeout / HZ;
 	memcpy(cmd->cdb, Cmnd->cmnd, Cmnd->cmd_len);
 }
 
