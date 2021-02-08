Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D35FC433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Feb 2021 08:05:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C083C64E7C
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Feb 2021 08:05:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbhBHIFA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Feb 2021 03:05:00 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:50907 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbhBHIEW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Feb 2021 03:04:22 -0500
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210208080339epoutp01613477d05729ee54432d85845c946694~htw_elBc30840008400epoutp01K
        for <linux-scsi@vger.kernel.org>; Mon,  8 Feb 2021 08:03:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210208080339epoutp01613477d05729ee54432d85845c946694~htw_elBc30840008400epoutp01K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1612771419;
        bh=+IQbcwYHHKAKbr2oo3oYjCL3PaagPDjw+o+axqX9N/w=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=tGrpubLslTtJWVydzbRsZcUQzN5Z+pzF1W0NBtJyakxdzSfQD8bDUAyc1bELpecij
         e4WAtpFbIbcnbs+zD/eemex2utMOPEyro7TcCpESMpsG7RZ0WMoSK1opY+cVu2HONW
         jLD+26IMnaAgj44j3Z/IRXNqAtqna+3apN27BdlY=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210208080337epcas2p32404be3d7313909405c470e483d47de6~htw9GbX9e2452724527epcas2p3B;
        Mon,  8 Feb 2021 08:03:37 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.185]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4DYz6v08hvz4x9QG; Mon,  8 Feb
        2021 08:03:35 +0000 (GMT)
X-AuditID: b6c32a46-777d6a800000dbf8-ab-6020f0566e7e
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        A1.4A.56312.650F0206; Mon,  8 Feb 2021 17:03:34 +0900 (KST)
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
In-Reply-To: <5bd43da52369a56f18867fa18efb3020@codeaurora.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210208080333epcms2p59403f0acbc9730c9a605d265836a956d@epcms2p5>
Date:   Mon, 08 Feb 2021 17:03:33 +0900
X-CMS-MailID: 20210208080333epcms2p59403f0acbc9730c9a605d265836a956d
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBJsWRmVeSWpSXmKPExsWy7bCmuW7YB4UEgw+bWS0ezNvGZrG37QS7
        xcufV9ksDt9+x24x7cNPZotP65exWrw8pGmx6kG4RfPi9WwWc842MFn09m9ls1h0YxuTxeVd
        c9gsuq/vYLNYfvwfk8XtLVwWS7feZLTonL6GxWLRwt0sDsIel694e1zu62Xy2DnrLrvHhEUH
        GD32z13D7tFycj+Lx8ent1g8+rasYvT4vEnOo/1AN1MAV1SOTUZqYkpqkUJqXnJ+SmZeuq2S
        d3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QX0oKZYk5pUChgMTiYiV9O5ui/NKSVIWM
        /OISW6XUgpScAkPDAr3ixNzi0rx0veT8XCtDAwMjU6DKhJyMc7POsBSc5ah4cn0BewPjY7Yu
        Rk4OCQETiR9nD7N2MXJxCAnsYJR4eu4JkMPBwSsgKPF3hzBIjbCAt8Sv7iYmEFtIQEli/cVZ
        7BBxPYlbD9cwgthsAjoS00/cB4uLCHhKfJ28Gmwms0ADm0TbqeWsEMt4JWa0P2WBsKUlti/f
        CtbMKWAn8X/eREaIuIbEj2W9zBC2qMTN1W/ZYez3x+ZD1YhItN47C1UjKPHg526ouKTEsd0f
        mCDseomtd34xghwhIdDDKHF45y2oI/QlrnVsZIF40lfiwiURkDCLgKrE9RN9UCUuEpM+bQKb
        zywgL7H97RxmkHJmAU2J9bv0QUwJAWWJI7dYYL5q2PibHZ3NLMAn0XH4L1x8x7wnUJepSaz7
        uZ5pAqPyLERAz0KyaxbCrgWMzKsYxVILinPTU4uNCoyQ43YTIziJa7ntYJzy9oPeIUYmDsZD
        jBIczEoivIGdcglCvCmJlVWpRfnxRaU5qcWHGE2BvpzILCWanA/MI3kl8YamRmZmBpamFqZm
        RhZK4rzFBg/ihQTSE0tSs1NTC1KLYPqYODilGph2GQppzeTfv4Gj+WnZjkbv+x+tti86GNGw
        fTLnswBne5cVPnuiJrs8nDhhWeWRsIAoDQWe7guzHki6TNcNdTLPeiD+8OR0G56TN2fpVUQv
        O9vpN3vhk4utSdMm1TV1NCut2PGebWqPcO2ErfXs0j8tPwdsKYzIOdwYr6F+knvLDZGnRdEp
        QmVyrR/eLQo4I7Ekt0Ni41WLnuzC6JjZaW3WE13v1edVfJuw1rowSaFwc9rdXX9PfV3JUCSo
        +qI/ck3GD+sO5uvyand1vxzz/x/5fP3mXeZcja/0FrVdkOt5qhI64Rz/v54ZnvsPaW9cLmYj
        YsWefziPSTt7m4PKu6zVjYWdu9Vab//s0bll36DEUpyRaKjFXFScCADcNu3dawQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5
References: <5bd43da52369a56f18867fa18efb3020@codeaurora.org>
        <20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p6>
        <20210129053005epcms2p323338fbb83459d2786fc0ef92701b147@epcms2p3>
        <CGME20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p5>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> @@ -342,13 +1208,14 @@ void ufshpb_suspend(struct ufs_hba *hba)
> >  	struct scsi_device *sdev;
> > 
> >  	shost_for_each_device(sdev, hba->host) {
> > -		hpb = sdev->hostdata;
> > +		hpb = ufshpb_get_hpb_data(sdev);
> >  		if (!hpb)
> >  			continue;
> > 
> >  		if (ufshpb_get_state(hpb) != HPB_PRESENT)
> >  			continue;
> >  		ufshpb_set_state(hpb, HPB_SUSPEND);
> > +		ufshpb_cancel_jobs(hpb);
> 
> Here may have a dead lock problem - in the case of runtime suspend,
> when ufshpb_suspend() is invoked, all of hba's children scsi devices
> are in RPM_SUSPENDED state. When this line tries to cancel a running
> map work, i.e. when ufshpb_get_map_req() calls below lines, it will
> be stuck at blk_queue_enter().
> 
> req = blk_get_request(hpb->sdev_ufs_lu->request_queue,
> 		      REQ_OP_SCSI_IN, 0);
> 
> Please check block layer power management, and see also commit d55d15a33
> ("scsi: block: Do not accept any requests while suspended").

I am agree with your comment.
How about add BLK_MQ_REQ_NOWAIT flag on blk_get_request() to avoid hang?

Thanks,
Daejun
