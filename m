From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: [RFC 2/2] mpt3sas/megaraid_sas : reply queue load balancing
Date: Mon, 15 Jan 2018 17:43:09 +0530
Message-ID: <b55ae2b79eca26ca0ec58a50698ae18b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:46464 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932363AbeAOMNL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jan 2018 07:13:11 -0500
Received: by mail-io0-f194.google.com with SMTP id f34so7576619ioi.13
        for <linux-scsi@vger.kernel.org>; Mon, 15 Jan 2018 04:13:11 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Peter Rivera <peter.rivera@broadcom.com>

Patch for Fix-2 explained in PATCH 0.

Signed-off-by: Kashyap Desai < kashyap.desai@broadcom.com>
---
 mpt3sas/mpt3sas_base.c | 5 ++++-
 mpt3sas/mpt3sas_base.h | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/mpt3sas/mpt3sas_base.c b/mpt3sas/mpt3sas_base.c index
0b351d4..20bf2ad 100644
--- a/mpt3sas/mpt3sas_base.c
+++ b/mpt3sas/mpt3sas_base.c
@@ -2811,7 +2811,8 @@ mpt3sas_base_get_reply_virt_addr(struct
MPT3SAS_ADAPTER *ioc, u32 phys_addr)  static inline u8
_base_get_msix_index(struct MPT3SAS_ADAPTER *ioc)  {
-	return ioc->cpu_msix_table[raw_smp_processor_id()];
+	return ioc->reply_queue_count ? (atomic64_add_return(1,
+	    &ioc->total_io_cnt) % ioc->reply_queue_count) : 0;
 }

 /**
@@ -5775,6 +5776,8 @@ _base_make_ioc_operational(struct MPT3SAS_ADAPTER
*ioc)
 	dinitprintk(ioc, pr_info(MPT3SAS_FMT "%s\n", ioc->name,
 	    __func__));

+	atomic64_set(&ioc->total_io_cnt, 0);
+
 	/* clean the delayed target reset list */
 	list_for_each_entry_safe(delayed_tr, delayed_tr_next,
 	    &ioc->delayed_tr_list, list) {
diff --git a/mpt3sas/mpt3sas_base.h b/mpt3sas/mpt3sas_base.h index
456d928..1c39107 100644
--- a/mpt3sas/mpt3sas_base.h
+++ b/mpt3sas/mpt3sas_base.h
@@ -1357,6 +1357,7 @@ struct MPT3SAS_ADAPTER {
 	u8		is_gen35_ioc;
 	u8		atomic_desc_capable;
 	u32		irqpoll_weight;
+	atomic64_t	total_io_cnt;
 	PUT_SMID_IO_FP_HIP put_smid_scsi_io;
 	PUT_SMID_IO_FP_HIP put_smid_fast_path;
 	PUT_SMID_IO_FP_HIP put_smid_hi_priority;
--
2.5.5
