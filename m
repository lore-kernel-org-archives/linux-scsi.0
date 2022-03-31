Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AD56C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Mar 2022 01:25:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345417AbiCaB1j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Mar 2022 21:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbiCaB1j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Mar 2022 21:27:39 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E76143380
        for <linux-scsi@vger.kernel.org>; Wed, 30 Mar 2022 18:25:52 -0700 (PDT)
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220331012549epoutp03d4c2672c53c818afd172e7c4d056db60~hUsYTbJAa1735017350epoutp03X
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 01:25:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220331012549epoutp03d4c2672c53c818afd172e7c4d056db60~hUsYTbJAa1735017350epoutp03X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1648689949;
        bh=guf5a+UyXn8Tu3/RRFV+ifGaLBDshbdYgxhEy4V5WMs=;
        h=From:To:Cc:Subject:Date:References:From;
        b=O92wQugQJTzhIzLLfhgw58ER+ayDZpUwilhzZs9ChZVb7Ma7D9bUEBV1k5auIo7Gx
         2teX5JC0jiQUjuptEZs4XdjYmxjOEq18d9BglnlBvcwOA3/uSMTd/Hz/Mrqtrvj/13
         uBBfOgo2UXOZ/Cl6eMdYzuXExURjYR9+E4XjvpBc=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20220331012548epcas2p374a6d028528c3433ed9716d29a31e4cd~hUsXzvkyh0405704057epcas2p3F;
        Thu, 31 Mar 2022 01:25:48 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.36.91]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4KTQbl6kMrz4x9QP; Thu, 31 Mar
        2022 01:25:39 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        53.28.16040.31305426; Thu, 31 Mar 2022 10:25:39 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20220331012539epcas2p180d804d9562b6e0fb968ffd181d64605~hUsO49YM_0964809648epcas2p1G;
        Thu, 31 Mar 2022 01:25:39 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220331012539epsmtrp2ab4320fb0eb6d74d4d5a2ff101393734~hUsO39NMN3063230632epsmtrp2R;
        Thu, 31 Mar 2022 01:25:39 +0000 (GMT)
X-AuditID: b6c32a46-bffff70000023ea8-d1-62450313f134
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        38.13.24342.21305426; Thu, 31 Mar 2022 10:25:39 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220331012538epsmtip1e344a08d3833708f9f1b61e32c5f6d7e~hUsOqhHc10410904109epsmtip1w;
        Thu, 31 Mar 2022 01:25:38 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        cang@codeaurora.org, adrian.hunter@intel.com, sc.suh@samsung.com,
        hy50.seo@samsung.com, sh425.lee@samsung.com,
        bhoon95.kim@samsung.com, vkumar.1997@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RESEND PATCH v3] scsi: ufs: exclude UECxx from SFR dump list
