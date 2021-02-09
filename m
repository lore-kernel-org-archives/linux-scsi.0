Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56476C433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 01:28:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14C176023B
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 01:28:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbhBIB2b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Feb 2021 20:28:31 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:20770 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbhBIB2X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Feb 2021 20:28:23 -0500
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210209012739epoutp0486ea1c64373d18e0dc73ff02e2108d10~h8AgjEXG33144731447epoutp048
        for <linux-scsi@vger.kernel.org>; Tue,  9 Feb 2021 01:27:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210209012739epoutp0486ea1c64373d18e0dc73ff02e2108d10~h8AgjEXG33144731447epoutp048
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1612834059;
        bh=IVTi1/fqkT4P2V5ja0EkF1goxEb7HDWuBTmQvwKKMc4=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=SaMUCF+ETp+bg7gCRr+WyNSsifS+GMzDCPZuLc0qeYPTCtQ/B+E3t+CE5gO/LAGY/
         kMaDpSsn3cy+pCn+QZtzINJm84oJvUMPAgOlcaL0EE3VMCeLJq0XZXR8EcIgOU12cT
         SrKv0Hy/kO5jSzpGvqb61HnICEU86th6XZgllGPM=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210209012738epcas2p47972312b144c2a8fd813774bb82dcc3e~h8AfyJhrg0963409634epcas2p49;
        Tue,  9 Feb 2021 01:27:38 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.182]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4DZQHX0wQDz4x9QD; Tue,  9 Feb
        2021 01:27:36 +0000 (GMT)
X-AuditID: b6c32a46-1d9ff7000000dbf8-42-6021e5074975
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        03.60.56312.705E1206; Tue,  9 Feb 2021 10:27:35 +0900 (KST)
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
In-Reply-To: <5b9f5edbe26930765ee4adaa786db7da@codeaurora.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210209012734epcms2p8354347b1dd71601e74b505c715d36af0@epcms2p8>
Date:   Tue, 09 Feb 2021 10:27:34 +0900
X-CMS-MailID: 20210209012734epcms2p8354347b1dd71601e74b505c715d36af0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrELsWRmVeSWpSXmKPExsWy7bCmhS77U8UEgxv9vBYP5m1js9jbdoLd
        4uXPq2wWh2+/Y7eY9uEns8Wn9ctYLV4e0rRY9SDconnxejaLOWcbmCx6+7eyWSy6sY3J4vKu
        OWwW3dd3sFksP/6PyeL2Fi6LpVtvMlp0Tl/DYrFo4W4WB2GPy1e8PS739TJ57Jx1l91jwqID
        jB77565h92g5uZ/F4+PTWywefVtWMXp83iTn0X6gmymAK6qB0SaxKDkjsyxVITUvOT8lMy/d
        Vik0xE3XQkkhI7+4xFYp2tDCSM/Q0lTPxFLPyDzWytDAwMhUSSEvMTfVVqlCF6pbSaEouQCo
        uiS1uKQoNTkVKFTkUFySmJ6qV5yYW1yal66XnJ+rpFCWmFMK1Kekb2eTkZqYklqkkPCEMWPx
        7k72go3CFVum3WNtYHzA18XIySEhYCLRsnEiM4gtJLCDUeJKv0AXIwcHr4CgxN8dwiBhYQFv
        iV/dTUwQJUoS6y/OYoeI60nceriGEcRmE9CRmH7iPlhcRMBT4uvk1axdjFwczAINbBJtp5az
        QuzilZjR/pQFwpaW2L58K1gzp4CdxONHR6DiGhI/lvUyQ9iiEjdXv2WHsd8fm88IYYtItN47
        C1UjKPHg526ouKTEsd0fmCDseomtd34xghwhIdDDKHF45y2oI/QlrnVsZIF40lfixMQokDCL
        gKrEwd3boWa6SLz7NgFsL7OAvMT2t3OYQcqZBTQl1u/SBzElBJQljtxigfmqYeNvdnQ2swCf
        RMfhv3DxHfOeQF2mJrHu53qmCYzKsxABPQvJrlkIuxYwMq9iFEstKM5NTy02KjBCjuZNjOB0
        r+W2g3HK2w96hxiZOBgPMUpwMCuJ8AZ2yiUI8aYkVlalFuXHF5XmpBYfYqwC+nIis5Rocj4w
        4+SVxBuaGRiZmRqbGBubmpiSLWxqZGZmYGlqYWpmZKEkzlts8CBeSCA9sSQ1OzW1ILUIZjkT
        B6dUA9Nm89+mkXfv8m0wtGR93rtjyo29V6cpSltIXnwl7fkjv+5a5fSYwh/GWedmSqjNZVPn
        yS465SOsnf+gUY2f4YinjV9KnLuvoE9d63Y1wdcnePsEjk65pOnmOi39p8V9ix8POxUy+V83
        rZj5eg7fIrak219FnundcLtte7EnpnjCajcxZYu770/Mz11teyz62pfvS7WP3d5942ax5PTY
        pMTT/SI/d2Rwc6vYxm+c8NsgM+iy2O/eeIGIrRyKp798s5q42sJK9m3miqOHf8yM38PpXFzA
        dKJIsPqUeeNLuRNB/bmPu/jeakw60FWsz/Hpplblr/mmz5Zs/yogox4ebxNS4cQV+Vz53Z6q
        r937fyqxFGckGmoxFxUnAgDw+NemxQQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5
