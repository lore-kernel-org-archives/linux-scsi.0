Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06491C0015E
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Jul 2023 16:39:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbjGUQjV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Jul 2023 12:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbjGUQjC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Jul 2023 12:39:02 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E5C349ED;
        Fri, 21 Jul 2023 09:37:25 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id 2adb3069b0e04-4fb7373dd35so4080250e87.1;
        Fri, 21 Jul 2023 09:37:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689957437; x=1690562237;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sy1CMbA9h8MyISsmlxFD3H9uleaHAMciF3iNXrbKPXI=;
        b=cURjEIW0JoTFMtd0MFjRif1LCfBqNJDW0qmPcMMmNo0NZnRo7r54K/6Vo+BwqoOakZ
         3UmY/SbZRq5gJf+7GDXSOg6Liy08ExJvAtzVcRGwGN53EiqxdK3EQz2T0zyMAadk0juc
         DMHt2bYhOFUFWCmFonLkRFsrUYXXESn1b/ztKlc9PTh7IDGVnKwvyJS+CxRqfiMd/Cix
         fBL/lQ89oz9207xgZDxtajvEpoYvux+GK+WXlgMnLq5KjxA3yxryXe8sjTJCy580ZH43
         nq3TdGpaqBiGLJOTtfaQJqDeAXMu7YhnQ11fTJTo++80DkTPcQpNBRu30hcLX3VOF0+b
         R6kw==
X-Gm-Message-State: ABy/qLYT0IlVtC61Pkq0M5tvcavb4CQSkwvTXXOqKWtCCtYH+d1YfO3l
        wtOntOIqE5sHehWNOZunLidkZB6SA1DsGw==
X-Google-Smtp-Source: APBJJlF4hbC5pYpHY6nPBPZrXFJkuIuJv1qkFKM3M6i20QhLLrBNRSkWvUIe3ye8OUYhtPZ8bfOu4g==
X-Received: by 2002:a05:6512:220a:b0:4f8:6e1a:f3ac with SMTP id h10-20020a056512220a00b004f86e1af3acmr1093438lfu.28.1689957437348;
        Fri, 21 Jul 2023 09:37:17 -0700 (PDT)
Received: from flawful.org (c-f5f0e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.240.245])
        by smtp.gmail.com with ESMTPSA id s3-20020a19ad43000000b004fbad09317csm810924lfd.189.2023.07.21.09.37.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jul 2023 09:37:17 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 5C7AA3F2E; Fri, 21 Jul 2023 18:37:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1689957436; bh=1KEtoqG8iFBcyK+j2liNzeIKfEtGmRDVia0Bj1gjXcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lGKjXK5Fhd6/ziwR7HIjdBp/Yk54v5Jqqd0PKxgelW2mkCTuScyCWdiRnx58Az5Sa
         E2zW7m4X5BQL8G6/2yrDQSjxt0A+Itff20Bsywy7ZAq/icaUNWyb5YJlo81UUyGgzf
         Qv0xgZVyLLzeEYhfOqZR9fUtAH25tMMW91P/rrZY=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id B367D3F58;
        Fri, 21 Jul 2023 18:33:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1689957181; bh=1KEtoqG8iFBcyK+j2liNzeIKfEtGmRDVia0Bj1gjXcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E/W4XGuYz509MTJV4untTRm8x80yIPmvD946+ulx5gAXpkl8NlfJoR8UlkX1l79K8
         arw2gh8C2+c7cFRuZP7OYFzOt212KP6nyCb5zdoJkp+xQS991B9n1AacddfjkL+ZAZ
         fYhgrsaBUvoqX8w9Nmhz9ShVWfDCmAsUwi4lO5zk=
From:   Niklas Cassel <nks@flawful.org>
To:     Damien Le Moal <dlemoal@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sergey Shtylyov <s.shtylyov@omp.ru>
Cc:     Hannes Reinecke <hare@suse.com>,
        John Garry <john.g.garry@oracle.com>,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        Niklas Cassel <niklas.cassel@wdc.com>,
        linux-doc@vger.kernel.org
