Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=BAYES_00,
	CHARSET_FARAWAY_HEADER,DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1DF2C4708F
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 03:09:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDBC1613B8
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 03:09:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbhFCDLl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Jun 2021 23:11:41 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:52105 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbhFCDKt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jun 2021 23:10:49 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210603030904epoutp01b4d34e21b68739e001f06521784de1e1~E87mdbifd1154911549epoutp01-
        for <linux-scsi@vger.kernel.org>; Thu,  3 Jun 2021 03:09:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210603030904epoutp01b4d34e21b68739e001f06521784de1e1~E87mdbifd1154911549epoutp01-
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1622689744;
        bh=uXFNGr7iIsoHmsC2Yt6YGJWzJGS7MPdT00sEobYt6ec=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=PWywPvofIg9/oyD6MT1nThOAjoM1vqOWghA+ZlCM/9d2TvGbALMO/imIEL1t+fU9I
         9Styh9KSyGRwGWS/abQ/yxq5IEUTQC9tSdeHXMtCvs5gclEgAdoMKOuWtkK3R+L/nY
         zpA3ow/JYxNQ3JnSRbmeQNhjHEB6+35FXOD5S31I=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20210603030903epcas2p1ca60f2b01db2715c57e10f243bcd2b14~E87mB5fn22844428444epcas2p1S;
        Thu,  3 Jun 2021 03:09:03 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.190]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4FwW7x5hN3z4x9Q8; Thu,  3 Jun
        2021 03:09:01 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        10.B3.09717.AC748B06; Thu,  3 Jun 2021 12:08:58 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20210603030857epcas2p3538825761fc42b6ca798b259c9da6970~E87gZ9alc0640906409epcas2p3u;
        Thu,  3 Jun 2021 03:08:57 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210603030857epsmtrp2c5ad286f1d1a512f7b34f3720e48c4b8~E87gZK3im1293512935epsmtrp2k;
        Thu,  3 Jun 2021 03:08:57 +0000 (GMT)
