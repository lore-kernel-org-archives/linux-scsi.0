Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D3B4C77B7C
	for <linux-scsi@archiver.kernel.org>; Thu, 11 May 2023 01:21:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236357AbjEKBVy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 May 2023 21:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjEKBVw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 May 2023 21:21:52 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5416F173F;
        Wed, 10 May 2023 18:21:50 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id 2adb3069b0e04-4f122ff663eso8895404e87.2;
        Wed, 10 May 2023 18:21:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683768108; x=1686360108;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FvXh09aWP7P+HMPPl8UsA09jiTPpMGGk/a0+EraUsbg=;
        b=ktpoa2QjMHtbrxV86u6tsO6JKcYCoecHidAYQJC2xBvdQYCacbiJqQ3+hbO7Wq+WXd
         i75RcPyGjN+BI9NW1Bd0PE5HwHi92Gwl4oep+wQlL95OUCFLPvj6WH2a01+pTDPGL9rM
         iTEJyKmB5IFldIFr/MhXrI7+nB4nNgTDRIrhg9V0jlcUBPUqhQnfAMxhcSVLGj1zKhJC
         B8RBr+bVeu0KcuiuGneEEBZ7V47x7ks+L2MpG5LdHprNNlRQ5qvYA2dhraEunAHORKfc
         VPUcSpSVYMLWii0Xai5Ucvp85YPuS8eCxSLoqWGs4AVKvrac/VYSopvQkAJl1OLxjUcZ
         wHCg==
X-Gm-Message-State: AC+VfDwagc64kIhFZMcnMsK8B/Bg8wiI2/gw3z/7PcI7KXNInb1grPSs
        bDy38h5HwXT1i3pTkUcBxcB6vXsaEgVsUSwC
X-Google-Smtp-Source: ACHHUZ4ENdNHuG2dajdKH4TvRhb0uNodn97xHK0D9Neem+uayfZx0tcW6S4LBXeQihXq95Os0I/hyQ==
X-Received: by 2002:a05:6512:491:b0:4f2:661e:b496 with SMTP id v17-20020a056512049100b004f2661eb496mr657043lfq.67.1683768108497;
        Wed, 10 May 2023 18:21:48 -0700 (PDT)
Received: from flawful.org (c-fcf6e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.246.252])
        by smtp.gmail.com with ESMTPSA id u10-20020ac248aa000000b004f14591a942sm915025lfg.271.2023.05.10.18.21.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 18:21:48 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 6C0BF585; Thu, 11 May 2023 03:21:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1683768107; bh=kMdL9oKbRAKDmZBrL/wC6GL/SapR5JDQBKHl6R8a2HM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CrMeJKGo6pEn67SvEI2SkbTuTBBt/aYlpIvmgEYSdl8NQj/BH/vZG9PXsJLA5Hx9k
         Edw0VEh/G3pgEyeqb0EFiD3PHUna6oaMx0leSQgVjTmRNXE7DlRJ0FDVISm4VOO4Xf
         HVlgvtL7Yys3f6r3snmIQFpMqcjI6yogJZpWDbRM=
Received: from x1-carbon.. (unknown [64.141.80.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id 9441777C;
        Thu, 11 May 2023 03:15:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1683767725; bh=kMdL9oKbRAKDmZBrL/wC6GL/SapR5JDQBKHl6R8a2HM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C/ZUSJnVkg+d9hFBm3ljZRUSZGSQ7XBYGUEIMfs27u1DEis4eevLtEYM1RyadSkXE
         foeHaE6mNA0qN231GP48FRhxZNUnFWEzYkPNiknuXuFaHQet559+8Nd7EBs72QhOVe
         qkfqwbAscCNRBfvqJSAByyBD+ZRaoiJHUHqlDZRY=
From:   Niklas Cassel <nks@flawful.org>
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <dlemoal@kernel.org>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v7 12/19] ata: libata-scsi: remove unnecessary !cmd checks
Date:   Thu, 11 May 2023 03:13:45 +0200
Message-Id: <20230511011356.227789-13-nks@flawful.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230511011356.227789-1-nks@flawful.org>
References: <20230511011356.227789-1-nks@flawful.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

There is no need to check if !cmd as this can only happen for
ATA internal commands which uses the ATA internal tag (32).

Most users of ata_scsi_set_sense() are from _xlat functions that
translate a scsicmd to an ATA command. These obviously have a qc->scsicmd.

ata_scsi_qc_complete() can also call ata_scsi_set_sense() via
ata_gen_passthru_sense() / ata_gen_ata_sense(), called via
ata_scsi_qc_complete(). This callback is only called for translated
commands, so it also has a qc->scsicmd.

ata_eh_analyze_ncq_error(): the NCQ error log can only contain a 0-31
value, so it will never be able to get the ATA internal tag (32).

ata_eh_request_sense(): only called by ata_eh_analyze_tf(), which
is only called when iteratating the QCs using ata_qc_for_each_raw(),
which does not include the internal tag.

Since there is no existing call site where cmd can be NULL, remove the
!cmd check from ata_scsi_set_sense() and ata_scsi_set_sense_information().

Suggested-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 drivers/ata/libata-scsi.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 7bb12deab70c..072785808751 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -209,9 +209,6 @@ void ata_scsi_set_sense(struct ata_device *dev, struct scsi_cmnd *cmd,
 {
 	bool d_sense = (dev->flags & ATA_DFLAG_D_SENSE);
 
-	if (!cmd)
-		return;
-
 	scsi_build_sense(cmd, d_sense, sk, asc, ascq);
 }
 
@@ -221,9 +218,6 @@ void ata_scsi_set_sense_information(struct ata_device *dev,
 {
 	u64 information;
 
-	if (!cmd)
-		return;
-
 	information = ata_tf_read_block(tf, dev);
 	if (information == U64_MAX)
 		return;
-- 
2.40.1

