Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2004C4320A
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jul 2021 10:40:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9064660234
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jul 2021 10:40:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232557AbhGZJ7w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Jul 2021 05:59:52 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:17092 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232594AbhGZJ7s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jul 2021 05:59:48 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210726104013epoutp020cfcdea220cede5dbe900a4a30202bd8~VURon82P01676716767epoutp02q
        for <linux-scsi@vger.kernel.org>; Mon, 26 Jul 2021 10:40:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210726104013epoutp020cfcdea220cede5dbe900a4a30202bd8~VURon82P01676716767epoutp02q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1627296013;
        bh=INRD4VT0wVS5A1ECdXU3vUnqwaxz1J6BzNmZ9SZOV3M=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=nppIq3qjCuWPAKuy0H6IegR4FmvTLqCZ3T3nmXljbgENcJvURj/Qa6UH+VqRSDlYv
         yYEOglngnNmP3B2fwlpL6WV1S2Gepb4pP0lkYzbdx3KSliwGsg8FpdHb++HFdFpcnl
         ujgwWDy3FjjJV87GQhw87QY4nTIb7jnTs2vQPD1c=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210726104012epcas2p2946a1017cb5da14338b475c3f87bf505~VURn3nFK90147601476epcas2p2b;
        Mon, 26 Jul 2021 10:40:12 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.188]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4GYGf166g8z4x9Q0; Mon, 26 Jul
        2021 10:40:09 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        37.C7.09541.9019EF06; Mon, 26 Jul 2021 19:40:09 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20210726104008epcas2p461255258c3807a0f37cdba478d9c4a98~VURkjt_yS1029510295epcas2p4Z;
        Mon, 26 Jul 2021 10:40:08 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210726104008epsmtrp2c07e53c50656d9ae56459208ae4da0b0~VURkimAuF0278102781epsmtrp2F;
        Mon, 26 Jul 2021 10:40:08 +0000 (GMT)
