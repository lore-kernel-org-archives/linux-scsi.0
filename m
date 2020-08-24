Return-Path: <SRS0=xqUt=CC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AE45C433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Aug 2020 02:38:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16961206F7
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Aug 2020 02:38:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="aBxDhFrs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbgHXCiX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Aug 2020 22:38:23 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:49503 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726635AbgHXCiS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Aug 2020 22:38:18 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200824023815epoutp01f1a17804bebc28c5474d52410973091c~uE86IEa4O1033510335epoutp01O
        for <linux-scsi@vger.kernel.org>; Mon, 24 Aug 2020 02:38:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200824023815epoutp01f1a17804bebc28c5474d52410973091c~uE86IEa4O1033510335epoutp01O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1598236695;
        bh=EEVpyJrsohhQBHvzH9ZD9lf77TAmtFsl/8DEBhWLFEk=;
        h=From:To:Cc:Subject:Date:References:From;
        b=aBxDhFrsVUEHfXbxiMuOxXlVdUwzuzeCmTOzuvDNUA89thHpiEESHpSmlDMxDrlJn
         Q2s1zXwITmYxM8odddclwQk3uQl7M3HOzakeLcwWOkJP+am8ctBLsNxmKHzJ6t/ncJ
         fMoTp2sHs9ve/LvKaBVfd/85c5gbZsWaRKUH2e+g=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20200824023814epcas2p37590e85757089ea4b61efc747ec393cd~uE85l-Cte2866228662epcas2p3h;
        Mon, 24 Aug 2020 02:38:14 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.191]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4BZbrz4CZmzMqYkX; Mon, 24 Aug
        2020 02:38:11 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        98.AB.27013.318234F5; Mon, 24 Aug 2020 11:38:11 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20200824023811epcas2p4915326d30728acff0a721043706e1f3b~uE81-IUZv0332003320epcas2p4c;
        Mon, 24 Aug 2020 02:38:11 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200824023811epsmtrp194037c9383b3628e837c4b38bc4fe95b~uE81_P0Z_1622416224epsmtrp1O;
        Mon, 24 Aug 2020 02:38:11 +0000 (GMT)
X-AuditID: b6c32a48-d35ff70000006985-c1-5f432813162f
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        C7.88.08382.218234F5; Mon, 24 Aug 2020 11:38:10 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200824023810epsmtip2955c503a213e041c6fec6c6b09051449~uE81r12qG3272332723epsmtip2c;
        Mon, 24 Aug 2020 02:38:10 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v2 0/2] skipping manual flush for write booster
