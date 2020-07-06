Return-Path: <SRS0=95cY=AR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 431EBC433DF
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 06:43:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E9D02073E
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 06:43:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="lUQXXz2O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbgGFGnl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jul 2020 02:43:41 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:49054 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727896AbgGFGnl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jul 2020 02:43:41 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200706064338epoutp04b68ad072b1096cb5ff04969deaea3558~fFsK-jxqv2748727487epoutp04Q
        for <linux-scsi@vger.kernel.org>; Mon,  6 Jul 2020 06:43:38 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200706064338epoutp04b68ad072b1096cb5ff04969deaea3558~fFsK-jxqv2748727487epoutp04Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594017818;
        bh=JJ3eblqzvDHmmUSwLb8DiLJTGUG48cnCCBuU73TU9G0=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=lUQXXz2OzEUD2yvCWzMEjc4+IeLO5wYz9dLskcHrRA/wOIjWAU56Yym4j+udtVyHA
         adIBWoKlV0T7cCL1xnx/2QerpTGJizUWBKSZDSAFA47uI3SILGJ+2QtvaDuqxXl+n/
         mfrwQW2PeUlf3scHvkBs/vbEdHfAnrF0VpoUABDk=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20200706064336epcas2p2b495a184a13a00cda398f77835e7da3e~fFsIhVHFT1112411124epcas2p2Z;
        Mon,  6 Jul 2020 06:43:36 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.190]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4B0bck3cBxzMqYkW; Mon,  6 Jul
        2020 06:43:34 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        EA.E0.27013.618C20F5; Mon,  6 Jul 2020 15:43:34 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20200706064333epcas2p49777d77c306bb34b1b185d006f9774bf~fFsGGjLhH2573125731epcas2p4F;
        Mon,  6 Jul 2020 06:43:33 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200706064333epsmtrp1b5f716c78c31d8bac54c1394aad7dbae~fFsGFedLb2150421504epsmtrp1s;
        Mon,  6 Jul 2020 06:43:33 +0000 (GMT)
X-AuditID: b6c32a48-d1fff70000006985-29-5f02c816861d
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        D2.5B.08303.518C20F5; Mon,  6 Jul 2020 15:43:33 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20200706064333epsmtip1963bd8428a297ae4817bca72c61ed28f~fFsF5YKmm0429304293epsmtip1Y;
        Mon,  6 Jul 2020 06:43:33 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Bart Van Assche'" <bvanassche@acm.org>,
        <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <avri.altman@wdc.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <beanhuo@micron.com>,
        <asutoshd@codeaurora.org>, <cang@codeaurora.org>,
        <grant.jung@samsung.com>, <sc.suh@samsung.com>,
        <hy50.seo@samsung.com>, <sh425.lee@samsung.com>
