Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DDC8C433EF
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Feb 2022 07:05:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355921AbiBEHFV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Feb 2022 02:05:21 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:11621 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379475AbiBEHFV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Feb 2022 02:05:21 -0500
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220205070519epoutp047d4de2abf9882960e3468d196623985f~Q0fYvZvV81088110881epoutp04K
        for <linux-scsi@vger.kernel.org>; Sat,  5 Feb 2022 07:05:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220205070519epoutp047d4de2abf9882960e3468d196623985f~Q0fYvZvV81088110881epoutp04K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1644044719;
        bh=MDWamiSsdGH55XHKfjlVNz7hdI78i64tdFqOlAaoSt8=;
        h=From:To:Subject:Date:References:From;
        b=t9Xwu3MQl/NUoNFt8W4uWpCZTBmolh9hjHhQHUCC31/C9zdz+DteuVBS24SJdRDFl
         ErMy1IKcd7e8aEZTxZt2m1KM9K/PV10RBesJfsCJ1HrlgPbfy0paRP6sTsRJrsPHa8
         0oq4L0UzFpX2OmVKcmuDIlwg9ZUI6lgk5ulq/y1U=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20220205070518epcas2p35b9d106c97dbb264192b775b2815ffcc~Q0fYBWoBc0316203162epcas2p3N;
        Sat,  5 Feb 2022 07:05:18 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.101]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4JrNhX1CQ8z4x9Pt; Sat,  5 Feb
        2022 07:05:16 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        27.F0.51767.BA12EF16; Sat,  5 Feb 2022 16:05:16 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20220205070515epcas2p324076e473ad0d955f43fdb3cb409c584~Q0fU5fvd30264002640epcas2p3S;
        Sat,  5 Feb 2022 07:05:15 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220205070515epsmtrp1d9ba2ae9874a4a654682dcee17b99e81~Q0fU4pAQC3154131541epsmtrp1B;
        Sat,  5 Feb 2022 07:05:15 +0000 (GMT)
X-AuditID: b6c32a45-447ff7000000ca37-2e-61fe21abdb90
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        AC.A2.08738.AA12EF16; Sat,  5 Feb 2022 16:05:15 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220205070514epsmtip17d69b2a8b50a3d7b535c6b2bfaaa6ad7~Q0fUrqRnP2572025720epsmtip1q;
        Sat,  5 Feb 2022 07:05:14 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <avri.altman@wdc.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <beanhuo@micron.com>,
        <cang@codeaurora.org>, <adrian.hunter@intel.com>,
        <sc.suh@samsung.com>, <hy50.seo@samsung.com>,
        <sh425.lee@samsung.com>, <bhoon95.kim@samsung.com>
