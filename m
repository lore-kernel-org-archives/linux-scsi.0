Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA75CC433E6
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Feb 2021 08:58:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D6DC64E7E
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Feb 2021 08:58:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbhBHI5L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Feb 2021 03:57:11 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:14752 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbhBHIy5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Feb 2021 03:54:57 -0500
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210208085349epoutp03412c941907f37b471477b060cde47a04~hucx91FPM2653626536epoutp035
        for <linux-scsi@vger.kernel.org>; Mon,  8 Feb 2021 08:53:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210208085349epoutp03412c941907f37b471477b060cde47a04~hucx91FPM2653626536epoutp035
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1612774429;
        bh=1C7iRBjhiHTp7FqxaGkFhrEhKzDIx/j/jpyPxREAHz8=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=f5baUfGVDV53Cl97SBY0oi3FEgvsUjyMlMoz38rwDsU/wxmHdIyjqIuBU7QsuxI2O
         UsEQ/4XvDEtY5d+JCPyXQV0aWSeBahhOybZYOGqYw4sx//QjOFbKnB50xg+mUz1Pb0
         WtWeSiWB4D3SPGwK2U7C9yE1OUfHf1n4QLEXgSNU=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210208085348epcas2p3637e8cf946ad2cc7a9003ef501da66ca~hucxQOdk62768927689epcas2p3D;
        Mon,  8 Feb 2021 08:53:48 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.188]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4DZ0Dp6hh1z4x9Q7; Mon,  8 Feb
        2021 08:53:46 +0000 (GMT)
X-AuditID: b6c32a46-1d9ff7000000dbf8-b2-6020fc1a16f1
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        73.36.56312.A1CF0206; Mon,  8 Feb 2021 17:53:46 +0900 (KST)
Mime-Version: 1.0
Subject: RE: Re: [PATCH v19 2/3] scsi: ufs: L2P map management for HPB read
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Can Guo <cang@codeaurora.org>,
        Daejun Park <daejun7.park@samsung.com>
CC:     Greg KH <gregkh@linuxfoundation.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "huobean@gmail.com" <huobean@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <88b608e2e133ba7ccd5bb452898848fd@codeaurora.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210208085346epcms2p1c11b70be9d258df66cb2ca4542835fac@epcms2p1>
Date:   Mon, 08 Feb 2021 17:53:46 +0900
X-CMS-MailID: 20210208085346epcms2p1c11b70be9d258df66cb2ca4542835fac
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLsWRmVeSWpSXmKPExsWy7bCmha7UH4UEg6XHjS0ezNvGZrG37QS7
        xcufV9ksDt9+x24x7cNPZotP65exWrw8pGmx6kG4RfPi9WwWc842MFn09m9ls1h0YxuTxeVd
        c9gsuq/vYLNYfvwfk8XtLVwWS7feZLTonL6GxWLRwt0sDsIel694e1zu62Xy2DnrLrvHhEUH
        GD32z13D7tFycj+Lx8ent1g8+rasYvT4vEnOo/1AN1MAV1QDo01iUXJGZlmqQmpecn5KZl66
        rVJoiJuuhZJCRn5xia1StKGFkZ6hpameiaWekXmslaGBgZGpkkJeYm6qrVKFLlS3kkJRcgFQ
        dUlqcUlRanIqUKjIobgkMT1Vrzgxt7g0L10vOT9XSaEsMacUqE9J384mIzUxJbVIIeEJY8a5
        nVPZCmYJVfydv52tgXEJbxcjJ4eEgInE/0MNrCC2kMAORol/z3O7GDk4eAUEJf7uEAYJCwt4
        S/zqbmKCKFGSWH9xFjtEXE/i1sM1jCA2m4COxPQT98HiIgKeEl8nrwYaycXBLNDAJtF2ajkr
        xC5eiRntT1kgbGmJ7cu3gjVzCthJTG2/yQQR15D4sayXGcIWlbi5+i07jP3+2HxGCFtEovXe
        WagaQYkHP3dDxSUlju3+ADWnXmLrnV+MIEdICPQwShzeeQvqCH2Jax0bwY7gFfCVuHX9MpjN
        IqAq0T/lC1Szi8T5rtlg9cwC8hLb385hBgUKs4CmxPpd+iCmhICyxJFbLDBvNWz8zY7OZhbg
        k+g4/BcuvmPeE6jpahLrfq5nmsCoPAsR0rOQ7JqFsGsBI/MqRrHUguLc9NRiowIj5HjexAhO
        +FpuOxinvP2gd4iRiYPxEKMEB7OSCG9gp1yCEG9KYmVValF+fFFpTmrxIcYqoC8nMkuJJucD
        c05eSbyhmYGRmamxibGxqYkp2cKmRmZmBpamFqZmRhZK4rzFBg/ihQTSE0tSs1NTC1KLYJYz
        cXBKNTBNDvGc+XHhJt2a6Ln1Jo2Gz1NYl1fkBhyPZXKJa7q3rWjmtFe8n/+FfH+yb53lHT43
        reeTcySn35l7Q9wi2jTxXs2TttwVNTNNyuMWRP1lmWsYpJIi+LqkZCtnibHDCzMbTfGQ8klG
        VyNezvTxUjsr6bBG+IV3gtbuvoXTrxc+8d7zZ9mv5MnW/75mNjqLdEV1eiWe+Hd+r9D8Txc0
        bzKXChc/fLVJaymrtkpSnSVrFevBklu2D3+4/7utt+PTgTQup1sZD12DM+OtipI/V4pwnP5c
        ser9a2mz27ej/5yfdifZbb46zyqbPb0yfj97RHV+fLl59brKxiV6a6ZeOzev6snfOa27pLek
        7d3/O45diaU4I9FQi7moOBEAVTa6lMYEAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5
