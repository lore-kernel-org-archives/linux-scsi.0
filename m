Return-Path: <SRS0=EBgm=AS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31C02C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 06:50:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BFA1206E9
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 06:50:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="FDolUC92"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbgGGGuy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jul 2020 02:50:54 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:62809 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727008AbgGGGuy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jul 2020 02:50:54 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200707065052epoutp048ecb8060922b5f5ad1f0de59830ed447~fZbxQY5jD1077710777epoutp04_
        for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2020 06:50:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200707065052epoutp048ecb8060922b5f5ad1f0de59830ed447~fZbxQY5jD1077710777epoutp04_
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594104652;
        bh=f2MLdUIYHh8CiGmeIVKXfca4KHhSF9OPDoC3dL6ALXo=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=FDolUC92W4+qR1k0D7iKJmvf5Dm+eN/1hVPU2f+MzzdXBCYfv5Nk+y46A5RtAOqaf
         KlulShZ+Z6S/ixShSP3YBIfoAfSNyFN3OuN3MeC6/xvG0qHjVaEsL/f/RFjzhDP0tZ
         VGKikSGE/4KbtDAfat060ea/t8COgmKosnUcPZcI=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTP id
        20200707065051epcas1p45acd994d596f3659e852c3aa3428cc88~fZbwR29-30974109741epcas1p4F;
        Tue,  7 Jul 2020 06:50:51 +0000 (GMT)
