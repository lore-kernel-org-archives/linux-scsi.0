Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 642F7C433E9
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 01:50:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26BBF64FB0
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 01:50:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232977AbhBEBtw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Feb 2021 20:49:52 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:55069 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbhBEBtv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2021 20:49:51 -0500
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210205014907epoutp02817b45fd1adc8bc16d1eea3b5a670f5c~gtuHZssIe0979809798epoutp02H
        for <linux-scsi@vger.kernel.org>; Fri,  5 Feb 2021 01:49:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210205014907epoutp02817b45fd1adc8bc16d1eea3b5a670f5c~gtuHZssIe0979809798epoutp02H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1612489747;
        bh=C3dFxkK0kWLNWz5MmIHloF9lErrhh6j/ok64cvvAl6Y=;
        h=From:To:Cc:Subject:Date:References:From;
        b=tzdtumFK+qFsVNc+cpo0LFkdecvugofx3jXuVHzEwAhsbiOPnYor69ia5LMG7cZxX
         Ly7zEXx1Fr4KLGyvXw9liKMdyVabAnyU9eu+WwZXCuF3xYAFo4iZAjNhaIQTuKe0/t
         5V428HP4g3i5qzex1qEg0uFq9Dam5gniGjmHcF/k=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210205014906epcas1p1c5de1d16e2db96a8c052ac6d86425dcd~gtuF-tdVi2357423574epcas1p1T;
        Fri,  5 Feb 2021 01:49:06 +0000 (GMT)
