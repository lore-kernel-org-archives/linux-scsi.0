Return-Path: <SRS0=UMfj=7Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8B5FC433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Jun 2020 02:28:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90E8120835
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Jun 2020 02:28:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="RHl1lg3X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbgFLC2I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Jun 2020 22:28:08 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:21171 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726349AbgFLC2G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Jun 2020 22:28:06 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200612022803epoutp0381bb349b0e1f40f130aa1f6b9f266141~XquKIZPf91988619886epoutp03_
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2020 02:28:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200612022803epoutp0381bb349b0e1f40f130aa1f6b9f266141~XquKIZPf91988619886epoutp03_
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1591928883;
        bh=hdov1UyoasQI8pS6FcIxfYTfSmxps6Svz6JY4APTa/A=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=RHl1lg3XUHpp+pyXqVMHyr6U/M+jGbYyNP7C6bGNpnnW04Ut0jnIOjpEAuY7mgdHS
         gCu2cAOrc74+nke7tJFmjO0lWyKY2djH5otc57S7O71JEEUhScJEU+Aw06PqugP3dp
         JeYHfylhx56NL//rmVrNfCRWClTkdrR7Ss+nmBVA=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20200612022802epcas2p42b47335386aea0f153933fec99d2048f~XquJHdqaF1818718187epcas2p4O;
        Fri, 12 Jun 2020 02:28:02 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.184]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 49jl4x0bZKzMqYkl; Fri, 12 Jun
        2020 02:28:01 +0000 (GMT)
X-AuditID: b6c32a47-fc5ff70000006b31-1d-5ee2e830fab6
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        3C.75.27441.038E2EE5; Fri, 12 Jun 2020 11:28:00 +0900 (KST)
Mime-Version: 1.0
Subject: Re: [RFC PATCH 2/5] scsi: ufs: Add UFS-feature layer
Reply-To: daejun7.park@samsung.com
From:   Daejun Park <daejun7.park@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Daejun Park <daejun7.park@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
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
In-Reply-To: <1319810e-a323-c022-5e27-902f88cefe8f@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20200612022759epcms2p47929b76eb2e809240f415c19f9383f92@epcms2p4>
Date:   Fri, 12 Jun 2020 11:27:59 +0900
X-CMS-MailID: 20200612022759epcms2p47929b76eb2e809240f415c19f9383f92
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLJsWRmVeSWpSXmKPExsWy7bCmqa7Bi0dxBvsOiVhsvPuK1eLBvG1s
        FnvbTrBbvPx5lc3i4MNOFovDt9+xW0z78JPZ4tP6ZawWLw9pWqx6EG7R27+VzWLRjW1MFpd3
        zWGz6L6+g81i+fF/TBYTXi5hsVi69SajRef0NSwWH3rqLBYt3M3iIOJx+Yq3x+W+XiaPxXte
        MnlMWHSA0aPl5H4Wj+/rO9g8Pj69xeLRt2UVo8fnTXIe7Qe6mQK4onJsMlITU1KLFFLzkvNT
        MvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4CeU1IoS8wpBQoFJBYXK+nb2RTl
        l5akKmTkF5fYKqUWpOQUGBoW6BUn5haX5qXrJefnWhkaGBiZAlUm5GT8u32SveCmSMXVzR/Z
        Ghi7BLoYOTkkBEwkThxYzdjFyMUhJLCDUeL+8WNADgcHr4CgxN8dwiA1wgK2EhfXLGEGsYUE
        lCTWX5zFDhHXk7j1cA0jiM0moCMx/cR9sLiIwEQWief7XUFmMgt8Y5LYfPEIG8QyXokZ7U9Z
        IGxpie3Lt4Lt4hSwlvj/SAwirCHxY1kvM4QtKnFz9Vt2GPv9sfmMELaIROu9s1A1ghIPfu6G
        iktKHNv9gQnCrpfYeucX2F8SAj2MEod33mKFSOhLXOvYCHYDr4CvxJxrEMtYBFQlZrzfAdXs
        IvGi5T9YPbOAvMT2t3OYQe5kFtCUWL9LH8SUEFCWOHKLBearho2/2dHZzAJ8Eh2H/8LFd8x7
        AjVdTWLdz/VMExiVZyECehaSXbMQdi1gZF7FKJZaUJybnlpsVGCMHLebGMHpXMt9B+OMtx/0
        DjEycTAeYpTgYFYS4RUUfxgnxJuSWFmVWpQfX1Sak1p8iNEU6MuJzFKiyfnAjJJXEm9oamRm
        ZmBpamFqZmShJM5bbHUhTkggPbEkNTs1tSC1CKaPiYNTqoGpRHGD1g9n7dTfa5Tb5uqcWsCp
        WeXkdunn/TCxuHM/GP4p3jH6eUZRy6d0zWpDNfnLTYFvf1xu/K5Q+/rJTpubO7IvxCZZP/Bn
        0Np8f31C7qS4M/+Nuoyyf9YqnBSsFjkzucW+qfdjHqu/vtia4nuF37qeXX3DmHOQ+a3Q+44d
        ke088s9rmLqriv2+ih/da1TZkf752x+Xp9EhxXsDX6VfDjzpErW28OxxAa3J614X3WLuP7NM
        Qvmk1vng8vSyH4vk/Pb4G9t8y3J4HeUoHyt2bv4nrcvdcxYtftf9f7lUCcfjQ6pP7Ux9+6T0
        gkJNJzwodGwROiE2u3dGM9POZTecM4v2vzh9NqzlwuJvCgeUWIozEg21mIuKEwFtWO/BcAQA
        AA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200605011604epcms2p8bec8ef6682583d7248dc7d9dc1bfc882
