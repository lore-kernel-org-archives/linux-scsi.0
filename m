Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 227F5C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 21:14:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC127610CA
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 21:14:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbhJ1VQv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Oct 2021 17:16:51 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:35273 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbhJ1VQv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Oct 2021 17:16:51 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20211028211422epoutp02ff983323ab07dc23b8fcfea0da0e4041~yTkJ5y2LA0537105371epoutp02U
        for <linux-scsi@vger.kernel.org>; Thu, 28 Oct 2021 21:14:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20211028211422epoutp02ff983323ab07dc23b8fcfea0da0e4041~yTkJ5y2LA0537105371epoutp02U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1635455662;
        bh=6a4uyrZ6koMcqOIdTiv9lwrxGfAw0oIlzAk/+IKAd+Q=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=nfc9y/wlQE1W6VKPEIcCxBGWe4H4thGV2zeD2oYG789VuAotsq70nAgnC92k4zvd0
         cXqsT25kL/eIkhv7Cm0m1fHNF2nbY5WvnLdNKWQgmPgmrmavhIdrclsw4UoPy+SIgb
         rKemmgR25mh0R+8sq5V+IzSvAO+aNwfS19F16YlM=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20211028211421epcas2p2a7bc2c4275211f52c6023696b967347c~yTkJAJhHz2451824518epcas2p2E;
        Thu, 28 Oct 2021 21:14:21 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.36.92]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4HgJGG4lVmz4x9Pr; Thu, 28 Oct
        2021 21:14:14 +0000 (GMT)
X-AuditID: b6c32a47-473ff7000000271e-6e-617b12a69ced
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        29.75.10014.6A21B716; Fri, 29 Oct 2021 06:14:14 +0900 (KST)
Mime-Version: 1.0
Subject: RE: [PATCH] scsi: ufs: mark HPB support as BROKEN
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Christoph Hellwig <hch@lst.de>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Jaegeuk Kim <jaegeuk@kernel.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Daejun Park <daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <76b67325-9788-2876-5546-5be6df615a5c@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20211028211414epcms2p6a5ee1ccf25dc45bcefbe2f3d21557563@epcms2p6>
Date:   Fri, 29 Oct 2021 06:14:14 +0900
X-CMS-MailID: 20211028211414epcms2p6a5ee1ccf25dc45bcefbe2f3d21557563
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLJsWRmVeSWpSXmKPExsWy7bCmme4yoepEgwlPlCwezNvGZvHy51U2
        i9V3+9kspn34yWzx8pCmxaoH4RYrVx9lsniyfhazxcZ+Dou9t7Qtuq/vYLNYfvwfkwOPx+Ur
        3h7TJp1i87h8ttRj06pONo/dNxvYPD4+vcXi0bdlFaPH501yHu0HupkCOKOybTJSE1NSixRS
        85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOArlVSKEvMKQUKBSQWFyvp
        29kU5ZeWpCpk5BeX2CqlFqTkFJgX6BUn5haX5qXr5aWWWBkaGBiZAhUmZGf07EgveCtYMevT
        VuYGxv98XYwcHBICJhIn1hZ2MXJxCAnsYJQ4ffkNE0icV0BQ4u8O4S5GTg5hASuJPzOvMILY
        QgJKEusvzmKHiOtJ3Hq4BizOJqAjMf3EfXaQOSICzYwSz1ZsYwRxmAU+M0lc3P8BrENCgFdi
        RvtTFghbWmL78q1g3ZwC1hLTH6xkhohrSPxY1gtli0rcXP2WHcZ+f2w+I4QtItF67yxUjaDE
        g5+7oeKSEsd2f2CCsOsltt75BXaEhEAPo8ThnbdYIRL6Etc6NoIdwSvgK3H76QewOIuAqsTf
        6S1sEDUuEjv3nQWLMwvIS2x/O4cZFCrMApoS63fpQwJOWeLILRaYtxo2/mZHZzML8El0HP4L
        F98x7wnUaWoS636uZ5rAqDwLEdSzkOyahbBrASPzKkax1ILi3PTUYqMCY3jcJufnbmIEp1st
        9x2MM95+0DvEyMTBeIhRgoNZSYT38rzyRCHelMTKqtSi/Pii0pzU4kOMpkBfTmSWEk3OByb8
        vJJ4QxNLAxMzM0NzI1MDcyVxXkvR7EQhgfTEktTs1NSC1CKYPiYOTqkGpjnPLypx3zOdFl/o
        Efiu6NLl9m0LeAsnLUxt/Det4dR68Z6JVSuPLP1sqpBzZH/potXSE7rSZ07XmWiUfFm2XWED
        x9n/nWqHTtu8fmp7XPBkVscqhr1MX9gMMj7tPnOOvVPzv/Sq5/MWPlZYeSTrxIlXLnGTfsw7
        psdXy3O4KGfJX0E9pm5OpUIvn536Dj2c07s7+KSV3BSM+Z2m7d3Z/e7jvJf3XfwN5xYc4imM
        TN74J1RV+dz/eM5Lx2VWle5w+tpYk3lY+G8Ov/O8D2kd4mK9tRFc2u9O3vinq3Nb+0moVc/U
        9+dYl6XMPLXh6pnGglbRFs4+LpbWz8euhZW9rneVdotfECW6dWf51cxHzUosxRmJhlrMRcWJ
        AJX4VaVABAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211028205342epcas2p40838e84438572adf052d106dc82e35ff
