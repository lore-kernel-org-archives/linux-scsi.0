Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC340C433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Mar 2021 00:35:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7463465010
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Mar 2021 00:35:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbhCEAfc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Mar 2021 19:35:32 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:59979 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbhCEAfb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Mar 2021 19:35:31 -0500
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210305003530epoutp02dad3f545b8d0f0a3678907e7212050ea~pSx0rPDpJ2325223252epoutp02M
        for <linux-scsi@vger.kernel.org>; Fri,  5 Mar 2021 00:35:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210305003530epoutp02dad3f545b8d0f0a3678907e7212050ea~pSx0rPDpJ2325223252epoutp02M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1614904530;
        bh=I+X5YVKEXxoL9ACpwPz1C5rdDhbo9vl8umRKNjR/7ic=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=JgjnAqdHwqYpuyC2r2E+fflla9n8LYdVfZiAbxkcupNBl4DRGq4eahrY4LISMr0ls
         KgdtXl62vJuDDQ3kOyJ1sg3huckkRLvH5i7TDhwgEKfss49h+M7h/mnNVp83S3+9Ne
         enl8zjVqaoDEXUKONqXhsBfXUEEmEKG2j0WW0JBQ=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210305003529epcas2p4546428b33c43401c489ff5c9439e362e~pSxz42XkZ1351413514epcas2p4G;
        Fri,  5 Mar 2021 00:35:29 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.188]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4Ds80H0gJjz4x9Q5; Fri,  5 Mar
        2021 00:35:27 +0000 (GMT)
X-AuditID: b6c32a47-b97ff7000000148e-58-60417ccdd8bf
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        EB.25.05262.DCC71406; Fri,  5 Mar 2021 09:35:25 +0900 (KST)
Mime-Version: 1.0
Subject: RE: Re: [PATCH v26 4/4] scsi: ufs: Add HPB 2.0 support
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Bean Huo <huobean@gmail.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <0242e4ab10acff9a7d71c2f956ba4624bf95add2.camel@gmail.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210305003525epcms2p5f99e8decce000d81e811875b1a495523@epcms2p5>
Date:   Fri, 05 Mar 2021 09:35:25 +0900
X-CMS-MailID: 20210305003525epcms2p5f99e8decce000d81e811875b1a495523
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDJsWRmVeSWpSXmKPExsWy7bCmqe65GscEg2MxFg/mbWOz2Nt2gt3i
        5c+rbBaHb79jt5j24Sezxaf1y1gtXh7StFj1INyiefF6Nos5ZxuYLHr7t7JZPL7zmd1i0Y1t
        TBb9/9pZLC7vmsNm0X19B5vF8uP/mCxub+GyWLr1JqNF5/Q1LA4iHpeveHtc7utl8tg56y67
        x4RFBxg99s9dw+7RcnI/i8fHp7dYPPq2rGL0+LxJzqP9QDdTAFdUjk1GamJKapFCal5yfkpm
        XrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0G9KCmWJOaVAoYDE4mIlfTubovzS
        klSFjPziElul1IKUnAJDwwK94sTc4tK8dL3k/FwrQwMDI1OgyoScjIbz31kKTtlXvH/3jq2B
        8a16FyMnh4SAicTLvwuYQGwhgR2MEoc+K3YxcnDwCghK/N0hDBIWFrCXePl+FVSJksT6i7PY
        IeJ6ErcermEEsdkEdCSmn7gPFOfiEBH4xSyx6+FyJhCHWeA3k8Tik//ZIJbxSsxof8oCYUtL
        bF++FaybU8BdomXBKnaIuIbEj2W9zBC2qMTN1W/ZYez3x+YzQtgiEq33zkLVCEo8+LkbKi4p
        cWz3ByYIu15i651fjCBHSAj0MEoc3nmLFSKhL3GtYyPYEbwCvhL7Lm0AG8QioCpxb1ovE8j3
        EgIuEk3P9UDCzALyEtvfzmEGCTMLaEqs36UPUaEsceQWC8xXDRt/s6OzmQX4JDoO/4WL75j3
        BOoyNYl1P9czTWBUnoUI6VlIds1C2LWAkXkVo1hqQXFuemqxUYExctxuYgQncy33HYwz3n7Q
        O8TIxMF4iFGCg1lJhFf8pW2CEG9KYmVValF+fFFpTmrxIUZToCcnMkuJJucD80leSbyhqZGZ
        mYGlqYWpmZGFkjhvscGDeCGB9MSS1OzU1ILUIpg+Jg5OqQYm53MCH64qnoxvkluSqL+71KTm
        S+nheIU3pUUn7m7evM6G48bNc9psIWqSZ39JWi+8FG/q6rs8YluiuC3XOeE5Jzi2Rn2R4OrJ
        fz+jze6/zo4N2qzfDP5NNY3wj7Od1VQ7dc6Mq03beMUlLOwuLav/F/jcQsW2ydvxck3s37q5
        J74abGtVv1+kyrW8fOWVHv6bsu2nsgLTZ54vKOPUfbSALWKzFIfVux9TC6S32GTcbg5qdpKP
        +TFj76OTLP+f/rqd8/i+9+YIXVFpcaUtv2T/mKmaWCt7V8a9mnbn02qdA3Hdp/gk+o01TWpn
        WUmmKiomfeTLKxZ5+WLh3/els21cff+ftl+l5RXEbTfRLUCJpTgj0VCLuag4EQAcd9+nbwQA
        AA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210303062633epcms2p252227acd30ad15c1ca821d7e3f547b9e
