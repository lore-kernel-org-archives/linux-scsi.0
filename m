Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25710C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 01:50:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DED661039
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 01:50:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbhJ2BxH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Oct 2021 21:53:07 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:16642 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231463AbhJ2BxH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Oct 2021 21:53:07 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20211029015037epoutp01ad7e9f86848ca26f36aa24c9903765d5~yXVXF0S6n0429704297epoutp01U
        for <linux-scsi@vger.kernel.org>; Fri, 29 Oct 2021 01:50:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20211029015037epoutp01ad7e9f86848ca26f36aa24c9903765d5~yXVXF0S6n0429704297epoutp01U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1635472237;
        bh=eHo6lGrsCqsaUiVhVVo8v2uZ3Ts+zCHxdun5/3sbIJI=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=OQVhQGozV0nowhULdSLT/HGDlXjpVn2W1Ys18qVxJVnIVUTGwusVqfDC57GBTdOR5
         OCH67Br9l22kHikqa6KVxCrApw08NpHZ9xZv6qA1Ek3EvK8CK8GzBy/hwC8RB8Rgob
         AQm8zWgG0ZV8qgAqRaGWSMXaCzA6WJ3x09X3wJO8=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20211029015037epcas2p1d3cc31a2d575ac538786ece9bc9fe47b~yXVWhWd4n1145311453epcas2p1c;
        Fri, 29 Oct 2021 01:50:37 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.36.88]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4HgQNs4w6kz4x9Qp; Fri, 29 Oct
        2021 01:50:21 +0000 (GMT)
X-AuditID: b6c32a46-a25ff70000002722-50-617b53587643
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        68.97.10018.8535B716; Fri, 29 Oct 2021 10:50:16 +0900 (KST)
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
In-Reply-To: <YXtPNIDzeln8zBCn@T590>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20211029015015epcms2p3a46e0779e43ab84c00388d99abf3b867@epcms2p3>
Date:   Fri, 29 Oct 2021 10:50:15 +0900
X-CMS-MailID: 20211029015015epcms2p3a46e0779e43ab84c00388d99abf3b867
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDJsWRmVeSWpSXmKPExsWy7bCmmW5EcHWiwZ8twhYP5m1js3j58yqb
        xbQPP5ktXh7StFj1INxiztkGJotFN7YxWRw/+Y7R4vKuOWwW3dd3sFksP/6PyeLQ5GYmBx6P
        y1e8PXbOusvuMWHRAUaPj09vsXi833eVzaNvyypGj8+b5DzaD3QzBXBEZdtkpCampBYppOYl
        56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAN2qpFCWmFMKFApILC5W0rez
        KcovLUlVyMgvLrFVSi1IySkwL9ArTswtLs1L18tLLbEyNDAwMgUqTMjOmHCghbXgp3DFhreH
        GBsYT/F3MXJySAiYSOyasZWti5GLQ0hgB6PEhp8vgRwODl4BQYm/O4RBaoQF3CSWr5rECGIL
        CShJrL84ix0iridx6+EasDibgI7E9BP3weIiAl4SG56tZASZySxwgFni+Nw3bBDLeCVmtD9l
        gbClJbYv3wrWzCmgIjH38nRmiLiGxI9lvVC2qMTN1W/ZYez3x+YzQtgiEq33zkLVCEo8+Lkb
        Ki4pcWz3ByYIu15i651fYEdICPQwShzeeYsVIqEvca1jI9gRvAK+EvM2PANrYBFQlXje/x3q
        OBeJdR+eg9nMAvIS29/OYQYFCrOApsT6XfogpoSAssSRWywwbzVs/M2OzmYW4JPoOPwXLr5j
        3hOo09Qk1v1czzSBUXkWIqRnIdk1C2HXAkbmVYxiqQXFuempxUYFRvDITc7P3cQITrZabjsY
        p7z9oHeIkYmD8RCjBAezkgjv5XnliUK8KYmVValF+fFFpTmpxYcYTYG+nMgsJZqcD0z3eSXx
        hiaWBiZmZobmRqYG5krivJai2YlCAumJJanZqakFqUUwfUwcnFINTDsfLvyp2pKofXbe+X+q
        sm21h/Iz40+/iN7yj6HYsXiK17MTj3XSZdZpie9d7mhpWyHA9MzOa5Xhr59fajbZ/9K1ebXz
        ziu3k8IMJ/gqfyT2L/zQ9Y9XlLs5TCzo5Je87blbRN/fmO9w9tR/0d9cf9oWX5nw4S23oYea
        67dj/s8jkxzy4g37Hlg/DJTWPngssTdKb8NCx69chbeKHlpnPtm3zKvN8PXeHYk8/c57Nv5k
        rWbIK6kteXTHZseJ9wf/nv6Ufu1jSb342bVdDl+PpJ5Sm6AXci1+t2pk8OIM3x71xNT0J7N0
        DIuKmHd/+xG2Rsnc86zl0VPbEu+9zmeYvqxg8YkGpbS/z99O67HhNVZiKc5INNRiLipOBAAx
        TnyZPwQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211027223619epcms2p60bbc74c9ba9757c58709a99acd0892ff
