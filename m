Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA36DC2BBCF
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 01:06:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF80B23A57
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 01:06:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732116AbgLRBGJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Dec 2020 20:06:09 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:49167 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727142AbgLRBGJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Dec 2020 20:06:09 -0500
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20201218010525epoutp03cc720fa0af85986473e86d64b014ee43~Rqg_QYlh80559305593epoutp03H
        for <linux-scsi@vger.kernel.org>; Fri, 18 Dec 2020 01:05:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20201218010525epoutp03cc720fa0af85986473e86d64b014ee43~Rqg_QYlh80559305593epoutp03H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608253525;
        bh=Z1z+1gbj3d2xNnL0OZ9CBWro1uoapM2pBsfMrHP8Jvg=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=Bw20J2RKNIiH4uWPAyWyrU1Tklrfvm9dRINaX5ycNcjhbM69Wud3j+eFZJI/ZJ5Yu
         WWXq8Csms0iIh6cpNWCen0VE9e+6ZyWG00kaSJCJCUWeCNjv9tfp+mneqPEi2uVBGC
         Z5vIaMAK6HoEk2Sb68tN7KmGMYyYbjkWtHe25xRA=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20201218010524epcas2p3b215e27928d81bf9979764f7b7fbeabb~Rqg9fnUCA2164321643epcas2p3P;
        Fri, 18 Dec 2020 01:05:24 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.182]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4CxrJK1BwMz4x9Q0; Fri, 18 Dec
        2020 01:05:21 +0000 (GMT)
X-AuditID: b6c32a47-b81ff7000000148e-2b-5fdc0050cc3a
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        CF.C3.05262.0500CDF5; Fri, 18 Dec 2020 10:05:21 +0900 (KST)
Mime-Version: 1.0
Subject: RE: Re: [PATCH v14 0/3] scsi: ufs: Add Host Performance Booster
 Support
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Daejun Park <daejun7.park@samsung.com>
CC:     "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <X9ncUJH/vHO7Luqi@kroah.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20201218010520epcms2p1f7994bde414008ea1f44c733350308db@epcms2p1>
Date:   Fri, 18 Dec 2020 10:05:20 +0900
X-CMS-MailID: 20201218010520epcms2p1f7994bde414008ea1f44c733350308db
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLsWRmVeSWpSXmKPExsWy7bCmqW4gw514gy13mC023n3FavFg3jY2
        i71tJ9gtXv68ymZx+PY7dotpH34yW3xav4zV4uUhTYtVD8ItmhevZ7OYc7aByaK3fyubxaIb
        25gsLu+aw2bRfX0Hm8Xy4/+YLG5v4bJYuvUmo0Xn9DUsFosW7mZxEPG4fMXb43JfL5PHzll3
        2T0mLDrA6LF/7hp2j5aT+1k8Pj69xeLRt2UVo8fnTXIe7Qe6mQK4ohoYbRKLkjMyy1IVUvOS
        81My89JtlUJD3HQtlBQy8otLbJWiDS2M9AwtTfVMLPWMzGOtDA0MjEyVFPISc1NtlSp0obqV
        FIqSC4CqS1KLS4pSk1OBQkUOxSWJ6al6xYm5xaV56XrJ+blKCmWJOaVAfUr6djYZqYkpqUUK
        CU8YM942nmEquC5XcWL2Y6YGxv3iXYwcHBICJhIvV4Z1MXJyCAnsYJSYN1EdJMwrICjxd4cw
        iCksECTx7KAfRIWSxPqLs9hBbGEBPYlbD9cwgthsAjoS00/cZwcpFwEqvzzNoIuRi4NZYBWb
        xLKTJ1lBaiQEeCVmtD9lgbClJbYv3wrWyymgKbFyehdUjYbEj2W9zBC2qMTN1W/ZYez3x+Yz
        QtgiEq33zkLVCEo8+LkbKi4pcWz3ByYIu15i651fjCBHSAj0MEoc3nkLaoG+xLWOjWBH8Ar4
        Stx9vgNsAYuAqsT1VfOhalwkdi1ZAzaIWUBeYvvbOcwgjzEDHbp+lz4k0JQljtxigXmrYeNv
        dnQ2swCfRMfhv3DxHfOeQJ2mJrHu53qmCYzKsxDhPAvJrlkIuxYwMq9iFEstKM5NTy02KjBG
        juRNjOCkr+W+g3HG2w96hxiZOBgPMUpwMCuJ8IY+uB0vxJuSWFmVWpQfX1Sak1p8iLEK6MuJ
        zFKiyfnAvJNXEm9oZmBkZmpsYmxsamJKtrCpkZmZgaWphamZkYWSOG/oyr54IYH0xJLU7NTU
        gtQimOVMHJxSDUxOWe2su5Wdp/ktesVQJbIkQLN4/YMshZj4LXm7ryX4X5hQfn2BeNTrZr39
        JpcEXM4U23sUHluasa4qo4/5fnGtxZdauY1vDAyKz99LEZ1dmNgtvsZf4o5Hwmdjhg1lWhVp
        ElrHA59P6n/+lX/Hsn0rMj926gp7itWuVTm+ze/ltXZf2weJ/1WPTm8SalgUtdex6+DNYG3/
        Q3uWnxTXXPflvdDVco7NWgePp7BmGxZy3tE+UzLtNLPp5FTmVANT/0U3A+WdAjQqJyt5rn9e
        Nc2nZxPHIq+tjny7l+bUGE5O8vLr5tjZ9lElNTqI47LA74ubO5/d2Krcc9Kw8e57I6XlOzjc
        M16diOXg67O4o8RSnJFoqMVcVJwIAEa2tMfIBAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201215082235epcms2p88c9d8fd4dc773f6a4901dab241063306
