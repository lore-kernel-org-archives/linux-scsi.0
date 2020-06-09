Return-Path: <SRS0=2p7s=7W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AF50C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Jun 2020 00:58:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F372820760
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Jun 2020 00:58:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Ht4H7zAt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728787AbgFIA6S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Jun 2020 20:58:18 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:41490 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731912AbgFIA6I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2020 20:58:08 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200609005804epoutp03ae8409f8487585d5fa211ae823a1fedd~Wuju-I2OI0061700617epoutp03E
        for <linux-scsi@vger.kernel.org>; Tue,  9 Jun 2020 00:58:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200609005804epoutp03ae8409f8487585d5fa211ae823a1fedd~Wuju-I2OI0061700617epoutp03E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1591664284;
        bh=AdItsk5QedulWFP4OWDofYoftQEDP1ebFB4Udoioxoo=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=Ht4H7zAtFJ+jnv7GvsTu4dnrlNBSvzvF7c3ZR2+AhWP3qo0j66xjXl55mLXjVuAcL
         RKep6JYzWkTwrNF/cu+2nP2krXoJUTpEiZUHV8l+VI6D/7mt7NDaE9gKzV5YTJM7nj
         qZ8KA9mjIxNbklJMlbqGGEHW9eznh+yYO8U/EiQ8=
Received: from epcpadp2 (unknown [182.195.40.12]) by epcas1p3.samsung.com
        (KnoxPortal) with ESMTP id
        20200609005803epcas1p3f955fd4d0fe852a91d52a42e2d062518~WujuQPSoy1119911199epcas1p3d;
        Tue,  9 Jun 2020 00:58:03 +0000 (GMT)
Mime-Version: 1.0
Subject: RE: [RFC PATCH 4/5] scsi: ufs: L2P map management for HPB read
Reply-To: daejun7.park@samsung.com
From:   Daejun Park <daejun7.park@samsung.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <SN6PR04MB46409E16CCF95A0AA9FFE944FC870@SN6PR04MB4640.namprd04.prod.outlook.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1776409896.101591664283293.JavaMail.epsvc@epcpadp2>
Date:   Tue, 09 Jun 2020 09:52:56 +0900
X-CMS-MailID: 20200609005256epcms2p4b00fc4d4f6e4d11b1e082366ee195846
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200605011604epcms2p8bec8ef6682583d7248dc7d9dc1bfc882
References: <SN6PR04MB46409E16CCF95A0AA9FFE944FC870@SN6PR04MB4640.namprd04.prod.outlook.com>
        <231786897.01591322101492.JavaMail.epsvc@epcpadp1>
        <336371513.41591320902369.JavaMail.epsvc@epcpadp1>
        <963815509.21591320301642.JavaMail.epsvc@epcpadp1>
        <231786897.01591320001492.JavaMail.epsvc@epcpadp1>
        <963815509.21591323002276.JavaMail.epsvc@epcpadp1>
        <CGME20200605011604epcms2p8bec8ef6682583d7248dc7d9dc1bfc882@epcms2p4>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > The data structure for map data request and L2P map uses mempool API,
> > minimizing allocation overhead while avoiding static allocation.
> Maybe one or two more sentences to explain the L2P framework:
> Each hpb lun maintains 2 "to-do" lists: 
>  - hpb->lh_inact_rgn - regions to be inactivated, and 
>  - hpb->lh_act_srgn - subregions to be activated
> Those lists are being checked on every resume and completion interrupt.
OK, I will add more description of L2P framework.

