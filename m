Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A5D9C77B77
	for <linux-scsi@archiver.kernel.org>; Sat,  8 Apr 2023 21:40:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbjDHVkz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 8 Apr 2023 17:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjDHVkv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Apr 2023 17:40:51 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 421AE5BBF
        for <linux-scsi@vger.kernel.org>; Sat,  8 Apr 2023 14:40:48 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id v29so1557411wra.13
        for <linux-scsi@vger.kernel.org>; Sat, 08 Apr 2023 14:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680990047; x=1683582047;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1r1SnOX6wBN2nHGoU3kualPj54nGeQSAaKXS+XIlZkY=;
        b=bBHCoWqCZjmRMr/6jc1rmR8Zb3K5vch/8ZNshCg45bdBET0jkywDKUWqGOJiRN2Z8B
         X4s3n6cRGmlKcNQfE65/c9k15VqfINbbSEi+w0fFsPOyau57izi4gZHjRELdirmkOcqS
         b/MGT5prRycMjYmnmUm7uXaNiYZUaBUvMf+bJOPztSwftxdAjr4yS7ae5FoEKcxn8qc/
         JDrouNcvioskloCtX1qRiDEb+JKBUDRk1sivUHgDEKNzmWDVHl8/ojePIAmAktLC/62R
         6QoHzgqQnSMuVxwyHSG/qNDjTiR1QKk75H+ztg+h4NggiFsBGTBDJA56pE5roG/+1uw2
         CWLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680990047; x=1683582047;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1r1SnOX6wBN2nHGoU3kualPj54nGeQSAaKXS+XIlZkY=;
        b=Ja/zgjq4Btn8fLGV2g2LVJQ3fFk0POzM5XMnN5TBFKgW6QTXblB8TTAYKyrTSwa5mF
         lbqs6dq9JjdQXUgtyxB0BgSOxaPBKl+yl4wQok1fCb1wQ64d1Vcph1WHOMsk26q/ih1y
         r+ycs/2eH9snQvdixBomIYiANnRX0xiPR2eADSt1xCd/cOOCNtk/WA5VZjOdPgsTX4Ja
         Jeaeo4h6P4OwLKNrheKrURCEBRsSARmeiiyEwLXsa6wEuw48YOMYG7zbejvHbQvewvjD
         24a7oJVj5Nmh3/GYWgEsqgWPP3+a+VgnOAFYMo6bjiLU9kDkBHMUS0/ATN2dR7gUdwi7
         AAWg==
X-Gm-Message-State: AAQBX9fWyt2yyyNzdyigDTt1PHeg8KySTOlTzgi0ZPBtEQzBe7NiKbV4
        sX1QvNAUJ88BZZ1cAlR32GMgQA==
X-Google-Smtp-Source: AKy350YFShjn4hELK46QnNTz06X559nncDEtCLRY2NKWt5Icc+qKjSwPyUFsi9Ob6YNkuINvGr+6TQ==
X-Received: by 2002:a5d:50d0:0:b0:2ce:ae4c:c429 with SMTP id f16-20020a5d50d0000000b002ceae4cc429mr3829849wrt.4.1680990046639;
        Sat, 08 Apr 2023 14:40:46 -0700 (PDT)
Received: from localhost.localdomain ([188.25.26.161])
        by smtp.gmail.com with ESMTPSA id s6-20020a5d4ec6000000b002efb6e0c495sm3061377wrv.91.2023.04.08.14.40.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Apr 2023 14:40:46 -0700 (PDT)
From:   Abel Vesa <abel.vesa@linaro.org>
To:     Ulf Hansson <ulf.hansson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>
Cc:     linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH v7 0/3] Add dedicated Qcom ICE driver
Date:   Sun,  9 Apr 2023 00:40:38 +0300
Message-Id: <20230408214041.533749-1-abel.vesa@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

As both SDCC and UFS drivers use the ICE with duplicated implementation,
while none of the currently supported platforms make use concomitantly
of the same ICE IP block instance, the new SM8550 allows both UFS and
SDCC to do so. In order to support such scenario, there is a need for
a unified implementation and a devicetree node to be shared between
both types of storage devices. So lets drop the duplicate implementation
of the ICE from both SDCC and UFS and make it a dedicated (soc) driver.

The v6 is here:
https://lore.kernel.org/all/20230407105029.2274111-1-abel.vesa@linaro.org/

Changes since v6:
 * Dropped the patches 1, 3 and 6 as they are already in Bjorn's tree.
 * Dropped the minItems for both the qcom,ice and the reg in the
   qcom,ice compatile subschema, in the ufs schema file,
   like Krzysztof suggested

Changes since v5:
 * See each individual patch for changelogs.

Changes since v4:
 * dropped the SDHCI dt-bindings patch as it will be added along
   with the first use of qcom,ice property from an SDHCI DT node


Abel Vesa (3):
  dt-bindings: ufs: qcom: Add ICE phandle
  scsi: ufs: ufs-qcom: Switch to the new ICE API
  mmc: sdhci-msm: Switch to the new ICE API

 .../devicetree/bindings/ufs/qcom,ufs.yaml     |  24 ++
 drivers/mmc/host/Kconfig                      |   2 +-
 drivers/mmc/host/sdhci-msm.c                  | 223 ++++------------
 drivers/ufs/host/Kconfig                      |   2 +-
 drivers/ufs/host/Makefile                     |   4 +-
 drivers/ufs/host/ufs-qcom-ice.c               | 244 ------------------
 drivers/ufs/host/ufs-qcom.c                   |  99 ++++++-
 drivers/ufs/host/ufs-qcom.h                   |  32 +--
 8 files changed, 176 insertions(+), 454 deletions(-)
 delete mode 100644 drivers/ufs/host/ufs-qcom-ice.c

-- 
2.34.1

