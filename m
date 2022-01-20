Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F33BC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Jan 2022 03:10:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358268AbiATDKn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Jan 2022 22:10:43 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:41220 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358266AbiATDKm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jan 2022 22:10:42 -0500
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220120031041epoutp0129f202fed8001e758a477e6cbce1efab~L299GbqxC0229302293epoutp017
        for <linux-scsi@vger.kernel.org>; Thu, 20 Jan 2022 03:10:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220120031041epoutp0129f202fed8001e758a477e6cbce1efab~L299GbqxC0229302293epoutp017
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1642648241;
        bh=YoN6pTjlP1sER3RLX5T+grSkeJssNLGyVrUrBvaEJj8=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=HGctwb1RuiZ5Gw3rjkNeNU48akBM+VrgVEp6s/crPE0xWCQS4V+ZU4U96rauttQl+
         PT+lcOLMkTX4CYAC7dZKyYUzuna6SvR6POWHmsKQz2AEEQVzR0cs+Il//Y7063FzOu
         udxboo+fFVv2YLOkpJOToAFAJW4+lBATX3swro9o=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20220120031040epcas2p4657bc7ea05b71f26125176a67a631a23~L298kbhwp1676816768epcas2p4k;
        Thu, 20 Jan 2022 03:10:40 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.91]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4JfSFB4xLhz4x9Q7; Thu, 20 Jan
        2022 03:10:38 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        E2.43.51767.EA2D8E16; Thu, 20 Jan 2022 12:10:38 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20220120031038epcas2p2388c53ae70af2cad01fa282290d80487~L296PEffq2731227312epcas2p2M;
        Thu, 20 Jan 2022 03:10:38 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220120031038epsmtrp19b7098963fc04c954847db27ed34031c~L296OXrNy0825108251epsmtrp1R;
        Thu, 20 Jan 2022 03:10:38 +0000 (GMT)
X-AuditID: b6c32a45-45dff7000000ca37-1e-61e8d2aeea6d
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        EA.3A.29871.DA2D8E16; Thu, 20 Jan 2022 12:10:37 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20220120031037epsmtip224bb70b0ec2c854789abb455a146faac~L296FVFZe0287902879epsmtip2G;
        Thu, 20 Jan 2022 03:10:37 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Bart Van Assche'" <bvanassche@acm.org>,
        <linux-scsi@vger.kernel.org>, <sc.suh@samsung.com>,
        <hy50.seo@samsung.com>, <sh425.lee@samsung.com>,
        <bhoon95.kim@samsung.com>, <vkumar.1997@samsung.com>
