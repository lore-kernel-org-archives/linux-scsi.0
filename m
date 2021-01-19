Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71581C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 23:07:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DDF022D08
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 23:07:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbhASXHj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jan 2021 18:07:39 -0500
Received: from mga17.intel.com ([192.55.52.151]:24142 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395361AbhASORN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Jan 2021 09:17:13 -0500
IronPort-SDR: hNWqhV0mmu7tbd49MkXtb++U01q55sCsqiXgBBVbRryKKzf3V5zzqLU/EAVpzLAhgQ1n5PH990
 BadOLZkrqYRw==
X-IronPort-AV: E=McAfee;i="6000,8403,9868"; a="158704813"
X-IronPort-AV: E=Sophos;i="5.79,359,1602572400"; 
   d="scan'208";a="158704813"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2021 06:15:43 -0800
IronPort-SDR: M2KeUX9KMFL3STSPaDSMletKeaY7XWUWHpQJvyLApA4DJqMUMW/zPV+X9hMqAW72GLAKNhAU8/
 wjjYgstEbIIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,359,1602572400"; 
   d="scan'208";a="347189929"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.149])
  by fmsmga007.fm.intel.com with ESMTP; 19 Jan 2021 06:15:40 -0800
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <huobean@gmail.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH 1/4] scsi: ufs: Add exception event tracepoint
Date:   Tue, 19 Jan 2021 16:15:39 +0200
Message-Id: <20210119141542.3808-2-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210119141542.3808-1-adrian.hunter@intel.com>
References: <20210119141542.3808-1-adrian.hunter@intel.com>
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
       kworker/2:2-173     [002] ....   731.486419: ufshcd_exception_event: 0000:00:12.5: exception event status 0x0
       kworker/2:2-173     [002] ....   732.608918: ufshcd_exception_event: 0000:00:12.5: exception event status 0x4
       kworker/2:2-173     [002] ....   732.609312: ufshcd_exception_event: 0000:00:12.5: exception event status 0x4

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/scsi/ufs/ufshcd.c  |  2 ++
 include/trace/events/ufs.h | 21 +++++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 46a499b7e8a8..7d46b2c278dd 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5624,6 +5624,8 @@ static void ufshcd_exception_event_handler(struct work_struct *work)
 		goto out;
 	}
 
+	trace_ufshcd_exception_event(dev_name(hba->dev), status);
+
 	status &= hba->ee_ctrl_mask;
 
 	if (status & MASK_EE_URGENT_BKOPS)
diff --git a/include/trace/events/ufs.h b/include/trace/events/ufs.h
index e151477d645c..5a2586217eb6 100644
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
+	TP_printk("%s: exception event status 0x%x",
+		__get_str(dev_name), __entry->status
+	)
+);
+
 #endif /* if !defined(_TRACE_UFS_H) || defined(TRACE_HEADER_MULTI_READ) */
 
 /* This part must be outside protection */
-- 
2.17.1

