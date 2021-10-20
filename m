Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59D09C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 21:14:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37183611ED
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 21:14:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbhJTVQk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 17:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbhJTVQk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Oct 2021 17:16:40 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54CC5C06161C
        for <linux-scsi@vger.kernel.org>; Wed, 20 Oct 2021 14:14:25 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 75so23669180pga.3
        for <linux-scsi@vger.kernel.org>; Wed, 20 Oct 2021 14:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nGHfXjRS7IjEqltOU7IXsTSN/E9GxWWSNNmXRLXSYQQ=;
        b=oIPCiRrltm2Zw4c7yfbM+rXJFIFKiqZi60Kt258283mP4Pz1XqwT7b8mGudyBy53cM
         nA6h3cJBlYpkJKDQsDt0EtMhcRKAcAEe7QgJorpJZi3iTfrCDbqmTAajX7j+yQNiqJ80
         rXqzDpcCu1tiyKeovkIr8YHykcC2P5Ux9hy6HyFLeNj6oiR4k2EfzxIJ6ZPVHZIxe0xU
         AQEJu5UhmiLrkiGQA9meGYfQx6sVPyVQxxdsdx/unIhUX8GF5JVuTzYssa9jOAS51CGA
         mqq6vz34XTFcAW+oqE5upPJeMB1X4pTHz8fCBQWHn7UaBujLj72Y4iSqZ9ueIXNtrW/K
         L4jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nGHfXjRS7IjEqltOU7IXsTSN/E9GxWWSNNmXRLXSYQQ=;
        b=I9TOstQY049qr6mSvkCAeIjQYSsQocd1G+1fa+UriUo/9cNHqgvNi/GMz6DEJaeLn/
         WZZ4g/2fD8Oj0Rl/dje3yUe3pKIXzeVb5SoWXNp+KKffCtQym2wg80N8Kd8DVbV5/Of+
         gUdqQt3uK/bty50UODCMIE52VPt7pSXu5KWZ5KRnzHvKHkIIUgU4B9OIa0Bs2rGXcfUg
         1XHaO1CxsgEDxSHwgb7c7+FZ11YWFE3nHIGAJbRj83gIg7l+Js6vxE0FlKmkuTlCjYFr
         R7+YURi9BTl3d/crjiFl3P2ojqH/F/yksTYkN7iWsEyAWnNFkDw2p+G8YUbCjrlwiNiQ
         noNg==
X-Gm-Message-State: AOAM533CveUq0b9l0HNqqLc5/7a6F5QGzliGqYRT6hO9LK659QWtfKNN
        W8BKGKac+35lcAumbgIbbNhkvn1izyI=
X-Google-Smtp-Source: ABdhPJwCSVMb6K8x8Q9hMDWDOgZVkPmArIePcFuqiwHA2bxU+d1pIiE16YHgqcOcp8+4tV9oPYXVOQ==
X-Received: by 2002:a63:370c:: with SMTP id e12mr1254599pga.359.1634764464726;
        Wed, 20 Oct 2021 14:14:24 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id pi9sm3700689pjb.31.2021.10.20.14.14.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 14:14:24 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        Zheyu Ma <zheyuma97@gmail.com>
Subject: [PATCH 1/8] lpfc: Revert LOG_TRACE_EVENT back to LOG_INIT prior to driver_resource_setup
Date:   Wed, 20 Oct 2021 14:14:10 -0700
Message-Id: <20211020211417.88754-2-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211020211417.88754-1-jsmart2021@gmail.com>
References: <20211020211417.88754-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In cases when lpfc_enable_pci_dev fails, lpfc_printf_log with
LOG_TRACE_EVENT set will call lpfc_dmp_dbg which uses the
phba->port_list_lock.

However, phba->port_list_lock does not get initialized until
lpfc_setup_driver_resource_phase1.  Thus, any initialization routine with
LOG_TRACE_EVENT log message prior to lpfc_setup_driver_resource_phase1
will crash.

Revert LOG_TRACE_EVENT back to LOG_INIT for all log messages in routines
prior to lpfc_setup_driver_resource_phase1.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
CC: Zheyu Ma <zheyuma97@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 6 +++---
 drivers/scsi/lpfc/lpfc_scsi.c | 2 +-
 drivers/scsi/lpfc/lpfc_sli.c  | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index b7de66f89b3b..5e959c4f05c2 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -7385,7 +7385,7 @@ lpfc_enable_pci_dev(struct lpfc_hba *phba)
 out_disable_device:
 	pci_disable_device(pdev);
 out_error:
-	lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
+	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 			"1401 Failed to enable pci device\n");
 	return -ENODEV;
 }
@@ -8428,7 +8428,7 @@ lpfc_init_api_table_setup(struct lpfc_hba *phba, uint8_t dev_grp)
 		phba->lpfc_stop_port = lpfc_stop_port_s4;
 		break;
 	default:
-		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"1431 Invalid HBA PCI-device group: 0x%x\n",
 				dev_grp);
 		return -ENODEV;
@@ -11661,7 +11661,7 @@ lpfc_sli4_pci_mem_setup(struct lpfc_hba *phba)
 	/* There is no SLI3 failback for SLI4 devices. */
 	if (bf_get(lpfc_sli_intf_valid, &phba->sli4_hba.sli_intf) !=
 	    LPFC_SLI_INTF_VALID) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"2894 SLI_INTF reg contents invalid "
 				"sli_intf reg 0x%x\n",
 				phba->sli4_hba.sli_intf.word0);
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 83ad03d22a49..f35246024988 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5115,7 +5115,7 @@ lpfc_scsi_api_table_setup(struct lpfc_hba *phba, uint8_t dev_grp)
 		phba->lpfc_scsi_prep_cmnd_buf = lpfc_scsi_prep_cmnd_buf_s4;
 		break;
 	default:
-		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"1418 Invalid HBA PCI-device group: 0x%x\n",
 				dev_grp);
 		return -ENODEV;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index d800c6a69c95..244e7d68428e 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -10026,7 +10026,7 @@ lpfc_mbox_api_table_setup(struct lpfc_hba *phba, uint8_t dev_grp)
 		phba->lpfc_sli_brdready = lpfc_sli_brdready_s4;
 		break;
 	default:
-		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"1420 Invalid HBA PCI-device group: 0x%x\n",
 				dev_grp);
 		return -ENODEV;
@@ -11194,7 +11194,7 @@ lpfc_sli_api_table_setup(struct lpfc_hba *phba, uint8_t dev_grp)
 		phba->__lpfc_sli_issue_fcp_io = __lpfc_sli_issue_fcp_io_s4;
 		break;
 	default:
-		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"1419 Invalid HBA PCI-device group: 0x%x\n",
 				dev_grp);
 		return -ENODEV;
-- 
2.26.2

