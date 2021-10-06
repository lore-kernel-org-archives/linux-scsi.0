Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11AF3C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 10:05:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9CB461152
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 10:05:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238070AbhJFKHY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Oct 2021 06:07:24 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:15495 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238059AbhJFKHT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Oct 2021 06:07:19 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20211006100526euoutp0288b40e5c54c3908bb1063305b1f5d5fc~raP0iyjqE2260922609euoutp02m
        for <linux-scsi@vger.kernel.org>; Wed,  6 Oct 2021 10:05:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20211006100526euoutp0288b40e5c54c3908bb1063305b1f5d5fc~raP0iyjqE2260922609euoutp02m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1633514726;
        bh=8UeUB7ujFp054c6NYv5PnL9PcSTwN20u+c3tPWoZ/Ts=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=gh5GG4vFpPa8yd0aTaq0BYLOvlopy5lRcayQwmRi/QCLs2Vx+kvrBgx3DLrjHs6T1
         OVqnjXbYdPCVn2Htci7kXzdwCo+qhz6lTdBt7VLStRg3HZ9w7mDJzjMDgaglVyxoDQ
         oHZr4+2fj7Zvo/6CO62C+kLJNmrMFhnAF8sQB0sM=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20211006100525eucas1p11a0dd5d9be9e7517aa477f007d64a89f~raPzzOT322660526605eucas1p1p;
        Wed,  6 Oct 2021 10:05:25 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 05.36.45756.5E47D516; Wed,  6
        Oct 2021 11:05:25 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20211006100524eucas1p2a1686056cf4a213dc42af4da610ddb67~raPzQbfZM3035530355eucas1p2m;
        Wed,  6 Oct 2021 10:05:24 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20211006100524eusmtrp1f259da37f2d056536891022ee35c0c12~raPzPegq41327913279eusmtrp1w;
        Wed,  6 Oct 2021 10:05:24 +0000 (GMT)
X-AuditID: cbfec7f2-7d5ff7000002b2bc-04-615d74e51519
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 84.78.31287.4E47D516; Wed,  6
        Oct 2021 11:05:24 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20211006100524eusmtip128bb89f78867a5936408df4c49982d42~raPzBqDMU0572405724eusmtip1Y;
        Wed,  6 Oct 2021 10:05:24 +0000 (GMT)