Received: from epsmges1p2.samsung.com (unknown [182.195.40.164]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4DWyy94czmz4x9Q2; Fri,  5 Feb
        2021 01:49:05 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
        epsmges1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        03.39.63458.114AC106; Fri,  5 Feb 2021 10:49:05 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210205014904epcas1p1b8cf04408ff6f5ef9ebd5c95b8a99f27~gtuESkyz52605026050epcas1p1I;
        Fri,  5 Feb 2021 01:49:04 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210205014904epsmtrp1feb7e5e70a6523803e15fa9afaf27abf~gtuERSRcE0437704377epsmtrp1X;
        Fri,  5 Feb 2021 01:49:04 +0000 (GMT)
X-AuditID: b6c32a36-6dfff7000000f7e2-47-601ca4111fa3
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D9.E8.13470.014AC106; Fri,  5 Feb 2021 10:49:04 +0900 (KST)
Received: from localhost.localdomain (unknown [10.253.101.61]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210205014904epsmtip208ab073b333c2de67fe4bd3835b2fe17~gtuD_Hlv30103001030epsmtip2C;
        Fri,  5 Feb 2021 01:49:04 +0000 (GMT)
From:   DooHyun Hwang <dh0421.hwang@samsung.com>
To:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, asutoshd@codeaurora.org, beanhuo@micron.com,
        jaegeuk@kernel.org, adrian.hunter@intel.com, satyat@google.com
Cc:     grant.jung@samsung.com, jt77.jang@samsung.com,
        junwoo80.lee@samsung.com, jangsub.yi@samsung.com,
        sh043.lee@samsung.com, cw9316.lee@samsung.com,
        sh8267.baek@samsung.com, wkon.kim@samsung.com,
        DooHyun Hwang <dh0421.hwang@samsung.com>
Subject: [PATCH 1/3] scsi: ufs: retry link startup if that fails and device
 state is not active
Date:   Fri,  5 Feb 2021 10:36:31 +0900
Message-Id: <20210205013633.16243-1-dh0421.hwang@samsung.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Tf1BUVRSe+97btytI81wMbzsUuEQMILgLLF5RLInwjTpBWkxT0PIGXkAt
        uzv7lsaaaiSJXwsuoMwIESFYJGJMG9AuLqCLCmsUkyCJJeiEClL8DFATancfTfz3ne9855x7
        vnuvCBffIyWiTLWe1akZlZR0I9q6A0NDNpzyTpGN5vgh+1gTiW7VtJGoI69XiCYeXiPRhduF
        BJpr/kqATlzJE6DOIbsQPVpuFqKx5iocFbQew1Dd9TYMme/1CVH78hEMDbRXk8jwi5lEDT0r
        GDKeuUmiTx53Emior1eAvmwdBui7q4vEC170wNESjK41ZdP11gmMNjUWknRp3XlA59q7CHqp
        uYCkZ+/cIOijLY2Anjc9Q+efN2AJ7m+odmawTBqr82XVqZq0THV6tHTfQeWLSkWkTB4i3462
        SX3VTBYbLY3dnxASl6lyrCv1fY9RZTuoBIbjpFt37dRpsvWsb4aG00dLWW2aSiuXaUM5JovL
        VqeHpmqyouQyWZjCoUxRZSxcHALaadGhhV/L8MOgWFgERCJIRcChTkERcBOJKTOAdblLGB/M
        AfjF4PXVYBHArpYLZBFY56oY+aeS5BMdAC5f6yecCTE1D+CJkWQnJqlQaC1pdPXdSHVi8LfT
        Xa5WODUL4Mkbk65WnhQDl/orcCcmKH/4Y36RwIk9qGg4Zi8h+HE+8PFoMc7zG6C9cszF4w7+
        SOtnOK8ZF8GbF4N5HAuraysxHnvC+z0tQh5L4IQxbxUbADTadjkPBKlSAAd6ild3C4dz8/PA
        6QxOBcLm9q08vRla/v4c8HOfgFMLxQLePA9YkCfmJc/B+pUlh0TowN4wx51naXi249KqPclw
        qnxEUAp8qtbsUrVml6r/x9YCvBF4sVouK53l5NqwtXdqAq4XHxRpBuV/zoTaACYCNgBFuHSj
        B5MnSRF7pDHvf8DqNEpdtorlbEDhcLcMlzyZqnF8GbVeKVeEhYeHo4jIbZGKcOkmD0Z2Symm
        0hk9+y7Lalndf3WYaJ3kMFZfEE/i/q/FFOn9p85NDJb9/urX3zJg0eJXPB1oV0ZY97wVZYrZ
        Xgo7diz8caD8imfCHBnXrv7+wMFuq1tcb8A3g0224EX/U6+Pa7iktvjRmsTj5KzFuKXCPFod
        8DCp4efWAnP8pZd/kNxdX50ormnoMz+f+2BLzszexMlj9y1xPoXGj+pO7676VLTXvYY0rM8I
        Hjn7lyZK+IA7vt/AxJwxJE9O+Od/SLTvK0+9fMho2gH7A5ouKzZZOoKmvMUWv0SbyWt889Wn
        Jh+9mfL0no+1b1vSuG7DlDrTas1Z0rHP/jRMTMzfqTnZdTtiZqX6ldRSG3s3JibgpZaAc+8k
        DVdMx+6WElwGIw/CdRzzL0Y98w16BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBIsWRmVeSWpSXmKPExsWy7bCSvK7AEpkEg71n+S1OPlnDZvFg3jY2
        i71tJ9gtXv68ymZx8GEni8Wn9ctYLWacamO12HftJLvFr7/r2S2erJ/FbNGxdTKTxaIb25gs
        djw/w26x628zk8XlXXPYLLqv72CzWH78H5NF/+q7bBZNf/axWFw7c4LVYunWm4wWmy99Y3EQ
        87jc18vksWBTqcfiPS+ZPDat6mTzmLDoAKNHy8n9LB7f13eweXx8eovFo2/LKkaPz5vkPNoP
        dDMFcEdx2aSk5mSWpRbp2yVwZXw9co2x4D1HxdfbE5kbGHvYuxg5OSQETCTu/Z/J1sXIxSEk
        sJtRYvn3pSwQCRmJ7vt7gYo4gGxhicOHiyFqPjJKrN/0FKyZTUBPYk/vKlaQhIjAOSaJ2/OW
        MII4zAK/GSUm/WgGqxIWiJfoXN8CZrMIqEqcbe9iBbF5BWwlnpzshdomL/Hnfg8zRFxQ4uTM
        J2BxZqB489bZzBMY+WYhSc1CklrAyLSKUTK1oDg3PbfYsMAwL7Vcrzgxt7g0L10vOT93EyM4
        8rQ0dzBuX/VB7xAjEwfjIUYJDmYlEd7ENqkEId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwXuk7G
        CwmkJ5akZqemFqQWwWSZODilGpg456lpq7JuV/7goV2dzbEz3/1z6ImTUezOE1KZlt6+lcki
        cfZRXaKexAapCxcqftf+8+td8NpUerMK++0L1x/4Gt96tc1+ZV1wulu1S7kHx9Yrp1liFyVG
        zztSHuT36Piq4/dWvp1+OGbqver37FXbg2UnH9a4/Xxx9dEwp6q5eoZ2n9//WP/rETf3i3me
        yUVbCn3ZvGN33sz8Y+RnG3iq6IDOE/V3YT+fLNO60jHBLVTqbPD0rvNHeJdW3+MUPLZeWfN1
        0g7PtM2vOk5MdJJUWtwV3HD6bklU6ebd6t4F4qm5s2Tmz19WOHfPMqaL0gbsz6K+zJPgiPqh
        wPb85evXHdqlZ5LPeSvph3kpTDmgxFKckWioxVxUnAgA1EmFUSsDAAA=
X-CMS-MailID: 20210205014904epcas1p1b8cf04408ff6f5ef9ebd5c95b8a99f27
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210205014904epcas1p1b8cf04408ff6f5ef9ebd5c95b8a99f27
References: <CGME20210205014904epcas1p1b8cf04408ff6f5ef9ebd5c95b8a99f27@epcas1p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove unnecessary link startup command if it was completed.

UniPro stack is reset and enabled when ufshc is enabled.
The link startup command is issued after enabling ufshc,
if link startup is completed, there is no needed to issue again.

Signed-off-by: DooHyun Hwang <dh0421.hwang@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 721f55db181f..286f7c918f0e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4642,13 +4642,13 @@ static int ufshcd_link_startup(struct ufs_hba *hba)
 		ufshcd_update_evt_hist(hba,
 				       UFS_EVT_LINK_STARTUP_FAIL,
 				       (u32)ret);
-		goto out;
-	}
 
-	if (link_startup_again) {
-		link_startup_again = false;
-		retries = DME_LINKSTARTUP_RETRIES;
-		goto link_startup;
+		if (link_startup_again) {
+			link_startup_again = false;
+			retries = DME_LINKSTARTUP_RETRIES;
+			goto link_startup;
+		}
+		goto out;
 	}
 
 	/* Mark that link is up in PWM-G1, 1-lane, SLOW-AUTO mode */
-- 
2.29.0