Date:   Mon, 24 Aug 2020 11:29:25 +0900
Message-Id: <cover.1598236010.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPKsWRmVeSWpSXmKPExsWy7bCmqa6whnO8wap9ChYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCxubjnKYtF9fQebxfLj/5gs
        uu7eYLRY+u8tiwOfx+Ur3h6X+3qZPCYsOsDo8X19B5vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBH
        VI5NRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtDdSgpl
        iTmlQKGAxOJiJX07m6L80pJUhYz84hJbpdSClJwCQ8MCveLE3OLSvHS95PxcK0MDAyNToMqE
        nIxDD9eyF7SxVcy5LdHA+J2li5GTQ0LARGLqo3msXYxcHEICOxglFkyazgqSEBL4xCix+qIi
        ROIbo8TfJy2MMB1LNrxhgUjsZZS4uacXqv0Ho8TKR9vA5rIJaEo8vTmVCSQhIrCZSeLVgvvM
        IAlmAXWJXRNOMIHYwgL2EqsnHgTbxyKgKvHpwnMgm4ODV8BCYvJGHYhtchI3z3UyQ9g/2SWO
        LsqBsF0kZtzfC3WRsMSr41vYIWwpiZf9bVB2vcS+qQ1gx0kI9DBKPN33D6rBWGLWs3ZGkF3M
        QIeu36UPYkoIKEscucUCcSWfRMfhv+wQYV6JjjYhiEZliV+TJkMNkZSYefMO1CYPiY99jeyQ
        gIuV+HmwjXUCo+wshPkLGBlXMYqlFhTnpqcWGxWYIEfRJkZwStTy2ME4++0HvUOMTByMhxgl
        OJiVRHhvb7KPF+JNSaysSi3Kjy8qzUktPsRoCgyticxSosn5wKScVxJvaGpkZmZgaWphamZk
        oSTO+87qQpyQQHpiSWp2ampBahFMHxMHp1QDk+27hJKZi86aXEpeqdaSxVfZXLjTu7fOJ2x3
        i7zqbauw/Qm8TzxLnSea3VzPE31vxpJvRzZsrrq/tO9FRpHw8/OuJ7gufnKfWiG49ixH47O4
        xdO4783jOfDt+JfJyc+PKEYu3b7NyO/Zs/tXhKxT6x78W/Rm5sc52bfE5ZdV3jxR36uYy/zI
        6GvA3OsuC4uOeP6bYRt9WENe//fds2c9372o5i9UEvcImFW2QnG+vUdlRuvT/a1BqYtq7l+L
        f2gg6v9PuSR85/oweZFH6/nrd7NKrJjT8H1Kd03zu7fr9lg8uRY2cZ3b7zD2JT0Z/7Z/+Xpp
        ttSUL6WJ3VHRKgyZGWdEP11MDGgy523nPKpu0qXEUpyRaKjFXFScCACEB+y2EgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsWy7bCSvK6QhnO8wdwFFhYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCxubjnKYtF9fQebxfLj/5gs
        uu7eYLRY+u8tiwOfx+Ur3h6X+3qZPCYsOsDo8X19B5vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBH
        FJdNSmpOZllqkb5dAlfGoYdr2Qva2Crm3JZoYPzO0sXIySEhYCKxZMMbIJuLQ0hgN6PE0rVb
        mCESkhIndj5nhLCFJe63HGGFKPrGKLHp7TewIjYBTYmnN6cygSREBA4zSfzf+pwdJMEsoC6x
        a8IJJhBbWMBeYvXEg6wgNouAqsSnC8+BbA4OXgELickbdSAWyEncPNfJPIGRZwEjwypGydSC
        4tz03GLDAsO81HK94sTc4tK8dL3k/NxNjOAw1dLcwbh91Qe9Q4xMHIyHGCU4mJVEeG9vso8X
        4k1JrKxKLcqPLyrNSS0+xCjNwaIkznujcGGckEB6YklqdmpqQWoRTJaJg1OqgUnq/YT+6zoe
        PbdOPE4KnhltxPtoU6Xm5Fls99U8D3VFTXxyegH3n/ObjxeFM2od8N7TO3+qFtdO1sz60Pn8
        vyLyFKco668Sy1Fre2mgMWHTlkJz8e8vz4g/Yf0nwC4ceDBK/uUVQc7rl4XCtkaazGP8mmpW
        6nHFPWn3T449G9ON/87YUZ59cHZF+M2Fy5U+J91tnSPwcHedncDdhddPZ7C33O8wboi6nXxz
        9s6Aaaw9EiZRYo7c7ZU3r868wZcflxVwpOGF9eOw08ab/AxLS5QKXX5vufpt5lnjxXP3TrXm
        P9nqGSK/QPJGpx5juLh/0jbBV3G2pwInpf/uEbkx4+PqXdxfZtdsU/pu85r7h4gSS3FGoqEW
        c1FxIgA9a2yIwgIAAA==
X-CMS-MailID: 20200824023811epcas2p4915326d30728acff0a721043706e1f3b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200824023811epcas2p4915326d30728acff0a721043706e1f3b
References: <CGME20200824023811epcas2p4915326d30728acff0a721043706e1f3b@epcas2p4.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

v2 -> v1: enable the quirk in exynos

We have two knobs to flush for write booster, i.e.
fWriteBoosterEn, fWriteBoosterBufferFlushEn.
However, many product makers uses only fWriteBoosterBufferFlushEn,
because this can reportedly cover most scenarios and
there have been some reports that flush by fWriteBoosterEn could
lead raise power consumption thanks to unexpected internal
operations. So we need a way to enable or disable fWriteBoosterEn.

Kiwoong Kim (2):
  ufs: introduce skipping manual flush for wb
  ufs: exynos: enable UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL

 drivers/scsi/ufs/ufs-exynos.c | 3 ++-
 drivers/scsi/ufs/ufshcd.c     | 3 +++
 drivers/scsi/ufs/ufshcd.h     | 5 +++++
 3 files changed, 10 insertions(+), 1 deletion(-)

-- 
2.7.4

