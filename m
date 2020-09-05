Return-Path: <SRS0=n0Yx=CO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EDB6C433E2
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Sep 2020 06:15:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 112B920FC3
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Sep 2020 06:15:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="XPn+jegO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbgIEGP5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Sep 2020 02:15:57 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:25819 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbgIEGPz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Sep 2020 02:15:55 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200905061553epoutp04256b456ec280408fc9c8e6464f9e72e7~xzqWTDNU11460114601epoutp04D
        for <linux-scsi@vger.kernel.org>; Sat,  5 Sep 2020 06:15:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200905061553epoutp04256b456ec280408fc9c8e6464f9e72e7~xzqWTDNU11460114601epoutp04D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1599286553;
        bh=fne0bi3r8rCywLma3Pdbp9pLmEKJiLfmPjOoWhNiuck=;
        h=From:To:Cc:Subject:Date:References:From;
        b=XPn+jegOKHQB+xgHH+VL3pU1zCwCQ702SoUe7jdrbM38f9iB8SrcbgwN2tb+EXfvr
         ShJUwNbkhYHyZolFvgkgvvLUpW+FzTTNPnDIy0apsVNLcvHNWPidZW3rdx8lF0ftNy
         1bmkVdZzM+R8oxJ/yWvr3WVtibWYXPLixf2xb9/Q=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20200905061552epcas2p15d9c5cb9709e275b2e848f29489c1837~xzqVTuIw82988129881epcas2p1M;
        Sat,  5 Sep 2020 06:15:52 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.184]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4Bk46Y72ChzMqYkY; Sat,  5 Sep
        2020 06:15:49 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        78.68.18874.51D235F5; Sat,  5 Sep 2020 15:15:49 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20200905061548epcas2p1dc708a23247702c6b1f6c0eedc513a92~xzqSIMq-72988129881epcas2p1K;
        Sat,  5 Sep 2020 06:15:48 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200905061548epsmtrp1402e403702961c6fc47bdc7688414a03~xzqSHXWSB1722117221epsmtrp1R;
        Sat,  5 Sep 2020 06:15:48 +0000 (GMT)
X-AuditID: b6c32a46-519ff700000049ba-00-5f532d150588
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        37.12.08382.41D235F5; Sat,  5 Sep 2020 15:15:48 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200905061548epsmtip184390fcbb616bc086dab78c7a02c8b1a~xzqR55YWs0319903199epsmtip1a;
        Sat,  5 Sep 2020 06:15:48 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v4 0/2] ufs: introduce skipping manual flush for wb
