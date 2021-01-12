Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BA4BC433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 03:00:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 695C822D3E
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 03:00:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733174AbhALDA2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 22:00:28 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:33175 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbhALDA1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jan 2021 22:00:27 -0500
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210112025945epoutp0360c2eb43b1c40bf459ee06b9bab7af44~ZXM7Zmwwb1426514265epoutp03n
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jan 2021 02:59:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210112025945epoutp0360c2eb43b1c40bf459ee06b9bab7af44~ZXM7Zmwwb1426514265epoutp03n
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1610420385;
        bh=VnbI6c10BjMnEnp4rJHZ+dUtpje3agBt0O41aWVZArI=;
        h=From:To:Cc:Subject:Date:References:From;
        b=jcs4uFAbZvQzlsbJshZSqlO1MTyb0LQ79226mQj7jl470Ug3VJhgc70QQPhBgZ5uw
         MjFVVgiM+a3bGQOgbCSdoZPO2L2qmGFRnjzJQ2YYpJck604fPfh0j0raaqt6hMVeCN
         hh6RX96AQJa36ryzsvdFHEy5wWa7uefFmZzRAdag=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210112025944epcas2p418421cea08b31e8aa410034d4516fa59~ZXM6voel-0760907609epcas2p4R;
        Tue, 12 Jan 2021 02:59:44 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.187]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4DFFfj0grNz4x9Pw; Tue, 12 Jan
        2021 02:59:41 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        85.E2.56312.C901DFF5; Tue, 12 Jan 2021 11:59:40 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20210112025940epcas2p2f27c4f5e84f7f745a64027bdba536227~ZXM3BWITU1401914019epcas2p2K;
        Tue, 12 Jan 2021 02:59:40 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210112025940epsmtrp20695257bf66e9fb3097c68b3a805d80b~ZXM3Ad1ph2420624206epsmtrp26;
        Tue, 12 Jan 2021 02:59:40 +0000 (GMT)
X-AuditID: b6c32a46-1d9ff7000000dbf8-de-5ffd109c8916
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        9B.32.08745.C901DFF5; Tue, 12 Jan 2021 11:59:40 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210112025940epsmtip1e328ba251ebadbe8c05580ec0ee5be2b~ZXM2uvwUP1202812028epsmtip1Q;
        Tue, 12 Jan 2021 02:59:40 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RESEND PATCH v3 0/2] permit vendor specific values of unipro
 timeouts
