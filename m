Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DFD0C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Oct 2023 18:59:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233401AbjJaS7F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 Oct 2023 14:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233231AbjJaS7E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Oct 2023 14:59:04 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 667B6E8
        for <linux-scsi@vger.kernel.org>; Tue, 31 Oct 2023 11:59:02 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1ca85ff26afso11041335ad.1
        for <linux-scsi@vger.kernel.org>; Tue, 31 Oct 2023 11:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698778742; x=1699383542; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tlpWK49hIBdc/FU/2GIUrAp30u6EONBnVwJ2rzn6r/Q=;
        b=gAIWLXKN8VL+ZxNB04U2PKoBkJTT7BJZa7HbgtcGX8c6L8m0NRLfJD/20ZuoupLEzS
         X4C2QcJmutMQDKIMpfUqG+wnnJS9A+tY/4sQg41BEd23WeoO+cDFvVONJbKceB8V45c/
         xQMQt7AkexmNGLsBZT59WG+Kcg73/NTaprN73K2QKN5aWLBulwj1ceCI0GnqFqgVF9FP
         fskpvTl09Kwh59qDAyUF07gyU6Fp7ysH9klG7EZ2uq7YfqzNIprplIKovou9Zew9bFKY
         VMj94YRVogNXBbaT3b9n5tYtzRUM3tyzTvpsgLHhrfOH3YnQ85GPsII2Y0S6KenHZOWN
         N0Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698778742; x=1699383542;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tlpWK49hIBdc/FU/2GIUrAp30u6EONBnVwJ2rzn6r/Q=;
        b=mr+z8MyutqZ0Hsf4Gm8R55QYJYKFlS9XtjRbPDKp7Bh98WiGA82I3U3z6jV2kktew3
         gaPH0WsuW//9NUyguhc+hRBMedoHmdc7NoxwKZmod7Y+mUfRZ8kHTAPBeArZyMjCqpkP
         J3iVYj3yx9RosRoWx6aceZwBmWqhl1Utqvy4U9Yi+GGkOpsIIqS0965e0x8dM9FADgEW
         iqY+qmXrEHVKiUoLHbOvoco/3w/AJ3Fm7i/0cHjTsD0I5gRGks6pd5R6Fykskk+8yT+a
         j4NEGyvtQ3mDdbTiwtXd94qSI026aweQMdNq8B2LWAK4SLo6+iLKjT4y2lYbhHPYF4uh
         EoPw==
X-Gm-Message-State: AOJu0YxFjUSThrMNDFEfi+rnDl8qYvVXsOGtU3I2QWXZmopGTDXt6IH0
        //0AJO+FMlW37etvAPgbChGoS1Osu+A=
X-Google-Smtp-Source: AGHT+IFVv/GhF2vXV3kzcSRdMdZzXww0P//59wqpNa9Mxlxpmi5i+Zzt5YTabLNH7sFxN6yaLEuOXg==
X-Received: by 2002:a17:902:f305:b0:1bf:349f:b85c with SMTP id c5-20020a170902f30500b001bf349fb85cmr13381324ple.1.1698778741731;
        Tue, 31 Oct 2023 11:59:01 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id bh6-20020a170902a98600b001c9d6923e7dsm1628657plb.222.2023.10.31.11.59.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 31 Oct 2023 11:59:01 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 1/9] lpfc: Correct maximum PCI function value for RAS fw logging
Date:   Tue, 31 Oct 2023 12:12:16 -0700
Message-Id: <20231031191224.150862-2-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20231031191224.150862-1-justintee8345@gmail.com>
References: <20231031191224.150862-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently, the ras_fwlog_func sysfs parameter allows users to input a value
greater than three when selecting a PCI function to enable RAS fw logging
feature.

The user's input is sanity checked in lpfc_sli4_ras_init, but allowing an
input greater than three doesn't make sense because the max number of ports
per HBA is four.

Change the allowable range from [0, 7] to [0, 3].

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index b1c9107d3408..48c727a51193 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -5905,11 +5905,11 @@ LPFC_ATTR_RW(ras_fwlog_level, 0, 0, 4, "Firmware Logging Level");
 /*
  * lpfc_ras_fwlog_func: Firmware logging enabled on function number
  * Default function which has RAS support : 0
- * Value Range is [0..7].
+ * Value Range is [0..3].
  * FW logging is a global action and enablement is via a specific
  * port.
  */
-LPFC_ATTR_RW(ras_fwlog_func, 0, 0, 7, "Firmware Logging Enabled on Function");
+LPFC_ATTR_RW(ras_fwlog_func, 0, 0, 3, "Firmware Logging Enabled on Function");
 
 /*
  * lpfc_enable_bbcr: Enable BB Credit Recovery
-- 
2.38.0

