Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41F86C77B70
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Apr 2023 12:01:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238258AbjDFMBT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Apr 2023 08:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238192AbjDFMAz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Apr 2023 08:00:55 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D07230D4;
        Thu,  6 Apr 2023 04:58:13 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id h17so39234767wrt.8;
        Thu, 06 Apr 2023 04:58:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680782291;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w7uewdVPDtWlBmd0txwJX02g5PYGjBmA/8tf1xq7PQc=;
        b=JpaAwBSjB1qEaPPlW1EO6tqmKSRez8Dq1m56wP/aN3/lR0POfZOIgbTZlKnC6T8A9u
         8NUpMCMfUwojPD8BbTSh1mtYe9/NYMY3S2Hnx6sVnqiKg+N6mEJWTJ+LNXHsLkS+zj5m
         oT/JK93HmF2fMv7FeZnX9ituxlrM2aHbxJueAIAfCtPg4uzL6SqiVsUqGuHJYMvXieqK
         iEm4pDfjVpuXCciyKUechdY4HLwgiEHilPAMSjw2Rg0n7DkbT+glsNg3cDNMKEMg4CEA
         BfT6mUr4BSEBkgZ6+MsRMOoT1qOPBzDK6LEoRGV9oohFAS3TJGmNqd2OCw5vSZBUrZtK
         ThXg==
X-Gm-Message-State: AAQBX9cC700kECV/rC7H3tkoH0uWKeNWfzsPiHm263v9S3zV5wuW4IuK
        ZxLjc6afQJRdNOPVWPSnNc7dUPXaznuPzw==
X-Google-Smtp-Source: AKy350Z52mlf+miam/OjAYF64Wbw1zHimhNWm50Qh9NuMESgECFP0wvqY5JQOILWFUQjsgs9wW9iYg==
X-Received: by 2002:a05:6512:21e:b0:4ea:129c:528 with SMTP id a30-20020a056512021e00b004ea129c0528mr2580828lfo.56.1680781258240;
        Thu, 06 Apr 2023 04:40:58 -0700 (PDT)
Received: from flawful.org (c-fcf6e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.246.252])
        by smtp.gmail.com with ESMTPSA id t12-20020ac24c0c000000b004eb3bb581ccsm229247lfq.53.2023.04.06.04.40.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 04:40:58 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 2FB8067E; Thu,  6 Apr 2023 13:40:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680781257; bh=OuulYDiO5r4YnHxGZH5etX0gMKwwO40hqAMiklCCvpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vGjxtfR0uA6BHzXH0p6vJOfXLUigo5InyUtXK9WCQpAmy5ObAS3HYqCGo3mjrG5sj
         ms1ztoYEljQSWbOhm0BlYWbiWv9urvpYZtXNLxsATuT2zZSfnSiKoFfm3lXpM82Rx6
         2jPuXaVPljjZco3u33LmadL+NI7+7ILqbF7JKwfE=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id 810D9D18;
        Thu,  6 Apr 2023 13:33:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680780795; bh=OuulYDiO5r4YnHxGZH5etX0gMKwwO40hqAMiklCCvpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rz8PfjZ19ppe1jRbLu2pcCzOREJ3OkaGYEmWwy4DiZ/lTR9lWwZhEw2Tc36tzoS6l
         zzdCXcAZcEnGER9Ej3sr3HbtRYQZV4LXCfOWQQ9bH7vEpIoGANw6S//qbY9L66UcdN
         1VzU8EWxwWF8CYQ9l+yTDQTNsNC9mgedn/gjsAVY=
From:   Niklas Cassel <nks@flawful.org>
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <dlemoal@fastmail.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v6 12/19] ata: libata-scsi: remove unnecessary !cmd checks
Date:   Thu,  6 Apr 2023 13:32:41 +0200
Message-Id: <20230406113252.41211-13-nks@flawful.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406113252.41211-1-nks@flawful.org>
References: <20230406113252.41211-1-nks@flawful.org>
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
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/ata/libata-scsi.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index e093c7a7deeb..26746609bf76 100644
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
2.39.2

