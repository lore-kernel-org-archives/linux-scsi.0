Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7E1CC433E9
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 01:43:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC3E464FA7
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 01:43:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbhCQBnT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Mar 2021 21:43:19 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:56467 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbhCQBnB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Mar 2021 21:43:01 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210317014259epoutp01f9460cdd662bcc012f2531383e68c174~s-cLahPMC1100111001epoutp01p
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 01:42:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210317014259epoutp01f9460cdd662bcc012f2531383e68c174~s-cLahPMC1100111001epoutp01p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1615945379;
        bh=aLfJAbuiDPAlx+RD/6lBLEj/FwjdZZ+/0ra3YnK5HRI=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=mO4bHvbPAd/M1VchScw0ufMWyLDMZgq1p9d3SbrmvO1ssNfmeLQosBn2uVUWNgKYq
         rpoGLcP6hOfsLz/HU6SHxooUEma0nfdx96Lzi56a+cFe665O7t1sqZCiTXvFzrNkdA
         xE5NwehACKf3STT9ytF9j5AK4GxdPbrS8gpHB39Q=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20210317014256epcas2p1737b43acf8e410690333fd1adf9531a2~s-cIhx0GI3228832288epcas2p1r;
        Wed, 17 Mar 2021 01:42:56 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.187]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4F0Xwb1rpSz4x9QC; Wed, 17 Mar
        2021 01:42:55 +0000 (GMT)
X-AuditID: b6c32a45-34dff7000001297d-fa-60515e9f24fe
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        4E.D7.10621.F9E51506; Wed, 17 Mar 2021 10:42:55 +0900 (KST)
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
In-Reply-To: <a18909e8f4db023455b7513bf6c60312@codeaurora.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210317014253epcms2p1f45db6a281645282e1540e0070999d73@epcms2p1>
Date:   Wed, 17 Mar 2021 10:42:53 +0900
X-CMS-MailID: 20210317014253epcms2p1f45db6a281645282e1540e0070999d73
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDJsWRmVeSWpSXmKPExsWy7bCmue78uMAEgy/H2S0ezNvGZrG37QS7
        xcufV9ksDt9+x24x7cNPZotP65exWrw8pGmx6kG4RfPi9WwWc842MFn09m9ls3h85zO7xaIb
        25gs+v+1s1hc3jWHzaL7+g42i+XH/zFZ3N7CZbF0601Gi87pa1gcRDwuX/H2uNzXy+Sxc9Zd
        do8Jiw4weuyfu4bdo+XkfhaPj09vsXj0bVnF6PF5k5xH+4FupgCuqBybjNTElNQihdS85PyU
        zLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKDnlBTKEnNKgUIBicXFSvp2NkX5
        pSWpChn5xSW2SqkFKTkFhoYFesWJucWleel6yfm5VoYGBkamQJUJORkzD01iKrgvV7Ht2X+m
        BsYzYl2MHBwSAiYS0z9wdTFycQgJ7GCUeP3iMjtInFdAUOLvDuEuRk4OYQF7ia8btrGC2EIC
        ShLrL85ih4jrSdx6uIYRxGYT0JGYfuI+WFxEwFPi6+TVrCAzmQWWs0k0LtsP1iwhwCsxo/0p
        C4QtLbF9+VawZk4BO4nzK1rYIOIaEj+W9TJD2KISN1e/ZYex3x+bzwhhi0i03jsLVSMo8eDn
        bqi4pMSx3R+YIOx6ia13fjGCHCEh0MMocXjnLagj9CWudWwEO4JXwFdi6sMfTCAPswioSrw4
        nw5R4iKx9twXsHJmAXmJ7W/nMIOUMAtoSqzfpQ8JNmWJI7dYYL5q2PibHZ3NLMAn0XH4L1x8
        x7wnUJepSaz7uZ5pAqPyLERAz0KyaxbCrgWMzKsYxVILinPTU4uNCgyRo3YTIziZa7nuYJz8
        9oPeIUYmDsZDjBIczEoivKZ5AQlCvCmJlVWpRfnxRaU5qcWHGE2BnpzILCWanA/MJ3kl8Yam
        RmZmBpamFqZmRhZK4rzFBg/ihQTSE0tSs1NTC1KLYPqYODilGphOZvhbhvbPeHPgFPcjP++6
        +vD/c673Ty+vErG3LF9ZOkPI8mel462o1wbMx27dWnC9M7+zeq5F9eyClvY7F29o3zcxyYzZ
        aJ2Yu0yluf5Ei1SHUYZWvmPodS4+zYqwvPfs/37vjYs9FT7hpv3yWY3xWQsC5/E02RsZOP88
        56j1nfOuvFH0otv+ltduG2yJ7dBi6Xy0U02zJKD9oStzv9ELdv7bLEtEIry0FLfrP9C/lyxg
        us83vlHnfs6bif4Tln00WV+0/s//VW/4euv3m8RMKpo742CN9qWPHslfCjQWOrVyr3mvcs3b
        4dxD0z32Fo0/G9+35nVM2PD85Gvhn5Jm8/wl5JcXT9r9bGe8vBJLcUaioRZzUXEiAP/vW/lv
        BAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210315012850epcms2p361447b689e925561c48aa9ca54434eb5
