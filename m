Return-Path: <SRS0=/9Oe=AC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D142C433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Jun 2020 17:54:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0094725228
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Jun 2020 17:54:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="mivpMRmf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730520AbgFURyl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 21 Jun 2020 13:54:41 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:63695 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730485AbgFURyk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Jun 2020 13:54:40 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200621175436epoutp045e7f30a17fa2c61585182dd3b526720f~aoKuHOruZ1713817138epoutp04V
        for <linux-scsi@vger.kernel.org>; Sun, 21 Jun 2020 17:54:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200621175436epoutp045e7f30a17fa2c61585182dd3b526720f~aoKuHOruZ1713817138epoutp04V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592762076;
        bh=sMQfHlL5WKZfNlTa+has0Lg2mADa798q36HwDttq6B4=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=mivpMRmflPaGQ5fP0EY6ay0rVIANhgu41TDmFcy55v7xNWd8NjeUCFux/u9dsumUd
         j4bCui7TX3J+AfVIUzCTxYlqquN+wfTPZvVxl3tzVud27zP8tH7GXOtdYHcasjizSp
         opOuboRZv9qXIjrI/8sHhpw4fGgv1+pw6tLAjmOQ=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20200621175435epcas5p4b2a74c1c8a408492bc70c545dd5d35b9~aoKtAIEDM1252612526epcas5p4I;
        Sun, 21 Jun 2020 17:54:35 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        56.FF.09467.BDE9FEE5; Mon, 22 Jun 2020 02:54:35 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20200621175434epcas5p4f6d89121ecdc949fb8283f76e1cd115f~aoKsE1XTn3152431524epcas5p41;
        Sun, 21 Jun 2020 17:54:34 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200621175434epsmtrp2b3835003f4f1aa0cb5f9f7a8d9d31154~aoKsEMsJt2446824468epsmtrp27;
        Sun, 21 Jun 2020 17:54:34 +0000 (GMT)
