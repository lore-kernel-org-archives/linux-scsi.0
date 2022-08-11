Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF414C3F6B0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Aug 2022 16:24:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237812AbiHKQYg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Aug 2022 12:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237841AbiHKQXp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2022 12:23:45 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E17FBC22
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2022 09:05:15 -0700 (PDT)
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com [209.85.222.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id B472C40AB0
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2022 16:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1660233913;
        bh=Gpg/iZCht06ZJwQqzIOGCQK+PZyVVKbql5uSYvNmUno=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=pssEXXnx/MNoPi4yj/6LmwIRgEbOtROuzBK/IBcPSZ9TPhYGLWHNBQQZ8Nk3eMO3F
         h2qxia5o/B7wBIVC64PN+6M3bPQehqDRdD6zMgNLsLdrGK3MorzqgMNdvKFTxW1CyX
         cxSZfmpywFpr0gEUXxUXOo+TqRVWVHdWWzxOYKaxqdtWB0GVw6/IQ0kWSa/BB6lyO5
         VBzzev9YhKCKTDqvpH7LTOjHJvWjJDg03iCjATEUmjTKW8b5qb5eb+uyBEFVPc0INx
         dkZ03TZ+TXBHWOew/NwE4gtmQ5d7ViIFllcpj15XbFA3VRBAaAZy0Ei6uG1EbsGEnJ
         qSUj6E3GEjnXA==
Received: by mail-ua1-f71.google.com with SMTP id 3-20020ab00503000000b0038cddbf6b02so2042057uax.7
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2022 09:05:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=Gpg/iZCht06ZJwQqzIOGCQK+PZyVVKbql5uSYvNmUno=;
        b=KIR855ti/IbF3R4w7C+zdTe+4EDWVdE158V1VpGo2xb4jGh/6KuP8dhgbuPufqt2+J
         Oan0lx70c7x13blO2eHzgOdkJWwYv1nAm/Gs9xdmpcegKu2iPpq9BRyeNyfKzV/FOASb
         UJmin0D8SQoKCX+J4iMvY8xRZGP2srqqJ1q6NgxK3UicKaMjOqAmAGBHbtsIv4nJ/cG6
         xgEwoY/solXD4cnC5ogKPbTn/QsgYVy+f0vvjawuQqnlQrSgf6YRNKP2KkNB5N96p+9/
         X3n1xQ7HO3zvDssc0P53iEamP+/Dh1j0ytY9/vJGk4tWXNL7B5wsauqbCaT7tOuQT43y
         I32Q==
X-Gm-Message-State: ACgBeo2/lPQBqWcmGDklhm1EINNEhc8gClSJ6YMxDAvd8aawXXcGJ9aH
        ir5O8PWtIMh7xXkOWz5eDLClRneueASMvh+bX12NyUnO9XpSx+/NuZmBJ+1udLKqMsd80kgWySN
        T2PpzpDqQzTuOaTDj3GZmGs/rIZVG3grOwVuQDi0=
X-Received: by 2002:ab0:67cf:0:b0:341:257f:ce52 with SMTP id w15-20020ab067cf000000b00341257fce52mr14471453uar.109.1660233912782;
        Thu, 11 Aug 2022 09:05:12 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6NN0lSAMItN2EJu88W2jMnb/9oM0Z1LLTCND0CzIQb8WtR5ITOtGO6k0w3XxBpuBaJ2ePPBw==
X-Received: by 2002:ab0:67cf:0:b0:341:257f:ce52 with SMTP id w15-20020ab067cf000000b00341257fce52mr14471422uar.109.1660233912473;
        Thu, 11 Aug 2022 09:05:12 -0700 (PDT)
Received: from mfo-t470.. ([2804:14c:4e1:83a2:2ee9:2118:a2dc:3dd6])
        by smtp.gmail.com with ESMTPSA id s65-20020a1ff444000000b003778205cfe7sm2266218vkh.35.2022.08.11.09.05.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Aug 2022 09:05:11 -0700 (PDT)
From:   Mauricio Faria de Oliveira <mfo@canonical.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: qla2xxx: log message "skipping scsi_scan_host()" as informational
Date:   Thu, 11 Aug 2022 13:05:07 -0300
Message-Id: <20220811160507.108006-1-mfo@canonical.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This message is helpful to troubleshoot missing LUNs/SAN boot errors.
It'd be nice to log it by default instead of only enabled with debug.

This user had an accidental/forgotten file modprobe.d/qla2xxx.conf
w/ option qlini_mode=disabled from experiments with FC target mode,
and their boot LUN didn't come up, as it skips scsi scan, of course.

But their boot log didn't provide any clues to help understand that.

The issue/message could be figured out w/ ql2xextended_error_logging,
but it would have been simpler (or even deflected/addressed by user)
w/ it there by default.
(And it also would help support/triage/deflection tooling.)

P.S.: I can't test it on real hardware now (built on next-20220811),
but it's just like other messages in the same function, just below.

Expected change:

 scsi host15: qla2xxx
+qla2xxx [0000:3b:00.0]-00fb:15: skipping scsi_scan_host() for non-initiator port
 qla2xxx [0000:3b:00.0]-00fb:15: QLogic QLE2692 - QLE2692 Dual Port 16Gb FC to PCIe Gen3 x8 Adapter.

According to:

  qla2x00_probe_one()
  ...
          ret = scsi_add_host(...);
  ...
                  ql_log(ql_log_info, ...
                          "skipping scsi_scan_host() for non-initiator port\n");
  ...
          ql_log(ql_log_info, ...
              "QLogic %s - %s.\n", ha->model_number, ha->model_desc);

Signed-off-by: Mauricio Faria de Oliveira <mfo@canonical.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 0bd0fd1042df..f19cd2b59ad5 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3530,7 +3530,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		qla_dual_mode_enabled(base_vha))
 		scsi_scan_host(host);
 	else
-		ql_dbg(ql_dbg_init, base_vha, 0x0122,
+		ql_log(ql_log_info, base_vha, 0x0122,
 			"skipping scsi_scan_host() for non-initiator port\n");
 
 	qla2x00_alloc_sysfs_attr(base_vha);
-- 
2.34.1

