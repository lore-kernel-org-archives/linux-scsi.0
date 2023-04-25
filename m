Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F00AC77B7F
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Apr 2023 23:36:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236474AbjDYXgH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Apr 2023 19:36:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236470AbjDYXgF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Apr 2023 19:36:05 -0400
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC080CC0A
        for <linux-scsi@vger.kernel.org>; Tue, 25 Apr 2023 16:36:04 -0700 (PDT)
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-63b5c48ea09so5343807b3a.1
        for <linux-scsi@vger.kernel.org>; Tue, 25 Apr 2023 16:36:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682465764; x=1685057764;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1z1GFeUQapTALq8+imwrYo4FCEcU0L6/oyp6r4TPby4=;
        b=gJ+as0jt1wmme3Unhu+NwmrnwG01aci8E+dlp/NWDsCoe1brKNrDGLtTqSNeyKcsXj
         Zu+tmqo2JuRYrNvQ3dDhGPE5wbjk30BJpvx/o1leSbSKaHluRIR8/8kPwNWf2Z6PSK59
         Y8JQQIk0KSl55qu3uWDrou57vKA1g5iS7f93h+bLheLlRcvQAT/ggt2VY0Tn234ulT+T
         CEmV4a2tjJo5LaoiJShDGZJXiE/lrnN5uR7TV9J0cArInxdoBqu0u+RLjLTorHsQ3LDn
         QqWwTiBtjDu+e3W5+64+H3h0aNx4aWDEKhN5noMpOB7uHbf0akqwLPsO2pTc1B1+alT7
         MhAg==
X-Gm-Message-State: AAQBX9cTXj6eTxuU9f/CV8kvHif1XLr+HFA8NpHQoOKT3RAbYAEe//h7
        DTN3eX9Oll5dNKphuIGJj6Q=
X-Google-Smtp-Source: AKy350aFtVNjSHYaBGbNQGZfrzbQ45IIh+uKDbT1PA8HP0AG7ksQoP46UdPN7XqTLJtkb+YQtruJng==
X-Received: by 2002:a05:6a00:22c1:b0:63b:4e99:807d with SMTP id f1-20020a056a0022c100b0063b4e99807dmr25579200pfj.8.1682465764057;
        Tue, 25 Apr 2023 16:36:04 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5099:ad7c:6c1:9570])
        by smtp.gmail.com with ESMTPSA id j12-20020a056a00174c00b00634b91326a9sm10146984pfc.143.2023.04.25.16.36.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 16:36:03 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Bart Van Assche <bvanassche@google.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 1/4] scsi: core: Use min() instead of open-coding it
Date:   Tue, 25 Apr 2023 16:34:43 -0700
Message-ID: <20230425233446.1231000-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
In-Reply-To: <20230425233446.1231000-1-bvanassche@acm.org>
References: <20230425233446.1231000-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bart Van Assche <bvanassche@google.com>

Use min() instead of open-coding it in scsi_normalize_sense().

Cc: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_common.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_common.c b/drivers/scsi/scsi_common.c
index 6e50e81a8216..24dec80a6253 100644
--- a/drivers/scsi/scsi_common.c
+++ b/drivers/scsi/scsi_common.c
@@ -176,8 +176,7 @@ bool scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
 		if (sb_len > 2)
 			sshdr->sense_key = (sense_buffer[2] & 0xf);
 		if (sb_len > 7) {
-			sb_len = (sb_len < (sense_buffer[7] + 8)) ?
-					 sb_len : (sense_buffer[7] + 8);
+			sb_len = min(sb_len, sense_buffer[7] + 8);
 			if (sb_len > 12)
 				sshdr->asc = sense_buffer[12];
 			if (sb_len > 13)