X-AuditID: b6c32a47-5f3ff70000002545-63-60fe91092ea1
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        88.DE.08289.8019EF06; Mon, 26 Jul 2021 19:40:08 +0900 (KST)
Received: from KORCO039056 (unknown [10.229.8.156]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210726104008epsmtip22401d469c90b6c8a6e92fd39d41f3e5b~VURkT5hxp1794717947epsmtip2h;
        Mon, 26 Jul 2021 10:40:08 +0000 (GMT)
From:   "Chanho Park" <chanho61.park@samsung.com>
To:     "'Bean Huo'" <huobean@gmail.com>,
        "'Krzysztof Kozlowski'" <krzk@kernel.org>,
        "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'James E . J . Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K . Petersen'" <martin.petersen@oracle.com>
Cc:     "'Can Guo'" <cang@codeaurora.org>,
        "'Jaegeuk Kim'" <jaegeuk@kernel.org>,
        "'Kiwoong Kim'" <kwmad.kim@samsung.com>,
        "'Avri Altman'" <avri.altman@wdc.com>,
        "'Adrian Hunter'" <adrian.hunter@intel.com>,
        "'Christoph Hellwig'" <hch@infradead.org>,
        "'Bart Van Assche'" <bvanassche@acm.org>,
        "'jongmin jeong'" <jjmin.jeong@samsung.com>,
        "'Gyunghoon Kwon'" <goodjob.kwon@samsung.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-scsi@vger.kernel.org>
In-Reply-To: <2b4f4e6d76cdc517843fe8880312541c754d5352.camel@gmail.com>
Subject: RE: [PATCH v2 14/15] scsi: ufs: ufs-exynos: multi-host
 configuration for exynosauto
Date:   Mon, 26 Jul 2021 19:40:08 +0900
Message-ID: <000601d7820a$9aa11210$cfe33630$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJIF3zu3g+/Awptn47LJA2vs45sGwKSU/P/Ail7aZYBcufzmKpCXg/g
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAJsWRmVeSWpSXmKPExsWy7bCmqS7nxH8JBo9btC1OPlnDZvFg3jY2
        i5c/r7JZTPvwk9ni0/plrBY9O50tTk9YxGQx52wDk8WT9bOYLRbd2MZksfKahcX58xvYLW5u
        OcpiMeP8PiaL7us72CyWH//H5CDgcfmKt8flvl4mj52z7rJ7bF6h5bF4z0smj02rOtk8Jiw6
        wOjx8ektFo++LasYPT5vkvNoP9DNFMAdlWOTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhr
        aGlhrqSQl5ibaqvk4hOg65aZA/SNkkJZYk4pUCggsbhYSd/Opii/tCRVISO/uMRWKbUgJafA
        0LBArzgxt7g0L10vOT/XytDAwMgUqDIhJ6P951nGgscCFRc/vGJsYGzk7WLk5JAQMJGY+mQx
        excjF4eQwA5Gie57V9kgnE+MEm8XrWWFcD4zSmydeJ8RpuXgj+/MEIldjBIrG+YwQTgvGCW2
        nLvCClLFJqAv8bJjG5gtApLoXywKYjMLnGCWmHyKGcTmFHCXaJ+yCqxGWCBO4vLybWAbWARU
        JRYs+cACYvMKWEpceNkNZQtKnJz5hAVijrbEsoWvmSEuUpD4+XQZ1C43iee3j7JC1IhIzO5s
        A7tUQuA/h8SuzzOZIBpcJD7uuM4OYQtLvDq+BcqWkvj8bi8bREM3o0Tro/9QidWMEp2NPhC2
        vcSv6VuANnAAbdCUWL9LH8SUEFCWOHIL6jY+iY7Df9khwrwSHW1CEI3qEge2T2eBsGUluud8
        Zp3AqDQLyWezkHw2C8kHsxB2LWBkWcUollpQnJueWmxUYIwc25sYwUldy30H44y3H/QOMTJx
        MB5ilOBgVhLhdVjxO0GINyWxsiq1KD++qDQntfgQoykwrCcyS4km5wPzSl5JvKGpkZmZgaWp
        hamZkYWSOK9G3NcEIYH0xJLU7NTUgtQimD4mDk6pBqaAN1X3wj5HK5tu/DI5LsDc+rEXb+hr
        /n4z5b5b0Rf8J3stalSb8P/uEuaNSx6JqtV/Xik0Y/vFPyxzqgNPlxc12BwO2utuXRQZ4uS/
        WOd254unj6X//vrFbnl52e9FN5O0s/5/4Vnye9qx3v5J3BWRGzTeBBZe8HYVn7e5Z9OtkHWO
        Tmoi3F/3O5efdfl4+RyrlT6vqbJtIY+D8vIa9X0B02wTNq33s1u2bP4iwfc3P4ldOGJ2aLni
        kcO3nP5+uhi6pnJav9xZ/SUrxS5cOfvo9/cEyUo2ofSlrx592HOzfGfRv9aw2ZPVw2qTp/a0
        iiwsU0j83zjr9aztbUWdHgm/pjYrcZsc0Ld7b68Ys/KHEktxRqKhFnNRcSIA0jmlb3MEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsWy7bCSvC7HxH8JBg2rNC1OPlnDZvFg3jY2
        i5c/r7JZTPvwk9ni0/plrBY9O50tTk9YxGQx52wDk8WT9bOYLRbd2MZksfKahcX58xvYLW5u
        OcpiMeP8PiaL7us72CyWH//H5CDgcfmKt8flvl4mj52z7rJ7bF6h5bF4z0smj02rOtk8Jiw6
        wOjx8ektFo++LasYPT5vkvNoP9DNFMAdxWWTkpqTWZZapG+XwJWx5+kz9oL7AhUXD2Y2MH7l
        6WLk5JAQMJE4+OM7M4gtJLCDUWLvF1eIuKzEs3c72CFsYYn7LUdYuxi5gGqeMUqcuTUZrIFN
        QF/iZcc2sISIwCtGiRNX29lAHGaBC8wSF3Y/YYNoaWSS2Nz1nQWkhVPAXaJ9yipWEFtYIEbi
        2IYNjCA2i4CqxIIlH8BqeAUsJS687IayBSVOznwCZjMLaEv0PmxlhLGXLXzNDHGfgsTPp8vA
        ZooIuEk8v32UFaJGRGJ2ZxvzBEbhWUhGzUIyahaSUbOQtCxgZFnFKJlaUJybnltsWGCUl1qu
        V5yYW1yal66XnJ+7iREc31paOxj3rPqgd4iRiYPxEKMEB7OSCK/Dit8JQrwpiZVVqUX58UWl
        OanFhxilOViUxHkvdJ2MFxJITyxJzU5NLUgtgskycXBKNTApza1R21tdw381I1TogubtaUFf
        dyafEBV7+uX6nNvlUz79OD9lWdiytt9Lk7f2hu3/eTuv2OfItHtX+vx74yOS427dX6B5Kcu9
        QdPBKY4555xBeqmkSnTszejTmUomz/qTJl+73qHj1CPq5Zk34cBsmylvopqfnnxz48fxUpVm
        Zbc9SxqUvV5tZUxV91xU/Crk5bmNC/pmXtA52DltjtitX0XVZ3LzdMLtJp44UhX9/mhF76V6
        l5YNUx97L3isc2H+BLcvixz1OeXnJize61oc+q12trVd/wE+F4aL/yS9t292mCwTNu+B4+KF
        DTb6LyMcT2mZ/gpzuWziIv751cK6BSeZJ6WZ7zmwwmbFwdBPSizFGYmGWsxFxYkAKZC8cF4D
        AAA=
X-CMS-MailID: 20210726104008epcas2p461255258c3807a0f37cdba478d9c4a98
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210714071200epcas2p3f76e68f6bbb4755574dba2055a8130ab
References: <20210714071131.101204-1-chanho61.park@samsung.com>
        <CGME20210714071200epcas2p3f76e68f6bbb4755574dba2055a8130ab@epcas2p3.samsung.com>
        <20210714071131.101204-15-chanho61.park@samsung.com>
        <2b4f4e6d76cdc517843fe8880312541c754d5352.camel@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > UFS controller of ExynosAuto v9 SoC supports multi-host interface for
> > I/O
> >
> > virtualization. In general, we're using para-virtualized driver to
> >
> > support a block device by several virtual machines. However, it should
> >
> > be relayed by backend driver. Multi-host functionality extends the
> > host
> >
> > controller by providing register interfaces that can be used by each
> >
> > VM's ufs drivers respectively. By this, we can provide direct access
> > to
> >
> > the UFS device for multiple VMs. It's similar with SR-IOV of PCIe.
> >
>=20
> Hi Chanho Park,
> very inteseted in this patch. you mentined SR-IOV. In order to make your
> patch work on the UFS, does UFS device side need changes?
>=20
> or the common current 3.1 UFS can work with this new controller?

Our UFS controller was built on top of JEDEC 2.1 spec with some custom impl=
ementations to support this feature. UFS device side, no changes will be ne=
cessary.

>=20
>=20
>=20
> >
> >
> > We divide this M-HCI as PH(Physical Host) and VHs(Virtual Host). The
> > PH
> >
> > supports all UFSHCI functions(all SAPs) same as conventional UFSHCI
> > but
> >
> > the VH only supports data transfer function. Thus, except UTP_CMD_SAP
> > and
> >
> > UTP_TMPSAP, the PH should handle all the physical features.
> >
> >
> >
> > This patch provides an initial implementation of PH part. M-HCI can
> >
> > support up to four interfaces but this patch initially supports only
> > 1
> >
> > PH and 1 VH. For this, we uses TASK_TAG=5B7:5=5D field so TASK_TAG=5B4:=
0=5D
> > for
> >
> > 32 doorbel will be supported. After the PH is initiated, this will
> > send
>=20
>=20
> I don't understand here.  how many doorbell registers you have now?
> and doesn VHs have a doorbell register also? and each doorbell register
> still supprts 32 tags?

A PH has its own doorbell register and each VHs also has it as well.
The TASK_TAG=5B7:5=5D can be used to distinguish the origin of the request =
among VHs and remaining TASK_TAG=5B4:0=5D will be used for supporting 32 ta=
gs.

Best Regards,
Chanho Park

