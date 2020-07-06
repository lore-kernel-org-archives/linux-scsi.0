Return-Path: <SRS0=95cY=AR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9ACCC433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 06:41:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C53C72073E
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 06:41:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="N33jIdZT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbgGFGlh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jul 2020 02:41:37 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:57949 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbgGFGlh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jul 2020 02:41:37 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200706064133epoutp01ba591021a2c58690b37b7e2bb217bad8~fFqWrcTBN0527905279epoutp01Z
        for <linux-scsi@vger.kernel.org>; Mon,  6 Jul 2020 06:41:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200706064133epoutp01ba591021a2c58690b37b7e2bb217bad8~fFqWrcTBN0527905279epoutp01Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594017693;
        bh=2+gUSuN152Je6omL4HYFPCSWAmErOliiB+cafj8FqPQ=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=N33jIdZTVlxgMEHWZaL4FxLKGYtG0QL/maaWgax5oTNFhu455jPqGnEOXaDmTKeZU
         WoZ0FWqUTE/Ixn6PXucrEY+sUgGXhTa9H7DYnkO8Aviu33+rz7zU+FKGKEcogLhvhu
         Z1dgsZXT59IIC3CQWeNsBqDvZiREJJ+f3LbPi0HA=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20200706064132epcas2p2dac3465fa1c8e48ec5eade419c3ecbdd~fFqVgSO7h2635126351epcas2p2h;
        Mon,  6 Jul 2020 06:41:32 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.185]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4B0bZM36LmzMqYl3; Mon,  6 Jul
        2020 06:41:31 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        66.0D.27441.B97C20F5; Mon,  6 Jul 2020 15:41:31 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20200706064130epcas2p2a3335ddd53ddfeabb06c46cb8a0b24e6~fFqTUSGRU0322703227epcas2p2Z;
        Mon,  6 Jul 2020 06:41:30 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200706064130epsmtrp266cb8a2c4a7472c5ca8dc6ddedc23024~fFqTTdcIX0223602236epsmtrp2c;
        Mon,  6 Jul 2020 06:41:30 +0000 (GMT)
X-AuditID: b6c32a47-fc5ff70000006b31-68-5f02c79bd048
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        AD.47.08382.A97C20F5; Mon,  6 Jul 2020 15:41:30 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200706064130epsmtip258a41d48f03db0f0e9e275b07b6384f7~fFqTDc3Nq2159921599epsmtip2R;
        Mon,  6 Jul 2020 06:41:30 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Avri Altman'" <Avri.Altman@wdc.com>,
        <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <bvanassche@acm.org>,
        <grant.jung@samsung.com>, <sc.suh@samsung.com>,
        <hy50.seo@samsung.com>, <sh425.lee@samsung.com>
In-Reply-To: <SN6PR04MB4640F8152119C231A6EB46FEFC680@SN6PR04MB4640.namprd04.prod.outlook.com>
Subject: RE: [RFC PATCH v3 2/2] exynos-ufs: implement dbg_register_dump and
 compl_xfer_req
