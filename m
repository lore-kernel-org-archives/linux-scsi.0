Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1440C4167B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 02:58:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C6EE23976
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 02:58:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728371AbgLHC6X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 21:58:23 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:31241 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728136AbgLHC6W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 21:58:22 -0500
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20201208025739epoutp01c46293b29f87a233ce70027d381c967c~OnmGenqIW0564205642epoutp01P
        for <linux-scsi@vger.kernel.org>; Tue,  8 Dec 2020 02:57:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20201208025739epoutp01c46293b29f87a233ce70027d381c967c~OnmGenqIW0564205642epoutp01P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1607396259;
        bh=hdZZ+/7XX3C01adJ1BxuhBqM9QJ43p3zU5pXJVSrO3w=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=FGc1KgY9kM11b+Yk8E7lB9M3BAljcX59/kiisL/Ku+/shoCaVPQtd3h9oItdBCt9Y
         VUWiHkFz4UnRx0WYZLLy0VqqWNFY/kyjBAeK3uZaLWcDpINfyoiRsT+JC71vWoH0TS
         dIWd82yMTdDDHoQH3BRLQW8BGLdu0Lr58hY6cnyQ=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20201208025738epcas5p3f7d9816ff296c06ee199972bdfc4c93d~OnmGE457X0400604006epcas5p3I;
        Tue,  8 Dec 2020 02:57:38 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A0.7E.50652.2ABEECF5; Tue,  8 Dec 2020 11:57:38 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20201208025738epcas5p4a50b39f580a76d0961eb5d8f8878ec2c~OnmFbwAOF3236132361epcas5p4d;
        Tue,  8 Dec 2020 02:57:38 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201208025737epsmtrp257049d7bac9afa8e95e584d99a57a687~OnmFa98r23094730947epsmtrp2I;
        Tue,  8 Dec 2020 02:57:37 +0000 (GMT)
