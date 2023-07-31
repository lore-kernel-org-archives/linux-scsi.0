Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14A4FC001E0
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jul 2023 14:40:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232593AbjGaOkQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jul 2023 10:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232547AbjGaOkM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jul 2023 10:40:12 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3272411B;
        Mon, 31 Jul 2023 07:40:11 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id 2adb3069b0e04-4fe07f0636bso7408256e87.1;
        Mon, 31 Jul 2023 07:40:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690814409; x=1691419209;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KIcJ+DY3XhMKETlUOqbLoo1KBmrfR4L+ppXQy9TiybY=;
        b=bFrZb4Z/FRUqbtue3Y+DlLb1h1KKltes1ux9peFukrSYQ2xeIkPul8DIeiS+FcE9lH
         jtWgfUCQUOomA3zRIT3NVXvGNYKCkC/EwfzQeGSenYifgPHBWaFJTgVGKMEZ0ce+y1bB
         zIwOFPCKn+2+Jo5lvGolRF5/sFr8AtXWk6e8TBffmP39t+US/kKNKTD3YdGfaKtfCMQA
         31TJBuHaTEP20dzXwGcoShkEw47RGiG+yLPOm1Yxm05hU9+wZPLG3Jw+rUVtwXCBl8lL
         KrfaoiKtFdF+GAKqluzDiQvkYlDTJlVh9Fcgs66B9yb1MBEmBgMI5GEr4syM6sO9x2T5
         tgKA==
X-Gm-Message-State: ABy/qLY6e7mSO98a0jVHPXfzSlrqCwp3k2ttQpNzG5Xfl7RAdBznM5Dr
        0YyHrSqs4Z8yFmr8aG2gTeLIjmoJswSX8g==
X-Google-Smtp-Source: APBJJlHnyjEPfM97oZA/PBYKRALe+VOrckMFRUITH2pYSAXDSoQbz2pW1+SpRj8uVg5J49X8Q98zyQ==
X-Received: by 2002:ac2:504d:0:b0:4fe:82c:5c8a with SMTP id a13-20020ac2504d000000b004fe082c5c8amr2823lfm.58.1690814409202;
        Mon, 31 Jul 2023 07:40:09 -0700 (PDT)
Received: from flawful.org (c-f5f0e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.240.245])
        by smtp.gmail.com with ESMTPSA id w3-20020ac24423000000b004fe1f02db22sm1719645lfl.186.2023.07.31.07.40.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 07:40:08 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id E90CE3F6E; Mon, 31 Jul 2023 16:40:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1690814408; bh=edDMj8QumS1e68jpdMyw7e897DoL0c2jDNcs9yDf72g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eeZmWMPqvK2vQiM76FVe7Ffv+XblGp3w968KUIPkyAO5CnfP3Hg5QBizHaw9kPqX/
         eourhuX0vNP3g8/UVHDUbB4EcXvtoevX5VaNvl2Reb1/IM6wpGl7NHPADr76TtlwC1
         Mwvryww13FLsquxKcF6sOmWB2W6ZZOxBZ7/n6IWE=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id D440657C0;
        Mon, 31 Jul 2023 16:35:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1690814104; bh=edDMj8QumS1e68jpdMyw7e897DoL0c2jDNcs9yDf72g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NmYfmLEj/FOULU54oOsnSNCfgS93+RAYDd9H3fxC+SkAw5t0isGIJB/8SyOVVUifH
         uz4qIxHicsgmX7z8it/zlhc1DZRLSu6jg6Zvs+fLIJjZgk++KSDaMlIj6GyqSWmuHq
         sVNLZ0v1d02BNmfJGr8qzxiTg++wzGUbDg9nx4yA=
From:   Niklas Cassel <nks@flawful.org>
To:     Damien Le Moal <dlemoal@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sergey Shtylyov <s.shtylyov@omp.ru>
Cc:     Hannes Reinecke <hare@suse.com>,
        John Garry <john.g.garry@oracle.com>,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Jason Yan <yanaijie@huawei.com>, linux-doc@vger.kernel.org
Subject: [PATCH v4 10/10] ata: remove deprecated EH callbacks
Date:   Mon, 31 Jul 2023 16:34:21 +0200
Message-ID: <20230731143432.58886-11-nks@flawful.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230731143432.58886-1-nks@flawful.org>
References: <20230731143432.58886-1-nks@flawful.org>
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
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Reviewed-by: Jason Yan <yanaijie@huawei.com>
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
index 049159905a28..7a9cbc28472d 100644
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

