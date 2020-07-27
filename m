Return-Path: <SRS0=pIAL=BG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD397C433E4
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 11:28:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC56220663
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 11:28:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="By/jlQLv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbgG0L2H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jul 2020 07:28:07 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:54050 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726744AbgG0L2G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jul 2020 07:28:06 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200727112803epoutp011e64b36d53e7330a9ef74d16029ce938~lmHffPWFY1221412214epoutp01a
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2020 11:28:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200727112803epoutp011e64b36d53e7330a9ef74d16029ce938~lmHffPWFY1221412214epoutp01a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1595849283;
        bh=5ms+BlpB9je1Ws0wRff4ib5SVFYg9Xg6lplh0DTHrBA=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=By/jlQLvbM95/7rcacCFzGhgpO+vwE9QaRvFcbLR/+qdU4xUvO0ghoBL0jcEwsG28
         XXuY7wXll/W78dB7LZ3IaLQHhICz04NpJzCw6wIfgmjFkMIAV0yQSkUKPMNR67nelr
         hRqHaGXdPuQtV5YRuIo4SUvY6qhhcFFCK1yT2rZg=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20200727112802epcas2p12d1ccf0975f7a6e07db33cebab8c7a72~lmHezv9h93081230812epcas2p1J;
        Mon, 27 Jul 2020 11:28:02 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.184]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4BFcxD5Y71zMqYkY; Mon, 27 Jul
        2020 11:28:00 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        5F.6B.27013.04ABE1F5; Mon, 27 Jul 2020 20:28:00 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20200727112800epcas2p3a62bc55accea032b2a5763b1cd91297c~lmHcYbdYo2505125051epcas2p3I;
        Mon, 27 Jul 2020 11:28:00 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200727112800epsmtrp2ef2408a0f97a35614ecf2adca911aa26~lmHcXtRKL2041020410epsmtrp2i;
        Mon, 27 Jul 2020 11:28:00 +0000 (GMT)
