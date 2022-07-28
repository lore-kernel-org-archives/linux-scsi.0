Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F743C04A68
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jul 2022 17:30:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231573AbiG1Ra6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jul 2022 13:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiG1Ra5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jul 2022 13:30:57 -0400
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 892276FA14;
        Thu, 28 Jul 2022 10:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1659029456; x=1690565456;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=XNFj4plBTLrQLTuoVPA2R4SqV2ybwrCgihjL8EFDQpU=;
  b=eK5QwNNkUD2+LrMxE6i2lKt/FaPqOcj14cDj4hR+P2+8Xp54wKxEsUUr
   i9shkKlnPNot40DZsQNK2X0Pt4Fw/ljnUtK60gcm/vIVebyBQQAOpimY4
   jr7HWHih96bWQ+DOsJInJrpALfLTxJ36Vl9l3kzaIeUEbWaeyZISyLFPZ
   Q=;
Received: from unknown (HELO ironmsg01-sd.qualcomm.com) ([10.53.140.141])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 28 Jul 2022 10:30:56 -0700
X-QCInternal: smtphost
Received: from unknown (HELO nasanex01a.na.qualcomm.com) ([10.52.223.231])
  by ironmsg01-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 10:30:56 -0700
Received: from hu-cchinnad-hyd.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Thu, 28 Jul 2022 10:30:53 -0700
From:   Chetan C R <quic_cchinnad@quicinc.com>
To:     <bvanassche@acm.org>
CC:     <jejb@linux.ibm.com>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>,
        Chetan C R <quic_cchinnad@quicinc.com>
Subject: [PATCH V2] scsi: ufs: Get boot device storage type from command line
Date:   Thu, 28 Jul 2022 23:00:41 +0530
Message-ID: <1659029442-19135-1-git-send-email-quic_cchinnad@quicinc.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

v1->v2:
 - Made UFS_QCOM_CMDLINE as default 'Y' to get __setup()

Get the boot device storage type by reading it from
kernel command line arguments and export the same
information to ufs modules.

Chetan C R (1):
  scsi: ufs: Get boot device storage type from command line

 drivers/ufs/host/Kconfig       | 10 ++++++++
 drivers/ufs/host/Makefile      |  1 +
 drivers/ufs/host/ufs-cmdline.c | 54 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 65 insertions(+)
 create mode 100644 drivers/ufs/host/ufs-cmdline.c

-- 
2.7.4

