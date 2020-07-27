Return-Path: <SRS0=pIAL=BG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1344AC433E4
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 12:17:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3C1F206E7
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 12:17:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="KZAv1/Hv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728282AbgG0MRM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jul 2020 08:17:12 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:12112 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726555AbgG0MRJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jul 2020 08:17:09 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200727121706epoutp019ddbc7db7e763612871298d92fe2fd5f~lmyUbY9HZ1385313853epoutp01e
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2020 12:17:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200727121706epoutp019ddbc7db7e763612871298d92fe2fd5f~lmyUbY9HZ1385313853epoutp01e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1595852226;
        bh=NcDAWn5vlX20tOOFq44rTlKVPc14UwSVPaRdJqF9rXc=;
        h=From:To:Cc:Subject:Date:References:From;
        b=KZAv1/HvFQYaLZGLQ1YCiSSr1SKC83FOSEchKByN60s4Bq9rbv8kKViKo5Ktv7yec
         lYsKfZFAivS9Kw54iZcczxkC1sYrQggylhjfGCG4NsoSGByXMiJQIrFtDXF7kLKQ3N
         oKhfXzp+7L2X1L6rg1twjwGGCH9Z/PZRw8YRVdAw=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20200727121705epcas2p48b558016fc0df0715d909e4a77f9262a~lmyTwh8su2057320573epcas2p4E;
        Mon, 27 Jul 2020 12:17:05 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.189]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4BFf1p5PH0zMqYkV; Mon, 27 Jul
        2020 12:17:02 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        49.D5.27441.EB5CE1F5; Mon, 27 Jul 2020 21:17:02 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20200727121701epcas2p345545e515b2f3ef8b951d0134a92d7b8~lmyP2E89E0841408414epcas2p3Q;
        Mon, 27 Jul 2020 12:17:01 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200727121701epsmtrp1390cf0722e14388497c1b11e666e2887~lmyP1WENB1270612706epsmtrp1f;
        Mon, 27 Jul 2020 12:17:01 +0000 (GMT)