References: <1319810e-a323-c022-5e27-902f88cefe8f@acm.org>
        <963815509.21591320301642.JavaMail.epsvc@epcpadp1>
        <231786897.01591320001492.JavaMail.epsvc@epcpadp1>
        <336371513.41591320902369.JavaMail.epsvc@epcpadp1>
        <CGME20200605011604epcms2p8bec8ef6682583d7248dc7d9dc1bfc882@epcms2p4>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On 2020-06-04 18:30, Daejun Park wrote:
> > +inline void ufsf_slave_configure(struct ufs_hba *hba,
> > +         struct scsi_device *sdev)
> > +{
> > +  /* skip well-known LU */
> > +  if (sdev->lun >= UFS_UPIU_MAX_UNIT_NUM_ID)
> > +    return;
> > +
> > +  if (!(hba->dev_info.b_ufs_feature_sup & UFS_FEATURE_SUPPORT_HPB_BIT))
> > +    return;
> > +
> > +  atomic_inc(&hba->ufsf.slave_conf_cnt);
> > +  smp_mb__after_atomic(); /* for slave_conf_cnt */
> > +
> > +  /* waiting sdev init.*/
> > +  if (waitqueue_active(&hba->ufsf.sdev_wait))
> > +    wake_up(&hba->ufsf.sdev_wait);
> > +}

> Guarding a wake_up() call with a waitqueue_active() check is an
> anti-pattern. Please don't do that and call wake_up() directly.
> Additionally, wake_up() includes a barrier if it wakes up a kernel
> thread so the smp_mb__after_atomic() can be left out if the
> waitqueue_active() call is removed.
OK, I will change it.

> > +/**
> > + * struct ufsf_operation - UFS feature specific callbacks
> > + * @prep_fn: called after construct upiu structure
> > + * @reset: called after proving hba
                           ^^^^^^^
> Is this a typo? Should "proving" perhaps be changed into "probing"?
Yes, I will change.

> > +struct ufshpb_driver {
> > +  struct device_driver drv;
> > +  struct list_head lh_hpb_lu;
> > +
> > +  struct ufsf_operation ufshpb_ops;
> > +
> > +  /* memory management */
> > +  struct kmem_cache *ufshpb_mctx_cache;
> > +  mempool_t *ufshpb_mctx_pool;
> > +  mempool_t *ufshpb_page_pool;
> > +
> > +  struct workqueue_struct *ufshpb_wq;
> > +};

> Why is a dedicated workqueue needed? Why are the standard workqueues not
> good enough?
The map_work handles map related operations, including IO operations. So, adding
this task to the standard WQ can interfere with other jobs and degrade HPB related performance.


> > @@ -2525,6 +2525,8 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
> >  
> >    ufshcd_comp_scsi_upiu(hba, lrbp);
> >  
> > +  ufsf_ops_prep_fn(hba, lrbp);
> > +
> >    err = ufshcd_map_sg(hba, lrbp);
> >    if (err) {
> >      lrbp->cmd = NULL;

> What happens if a SCSI command is retried and hence ufsf_ops_prep_fn()
> is called multiple times for the same SCSI command?
Developers of UFS features should implement it so that prep_fn does not have
any problems even if it processes the same SCSI command multiple times.
In HPB feature, prep_fn modifies only upiu  structure. So it is ok to call
it multiple times because the upiu is rebuilt from ufshcd_comp_scsi_upiu().

Thanks,

Daejun.

