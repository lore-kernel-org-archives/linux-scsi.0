Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C175C433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 02:48:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D36F961249
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 02:48:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbhDZCt1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Apr 2021 22:49:27 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:11631 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbhDZCt1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Apr 2021 22:49:27 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210426024844epoutp0299cb76d9981b4d4768fe654cbb0afbb1~5SJAazARP0507205072epoutp02Y
        for <linux-scsi@vger.kernel.org>; Mon, 26 Apr 2021 02:48:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210426024844epoutp0299cb76d9981b4d4768fe654cbb0afbb1~5SJAazARP0507205072epoutp02Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1619405324;
        bh=4ob6MCI6cZXvhtmK5oTsjw66/FJrr0nc3ypW4cDAKUU=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=FlwbOHhQLsAqXRKx0Qa6+gJdzx4aq7gIV8ac9LbzMT8PTL3ar5A470sS460pwIwQA
         qRrw8+rXg3qlraZpJ6jPlUsvdfbvPxkuIwaH1fYB77vTDGiDkvmhNJs9eRkxOO5klr
         TKewMWqBaiNz5LVsC42Ca/8JkDx9HCQgE23eqauA=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20210426024843epcas2p141f017287c214a2c4a2243638e306419~5SI-hbFlE1672616726epcas2p1e;
        Mon, 26 Apr 2021 02:48:43 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.188]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4FT8V10s8Wz4x9Q0; Mon, 26 Apr
        2021 02:48:41 +0000 (GMT)
X-AuditID: b6c32a47-f61ff700000024d9-80-60862a0869bb
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        FB.EE.09433.80A26806; Mon, 26 Apr 2021 11:48:40 +0900 (KST)
Mime-Version: 1.0
Subject: RE: Re: [PATCH v32 0/4] scsi: ufs: Add Host Performance Booster
 Support
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
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Dukhyun Kwon <d_hyun.kwon@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Jaemyung Lee <jaemyung.lee@samsung.com>,
        Jieon Seol <jieon.seol@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <b7f64b4dcd688b769f9ff8f9b4b378a2@codeaurora.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210426024840epcms2p7fa68f5abe64b031bbf67d0f69d88b7b5@epcms2p7>
