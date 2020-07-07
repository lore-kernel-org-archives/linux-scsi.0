Return-Path: <SRS0=EBgm=AS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09A0DC433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 06:09:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF6AB20739
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 06:09:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="N3BcjPEB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727962AbgGGGJh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jul 2020 02:09:37 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:37289 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727871AbgGGGJh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jul 2020 02:09:37 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200707060933epoutp046012393a5637aa8c2c838ccde0054da9~fY3sPQPXk0622706227epoutp04W
        for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2020 06:09:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200707060933epoutp046012393a5637aa8c2c838ccde0054da9~fY3sPQPXk0622706227epoutp04W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594102173;
        bh=CwAFqFUBVY7fakh0Q5mhA1eO8ppVuehlvwiJJHPWyCI=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=N3BcjPEB+dqMtRahzRWzxbwcIoDqIzk07HTJSKexjnbUp7ASJUStnLcPHEaSMYj9/
         l0TKYifwUEMxoLodjRZl/jNIKIVSlgQdeMuy2HP1minRTFWwKGiRPqyz/XyeqtAXvr
         QGhRGi4bwCgizE+ibUulBcMrKs4VjFyTIUFZAXrM=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20200707060932epcas2p1d15f03f8f20e3d28e13e41c7a82ac4ad~fY3rcIEs70094800948epcas2p1J;
        Tue,  7 Jul 2020 06:09:32 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.189]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4B1Bpy5XfTzMqYkj; Tue,  7 Jul
        2020 06:09:30 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        73.9E.19322.A91140F5; Tue,  7 Jul 2020 15:09:30 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20200707060929epcas2p2ee3a7058f5674b4be1cd483e8aa80b55~fY3pI8KfQ1504215042epcas2p2E;
        Tue,  7 Jul 2020 06:09:29 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200707060929epsmtrp1be0423a49aba4195a38978532425b1bc~fY3pIJ4dx1927519275epsmtrp1N;
        Tue,  7 Jul 2020 06:09:29 +0000 (GMT)
X-AuditID: b6c32a45-7adff70000004b7a-1b-5f04119aa875
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        E0.14.08303.991140F5; Tue,  7 Jul 2020 15:09:29 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200707060929epsmtip2f3e059cbef347c6630a65d49cb7d0e4e~fY3o04HFV0285402854epsmtip2S;
        Tue,  7 Jul 2020 06:09:29 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Avri Altman'" <Avri.Altman@wdc.com>,
        <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <bvanassche@acm.org>,
        <grant.jung@samsung.com>, <sc.suh@samsung.com>,
        <hy50.seo@samsung.com>, <sh425.lee@samsung.com>
In-Reply-To: <SN6PR04MB4640958B96D370146EA86334FC660@SN6PR04MB4640.namprd04.prod.outlook.com>
Subject: RE: [RFC PATCH v1] ufs: introduce async ufs interface
 initialization
