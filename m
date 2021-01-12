Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02795C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 02:58:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C071D22D2A
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 02:58:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733044AbhALC55 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 21:57:57 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:43109 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730100AbhALC54 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jan 2021 21:57:56 -0500
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210112025713epoutp0420ad102e3777a6d069567e57edc421e3~ZXKuS96FH3140431404epoutp04Z
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jan 2021 02:57:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210112025713epoutp0420ad102e3777a6d069567e57edc421e3~ZXKuS96FH3140431404epoutp04Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1610420233;
        bh=z98SLPPYv7RuGTkiwaVmLF/zFhNb3G5abTl02iD0BOM=;
        h=From:To:Cc:Subject:Date:References:From;
        b=UYLI+rVyl6+Ma9RDUn9zlqqds09Jh7Jv2NaJl70L9d70fb1jjlCIUr9MDcJDIGTFf
         BVppgAzwTyYyhM6sPGH90u0khORkFXNEay+6oRG9sSURjYHs9cdbZe1Khka1znhlZk
         QOYLwIc6H2ylM8P7ZKaYyySqNDn2PoH0FofyY8Cw=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210112025712epcas2p42d21697d630f108303f6507ae65fcf64~ZXKtmcqG00196301963epcas2p4-;
        Tue, 12 Jan 2021 02:57:12 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.185]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4DFFbq06fgz4x9Px; Tue, 12 Jan
        2021 02:57:11 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        1A.BA.52511.6001DFF5; Tue, 12 Jan 2021 11:57:10 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20210112025710epcas2p1c43b5cd5812881996190ae396116b26a~ZXKrTZw9c0804908049epcas2p1x;
        Tue, 12 Jan 2021 02:57:10 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210112025710epsmtrp2efb5a2f6d2c4d9074c3be5d1d3a30124~ZXKrSYeeL2322723227epsmtrp26;
        Tue, 12 Jan 2021 02:57:10 +0000 (GMT)
X-AuditID: b6c32a48-50fff7000000cd1f-86-5ffd10069812
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        F2.12.08745.6001DFF5; Tue, 12 Jan 2021 11:57:10 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210112025710epsmtip11d76f70108d09502f4c000e1960e1303~ZXKq96UN-1202812028epsmtip1t;
        Tue, 12 Jan 2021 02:57:10 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v5 0/2] permit to set block parameters per vendor