References: <0242e4ab10acff9a7d71c2f956ba4624bf95add2.camel@gmail.com>
        <20210303062633epcms2p252227acd30ad15c1ca821d7e3f547b9e@epcms2p2>
        <20210303062926epcms2p6aa6737e5ed3916eed9ab80011aad3d83@epcms2p6>
        <CGME20210303062633epcms2p252227acd30ad15c1ca821d7e3f547b9e@epcms2p5>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bean,

> > +
> > +static inline int ufshpb_get_read_id(struct ufshpb_lu *hpb)
> > +{
> > +       if (++hpb->cur_read_id >= MAX_HPB_READ_ID)
> > +               hpb->cur_read_id = 0;
> > +       return hpb->cur_read_id;
> > +}
> > +
> > +static int ufshpb_execute_pre_req(struct ufshpb_lu *hpb, struct
> > scsi_cmnd *cmd,
> > +                                 struct ufshpb_req *pre_req, int
> > read_id)
> > +{
> > +       struct scsi_device *sdev = cmd->device;
> > +       struct request_queue *q = sdev->request_queue;
> > +       struct request *req;
> > +       struct scsi_request *rq;
> > +       struct bio *bio = pre_req->bio;
> > +
> > +       pre_req->hpb = hpb;
> > +       pre_req->wb.lpn = sectors_to_logical(cmd->device,
> > +                                            blk_rq_pos(cmd-
> > >request));
> > +       pre_req->wb.len = sectors_to_logical(cmd->device,
> > +                                            blk_rq_sectors(cmd-
> > >request));
> > +       if (ufshpb_pre_req_add_bio_page(hpb, q, pre_req))
> > +               return -ENOMEM;
> > +
> > +       req = pre_req->req;
> > +
> > +       /* 1. request setup */
> > +       blk_rq_append_bio(req, &bio);
> > +       req->rq_disk = NULL;
> > +       req->end_io_data = (void *)pre_req;
> > +       req->end_io = ufshpb_pre_req_compl_fn;
> > +
> > +       /* 2. scsi_request setup */
> > +       rq = scsi_req(req);
> > +       rq->retries = 1;
> > +
> > +       ufshpb_set_write_buf_cmd(rq->cmd, pre_req->wb.lpn, pre_req-
> > >wb.len,
> > +                                read_id);
> > +       rq->cmd_len = scsi_command_size(rq->cmd);
> > +
> > +       if (blk_insert_cloned_request(q, req) != BLK_STS_OK)
> > +               return -EAGAIN;
> > +
> > +       hpb->stats.pre_req_cnt++;
> > +
> > +       return 0;
> > +}
> > +
> > +static int ufshpb_issue_pre_req(struct ufshpb_lu *hpb, struct
> > scsi_cmnd *cmd,
> > +                               int *read_id)
> > +{
> > +       struct ufshpb_req *pre_req;
> > +       struct request *req = NULL;
> > +       struct bio *bio = NULL;
> > +       unsigned long flags;
> > +       int _read_id;
> > +       int ret = 0;
> > +
> > +       req = blk_get_request(cmd->device->request_queue,
> > +                             REQ_OP_SCSI_OUT | REQ_SYNC,
> > BLK_MQ_REQ_NOWAIT);
> > +       if (IS_ERR(req))
> > +               return -EAGAIN;
> > +
> > +       bio = bio_alloc(GFP_ATOMIC, 1);
> > +       if (!bio) {
> > +               blk_put_request(req);
> > +               return -EAGAIN;
> > +       }
> > +
> > +       spin_lock_irqsave(&hpb->rgn_state_lock, flags);
> > +       pre_req = ufshpb_get_pre_req(hpb);
> > +       if (!pre_req) {
> > +               ret = -EAGAIN;
> > +               goto unlock_out;
> > +       }
> > +       _read_id = ufshpb_get_read_id(hpb);
> > +       spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
> > +
> > +       pre_req->req = req;
> > +       pre_req->bio = bio;
> > +
> > +       ret = ufshpb_execute_pre_req(hpb, cmd, pre_req, _read_id);
> > +       if (ret)
> > +               goto free_pre_req;
> > +
> > +       *read_id = _read_id;
> > +
> > +       return ret;
> > +free_pre_req:
> > +       spin_lock_irqsave(&hpb->rgn_state_lock, flags);
> > +       ufshpb_put_pre_req(hpb, pre_req);
> > +unlock_out:
> > +       spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
> > +       bio_put(bio);
> > +       blk_put_request(req);
> > +       return ret;
> > +}
> > +
> >  /*
> >   * This function will set up HPB read command using host-side L2P
> > map data.
> > - * In HPB v1.0, maximum size of HPB read command is 4KB.
> >   */
> > -void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
> > +int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
> >  {
> >         struct ufshpb_lu *hpb;
> >         struct ufshpb_region *rgn;
> > @@ -291,26 +560,27 @@ void ufshpb_prep(struct ufs_hba *hba, struct
> > ufshcd_lrb *lrbp)
> >         u64 ppn;
> >         unsigned long flags;
> >         int transfer_len, rgn_idx, srgn_idx, srgn_offset;
> > +       int read_id = 0;
> >         int err = 0;
> >  
> >         hpb = ufshpb_get_hpb_data(cmd->device);
> >         if (!hpb)
> > -               return;
> > +               return -ENODEV;
> >  
> >         if (ufshpb_get_state(hpb) != HPB_PRESENT) {
> >                 dev_notice(&hpb->sdev_ufs_lu->sdev_dev,
> >                            "%s: ufshpb state is not PRESENT",
> > __func__);
> > -               return;
> > +               return -ENODEV;
> >         }
> >  
> >         if (!ufshpb_is_write_or_discard_cmd(cmd) &&
> >             !ufshpb_is_read_cmd(cmd))
> > -               return;
> > +               return 0;
> >  
> >         transfer_len = sectors_to_logical(cmd->device,
> >                                           blk_rq_sectors(cmd-
> > >request));
> >         if (unlikely(!transfer_len))
> > -               return;
> > +               return 0;
> >  
> >         lpn = sectors_to_logical(cmd->device, blk_rq_pos(cmd-
> > >request));
> >         ufshpb_get_pos_from_lpn(hpb, lpn, &rgn_idx, &srgn_idx,
> > &srgn_offset);
> > @@ -323,18 +593,19 @@ void ufshpb_prep(struct ufs_hba *hba, struct
> > ufshcd_lrb *lrbp)
> >                 ufshpb_set_ppn_dirty(hpb, rgn_idx, srgn_idx,
> > srgn_offset,
> >                                  transfer_len);
> >                 spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
> > -               return;
> > +               return 0;
> >         }
> >  
> > -       if (!ufshpb_is_support_chunk(transfer_len))
> > -               return;
> > +       if (!ufshpb_is_support_chunk(hpb, transfer_len) &&
> > +           (ufshpb_is_legacy(hba) && (transfer_len !=
> > HPB_LEGACY_CHUNK_HIGH)))
> > +               return 0;
> >  
> >         spin_lock_irqsave(&hpb->rgn_state_lock, flags);
> >         if (ufshpb_test_ppn_dirty(hpb, rgn_idx, srgn_idx,
> > srgn_offset,
> >                                    transfer_len)) {
> >                 hpb->stats.miss_cnt++;
> >                 spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
> > -               return;
> > +               return 0;
> >         }
> >  
> >         err = ufshpb_fill_ppn_from_page(hpb, srgn->mctx, srgn_offset,
> > 1, &ppn);
> > @@ -347,28 +618,46 @@ void ufshpb_prep(struct ufs_hba *hba, struct
> > ufshcd_lrb *lrbp)
> >                  * active state.
> >                  */
> >                 dev_err(hba->dev, "get ppn failed. err %d\n", err);
> > -               return;
> > +               return err;
> > +       }
> > +
> > +       if (!ufshpb_is_legacy(hba) &&
> > +           ufshpb_is_required_wb(hpb, transfer_len)) {
> > +               err = ufshpb_issue_pre_req(hpb, cmd, &read_id);
> > +               if (err) {
> > +                       unsigned long timeout;
> > +
> > +                       timeout = cmd->jiffies_at_alloc +
> > msecs_to_jiffies(
> > +                                 hpb->params.requeue_timeout_ms);
> > +
> > +                       if (time_before(jiffies, timeout))
> > +                               return -EAGAIN;
> > +
> > +                       hpb->stats.miss_cnt++;
> > +                       return 0;
> > +               }
> >         }
> >  
> > -       ufshpb_set_hpb_read_to_upiu(hpb, lrbp, lpn, ppn,
> > transfer_len);
> > +       ufshpb_set_hpb_read_to_upiu(hpb, lrbp, lpn, ppn,
> > transfer_len, read_id);
> >  
> >         hpb->stats.hit_cnt++;
> > +       return 0;
> >  }
>  
>  
>  
> BUG!!!
>  
>  
> Please read HPB 2.0 Spec carefully, and check how to correctly use HPB
> READ ID. you are assigning 0 for HPB write buffer. how can you expect
> the HPB READ be paired???
>  
I fixed as follows,

static inline int ufshpb_get_read_id(struct ufshpb_lu *hpb)
{
	if (hpb->cur_read_id >= MAX_HPB_READ_ID)
		hpb->cur_read_id = 0;
	return ++hpb->cur_read_id;
}

Thanks for comments, I will check carefully.

Thanks,
Daejun
