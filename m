Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CAB2C433B4
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Apr 2021 06:12:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43B2361056
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Apr 2021 06:12:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233247AbhDAGMM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Apr 2021 02:12:12 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:65452 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhDAGLo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2021 02:11:44 -0400
IronPort-SDR: h9FZGCqXFN/bc1lVEqkmR7gm837N5xbF5mXKRZEVXovS5u3P3k//ybkfXmENM6FRVxtxvE+9si
 qKVYoywipR0SeQsb9NIIKK4XrFS0U6roeN9ph7JtTj6rNbrQVLmxIAKEQZDSwz2D0m6dNSlWt4
 ypaYDu3lRlQBpuvatQl1L8tkZd23mlM5XXlCyF3Fd4EJlYANjA9CT9zj1rLAg6BIVq4z6s3y3v
 ICZ9ls17wj6IFT/VntE4eLHeQnNsKpbyEdS9EGm3qX1sCY+VLbAWmjXdLPc/bUYu6wvqCkzkXU
 598=
X-IronPort-AV: E=Sophos;i="5.81,296,1610438400"; 
   d="scan'208";a="47836542"
Received: from unknown (HELO ironmsg02-sd.qualcomm.com) ([10.53.140.142])
  by labrats.qualcomm.com with ESMTP; 31 Mar 2021 23:11:44 -0700
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg02-sd.qualcomm.com with ESMTP; 31 Mar 2021 23:11:43 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id EBBDD210A9; Wed, 31 Mar 2021 23:11:43 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, cang@codeaurora.org
Subject: [PATCH v3 0/2] Introduce hba performance monitoring sysfs nodes
Date:   Wed, 31 Mar 2021 23:11:40 -0700
Message-Id: <1617257503-669-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add a new sysfs group which has nodes to monitor data/request transfer
performance. This sysfs group has nodes showing total sectors/requests
transferred, total busy time spent and max/min/avg/sum latencies. This
group can be enhanced later to show more UFS driver layer performance
data during runtime.

It works like:
/sys/bus/platform/drivers/ufshcd/*/monitor # echo 4096 > monitor_chunk_size
/sys/bus/platform/drivers/ufshcd/*/monitor # echo 1 > monitor_enable
/sys/bus/platform/drivers/ufshcd/*/monitor # grep ^ /dev/null *
monitor_chunk_size:4096
monitor_enable:1
read_nr_requests:17
read_req_latency_avg:169
read_req_latency_max:594
read_req_latency_min:66
read_req_latency_sum:2887
read_total_busy:2639
read_total_sectors:136
write_nr_requests:116
write_req_latency_avg:440
write_req_latency_max:4921
write_req_latency_min:23
write_req_latency_sum:51052
write_total_busy:19584
write_total_sectors:928

Change since v2:
- Fixed a sparse error

Change since v1:
- Moved code from ufs-qcom.c to ufshcd.c

Can Guo (2):
  scsi: ufs: Introduce hba performance monitor sysfs nodes
  scsi: ufs: Add support for hba performance monitor

 Documentation/ABI/testing/sysfs-driver-ufs | 126 +++++++++++++++
 drivers/scsi/ufs/ufs-sysfs.c               | 237 +++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.c                  |  62 ++++++++
 drivers/scsi/ufs/ufshcd.h                  |  21 +++
 4 files changed, 446 insertions(+)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

