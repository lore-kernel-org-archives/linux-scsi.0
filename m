Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52C36C001DE
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jul 2023 14:50:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233089AbjGaOun (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jul 2023 10:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232355AbjGaOum (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jul 2023 10:50:42 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D946FDB
        for <linux-scsi@vger.kernel.org>; Mon, 31 Jul 2023 07:50:40 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1b9c5e07c1bso39175845ad.2
        for <linux-scsi@vger.kernel.org>; Mon, 31 Jul 2023 07:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1690815040; x=1691419840;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jzYKaWJBV7r6FBoOWy19q9Vp5WCRs4zk2VoX6XkHWd8=;
        b=FiV/Ypzo1L9irb459PibZEA01bTRKxCauVE3RYfPGl/Ly3CSCK0JZk5J7sG9j6Ps5x
         WU51Z0H5kNiiVoVthnZfzx/Ow4FXg1lZdalT9fqp9Mwk4Yy21l3cSapyxEUtcTDdjNd6
         uk7qcY7YC5zfrNCpOvk2cp4hs/98yCgROAwsDkQ0bt8a0UAjBy1tkGZ0smCyReG8Vbsb
         cc+66Hc+oqpoZEHOCdc4g203alAeo5xoT6MfQ6V23oQehMpgVCchD/GqH7UPRnL06RiK
         p0jtrhBjkG8rzzqFqKyoJOjvWW/WkkMNqs6coYXfgaOeuu+b1DZxGpzVoDpGRzAVHrgl
         NwNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690815040; x=1691419840;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jzYKaWJBV7r6FBoOWy19q9Vp5WCRs4zk2VoX6XkHWd8=;
        b=CPCjkvxsdFAHsmxoLr3SZ2T4H/SW9TcwFSd4Cngp/0RzLtJ6AmUrusMlVTaOJ0KFNP
         nFUv3C0SNxYpfrrKhQCRtHB6QzWfpYAdXV8N5WJ78LbWOhj+8WVaRwzm2Vo3gQ4xgAiC
         Hti2W2T7UP1gEay1l515ncmtRSvY4Q0nNAN8Fvh59/uXfouVFqtfT88S5zWP6ExMahzk
         yJYiuKhzhOhRFe6O8GcFcHaZvAMWCEEP31GeJu28VjX/FZTf+SxKWau5eaJFKBcNmLkg
         mzOJb6lHMXN+Y4qWl3kR5UbLABbAHXEIx2Y6F1MuMLs89zDNm0hsy0PIneWipH+YioQ9
         ACOA==
X-Gm-Message-State: ABy/qLbU2wtH8CUavaP9MwmsPMN+V0g45TF1a6ZvzvBphCjiPzYwR4Kv
        92H4Hx+/398F4ZNhWZweslkS
X-Google-Smtp-Source: APBJJlEs1zZUAT7jWFiRSzS0YUYnrcO/xgzGopf53tcs+gaZO4k8RCHFNjTuJvXXqbACrf4JkYEYkw==
X-Received: by 2002:a17:902:7894:b0:1bb:c7b6:493a with SMTP id q20-20020a170902789400b001bbc7b6493amr9632018pll.21.1690815040268;
        Mon, 31 Jul 2023 07:50:40 -0700 (PDT)
Received: from localhost.localdomain ([117.193.209.129])
        by smtp.gmail.com with ESMTPSA id y4-20020a170902ed4400b001b06c106844sm8730185plb.151.2023.07.31.07.50.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 07:50:39 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     andersson@kernel.org, konrad.dybcio@linaro.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 0/2] scsi: ufs: qcom: Add interconnect support
Date:   Mon, 31 Jul 2023 20:20:18 +0530
Message-Id: <20230731145020.41262-1-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

This series adds interconnect support to Qcom UFS driver. Interconnect support
is added to Qcom UFS driver for scaling the interconnect path dynamically. This
is required to avoid boot crash in recent SoCs and also to save power during
runtime. More information is available in patch 2/2.

Credits
=======

This series is a continuation of previous work by Brian Masney [1].

Testing
=======

This series is tested on 96Boards RB3 (SDM845 SoC) and RB5 (SM8250 SoC)
development boards.

NOTE: This series is a spin-off from previous OPP and interconnect series:
https://lore.kernel.org/all/20230720054100.9940-1-manivannan.sadhasivam@linaro.org/

Since the devicetree patches are already merged to Qcom tree, they are excluded
from this series.

Thanks,
Mani

[1] https://lore.kernel.org/all/20221117104957.254648-1-bmasney@redhat.com/

Manivannan Sadhasivam (2):
  scsi: ufs: core: Add enums for UFS lanes
  scsi: ufs: qcom: Add support for scaling interconnects

 drivers/ufs/core/ufshcd.c        |   4 +-
 drivers/ufs/host/ufs-qcom.c      | 131 ++++++++++++++++++++++++++++++-
 drivers/ufs/host/ufs-qcom.h      |   3 +
 drivers/ufs/host/ufshcd-pltfrm.c |   4 +-
 include/ufs/unipro.h             |   6 ++
 5 files changed, 143 insertions(+), 5 deletions(-)

-- 
2.25.1