Received: from localhost (106.210.248.142) by CAMSVWEXC01.scsc.local
        (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
        Wed, 6 Oct 2021 11:05:23 +0100
Date:   Wed, 6 Oct 2021 12:05:23 +0200
From:   Javier =?utf-8?B?R29uesOhbGV6?= <javier.gonz@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "lsf-pc@lists.linux-foundation.org" 
        <lsf-pc@lists.linux-foundation.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "msnitzer@redhat.com" <msnitzer@redhat.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "roland@purestorage.com" <roland@purestorage.com>,
        "mpatocka@redhat.com" <mpatocka@redhat.com>,
        "hare@suse.de" <hare@suse.de>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "rwheeler@redhat.com" <rwheeler@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
        "zach.brown@ni.com" <zach.brown@ni.com>,
        "osandov@fb.com" <osandov@fb.com>,
        Adam Manzanares <a.manzanares@samsung.com>,
        SelvaKumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        "Kanchan Joshi" <joshi.k@samsung.com>,
        Vincent Fu <vincent.fu@samsung.com>
Subject: Re: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
Message-ID: <20211006100523.7xrr3qpwtby3bw3a@mpHalley.domain_not_set.invalid>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c2d0dff9-ad6d-c32b-f439-00b7ee955d69@acm.org>
X-Originating-IP: [106.210.248.142]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
        CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUxTZxTG9957e3tbBlwLC29Et6zTberE4czyRo3iZPE2pmTTDfeF0Iy7
        SiyttrC5D7Wjxq3VCVYjWAIaolQoX2sVGaModYMh1Q0tExCrrmVT5ENK2cpG2dpezfjvd855
        nvecJ3kpXGQg51I5yjxWrZQpxKSQaGyfurp0MC9D9nLQAJHlViGJjj2cwpHp5gMC2UdLechj
        /RdDLRVGDFVZfsRQ0ODGkNHxK0D2/iXoROUgHx240USi1gd2HJk7ZjB0+OseDF01TZPokruH
        QJZphKp+x9DQha0p8cx110bmsG6Uz1y/ks9Yq/UkYzu1lznSawbM931akinx+UnmhvM8xowP
        9hNM491v+MxYa09I1vU5M2F9mvnq4gHsjdj3hKuzWUXOx6x62Zos4bbTjm58hzNqV6DgGE8L
        fhAYgICC9ArYfr8NGICQEtFnACz3XOZxhR/AuvGjWFgloicA9HnQY8dA8CafE5kBdBuGHxUh
        kct/+dFbZwFscBWBsIWgF8CGAS0ZZpJeC69V9uNhjqdfhH/eMRNhA06XU9B/u5kID56gWbhv
        uI0f5jhaApsaCiN3RNNSWFbcx+N4Duw87o3ocXol1D8sCPWpECdC8wzFtZ+BunOlkV0CehW8
        dbs5IoH0c9BcLOXS7Ia17c5IAEifFsLAtW9JbpAKp+z1PI7j4FDHWT7H82DXkYMEZ9AB6Kxx
        4VxxEMBp4xnAbVgFDzkVnGEdPH/0Ls61Y2DvyBzuthhobCzGi8BC06w0pllpTP+nMc1KcxIQ
        1SCBzdfkyllNspL9JEkjy9XkK+VJH6pyrSD0XbtmOnxNoGxoPMkBMAo4AKRwcXy0am2GTBSd
        Lfv0M1atylTnK1iNAyRShDghurq0JlNEy2V57HaW3cGqH08xSjBXiwnu6ep/Nr2Z3brko2df
        aIhJ6NP/tIDZuCxjzDdi01eumZ+ir0u7uG61KqH8XpZIYtzQY07xSSzpu6L+kVQd9yXu6bRM
        irG0J7+Yx3re1wmlbYujbG63duFwb1vhhKven5pb9Jp8/6X+lj9obwny7V2OKl7a8pv93Pqc
        +96ynI6CpzqzuucvktYsSn69aES927b8+fVRryytNX2QuYk3Sqh2BrauRCXvDOj2TwalgjjF
        CVB75VBfZbPty/Sh7yRBZWxs4OSr+3QoNX3nW5Nl0pZ3S8ZNlurUC95AfK2uNVn899unNkxa
        PXV/VXiFUmJsRfedqrRfprzbmzWb5W56i2UPISY022TJi3G1RvYfXce2Jx0EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPKsWRmVeSWpSXmKPExsVy+t/xu7pPSmITDc5u07dYfbefzWLah5/M
        FrNuv2ax2PtuNqvF403/mSz2LJrEZLFy9VEmi79d95gsJh26xmix95a2xfxlT9ktuq/vYLPY
        93ovs8Xy4/+YLCZ2XGWyODfrD5vF4XtXWSxW/7GwWPmMyeLV/jgHEY/LV7w9Jja/Y/e4fLbU
        Y9OqTjaPzUvqPSbfWM7osftmA5vHjE9f2Dyun9nO5PHx6S0Wj20Pe9k93u+7ClR2utrj8yY5
        j/YD3UwB/FF6NkX5pSWpChn5xSW2StGGFkZ6hpYWekYmlnqGxuaxVkamSvp2NimpOZllqUX6
        dgl6GUsPXWQuOMNd8aNpGmsD4xHOLkZODgkBE4k7f2+zdzFycQgJLGWUmPDkDRtEQkbi05WP
        7BC2sMSfa11sEEUfGSW+dGxhhXC2MEo8v90JVsUioCKx4U4DWDebgL3EpWW3mEFsEQENiW8P
        lrOANDALzOOQ+HJ/FwtIgkEgVaLlzUGwZmEBT4kdG/qZQGxeAV+JudNvQm34wSRx4GYvG0RC
        UOLkzCdgzcwCFhIz559n7GLkALKlJZb/44AIy0s0b50NtphTwFri7v1drCAlEgLKEsun+0J8
        Uyvx6v5uxgmMorOQDJ2FZOgshKGzkAxdwMiyilEktbQ4Nz232FCvODG3uDQvXS85P3cTIzAl
        bTv2c/MOxnmvPuodYmTiYDzEKMHBrCTCm28fmyjEm5JYWZValB9fVJqTWnyI0RQYXBOZpUST
        84FJMa8k3tDMwNTQxMzSwNTSzFhJnHfr3DXxQgLpiSWp2ampBalFMH1MHJxSDUz5D4/J/m5b
        rutbZPpGbkurskns0fMnbDqaGqpe+l3fO19aV6GAJXCdy1RvDe5+yUhHvUL25sWKPhMsypmb
        mR+veLpuxbNXC9/b6slzXJYrn7OSu2vfmt0BHLcuvnVjeNVadFVCX7JDKqrP5tzfP9ujm5fE
        Fzb/bit4POdcAcM6+8baM+GH/8aJvZ88jW/qWsvqffMj06uUbwoJlX1b+yq859L1tslumz7f
        OuK0yjjqQk31kvvcMRuX/iyTW23O+T7WaNP7tyzfJnvd2rVDT8ZfWJ55WbTRG6bpuqw79lUy
        uCxmXRCwpWvl3L9K06JEpjCwnF3tzrsruPEQg3bMWcH3LDP1VDcHB3lMr1iVtk+JpTgj0VCL
        uag4EQABnR0A0gMAAA==
X-CMS-MailID: 20211006100524eucas1p2a1686056cf4a213dc42af4da610ddb67
X-Msg-Generator: CA
X-RootMTR: 20210928191342eucas1p23448dcd51b23495fa67cdc017e77435c
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210928191342eucas1p23448dcd51b23495fa67cdc017e77435c
References: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
        <PH0PR04MB74161CD0BD15882BBD8838AB9B529@PH0PR04MB7416.namprd04.prod.outlook.com>
        <CGME20210928191342eucas1p23448dcd51b23495fa67cdc017e77435c@eucas1p2.samsung.com>
        <20210928191340.dcoj7qrclpudtjbo@mpHalley.domain_not_set.invalid>
        <c2d0dff9-ad6d-c32b-f439-00b7ee955d69@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 30.09.2021 09:20, Bart Van Assche wrote:
>On 9/28/21 12:13 PM, Javier González wrote:
>>Since we are not going to be able to talk about this at LSF/MM, a few of
>>us thought about holding a dedicated virtual discussion about Copy
>>Offload. I believe we can use Chaitanya's thread as a start. Given the
>>current state of the current patches, I would propose that we focus on
>>the next step to get the minimal patchset that can go upstream so that
>>we can build from there.
>>
>>Before we try to find a date and a time that fits most of us, who would
>>be interested in participating?
>
>Given the technical complexity of this topic and also that the people who are
>interested live in multiple time zones, I prefer email to discuss the technical
>aspects of this work. My attempt to summarize how to implement copy offloading
>is available here: https://protect2.fireeye.com/v1/url?k=ba7e5d9a-e5e564d5-ba7fd6d5-0cc47a30d446-07a47f3f53cbfe53&q=1&e=c3973bdc-b6fd-43fb-80e6-0c86cb6b4d5f&u=https%3A%2F%2Fgithub.com%2Fbvanassche%2Flinux-kernel-copy-offload.
>Feedback on this text is welcome.

Thanks for sharing this Bart.

I agree that the topic is complex. However, we have not been able to
find a clear path forward in the mailing list.

What do you think about joining the call to talk very specific next
steps to get a patchset that we can start reviewing in detail.

I think that your presence in the call will help us all.

What do you think?

