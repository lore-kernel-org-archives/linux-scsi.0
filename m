Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9661EC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 11:06:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65EF560FF2
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 11:06:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbhJULIQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Oct 2021 07:08:16 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:58255 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbhJULIP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Oct 2021 07:08:15 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20211021110558epoutp04fa346261639c01721d69c335434fe39b~wBv9JxoKi0238702387epoutp04i
        for <linux-scsi@vger.kernel.org>; Thu, 21 Oct 2021 11:05:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20211021110558epoutp04fa346261639c01721d69c335434fe39b~wBv9JxoKi0238702387epoutp04i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1634814358;
        bh=E81I91Ly+sN/ik9HuuzBvPWDk+tYRb4B5ab2DliGbXE=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=rzKoUcCSqI+jYZJn6Z4wwQxbdGe/JfwLmRhJ4hrVrMLgwbnQQIT41hRFzzIPHQZXX
         ZHSQLl3UkWR98f8SBO8uyrlBgZ6/Zk+S7/autmKgl3RjL8B+BRQs7k+O5BcLF8oCIW
         juAfPcAGoEH3Kybno5FiTmHNeSYXXRRPzvGCJ1wk=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20211021110558epcas2p3400a85f63255fb0fb50afd47f70e096e~wBv86i1e60617306173epcas2p34;
        Thu, 21 Oct 2021 11:05:58 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.36.91]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4HZl5Y6CDmz4x9Px; Thu, 21 Oct
        2021 11:05:53 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        77.B5.12141.A8941716; Thu, 21 Oct 2021 20:05:46 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20211021110545epcas2p4ced30b773a1e4656b9aff50f1deef46d~wBvw4RePl2997629976epcas2p4K;
        Thu, 21 Oct 2021 11:05:45 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20211021110545epsmtrp1ae238363a662c944fc3d213c0c9b06b6~wBvw8MydK1989319893epsmtrp1v;
        Thu, 21 Oct 2021 11:05:45 +0000 (GMT)
X-AuditID: b6c32a48-d73ff70000002f6d-29-6171498aed81
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        02.FA.08738.88941716; Thu, 21 Oct 2021 20:05:44 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20211021110544epsmtip224910037d630bf77bfe0ac314bff32a5~wBvwoMuQs0341403414epsmtip2K;
        Thu, 21 Oct 2021 11:05:44 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Can Guo'" <cang@codeaurora.org>
Cc:     <linux-scsi@vger.kernel.org>
In-Reply-To: <ce88a8c47d46acd43b3645a3b97ab956@codeaurora.org>
Subject: RE: [PATCH RESEND v2] scsi: ufs: clear doorbell for hibern8 errors
 when using ah8
