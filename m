Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7D21C433E9
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Mar 2021 07:08:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9558364E6C
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Mar 2021 07:08:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbhCOHH7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Mar 2021 03:07:59 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:51385 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbhCOHHd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Mar 2021 03:07:33 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210315070731epoutp02965ac5b8b8554e188987338531ddbdd4~sck9XW3RE2939629396epoutp02i
        for <linux-scsi@vger.kernel.org>; Mon, 15 Mar 2021 07:07:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210315070731epoutp02965ac5b8b8554e188987338531ddbdd4~sck9XW3RE2939629396epoutp02i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1615792051;
        bh=TDL/0xmZeCwq9eL4cssseC+KS9L28vgGn3FnFLDSSOY=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=bVz15ghoT1cLBiybtMFolsUX+Sq29xK49BfpPkkeSm6YMrMXOxYN7edfZMD5U9WMH
         3k/TvYX8fGmIFP29uy+aaVGtOqHuyqXBDO67yVsiFX5A+yYovDqJ6ritbUO+JvSAIp
         Og17AWUSoTNxxhc/0kZJokH/bLMtYCG/63VjPEOI=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210315070730epcas2p389b5beb74012f958ecabfc50be60db1f~sck8tUhAF1054010540epcas2p3n;
        Mon, 15 Mar 2021 07:07:30 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.185]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4DzSD11Mpjz4x9Q3; Mon, 15 Mar
        2021 07:07:29 +0000 (GMT)
X-AuditID: b6c32a46-1d9ff7000000dbf8-1b-604f07b1d649
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        5E.1D.56312.1B70F406; Mon, 15 Mar 2021 16:07:29 +0900 (KST)
Mime-Version: 1.0
Subject: RE: Re: [PATCH v29 4/4] scsi: ufs: Add HPB 2.0 support
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
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <2da1c963bd3ff5f682d18a251ed08989@codeaurora.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210315070728epcms2p87136c86803afa85a441ead524130245c@epcms2p8>
Date:   Mon, 15 Mar 2021 16:07:28 +0900
X-CMS-MailID: 20210315070728epcms2p87136c86803afa85a441ead524130245c
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBLsWRmVeSWpSXmKPExsWy7bCmqe5Gdv8Eg/YD7BYP5m1js9jbdoLd
        4uXPq2wWh2+/Y7eY9uEns8Wn9ctYLV4e0rRY9SDconnxejaLOWcbmCx6+7eyWTy+85ndYtGN
        bUwW/f/aWSwu75rDZtF9fQebxfLj/5gsbm/hsli69SajRef0NSwOIh6Xr3h7XO7rZfLYOesu
        u8eERQcYPfbPXcPu0XJyP4vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBXVAOjTWJRckZmWapCal5y
        fkpmXrqtUmiIm66FkkJGfnGJrVK0oYWRnqGlqZ6JpZ6ReayVoYGBkamSQl5ibqqtUoUuVLeS
        QlFyAVB1SWpxSVFqcipQqMihuCQxPVWvODG3uDQvXS85P1dJoSwxpxSoT0nfziYjNTEltUgh
        4Qljxt4bU1gKFolUvHh7nrGBsYOvi5GTQ0LARGLzjJ8sXYxcHEICOxglei5OZO9i5ODgFRCU
        +LtDGKRGWMBe4uuGbawgtpCAksT6i7PYIeJ6ErcermEEsdkEdCSmn7gPFhcR8JT4Onk1K8hM
        ZoHlbBKNy/azQizjlZjR/pQFwpaW2L58K1gzp4CdxMOjZ5gh4hoSP5b1QtmiEjdXv2WHsd8f
        m88IYYtItN47C1UjKPHg526ouKTEsd0fmCDseomtd34xghwhIdDDKHF45y2oI/QlrnVsBDuC
        V8BXYtX0v2ALWARUJfomLmUGeV5CwEXiy8lqkDCzgLzE9rdzwMLMApoS63fpQ1QoSxy5xQLz
        VcPG3+zobGYBPomOw3/h4jvmPYG6TE1i3c/1TBMYlWchAnoWkl2zEHYtYGRexSiWWlCcm55a
        bFRghBzPmxjBqV/LbQfjlLcf9A4xMnEwHmKU4GBWEuH9rOObIMSbklhZlVqUH19UmpNafIix
        CujJicxSosn5wOyTVxJvaGZgZGZqbGJsbGpiSrawqZGZmYGlqYWpmZGFkjhvscGDeCGB9MSS
        1OzU1ILUIpjlTBycUg1MTif2PGlVmsAQJzVjSbuEUxmzYcDt9dp/69dmPqiaInfI8e6mmfFt
        dwMMz4o+Mp2V9eTeIrHEOw43xaZP4la/XvbqRnVyyWvth6Ir/rsecG0VDl28x786Ujvr4R3n
        B06nwv/6GkglzGCzOCBYsyFujvqrtYFHo/pKNP37PE99ddrhetHrbZNrjK0/F6+I552GXz63
        JFsbLede/aWgeCV1o6phczDjrbfvP0u8Pv3ZeLrhDZW+sBczQhW7dAPur5nfdTLC0+WF58tp
        X9w4/GuOSEp3r8rJfDO35Pd26fOtnnNn165k1/RyN5NXY3VM43/DuDlcinfqda8YPdP3DyI8
        /z2Y+fr3BZWvHCa9ZXpKLMUZiYZazEXFiQD7fcKkywQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210315012850epcms2p361447b689e925561c48aa9ca54434eb5
