Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD55FC433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 03:48:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B42CB2250E
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 03:48:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729242AbhASDs3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jan 2021 22:48:29 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:48217 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728766AbhASDp5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2021 22:45:57 -0500
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210119034506epoutp03c7b45b40a0cb59ff6f5619b273b95976~bhViBgN0q2549825498epoutp03p
        for <linux-scsi@vger.kernel.org>; Tue, 19 Jan 2021 03:45:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210119034506epoutp03c7b45b40a0cb59ff6f5619b273b95976~bhViBgN0q2549825498epoutp03p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1611027906;
        bh=77HlopfxLmeKmgbSYqp33fkcPRR5Rk3i6gdV4sm6jaE=;
        h=From:To:Cc:Subject:Date:References:From;
        b=NqIyrZ+rd9f9K2Bl2fM1HLNcpMpum3xx+Ouz0aYOof1EXMdAX+pgD1jzVsOxWNbes
         ZX7XV2TG5aPDZMbWX/yVVaBt6YNq3lXXkvPM93nltpdqz6thZVnKNSvNVpxvGR07Rv
         VncLeDGaHSVUWg9AXE1VsIk0Zw17yN+kaKxc9jVw=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210119034506epcas2p471434356ed346967a51efb4d02fdd016~bhVhQ2QVS0550105501epcas2p4E;
        Tue, 19 Jan 2021 03:45:06 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.188]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4DKZKq36bHz4x9Pv; Tue, 19 Jan
        2021 03:45:03 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        98.F1.05262.FB556006; Tue, 19 Jan 2021 12:45:03 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20210119034502epcas2p1b78378690bcbdc6453f657a3379ab90a~bhVd7Srnd1921519215epcas2p1a;
        Tue, 19 Jan 2021 03:45:02 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210119034502epsmtrp14a30c9ce15744dff2d0ba51d5d5cf80a~bhVd6FH_f1244212442epsmtrp1H;
        Tue, 19 Jan 2021 03:45:02 +0000 (GMT)
X-AuditID: b6c32a47-b97ff7000000148e-e3-600655bfde05
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        5C.7E.13470.EB556006; Tue, 19 Jan 2021 12:45:02 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210119034502epsmtip15f5f1d0c373a8c8826d1e4b74f5660a9~bhVdqFK4o2320023200epsmtip1b;
        Tue, 19 Jan 2021 03:45:02 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RESEND PATCH v6 0/2] introduce a quirk to allow only page-aligned
 sg entries
