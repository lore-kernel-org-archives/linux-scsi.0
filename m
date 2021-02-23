Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72AF7C433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 00:35:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3548D64F0E
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 00:35:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233764AbhBXAdH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Feb 2021 19:33:07 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:12055 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234552AbhBWXzr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2021 18:55:47 -0500
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210223235502epoutp01f6bd4124be07cba2be17704ccf2e143c~mha7zkFhc2263822638epoutp01m
        for <linux-scsi@vger.kernel.org>; Tue, 23 Feb 2021 23:55:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210223235502epoutp01f6bd4124be07cba2be17704ccf2e143c~mha7zkFhc2263822638epoutp01m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1614124502;
        bh=AYruRk8nl6xfKCakVQjyg5hwKFcT7auUu/Wqgs0Ha+Y=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=KHWoVSHVnfLSQR3+f2wUhhN2ZhR/CiOEeUBwsYyGW1pLqnSLu39RHIlmBMfDIsnHs
         rtxy+1SBOVOVTUKimSgWDGpLwadI1ZQRuVqlyMX5FR6L5+7Sx2+js2J+Lug2pKxGMX
         lw7CLpL/R0aD+0LbeZmcLHMiZG8g5XeVnuqsGMAs=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20210223235501epcas2p188899f67a1d491d98771927922bd5668~mha6VIMLn1754517545epcas2p1g;
        Tue, 23 Feb 2021 23:55:01 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.185]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4DlbWl1jMNz4x9Q0; Tue, 23 Feb
        2021 23:54:59 +0000 (GMT)
X-AuditID: b6c32a45-34dff7000001297d-bb-603595d35453
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        B1.93.10621.3D595306; Wed, 24 Feb 2021 08:54:59 +0900 (KST)
Mime-Version: 1.0
Subject: RE: RE: [PATCH v22 4/4] scsi: ufs: Add HPB 2.0 support
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <DM6PR04MB6575DA862FD50130DAF1E573FC809@DM6PR04MB6575.namprd04.prod.outlook.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210223235458epcms2p666e7cca021e09c715ca3b11ada39ebeb@epcms2p6>
Date:   Wed, 24 Feb 2021 08:54:58 +0900
X-CMS-MailID: 20210223235458epcms2p666e7cca021e09c715ca3b11ada39ebeb
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLsWRmVeSWpSXmKPExsWy7bCmhe7lqaYJBs2fWS0ezNvGZrG37QS7
        xcufV9ksDt9+x24x7cNPZotP65exWrw8pGmx6kG4RfPi9WwWc842MFn09m9ls3h85zO7xaIb
        25gs+v+1s1hc3jWHzaL7+g42i+XH/zFZ3N7CZbF0601Gi87pa1gsFi3czeIg6nH5irfH5b5e
        Jo+ds+6ye0xYdIDRY//cNeweLSf3s3h8fHqLxaNvyypGj8+b5DzaD3QzBXBFNTDaJBYlZ2SW
        pSqk5iXnp2TmpdsqhYa46VooKWTkF5fYKkUbWhjpGVqa6plY6hmZx1oZGhgYmSop5CXmptoq
        VehCdSspFCUXAFWXpBaXFKUmpwKFihyKSxLTU/WKE3OLS/PS9ZLzc5UUyhJzSoH6lPTtbDJS
        E1NSixQSnjBm7L/znb1gpWDF82fb2RoYf3N3MXJySAiYSBzofsfaxcjFISSwg1Hi6J5XzF2M
        HBy8AoISf3cIg9QIC9hLvGlZzARiCwkoSay/OIsdIq4ncevhGkYQm01AR2L6ifvsIHNEBFaw
        SFz8dYkNxGEW+MUkceLxB0aIbbwSM9qfskDY0hLbl28Fi3MKxEqsOPuRGSKuIfFjWS+ULSpx
        c/Vbdhj7/bH5UHNEJFrvnYWqEZR48HM3VFxS4tjuD0wQdr3E1ju/GEGOkBDoYZQ4vPMWK0RC
        X+Jax0awI3gFfCUur57PBvIxi4CqxJPeEogSF4mZB8+ClTALyEtsfzsHHCjMApoS63fpg5gS
        AsoSR26xwHzVsPE3OzqbWYBPouPwX7j4jnlPoC5Tk1j3cz3TBEblWYiQnoVk1yyEXQsYmVcx
        iqUWFOempxYbFRgiR/QmRnAe0HLdwTj57Qe9Q4xMHIyHGCU4mJVEeNnuGiUI8aYkVlalFuXH
        F5XmpBYfYqwCenIis5Rocj4wE+WVxBuaGRiZmRqbGBubmpiSLWxqZGZmYGlqYWpmZKEkzlts
        8CBeSCA9sSQ1OzW1ILUIZjkTB6dUAxP3q60m8mxeK7ZU5+/5bHT0RNk0o9ps0fy0B1VhfLc8
        kya8vrq4NGFVI+sLx+rjXMqJaa8VTvrfuasmlXzCQHUnwxknUc6sj9LMR4znzJ8Vx6jTsZc7
        aEdB1zNNK8uAQB+nI+Gx2p9PzN+6uVnSMESV94Waa32eQ8vHpD2Ws/QSZj/avV9o+rUfEx6W
        HyjQ6VludXHWD49fwTesGu5HHd7ZbtWT+810mV9TxpGS2kW/KifLqx29v5Iz832uPrOrxPo5
        MdFSF0rbJuv+ysj96yIf8zvhu/Dl3nezGqb7Hr3w7ejt72lrfOxzj/u6rX39Y7+J2NxMoZro
        MoNdk1vvC07ezPT+dDd3TFjGCa2Uw0osxRmJhlrMRcWJAELGdKLRBAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210222092907epcms2p307f3c4116349ebde6eed05c767287449
