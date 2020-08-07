Return-Path: <SRS0=GwgI=BR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56CECC433DF
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Aug 2020 07:01:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EA3E20866
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Aug 2020 07:01:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="AZmQ4EPv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbgHGHBj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Aug 2020 03:01:39 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:63476 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgHGHBe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Aug 2020 03:01:34 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200807070125epoutp02605cf7787f475294f78136fb523f4da4~o6k0rz8Ry3217432174epoutp02S
        for <linux-scsi@vger.kernel.org>; Fri,  7 Aug 2020 07:01:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200807070125epoutp02605cf7787f475294f78136fb523f4da4~o6k0rz8Ry3217432174epoutp02S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1596783685;
        bh=ZnUNVIsgVf6GOO20ss6OX5j8BHWnWscPqwY9BTp1AF8=;
        h=From:To:Cc:Subject:Date:References:From;
        b=AZmQ4EPv308cMsl4ogYMIxwMqdkuW5NkwFIKJYw161it4vg/QUe68cihzjUtHnREa
         Lahdj/JREjgRyWPi5fCexA8e7/VQ91pKMAWTzSni+8tHJzIvoPIh8iqAvR0MKMKc7o
         fcpX2vG95FcK7FqSjER17V1cT8PNH32xKJk4RDfg=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20200807070124epcas2p47744705c4b69c39129de918a8a6c2d04~o6kz-btZl1808018080epcas2p4V;
        Fri,  7 Aug 2020 07:01:24 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.191]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4BNGVV2B5dzMqYkc; Fri,  7 Aug
        2020 07:01:22 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        92.E8.18874.04CFC2F5; Fri,  7 Aug 2020 16:01:20 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20200807070119epcas2p198639f0b065c97baf2b9bae231ec137b~o6kv2G_iw1280212802epcas2p1i;
        Fri,  7 Aug 2020 07:01:19 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200807070119epsmtrp2ddd25e639e6acbcd79ef6e6957a298b9~o6kv0wwOM0180401804epsmtrp2V;
        Fri,  7 Aug 2020 07:01:19 +0000 (GMT)
X-AuditID: b6c32a46-503ff700000049ba-90-5f2cfc40141c
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        E4.F1.08303.F3CFC2F5; Fri,  7 Aug 2020 16:01:19 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200807070119epsmtip2a006e9e158f203d1c52d44dac629c1d5~o6kvnhy300449804498epsmtip2Y;
        Fri,  7 Aug 2020 07:01:19 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v1] ufs: change the way to complete fDeviceInit
