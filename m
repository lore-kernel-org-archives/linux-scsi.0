Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E8CDC4361B
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Dec 2020 03:08:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D61420637
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Dec 2020 03:08:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbgLSDIb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Dec 2020 22:08:31 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:15078 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbgLSDIa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2020 22:08:30 -0500
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20201219030748epoutp0292bc625db0dc987d24f17e780101cb79~R-1GsQr0K2795027950epoutp02E
        for <linux-scsi@vger.kernel.org>; Sat, 19 Dec 2020 03:07:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20201219030748epoutp0292bc625db0dc987d24f17e780101cb79~R-1GsQr0K2795027950epoutp02E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608347268;
        bh=UOe687YZDoV6k7D5BqOOIrAQpOjz/RSvu+28EKB+sU0=;
        h=From:To:Cc:Subject:Date:References:From;
        b=fQxWJ+x/gD+i6I0p0Fm4QQdxrJORubhX2Nc6ZzWprg3LhUCgaM+cZLzkbBxVzrE20
         DS0Wt/EKNBNxafoKqgZgfyI3Lgzshkn2cvJoJ8rRcEn38AcGOVxPa/KiYEQOYhDCMp
         JNob1uii/aB5Dz+aiZzrDfJEfCVwgUFPTmjpQpVw=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20201219030747epcas2p1758d8caae7b20d0db513f012359b133f~R-1F7u9eb2415924159epcas2p1C;
        Sat, 19 Dec 2020 03:07:47 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.187]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4CyVz43ZBVz4x9Pp; Sat, 19 Dec
        2020 03:07:44 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        70.30.05262.08E6DDF5; Sat, 19 Dec 2020 12:07:44 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20201219030743epcas2p39ee0570eea153915ad8e525e8f508e66~R-1CPWxBu0910909109epcas2p3w;
        Sat, 19 Dec 2020 03:07:43 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201219030743epsmtrp15b129f14de72d213b9ef41ff6eda1f56~R-1CL3tyT0919109191epsmtrp1R;
        Sat, 19 Dec 2020 03:07:43 +0000 (GMT)
X-AuditID: b6c32a47-b97ff7000000148e-f7-5fdd6e80fbd9
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        EB.41.08745.F7E6DDF5; Sat, 19 Dec 2020 12:07:43 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20201219030743epsmtip2e4deb24cefc49e2ac10a87acde67d91d~R-1B5m0cW0913909139epsmtip2l;
        Sat, 19 Dec 2020 03:07:43 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v2 0/2] permit vendor specific values of unipro timeouts
