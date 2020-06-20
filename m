Return-Path: <SRS0=CpYn=AB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8F6CC433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Jun 2020 01:59:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4BC722450
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Jun 2020 01:59:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="oX1UTtOW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731631AbgFTB7d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Jun 2020 21:59:33 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:20773 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731607AbgFTB7b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jun 2020 21:59:31 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200620015927epoutp02400c5a56cba0fb1608c792296b9290bf~aHfeZyNB33190931909epoutp02O
        for <linux-scsi@vger.kernel.org>; Sat, 20 Jun 2020 01:59:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200620015927epoutp02400c5a56cba0fb1608c792296b9290bf~aHfeZyNB33190931909epoutp02O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592618367;
        bh=KdLaFttTZsyLbLRvJHiqZZhUTfRUx/An8XWa/zYCky0=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=oX1UTtOWCoE5jUMS2elv7zih/NrgIjrYfj26zQDF7JtaQWbNDvu7nofN1zZEApbhr
         qGolaSt1rlf4BnmObwyJwKATJNucFtBN9p1sUBm17I0Jx1TI0pEy3zUdcNy1axGl62
         zeIQt+OYsfoYiGkpQo8ojgqxWmIqPSTF5fFv2GMY=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20200620015926epcas5p38d9b638e7ae6c699ed72a6d851962376~aHfdv7hBN1787917879epcas5p3M;
        Sat, 20 Jun 2020 01:59:26 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        84.5F.09467.E7D6DEE5; Sat, 20 Jun 2020 10:59:26 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200620015926epcas5p3bf08a9d9d8adab3e024bc8142a3d5b5a~aHfdKypJD1117311173epcas5p3b;
        Sat, 20 Jun 2020 01:59:26 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200620015926epsmtrp1fcbb557b35ef1f78d20aa5ef881c26c1~aHfdHT9A21621516215epsmtrp1n;
        Sat, 20 Jun 2020 01:59:26 +0000 (GMT)