Subject: About reading UECxx in ufshcd_dump_regs
Date:   Sat, 5 Feb 2022 16:05:14 +0900
Message-ID: <000001d81a5e$b9907610$2cb16230$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AdgaXLxl4uvkEEgnTTyQR5qcIo9yWQ==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDJsWRmVeSWpSXmKPExsWy7bCmqe4axX+JBg3bmCxOPlnDZvFg3jY2
        i5c/r7JZHHzYyWLxdekzVotP65exWqxe/IDFYtENoLru6zvYLJYf/8dk0XX3BqPF0n9vWRx4
        PC739TJ5LN7zksljwqIDjB7f13eweXx8eovFo2/LKkaPz5vkPNoPdDMFcERl22SkJqakFimk
        5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAnaukUJaYUwoUCkgsLlbS
        t7Mpyi8tSVXIyC8usVVKLUjJKTAv0CtOzC0uzUvXy0stsTI0MDAyBSpMyM74cfonY8FptopV
        DTeZGhins3YxcnJICJhIvHr5jAnEFhLYwSjx9Fp4FyMXkP2JUeLOpvdsEM5nRokZt88wwnR8
        +LySGaJjF6PEvTXBEPYLRokNm9lAbDYBbYlpD3ezgjSLCOxgkrg34QVYg7CAgUR38xKwIhYB
        FYkZl6+D2bwClhIrXnYxQdiCEidnPmEBsZmBBi1b+JoZYrGCxM+ny8DOFhHQk/g05RxUjYjE
        7M42ZpBlEgILOSS67v4AGsQB5LhI3NuVCtErLPHq+BZ2CFtK4mV/GztESbHEpn3yEK0NjBJL
        Pm1mgagxlpj1rJ0RpIZZQFNi/S59iHJliSO3oLbySXQc/gs1hVeio00IolFZ4tekydCQkpSY
        efMO1FIPiWX337NCQipWYv2l8ywTGBVmIfl3FpJ/ZyH5axbCDQsYWVYxiqUWFOempxYbFRjC
        Yzo5P3cTIzgZa7nuYJz89oPeIUYmDsZDjBIczEoivNnTficK8aYkVlalFuXHF5XmpBYfYjQF
        xsBEZinR5HxgPsgriTc0sTQwMTMzNDcyNTBXEuf1StmQKCSQnliSmp2aWpBaBNPHxMEp1cDU
        dNsm6VJ82olTXpfcdk9L76y5dMxIe92cD5asb6ccl+0u+fKjV9RH/cMR7hSXEsEqs/3pIakN
        MQ/F/B/Nr+w9MbF3yfesfcUqO+8yLM6MPb3s4u3W+3yJbyeUib16eVVyKXNES4h3nVpiT/sp
        9lda8cnO/eY/vXLfNmX/FKv909EXFSgldl1w5S+p3BvXbZ3XpXlk7RC96NO5xSg8YJ38EaGW
        jlIFp6nM87ev+xi5evrdj9cjfN5GeNuVPf7jcm/ribNz48VO3eCbtlDyZ1L6u7OaLArvZzsG
        H31WFpO7pH/XebPtGaubOy4+U/5iF9fGXdstFiCd9sVoYqsUxxH5Ldpf5uUUfdyXxxGk66/E
        UpyRaKjFXFScCAAuh/JaTwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42LZdlhJTne14r9Eg59HmC1OPlnDZvFg3jY2
        i5c/r7JZHHzYyWLxdekzVotP65exWqxe/IDFYtGNbUwW3dd3sFksP/6PyaLr7g1Gi6X/3rI4
        8Hhc7utl8li85yWTx4RFBxg9vq/vYPP4+PQWi0ffllWMHp83yXm0H+hmCuCI4rJJSc3JLEst
        0rdL4Mq4/eUyS8E5tooTT5qZGxhnsHYxcnJICJhIfPi8khnEFhLYwSix7aMqRFxS4sTO54wQ
        trDE/ZYjQPVcQDXPGCXOrvvLBpJgE9CWmPZwN1hCROAYk8TRO1/ZQRLCAgYS3c1LwIpYBFQk
        Zly+DmbzClhKrHjZxQRhC0qcnPmEBcRmBhr09OZTOHvZwtfMEJsVJH4+XQZ2qYiAnsSnKeeg
        akQkZne2MU9gFJiFZNQsJKNmIRk1C0nLAkaWVYySqQXFuem5xYYFRnmp5XrFibnFpXnpesn5
        uZsYwXGlpbWDcc+qD3qHGJk4GA8xSnAwK4nwZk/7nSjEm5JYWZValB9fVJqTWnyIUZqDRUmc
        90LXyXghgfTEktTs1NSC1CKYLBMHp1QDk9e+FZNMtkfftn6tJ7W842f+t3wd99VLtmfYPlMs
        llxxg1P65Ordbw+5NTw6XaiWXdloZnHVcmbJO/sXPz7ln+zsFzgvGnBS4Z/gRetfYi+lLZ/z
        Bqvozvf0VbXqCbyxKuqowqwGm6wDPwKWSHPu/Ph9uYUV+y3V5a1+IkzKl+t8OlQn74j5vMHG
        L2NSZt2SjeZM+fFa55+syA2x38uo18VX5y6zi0Wmzp61sl54XeCcjvMfr/IK7dr281J5X/q6
        Qzy/mJSTXi9tYzGa+6fdp09fl0c2xWide/q6lo/yu5Vq+Wr9Y9wfWj16J897ylaeqfbp9Kvf
        NtbHPpcrS1XVnfdcbtrxkJMOTHlWaT+VWIozEg21mIuKEwFvRtDSGgMAAA==
X-CMS-MailID: 20220205070515epcas2p324076e473ad0d955f43fdb3cb409c584
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220205070515epcas2p324076e473ad0d955f43fdb3cb409c584
References: <CGME20220205070515epcas2p324076e473ad0d955f43fdb3cb409c584@epcas2p3.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Dear all

I want to discuss about reading UECxx of UFS SFRs in ufshcd_dump_regs.

There are five SFRs - UECPA, UECDL, UECN, UECT and UECDME which are all ROC=
 type that means they are cleared when reading them.
Originally, these SFRs are to let UFS driver know UIC error type which a UI=
C errors occurs.
Thus, when UFS driver reads them after clearing IS.UE, they are cleared.

I think the read values would be zero in many cases because of the flow I m=
entioned
And there might be some cases when ufshcd_dump_regs reads them before the I=
SR reads them.
e.g. when a command is timed out and ufshcd_dump_regs is called in ufshcd_a=
bort.

So I want to ask this: how about removing reading UECxx in ufshcd_dump_regs=
?
I think reading them is meaningless and might be even a little bit risky.

Thanks.
Kiwoong Kim


