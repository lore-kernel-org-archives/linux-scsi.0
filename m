Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD8EEC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 03:31:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BA7F60F5E
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 03:31:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236610AbhJHDdm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 23:33:42 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:56314 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234904AbhJHDdl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 23:33:41 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20211008033144epoutp02bb9179b14069126b941d2f91d3e94961~r8Kp1gWrJ1997619976epoutp02K
        for <linux-scsi@vger.kernel.org>; Fri,  8 Oct 2021 03:31:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20211008033144epoutp02bb9179b14069126b941d2f91d3e94961~r8Kp1gWrJ1997619976epoutp02K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1633663904;
        bh=FudOjlJ6D5/jgTmPY1C0mRqJku+8iiIy7TKFbhuwvBU=;
        h=From:To:Cc:Subject:Date:References:From;
        b=Tr4vZq+zNOIrpucjVaFOaHXdBdAwUdHArIzACoscc2BJ60ws/x1uTkrwecBZja4iS
         r0H+AL+q58ujYasBZwbvfvFZ58K8bQxk7o3bLzWwVhFa2fUgvu1hQB/Y4skgC+c+N8
         +B4n6Vl1hJ4uIaazNTNTv/KY8jKT0PnVkySikSj8=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20211008033144epcas2p19ddeaebee39c621b595b9390350189ff~r8KpMTLt52405824058epcas2p1k;
        Fri,  8 Oct 2021 03:31:44 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.91]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4HQYdS4Pq5z4x9Q0; Fri,  8 Oct
        2021 03:31:40 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        28.22.09717.A9BBF516; Fri,  8 Oct 2021 12:31:38 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20211008033133epcas2p27e537eb6140c01dadcf8f75785a238de~r8Ke5UU7K0569305693epcas2p2L;
        Fri,  8 Oct 2021 03:31:33 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20211008033133epsmtrp2a8d2a4b7035012b7829bb17aa9ca62ae~r8Ke8zC1t0420904209epsmtrp2J;
        Fri,  8 Oct 2021 03:31:33 +0000 (GMT)
X-AuditID: b6c32a45-a3131a80000025f5-e3-615fbb9ac33f
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        38.99.08750.59BBF516; Fri,  8 Oct 2021 12:31:33 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20211008033132epsmtip159db4b2633c17bf5d800ab754826f2e4~r8KeqTpWs0568105681epsmtip1W;
        Fri,  8 Oct 2021 03:31:32 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        cang@codeaurora.org, adrian.hunter@intel.com, sc.suh@samsung.com,
        hy50.seo@samsung.com, sh425.lee@samsung.com,
        bhoon95.kim@samsung.com, vkumar.1997@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v2] scsi: ufs: clear doorbell for hibern8 errors when using
 ah8
