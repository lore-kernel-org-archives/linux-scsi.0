Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C4CCC4742C
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Nov 2020 06:30:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22D6121D7F
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Nov 2020 06:30:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbgKMGaO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Nov 2020 01:30:14 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:9285 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbgKMGaN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Nov 2020 01:30:13 -0500
IronPort-SDR: 06n+EC0kXaZT+FpptyVYJKhnrBxPGzZjpwuUa/NAcymGryhTv6HGjP9NuMJVNvE8nFlAR7aofs
 0twY/loJQIBgmUxzK3UYiDIOMOq1GvpP0qbEKNsHD8XZ9oZICHMo420V8BIM1rfBjF3Ne6rqbl
 uQOZ3z+UHVuL6kU9oY9M66Gj1kXWvgSPUgwapZQSndMss9M1OtypbLwFvCzM6yXCdUnwehHT2t
 C7So80RiT6oyHfY7k7dp5HzSPAifJ18fmz+OtRBsvBfCsc6t7G0Rd/5JUqiFpLHEgHWFdPfdHR
 XD4=
X-IronPort-AV: E=Sophos;i="5.77,474,1596524400"; 
   d="scan'208";a="47457225"
Received: from unknown (HELO ironmsg02-sd.qualcomm.com) ([10.53.140.142])
  by labrats.qualcomm.com with ESMTP; 12 Nov 2020 22:30:13 -0800
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg02-sd.qualcomm.com with ESMTP; 12 Nov 2020 22:30:11 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id EED4921787; Thu, 12 Nov 2020 22:30:11 -0800 (PST)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Subject: [PATCH RFC v1 0/1] scsi: pm: Leave runtime resume along if block layer PM is enabled
Date:   Thu, 12 Nov 2020 22:30:07 -0800
Message-Id: <1605249009-13752-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In current UFS driver, if the hba device is in RPM_SUSPENDED status when system suspend
happens, UFS driver chooses not to resume hba device during system resume [1], which is
to achieve power efficiency by leaving the runtime PM to block layer PM.

Similarly, if block layer runtime PM is enabled for one SCSI device, then there is no
need to forcibly change the SCSI device and its request queue's runtime PM status to
RPM_ACTIVE in scsi_dev_type_resume(), since block layer PM shall resume the SCSI device
on the demand of bios.

Without this change, if situation [1] happens, when scsi_dev_type_resume() invokes
blk_pm_set_active(), we will get an error since it is trying to set the SCSI device's
runtime PM status to RPM_ACTIVE even when its parent is not RPM_ACTIVE, which actually
is not fatal. This change can avoid the annoying error logs when situation [1] happens.

However, there are some rare cases where upper layers start to submit bios into the
request queue of one SCSI device even when scsi_dev_type_resume() is still running on
that SCSI device. In these rare cases, if situation [1] happens, when a bio is sent to
block layer, block layer runtime PM shall try to runtime resume the SCSI device
(invoked from blk_queue_enter()) and if meanwhile scsi_dev_type_resume() has ran over
line #83 but before #85 (see below code snippet), block layer runtime PM won't be able
to resume it due to runtime PM is disabled on this device at this moment. And later if
no more bios kick blk_queue_enter(), the bio will be stuck at blk_queue_enter() forever.
This change can fix the problem too.

<--code snippet-->
72 static int scsi_dev_type_resume(struct device *dev,
73 		int (*cb)(struct device *, const struct dev_pm_ops *))
74 {
...
83 		pm_runtime_disable(dev);
84 		err = pm_runtime_set_active(dev);
85 		pm_runtime_enable(dev);
...
<--code snippet-->

Can Guo (1):
  scsi: pm: Leave runtime resume along if block layer PM is enabled

 drivers/scsi/scsi_pm.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

