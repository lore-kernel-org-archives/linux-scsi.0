Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3D4DC433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 05:38:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA321619B1
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 05:38:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbhCWFhq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Mar 2021 01:37:46 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:14628 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbhCWFhh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Mar 2021 01:37:37 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210323053735epoutp034911f92549c126b2d29a394296b20c2f~u4guDf8QT1742117421epoutp03M
        for <linux-scsi@vger.kernel.org>; Tue, 23 Mar 2021 05:37:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210323053735epoutp034911f92549c126b2d29a394296b20c2f~u4guDf8QT1742117421epoutp03M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1616477855;
        bh=uyzlbgbXw381TKZi8Ui8NC3M6tr5mvhpMRk8Yzi6zI0=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=LQZYcBabaYYiUFSZmc2wU1p+GcRS5/jqJtNhaU1gFA5wFbni3fXR1u2G19aZ95ASw
         K3jE5CvoFDIbPDopRg60ZDsJDeiAPE32DzeF7d0/xATltNbRm250Gyz4DjQyqKOqBT
         tXmFbDt5cFPFH7iLdLQ0DfjU0TwZBaeUw4e1at18=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210323053734epcas2p3abb59e35e5052ef078a7d22f798f5e29~u4gtQZIKp0174801748epcas2p35;
        Tue, 23 Mar 2021 05:37:34 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.183]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4F4KrX17MJz4x9Q7; Tue, 23 Mar
        2021 05:37:32 +0000 (GMT)
X-AuditID: b6c32a47-b81ff7000000148e-df-60597e9bb388
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        25.17.05262.B9E79506; Tue, 23 Mar 2021 14:37:32 +0900 (KST)
Mime-Version: 1.0
Subject: RE: Re: [PATCH v31 2/4] scsi: ufs: L2P map management for HPB read
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Can Guo <cang@codeaurora.org>, Bean Huo <huobean@gmail.com>
CC:     Daejun Park <daejun7.park@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
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
In-Reply-To: <e9b912bca9fd48c9b2fd76bea80439ae@codeaurora.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210323053731epcms2p70788f357b546e9ca21248175a8884554@epcms2p7>
Date:   Tue, 23 Mar 2021 14:37:31 +0900
X-CMS-MailID: 20210323053731epcms2p70788f357b546e9ca21248175a8884554
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGJsWRmVeSWpSXmKPExsWy7bCmqe6cusgEg1czmSwezNvGZrG37QS7
        xcufV9kspn34yWzxaf0yVouXhzQtdh08yGax6kG4RfPi9WwWc842MFn09m9ls9h8cAOzxeM7
        n9ktFt3YxmTR/6+dxWLbZ0GL4yffMVpc3jWHzaL7+g42i+XH/zFZLN16k9Gic/oaFgcxj8tX
        vD0u9/UyeeycdZfdY8KiA4we++euYfdoObmfxePj01ssHn1bVjF6fN4k59F+oJspgCsqxyYj
        NTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6E0lhbLEnFKg
        UEBicbGSvp1NUX5pSapCRn5xia1SakFKToGhYYFecWJucWleul5yfq6VoYGBkSlQZUJOxvmr
        zewF3/grjn5oZ2tgnMPdxcjJISFgItFw5TZbFyMXh5DADkaJnh23mLoYOTh4BQQl/u4QBqkR
        FvCW+HNhKhuILSSgJLH+4ix2iLiexK2HaxhBbDYBHYnpJ+6zg7SKCNhLrGwKAhnJLPCHTWLp
        rcdMELt4JWa0P2WBsKUlti/fCtbLKWAnceD/W1aIuIbEj2W9zBC2qMTN1W/ZYez3x+YzQtgi
        Eq33zkLVCEo8+LkbKi4pcWz3B6hd9RJb7/xiBDlCQqCHUeLwzltQC/QlrnVsBDuCV8BX4v/u
        T2CDWARUJS72TAH7XULARWLvKX2QMLOAvMT2t3OYQcLMApoS63fpQ1QoSxy5xQLzVcPG3+zo
        bGYBPomOw3/h4jvmPYG6TE1i3c/1TBMYlWchwnkWkl2zEHYtYGRexSiWWlCcm55abFRgjBy1
        mxjBCV7LfQfjjLcf9A4xMnEwHmKU4GBWEuFtCY9IEOJNSaysSi3Kjy8qzUktPsRoCvTkRGYp
        0eR8YI7JK4k3NDUyMzOwNLUwNTOyUBLnLTZ4EC8kkJ5YkpqdmlqQWgTTx8TBKdXA1HzEYMHt
        Tq+vk/c2uxn7mGmtiK+V+1S+JPEK164yVYOTPEHfPZMaIqX+xwTnLRd9sO5R4e1vxy5vXPgj
        0b5J7vem6roNujmFV83e6Dd9yKh/FrKF7ejpT3bGTDZWiuske/an8DytZm6Mkin/W3GQY77I
        9tp37gd7f/duaKj4Y+NmsOrnhgt3FQ/Lxx3dtaqxZ01QC6dU+aQetr4zNc8mdi9y/2uc1Dnh
        w4/un66qdbFnNvorXf3wyy337i2JQ219Ike+er230Zed8VLxcl/TwX9P7iqkxE2LX76Ap/Tp
        5k2CE3um5bSkRS7nd3ESWrn7qYbC5pcnQ85vEXIIzFH8yRob9E9tsccMB1ORqBNflViKMxIN
        tZiLihMBCfCDI3kEAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210322065127epcms2p5021a61416a6b427c62fcaf5d8b660860
