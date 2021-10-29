Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9039DC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 02:50:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BF4561165
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 02:50:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbhJ2Cw5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Oct 2021 22:52:57 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:40771 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231544AbhJ2Cwy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Oct 2021 22:52:54 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20211029025025epoutp01f64c743e547ce06b9f07d142a1c1cd13~yYJkGqxMX2891628916epoutp01d
        for <linux-scsi@vger.kernel.org>; Fri, 29 Oct 2021 02:50:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20211029025025epoutp01f64c743e547ce06b9f07d142a1c1cd13~yYJkGqxMX2891628916epoutp01d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1635475825;
        bh=aLvbfxpxREsTn4jyDQjyggqM5hjnqu1ZAt7I9yeQkXA=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=hmM0ftI/MUiztd1J57HkClDYJT8PsluP6ovkciTOGpGv6skmRubTd3wiHA2b5jtyL
         G+y87OpkPnn4eZVJRuLAycYbYoX9XraAwZ2wR+x9pglnmjrK7sfKMcYt+RBI6myzcd
         LEaKpgN30VTEAKEKNg8e+Xc+wPXSGl0OMHeOY6wI=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20211029025024epcas2p1f6b117d506aec3b6ed13d0620ee1f033~yYJjczJJ91595015950epcas2p1i;
        Fri, 29 Oct 2021 02:50:24 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.102]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4HgRk06yZ1z4x9Py; Fri, 29 Oct
        2021 02:50:16 +0000 (GMT)
X-AuditID: b6c32a45-45dff7000000ca37-10-617b6164fe7b
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        6E.3E.51767.4616B716; Fri, 29 Oct 2021 11:50:12 +0900 (KST)
Mime-Version: 1.0
Subject: RE: [PATCH] scsi: ufs: Fix proper API to send HPB pre-request
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Ming Lei <ming.lei@redhat.com>,
        Daejun Park <daejun7.park@samsung.com>
CC:     ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "huobean@gmail.com" <huobean@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        Keoseong Park <keosung.park@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <YXtYME4yW6bFA1Cb@T590>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20211029025012epcms2p429d940cb32f5f31a2ac3fe395538a755@epcms2p4>
Date:   Fri, 29 Oct 2021 11:50:12 +0900
X-CMS-MailID: 20211029025012epcms2p429d940cb32f5f31a2ac3fe395538a755
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFJsWRmVeSWpSXmKPExsWy7bCmmW5KYnWiwdYrRhYP5m1js3j58yqb
        xbQPP5ktXh7StFj1INxiztkGJotFN7YxWRw/+Y7R4vKuOWwW3dd3sFksP/6PyeLQ5GYmBx6P
        y1e8PXbOusvuMWHRAUaPj09vsXi833eVzaNvyypGj8+b5DzaD3QzBXBEZdtkpCampBYppOYl
        56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAN2qpFCWmFMKFApILC5W0rez
        KcovLUlVyMgvLrFVSi1IySkwL9ArTswtLs1L18tLLbEyNDAwMgUqTMjO2Plcs+C0bMWXj33s
        DYx3xboYOTgkBEwkfqwu6mLk4hAS2MEo8XPVL1aQOK+AoMTfHcJdjJwcwgJuEstXTWIEsYUE
        lCTWX5zFDhHXk7j1cA1YnE1AR2L6iftgcREBL4kNz1YygsxkFjjALHF87hs2kISEAK/EjPan
        LBC2tMT25VvBmjkFVCTm3/3HChHXkPixrJcZwhaVuLn6LTuM/f7YfEYIW0Si9d5ZqBpBiQc/
        d0PFJSWO7f7ABGHXS2y98wvsCAmBHkaJwztvQS3Ql7jWsRHsCF4BX4m9c9eB2SwCqhIPd6yA
        Guoi8eBAL9hQZgF5ie1v5zCDAoVZQFNi/S59SLgpSxy5xQLzVsPG3+zobGYBPomOw3/h4jvm
        PYE6TU1i3c/1TBMYlWchQnoWkl2zEHYtYGRexSiWWlCcm55abFRgCI/a5PzcTYzgRKvluoNx
        8tsPeocYmTgYDzFKcDArifBenleeKMSbklhZlVqUH19UmpNafIjRFOjLicxSosn5wFSfVxJv
        aGJpYGJmZmhuZGpgriTOaymanSgkkJ5YkpqdmlqQWgTTx8TBKdXAJMfmdvCl/b39K/Vd7XR0
        LF+fPtvbLv1T+ebeBKHLqnLvyy4Hh+kt23W35fv6L2vvKt0yct/2qv7PZb4LXDP/VwWrbfp7
        v9d9haPku6P7dq7mVnRvuxwkWh0X+IeJK3vHpzc7pk9ha1HYVzzTQOnw/Z/iB0UdS5a9sTgV
        Gzdl8YztCyOFn3z3ZOZ82PYvkFd3xVJXK44DdTw5nyy0NO1O1Sq/8Y1X+V5W9UE7s1B2Ou9U
        idT9muL81Tp+U+zvT7U0bLB7nhT3przUVe/++rex8e9u7Xt4bunqnduNtn615RVLujC1e0L8
        Ie9LUWmxu0onO7Y7LItWW3llGae0+qL2WU3715xuNJmrVpimPe9agRJLcUaioRZzUXEiAIlZ
        Tck9BAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211027223619epcms2p60bbc74c9ba9757c58709a99acd0892ff
