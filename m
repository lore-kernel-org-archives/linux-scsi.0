Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B41D6C04A95
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Oct 2022 03:07:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbiJWDHB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Oct 2022 23:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbiJWDGe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Oct 2022 23:06:34 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C53183B8
        for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2022 20:06:30 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29N2tGUS012781;
        Sun, 23 Oct 2022 03:04:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=njWcjRm7rRVDU92EVjdVekYdbKtw8s0S20ejH0HXvtA=;
 b=H7+kvl/NfFkoG/j7kRm7aeJ5VJgray9IdTXYfv4k3pkF/x927ZfSV26PRy1LVFbJX91d
 XXeAeIqMU0n5bZcnQ2QHm6Dl1N+zqnfhLgSvHoUDJPiODre8FeZDFLYu5D7dIEo5ItUX
 R2ZmlFDkSMwoxEQ9TmAzFHwsoUQ1DklUVkjLlHAITpR4pM+PiBJ4mZ/XjMCbu82AlBZZ
 Vri+eCtjC1jtdDCxfpqsy0VgozMUbIqryzFEXQYwrR8RXJvlvXAwCHqWDXVJf5fZyk1u
 GXFJFnzB5HYGadg7H29Z9DL4ln9Z7/LEdQznstv5szbze21jBrQPWYyZ4GKNjpqiCFkW Ww== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc84ss3fs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:22 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29MI26um030662;
        Sun, 23 Oct 2022 03:04:21 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y2ryx7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hl/6p020bTz89BdPKzoj8EP4NVtYeauE6I4Tx0qHpllZKypyh/cI2dSPtRBtFQVY0ROKihNUlm29AQLoqowruVZPZn7z6ea7IyNrHCtaAnXuF/r+tT5JWL5Q2I/eVdZtK/dBomYXMyHbzpqfeunNmYSXhDRI1kPXsRG46LRAgvIHhd4Y1ivJu14ueT1xUGBZvz2EQksYTattRIBTKLhFCTRQjJRm3dywSrcKmHkYNtV8LPKrYlJ02zJ+fESjdHhVFa5sQHKLyOLqD78LxU//DESnLTdbEThhrbeD3vrdg+CscAk4lYQlovHZZkSHAD84TZZks0BZX4b5a+5LemzWGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=njWcjRm7rRVDU92EVjdVekYdbKtw8s0S20ejH0HXvtA=;
 b=hSExnWLgdyBdiwMikQmHpoL0Dcnmglvb9xAnc1xOD/cjZw9t02+RmzYR5qPyyf4Zya3ELRvSmsPE6ul/3lXYhE64tRfPIUwjAsA94QmA8tp2Y+FQJCU4JxChiMsTY8c8ZlHojHCct3h82Q8sHk6wk20pa22x9odjFwIA3Slxf52KygAZMHcOeJw11cqV4VsLc1p9wxkU8LUw28oGflexh3gotlNUW+dmqLNVx0cOe2dlWtCzCYTLs9lSqLMXYgirCDHLBSWEM155WtIoV5FD1EicgEWcb/o5ZIRr2o3aywSrhxoi1we0JGl8hlo9Munatwh/ql73dJcL2lPMmsI4oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=njWcjRm7rRVDU92EVjdVekYdbKtw8s0S20ejH0HXvtA=;
 b=YA+XqsoSjWvoQZe98cFuZntae3+JBf1Wqt4FEHroZKFjPsIXG15cRW7P+OsJjUMOI8HiolRFJJGVJMOA6zV75wTVd0KLbb/Mz/xIqbUQ7a8RWM8se86OQ68A7BnQQF9FIkppycPVnXBUDGyBUgu7/2XEI0x4do4+/nd/Mjlorrc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5150.namprd10.prod.outlook.com (2603:10b6:5:3a1::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.21; Sun, 23 Oct 2022 03:04:19 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.021; Sun, 23 Oct 2022
 03:04:19 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v5 08/35] scsi: scsi_dh: Convert to scsi_exec_req
