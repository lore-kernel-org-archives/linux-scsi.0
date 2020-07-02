Return-Path: <SRS0=HQac=AN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F517C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 02:55:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 605A820781
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 02:55:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="NIo6AK+2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgGBCzz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jul 2020 22:55:55 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:35731 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgGBCzy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jul 2020 22:55:54 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200702025552epoutp04835d3cd9e949003427bbe2a54305375d~d0AKRg_wB2334823348epoutp04G
        for <linux-scsi@vger.kernel.org>; Thu,  2 Jul 2020 02:55:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200702025552epoutp04835d3cd9e949003427bbe2a54305375d~d0AKRg_wB2334823348epoutp04G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593658552;
        bh=Zb/28MJ1z33AyKGcFBfHI7ooC02K01RnC2Q7LJTf+70=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=NIo6AK+2ccIqiYeWGGWcDx91e6rFbGJTQ490GxVm+RlQrAbwalZmlF3MxV8K4+iqW
         6TznB5zdlYbhtpOsWg7W9aOsDZE/mv6SUb3tW7f2E6ePYBOyf/cmSPXXOv8VfXg72b
         D0+dHG7PYz9Xq5XV8yRaRG9OCKIoFuyCmdm3YM1c=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20200702025552epcas2p47aceb04bb33b1fe81ed918d4b7c9f3ab~d0AKDKQ5W0707307073epcas2p4H
        for <linux-scsi@vger.kernel.org>; Thu,  2 Jul 2020 02:55:52 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.188]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 49y2lp2LrGzMqYkq for
        <linux-scsi@vger.kernel.org>; Thu,  2 Jul 2020 02:55:50 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        6F.10.27441.4BC4DFE5; Thu,  2 Jul 2020 11:55:48 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20200702025548epcas2p44b6af5973852dfc88d65a89c134d5316~d0AGZQgaG0701807018epcas2p4R
        for <linux-scsi@vger.kernel.org>; Thu,  2 Jul 2020 02:55:48 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200702025548epsmtrp1fe7f8fcaf7c8186498dcdeb750993bfd~d0AGYtdN93031230312epsmtrp1y
        for <linux-scsi@vger.kernel.org>; Thu,  2 Jul 2020 02:55:48 +0000 (GMT)
X-AuditID: b6c32a47-fafff70000006b31-a7-5efd4cb4de0b
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        7E.63.08303.4BC4DFE5; Thu,  2 Jul 2020 11:55:48 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20200702025548epsmtip1591aced85d56abfcf901903a2a9726dc~d0AGRY5VJ0938909389epsmtip1H
        for <linux-scsi@vger.kernel.org>; Thu,  2 Jul 2020 02:55:48 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     <linux-scsi@vger.kernel.org>
In-Reply-To: <1593658191.3278.7.camel@mtkswgap22>
Subject: RE: [RFC PATCH v2 0/2] ufs: introduce callbacks to get command
 information