References: <YXtPNIDzeln8zBCn@T590>
        <20211027223619epcms2p60bbc74c9ba9757c58709a99acd0892ff@epcms2p6>
        <CGME20211027223619epcms2p60bbc74c9ba9757c58709a99acd0892ff@epcms2p3>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> On Thu, Oct 28, 2021 at 07:36:19AM +0900, Daejun Park wrote:
> > This patch addresses the issue of using the wrong API to create a
> > pre_request for HPB READ.
> > HPB READ candidate that require a pre-request will try to allocate a
> > pre-request only during request_timeout_ms (default: 0). Otherwise, it is
>  
> Can you explain about 'only during request_timeout_ms'?
>  
> From the following code in ufshpb_prep(), the pre-request is allocated
> for each READ IO in case of (!ufshpb_is_legacy(hba) && ufshpb_is_required_wb(hpb,
> transfer_len)).
>  
>    if (!ufshpb_is_legacy(hba) &&
>             ufshpb_is_required_wb(hpb, transfer_len)) {
>                 err = ufshpb_issue_pre_req(hpb, cmd, &read_id);
>  
> > passed as normal READ, so deadlock problem can be resolved.
> > 
> > Signed-off-by: Daejun Park <daejun7.park@samsung.com>
> > ---
> >  drivers/scsi/ufs/ufshpb.c | 11 +++++------
> >  drivers/scsi/ufs/ufshpb.h |  1 +
> >  2 files changed, 6 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
> > index 02fb51ae8b25..3117bd47d762 100644
> > --- a/drivers/scsi/ufs/ufshpb.c
> > +++ b/drivers/scsi/ufs/ufshpb.c
> > @@ -548,8 +548,7 @@ static int ufshpb_execute_pre_req(struct ufshpb_lu *hpb, struct scsi_cmnd *cmd,
> >                                   read_id);
> >          rq->cmd_len = scsi_command_size(rq->cmd);
> >  
> > -        if (blk_insert_cloned_request(q, req) != BLK_STS_OK)
> > -                return -EAGAIN;
> > +        blk_execute_rq_nowait(NULL, req, true, ufshpb_pre_req_compl_fn);
>  
> Be care with above change, blk_insert_cloned_request() allocates
> driver tag and issues the request to LLD directly, then returns the
> result. If anything fails in the code path, -EAGAIN is returned.
>  
> But blk_execute_rq_nowait() simply queued the request in block layer,
> and run hw queue. It doesn't allocate driver tag, and doesn't issue it
> to LLD.
>  
> So ufshpb_execute_pre_req() may think the pre-request is issued to LLD
> successfully, but actually not, maybe never. What will happen after the
> READ IO is issued to device, but the pre-request(write buffer) isn't
> sent to device?

In that case, the HPB READ cannot get benefit from pre-request. But it is not
common case.

> Can you explain how this change solves the deadlock?

The deadlock is happen when the READ waiting allocation of pre-request. But
the timeout code makes to stop waiting after given time later.

Thanks,
Daejun