Date:   Tue, 19 Jan 2021 12:33:40 +0900
Message-Id: <cover.1611026909.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplk+LIzCtJLcpLzFFi42LZdljTXHd/KFuCwfsbAhYP5m1js9jbdoLd
        4uXPq2wWBx92slh8XfqM1WLah5/MFp/WL2O1+PV3PbvF6sUPWCwW3djGZHFzy1EWi+7rO9gs
        lh//x2TRdfcGo8XSf29ZHPg9Ll/x9rjc18vkMWHRAUaP7+s72Dw+Pr3F4tG3ZRWjx+dNch7t
        B7qZAjiicmwyUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJz
        gI5XUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BQYGhboFSfmFpfmpesl5+daGRoY
        GJkCVSbkZPw7u5ipoJ2l4u6mz+wNjFOYuxg5OSQETCTevm9i62Lk4hAS2MEoMe3vGyjnE6PE
        yyfPWCCcb4wSPw8vYIJp2TV3AztEYi+jxPVvr6GqfjBKXHv5kAWkik1AU+LpzalMIAkRgTNM
        Etdaz7KCJJgF1CV2TTgBNkpYIELi491l7CA2i4CqxKRPpxi7GDk4eAUsJHZtMILYJidx81wn
        1LGNHBJflxpD2C4SR3s3s0DYwhKvjm9hh7ClJF72t0HZ9RL7pjawgtwgIdDDKPF03z9GiISx
        xKxn7WC7mIEOXb9LH8SUEFCWOHKLBeJKPomOw3/ZIcK8Eh1tQhCNyhK/Jk2GGiIpMfPmHagS
        D4ntNzNAwkICsRJT799in8AoOwth/AJGxlWMYqkFxbnpqcVGBcbIcbSJEZwetdx3MM54+0Hv
        ECMTB+MhRgkOZiUR3tJ1TAlCvCmJlVWpRfnxRaU5qcWHGE2BgTWRWUo0OR+YoPNK4g1NjczM
        DCxNLUzNjCyUxHmLDR7ECwmkJ5akZqemFqQWwfQxcXBKNTDN3Fo3r8slk3NhQbeUeu2+2pPz
        7lxud2jYvbO2cd6R+XM8qqpDnlo/fjq733bLA5PTh+qZ7/HHms6I7F2oYZ+Wm/J8fcm13xr3
        /dhCznRdPBIxu317Rt5jaa+/ljKeMy6vtTi0qvdi1OV1Sq/mqxuv9l6Wflxx+5+UR5+9VTQs
        ZK9K5t356M31Yh1L45LJaeee7g3ZcP/C1UaBaYrHdQ6EO3JWuqp135ze1CT+bu6a7NVHF0ts
        9q163zrjum3EwUVie1tW5q59tWf1WzNBjlmq+xqcVV927wjQqZvxYrnzl/syStUJsfGnEkof
        SD5lEP72v9HqqdiUL7o2DUzl7G3T+3e4mb7gvsyqmBMx3cJeiaU4I9FQi7moOBEACxsu4hgE
        AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsWy7bCSnO6+ULYEg95H4hYP5m1js9jbdoLd
        4uXPq2wWBx92slh8XfqM1WLah5/MFp/WL2O1+PV3PbvF6sUPWCwW3djGZHFzy1EWi+7rO9gs
        lh//x2TRdfcGo8XSf29ZHPg9Ll/x9rjc18vkMWHRAUaP7+s72Dw+Pr3F4tG3ZRWjx+dNch7t
        B7qZAjiiuGxSUnMyy1KL9O0SuDL+nV3MVNDOUnF302f2BsYpzF2MnBwSAiYSu+ZuYO9i5OIQ
        EtjNKHH62A8WiISkxImdzxkhbGGJ+y1HWCGKvjFKfHlzgg0kwSagKfH05lQmkISIwD0miUsT
        5oKNZRZQl9g14QRQgoNDWCBM4tAWsDCLgKrEpE+nGEHCvAIWErs2GEHMl5O4ea6TeQIjzwJG
        hlWMkqkFxbnpucWGBYZ5qeV6xYm5xaV56XrJ+bmbGMEBq6W5g3H7qg96hxiZOBgPMUpwMCuJ
        8JauY0oQ4k1JrKxKLcqPLyrNSS0+xCjNwaIkznuh62S8kEB6YklqdmpqQWoRTJaJg1OqgSnf
        RTIne3ubz5rD4dsnH7BhOXWJw02283XUq6MH+st1+rewJt+oOHB3zs7NnyYtdNxUEraKtdRu
        AvuNxFlJcyreK/yKOSW6z0slXCr64dP9wfErrOctjD0fm38sZ4GH+9YVN8NXTHgnEh0eyLQp
        Q+iaz6xFd2s99awUtigZcKf/EZoZt3PHNLnlz1nitlQfvsn8LmxXz5IlBc6bZ2/vkBLb5q6m
        uPmp/+QzXQx50b2dOo2Oyw+a3G1fe+564cLF+/fH8zzcNLeoX6jl0yrzxbyc+UfWmR0/rqmm
        7bs626HNhu/RNA+WlRMrzXYee/ldpFBJrLsrYdHGjS25gcv7rnQ8bdOVO/8lmi1votTUnEVK
        LMUZiYZazEXFiQAWaZuPxwIAAA==
X-CMS-MailID: 20210119034502epcas2p1b78378690bcbdc6453f657a3379ab90a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210119034502epcas2p1b78378690bcbdc6453f657a3379ab90a
References: <CGME20210119034502epcas2p1b78378690bcbdc6453f657a3379ab90a@epcas2p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

v5 -> v6: replace the way with using a quirk
v4 -> v5: collect received tags
v3 -> v4: fix some typos
v2 -> v3: rename exynos functions
v1 -> v2: rename the vops and fix some typos

Kiwoong Kim (2):
  ufs: introduce a quirk to allow only page-aligned sg entries
  ufs: ufs-exynos: use UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE

 drivers/scsi/ufs/ufs-exynos.c | 3 ++-
 drivers/scsi/ufs/ufshcd.c     | 2 ++
 drivers/scsi/ufs/ufshcd.h     | 4 ++++
 3 files changed, 8 insertions(+), 1 deletion(-)

-- 
2.7.4

