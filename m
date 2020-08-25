Return-Path: <SRS0=BOoC=CD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8207AC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Aug 2020 02:08:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6934320738
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Aug 2020 02:08:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgHYCIF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Aug 2020 22:08:05 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:20064 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgHYCIE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Aug 2020 22:08:04 -0400
IronPort-SDR: hFSyh/HraGKJgQJMtkouMIBqpiIWo2L9yAzskPCcR5G+878iaDHAqGQJeQdLViunjFgPtDkPC/
 CYW7B1PglqfTMaTSP+C7SK0f5bPBsNjO6o6HaU/7tsdH0PFcN4V8FpvIMNZ4m1FAqwGGsxdUR+
 hHDO+SKlazf1djHfpCbYljdliFLBTjj9/JXZfjVAFCDU9rkWmsFB9KBMjgodciWHtlSOW/EUhX
 UvVtoOqm0Vape43ScT33vfk/yhGIqe2W//C5zcYJjx4NTonr/oRCX25F+lvj/me3Yk0QT23zyR
 1SU=
X-IronPort-AV: E=Sophos;i="5.76,350,1592895600"; 
   d="scan'208";a="47272758"
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by labrats.qualcomm.com with ESMTP; 24 Aug 2020 19:07:10 -0700
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg03-sd.qualcomm.com with ESMTP; 24 Aug 2020 19:07:09 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 4163A21626; Mon, 24 Aug 2020 19:07:09 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Subject: [RESEND PATCH v1 0/2] Add UFS LINERESET handling
Date:   Mon, 24 Aug 2020 19:07:04 -0700
Message-Id: <1598321228-21093-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PA Layer issues a LINERESET to the PHY at the recovery step in the Power
Mode change operation. If it happens during auto or mannual hibern8 enter,
even if hibern8 enter succeeds, UFS power mode shall be set to PWM-G1 mode
and kept in that mode after exit from hibern8, leading to bad performance.
Handle the LINERESET in the eh_work by restoring power mode to HS mode
after all pending reqs and tasks are cleared from doorbell.

Can Guo (2):
  scsi: ufs: Abort tasks before clear them from doorbell
  scsi: ufs: Handle LINERESET indication in err handler

 drivers/scsi/ufs/ufshcd.c | 254 ++++++++++++++++++++++++++++++++--------------
 drivers/scsi/ufs/ufshcd.h |   2 +
 drivers/scsi/ufs/ufshci.h |   1 +
 drivers/scsi/ufs/unipro.h |   3 +
 4 files changed, 184 insertions(+), 76 deletions(-)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