References: <5b9f5edbe26930765ee4adaa786db7da@codeaurora.org>
        <88b608e2e133ba7ccd5bb452898848fd@codeaurora.org>
        <5bd43da52369a56f18867fa18efb3020@codeaurora.org>
        <20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p6>
        <20210129053005epcms2p323338fbb83459d2786fc0ef92701b147@epcms2p3>
        <20210208080333epcms2p59403f0acbc9730c9a605d265836a956d@epcms2p5>
        <20210208085346epcms2p1c11b70be9d258df66cb2ca4542835fac@epcms2p1>
        <CGME20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p8>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>>>>> @@ -342,13 +1208,14 @@ void ufshpb_suspend(struct ufs_hba *hba)
>>>>> >          struct scsi_device *sdev;
>>>>> >
>>>>> >          shost_for_each_device(sdev, hba->host) {
>>>>> > -                hpb = sdev->hostdata;
>>>>> > +                hpb = ufshpb_get_hpb_data(sdev);
>>>>> >                  if (!hpb)
>>>>> >                          continue;
>>>>> >
>>>>> >                  if (ufshpb_get_state(hpb) != HPB_PRESENT)
>>>>> >                          continue;
>>>>> >                  ufshpb_set_state(hpb, HPB_SUSPEND);
>>>>> > +                ufshpb_cancel_jobs(hpb);
>>>>> 
>>>>> Here may have a dead lock problem - in the case of runtime suspend,
>>>>> when ufshpb_suspend() is invoked, all of hba's children scsi devices
>>>>> are in RPM_SUSPENDED state. When this line tries to cancel a running
>>>>> map work, i.e. when ufshpb_get_map_req() calls below lines, it will
>>>>> be stuck at blk_queue_enter().
>>>>> 
>>>>> req = blk_get_request(hpb->sdev_ufs_lu->request_queue,
>>>>>                       REQ_OP_SCSI_IN, 0);
>>>>> 
>>>>> Please check block layer power management, and see also commit
>>>>> d55d15a33
>>>>> ("scsi: block: Do not accept any requests while suspended").
>>>> 
>>>> I am agree with your comment.
>>>> How about add BLK_MQ_REQ_NOWAIT flag on blk_get_request() to avoid
>>>> hang?
>>>> 
>>> 
>>> That won't work - BLK_MQ_REQ_NOWAIT allows one to fast fail from
>>> blk_mq_get_tag(),
>>> but blk_queue_enter() comes before __blk_mq_alloc_request();
>>> 
>> In blk_queue_enter(), BLK_MQ_REQ_NOWAIT flag can make error than wait 
>> rpm
>> resume. Please refer following code.
> 
>Oops, sorry, my memory needs to be refreshed on that part.
> 
>But will BLK_MQ_REQ_NOWAIT flag breaks your original purpose? When
>runtime suspend is out of the picture, if traffic is heavy on the
>request queue, map_work() will be stopped frequently once it is
>not able to get a request from the queue - that shall pull down the
>efficiency of one map_work(), that may hurt random performance...

I think deadlock prevention is the most important. So I want to add
BLK_MQ_REQ_NOWAIT flag.
Starvation of map request can be distinguish by return value of
blk_get_request(). -EWOULDBLOCK means there is no available tags for this
request. -EBUSY means failed on blk_queue_enter(). To overcome starvation
of map request, we can try N times in heavy traffic situation (maybe N=3?).

Thanks,
Daejun
