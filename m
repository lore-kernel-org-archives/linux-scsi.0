Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98E5CC04E69
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Aug 2023 18:45:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbjHNSo5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Aug 2023 14:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231594AbjHNSot (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Aug 2023 14:44:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C38C910C0
        for <linux-scsi@vger.kernel.org>; Mon, 14 Aug 2023 11:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692038644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4joPWpzOwMxG2JmzffBKuFwUsBB4CLDunmCkMRyxEIg=;
        b=A1FsjM1ikE14pJWCH4LCtq4jq/+33hFfbKGlbc+kO5A2/npQpB4Bb6LmoiA6T4XhMkDXqV
        kX0aMpL/odtd5ZQh3/sqDdk93e+RBqoTj3EeeiGigdq51/AyNrCpnL6rIK/eWt9W6lVuQZ
        /aEzfjhKBmd6N2CovsvGvcmVPFirrJY=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-656-NmCV2bKqNkyDS1-m1J3_fA-1; Mon, 14 Aug 2023 14:44:02 -0400
X-MC-Unique: NmCV2bKqNkyDS1-m1J3_fA-1
Received: by mail-yb1-f197.google.com with SMTP id 3f1490d57ef6-d68c0f22fc9so4383083276.0
        for <linux-scsi@vger.kernel.org>; Mon, 14 Aug 2023 11:44:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692038642; x=1692643442;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4joPWpzOwMxG2JmzffBKuFwUsBB4CLDunmCkMRyxEIg=;
        b=YiKwRN5RVn83SudFcUYl3VC8EfZbLYTuSpyrtaOUFQa6h6wod1lVn8kS8Vrb2hJzfI
         64AMl43igxmwXfu37zQWsgeQdZBZaIdxOpdaNGJqu/geIcQ/UOAHM7PqeqcD4VphTYID
         VqmyaTUCWbXkIZnenDQDOxeyPWeG9+ikguExInMLaGODBbGn0kmBZqL7uehDUQK9u8op
         DRnQY/Ywq8jVF0uWo7bvNPZHpkZ49k87utlbUZ/VpyvuSbChyGObMBjrEHAFr0gO0MJ+
         iItNPEMsyHHo7NZXlwEzTMxgdTMzE6l6Cx2cu31nNnqB+oI474MaXYIRAu6qnvv3UQaa
         kOhA==
X-Gm-Message-State: AOJu0YwbrRKYJwOEeVeVq4weSQM0s6ze8WUX5H0vnky5eucoAsyNaOce
        xxpIlrG2GDT4JRBNP/ZqrJiUg0RKr4bFDC0EBjw4Qzc+ntdFgA0yl9+6ndELNdACAW6UozRaFIb
        9dYjWtjI8aA6IbbZzgEFgCA==
X-Received: by 2002:a25:dbc6:0:b0:d3f:cfa:2349 with SMTP id g189-20020a25dbc6000000b00d3f0cfa2349mr12990854ybf.3.1692038642195;
        Mon, 14 Aug 2023 11:44:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGDOouh4FCszIJRQfOkk++fDwHAw9URgmOfSdxESw5t1t1TvI9bn4i/fnwtAhx4HqGXA2+NTg==
X-Received: by 2002:a25:dbc6:0:b0:d3f:cfa:2349 with SMTP id g189-20020a25dbc6000000b00d3f0cfa2349mr12990842ybf.3.1692038641946;
        Mon, 14 Aug 2023 11:44:01 -0700 (PDT)
Received: from brian-x1.. (c-73-214-169-22.hsd1.pa.comcast.net. [73.214.169.22])
        by smtp.gmail.com with ESMTPSA id x131-20020a25ce89000000b00d674f3e2891sm1864387ybe.40.2023.08.14.11.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 11:44:01 -0700 (PDT)
From:   Brian Masney <bmasney@redhat.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hugo@hugovil.com, quic_nguyenb@quicinc.com
Subject: [PATCH v3 1/2] scsi: ufs: core: convert to dev_err_probe() in hba_init
Date:   Mon, 14 Aug 2023 14:43:51 -0400
Message-ID: <20230814184352.200531-2-bmasney@redhat.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230814184352.200531-1-bmasney@redhat.com>
References: <20230814184352.200531-1-bmasney@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Convert ufshcd_variant_hba_init() over to use dev_err_probe() to avoid
log messages like the following on bootup:

    ufshcd-qcom 1d84000.ufs: ufshcd_variant_hba_init: variant qcom init
        failed err -517

Signed-off-by: Brian Masney <bmasney@redhat.com>
---
Changes since v2
- None

Changes since v1
- Dropped code cleanup

 drivers/ufs/core/ufshcd.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 129446775796..409d176542e1 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9235,8 +9235,9 @@ static int ufshcd_variant_hba_init(struct ufs_hba *hba)
 
 	err = ufshcd_vops_init(hba);
 	if (err)
-		dev_err(hba->dev, "%s: variant %s init failed err %d\n",
-			__func__, ufshcd_get_var_name(hba), err);
+		dev_err_probe(hba->dev, err,
+			      "%s: variant %s init failed err %d\n",
+			      __func__, ufshcd_get_var_name(hba), err);
 out:
 	return err;
 }
-- 
2.41.0