References: <2da1c963bd3ff5f682d18a251ed08989@codeaurora.org>
        <20210315012850epcms2p361447b689e925561c48aa9ca54434eb5@epcms2p3>
        <20210315013137epcms2p861f06e66be9faff32b6648401778434a@epcms2p8>
        <CGME20210315012850epcms2p361447b689e925561c48aa9ca54434eb5@epcms2p8>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>> This patch supports the HPB 2.0.
>> 
>> The HPB 2.0 supports read of varying sizes from 4KB to 512KB.
>> In the case of Read (<= 32KB) is supported as single HPB read.
>> In the case of Read (36KB ~ 512KB) is supported by as a combination of
>> write buffer command and HPB read command to deliver more PPN.
>> The write buffer commands may not be issued immediately due to busy 
>> tags.
>> To use HPB read more aggressively, the driver can requeue the write 
>> buffer
>> command. The requeue threshold is implemented as timeout and can be
>> modified with requeue_timeout_ms entry in sysfs.
>> 
>> Signed-off-by: Daejun Park <daejun7.park@samsung.com>
>> ---
>> +static struct attribute *hpb_dev_param_attrs[] = {
>> +        &dev_attr_requeue_timeout_ms.attr,
>> +        NULL,
>> +};
>> +
>> +struct attribute_group ufs_sysfs_hpb_param_group = {
>> +        .name = "hpb_param_sysfs",
>> +        .attrs = hpb_dev_param_attrs,
>> +};
>> +
>> +static int ufshpb_pre_req_mempool_init(struct ufshpb_lu *hpb)
>> +{
>> +        struct ufshpb_req *pre_req = NULL;
>> +        int qd = hpb->sdev_ufs_lu->queue_depth / 2;
>> +        int i, j;
>> +
>> +        INIT_LIST_HEAD(&hpb->lh_pre_req_free);
>> +
>> +        hpb->pre_req = kcalloc(qd, sizeof(struct ufshpb_req), GFP_KERNEL);
>> +        hpb->throttle_pre_req = qd;
>> +        hpb->num_inflight_pre_req = 0;
>> +
>> +        if (!hpb->pre_req)
>> +                goto release_mem;
>> +
>> +        for (i = 0; i < qd; i++) {
>> +                pre_req = hpb->pre_req + i;
>> +                INIT_LIST_HEAD(&pre_req->list_req);
>> +                pre_req->req = NULL;
>> +                pre_req->bio = NULL;
> 
>Why don't prepare bio as same as wb.m_page? Won't that save more time
>for ufshpb_issue_pre_req()?

It is pre_req pool. So although we prepare bio at this time, it just only for first pre_req.
After use it, it should be prepared bio at issue phase.

Thanks,
Daejun

> 
>Thanks,
>Can Guo.
> 
>> +
>> +                pre_req->wb.m_page = alloc_page(GFP_KERNEL | __GFP_ZERO);
>> +                if (!pre_req->wb.m_page) {
>> +                        for (j = 0; j < i; j++)
>> +                                __free_page(hpb->pre_req[j].wb.m_page);
>> +
>> +                        goto release_mem;
>> +                }
>> +                list_add_tail(&pre_req->list_req, &hpb->lh_pre_req_free);
>> +        }
>> +
>> +        return 0;
>> +release_mem:
>> +        kfree(hpb->pre_req);
>> +        return -ENOMEM;
>> +}
>> +
> 
> 
>  
