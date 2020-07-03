Return-Path: <SRS0=NMWN=AO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65E17C433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 05:38:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FB9820772
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 05:38:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="K8ld7oEA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbgGCFi7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jul 2020 01:38:59 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:19775 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725915AbgGCFi6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2020 01:38:58 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200703053856epoutp04037ad9cb9dd254a3ad218897ce8990b9~eJ30QAW7l0800008000epoutp04F
        for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2020 05:38:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200703053856epoutp04037ad9cb9dd254a3ad218897ce8990b9~eJ30QAW7l0800008000epoutp04F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593754736;
        bh=XtnR6AN0FxzK+hJcEmy8nHGjh9saotcBzBtkcpMcMK8=;
        h=From:To:Cc:Subject:Date:References:From;
        b=K8ld7oEAkQPoi+AkXvV6+DjCQErsGdFTc5fBVBvqmSB5Sm4/q6XboAWN0+FOpl5+1
         yNfEox/EdL4bgQcCIh8ATyr/SgiuUqgRp4TA6+rIiuB5va9/ayXEdDll4DmySkZqXF
         JldTjpX5BX0t9ppqzddwirlsonURZFdvRgC+yuL4=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20200703053855epcas2p3718c774bbbbbf4bdee2e43593de95a96~eJ3zyZtDW0469104691epcas2p3x;
        Fri,  3 Jul 2020 05:38:55 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.185]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 49ykKT4jYXzMqYkv; Fri,  3 Jul
        2020 05:38:53 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        6E.69.19322.C64CEFE5; Fri,  3 Jul 2020 14:38:52 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20200703053852epcas2p47779aeac8c01a2b94596fdd9e660fe69~eJ3wp8xoJ1296212962epcas2p4E;
        Fri,  3 Jul 2020 05:38:52 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200703053852epsmtrp2a589dd05dc1d6148499a830b43a3f72a~eJ3wpJMBO0409004090epsmtrp2X;
        Fri,  3 Jul 2020 05:38:52 +0000 (GMT)
X-AuditID: b6c32a45-797ff70000004b7a-35-5efec46ce4e7
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        4F.9A.08382.C64CEFE5; Fri,  3 Jul 2020 14:38:52 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200703053852epsmtip1fa4c76864c1094c8526b2f318525f8c3~eJ3wb6Zp-2379623796epsmtip1H;
        Fri,  3 Jul 2020 05:38:52 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RFC PATCH v3 0/2] ufs: introduce callbacks to get command
 information
