Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF33BC48BE5
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Jun 2021 07:40:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99EB660FEA
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Jun 2021 07:40:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbhFUHmm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Jun 2021 03:42:42 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:38938 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbhFUHmS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Jun 2021 03:42:18 -0400
Received: from epcas3p1.samsung.com (unknown [182.195.41.19])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210621074002epoutp0341ea3683adf00330ce55421e79f30687~KiPVYd3i70406904069epoutp03B
        for <linux-scsi@vger.kernel.org>; Mon, 21 Jun 2021 07:40:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210621074002epoutp0341ea3683adf00330ce55421e79f30687~KiPVYd3i70406904069epoutp03B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1624261202;
        bh=8gSPm9Hg3e41/IwdieaStu9mm6YvGDEAx4oK1XBqGzc=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=NnhyLJmUZtS2iLJx2E0KMolSGDqayRqbEsQlToOepcd39ao3g1aZXbMu5FRNRRsM5
         /fllZf2yiFCVLe/VH1PuNIppgARTz1i5PGmZVGVDrPK+lWNKUFFh/nj1HwnVfIDL91
         cn75g4pEAPsE5kdb4HBh8AtIDXE1+bhwK8sOdFpI=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas3p4.samsung.com (KnoxPortal) with ESMTP id
        20210621074002epcas3p4706ad612bdd7bd7e1546496f681ba702~KiPUxzgyH2139521395epcas3p4R;
        Mon, 21 Jun 2021 07:40:02 +0000 (GMT)
Received: from epcpadp3 (unknown [182.195.40.17]) by epsnrtp2.localdomain
        (Postfix) with ESMTP id 4G7hJL1knVz4x9Q4; Mon, 21 Jun 2021 07:40:02 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: RE: [PATCH v11 08/12] scsi: ufshpb: Add "Cold" regions timer
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <DM6PR04MB6575C466A26C5FEB5EEE5B6FFC0A9@DM6PR04MB6575.namprd04.prod.outlook.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1796371666.41624261202246.JavaMail.epsvc@epcpadp3>
Date:   Mon, 21 Jun 2021 16:33:10 +0900
X-CMS-MailID: 20210621073310epcms2p8e44aca67b76b96c8418bae25442c6d67
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210616112925epcas2p1267d33aee5fa552333a0503207e262f2
References: <DM6PR04MB6575C466A26C5FEB5EEE5B6FFC0A9@DM6PR04MB6575.namprd04.prod.outlook.com>
        <20210616112800.52963-9-avri.altman@wdc.com>
        <20210616112800.52963-1-avri.altman@wdc.com>
        <1891546521.01624253881548.JavaMail.epsvc@epcpadp4>
        <CGME20210616112925epcas2p1267d33aee5fa552333a0503207e262f2@epcms2p8>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Avri,

> > Hi Avri,
> > 
> > >diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
> > >index 39b86e8b2eee..cf719831adb3 100644
> > >--- a/drivers/scsi/ufs/ufshpb.c
> > >+++ b/drivers/scsi/ufs/ufshpb.c
> > 
> > ...
> > 
> > >+static void ufshpb_read_to_handler(struct work_struct *work)
> > >+{
> > >+        struct ufshpb_lu *hpb = container_of(work, struct ufshpb_lu,
> > >+                                             ufshpb_read_to_work.work);
> > >+        struct victim_select_info *lru_info = &hpb->lru_info;
> > >+        struct ufshpb_region *rgn, *next_rgn;
> > >+        unsigned long flags;
> > >+        LIST_HEAD(expired_list);
> > >+
> > >+        if (test_and_set_bit(TIMEOUT_WORK_RUNNING, &hpb-
> > >work_data_bits))
> > >+                return;
> > >+
> > >+        spin_lock_irqsave(&hpb->rgn_state_lock, flags);
> > >+
> > >+        list_for_each_entry_safe(rgn, next_rgn, &lru_info->lh_lru_rgn,
> > >+                                 list_lru_rgn) {
> > >+                bool timedout = ktime_after(ktime_get(), rgn->read_timeout);
> > >+
> > >+                if (timedout) {
> > >+                        rgn->read_timeout_expiries--;
> > >+                        if (is_rgn_dirty(rgn) ||
> > >+                            rgn->read_timeout_expiries == 0)
> > >+                                list_add(&rgn->list_expired_rgn, &expired_list);
> > 
> > Why we need additional expired_list for updating inactive information?
> Since the lru list is accessed under rgn_state_lock, 
> and inactivation is done under rsp_list_lock,
> It's just a convenient way to list all the expired  regions.
OK,

>  
> > And I think "rgn->list_lru_rgn" should be deleted when it is expired.
> Oh - I don't think so.
> This should be done in one place only, which is cleanup_lru_info,
> Which is called, in host mode, after a successful unmap request.

Then I think list_for_each_entry_safe can be changed to list_for_each_entry,
because there is no deletion of the list. But it doesn't look like it needs
a fix right now.

Thanks,
Daejun