X-AuditID: b6c32a47-fc5ff70000006b31-0d-5f1ec5be1a20
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        69.2B.08382.DB5CE1F5; Mon, 27 Jul 2020 21:17:01 +0900 (KST)
Received: from rack03.dsn.sec.samsung.com (unknown [12.36.155.109]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200727121701epsmtip209e5f06ec9ce13f2df55133978f78807~lmyPpIBlX1877718777epsmtip2k;
        Mon, 27 Jul 2020 12:17:01 +0000 (GMT)
From:   SEO HOYOUNG <hy50.seo@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, junwoo80.lee@samsung.com
Cc:     SEO HOYOUNG <hy50.seo@samsung.com>
Subject: [RFC PATCH v4 0/2] Support vendor specific operations for WB
Date:   Mon, 27 Jul 2020 21:17:22 +0900
Message-Id: <cover.1595850338.git.hy50.seo@samsung.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGJsWRmVeSWpSXmKPExsWy7bCmqe6+o3LxBjeXaVs8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWvz6u57dYvXiBywWi25sY7LY9beZyaL7+g42i+XH/zE5
        8HhcvuLtcbmvl8ljwqIDjB7f13eweXx8eovFo2/LKkaPz5vkPNoPdDMFcETl2GSkJqakFimk
        5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAXaukUJaYUwoUCkgsLlbS
        t7Mpyi8tSVXIyC8usVVKLUjJKTA0LNArTswtLs1L10vOz7UyNDAwMgWqTMjJ+Hu8g7XgCE/F
        m62bWBoYf3B2MXJySAiYSCzd2sLexcjFISSwg1Hi7pfFbBDOJ0aJTRfmMUI43xglVvyeAFTG
        AdayfrYeRHwvo8TntRuh2n8wSmz4Mp0NZC6bgIbEmmOHmEASIgJdTBIPd35jAkkwC6hJfL67
        jAXEFhZwleia0QjWwCKgKrG/tQUszitgLnFl4x8miAPlJRY1/GaCiAtKnJz5hAVijrxE89bZ
        zBA1nRwSG7o9IGwXiSlnDrJB2MISr45vYYewpSRe9rdB2fUSU+6tYgE5TkKgh1Fiz4oTUMuM
        JWY9a2cEeZNZQFNi/S59iI+VJY7cglrLJ9Fx+C80IHglOtqEIBqVJM7MvQ0VlpA4ODsHIuwh
        8f3zN7AjhQRiJX6+/842gVF+FpJfZiH5ZRbC2gWMzKsYxVILinPTU4uNCoyR43QTIzjBarnv
        YJzx9oPeIUYmDsZDjBIczEoivNyiMvFCvCmJlVWpRfnxRaU5qcWHGE2BoTuRWUo0OR+Y4vNK
        4g1NjczMDCxNLUzNjCyUxHmLrS7ECQmkJ5akZqemFqQWwfQxcXBKNTC1c8xju7jmbYPMe0Pj
        vm3pUS/7JZyzJV5HJlwN4G53elLZe0jVbmH00/Xal21OVJ7k9pBd2C5g6hnEGtXe+WZjJHfg
        Mf0l+WyrCxY6zTwm5y5RGDb9lXfjlGnax846iD7ZHbpy7co2tVU5Dy/7L5+zNzF6tfb+rfUr
        //afbj1w+7+VmvaTX5rBP3xX/nNgfL96Qm/6Zy/f2ijvZa+Ejh3MrmpM/qj17RjfZccHMzsC
        HNMnXH5S9LlWcWdd3Dr57JltZ4KDC3lK/nJarAiUtzwdvEbn6iOGT6bz1hbNq83drSnHZyxW
        tHGJhHXGMy+mi5zrDlTMX83lWBO/OFCmc+35+LsergsyHWRdd7gnCiuxFGckGmoxFxUnAgA+
        C7/uOQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsWy7bCSvO7eo3LxBgs+qVo8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWvz6u57dYvXiBywWi25sY7LY9beZyaL7+g42i+XH/zE5
        8HhcvuLtcbmvl8ljwqIDjB7f13eweXx8eovFo2/LKkaPz5vkPNoPdDMFcERx2aSk5mSWpRbp
        2yVwZfw93sFacISn4s3WTSwNjD84uxg5OCQETCTWz9brYuTiEBLYzShxte84WxcjJ1BcQuL/
        4iYmCFtY4n7LEVaIom+MEt0TvzKCJNgENCTWHDvEBJIQEZjBJHFjyy9mkASzgJrE57vLWEBs
        YQFXia4ZjWBTWQRUJfa3toDFeQXMJa5s/AO1QV5iUcNvJoi4oMTJmU9YIObISzRvnc08gZFv
        FpLULCSpBYxMqxglUwuKc9Nziw0LDPNSy/WKE3OLS/PS9ZLzczcxgoNeS3MH4/ZVH/QOMTJx
        MB5ilOBgVhLh5RaViRfiTUmsrEotyo8vKs1JLT7EKM3BoiTOe6NwYZyQQHpiSWp2ampBahFM
        lomDU6qBSaSPZXf+9Jfp8rPfWIT5e6o2XP78bX9Ak862SS0MKkwBh3JdL5/9elSlOKaVd9PM
        SW4F1/a+yuj88qOr0pd95bkbB0ocP/CYzUkOr73UVNEbfmP3zeYFWQ5xKTtbbfr9ssx2dPUG
        Fh7btpKpWUvt6LdAiWlWk6MTqs58LNjwQ6hZnb1vnsnRf+yxBjvPNBxoEz9972VcyPyL5gcm
        enY+CRUtkr5gf+Nx0KYXhlvOnPlzfMVPubqufXde5idd/c/JI5U7Oev0Dvme3Tlb++sWldX0
        +r5Qc9vou5XhK+/FpSee3uzV4HjMecRoZ5lajIrv7x6fRGklmQYFee+XV2vvzY+U2yfNtT1p
        8cMzYnbblViKMxINtZiLihMBc8P7PekCAAA=
X-CMS-MailID: 20200727121701epcas2p345545e515b2f3ef8b951d0134a92d7b8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200727121701epcas2p345545e515b2f3ef8b951d0134a92d7b8
References: <CGME20200727121701epcas2p345545e515b2f3ef8b951d0134a92d7b8@epcas2p3.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,
Here is v4 of the patchset.
This patchs for supporting WB of vendor specific.
- when UFS reset and restore, need to cleare WB buffer.
- need to check WB buffer and flush operate before enter suspend
- do not enable WB with UFS probe.

our vendor device did not support gear scaling. So we can't use gear scaling code at mainline.
And we want to WB disable after probe. If IO state busy, then we will enable WB with IO monitoring.
I think always enable WB, then maybe occur power related problems.
If this patch merged, we will select to function sequence for performance of WB.
I think the current WB mainline will not be able to satisfy the performance and operation of each vendor.

[v1 -> v2]
- The ufshcd_reset_vendor() fuction for WB reset.
So I modified function name.
- uploade vendor wb code.

[v2 -> v3]
- modified minor details about blank, typing error etc..

[v3 -> v4]
- squash about fucntion name
- remove export symbol about function. because occur HPB patch.

SEO HOYOUNG (2):
  scsi: ufs: modify write booster
  scsi: ufs: add vendor specific write booster

 drivers/scsi/ufs/Kconfig      |   8 +
 drivers/scsi/ufs/Makefile     |   1 +
 drivers/scsi/ufs/ufs-exynos.c |   6 +
 drivers/scsi/ufs/ufs_ctmwb.c  | 270 ++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs_ctmwb.h  |  26 ++++
 drivers/scsi/ufs/ufshcd.c     |  19 ++-
 drivers/scsi/ufs/ufshcd.h     |  39 +++++
 7 files changed, 365 insertions(+), 4 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufs_ctmwb.c
 create mode 100644 drivers/scsi/ufs/ufs_ctmwb.h

-- 
2.26.0

