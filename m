Return-Path: <SRS0=pIAL=BG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE416C433EA
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 02:34:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFFB520715
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 02:34:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="YrbfJ+vh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbgG0CeJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Jul 2020 22:34:09 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:53595 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbgG0CeI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 26 Jul 2020 22:34:08 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200727023405epoutp02386b7be709f8be38c95fee435b2953e4~le1RmjBap0509105091epoutp02L
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2020 02:34:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200727023405epoutp02386b7be709f8be38c95fee435b2953e4~le1RmjBap0509105091epoutp02L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1595817245;
        bh=tWOuKy5Cr18AsEZybZANyovRETBpjFxw2jUNOKvwofQ=;
        h=From:To:Cc:Subject:Date:References:From;
        b=YrbfJ+vhJDwbI/vWqb/c0QKThJHeYwxxBhz86NfeyswCUPiOPrDPEhKsi3Ot0THen
         4QKdzuaEGT1OBxUsmrmPNdMRuu3rJCqXgaGUqYJ57+nczTTAyHpojOUgdzxtOFVg0l
         kcF6By40W9nOE2KQKf5jQ99N30F9FpO01vWJgn1k=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20200727023404epcas2p1dd304198b7b418ab229467e2fe0cd784~le1Q7_WjF0997609976epcas2p1U;
        Mon, 27 Jul 2020 02:34:04 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.190]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4BFP572TJxzMqYkj; Mon, 27 Jul
        2020 02:34:03 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        74.E4.18874.A1D3E1F5; Mon, 27 Jul 2020 11:34:02 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20200727023402epcas2p2722148df6f3e24533f09381dc47aa906~le1Of3XXl0695406954epcas2p2X;
        Mon, 27 Jul 2020 02:34:02 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200727023402epsmtrp2d65fc975e00bac390c85a27cde30dad4~le1OeuunE0048300483epsmtrp2y;
        Mon, 27 Jul 2020 02:34:02 +0000 (GMT)
X-AuditID: b6c32a46-503ff700000049ba-9d-5f1e3d1a33e7
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        6D.2B.08303.91D3E1F5; Mon, 27 Jul 2020 11:34:01 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200727023401epsmtip258589bc570814383b66139442472e3c5~le1ON_V8r2856028560epsmtip2k;
        Mon, 27 Jul 2020 02:34:01 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v1] ufs: fix a bug of wrong usage of test_and_set_bit