References: <88b608e2e133ba7ccd5bb452898848fd@codeaurora.org>
        <5bd43da52369a56f18867fa18efb3020@codeaurora.org>
        <20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p6>
        <20210129053005epcms2p323338fbb83459d2786fc0ef92701b147@epcms2p3>
        <20210208080333epcms2p59403f0acbc9730c9a605d265836a956d@epcms2p5>
        <CGME20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p1>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>>> @@ -342,13 +1208,14 @@ void ufshpb_suspend(struct ufs_hba *hba)
>>> >          struct scsi_device *sdev;
>>> >
>>> >          shost_for_each_device(sdev, hba->host) {
>>> > -                hpb = sdev->hostdata;
>>> > +                hpb = ufshpb_get_hpb_data(sdev);
>>> >                  if (!hpb)
>>> >                          continue;
>>> >
>>> >                  if (ufshpb_get_state(hpb) != HPB_PRESENT)
>>> >                          continue;
>>> >                  ufshpb_set_state(hpb, HPB_SUSPEND);
>>> > +                ufshpb_cancel_jobs(hpb);
>>> 
>>> Here may have a dead lock problem - in the case of runtime suspend,
>>> when ufshpb_suspend() is invoked, all of hba's children scsi devices
>>> are in RPM_SUSPENDED state. When this line tries to cancel a running
>>> map work, i.e. when ufshpb_get_map_req() calls below lines, it will
>>> be stuck at blk_queue_enter().
>>> 
>>> req = blk_get_request(hpb->sdev_ufs_lu->request_queue,
>>>                       REQ_OP_SCSI_IN, 0);
>>> 
>>> Please check block layer power management, and see also commit 
>>> d55d15a33
>>> ("scsi: block: Do not accept any requests while suspended").
>> 
>> I am agree with your comment.
>> How about add BLK_MQ_REQ_NOWAIT flag on blk_get_request() to avoid 
>> hang?
>> 
> 
>That won't work - BLK_MQ_REQ_NOWAIT allows one to fast fail from 
>blk_mq_get_tag(),
>but blk_queue_enter() comes before __blk_mq_alloc_request();
> 
In blk_queue_enter(), BLK_MQ_REQ_NOWAIT flag can make error than wait rpm
resume. Please refer following code.

int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags)
{
	const bool pm = flags & BLK_MQ_REQ_PM;

	while (true) {
		bool success = false;

		rcu_read_lock();
		if (percpu_ref_tryget_live(&q->q_usage_counter)) {
			/*
			 * The code that increments the pm_only counter is
			 * responsible for ensuring that that counter is
			 * globally visible before the queue is unfrozen.
			 */
			if ((pm && queue_rpm_status(q) != RPM_SUSPENDED) ||
			    !blk_queue_pm_only(q)) {
				success = true;
			} else {
				percpu_ref_put(&q->q_usage_counter);
			}
		}
		rcu_read_unlock();

		if (success)
			return 0;

		if (flags & BLK_MQ_REQ_NOWAIT)
			return -EBUSY;	<-- out from the function.
			
Thanks,
Daejun
