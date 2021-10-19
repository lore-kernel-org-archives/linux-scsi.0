Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24616C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 05:13:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA5A160FF2
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 05:13:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232856AbhJSFQG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Oct 2021 01:16:06 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:17953 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbhJSFQF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Oct 2021 01:16:05 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20211019051351epoutp015d83424320d48a6fed1a9009444fa102~vVp9D6jUI0284202842epoutp01Y
        for <linux-scsi@vger.kernel.org>; Tue, 19 Oct 2021 05:13:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20211019051351epoutp015d83424320d48a6fed1a9009444fa102~vVp9D6jUI0284202842epoutp01Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1634620431;
        bh=FudOjlJ6D5/jgTmPY1C0mRqJku+8iiIy7TKFbhuwvBU=;
        h=From:To:Cc:Subject:Date:References:From;
        b=DfrClabvTRZuGSLqQiTG1++WjfeX0oIeISNklJRwPgajGmvDZ2bp2pIWYUr/bRL2H
         tRMSRgvz46dcuoyK1AstuE2Yc0YYfO2AOehnVPiUAy+6dQprdOGsuKOtpoZJqXM9dc
         dBNGPRExJ1uH18+djelnMoacXNOVbNHkFfUDF7no=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20211019051351epcas2p375e0ce61f07998c0ca20b5eaf3cda0cf~vVp8aVj5h1667916679epcas2p35;
        Tue, 19 Oct 2021 05:13:51 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.99]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4HYMND5qrKz4x9Qg; Tue, 19 Oct
        2021 05:13:48 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        28.60.09868.B045E616; Tue, 19 Oct 2021 14:13:47 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20211019051346epcas2p132d3b9c6a1c812f3132e913525235b83~vVp4bTQv01527115271epcas2p18;
        Tue, 19 Oct 2021 05:13:46 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20211019051346epsmtrp16f44d9fc87cdc94baa573b6e580f2cf5~vVp4aZ3HT1490514905epsmtrp1B;
        Tue, 19 Oct 2021 05:13:46 +0000 (GMT)
X-AuditID: b6c32a45-9a3ff7000000268c-6b-616e540bc644
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        94.86.08738.A045E616; Tue, 19 Oct 2021 14:13:46 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20211019051346epsmtip2dbf70093c25cbf90ac11d95b3f0a8eac~vVp4I7RVn0229902299epsmtip2X;
        Tue, 19 Oct 2021 05:13:46 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        cang@codeaurora.org, adrian.hunter@intel.com, sc.suh@samsung.com,
        hy50.seo@samsung.com, sh425.lee@samsung.com,
        bhoon95.kim@samsung.com, vkumar.1997@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH RESEND v2] scsi: ufs: clear doorbell for hibern8 errors when
 using ah8