Date:   Sat, 19 Dec 2020 11:56:52 +0900
Message-Id: <cover.1608346381.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplk+LIzCtJLcpLzFFi42LZdljTTLch7268wdXt4hYP5m1js9jbdoLd
        4uXPq2wWBx92slh8XfqM1WLah5/MFp/WL2O1+PV3PbvF6sUPWCwW3djGZHFzy1EWi+7rO9gs
        lh//x2TRdfcGo8XSf29ZHPg9Ll/x9rjc18vkMWHRAUaP7+s72Dw+Pr3F4tG3ZRWjx+dNch7t
        B7qZAjiicmwyUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJz
        gI5XUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BQYGhboFSfmFpfmpesl5+daGRoY
        GJkCVSbkZMw8sJu9YAVLxY7vV1gaGHcwdzFyckgImEicmHSdvYuRi0NIYAejxK2TP9hBEkIC
        nxglzux2g0h8ZpSYMvEtC0zHpra/UB27GCXeXrzPBOH8YJTYd/cr2Fw2AU2JpzengiVEBM4w
        SVxrPcsKkmAWUJfYNeEEE4gtLOAhsebOPjYQm0VAVeL8kveMIDavgIVE84JPUOvkJG6e64Q6
        tpFD4s68LAjbReLosd3sELawxKvjW6BsKYmX/W1Qdr3EvqkNrCBHSAj0MEo83fePESJhLDHr
        WTuQzQF0kKbE+l36IKaEgLLEkVssEGfySXQcBvkSJMwr0dEmBNGoLPFr0mSoIZISM2/egdrk
        IXHg7QKwciGBWImHfwQnMMrOQhi/gJFxFaNYakFxbnpqsVGBMXIcbWIEp0ct9x2MM95+0DvE
        yMTBeIhRgoNZSYQ39MHteCHelMTKqtSi/Pii0pzU4kOMpsDQmsgsJZqcD0zQeSXxhqZGZmYG
        lqYWpmZGFkrivKEr++KFBNITS1KzU1MLUotg+pg4OKUamIICKlLenEioenZpYbrXuSlzb0xw
        qeRQWnXnWlL03Pb3/fH3DsR8Zcw0njw7qtD2+3K9qvxw2+mlHMuM/h0w+x3tNd9aMk+eoaDN
        7UveEtaLbu/S1Dy1NR34y1cv/hMeq1v05uG5zK95xy6umvn8+UXVQ/MVBP8W2kmvveJUZX1R
        pXXVhGnGaTpbH83q89JacPRp5kVNqeWK9q2nc7awO75Q4Cu6LySne+T+XZelBjm5CySSLVe1
        KawuK49u1W2z8Ny/xSfw7bmibaW7Q/KdpiZtWCzJc+cLQ93nbSf6njicfve84enHnIvTpBrY
        m2LjV9/lmKi8vWtnupOer7peivBm47be155TEwTU2iv9lViKMxINtZiLihMBvjNfRhgEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsWy7bCSvG593t14g8ZfPBYP5m1js9jbdoLd
        4uXPq2wWBx92slh8XfqM1WLah5/MFp/WL2O1+PV3PbvF6sUPWCwW3djGZHFzy1EWi+7rO9gs
        lh//x2TRdfcGo8XSf29ZHPg9Ll/x9rjc18vkMWHRAUaP7+s72Dw+Pr3F4tG3ZRWjx+dNch7t
        B7qZAjiiuGxSUnMyy1KL9O0SuDJmHtjNXrCCpWLH9yssDYw7mLsYOTkkBEwkNrX9Ze9i5OIQ
        EtjBKPFywg0miISkxImdzxkhbGGJ+y1HWCGKvjFKnDvRwQKSYBPQlHh6cyoTSEJE4B6TxKUJ
        c8HGMguoS+yacAJskrCAh8SaO/vYQGwWAVWJ80veg03lFbCQaF7wiQVig5zEzXOdzBMYeRYw
        MqxilEwtKM5Nzy02LDDKSy3XK07MLS7NS9dLzs/dxAgOWi2tHYx7Vn3QO8TIxMF4iFGCg1lJ
        hDf0we14Id6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwXuk7GCwmkJ5akZqemFqQWwWSZODilGpg6
        V9f9U5wxX2Zq4IN7O5NerH1RpvTuiPuO+jOJG1jud3ilfsmP+xX9r/2B88afnixe0Yv4NQt1
        FzxqPjFxwQGh+5Fxv2en2RzqthA/69NkkCWyLKIuu3XFpL0//iTZz7l+VC/HucKxPm16Wvu8
        JHsJ+djNV3OW+93XusfL2l7Oa6Ip8iQxyXzHQl0OQXsl6WjjbakOG7QnbvzI2r6xmu9j5Xr+
        GX6Sj79IZdatOju3QmJH95UYrsTGUvnUcy9nc5gKXXkQe/yOQOOG/j1Hp/JlN/C+1tGZXLop
        eXP1j8sx38odxc9P+mDkNid7bZNhsqas+u5fdzYEXns4O9xyUcmUfTN+zuGwulF4N0v66lsl
        luKMREMt5qLiRAAYsU9XyQIAAA==
X-CMS-MailID: 20201219030743epcas2p39ee0570eea153915ad8e525e8f508e66
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201219030743epcas2p39ee0570eea153915ad8e525e8f508e66
References: <CGME20201219030743epcas2p39ee0570eea153915ad8e525e8f508e66@epcas2p3.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

v1 -> v2: change some comments and rename the quirk

There are some attribute settings before power mode change in ufshcd.c
that should have been variant per vendor.

Kiwoong Kim (2):
  ufs: add a quirk not to use default unipro timeout values
  ufs: ufs-exynos: apply vendor specifics for three timeouts

 drivers/scsi/ufs/ufs-exynos.c |  8 +++++++-
 drivers/scsi/ufs/ufshcd.c     | 40 +++++++++++++++++++++-------------------
 drivers/scsi/ufs/ufshcd.h     |  6 ++++++
 3 files changed, 34 insertions(+), 20 deletions(-)

-- 
2.7.4