Date:   Tue, 12 Jan 2021 11:48:25 +0900
Message-Id: <cover.1610419672.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplk+LIzCtJLcpLzFFi42LZdljTVHeOwN94gwVHrS0ezNvGZrG37QS7
        xcufV9ksDj7sZLH4uvQZq8W0Dz+ZLT6tX8Zq8evvenaL1YsfsFgsurGNyeLmlqMsFt3Xd7BZ
        LD/+j8mi6+4NRoul/96yOPB7XL7i7XG5r5fJY8KiA4we39d3sHl8fHqLxaNvyypGj8+b5Dza
        D3QzBXBE5dhkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXm
        AB2vpFCWmFMKFApILC5W0rezKcovLUlVyMgvLrFVSi1IySkwNCzQK07MLS7NS9dLzs+1MjQw
        MDIFqkzIybi0qpW94AJzxZTePqYGxvdMXYycHBICJhJvLm5n7mLk4hAS2MEoseLOfVYI5xOj
        ROf0xVDOZ0aJtYvnwbVs/zSFBcQWEtjFKDH5XwaE/YNR4vENSxCbTUBT4unNqUwgzSICZ5gk
        rrWeZQVJMAuoS+yacAIowcEhLBAoceWFD0iYRUBV4vLpNrD5vAIWEq/7VrBA7JKTuHmuE+w8
        CYFGDon2zXugEi4S77acZoOwhSVeHd/CDmFLSXx+txcqXi+xb2oDK0RzD6PE033/GCESxhKz
        nrUzghzBDHTp+l36IKaEgLLEkVssEGfySXQc/ssOEeaV6GgTgmhUlvg1aTLUEEmJmTfvQG31
        kNhzexI7JBhiJc69nMU4gVF2FsL8BYyMqxjFUguKc9NTi40KjJDjaBMjOD1que1gnPL2g94h
        RiYOxkOMEhzMSiK8Xhv+xAvxpiRWVqUW5ccXleakFh9iNAWG10RmKdHkfGCCziuJNzQ1MjMz
        sDS1MDUzslAS5y02eBAvJJCeWJKanZpakFoE08fEwSnVwFSxVEFzQuqHy7Pn3NnCIzfhSklz
        b+SqZUnzTB7cmZjr3/radtoUEdvm4mP/1hr+zpJMM8uM+pxsH7vwZ9JTNRWW1P+Nthsj0/yz
        BG8ZGbn+uuNaLf3txcPj0v3q4dNVgi7+5EluVmN+fz/J9DfL8ubDyglCU9TucL57q/5TyOJA
        x0m1CzubqztcTLfLGqlO+T5hq8Rbs2PTYrjZxMMVZTz8L3+66qQb/ZJl6xbb5LV17DPtP1x6
        a67peu/OgsX/d5R3h7TsC7EuFl5dnB0vLh0/I2mpl5yY4A3v8NRffOurHOQ2GOe+e/VDy++r
        PfN2WZ40Fq1lpizfTnQKLRZ96Jzrkjbp2q+mQ+8FDN7YKbEUZyQaajEXFScCAGut1KYYBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsWy7bCSnO4cgb/xBt+fSlg8mLeNzWJv2wl2
        i5c/r7JZHHzYyWLxdekzVotpH34yW3xav4zV4tff9ewWqxc/YLFYdGMbk8XNLUdZLLqv72Cz
        WH78H5NF190bjBZL/71lceD3uHzF2+NyXy+Tx4RFBxg9vq/vYPP4+PQWi0ffllWMHp83yXm0
        H+hmCuCI4rJJSc3JLEst0rdL4Mq4tKqVveACc8WU3j6mBsb3TF2MnBwSAiYS2z9NYeli5OIQ
        EtjBKPH26yR2iISkxImdzxkhbGGJ+y1HWCGKvjFKtF4+xgqSYBPQlHh6cyoTSEJE4B6TxKUJ
        c5lBEswC6hK7JpwASnBwCAv4S2yeagASZhFQlbh8ug1sM6+AhcTrvhUsEAvkJG6e62SewMiz
        gJFhFaNkakFxbnpusWGBUV5quV5xYm5xaV66XnJ+7iZGcMhqae1g3LPqg94hRiYOxkOMEhzM
        SiK8Xhv+xAvxpiRWVqUW5ccXleakFh9ilOZgURLnvdB1Ml5IID2xJDU7NbUgtQgmy8TBKdXA
        NJu3evqWoH+dF+eUliyZrBOxjJ1/0dotK39FvNr7zV+3rJlx+WNdgRXfdlyTETWyyH2y1NPJ
        UKb8mLyqXdNrDoVTy9pSgsX/r+6eEv74p5GE9K7LrfwJ0UFMIawiC18tlTG+qLFqqvQOt74z
        zK/XhkRqaB0rWXQ4ozSw5vCG2MbZavdz7xUyPOlf+2HqryVdGT3s/yzfhHBqhDOWzVYWrT7w
        RrL/82neZew3BHiu5KXarTnuY3aHufrxrkqGHeJn/v3wU3oX2ujNOfWeqMv3N3p6j1+EsL3R
        mDDpolxvzo8Zcrzy944eKJ67OGrvCh7Wn+9fdzi+9fnDFxS48P3df8rZU46daV+/z83X/+Ht
        Q0osxRmJhlrMRcWJAJ6LAzPIAgAA
X-CMS-MailID: 20210112025940epcas2p2f27c4f5e84f7f745a64027bdba536227
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210112025940epcas2p2f27c4f5e84f7f745a64027bdba536227
References: <CGME20210112025940epcas2p2f27c4f5e84f7f745a64027bdba536227@epcas2p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

v2 -> v3: remove change ids
v1 -> v2: change some comments and rename the quirk

Kiwoong Kim (2):
  ufs: add a quirk not to use default unipro timeout values
  ufs: ufs-exynos: apply vendor specifics for three timeouts

 drivers/scsi/ufs/ufs-exynos.c |  8 +++++++-
 drivers/scsi/ufs/ufshcd.c     | 40 +++++++++++++++++++++-------------------
 drivers/scsi/ufs/ufshcd.h     |  6 ++++++
 3 files changed, 34 insertions(+), 20 deletions(-)

-- 
2.7.4

