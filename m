Return-Path: <SRS0=BOoC=CD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C15AC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Aug 2020 01:52:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D3F020706
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Aug 2020 01:52:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="vLPido1a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbgHYBwN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Aug 2020 21:52:13 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:19363 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725924AbgHYBwJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Aug 2020 21:52:09 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200825015207epoutp0476b3424e9bc0e63f1bdbe6619838079a~uX96KHmOp1105711057epoutp04L
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2020 01:52:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200825015207epoutp0476b3424e9bc0e63f1bdbe6619838079a~uX96KHmOp1105711057epoutp04L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1598320327;
        bh=15nlBl2iQg54h8gzMkAz9/Oo4D/EzEUlukD9+4pn6pw=;
        h=From:To:Cc:Subject:Date:References:From;
        b=vLPido1aO+D9/Bcr3Il9AT8/2RMce1ff88YMPMqp26RKIoxu5cM/ikZUjElIrA8K4
         gfGgdzGIDIJ5afIXKSuwIaIFS/bZnnVTs/A+Iym4NCZ8aEQgMxiNbcD0819vCecVob
         WEbf8vfy2626VzZLChasvR45wxdayCB/upXReRrg=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20200825015206epcas2p1a3fade69a8253f8c0a8092aa366f378d~uX95Vz-m83018330183epcas2p1b;
        Tue, 25 Aug 2020 01:52:06 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.185]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4BbBnH2bCkzMqYkY; Tue, 25 Aug
        2020 01:52:03 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        B9.05.18874.1CE644F5; Tue, 25 Aug 2020 10:52:01 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20200825015200epcas2p2aef1427e960c86e7da08dc4608f20e26~uX9z6zqlz0267902679epcas2p2t;
        Tue, 25 Aug 2020 01:52:00 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200825015200epsmtrp1196352bb368335724571fb41f59d9606~uX9z58qnm2903729037epsmtrp1T;
        Tue, 25 Aug 2020 01:52:00 +0000 (GMT)
X-AuditID: b6c32a46-519ff700000049ba-e3-5f446ec1d8b6
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        8F.A8.08303.0CE644F5; Tue, 25 Aug 2020 10:52:00 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200825015200epsmtip2607f47de967daa2a7a081289b4e8c437~uX9zo9Ofk2648826488epsmtip2e;
        Tue, 25 Aug 2020 01:52:00 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v3 0/2] ufs: introduce skipping manual flush for wb
Date:   Tue, 25 Aug 2020 10:43:14 +0900
Message-Id: <cover.1598319701.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42LZdljTTPdgnku8wfUV7BYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCxubjnKYtF9fQebxfLj/5gs
        uu7eYLRY+u8tiwOfx+Ur3h6X+3qZPCYsOsDo8X19B5vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBH
        VI5NRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtDdSgpl
        iTmlQKGAxOJiJX07m6L80pJUhYz84hJbpdSClJwCQ8MCveLE3OLSvHS95PxcK0MDAyNToMqE
        nIz3G/kLVrNXPD3ymLmBsZWti5GTQ0LARGLpuTtANheHkMAORomGCQ/ZIZxPjBLP1/5lgnA+
        M0pcft3NBNOybME5qMQuRom151ZBOT8YJR5+fcoOUsUmoCnx9OZUsISIwGYmiVcL7jODJJgF
        1CV2TTgBNkpYwFni2uYpYDaLgKrEi4stYFfxClhITPo/mwVinZzEzXOdzCCDJAR+sktc2P8A
        6nQXiSsfnjBC2MISr45vYYewpSRe9rdB2fUS+6Y2sEI09zBKPN33D6rBWGLWs3YgmwPoIk2J
        9bv0QUwJAWWJI7dYIO7kk+g4/JcdIswr0dEmBNGoLPFr0mSoIZISM2/egdrkIXFkZRsTSLmQ
        QKzEghlmExhlZyGMX8DIuIpRLLWgODc9tdiowAg5kjYxgtOiltsOxilvP+gdYmTiYDzEKMHB
        rCTCK3jROV6INyWxsiq1KD++qDQntfgQoykwuCYyS4km5wMTc15JvKGpkZmZgaWphamZkYWS
        OG+94oU4IYH0xJLU7NTUgtQimD4mDk6pBqaGwz0iz1k8XG49X3Rt89HbfrMaYuZoHQtbLZzx
        PI7RSzi94BGz23zT7uqHva4Ourts+aqjHqtJLOjJDZn4WVVQen1UOePq6VdFOgomsCzQVnvY
        Vn+7mdPAKLRq1mWjEDMG35VBtWy3jKbdXtzQcTpQ495x4RfXdF5oB0VPsGKf+scgXSfEYVFg
        5R9ft+0cU37PaL3+LdJzYvvGE113e5U2NibO8XBdorh60zXl2xrxWXcd1r35v7xvZcn1Kcyt
        TktXGK+YbnnwMZ+ZSfntt1nPtxxlnrvf0KU8TOZ2h/F3uYXfjZJmvV9gsEbmivbjAx+O/t16
        ZnPoj1k6E39fE529P8XhueiCU9LJ6bY6QdJKLMUZiYZazEXFiQBC3jolFAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsWy7bCSvO6BPJd4g+4rIhYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCxubjnKYtF9fQebxfLj/5gs
        uu7eYLRY+u8tiwOfx+Ur3h6X+3qZPCYsOsDo8X19B5vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBH
        FJdNSmpOZllqkb5dAlfG+438BavZK54eeczcwNjK1sXIySEhYCKxbME5pi5GLg4hgR2MEl/2
        /WSFSEhKnNj5nBHCFpa433KEFaLoG6PEtt37WEASbAKaEk9vTgXrFhE4zCTxf+tzdpAEs4C6
        xK4JJ5hAbGEBZ4lrm6eA2SwCqhIvLraAreYVsJCY9H82C8QGOYmb5zqZJzDyLGBkWMUomVpQ
        nJueW2xYYJSXWq5XnJhbXJqXrpecn7uJERyoWlo7GPes+qB3iJGJg/EQowQHs5IIr+BF53gh
        3pTEyqrUovz4otKc1OJDjNIcLErivF9nLYwTEkhPLEnNTk0tSC2CyTJxcEo1MNkULd+6bUv+
        W6+Dwn9iKlYFTs+6s6fINv85973MbiVViU97l/NZPeuT/LRzAcc7OeuHCUurWB1WLQg82vd9
        seYXq96Ms9vOPAhVtj0sOYOjK11vEZ8q+8/VYedYrqztvzK5asqZR59MEl4nLa74c3qJmLm+
        xktJ94xd3+JOhRxaJZryftfPCWvvfv8S4GFpIz1xpbndquUvG3+e4e7/5h0v+H+yw9m9Pn1P
        33VccV43/fGf/DMXtG+Xb779e3eVRK18mPu3wK/sqgtZn69ueHNVUD1xDVfdpMP6P9rrLRZW
        2y9K4TqXY+8wN0d1UuKVc/+eCeX598UfXHjo9O6Lelt+vuk4xmh6+IF6qOWrjy/3K7EUZyQa
        ajEXFScCAJU1SQ/DAgAA
X-CMS-MailID: 20200825015200epcas2p2aef1427e960c86e7da08dc4608f20e26
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200825015200epcas2p2aef1427e960c86e7da08dc4608f20e26
References: <CGME20200825015200epcas2p2aef1427e960c86e7da08dc4608f20e26@epcas2p2.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

v1 -> v2: enable the quirk in exynos
v2 -> v3: modify some commit messages

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