X-AuditID: b6c32a48-d1fff70000006985-5c-5f1eba40cb9a
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        81.E0.08303.04ABE1F5; Mon, 27 Jul 2020 20:28:00 +0900 (KST)
Received: from KORDO040863 (unknown [12.36.185.126]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200727112800epsmtip2fd1fc76325935b6572c89be02557df52~lmHcMSLIi2946729467epsmtip2X;
        Mon, 27 Jul 2020 11:28:00 +0000 (GMT)
From:   =?UTF-8?B?7ISc7Zi47JiB?= <hy50.seo@samsung.com>
To:     "'Avri Altman'" <Avri.Altman@wdc.com>,
        <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <bvanassche@acm.org>,
        <grant.jung@samsung.com>
In-Reply-To: <SN6PR04MB4640AC885D7E57D6FB4A9994FC720@SN6PR04MB4640.namprd04.prod.outlook.com>
Subject: RE: [RFC PATCH v3 1/3] scsi: ufs: modify write booster
Date:   Mon, 27 Jul 2020 20:28:00 +0900
Message-ID: <074101d66408$fbce5e10$f36b1a30$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQHLP/cB05Q6MF8BaP7+redz0q/FGgJKaxVPAfmAvQEBqiAtXwC8ncqPAgJkXF2o7CmJ0A==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEJsWRmVeSWpSXmKPExsWy7bCmma7DLrl4g/5F2hYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WHRjG5NF9/UdbBbLj/9jcuDyuHzF2+NyXy+T
        x4RFBxg9vq/vYPP4+PQWi0ffllWMHp83yXm0H+hmCuCIyrHJSE1MSS1SSM1Lzk/JzEu3VfIO
        jneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAbpRSaEsMacUKBSQWFyspG9nU5RfWpKqkJFf
        XGKrlFqQklNgaFigV5yYW1yal66XnJ9rZWhgYGQKVJmQk3Fz0m22gr/MFdd/HGJvYGxi7mLk
        5JAQMJFoWnyDCcQWEtjBKHGiX7GLkQvI/sQo8erTSxYI5zOjxKz7fawwHd+bD7NCdOxilPg3
        vwjCfskoce9FOojNJmAq0bdtBStIs4jANCaJ3b8WAa3g4OAUiJVYczkPpEZYwF7i/bJ97CA2
        i4CqxLVDB8Bm8gpYSlyY+YIRwhaUODnzCQuIzSwgL7H97RyoqxUkdpx9DVYjIhAmseLxX3aI
        GhGJ2Z1tzCB7JQR2cEjM+7GOHaLBRaJx52yoZmGJV8e3QMWlJD6/28sGYddLTLm3igWiuYdR
        Ys+KE0wQCWOJWc/aGUEeYBbQlFi/Sx/ElBBQljhyC+o2PomOwyA3gIR5JTrahCAalSTOzL0N
        FZaQODg7ByLsIdF7aAn7BEbFWUienIXkyVlInpmFsHYBI8sqRrHUguLc9NRiowIT5JjexAhO
        vFoeOxhnv/2gd4iRiYPxEKMEB7OSCC+3qEy8EG9KYmVValF+fFFpTmrxIUZTYLBPZJYSTc4H
        pv68knhDUyMzMwNLUwtTMyMLJXHed1YX4oQE0hNLUrNTUwtSi2D6mDg4pRqYFP/03Etd+uee
        +4tk/+uRDX/uM5zdcvUkt3GTlrGjKmPvyoyc5FdZ3+Zk9a3v3+Np+fz5qct6occsE0+XByof
        TSkJP1gpszJz3kfl/ZdPhsuxc06U3Ox73ybIafr+VRsqH7Zaza9RtzozI9JHZEHAckZJFb4O
        TqvPNw1yT5uvWKkW82dP4IrTF9TkU8JWOjx+3CTZptql/2DDua0ruKMk47/xGu58lSf7bu+K
        Q9zLHOp0SyxkGI9NSNqzfWq2oavmM+VtP3PifrlPlJzHVd/MP0Py/iLfK7ZlQXs6drYknTS9
        mPP+3/G163knPhEwUMxYdiBeeyvv3YWbL/i7qIjufss7M2PO/WdpU8pSTd4tVWIpzkg01GIu
        Kk4EACkZ5N1FBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsWy7bCSvK7DLrl4g9aL3BYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WHRjG5NF9/UdbBbLj/9jcuDyuHzF2+NyXy+T
        x4RFBxg9vq/vYPP4+PQWi0ffllWMHp83yXm0H+hmCuCI4rJJSc3JLEst0rdL4Mq4Oek2W8Ff
        5orrPw6xNzA2MXcxcnJICJhIfG8+zNrFyMUhJLCDEci5wQSRkJD4v7gJyhaWuN9yhBXEFhJ4
        zigx84IAiM0mYCrRt20FWLOIwAImiUer9zNBTFrBLHHx+xUgh4ODUyBWYs3lPJAGYQF7iffL
        9rGD2CwCqhLXDh0AG8orYClxYeYLRghbUOLkzCcsIDazgLZE78NWRghbXmL72zlQVytI7Dj7
        GiwuIhAmseLxX3aIGhGJ2Z1tzBMYhWYhGTULyahZSEbNQtKygJFlFaNkakFxbnpusWGBUV5q
        uV5xYm5xaV66XnJ+7iZGcMRpae1g3LPqg94hRiYOxkOMEhzMSiK83KIy8UK8KYmVValF+fFF
        pTmpxYcYpTlYlMR5v85aGCckkJ5YkpqdmlqQWgSTZeLglGpgqvlvsm2b7/l1pz9Y6+707HR7
        GhFZZOuS+cVn4buPM1sEZ/71Y3mZcEluV66jeGDgJUf+F7vu7v4a8/fBwu+3S3ZtP9NRNePC
        fvf7+Y6yze+N71mu69vLndrGaZKptuLJ27Nyl9vfTbr0V4Qve7GL8JItfRZGV9qepm78cmHr
        Jp8lmVfyFn6+EHy7YPK5j+wnN/kfzVS70qWYtO57zb5f0trKIZdfiaXLrGaap/XieUHrjPNM
        QX9WX2Lgb5FSaVyraxTAnqd2d+rmrISY7piPf+vFLHj3zimVtb3VvznwhpncnqmP/O5e1nSr
        aHeL42E+tNKP+5Fmjf6Pa98OF9W8MlI4bvVBJ/vrrbnMj4572SmxFGckGmoxFxUnAgAYVqQo
        JwMAAA==
X-CMS-MailID: 20200727112800epcas2p3a62bc55accea032b2a5763b1cd91297c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200721095648epcas2p18c3d496076ecd1537e47081c19dbb97e
References: <cover.1595325064.git.hy50.seo@samsung.com>
        <CGME20200721095648epcas2p18c3d496076ecd1537e47081c19dbb97e@epcas2p1.samsung.com>
        <90ad671ed4a2b4f6035e9858153a13f7c00a1904.1595325064.git.hy50.seo@samsung.com>
        <SN6PR04MB46406E701D8571E3A1EB5FDFFC750@SN6PR04MB4640.namprd04.prod.outlook.com>
        <071d01d663fc$4782ef40$d688cdc0$@samsung.com>
        <SN6PR04MB4640AC885D7E57D6FB4A9994FC720@SN6PR04MB4640.namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> 
> > > Like I already told you in your v1:
> > > If you are relaying on ufsfeatures - you need to wait for it to be
> merged.
> > > Meanwhile, it got nacked (nack^2 actually), so you need to take this
> > > into account.
> >
> > Sorry, for not catching this.
> > Then can I know when the code was merged?
> > I will remove this function.
> You can follow "scsi: ufs: Add Host Performance Booster Support" - Only if
> you are not removing the dependency in ufsfeatures.
OK, I will remove this