Subject: [PATCH v3 9/9] ata: remove deprecated EH callbacks
Date:   Fri, 21 Jul 2023 18:32:20 +0200
Message-ID: <20230721163229.399676-10-nks@flawful.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721163229.399676-1-nks@flawful.org>
References: <20230721163229.399676-1-nks@flawful.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Now when all libata drivers have migrated to use the error_handler
callback, remove the deprecated phy_reset and eng_timeout callbacks.

Also remove references to non-existent functions sata_phy_reset and
ata_qc_timeout from Documentation/driver-api/libata.rst.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 Documentation/driver-api/libata.rst | 22 ++++++----------------
 drivers/ata/pata_sl82c105.c         |  3 +--
 include/linux/libata.h              |  6 ------
 3 files changed, 7 insertions(+), 24 deletions(-)

diff --git a/Documentation/driver-api/libata.rst b/Documentation/driver-api/libata.rst
index eecb8b81e185..5da27a749246 100644
--- a/Documentation/driver-api/libata.rst
+++ b/Documentation/driver-api/libata.rst
@@ -256,14 +256,6 @@ advanced drivers implement their own ``->qc_issue``.
 Exception and probe handling (EH)
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
-::
-
-    void (*eng_timeout) (struct ata_port *ap);
-    void (*phy_reset) (struct ata_port *ap);
-
-
-Deprecated. Use ``->error_handler()`` instead.
-
 ::
 
     void (*freeze) (struct ata_port *ap);
@@ -348,8 +340,7 @@ SATA phy read/write
                        u32 val);
 
 
-Read and write standard SATA phy registers. Currently only used if
-``->phy_reset`` hook called the :c:func:`sata_phy_reset` helper function.
+Read and write standard SATA phy registers.
 sc_reg is one of SCR_STATUS, SCR_CONTROL, SCR_ERROR, or SCR_ACTIVE.
 
 Init and shutdown
@@ -520,13 +511,12 @@ to return without deallocating the qc. This leads us to
 
 :c:func:`ata_scsi_error` is the current ``transportt->eh_strategy_handler()``
 for libata. As discussed above, this will be entered in two cases -
-timeout and ATAPI error completion. This function calls low level libata
-driver's :c:func:`eng_timeout` callback, the standard callback for which is
-:c:func:`ata_eng_timeout`. It checks if a qc is active and calls
-:c:func:`ata_qc_timeout` on the qc if so. Actual error handling occurs in
-:c:func:`ata_qc_timeout`.
+timeout and ATAPI error completion. This function will check if a qc is active
+and has not failed yet. Such a qc will be marked with AC_ERR_TIMEOUT such that
+EH will know to handle it later. Then it calls low level libata driver's
+:c:func:`error_handler` callback.
 
-If EH is invoked for timeout, :c:func:`ata_qc_timeout` stops BMDMA and
+When the :c:func:`error_handler` callback is invoked it stops BMDMA and
 completes the qc. Note that as we're currently in EH, we cannot call
 scsi_done. As described in SCSI EH doc, a recovered scmd should be
 either retried with :c:func:`scsi_queue_insert` or finished with
diff --git a/drivers/ata/pata_sl82c105.c b/drivers/ata/pata_sl82c105.c
index 3b62ea482f1a..93882e976ede 100644
--- a/drivers/ata/pata_sl82c105.c
+++ b/drivers/ata/pata_sl82c105.c
@@ -180,8 +180,7 @@ static void sl82c105_bmdma_start(struct ata_queued_cmd *qc)
  *	document.
  *
  *	This function is also called to turn off DMA when a timeout occurs
- *	during DMA operation. In both cases we need to reset the engine,
- *	so no actual eng_timeout handler is required.
+ *	during DMA operation. In both cases we need to reset the engine.
  *
  *	We assume bmdma_stop is always called if bmdma_start as called. If
  *	not then we may need to wrap qc_issue.
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 2d5e4b516a69..3718169834d5 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -975,12 +975,6 @@ struct ata_port_operations {
 	ssize_t (*transmit_led_message)(struct ata_port *ap, u32 state,
 					ssize_t size);
 
-	/*
-	 * Obsolete
-	 */
-	void (*phy_reset)(struct ata_port *ap);
-	void (*eng_timeout)(struct ata_port *ap);
-
 	/*
 	 * ->inherits must be the last field and all the preceding
 	 * fields must be pointers.
-- 
2.41.0

