Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 742A2C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Sep 2021 05:47:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A4A2611B0
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Sep 2021 05:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239226AbhIWFtW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Sep 2021 01:49:22 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:53410 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbhIWFtU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Sep 2021 01:49:20 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210923054747epoutp03f356e93e5d42836b06ac81a2312f8efb~nXWJ2cB003066530665epoutp03F
        for <linux-scsi@vger.kernel.org>; Thu, 23 Sep 2021 05:47:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210923054747epoutp03f356e93e5d42836b06ac81a2312f8efb~nXWJ2cB003066530665epoutp03F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1632376067;
        bh=KNLsbV+6FGy/WK7JldCemi5hEqLctbXIGV738zAc1SA=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=ZcjMLCKRs5OXkLyfV5F8B0vh8nVzU6mY94l3XaKIoJea4TPRva0AGNyCZkOaqBTM+
         KHpqIdgI3T1dqEzsiPQeObPCXcqlQSZL9U5UO8SrCeD9/LYj8tT8fYqESsR0lVV6TY
         zBVdBqnWNcUuOicA+ZcP+BNwQ5kKc2imfP9nIMPc=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210923054746epcas2p4c040b330e03151b1de75851d58529f46~nXWJUhix61279812798epcas2p4z;
        Thu, 23 Sep 2021 05:47:46 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.186]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4HFPMN6QQZz4x9Pv; Thu, 23 Sep
        2021 05:47:44 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        EB.84.09717.0051C416; Thu, 23 Sep 2021 14:47:44 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20210923054744epcas2p44598a40148d965fda57fe65ff687f51c~nXWG2CouI1279812798epcas2p4h;
        Thu, 23 Sep 2021 05:47:44 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210923054744epsmtrp1fa75486b66f324822cfc89311aa60b08~nXWG09qzD0211402114epsmtrp1l;
        Thu, 23 Sep 2021 05:47:44 +0000 (GMT)
