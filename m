Return-Path: <SRS0=HyWO=6K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 735C9C55199
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Apr 2020 15:57:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5358E208FE
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Apr 2020 15:57:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="JeKrG4pE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726176AbgDZP5v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Apr 2020 11:57:51 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:11259 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbgDZP5v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 26 Apr 2020 11:57:51 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200426155749epoutp026feb598daa25653bf07afb968c41489d~Jacwwyp1y1579315793epoutp02B
        for <linux-scsi@vger.kernel.org>; Sun, 26 Apr 2020 15:57:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200426155749epoutp026feb598daa25653bf07afb968c41489d~Jacwwyp1y1579315793epoutp02B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1587916669;
        bh=trTFp5Ur6qfiEfREXZJnth3cZOnKt8jOp2bjI2S9iaI=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=JeKrG4pE378YAMsTdAwCRiIWiRwDEvFTuBsXS4NkgI+TTcTsOPtmnniB12C9XltMw
         1KmeYTjAHB6WAOb3S/ATocDXCX2Cre9XB9BAtYSrcZEC8/cumDFhWYtie6b7AnmpZR
         G5dIwtBDV7LrQOhjGJAgFzcwdTEcGgjnwJT0d9Xo=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200426155748epcas5p2eee73d1dccf8933d1acaea7659b9b67b~Jacv1f9Fl3173031730epcas5p2B;
        Sun, 26 Apr 2020 15:57:48 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        BE.4B.04736.C7FA5AE5; Mon, 27 Apr 2020 00:57:48 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20200426155747epcas5p18a5839ee37d56c6aa1dfa319c8df8a31~JacvX3nwp2537425374epcas5p1X;
        Sun, 26 Apr 2020 15:57:47 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200426155747epsmtrp27897ebe2db6314da5c7bdf10014b86c0~JacvXLxL-1929019290epsmtrp2c;
        Sun, 26 Apr 2020 15:57:47 +0000 (GMT)
