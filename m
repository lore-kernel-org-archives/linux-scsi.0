Return-Path: <SRS0=Tsb4=6F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4500AC54FCB
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 00:59:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24ECD2078C
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 00:59:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Pq54sHDj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbgDUA7c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Apr 2020 20:59:32 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:42882 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbgDUA7c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Apr 2020 20:59:32 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200421005929epoutp0259ecf0d4044d56e394c914df0dc0db54~Hr9-XcarY1414214142epoutp02M
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2020 00:59:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200421005929epoutp0259ecf0d4044d56e394c914df0dc0db54~Hr9-XcarY1414214142epoutp02M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1587430769;
        bh=LYW5DmJgoPb7LB4JzUV52hR/PII0bF9iE3OA33GLTq0=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=Pq54sHDjw06OaLpkN8RqFZsIM1Xjg+arBQguNlfUti+ITtW/zgKRNI4z805TkbTXa
         MCitQJ5DUl//mbgUBdOLanJ94FOYBukBJ25txApeCsM+bqPT7dJptnj9QmKFDvPG7s
         rBq64WgtUvH5T9BwxgW8tvLjrRJipe8qnFWWIfKI=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20200421005928epcas5p4f7b51758feb9d1482de7b82c135fda71~Hr9_PTIid1071210712epcas5p4c;
        Tue, 21 Apr 2020 00:59:28 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        09.2E.04782.0754E9E5; Tue, 21 Apr 2020 09:59:28 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20200421005927epcas5p169031aa337f797611b67a8272d997236~Hr99VYeCL0404404044epcas5p1F;
        Tue, 21 Apr 2020 00:59:27 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200421005927epsmtrp1b8e08e4e3eb40e4e920cbd2ce2ebea3a~Hr99Uid5z2251822518epsmtrp1n;
        Tue, 21 Apr 2020 00:59:27 +0000 (GMT)
