Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 302D7EE7FF4
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Sep 2023 06:01:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234289AbjIKGBH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 02:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234288AbjIKGBF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 02:01:05 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D8DCD2;
        Sun, 10 Sep 2023 23:00:58 -0700 (PDT)
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38B5iYfV026956;
        Mon, 11 Sep 2023 06:00:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=qcppdkim1;
 bh=G6KhS/41CnEp4pd00YTwr0gP5hZO7WDTthOGelST+0w=;
 b=kj2I0Rj5rqMoYJSg7qiVJpZGerZkIfdMge9m27A2V2arGlvK+r8vru83JOcZ1yd+2z6t
 Lx/57mjb+2g4nGfcNOCgjQyXGdadWBxdqk2MjjXM5m8E3i3nnvB96o67gQpDnBdP658S
 Id8zr9j7TlK8snpVyRCr0yCGpp5k1DW748DvQykLko+uLss6yckFh/TGIdrCF9DpCDep
 vW/37wi+imebiQ5wHiDz5oyy21i+qtBWtwwkTKmCGJIfsbNlSvOgmiXDljpXEn1Ef/S6
 0msJUIohyWmiIKqbUaXoR2xvBK1xHr+mCNm9OfvyuabsLGdjpyG3hJLKuTAbSEdCET4B WA== 
Received: from nasanppmta01.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3t0edmk1ap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Sep 2023 06:00:52 +0000
Received: from pps.filterd (NASANPPMTA01.qualcomm.com [127.0.0.1])
        by NASANPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 38B60Ncv021160;
        Mon, 11 Sep 2023 06:00:51 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by NASANPPMTA01.qualcomm.com (PPS) with ESMTP id 3t0ht30048-1;
        Mon, 11 Sep 2023 06:00:51 +0000
Received: from NASANPPMTA01.qualcomm.com (NASANPPMTA01.qualcomm.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38B60pes021538;
        Mon, 11 Sep 2023 06:00:51 GMT
Received: from stor-dylan.qualcomm.com (stor-dylan.qualcomm.com [192.168.140.207])
        by NASANPPMTA01.qualcomm.com (PPS) with ESMTP id 38B60p2w021537;
        Mon, 11 Sep 2023 06:00:51 +0000
Received: by stor-dylan.qualcomm.com (Postfix, from userid 359480)
        id D7FDC20DEF; Sun, 10 Sep 2023 23:00:50 -0700 (PDT)
From:   Can Guo <quic_cang@quicinc.com>
To:     quic_cang@quicinc.com, mani@kernel.org, quic_nguyenb@quicinc.com,
        quic_nitirawa@quicinc.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>, Lu Hongfei <luhongfei@vivo.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 6/6] scsi: ufs: ufs-sysfs: Introduce UFS power info sysfs nodes
Date:   Sun, 10 Sep 2023 22:59:27 -0700
Message-Id: <1694411968-14413-7-git-send-email-quic_cang@quicinc.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1694411968-14413-1-git-send-email-quic_cang@quicinc.com>
References: <1694411968-14413-1-git-send-email-quic_cang@quicinc.com>
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: dI6VzXJHbKw-myoyrGk76uyywg1jL1a2
X-Proofpoint-GUID: dI6VzXJHbKw-myoyrGk76uyywg1jL1a2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-11_03,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 priorityscore=1501 mlxlogscore=486 malwarescore=0 spamscore=0
 impostorscore=0 lowpriorityscore=0 clxscore=1015 phishscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309110054
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Having UFS power info available in sysfs makes it easier to tell the state
of the link during runtime considering we have a bounch of power saving
features and various combinations for backward compatiblity.

Signed-off-by: Can Guo <quic_cang@quicinc.com>
---
 Documentation/ABI/testing/sysfs-driver-ufs | 48 ++++++++++++++++++++++++++----
 1 file changed, 43 insertions(+), 5 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index 0c7efaf..25169f2 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -1214,12 +1214,50 @@ Description:	This file shows the average latency (in micro seconds) of write
 
 		The file is read only.
 
-What:		/sys/bus/platform/drivers/ufshcd/*/monitor/write_req_latency_sum
-What:		/sys/bus/platform/devices/*.ufs/monitor/write_req_latency_sum
-Date:		January 2021
+What:		/sys/bus/platform/drivers/ufshcd/*/power_info/gear
+What:		/sys/bus/platform/devices/*.ufs/power_info/gear
+Date:		September 2023
 Contact:	Can Guo <quic_cang@quicinc.com>
-Description:	This file shows the total latency (in micro seconds) of write
-		requests after monitor gets started.
+Description:	This file shows the gear of UFS link.
+
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/power_info/lane
+What:		/sys/bus/platform/devices/*.ufs/power_info/lane
+Date:		September 2023
+Contact:	Can Guo <quic_cang@quicinc.com>
+Description:	This file shows how many lanes are enabled on the UFS link.
+
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/power_info/mode
+What:		/sys/bus/platform/devices/*.ufs/power_info/mode
+Date:		September 2023
+Contact:	Can Guo <quic_cang@quicinc.com>
+Description:	This file shows the power mode of UFS link.
+
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/power_info/rate
+What:		/sys/bus/platform/devices/*.ufs/power_info/rate
+Date:		September 2023
+Contact:	Can Guo <quic_cang@quicinc.com>
+Description:	This file shows the high speed rate of UFS link.
+
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/power_info/dev_pm
+What:		/sys/bus/platform/devices/*.ufs/power_info/dev_pm
+Date:		September 2023
+Contact:	Can Guo <quic_cang@quicinc.com>
+Description:	This file shows the UFS device power mode, i.e., the power mode
+		set to UFS device via the Start Stop Unit command.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/power_info/link_state
+What:		/sys/bus/platform/devices/*.ufs/power_info/link_state
+Date:		September 2023
+Contact:	Can Guo <quic_cang@quicinc.com>
+Description:	This file shows the the state of the UFS link.
 
 		The file is read only.
 
-- 
2.7.4