X-AuditID: b6c32a4b-ae3ff70000001280-c6-5ea5af7c4764
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        17.EB.25866.B7FA5AE5; Mon, 27 Apr 2020 00:57:47 +0900 (KST)
Received: from alimakhtar02 (unknown [107.108.234.165]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200426155744epsmtip2783424f39ac89a66da02d6034f69d994~JacsOstWm0566905669epsmtip2s;
        Sun, 26 Apr 2020 15:57:44 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Christoph Hellwig'" <hch@infradead.org>
Cc:     <robh@kernel.org>, <devicetree@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <krzk@kernel.org>,
        <avri.altman@wdc.com>, <martin.petersen@oracle.com>,
        <kwmad.kim@samsung.com>, <stanley.chu@mediatek.com>,
        <cang@codeaurora.org>, <linux-samsung-soc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <20200422065541.GL20318@infradead.org>
Subject: RE: [PATCH v6 05/10] scsi: ufs: add quirk to fix abnormal ocs fatal
 error
Date:   Sun, 26 Apr 2020 21:27:42 +0530
Message-ID: <000201d61be3$6e262c90$4a7285b0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJQDPill8kAmUENoj8JBCZ49rLenQIFk/WPAcfxkaoBJkvH+qdwDfUw
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0gUURjFufPaUXZjWgU/lTI3JBWsxKJrRA8oGzKoP7QixNxqUPPJjm+k
        BLO0VVOh0EWs1FURxFrX2jZLM1cRS4M0s6LXtqGm9tCWRNAax8j/znfv+X2Hc7ksqX5De7Hx
        yWmCLlmbqGFcqbtPAgKCcluN0VtbCtbiifkRBv9sbaDxjZ5BGg+U1RJ4aOi2Ao+ZbRQ22V/S
        +IW1msGVQ48IrB+1MLixb5HASx0WBTa2j6G9Kv5FaQnBtzUF8qbmIoZvq7/AX+zvpPgfjtcU
        X2puRvysaT1/uUtPHHU56brrrJAYnyHotuyOcY2bnL7KpLawWaY77Yo8dFFxBbmwwG0DS8EU
        cQW5smruAYLFTgcjDz8R1PyupeVhFoHVbvqLsMtIVcVp+dyKoOCDYQWfQtBjttHSXoYLAkvd
        JUbS7n/1s1vjSDKR3FsCrjm/kdImFy4EnIXxkseNi4BRp4OSNMX5wdi4nZS0iguF9tJ+QtZr
        ob/q87KH5Hzg3nQ1KXfYAPOOBlrOCoP7S8+R7PEA23wxKeUC94GFkfE6Sgb2Q+PCAiFrN5js
        M688hhfMzjxk5JYJUGwNkY9zwVjTu4Luga7hakqykFwAtFq3yFFroGThMyGTKii8pJbdfpA/
        M7JCekO5Xk/LmocbNoOiDPkaVhUzrCpmWFXA8D/sJqKakaeQKibFCuL21JBkIXOzqE0S05Nj
        N59JSTKh5S8XGG5BpsHD3YhjkUapKhTqo9W0NkPMTupGwJIad1VUWm20WnVWm50j6FJO6dIT
        BbEbebOUxkNVQY9EqblYbZqQIAipgu7fLcG6eOUh35idFZ1xYecYqjzy1cyOT8P+6MeEs+kT
        uW5XkVr3kLa1DOSeHz7imZ91gjzSbUzJCbbMt06LynLzsWrfyJfTSp+IfSUOuz+xxO5NNH0M
        vf5U+/0LLle+O1gRPoffPT60aT8mf3m/9+l9XXagIPh45lyHfVBvrBS/xYc58deNGkqM0wYH
        kjpR+wfa13U/bgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsWy7bCSvG71+qVxBnPv6Fq8/HmVzeLT+mWs
        FvOPnGO1OD1hEZPF+fMb2C1ubjnKYrHp8TVWi8u75rBZzDi/j8mi+/oONovlx/8xWfzfs4Pd
        YunWm4wOvB6X+3qZPDav0PLYtKqTzWPzknqPlpP7WTw+Pr3F4tG3ZRWjx+dNch7tB7qZAjij
        uGxSUnMyy1KL9O0SuDJeve1nK1jLUbFp41b2BsYW9i5GDg4JAROJmZOSuhi5OIQEdjBKXHu6
        n6mLkRMoLi1xfeMEdghbWGLlv+fsEEWvGCVOPl7LApJgE9CV2LG4jQ3EFgGyzy58wQhSxCzw
        gkli4pu/TBAdzxglFuxbxASyjlPAWOJbRyaIKSwQJDHtdDhIL4uAqsTNF4+ZQWxeAUuJrX0n
        mSBsQYmTM5+wgJQzC+hJtG1kBAkzC8hLbH87hxniNgWJn0+XsUKc4Cax8/8FqBpxiaM/e5gn
        MArPQjJpFsKkWUgmzULSsYCRZRWjZGpBcW56brFhgVFearlecWJucWleul5yfu4mRnCkamnt
        YNyz6oPeIUYmDsZDjBIczEoivDEli+KEeFMSK6tSi/Lji0pzUosPMUpzsCiJ836dtTBOSCA9
        sSQ1OzW1ILUIJsvEwSnVwNRqstjgxMa2tZ+KlJzOrezklr1/5ePtHz/np6hJZ5gnPbm2J3X1
        N4N6AZOrVlYnMg7ezU41F/J70pn8sjT5XuwRzXthIXlZ/nWfe6OK6xUDt0QuuHjk0fY5Rvu9
        Wr0+mqufPDehVmTjbxGZzBUnlYNdC80d3X7cOr48eZbTf0OWg4t2H+6YVubXsyejV7fBavcT
        na6ObtZdP3JWV7uVtMT9mqefyPFM/MZ/+973fI84u1+dvvvdT/bGt6JJR79xW77iWrCWT+Zh
        fFxawE29ngi5/bWeDJ5H/4YFro1+V2UXVTfv2d5U9/URTo48Z4tPVi42/985ZZLcnilXls2t
        +p+ZYSO7sPY1497IjMK4G0osxRmJhlrMRcWJABNp82pDAwAA
X-CMS-MailID: 20200426155747epcas5p18a5839ee37d56c6aa1dfa319c8df8a31
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200417181016epcas5p2ee7ac86d743ceee9076690dc5b1e2f08
References: <20200417175944.47189-1-alim.akhtar@samsung.com>
        <CGME20200417181016epcas5p2ee7ac86d743ceee9076690dc5b1e2f08@epcas5p2.samsung.com>
        <20200417175944.47189-6-alim.akhtar@samsung.com>
        <20200422065541.GL20318@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig <hch@infradead.org>
> Sent: 22 April 2020 12:26
> To: Alim Akhtar <alim.akhtar@samsung.com>
> Cc: robh@kernel.org; devicetree@vger.kernel.org;
linux-scsi@vger.kernel.org;
> krzk@kernel.org; avri.altman@wdc.com; martin.petersen@oracle.com;
> kwmad.kim@samsung.com; stanley.chu@mediatek.com;
> cang@codeaurora.org; linux-samsung-soc@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v6 05/10] scsi: ufs: add quirk to fix abnormal ocs
fatal error
> 
> On Fri, Apr 17, 2020 at 11:29:39PM +0530, Alim Akhtar wrote:
> > From: Kiwoong Kim <kwmad.kim@samsung.com>
> >
> > Some architectures determines if fatal error for OCS occurrs to check
> > status in response upiu. This patch is to prevent from reporting
> > command results with that.
> 
> What does "Some architectures" mean?  All this seems to be about error
> propagation to the SCSI midlyaer, so this sounds rather strange.
Ok will update the commit message with more details.

