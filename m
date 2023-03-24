Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E1DBC76195
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Mar 2023 07:41:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231422AbjCXHlj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Mar 2023 03:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbjCXHlh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Mar 2023 03:41:37 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4F2319F18
        for <linux-scsi@vger.kernel.org>; Fri, 24 Mar 2023 00:41:35 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id ew6so4352401edb.7
        for <linux-scsi@vger.kernel.org>; Fri, 24 Mar 2023 00:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1679643694;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=X/XWx7YkBxGnboDoZgQ7k0nvdNbLK5mLNGMl2mAQck8=;
        b=y8zuVgRuzHzC24+lgI2LUBOgkWYy3kb7SGkW+YrO4cBzYgZZcpDwDM+s4XIh5PbkGC
         UFR+WYPQXxtOmIjjsQdikK2Q1c3n0Zh2q5c2LzvELoe0lKl0g+SIhcdSs0GLtgUT6b7M
         vaebepD5WuWjd/kpStDB13QO9WVcXUjUTz2PyhDLjdyTt3Bz5HSvJHrW/kFetYgFbGtr
         7WtyzQ+1UOwDlU72oZey1Obkk+4I+ZnbPjMLe0zxWnv58irb/eaj4hulf5roo08bxm+6
         JV0YB9tPSP4Gpoan5jENIw40KuFAKrQRTB9xQgY0k2O6zAqhxzGPVJxRBGeafn/iFebG
         QzLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679643694;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X/XWx7YkBxGnboDoZgQ7k0nvdNbLK5mLNGMl2mAQck8=;
        b=DVfZ15uhBo4tgQ9ElVyX7IvDjXFiOXDZMQtu2Gr/jzWXCTQQLfu7oHQnZznHRFClws
         MZcq3se/46pu7lsOrhPxDZqj07QuncI+9r4z9Sl1KItHig7DbZ4S6Qmf50ZEl12EmsTK
         2Nzm6zltmh5swajbwSYtH+/nLqpkP5B5rF9hVFaWAAMAv93tWHpR2P3TuOJpkXslSSHP
         XDgftFXfkanwjH1CbVdfNAB85WF71NJNF+f/H+hfx7sy7pp2x3lTfS7iQBUK61eEOH8J
         ipafeTFOogMAoHKuMaXQrOT9rGKpWNZ0pE2X1ZMkfq6sTi4G+SuPVavq7qwcm3mGD1xg
         G47g==
X-Gm-Message-State: AAQBX9d9y540JO9aF1sx+VZ/sg+aMsBN5EtNb55sz/ltdHhXyz6ZIPoZ
        MX4nVkKfg9vGLqxy7xM4bkiFTA==
X-Google-Smtp-Source: AKy350Zow5T6QA/twFWOhVbkw0YON81CH4a5u2mrMAh8v5pAtniRwZgs0rK8eL9aW9GFlHa6vcrG2Q==
X-Received: by 2002:aa7:c397:0:b0:4fe:e851:af4a with SMTP id k23-20020aa7c397000000b004fee851af4amr1753723edq.39.1679643694211;
        Fri, 24 Mar 2023 00:41:34 -0700 (PDT)
Received: from [192.168.0.29] (84-115-214-73.cable.dynamic.surfer.at. [84.115.214.73])
        by smtp.gmail.com with ESMTPSA id d23-20020a50f697000000b004fd2a7aa1ecsm10271227edn.32.2023.03.24.00.41.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 00:41:33 -0700 (PDT)
From:   Luca Weiss <luca.weiss@fairphone.com>
Subject: [PATCH v3 0/3] Fix some issues in QCOM UFS bindings
Date:   Fri, 24 Mar 2023 08:41:27 +0100
Message-Id: <20221209-dt-binding-ufs-v3-0-499dff23a03c@fairphone.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIACdUHWQC/33NTQrCMBAF4KuUrB1Jx7YxrryHuEjz0wRqIkkbk
 NK7O7gUdDXzBt43Gys2B1vYpdlYtjWUkCKF06Fh2qs4WQiGMkOO2CKXYBYYQzQhTrC6AmiEGzo
 hhXPIqDSqYmHMKmpPtbjOMx19KEvKr8+T2tK4/fRqCxzOpufouG1puToV8tOnaI86PdiduIr/C
 STCaKF4N0jZC/lN7Pv+BteJehP4AAAA
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Iskren Chernev <me@iskren.info>,
        Manivannan Sadhasivam <mani@kernel.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        Luca Weiss <luca.weiss@fairphone.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        Iskren Chernev <me@iskren.info>
X-Mailer: b4 0.12.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
---
Changes in v3:
- Drop applied patch
- Pick up sm6115 patch from v5 https://lore.kernel.org/all/20221030094258.486428-2-iskren.chernev@gmail.com/
- Rebase on linux-next
- Link to v2: https://lore.kernel.org/r/20221209-dt-binding-ufs-v2-0-dc7a04699579@fairphone.com

Changes in v2:
- Add new patch adding reg-names to sm6115 & rebase series on top of sm6115
  addition
- Fix binding example after sm8450 move, split this patch from original patch
  since it became too big
- Move reg-names definition to top-level
- Link to v1: https://lore.kernel.org/r/20221209-dt-binding-ufs-v1-0-8d502f0e18d5@fairphone.com

---
Iskren Chernev (1):
      dt-bindings: ufs: qcom: Add sm6115 binding

Luca Weiss (2):
      dt-bindings: ufs: qcom: Add reg-names property for ICE
      dt-bindings: ufs: qcom: Fix sm8450 bindings

 .../devicetree/bindings/ufs/qcom,ufs.yaml          | 61 ++++++++++++++++++++--
 1 file changed, 56 insertions(+), 5 deletions(-)
---
base-commit: e5dbf24e8b9e6aa0a185d86ce46a7a9c79ebb40f
change-id: 20221209-dt-binding-ufs-2d7f64797ff2

Best regards,
-- 
Luca Weiss <luca.weiss@fairphone.com>