Received: from epsmges1p3.samsung.com (unknown [182.195.40.166]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4B1Ckf2Sj1zMqYkW; Tue,  7 Jul
        2020 06:50:50 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        B8.C4.29173.74B140F5; Tue,  7 Jul 2020 15:50:47 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200707065045epcas1p166c2d6094e7aa2f7b2802bd70fd8f5f2~fZbqp4hQ81794117941epcas1p1N;
        Tue,  7 Jul 2020 06:50:45 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200707065045epsmtrp190c2f2874348308108c1be060bff69a2~fZbqpHRz00837708377epsmtrp16;
        Tue,  7 Jul 2020 06:50:45 +0000 (GMT)
X-AuditID: b6c32a37-9cdff700000071f5-e8-5f041b479751
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        93.B8.08303.54B140F5; Tue,  7 Jul 2020 15:50:45 +0900 (KST)
Received: from grantjung02 (unknown [10.214.113.116]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200707065045epsmtip1286256647a36f34784aba2938f6501bd~fZbqdYVtp0207902079epsmtip1N;
        Tue,  7 Jul 2020 06:50:45 +0000 (GMT)
From:   "Grant Jung" <grant.jung@samsung.com>
To:     "'Kiwoong Kim'" <kwmad.kim@samsung.com>,
        "'Avri Altman'" <Avri.Altman@wdc.com>,
        <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <bvanassche@acm.org>, <sc.suh@samsung.com>,
        <hy50.seo@samsung.com>, <sh425.lee@samsung.com>
In-Reply-To: <000801d65425$2ce3ad50$86ab07f0$@samsung.com>
Subject: RE: [RFC PATCH v1] ufs: introduce async ufs interface
 initialization
Date:   Tue, 7 Jul 2020 15:50:45 +0900
Message-ID: <524801d6542a$f0744680$d15cd380$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJf3Lb61o2624A7HIYY502pzJR6wwGotN4cAhHmw+IB2c0IWqe79T+Q
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGJsWRmVeSWpSXmKPExsWy7bCmrq67NEu8wc41phYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFqsXP2CxWHRjG5PFzS1HWSy6r+9gs1h+/B+TRdfdG4wW
        S/+9ZXHg9bh8xdvjcl8vk8eERQcYPb6v72Dz+Pj0FotH35ZVjB6fN8l5tB/oZgrgiMqxyUhN
        TEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAE6WUmhLDGnFCgU
        kFhcrKRvZ1OUX1qSqpCRX1xiq5RakJJTYGhQoFecmFtcmpeul5yfa2VoYGBkClSZkJNxYude
        1oJutoreu5tZGhjvsXQxcnJICJhI3D7dxtzFyMUhJLCDUeL5ni52kISQwCdGiad92hCJz4wS
        C+fcZ4Tp+HTvDAtEYhejRNeag1DOK0aJx18+grWzCWhLTNz1mQnEFhF4xyTRN9sExOYUsJKY
        07OXDcQWFvCX+DR3KdgdLAIqEu/utoP18gpYSiy+cpoZwhaUODnzCVgNM9DMZQtfM0NcoSDx
        8+kyVoj5bhKXVuxkhqgRkZjdCfGPhMAJDomNLWvZIBpcJFaeWssEYQtLvDq+hR3ClpJ42d/G
        DtHQzyixruc0C4QzAchZdxBqnbHEp8+fgQHAAbRCU2L9Ln2IsKLEzt9zGSE280m8+9rDClIi
        IcAr0dEmBFGiInFy4y1WmF0P9s2Dmughsf7mZ7YJjIqzkPw5C8mfs5D8Mwth8QJGllWMYqkF
        xbnpqcWGBcbI0b2JEZygtcx3ME57+0HvECMTB+MhRgkOZiUR3l5txngh3pTEyqrUovz4otKc
        1OJDjKbAkJ/ILCWanA/MEXkl8YamRsbGxhYmZuZmpsZK4ry+VhfihATSE0tSs1NTC1KLYPqY
        ODilGpjcP3JV3W/p+Rsf7pMWte/IIn+nm9f/F920P3ZHaNWPd/ZnhbJPaC8yFL0asfuuohP/
        o6IZ6+6uPPmLfdrjKbvZNHJs53nd4X49+4/bir9enROFM3fKFXoaFmhGPi94fiZ6rtXrr/8P
        hcUp/o94tprR9zPLpK8Ty5o/alQcmPxh3YIHpyWOvXy3pUlh57vlClKzU6TDKu/+/bV42t2K
        phxn18ssB7brex9SSZngwN21+csadt/ayG+mx1dtV/xaMnFHV2ZM+n63q5d359TfeP0z7EH7
        88tH72sdZN70KFuTe0enfwin7uN5sRPX9F1PNzY89+p547U3mwuKk4+LTlqw5K79/uxFtQW9
        P223aK+YvkKJpTgj0VCLuag4EQCMH7vKWQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsWy7bCSnK6rNEu8wZ4NUhYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFqsXP2CxWHRjG5PFzS1HWSy6r+9gs1h+/B+TRdfdG4wW
        S/+9ZXHg9bh8xdvjcl8vk8eERQcYPb6v72Dz+Pj0FotH35ZVjB6fN8l5tB/oZgrgiOKySUnN
        ySxLLdK3S+DKmN8aXjCRraJ/3R2mBsYHLF2MnBwSAiYSn+6dAbK5OIQEdjBKfJ23BSohJbH4
        8gPmLkYOIFtY4vDhYoiaF4wSpxZ9YQSpYRPQlpi46zMTSEJE4A+TxPsn31khqqYzSUyaeYwZ
        pIpTwEpiTs9eNpBJwgK+Eo/+aoCEWQRUJN7dbWcHsXkFLCUWXznNDGELSpyc+QTsCGagBb0P
        Wxlh7GULXzNDHKcg8fPpMlYQW0TATeLSip3MEDUiErM725gnMArNQjJqFpJRs5CMmoWkZQEj
        yypGydSC4tz03GLDAqO81HK94sTc4tK8dL3k/NxNjOBo1NLawbhn1Qe9Q4xMHIyHGCU4mJVE
        eHu1GeOFeFMSK6tSi/Lji0pzUosPMUpzsCiJ836dtTBOSCA9sSQ1OzW1ILUIJsvEwSnVwGT5
        jVPCcMG6ykTfmFPO90NupExPZoucbeVXtXZPIMuBN+pbzddNd13j+/LpqRsFy5Mc60MX7Eju
        04i122wasWryJ0O9g+kPTvKI27FJ+nutZl1oqjN/aZC540nxtKCpqReszuzIzji1JfGQ6ds5
        x2bMyZBKdG/Tm/5kypRLL0rYbDJWtxYa/T7fXPB/QeSqd3G/putcm5oVWsV60yVOdcqm7aGT
        5ZeJ3znuEbA7+ofVm3MOCh9jhd9M54z8wzEpR7hl5s2TMlL9ZrpNWUoce9g5HotdZniqcl/y
        4cqrtju2JNl3FQqXNTO1G+q/Fzgk+HuVgHHtVe7/yxwXN7at/Nw/oVOtynkG0zaPuWsTlZRY
        ijMSDbWYi4oTAVwTBn81AwAA
X-CMS-MailID: 20200707065045epcas1p166c2d6094e7aa2f7b2802bd70fd8f5f2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200702082826epcas2p2face6d1689c2f5efc1dcdb53c19804b8
References: <CGME20200702082826epcas2p2face6d1689c2f5efc1dcdb53c19804b8@epcas2p2.samsung.com>
        <1593678039-139543-1-git-send-email-kwmad.kim@samsung.com>
        <SN6PR04MB4640958B96D370146EA86334FC660@SN6PR04MB4640.namprd04.prod.outlook.com>
        <000801d65425$2ce3ad50$86ab07f0$@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > > When you set uic_link_state during sleep statae to
> > > UIC_LINK_OFF_STATE, UFS driver does interface initialization that is
> > > a series of some steps including fDeviceInit and thus, You might
> > > feel that its latency is a little bit longer.
> > >
> > > This patch is run it asynchronously to reduce system wake-up time.
> > Can you share your initial testing findings?
> > How much time does it save?
>=20
> Will share when I'm done. And I think you might already know and the time
> is variant per device and its situation, particularly for fDeviceInit.
>=20
> Thanks.
> Kiwoong Kim

I think it depends on each platform.=20
I has used this since years ago to reduce system wake-up time and could sav=
e about 60ms at that time.

BR
Grant.


