Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="ixppTE1r"
Received: from rcdn-iport-1.cisco.com (rcdn-iport-1.cisco.com [173.37.86.72])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4096C7;
	Mon, 11 Dec 2023 09:40:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=2336; q=dns/txt; s=iport;
  t=1702316416; x=1703526016;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ov+22JfMWX71JUrjb9pbSfvsIvqm6DfNrkyUATv3g3I=;
  b=ixppTE1r9T4+kzEHUPBMiRnirVJ0vsIBMQLxzr3wVuS0NRUX61kz7n33
   8bgSoZD+FLs8t0ksBVwhRZ5n2HNWN/d2PloY85iEDoDWbekO9eNr6H8xW
   kGOGBz3owqrY4Un9rPZlhi03G3I3grfEVR5C9H8kVarrCRME9YMtxgNb/
   I=;
X-CSE-ConnectionGUID: KdjS/1psTCaTV/hgYiUwog==
X-CSE-MsgGUID: j6MxhxOHQCOm8xUeSkm/vw==
X-IronPort-AV: E=Sophos;i="6.04,268,1695686400"; 
   d="scan'208";a="158328742"
Received: from rcdn-core-1.cisco.com ([173.37.93.152])
  by rcdn-iport-1.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2023 17:40:14 +0000
Received: from localhost.cisco.com ([10.193.101.253])
	(authenticated bits=0)
	by rcdn-core-1.cisco.com (8.15.2/8.15.2) with ESMTPSA id 3BBHaKr2009547
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 11 Dec 2023 17:40:14 GMT
From: Karan Tilak Kumar <kartilak@cisco.com>
To: sebaddel@cisco.com
Cc: arulponn@cisco.com, djhawar@cisco.com, gcboffa@cisco.com, mkai2@cisco.com,
        satishkh@cisco.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Karan Tilak Kumar <kartilak@cisco.com>, Hannes Reinecke <hare@suse.de>
Subject: [PATCH v6 08/13] scsi: fnic: Define stats to track multiqueue (MQ) IOs
Date: Mon, 11 Dec 2023 09:36:12 -0800
Message-Id: <20231211173617.932990-9-kartilak@cisco.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20231211173617.932990-1-kartilak@cisco.com>
References: <20231211173617.932990-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.193.101.253, [10.193.101.253]
X-Outbound-Node: rcdn-core-1.cisco.com

Define an array to track IOs for the different queues,
print the IO stats in fnic get stats data.

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
 drivers/scsi/fnic/fnic_stats.h |  2 ++
 drivers/scsi/fnic/fnic_trace.c | 11 +++++++++++
 2 files changed, 13 insertions(+)

diff --git a/drivers/scsi/fnic/fnic_stats.h b/drivers/scsi/fnic/fnic_stats.h
index 07d1556e3c32..9d7f98c452dd 100644
--- a/drivers/scsi/fnic/fnic_stats.h
+++ b/drivers/scsi/fnic/fnic_stats.h
@@ -2,6 +2,7 @@
 /* Copyright 2013 Cisco Systems, Inc.  All rights reserved. */
 #ifndef _FNIC_STATS_H_
 #define _FNIC_STATS_H_
+#define FNIC_MQ_MAX_QUEUES 64
 
 struct stats_timestamps {
 	struct timespec64 last_reset_time;
@@ -26,6 +27,7 @@ struct io_path_stats {
 	atomic64_t io_btw_10000_to_30000_msec;
 	atomic64_t io_greater_than_30000_msec;
 	atomic64_t current_max_io_time;
+	atomic64_t ios[FNIC_MQ_MAX_QUEUES];
 };
 
 struct abort_stats {
diff --git a/drivers/scsi/fnic/fnic_trace.c b/drivers/scsi/fnic/fnic_trace.c
index be0d7c57b242..aaa4ea02fb7c 100644
--- a/drivers/scsi/fnic/fnic_trace.c
+++ b/drivers/scsi/fnic/fnic_trace.c
@@ -204,6 +204,7 @@ int fnic_get_stats_data(struct stats_debug_info *debug,
 	int len = 0;
 	int buf_size = debug->buf_size;
 	struct timespec64 val1, val2;
+	int i = 0;
 
 	ktime_get_real_ts64(&val1);
 	len = scnprintf(debug->debug_buffer + len, buf_size - len,
@@ -266,6 +267,16 @@ int fnic_get_stats_data(struct stats_debug_info *debug,
 		  (u64)atomic64_read(&stats->io_stats.io_btw_10000_to_30000_msec),
 		  (u64)atomic64_read(&stats->io_stats.io_greater_than_30000_msec));
 
+	len += scnprintf(debug->debug_buffer + len, buf_size - len,
+			"------------------------------------------\n"
+			"\t\tIO Queues and cumulative IOs\n"
+			"------------------------------------------\n");
+
+	for (i = 0; i < FNIC_MQ_MAX_QUEUES; i++) {
+		len += scnprintf(debug->debug_buffer + len, buf_size - len,
+				"Q:%d -> %lld\n", i, (u64)atomic64_read(&stats->io_stats.ios[i]));
+	}
+
 	len += scnprintf(debug->debug_buffer + len, buf_size - len,
 		  "\nCurrent Max IO time : %lld\n",
 		  (u64)atomic64_read(&stats->io_stats.current_max_io_time));
-- 
2.31.1

