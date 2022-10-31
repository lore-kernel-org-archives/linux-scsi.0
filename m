Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D29E3FA3741
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Oct 2022 18:05:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbiJaSFm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Oct 2022 14:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJaSE0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Oct 2022 14:04:26 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF9D13E24
        for <linux-scsi@vger.kernel.org>; Mon, 31 Oct 2022 11:04:25 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id 130so11346803pfu.8
        for <linux-scsi@vger.kernel.org>; Mon, 31 Oct 2022 11:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6pljquG0hkdcBPdXIDtkq1v6aN8iyQB1w4S/2qg/cek=;
        b=mbaTkWIZctaMqvca5J6aUZD1yU2UYtJBk9TxNW1vYxyFZbwSlWxTXO/4DvGjs1wwJP
         S1J/cj97edabhnPuqksCMwl1eu0ORZNLO9ms8r65u5wbDVM04VFOtkiuyQd5XCsFjEc4
         VxmFMqOjyuYh/4HnDzczDsxkfw4Ljzr5rdipzDoPlVV4yLGL5TQRGdMhg0gH7eruNE1p
         oVxsho9okB2M0NIN0f8X+MTG8f0e1tsxV+lJ/wS1Zg/Bztivz97X/3AHiBkQ6iJWdWB8
         7d+YNlNfqNBJXgOHKYfrFWm1JyjwBC+4J632yCsu+NbuC2rabHpI0o5hHgp7KaecAtwR
         L0RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6pljquG0hkdcBPdXIDtkq1v6aN8iyQB1w4S/2qg/cek=;
        b=g6H4X2IUIqOvGArAWDKCyceWBxm6Hv/Rm5MvDshEs0llDMjXfWyiXKiZAOJnzTByw7
         Q906l1aL+ms/tuilnGHqTK+Oz1AoW9QTp13cYwg/xtbN//wGWsnqspUfu27i1vAXSZWX
         lSnh2CABXGpwmYAJGYlbdhXmJxDDJwxc+tpd6K/nBIgSF+rrhkg9t6B21gL5fD3Vg4Kr
         2Fwg7y3frklWwY5M8fVblp2Cn0ptRAF2ehhgG+7AYT/p4K0pq0Cn4hRBKvdgkAxY8pMz
         U364lMHeU8hEA/QRVvJ/2J24zZF+QD2CE3Hf+YNs+XhryqIY7hi66SbUKjPjdKDZvt5S
         PHCQ==
X-Gm-Message-State: ACrzQf2edyeRYvVxBhL911bfTXMFFfk6LXisLxvyBnGL/aacwnxHjAOk
        nBCpgkNFSsxyiUIjFJBKhiDf
X-Google-Smtp-Source: AMsMyM5bkO0jc5E/Yeey8T7kpu9gaLOBOsA6kJDN2KwU5inXsF6u37NtULiOyALmrO8jomRmhKhNOg==
X-Received: by 2002:a05:6a00:c8d:b0:56d:370f:2003 with SMTP id a13-20020a056a000c8d00b0056d370f2003mr11529938pfv.76.1667239465227;
        Mon, 31 Oct 2022 11:04:25 -0700 (PDT)
Received: from localhost.localdomain ([117.193.209.221])
        by smtp.gmail.com with ESMTPSA id q14-20020a170902a3ce00b00186c6d2e7e3sm4742224plb.26.2022.10.31.11.04.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 11:04:24 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        andersson@kernel.org, vkoul@kernel.org,
        krzysztof.kozlowski+dt@linaro.org
Cc:     konrad.dybcio@somainline.org, robh+dt@kernel.org,
        quic_cang@quicinc.com, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org,
        dmitry.baryshkov@linaro.org, ahalaney@redhat.com,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH v2 15/15] MAINTAINERS: Add myself as the maintainer for Qcom UFS driver
Date:   Mon, 31 Oct 2022 23:32:17 +0530
Message-Id: <20221031180217.32512-16-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221031180217.32512-1-manivannan.sadhasivam@linaro.org>
References: <20221031180217.32512-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Qcom UFS driver has been left un-maintained till now. I'd like to step
up to maintain the driver and its binding.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index cf0f18502372..149fd6daf52b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -21097,6 +21097,14 @@ L:	linux-mediatek@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	drivers/ufs/host/ufs-mediatek*
 
+UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER QUALCOMM HOOKS
+M:	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
+L:	linux-arm-msm@vger.kernel.org
+L:	linux-scsi@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
+F:	drivers/ufs/host/ufs-qcom.c
+
 UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER RENESAS HOOKS
 M:	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
 L:	linux-renesas-soc@vger.kernel.org
-- 
2.25.1

