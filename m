Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3C72C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 02:33:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 645A822AED
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 02:33:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725807AbgLVCda (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Dec 2020 21:33:30 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:48530 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgLVCda (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2020 21:33:30 -0500
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20201222023247epoutp014ccdd3c4be4d3da6b13d620ea55e0c5e~S6SZf4fW13074330743epoutp01u
        for <linux-scsi@vger.kernel.org>; Tue, 22 Dec 2020 02:32:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20201222023247epoutp014ccdd3c4be4d3da6b13d620ea55e0c5e~S6SZf4fW13074330743epoutp01u
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608604367;
        bh=0crSAkTrBXOJwptFoCySzatSZKupiEoOvtFFDU5Ufcc=;
        h=From:To:Cc:Subject:Date:References:From;
        b=rQnuEEC5Ma58NtPdRh+nqOX5+j1lEy/ufBBIwblRcAmQcUIyYL9jv3pshb6VZokt1
         bhD9BLlrEgy8t4hExGnbVUyvd1mqpkV8MytPbKr2ltXeLbYlSsWMVsV2207936n3sm
         Y4zXIgqz6CORjcgY2ErP53rMRfATNgdu9P5RShY8=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20201222023244epcas2p396dd2ce16eb59280b40426978a5c1e7c~S6SWSsVqy0314603146epcas2p3o;
        Tue, 22 Dec 2020 02:32:44 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.185]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4D0L3G2dvBzMqYkf; Tue, 22 Dec
        2020 02:32:42 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        B3.47.10621.8CA51EF5; Tue, 22 Dec 2020 11:32:40 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20201222023237epcas2p4dff5928195198835ec96df9c911a01e5~S6SPrlesF1536615366epcas2p4L;
        Tue, 22 Dec 2020 02:32:37 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201222023237epsmtrp15e095816e9f7e1652078845ec757cef1~S6SPqtlPm2479524795epsmtrp16;
        Tue, 22 Dec 2020 02:32:37 +0000 (GMT)
X-AuditID: b6c32a45-8dc16a800001297d-45-5fe15ac83e81
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        B0.55.08745.5CA51EF5; Tue, 22 Dec 2020 11:32:37 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20201222023237epsmtip1dcab0ac41c1b9557a9d25699bd29e8f3~S6SPWP6tC1496414964epsmtip1S;
        Tue, 22 Dec 2020 02:32:37 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v3 0/2] permit to set block parameters per vendor