Date:   Thu, 31 Mar 2022 10:24:05 +0900
Message-Id: <1648689845-33521-1-git-send-email-kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphk+LIzCtJLcpLzFFi42LZdljTVFeY2TXJ4Pc2NYuTT9awWTyYt43N
        4uXPq2wWBx92slh8XfqM1eLT+mWsFqsXP2CxWHRjG5PFzS1HWSwu75rDZtF9fQebxfLj/5gs
        uu7eYLRY+u8ti8Wd+x9ZHPg9Lvf1Mnks3vOSyWPCogOMHt/Xd7B5fHx6i8Wjb8sqRo/Pm+Q8
        2g90MwVwRGXbZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl
        5gBdr6RQlphTChQKSCwuVtK3synKLy1JVcjILy6xVUotSMkpMC/QK07MLS7NS9fLSy2xMjQw
        MDIFKkzIzpg0eyV7QRtPxd8b89gaGM9wdjFyckgImEh8WnWcsYuRi0NIYAejxNxfq6GcT4wS
        725cZYVwvjFKnP/QzArT8uF3GztEYi+jRNf/R1AtPxglPk68yQxSxSagKfH05lQmEFtE4DqT
        xLztGSA2s4C6xK4JJ8DiwgJuEhvmNLOB2CwCqhItf7uBNnBw8Aq4SqxcWQCxTE7i5rlOZpD5
        EgKdHBI9DZNZIBIuEodnP2CDsIUlXh3fwg5hS0l8freXDWSOhECxxKZ98hC9DYwSSz5thuo1
        lpj1rJ0RpIYZ6M71u/QhypUljtxigbiST6Lj8F92iDCvREebEESjssSvSZMZIWxJiZk370At
        9ZD4OfE02EAhgViJd3NZJjDKzkIYv4CRcRWjWGpBcW56arFRgRE8ipLzczcxgpOjltsOxilv
        P+gdYmTiYDzEKMHBrCTC+/Ggc5IQb0piZVVqUX58UWlOavEhRlNgYE1klhJNzgem57ySeEMT
        SwMTMzNDcyNTA3MlcV6vlA2JQgLpiSWp2ampBalFMH1MHJxSDUzOllcWrNk6ob1+zrspFwOK
        IzIM1iacjs/3ufHxoLVZpcMq9Um1iVaXnghKz09pjDmi5jl7s7Iv68ST3e+mv9iqP33Zfh6f
        I46a7vt2RL28NIHr99elQQyf6188DlCNfTJRN+jP0kD74I+83+6973uauDnk69f4A+m6dptv
        n9RMOL1Wrd7uzon5frM+TN0c2va/S2vHFzfhWbFMFpFWQstO/trC2X/U8V3hWuZ71gfv+ugI
        3Er7Jbj8cJrOBMmG3U2fZnNt2Wqw4z3Tt5Inzxmme6U/l7+m2OJ/1IPxmILUhiLL/h3R6zxc
        I0RE9rFdnZXMxHjmx1Xh6Xs/XS3Ym+fhdqYnfxLfxINeJ9qNs3LuKLEUZyQaajEXFScCAFKH
        zpIXBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsWy7bCSnK4ws2uSwcU5zBYnn6xhs3gwbxub
        xcufV9ksDj7sZLH4uvQZq8Wn9ctYLVYvfsBisejGNiaLm1uOslhc3jWHzaL7+g42i+XH/zFZ
        dN29wWix9N9bFos79z+yOPB7XO7rZfJYvOclk8eERQcYPb6v72Dz+Pj0FotH35ZVjB6fN8l5
        tB/oZgrgiOKySUnNySxLLdK3S+DKmDR7JXtBG0/F3xvz2BoYz3B2MXJySAiYSHz43cbexcjF
        ISSwm1Fi8v8fzBAJSYkTO58zQtjCEvdbjrBCFH1jlPiz+iMbSIJNQFPi6c2pTCAJEYGXTBIv
        5qwBSzALqEvsmnCCCcQWFnCT2DCnGSzOIqAq0fK3G2gSBwevgKvEypUFEAvkJG6e62SewMiz
        gJFhFaNkakFxbnpusWGBYV5quV5xYm5xaV66XnJ+7iZGcNBqae5g3L7qg94hRiYOxkOMEhzM
        SiK8Hw86JwnxpiRWVqUW5ccXleakFh9ilOZgURLnvdB1Ml5IID2xJDU7NbUgtQgmy8TBKdXA
        VHP2ON/rTQKXWf9IHu9VVT7kJO0p2H9zpfMW2/0MTM1XmNZb/7nLmfyCrbK06jxv8lrNrKuX
        Zv+f/3al5bznX3d0P3tke7bs29Rnh47d3xr7ZcXVDcom51bWCt02Y9K+0fZbZf/DguI9sVN2
        MLd+YFt/caXFgbfHFlUIeQX5L97M/OLslIdX3x+pf7p70qytDydleZ0062PM23Tc84/FB48r
        e69kc7c/+zhv3Yes2UInwtQOrln5ol8442P2ZCs1H8Fgu3tXt1z85XvLZ/N7seVpf/KftT37
        qPFm5zbFOUy3kuq7r3xXYb+28eSm2dvX1D3/+O5JjeClj+8szs3s0TfkuLR7qc/ZWstHHgtL
        BbYw7FBiKc5INNRiLipOBAD6ibSAyQIAAA==
X-CMS-MailID: 20220331012539epcas2p180d804d9562b6e0fb968ffd181d64605
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220331012539epcas2p180d804d9562b6e0fb968ffd181d64605
References: <CGME20220331012539epcas2p180d804d9562b6e0fb968ffd181d64605@epcas2p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

v2 -> v3: add fixes
v1 -> v2: does skipping only for zero offset

These are ROC type things that means their values
are cleared when the SFRs are read.
They are usually read in ISR when an UIC error occur.
Thus, their values would be zero at many cases. And
there might be a little bit risky when they are read to
be cleared before the ISR reads them, e.g. the case that
a command is timed-out, ufshcd_dump_regs is called in
ufshcd_abort and an UIC error occurs at the nearly
same time. In this case, ISR will be called but UFS error handler
will not be scheduled.
This patch is to make UFS driver not read those SFRs in the
dump function, i.e. ufshcd_dump_regs.

Fixes: d67247566450 ("scsi: ufs: Use explicit access size in ufshcd_dump_regs")
Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 460d2b4..7f2a1ed 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -115,8 +115,13 @@ int ufshcd_dump_regs(struct ufs_hba *hba, size_t offset, size_t len,
 	if (!regs)
 		return -ENOMEM;
 
-	for (pos = 0; pos < len; pos += 4)
+	for (pos = 0; pos < len; pos += 4) {
+		if (offset == 0 &&
+		    pos >= REG_UIC_ERROR_CODE_PHY_ADAPTER_LAYER &&
+		    pos <= REG_UIC_ERROR_CODE_DME)
+			continue;
 		regs[pos / 4] = ufshcd_readl(hba, offset + pos);
+	}
 
 	ufshcd_hex_dump(prefix, regs, len);
 	kfree(regs);
-- 
2.7.4

