Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60AF9C48BD1
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Jun 2021 00:28:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4380A6128A
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Jun 2021 00:28:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbhFKAal (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Jun 2021 20:30:41 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:29573 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231157AbhFKAak (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jun 2021 20:30:40 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210611002841epoutp03550a85aa3251a41776437ced94558090~HX53Bs3_U0533505335epoutp03v
        for <linux-scsi@vger.kernel.org>; Fri, 11 Jun 2021 00:28:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210611002841epoutp03550a85aa3251a41776437ced94558090~HX53Bs3_U0533505335epoutp03v
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1623371321;
        bh=Gi1v3ZiCT2bowcQbssxsuDnG8OxLKfsTlGg+RrVfSp0=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=P8oblYOKgllmOWjv1ONJpeBQ9YrtswroVjdkag0HZevDY+EnR1x28fgkdMhrSnFWM
         LWKfueex+90UUxIP86kXSOp+92aTF75bylMY9DqdXuqPSxVuIaDjChlu5+rz6uOIwr
         VVC6TRoxrn7KvRY7vzoHOa8a/K2Pe2c9pEmMgGEY=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210611002840epcas2p324e845b61b5739ac8ab1db5e1cf471f4~HX52NBlvJ1992719927epcas2p39;
        Fri, 11 Jun 2021 00:28:40 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.185]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4G1MCC1hstz4x9Px; Fri, 11 Jun
        2021 00:28:39 +0000 (GMT)
X-AuditID: b6c32a48-4e5ff700000025f5-d6-60c2ae367b66
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        B7.53.09717.63EA2C06; Fri, 11 Jun 2021 09:28:38 +0900 (KST)
Mime-Version: 1.0
Subject: RE: Re: [PATCH v36 1/4] scsi: ufs: Introduce HPB feature
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
In-Reply-To: <5694e1e0-1c8c-12ef-3215-3d3413a86ea2@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210611002837epcms2p672829dbecc175ef8cb2428ebf36e8cae@epcms2p6>
Date:   Fri, 11 Jun 2021 09:28:37 +0900
X-CMS-MailID: 20210611002837epcms2p672829dbecc175ef8cb2428ebf36e8cae
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA11TfUxbVRT3vvd4fSBdHh9jV9TZPTYjU0rbUbwMmIwt+pJtiluyqYmDF3h8
        xNI2fdTojBH5KgKFkTH5kA1CJygfw01bWlAHrTJwIWaDCatIWRwxzHQyCDokTNtS3OJ/v/s7
        v3N+55x7L4WHzpORVJ66gNepORVDBhEWRzSKiT9vz5DNrYah2bMWEn1TNiJC8yvXSfTxwgqO
        FnvbA9C8PRr1Dw2RqHP2GCo29ZKoeawQQ8YaM4m+HPoCR79OL4lQ25QFQzX3DQSyLIWgy6N3
        ABrvbyZR5aSVRB2X72PoU/MNgD6q7yZSItjxiQPseLURY21Nv4jYk22DgL10plvEloxeIti7
        c06Crf6qE7BLF7eyhsFKLC3oDVVSLs9l8ToJr87UZOWpc5KZA0fS96Ur42XyGHkCep6RqLl8
        PpnZfzAt5sU8lWdMRvI2p9J7qDROEJjYPUk6jb6Al+RqhIJkhtdmqbRyuVYqcPmCXp0jzdTk
        75bLZAqlR5mhyv25rZ/Qmsl3Fn9bJQuBi6gAgRSk46DR9KeoAgRRobQVwLqJSk+AosR0CFyz
        hnk1YfReWHv9tE8fSjOw92qTaJ2XQufNbuDFJP0crB9x+eqE00UEtDnchPeA0z/i8OspA1h3
        E8MGw5zf+XHY12H28YF0IvxryYCt88/Ae+1GfB1vhje63KIN/Mdwi79OOCydGfNrQuDsyoCf
        fwwODyz463wAzdN/A28TkK4C0GFzBqwHYuFP5Rd8TYjpQ/D3smHSiwl6B5xoaPc3tx8O3Hb5
        9Dj9FOxzN+PereB0NOztj/VCSEfB75zExliFF1ZF/8c4vQmWO9b+461nb/lbexqeX+nFToKo
        pgerbnrIq+mBVyvAO0EErxXyc3hBoY17+HYvAt+b38lawSfuBakdYBSwA0jhTLjY9rk9I1Sc
        xb17gtdp0nV6FS/YgdIzZS0euTlT4/k06oJ0uVIRHy9LUCJlvAIxW8SUyJNE53AF/Fs8r+V1
        G3kYFRhZiNWdiYsKy9ve2HL4Sks5ntbTuLxIi1PCHfP15p7qb3+ona9PlDpH+1a7MN22ydJC
        peTlmJJS87J6tGrH3S5pY3GqiXMPtUsST1c9m72vMnrrqyH6O0VPrhmPF3dgjjTXLXwwrsSm
        fyEje7vtBNnQeUT8hCk0+TVXUV4/nh+yoPi+5r2GsWtbXp+KaheaJ6fqZIP/RLjGxkcGqpYD
        ZsjPeirDTsFNSValYtG9y3nY+OjRuOVTKlVq1hUp+0jZ+x8uUjOvRFiO7pGnBL8UHWA6h2cX
        td6rqErgTbd3TQeSyuVtrTebg4m6mmM1x/cuZKbal9y5bwavXTNcHcrcvWKZPjjNEEIuJ9+J
        6wTuX3SYoMZ8BAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210607041650epcms2p29002c9d072738bbf21fb4acf31847e8e
References: <5694e1e0-1c8c-12ef-3215-3d3413a86ea2@acm.org>
        <20210607041650epcms2p29002c9d072738bbf21fb4acf31847e8e@epcms2p2>
        <20210607041755epcms2p271195b24f4a10e777d240ff5d844168f@epcms2p2>
        <CGME20210607041650epcms2p29002c9d072738bbf21fb4acf31847e8e@epcms2p6>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

>On 6/6/21 9:17 PM, Daejun Park wrote:
>> +What:                /sys/class/scsi_device/*/device/hpb_sysfs/hit_cnt
>> +Date:                June 2021
>> +Contact:        Daejun Park <daejun7.park@samsung.com>
>> +Description:        This entry shows the number of reads that changed to HPB read.
>> +
>> +                The file is read only.
> 
>This patch introduces the hit_cnt attribute in the hpb_sysfs directory
>and patch 4 moves that attribute to the hpb_stats directory. That is not
>how sysfs attributes should be introduced. Please introduce the hit_cnt
>attribute in the hpb_stats directory in this patch such that the sysfs
>directory does not have to be modified in patch 4.
Sure, Sure, I will prepare this in the next patch.

Thanks,
Daejun

> 
>Thanks,
> 
>Bart.
> 
> 
>  