Date:   Tue, 7 Jul 2020 15:09:29 +0900
Message-ID: <000801d65425$2ce3ad50$86ab07f0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJf3Lb61o2624A7HIYY502pzJR6wwGotN4cAhHmw+Knyrt0YA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCJsWRmVeSWpSXmKPExsWy7bCmhe4sQZZ4g/WbtS0ezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usXrxAxaLRTe2MVl0X9/BZrH8+D8mi667Nxgt
        lv57y+LA63H5irfH5b5eJo8Jiw4wenxf38Hm8fHpLRaPvi2rGD0+b5LzaD/QzRTAEZVjk5Ga
        mJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0spJCWWJOKVAo
        ILG4WEnfzqYov7QkVSEjv7jEVim1ICWnwNCwQK84Mbe4NC9dLzk/18rQwMDIFKgyISfj2Zmr
        LAUnWSrWXjrI1MB4nrmLkZNDQsBEYuKeiYxdjFwcQgI7GCUaJr1lgXA+MUosPbeMCaRKSOAz
        o8SZvkCYjtdLvrFAxHcxSvyZVgbR8IJRYu2GXrAEm4C2xLSHu1lBEiIC95kkjux8AJbgFIiV
        2HqgC2yqsIC/xKe5S8HiLAIqEh0zljGC2LwClhKNSx8xQ9iCEidnPgGrYQYaumzha6i7FSR+
        Pl3GCmKLCDhJrLrQAFUjIjG7s40ZZLGEwAkOic7Xn1ghGlwkppy9wQRhC0u8Or6FHcKWknjZ
        3wZl10vsm9rACtHcwyjxdN8/RoiEscSsZ+1ANgfQBk2J9bv0QUwJAWWJI7eg9vJJdBz+yw4R
        5pXoaBOCaFSW+DVpMtQQSYmZN+9AbfKQWH/zM9sERsVZSL6cheTLWUi+mYWwdwEjyypGsdSC
        4tz01GKjAkPkyN7ECE7OWq47GCe//aB3iJGJg/EQowQHs5IIb682Y7wQb0piZVVqUX58UWlO
        avEhRlNguE9klhJNzgfmh7ySeENTIzMzA0tTC1MzIwslcd5cxQtxQgLpiSWp2ampBalFMH1M
        HJxSDUzKCo8VO+5mBwotu3bgQV6+29H/69NeCgj6CrznWZxdX9BjIz05KGfjhZ7WhIV73/Uc
        2aay+37Qprq5GnfUPRLqJGo/PE42embAkyi1d8bU5ckzbjjvimyoq4uX29ax46bV6Uy1NZ97
        xOWi/gh/YJ/0sTln21bGk4X6S22dX1zfNTsxPXCh8Dr96cu16z05jLpP7rGuzvudp+fgePpM
        c/z6z2yflUyWf09kWte1dNq/kkgjoas5labmWg+bZ7+NNX+sJb2O5+YyK8bG/P9zF3BuEbkl
        aL80xpj/o8G7pJVWF+b80+rYaOD3TuJbUU7yhhIvX/to1oD0dX2fKgVNl92udGs3FI14+DTd
        +rfwXCWW4oxEQy3mouJEAKt/EFJXBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsWy7bCSvO5MQZZ4g6YnRhYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCy6r+9gs1h+/B+TRdfdG4wW
        S/+9ZXHg9bh8xdvjcl8vk8eERQcYPb6v72Dz+Pj0FotH35ZVjB6fN8l5tB/oZgrgiOKySUnN
        ySxLLdK3S+DKmPR9AnvBeZaKV4v/MTUwXmTuYuTkkBAwkXi95BsLiC0ksINRYtYZIYi4pMSJ
        nc8ZIWxhifstR1i7GLmAap4xShy51scEkmAT0JaY9nA3WEJE4C2TxJ3bl5kgql4ySixt3cIK
        UsUpECux9UAXUIKDQ1jAV+LRXw2QMIuAikTHjGVgG3gFLCUalz5ihrAFJU7OfAJ2ETPQgqc3
        n8LZyxa+hrpaQeLn02Vg40UEnCRWXWiAqhGRmN3ZxjyBUWgWklGzkIyahWTULCQtCxhZVjFK
        phYU56bnFhsWGOWllusVJ+YWl+al6yXn525iBMejltYOxj2rPugdYmTiYDzEKMHBrCTC26vN
        GC/Em5JYWZValB9fVJqTWnyIUZqDRUmc9+ushXFCAumJJanZqakFqUUwWSYOTqkGpoOR62O6
        Z3sk+FzYfVlm775G3QUbHt/lyHjJcfHd8Z7A14ZnXoVf5n0YI+42TVvIcqJoS56byA2DlZ55
        BRf2XksJjo6fJdT5Ouq0ourRH+wm39s/xK6x/PdIgY/lQHiz7hMJg12RJjLsxadnTs1wTWQ6
        2bzzm04o0/ONb/Y0Gk5O0c+9xtKwIPdtf93hOxefTDx95IcNR8qvZdntnQuzKg49tag0klVy
        vSoxKVsvb03SkvSvazbZRTreYPZfGLiv6lyP7tkFInkX3oRWrfD8OiG/k2nR5jehpyw1w2pn
        Wf8RKvj8bInwjDa1I9e6DuyMkP076d2Ct5dMDRWC9Jz3WQW/P/NCP2vi7FjZR8vvSCqxFGck
        GmoxFxUnAgByuvG+NgMAAA==
X-CMS-MailID: 20200707060929epcas2p2ee3a7058f5674b4be1cd483e8aa80b55
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200702082826epcas2p2face6d1689c2f5efc1dcdb53c19804b8
References: <CGME20200702082826epcas2p2face6d1689c2f5efc1dcdb53c19804b8@epcas2p2.samsung.com>
        <1593678039-139543-1-git-send-email-kwmad.kim@samsung.com>
        <SN6PR04MB4640958B96D370146EA86334FC660@SN6PR04MB4640.namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > When you set uic_link_state during sleep statae to UIC_LINK_OFF_STATE,
> > UFS driver does interface initialization that is a series of some
> > steps including fDeviceInit and thus, You might feel that its latency
> > is a little bit longer.
> >
> > This patch is run it asynchronously to reduce system wake-up time.
> Can you share your initial testing findings?
> How much time does it save?

Will share when I'm done. And I think you might already know and
the time is variant per device and its situation, particularly for fDeviceI=
nit.

Thanks.
Kiwoong Kim

