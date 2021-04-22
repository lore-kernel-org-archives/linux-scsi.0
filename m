Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B580C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 02:29:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0A2461452
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 02:29:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234240AbhDVC35 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 22:29:57 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:55054 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234055AbhDVC34 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Apr 2021 22:29:56 -0400
IronPort-SDR: rY2cNJbboWiRn+Xa1PYK1rR+cZgK7X2v71G6p8lpFD5+fyWEai++pKzOOG11h07EBdb+JJY5P8
 MRNCAWiOjYcCJfcY7kEg+SGrR/VJ/c3+wXgY3xuRmKp7JWDOH+SPDwpG4U3uiZ/cbiCodluId2
 Tm07S09RdStjYdojIROTX5OiXUsyqNboeSXFkIodPjxMFfM78oFbnsOT64/9rBkXko5zKZEw8X
 przmob/LRoc1aLMu4Zf+zEdMJFVZn3qetXcZOxvzj46DC1uGxE7ggUHKO/KXNkrKcgSklR3JM0
 6/A=
X-IronPort-AV: E=Sophos;i="5.82,241,1613462400"; 
   d="scan'208";a="29756611"
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
  by labrats.qualcomm.com with ESMTP; 21 Apr 2021 19:29:22 -0700
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg-SD-alpha.qualcomm.com with ESMTP; 21 Apr 2021 19:29:21 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 9F52F2115E; Wed, 21 Apr 2021 19:29:21 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, cang@codeaurora.org
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Bean Huo <beanhuo@micron.com>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v5 2/2] scsi: ufs: Add support for hba performance monitor
Date:   Wed, 21 Apr 2021 19:28:40 -0700
Message-Id: <1619058521-35307-3-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1619058521-35307-1-git-send-email-cang@codeaurora.org>
References: <1619058521-35307-1-git-send-email-cang@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add a new sysfs group which has nodes to monitor data/request transfer
performance. This sysfs group has nodes showing total sectors/requests
transferred, total busy time spent and max/min/avg/sum latencies.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 Documentation/ABI/testing/sysfs-driver-ufs | 126 +++++++++++++++++++++++++++++
 1 file changed, 126 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index d1bc23c..8380866 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -995,6 +995,132 @@ Description:	This entry shows the target state of an UFS UIC link
 
 		The file is read only.
 
+What:		/sys/bus/platform/drivers/ufshcd/*/monitor/monitor_enable
+Date:		January 2021
+Contact:	Can Guo <cang@codeaurora.org>
+Description:	This file shows the status of performance monitor enablement
+		and it can be used to start/stop the monitor. When the monitor
+		is stopped, the performance data collected is also cleared.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/monitor/monitor_chunk_size
+Date:		January 2021
+Contact:	Can Guo <cang@codeaurora.org>
+Description:	This file tells the monitor to focus on requests transferring
+		data of specific chunk size (in Bytes). 0 means any chunk size.
+		It can only be changed when monitor is disabled.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/monitor/read_total_sectors
+Date:		January 2021
+Contact:	Can Guo <cang@codeaurora.org>
+Description:	This file shows how many sectors (in 512 Bytes) have been
+		sent from device to host after monitor gets started.
+
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/monitor/read_total_busy
+Date:		January 2021
+Contact:	Can Guo <cang@codeaurora.org>
+Description:	This file shows how long (in micro seconds) has been spent
+		sending data from device to host after monitor gets started.
+
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/monitor/read_nr_requests
+Date:		January 2021
+Contact:	Can Guo <cang@codeaurora.org>
+Description:	This file shows how many read requests have been sent after
+		monitor gets started.
+
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/monitor/read_req_latency_max
+Date:		January 2021
+Contact:	Can Guo <cang@codeaurora.org>
+Description:	This file shows the maximum latency (in micro seconds) of
+		read requests after monitor gets started.
+
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/monitor/read_req_latency_min
+Date:		January 2021
+Contact:	Can Guo <cang@codeaurora.org>
+Description:	This file shows the minimum latency (in micro seconds) of
+		read requests after monitor gets started.
+
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/monitor/read_req_latency_avg
+Date:		January 2021
+Contact:	Can Guo <cang@codeaurora.org>
+Description:	This file shows the average latency (in micro seconds) of
+		read requests after monitor gets started.
+
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/monitor/read_req_latency_sum
+Date:		January 2021
+Contact:	Can Guo <cang@codeaurora.org>
+Description:	This file shows the total latency (in micro seconds) of
+		read requests sent after monitor gets started.
+
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/monitor/write_total_sectors
+Date:		January 2021
+Contact:	Can Guo <cang@codeaurora.org>
+Description:	This file shows how many sectors (in 512 Bytes) have been sent
+		from host to device after monitor gets started.
+
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/monitor/write_total_busy
+Date:		January 2021
+Contact:	Can Guo <cang@codeaurora.org>
+Description:	This file shows how long (in micro seconds) has been spent
+		sending data from host to device after monitor gets started.
+
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/monitor/write_nr_requests
+Date:		January 2021
+Contact:	Can Guo <cang@codeaurora.org>
+Description:	This file shows how many write requests have been sent after
+		monitor gets started.
+
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/monitor/write_req_latency_max
+Date:		January 2021
+Contact:	Can Guo <cang@codeaurora.org>
+Description:	This file shows the maximum latency (in micro seconds) of write
+		requests after monitor gets started.
+
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/monitor/write_req_latency_min
+Date:		January 2021
+Contact:	Can Guo <cang@codeaurora.org>
+Description:	This file shows the minimum latency (in micro seconds) of write
+		requests after monitor gets started.
+
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/monitor/write_req_latency_avg
+Date:		January 2021
+Contact:	Can Guo <cang@codeaurora.org>
+Description:	This file shows the average latency (in micro seconds) of write
+		requests after monitor gets started.
+
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/monitor/write_req_latency_sum
+Date:		January 2021
+Contact:	Can Guo <cang@codeaurora.org>
+Description:	This file shows the total latency (in micro seconds) of write
+		requests after monitor gets started.
+
+		The file is read only.
+
 What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/wb_presv_us_en
 Date:		June 2020
 Contact:	Asutosh Das <asutoshd@codeaurora.org>
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

