Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56EC5C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 02:18:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F2A023117
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 02:18:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727918AbhAMCSW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 21:18:22 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:30316 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbhAMCSW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 21:18:22 -0500
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210113021740epoutp02444341c3dd86042c765d5391a4612526~ZqRd_agrn2588425884epoutp02G
        for <linux-scsi@vger.kernel.org>; Wed, 13 Jan 2021 02:17:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210113021740epoutp02444341c3dd86042c765d5391a4612526~ZqRd_agrn2588425884epoutp02G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1610504260;
        bh=wuOlOAyTDDjXiWwcDeJRL0JQlFPqFobWkJdWGwGnf80=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=uR+fzBAML9LqrpHEM7Z87YMP+XsMXqGTbOgFV5tcZ0FiF1njqmMIw7l6ZuvC8Z43L
         RgMX/0RSX8gORrwwoDMgTuhXnAEx3AFFRJ/IM+aedml5/YxWay9JaHjq0ltrp1Sz4x
         wmsft6uhJXb380gg97O1diFhXGbJeJxw2niiPFgM=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210113021739epcas2p28ab30c0ced305150167a05999774839d~ZqRdvV9st0175801758epcas2p2s;
        Wed, 13 Jan 2021 02:17:39 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.189]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4DFrgj1BHxz4x9QG; Wed, 13 Jan
        2021 02:17:37 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        F0.07.52511.D385EFF5; Wed, 13 Jan 2021 11:17:33 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20210113021733epcas2p1509de925ab3bd64a03b73648c721ecc7~ZqRXWhrOk2556425564epcas2p1Z;
        Wed, 13 Jan 2021 02:17:33 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210113021733epsmtrp2be9a20936cb71684b16cf44b9c146926~ZqRXV9sW12867728677epsmtrp2f;
        Wed, 13 Jan 2021 02:17:33 +0000 (GMT)
X-AuditID: b6c32a48-4f9ff7000000cd1f-12-5ffe583dac7a
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        6E.85.13470.C385EFF5; Wed, 13 Jan 2021 11:17:32 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210113021732epsmtip13d3aa1c931b5233782b331605642db58~ZqRXMHFRv0272502725epsmtip1t;
        Wed, 13 Jan 2021 02:17:32 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Avri Altman'" <Avri.Altman@wdc.com>, <linux-scsi@vger.kernel.org>
In-Reply-To: <DM6PR04MB65753000A58B9C4A8BAB28E2FCAA0@DM6PR04MB6575.namprd04.prod.outlook.com>
Subject: RE: [RESEND PATCH v3 0/2] permit vendor specific values of unipro
 timeouts