Date:   Tue, 22 Dec 2020 11:21:45 +0900
Message-Id: <cover.1608603608.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjk+LIzCtJLcpLzFFi42LZdljTQvdE1MN4g7YuHYsH87axWextO8Fu
        8fLnVTaLgw87WSy+Ln3GajHtw09mi0/rl7Fa/Pq7nt1i9eIHLBaLbmxjsri55SiLRff1HWwW
        y4//Y7LounuD0WLpv7csDvwel694e1zu62XymLDoAKPH9/UdbB4fn95i8ejbsorR4/MmOY/2
        A91MARxROTYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5
        QMcrKZQl5pQChQISi4uV9O1sivJLS1IVMvKLS2yVUgtScgoMDQv0ihNzi0vz0vWS83OtDA0M
        jEyBKhNyMq5tOsJc8JupYs/Kh+wNjIuZuhg5OCQETCTu3ojtYuTiEBLYwShxd8V8JgjnE6PE
        0klrGCGcz4wSDYt3sncxcoJ1nHo2CapqF1DLtS5WCOcHo8SR3TtZQKrYBDQlnt6cClYlInCG
        SeJa61lWkASzgLrErgknmEBsYQFHic6ZzWBjWQRUJXZ+W8oGYvMKWEis2PqEEWKdnMTNc53M
        EPZfdol7j70gbBeJ+2/PM0HYwhKvjm+BOk9K4mV/G5RdL7FvagPYdRICPYwST/f9gxpqLDHr
        WTsjKASYgS5dv0sfEhjKEkdusUCcySfRcfgvO0SYV6KjTQiiUVni16TJUEMkJWbevAO1yUPi
        5tUOsGuEBGIlGuZ+ZZ7AKDsLYf4CRsZVjGKpBcW56anFRgWGyJG0iRGcILVcdzBOfvtB7xAj
        EwfjIUYJDmYlEV4zqfvxQrwpiZVVqUX58UWlOanFhxhNgcE1kVlKNDkfmKLzSuINTY3MzAws
        TS1MzYwslMR5iw0exAsJpCeWpGanphakFsH0MXFwSjUwWWT5yP/96BrB5RD7/5+Ynk72GTuu
        2W/OcU84uDvt/9J8LxnFyzOc32X/YL/4Y+/eooXrnfq3FP50KWFuf7nUOk25vH92as/WObwz
        3eZoCG3coiER7hnfyr04VcGXJSvs3Lpj60w9z3x4kOmgwqhYVR8V3m/et/DrZfWPx02+mpnz
        LM47ELtS/tuegBMu660rr8xu+1KxN0vVZ7/kCj8VacPVvc8rfmdzND+7HSvJ6XK7+tXR5R0m
        Gdf5DL6v0MhI22keHdF776KW6LXzxhLFV9mdVXderWnrTwzs9ttlK6x/8Ii/gNf0JiWhF+vm
        StipldTaze56vcChJHrRp/8ObYcT/r21VlY0ZzvE+UiJpTgj0VCLuag4EQBYF8+9GQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsWy7bCSnO7RqIfxBv+m8Vk8mLeNzWJv2wl2
        i5c/r7JZHHzYyWLxdekzVotpH34yW3xav4zV4tff9ewWqxc/YLFYdGMbk8XNLUdZLLqv72Cz
        WH78H5NF190bjBZL/71lceD3uHzF2+NyXy+Tx4RFBxg9vq/vYPP4+PQWi0ffllWMHp83yXm0
        H+hmCuCI4rJJSc3JLEst0rdL4Mq4tukIc8Fvpoo9Kx+yNzAuZupi5OSQEDCROPVsEpDNxSEk
        sINR4vbvLlaIhKTEiZ3PGSFsYYn7LUdYIYq+MUpMaXrDApJgE9CUeHpzKli3iMA9JolLE+Yy
        gySYBdQldk04AbZCWMBRonNmMzuIzSKgKrHz21I2EJtXwEJixdYnUBvkJG6e62SewMizgJFh
        FaNkakFxbnpusWGBUV5quV5xYm5xaV66XnJ+7iZGcNBqae1g3LPqg94hRiYOxkOMEhzMSiK8
        ZlL344V4UxIrq1KL8uOLSnNSiw8xSnOwKInzXug6GS8kkJ5YkpqdmlqQWgSTZeLglGpgqpu0
        Kfqsc/E59SvmucecZmyUDtE2bDzmdrI7mu15vNG5qbWVO56rvvCVWrD/QMIK3Qj1KwuW35/D
        vHZbQ6Sv52/5osQnqb7THWSNZoh+nWi+VqKrxcLHXFT8u7NOdQfDVqa9zkoHxG5Odpzr/STc
        pmH/1luqWV9XRW21Z1H5y7GJ5cKZZwpe78t6bwjtfye/xfvUmYfRk0//jv/4e6/gRGv2ZEu9
        LQqpumW1s9sjywPfav679sQ0f8Km6TcrchwKJCO+eV3W9A8QvJ11Lba2SF2Oqe6b3G4Wmwkv
        HOuWfRaY9X+f4L6sdyZBQvpcAetYFWf3RUZsXRZqJqzt8/7OX5HjU0WanBi0vvGqsYorsRRn
        JBpqMRcVJwIAs4XAV8kCAAA=
X-CMS-MailID: 20201222023237epcas2p4dff5928195198835ec96df9c911a01e5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201222023237epcas2p4dff5928195198835ec96df9c911a01e5
References: <CGME20201222023237epcas2p4dff5928195198835ec96df9c911a01e5@epcas2p4.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

v3 -> v2: rename exynos functions
v1 -> v2: rename the vops and fix some typos

Kiwoong Kim (2):
  ufs: add a vops to configure block parameter
  ufs: ufs-exynos: set dma_alignment to 4095

 drivers/scsi/ufs/ufs-exynos.c | 9 +++++++++
 drivers/scsi/ufs/ufshcd.c     | 2 ++
 drivers/scsi/ufs/ufshcd.h     | 8 ++++++++
 3 files changed, 19 insertions(+)

-- 
2.7.4