Date:   Sat,  5 Sep 2020 15:06:50 +0900
Message-Id: <cover.1599285983.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42LZdljTVFdUNzje4ESLpcWDedvYLPa2nWC3
        ePnzKpvFwYedLBbTPvxktvi0fhmrxa+/69ktVi9+wGKx6MY2JoubW46yWHRf38Fmsfz4PyaL
        rrs3GC2W/nvL4sDncfmKt8flvl4mjwmLDjB6fF/fwebx8ektFo++LasYPT5vkvNoP9DNFMAR
        lWOTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3S3kkJZ
        Yk4pUCggsbhYSd/Opii/tCRVISO/uMRWKbUgJafA0LBArzgxt7g0L10vOT/XytDAwMgUqDIh
        J6Pp9g6mgjPsFe/fPmFqYJzH1sXIySEhYCLx4PIBpi5GLg4hgR2MEq2nj7JDOJ8YJV7fvAFW
        JSTwjVGicUt4FyMHWEfbVG6Imr2MEjNfrGeFcH4wSuz49oAZpIFNQFPi6c2pYGNFBDYzSbxa
        cB8swSygLrFrwgkmEFtYwFliwvO7YDaLgKrEhjnH2EFsXgELiRUrZjFB3CcncfNcJzPIIAmB
        n+wSW76tYoFIuEhcnPmXEcIWlnh1fAs7hC0l8bK/Dcqul9g3tYEVormHUeLpvn9QDcYSs561
        M4L8wwx06vpd+hCvKUscucUCcSefRMfhv+wQYV6JjjYhiEZliV+TJkMNkZSYefMO1CYPidUb
        PzJCAitWouPaIcYJjLKzEOYvYGRcxSiWWlCcm55abFRghBxJmxjBaVHLbQfjlLcf9A4xMnEw
        HmKU4GBWEuH1OBcYL8SbklhZlVqUH19UmpNafIjRFBheE5mlRJPzgYk5ryTe0NTIzMzA0tTC
        1MzIQkmct17xQpyQQHpiSWp2ampBahFMHxMHp1QDk2fB2onbA8SLrJ+u87kY9E21QLvqBw+7
        8uzfHL4J19jYwqwd7ixP0HNxXj1rc2Zp9sSphVzPd8iteCOQ/MznvM0sw3V+U0JPRP9tPrbt
        99HWzNLmT/ceJW16uXAdL5PP1J7gTUebMxoy3k2Wub7ulu6vefbvlXYvE91x+IDogQ9vrr7+
        L9qoZ2P/XDnY3WwK156gpecqpIO23bqWEF6lrj5jKae13gWWe7fjZ+Z/7WfdYnU18JzkI16L
        A0+uOZ63XZETFWK3kSlnTW+84KeSpf+5TwY4tTyM5XJLDa7cGTnlj5bW/RcFf51OLDgwd+/v
        4M1R9VU+nmcUP6c+Ul5bxbSttbd8vquzGMdzs+bnDUosxRmJhlrMRcWJAIFM2ysUBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsWy7bCSnK6IbnC8wcHVGhYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCxubjnKYtF9fQebxfLj/5gs
        uu7eYLRY+u8tiwOfx+Ur3h6X+3qZPCYsOsDo8X19B5vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBH
        FJdNSmpOZllqkb5dAldG0+0dTAVn2Cvev33C1MA4j62LkYNDQsBEom0qdxcjF4eQwG5Gie6e
        N+xdjJxAcUmJEzufM0LYwhL3W46wgthCAt8YJV59A7PZBDQlnt6cygTSLCJwmEni/9bnYM3M
        AuoSuyacYAKxhQWcJSY8vwtmswioSmyYcwyshlfAQmLFillMEAvkJG6e62SewMizgJFhFaNk
        akFxbnpusWGBYV5quV5xYm5xaV66XnJ+7iZGcJhqae5g3L7qg94hRiYOxkOMEhzMSiK8HucC
        44V4UxIrq1KL8uOLSnNSiw8xSnOwKInz3ihcGCckkJ5YkpqdmlqQWgSTZeLglGpgkin9rsat
        H62dumjm34Iu6Y5VDKUqG135RTZsZetZ6mqw7fsE20lTGSv6H51zL5gkLPkhdaK6Jve/x2EH
        1RcEWE9c0dTVsdRVtdO9dN/y9AOf6wJWFM39sjE2t0bxr3RK0xrvrYbPL/LN33pEjVWz+sik
        P+HPJedYdzrU7L93sKVDfsK+myYGi1r+3fYVeBF0Xs08VuyCaP9hg6qWJntR0yWGgpMSjzWa
        efp7Osow7OaaubX6TKjD2ZCk4E/lWX8tLOPuflo573TL6daTSW/059lZ6sVabPlwJlTM2ezM
        2p9tJv8b6hq19p98FX1pwo0I1fUVnK+26e5SL8qJiIhir945TbbuUnSn0RePg0+VWIozEg21
        mIuKEwGxB9eiwgIAAA==
X-CMS-MailID: 20200905061548epcas2p1dc708a23247702c6b1f6c0eedc513a92
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200905061548epcas2p1dc708a23247702c6b1f6c0eedc513a92
References: <CGME20200905061548epcas2p1dc708a23247702c6b1f6c0eedc513a92@epcas2p1.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

v3 -> v4: migrate these to 5.10
v2 -> v3: modify some commit messages
v1 -> v2: enable the quirk in exynos

We have two knobs to flush for write booster, i.e.
fWriteBoosterBufferFlushDuringHibernate and fWriteBoosterBufferFlushEn.
However, many product makers uses only fWriteBoosterBufferFlushDuringHibernate,
because this can reportedly cover most scenarios and
there have been some reports that flush by fWriteBoosterBufferFlushEn
could lead to raise power consumption thanks to unexpected internal
operations. So we need a way to enable or disable fWriteBoosterEn
operations. For those case, this quirk will allow to avoid manual flush

Kiwoong Kim (2):
  ufs: introduce skipping manual flush for wb
  ufs: exynos: enable UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL

 drivers/scsi/ufs/ufs-exynos.c | 3 ++-
 drivers/scsi/ufs/ufshcd.c     | 3 +++
 drivers/scsi/ufs/ufshcd.h     | 5 +++++
 3 files changed, 10 insertions(+), 1 deletion(-)

-- 
2.7.4