Date:   Thu, 2 Jul 2020 11:55:47 +0900
Message-ID: <00ad01d6501c$49e85e80$ddb91b80$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJo11DRWpaCmZyk9SvMikSWyKbQggGAxrCoA1PM90Snp+U5EA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGKsWRmVeSWpSXmKPExsWy7bCmqe4Wn79xBo1LtSy6r+9gc2D0+LxJ
        LoAxKscmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2io
        kkJZYk4pUCggsbhYSd/Opii/tCRVISO/uMRWKbUgJafA0LBArzgxt7g0L10vOT/XytDAwMgU
        qDIhJ+NjxwP2gm+sFYsOr2VsYDzE0sXIySEhYCJx7OYa1i5GLg4hgR2MEpsPLWGBcCYzAWW2
        MEM4U5gkZl1uZIVpeTP9OlTLLkaJLbteMoIkhAQ6mSQ6PyqC2GwC2hLTHu4GaxARUJD423aI
        GcTmFDCUeP7rJhuILSwQKrFk1lWwXhYBFYkXMy+B3cQrYClxav9JKFtQ4uTMJ2A2s4C8xPa3
        c5ghjlCQ+Pl0GdR8J4n1a+ayQtSISMzubAO7WkJgF7vE9j9rGCEaXCRmrlnGBmELS7w6voUd
        wpaSeNnfBmXXS+yb2sAK0dzDKPF03z+oZmOJWc/agWwOoA2aEut36YOYEgLKEkduQd3GJ9Fx
        +C87RJhXoqNNCKJRWeLXpMlQQyQlZt68A7XJQ2Lrh6fMExgVZyH5chaSL2ch+WYWwt4FjCyr
        GMVSC4pz01OLjQqMkSN7EyM4wWm572Cc8faD3iFGJg7GQ4wSHMxKIrynDX7FCfGmJFZWpRbl
        xxeV5qQWH2I0BYb7RGYp0eR8YIrNK4k3NDUyMzOwNLUwNTOyUBLnLba6ECckkJ5YkpqdmlqQ
        WgTTx8TBKdXA1MfxtvirwnkGJam3F9U/nlJsi58ty1z64MMfdsMZe+8q3dpbdjnqhu2dNO8D
        V/dufhZS9JKTQ9TznLfJuuR77IJVBcbp/YUlkZMuZOwS8fS+onI9nEd6v5Hlvh3T+Qpsw5I2
        ZijoOyq0H/9v9/2T7hkL0141kYAO41ztC/3vnG2Y7eaFrpQ3DFWeH+v17qLQ3W9z3NOXuq2Y
        KHnNofdxdtHPLzPszu/QuXY6PCg6ZdeeuDv7JNhs3nQrf6rY9PJxRG35evVDrULGFT+m8N6Z
        5LLrv1WW8OY8s0YWD6YbHMvK1LLfOB60FDW+svTwu7fvpzmbLX3vlTZr3YJywdY4i8C2qgeR
        ngaKLMf4UuqUWIozEg21mIuKEwFAt/Ew+QMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsWy7bCSnO4Wn79xBgseiVt0X9/B5sDo8XmT
        XABjFJdNSmpOZllqkb5dAlfGx44H7AXfWCsWHV7L2MB4iKWLkZNDQsBE4s3066xdjFwcQgI7
        GCX+rV/CBJGQlDix8zkjhC0scb/lCFRRO5PEj1MXWEESbALaEtMe7gazRQQUJP62HWKGKFrP
        KHH82wqwBKeAocTzXzfZuhg5OIQFgiV6ZiWDhFkEVCRezLwEdgWvgKXEqf0noWxBiZMzn4DZ
        zEDzex+2MkLY8hLb385hhjhIQeLn02VQe50k1q+ZywpRIyIxu7ONeQKj0Cwko2YhGTULyahZ
        SFoWMLKsYpRMLSjOTc8tNiwwykst1ytOzC0uzUvXS87P3cQIDmktrR2Me1Z90DvEyMTBeIhR
        goNZSYT3tMGvOCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8X2ctjBMSSE8sSc1OTS1ILYLJMnFw
        SjUwaWQ4H1q4ausEO88D/G2CSnsU/dcnGWctW7A3h9fmv9oBH6Etuw+s/7lWL2RvhyfXwUkf
        lNYHvvu9YNJK3qXpnW43Ni5kUkrmN7oefU1VOm/em6XFruWprGs/fPTxdRXZ/K8jJLI5Ys4Z
        lrO2m6snHOmZXj9726NL62/f/5AYf3pB5JXDQjeV+fe69HX+dXO3SzxypMWBzZTHda5F7mHz
        Gzf8t/hv1D5YfVlL0sLDYb7DtuTZyp0JBYL867dxrS+7t9Mp/vsilcpjR0ILL9/4x96Yo69W
        t+CT5o0jB1LlUr/vvXfpcVHMjr9pVyJnCCtvnpYUp3ksKJKXJzDmWIuY75UNS/de5SptuhFk
        Gqbgr8RSnJFoqMVcVJwIANrQVHTYAgAA
X-CMS-MailID: 20200702025548epcas2p44b6af5973852dfc88d65a89c134d5316
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200702024556epcas2p41b15bb9fb91884435a2cb8711273d29f
References: <CGME20200702024556epcas2p41b15bb9fb91884435a2cb8711273d29f@epcas2p4.samsung.com>
        <cover.1593657314.git.kwmad.kim@samsung.com>
        <1593658191.3278.7.camel@mtkswgap22>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Hi Kiwoong,
> 
> On Thu, 2020-07-02 at 11:38 +0900, Kiwoong Kim wrote:
> > Some SoC specific might need command history for various reasons, such
> > as stacking command contexts in system memory to check for debugging
> > in the future or scaling some DVFS knobs to boost IO throughput.
> >
> > What you would do with the information could be variant per SoC
> > vendor.
> >
> > Kiwoong Kim (2):
> >   ufs: introduce a callback to get info of command completion
> >   exynos-ufs: implement dbg_register_dump and compl_xfer_req
> 
> Thanks for the update!
> 
> Would you please elaborate the change log in cover letter for easier
> review in the future?
> 
> Thanks,
> Stanley Chu
> 

I'll keep in mind.

Thanks.
Kiwoong Kim


