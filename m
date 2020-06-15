Return-Path: <SRS0=1R64=74=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD0A8C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 16:24:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6CAA2078E
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 16:24:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="nk+CrK+q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731008AbgFOQYU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Jun 2020 12:24:20 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:26469 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730795AbgFOQYP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jun 2020 12:24:15 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200615162410epoutp01a8848fe5d891ad431f0fad337fe4a907~YxEC2rrox1537515375epoutp01Z
        for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2020 16:24:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200615162410epoutp01a8848fe5d891ad431f0fad337fe4a907~YxEC2rrox1537515375epoutp01Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592238250;
        bh=BEyEvCjpVeZ0zAtPUpZTgBK+qidw68l28PlKRvrd7jk=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=nk+CrK+qc0f8ji52XtUiNy90799GBidX1zYiF7LTklutrm0zGDpEyzSPXGwyUWWR4
         F1Lam81jeItu+474IkdKRH+cdqULbjtQG8n/ZIpeL9SFFwSQt7nAV4Rz93uWIwaGwP
         VlkY2NPWF0m8uzb6JmQqydo6Dl9SyBzNPKAtnj4E=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20200615162409epcas5p1076dad5980246b4ed9585b73bdd7d4d6~YxECOMLhF0740907409epcas5p1h;
        Mon, 15 Jun 2020 16:24:09 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        47.26.09475.9A0A7EE5; Tue, 16 Jun 2020 01:24:09 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200615162408epcas5p3c8bfc7f248fa72fd01156d39851e628d~YxEBRa4iD0964309643epcas5p30;
        Mon, 15 Jun 2020 16:24:08 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200615162408epsmtrp1a573006830526845280bb8711ad00873~YxEBQlGE12292522925epsmtrp1F;
        Mon, 15 Jun 2020 16:24:08 +0000 (GMT)