In-Reply-To: <f68bd8fa-e848-df11-1493-aff82911eb2c@acm.org>
Subject: RE: [PATCH v1] scsi: ufs: see link lost as fatal
Date:   Thu, 20 Jan 2022 12:10:37 +0900
Message-ID: <001501d80dab$4c5d6ef0$e5184cd0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQFch6D2S1FxJ37uPaIY3XASydMiwQJpj803AX0x9a6tQw1kUA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplk+LIzCtJLcpLzFFi42LZdljTQnfdpReJBi+Xy1t8XfqM1WLah5/M
        FqsXP2Cx6L6+g82i6+4NRoul/96yWNy5/5HFgd3j8hVvj74tqxg9Pm+SC2COyrbJSE1MSS1S
        SM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqtpFCWmFMKFApILC5W
        0rezKcovLUlVyMgvLrFVSi1IySkwL9ArTswtLs1L18tLLbEyNDAwMgUqTMjOWPlqCXvBFpaK
        48cuMjYw7mHuYuTgkBAwkZj4U7uLkYtDSGAHo8TZlStYIJxPjBL3ew8wQTjfGCXe/X0N5HCC
        dcz9tYYdIrGXUWL3ySusEM4LRomnF3pYQarYBLQlpj3cDZYQETjNKNG78Bo7SIJTwFri3uKT
        LCC2sIClxIt9R8DiLAKqEgc/XmUGsXmB4ocWrGKBsAUlTs58AmYzAw1dtvA1M8QZChI/ny4D
        WyYi4CSxeMNNZogaEYnZnW3MIIslBL6yS0xoncsI0eAicfHaXqgfhCVeHd/CDmFLSbzsb2OH
        aGhmlNi5uxGqewqjxJL9H6CqjCVmPWtnBIUZs4CmxPpd+pDgU5Y4cgvqOD6JjsN/2SHCvBId
        bUIQjcoSvyZNhjpBUmLmzTtQJR4SLxpcJzAqzkLy5SwkX85C8s0shLULGFlWMYqlFhTnpqcW
        GxUYwmM7OT93EyM4XWq57mCc/PaD3iFGJg7GQ4wSHMxKIrxS9c8ShXhTEiurUovy44tKc1KL
        DzGaAsN9IrOUaHI+MGHnlcQbmlgamJiZGZobmRqYK4nzeqVsSBQSSE8sSc1OTS1ILYLpY+Lg
        lGpgWlhnPVtAW2fx890ZTLFPnlWElSiqWWybKZzk87VfrnDNGTY3ReW6kskXmaLNDh21jNhU
        /634m/HPu7/mLcvqe82o/T+uTrZoGb/XilCR8NSsmsVzjjDu2Xl9vl7Ppn33julmRDkdsjay
        lt5j1Vo7J3Ky5BWmgImf7QRP3/xS35FYzfZYu6Zc0ipRPrylt+dFUedR1cOsnLHBt1umXtb8
        78mRb3x5XrvJZ729PSry98tXPPefmPvcY9mnjJiYpnOunjIHSx6FlLons3ELxm7jCg1a5xfO
        /GzxhF3CHj1z3B8lNrzlqlzpaGLw3FyMQ/dPyqX2m9wb/mfk3Pa1NarZPeHQgkMSu2Ol4h12
        PVBiKc5INNRiLipOBABGZZuJIAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsWy7bCSvO7aSy8SDU5dsbb4uvQZq8W0Dz+Z
        LVYvfsBi0X19B5tF190bjBZL/71lsbhz/yOLA7vH5SveHn1bVjF6fN4kF8AcxWWTkpqTWZZa
        pG+XwJWx/NVf5oJtLBX7ezewNTDuYu5i5OSQEDCRmPtrDTuILSSwm1Fi3kRviLikxImdzxkh
        bGGJ+y1HWLsYuYBqnjFKdBzdxgqSYBPQlpj2cDdYQkTgMqPE6f4LUFXHGSVuNV9gAqniFLCW
        uLf4JAuILSxgKfFi3xGwdSwCqhIHP14FO4MXKH5owSoWCFtQ4uTMJ2A2M9CGpzefwtnLFr6G
        OltB4ufTZWBXiAg4SSzecJMZokZEYnZnG/MERqFZSEbNQjJqFpJRs5C0LGBkWcUomVpQnJue
        W2xYYJiXWq5XnJhbXJqXrpecn7uJERwjWpo7GLev+qB3iJGJg/EQowQHs5IIr1T9s0Qh3pTE
        yqrUovz4otKc1OJDjNIcLErivBe6TsYLCaQnlqRmp6YWpBbBZJk4OKUamDyNvzzyWBJ49sqa
        W6mdnWXJd1oV15Z+6/+8wvAww3Nhm5XHXveEbGPzSwiU+fRRcPF19rpZCizX3KU2nln+y9tk
        4Z2neRO/iezPsFetiXjAYMi+Yev0v25PvxWJVX5zcXV1++sZtfztTK43u/r/nvGp69vdOkvm
        /Fm78OQ+R6mT7dnT9j1q4/haJBiu739o1hpFt72VoTY+kVK+T5doTNmcO+ds3syKudn6eybH
        blFl+lm72/aG+jLh17PKY3tL5WrO/GhY9rGxy2OPW9ZjmVNZqzealvkpnFO+qK39sWvTKdeJ
        DT0R8+02Hzn4dumL7Urz7jA+yRdplWO76h/ScG8X7+pE+WOXS1N2WrjfTlJiKc5INNRiLipO
        BABInMBKAAMAAA==
X-CMS-MailID: 20220120031038epcas2p2388c53ae70af2cad01fa282290d80487
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220117103912epcas2p41c5d54a9242e46264c4e388a1db27f6b
References: <CGME20220117103912epcas2p41c5d54a9242e46264c4e388a1db27f6b@epcas2p4.samsung.com>
        <1642415846-141110-1-git-send-email-kwmad.kim@samsung.com>
        <f68bd8fa-e848-df11-1493-aff82911eb2c@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> and also =22UIC Link Lost Status (ULLS): This indicates a condition where
> remote end is trying to reestablish a link and the link is lost. This bit
> corresponds to the UniPro DME_LINKLOST.ind SAP primitive.=22

It seems that you've said the why. That is, Link lost presents communicatio=
n is
not possible and the driver should do recovery from host reset. The way to =
make it
is that make the driver this as fatal. This patch is to make Link Lost join=
 in
INT_FATAL_ERRORS to do that.

Okay, I'll update the comment.

Thanks.
Kiwoong Kim

