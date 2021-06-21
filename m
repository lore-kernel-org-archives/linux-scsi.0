Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8884CC48BE5
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Jun 2021 05:38:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F9F1610A3
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Jun 2021 05:38:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbhFUFkS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Jun 2021 01:40:18 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:36995 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbhFUFkR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Jun 2021 01:40:17 -0400
Received: from epcas3p4.samsung.com (unknown [182.195.41.22])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210621053802epoutp04e540b288111dc838e3d07ac10d5a83d6~Kgkzd_GTC2297522975epoutp046
        for <linux-scsi@vger.kernel.org>; Mon, 21 Jun 2021 05:38:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210621053802epoutp04e540b288111dc838e3d07ac10d5a83d6~Kgkzd_GTC2297522975epoutp046
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1624253882;
        bh=/JNeiseTrnaIKRNZL2o3iW/AjK3zc5cFVTM3H9aTY6Y=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=kCJhMFpR1mJrFbM44r7zgOX2MjOAxLkAAw2pcTnoQ0fVYC3Rg97/6Ny37/sPKULuh
         x25doBRHK4CN4Nhwk5ips6zpoMWtI2cURuY1NI5WssL4WpREGYLUNRz0uxFyaB8D7p
         Gfe9Ri5BVqZEooI0l4wU8t2eD1SOMU9fNBUlkZWQ=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas3p2.samsung.com (KnoxPortal) with ESMTP id
        20210621053801epcas3p2c88967920c133151263d26de4cab2136~Kgky2e-452419524195epcas3p26;
        Mon, 21 Jun 2021 05:38:01 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp2.localdomain
        (Postfix) with ESMTP id 4G7dbY43sDz4x9Q0; Mon, 21 Jun 2021 05:38:01 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH v11 08/12] scsi: ufshpb: Add "Cold" regions timer
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <avi.shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20210616112800.52963-9-avri.altman@wdc.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1891546521.01624253881548.JavaMail.epsvc@epcpadp4>
Date:   Mon, 21 Jun 2021 14:17:33 +0900
X-CMS-MailID: 20210621051733epcms2p1dd6b54d0142845e865285385dda43a43
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210616112925epcas2p1267d33aee5fa552333a0503207e262f2
References: <20210616112800.52963-9-avri.altman@wdc.com>
        <20210616112800.52963-1-avri.altman@wdc.com>
        <CGME20210616112925epcas2p1267d33aee5fa552333a0503207e262f2@epcms2p1>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Avri,

>diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
>index 39b86e8b2eee..cf719831adb3 100644
>--- a/drivers/scsi/ufs/ufshpb.c
>+++ b/drivers/scsi/ufs/ufshpb.c

...

>+static void ufshpb_read_to_handler(struct work_struct *work)
>+{
>+        struct ufshpb_lu *hpb = container_of(work, struct ufshpb_lu,
>+                                             ufshpb_read_to_work.work);
>+        struct victim_select_info *lru_info = &hpb->lru_info;
>+        struct ufshpb_region *rgn, *next_rgn;
>+        unsigned long flags;
>+        LIST_HEAD(expired_list);
>+
>+        if (test_and_set_bit(TIMEOUT_WORK_RUNNING, &hpb->work_data_bits))
>+                return;
>+
>+        spin_lock_irqsave(&hpb->rgn_state_lock, flags);
>+
>+        list_for_each_entry_safe(rgn, next_rgn, &lru_info->lh_lru_rgn,
>+                                 list_lru_rgn) {
>+                bool timedout = ktime_after(ktime_get(), rgn->read_timeout);
>+
>+                if (timedout) {
>+                        rgn->read_timeout_expiries--;
>+                        if (is_rgn_dirty(rgn) ||
>+                            rgn->read_timeout_expiries == 0)
>+                                list_add(&rgn->list_expired_rgn, &expired_list);

Why we need additional expired_list for updating inactive information?
And I think "rgn->list_lru_rgn" should be deleted when it is expired.

>+                        else
>+                                rgn->read_timeout = ktime_add_ms(ktime_get(),
>+                                                         READ_TO_MS);
>+                }
>+        }
>+
>+        spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
>+
>+        list_for_each_entry_safe(rgn, next_rgn, &expired_list,
>+                                 list_expired_rgn) {
>+                list_del_init(&rgn->list_expired_rgn);
>+                spin_lock_irqsave(&hpb->rsp_list_lock, flags);
>+                ufshpb_update_inactive_info(hpb, rgn->rgn_idx);
>+                spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
>+        }
>+
>+        ufshpb_kick_map_work(hpb);
>+
>+        clear_bit(TIMEOUT_WORK_RUNNING, &hpb->work_data_bits);
>+
>+        schedule_delayed_work(&hpb->ufshpb_read_to_work,
>+                              msecs_to_jiffies(POLLING_INTERVAL_MS));
>+}
>+

Thanks,
Daejun