References: <e9b912bca9fd48c9b2fd76bea80439ae@codeaurora.org>
        <20210322065127epcms2p5021a61416a6b427c62fcaf5d8b660860@epcms2p5>
        <20210322065410epcms2p431f73262f508e9e3e16bd4995db56a4b@epcms2p4>
        <75df140d2167eadf1089d014f571d711a9aeb6a5.camel@gmail.com>
        <d6a032261a642a4afed80188ea4772ee@codeaurora.org>
        <CGME20210322065127epcms2p5021a61416a6b427c62fcaf5d8b660860@epcms2p7>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>On 2021-03-23 12:22, Can Guo wrote:
>> On 2021-03-22 17:11, Bean Huo wrote:
>>> On Mon, 2021-03-22 at 15:54 +0900, Daejun Park wrote:
>>>> +       switch (rsp_field->hpb_op) {
>>>> 
>>>> +       case HPB_RSP_REQ_REGION_UPDATE:
>>>> 
>>>> +               if (data_seg_len != DEV_DATA_SEG_LEN)
>>>> 
>>>> +                       dev_warn(&hpb->sdev_ufs_lu->sdev_dev,
>>>> 
>>>> +                                "%s: data seg length is not
>>>> same.\n",
>>>> 
>>>> +                                __func__);
>>>> 
>>>> +               ufshpb_rsp_req_region_update(hpb, rsp_field);
>>>> 
>>>> +               break;
>>>> 
>>>> +       case HPB_RSP_DEV_RESET:
>>>> 
>>>> +               dev_warn(&hpb->sdev_ufs_lu->sdev_dev,
>>>> 
>>>> +                        "UFS device lost HPB information during
>>>> PM.\n");
>>>> 
>>>> +               break;
>>> 
>>> Hi Deajun,
>>> This series looks good to me. Just here I have one question. You 
>>> didn't
>>> handle HPB_RSP_DEV_RESET, just a warning.  Based on your SS UFS, how 
>>> to
>>> handle HPB_RSP_DEV_RESET from the host side? Do you think we shoud
>>> reset host side HPB entry as well or what else?
>>> 
>>> 
>>> Bean
>> 
>> Same question here - I am still collecting feedbacks from flash vendors 
>> about
>> what is recommanded host behavior on reception of HPB Op code 0x2, 
>> since it
>> is not cleared defined in HPB2.0 specs.
>> 
>> Can Guo.
> 
>I think the question should be asked in the HPB2.0 patch, since in 
>HPB1.0 device
>control mode, a HPB reset in device side does not impact anything in 
>host side -
>host is not writing back any HPB entries to device anyways and HPB Read 
>cmd with
>invalid HPB entries shall be treated as normal Read(10) cmd without any 
>problems.

Yes, UFS device will process read command even the HPB entries are valid or
not. So it is warning about read performance drop by dev reset.

Thanks,
Daejun

>Please correct me if I am wrong.



>Thanks,
>Can Guo.
> 
> 
>  