Date:   Fri,  7 Aug 2020 15:52:56 +0900
Message-Id: <1596783176-183741-1-git-send-email-kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42LZdljTVNfhj068wZLvnBYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCxubjnKYtF9fQebxfLj/5gs
        uu7eYLRY+u8tiwOfx+Ur3h6X+3qZPCYsOsDo8X19B5vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBH
        VI5NRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtDdSgpl
        iTmlQKGAxOJiJX07m6L80pJUhYz84hJbpdSClJwCQ8MCveLE3OLSvHS95PxcK0MDAyNToMqE
        nIyfJ6czF1wQqHje49TAuJa3i5GTQ0LARGL17U3MXYxcHEICOxgl7myezwThfGKUWDRtISuE
        85lR4vW7j8wwLcsOPWODSOxilOi9ux6q5QejRNfjTiaQKjYBTYmnN6eCJUQENjNJvFpwH6yd
        WUBdYteEE2BFwgL2EjsWbmUFsVkEVCV2HF4NZvMKuElMPfGRHWKdnMTNc51gF0oI/GSXuPhk
        BhNEwkWiZ+V8NghbWOLV8S1QDVISn9/thYrXS+yb2sAK0dzDKPF03z9GiISxxKxn7UA2B9BF
        mhLrd+mDmBICyhJHbrFA3Mkn0XH4LztEmFeio00IolFZ4tekyVBDJCVm3rwDtdVDovXVXzBb
        SCBW4tvq+2wTGGVnIcxfwMi4ilEstaA4Nz212KjACDmWNjGCE6OW2w7GKW8/6B1iZOJgPMQo
        wcGsJMKb9UI7Xog3JbGyKrUoP76oNCe1+BCjKTC8JjJLiSbnA1NzXkm8oamRmZmBpamFqZmR
        hZI4b73ihTghgfTEktTs1NSC1CKYPiYOTqkGJoYXf9rWtj9uWNXtUdPxr+NGyNkzOpc9NISs
        +vrv7vnd/Zzn294P7JJ7Oc/vt1R9+02Lr1dw1s83Fl2ZoQqbDxXNfMpW+O1vFNthyzBt6VUM
        Z3ZXqdj7MAnstd60Xvr5y1P+lz7bzLp3+12RS/vjm1lTTyzU+rv1Vf9GEfautqMqhZPWH53o
        1ik847aXFF+H/cRJp1xu7Hw4Q/PD5Vtu7P9/HCx+JcnrEPNi9p/Db/mZjWYc1Ev/+cBZOKE7
        U9Vvy+GVv456luUe80k8ms8sK1Y4+zL3vqR7E7oXXZq62eLPmb3dKUJhVqVZya0z043F/9wI
        vnZo31yR2js8R08eXtoYpd5/ZLv//4TalI8a+xcosRRnJBpqMRcVJwIAz1HCaxUEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsWy7bCSvK79H514g6lb9CwezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usXrxAxaLRTe2MVnc3HKUxaL7+g42i+XH/zFZ
        dN29wWix9N9bFgc+j8tXvD0u9/UyeUxYdIDR4/v6DjaPj09vsXj0bVnF6PF5k5xH+4FupgCO
        KC6blNSczLLUIn27BK6MnyenMxdcEKh43uPUwLiWt4uRk0NCwERi2aFnbF2MXBxCAjsYJVqv
        7mGESEhKnNj5HMoWlrjfcoQVougbo8SSS4uZQRJsApoST29OZQJJiAgcZpL4v/U5O0iCWUBd
        YteEE0wgtrCAvcSOhVtZQWwWAVWJHYdXg9m8Am4SU098ZIfYICdx81wn8wRGngWMDKsYJVML
        inPTc4sNC4zyUsv1ihNzi0vz0vWS83M3MYIDVUtrB+OeVR/0DjEycTAeYpTgYFYS4c16oR0v
        xJuSWFmVWpQfX1Sak1p8iFGag0VJnPfrrIVxQgLpiSWp2ampBalFMFkmDk6pBibNr6aLF54J
        facxOf6xk1XhrAmBkrIVIl+1Y7e78ejOvq2QOGV9VnXDpzUd2y89iM6xzqudtIKn8Emo5qEE
        o8pwkTq5d5IWTlXCz76c/vch9bSlSIr9t5dili9/qX10jlRbN+mZcMnbkuOrGLN+cEdyRcpc
        5Wp3rWrr+V7w1dF6W8GjlNhwvgd2V/lnTL1m4Jw2P+zgt6WnNkRybNY6bZ75kb29UTXIOZbX
        U2uf5a2JE/PXrm8IT16fsJ1zvRe/p/kfxpuhG85NXZ2+dvPKhY8Vg8/Enur64XOO5YHOhffr
        Pdk4RRRrrHufp94WWFosI75v/+6FEboumqvX3jihX3Ftwsn76jc+VryO23HmaoQSS3FGoqEW
        c1FxIgAT+4nowwIAAA==
X-CMS-MailID: 20200807070119epcas2p198639f0b065c97baf2b9bae231ec137b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200807070119epcas2p198639f0b065c97baf2b9bae231ec137b
References: <CGME20200807070119epcas2p198639f0b065c97baf2b9bae231ec137b@epcas2p1.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently, UFS driver checks if fDeviceInit
is cleared at several times, not period. This patch
is to wait its completion with the period, not retrying.
Many device vendors usually provides the specification on
it with just period, not a combination of a number of retrying
and period. So it could be proper to regard to the information
coming from device vendors.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 092480a..c508931 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4148,7 +4148,8 @@ EXPORT_SYMBOL_GPL(ufshcd_config_pwr_mode);
  */
 static int ufshcd_complete_dev_init(struct ufs_hba *hba)
 {
-	int i;
+	u32 dev_init_compl_in_ms = 1500;
+	unsigned long timeout;
 	int err;
 	bool flag_res = true;
 
@@ -4161,20 +4162,26 @@ static int ufshcd_complete_dev_init(struct ufs_hba *hba)
 		goto out;
 	}
 
-	/* poll for max. 1000 iterations for fDeviceInit flag to clear */
-	for (i = 0; i < 1000 && !err && flag_res; i++)
-		err = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_READ_FLAG,
-			QUERY_FLAG_IDN_FDEVICEINIT, 0, &flag_res);
+	/* Poll fDeviceInit flag to be cleared */
+	timeout = jiffies + msecs_to_jiffies(dev_init_compl_in_ms);
+	do {
+		err = ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_READ_FLAG,
+					QUERY_FLAG_IDN_FDEVICEINIT, 0, &flag_res);
+		if (!flag_res)
+			break;
+		usleep_range(5000, 10000);
+	} while (time_before(jiffies, timeout));
 
-	if (err)
+	if (err) {
 		dev_err(hba->dev,
-			"%s reading fDeviceInit flag failed with error %d\n",
-			__func__, err);
-	else if (flag_res)
+				"%s reading fDeviceInit flag failed with error %d\n",
+				__func__, err);
+	} else if (flag_res) {
 		dev_err(hba->dev,
-			"%s fDeviceInit was not cleared by the device\n",
-			__func__);
-
+				"%s fDeviceInit was not cleared by the device\n",
+				__func__);
+		err = -EBUSY;
+	}
 out:
 	return err;
 }
-- 
2.7.4

