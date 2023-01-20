Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC9E7C05027
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Jan 2023 11:06:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbjATLGd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Jan 2023 06:06:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbjATLGc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Jan 2023 06:06:32 -0500
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E1C26589;
        Fri, 20 Jan 2023 03:06:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1674212791; x=1705748791;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=r4eVcY5PWTSkhuZjkCI/FpAddwZzhCktbJKHEhuYyT4=;
  b=hBKiuYbO0Fhq9Z6Mx4FlC1yahmtf+/3hZehK6jfnufglMb4OAzqzKbfA
   DJ4d5sp7GaSGNxHPNjeTZG59AEal/4yapihM648dixB0D/Y+T7Hrcw29H
   VCtHvA8WMkZBxaaKvRTZ13xbWvv+cQf3eUHp834vmWkE76dupm2B1wlYZ
   Y=;
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 20 Jan 2023 03:06:31 -0800
X-QCInternal: smtphost
Received: from unknown (HELO nasanex01a.na.qualcomm.com) ([10.52.223.231])
  by ironmsg-SD-alpha.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2023 03:06:31 -0800
Received: from hu-ahari-hyd.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Fri, 20 Jan 2023 03:06:25 -0800
From:   Anjana Hari <quic_ahari@quicinc.com>
To:     <agross@kernel.org>, <andersson@kernel.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <bvanassche@acm.org>, <konrad.dybcio@linaro.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <quic_narepall@quicinc.com>, <quic_nitirawa@quicinc.com>,
        <quic_rampraka@quicinc.com>, Anjana Hari <quic_ahari@quicinc.com>
Subject: [PATCH v2 0/1] scsi: ufs: Add hibernation callbacks
Date:   Fri, 20 Jan 2023 16:36:04 +0530
Message-ID: <20230120110605.9090-1-quic_ahari@quicinc.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds hibernation callbacks in UFS driver.
Please take a look and let us know your thoughts.

v1:
 - Addressed Bart's comments
 - Moved core and host related changes to single patch
 - Note to Bart: Regrading the comment to pass "restore" as an
 argument instead of adding a new member to ufs_hba structure, adding
 new function argument in core file (ufshcd.c) is forcing us to make
 changes to other vendor files to fix the compilation errors. Hence
 we have retained our original change. Please let us know your inputs
 on this.

Initial version:
 - Adds hibernation callbacks - freeze, restore and thaw,
 required for suspend to disk feature.

Anjana Hari (1):
  scsi: ufs: Add hibernation callbacks

 drivers/ufs/core/ufshcd.c   | 60 +++++++++++++++++++++++++++++++++++++
 drivers/ufs/host/ufs-qcom.c |  6 +++-
 include/ufs/ufshcd.h        |  8 +++++
 3 files changed, 73 insertions(+), 1 deletion(-)

-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center, Inc., is a member of Code Aurora Forum, a Linux Foundation Collaborative Project

