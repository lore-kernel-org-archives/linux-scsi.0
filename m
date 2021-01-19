Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB0A0C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 03:48:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C06742250E
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 03:48:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729257AbhASDsb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jan 2021 22:48:31 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:48255 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728770AbhASDp5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2021 22:45:57 -0500
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210119034508epoutp03cf050484fbb43a651ae009bc60d3d4f1~bhVjIoumZ2531525315epoutp03-
        for <linux-scsi@vger.kernel.org>; Tue, 19 Jan 2021 03:45:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210119034508epoutp03cf050484fbb43a651ae009bc60d3d4f1~bhVjIoumZ2531525315epoutp03-
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1611027908;
        bh=YA1/e4TPOxL6MryBAuaA6i41XFxzfZMi+vkRoddHhbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=Rvy4+GJZDNFVcsBkJYbsHmtsEWiB/PJlxR8RVGmVcHIUCqBHvaJ+1HiJemxXOnb5N
         F2ReHayPLqGMPUDB+ckg5gYV5m1ZjUITu9AuWCFrCm79ebWXD22Z6TGCzz8slURfWZ
         pqljL7+J/zX/O1MUxcKu7aYb2MYy+ZdHbQvXsN10=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210119034507epcas2p4cffb9920a56ce312dde03c7ebb84fffd~bhVig18HP2622426224epcas2p4i;
        Tue, 19 Jan 2021 03:45:07 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.185]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4DKZKs0kjFz4x9Pt; Tue, 19 Jan
        2021 03:45:05 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        D9.F1.05262.FB556006; Tue, 19 Jan 2021 12:45:03 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20210119034503epcas2p1d5be1d29bc5def9d4f622e5edfd31df8~bhVexUOXZ1621716217epcas2p1x;
        Tue, 19 Jan 2021 03:45:03 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210119034503epsmtrp203260053fa5f1f46098a057a90af569f~bhVewX0As0281202812epsmtrp2Z;
        Tue, 19 Jan 2021 03:45:03 +0000 (GMT)
X-AuditID: b6c32a47-b81ff7000000148e-e6-600655bfd816
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        4E.7E.13470.FB556006; Tue, 19 Jan 2021 12:45:03 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210119034503epsmtip1a1f91cfc829b0debbf91931ca2ed5944~bhVeks8Of2273022730epsmtip1X;
        Tue, 19 Jan 2021 03:45:03 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RESEND PATCH -6 1/2] ufs: introduce a quirk to allow only
 page-aligned sg entries