References: <a18909e8f4db023455b7513bf6c60312@codeaurora.org>
        <2da1c963bd3ff5f682d18a251ed08989@codeaurora.org>
        <20210315012850epcms2p361447b689e925561c48aa9ca54434eb5@epcms2p3>
        <20210315013137epcms2p861f06e66be9faff32b6648401778434a@epcms2p8>
        <20210315070728epcms2p87136c86803afa85a441ead524130245c@epcms2p8>
        <d6a4511fd85e6e47c5aef22e335bb253@codeaurora.org>
        <CGME20210315012850epcms2p361447b689e925561c48aa9ca54434eb5@epcms2p1>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>On 2021-03-15 15:23, Can Guo wrote:
>> On 2021-03-15 15:07, Daejun Park wrote:
>>>>> This patch supports the HPB 2.0.
>>>>> 
>>>>> The HPB 2.0 supports read of varying sizes from 4KB to 512KB.
>>>>> In the case of Read (<= 32KB) is supported as single HPB read.
>>>>> In the case of Read (36KB ~ 512KB) is supported by as a combination 
>>>>> of
>>>>> write buffer command and HPB read command to deliver more PPN.
>>>>> The write buffer commands may not be issued immediately due to busy
>>>>> tags.
>>>>> To use HPB read more aggressively, the driver can requeue the write
>>>>> buffer
>>>>> command. The requeue threshold is implemented as timeout and can be
>>>>> modified with requeue_timeout_ms entry in sysfs.
>>>>> 
>>>>> Signed-off-by: Daejun Park <daejun7.park@samsung.com>
>>>>> ---
>>>>> +static struct attribute *hpb_dev_param_attrs[] = {
>>>>> +        &dev_attr_requeue_timeout_ms.attr,
>>>>> +        NULL,
>>>>> +};
>>>>> +
>>>>> +struct attribute_group ufs_sysfs_hpb_param_group = {
>>>>> +        .name = "hpb_param_sysfs",
>>>>> +        .attrs = hpb_dev_param_attrs,
>>>>> +};
>>>>> +
>>>>> +static int ufshpb_pre_req_mempool_init(struct ufshpb_lu *hpb)
>>>>> +{
>>>>> +        struct ufshpb_req *pre_req = NULL;
>>>>> +        int qd = hpb->sdev_ufs_lu->queue_depth / 2;
>>>>> +        int i, j;
>>>>> +
>>>>> +        INIT_LIST_HEAD(&hpb->lh_pre_req_free);
>>>>> +
>>>>> +        hpb->pre_req = kcalloc(qd, sizeof(struct ufshpb_req), 
>>>>> GFP_KERNEL);
>>>>> +        hpb->throttle_pre_req = qd;
>>>>> +        hpb->num_inflight_pre_req = 0;
>>>>> +
>>>>> +        if (!hpb->pre_req)
>>>>> +                goto release_mem;
>>>>> +
>>>>> +        for (i = 0; i < qd; i++) {
>>>>> +                pre_req = hpb->pre_req + i;
>>>>> +                INIT_LIST_HEAD(&pre_req->list_req);
>>>>> +                pre_req->req = NULL;
>>>>> +                pre_req->bio = NULL;
>>>> 
>>>> Why don't prepare bio as same as wb.m_page? Won't that save more time
>>>> for ufshpb_issue_pre_req()?
>>> 
>>> It is pre_req pool. So although we prepare bio at this time, it just
>>> only for first pre_req.
>> 
>> I meant removing the bio_alloc() in ufshpb_issue_pre_req() and 
>> bio_put()
>> in ufshpb_pre_req_compl_fn(). bios, in pre_req's case, just hold a 
>> page.
>> So, prepare 16 (if queue depth is 32) bios here, just use them along 
>> with
>> wb.m_page and call bio_reset() in ufshpb_pre_req_compl_fn(). Shall it 
>> work?
>> 
> 
>If it works, you can even have the bio_add_pc_page() called here. Later 
>in
>ufshpb_execute_pre_req(), you don't need to call 
>ufshpb_pre_req_add_bio_page(),
>just call ufshpb_prep_entry() once instead - it save many repeated steps 
>for a
>pre_req, and you don't even need to call bio_reset() in this case, since 
>for a
>bio, nothing changes after it is binded with a specific page...

Hi, Can Guo

I tried the idea that you suggested, but it doesn't work properly.
This optimization should be done next time for enhancement.

Thanks
Daejun

>Can Guo.
> 
>> Thanks,
>> Can Guo.
>> 
>>> After use it, it should be prepared bio at issue phase.
>>> 
>>> Thanks,
>>> Daejun
>>> 
>>>> 
>>>> Thanks,
>>>> Can Guo.
>>>> 
>>>>> +
>>>>> +                pre_req->wb.m_page = alloc_page(GFP_KERNEL | 
>>>>> __GFP_ZERO);
>>>>> +                if (!pre_req->wb.m_page) {
>>>>> +                        for (j = 0; j < i; j++)
>>>>> +                                
>>>>> __free_page(hpb->pre_req[j].wb.m_page);
>>>>> +
>>>>> +                        goto release_mem;
>>>>> +                }
>>>>> +                list_add_tail(&pre_req->list_req, 
>>>>> &hpb->lh_pre_req_free);
>>>>> +        }
>>>>> +
>>>>> +        return 0;
>>>>> +release_mem:
>>>>> +        kfree(hpb->pre_req);
>>>>> +        return -ENOMEM;
>>>>> +}
>>>>> +
>>>> 
>>>> 
>>>> 
> 
> 
>  