Date:   Sat, 22 Oct 2022 22:03:36 -0500
Message-Id: <20221023030403.33845-9-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221023030403.33845-1-michael.christie@oracle.com>
References: <20221023030403.33845-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR15CA0014.namprd15.prod.outlook.com
 (2603:10b6:610:51::24) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS7PR10MB5150:EE_
X-MS-Office365-Filtering-Correlation-Id: e7aeb8a3-2bd3-49e7-9be8-08dab4a346ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 20mJ4chXskS+78jmCyFlEpuxy56VBgE3mm5cxpDHhcLc098RKyhjEGbHVDKXcbmLnrQTten9GCJLs7UcyhWN8D1vgxICng455gaewRSFK3ZWJ1hWl5viCzXvR97KKN64MoUz82xefE9cWqWF9h5Py/0UKHjga4ZcO38vFLXq1GInaseh0mHtzWqcCn2YsYQVxTrgreMuv+T+zrDxT6gdW7HWargVR/d1kMjJ06GUlM4MKiJz5Id54NTrWJItq61Vp6+ffeAygAuWJE971xuVDr4gyegjPKjee6M4E6HHoczoJCrvmcWzszVfFjvbJhlNwFYPK2wDxpWqz95R2uvF7H3DaEGGZeyv4jeUqLygVcO/KkHeSGmF8dFjSTjJ5bfvUmsMkFiCehSKSiD5ZRQj4BHJ9XzsuTiJ6GBm/55Djj8jogu20Xe533P4AM54L63eWph0TAiQDpuqOHum6FutfIHDnpo+Chu7nGwkV89/RGsj8ZjjUCr/aqrTLbL57imNYUmwBsGBh4mYDnL2Bi8jd6faYooMoj8oYD42UoDViVzQ3SO5lwXKSfAdGp5Sx+mJ2gVJPIvTQSmVgHKP1oYs3lU05Rh5McvkX/iyvCM19fYpbbA+Cii1O3gMrJZSbl0gfe0pLxWSf7UYdd0P+6XQoUH/RY+VlIt18Nu1JjfZc3wqocVJg04tbjOqMTMFPKatZMTHqtEkrxtjko7ratZOcg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(346002)(136003)(366004)(376002)(451199015)(478600001)(8676002)(4326008)(36756003)(186003)(1076003)(66476007)(66556008)(86362001)(66946007)(38100700002)(41300700001)(6486002)(83380400001)(2906002)(6506007)(26005)(107886003)(2616005)(316002)(6512007)(6666004)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OyJH3Q0/zF7H1AUriGG+O2oBYCdLcdguHI3vgb6ZePb5711Bk3Lpr6RMc4US?=
 =?us-ascii?Q?lB0L+FB1LxPziIh8rYJ9zQnmc9jZI6AED6cH+8t2ZMbH5Kj318Bl31Q0QaZ/?=
 =?us-ascii?Q?mzZJ/ph393dtol6kgHhCvjpqw3M4WF4ES6j1jyU1X2KG3q9ZMh0t+lh5XElR?=
 =?us-ascii?Q?QwogFVvASseO4MJBlwg34uOx2HZwpnx1RHepWq8Wt0jZelLjcYXfAmI2ZFHF?=
 =?us-ascii?Q?WQTJWygIWWX5VuBbPKTSkyFAHCf8eZYQvdizTzOS0tr9MufKgEAuqf7OvJad?=
 =?us-ascii?Q?OB6/8f5g6e7R2jkW6fZmT8L97l9I4jESZhTmmk11F8neYNAjrk27HuwpdVU4?=
 =?us-ascii?Q?2+ErX2e5tNtFU00jGXUb+R5irF/4H+pTBZYGkv58ciDOT66Vsavf/fIB/OOx?=
 =?us-ascii?Q?yCYa6ZQHwsLMlmZaBDWQY7XWECa0zYfpfvbDxH7Rc1QdlBKdSQ9mSYKEsc0t?=
 =?us-ascii?Q?Tl/g7soWkGN3HvVwjl7l7SVwHWr6CXqBu+5YLSCV2EgpxgoRJiVPo8+aMhW7?=
 =?us-ascii?Q?xzyZV7+4Ozloo5d+zgJDmfF44EIt8S3E46qHvHaAG/tlCxcY+1zsQQKXRW8q?=
 =?us-ascii?Q?ExxrcKnQuIFTBSzvqjZcatmVGhqx4rbuN5mxE/j3TqwxqstsmTvxlp7X35ah?=
 =?us-ascii?Q?xs01+L/rZKxRzMF0sLdXyWlZfKlPzsbQIZKYVp7/8NRsfb3MXoSgBUXHpfV/?=
 =?us-ascii?Q?iSy+5ftOgOVEABUlPhQoyXyYdmH1Zi75g6AYtns04iCpDaJE4Um45GdizVQs?=
 =?us-ascii?Q?br2yMFE0HbOgm4wCQAvkpe82SfGQtmhJoTJbXn9qnYaJL9OUYIb7tGBnboJP?=
 =?us-ascii?Q?YhSGyZvzBlvckcIKgd+qKmhdAUTos+jm0YUMxnUxoecA/lvY1EjOP3yph5+6?=
 =?us-ascii?Q?JUWcJ9WKTsk5ysUgs09gAyl7dxqN6hQPMhc5FAUlXT28/BVkhq72l5j1pKzm?=
 =?us-ascii?Q?qQvN2grKgDvzy5IJ/CrH0CptUu0pE1TcxOvV7hAvpVc1xfHiNwVpQjetmpZI?=
 =?us-ascii?Q?00KznM0430VfG1JjvmbQttBpd79I6bhRZXRpWNQKZWNiTJo67BiUvHRg2hhN?=
 =?us-ascii?Q?91q5D1F9NLS/sL4WrGifwJLvY+jJzWpXT6KbqKXQeEOrZAmEzD6pBqMZ2jCE?=
 =?us-ascii?Q?yzL776UAsT7Nehj60TLYJlu3BRa51B9z3wow22p19PQChQo7F3WCnwlksc2u?=
 =?us-ascii?Q?MNw1DzE/lKj+6NIQSWsEtOoszUKGpXX7lMDfp2Tw8eyf4SlSCZ4IaT0ZApGY?=
 =?us-ascii?Q?e0hbqt06jmw0YO32m6MPFupLTd1/QTyNcE2bc+3ptC5aeZCn2aFBv2fpk72w?=
 =?us-ascii?Q?klPK+E6HeXewqo0fZ6c9wcBDDKY11OmrCC9EU1fG+tChTv/895bG62GrreUY?=
 =?us-ascii?Q?ZAL5O8XT/9W989ARwj73MaKTAokZ4tTBCeho/ZrpqpP+eehj8dVKWJcxRYrf?=
 =?us-ascii?Q?9L7qV32rq/JOh7dCpGDGfZTO3uAM+GAlp+hIvCHhTjm7FlfnQ/Ha2SYMr9QY?=
 =?us-ascii?Q?tmvJWPWOghVFvwM4tYpMiG9ac6MlKXDKk1IS/FBGZuT+BYHzBmJ+H723up6I?=
 =?us-ascii?Q?I2ni6RenfPi/33cs9oZ7VmXIe+jObJ2aJTDJwm7OurwD09+KqP9q0i1w6YYS?=
 =?us-ascii?Q?0Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7aeb8a3-2bd3-49e7-9be8-08dab4a346ee
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2022 03:04:19.0307
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C3g+GAxjBUiX0vBc/rRqAJO8i1x2chW+CqOx9P/UhJTQ5g6Gf/htmCKoxQe2NyLh2UQ03f4MAQSRFn337OJITsPtMqAnsaoekCIBWsTY4MU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5150
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210230018
X-Proofpoint-ORIG-GUID: 0aU1HG0kigJ2G_tV8aSkhsmjr_w9wmAG
X-Proofpoint-GUID: 0aU1HG0kigJ2G_tV8aSkhsmjr_w9wmAG
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

