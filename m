Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1562C433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 10:33:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 753672074D
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 10:33:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="SH86u7Z+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728458AbgEOKdU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 06:33:20 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:2002 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728156AbgEOKdT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2020 06:33:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1589538799; x=1621074799;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6JyjevTXi30Ra8MJtEs+SOstBuSe182myQ1YtRcMwrs=;
  b=SH86u7Z+RmssjW/UKcpFqBHoMz6WQszV86yxb1QH1s6A+F2Y0UJrFkbg
   bcDPbb9YmA4zG6G41b++ffiKJ5xP2UESMy+RKI3CnMO1Idx575jAqX6VZ
   W7X0A5KNOAQMbH1NunvFMeCqppuwzfyhkM4em1Ut8VcYQaMfKaqPNsA6K
   VkOWKH1mlMGxnH20IYnPleNQzOVXHi/Zd9tElwnSbfi3NwSpnfxO6m5Mf
   zMClmwY+9QzDOkq757cDbA+DUwijlL/ofb8dN43WkHqNRtODFyWtOjRFV
   6WQD4XerEdTz4gnmHb6EphS+2meJpSD3A1/Ne8luf4ASXld3aZrWIuq4T
   Q==;
IronPort-SDR: sHtuxIsD4NU1WhzJAKJ4zvi4s7W39U1cycCxDoxEDN+wN18UAVaFwA+Mhaxckl6Vkl1jp/CDiP
 /4ynM1IADWP5DRXoC1WCpaWeYInUYaOB3NpeXl20eAhpn/CB4h+DPjwO1qfMSk9LPCErvnBUTQ
 m3i8Y5PDphomNvLM7D0hEZ6kYx2NPJD0dzpaoYvavQw5aIbpWzn3lBf2g83vPLnWme6Vzbgd6P
 hzkThsA2j4t0DTh3zTXuXcxgFVdklB6a15kDxoZYixFhK/aze1q/9s7+NhiiIlvbmyX9vHv0qK
 ILw=
X-IronPort-AV: E=Sophos;i="5.73,394,1583164800"; 
   d="scan'208";a="142113860"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 15 May 2020 18:33:19 +0800
IronPort-SDR: tvi1LgUTx5wf84CQeqhaYQvgt2AvhCz736AVKc8v5TfjPX69eT1kwVpC0CmU4p0nBWxHh9Z2y5
 QKsP9B/0nglR2DBxNPZx8VOFmVOnMhJuE=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2020 03:23:29 -0700
IronPort-SDR: O6V3SslWYV1kHoNF7CO9NcAHntwUzYct3jabOkhOsZGctm6NFncgkdJw09IsKH36WPdBZPeOy9
 ylqAAvE5A3uQ==
WDCIronportException: Internal
Received: from ile422988.sdcorp.global.sandisk.com ([10.0.231.246])
  by uls-op-cesaip01.wdc.com with ESMTP; 15 May 2020 03:33:14 -0700
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>, alim.akhtar@samsung.com,
        asutoshd@codeaurora.org, Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <avi.shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>, cang@codeaurora.org,
        stanley.chu@mediatek.com,
        MOHAMMED RAFIQ KAMAL BASHA <md.rafiq@samsung.com>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [RFC PATCH 13/13] scsi: scsi_dh: ufshpb: Add "Cold" subregions timer
Date:   Fri, 15 May 2020 13:30:14 +0300
Message-Id: <1589538614-24048-14-git-send-email-avri.altman@wdc.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1589538614-24048-1-git-send-email-avri.altman@wdc.com>
References: <1589538614-24048-1-git-send-email-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In order not to hang on to “cold” subregions, we shall inactivate a
subregion that has no READ access for a predefined amount of time. For
that purpose we shall attach to any active subregion a timer, triggering
it on every READ to expire after 500msec. On timer expiry we shall make
note of that event and call the state-machine worker to handle it.

