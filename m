Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDB52C433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 16 Oct 2022 20:00:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbiJPUA1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 16 Oct 2022 16:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbiJPUAR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Oct 2022 16:00:17 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B9C624BEB
        for <linux-scsi@vger.kernel.org>; Sun, 16 Oct 2022 13:00:16 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29GJlr1W004935;
        Sun, 16 Oct 2022 20:00:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=njWcjRm7rRVDU92EVjdVekYdbKtw8s0S20ejH0HXvtA=;
 b=GUozCluTPRkFo380I6aBidznBAGjTzR4MDHNfAOXYuPL5jvsIvI8HMoN3HLYcAFNOND1
 0svBPP/qGuws3CQVmyX1+MV9P4GMH028Eck3FXIkadcuyctX8woJLeSaEdBV2ITVkBYT
 Lb4QDn4uktuEoVax8cX9tteLFtphyXsxSqm+fyRQL8kYF+h0P427xsQwonRkUyupBERY
 26blIMg75jnN3dCrrElyblu4T9ikM2RjIDPAbFSFknIYVm2VU6h+Dh4jRrgdmJR6aXk4
 rzH2gyPZaeXTVDEY3ra5H/2XNQDb2Ej4uqIMV+F3HA2Wq7SAzZFgO1G6Ejm6SRi4P4Vs Vw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k8jt2g7a1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:00:08 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29GCAneG001181;
        Sun, 16 Oct 2022 20:00:07 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2045.outbound.protection.outlook.com [104.47.56.45])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hqwmgmf-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:00:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P/0Jx2CU6m2XWZBKSWv7vAni1xn6hkzqx71Nc8bZ0KYCHSoQSZBKEsaHEuO09Od7QYJMwKGMoEt5ZsZT4VLWpmEyIlmD5QVu/7euIuTbVw1Pjh6/9demGaQNxL0dBfjZb3Pt4QPKVNQjjFltCJBsr2KPjcRoAPhTL2zn6v630QLg5u/5NpYBavZfTmw+JldmMilRoyfQe4hVY1WmgQRYqihKfOZOmz0uY4cnBt5vP2bXGXwdfKEJk2+prOn/hz/Yp101bByjAF82uCpOGVdSZQS9lK4tOEe/3GNRy7P7Y9/zKWIQA0G92J9llbB+QP9zL6B4nVK1M+t3jAzb5eEKXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=njWcjRm7rRVDU92EVjdVekYdbKtw8s0S20ejH0HXvtA=;
 b=cm9RXLbA//5mY5jobSA5PWm3To4Gedlsly/OxqJV0hu9aNjUL64Ea+WKPd7jIQ74cYQB+IX6TY7vqjK56lXgncx6r9eBlbVGXUWLKFy/BvixvfHQQjc73tV/L2bfFAfKgJ+Rc1YBxCJRD9LQkm+ZY33Bet59pM7SagIr6gTd0+mrS8EA78zCIDDMcOcdfIpjKOC/z52IPmlF3ULTaVt17jZdSHViLMNRPIFsxa3rijGNwQubbvktTfpjCZd9EsXoH3W1xi4QllPrnJwF6+qIRrjR371kq0/TjQkvFzp0flhqGraHBVZ/OD0CwylzQCYqn8mLWH2rOPyYbX6PZE+UMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=njWcjRm7rRVDU92EVjdVekYdbKtw8s0S20ejH0HXvtA=;
 b=Zvc1yVe4EueZ94MYJxSJPlrRTlZaa4bl2Cv6nJKdMCQM1/ml4FtX+0SSPl1nUbtCQf9P8oOmx2P112ihZX53duG4rpyFT2WW3rpyAqMci0I+LL3H1GqeiwjpkPbWvbvz6JG+d72uJq9xHJSCgsN9cekT5udgx5EDeyntNT4OcWM=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB6727.namprd10.prod.outlook.com (2603:10b6:8:13a::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.29; Sun, 16 Oct 2022 20:00:02 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5723.033; Sun, 16 Oct 2022
 20:00:02 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 08/36] scsi: scsi_dh: Convert to scsi_exec_req
Date:   Sun, 16 Oct 2022 14:59:18 -0500
Message-Id: <20221016195946.7613-9-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221016195946.7613-1-michael.christie@oracle.com>
References: <20221016195946.7613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR15CA0002.namprd15.prod.outlook.com
 (2603:10b6:610:51::12) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB6727:EE_