Date:   Thu, 21 Oct 2021 20:05:44 +0900
Message-ID: <029f01d7c66b$9838f970$c8aaec50$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQIPpLk+GfI6SjvCnzedxKlglX7R9QIy3PWBAupkR36rRKNzgA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAKsWRmVeSWpSXmKPExsWy7bCmuW6XZ2GiwfNb7Baf1i9jtei+voPN
        gcnjcl8vk8fnTXIBTFHZNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2
        Si4+AbpumTlA45UUyhJzSoFCAYnFxUr6djZF+aUlqQoZ+cUltkqpBSk5BeYFesWJucWleel6
        eaklVoYGBkamQIUJ2RmfL19kLfjCWLHt1AfGBsZjjF2MHBwSAiYSvw4WdjFycQgJ7GCUWPjq
        PyOE84lRYtn+VlYI5zOjxImZv4EynGAdz3ovQVXtYpQ48riBGcJ5wSgxqfMrG0gVm4C2xLSH
        u1lBbBEBVYl3refB4swCChJvv+1lAtnNKWAnsfZvBEhYWCBGYsmPVmYQmwWo/OLBi+wgNq+A
        pcTiR9uYIGxBiZMzn7BAjDGQeH9uPjOELS+x/e0cZojjFCR+Pl0GtdZJomXyGVaIGhGJ2Z1t
        YHdKCFxjlziwdidUg4vErN+voD4Tlnh1fAs7hC0l8bK/Dcqul9g3tYEVormHUeLpvn9QDcYS
        s561QwNSWeLILajj+CQ6Dv9lhwjzSnS0CUFUK0v8mjQZqlNSYubNO+wTGJVmIXltFpLXZiF5
        bRaSFxYwsqxiFEstKM5NTy02KjCBx3Zyfu4mRnDS0/LYwTj77Qe9Q4xMHIyHGCU4mJVEeHdX
        5CcK8aYkVlalFuXHF5XmpBYfYjQFhvZEZinR5Hxg2s0riTc0sTQwMTMzNDcyNTBXEue1FM1O
        FBJITyxJzU5NLUgtgulj4uCUamDa9Vtf6GRHWGyT76ndbnOu+cgemirDukzraqVr3LRD/WF1
        ZzYcmfq9NNGKsXL9occJj/iCrjJ/vnsyv+5U1qPFDruvPVHlNVB72uw5Y23TG8M7FvXNG/1X
        HLrLuMc56s7FNUtvN63X4Fn7dtbPPzYXnZP+cjT6aPXUrjiZunFD0JEJNmr1XmysodwHHC4e
        rXjwSnq//eU5ClY+gkdDmzb/kPkv3PX46ZSEzFPBcQwbOqY5CO7wefQ2Td2rgLPIeSvL2te7
        Nj4TtTg45cXi+ccbOBTdP23bVSbhrHTq+83/H+z1QxarlevNN27g8GzVSan5Eq4ikMMct8zu
        /o3VTtmNvVejqudaezEmcYVJSacpsRRnJBpqMRcVJwIAIfmDkAMEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsWy7bCSvG6HZ2Giwe9jFhaf1i9jtei+voPN
        gcnjcl8vk8fnTXIBTFFcNimpOZllqUX6dglcGZ8vX2Qt+MJYse3UB8YGxmOMXYycHBICJhLP
        ei+B2UICOxglrkxJgYhLSpzY+RyqRljifssR1i5GLqCaZ4wS65Z9ZAdJsAloS0x7uJsVxBYR
        UJV413qeDcRmFlCQePttLxNEwylGia9fO1i6GDk4OAXsJNb+jQCpERaIklhxpBVsAQtQ78WD
        F8Fm8gpYSix+tI0JwhaUODnzCQvETCOJc4f2Q82Xl9j+dg4zxHEKEj+fLoO6wUmiZfIZVoga
        EYnZnW3MExiFZyEZNQvJqFlIRs1C0rKAkWUVo2RqQXFuem6xYYFRXmq5XnFibnFpXrpecn7u
        JkZw8Gtp7WDcs+qD3iFGJg7GQ4wSHMxKIry7K/IThXhTEiurUovy44tKc1KLDzFKc7AoifNe
        6DoZLySQnliSmp2aWpBaBJNl4uCUamBSX+qs0Htd4MKWKk5nZdmpvP+TtkxOtPK/VJrV1Cv/
        Zs+9BVVhFUzsW0RbJO2z2Y9dDDixulnv1JfJnGJl6/0n1e//8Hfd5puNit82c12Y3P6pZc40
        G0ZHk5Vnctrt177WWffEdeEazhfemz15HnyUWV90/Xa39g7v6NIcMabADzOul74+f/HtT/Y5
        PzyjlkXeYfGzLfo65VDauXf5h2VLH/Y+afDbLO/XdCo3UNYxeaHltGWL7k1Jjq7sj/j04Zm8
        Vbja7IOWEopzjO70lpi0vv68Y2ru1i0K+mkBDnNMC29kfv6/ru7Jtp9zX0/gMzacF5e8ZUHW
        rqCoe6lT34lWFT6aoOTaEH/3wbx3wWc6lViKMxINtZiLihMBpfUxJO0CAAA=
X-CMS-MailID: 20211021110545epcas2p4ced30b773a1e4656b9aff50f1deef46d
X-Msg-Generator: CA
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211019051346epcas2p132d3b9c6a1c812f3132e913525235b83
References: <CGME20211019051346epcas2p132d3b9c6a1c812f3132e913525235b83@epcas2p1.samsung.com>
        <1634619427-171880-1-git-send-email-kwmad.kim@samsung.com>
        <ce88a8c47d46acd43b3645a3b97ab956@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Same ask as Adrian did, ufshcd_hba_stop() should clear all doorbell bits
> as it disables UFS host controller, then ufshcd_complete_requests()
> completes any pending requests, no?

I replied Adrian's feedback.

Thanks.
Kiwoong Kim

