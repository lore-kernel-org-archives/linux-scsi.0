Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB480C4361B
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 07:42:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78C1E23A5B
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 07:42:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbgLRHmh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Dec 2020 02:42:37 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:54594 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbgLRHmh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2020 02:42:37 -0500
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20201218074153epoutp0498b3caeb3ef3c1c044e744892c55d051~Rv7IbmXnQ1319713197epoutp04f
        for <linux-scsi@vger.kernel.org>; Fri, 18 Dec 2020 07:41:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20201218074153epoutp0498b3caeb3ef3c1c044e744892c55d051~Rv7IbmXnQ1319713197epoutp04f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608277313;
        bh=Bktn3VoJLDBUhnyhAAxYzXnBHuruF7CACrylomaa/N8=;
        h=From:To:Cc:Subject:Date:References:From;
        b=IYHzSXrCa9CRZm8YeUpxZD8O2mmBXoVKkp63+2G/10XZxK1Za/JsH5HLC9b1wIbBH
         AyZGbWyI4NWqEtSu2ooa3ZEOLtPe1nHb+wPQmyG4/k7dX2iF1yJYQEQJ0lFOEv6JiJ
         GCKXHtedWivdr01EYYHWFgOZiDdyQ87hYH4kOyTU=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20201218074152epcas2p2da779324d5ff9e9860c846014fe73253~Rv7HcFmRi2105121051epcas2p2L;
        Fri, 18 Dec 2020 07:41:52 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.190]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4Cy15m5HKfz4x9Q9; Fri, 18 Dec
        2020 07:41:48 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        42.5B.05262.A3D5CDF5; Fri, 18 Dec 2020 16:41:46 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20201218074142epcas2p4c5f276e54ff896b8e990303376a15154~Rv69_HlB_3191431914epcas2p4f;
        Fri, 18 Dec 2020 07:41:42 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201218074142epsmtrp101951cd3a0a4b7da036d0284e0e0aed4~Rv699BR0u1822618226epsmtrp1N;
        Fri, 18 Dec 2020 07:41:42 +0000 (GMT)
X-AuditID: b6c32a47-b81ff7000000148e-45-5fdc5d3a451e
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        BC.B4.13470.63D5CDF5; Fri, 18 Dec 2020 16:41:42 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20201218074142epsmtip101b55d8038528b15b5b0c77770cc8dee~Rv69qoJvG2655626556epsmtip1h;
        Fri, 18 Dec 2020 07:41:42 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RFC PATCH v1 0/2] permit vendor specific timeouts for PMC