Date:   Mon, 26 Apr 2021 11:48:40 +0900
X-CMS-MailID: 20210426024840epcms2p7fa68f5abe64b031bbf67d0f69d88b7b5
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA12Te0xTVxzHc+693BaSkguCHsABu2xGcJSWUXYEykwgswzcyJ6Ki3CFSyHr
        K71lwRmR+ABEARc2xAYRWHjIq+CE1hImryEykGwIEybKMoiYiDLZzDpHN/pgmv33yTe/1/f3
        O4ePe94nffnZKh2rVTEKmnQjugeDUSg/pCBNtPwwGs1Xd5Oot2CEhx5YpkhUsWLB0RNDgwt6
        MBCMzP39JGqe/xgd/9pAoqrxfAyVlHWR6Jv+Dhz9emeVh+pud2OozFpIoO5VD3T9xiOAJs1V
        JDr9k4lEjdetGKrvmgHo1LlWYtdm2eStRNlkaQkmu6qf48nO1vUB2bULrTzZiRvXCNlvi7OE
        rPRKM5CtXvaXFfadxpLdUhQxWSyTwWoDWVW6OiNbJZfSie+nxqVKIkXiUPFO9AYdqGKUrJSO
        T0oOfStbsW6TDvyMUeSsS8kMx9FhsTFadY6ODcxSczopzWoyFBqxWCPkGCWXo5IL09XKKLFI
        FC5Zj0xTZF0obwOaedfcofNh+eAJWQxc+ZCKgMODA6AYuPE9KROAX5a28IoBny+gPOCaaZMt
        ZhP1Hvy7v42wsSdFQ8MPep5DF8LZX1qBjUnqNXhu5J5d96IS4B/lLS62mji1RsLvR5pcHM0E
        sLJwkXCwHzQ2dtmTXalYqL9Yhjv07fDPhhIne8OZlmXeBj8evggc7AVP3h13xnjAeUuPU/eB
        wz0rmIOPwq47f9mNQeoMgINXZ51DhMHpok77EAJqD6xeGrVvgqBehWeKDc5C8fBYY7ddx6kA
        aFyuwm1LwalgaDCH2RBSQXBoltiwld/5jPd/xil3WDS49p9uql5wjrYNtlsM2FkQpH++af0L
        vfTPe9UAvBlsZjWcUs5y4ZrXX7ztZWB/8SG7TaByeUU4ADA+GACQj9NeAtJ8Ms1TkMEc+pzV
        qlO1OQqWGwCSdZdf4L7e6er1L6PSpYol4ZGRop0SJIkMR/QWgYXNS/Ok5IyO/ZRlNax2Iw/j
        u/rmYzsE9yp+Ptj+He9W/s1YpYgQavLmJm5/9WbBO++6N50CSVR6dPylrpfJHVzRzam+JUPa
        6IFD+440l4W8bVVu3f5jZ2bIQkTHw28bjB0f5QaFHZvp8IF7k4X+/a2l5y2KCvczd1Ni8vwO
        90pivJ7WpT8OuKLDxoqltfWKYe/6iIl/2uUHMutf+r0zYNrHGr2U0Ly62NkREyvf1mPcorS2
        JU3s1xmfnZiYOl7C7KNKLaPagsQ4+Vazr6nq/nRZps/Yh65B1tqj0uhPmLldubyUp1hDlF9t
        3N4mo8W8J2U2J+mVRws1HxypKS/xlx4e0uq8xhJ6x91GyVjBAplXmX2wPOrSfprgshhxCK7l
        mH8BqLsPN3oEAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210331011526epcms2p37684869a9781d1eb45bfcbfe9babd217
References: <b7f64b4dcd688b769f9ff8f9b4b378a2@codeaurora.org>
        <20210331011526epcms2p37684869a9781d1eb45bfcbfe9babd217@epcms2p3>
        <CGME20210331011526epcms2p37684869a9781d1eb45bfcbfe9babd217@epcms2p7>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Can Guo,

>> 
>> HPB is shown to have a performance improvement of 58 - 67% for random 
>> read
>> workload. [1]
>> 
>> [1]:
>> https://www.usenix.org/conference/hotstorage17/program/presentation/jeong
>> 
>> Daejun Park (4):
>>   scsi: ufs: Introduce HPB feature
>>   scsi: ufs: L2P map management for HPB read
>>   scsi: ufs: Prepare HPB read for cached sub-region
>>   scsi: ufs: Add HPB 2.0 support
>> 
>>  Documentation/ABI/testing/sysfs-driver-ufs |  162 ++
>>  drivers/scsi/ufs/Kconfig                   |    9 +
>>  drivers/scsi/ufs/Makefile                  |    1 +
>>  drivers/scsi/ufs/ufs-sysfs.c               |   22 +
>>  drivers/scsi/ufs/ufs.h                     |   54 +-
>>  drivers/scsi/ufs/ufshcd.c                  |   74 +-
>>  drivers/scsi/ufs/ufshcd.h                  |   29 +
>>  drivers/scsi/ufs/ufshpb.c                  | 2387 ++++++++++++++++++++
>>  drivers/scsi/ufs/ufshpb.h                  |  277 +++
>>  9 files changed, 3013 insertions(+), 2 deletions(-)
>>  create mode 100644 drivers/scsi/ufs/ufshpb.c
>>  create mode 100644 drivers/scsi/ufs/ufshpb.h
> 
>To the entire series:
> 
>Tested-by: Can Guo <cang@codeaurora.org>

Thanks for testing the patch series. :)

Daejun
