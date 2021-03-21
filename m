Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB985C433C1
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Mar 2021 21:59:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8943461947
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Mar 2021 21:59:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231622AbhCUV6r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 21 Mar 2021 17:58:47 -0400
Received: from alexa-out.qualcomm.com ([129.46.98.28]:40323 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231548AbhCUV6V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Mar 2021 17:58:21 -0400
Received: from ironmsg-lv-alpha.qualcomm.com ([10.47.202.13])
  by alexa-out.qualcomm.com with ESMTP; 21 Mar 2021 14:58:20 -0700
X-QCInternal: smtphost
Received: from ironmsg01-blr.qualcomm.com ([10.86.208.130])
  by ironmsg-lv-alpha.qualcomm.com with ESMTP/TLS/AES256-SHA; 21 Mar 2021 14:58:19 -0700
X-QCInternal: smtphost
Received: from maggarwa.ap.qualcomm.com (HELO nitirawa-linux.qualcomm.com) ([10.206.25.176])
  by ironmsg01-blr.qualcomm.com with ESMTP; 22 Mar 2021 03:27:40 +0530
Received: by nitirawa-linux.qualcomm.com (Postfix, from userid 2342877)
        id C2DA72E19; Mon, 22 Mar 2021 03:27:39 +0530 (IST)
From:   Nitin Rawat <nitirawa@codeaurora.org>
To:     asutoshd@codeaurora.org, cang@codeaurora.org,
        stummala@codeaurora.org, vbadigan@codeaurora.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bjorn.andersson@linaro.org,
        adrian.hunter@intel.com, bvanassche@acm.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nitin Rawat <nitirawa@codeaurora.org>
Subject: [PATCH V2 0/3] scsi: ufs: Add a vops to configure VCC voltage level
Date:   Mon, 22 Mar 2021 03:27:34 +0530
Message-Id: <1616363857-26760-1-git-send-email-nitirawa@codeaurora.org>
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

v1 -> v2
Added suggested-by on patch2 (scsi: ufs: add a vops to configure VCC voltage level)

Nitin Rawat (3):
  scsi: ufs: export api for use in vendor file
  scsi: ufs: add a vops to configure VCC voltage level
  scsi: ufs-qcom: configure VCC voltage level in vendor file

 drivers/scsi/ufs/ufs-qcom.c | 51 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.c   | 13 +++++++++---
 drivers/scsi/ufs/ufshcd.h   | 14 +++++++++++++
 3 files changed, 75 insertions(+), 3 deletions(-)

--
2.7.4

