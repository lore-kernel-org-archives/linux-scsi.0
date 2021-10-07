Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 400E9C4332F
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:29:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18CDA61074
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:29:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234059AbhJGUbf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:31:35 -0400
Received: from mail-pj1-f48.google.com ([209.85.216.48]:54228 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233598AbhJGUbe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:31:34 -0400
Received: by mail-pj1-f48.google.com with SMTP id ls18so5792142pjb.3
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:29:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kYLCJrelhZyfUbYgWeKzwy/9UHYa6/H2nyik2Rb13cQ=;
        b=cQoUuLc4M+Lg+WYqznvQ/5Mfpw8YPrOPKCvv0xc2shQ6AqMtMpWzEcjOeSn61zI8eS
         1Et5ec0aVMmQejZ6B/Mn/haYJ5NW3bzRl83cJAyBCFOANHC71DeJhgXXf78CJEkEQQgV
         BpQPx8U4kUNV/7eMpYonYyrfAGJxiNbD5xJkTyFrFsCBwlTvltyABaFAFbFxUhaeilCI
         StPwbgScMW8O+bTtjkLp0s2Y9ni6ZD11vTwpJkFW6clXptu9FDX5iKYB0JFJidUZhGpl
         9CPKQBDsotkh0FV8q76+5zhTu5NcIwzVDNJjKr4DEDRooU4ZXQrLSSWeYQIHEfJ2vTdS
         FP/Q==
X-Gm-Message-State: AOAM530CufUXZA55ylHOPV/P0WukZ+W7HfK8mK9doQWMuD5YIy/fTLm+
        Hrqb4BtdmRFFTHelwAt38cM=
X-Google-Smtp-Source: ABdhPJwK1mWYGpOjcVHaH7EufoT0xBf+gnd0jluRtVTZFBfDYxXcXqkVrBRDC6GzRerhiU/J3Qh6nQ==
X-Received: by 2002:a17:90b:1bc3:: with SMTP id oa3mr7129285pjb.75.1633638580529;
        Thu, 07 Oct 2021 13:29:40 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.29.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:29:40 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH v3 04/88] firewire: sbp2: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:27:59 -0700
Message-Id: <20211007202923.2174984-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007202923.2174984-1-bvanassche@acm.org>
References: <20211007202923.2174984-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/firewire/sbp2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index 4d5054211550..aeed3f2273e8 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1375,7 +1375,7 @@ static void complete_command_orb(struct sbp2_orb *base_orb,
 	sbp2_unmap_scatterlist(device->card->device, orb);
 
 	orb->cmd->result = result;
-	orb->cmd->scsi_done(orb->cmd);
+	scsi_done(orb->cmd);
 }
 
 static int sbp2_map_scatterlist(struct sbp2_command_orb *orb,