X-AuditID: b6c32a48-4e5ff700000025f5-5d-60b847ca0282
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        FB.08.08163.9C748B06; Thu,  3 Jun 2021 12:08:57 +0900 (KST)
Received: from KORDO039821 (unknown [10.229.8.133]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210603030857epsmtip242bc5a7f346995b4973bb5fe07820b2a~E87gIAeaJ0795707957epsmtip29;
        Thu,  3 Jun 2021 03:08:57 +0000 (GMT)
From:   =?ks_c_5601-1987?B?waTBvrnO?= <jjmin.jeong@samsung.com>
To:     "'Christoph Hellwig'" <hch@infradead.org>
Cc:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <cang@codeaurora.org>, <beanhuo@micron.com>,
        <adrian.hunter@intel.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <YK9RkXoLsUT38cTP@infradead.org>
Subject: RE: [PATCH 1/3] scsi: ufs: add quirk to handle broken UIC command
Date:   Thu, 3 Jun 2021 12:08:57 +0900
Message-ID: <000001d75825$cb0ab5f0$612021d0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ks_c_5601-1987"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQIoW8PMwO5SDtoUto4XDMUWk4sZmgFpFnawAa5jbJkC4eUAGqovwbbQ
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNJsWRmVeSWpSXmKPExsWy7bCmue4p9x0JBmt6eS1OPlnDZvFg3jY2
        i5c/r7JZHHzYyWLxaf0yVovTExYxWSy6sY3J4vKuOWwW3dd3sFksP/6PyYHL43JfL5PH5hVa
        Hov3vGTymLDoAKPH9/UdbB4fn95i8ejbsorR4/MmOY/2A91MAZxROTYZqYkpqUUKqXnJ+SmZ
        eem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QIcqKZQl5pQChQISi4uV9O1sivJL
        S1IVMvKLS2yVUgtScgoMDQv0ihNzi0vz0vWS83OtDA0MjEyBKhNyMi4vPM5a8IK14v+GOcwN
        jEdZuhg5OSQETCSuvp7C2MXIxSEksINR4tHjl2wQzidGidtfW5hBqoQEPjNKtG0K6WLkAOvY
        8CYAIryLUeL6FgWI+heMEnNmzWcESbAJ2EpsOfyICcQWEdCVOLvwBdgGZoEvjBJ71p0AK+IE
        SqxsuwxmCwt4STz5Nw1sGYuAisTVhgOsIDavgKVE/6of7BC2oMTJmU/AzmYWMJJYsno+E4Qt
        L7H97RxmiHcUJH4+XcYKsdhN4tbyC8wQNSISszvbmEGOkBA4wyHRue4tVIOLRPPkBVC2sMSr
        41vYIWwpic/v9rJB2PUSuxv2QDVPYJTo7rwKDTx7iV/Tt7BCgkVZ4sgtqOP4JDoO/2WHCPNK
        dLQJQVSrSmxZvJERwpaWWLr2OMsERqVZSF6bheS1WUhem4XkhQWMLKsYxVILinPTU4uNCkyQ
        Y3sTIzgVa3nsYJz99oPeIUYmDsZDjBIczEoivHvUdiQI8aYkVlalFuXHF5XmpBYfYjQFhvZE
        ZinR5HxgNsgriTc0NTIzM7A0tTA1M7JQEuf9mVqXICSQnliSmp2aWpBaBNPHxMEp1cDk2R5Z
        2RIcv1m4vCpsdmbcjF+ar9inZ35XCdwgck/1zGHPjp0Wxiwsem/9/Ru6T/1d/SV9m/VMJQXT
        pWfFPziHL5DYPfl9tIDTM7mQl0s/1ds6yt+Yp8IjJfV8+WnfZVdWHmNb4bF478QyL/2NDG//
        8tSqc3hzaqtfiHy4pGdPamr0Y+fz3ZntrT48H3yX2W5JvbolvFJHUMsuZ50w97IOdhHpB13T
        vO/FaAZPdSm/KL5EYVH1mc/JISum1OV6ebVPXaLYcLNLROYA4yNOvZvbz6Rs1vHcdnD3lY+d
        k0tnM+dyHLGwXrps6urakD4B5338oTuCGF61BLy/EHj4yYaUwo0PPunx5GRdz/3alK3EUpyR
        aKjFXFScCADdzMbbTgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsWy7bCSvO5J9x0JBj/WqlmcfLKGzeLBvG1s
        Fi9/XmWzOPiwk8Xi0/plrBanJyxislh0YxuTxeVdc9gsuq/vYLNYfvwfkwOXx+W+XiaPzSu0
        PBbvecnkMWHRAUaP7+s72Dw+Pr3F4tG3ZRWjx+dNch7tB7qZAjijuGxSUnMyy1KL9O0SuDIu
        LzzOWvCCteL/hjnMDYxHWboYOTgkBEwkNrwJ6GLk4hAS2MEo8fTpfKi4tMSaPdJdjJxAprDE
        /ZYjrCC2kMAzRol52wVBbDYBW4kthx8xgdgiAroSZxe+YASZwyzwj1Fi+9dvLBBDHzBKLJn9
        F6ybE6hqZdtlRhBbWMBL4sm/acwgNouAisTVhgNgNbwClhL9q36wQ9iCEidnPmEBsZmBDm08
        3A1ly0tsfzuHGeI6BYmfT5exQlzhJnFr+QVmiBoRidmdbcwTGIVnIRk1C8moWUhGzULSsoCR
        ZRWjZGpBcW56brFhgVFearlecWJucWleul5yfu4mRnBEamntYNyz6oPeIUYmDsZDjBIczEoi
        vHvUdiQI8aYkVlalFuXHF5XmpBYfYpTmYFES573QdTJeSCA9sSQ1OzW1ILUIJsvEwSnVwGT2
        61tCXIZYS1tBKtue+yv+XvOXPv1zrujRSzb8m87ZJM54NOEiMzujUIrirJjg1RYKD7uXiXs/
        fsWp98Ss5GKnlXIF+9+lt6I3PF90+IMWz/Zk7rM9EX/zv847++OEo07H4q33lzN+2Os/cWpC
        gZVEW+MGq7VWf+oNO2fdb+8+opTYt/nC1FWLjauLPKziuQKXPp/tuWDOgsA9KgJHtCQfhz/X
        lzUS4GzbrbPb5Fr5tuTjHwzDd/RuPvdcSXIb61TDHQd6g3ee13+ULH82rvjd3O31vHGetizt
        9pfi7HSvb29vyMhKdXZv73t0h2nVM7XGuc7fb3rxFT/nZu+dyHRvifCcLaarX4l2SbyWuqzE
        UpyRaKjFXFScCADsX5h5NwMAAA==
X-CMS-MailID: 20210603030857epcas2p3538825761fc42b6ca798b259c9da6970
X-Msg-Generator: CA
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210527031219epcas2p313fcf248833cf14ec9a164dd91a1ca13
References: <20210527030901.88403-1-jjmin.jeong@samsung.com>
        <CGME20210527031219epcas2p313fcf248833cf14ec9a164dd91a1ca13@epcas2p3.samsung.com>
        <20210527030901.88403-2-jjmin.jeong@samsung.com>
        <YK9RkXoLsUT38cTP@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > samsung ExynosAuto SoC has two types of host controller interface to
> > support the virtualization of UFS Device.
> > One is the physical host(PH) that the same as conventaional UFSHCI,
> > and the other is the virtual host(VH) that support data transfer
> function only.
> 
> You forgot to include the hunk that actually sets the quirk.

thanks for your review.
We will set up the quirk in exynos ufs driver.
I will upload the patch together in v2 patchs.

> 
> Also please work on the commit log formatting.

I'll erase the change-id log next patch too. Thank you.

> 
> > Change-Id: Ie528726b29bcb643149440bf1c90eaa5995c5ac1
> 
> This kind of crap has no business in a commit log.

Best Regards,
Jongmin jeong