X-MS-Office365-Filtering-Correlation-Id: d196c8cc-2c7b-4e7c-4d0b-08daafb102f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IuERFHpG4NOSWrjeMrBPS8s87kqAdiqH9kXLCuryeUmS7vz5cC5uyU3NaJO7+dG/YJ6HeZgip7EUtysDRa511Z1XqLKYDtNNc1j9iDIHQiiTQGEjTFPstqrKlnBLZGsvzha2qy4Mn01gTOchkExke3yeWelYaPo4uoHB/ZMhaFebDf6m0dlftTI85NQHsvHKgRC4YmBE+UI8uV4wI7pZBuelO44RG8Ar0RZgJ3jGrAHXSyaNDXu8tn0RDm2Zj1ZiVCqtHkc8Ft88sDFfCYa4U1ZNrOn66MPrzsYqHnf62/aWKbvh82osAxaDEyeYE3klmJXjn1uf5EMgyoczDpMIsgZythqOJrS7rJnsOmcqDgqM1lnm5GTwNhOZJ3CL6c2ikoNq1klJX7p1nk+QpRSWkmswC1IDWhQ84s3SxU+LZvIyhubaUgIdcwb07slx7qMr8NSQ5vNm2mJ88HDkmGWCid53xy/AwYNMzvYFDo0hZYxvnhorVsrCN2uO5stzJEb0nUteKJX6dj1sBv4DxRtx3AqoqyO5u0vqYGCjHswsfXbBwH3yn2mKeECrQVDWAqhYtRVSyl/iw4liz4VjjQGn9Kcv7NsqEaOYnAHoXYKQdIiEL2U6xvquX9m6+nMHTzs9XNC/7PILfS9LeYpzQcRLC2faevaYFS9Z1rJJkozLbnSKb4brqfiy+mEpaXiu4lCVbVzfh6ErM03hjUf2m6LM5Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39860400002)(376002)(346002)(396003)(451199015)(38100700002)(478600001)(6486002)(186003)(4326008)(2616005)(36756003)(6506007)(316002)(66476007)(107886003)(66946007)(66556008)(6666004)(1076003)(8676002)(5660300002)(6512007)(2906002)(26005)(8936002)(86362001)(41300700001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xdD4RE35dtrNStlg+dW3Ub/RS07AklsH2atlgnavJtPeh/eQtyjLpiGyHtey?=
 =?us-ascii?Q?crtNZ0zA5uXmuliqT/aK0L5Fp2Y4J2cy81yJ87IkpQvx1xD1u9RHVoanAV0b?=
 =?us-ascii?Q?QBzw4cn+DC15nJJzaQmpuY3XCdu8zoioqV+Pxbl/SiRXu/96Zej2L5R+R67r?=
 =?us-ascii?Q?spcvir7D3vC0YMED23Xl3yRDnZFJKQ8xJ5AIJW7EtXRSENgnuUk0ratOI9tM?=
 =?us-ascii?Q?sor+CmYsv28JKKjvd0hdi25tTVjXi/JyWnwGeMkXQmzsGp5LUl2piNQGk1AO?=
 =?us-ascii?Q?CL/A4L9f1D6/sQvsHa6i+DHxDYMsT94gbzTNseZD45ur8z0LK74FUnqS39f2?=
 =?us-ascii?Q?0+7hz2l/AP/WnK1fdaYJFFkSjDDjDAs6nK4XQXDO/TKjmE3WbSNZgxFn4edz?=
 =?us-ascii?Q?FpHwFrB1cZd40adwNnV9CExa/Iv/mra05+MVVAlmrUSUNlNeRECWUWtqxbTs?=
 =?us-ascii?Q?LSqNjiajA2zYMAvOGlereOQu138qgMafW1lnPvFsEmPyXfX8u3xx6mj5K8Ug?=
 =?us-ascii?Q?1pGi1nvCs6o7bji/dBmGOubgpQuIO6t64qDK5TERpUZQxeei7lHq7uftP/9U?=
 =?us-ascii?Q?jA8/euCLkIEP8X5rhUBO4OzAuU5Q0dVJy4i7JSGZSuEC8tXOyuQpzT/nJrM1?=
 =?us-ascii?Q?9n5n3myogD5G9FPYuh+mw9bpVZQiE31OdvBDJgbbT0tWewLqpyEUEjQkW1I9?=
 =?us-ascii?Q?+C1YCqDHHNwP/JfsY/EqIP1lIiWCxgk68Lj2ZP/pq2wcj3V00zOOf4RnBGWJ?=
 =?us-ascii?Q?eCEUkoquJu3Z/cG8P7cSc0TkCL7GRoOiZeNsDBkCqB7jgfVpwDbRlxTG/dnB?=
 =?us-ascii?Q?NlJAQkgqy852OyQBAnGasNTaAzx5Qhgq4hZRTbBrx0caLXNQ80VF47rgbBW8?=
 =?us-ascii?Q?8axa7v1AOWSkzHIxxNVmmUuNv/kzldJ3k1Nbc4nYtniDll63CNrWRoIIXHVQ?=
 =?us-ascii?Q?OmChE1uuywflluoyed+EEQrzf5NIJseVse5KhCKvk/8ZKb3ApRAXRXzUGuGu?=
 =?us-ascii?Q?JjpW4gdcvNLaDoUlcq0xFHAv7cevalIxc/HYuUegdxI8M+Wtv5hGNCXga2jF?=
 =?us-ascii?Q?/qEIWfmCPQXrwBdSb4w5GcD7MTwN7W+FFPHDMXVdqB3sL3Sfs9TAS8CVVLl8?=
 =?us-ascii?Q?/BN+RxvHKipw+6nsIeqkbacO4Ljrg4TMZycXpwTYBazSQfi6xe/Hvee8JX60?=
 =?us-ascii?Q?IkMln6LYJaSpG72V8Ug0AdktT9mLSPXfXPy/l57BX/d619fOnJdLynjoGGpX?=
 =?us-ascii?Q?FpBdNbmRTv5eXlLQnh+XNhGTBSQnqbt5PuZsOr+P8wvV1lkFkBwLGaf+n45v?=
 =?us-ascii?Q?RpiOwnA9GHheAzR8PfST1S8lYfN6+OORAjIva19rIyYAovFind7juAfltfun?=
 =?us-ascii?Q?JQHjJXVjeIveOw1x4dnkVl3dG42afjD9kpqgtfMqUEXumhIKbMxvqJu5Fz7F?=
 =?us-ascii?Q?0BUks1fpTgNSTrArTfnY++4LNXkPb3t8yDzpr4f35786VH4drj2FQJLs6SbR?=
 =?us-ascii?Q?bHzmimCDvq994j795YAE64n4yOJretMkDMvXn3sy8caOdvmYsJhzr+Bj+GwJ?=
 =?us-ascii?Q?/nmvFsYJKOFyZqNp83HL3FpdDtrP7SHE2LEgPrF53TTeomsWtSmOb4GHN60R?=
 =?us-ascii?Q?hw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d196c8cc-2c7b-4e7c-4d0b-08daafb102f0
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2022 20:00:02.0815
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j4xKsKZIQDUww0lgZ72CNd+psCwjCfpsQZDe+nwevBeIEzsWrmG1NzC5H4rLYLBgh7uA4tOEqXfAAZ+oFnlCiCJAWouaVzfatBQ792siOR0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-16_15,2022-10-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210160124
X-Proofpoint-ORIG-GUID: B9ep5B2JWfe3M8_82CaFmitE53bi2U13
X-Proofpoint-GUID: B9ep5B2JWfe3M8_82CaFmitE53bi2U13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/device_handler/scsi_dh_alua.c  | 26 ++++++++++++++++-----
 drivers/scsi/device_handler/scsi_dh_emc.c   | 13 ++++++++---
 drivers/scsi/device_handler/scsi_dh_hp_sw.c | 20 ++++++++++++----
 drivers/scsi/device_handler/scsi_dh_rdac.c  | 15 +++++++++---
 4 files changed, 58 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 610a51538f03..e4825da21d05 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -139,9 +139,16 @@ static int submit_rtpg(struct scsi_device *sdev, unsigned char *buff,
 		cdb[1] = MI_REPORT_TARGET_PGS;
 	put_unaligned_be32(bufflen, &cdb[6]);
 
-	return scsi_execute(sdev, cdb, DMA_FROM_DEVICE, buff, bufflen, NULL,
-			sshdr, ALUA_FAILOVER_TIMEOUT * HZ,
-			ALUA_FAILOVER_RETRIES, req_flags, 0, NULL);
+	return scsi_exec_req(((struct scsi_exec_args) {
+				.sdev = sdev,
+				.cmd = cdb,
+				.data_dir = DMA_FROM_DEVICE,
+				.buf = buff,
+				.buf_len = bufflen,
+				.sshdr = sshdr,
+				.timeout = ALUA_FAILOVER_TIMEOUT * HZ,
+				.retries = ALUA_FAILOVER_RETRIES,
+				.op_flags = req_flags }));
 }
 
 /*
@@ -171,9 +178,16 @@ static int submit_stpg(struct scsi_device *sdev, int group_id,
 	cdb[1] = MO_SET_TARGET_PGS;
 	put_unaligned_be32(stpg_len, &cdb[6]);
 
-	return scsi_execute(sdev, cdb, DMA_TO_DEVICE, stpg_data, stpg_len, NULL,
-			sshdr, ALUA_FAILOVER_TIMEOUT * HZ,
-			ALUA_FAILOVER_RETRIES, req_flags, 0, NULL);
+	return scsi_exec_req(((struct scsi_exec_args) {
+				.sdev = sdev,
+				.cmd = cdb,
+				.data_dir = DMA_TO_DEVICE,
+				.buf = stpg_data,
+				.buf_len = stpg_len,
+				.sshdr = sshdr,
+				.timeout = ALUA_FAILOVER_TIMEOUT * HZ,
+				.retries = ALUA_FAILOVER_RETRIES,
+				.op_flags = req_flags }));
 }
 
 static struct alua_port_group *alua_find_get_pg(char *id_str, size_t id_size,
diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index 2e21ab447873..0ad6163dc426 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -263,9 +263,16 @@ static int send_trespass_cmd(struct scsi_device *sdev,
 	BUG_ON((len > CLARIION_BUFFER_SIZE));
 	memcpy(csdev->buffer, page22, len);
 
-	err = scsi_execute(sdev, cdb, DMA_TO_DEVICE, csdev->buffer, len, NULL,
-			&sshdr, CLARIION_TIMEOUT * HZ, CLARIION_RETRIES,
-			req_flags, 0, NULL);
+	err = scsi_exec_req(((struct scsi_exec_args) {
+				.sdev = sdev,
+				.cmd = cdb,
+				.data_dir = DMA_TO_DEVICE,
+				.buf = csdev->buffer,
+				.buf_len = len,
+				.sshdr = &sshdr,
+				.timeout = CLARIION_TIMEOUT * HZ,
+				.retries = CLARIION_RETRIES,
+				.op_flags = req_flags }));
 	if (err) {
 		if (scsi_sense_valid(&sshdr))
 			res = trespass_endio(sdev, &sshdr);
diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 0d2cfa60aa06..adcbe3b883b7 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -87,8 +87,14 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 		REQ_FAILFAST_DRIVER;
 
 retry:
-	res = scsi_execute(sdev, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
-			HP_SW_TIMEOUT, HP_SW_RETRIES, req_flags, 0, NULL);
+	res = scsi_exec_req(((struct scsi_exec_args) {
+				.sdev = sdev,
+				.cmd = cmd,
+				.data_dir = DMA_NONE,
+				.sshdr = &sshdr,
+				.timeout = HP_SW_TIMEOUT,
+				.retries = HP_SW_RETRIES,
+				.op_flags = req_flags }));
 	if (res) {
 		if (scsi_sense_valid(&sshdr))
 			ret = tur_done(sdev, h, &sshdr);
@@ -125,8 +131,14 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 		REQ_FAILFAST_DRIVER;
 
 retry:
-	res = scsi_execute(sdev, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
-			HP_SW_TIMEOUT, HP_SW_RETRIES, req_flags, 0, NULL);
+	res = scsi_exec_req(((struct scsi_exec_args) {
+				.sdev = sdev,
+				.cmd = cmd,
+				.data_dir = DMA_NONE,
+				.sshdr = &sshdr,
+				.timeout = HP_SW_TIMEOUT,
+				.retries = HP_SW_RETRIES,
+				.op_flags = req_flags }));
 	if (res) {
 		if (!scsi_sense_valid(&sshdr)) {
 			sdev_printk(KERN_WARNING, sdev,
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index bf8754741f85..c4d1830512ca 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -538,6 +538,7 @@ static void send_mode_select(struct work_struct *work)
 	unsigned int data_size;
 	blk_opf_t req_flags = REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
 		REQ_FAILFAST_DRIVER;
+	int result;
 
 	spin_lock(&ctlr->ms_lock);
 	list_splice_init(&ctlr->ms_head, &list);
@@ -555,9 +556,17 @@ static void send_mode_select(struct work_struct *work)
 		(char *) h->ctlr->array_name, h->ctlr->index,
 		(retry_cnt == RDAC_RETRY_COUNT) ? "queueing" : "retrying");
 
-	if (scsi_execute(sdev, cdb, DMA_TO_DEVICE, &h->ctlr->mode_select,
-			data_size, NULL, &sshdr, RDAC_TIMEOUT * HZ,
-			RDAC_RETRIES, req_flags, 0, NULL)) {
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = cdb,
+					.data_dir = DMA_TO_DEVICE,
+					.buf = &h->ctlr->mode_select,
+					.buf_len = data_size,
+					.sshdr = &sshdr,
+					.timeout = RDAC_TIMEOUT * HZ,
+					.retries = RDAC_RETRIES,
+					.op_flags = req_flags }));
+	if (result) {
 		err = mode_select_handle_sense(sdev, &sshdr);
 		if (err == SCSI_DH_RETRY && retry_cnt--)
 			goto retry;
-- 
2.25.1

