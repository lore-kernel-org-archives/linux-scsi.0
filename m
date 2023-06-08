Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3E79C77B7A
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Jun 2023 02:52:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233833AbjFHCwS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jun 2023 22:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233845AbjFHCwR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2023 22:52:17 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D7D02126
        for <linux-scsi@vger.kernel.org>; Wed,  7 Jun 2023 19:52:15 -0700 (PDT)
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20230608025213epoutp04425fad8f1a7398f517da6af5f8d1eca6~mj1t0p6Qs2194021940epoutp04f
        for <linux-scsi@vger.kernel.org>; Thu,  8 Jun 2023 02:52:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20230608025213epoutp04425fad8f1a7398f517da6af5f8d1eca6~mj1t0p6Qs2194021940epoutp04f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1686192733;
        bh=dfqkyElmqhZkAK2JGO3Z6Dvmfh+xa6tjZtT5zmHKVEo=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=qshAW52w+IBOB/3C7Y28LKuRx33HOITdWDwl/I8uKfAxwpRgl4yarAExBwQO7PnJL
         qQgzPJzeLHeYpCCVPWbqP0gn3YddDJ3ZzlneklMhzoKvYNb+mQB5MQHxwXs551dRNt
         FL7OV4XPg11h92JHwlNQxKlUB3L/janI/NerayuY=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20230608025213epcas2p206d1877ee243da2ebf5bf49a6f50930c~mj1te94393200632006epcas2p2E;
        Thu,  8 Jun 2023 02:52:13 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.36.101]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4Qc7zJ20JVz4x9Py; Thu,  8 Jun
        2023 02:52:12 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        87.D9.07392.B5241846; Thu,  8 Jun 2023 11:52:11 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20230608025211epcas2p3aed21cf13b9e8f77aac302424f8a6f22~mj1rqWRAC0885108851epcas2p3V;
        Thu,  8 Jun 2023 02:52:11 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230608025211epsmtrp28dddb3571891356289a4d06fa92d43bc~mj1rpw7T61525315253epsmtrp2U;
        Thu,  8 Jun 2023 02:52:11 +0000 (GMT)