References: <76b67325-9788-2876-5546-5be6df615a5c@acm.org>
        <20211026071204.1709318-1-hch@lst.de>
        <99641481-523a-e5a9-db48-dac2b547b4bd@acm.org>
        <7ed11ee1f8beca9a27c0cb2eb0dcea4dbd557961.camel@HansenPartnership.com>
        <870e986c-08dd-2fa2-a593-0f97e10d6df5@kernel.dk>
        <4438ab72-7da0-33de-ecc9-91c3c179eca7@acm.org>
        <c3d85be5-2708-ea50-09ac-2285928bbe0e@kernel.dk>
        <36729509daa80fd48453e8a3a1b5c23750948e6c.camel@HansenPartnership.com>
        <yq1ee873av4.fsf@ca-mkp.ca.oracle.com>
        <679b4d3b-778e-47cd-d53f-f7bf77315f7c@acm.org>
        <20211027052724.GA8946@lst.de>
        <b2bcc13ccdc584962128a69fa5992936068e1a9b.camel@HansenPartnership.com>
        <a6af2ce7-4a03-ab0c-67cd-c58022e5ded1@acm.org>
        <4f16a99974be6f2a0f207d5ca7327719cdf4e36e.camel@HansenPartnership.com>
        <CGME20211028205342epcas2p40838e84438572adf052d106dc82e35ff@epcms2p6>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

>On 10/28/21 1:33 PM, James Bottomley wrote:
>> On Thu, 2021-10-28 at 13:21 -0700, Bart Van Assche wrote:
>> [...]
>>> Hi James,
>>>
>>> The help with trying to find a solution is appreciated.
>>>
>>> One of the software developers who is familiar with HPB explained to
>>> me that READ BUFFER and WRITE BUFFER commands may be received in an
>>> arbitrary order by UFS devices. The UFS HPB spec requires UFS devices
>>> to be able to stash up to 128 such pairs. I'm concerned that leaving
>>> out WRITE BUFFER commands only will break the HPB protocol in a
>>> subtle way.
>> 
>> Based on the publicly available information (the hotstorage paper) I
>> don't belive it can.  The Samsung guys also appear to confirm that the
>> use of WRITE BUFFER is simply an optimzation for large requests:
>> 
>> https://lore.kernel.org/all/20211025051654epcms2p36b259d237eb2b8b885210148118c5d3f@epcms2p3/
>> 
>> As did the excerpt from the spec you posted.  It will cause slowdowns
>> for reads of > 32kb, because they have to go through the native FTL
>> lookup now, but there shouldn't be any functional change.  Unless
>> there's anything else in the proprietary spec that contradicts this?
> 
>Are the UFS standards really proprietary? On https://protect2.fireeye.com/v1/url?k=06710f38-59ea363a-06708477-0cc47a312ab0-c90f3c77bf2bad78&q=1&e=f2e21ae2-d0b7-459b-9881-2a4a38b8ec92&u=https%3A%2F%2Fwww.t10.org%2Fpubs.htm
>I found the following: "Approved American National Standards and Technical
>Reports may be purchased from: [ ... ]". And on
>https://protect2.fireeye.com/v1/url?k=0d1654b0-528d6db2-0d17dfff-0cc47a312ab0-21da8440e5f6d771&q=1&e=f2e21ae2-d0b7-459b-9881-2a4a38b8ec92&u=https%3A%2F%2Fwww.jedec.org%2Fdocument_search%3Fsearch_api_views_fulltext%3Dhpb I found
>the following: "Available for purchase: $80.00". It seems to me that SCSI
>and JEDEC standards are available under similar conditions?
> 
>Regarding the question about the impact of leaving out WRITE BUFFER
>commands on the HPB protocol, I hope that one of the HPB experts will be so
>kind to answer that question.

If the driver doesn't send WRITE BUFFER commands on the HPB protocol, the
READ which requires pre-request (e.g. >32KB) cannot be HPB READ.

Thanks,
Daejun
