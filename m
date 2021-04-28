Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29362C433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Apr 2021 00:37:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2FDD61402
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Apr 2021 00:37:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236224AbhD1AiB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 20:38:01 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:15138 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230460AbhD1Ah7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Apr 2021 20:37:59 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210428003713epoutp04c0c8273e1e5691c45555a20ab6bf0036~53ov5iTds1432214322epoutp047
        for <linux-scsi@vger.kernel.org>; Wed, 28 Apr 2021 00:37:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210428003713epoutp04c0c8273e1e5691c45555a20ab6bf0036~53ov5iTds1432214322epoutp047
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1619570233;
        bh=MyzbAvy2TEp0LhpPA5JdGl6Gnb8RzdSt8fE8YmMeFh0=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=iOwyY8d/uIJTI6hdjweUCDhBU0nlNaJ8cjPsxe9L7JFa8yFFxJA9gatxJfjevEdAg
         fAE0QWJEs6pGgqy8l+g2ynWEORlD+buSuQbv69/sMcMOGmks8PqCij/O8A3cepdkBN
         jb3yUE4eM77ha2wUXBXKdRWOCpNs15J0h0NP/b+Y=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210428003712epcas2p329b19bde528f1ec0ed8ae4fbb4313dce~53ou4AsRF3033430334epcas2p3X;
        Wed, 28 Apr 2021 00:37:12 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.183]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4FVKTK6tPzz4x9Q1; Wed, 28 Apr
        2021 00:37:09 +0000 (GMT)
X-AuditID: b6c32a46-e17ff700000025de-1e-6088ae350fc1
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        6C.7A.09694.53EA8806; Wed, 28 Apr 2021 09:37:09 +0900 (KST)
Mime-Version: 1.0
Subject: RE: RE: [PATCH v32 4/4] scsi: ufs: Add HPB 2.0 support
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
In-Reply-To: <BL0PR04MB6564B4E309188E320AB258E6FC479@BL0PR04MB6564.namprd04.prod.outlook.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210428003709epcms2p2e183e74e64b388d5feb5dd45396393dc@epcms2p2>
Date:   Wed, 28 Apr 2021 09:37:09 +0900
X-CMS-MailID: 20210428003709epcms2p2e183e74e64b388d5feb5dd45396393dc
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOJsWRmVeSWpSXmKPExsWy7bCmqa7puo4EgzPNZhYP5m1js9jbdoLd
        4uXPq2wW0z78ZLb4tH4Zq8XLQ5oWuw4eZLNY9SDconnxejaLOWcbmCx6+7eyWWw+uIHZ4vGd
        z+wWi25sY7Lo/9fOYrHts6DF8ZPvGC0u75rDZtF9fQebxfLj/5gslm69yWjROX0Ni4OYx+Ur
        3h6X+3qZPHbOusvuMWHRAUaP/XPXsHu0nNzP4vHx6S0Wj74tqxg9Pm+S82g/0M0UwBWVY5OR
        mpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkD9KaSQlliTilQ
        KCCxuFhJ386mKL+0JFUhI7+4xFYptSAlp8DQsECvODG3uDQvXS85P9fK0MDAyBSoMiEnY0nn
        E+aCTu6KuVv2sjYwfmHvYuTkkBAwkXj69gxbFyMXh5DADkaJxqUPgRwODl4BQYm/O4RBTGEB
        e4kTC8xAyoUElCTWX5wF1iosoCdx6+EaRhCbTUBHYvqJ++wgY0QEfjNLXHw7jRXEYRY4zyyx
        50Y7I8QyXokZ7U9ZIGxpie3Lt4LFOQViJT7PeAUV15D4sayXGcIWlbi5+i07jP3+2HyoOSIS
        rffOQtUISjz4uRsqLilxbPcHJgi7XmLrnV+MIEdICPQwShzeeYsVIqEvca1jI9gyXgFfie7e
        BjCbRUBV4vbjiewgH0sIuEjs+1gIEmYWkJfY/nYOM0iYWUBTYv0ufYgKZYkjt1hgvmrY+Jsd
        nc0swCfRcfgvXHzHvCdQl6lJrPu5nmkCo/IsREDPQrJrFsKuBYzMqxjFUguKc9NTi40KjJDj
        dhMjOMVrue1gnPL2g94hRiYOxkOMEhzMSiK8bLtaE4R4UxIrq1KL8uOLSnNSiw8xmgI9OZFZ
        SjQ5H5hl8kriDU2NzMwMLE0tTM2MLJTEeX+m1iUICaQnlqRmp6YWpBbB9DFxcEo1MG3UcOB6
        fqTxyi+LrUqPHu6wu/a+Y1OL4VJxu6UPzh8qUDtmk3zDc0lw7LlDStxGH3fv9qk4f39TnYj5
        ipM8T148i1g6+UBywc1JKc2Ls5/9XmygmP41pSTjOseWzuCntau8eoOc+1/WB2orKC8NOOe1
        g99GVMejsXrnTLaNDuwueyYXfDxx6NLGBFYFFtGgDtVZjrc0F5pqRNSrWi+w0pOOPCu+YrtT
        p5VE1sruNYxXLFeFc8utMTt/kPcb541TgdPe9p4JfNgd+JfT5NATz5VJmf84Z5dvnScwuSFT
        Za5yfMfqWIMn51PcnlysOvX8esa5yfysIhyaWfOVWr/7PWvz7frAd7jqZ0TluQW72pVYijMS
        DbWYi4oTAaDebnJ6BAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210331011526epcms2p37684869a9781d1eb45bfcbfe9babd217
References: <BL0PR04MB6564B4E309188E320AB258E6FC479@BL0PR04MB6564.namprd04.prod.outlook.com>
        <20210331011526epcms2p37684869a9781d1eb45bfcbfe9babd217@epcms2p3>
        <20210331011839epcms2p45d3d059fcd9e85a548014a79c3f388bc@epcms2p4>
        <CGME20210331011526epcms2p37684869a9781d1eb45bfcbfe9babd217@epcms2p2>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Avri,

>> @@ -1653,6 +2148,7 @@ void ufshpb_destroy_lu(struct ufs_hba *hba, struct
>> scsi_device *sdev)
>> 
>>         ufshpb_cancel_jobs(hpb);
>> 
>> +       ufshpb_pre_req_mempool_destroy(hpb);
>>         ufshpb_destroy_region_tbl(hpb);
>> 
>>         kmem_cache_destroy(hpb->map_req_cache);
>> @@ -1692,6 +2188,7 @@ static void ufshpb_hpb_lu_prepared(struct ufs_hba
>> *hba)
>>                         ufshpb_set_state(hpb, HPB_PRESENT);
>>                         if ((hpb->lu_pinned_end - hpb->lu_pinned_start) > 0)
>>                                 queue_work(ufshpb_wq, &hpb->map_work);
>> +                       ufshpb_issue_umap_all_req(hpb);
>>                 } else {
>>                         dev_err(hba->dev, "destroy HPB lu %d\n", hpb->lun);
>>                         ufshpb_destroy_lu(hba, sdev);
>Here in lu_prepare, ufshpb_remove can be called without destroy_lu,
>and while there are jobs running.

If init_success is false, ufshpb_destroy_lu and ufshpb_remove are called.
If init_success is true, ufshpb_destroy_lu and ufshpb_remove are not called
in this function.

So I think it is not problem.

Thanks,
Daejun

>How about calling destroy_lu as part of ufshpb_remove?
>Calling it again when __scsi_remove_device, hostdata is already null so it won't matter.
> 
>Again, only after we know where all this is going to.
> 
>Thanks,
>Avri
> 
> 
>  
