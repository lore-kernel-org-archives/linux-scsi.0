Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6547FC433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 06:26:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3166864E45
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 06:26:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbhBIGZs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 01:25:48 -0500
Received: from mga07.intel.com ([134.134.136.100]:37171 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230183AbhBIGZV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 9 Feb 2021 01:25:21 -0500
IronPort-SDR: xncUHIOJlIidHgPfvnHcqgku9w8UPZlTBq2ka9SRS0OndOo1sktckJIwj5v3Y/9JHW7IDFrZVh
 /xMx6w1IGiWQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9889"; a="245904363"
X-IronPort-AV: E=Sophos;i="5.81,164,1610438400"; 
   d="scan'208";a="245904363"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 22:24:41 -0800
IronPort-SDR: akQes4JlNVqeFGDLbgIYq/YT+drWBmZUKTyEPZUROLF3xxwY076XB9GG8ULVstCmG0A1fWa17B
 44LLQz0Da1DQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,164,1610438400"; 
   d="scan'208";a="398681946"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.149])
  by orsmga007.jf.intel.com with ESMTP; 08 Feb 2021 22:24:38 -0800
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <huobean@gmail.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH V2 1/4] scsi: ufs: Add exception event tracepoint
Date:   Tue,  9 Feb 2021 08:24:34 +0200
Message-Id: <20210209062437.6954-2-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210209062437.6954-1-adrian.hunter@intel.com>
References: <20210209062437.6954-1-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently, exception event status can be read from wExceptionEventStatus
attribute (sysfs file attributes/exception_event_status under the UFS host
controller device directory). Polling that attribute to track UFS exception
events is impractical, so add a tracepoint to track exception events for
testing and debugging purposes.

Note, by the time the exception event status is read, the exception event
may have cleared, so the value can be zero - see example below.

Note also, only enabled exception events can be reported. A subsequent
patch adds the ability for users to enable selected exception events via
debugfs.

Example with driver instrumented to enable all exception events:

  # echo 1 > /sys/kernel/debug/tracing/events/ufs/ufshcd_exception_event/enable

  ... do some I/O ...

  # cat /sys/kernel/debug/tracing/trace
  # tracer: nop
  #
  # entries-in-buffer/entries-written: 3/3   #P:5
  #
  #                                _-----=> irqs-off
  #                               / _----=> need-resched
  #                              | / _---=> hardirq/softirq
  #                              || / _--=> preempt-depth
  #                              ||| /     delay
  #           TASK-PID     CPU#  ||||   TIMESTAMP  FUNCTION
  #              | |         |   ||||      |         |
       kworker/2:2-173     [002] ....   731.486419: ufshcd_exception_event: 0000:00:12.5: status 0x0
       kworker/2:2-173     [002] ....   732.608918: ufshcd_exception_event: 0000:00:12.5: status 0x4
       kworker/2:2-173     [002] ....   732.609312: ufshcd_exception_event: 0000:00:12.5: status 0x4

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/scsi/ufs/ufshcd.c  |  2 ++
 include/trace/events/ufs.h | 21 +++++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 721f55db181f..d6fdce655388 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5616,6 +5616,8 @@ static void ufshcd_exception_event_handler(struct work_struct *work)
 		goto out;
 	}
 
+	trace_ufshcd_exception_event(dev_name(hba->dev), status);
+
 	status &= hba->ee_ctrl_mask;
 
 	if (status & MASK_EE_URGENT_BKOPS)
diff --git a/include/trace/events/ufs.h b/include/trace/events/ufs.h
index e151477d645c..1cb6f1afba0e 100644
--- a/include/trace/events/ufs.h
+++ b/include/trace/events/ufs.h
@@ -349,6 +349,27 @@ TRACE_EVENT(ufshcd_upiu,
 	)
 );
 
+TRACE_EVENT(ufshcd_exception_event,
+
+	TP_PROTO(const char *dev_name, u16 status),
+
+	TP_ARGS(dev_name, status),
+
+	TP_STRUCT__entry(
+		__string(dev_name, dev_name)
+		__field(u16, status)
+	),
+
+	TP_fast_assign(
+		__assign_str(dev_name, dev_name);
+		__entry->status = status;
+	),
+
+	TP_printk("%s: status 0x%x",
+		__get_str(dev_name), __entry->status
+	)
+);
+
 #endif /* if !defined(_TRACE_UFS_H) || defined(TRACE_HEADER_MULTI_READ) */
 
 /* This part must be outside protection */
-- 
2.17.1