Date:   Fri,  8 Oct 2021 12:15:08 +0900
Message-Id: <1633662908-20941-1-git-send-email-kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnk+LIzCtJLcpLzFFi42LZdljTQnfW7vhEgzuP+SxOPlnDZvFg3jY2
        i5c/r7JZHHzYyWLxdekzVotP65exWqxe/IDFYtGNbUwWN7ccZbG4vGsOm0X39R1sFsuP/2Oy
        6Lp7g9Fi6b+3LBZ37n9kceD3uNzXy+SxeM9LJo8Jiw4wenxf38Hm8fHpLRaPvi2rGD0+b5Lz
        aD/QzRTAEZVtk5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuW
        mQN0vZJCWWJOKVAoILG4WEnfzqYov7QkVSEjv7jEVim1ICWnwLxArzgxt7g0L10vL7XEytDA
        wMgUqDAhO2PViUssBc95KhrXHWFqYDzE1cXIySEhYCKx48xvti5GLg4hgR2MEt0Hl7JCOJ8Y
        Jc4ePs4I4XxmlDg2+zE7TMuKrh4miMQuRokPzf+ZIZwfQC0npzOCVLEJaEo8vTmVCcQWEbjO
        JDFvewaIzSygLrFrwgmwuLBAoMTF/5vB6lkEVCX61k8Ai/MKuEqcaLrDBrFNTuLmuU6wBRIC
        f9kl5u/9zASRcJH4d/MIM4QtLPHq+Bao86QkPr/bC9VcL7FvagMrRHMPo8TTff8YIRLGErOe
        tQPZHEAXaUqs36UPYkoIKEscucUCcSefRMfhv+wQYV6JjjYhiEZliV+TJkMNkZSYefMO1FYP
        iZlvboJdJiQQK7HpzCy2CYyysxDmL2BkXMUollpQnJueWmxUYAiPpeT83E2M4BSp5bqDcfLb
        D3qHGJk4GA8xSnAwK4nw5tvHJgrxpiRWVqUW5ccXleakFh9iNAWG10RmKdHkfGCSziuJNzSx
        NDAxMzM0NzI1MFcS5537zylRSCA9sSQ1OzW1ILUIpo+Jg1OqgSk9YpL6HeU0T6mVitMqq1XW
        5su2Cy/ZvGWF2THvwAepa/Oz52s5/OernvrnwzUWxzeWJVcX7xbaGnZsvbawu4Slwuq5msJP
        jzA6rEwNundBNjlqwYXzE+tzW0tNLn/9Zp4zX0yfR9621cOOX66mzULZa6sYc9fV4hNBATef
        lOVFxn0v22zCe67z1cJF4rP2W8kG/skp1N3/oCL74OYFHZ/cQ7zddFwOOeb77vjAYJpy0Ej2
        gt5clSNvnxQlPeroXJqz8nKW6bMP83gCZt3NFTe/e7f4evir2RasHp9NC/rSklj+pValHNSQ
        N1r27Gjs+qvbJ+lV6XRs7Y/r36l4/OYrpbWLWtj+v0m3dt7Aq8RSnJFoqMVcVJwIAOCRNk0a
        BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOLMWRmVeSWpSXmKPExsWy7bCSnO7U3fGJBqva9CxOPlnDZvFg3jY2
        i5c/r7JZHHzYyWLxdekzVotP65exWqxe/IDFYtGNbUwWN7ccZbG4vGsOm0X39R1sFsuP/2Oy
        6Lp7g9Fi6b+3LBZ37n9kceD3uNzXy+SxeM9LJo8Jiw4wenxf38Hm8fHpLRaPvi2rGD0+b5Lz
        aD/QzRTAEcVlk5Kak1mWWqRvl8CVserEJZaC5zwVjeuOMDUwHuLqYuTkkBAwkVjR1cPUxcjF
        ISSwg1Fi2vRvTBAJSYkTO58zQtjCEvdbjrBCFH1jlDi5dRVYgk1AU+Lpzalg3SICL5kkXsxZ
        wwaSYBZQl9g14QTYJGEBf4ktH/vBGlgEVCX61k8Ai/MKuEqcaLrDBrFBTuLmuU7mCYw8CxgZ
        VjFKphYU56bnFhsWGOWllusVJ+YWl+al6yXn525iBIetltYOxj2rPugdYmTiYDzEKMHBrCTC
        m28fmyjEm5JYWZValB9fVJqTWnyIUZqDRUmc90LXyXghgfTEktTs1NSC1CKYLBMHp1QDk2qw
        //yee0ZlR0R3PXULdz3/o/CErrF1UGAoz47fKsw/v3TsrUxevZqz3rVfuOpQzo6+/Tf//dkr
        FaMjfiD8+d7JnoW1PO/Nj0beO7Xms3q5+zRjte5rHzYaFohsctvWEbHvzL+Xy/niL5zJSPra
        nu9dwpl/xf2p2FEBxtQTi84pKs1aeUFD+Ddza0BYPOvrnX8Ckmqz9RZWHHI0uHfQzuHWola2
        B4sCD8541vp176bbZktenbdrXzN98bKdZr9ndMWeXWjYbNalbLA2NuDKw65YLu2mf7PDzn99
        ndI4+zC/myOD3K7Yk2uun3lXJ698Ot0qTf+k/UW3GM6vrTH2S5JSb/D17/u6+vKXf52LhJRY
        ijMSDbWYi4oTAYb2divKAgAA
X-CMS-MailID: 20211008033133epcas2p27e537eb6140c01dadcf8f75785a238de
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211008033133epcas2p27e537eb6140c01dadcf8f75785a238de
References: <CGME20211008033133epcas2p27e537eb6140c01dadcf8f75785a238de@epcas2p2.samsung.com>
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

