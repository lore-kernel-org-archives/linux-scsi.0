Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A263AC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:06:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8090E61406
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:06:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347065AbhI2WIJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:08:09 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:40908 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347024AbhI2WIE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:08:04 -0400
Received: by mail-pj1-f53.google.com with SMTP id d4-20020a17090ad98400b0019ece228690so5203315pjv.5
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:06:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kYLCJrelhZyfUbYgWeKzwy/9UHYa6/H2nyik2Rb13cQ=;
        b=F/U9Hu1SxgqX+8oMo1CqcpOX+sZ4nQVS7E8Hx8PGm/0CScpOOeRsGLHnLdQgW/4emR
         i///KYoKJnhf84MfEEpq1wJ5+NnejU5CDooVWM2KiuzWJHCITFWzvpiJefsd6Bp/FgpP
         mCtDRDPBin7CeO+gGFmA7mhdybHZxvymqQsWR1ukWxjIWC6/9zB1p0fJyXAZ7NlSiinm
         YJsEBFOPvETSFhvCOVl47PIxoBsu7bh5gqHAFj9FJmMewWNNa//IIQOtoGmdSISDnzKQ
         Rh6azZnygGf7lfBIr0Y7/pjAlhMladqjHx8zPLidKVDQ1CIN30ejH2Q6No1akzzx/5BO
         +PbA==
X-Gm-Message-State: AOAM531NqNnP+VZ1dASWZtDH8W/DAiwCKg76MP/AX5pEXUIvwFC24DVF
        l1QuW+BtylLbELyBLKYYyjg=
X-Google-Smtp-Source: ABdhPJzBwSDggDFTyNm20kBYxKMXzgPwqQWg7Dl0QC2WKgtU+m8bJvtJklhDYxLD8kvA2u4/NV757w==
X-Received: by 2002:a17:90a:d802:: with SMTP id a2mr8977472pjv.194.1632953182230;
        Wed, 29 Sep 2021 15:06:22 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.06.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:06:21 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH v2 04/84] firewire: sbp2: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:04:40 -0700
Message-Id: <20210929220600.3509089-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929220600.3509089-1-bvanassche@acm.org>
References: <20210929220600.3509089-1-bvanassche@acm.org>
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