Timers will not be attached to a pinned region's subregions.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/device_handler/scsi_dh_ufshpb.c | 47 +++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_ufshpb.c b/drivers/scsi/device_handler/scsi_dh_ufshpb.c
index 04e3d56..e89dd30 100644
--- a/drivers/scsi/device_handler/scsi_dh_ufshpb.c
+++ b/drivers/scsi/device_handler/scsi_dh_ufshpb.c
@@ -123,6 +123,8 @@ struct ufshpb_subregion {
 	unsigned long event;
 	struct mutex state_lock;
 	struct work_struct hpb_work;
+
+	struct timer_list read_timer;
 };
 
 /**
@@ -210,6 +212,31 @@ static unsigned int entries_per_region_mask;
 static unsigned int entries_per_subregion_shift;
 static unsigned int entries_per_subregion_mask;
 
+static void ufshpb_read_timeout(struct timer_list *t)
+{
+	struct ufshpb_subregion *s = from_timer(s, t, read_timer);
+	enum ufshpb_state s_state;
+
+	rcu_read_lock();
+	s_state = s->state;
+	rcu_read_unlock();
+
+	if (WARN_ON_ONCE(s_state != HPB_STATE_ACTIVE))
+		return;
+
+	if (atomic64_read(&s->writes) < SET_AS_DIRTY &&
+	    !atomic_dec_and_test(&s->read_timeout_expiries)) {
+		/* rewind the timer for clean subregions */
+		mod_timer(&s->read_timer,
+			  jiffies + msecs_to_jiffies(READ_TIMEOUT_MSEC));
+		return;
+	}
+
+	set_bit(SUBREGION_EVENT_TIMER, &s->event);
+
+	queue_work(s->hpb->wq, &s->hpb_work);
+}
+
 static inline unsigned int ufshpb_lba_to_region(u64 lba)
 {
 	return lba >> entries_per_region_shift;
@@ -376,6 +403,7 @@ static bool ufshpb_test_block_dirty(struct ufshpb_dh_data *h,
 	struct ufshpb_region *r = hpb->region_tbl + region;
 	struct ufshpb_subregion *s = r->subregion_tbl + subregion;
 	enum ufshpb_state s_state;
+	bool is_dirty;
 
 	__update_rw_counters(hpb, start_lba, end_lba, REQ_OP_READ);
 
@@ -386,7 +414,14 @@ static bool ufshpb_test_block_dirty(struct ufshpb_dh_data *h,
 	if (s_state != HPB_STATE_ACTIVE)
 		return true;
 
-	return (atomic64_read(&s->writes) >= SET_AS_DIRTY);
+	is_dirty = (atomic64_read(&s->writes) >= SET_AS_DIRTY);
+	if (!is_dirty && !test_bit(region, hpb->pinned_map)) {
+		mod_timer(&s->read_timer,
+			  jiffies + msecs_to_jiffies(READ_TIMEOUT_MSEC));
+		atomic_set(&s->read_timeout_expiries, READ_TIMEOUT_EXPIRIES);
+	}
+
+	return is_dirty;
 }
 
 /* Call this on write from prep_fn */
@@ -456,6 +491,8 @@ static void __subregion_inactivate(struct ufshpb_dh_lun *hpb,
 	list_add(&s->mctx->list, &hpb->lh_map_ctx);
 	spin_unlock(&hpb->map_list_lock);
 	s->mctx = NULL;
+
+	del_timer(&s->read_timer);
 }
 
 static void ufshpb_subregion_inactivate(struct ufshpb_dh_lun *hpb,
@@ -602,6 +639,13 @@ static int __subregion_activate(struct ufshpb_dh_lun *hpb,
 	atomic64_sub(atomic64_read(&s->writes), &r->writes);
 	atomic64_set(&s->writes, 0);
 
+	if (!test_bit(r->region, hpb->pinned_map)) {
+		timer_setup(&s->read_timer, ufshpb_read_timeout, 0);
+		mod_timer(&s->read_timer,
+			  jiffies + msecs_to_jiffies(READ_TIMEOUT_MSEC));
+		atomic_set(&s->read_timeout_expiries, READ_TIMEOUT_EXPIRIES);
+	}
+
 out:
 	if (ret)
 		__subregion_inactivate(hpb, r, s);
@@ -1377,6 +1421,7 @@ static void ufshpb_region_tbl_remove(struct ufshpb_dh_lun *hpb)
 							r->subregion_tbl + j;
 
 				cancel_work_sync(&s->hpb_work);
+				del_timer(&s->read_timer);
 			}
 
 			kfree(r->subregion_tbl);
-- 
2.7.4

