Return-Path: <SRS0=lXiU=A3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE516C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jul 2020 00:27:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 921CE2072E
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jul 2020 00:27:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="LKuyCYAF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgGPA1Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jul 2020 20:27:25 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:56663 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726479AbgGPA1Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2020 20:27:24 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200716002721epoutp02bc9171b38bb3d9d724c9f87040e48178~iFAfWOI5W0985909859epoutp02i
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2020 00:27:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200716002721epoutp02bc9171b38bb3d9d724c9f87040e48178~iFAfWOI5W0985909859epoutp02i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594859241;
        bh=3+ccxZmxOKKjD+qACON/DRmLamaCcOQyZMOiME9hmgI=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=LKuyCYAFtoun6DN0YqPQ0APfBUR7pgUNHP2NQpi5CgOEm01rXZ16dH+IdqvtSBpu5
         3cyyCeNR2eZgyX1n8Py3fp04HOqKSGDPjpUWDMk8eHXHrR/iqdC6YZSu83d7Z9DczN
         pmuCLYw47qxAU2Xgxgq1D9ODUGMiUPP+HNFM+IdI=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200716002721epcas5p2f3c66ca084ed0f5b5b6f5f27c17f4108~iFAemzUhr3009330093epcas5p2K;
        Thu, 16 Jul 2020 00:27:21 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        30.E8.09703.9EE9F0F5; Thu, 16 Jul 2020 09:27:21 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20200715182604epcas5p1ec9a4e49ab8499c0cfdb3044e8bd7c60~iAFDCOB6w3082830828epcas5p1B;
        Wed, 15 Jul 2020 18:26:04 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200715182604epsmtrp2f2864d015dc8accbae9c0050ff6c91d3~iAFC_ohTF0427404274epsmtrp2Y;
        Wed, 15 Jul 2020 18:26:04 +0000 (GMT)
