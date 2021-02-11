Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9E20C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 19:21:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7395B64DA1
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 19:21:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbhBKTTd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 14:19:33 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:12488 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbhBKTT3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2021 14:19:29 -0500
IronPort-SDR: yazEGgeAj2g9SnbjH6tVBw2tYi46SQgj9ZXwINNiGU/dIVCSAsXyEReM4v7NBiiPEjRi5mu1ja
 g3SkZoKbGjbIW5Rm4XSDGhPzFe7esDXzpURjaVA45RlOdjXXCLMQbKMtiN2Hth9Uec0eqEl4eK
 KQA0zJqVdM06RnzEIH3AvYQEEAyvRaTJrCvCob8IwCtSbb2Ut9owLEd0GhzQokUxUxaL+AMFES
 eL7VBgpNX34qtyyL7Gkc3w8OZemz97Oa0Z2F163IGF5DcUpNlCuR5BsVwDCurKIWutR42nlLSi
 ojM=
X-IronPort-AV: E=Sophos;i="5.81,171,1610438400"; 
   d="scan'208";a="47741091"
Received: from unknown (HELO ironmsg02-sd.qualcomm.com) ([10.53.140.142])
  by labrats.qualcomm.com with ESMTP; 11 Feb 2021 11:18:48 -0800
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg02-sd.qualcomm.com with ESMTP; 11 Feb 2021 11:18:47 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 92687)
        id CB9982191A; Thu, 11 Feb 2021 11:18:47 -0800 (PST)
From:   Asutosh Das <asutoshd@codeaurora.org>
To:     cang@codeaurora.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc:     Asutosh Das <asutoshd@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, stern@rowland.harvard.edu
Subject: [RFC PATCH v3 0/1] Enable power management for ufs wlun 
Date:   Thu, 11 Feb 2021 11:18:28 -0800
Message-Id: <cover.1613070911.git.asutoshd@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


This patch attempts to fix a deadlock in ufs while sending SSU.
Recently, blk_queue_enter() added a check to not process requests if the
queue is suspended. That leads to a resume of the associated device which
is suspended. In ufs, that device is ufs device wlun and it's parent is
ufs_hba. This resume tries to resume ufs device wlun which in turn tries
to resume ufs_hba, which is already in the process of suspending, thus
causing a deadlock.

This patch takes care of:
* Suspending the ufs device lun only after all other luns are suspended
* Sending SSU during ufs device wlun suspend
* Clearing uac for rpmb and ufs device wlun
* Not sending commands to the device during host suspend

I'm testing it out now, please take a look and let me know.

Asutosh Das (1):
  scsi: ufs: Enable power management for wlun

 drivers/scsi/ufs/ufshcd.c  | 415 +++++++++++++++++++++++++++++++++++++--------
 drivers/scsi/ufs/ufshcd.h  |   4 +
 include/trace/events/ufs.h |  20 +++
 3 files changed, 364 insertions(+), 75 deletions(-)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

