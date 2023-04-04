Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 371F2C77B6C
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Apr 2023 18:35:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235778AbjDDSfF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Apr 2023 14:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236487AbjDDSeq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Apr 2023 14:34:46 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3FF55FF7;
        Tue,  4 Apr 2023 11:32:32 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id h25so43518956lfv.6;
        Tue, 04 Apr 2023 11:32:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680633151;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w7uewdVPDtWlBmd0txwJX02g5PYGjBmA/8tf1xq7PQc=;
        b=qdn+l6SMWdKq3D8JEKfGnZy46u3/ov6F91Qg5pTKyCdjW1OpQXVfJe8RqJO+dYbii+
         5yx9CTNbo7DbS0Z5J+0dG3bbwCWcdNilO4anr9GsgW6UKGbo0lcL2eHoe9jY7E9ZTYpT
         cJXD2T+YwQj7IIuqepFJJBInaQT6LHIKK/dKsINqH7m8YK8h5NHMmnzy0cU1NikKvs4C
         GHQGi/D3F+hhJAbuzUmu76OV9jntlpoxkJRdlD05H1UgCh9KmgTCPICtFBoQuP2LWLDK
         Vt3jWUJjH/E4xkx3pf1velZtycvQQ8fJk3XRMOuVnTjuOAOqfWOxK1r3er6R+I8v9e3z
         isUA==
X-Gm-Message-State: AAQBX9d9NSuKqEf08sEWH9pJ2Zgfe5MVzStpfVl1pUsFIyNZLRZCnzCt
        SggZkE5pz+2+PhqDsDzdnT87XAbnPgZKSg==
X-Google-Smtp-Source: AKy350a/q6j+7ThkLuTFZuBTOSVG5cY4mVJyjQ0w0cl+0NfiEIAn3w/peHFABBmFLbyApZAMl3zwVg==
X-Received: by 2002:a05:6512:244:b0:4db:3928:d66d with SMTP id b4-20020a056512024400b004db3928d66dmr789969lfo.42.1680633151138;
        Tue, 04 Apr 2023 11:32:31 -0700 (PDT)
Received: from flawful.org (c-a3f5e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.245.163])
        by smtp.gmail.com with ESMTPSA id q28-20020ac25a1c000000b004db1a7e6decsm2436206lfn.205.2023.04.04.11.32.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 11:32:30 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 1DEE82C0; Tue,  4 Apr 2023 20:32:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680633150; bh=OuulYDiO5r4YnHxGZH5etX0gMKwwO40hqAMiklCCvpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tn3TB8ZBVAHi+2X3GT643OVNgPiVhOKq4HcoyaVY3I5tQUZrfK/7Gdm+XCwu32lTD
         0kFYJ8bS7a4d6OllMMjxtgOe+zKX9a8Z3ozly2dskCJpPKGZcecvq0V54W9VrwsYtE
         BOvLPiBgtUcwao7dtGvPimX8tAYr4bKyiOjKX7a8=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id B4A191112;
        Tue,  4 Apr 2023 20:25:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680632751; bh=OuulYDiO5r4YnHxGZH5etX0gMKwwO40hqAMiklCCvpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rja1UesVO/e3UwGidur3122sukAkFvkvYeY0RqiAzvV2HLQRA81UlURq80douhzUa
         QdUy5a+uLtHrvLBHULRTFqvzJwRSyd8lIF7rJAlBxRleJ+oNf1vYaj/URw8Fxes3DD
         eJP1LVJQGJBECn/O2gvOhXVhSHEPonuHlxGqAmPg=
From:   Niklas Cassel <nks@flawful.org>
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v5 12/19] ata: libata-scsi: remove unnecessary !cmd checks
Date:   Tue,  4 Apr 2023 20:24:17 +0200
Message-Id: <20230404182428.715140-13-nks@flawful.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230404182428.715140-1-nks@flawful.org>
References: <20230404182428.715140-1-nks@flawful.org>
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