Date:   Tue, 19 Jan 2021 12:33:41 +0900
Message-Id: <56dddef94f60bd9466fd77e69f64bbbd657ed2a1.1611026909.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1611026909.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1611026909.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAJsWRmVeSWpSXmKPExsWy7bCmme7+ULYEg11/zC0ezNvGZrG37QS7
        xcufV9ksDj7sZLH4uvQZq8W0Dz+ZLT6tX8Zq8evvenaL1YsfsFgsurGNyeLmlqMsFt3Xd7BZ
        LD/+j8mi6+4NRoul/96yOPB7XL7i7XG5r5fJY8KiA4we39d3sHl8fHqLxaNvyypGj8+b5Dza
        D3QzBXBE5dhkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXm
        AB2vpFCWmFMKFApILC5W0rezKcovLUlVyMgvLrFVSi1IySkwNCzQK07MLS7NS9dLzs+1MjQw
        MDIFqkzIyTjT+Y+14Bt/xeO/X1kbGL/zdDFyckgImEg03eph7GLk4hAS2MEo0XzgKzuE84lR
        Yvv84ywQzjdGied/X7HAtJxa+osZIrGXUeJMwxao/h+MEm9utzGBVLEJaEo8vTmVCSQhInCG
        SeJa61lWkASzgLrErgkngBIcHMICsRKff1eDhFkEVCX+Pr4O1ssrEC2xaPszNohtchI3z3Uy
        g9icApYSMzv2MKGyuYBq5nJIbJpwgxGiwUVi0cXTUM3CEq+Ob2GHsKUkPr/bCxWvl9g3tYEV
        ormHUeLpvn9QzcYSs561M4Icxwz0wfpd+iCmhICyxJFbLBDn80l0HP7LDhHmlehoE4JoVJb4
        NWky1BBJiZk370Bt9ZCYcmI3GyR8gDY9/zWXaQKj/CyEBQsYGVcxiqUWFOempxYbFRgjR98m
        RnBS1XLfwTjj7Qe9Q4xMHIyHGCU4mJVEeEvXMSUI8aYkVlalFuXHF5XmpBYfYjQFBuREZinR
        5HxgWs8riTc0NTIzM7A0tTA1M7JQEuctNngQLySQnliSmp2aWpBaBNPHxMEp1cAUd+xXoP21
        gKSrRYKX7e4XrKhaPuOI9skAT52nQh+FNzJ9+xHL4qJ1JIVDcXLJ/eefbTdEXuDv1L4VJprW
        pvtYg5fJbKriX5+omDkv2redV/9xmvOY5/XTSzbfmXz7mdvFCSxhsyad+Vmyv3RXf5bNj52z
        L5/zU7g334hb31yRoeVE6jLuD9mhMzatOllkfni9TZz85OMrtnGxTgopVP4+Z9HOZNm13Gwq
        Hcu1nrb+zOz0lM9MbZ+Z+6jWYlbh/yNPe3/aq8ruvz/zc8eq6LrJapabFzknuVVN1y/iYbV/
        5RrmLHPfN6f6SvYjj3dKb81jrQ4+YZokIXj/aEnZ7ukT/3oxWZiJXucVUD2+dLK5EktxRqKh
        FnNRcSIAUtookzMEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsWy7bCSnO7+ULYEg3vHhS0ezNvGZrG37QS7
        xcufV9ksDj7sZLH4uvQZq8W0Dz+ZLT6tX8Zq8evvenaL1YsfsFgsurGNyeLmlqMsFt3Xd7BZ
        LD/+j8mi6+4NRoul/96yOPB7XL7i7XG5r5fJY8KiA4we39d3sHl8fHqLxaNvyypGj8+b5Dza
        D3QzBXBEcdmkpOZklqUW6dslcGWc6fzHWvCNv+Lx36+sDYzfeboYOTkkBEwkTi39xdzFyMUh
        JLCbUaKp4QAbREJS4sTO54wQtrDE/ZYjrBBF3xglHk6cxgqSYBPQlHh6cyoTSEJE4B6TxKUJ
        c5lBEswC6hK7JpwASnBwCAtESzQ9sQcJswioSvx9fJ0JxOYFCi/a/gxqmZzEzXOdYK2cApYS
        Mzv2gNUICVhILNz5kwWX+ARGgQWMDKsYJVMLinPTc4sNCwzzUsv1ihNzi0vz0vWS83M3MYJj
        QktzB+P2VR/0DjEycTAeYpTgYFYS4S1dx5QgxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdC18l4
        IYH0xJLU7NTUgtQimCwTB6dUA5NNiNmmwsPPWjMWTH4Q3Surmbp346LtJuV2Gw/PFlfSmbet
        QyX0+N7Gm8L6+zfV/D5XEjvVRXPieQeZiHlr3zg/fHapcNur4zmc716GfXP43Fp0fuqm+GCX
        ZfvXL16isPHWM44nFbfse7UqfzndmPLvn9TxoqXuQrP5Es/XzZm/RftmxZ1DCad2dsyNW5uq
        t989zrjiea9b89YvWidiXSYzHD3UPcfk565442kXFd8uFDDdZKWowZ/J/TIn8UX2aa/wbY4v
        FjIwL26Qm1bZknTic8mFZM+FmyKrU3dsyxSrvCRydVJDVWN5u0GJ4cWSTQ5/iqT3hUQ+qkq6
        9XV5TlbsM5GEVIXS1yue8U3iL09XYinOSDTUYi4qTgQABIvjtPgCAAA=
X-CMS-MailID: 20210119034503epcas2p1d5be1d29bc5def9d4f622e5edfd31df8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210119034503epcas2p1d5be1d29bc5def9d4f622e5edfd31df8
References: <cover.1611026909.git.kwmad.kim@samsung.com>
        <CGME20210119034503epcas2p1d5be1d29bc5def9d4f622e5edfd31df8@epcas2p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some SoCs could require one scatterlist entry for smaller than
page size, i.e. 4KB. For the cases of dispatching commands
with more than one scatterlist entry and under 4KB size,
They could behave as follows:

Given that a command to read something
from device is dispatched with two scatterlist entries that
are named AAA and BBB. After dispatching, host builds two PRDT
entries and during transmission, device sends just one DATA IN
because device doesn't care on host dma. The host then tranfers
the whole data from start address of the area named AAA.
In consequence, the area that follows AAA would be corrupted.

    |<------------->|
    +-------+------------         +-------+
    +  AAA  + (corrupted)   ...   +  BBB  +
    +-------+------------         +-------+

In this case, you need to force an aligment with page size for
sg entries.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 2 ++
 drivers/scsi/ufs/ufshcd.h | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e221add..847eb02 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4792,6 +4792,8 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
 	struct request_queue *q = sdev->request_queue;
 
 	blk_queue_update_dma_pad(q, PRDT_DATA_BYTE_COUNT_PAD - 1);
+	if (hba->quirks & UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE)
+		blk_queue_update_dma_alignment(q, PAGE_SIZE - 1);
 
 	if (ufshcd_is_rpm_autosuspend_allowed(hba))
 		sdev->rpm_autosuspend = 1;
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 9bb5f0e..9e7223f 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -549,6 +549,10 @@ enum ufshcd_quirks {
 	 */
 	UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL		= 1 << 12,
 
+	/*
+	 * This quirk allows only sg entries aligned with page size.
+	 */
+	UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE		= 1 << 13,
 };
 
 enum ufshcd_caps {
-- 
2.7.4