X-AuditID: b6c32a49-a29ff700000024fb-79-5eed6d7e42e9
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        9C.51.08303.D7D6DEE5; Sat, 20 Jun 2020 10:59:26 +0900 (KST)
Received: from alimakhtar02 (unknown [107.108.234.165]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200620015921epsmtip2d2869c2bab2e67208638cb55561d2589~aHfYlhY5W2707527075epsmtip2W;
        Sat, 20 Jun 2020 01:59:20 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Kishon Vijay Abraham I'" <kishon@ti.com>, <robh@kernel.org>
Cc:     <krzk@kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <avri.altman@wdc.com>, <stanley.chu@mediatek.com>,
        <linux-scsi@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <cang@codeaurora.org>,
        <devicetree@vger.kernel.org>, <kwmad.kim@samsung.com>,
        <linux-kernel@vger.kernel.org>, "'Vinod Koul'" <vkoul@kernel.org>,
        "'Martin K. Petersen'" <martin.petersen@oracle.com>
In-Reply-To: 
Subject: RE: [PATCH v10 00/10] exynos-ufs: Add support for UFS HCI
Date:   Sat, 20 Jun 2020 07:29:18 +0530
Message-ID: <000001d646a6$6cb5fd70$4621f850$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQNA14zZ9KpC6NxovY65uGX80LQ4kgIpylB3AdlmWUMBx1WEmQIl7Fhypb7UH7CADUNgsA==
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEKsWRmVeSWpSXmKPExsWy7bCmhm5d7ts4gwlXtC1e/rzKZvFp/TJW
        i/lHzrFaXHjaw2Zx/vwGdoubW46yWGx6fI3V4vKuOWwWM87vY7Lovr6DzWL58X9MFv/37GC3
        WLr1JqPFzjsnmB34PC739TJ5bFrVyeaxeUm9R8vJ/SweH5/eYvHo27KK0eP4je1MHp83yXm0
        H+hmCuCM4rJJSc3JLEst0rdL4MronXqJueA4e8XzjmVsDYxfWbsYOTgkBEwkNm2w6mLk4hAS
        2M0osfn3HGYI5xOjxMGjx1ggnM+MEid3PmTqYuQE61i3diETRGIXo8TlNQugWt4wShx7dYUV
        pIpNQFdix+I2NpAdIgKOEg274kBqmAWamSWOfe4Di3MK8EpM+GcNUi4s4CTxesUesAUsAqoS
        K7u7wGxeAUuJHceXsEPYghInZz5hAbGZBbQlli18zQxxkILEz6fLwNaKCIRJfH3yEapGXOLo
        zx6w2yQEHnBInGs8CdXgIjHl8T0oW1ji1fEt7BC2lMTL/jZ2SLhkS/TsMoYI10gsnXeMBcK2
        lzhwZQ4LSAmzgKbE+l36EKv4JHp/P2GC6OSV6GgTgqhWlWh+dxWqU1piYnc3NNA9JPqaRCcw
        Ks5C8tcsJH/NQnL/LIRdCxhZVjFKphYU56anFpsWGOallusVJ+YWl+al6yXn525iBCc7Lc8d
        jHcffNA7xMjEwXiIUYKDWUmE9/D7N3FCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeZV+nIkTEkhP
        LEnNTk0tSC2CyTJxcEo1MEWuEZ+wSevR/fYuPfZLuzy3LWMocTHNdiwTmp3wV8hiP1/0ZU6l
        UJu/0+5/2Hnv3LSHx4ME7l02vLl7wQWTiN2eAaK+TI1C22bIN1lNODw5zIdtFt/eZDmDMpZZ
        mW/WC28Ncu+yncn+7fq3ym/csyev1xU8U7xAtdRhYiXLHt1Ln1viz51u8UvYxD9xgVGkRcCb
        RNfXq5c37vhcc0rspMLKWQvf1N1r+fXeuyPyooyseaGzZuKz+s5Jx9pnVPEy13AeYH4188jf
        xaaKl3wKz88qneK14LRiz+J8uaBUu22KfYLFrw7npiyb0cvwLNvx3IXdQu29FzleK35/aHLS
        Vicy5M/6i/ueCydUec7JnKrEUpyRaKjFXFScCADjEVON5QMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsWy7bCSvG5d7ts4g19tTBYvf15ls/i0fhmr
        xfwj51gtLjztYbM4f34Du8XNLUdZLDY9vsZqcXnXHDaLGef3MVl0X9/BZrH8+D8mi/97drBb
        LN16k9Fi550TzA58Hpf7epk8Nq3qZPPYvKTeo+XkfhaPj09vsXj0bVnF6HH8xnYmj8+b5Dza
        D3QzBXBGcdmkpOZklqUW6dslcGU0NF9gLtjEXnF89kGmBsZHrF2MnBwSAiYS69YuZAKxhQR2
        MEr8OW0HEZeWuL5xAjuELSyx8t9zIJsLqOYVo8SjS6cZQRJsAroSOxa3sYHYIgLOEne3PWUF
        KWIW6GeW2HJ/E1THMiaJh5f+AK3g4OAU4JWY8M8apEFYwEni9Yo9YJtZBFQlVnZ3gdm8ApYS
        O44vYYewBSVOznzCAmIzC2hLPL35FM5etvA1M8R1ChI/ny5jhTgiTOLrk49QNeISR3/2ME9g
        FJ6FZNQsJKNmIRk1C0nLAkaWVYySqQXFuem5xYYFRnmp5XrFibnFpXnpesn5uZsYwbGrpbWD
        cc+qD3qHGJk4GA8xSnAwK4nwHn7/Jk6INyWxsiq1KD++qDQntfgQozQHi5I479dZC+OEBNIT
        S1KzU1MLUotgskwcnFINTKm2QeoLxG/p2817qGsWVa1woGeO1eLm6Ys/MU2Qi0tQ/vCSfdU6
        CY7e7fx1bG/+8/r1GW2exMkZl2KcvrOsdF34RcF+ptrzMmeetsfKCr50WXlFfEZmo+N5xn/c
        v40Wnuc1mPGNO+y3xUMu1TcnzU/eWxxpFPnoZtkhtQapgKXqLt9K8/e9jr5rNDmg3raG+SOX
        5ZrFb9XNEm54XzFaF9A7waGzosl2z60TkQsubHPe1nHZZPqG5z6tey5nbjz9eJN3YertxxGe
        22Z7nBZsOKcfdW7KTH+XyTXLdWaIKhR/e8Tt5dnDVsZR6W4Q0XO08LGUsqCP2OtY2YbXBbll
        l+Zxzt7f1WK0rYNtjbmJEktxRqKhFnNRcSIABRKlukwDAAA=
X-CMS-MailID: 20200620015926epcas5p3bf08a9d9d8adab3e024bc8142a3d5b5a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200528013223epcas5p2be85fa8803326b49a905fb7225992cad
References: <CGME20200528013223epcas5p2be85fa8803326b49a905fb7225992cad@epcas5p2.samsung.com>
        <20200528011658.71590-1-alim.akhtar@samsung.com>
        <159114947915.26776.12485309894552696104.b4-ty@oracle.com>
        <013a01d63d3e$ecf404d0$c6dc0e70$@samsung.com>
        <89b96bd0-a9a3-cdd8-dc67-1f9f49eef264@ti.com> 
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Kishon,

> -----Original Message-----
> From: Alim Akhtar <alim.akhtar=40samsung.com>
> Sent: 11 June 2020 20:49
> To: 'Kishon Vijay Abraham I' <kishon=40ti.com>; 'Martin K. Petersen'
> > >>
> > >> Applied =5B1,2,3,4,5,9=5D to 5.9/scsi-queue. The series won't show u=
p
> > >> in my
> > > public
> > >> tree until shortly after -rc1 is released.
> > >>
> > > Thanks Martin,
> > > Hi Rob and Kishon/Vinod
> > > Can you please pickup dt-bindings and PHY driver respectively?
> >
> > You might have CC'ed me only for the PHY patch. I don't have the
> > dt-bindings in my inbox. Care to re-send what's missing again? This
> > will be merged after -rc1 is tagged.
> >

-rc1 is out, I do not see phy driver patch in your tree=5B1=5D yet, let me =
know if I am looking into right tree.
=5B1=5D -> git://git.kernel.org/pub/scm/linux/kernel/git/phy/linux-phy.git

Thanks=21=20

> Sure, will re-send this series.
>=20
> > Thanks
> > Kishon