Date:   Mon, 27 Jul 2020 11:25:49 +0900
Message-Id: <1595816749-108744-1-git-send-email-kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42LZdljTXFfKVi7eoOWyhMWDedvYLPa2nWC3
        ePnzKpvFwYedLBbTPvxktvi0fhmrxa+/69ktVi9+wGKx6MY2JoubW46yWHRf38Fmsfz4PyaL
        rrs3GC2W/nvL4sDncfmKt8flvl4mjwmLDjB6fF/fwebx8ektFo++LasYPT5vkvNoP9DNFMAR
        lWOTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3S3kkJZ
        Yk4pUCggsbhYSd/Opii/tCRVISO/uMRWKbUgJafA0LBArzgxt7g0L10vOT/XytDAwMgUqDIh
        J2PxSeWC/ywV7ef+sTYwTmHpYuTkkBAwkXjx+h8TiC0ksINRYu2B0i5GLiD7E6PEzEM7mSCc
        z4wSM9bOZoXp6LhxjhEisYtR4vumPqiqH4wSH5fNYAOpYhPQlHh6cypYQkRgM5PEqwX3mUES
        zALqErsmnABbKCzgKjFzwUpGEJtFQFXi7I4vYHFeATeJ3u51jBDr5CRunutkBhkkIfCVHWjd
        LKg7XCT6Pl5mh7CFJV4d3wJlS0l8freXDcKul9g3tYEVormHUeLpvn9QU40lZj1rB7I5gC7S
        lFi/Sx/ElBBQljhyiwXiTj6JjsN/2SHCvBIdbUIQjcoSvyZNhhoiKTHz5h2orR4Sp+9tZ4eE
        Y6zEixvHWCYwys5CmL+AkXEVo1hqQXFuemqxUYERciRtYgSnRS23HYxT3n7QO8TIxMF4iFGC
        g1lJhJdbVCZeiDclsbIqtSg/vqg0J7X4EKMpMLwmMkuJJucDE3NeSbyhqZGZmYGlqYWpmZGF
        kjhvveKFOCGB9MSS1OzU1ILUIpg+Jg5OqQamxvhHefoKWsfje567TMk7eXNqyUfdu3IJ706c
        DrXS4qk8K37/YOf82NgpRsGn695HrVw1bX0W4/sy/7ka1qemfGCNeHjmaW/UmYvh/3W+RKy2
        Mbvb8a3aeJ/vEu/T7Pa1M1VP3Vys2xDFoOmtJBeUJHgp8srNe8fTNAv5t1ZY1Nqu2JL/48Sp
        RcXKN+u//5joxzjZa2dwt+CFc6Ib5vh0yF7NNC1c71H45F+VeDzDQuOqeCWTx0pJ9mndnmu2
        KqTkfP5kv21T8+KM69efp/+ZL+RQ//6T8+vZiZNUXnA7zbH+5vXjSv6susjottnZWx8L8Syu
        /ru7yOXMTfUS6T61r9ILrikxeq+Zf/f1DFcOJZbijERDLeai4kQA4eMPXBQEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsWy7bCSvK6krVy8wawrFhYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCxubjnKYtF9fQebxfLj/5gs
        uu7eYLRY+u8tiwOfx+Ur3h6X+3qZPCYsOsDo8X19B5vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBH
        FJdNSmpOZllqkb5dAlfG4pPKBf9ZKtrP/WNtYJzC0sXIySEhYCLRceMcYxcjF4eQwA5GiW8b
        fkIlJCVO7HzOCGELS9xvOcIKUfSNUeLInRZ2kASbgKbE05tTmUASIgKHmST+b30OlmAWUJfY
        NeEEE4gtLOAqMXPBSrBJLAKqEmd3fAGL8wq4SfR2r4PaICdx81wn8wRGngWMDKsYJVMLinPT
        c4sNC4zyUsv1ihNzi0vz0vWS83M3MYIDVUtrB+OeVR/0DjEycTAeYpTgYFYS4eUWlYkX4k1J
        rKxKLcqPLyrNSS0+xCjNwaIkzvt11sI4IYH0xJLU7NTUgtQimCwTB6dUA9MC8dJl8kGy0j93
        39mhcsGsILy9uTWl/dWn/Nd3tc1CBA5dv93JlPJ5W7RpLsvNFN27ZxMWKUQtOuwQL+99iVtB
        8fv1H8uuTBA0+3BluraRV42fQscOH5ZpjJMcOdXXm26S4T2j6/5J5E7u1qeZ3M9XalasrNZn
        /NpUuq/yzKfXVdI6CqyW3Mqat1ZI54ubusadT0v7arfhV7lW9PzphkxcFxIeXZDV2ef2blNI
        RMPpR5YsS2f+2/bi9Z6oN7cO8q//+eBwpfDutJjfpowLljWL3TnOXfrmWKCJ8eLQdesiI8te
        Wn3dNfGwm8HUvwf5T0QETfdene++INHty5bmt9N3asya+fG5r1mrwC+L2j9KLMUZiYZazEXF
        iQDA9ZxbwwIAAA==
X-CMS-MailID: 20200727023402epcas2p2722148df6f3e24533f09381dc47aa906
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200727023402epcas2p2722148df6f3e24533f09381dc47aa906
References: <CGME20200727023402epcas2p2722148df6f3e24533f09381dc47aa906@epcas2p2.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Just a number should have been used, not a shifted value.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exynos.h
index a91656c..032bb50 100644
--- a/drivers/scsi/ufs/ufs-exynos.h
+++ b/drivers/scsi/ufs/ufs-exynos.h
@@ -216,7 +216,7 @@ struct exynos_ufs {
 
 	struct ufs_exynos_handle handle;
 	unsigned long dbg_flag;
-#define EXYNOS_UFS_DBG_DUMP_CXT			BIT(0)
+#define EXYNOS_UFS_DBG_DUMP_CXT			0
 };
 
 #define for_each_ufs_rx_lane(ufs, i) \
-- 
2.7.4

