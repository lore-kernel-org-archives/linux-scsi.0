Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 142A1C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Oct 2022 17:11:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbiJQRLz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Oct 2022 13:11:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbiJQRLy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Oct 2022 13:11:54 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A87C6FA0D
        for <linux-scsi@vger.kernel.org>; Mon, 17 Oct 2022 10:11:53 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id g28so11663638pfk.8
        for <linux-scsi@vger.kernel.org>; Mon, 17 Oct 2022 10:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0tBsZ76gwc8/70eg063yamfq95Tc780KUhRC9NyQyUU=;
        b=JfqX/tWXuWfol9Fbo7MMWPEIFekj8VCvbIam0iehMAxcW9tuJ0AW88tOYP1WRwJvVR
         8MKwYYrzg1NOd9uiLXL/mItJH+Ryi/C3tcDrgRmOwmQTCqtVXWncmqhdarpXTD6ljyKW
         N9Z8PbF/v6gBfq2SYCKJVrmfFcJVeDP9Vm4f0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0tBsZ76gwc8/70eg063yamfq95Tc780KUhRC9NyQyUU=;
        b=1jYM+6PoXpC7cyS9FUyhr3gqpWofdX2iZgfZeIfum/8WU39wgpu3exwy5WwFpEHRlI
         M4Qax1y5of5U6LDkvBpaNQ213Mg8wYGkakOEY+imQRi+yDSZ4isSW8+o219/doprcmj5
         4vXp8HdMECcs6FL2UrJdbTfdEo4+DAty3Xz1qP8nbXxhQ6l933L1pwe6E4xvGqwg/jrf
         /C2XR9ZgiMoW+B4StseMQU5obqydy6XePx0iliq1NQP9sZvoCKIpeZwAwd496c5l8HZI
         qZfObf55/whw9uxt/NNqj6k/AeZGMS1GEC53t6i2CyE6QHAKHAJj+myauak7dQowEU98
         ED6Q==
X-Gm-Message-State: ACrzQf1GUL4TdcNXSUrLrzEWbfmU/Qhf+CU8WooQfhhVSfSTmAGaOE66
        WF/Jx0il7PHNETi1nck2F2cXjAqkjTxX3Q==
X-Google-Smtp-Source: AMsMyM74ewJl164Y2UsNgLzMWBSmVqg3OL997xAOzqDhQPpx44i3PgLUYOrFqW4PdN9S9F71YSELuQ==
X-Received: by 2002:a63:4a53:0:b0:439:3c80:e053 with SMTP id j19-20020a634a53000000b004393c80e053mr11584993pgl.3.1666026712543;
        Mon, 17 Oct 2022 10:11:52 -0700 (PDT)
Received: from khazhy-linux.svl.corp.google.com ([2620:15c:2d4:203:a9cb:592c:5760:8872])
        by smtp.gmail.com with ESMTPSA id b8-20020a17090a7ac800b00205d70ccfeesm9706025pjl.33.2022.10.17.10.11.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 10:11:52 -0700 (PDT)
From:   Khazhismel Kumykov <khazhy@chromium.org>
X-Google-Original-From: Khazhismel Kumykov <khazhy@google.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Gabriel Krisman Bertazi <krisman@collabora.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Khazhismel Kumykov <khazhy@google.com>
Subject: [PATCH] scsi: fix crash in scsi_remove_host after alloc failure
Date:   Mon, 17 Oct 2022 10:11:47 -0700
Message-Id: <20221017171147.3300575-1-khazhy@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If transport_register_device returns error, shost_gendev has already
been cleaned up - however since we ignore the error device setup
continues happily. We will eventually call transport_unregister_device,
attempting to delete shost_gendev again, resulting in a crash.

It looks like when this cleanup behavior was added, iscsi was updated,
but scsi was missed.

Fixes: cd7ea70bb00a ("scsi: drivers: base: Propagate errors through the transport component")

Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
---
 drivers/scsi/scsi_sysfs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index c95177ca6ed2..722ab042fbd7 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1599,7 +1599,11 @@ EXPORT_SYMBOL(scsi_register_interface);
  **/
 int scsi_sysfs_add_host(struct Scsi_Host *shost)
 {
-	transport_register_device(&shost->shost_gendev);
+	int err;
+
+	err = transport_register_device(&shost->shost_gendev);
+	if (err)
+		return err;
 	transport_configure_device(&shost->shost_gendev);
 	return 0;
 }
-- 
2.38.0.413.g74048e4d9e-goog