X-AuditID: b6c32a4b-389ff70000002503-c3-5ee7a0a9c69e
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        9E.2E.08382.8A0A7EE5; Tue, 16 Jun 2020 01:24:08 +0900 (KST)
Received: from alimakhtar02 (unknown [107.108.234.165]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200615162405epsmtip19e7d7fb67d9663b3e7591a2ca5be9e08~YxD_UUEA-2560325603epsmtip1s;
        Mon, 15 Jun 2020 16:24:05 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     <kishon@ti.com>
Cc:     <kbuild-all@lists.01.org>, <clang-built-linux@googlegroups.com>,
        <devicetree@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <krzk@kernel.org>, <avri.altman@wdc.com>,
        <martin.petersen@oracle.com>, <kwmad.kim@samsung.com>,
        <stanley.chu@mediatek.com>, <cang@codeaurora.org>,
        <linux-samsung-soc@vger.kernel.org>,
        "'kernel test robot'" <lkp@intel.com>
In-Reply-To: <202006131334.EEnoEaXS%lkp@intel.com>
Subject: RE: [RESEND PATCH v10 07/10] phy: samsung-ufs: add UFS PHY driver
 for samsung SoC
Date:   Mon, 15 Jun 2020 21:54:03 +0530
Message-ID: <000101d64331$65230260$2f690720$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJxKJl1qzUofIPujdEacJl88XyIuwGkdPiqAy1Y4e2nfYD4sA==
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNKsWRmVeSWpSXmKPExsWy7bCmuu7KBc/jDK6c1bJ4+fMqm8Wn9ctY
        LR68mc1mMf/IOVaLs93XGC0uPO1hszh/fgO7xc0tR1ksZpzfx2TRfX0Hm8Wr5kdsFsuP/2Oy
        WLr1JqMDr8flvl4mjz0TT7J5LN7zkslj06pONo/u2f9YPFpO7mfx+Pj0FotH35ZVjB7Hb2xn
        8vi8Sc6j/UA3UwB3FJdNSmpOZllqkb5dAlfGm7sLWAo6eSp2nnnF1MC4jKuLkYNDQsBE4t9d
        6y5GLg4hgd2MEt0nZjBCOJ8YJW5vPssM4XxjlNi1YD9LFyMnWMfVKW+hEnsZJS41b2eDcN4w
        Spw82cEMUsUmoCuxY3EbG4gtIiAssXnfW7AiZoHnTBLTnr5jAklwChhJvNrdwgpiCwvESOxs
        fAzWzCKgKtH4bT2YzStgKXGv8QWULShxcuYTsDOYBeQltr+dwwxxkoLEz6fLWCGWOUmc3L2G
        DaJGXOLozx6wUyUEvnBILP24jh2iwUXi+9wfUP8IS7w6vgUqLiXxsr+NHRIy2RI9u4whwjUS
        S+cdgyq3lzhwZQ4LSAmzgKbE+l36EKv4JHp/P2GC6OSV6GgTgqhWlWh+dxWqU1piYnc3K4Tt
        IbHp3jb2CYyKs5A8NgvJY7OQPDALYdkCRpZVjJKpBcW56anFpgXGeanlesWJucWleel6yfm5
        mxjB6U/Lewfjowcf9A4xMnEwHmKU4GBWEuE9JP88Tog3JbGyKrUoP76oNCe1+BCjNAeLkjiv
        0o8zcUIC6YklqdmpqQWpRTBZJg5OqQamQyffFsQIMrx4+vho23v5KzqOzB6vztp1fVlZLxl0
        X/Nve0nRfpUilyL3fzumKBbHqWVOvlNvXX6bXWLv5tP27tdfnncq6ujiYY1bN2WGgI/Kef0c
        Ycm96XcPs2RzHapYv+bg7G/lCfNnywuqGuqEu6UvjDY4MPexhqnah03KBtd23/S7FRFx3jss
        d0pTAsM0ifA10ze2dwZovvRdv7WUJ/pdfdIhM72ij3MEW/1u/6+relC/NH3h+lP2V1R6jLss
        /q0SWFJ4XjevaIGXyabcn0/FkkP7uZrvm8y+JCVbInAywcPv04I92eJ+t09ZG7ef+PdR8fq3
        0zUpxr55Obuqn72r+dGuucr2WGryd0YlluKMREMt5qLiRAALl04q7gMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsWy7bCSnO6KBc/jDDp3aFm8/HmVzeLT+mWs
        Fg/ezGazmH/kHKvF2e5rjBYXnvawWZw/v4Hd4uaWoywWM87vY7Lovr6DzeJV8yM2i+XH/zFZ
        LN16k9GB1+NyXy+Tx56JJ9k8Fu95yeSxaVUnm0f37H8sHi0n97N4fHx6i8Wjb8sqRo/jN7Yz
        eXzeJOfRfqCbKYA7issmJTUnsyy1SN8ugSvjzd0FLAWdPBU7z7xiamBcxtXFyMkhIWAicXXK
        W+YuRi4OIYHdjBIHXrxggkhIS1zfOIEdwhaWWPnvOTtE0StGid3LnzKCJNgEdCV2LG5jA7FF
        gIo273vLBlLELPCVSWLisr+MEB1bGCXaPuxiBqniFDCSeLW7hRXEFhaIkmib+xFsHYuAqkTj
        t/VgNbwClhL3Gl9A2YISJ2c+Yeli5ACaqifRthFsMbOAvMT2t3OYIa5TkPj5dBkrxBFOEid3
        r2GDqBGXOPqzh3kCo/AsJJNmIUyahWTSLCQdCxhZVjFKphYU56bnFhsWGOallusVJ+YWl+al
        6yXn525iBMexluYOxu2rPugdYmTiYDzEKMHBrCTCe0j+eZwQb0piZVVqUX58UWlOavEhRmkO
        FiVx3huFC+OEBNITS1KzU1MLUotgskwcnFINTOfqeOY/EUhj+jbdVCjr3OQvTyP/5pelzf26
        oVdz61H37Ovf2w/n89zlNm/+IRe280v6n8S+LV4bbh9LPcS3IbPT+yTL2T9lJTP/9F2W2dN9
        WbuHZ5/46i8zPyuIPbh5+EOC+ZbT0nLWF7bPSC/Z7Hq77oJFnHkK0+szgt5Juow79aa5LShm
        +MWg2rfO4GNqccrxzQef2779upQ/+8KNCT4zP/TGr9WNTJni7Lixsv/XqdaF3NO+BIlM65rP
        nup7Pv+pyJmtO25vSNLV365/48N83fCTdzcqRP/OWq17/gLHg2114l9ffV3z++veyyd3bhfb
        vylJeYPax8vvN52dfa7pWFbC3VkvFcsPB+hpd1nvUmIpzkg01GIuKk4EAJd1RTVSAwAA
X-CMS-MailID: 20200615162408epcas5p3c8bfc7f248fa72fd01156d39851e628d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200613052521epcas5p140d979df19fae20c858c485409596a7a
References: <20200613024706.27975-8-alim.akhtar@samsung.com>
        <CGME20200613052521epcas5p140d979df19fae20c858c485409596a7a@epcas5p1.samsung.com>
        <202006131334.EEnoEaXS%lkp@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Kishon,

> -----Original Message-----
> From: kernel test robot <lkp@intel.com>
> All warnings (new ones prefixed by >>, old ones prefixed by <<):
> 
> >> drivers/phy/samsung/phy-samsung-ufs.c:47:5: warning: no previous
> >> prototype for function 'samsung_ufs_phy_wait_for_lock_acq'
> >> [-Wmissing-prototypes]
> int samsung_ufs_phy_wait_for_lock_acq(struct phy *phy) ^
> drivers/phy/samsung/phy-samsung-ufs.c:47:1: note: declare 'static' if the
> function is not intended to be used outside of this translation unit int
> samsung_ufs_phy_wait_for_lock_acq(struct phy *phy) ^ static
> >> drivers/phy/samsung/phy-samsung-ufs.c:77:5: warning: no previous
> >> prototype for function 'samsung_ufs_phy_calibrate'
> >> [-Wmissing-prototypes]
> int samsung_ufs_phy_calibrate(struct phy *phy) ^
> drivers/phy/samsung/phy-samsung-ufs.c:77:1: note: declare 'static' if the
> function is not intended to be used outside of this translation unit int
> samsung_ufs_phy_calibrate(struct phy *phy) ^ static
> 2 warnings generated.
> 
Not sure, how to handle this here, is this something that you can take care
while applying this patch? Or
Shell in send another patch to fix this warning reported by test robot?
(Other patches in this series is already taken in respective tree)

> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://protect2.fireeye.com/url?k=9d5936bf-c0c2cadc-9d58bdf0-
> 0cc47a31cdbc-
> 6ed890c1e74d92a7&q=1&u=https%3A%2F%2Flists.01.org%2Fhyperkitty%2Flist
> %2Fkbuild-all%40lists.01.org