In-Reply-To: <b2a0f977-8155-a947-d883-626c1c7762bb@acm.org>
Subject: RE: [RFC PATCH v3 1/2] ufs: support various values per device
Date:   Mon, 6 Jul 2020 15:43:33 +0900
Message-ID: <000701d65360$c496eec0$4dc4cc40$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHu1pDNEI1WArg19xfehYJkuPyuggFIo2zFASntDDcCEEC49Kik/ZLA
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCJsWRmVeSWpSXmKPExsWy7bCmma7YCaZ4g6WdrBYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCy6r+9gs1h+/B+TRdfdG4wW
        S/+9ZXHg9bh8xdvjcl8vk8eERQcYPb6v72Dz+Pj0FotH35ZVjB6fN8l5tB/oZgrgiMqxyUhN
        TEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAE6WUmhLDGnFCgU
        kFhcrKRvZ1OUX1qSqpCRX1xiq5RakJJTYGhYoFecmFtcmpeul5yfa2VoYGBkClSZkJNxc89m
        loIJLBXdLV/ZGhgXMncxcnJICJhI9Hc+Z+xi5OIQEtjBKPF8/Tc2COcTo8SP/9egMp8ZJVrn
        /WOHaflyZCuYLSSwi1FiWasuRNELRokrR6awgCTYBLQlpj3czQqSEBF4yCRx+dFlsA5OAWuJ
        i4veAyU4OIQF3CQe7CgCCbMIqEhc37KGCcTmFbCUOPl0KiuELShxcuYTsJnMQDOXLXwNdbeC
        xM+ny8BqRIDGbHiyjxGiRkRidmcbM8heCYEjHBJXL+2ButpF4ujt14wQtrDEq+NboOJSEi/7
        26Dseol9UxtYIZp7GCWe7vsH1WAsMetZOyPI0cwCmhLrd+mDmBICyhJHbkHdxifRcfgvO0SY
        V6KjTQiiUVni16TJUEMkJWbevAO1yUOib8dd1gmMirOQfDkLyZezkHwzC2HvAkaWVYxiqQXF
        uempxUYFJsiRvYkRnJy1PHYwzn77Qe8QIxMH4yFGCQ5mJRHeXm3GeCHelMTKqtSi/Pii0pzU
        4kOMpsBwn8gsJZqcD8wPeSXxhqZGZmYGlqYWpmZGFkrivO+sLsQJCaQnlqRmp6YWpBbB9DFx
        cEo1ME1cbslq8OlMaLv99kU6qwUMXr/7+fTY4Zd36v6+Fl3UZPRx9cNozSJBiaiDpTYdbfuK
        g123nBP9Ybps6sGL7zad3shuUHO5O1qJoXWJ1i7uF/qFLm4Wh5nuenEoLxFbedv/mnSA8Lb8
        m9PFm6It439kJr9MqPl3Xcd0cuV7fi93889rEwwnfnKJSLqs91sjrOjJhKKfsicYubu2X9mi
        fnR38fFXvtHXfygfm9FzVHc1S70Do32lSIHRlj/HFm9/eNuqSc6mYKHszeecmW9NChg7o38f
        cBf2snXxt2S3PSStst8pOW16ua7lvRT2mUFtNdtyv71zv/y+1krv4cSX6nzyBw1OpUnb7tr3
        zk7+lxJLcUaioRZzUXEiABPqrDhXBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsWy7bCSnK7oCaZ4g+a5shYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCy6r+9gs1h+/B+TRdfdG4wW
        S/+9ZXHg9bh8xdvjcl8vk8eERQcYPb6v72Dz+Pj0FotH35ZVjB6fN8l5tB/oZgrgiOKySUnN
        ySxLLdK3S+DKuLdqE3vBF+aKh5cyGxhbmbsYOTkkBEwkvhzZyt7FyMUhJLCDUaJp1SlGiISk
        xImdz6FsYYn7LUdYIYqeMUq8vbcbLMEmoC0x7eFusISIwEcmiZV7GplAEkICnUwSq9+Ugdic
        AtYSFxe9Byri4BAWcJN4sKMIJMwioCJxfcsasHJeAUuJk0+nskLYghInZz5hAbGZgeb3Pmxl
        hLGXLXwNdbWCxM+ny8DqRYBGbniyD6pGRGJ2ZxvzBEahWUhGzUIyahaSUbOQtCxgZFnFKJla
        UJybnltsWGCUl1quV5yYW1yal66XnJ+7iREcjVpaOxj3rPqgd4iRiYPxEKMEB7OSCG+vNmO8
        EG9KYmVValF+fFFpTmrxIUZpDhYlcd6vsxbGCQmkJ5akZqemFqQWwWSZODilGpisJB7l3H8e
        qP7kIqfk4wf5QWs9Fhq4rFUU4BaJtQ7Wvf3n59HlukvFuE7NM3x4qvDXooA71vPXbHBZ9CPp
        U8ZLZW+lTww7T//RWP1r6+qYxK0KW3aymXgvjltqtlT40XYLnfZLwVlbdGTsJBezXKkRtw32
        kSmcoTJf0+DkY48J3x7EnYracepw8fxsjV6Tb6d5Q9bm82d43nx5Rq3DTvL7/4BXlw5ynmri
        Wpj/JTcj9U7nLoWI+7Nj11hdSNGUypo39er5xLK5Wud35KdtEFSQ2q34+t3lGV+2nzn0j03q
        jILwsi8i4nPK971lP5nYw7E9lMO/K9a/8dLeDfVZn9X/GanJlDJuUNYsDVLL67qnxFKckWio
        xVxUnAgAfGR2ZTUDAAA=
X-CMS-MailID: 20200706064333epcas2p49777d77c306bb34b1b185d006f9774bf
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200703053756epcas2p1f32da04da87c8f56a6052caada95fb9a
References: <cover.1593753896.git.kwmad.kim@samsung.com>
        <CGME20200703053756epcas2p1f32da04da87c8f56a6052caada95fb9a@epcas2p1.samsung.com>
        <dc21b368f44c8a9a257d1b00549e3b5aeec00755.1593753896.git.kwmad.kim@samsung.com>
        <b2a0f977-8155-a947-d883-626c1c7762bb@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> On 2020-07-02 22:30, Kiwoong Kim wrote:
> > +static const struct ufs_dev_value ufs_dev_values=5B=5D =3D =7B
> > +	=7B0, 0, 0, 0, false=7D,
> > +=7D;
>=20
> A minor stylistic request: please change =22=7B0, 0, 0, 0, false=7D=22 in=
to =22=7B =7D=22.
> The C language requires that structure members that have not been
> specified are zero-initialized.
>=20
> Thanks,
>=20
> Bart.

Got it and I experienced the tool chain to show warning messages for not sp=
ecifying details in there.

Thanks.
Kiwoong Kim

