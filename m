Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2038C43460
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Apr 2021 06:12:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 799D561057
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Apr 2021 06:12:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233303AbhDAGMM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Apr 2021 02:12:12 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:26806 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232994AbhDAGLz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2021 02:11:55 -0400
IronPort-SDR: ca9twiqKulQAzBUC6YO7RY/dWsrnhcsupaDqHE+2HFWFEQjTtcnEm8KQIpZIvd3bUZy9hpIkdH
 ZIxrjPhm1SHu59FiGjAhquaRh3r61zRHZxjahUxQRbnEiPxYYTVmjc7KyWq+uNhHJrU40tKlYw
 TUtM7vh/gXfrOgUDyCSFsB5O1kgpdQ7IaY1phUnE0MrM5BBBqdF43eE6WSq3hcyeWD1KF0DsDc
 NO2lFGjqQxpxlu1lrP/Pjx/fhjft2xbBLQ0HJSK+vH3BL/NhBuZ62Nk5yMpBbIo4GpK6uliyjk
 ykE=
X-IronPort-AV: E=Sophos;i="5.81,296,1610438400"; 
   d="scan'208";a="47836544"
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by labrats.qualcomm.com with ESMTP; 31 Mar 2021 23:11:55 -0700
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg03-sd.qualcomm.com with ESMTP; 31 Mar 2021 23:11:54 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 3907C210A9; Wed, 31 Mar 2021 23:11:54 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, cang@codeaurora.org
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/2] scsi: ufs: Add support for hba performance monitor
Date:   Wed, 31 Mar 2021 23:11:42 -0700
Message-Id: <1617257503-669-3-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1617257503-669-1-git-send-email-cang@codeaurora.org>
References: <1617257503-669-1-git-send-email-cang@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add a new sysfs group which has nodes to monitor data/request transfer
performance. This sysfs group has nodes showing total sectors/requests
transferred, total busy time spent and max/min/avg/sum latencies.

Signed-off-by: Can Guo <cang@codeaurora.org>

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

