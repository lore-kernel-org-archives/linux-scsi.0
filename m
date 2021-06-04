Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A105AC4708F
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 04:06:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CE8E61078
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 04:06:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbhFDEI2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Jun 2021 00:08:28 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:64563 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbhFDEI1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jun 2021 00:08:27 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210604040640epoutp01a6d32183c9781eecebe22a9b116acddc~FRXLf6uy61943319433epoutp014
        for <linux-scsi@vger.kernel.org>; Fri,  4 Jun 2021 04:06:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210604040640epoutp01a6d32183c9781eecebe22a9b116acddc~FRXLf6uy61943319433epoutp014
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1622779600;
        bh=uGYoBs1H20g7voD4bG564WPjR6hSkS1XhBtI4UMg76w=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=cUNovKDk+1+JLHTYuzMCBseWTeNlwStcf2qudIHeRnjfv1urEysGzx2kwTGIR1IBC
         3FUZVly/fTvBRGNC++j+ORxcH951bM4N8ADE3hSt8zg3haiPXRg6AvTg9KVhc/7+Zc
         e1RFUDv4iMdGuAZe6C0w7uZQIvVJuVY3EXfkRveg=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210604040639epcas2p42b15f2f9de2bb703478c991d9aefcfab~FRXKxrX0w0482404824epcas2p49;
        Fri,  4 Jun 2021 04:06:39 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.191]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4Fx8Mw6JPXz4x9Q7; Fri,  4 Jun
        2021 04:06:36 +0000 (GMT)
X-AuditID: b6c32a48-4fbff700000025f5-44-60b9a6ccc11e
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        43.ED.09717.CC6A9B06; Fri,  4 Jun 2021 13:06:36 +0900 (KST)
Mime-Version: 1.0
Subject: RE: Re: [PATCH v35 3/4] scsi: ufs: Prepare HPB read for cached
 sub-region
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Daejun Park <daejun7.park@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Dukhyun Kwon <d_hyun.kwon@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Jaemyung Lee <jaemyung.lee@samsung.com>,
        Jieon Seol <jieon.seol@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <4bf317c8-4c74-2207-95e2-34c59b14c454@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210604040636epcms2p7bcf940a2cd060336f79250de0060e08c@epcms2p7>
Date:   Fri, 04 Jun 2021 13:06:36 +0900
X-CMS-MailID: 20210604040636epcms2p7bcf940a2cd060336f79250de0060e08c
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA12Te0xbVRzHc3ovtxdMzaU8PGLcWNEFxqMPuewMYW4OzMWpIRnRZMbRG3ql
        zNLWPnzhlMjGUx6SbLCOx0RkWyUytrW0PBy0kzEz2Hgpq7wmEsWECfLP6mSTPnCL/33yPd9z
        ft/f75xDYsIlIoLMUxs4nZpViYgg3OqMoeOvt9nlkqVlCZpvshKor3iIj5bckwQ6seLG0F8d
        bQFoyRGDugcGCGSefwMVfdVBoIbhQh6qrLYQ6OLAeQwtTK/xUcuUlYeq75fgyLoWjK5euwPQ
        eHcDgSp+shHozNX7PPS15RZAZXXt+J5wZnxiPzNeVclj7KYZPlPT0g+Yy43tfObotcs4s7ro
        wpmqS2bArF3YwpT0V/Aygw6qUpQcq+B0kZw6R6PIU+emivYfyN6XTSdJpPHSXWinKFLN5nOp
        orRXMuNfylNttCmKfI9VGTekTFavF4l3p+g0RgMXqdToDakiTqtQaaVSbYKezdcb1bkJOZr8
        ZKlEIqM3nHKV8qSzFtdO8D+4WbuKF4ITRDkIJCGVCL+/PomXgyBSSNkAPFtYBMoBSQqoYLhu
        C/F4QqgseG9u2usXUiLYMWri+/QE6LrdDjxMUHGwbmiO7zknlPoMh3bnsvdQjLqBwd6pEuCr
        JoD1JYu4j5+CXWcsXj2Qeh6Wmef8nmh4t60S83EYvPXNMn+T/xxs9ntC4bHZYb8nGM67e/z6
        k3CwZ4Xn40+hZfpv4AkBqc8BdNpdAb4FMfyxtNMbQkC9Cq21Di/j1LNworXRHy4NNlvKvIxR
        W2HXcgPmmQpGxcCObrEHIRUFr7jwzbYKO+/x/88Y9Tgsda7/p9uafvVH2w6/dXfwakCU6eGo
        TY/UMj2sdRpgZhDOafX5uZxepk189HYvAO+b38HYwKnllQQH4JHAASCJiUIFvdttcqFAwX74
        EafTZOuMKk7vAPRGl19gEWE5mo1PozZkS2lZUpJkF43oJBkSPSFwc5/IhVQua+De4Tgtp9vc
        xyMDIwp5Awtszz/RucdmhKbxB6d+SAmradHJwgUPwo9s6x3PWh1uVPa/uwgmE8RBamWP/Jm+
        WeOe+JGst75rXriSPhyWc2D9NDsnLhi50zrGkfWlU8at9X/07G5X9P1c+vri/C+ZT5u37b3E
        hIgLzPRvFfNjOw9l1GUfkVaZpuDZ5LLzc/myqb0lC50ZBPXm8cCiyC8dbzP9KfbXXKNxeZMW
        zaorlgiI7TLQg31jz8XSs4fDjzuPmlsOxrwoOBn9cvQL+L6l3wceKyv+eIFx3062KqoE5+QX
        tTlRW26k3y06fE76flWgcrCh+JCzWmuJ61cOybXRZPpIaOtoBlVAp9lvNs0kEiJcr2SlOzCd
        nv0XHi4c/3wEAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210524084345epcms2p63dde85f3fdc127c29d25ada7d7f539cb
References: <4bf317c8-4c74-2207-95e2-34c59b14c454@acm.org>
        <12392bef-e018-8260-5279-16b7b43f5a8f@acm.org>
        <20210524084345epcms2p63dde85f3fdc127c29d25ada7d7f539cb@epcms2p6>
        <20210524084546epcms2p2c91dc1df482fd593307892825532c6dd@epcms2p2>
        <20210604011124epcms2p39a466db169ebbfd2c889e25fba9aa0b4@epcms2p3>
        <CGME20210524084345epcms2p63dde85f3fdc127c29d25ada7d7f539cb@epcms2p7>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>>> +/*
>>>> + * This function will set up HPB read command using host-side L2P map data.
>>>> + * In HPB v1.0, maximum size of HPB read command is 4KB.
>>>> + */
>>>> +void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
>>>> +{
>>> [ ... ]
>>>> +
>>>> +        ufshpb_set_hpb_read_to_upiu(hpb, lrbp, lpn, ppn, transfer_len);
>>>
>>> 'transfer_len' has type int and is truncated to type 'u8' when passed as
>>> an argument to ufshpb_set_hpb_read_to_upiu(). Please handle transfer_len
>>> values >= 256 properly.
>> 
>> Before entering the function, ufshpb_is_supported_chunk() checks whether
>> transfer_len <= hpb->pre_req_max_tr_len which is set to
>> HPB_MULTI_CHUNK_HIGH (128) on initalization.
> 
>How about adding a WARN_ON_ONCE() in ufshpb_prep() that verifies that
>transfer_len is <= HPB_MULTI_CHUNK_HIGH?

Sure, I will add WARN_ON_ONCE() just after calling ufshpb_is_supported_chunk().

Thanks

> 
>Thanks,
> 
>Bart.
> 
> 
>  
