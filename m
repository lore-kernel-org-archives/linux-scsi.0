Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 303BAC61DA4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:35:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbjCDAfv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:35:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbjCDAfN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:35:13 -0500
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8394910257
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:34:35 -0800 (PST)
Received: by mail-pl1-f169.google.com with SMTP id i10so4517434plr.9
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:34:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677890075;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xqqv+aHKme2XMo/FdJ5muGw9JOXNAt4DfJWK98zODgU=;
        b=8HvGpVSbI59o+q+cOo7YZHHZv/fPFHtxltaO/UOgAzZfN6W83ZEYo9QRQUtkGmJ+4U
         j74Z5nHrQ696TCk0MMM2oESbs5ud4ZPwzD4zlj/UBZiCtpszZubFPSng0Cu01EcB2EVt
         oklG5orJ7JcwrOsh1h+Utckv4U+iXLrWPU/LCw4iVuHbQtlJcZioEBPOQmyrxRP0a3Hb
         0H91cvZdrOXvyxD/Man/YKZOx5Jjf7U0m0d15SguJgD6TjYp1j8Zy9CyRQGLgHOTT5Vx
         RusU5e2RqBPyIhDp/KcQaBufWloatrOBjqfJS+b/LGbxp4XXt8Md0Fxwu79tDUHEdUTO
         kHvw==
X-Gm-Message-State: AO0yUKW5UEi4QIf8SscgFjzazO1zW8zYFD1082Zx5yJvYMewfdP4A0If
        jOZjc42iwk8P7bijSujLsGI=
X-Google-Smtp-Source: AK7set81qfNnNV+airLuqCNj7siARQWNktY+Zd/OGDLwHVE/Jvc6Gdn8yK9cHEqJ5fYxR30JASCXYA==
X-Received: by 2002:a17:902:e809:b0:19a:9890:eac6 with SMTP id u9-20020a170902e80900b0019a9890eac6mr4289110plg.24.1677890074923;
        Fri, 03 Mar 2023 16:34:34 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.34.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:34:34 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 74/81] scsi: virtio-scsi: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:56 -0800
Message-Id: <20230304003103.2572793-75-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230304003103.2572793-1-bvanassche@acm.org>
References: <20230304003103.2572793-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/virtio_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index c5558c45ab3a..58498da9869a 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -746,7 +746,7 @@ static enum scsi_timeout_action virtscsi_eh_timed_out(struct scsi_cmnd *scmnd)
 	return SCSI_EH_RESET_TIMER;
 }
 
-static struct scsi_host_template virtscsi_host_template = {
+static const struct scsi_host_template virtscsi_host_template = {
 	.module = THIS_MODULE,
 	.name = "Virtio SCSI HBA",
 	.proc_name = "virtio_scsi",
