Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3B56C47096
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 01:11:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DB6B6140C
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 01:11:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbhFDBNQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Jun 2021 21:13:16 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:24580 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbhFDBNP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jun 2021 21:13:15 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210604011128epoutp01be35894eb432d0c9290a21ed69fbdd1c~FO_Nu22gJ0526305263epoutp01h
        for <linux-scsi@vger.kernel.org>; Fri,  4 Jun 2021 01:11:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210604011128epoutp01be35894eb432d0c9290a21ed69fbdd1c~FO_Nu22gJ0526305263epoutp01h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1622769088;
        bh=LRUiLiX4cSKymfrziHeHmnueGFkCDFslCiYp2VNfNeg=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=pMlAKXBvDh6LLPQiwZU++Jlvot5S/XeVjzswZISqpfLzfqFy3glrNclt7eC9EmXlY
         JmWoDtEYxhXt5T5LLn4y5bSvjMbP0CnWmZtBEG0O1y2ngx1Q17YUjCXpV9q3aRzdUI
         JF7KfQDtcPHFz2HuxC9/dknGq64+gyDokaMrh+8U=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210604011127epcas2p4084ff7c128d4b5c98a4edfa6d94cb26b~FO_Mg4VSv3003830038epcas2p4A;
        Fri,  4 Jun 2021 01:11:27 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.181]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4Fx4Tn3Htwz4x9Q3; Fri,  4 Jun
        2021 01:11:25 +0000 (GMT)
X-AuditID: b6c32a48-4fbff700000025f5-6b-60b97dbdc9bd
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        5F.EF.09717.DBD79B06; Fri,  4 Jun 2021 10:11:25 +0900 (KST)
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
In-Reply-To: <12392bef-e018-8260-5279-16b7b43f5a8f@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210604011124epcms2p39a466db169ebbfd2c889e25fba9aa0b4@epcms2p3>
Date:   Fri, 04 Jun 2021 10:11:24 +0900
X-CMS-MailID: 20210604011124epcms2p39a466db169ebbfd2c889e25fba9aa0b4
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJJsWRmVeSWpSXmKPExsWy7bCmqe7e2p0JBo+msFo8mLeNzWJv2wl2
        i5c/r7JZTPvwk9ni0/plrBYvD2la7Dp4kM1i1YNwi+bF69ks5pxtYLLo7d/KZrH54AZmi8d3
        PrNbLLqxjcmi/187i8W2z4IWx0++Y7S4vGsOm0X39R1sFsuP/2OyWLr1JqNF5/Q1LA5iHpev
        eHtc7utl8tg56y67x4RFBxg99s9dw+7RcnI/i8fHp7dYPPq2rGL0+LxJzqP9QDdTAFdUjk1G
        amJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0JtKCmWJOaVA
        oYDE4mIlfTubovzSklSFjPziElul1IKUnAJDwwK94sTc4tK8dL3k/FwrQwMDI1OgyoScjN7D
        J1gKrnFVLL/3mbWBsYeji5GTQ0LARKKxYRJLFyMXh5DADkaJH9cWsXcxcnDwCghK/N0hDFIj
        LBAi8fv+HTYQW0hASWL9xVnsEHE9iVsP1zCC2GwCOhLTT9xnB5kjItDEIrHz8FuwocwC55kl
        9txoZ4TYxisxo/0pC4QtLbF9+VawOKeAtcSDO0dYIeIaEj+W9TJD2KISN1e/ZYex3x+bDzVH
        RKL13lmoGkGJBz93Q8UlJY7t/sAEYddLbL3zixHkCAmBHkaJwztvQS3Ql7jWsRHsCF4BX4ml
        aw+CDWIRUJWY9GI7VLOLxJ0LE8BsZgF5ie1v5zCDQoVZQFNi/S59EFNCQFniyC0WmLcaNv5m
        R2czC/BJdBz+CxffMe8J1HQ1iXU/1zNNYFSehQjqWUh2zULYtYCReRWjWGpBcW56arFRgQly
        7G5iBKd5LY8djLPfftA7xMjEwXiIUYKDWUmEd4/ajgQh3pTEyqrUovz4otKc1OJDjKZAX05k
        lhJNzgdmmrySeENTIzMzA0tTC1MzIwslcd6fqXUJQgLpiSWp2ampBalFMH1MHJxSDUzs/L3z
        wtXNBLd1Nn2yTI+RXm9d9/j748c/rJZmNG19Xmue4Zl/WqVm1XHHf2/r/etYOL9yRLdXn+C7
        9rfArE9qh/Zd7wVrjKRXaP+7/dgxZsO2EtsT+Qd13j+6FD75nb7lxvJNizLKD4q6td3svsL/
        lHv7rKw0F2OHeRWzyz7xnO7Wk/G48iN9p9ixuYbdF40OvZn7eJfUHLGADY/V/+2/6x/80Wbx
        fPtD269eEpimnbDe8MS5RW3TvLc/P2OZEhe1e7F0DvvfG+EbfKr5FeoXvq25F/j9Z4hN4s8z
        14+scdC/tnV9zoUpb+903M4sneIr9fTyt5nHSwLULdSajzge+JsSrBpwzUV84p+VT40nKrEU
        ZyQaajEXFScCAMPpsY18BAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210524084345epcms2p63dde85f3fdc127c29d25ada7d7f539cb
References: <12392bef-e018-8260-5279-16b7b43f5a8f@acm.org>
        <20210524084345epcms2p63dde85f3fdc127c29d25ada7d7f539cb@epcms2p6>
        <20210524084546epcms2p2c91dc1df482fd593307892825532c6dd@epcms2p2>
        <CGME20210524084345epcms2p63dde85f3fdc127c29d25ada7d7f539cb@epcms2p3>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

>> +static void
>> +ufshpb_set_hpb_read_to_upiu(struct ufshpb_lu *hpb, struct ufshcd_lrb *lrbp,
>> +                            u32 lpn, u64 ppn, u8 transfer_len)
>> +{
>> +        unsigned char *cdb = lrbp->cmd->cmnd;
>> +
>> +        cdb[0] = UFSHPB_READ;
>> +
>> +        /* ppn value is stored as big-endian in the host memory */
> 
>I think that that comment means that the type of the 'ppn' argument
>should be changed from 'u64' into __be64.

OK, I will change it.

> 
>> +        memcpy(&cdb[6], &ppn, sizeof(__be64));
>> +        cdb[14] = transfer_len;
>> +
>> +        lrbp->cmd->cmd_len = UFS_CDB_SIZE;
>> +}
>> +
>> +/*
>> + * This function will set up HPB read command using host-side L2P map data.
>> + * In HPB v1.0, maximum size of HPB read command is 4KB.
>> + */
>> +void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
>> +{
>[ ... ]
>> +
>> +        ufshpb_set_hpb_read_to_upiu(hpb, lrbp, lpn, ppn, transfer_len);
> 
>'transfer_len' has type int and is truncated to type 'u8' when passed as
>an argument to ufshpb_set_hpb_read_to_upiu(). Please handle transfer_len
>values >= 256 properly.

Before entering the function, ufshpb_is_supported_chunk() checks whether
transfer_len <= hpb->pre_req_max_tr_len which is set to
HPB_MULTI_CHUNK_HIGH (128) on initalization.

Thanks,
Daejun
