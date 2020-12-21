Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CA2BC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 01:38:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5ECCA22C7C
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 01:38:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbgLUBiQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 20 Dec 2020 20:38:16 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:23161 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbgLUBiQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Dec 2020 20:38:16 -0500
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20201221013733epoutp027cba3f468c4a1d4616330945bfbf83b4~Sl44a7Xip0741907419epoutp02-
        for <linux-scsi@vger.kernel.org>; Mon, 21 Dec 2020 01:37:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20201221013733epoutp027cba3f468c4a1d4616330945bfbf83b4~Sl44a7Xip0741907419epoutp02-
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608514653;
        bh=qb5UDXZL0Ia8BX16Ms1wtn7IaKI3zciuiUQAH9F+zUw=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=W5WKiCMIjwFgY79pzJFIIZ/DSeIDORusS5rYXRPLoR7/16c0FPzBHKE6Z2WzBnhU0
         1nR5p8Cuw9K/jkbdGnBXaIn1kiBYH1M1plle2yufaUkSjsyOTwAQ193hYCt/OSPtn4
         /N8ILLHzecASDB+v5uQuCVJRPlg8v9b6zQQY4btU=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20201221013733epcas2p1eb9e6c864f139ef73ab26dfd661b7a39~Sl44EQyrj3070630706epcas2p1I;
        Mon, 21 Dec 2020 01:37:33 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.181]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4Czht22HhDz4x9Ps; Mon, 21 Dec
        2020 01:37:30 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        1C.67.05262.95CFFDF5; Mon, 21 Dec 2020 10:37:29 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20201221013728epcas2p275c12451584172f2127223c8a70ff609~Sl4z4g_6e1946719467epcas2p2C;
        Mon, 21 Dec 2020 01:37:28 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201221013728epsmtrp2cce00bf341988626b2f23deb7dd5e5b5~Sl4z30gNZ3172031720epsmtrp2L;
        Mon, 21 Dec 2020 01:37:28 +0000 (GMT)
X-AuditID: b6c32a47-b81ff7000000148e-35-5fdffc597e94
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        0E.A3.08745.85CFFDF5; Mon, 21 Dec 2020 10:37:28 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20201221013728epsmtip19dbe2eddd42efeffab6bdb78fc6d3d09~Sl4zuFo0y1177811778epsmtip1h;
        Mon, 21 Dec 2020 01:37:28 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Avri Altman'" <Avri.Altman@wdc.com>, <linux-scsi@vger.kernel.org>
