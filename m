Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF0F2882DB;
	Mon, 29 Sep 2025 09:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759137971; cv=none; b=p1d+qcRp9U5E0d82VbOpv2EirLMGDdMcrEBfGqxMyCwkWs1Fp4w/FLXisdJdTBHjrRH7ruWeLv9zfTIDGav06Kb7mdCgE7oPdngkC7bC8J51BoezPKiCQ5yuHK4co3wSSjLxqU9IpXTq35L9phnXwdFZUJg5mgwsk9bqj1iCdCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759137971; c=relaxed/simple;
	bh=G80AouN6PDIGEF0/LIKnGIRSkYCCA2LgLJO3mKnzFtk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ol7/gvjNWAJXrtp9iM15VdWnA5yUSD/dV6OJhDJrvuIwI/Zd+5ym81kvqvqwSMcA1rG7yYaFZvy0FBfiQfWaR6OzXlRnGQU0dlVloezU+Zm6+lIlia1oD0oPiLrex+Ry6BDqfrw7yg3KASn9f3DUPLQNmK4/GxbGV74iumwijUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DBFg1m67; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DBFg1m67"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58T8sNdm013367;
	Mon, 29 Sep 2025 09:26:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=tSstgi5clCTVdB66xxyz8fmyBJrP/
	416Ngxv6KMH8Yg=; b=DBFg1m67acfKlQ3fRFLJwh6PzxV9AqoO/twt6xVb21PTz
	e6Q2vusQTKPscvB8MMb+nMBU9n8Ee3a44/LwALgmvPfyhFfy/4psL1CFle2sCXkn
	TD593xPIEtNthumc5EPAK3VvCVlDJsaZacNWfoCVXI8BvYqWeYn8nekd2Rg+rd4L
	2kQyfgxIAOxj/HDVpyD+F23rdu2g81IFyHOe9CmwP3ofLNcselael3I9o6dw4Q9/
	vRZ7MsyjX6hGclaz/KHF0QbJL3Zg+RjjHkqqopUt6iQUYcLjOvvmIKgIRiosi+D8
	4JtJUSGqdHep43ZXcjPufzE2ScKJ+o491LTot1tNQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49fq0v01hp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Sep 2025 09:26:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58T8Ljk0001920;
	Mon, 29 Sep 2025 09:26:02 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49e6ccpgrk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Sep 2025 09:26:02 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 58T9Q2Cr035423;
	Mon, 29 Sep 2025 09:26:02 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 49e6ccpgr1-1;
	Mon, 29 Sep 2025 09:26:02 +0000
From: Alok Tiwari <alok.a.tiwari@oracle.com>
To: njavali@marvell.com, mrangankar@marvell.com, martin.petersen@oracle.com,
        James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: alok.a.tiwari@oracle.com, linux-kernel@vger.kernel.org
Subject: [PATCH next] scsi: qla4xxx: fix typos in comments
Date: Mon, 29 Sep 2025 02:25:54 -0700
Message-ID: <20250929092559.51137-1-alok.a.tiwari@oracle.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-29_03,2025-09-29_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 suspectscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2509290091
X-Proofpoint-GUID: h70ayeXlNV6U6P3KtefFnVG-d9lSkngB
X-Authority-Analysis: v=2.4 cv=CNsnnBrD c=1 sm=1 tr=0 ts=68da50ab b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=YXOkn92C4h7wVYdyZBEA:9 cc=ntf
 awl=host:12089
X-Proofpoint-ORIG-GUID: h70ayeXlNV6U6P3KtefFnVG-d9lSkngB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI5MDA4NiBTYWx0ZWRfX4xGfFvbvydxp
 tAGeZhqOmAvF+LWMi/CpVzitIKFNTqotZuofbm4zAXefahA9q2fC75B2Nxk/k8wmT/fSqA4EFyG
 MwOgiU5xislffyMPxUrlKKEPGuXCaj/xx03SJlxd60Umcze9OuzLo2azxuzUw2HoKyW3lbfZIV2
 p9mWElCLLmQ0NfUoqw3OgCYMjLLlDA2j6yFsvOCuxpvz+XOSV/yWRYJ0jr1URiIyDRTcA1o/VpT
 rX9aa7ytvRqxnDOu9BsBNDBs5nsQbsCLZ8/fjwv7mLXSHW0zfR0RGytQ18yaj8ttSxyrCJ+eG7h
 YBj/qVTIb0sXtW4Dv/kVNNoJCDnBfCynFsInGzje/ZFEe/QNXTT6hgvdxPkgxfOa74qmGSUVmqT
 aY3cCLGoyw6ls48rop+nzEaDUb78AvU2yvtbCJz9s2Ql5bAwKNc=

Fix several spelling mistakes in qla4xxx driver comments:
 "Unfortunely" -> "Unfortunately"
 "becase" -> "because"
 "funcions" -> "functions"
 "targer_id" -> "target_id"

Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
---
 drivers/scsi/qla4xxx/ql4_os.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index a761c0aa5127..83ff66f954e6 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -4104,7 +4104,7 @@ void qla4xxx_srb_compl(struct kref *ref)
  * The mid-level driver tries to ensure that queuecommand never gets
  * invoked concurrently with itself or the interrupt handler (although
  * the interrupt handler may call this routine as part of request-
- * completion handling).   Unfortunely, it sometimes calls the scheduler
+ * completion handling). Unfortunately, it sometimes calls the scheduler
  * in interrupt context which is a big NO! NO!.
  **/
 static int qla4xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
@@ -4647,7 +4647,7 @@ static int qla4xxx_cmd_wait(struct scsi_qla_host *ha)
 			cmd = scsi_host_find_tag(ha->host, index);
 			/*
 			 * We cannot just check if the index is valid,
-			 * becase if we are run from the scsi eh, then
+			 * because if we are run from the scsi eh, then
 			 * the scsi/block layer is going to prevent
 			 * the tag from being released.
 			 */
@@ -4952,7 +4952,7 @@ static int qla4xxx_recover_adapter(struct scsi_qla_host *ha)
 	/* Upon successful firmware/chip reset, re-initialize the adapter */
 	if (status == QLA_SUCCESS) {
 		/* For ISP-4xxx, force function 1 to always initialize
-		 * before function 3 to prevent both funcions from
+		 * before function 3 to prevent both functions from
 		 * stepping on top of the other */
 		if (is_qla40XX(ha) && (ha->mac_index == 3))
 			ssleep(6);
@@ -6914,7 +6914,7 @@ static int qla4xxx_sess_conn_setup(struct scsi_qla_host *ha,
 	struct ddb_entry *ddb_entry = NULL;
 
 	/* Create session object, with INVALID_ENTRY,
-	 * the targer_id would get set when we issue the login
+	 * the target_id would get set when we issue the login
 	 */
 	cls_sess = iscsi_session_setup(&qla4xxx_iscsi_transport, ha->host,
 				       cmds_max, sizeof(struct ddb_entry),
-- 
2.50.1