> > 
> > Signed-off-by: Daejun Park <daejun7.park@samsung.com>
> > ---
> > +       for (i = 0; i < hpb->pages_per_srgn; i++) {
> > +               mctx->m_page[i] = mempool_alloc(ufshpb_drv.ufshpb_page_pool,
> > +                                               GFP_KERNEL);
> > +               memset(page_address(mctx->m_page[i]), 0, PAGE_SIZE);
> Better move this memset after if (!mctx->m_page[i]).
> And maybe use clear_page instead?
OK, I will change the code.

> > +               if (!mctx->m_page[i]) {
> > +                       for (j = 0; j < i; j++)
> > +                               mempool_free(mctx->m_page[j],
> > +                                            ufshpb_drv.ufshpb_page_pool);
> > +                       goto release_ppn_dirty;
> > +               }
> > +static inline int ufshpb_add_region(struct ufshpb_lu *hpb,
> > +                                   struct ufshpb_region *rgn)
> > +{
> Maybe better describe what this function does - ufshpb_get_rgn_map_ctx ?
Yes, I think "ufshpb_get_rgn_map_ctx" is better name.

> > +       if (!list_empty(&rgn->list_lru_rgn)) {
> > +               if (ufshpb_check_issue_state_srgns(hpb, rgn)) {
> So if one of its subregions has inflight map request - you add it to the "starved" list?
> Why call it starved?
"starved list" was wrong name. I will change it to "postponed_evict_list".

> > +        * Since the region state change occurs only in the hpb task-work,
> > +        * the state of the region cannot HPB_RGN_INACTIVE at this point.
> > +        * The region state must be changed in the hpb task-work
> I think that you called this worker map_work?
Yes, "the hpb task-work" will be changed to the map_work.

> > +               spin_unlock_irqrestore(&hpb->hpb_state_lock, flags);
> > +               ret = ufshpb_add_region(hpb, rgn);
> If this is not an active region,
> Although the device indicated to activate a specific subregion, 
> You are activating all the subregions of that region.
> You should elaborate on that in your commit log,
> and explain why this is the correct activation course.
Yes, I'm going to change the code to activate only the subregions that are "activate state".

> get_unaligned instead of be16_to_cpu ?
Yes, I will change.

> > +
> > +       if (!data_seg_len) {
> data_seg_len should be DEV_DATA_SEG_LEN, and you should also check HPB_UPDATE_ALERT,
> which you might want to do here and not in ufshpb_may_field_valid
Yes, I will change.

> > +       switch (rsp_field->hpb_type) {
> > +       case HPB_RSP_REQ_REGION_UPDATE:
> > +               WARN_ON(data_seg_len != DEV_DATA_SEG_LEN);
> > +               ufshpb_rsp_req_region_update(hpb, rsp_field);
> > +               break;
> What about hpb dev reset - oper 0x2?
Yes, I will change.

> > +static void ufshpb_add_active_list(struct ufshpb_lu *hpb,
> > +                                  struct ufshpb_region *rgn,
> > +                                  struct ufshpb_subregion *srgn)
> > +{
> > +       if (!list_empty(&rgn->list_inact_rgn))
> > +               return;
> > +
> > +       if (!list_empty(&srgn->list_act_srgn)) {
> > +               list_move(&srgn->list_act_srgn, &hpb->lh_act_srgn);
> Why is this needed?
> Why updating this subregion position?
The "ufshpb_add_active_list()" is called from "ufshpb_run_active_subregion_list()" to retry activating subregion that failed to activate.
Therefore, it requeues the subregion to activate region list head.

> > @@ -195,8 +1047,15 @@ static int ufshpb_alloc_region_tbl(struct ufs_hba
> > *hba, struct ufshpb_lu *hpb)
> >  release_srgn_table:
> >         for (i = 0; i < rgn_idx; i++) {
> >                 rgn = rgn_table + i;
> > -               if (rgn->srgn_tbl)
> > +               if (rgn->srgn_tbl) {
> > +                       for (srgn_idx = 0; srgn_idx < rgn->srgn_cnt;
> > +                            srgn_idx++) {
> > +                               srgn = rgn->srgn_tbl + srgn_idx;
> > +                               if (srgn->mctx)
> How is it even possible that on init there is an active subregion?
> ufshpb_init_pinned_active_region does its own cleanup.
I will fix the duplicated cleanup codes.

> > +       hpb->m_page_cache = kmem_cache_create("ufshpb_m_page_cache",
> > +                         sizeof(struct page *) * hpb->pages_per_srgn,
> > +                         0, 0, NULL);
> What is the advantage in using an array of page pointers,
> Instead of a single pointer to pages_per_srgn?
To minimize memory fragmentation problem, I used pointer + single page rather than single array of pages. 

> > @@ -398,6 +1326,9 @@ static void ufshpb_resume(struct ufs_hba *hba)
> > 
> >                 dev_info(&hpb->hpb_lu_dev, "ufshpb resume");
> >                 ufshpb_set_state(hpb, HPB_PRESENT);
> > +               if (!ufshpb_is_empty_rsp_lists(hpb))
> > +                       queue_work(ufshpb_drv.ufshpb_wq, &hpb->map_work);
> Ahha - so you are using the ufs driver pm flows to poll your work queue.
> Why device recommendations isn't enough?
I don't understand this comment. The code resumes map_work that was stopped by PM during the map request.
Please explain your concerns.

Thanks,
Avri
