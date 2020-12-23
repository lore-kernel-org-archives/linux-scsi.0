Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59297C433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Dec 2020 02:16:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35D5F23137
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Dec 2020 02:16:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgLWCQr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Dec 2020 21:16:47 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:43423 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbgLWCQr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Dec 2020 21:16:47 -0500
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20201223021604epoutp03c024295328bafadb7f5c73ac23a5ffc1~TNtFQf9gj0238702387epoutp03D
        for <linux-scsi@vger.kernel.org>; Wed, 23 Dec 2020 02:16:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20201223021604epoutp03c024295328bafadb7f5c73ac23a5ffc1~TNtFQf9gj0238702387epoutp03D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608689764;
        bh=kdSkHxAcqvK3yCTthd1OpdXHfbJp5LVoTiZHuvyD/2M=;
        h=From:To:Cc:Subject:Date:References:From;
        b=ciUPwcluwy4ZcWEkAGv4mf54mCHawQx81BQzII4ugU+w7J1K/YBMEPMrP5QSo+HtA
         fJDMe617H6gqhgYe91P1g/K/RczmArZq1ZVLDVuKt4XqkTt7MxsR806j+ePMTAhldS
         GGk7Ey6Q5inCrBzeKnnopsUTRpHc8UD4pNBYAbGs=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20201223021603epcas2p4dfed2d65a9edddae7126f3846a8e411a~TNtEYRfWB0748307483epcas2p4Y;
        Wed, 23 Dec 2020 02:16:03 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.183]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4D0xdY2jZVzMqYkx; Wed, 23 Dec
        2020 02:16:01 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        E1.35.56312.068A2EF5; Wed, 23 Dec 2020 11:16:00 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20201223021559epcas2p1c44e4b9764f946c608d810c40c08e53e~TNtBAcUO81015210152epcas2p1k;
        Wed, 23 Dec 2020 02:15:59 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201223021559epsmtrp2fe14fa93016883977eb31c5af5eea438~TNtA-eicG0280502805epsmtrp2B;
        Wed, 23 Dec 2020 02:15:59 +0000 (GMT)
X-AuditID: b6c32a46-1efff7000000dbf8-6b-5fe2a86065e1
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        55.56.13470.F58A2EF5; Wed, 23 Dec 2020 11:15:59 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20201223021559epsmtip1e3feb52845aa5b500ca792500df5ead3~TNtArl8Ly1482614826epsmtip1p;
        Wed, 23 Dec 2020 02:15:59 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v4 0/2] permit to set block parameters per vendor