References: <X9ncUJH/vHO7Luqi@kroah.com>
        <20201216024444epcms2p5e69281911dd675306c473df3d2cef8b2@epcms2p5>
        <CGME20201215082235epcms2p88c9d8fd4dc773f6a4901dab241063306@epcms2p1>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi, Greg

> > NAND flash memory-based storage devices use Flash Translation Layer (FTL)
> > to translate logical addresses of I/O requests to corresponding flash
> > memory addresses. Mobile storage devices typically have RAM with
> > constrained size, thus lack in memory to keep the whole mapping table.
> > Therefore, mapping tables are partially retrieved from NAND flash on
> > demand, causing random-read performance degradation.
> > 
> > To improve random read performance, JESD220-3 (HPB v1.0) proposes HPB
> > (Host Performance Booster) which uses host system memory as a cache for the
> > FTL mapping table. By using HPB, FTL data can be read from host memory
> > faster than from NAND flash memory. 
> > 
> > The current version only supports the DCM (device control mode).
> > This patch consists of 3 parts to support HPB feature.
> > 
> > 1) HPB probe and initialization process
> > 2) READ -> HPB READ using cached map information
> > 3) L2P (logical to physical) map management
> > 
> > In the HPB probe and init process, the device information of the UFS is
> > queried. After checking supported features, the data structure for the HPB
> > is initialized according to the device information.
> > 
> > A read I/O in the active sub-region where the map is cached is changed to
> > HPB READ by the HPB.
> > 
> > The HPB manages the L2P map using information received from the
> > device. For active sub-region, the HPB caches through ufshpb_map
> > request. For the in-active region, the HPB discards the L2P map.
> > When a write I/O occurs in an active sub-region area, associated dirty
> > bitmap checked as dirty for preventing stale read.
> > 
> > HPB is shown to have a performance improvement of 58 - 67% for random read
> > workload. [1]
> > 
> > We measured the total start-up time of popular applications and observed
> > the difference by enabling the HPB.
> > Popular applications are 12 game apps and 24 non-game apps. Each target
> > applications were launched in order. The cycle consists of running 36
> > applications in sequence. We repeated the cycle for observing performance
> > improvement by L2P mapping cache hit in HPB.
> > 
> > The Following is experiment environment:
> >  - kernel version: 4.4.0 
> >  - UFS 2.1 (64GB)
> > 
> > Result:
> > +-------+----------+----------+-------+
> > | cycle | baseline | with HPB | diff  |
> > +-------+----------+----------+-------+
> > | 1     | 272.4    | 264.9    | -7.5  |
> > | 2     | 250.4    | 248.2    | -2.2  |
> > | 3     | 226.2    | 215.6    | -10.6 |
> > | 4     | 230.6    | 214.8    | -15.8 |
> > | 5     | 232.0    | 218.1    | -13.9 |
> > | 6     | 231.9    | 212.6    | -19.3 |
> > +-------+----------+----------+-------+
> 
> I feel this was burried in the 00 email, shouldn't it go into the 01
> commit changelog so that you can see this?

Sure, I will move this result to 01 commit log.
 
> But why does the "cycle" matter here?

I think iteration minimizes other factors that affect the start-up time of
application.

> Can you run a normal benchmark, like fio, on here so we can get some
> numbers we know how to compare to other systems with, and possible
> reproduct it ourselves?  I'm sure fio will easily show random read
> performance increases, right?

Here is my iozone script:
iozone -r 4k -+n -i2 -ecI -t 16 -l 16 -u 16 
-s $IO_RANGE/16 -F mnt/tmp_1 mnt/tmp_2 mnt/tmp_3 mnt/tmp_4 
mnt/tmp_5 mnt/tmp_6 mnt/tmp_7 mnt/tmp_8 mnt/tmp_9 mnt/tmp_10 mnt/tmp_11 
mnt/tmp_12 mnt/tmp_13 mnt/tmp_14 mnt/tmp_15 mnt/tmp_16

Result:
+----------+--------+---------+
| IO range | HPB on | HPB off |
+----------+--------+---------+
|   1 GB   | 294.8  | 300.87  |
|   4 GB   | 293.51 | 179.35  |
|   8 GB   | 294.85 | 162.52  |
|  16 GB   | 293.45 | 156.26  |
|  32 GB   | 277.4  | 153.25  |
+----------+--------+---------+

Thanks,
Daejun