Date:   Wed, 13 Jan 2021 11:17:32 +0900
Message-ID: <000601d6e952$4028e3e0$c07aaba0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQLX/iijQroPUkLsvIKStvrZ0x/H/gGsscGLAb6oX7ioB0yD0A==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAKsWRmVeSWpSXmKPExsWy7bCmma5txL94g81nlS1e/rzKZtF9fQeb
        A5PH501yHu0HupkCmKJybDJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1Nt
        lVx8AnTdMnOAxisplCXmlAKFAhKLi5X07WyK8ktLUhUy8otLbJVSC1JyCgwNC/SKE3OLS/PS
        9ZLzc60MDQyMTIEqE3IyFr26xFbwm7Xi+ON3zA2MR1i6GDk5JARMJD7fWcPWxcjFISSwg1Hi
        0PqtTBDOJ0aJmS1HWSGcb4wSf/f8YIVpmd98ACqxl1FiS8tuRgjnBaPEm6vrmECq2AS0JaY9
        3A3WISLgLvHv61VmEJtTIFbixIazYHFhgVCJ319mgsVZBFQlnn16wQ5i8wpYSnyf8pEZwhaU
        ODnzCdixzEAzly18zQxxhYLEz6fLoOY7SZzdvwyqRkRidmcbM8hBEgKH2CXWz5wJlOAAclwk
        3q2F6hWWeHV8CzuELSXx+d1eNgi7XmLf1AZWiN4eRomn+/4xQiSMJWY9a2cEmcMsoCmxfpc+
        xEhliSO3oNbySXQc/ssOEeaV6GgTgmhUlvg1aTLUEEmJmTfvQG31kNhzexL7BEbFWUienIXk
        yVlInpmFsHcBI8sqRrHUguLc9NRiowIT5MjexAhOeloeOxhnv/2gd4iRiYPxEKMEB7OSCG9R
        9994Id6UxMqq1KL8+KLSnNTiQ4ymwGCfyCwlmpwPTLt5JfGGpkZmZgaWphamZkYWSuK8RQYP
        4oUE0hNLUrNTUwtSi2D6mDg4pRqYpDQ3b4t/5DU/5PBCyUlnahvyPmpUzdp30aPMV0utIJVJ
        t++z6y72qxe4Pz0X2FvutN1sq/qqGXmmIf9MJ7dVmHb+KPnqkj5pXiVD7m3pDZrZpbatO/gS
        0uu0NW7InZP6oiP7RzGgRorzvdH72lOB393vC23mtVnqd+PfkuiC/ov87w6EmTTsn9kV6/Zi
        bUFCb578p8PdG4LrwmLCDrs4XN3432TxgoBNq04q/G7/pdYpGt/P5H7KtPv1DrGIM57H3Sr4
        s9Jlj/D8kXZr2ycZyLrs1KwlPjE6O16nHque7re7pJn7b/1ZUa8VNtKn/nAsdYipfFWkzH/1
        zsKIbzK/QhZviq87dVNGf5ucLoMSS3FGoqEWc1FxIgDEJxWdAwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsWy7bCSnK5NxL94g5X9FhYvf15ls+i+voPN
        gcnj8yY5j/YD3UwBTFFcNimpOZllqUX6dglcGQcXt7EWfGatuLDlN2sD4x6WLkZODgkBE4n5
        zQdYuxi5OIQEdjNK3JzzhhkiISlxYudzRghbWOJ+yxGoomeMEn8Pf2AHSbAJaEtMe7ibFcQW
        EfCUeLBoFwtE0W1Gif47E8GKOAViJU5sOAtWJCwQLHG38w8biM0ioCrx7NMLsBpeAUuJ71M+
        MkPYghInZz4BO48ZaEHvw1ZGGHvZwtdQ1ylI/Hy6DGqxk8TZ/cug6kUkZne2MU9gFJqFZNQs
        JKNmIRk1C0nLAkaWVYySqQXFuem5xYYFhnmp5XrFibnFpXnpesn5uZsYwYGupbmDcfuqD3qH
        GJk4GA8xSnAwK4nwFnX/jRfiTUmsrEotyo8vKs1JLT7EKM3BoiTOe6HrZLyQQHpiSWp2ampB
        ahFMlomDU6qBSblv19VT/mxr//6u5rf6GtkfeX/yPJ8TsZ+sN/8qn5is/uZHzhJXHzd7l865
        4rGeX+N+iYsnnvMwupsumHhY+sMp0x72vkrhO2+uPT0po9m8il/ULuJb1fzvK9Z5iEwK8dqi
        JXng7efNH0sfz0j3zbn0KEv7vW/CHA/7VctsXmV+Utr0V1zHXyzgf5V1rku3ZVp+cnf86epo
        D410PaErZ2pvu9z3qsw0UdG6LuGZ90owLNhU7dZB7YKHlh9WTxROd964tGDP2xDZEJGI1u4v
        aVddP8S1ZKquzAzWEhaday5XKmxVcp9jQ9mexvUPZl3rrZkn28vksDIwX5fn1raOpmsHw/Tv
        BPCmvJKVr1FiKc5INNRiLipOBACldVwt4wIAAA==
X-CMS-MailID: 20210113021733epcas2p1509de925ab3bd64a03b73648c721ecc7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210112025940epcas2p2f27c4f5e84f7f745a64027bdba536227
References: <CGME20210112025940epcas2p2f27c4f5e84f7f745a64027bdba536227@epcas2p2.samsung.com>
        <cover.1610419672.git.kwmad.kim@samsung.com>
        <DM6PR04MB65753000A58B9C4A8BAB28E2FCAA0@DM6PR04MB6575.namprd04.prod.outlook.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> This series already got accepted and picked by Martin. alim.akhtar=40sams=
ung.com
>=20
> Thanks,
> Avri

Hm. I tried to find it but failed.
Could you share where his comment is with me?

Thanks.
Kiwoong Kim
>=20
> >
> > v2 -> v3: remove change ids
> > v1 -> v2: change some comments and rename the quirk
> >
> > Kiwoong Kim (2):
> >   ufs: add a quirk not to use default unipro timeout values
> >   ufs: ufs-exynos: apply vendor specifics for three timeouts
> >
> >  drivers/scsi/ufs/ufs-exynos.c =7C  8 +++++++-
> >  drivers/scsi/ufs/ufshcd.c     =7C 40 +++++++++++++++++++++------------=
----
> ---
> >  drivers/scsi/ufs/ufshcd.h     =7C  6 ++++++
> >  3 files changed, 34 insertions(+), 20 deletions(-)
> >
> > --
> > 2.7.4


