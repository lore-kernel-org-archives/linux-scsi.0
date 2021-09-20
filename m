Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76FDEC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Sep 2021 21:10:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EE9561159
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Sep 2021 21:10:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232964AbhITVLa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Sep 2021 17:11:30 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:28265 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233217AbhITVJa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Sep 2021 17:09:30 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1632172083; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=G3IVzzBfVgZWkFH3uGqzVuYGW1kOFbgXfF9zYJWD7A0=; b=VmwTKQvJ9EaUni9Sz058PEMXWXGO/u+yykahgQz8klM42Fi5zgbxPbzraaEyNsEeucDSNuYH
 dbeOKeIscQiIXG8UgbpulMC1dbYrOHKto4ivR0Y4DBDn5CylH6VCKx4exPe7T1Qpg5bvjijU
 vzvbyqu8WemljexbixzJMYZJSjs=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 6148f832507800c880eb2711 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 20 Sep 2021 21:08:02
 GMT
Sender: nguyenb=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4AEE1C43460; Mon, 20 Sep 2021 21:08:00 +0000 (UTC)
Received: from stor-berry.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: nguyenb)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 662F7C4338F;
        Mon, 20 Sep 2021 21:07:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 662F7C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   "Bao D. Nguyen" <nguyenb@codeaurora.org>
To:     cang@codeaurora.org, asutoshd@codeaurora.org,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc:     "Bao D. Nguyen" <nguyenb@codeaurora.org>,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH v1 0/2] Put Qualcomm's ufs controller to hibern8 during clock scaling
Date:   Mon, 20 Sep 2021 14:07:48 -0700
Message-Id: <cover.1632171047.git.nguyenb@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Asutosh Das tried to upstream this change about a year ago.
We would like to resume his work because Qualcomm's ufs controller
needs to be in hibern8 before scaling up/down the clocks.
Just like ufshcd_uic_hibern8_exit() is already being exported,
we would like to export ufshcd_uic_hibern8_enter() so that
Qualcomm's ufs controller can be put in hibern8 state.

Asutosh Das (2):
  scsi: ufs: export hibern8 entry and exit
  scsi: ufs-qcom: enter and exit hibern8 during clock scaling

 drivers/scsi/ufs/ufs-qcom.c | 12 +++++++++++-
 drivers/scsi/ufs/ufshcd.c   |  4 ++--
 drivers/scsi/ufs/ufshcd.h   |  2 ++
 3 files changed, 15 insertions(+), 3 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

