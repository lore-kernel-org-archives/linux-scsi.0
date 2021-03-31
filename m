Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2546BC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 03:16:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB81B619BD
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 03:16:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233462AbhCaDPb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Mar 2021 23:15:31 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:33701 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233360AbhCaDPU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Mar 2021 23:15:20 -0400
IronPort-SDR: pcLxzO+mfYDZ3Hrozdv24Ga1IUovwidZaRHvr04vqCOe3x7hFn0RkxTrMup9aJJim6qFyHy0IM
 HSgTPVNBW9v496rYMla75AHZBVKaP/RJRZfN/bQjxVfOUSO12x/grzoeXmNeibe62FF6IiiO9m
 mcp/xx3bHM2lwROdz3Zk3tUMaec1YZY+eLk4dwY5AaTmI5w4oGyVr3cEhQzQELGdynhr6jB13M
 9O5yrod2TPQtaVzs7B0DvysK3q8oVgoyFLp+F1CrNTxahGvFjn6VkEPhIKcauTrxv4s1TmtvJX
 j0c=
X-IronPort-AV: E=Sophos;i="5.81,291,1610438400"; 
   d="scan'208";a="47836032"
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by labrats.qualcomm.com with ESMTP; 30 Mar 2021 20:15:19 -0700
X-QCInternal: smtphost
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg03-sd.qualcomm.com with ESMTP; 30 Mar 2021 20:15:09 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 851D3210A6; Tue, 30 Mar 2021 20:15:09 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, cang@codeaurora.org
Subject: [PATCH v2 0/2] Introduce hba performance monitoring sysfs nodes
Date:   Tue, 30 Mar 2021 20:14:32 -0700
Message-Id: <1617160475-1550-1-git-send-email-cang@codeaurora.org>
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