References: <YXtYME4yW6bFA1Cb@T590> <YXtPNIDzeln8zBCn@T590>
        <20211027223619epcms2p60bbc74c9ba9757c58709a99acd0892ff@epcms2p6>
        <20211029015015epcms2p3a46e0779e43ab84c00388d99abf3b867@epcms2p3>
        <CGME20211027223619epcms2p60bbc74c9ba9757c58709a99acd0892ff@epcms2p4>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> On Fri, Oct 29, 2021 at 10:50:15AM +0900, Daejun Park wrote:
> > > On Thu, Oct 28, 2021 at 07:36:19AM +0900, Daejun Park wrote:
> > > > This patch addresses the issue of using the wrong API to create a
> > > > pre_request for HPB READ.
> > > > HPB READ candidate that require a pre-request will try to allocate a
> > > > pre-request only during request_timeout_ms (default: 0). Otherwise, it is
> > >  
> > > Can you explain about 'only during request_timeout_ms'?
> > >  
> > > From the following code in ufshpb_prep(), the pre-request is allocated
> > > for each READ IO in case of (!ufshpb_is_legacy(hba) && ufshpb_is_required_wb(hpb,
> > > transfer_len)).
> > >  
> > >    if (!ufshpb_is_legacy(hba) &&
> > >             ufshpb_is_required_wb(hpb, transfer_len)) {
> > >                 err = ufshpb_issue_pre_req(hpb, cmd, &read_id);
> > >  
> > > > passed as normal READ, so deadlock problem can be resolved.
> > > > 
> > > > Signed-off-by: Daejun Park <daejun7.park@samsung.com>
> > > > ---
> > > >  drivers/scsi/ufs/ufshpb.c | 11 +++++------
> > > >  drivers/scsi/ufs/ufshpb.h |  1 +
> > > >  2 files changed, 6 insertions(+), 6 deletions(-)
> > > > 
> > > > diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
> > > > index 02fb51ae8b25..3117bd47d762 100644
> > > > --- a/drivers/scsi/ufs/ufshpb.c
> > > > +++ b/drivers/scsi/ufs/ufshpb.c
> > > > @@ -548,8 +548,7 @@ static int ufshpb_execute_pre_req(struct ufshpb_lu *hpb, struct scsi_cmnd *cmd,
> > > >                                   read_id);
> > > >          rq->cmd_len = scsi_command_size(rq->cmd);
> > > >  
> > > > -        if (blk_insert_cloned_request(q, req) != BLK_STS_OK)
> > > > -                return -EAGAIN;
> > > > +        blk_execute_rq_nowait(NULL, req, true, ufshpb_pre_req_compl_fn);
> > >  
> > > Be care with above change, blk_insert_cloned_request() allocates
> > > driver tag and issues the request to LLD directly, then returns the
> > > result. If anything fails in the code path, -EAGAIN is returned.
> > >  
> > > But blk_execute_rq_nowait() simply queued the request in block layer,
> > > and run hw queue. It doesn't allocate driver tag, and doesn't issue it
> > > to LLD.
> > >  
> > > So ufshpb_execute_pre_req() may think the pre-request is issued to LLD
> > > successfully, but actually not, maybe never. What will happen after the
> > > READ IO is issued to device, but the pre-request(write buffer) isn't
> > > sent to device?
> > 
> > In that case, the HPB READ cannot get benefit from pre-request. But it is not
> > common case.
>  
> OK, so the device will ignore the pre-request if it isn't received in
> time, not sure it is common or not, since blk_execute_rq_nowait()
> doesn't provide any feedback. Here looks blk_insert_cloned_request()
> is better.

Yor're right.

> > 
> > > Can you explain how this change solves the deadlock?
> > 
> > The deadlock is happen when the READ waiting allocation of pre-request. But
> > the timeout code makes to stop waiting after given time later.
>  
> If you mean blk-mq timeout code will be triggered, I think it won't.
> Meantime, LLD may see nothing to timeout too.

I mean timeout of the HPB code. Please refer following code:

if (!ufshpb_is_legacy(hba) &&
	ufshpb_is_required_wb(hpb, transfer_len)) {
	err = ufshpb_issue_pre_req(hpb, cmd, &read_id);
	if (err) {
		unsigned long timeout;

		timeout = cmd->jiffies_at_alloc + msecs_to_jiffies(
			  hpb->params.requeue_timeout_ms);

		if (time_before(jiffies, timeout))
			return -EAGAIN;

		hpb->stats.miss_cnt++;
		return 0;
	}
}

Although the return value of ufshpb_issue_pre_req() is -EAGAIN, the code
ignores the return value and issues READ not HPB READ.

Thanks,
Daejun