X-AuditID: b6c32a45-4c1ff700000025f5-f1-614c1500c8d4
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        11.C8.09091.FF41C416; Thu, 23 Sep 2021 14:47:43 +0900 (KST)
Received: from KORCO039056 (unknown [10.229.8.156]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210923054743epsmtip12132d7dec80f3ea4b8378c71837d25e6~nXWGnLMOB2265222652epsmtip1Y;
        Thu, 23 Sep 2021 05:47:43 +0000 (GMT)
From:   "Chanho Park" <chanho61.park@samsung.com>
To:     "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'Avri Altman'" <avri.altman@wdc.com>,
        "'James E . J . Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K . Petersen'" <martin.petersen@oracle.com>,
        "'Krzysztof Kozlowski'" <krzysztof.kozlowski@canonical.com>
Cc:     "'Bean Huo'" <beanhuo@micron.com>,
        "'Bart Van Assche'" <bvanassche@acm.org>,
        "'Adrian Hunter'" <adrian.hunter@intel.com>,
        "'Christoph Hellwig'" <hch@infradead.org>,
        "'Can Guo'" <cang@codeaurora.org>,
        "'Jaegeuk Kim'" <jaegeuk@kernel.org>,
        "'Gyunghoon Kwon'" <goodjob.kwon@samsung.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        "'Kiwoong Kim'" <kwmad.kim@samsung.com>
In-Reply-To: <001501d7b031$8bb26790$a31736b0$@samsung.com>
Subject: RE: [PATCH v3 09/17] scsi: ufs: ufs-exynos: correct timeout value
 setting registers
Date:   Thu, 23 Sep 2021 14:47:43 +0900
Message-ID: <004201d7b03e$8778f0b0$966ad210$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Content-Language: ko
Thread-Index: AQKr0ifVbQZWZSl2xwEUfL3y5isNhQEFFhnDAOXa6WYBWRnvFqnuuBog
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIJsWRmVeSWpSXmKPExsWy7bCmhS6DqE+iQc9LBYuTT9awWTyYt43N
        4uXPq2wWBx92slhM+/CT2eLT+mWsFj07nS1OT1jEZPFk/Sxmi0U3tjFZbHz7g8ni5pajLBYz
        zu9jsui+voPNYvnxf0wO/B6Xr3h7zGroZfO43NfL5LF5hZbH4j0vmTw2repk85iw6ACjx/f1
        HWweH5/eYvHo27KK0ePzJjmP9gPdTAE8UTk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6
        hpYW5koKeYm5qbZKLj4Bum6ZOUDvKCmUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslVILUnIK
        DA0L9IoTc4tL89L1kvNzrQwNDIxMgSoTcjIWzNrJVPCRrWL9u4WsDYz3WbsYOTkkBEwkuu58
        Zepi5OIQEtjBKDFtWzcrhPOJUWLf2bPMEM43Rom3F1YwwrT0T73CDpHYyyhx6dxRqKoXjBI/
        u7Yyg1SxCehLvOzYBjZLROA/o8SjdZPBqpgFpjJLzFo7A8jh4OAUsJLYtJELpEFYIE7i+IXX
        7CA2i4CqxI2OVjCbV8BS4tr/RVC2oMTJmU9YQGxmAW2JZQtfM0OcpCDx8+kyVoi4iMTszjaw
        uIiAm8SOLT1gp0oI/OeQ+PNwEjvIXgkBF4mnfdwQvcISr45vYYewpSRe9rdB1XczSrQ++g+V
        WM0o0dnoA2HbS/yavoUVZA6zgKbE+l36ECOVJY7cgjqNT6Lj8F+oTbwSHW1CEI3qEge2T2eB
        sGUluud8Zp3AqDQLyWOzkDw2C8kzsxB2LWBkWcUollpQnJueWmxUYIgc25sYwWldy3UH4+S3
        H/QOMTJxMB5ilOBgVhLh/XzDK1GINyWxsiq1KD++qDQntfgQoykwqCcyS4km5wMzS15JvKGp
        kZmZgaWphamZkYWSOO/cf06JQgLpiSWp2ampBalFMH1MHJxSDUzJk4T28pd5Fh99emzdjAlf
        0nNM7nFtmxW641BXrN8ytv/6M1n2rRV0DUkpLkw6c6zh9bNrS/89zOnRrP23p/bw9Mw4a2kJ
        ryMbQow/O/5Yy9QwOfPT7dJyR9uPGb3Pvi6YsKuwcPUc6b6vHSnPvbNbdrX9zd/zat+R7Rtb
        Cw4wWstHnE+qLW1cmCP/3vz3Rt/qE4EiXKYr9Y7WbOY6YZkdzzG1WaDwkfUh+7KeMtN9S12r
        WtTmLlzRtXmjwkfVj/Fr9553MFl1/e2H7WGbt60XFon2WxV/9Fxss6jMQ9F3/uUZy/Wro0Iy
        Zu0T3xUSeWGJ8IWAhaFbbfPO/ZrGGJnYONOn/EjNXNOPehZRP88rsRRnJBpqMRcVJwIAD3Bh
        i3QEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsWy7bCSnO5/EZ9EgytXTSxOPlnDZvFg3jY2
        i5c/r7JZHHzYyWIx7cNPZotP65exWvTsdLY4PWERk8WT9bOYLRbd2MZksfHtDyaLm1uOsljM
        OL+PyaL7+g42i+XH/zE58HtcvuLtMauhl83jcl8vk8fmFVoei/e8ZPLYtKqTzWPCogOMHt/X
        d7B5fHx6i8Wjb8sqRo/Pm+Q82g90MwXwRHHZpKTmZJalFunbJXBlXF6wnqXgClvFnfOHmBoY
        j7B2MXJySAiYSPRPvcLexcjFISSwm1Fi1fQDjBAJWYln73awQ9jCEvdbQBpAip4xSvzYdJQN
        JMEmoC/xsmMbWEJEoJFJ4tqyu8wgDrPAXGaJlXP3Q839wijxc/o9oAwHB6eAlcSmjVwg3cIC
        MRKPFs0CW8cioCpxo6MVbB2vgKXEtf+LoGxBiZMzn7CA2MwC2hK9D1sZYexlC18zQ5ynIPHz
        6TJWiLiIxOzONrC4iICbxI4tPewTGIVnIRk1C8moWUhGzULSvoCRZRWjZGpBcW56brFhgWFe
        arlecWJucWleul5yfu4mRnCMa2nuYNy+6oPeIUYmDsZDjBIczEoivJ9veCUK8aYkVlalFuXH
        F5XmpBYfYpTmYFES573QdTJeSCA9sSQ1OzW1ILUIJsvEwSnVwBSTLzZHdvvFCx1b/YS1nWeo
        TL35nzXX0NyQZS6XY8jHlwbXJqaG5N8zn/u9pCvbpdzE1iPC/uP+0rNBO9MF1pUf+cFZs37O
        gcCOq39U+zxe753Ytp6hqdGqUbc2R3JtXPqrvbP51h4+uifae6Zi966avqYrn17MbXbZtObD
        twsdpnudvf26DPf41WoE5MzpevXO6ELb6viAWVNZGDm9at52X7326reE7d59vXN4P9VvPPD/
        d6vHk0+f6uqfl/xtT3252I5XuZfFWkBj/py3TMfXfp7R/V/oM0Nnx+GEnD+nBBhPnNskveLD
        BksvVUcTLg+zL84Xk2b/WuWhNleDm00rwaaE82nOlY7+7PgyYyWW4oxEQy3mouJEAI99849g
        AwAA
X-CMS-MailID: 20210923054744epcas2p44598a40148d965fda57fe65ff687f51c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210917065523epcas2p15b648b88af85252fe12ff8026307526a
References: <20210917065436.145629-1-chanho61.park@samsung.com>
        <CGME20210917065523epcas2p15b648b88af85252fe12ff8026307526a@epcas2p1.samsung.com>
        <20210917065436.145629-10-chanho61.park@samsung.com>
        <001501d7b031$8bb26790$a31736b0$@samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> >Subject: =5BPATCH v3 09/17=5D scsi: ufs: ufs-exynos: correct timeout val=
ue
> >setting registers
> >
> >PA_PWRMODEUSERDATA0 -> DL_FC0PROTTIMEOUTVAL
> >PA_PWRMODEUSERDATA1 -> DL_TC0REPLAYTIMEOUTVAL
> >PA_PWRMODEUSERDATA2 -> DL_AFC0REQTIMEOUTVAL
> >
> >Cc: Alim Akhtar <alim.akhtar=40samsung.com>
> >Cc: Kiwoong Kim <kwmad.kim=40samsung.com>
> >Cc: Krzysztof Kozlowski <krzysztof.kozlowski=40canonical.com>
> >Signed-off-by: Chanho Park <chanho61.park=40samsung.com>
> >---
> Please add a =5BFixes=5D tag with the original commit which introduce thi=
s

I'll add below =22Fixes=22 tag.

Fixes: a967ddb22d94 (=22scsi: ufs: ufs-exynos: Apply vendor-specific values=
 for three timeouts=22)

>=20
> With the above fix, feel free to add
>=20
> Reviewed-by: Alim Akhtar <alim.akhtar=40samsung.com>

Thanks for your review :)

Best Regards,
Chanho Park

