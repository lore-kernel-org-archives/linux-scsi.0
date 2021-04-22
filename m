Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7E60C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 02:29:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B471260232
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 02:29:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbhDVC3k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 22:29:40 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:13593 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbhDVC3k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Apr 2021 22:29:40 -0400
IronPort-SDR: 8YS6VZdBdn1HGlLo5/xeL1WQPR0O3poqDEzo+iKo0UEffGGLTHNvqg8hDqizqfj9JVJYeQfmdA
 wi9sSm83QOQZhfEKqhTKMyrf/9A0yeX0vumPdq/Wx3qw9ujQp/PmEVYy+LvPPYVvSudO+nrgT1
 9ElLy0Y1ijlJUtHDYuAd2BjP8UG8lRcTgbhpJX27T0stLQd9g/IUwoC7aaMu/+ax+Sli9JCLOb
 zM4EJIBv1NUtcZqlY7u96e7AyWWidywKOnhh7y7qdQ31ijzT48z6YPvkUVnkislo0185oZvi02
 dLE=
X-IronPort-AV: E=Sophos;i="5.82,241,1613462400"; 
   d="scan'208";a="29756610"
Received: from unknown (HELO ironmsg01-sd.qualcomm.com) ([10.53.140.141])
  by labrats.qualcomm.com with ESMTP; 21 Apr 2021 19:29:06 -0700
X-QCInternal: smtphost
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg01-sd.qualcomm.com with ESMTP; 21 Apr 2021 19:29:06 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 3C73F2115E; Wed, 21 Apr 2021 19:29:06 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, cang@codeaurora.org
Subject: [PATCH v5 0/2] Introduce hba performance monitoring sysfs nodes
Date:   Wed, 21 Apr 2021 19:28:38 -0700
Message-Id: <1619058521-35307-1-git-send-email-cang@codeaurora.org>
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

Change since v4:
- Use lrbp->compl_time_stamp as now in ufshcd_update_monitor()

Change since v3:
- Rebased

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