Date:   Wed, 23 Dec 2020 11:05:06 +0900
Message-Id: <cover.1608689016.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjk+LIzCtJLcpLzFFi42LZdljTTDdhxaN4g+/7lC0ezNvGZrG37QS7
        xcufV9ksDj7sZLH4uvQZq8W0Dz+ZLT6tX8Zq8evvenaL1YsfsFgsurGNyeLmlqMsFt3Xd7BZ
        LD/+j8mi6+4NRoul/96yOPB7XL7i7XG5r5fJY8KiA4we39d3sHl8fHqLxaNvyypGj8+b5Dza
        D3QzBXBE5dhkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXm
        AB2vpFCWmFMKFApILC5W0rezKcovLUlVyMgvLrFVSi1IySkwNCzQK07MLS7NS9dLzs+1MjQw
        MDIFqkzIyZjcfIW5YB5rRdPCfWwNjL0sXYycHBICJhLtM54xdTFycQgJ7GCUWH17ChuE84lR
        Yv+cHUwgVUIC3xglFrfLdzFygHW83mEGUbOXUeLZh1csEM4PRokrZ9YwgzSwCWhKPL05FWys
        iMAZJolrrWdZQRLMAuoSuyacAJsqLOAoMeXQTLAGFgFViQNvp4HV8ApYSKzsn8cOcZ+cxM1z
        ncwggyQEGjkkHn59yAiRcJG4Pu8/1BPCEq+Ob4FqkJL4/G4vG4RdL7FvagMrRHMPo8TTff+g
        mo0lZj1rZwT5hxno1PW79CFeU5Y4cosF4k4+iY7Df9khwrwSHW1CEI3KEr8mTYYaIikx8+Yd
        qK0eEn8PQ9hCArESp/ccY57AKDsLYf4CRsZVjGKpBcW56anFRgVGyJG0iRGcILXcdjBOeftB
        7xAjEwfjIUYJDmYlEV4zqfvxQrwpiZVVqUX58UWlOanFhxhNgeE1kVlKNDkfmKLzSuINTY3M
        zAwsTS1MzYwslMR5iw0exAsJpCeWpGanphakFsH0MXFwSjUwbZ3KfqBdkSV2kkXFxA9/JLdM
        Yko9W/Zzv9e2yIefzvQc+cW1KrRMpHrjbJ3Pqc/kvPgWtHI8yF0p+L7YqIpPJXdDWfO79NmH
        olb/vPLk0qLodfVt+bPdtU1K2OcfsY9fU1nX8Fh1ix+PYpzoJ1bv82uCDe3rFx1NdP4qnbZW
        yHVjzA21Lf/NLG+uZBF8q/hq7tErD7e/V+hIsHg6e3NdiI+54CqpjUfjzHonea4UODRBjanO
        eJ/3o1WdM25Ncfp4/Lbn/jCbud7PPRQtrrz9dP2Mi3ulgl/gnq53TMvPeuQnhcSm6bJ15ss9
        VpveHad7RuOTW93pj6ckfaNnHQ5bbrNwTcOEO0FKlw47tnwWV2Ipzkg01GIuKk4EAFSwXKEZ
        BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsWy7bCSnG78ikfxBlPW6Vs8mLeNzWJv2wl2
        i5c/r7JZHHzYyWLxdekzVotpH34yW3xav4zV4tff9ewWqxc/YLFYdGMbk8XNLUdZLLqv72Cz
        WH78H5NF190bjBZL/71lceD3uHzF2+NyXy+Tx4RFBxg9vq/vYPP4+PQWi0ffllWMHp83yXm0
        H+hmCuCI4rJJSc3JLEst0rdL4MqY3HyFuWAea0XTwn1sDYy9LF2MHBwSAiYSr3eYdTFycQgJ
        7GaUePuxGyjOCRSXlDix8zkjhC0scb/lCCtE0TdGifl7N4Ml2AQ0JZ7enMoEkhARuMckcWnC
        XGaQBLOAusSuCSeYQGxhAUeJKYdmgsVZBFQlDrydxgpi8wpYSKzsn8cOsUFO4ua5TuYJjDwL
        GBlWMUqmFhTnpucWGxYY5qWW6xUn5haX5qXrJefnbmIEh6yW5g7G7as+6B1iZOJgPMQowcGs
        JMJrJnU/Xog3JbGyKrUoP76oNCe1+BCjNAeLkjjvha6T8UIC6YklqdmpqQWpRTBZJg5OqQam
        sve3etXZzqpPaX2+X8HWN0V0u6pNb4c6M1OGje3+KmEftyAze16rpD97cqd9c913QM1XbMrp
        ayfP7+1nu7RGtd7O7lThOY3KWz+XP4lc13Prwh/p4z4Nmbr6mfNWX37VxHNR6m79az+nF4/P
        t9jN/lztp+0nNrdrulCj6t3pbxMDcxZ9Nf4zS2L6OftA02MTQpclBDnLSu3t+tV+Rih02+ma
        b79LONVu2HEKnzTaqZr01frN//8Fn7LcBDf0PPi/lKPH59shi99Occn5juJbjQ6c1fk2q6F1
        82LjqftiQjStXOpPtRg23UutrL+XaGrErSCSIBI3d9lzg72T4/kMPQr9r5pfuyDx8rrR479K
        LMUZiYZazEXFiQBatWcByAIAAA==
X-CMS-MailID: 20201223021559epcas2p1c44e4b9764f946c608d810c40c08e53e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201223021559epcas2p1c44e4b9764f946c608d810c40c08e53e
References: <CGME20201223021559epcas2p1c44e4b9764f946c608d810c40c08e53e@epcas2p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

v4 -> v3: fix some typos
v3 -> v2: rename exynos functions
v1 -> v2: rename the vops and fix some typos

There are some cases of dispatching a command with more than
one scatterlist entry and under 4KB size. Device sends just one DATA IN
but some SoCs transfer could tranfer data to a physically continuous
area, which should have done per each scatterlist entry.

Kiwoong Kim (2):
  ufs: add a vops to configure block parameter
  ufs: ufs-exynos: set dma_alignment to 4095

 drivers/scsi/ufs/ufs-exynos.c | 9 +++++++++
 drivers/scsi/ufs/ufshcd.c     | 2 ++
 drivers/scsi/ufs/ufshcd.h     | 8 ++++++++
 3 files changed, 19 insertions(+)

-- 
2.7.4