Date:   Tue, 19 Oct 2021 13:57:07 +0900
Message-Id: <1634619427-171880-1-git-send-email-kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmk+LIzCtJLcpLzFFi42LZdljTQpc7JC/R4P5vPouTT9awWTyYt43N
        4uXPq2wWBx92slh8XfqM1eLT+mWsFqsXP2CxWHRjG5PFzS1HWSwu75rDZtF9fQebxfLj/5gs
        uu7eYLRY+u8ti8Wd+x9ZHPg9Lvf1Mnks3vOSyWPCogOMHt/Xd7B5fHx6i8Wjb8sqRo/Pm+Q8
        2g90MwVwRGXbZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl
        5gBdr6RQlphTChQKSCwuVtK3synKLy1JVcjILy6xVUotSMkpMC/QK07MLS7NS9fLSy2xMjQw
        MDIFKkzIzlh14hJLwXOeisZ1R5gaGA9xdTFyckgImEjMWnKKqYuRi0NIYAejxPcNk9kgnE+M
        Ekcu/2WFcD4zSkzffo0VpuXfy5vMILaQwC5Gif2vnSGKfjBKLFvQBpZgE9CUeHpzKhOILSJw
        nUli3vYMEJtZQF1i14QTYHFhgQiJ269+sHcxcnCwCKhKHFgbBhLmFXCT+HFqJyPELjmJm+c6
        mUHmSwg0ckhc6NrNDFIvIeAisbVZC6JGWOLV8S3sELaUxMv+Nii7XmLf1AZWiN4eRomn+/5B
        DTWWmPWsnRFkDjPQnet36UOMVJY4cosF4ko+iY7Df9khwrwSHW1CEI3KEr8mTYYaIikx8+Yd
        qE0eEu8+XgEbKCQQK3HkotAERtlZCOMXMDKuYhRLLSjOTU8tNiowhMdQcn7uJkZwatRy3cE4
        +e0HvUOMTByMhxglOJiVRHiTXHMThXhTEiurUovy44tKc1KLDzGaAgNrIrOUaHI+MDnnlcQb
        mlgamJiZGZobmRqYK4nzWopmJwoJpCeWpGanphakFsH0MXFwSjUwJS2J/GF0Y1K61InVag+m
        ne730ma29ujZ2dxqeHRZ8dMFF34928Rn5N2yOXZq7InZ+v9f/M//1si85ujKft2XSY2mGm8O
        cD6+vnN71uzz3VnvfOrtmzSCon8VPtLp/q9hxXmsvUBv5upJZwrP3DpRbSCy66Tekdtrd+mt
        fME0gXHZsU4j1Y/HrBbLMVpMXvy86/O3v+xpl/SmLtybbh+gt7psd1dDaInk46BmgZzDiy5N
        XD+d6RXn1D2iDv90/A18zZrspHIZT968xR56pf+fUOh7eROtvsBl5TvlY+dKaU4+esq+IvXr
        dve6adsjGH2jp/7bM+G4c83VlsNSFS5p1WZHNG90Zelefqz/6h6DvRJLcUaioRZzUXEiAMC8
        yu4WBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsWy7bCSvC5XSF6iwcxr6hYnn6xhs3gwbxub
        xcufV9ksDj7sZLH4uvQZq8Wn9ctYLVYvfsBisejGNiaLm1uOslhc3jWHzaL7+g42i+XH/zFZ
        dN29wWix9N9bFos79z+yOPB7XO7rZfJYvOclk8eERQcYPb6v72Dz+Pj0FotH35ZVjB6fN8l5
        tB/oZgrgiOKySUnNySxLLdK3S+DKWHXiEkvBc56KxnVHmBoYD3F1MXJySAiYSPx7eZMZxBYS
        2MEosf4PD0RcUuLEzueMELawxP2WI6xdjFxANd8YJR5/PckKkmAT0JR4enMqE0hCROAlk8SL
        OWvYQBLMAuoSuyacYAKxhQXCJLbtnQsU5+BgEVCVOLA2DCTMK+Am8ePUTqgFchI3z3UyT2Dk
        WcDIsIpRMrWgODc9t9iwwCgvtVyvODG3uDQvXS85P3cTIzhktbR2MO5Z9UHvECMTB+MhRgkO
        ZiUR3iTX3EQh3pTEyqrUovz4otKc1OJDjNIcLErivBe6TsYLCaQnlqRmp6YWpBbBZJk4OKUa
        mMx87XxYT0ucTDRdrHXbtPHw6X7p/gZNhhzduy5vwpb5Hgl6avDq2cwwBYvHkpdMZ4cLMXY+
        ebqOpfaJQLFC649jlRpMlnVLJp2dsvXfi5s58VMOdrIKNJy89KA3eqFdVp647bdQId6w0HUW
        Flo5V1dqSnZejYgVilohnDVl15TNMz4VxJzd2iopfDBH+VDZ/0Mdy2a922VcrPiqdYIZs07t
        QQtjN2WNzhKmqV4r7cqS94pvXHH13f/PthGtfNfb2/xUVjT7LAjxuMTbLFJlsLY+jeHhhQk3
        ZNpeK89+Fttbb2O69Bj/zq7VhVuDM/Nb5j0y6yxyci3uYovKOeT2jPPhIYdbf9O4AsPVjzQq
        sRRnJBpqMRcVJwIAqD+7pMgCAAA=
X-CMS-MailID: 20211019051346epcas2p132d3b9c6a1c812f3132e913525235b83
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211019051346epcas2p132d3b9c6a1c812f3132e913525235b83
References: <CGME20211019051346epcas2p132d3b9c6a1c812f3132e913525235b83@epcas2p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Changes from v1:
* Change the time to requeue pended commands

When an scsi command is dispatched right after host complete
all the pended requests and ufs driver tries to ring a doorbell,
host might be still during entering into hibern8.
If the hibern8 error occurrs during that period, the doorbell
might not be zero and clearing it should have done.
But, current ufshcd_err_handler goes directly to reset
w/o clearing the doorbell when the driver's link state is broken.
This patch is to requeue pended commands after host reset.

Here's an actual symptom that I've faced. At the time, tag #17
is still pended even after host reset. And then the block timer
is expired.

exynos-ufs 11100000.ufs: ufshcd_check_errors: Auto Hibern8
Enter failed - status: 0x00000040, upmcrs: 0x00000001
..
host_regs: 00000050: b8671000 00000008 00020000 00000000
..
exynos-ufs 11100000.ufs: ufshcd_abort: Device abort task at tag 17

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 9faf02c..e5d4ef7 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7136,8 +7136,10 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
 	err = ufshcd_hba_enable(hba);
 
 	/* Establish the link again and restore the device */
-	if (!err)
+	if (!err) {
+		ufshcd_retry_aborted_requests(hba);
 		err = ufshcd_probe_hba(hba, false);
+	}
 
 	if (err)
 		dev_err(hba->dev, "%s: Host init failed %d\n", __func__, err);
-- 
2.7.4

