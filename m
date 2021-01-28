Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BDB1C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 16:56:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF88564E0C
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 16:56:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232267AbhA1Q4U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jan 2021 11:56:20 -0500
Received: from alexa-out.qualcomm.com ([129.46.98.28]:62233 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbhA1Q4M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2021 11:56:12 -0500
Received: from ironmsg-lv-alpha.qualcomm.com ([10.47.202.13])
  by alexa-out.qualcomm.com with ESMTP; 28 Jan 2021 08:55:30 -0800
X-QCInternal: smtphost
Received: from ironmsg02-blr.qualcomm.com ([10.86.208.131])
  by ironmsg-lv-alpha.qualcomm.com with ESMTP/TLS/AES256-SHA; 28 Jan 2021 08:55:28 -0800
X-QCInternal: smtphost
Received: from nitirawa-linux.qualcomm.com ([10.206.25.176])
  by ironmsg02-blr.qualcomm.com with ESMTP; 28 Jan 2021 22:25:01 +0530
Received: by nitirawa-linux.qualcomm.com (Postfix, from userid 2342877)
        id D5C3C2A73; Thu, 28 Jan 2021 22:25:01 +0530 (IST)
From:   Nitin Rawat <nitirawa@codeaurora.org>
To:     asutoshd@codeaurora.org, cang@codeaurora.org,
        stummala@codeaurora.org, vbadigan@codeaurora.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com
Cc:     bvanassche@acm.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nitin Rawat <nitirawa@codeaurora.org>
Subject: [PATCH V1 0/3] scsi: ufs: Add a vops to configure VCC voltage level
Date:   Thu, 28 Jan 2021 22:24:56 +0530
Message-Id: <1611852899-2171-1-git-send-email-nitirawa@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UFS specification allows different VCC configurations for UFS devices,
for example,
        (1)2.70V - 3.60V (For UFS 2.x devices)
        (2)2.40V - 2.70V (For UFS 3.x devices)
For platforms supporting both ufs 2.x (2.7v-3.6v) and
ufs 3.x (2.4v-2.7v), the voltage requirements (VCC) is 2.4v-3.6v.
So to support this, we need to start the ufs device initialization with
the common VCC voltage(2.7v) and after reading the device descriptor we
need to switch to the correct range(vcc min and vcc max) of VCC voltage
as per UFS device type since 2.7v is the marginal voltage as per specs
for both type of devices.

Once VCC regulator supply has been intialised to 2.7v and UFS device
type is read from device descriptor, we follows below steps to
change the VCC voltage values.

1. Set the device to SLEEP state.
2. Disable the Vcc Regulator.
3. Set the vcc voltage according to the device type and reenable
   the regulator.
4. Set the device mode back to ACTIVE.

The above changes are done in vendor specific file by
adding a vops which will be needed for platform
supporting both ufs 2.x and ufs 3.x devices.

Nitin Rawat (3):
  scsi: ufs: export api for use in vendor file
  scsi: ufs: add a vops to configure VCC voltage level
  scsi: ufs-qcom: configure VCC voltage level in vendor file

 drivers/scsi/ufs/ufs-qcom.c | 51 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.c   | 14 ++++++++++---
 drivers/scsi/ufs/ufshcd.h   | 14 +++++++++++++
 3 files changed, 76 insertions(+), 3 deletions(-)

--
2.7.4