X-AuditID: b6c32a49-a29ff700000024fb-34-5eef9edbf403
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        2A.47.08303.ADE9FEE5; Mon, 22 Jun 2020 02:54:34 +0900 (KST)
Received: from alimakhtar02 (unknown [107.108.234.165]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200621175432epsmtip29c090758dee0a46e97580180d13277ce~aoKqHYScd1238412384epsmtip2b;
        Sun, 21 Jun 2020 17:54:32 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Avri Altman'" <Avri.Altman@wdc.com>,
        "'Martin K. Petersen'" <martin.petersen@oracle.com>,
        "'Satya Tangirala'" <satyat@google.com>, <asutoshd@codeaurora.org>
Cc:     <linux-scsi@vger.kernel.org>,
        "'Barani Muthukumaran'" <bmuthuku@qti.qualcomm.com>,
        "'Kuohong Wang'" <kuohong.wang@mediatek.com>,
        "'Kim Boojin'" <boojin.kim@samsung.com>
In-Reply-To: <SN6PR04MB4640005BEC3EE690CB904298FC960@SN6PR04MB4640.namprd04.prod.outlook.com>
Subject: RE: [PATCH v2 0/3] Inline Encryption support for UFS
Date:   Sun, 21 Jun 2020 23:24:30 +0530
Message-ID: <000001d647f5$05a494c0$10edbe40$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQIx0Plgo8urqRvoCcKHhN3vSK1llAHhF8qPAXMuPMcBtvbalagD6w/A
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsWy7bCmhu7tee/jDLpey1vsbTvBbvHy51U2
        i5VbHjFbvDn5h82i9f8rZovu6zvYLJYf/8dk0b/6LpsDh8flvl4mjwWbSj1aTu5n8fj49BaL
        x6Kpzxg9+rasYvT4vEnOo/1AN1MARxSXTUpqTmZZapG+XQJXxvJ709kK7vNUrPv0irGBcRJX
        FyMnh4SAicSEna9Yuxi5OIQEdjNKvJ22nRnC+cQo8WH2MnYI5zOjxN9/l5m6GDnAWv6cFoaI
        72KU2L2zH6rjDaPE885PzCBz2QR0JXYsbmMDSYgILGOUePltLxOIwyywAWjux2WMIFWcArES
        vydfBrOFBWwlFp+cDNbNIqAq8eTQAlYQm1fAUuLqkUNMELagxMmZT1hAbGYBeYntb+cwQ3yh
        IPHz6TKwehEBN4lrm86zQ9SISxz92QN2noTAAQ6Jho+noRpcJI5u38sKYQtLvDq+hR3ClpL4
        /G4vG8Sf2RI9u4whwjUSS+cdY4Gw7SUOXJnDAlLCLKApsX6XPsQqPone30+gIcQr0dEmBFGt
        KtH87ipUp7TExO5uqKUeEks/T2CdwKg4C8ljs5A8NgvJA7MQli1gZFnFKJlaUJybnlpsWmCY
        l1quV5yYW1yal66XnJ+7iRGcrrQ8dzDeffBB7xAjEwfjIUYJDmYlEd7XAe/ihHhTEiurUovy
        44tKc1KLDzFKc7AoifMq/TgTJySQnliSmp2aWpBaBJNl4uCUamDqNXQ9MG1bc6m2XWv2p0z1
        l0ZLRDe12+7XmHlRm2njLG2d0hJmk8dmUzUCA5MuXzZ76Jq/5vjC2zOXuJ3+PnHfI7uN/5gi
        tIvZRc8JeJ3YM0mRhVVZTXHlSfdNs+N6ctS25om1ymdpxa9IDtK62WLpVttl8MdKqn2d+eGO
        1IsyrA7LX/5+8ln2Z06iv3bp9L6s+kf+/dHzUjd/OqW8w3LPza+XJbOFv3zY+SGpL/f5u1VN
        NgmfZq7+4c56WO2O2tcnr/KvSxf9eHfEruXE3ZTrmnsrX5/QS1eKrtuwOPa5/q/GxzmrOB9O
        ChZx36ZzjDfLLemu7Vu9xs6DF98dqN94sqRlYn57k+e/RQL/2u4rsRRnJBpqMRcVJwIARPn7
        t8YDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsWy7bCSvO6tee/jDPa+lrXY23aC3eLlz6ts
        Fiu3PGK2eHPyD5tF6/9XzBbd13ewWSw//o/Jon/1XTYHDo/Lfb1MHgs2lXq0nNzP4vHx6S0W
        j0VTnzF69G1ZxejxeZOcR/uBbqYAjigum5TUnMyy1CJ9uwSujOX3prMV3OepWPfpFWMD4ySu
        LkYODgkBE4k/p4W7GLk4hAR2MEqs2jOfsYuREyguLXF94wR2CFtYYuW/5+wQRa8YJU79/8AM
        kmAT0JXYsbiNDSQhIrCCUeLS55ksIA6zwCZGibt9IKNAWhqYJO5eX8QK0sIpECvxe/JlsB3C
        ArYSi09OBhvFIqAq8eTQArAaXgFLiatHDjFB2IISJ2c+YQG5lVlAT6JtI1grs4C8xPa3c5gh
        zlOQ+Pl0GViriICbxLVN59khasQljv7sYZ7AKDwLyaRZCJNmIZk0C0nHAkaWVYySqQXFuem5
        xYYFRnmp5XrFibnFpXnpesn5uZsYwVGnpbWDcc+qD3qHGJk4GA8xSnAwK4nwvg54FyfEm5JY
        WZValB9fVJqTWnyIUZqDRUmc9+ushXFCAumJJanZqakFqUUwWSYOTqkGpg0Sy7cejz9k6392
        rqAo04d53keunzt597K33ea/L1IO6wUe+6uS6PG3b/7k5zdWv/19d8fsVYbe7Cyd/n+Y7oe0
        JuZNdH2XU3+R+UX/ws2PNVIKn2n5isWW8MvJ6i1eduJ41mL3p+uXnPv0VvlMX13RDt7Kxqqj
        TTP2HbGed0zOvOLKzlkK8hUV94ONo/b9+pkR8+ja76aCRN4LWtMvLmjz2abd8uq03xJfadsj
        857PyLt1hif71IHjb8zrarmWvYuTYn77mrUrd+2JXTf/yvK7s1yIjLjyOcIppYaxe63NUpZL
        S1ZO2Sc4w+FC+8+lntv9Yp4Vti/5MWMzl+v9G3oxEQx2Sd6WfNNnn1DXX5WrxFKckWioxVxU
        nAgA96DAoikDAAA=
X-CMS-MailID: 20200621175434epcas5p4f6d89121ecdc949fb8283f76e1cd115f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200621123523epcas5p43bf94789149e6a49a4f9c18b10e1ef37
References: <20200618024736.97207-1-satyat@google.com>
        <yq1a70yh1f3.fsf@ca-mkp.ca.oracle.com>
        <CGME20200621123523epcas5p43bf94789149e6a49a4f9c18b10e1ef37@epcas5p4.samsung.com>
        <SN6PR04MB4640005BEC3EE690CB904298FC960@SN6PR04MB4640.namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Thanks Avri for CCing me.

> -----Original Message-----
> From: Avri Altman <Avri.Altman@wdc.com>
> Sent: 21 June 2020 18:05
> To: Martin K. Petersen <martin.petersen@oracle.com>; Satya Tangirala
> <satyat@google.com>; alim.akhtar@samsung.com; asutoshd@codeaurora.org
> Cc: linux-scsi@vger.kernel.org; Barani Muthukumaran
> <bmuthuku@qti.qualcomm.com>; Kuohong Wang
> <kuohong.wang@mediatek.com>; Kim Boojin <boojin.kim@samsung.com>
> Subject: RE: [PATCH v2 0/3] Inline Encryption support for UFS
> 
> +Alim & Asutosh
> 
> Hi Satya,
> 
> >
> > Avri,
> >
> > > This patch series adds support for inline encryption to UFS using
> > > the inline encryption support in the block layer. It follows the
> > > JEDEC UFSHCI v2.1 specification, which defines inline encryption for
UFS.
> >
> > I'd appreciate it if you could review this series.
> >
> > Thanks!
> >
> > --
> > Martin K. Petersen      Oracle Linux Engineering
> A quick question and a comment:
> 
> Does the IE infrastructure that you've added to the block layer invented
for ufs?
> Do you see other devices using it in the future?
> 
> Today, chipset vendors are using a different scheme for their IE.
> Need their ack before reviewing your patches.
> 
Yes, as of today at least in Samsung HCI, we use additional HW blocks to
handle all the crypto part.
(Though I need to check the status on the recent SoCs).
However given the fact that UFSHCI 2.1 spec does includes Crypto support,
and going by threads that you shared, looks  like other 
Vendors does uses IE. I am inclined toward getting this reviewed. 
> Thanks,
> Avri