In-Reply-To: <DM6PR04MB6575F7B2F1B6EB42C275049CFCC10@DM6PR04MB6575.namprd04.prod.outlook.com>
Subject: RE: [PATCH v2 0/2] permit vendor specific values of unipro timeouts
Date:   Mon, 21 Dec 2020 10:37:28 +0900
Message-ID: <000001d6d739$d7a375d0$86ea6170$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJKkwnskO3Hw/OB6WymW7E2AvOGmQHQR/zqApSr/eGo9iW1AA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLKsWRmVeSWpSXmKPExsWy7bCmqW7kn/vxBj+WsFq8/HmVzaL7+g42
        ByaPz5vkPNoPdDMFMEXl2GSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qba
        Krn4BOi6ZeYAjVdSKEvMKQUKBSQWFyvp29kU5ZeWpCpk5BeX2CqlFqTkFBgaFugVJ+YWl+al
        6yXn51oZGhgYmQJVJuRkvFj5iblgPVtFw+8GxgbGVyxdjBwcEgImEiv21XYxcnEICexglDg3
        +zgjhPOJUeLLwetQzmdGiTn/VrB3MXKCdfRf38oGkdjFKHG/dQ9YQkjgBaPE5zV5IDabgLbE
        tIe7WUFsEQF3iX9frzKD2JwCsRJT159nArGFBXwkPp3tZAI5g0VAVeLCxUwQk1fAUuLdYkuQ
        Cl4BQYmTM5+wgNjMAvIS29/OYYY4QUHi59NlUNOdJG5/mssOUSMiMbuzjRnkNAmBU+wSX8+e
        Y4RocJHYu+cGE4QtLPHq+BaoX6QkPr/bywZh10vsm9rACtHcwyjxdN8/qGZjiVnP2hlBjmMW
        0JRYv0sfEnLKEkduQd3GJ9Fx+C87RJhXoqNNCKJRWeLXpMlQQyQlZt68A7XVQ+LA2wXsExgV
        ZyH5chaSL2ch+WYWwt4FjCyrGMVSC4pz01OLjQqMkWN6EyM43Wm572Cc8faD3iFGJg7GQ4wS
        HMxKIrxmUvfjhXhTEiurUovy44tKc1KLDzGaAkN9IrOUaHI+MOHmlcQbmhqZmRlYmlqYmhlZ
        KInzhq7sixcSSE8sSc1OTS1ILYLpY+LglGpgUows35EVUm8dXz7P3u7h7FynA68Yf1y/+dTL
        pf+hx7eiwzLJ4jFp0xRDOmTm7LbYMv3Teo473TutK9jvvl/Ef2G9QUjhxsDrgv9fi+VrZ/1j
        PLYipVtEn2nnvdKZVb3Ka398NuvawuxlueG8tlChC6/FHb2Xlamfw+cKRzZcN93GsvHk+fv2
        6sLbl5U0BKbJrv+9//jaV/J3xBQ3L+IwFHKz7HZ81sJRkNzGeax/37OpO3uWVr0RnZI0z2HS
        NBvdtAkTn+1pr5xgHHVTn3/WnGIXs8tNS4uFHulv1i3ZN9NVRDTs3oM+i+qcLJ9n+jqn73kd
        //VvxuZljwXKK23Ts8tfTF74LG/WExOG+oIvSizFGYmGWsxFxYkAmVMU/wAEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsWy7bCSnG7En/vxBvsvKlq8/HmVzaL7+g42
        ByaPz5vkPNoPdDMFMEVx2aSk5mSWpRbp2yVwZbxY+Ym5YD1bRcPvBsYGxlcsXYycHBICJhL9
        17eydTFycQgJ7GCUmHXqBRtEQlLixM7njBC2sMT9liOsEEXPGCVmLF3GDJJgE9CWmPZwNyuI
        LSLgKfFg0S4WiKLbjBLzu7aDdXMKxEpMXX+eCcQWFvCR+HS2E8jm4GARUJW4cDETxOQVsJR4
        t9gSpIJXQFDi5MwnYMcxA43vfdjKCGHLS2x/O4cZ4h4FiZ9Pl0GtdZK4/WkuO0SNiMTszjbm
        CYxCs5CMmoVk1Cwko2YhaVnAyLKKUTK1oDg3PbfYsMAoL7Vcrzgxt7g0L10vOT93EyM4yLW0
        djDuWfVB7xAjEwfjIUYJDmYlEV4zqfvxQrwpiZVVqUX58UWlOanFhxilOViUxHkvdJ2MFxJI
        TyxJzU5NLUgtgskycXBKNTCtv37912fvMOG1vsFHGS9Jp7kmSX05yTlfuU1O482q8mNtOfFv
        5gikMvQfex1VYtCYr8r7ZbPzTbX2RXUCsjrs1fEl3FmLtbX3fNjqrc+9ZsHJbbv36nm1/Xx4
        o5i39M3rdU03MgSv2tr0ZvRNfqjO1K/pzdKycJLfLq7Vu2dmeX311yyLDOrcyVLlzdSV27Vv
        26t7k+vO9od1PNi085eF2xEu74xS/2Valtcu/DjkJN7+pTp7y7E0EemnnRZe0zwy0ytPvLG6
        1hQzVZNhCsuTjtBTMseMPRS/98Uf26Y5S5Hz++78Z9XR8RlKt959sNJ2ldLMcD8ubMXtVdWY
        5O5fsswi29Eh9Nj6z4J+SizFGYmGWsxFxYkAJb8sd+ECAAA=
X-CMS-MailID: 20201221013728epcas2p275c12451584172f2127223c8a70ff609
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201219030743epcas2p39ee0570eea153915ad8e525e8f508e66
References: <CGME20201219030743epcas2p39ee0570eea153915ad8e525e8f508e66@epcas2p3.samsung.com>
        <cover.1608346381.git.kwmad.kim@samsung.com>
        <DM6PR04MB6575F7B2F1B6EB42C275049CFCC10@DM6PR04MB6575.namprd04.prod.outlook.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> 
> Your gerrit change-ids still shows, other than that - looks good to me.
> 
> Thanks,
> Avri

I missed removing them in the patches. Will take care. Sorry.


Thanks.
Kiwoong Kim
> >
> > v1 -> v2: change some comments and rename the quirk
> >
> > There are some attribute settings before power mode change in ufshcd.c
> > that should have been variant per vendor.
> >
> > Kiwoong Kim (2):
> >   ufs: add a quirk not to use default unipro timeout values
> >   ufs: ufs-exynos: apply vendor specifics for three timeouts
> >
> >  drivers/scsi/ufs/ufs-exynos.c |  8 +++++++-
> >  drivers/scsi/ufs/ufshcd.c     | 40 +++++++++++++++++++++----------------
> ---
> >  drivers/scsi/ufs/ufshcd.h     |  6 ++++++
> >  3 files changed, 34 insertions(+), 20 deletions(-)
> >
> > --
> > 2.7.4


