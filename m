Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0798C00A5A
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Jan 2023 14:46:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231492AbjASOqp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Jan 2023 09:46:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbjASOqQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jan 2023 09:46:16 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 734A38457E
        for <linux-scsi@vger.kernel.org>; Thu, 19 Jan 2023 06:43:29 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id rl14so2902362ejb.2
        for <linux-scsi@vger.kernel.org>; Thu, 19 Jan 2023 06:43:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9KHL7S0sw0CegFriPkOF815DSWCPV/UoYSgl9XlgPOY=;
        b=rI60sDSpn5RzojNYOrqgO+epm0kV/SqZlHJaYJpL6rOLd4quu6COOI4QQUxn5hDufC
         wvmpYBA/n8ZesJA7fGa7GhyhbgTciGXVbP1c8V13I52l04+WA+1jUasLeBfgqJmcF718
         s269U+eS5Llwb+cIpfDxvv91RIB09MRX/sWALY/+aquNq4o/rYhBk9codbUErbq0hkE8
         drfuRyZeIXKOD/SdTJKPsilXpYHSpwhQ262iyh+/hQ7CNfK1PKMLWHbKB5YTnEzsMIbG
         MBwLpmeCMkQByoLOUtGZ7VAdi0/DHPPRYqSmzRigksJDvM1VNXWrX4xKODVHFpsdmOw/
         SkPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9KHL7S0sw0CegFriPkOF815DSWCPV/UoYSgl9XlgPOY=;
        b=MUsN3RDOsKp2RSl3Z9aB2VIzPFwzpCkLbERyQp7zevXGKUAxR2AgPkxtIyp81GH8IO
         0Oi436RDpMk0vPoNembppqWRPneqZWKDQWXK+Tu1uohs02oCJt27jd90u6JJt659m7Mu
         gDOlOGIfyFdlYtOaJlBmhsFkEfwuHpyc2bSX9tbLzv6g4+tSCd+ew6SQiWt6TEkYmi9m
         OhBIdnrBOmzlqIGNMVjVolj/v+YIbH1szvXj6mqWjfWFEFJ7rImBDKhwGJaCDIHkk9H5
         JknwgUHfFzaK/BHqfPJjLPvmf4opc5RAZw2rZzG0dFbs5rKl94NYRfgfM9jlY6hWiuyO
         oCQA==
X-Gm-Message-State: AFqh2kpHjsjNON6rKMG8tFcU/4DAsXBXfjcOi1VQQ8iNh9lWYqk+uket
        tmdu18+8X4ZHvRcYLlwco/GltQ==
X-Google-Smtp-Source: AMrXdXvKKXPY95QPENbEySgQE55aRaDebl+PjzRWVQqS4XzsL/YEJ8XskLiETVUXqdvkKsyyCLtJWQ==
X-Received: by 2002:a17:907:b610:b0:7c0:d23c:ead3 with SMTP id vl16-20020a170907b61000b007c0d23cead3mr12951464ejc.27.1674139407713;
        Thu, 19 Jan 2023 06:43:27 -0800 (PST)
Received: from eriador.lan (dzccz6yyyyyyyyyyybcwt-3.rev.dnainternet.fi. [2001:14ba:a085:4d00::8a5])
        by smtp.gmail.com with ESMTPSA id fn4-20020a1709069d0400b0084d4b907ff8sm13434169ejc.120.2023.01.19.06.43.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 06:43:27 -0800 (PST)
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 0/2] arm64/msm8996: enable UFS interconnect
Date:   Thu, 19 Jan 2023 16:43:24 +0200
Message-Id: <20230119144326.2492847-1-dmitry.baryshkov@linaro.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

MSM8996 requires a vote on UFS interconnects to work in a stable manner.
The first patch is a rework of older patch from Brian, see [1]

[1] https://lore.kernel.org/all/20221117104957.254648-2-bmasney@redhat.com/

Brian Masney (1):
  scsi: ufs: ufs-qcom: add basic interconnect support

Dmitry Baryshkov (1):
  arm64: dts: qcom: msm8996: enable UFS interconnects

 arch/arm64/boot/dts/qcom/msm8996.dtsi |  4 ++++
 drivers/ufs/host/ufs-qcom.c           | 26 ++++++++++++++++++++++++++
 2 files changed, 30 insertions(+)

-- 
2.39.0