Date:   Mon, 6 Jul 2020 15:41:29 +0900
Message-ID: <000601d65360$7b181530$71483f90$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQGzyCHOhCeJxiopSPNZAUTahmxpDALD+MYCAgaLp3MCKFW59akHmdNA
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMJsWRmVeSWpSXmKPExsWy7bCmme7s40zxBneWiVk8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWvz6u57dYvXiBywWi25sY7Lovr6DzWL58X9MFl13bzBa
        LP33lsWB1+PyFW+Py329TB4TFh1g9Pi+voPN4+PTWywefVtWMXp83iTn0X6gmymAIyrHJiM1
        MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoZCWFssScUqBQ
        QGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpOgaFhgV5xYm5xaV66XnJ+rpWhgYGRKVBlQk7G7stL
        WAuuM1Zs/72ZvYFxCWMXIyeHhICJxLkrN4BsLg4hgR2MEksvn2CHcD4xSnxe0A9WJSTwjVFi
        wQwVmI4pS7czQRTtZZR48+o+G4TzglHi0bTJzCBVbALaEtMe7mYFSYgI3GeSOLLzAQtIglMg
        VmJa8z4gm4NDWCBG4sEZO5Awi4CKxLKrK5lAwrwClhI7DzOBhHkFBCVOznwC1sksIC+x/e0c
        ZogjFCR+Pl3GCmKLCLhJHG34wQhRIyIxu7ONGWSthMAJDolZR9rYIBpcJDYfuQdlC0u8Or6F
        HcKWkvj8bi9UvF5i39QGVojmHkaJp/v+QQPJWGLWs3ZGkOOYBTQl1u/SBzElBJQljtyCuo1P
        ouPwX3aIMK9ER5sQRKOyxK9Jk6GGSErMvHkHaquHxNcHd5gnMCrOQvLlLCRfzkLyzSyEvQsY
        WVYxiqUWFOempxYbFRgjx/UmRnBq1nLfwTjj7Qe9Q4xMHIyHGCU4mJVEeHu1GeOFeFMSK6tS
        i/Lji0pzUosPMZoCg30is5Rocj4wO+SVxBuaGpmZGViaWpiaGVkoifMWW12IExJITyxJzU5N
        LUgtgulj4uCUamBSyj+cKWRRO68i6O7DjRIFy45q769QYyk12dDYFvM9we52vnglxzrbhY3+
        S+/N3sod1nNtS6f3kgfPr/CmvPebniHI9WzDhLVBFpr7vSTW9wdvW7dD9+U2oci5esJ3Trpp
        lbfNDHs9c/nXXWWmAXs5D54qC/5q8OiVnKDE/0P9/5nWLZ7uM+VnT02i1ntLw7f/05W+/XZb
        k7pnbuzD8JCt9l9nvulYfFEyU/b/vG7RxyfOHJXi6L96x9jscO6fudXTlColGoN9C66q7hX8
        vMtJ60wr+6qpVySyEvJerf20q+Tjzuk1vWs3MDx44LHh6bmqTw9FtnGYPHhqff98yQo95dNc
        ivIsgSo6k20vH8lQUmIpzkg01GIuKk4EAEh+xFRWBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsWy7bCSvO6s40zxBseucFk8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWvz6u57dYvXiBywWi25sY7Lovr6DzWL58X9MFl13bzBa
        LP33lsWB1+PyFW+Py329TB4TFh1g9Pi+voPN4+PTWywefVtWMXp83iTn0X6gmymAI4rLJiU1
        J7MstUjfLoErY/flJawF1xkrtv/ezN7AuISxi5GTQ0LARGLK0u1MXYxcHEICuxklzndvY4ZI
        SEqc2PkcqkhY4n7LEVaIomeMEt+3bGADSbAJaEtMe7gbLCEi8JZJ4s7ty1CjVjNJvJx3lgWk
        ilMgVmJa8z4wW1ggSmJ1x36wsSwCKhLLrq4EauDg4BWwlNh5mAkkzCsgKHFy5hOwcmagBb0P
        WxkhbHmJ7W/nQF2nIPHz6TJWEFtEwE3iaMMPqBoRidmdbcwTGIVmIRk1C8moWUhGzULSsoCR
        ZRWjZGpBcW56brFhgWFearlecWJucWleul5yfu4mRnBEamnuYNy+6oPeIUYmDsZDjBIczEoi
        vL3ajPFCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeW8ULowTEkhPLEnNTk0tSC2CyTJxcEo1MCU7
        9Fx7Zl/6+kJEc9LrZ/G3T635XsAfffyaJfcTxtOCTNJ5q9vmRvd7z55tZin53biLLyFXSZP5
        OJOA0+qPMnwK+0wMD9iX/uT+NLOn+HT0bXP9XYdWl1kzz4zPsX4w6+CMpnUFdxYHmDZ3rlP9
        wmGsXL3/95VE23Up8kbv15utmDqT7YPMpxPT5vLJ7qsKci1TEimJKy8T1L2xZo+7vYKyw7n8
        /Z81lOddv8j18GDYEtNXO/x/NrEWrVZODOoX6JQyXbfef2KkV4zm8bl7C47tnDaR/fOs0kO3
        OiomSOgJagpN6fXe4rpjeZ7WFo4eAU17E/7lCmzGZ6Wv72GOmPK3+5HLDPaNk2c667QnKrEU
        ZyQaajEXFScCAFymtnY3AwAA
X-CMS-MailID: 20200706064130epcas2p2a3335ddd53ddfeabb06c46cb8a0b24e6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200703053855epcas2p17dc1463fae3cfb0f8db0adb5e1c5a328
References: <cover.1593752220.git.kwmad.kim@samsung.com>
        <CGME20200703053855epcas2p17dc1463fae3cfb0f8db0adb5e1c5a328@epcas2p1.samsung.com>
        <9a3f8f8fed39aa7e07e20cf1ff25c708919ff2ea.1593752220.git.kwmad.kim@samsung.com>
        <SN6PR04MB4640F8152119C231A6EB46FEFC680@SN6PR04MB4640.namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > This patch implements callbacks dbg_register_dump and compl_xfer_req
> > to store IO contexts or print them.
> Each callback deserves its own patch.
> 
> Thanks,
> Avri

Got it

Thanks.
Kiwoong Kim