X-AuditID: b6c32a49-8b3ff700000012ae-e2-5e9e45707a2f
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F6.A2.04024.F654E9E5; Tue, 21 Apr 2020 09:59:27 +0900 (KST)
Received: from alimakhtar02 (unknown [107.108.234.165]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200421005923epsmtip1b2a60879cd5b82845f4c5b8ddb555e15~Hr95ZnAWe0436404364epsmtip1H;
        Tue, 21 Apr 2020 00:59:22 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Avri Altman'" <Avri.Altman@wdc.com>, <robh@kernel.org>
Cc:     <devicetree@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <krzk@kernel.org>, <martin.petersen@oracle.com>,
        <kwmad.kim@samsung.com>, <stanley.chu@mediatek.com>,
        <cang@codeaurora.org>, <linux-samsung-soc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <SN6PR04MB464049754716338FA4202E62FCD40@SN6PR04MB4640.namprd04.prod.outlook.com>
Subject: RE: [PATCH v6 09/10] scsi: ufs-exynos: add UFS host support for
 Exynos SoCs
Date:   Tue, 21 Apr 2020 06:29:20 +0530
Message-ID: <000001d61778$1ad10a70$50731f50$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJQDPill8kAmUENoj8JBCZ49rLenQJwluT7Ac8KJGcDHzROdqdT3pZg
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUhTYRTHe+7brsPF4xx6MrMaRGhYSgY3svSDxo0SKqIPUuawi4Zuji0r
        o0go1Jzv9KLL1KitWB8m2xxDq5n5kkTNmFZa2gddUJnlAkONzO0m+e13zvn/Oef/8LCk3EtH
        sac0pwWdRlWgZKSU81ns5nhtenNWgsERxn2eG2Y4v9VMcy09r2jO42mTcCOOXoqzTbyhOW9H
        E8M1eJ4QnOGti+Hu9/8huMVHLglnah9BqaG8t7qK4G2Wqwxvv3eJvzLgpvgZ3yjFVzssiP9p
        i+HLugzEQTZTmnxSKDh1RtBt25MtzaufNyFtufRc3+Q3sgTdYytQCAs4CRp6fqAKJGXluBPB
        0PsySiz8COoXDaRYzCJo8A1Ty5bF61eZAMvxYwQTFQpRNIVg7NoXSWDA4Hhw3S0NihQ4GR72
        1TIBEYnbCOh2W8nAIAQfh5uXF4kAh+Oj8ODlaNBM4U3w7MNssC/DO2HQ/guJHAYDjZPBK0i8
        Bcx3vpLiRRtgzmemxWV7ocb3ghA1kdA7VxmMANgsgUZPLyMa0mB4yPzPHA5f+h0SkaPgc03p
        ErNLnA+VHdvF9gUwNff9S58CXUNNVEBC4liwdmwTV62GqoVJQnTKoLxULqo3weXp5XdbC3UG
        Ay0yDyXjVlSLNhpXBDOuCGZcEcD4f1kroixojaDVq3MF/Q5tokY4u1WvUuuLNLlbcwrVNhT8
        anH7XMj46kA3wixShsraIpqz5LTqjL5Y3Y2AJZUKGRe31JKdVBWfF3SFJ3RFBYK+G61lKWWk
        rJ4ePibHuarTQr4gaAXd8pRgQ6JKUER7gp3JjA5diE/yW6iZbKs7Hw4fmkrMDP/oJKNrnWpd
        2uj6ut3zbS7T9+SGjJmwO2M//CmD4zmd0+5VA4UvzmdeHLJPbPR5Em7L01tSYr491aTPDzjr
        jtzIWVOYuq5fnb9L0fj71rvns8SniPUjka2D2a+1Cxl4v9uL6Xprs5LS56kS40idXvUXxc5B
        rmYDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsWy7bCSnG6+67w4g5PPhS1e/rzKZvFp/TJW
        i/lHzrFanD+/gd3i5pajLBabHl9jtbi8aw6bxYzz+5gsuq/vYLNYfvwfk8X/PTvYLZZuvcno
        wONxua+XyWPTqk42j81L6j1aTu5n8fj49BaLR9+WVYwenzfJebQf6GYK4IjisklJzcksSy3S
        t0vgypi1pZ+p4BZnxad/R5kaGL+xdzFyckgImEj8n9rJ1sXIxSEksJtRYt29D0wQCWmJ6xsn
        QBUJS6z895wdougVo8SaxmXMIAk2AV2JHYvb2EBsEQE7iVeTLzKCFDEL7GKS2HpvGxNEx0Qm
        iV9vF7CCVHEKxEpMb/4PtkJYIESidcM9sEksAqoSh+98A4vzClhKXNj8nRHCFpQ4OfMJC4jN
        LKAt8fTmUzh72cLXzBDnKUj8fLqMFeIKN4n+p6eZIGrEJY7+7GGewCg8C8moWUhGzUIyahaS
        lgWMLKsYJVMLinPTc4sNCwzzUsv1ihNzi0vz0vWS83M3MYIjVEtzB+PlJfGHGAU4GJV4eDeI
        zYsTYk0sK67MPcQowcGsJMJroQUU4k1JrKxKLcqPLyrNSS0+xCjNwaIkzvs071ikkEB6Yklq
        dmpqQWoRTJaJg1OqgTFFv9jjlfePin2qqQ9CQv/uX+YTlMbQrbWT50yB3jv1pDv749nfBVxd
        nZUZ6Vq/c9OtuQv1neIvCGVmc7Z6vnzZ6TBfnvmz6+4VW4wEqk9+n334paFg/AVzX/0g4W93
        Z/YE3PQxkD9xcPXniQ+euW+Omm7uteTIL+60HU+M38/zOivR3Ln4qpcSS3FGoqEWc1FxIgBF
        eQ44zAIAAA==
X-CMS-MailID: 20200421005927epcas5p169031aa337f797611b67a8272d997236
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200417181024epcas5p4231ae3dd2598155854e9b7ee52438bcb
References: <20200417175944.47189-1-alim.akhtar@samsung.com>
        <CGME20200417181024epcas5p4231ae3dd2598155854e9b7ee52438bcb@epcas5p4.samsung.com>
        <20200417175944.47189-10-alim.akhtar@samsung.com>
        <SN6PR04MB464049754716338FA4202E62FCD40@SN6PR04MB4640.namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Avri,

> -----Original Message-----
> From: Avri Altman <Avri.Altman=40wdc.com>
> Sent: 20 April 2020 15:56
> To: Alim Akhtar <alim.akhtar=40samsung.com>; robh=40kernel.org
> Cc: devicetree=40vger.kernel.org; linux-scsi=40vger.kernel.org; krzk=40ke=
rnel.org;
> martin.petersen=40oracle.com; kwmad.kim=40samsung.com;
> stanley.chu=40mediatek.com; cang=40codeaurora.org; linux-samsung-
> soc=40vger.kernel.org; linux-arm-kernel=40lists.infradead.org; linux-
> kernel=40vger.kernel.org
> Subject: RE: =5BPATCH v6 09/10=5D scsi: ufs-exynos: add UFS host support =
for Exynos
> SoCs
>=20
> > +       struct exynos_ufs_drv_data *drv_data;
> > +
> > +       u32 opts;
> > +=23define EXYNOS_UFS_OPT_HAS_APB_CLK_CTRL                BIT(0)
> > +=23define EXYNOS_UFS_OPT_SKIP_CONNECTION_ESTAB   BIT(1)
> > +=23define EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL    BIT(2)
> > +=23define EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX       BIT(3)
> > +=23define EXYNOS_UFS_OPT_USE_SW_HIBERN8_TIMER    BIT(4)
> Could not find where the last 2 are being used.
>=20
The assignment is done on line=23 988 and 989 in exynos_ufs_init() and used=
 in =7Bpre,post=7D_hibern8,=20
let me see if I can add these in the list of .opts in drv_data.
Thanks for pointing this out.

> Thanks,
> Avri