References: <DM6PR04MB6575DA862FD50130DAF1E573FC809@DM6PR04MB6575.namprd04.prod.outlook.com>
        <20210222092957epcms2p728b0c563f3cfbecbf8692d7e86f9afed@epcms2p7>
        <20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p3>
        <20210222093150epcms2p155352e2255e6bfd8f8d71c737ed05e76@epcms2p1>
        <CGME20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p6>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > @@ -2656,7 +2656,12 @@ static int ufshcd_queuecommand(struct Scsi_Host
> > *host, struct scsi_cmnd *cmd)
> > 
> >         lrbp->req_abort_skip = false;
> > 
> > -       ufshpb_prep(hba, lrbp);
> > +       err = ufshpb_prep(hba, lrbp);
> > +       if (err == -EAGAIN) {
> > +               lrbp->cmd = NULL;
> > +               ufshcd_release(hba);
> > +               goto out;
> > +       }
> Did I miss-read it, or are you bailing out of wb failed e.g. because no tag is available?
> Why not continue with read10?

We try to sending HPB read several times within the requeue_timeout_ms.
Because it strategy has more benefit for overall performance in this
situation that many requests are queueing.

>  
>  
> > +       if (blk_insert_cloned_request(q, req) != BLK_STS_OK)
> > +               return -EAGAIN;
> Why did you choose to use blk_insert_cloned_request and not e.g. the more common blk_execute_rq_nowait?

It is the process that sending one more command (write buffer) prior to
HPB read command. This API makes write buffer to issue directly. Other APIs,
for example blk_execute_rq_nowait, it can make queueing the command in the
scheduler, so the order of commands can be inversed.
Here is comment of the API.
// blk_insert_cloned_request - Helper for stacking drivers to submit a request

> > +       hpb->stats.pre_req_cnt++;
> > +
> > +       return 0;
> > +}
>  
> > -       ufshpb_set_hpb_read_to_upiu(hpb, lrbp, lpn, ppn, transfer_len);
> > +       if (ufshpb_is_required_wb(hpb, transfer_len)) {
> > +               err = ufshpb_issue_pre_req(hpb, cmd, &read_id);
> > +               if (err) {
> > +                       unsigned long timeout;
> > +
> > +                       timeout = cmd->jiffies_at_alloc + msecs_to_jiffies(
> > +                                 hpb->params.requeue_timeout_ms);
> > +                       if (time_before(jiffies, timeout))
> > +                               return -EAGAIN;
> Why requeue_timeout_ms needs to be a configurable parameter?
> Why rq->timeout is not enough?

We are using this value for re-trying threshold of HPB read.

Thanks,
Daejun

> Thanks,
> Avri
>  
>  
>  
>  
>   