X-AuditID: b6c32a4a-4b5ff700000025e7-a3-5f0f9ee94311
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        5D.39.08303.C3A4F0F5; Thu, 16 Jul 2020 03:26:04 +0900 (KST)
Received: from alimakhtar02 (unknown [107.108.234.165]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200715182559epsmtip2af529e172b3c953d9e6ddd437a496f67~iAE_F2oqk0899808998epsmtip2f;
        Wed, 15 Jul 2020 18:25:58 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Kiwoong Kim'" <kwmad.kim@samsung.com>,
        <linux-scsi@vger.kernel.org>, <avri.altman@wdc.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <bvanassche@acm.org>,
        <grant.jung@samsung.com>, <sc.suh@samsung.com>,
        <hy50.seo@samsung.com>, <sh425.lee@samsung.com>
In-Reply-To: <cover.1594798514.git.kwmad.kim@samsung.com>
Subject: RE: [PATCH v6 0/3] ufs: exynos: introduce the way to get cmd info
Date:   Wed, 15 Jul 2020 23:55:56 +0530
Message-ID: <075101d65ad5$66348460$329d8d20$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHAd02kf0hzbk2A6kTf3xoH16zPTwGHGd1aqSiC/5A=
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLKsWRmVeSWpSXmKPExsWy7bCmuu7LefzxBnPusFjsbTvBbvHy51U2
        i4MPO1kspn34yWzxaf0yVotff9ezW6xe/IDFYtGNbUwWN7ccZbHovr6DzWL58X9MFl13bzBa
        LP33lsWB1+PyFW+Py329TB4TFh1g9Pi+voPN4+PTWywefVtWMXp83iTn0X6gmymAI4rLJiU1
        J7MstUjfLoErY9vXbuaCiwIVG78uYWtgPMTbxcjJISFgIrHt33rWLkYuDiGB3YwS6352QDmf
        GCV+rZsF5XxmlPi2ZBorTMv54/ugErsYJa4t62SCcN4wSpz+doURpIpNQFdix+I2NpCEiMBt
        Jom1RzvZQRKcApYS6yadB7OFBbwkvvavZgaxWQRUJc53ngezeYFqvs3fwAphC0qcnPmEBcRm
        FtCWWLbwNTPEGQoSP58uA6sREbCSeLjjAhtEjbjE0Z89zCCLJQROcEj07jrIBtHgIjHr+SYW
        CFtY4tXxLewQtpTE53d7gWo4gOxsiZ5dxhDhGoml845BldtLHLgyhwWkhFlAU2L9Ln2IsKzE
        1FPrmCDW8kn0/n7CBBHnldgxD8ZWlWh+dxVqjLTExO5uaCh6SLzqOsY0gVFxFpIvZyH5chaS
        b2YhbF7AyLKKUTK1oDg3PbXYtMAoL7Vcrzgxt7g0L10vOT93EyM4xWl57WB8+OCD3iFGJg7G
        Q4wSHMxKIrw8XLzxQrwpiZVVqUX58UWlOanFhxilOViUxHmVfpyJExJITyxJzU5NLUgtgsky
        cXBKNTD12+3+YuUqKXhpskytq+RxBjVV18/uYgI5zvWqv0QVJOZ4TAqs2yDtnOlVmrdJyfLn
        XLXfVesezHKaPP9mtM1iNcN2sYLk+9H6PnNPlW5eczc/+MLsU+rvyuaXitmqXLqRJnl4tXTk
        gr2HrI+YbNMU0G94oXr268SfrbMu3D2795l2SMt2X/WElvl/FD1vG+y5YWLwlG3yvm0f826H
        lG6fHDvt+dOtn67PZ3rwYu/Cjnsblq45yN735cOErNNl859KCGyx4bIVf3ht+uyIaTz6H3+2
        3VNiEpq/ntulft6Xuu0Gx0SfVJ7nr59St3Sylyzf7djGNbXWi8WuHPGI2GPrcCApKT15e8S5
        SbvW1FTnKbEUZyQaajEXFScCAJ4TOqXgAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsWy7bCSvK6NF3+8wbfPmhZ7206wW7z8eZXN
        4uDDThaLaR9+Mlt8Wr+M1eLX3/XsFqsXP2CxWHRjG5PFzS1HWSy6r+9gs1h+/B+TRdfdG4wW
        S/+9ZXHg9bh8xdvjcl8vk8eERQcYPb6v72Dz+Pj0FotH35ZVjB6fN8l5tB/oZgrgiOKySUnN
        ySxLLdK3S+DKWLvtG0vBLIGK1ivH2RoYe3m7GDk5JARMJM4f38faxcjFISSwg1Hi/vpn7BAJ
        aYnrGydA2cISK/89Z4coesUo0X1hCgtIgk1AV2LH4jY2kISIwGsmiXtnfjFBVHUxSqxY+p8Z
        pIpTwFJi3aTzYKOEBbwkvvavBouzCKhKnO88D2bzAtV8m7+BFcIWlDg58wnYBmYBbYmnN5/C
        2csWvmaGOElB4ufTZWD1IgJWEg93XGCDqBGXOPqzh3kCo9AsJKNmIRk1C8moWUhaFjCyrGKU
        TC0ozk3PLTYsMMpLLdcrTswtLs1L10vOz93ECI5JLa0djHtWfdA7xMjEwXiIUYKDWUmEl4eL
        N16INyWxsiq1KD++qDQntfgQozQHi5I479dZC+OEBNITS1KzU1MLUotgskwcnFINTPs8p845
        xnryfuWLrI/S904Utm8236HVtSrxzUmDrL2b97YUaoUFtvPvDXhQcnS3veKKKT3cC9/ulNgY
        dZrx8IXax+d9xO3lGlZHx7Lfi/J94PQm4E3h9CVvVJgF1XfOuhlXtb9pv9bq6g6jE43yU3ef
        UtotFhGa31vT9+9+yoeOlandd/tyL68X/zvvTVmwf8LKQ+9N9CdY3WtdH/Xgk/6kub5fX29W
        /TSv7OoG1am6J+PmT75SyW+69v7PD18bw9V6A1KCjz2fGC5568f3yauXMnz7rLZ8a3+cxv0f
        jrYZ/5l2xr5JmH56FZviY8f117Q8Es2/sxtu/e8lJ3+5V/RW2pXqCz3T93GvLp7O/0hLiaU4
        I9FQi7moOBEAyDDvGTgDAAA=
X-CMS-MailID: 20200715182604epcas5p1ec9a4e49ab8499c0cfdb3044e8bd7c60
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CMS-RootMailID: 20200715074757epcas2p344b4e188af3221655c1697405b9e17f4
References: <CGME20200715074757epcas2p344b4e188af3221655c1697405b9e17f4@epcas2p3.samsung.com>
        <cover.1594798514.git.kwmad.kim@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Kiwoong,

> -----Original Message-----
> From: Kiwoong Kim <kwmad.kim=40samsung.com>
> Sent: 15 July 2020 13:10
> To: linux-scsi=40vger.kernel.org; alim.akhtar=40samsung.com;
> avri.altman=40wdc.com; jejb=40linux.ibm.com; martin.petersen=40oracle.com=
;
> beanhuo=40micron.com; asutoshd=40codeaurora.org; cang=40codeaurora.org;
> bvanassche=40acm.org; grant.jung=40samsung.com; sc.suh=40samsung.com;
> hy50.seo=40samsung.com; sh425.lee=40samsung.com
> Cc: Kiwoong Kim <kwmad.kim=40samsung.com>
> Subject: =5BPATCH v6 0/3=5D ufs: exynos: introduce the way to get cmd inf=
o
>=20
> v5 -> v6
> replace put_aligned with get_unaligned_be32 to set lba and sct fix null p=
ointer
> access symptom
>=20
> v4 -> v5
> Rebased on Stanley's patch (scsi: ufs: Fix and simplify ..
> Change cmd history print order
> rename config to SCSI_UFS_EXYNOS_DBG
> feature functions in ufs-exynos-dbg.c by SCSI_UFS_EXYNOS_DBG
>=20
> v3 -> v4
> seperate respective implementations of the callbacks change the location =
of
> compl_xfer_req related stuffs fix null pointer access
>=20
> v2 -> v3
> fix build errors
>=20
> v1 -> v2
> change callbacks
> allocate memory for ufs_s_dbg_mgr dynamically, not static way
>=20
> Kiwoong Kim (3):
>   ufs: introduce a callback to get info of command completion
>   ufs: exynos: introduce command history
>   ufs: exynos: implement dbg_register_dump
>=20
>  drivers/scsi/ufs/Kconfig          =7C  14 +++
>  drivers/scsi/ufs/Makefile         =7C   1 +
>  drivers/scsi/ufs/ufs-exynos-dbg.c =7C 198
> ++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/ufs/ufs-exynos-if.h  =7C  17 ++++
>  drivers/scsi/ufs/ufs-exynos.c     =7C  38 ++++++++
>  drivers/scsi/ufs/ufs-exynos.h     =7C  35 +++++++
>  drivers/scsi/ufs/ufshcd.c         =7C   1 +
>  drivers/scsi/ufs/ufshcd.h         =7C   8 ++
>  8 files changed, 312 insertions(+)
>  create mode 100644 drivers/scsi/ufs/ufs-exynos-dbg.c  create mode 100644
> drivers/scsi/ufs/ufs-exynos-if.h
>=20
This series looks good to me.
Reviewed-by: Alim Akhtar <alim.akhtar=40samsung.com>
Thanks,
> --
> 2.7.4