X-AuditID: b6c32a4a-6c9ff7000000c5dc-d7-5fceeba2c0ef
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        69.F1.13470.1ABEECF5; Tue,  8 Dec 2020 11:57:37 +0900 (KST)
Received: from alimakhtar02 (unknown [107.122.12.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20201208025736epsmtip1cb5356a515c6f36881e429ddb936febb~OnmDxeeSV1502615026epsmtip1g;
        Tue,  8 Dec 2020 02:57:36 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Bean Huo'" <huobean@gmail.com>, <avri.altman@wdc.com>,
        <asutoshd@codeaurora.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <stanley.chu@mediatek.com>,
        <beanhuo@micron.com>, <bvanassche@acm.org>,
        <tomas.winkler@intel.com>, <cang@codeaurora.org>
Cc:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
In-Reply-To: <20201207190137.6858-1-huobean@gmail.com>
Subject: RE: [PATCH 0/2] two UFS changes
Date:   Tue, 8 Dec 2020 08:27:35 +0530
Message-ID: <01a401d6cd0d$e2db4c60$a891e520$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQH5gtBARHfB6frg5az8lN1he36AbQG4tUtqqZlPhcA=
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPKsWRmVeSWpSXmKPExsWy7bCmlu6i1+fiDdqOKVnsbTvBbvHy51U2
        i4MPO1kspn34yWzxaf0yVos5ZxuYLBbd2MZkcXnXHDaL7us72CyWH//HZLF0601Giw89dQ48
        HpeveHtc7utl8tg56y67x+I9L5k8Jiw6wOjRcnI/i8f39R1sHh+f3mLx+LxJzqP9QDdTAFcU
        l01Kak5mWWqRvl0CV8bFhQ1sBS/ZKlY9esHcwHiOtYuRk0NCwETi5K+lLF2MXBxCArsZJX68
        Os8I4XxilLj5uZkJpEpI4BujxLrXaTAd87cdgurYyyhx4/JPdgjnJaPErOfL2UCq2AR0JXYs
        bmMDSYgI9DBJbPxxgAUkwSzgIHHywQ6wsZwCZhKnLswAiwsLaEi0fd7KCGKzCKhIfJrwE+xA
        XgFLidPLz0DZghInZz6BmiMvsf3tHGaIkxQkfj5dBlYjImAl8axjCStEjbjE0Z89zCBHSAjc
        4ZCYsv4DC0SDi8S3dUegbGGJV8e3sEPYUhKf3+0FupoDyM6W6NllDBGukVg67xhUub3EgStz
        WEBKmAU0Jdbv0odYxSfR+/sJE0Qnr0RHmxBEtapE87urUJ3SEhO7u6HB7iFxYc8npgmMirOQ
        PDYLyWOzkDwwC2HZAkaWVYySqQXFuempxaYFRnmp5XrFibnFpXnpesn5uZsYwWlOy2sH48MH
        H/QOMTJxMB5ilOBgVhLhVZM6Gy/Em5JYWZValB9fVJqTWnyIUZqDRUmcV+nHmTghgfTEktTs
        1NSC1CKYLBMHp1QDU9denTxOJ7s7jtwRdTPVeLd73Yv4fsH8wfdp9z3rFW/InIy0v9vHr3H3
        z7TOKDstE+m089Oeiessefb6/XW1spenN2dtrjx6puT/pDa1dydTrsgpvUyuagqb+2hnX+mW
        z0I/9eqlbKbH702ctKbHcrl6ELuHRWNZ8av6+/d1RXdy3bBpadi7NqbB2+/8s00yDEuTjLea
        aPLqHGbXeDHjpqq+71HHde8kL18PO+U0ezNHz3rLs9Hlu2o7WXv07u9aNaHUJ89HmcEy4lu9
        6Ar+3t6JVu/Lg0qbq80NXPaXZE17yTn/+OvHC1607ZtYf7to6vc1idZy5efCHSvt2Zed2JZm
        8vVd9DnzLdvNvZ88U2Ipzkg01GIuKk4EAAxqqDTiAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsWy7bCSnO7C1+fiDTqOWVrsbTvBbvHy51U2
        i4MPO1kspn34yWzxaf0yVos5ZxuYLBbd2MZkcXnXHDaL7us72CyWH//HZLF0601Giw89dQ48
        HpeveHtc7utl8tg56y67x+I9L5k8Jiw6wOjRcnI/i8f39R1sHh+f3mLx+LxJzqP9QDdTAFcU
        l01Kak5mWWqRvl0CV8bFhQ1sBS/ZKlY9esHcwHiOtYuRk0NCwERi/rZDLF2MXBxCArsZJV7e
        /M0OkZCWuL5xApQtLLHy33N2iKLnjBJXW1tYQBJsAroSOxa3sYEkRASmMUnsWXaEuYuRg4NZ
        wEliz80kiIZ2Rom/0/eCNXAKmEmcujADzBYW0JBo+7yVEcRmEVCR+DThJ9hJvAKWEqeXn4Gy
        BSVOznzCAjFTT6JtI1g5s4C8xPa3c5ghjlOQ+Pl0GVi5iICVxLOOJawQNeISR3/2ME9gFJ6F
        ZNIshEmzkEyahaRjASPLKkbJ1ILi3PTcYsMCw7zUcr3ixNzi0rx0veT83E2M4GjV0tzBuH3V
        B71DjEwcjIcYJTiYlUR41aTOxgvxpiRWVqUW5ccXleakFh9ilOZgURLnvdB1Ml5IID2xJDU7
        NbUgtQgmy8TBKdXAlN6cfOO87NRP2/PDaxbEr5m5KEX7s9VLH9NTZdEsG1TWePf/c14iuMRz
        565Ns8xfGz1iadj7aMK9puZN+TOuv0lpXrP52DmumhvpnVKlXLGVCrPP1GjquzWZdYbxrHg2
        w7Y5Mk/9x13LCU97W07tPn18j8vUpyf6r1hc6wp/zdamJnrlu89Gwb4NUYV9q6bP/bmt8B/n
        1C3TL2a+fxA8+ZK2m9nHurcdlrEN+4/oln/e3hJwY4vyPGX5VX/tmS2fMBk/K/OvN337O87e
        fdMXFu3Zu496KdaYl/O+cld+XrtsTX205HH19u1vrk0OspuxLapk6cWzK6+uaGj9/XtJcuj9
        QpPbLBwRHU1KJj0CE5VYijMSDbWYi4oTAZReEb5FAwAA
X-CMS-MailID: 20201208025738epcas5p4a50b39f580a76d0961eb5d8f8878ec2c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20201207190149epcas5p2d877f4e3f6d31548d97f9b486d243a05
References: <CGME20201207190149epcas5p2d877f4e3f6d31548d97f9b486d243a05@epcas5p2.samsung.com>
        <20201207190137.6858-1-huobean@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bean,

> -----Original Message-----
> From: Bean Huo <huobean@gmail.com>
> Sent: 08 December 2020 00:32
> To: alim.akhtar@samsung.com; avri.altman@wdc.com;
> asutoshd@codeaurora.org; jejb@linux.ibm.com;
> martin.petersen@oracle.com; stanley.chu@mediatek.com;
> beanhuo@micron.com; bvanassche@acm.org; tomas.winkler@intel.com;
> cang@codeaurora.org
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH 0/2] two UFS changes
> 
> From: Bean Huo <beanhuo@micron.com>
> 
> 
> 
> Bean Huo (2):
>   scsi: ufs: Remove an unused macro definition POWER_DESC_MAX_SIZE
>   scsi: ufs: Fix wrong print message in dev_err()
> 
>  drivers/scsi/ufs/ufs.h    | 1 -
>  drivers/scsi/ufs/ufshcd.c | 2 +-
>  2 files changed, 1 insertion(+), 2 deletions(-)
> 
Thanks!
Acked-by: Alim Akhtar <alim.akhtar@samsung.com>

> --
> 2.17.1