X-AuditID: b6c32a47-eedff70000001ce0-ed-6481425b46bb
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        47.E6.27706.A5241846; Thu,  8 Jun 2023 11:52:11 +0900 (KST)
Received: from KORCO011456 (unknown [10.229.38.105]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20230608025210epsmtip2db8e6a404ba73328e73982521f6ea50c~mj1rb9aYP1950619506epsmtip2Y;
        Thu,  8 Jun 2023 02:52:10 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Bart Van Assche'" <bvanassche@acm.org>,
        <linux-scsi@vger.kernel.org>, <sc.suh@samsung.com>,
        <hy50.seo@samsung.com>, <sh425.lee@samsung.com>,
        <kwangwon.min@samsung.com>, <junwoo80.lee@samsung.com>
In-Reply-To: <4eda6575-c124-3ca3-e772-567a7014d895@acm.org>
Subject: RE: [PATCH v2 3/3] ufs: poll pmc until another pa request is
 completed
Date:   Thu, 8 Jun 2023 11:52:10 +0900
Message-ID: <005801d999b4$38cb2260$aa616720$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQCI4sX3LzJ4oopUDLnE0XsEPfF6SAE4Orz8ASB+6M0CKmBR57H9hkYA
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmk+LIzCtJLcpLzFFi42LZdljTVDfaqTHFYMoHeYtpH34yW6xe/IDF
        YtffZiaLrTd2slh0X9/BZtF19wajxdJ/b1kc2D0uX/H26NuyitHj8ya5AOaobJuM1MSU1CKF
        1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoN1KCmWJOaVAoYDE4mIl
        fTubovzSklSFjPziElul1IKUnALzAr3ixNzi0rx0vbzUEitDAwMjU6DChOyMJed/MRdM56w4
        dL+ugXExexcjJ4eEgInEk8dPgGwuDiGBHYwSK//OZoNwPjFKLP7xixnC+cYoseHCf2aYls4b
        71khEnsZJb5cugnlvGSUmLhmOthgNgFtiWkPd4MlRATOMkqcW9PKCpLgFLCW+HTrE1iRsECg
        xMM9f5hAbBYBFYkZx/vB4rwClhJTLj+CsgUlTs58wgJiMwMNXbbwNdQZChI/ny4Dmyki4CbR
        NesNO0SNiMTszjawuyUEPrJLnPp8gRWiwUXiwY7FbBC2sMSr41ugQSAl8fndXqA4B5CdLbFn
        oRhEuEJi8bS3LBC2scSsZ+2MICXMApoS63fpQ1QrSxy5BXUZn0TH4b/sEGFeiY42IYhGZYlf
        kyYzQtiSEjNv3oHa6SFx6d085gmMirOQ/DgLyY+zkPwyC2HvAkaWVYxiqQXFuempxUYFxvC4
        Ts7P3cQITpVa7jsYZ7z9oHeIkYmD8RCjBAezkghvln19ihBvSmJlVWpRfnxRaU5q8SFGU2Co
        T2SWEk3OBybrvJJ4QxNLAxMzM0NzI1MDcyVxXmnbk8lCAumJJanZqakFqUUwfUwcnFINTLOT
        V4hOf7yx5uSRr/O/u+zcOOXvrPeJj/1c5zmpLpT6Y1e5IGpPc3DfEsGTs02b/YJk3irGLfeR
        E1eYFlrbnlca43Fhh+kmQcNrwWt92H5aqXVd+mCW2lRrvOiu+jKG/X6KPiKXzas+Xe3Knv3u
        zoXdR5hV5uu6hq8LKG4301j3s1y3w+BhGn/Nu52WxxxVBFuE9cLMapkvps7n3nR/WRH73U+q
        Xhmfv2RLHC5988Dtwx6lk2d+xFd/yXrJI87FfswuSOqRywzpo+wKf478WNQ/MUXQ6azhIeUF
        73OP71/YueZ/w9sjHtZthUJebDunZH3VXVo1++kOqznpHzoEHs6N8k72LH9hvNlmmrhzixJL
        cUaioRZzUXEiAKpWG1QeBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsWy7bCSvG60U2OKwawGJotpH34yW6xe/IDF
        YtffZiaLrTd2slh0X9/BZtF19wajxdJ/b1kc2D0uX/H26NuyitHj8ya5AOYoLpuU1JzMstQi
        fbsEroy+vdfYCvo5K5b838rWwDibvYuRk0NCwESi88Z71i5GLg4hgd2MEu0L77BAJCQlTux8
        zghhC0vcbzkCVfScUeLs+wlgRWwC2hLTHu4GS4gIXGWUeNKziQmiqpNJ4tnq86wgVZwC1hKf
        bn0C2ycs4C/xf8d8MJtFQEVixvF+MJtXwFJiyuVHULagxMmZT8A2MANt6H3YyghjL1v4mhni
        JAWJn0+Xgc0XEXCT6Jr1hh2iRkRidmcb8wRGoVlIRs1CMmoWklGzkLQsYGRZxSiZWlCcm55b
        bFhgmJdarlecmFtcmpeul5yfu4kRHCVamjsYt6/6oHeIkYmD8RCjBAezkghvln19ihBvSmJl
        VWpRfnxRaU5q8SFGaQ4WJXHeC10n44UE0hNLUrNTUwtSi2CyTBycUg1MhmYTCptKNzxu3Xdr
        W3N2hdaynU8L2BgcaqUVLoQc4JrNn9Vqv8fhnaZOu8CmkLUy5aZbteM2KCw783KFZIaG/Z7Q
        86sXqSdF7NQL8+4MlEqTi4wxl3WNkHnI7+MXo1SbUXSCRW7JRrltvVuz7/yztTj2NNghmf0q
        i27ZR4aWvpLoj3OWuF3Pnd+5/a+b9+ZC++k/k648UTpXtn39I76qpHU8HP5tB7fHXhGs2Z8s
        6MWZ9/WJFqfBJS6TIteUjg9pMw94TFlQv1/sQOGbq/LMHZpuZ5//Nt+jdmzpSrG1fLMOTQyb
        V+RntsRCUn/hpACWxo7Fn1/zH1phInYqLChgeZXhnukf/69oem/I/luJpTgj0VCLuag4EQCK
        qf7OAQMAAA==
X-CMS-MailID: 20230608025211epcas2p3aed21cf13b9e8f77aac302424f8a6f22
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230605012508epcas2p140e42906361b870e20b1e734e9e4df06
References: <cover.1685927620.git.kwmad.kim@samsung.com>
        <CGME20230605012508epcas2p140e42906361b870e20b1e734e9e4df06@epcas2p1.samsung.com>
        <67ce698df39ca0c277c078dca729d7f607b9feb2.1685927620.git.kwmad.kim@samsung.com>
        <4eda6575-c124-3ca3-e772-567a7014d895@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> A change history like the above should either occur below the =22---=22
> separator or in a cover letter instead of in the patch description.
>=20
> > diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> =5B ... =5D

Thanks for your information.

>=20
> There are two changes in this patch: the introduction of the
> __ufshcd_poll_uic_pwr() helper function and also the introduction of a
> wait loop. Please split this patch into two patches - one patch that
> introduces the helper function and a second patch that introduces the wai=
t
> loop. That will make this patch series easier to review.
>=20
> Thanks,
>=20
> Bart.

I got it and I have one question.

The reason why I bound all the three things is
because I thought they were tangled each other. I felt that the first patch=
 relies
on both the second one and the third one and the helper named __ufshcd_poll=
_uic_pwr
in the third one calls ufshcd_ready_for_uic_cmd where the change of the sec=
ond one is applied.
So I thought I should care this sort of conflict in terms of the driver's w=
orking.
Don't submitters need to care this?

Thanks.
Kiwoong Kim


