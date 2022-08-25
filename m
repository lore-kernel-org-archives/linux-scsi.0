Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B347C3F6B0
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Aug 2022 12:02:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233573AbiHYMCM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Aug 2022 08:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234446AbiHYMCJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Aug 2022 08:02:09 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BD4D74378
        for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2022 05:02:08 -0700 (PDT)
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 1497C3F46B
        for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2022 12:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1661428926;
        bh=fFOcq1QXlAjg0riGzLbxExTBvmoZm/E17uOMghOwy/I=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=vNBEEqvN/z2rquyCaAroWxltsqdUUFlHpdfjmbTDBKx3li0rZnfyf9qvDBM7T+ecA
         wvioeMk8zusiyGVpc+hwJHcVsKmXP402tfs+FIDSwtDwYj/AbOfdChQatj7TSd1rmQ
         3Q4QY1cqtpyAJn3sCgrR6xh8hu1hLELDZQDceYWWwRgjRRRqnQvzUPLoaZpV5FMRLf
         tJTvV32h6wezGYowVa5xA4kI38ZuUHK1jJprWiUDi7yIkivzFNPx1C7hFGbPjnJb4+
         KbxPwbJZMHFA+qd1c26RgZeMhQdOCFxZZxCDD+muYL6Bsf5Sj8NRZkiLoOkYy6etxl
         Fva4ejGuKwwwg==
Received: by mail-oi1-f199.google.com with SMTP id t28-20020a0568080b3c00b003433d8d19f0so6387010oij.17
        for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2022 05:02:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=fFOcq1QXlAjg0riGzLbxExTBvmoZm/E17uOMghOwy/I=;
        b=xiXu4xphQqxyFOdVUEl+IRJtMqa1l/GT/k/31nCFl0xefhk1XSJ/GzIwBiU4likBJi
         7VX+LggOOCcztgV14Yob2vAUSup6uz7RNusA6qUZAOBCRCEFl+ttrOIsns+1C3/vRdW8
         a27YBHwssFIDQ/auzjdA9nOOz3hhkFQ5rSD3Mav9DrMs+UGpy9tGu+dUsHASpWnJQrBz
         xpYfq6NPZ486hEv3/vV52K9XlNeoCAblI75g+fsUmIoV8/meIu6e7naVNLKyRqZZGrcG
         4hDOwDBHNnorLExgRLeTb3HyilJdGaE+Hlhsu56Tz+kAiOiYX4pdMZKep2fEaUkX+MEU
         /Vxg==
X-Gm-Message-State: ACgBeo1IOJvSqeX8QbiqkSucN0aRDigaWfhm7BBV17s6Ws1c1bHubkGS
        9DJtCpLS6mMyoyIAYAdG0njugPIzb/35ajAehtJ6uK7uKRD9dbEfQ9PDTphcU4g6tnlBfmaeDH2
        Dp/WyPEg3zphVPWWCaI87NjFWdtNc+6frWE6mSAY=
X-Received: by 2002:a05:6808:1b0d:b0:344:ee32:f7f9 with SMTP id bx13-20020a0568081b0d00b00344ee32f7f9mr5239899oib.25.1661428924548;
        Thu, 25 Aug 2022 05:02:04 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5Ow46lGnuEAzUEzbs4TRdvxbrFtxR4nSgfcwchBgHwRWpUxUNTqoZDphRc52VqwyGA56huBg==
X-Received: by 2002:a05:6808:1b0d:b0:344:ee32:f7f9 with SMTP id bx13-20020a0568081b0d00b00344ee32f7f9mr5239882oib.25.1661428924256;
        Thu, 25 Aug 2022 05:02:04 -0700 (PDT)
Received: from mfo-t470.. ([2804:14c:4e1:83a2:86e3:77b7:9dbb:19c6])
        by smtp.gmail.com with ESMTPSA id i15-20020a54408f000000b00344851ea0ddsm4553522oii.56.2022.08.25.05.02.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 05:02:03 -0700 (PDT)
From:   Mauricio Faria de Oliveira <mfo@canonical.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org
Subject: [PATCH RESEND] scsi: qla2xxx: log message "skipping scsi_scan_host()" as informational
Date:   Thu, 25 Aug 2022 09:01:59 -0300
Message-Id: <20220825120159.275051-1-mfo@canonical.com>
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
index 87a93892deac..8bd1947a650b 100644
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

