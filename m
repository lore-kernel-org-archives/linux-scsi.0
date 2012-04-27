From: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Subject: RE: [PATCH] [SCSI] mpt2sas : Fix unsafe using smp_processor_id() in
 preemptible
Date: Fri, 27 Apr 2012 16:09:16 +0530
Message-ID: <A6888A6805518E4EA4AF7072A28264A6067E92E962@inbmail02.lsi.com>
References: <201204170553.q3H5rgCl016528@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog135.obsmtp.com ([74.125.149.84]:35657 "EHLO
	na3sys009aog135.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759818Ab2D0Kjh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Apr 2012 06:39:37 -0400
In-Reply-To: <201204170553.q3H5rgCl016528@milmhbs0.lsil.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>, "Moore, Eric" <Eric.Moore@lsi.com>
Cc: "jejb@kernel.org" <jejb@kernel.org>

James, this patch is not picked up for 3.5. Request you to push this patch for next release.

Regards,
Nagalakshmi


-----Original Message-----
From: nagalakshmi.nandigama@lsi.com [mailto:nagalakshmi.nandigama@lsi.com] 
Sent: Tuesday, April 17, 2012 11:25 AM
To: stable@vger.kernel.org; linux-scsi@vger.kernel.org; Nandigama, Nagalakshmi; Prakash, Sathya; Moore, Eric
Cc: jejb@kernel.org
Subject: [PATCH] [SCSI] mpt2sas : Fix unsafe using smp_processor_id() in preemptible

When CONFIG_DEBUG_PREEMPT is enabled, bug is observed in the smp_processor_id().
This is because smp_processor_id() is not called in preempt safe condition.

To fix this issue, use raw_smp_processor_id instead of smp_processor_id.

Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
CC: stable@vger.kernel.org
---

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 272fab7..b010be0 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1792,7 +1792,7 @@ static inline void _base_writeq(__u64 b, volatile void __iomem *addr,
 static inline u8
 _base_get_msix_index(struct MPT2SAS_ADAPTER *ioc)
 {
-	return ioc->cpu_msix_table[smp_processor_id()];
+	return ioc->cpu_msix_table[raw_smp_processor_id()];
 }
 
 /**