Date:   Fri,  3 Jul 2020 14:31:03 +0900
Message-Id: <cover.1593752220.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42LZdljTTDfnyL84gwPTjCwezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usXrxAxaLRTe2MVnc3HKUxaL7+g42i+XH/zFZ
        dN29wWix9N9bFgc+j8tXvD0u9/UyeUxYdIDR4/v6DjaPj09vsXj0bVnF6PF5k5xH+4FupgCO
        qBybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKC7lRTK
        EnNKgUIBicXFSvp2NkX5pSWpChn5xSW2SqkFKTkFhoYFesWJucWleel6yfm5VoYGBkamQJUJ
        ORnX96YWfOOo+HBlDnMDYwt7FyMnh4SAicTjs3cYuxi5OIQEdjBKrFwwC8r5xCix4PFnJgjn
        G6PEi/dfgTIcYC33XgtCxPcySvxccJUdwvnBKHH6bTPYXDYBTYmnN6eCdYsIbGaSeLXgPjNI
        gllAXWLXhBNMILawQKDEpM1TweIsAqoSE2Z+A4vzClhIXN6zjBHiQDmJm+c6mUEGSQj8ZJfY
        e20dG0TCReLy/SZWCFtY4tXxLVAfSUl8frcXqqZeYt/UBlaI5h5Giaf7/kFNNZaY9awd7B9m
        oFPX79KHeE1Z4sgtFog7+SQ6Dv9lhwjzSnS0CUE0Kkv8mjQZaoikxMybd6C2ekg8Or8ezBYS
        iJVY+v4D0wRG2VkI8xcwMq5iFEstKM5NTy02KjBEjqRNjOC0qOW6g3Hy2w96hxiZOBgPMUpw
        MCuJ8Cao/osT4k1JrKxKLcqPLyrNSS0+xGgKDK+JzFKiyfnAxJxXEm9oamRmZmBpamFqZmSh
        JM6bq3ghTkggPbEkNTs1tSC1CKaPiYNTqoGp3ptVQvXZZo43Qu9fPGZd/eH/S2s3jqpJbnuV
        7Kq5f3++lXFozY3Xpi5czzamTNraWHVxft0py/DPW/Y+NJm/RcaR67ej866iVhGLr8teLG0M
        WLlgwdozL+/NfJd+3e3++3NnG6YuuROY5Po6dL9WZOy7h3Xn2Kd1GBe6T/ZguvZvZsudLGXF
        +Wd78q6UHGmVfmT+9dTStL7k2vlH0te+nvd48xuvDFX+LP57b4X73vn9Pt0enVfDn3Bm3z+F
        9tSjviUyqhql83cyvM39lXi4776boeUy+eW7Oi83S7w6YLfStvVBTfsNa6fdq7bxyPVqVi88
        9O3T9j3pc84vWnS1ML9QXkTW/P8a/fS864ecFJVYijMSDbWYi4oTAeTp0PoUBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsWy7bCSnG7OkX9xBj3bBS0ezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usXrxAxaLRTe2MVnc3HKUxaL7+g42i+XH/zFZ
        dN29wWix9N9bFgc+j8tXvD0u9/UyeUxYdIDR4/v6DjaPj09vsXj0bVnF6PF5k5xH+4FupgCO
        KC6blNSczLLUIn27BK6M63tTC75xVHy4Moe5gbGFvYuRg0NCwETi3mvBLkYuDiGB3YwS61o/
        MHcxcgLFJSVO7HzOCGELS9xvOcIKUfSNUeLV/mNsIAk2AU2JpzenMoEkRAQOM0n83/qcHSTB
        LKAusWvCCSYQW1jAX+LEyT1gcRYBVYkJM7+BxXkFLCQu71kGtUFO4ua5TuYJjDwLGBlWMUqm
        FhTnpucWGxYY5qWW6xUn5haX5qXrJefnbmIEh6mW5g7G7as+6B1iZOJgPMQowcGsJMKboPov
        Tog3JbGyKrUoP76oNCe1+BCjNAeLkjjvjcKFcUIC6YklqdmpqQWpRTBZJg5OqQYmh/z9D0sv
        r5neevo52/eXj0M1pFWm71JiCbklf//yHb0luosE9yQvVgvUqFyjLbNc8Od0c2bPWsNjZ381
        PZzvVhoedPd4j8CK35uMHzD/j26b2JjEvfKprPfUPz8lH9hZ7bYvZlVx05tgcjFaRvNWQeap
        MxFZc98tnnfnj/EB4x5dja2ehmf2dJX/+MFqniK0mTv/ooDi+y62vAnN/l82nIu+P2HqSm3F
        yW5TJjyZ80CcvfmzaVuORQfDda7mkxHeigY5vuZChclL0sUbD8ZsnLGz9KZqZpoV0wyH8ilP
        f0xh37jP/vE218r1n/Z5tQT+EsuL4hc2EVja6LCKr9JOO3yT1zsjYYWK5DsP9JuUWIozEg21
        mIuKEwEFlOY9wgIAAA==
X-CMS-MailID: 20200703053852epcas2p47779aeac8c01a2b94596fdd9e660fe69
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200703053852epcas2p47779aeac8c01a2b94596fdd9e660fe69
References: <CGME20200703053852epcas2p47779aeac8c01a2b94596fdd9e660fe69@epcas2p4.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

v2 -> v3
fix build errors

v1 -> v2
change callbacks
allocate memory for ufs_s_dbg_mgr dynamically, not static way

Some SoC specific might need command history for
various reasons, such as stacking command contexts
in system memory to check for debugging in the future
or scaling some DVFS knobs to boost IO throughput.

What you would do with the information could be
variant per SoC vendor.

Kiwoong Kim (2):
  ufs: introduce a callback to get info of command completion
  exynos-ufs: implement dbg_register_dump and compl_xfer_req

 drivers/scsi/ufs/Kconfig          |  14 +++
 drivers/scsi/ufs/Makefile         |   2 +-
 drivers/scsi/ufs/ufs-exynos-dbg.c | 202 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-exynos-if.h  |  17 ++++
 drivers/scsi/ufs/ufs-exynos.c     |  63 +++++++++++-
 drivers/scsi/ufs/ufs-exynos.h     |  13 +++
 drivers/scsi/ufs/ufshcd.c         |   2 +
 drivers/scsi/ufs/ufshcd.h         |   8 ++
 8 files changed, 318 insertions(+), 3 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufs-exynos-dbg.c
 create mode 100644 drivers/scsi/ufs/ufs-exynos-if.h

-- 
2.7.4