Date:   Tue, 12 Jan 2021 11:45:54 +0900
Message-Id: <cover.1610419491.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnk+LIzCtJLcpLzFFi42LZdljTQpdN4G+8Qf9pC4sH87axWextO8Fu
        8fLnVTaLgw87WSy+Ln3GajHtw09mi0/rl7Fa/Pq7nt1i9eIHLBaLbmxjsri55SiLRff1HWwW
        y4//Y7LounuD0WLpv7csDvwel694e1zu62XymLDoAKPH9/UdbB4fn95i8ejbsorR4/MmOY/2
        A91MARxROTYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5
        QMcrKZQl5pQChQISi4uV9O1sivJLS1IVMvKLS2yVUgtScgoMDQv0ihNzi0vz0vWS83OtDA0M
        jEyBKhNyMm7cvMRWsI25YuLKt8wNjBeYuhg5OSQETCQmX53DAmILCexglGh459XFyAVkf2KU
        2LRqPTuE85lR4tSvF2wwHSuPfGSFSOxilJg9+QcbhPODUWLlx81gc9kENCWe3pzKBJIQETjD
        JHGt9SwrSIJZQF1i14QTYEXCAo4SM/7fZAaxWQRUJQ58/wB2CK+AhcSPVdPZIdbJSdw818kM
        MkhCoJFDouvOTag7XCT2dx9nhbCFJV4d3wLVICXx+d1eqJp6iX1TG1ghmnsYJZ7u+8cIkTCW
        mPWsHcjmALpIU2L9Ln0QU0JAWeLILRaIO/kkOg7/ZYcI80p0tAlBNCpL/Jo0GWqIpMTMm3eg
        tnpI7J/bAw3HWIldfyawTWCUnYUwfwEj4ypGsdSC4tz01GKjAhPkWNrECE6RWh47GGe//aB3
        iJGJg/EQowQHs5IIr9eGP/FCvCmJlVWpRfnxRaU5qcWHGE2B4TWRWUo0OR+YpPNK4g1NjczM
        DCxNLUzNjCyUxHmLDB7ECwmkJ5akZqemFqQWwfQxcXBKNTBlPJYKO9d4hW/aTeXV53evuvsg
        /YFTapJvlJqS7e1XoVePH90lNpGd969Uex27Vk1MukT/1COp0ktMi3IKiuZ4C3W9EEq+ZXZF
        30HgfOlKSctfvp3sIWs8Pzz6zMWcqlctw3qyoNv85dUZmfYbeOaVHD7GbWbw+HN81tsaeWbr
        mzsOnH6sfujzcw3Lg7y7KvmfNnT/2Snz625IeeyTUt99e5UPRkofnav1J9OLWTvg/hrbIv/5
        5xnv/H0d47DD3yRvwrSEWr7Zk3jPXNkptN5ksuJWznJ9hzOB6kmT9MOfuH1227u76NaZF7/W
        x4iKZNsUO8vd3/ffQ0cr9Xc/x6RW0blxadHPZhyvErgy0VqJpTgj0VCLuag4EQDNzt8hGgQA
        AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsWy7bCSnC6bwN94g7M7RSwezNvGZrG37QS7
        xcufV9ksDj7sZLH4uvQZq8W0Dz+ZLT6tX8Zq8evvenaL1YsfsFgsurGNyeLmlqMsFt3Xd7BZ
        LD/+j8mi6+4NRoul/96yOPB7XL7i7XG5r5fJY8KiA4we39d3sHl8fHqLxaNvyypGj8+b5Dza
        D3QzBXBEcdmkpOZklqUW6dslcGXcuHmJrWAbc8XElW+ZGxgvMHUxcnJICJhIrDzykbWLkYtD
        SGAHo8T0g4+hEpISJ3Y+Z4SwhSXutxyBKvrGKLH90W92kASbgKbE05tTmUASIgL3mCQuTZjL
        DJJgFlCX2DXhBNgkYQFHiRn/b4LFWQRUJQ58/8ACYvMKWEj8WDWdHWKDnMTNc53MExh5FjAy
        rGKUTC0ozk3PLTYsMMpLLdcrTswtLs1L10vOz93ECA5aLa0djHtWfdA7xMjEwXiIUYKDWUmE
        12vDn3gh3pTEyqrUovz4otKc1OJDjNIcLErivBe6TsYLCaQnlqRmp6YWpBbBZJk4OKUamNbm
        xbdf0NWdurph18LlYbcFhZ6nzFm7/cmj7Vebz9runXzq5P7wbLnJv49/SQ/3qTy+dO7/vu+B
        367Ge7CExrV9+77iCeNbNUuxi0vibxheeLf0wgWp7a/XOf65Jn3/RZC89f3bM/yFKme+rbD8
        p30nfdUN3hVbBbPcL6hOOVy9YX+1g8uN+dL7Bfd9TLnTM/Wjeu+6YH5pv7ZP93+kS1UyTTs9
        U3aPlI73UqFj/mYfur1uPt/OPrerNreLyaxfyF/8zPkVyi80Vk0/y/VO5FNZ0vXtnY/CjqxP
        F/ZfU95n1M2Vd8IiNzVi/wsLoa+HL191VLSbsOrOH/avKc8i2TQuZThzp05c07z78fLW66s9
        lFiKMxINtZiLihMB4ZE77skCAAA=
X-CMS-MailID: 20210112025710epcas2p1c43b5cd5812881996190ae396116b26a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210112025710epcas2p1c43b5cd5812881996190ae396116b26a
References: <CGME20210112025710epcas2p1c43b5cd5812881996190ae396116b26a@epcas2p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

v4 -> v5: collect received tags
v3 -> v4: fix some typos
v2 -> v3: rename exynos functions
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