Date:   Fri, 18 Dec 2020 16:30:49 +0900
Message-Id: <cover.1608276380.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphk+LIzCtJLcpLzFFi42LZdljTTNcq9k68wf8rxhYP5m1js9jbdoLd
        4uXPq2wWBx92slh8XfqM1WLah5/MFp/WL2O1+PV3PbvF6sUPWCwW3djGZHFzy1EWi+7rO9gs
        lh//x2TRdfcGo8XSf29ZHPg9Ll/x9rjc18vkMWHRAUaP7+s72Dw+Pr3F4tG3ZRWjx+dNch7t
        B7qZAjiicmwyUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJz
        gI5XUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BQYGhboFSfmFpfmpesl5+daGRoY
        GJkCVSbkZLTfXc5U8JC5omvLVaYGxkbmLkYODgkBE4l1j9K6GDk5hAR2MEocvuzdxcgFZH9i
        lJj26xQzhPONUeL44S+MIFVgDbv/s0N07GWUWN/tBVH0g1Hi65qrrCAJNgFNiac3pzKBJEQE
        zjBJXGs9C5ZgFlCX2DXhBBPIamEBZ4lLC4JBwiwCqhJL+p4wgdi8AhYSM5b+YYFYJidx81wn
        2BUSAo0cEpMnLGCHSLhIPPjXCmULS7w6vgXKlpJ42d8GZddL7JvawArR3MMo8XTfP6gXjCVm
        PWtnBDmCGejS9bv0IUGhLHHkFgvEmXwSHYf/skOEeSU62oQgGpUlfk2aDDVEUmLmzTtQmzwk
        vrx/zwoJk1iJB19mMk1glJ2FMH8BI+MqRrHUguLc9NRiowJj5CjaxAhOjlruOxhnvP2gd4iR
        iYPxEKMEB7OSCG/og9vxQrwpiZVVqUX58UWlOanFhxhNgeE1kVlKNDkfmJ7zSuINTY3MzAws
        TS1MzYwslMR5Q1f2xQsJpCeWpGanphakFsH0MXFwSjUwiTcxzPxn4syZnLU+0uOr0cScHdxH
        n7U31HQodx2YGHrixoPSlL0fn3JdLQhZfnjZo8a5gu2bf5gfVFd0XB6roNz9ln3ZhaT9L97n
        eO+8c3naFx0ui7UcmX4TfmsK7Wy3YD8gp89/f8Ha4nnqgeeWznc0ZPyTfqfowqOCxE3i4Ua6
        tzcmXz6oUDZfbAW79nxV9o1nRf61Bf5x7Q33/ff5a67QtmqfrrdGjtusjvf8T/4s1eS8ZdmN
        o4Ud8pWMF7WND37R2r1aQD334on2h2dvB3w1dPnD8zNoN+Nxo3MtO1qmzFP8Xhtp2LaFKbH+
        aFRDJsOrb5+6zpfysCd/fPhPZkFV36+D04VTpIIY1GRklViKMxINtZiLihMBPyUUiBcEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsWy7bCSnK5Z7J14g8mL+C0ezNvGZrG37QS7
        xcufV9ksDj7sZLH4uvQZq8W0Dz+ZLT6tX8Zq8evvenaL1YsfsFgsurGNyeLmlqMsFt3Xd7BZ
        LD/+j8mi6+4NRoul/96yOPB7XL7i7XG5r5fJY8KiA4we39d3sHl8fHqLxaNvyypGj8+b5Dza
        D3QzBXBEcdmkpOZklqUW6dslcGW0313OVPCQuaJry1WmBsZG5i5GTg4JAROJdbv/s3cxcnEI
        CexmlHi1rQ8qISlxYudzRghbWOJ+yxFWiKJvjBI75j8GK2IT0JR4enMqE0hCROAek8SlCXPB
        EswC6hK7JpwASnBwCAs4S1xaEAwSZhFQlVjS94QJxOYVsJCYsfQPC8QCOYmb5zqZJzDyLGBk
        WMUomVpQnJueW2xYYJiXWq5XnJhbXJqXrpecn7uJERyyWpo7GLev+qB3iJGJg/EQowQHs5II
        b+iD2/FCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeS90nYwXEkhPLEnNTk0tSC2CyTJxcEo1MC2+
        8/KB5KyPD3dZX/onJvDB02ty9Q3xwh/h8d22CcftexOvtFjHPr4at6PKZd3769c2mfsvPVey
        6cU9w2/VLZ2Nm9tNhLukss4utjtsciTwe/kWoWl9R3M23p95SD92d4OSy7HAUNcZq7UvH/rS
        Fzv1HV/e5n2Gx6+pNlrYX29asVvp2/O0T2v3XDms/2v2lqo3ioGr9xWnqX21n3dN9OGl/qLP
        5S2WExLS194Si+WQeH34zDLWkPWaZ1y+5LuvC5vEYfDDsM/d4nbhhUk3j7AYbddL1j730bg0
        jbf+8U6he5qsVSyZW//K2Ov9rDiyXKnvbgrbNw/ny+yrXKSCHsxt0WGYoBZ57MbzKBvR6+ZK
        LMUZiYZazEXFiQBU/Ey9yAIAAA==
X-CMS-MailID: 20201218074142epcas2p4c5f276e54ff896b8e990303376a15154
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201218074142epcas2p4c5f276e54ff896b8e990303376a15154
References: <CGME20201218074142epcas2p4c5f276e54ff896b8e990303376a15154@epcas2p4.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There are some attribute settings before power mode change in ufshcd.c
that should be variant per vendor.

Kiwoong Kim (2):
  ufs: add a quirk for vendor specifics before pmc
  ufs: ufs-exynos: apply vendor specifics for three timeouts

 drivers/scsi/ufs/ufs-exynos.c |  8 +++++++-
 drivers/scsi/ufs/ufshcd.c     | 40 +++++++++++++++++++++-------------------
 drivers/scsi/ufs/ufshcd.h     |  6 ++++++
 3 files changed, 34 insertions(+), 20 deletions(-)

-- 
2.7.4

