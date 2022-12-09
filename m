Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D10BC4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Dec 2022 06:15:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbiLIGPy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Dec 2022 01:15:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiLIGPv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2022 01:15:51 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A438F715
        for <linux-scsi@vger.kernel.org>; Thu,  8 Dec 2022 22:15:51 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B8MIfLl002811;
        Fri, 9 Dec 2022 06:13:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=8iBDUcGFdAoUWj4rxtmqB3WcwSz320vHkiYSN+G3L3Y=;
 b=Dkwmo5yx6zheDt9Z0ahBcZ0IwU9MMeoGmbWBJSeXXoeaGgDEqrw1+GV8PYrNunq8zT8z
 rdnCa4TnM6fuDgykzw1TwE3EWm9oZVMvPs8isBT0d84chd/+XYDgLoL5Gl4XfVWt6yF2
 kgmmdpyqzgcAdF7DeR0QHz66LebpD1V+/CO4BfddLm1704Gvb/IErq6v/qPQPCvXlalD
 nsTUfUUvn0bXf6B0xTs6ESZntfyyPUSaS9xrcx767QRVPKWTKpP5tJ4rRsahqOaDg/C3
 hPPDe1CzCyIdoNEyBbh/WWjWWhcNHiM8Ahu/Qy68a4vmKd7bGc6f7goOfeJYRs0PFEuS Ig== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3maudkcjdw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 06:13:39 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B95eQX3008346;
        Fri, 9 Dec 2022 06:13:38 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3maa61ymmr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 06:13:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rf6iLynVqTJNzg7h9W2u7HsiOQyZf7MS33mvWRMnwXH5hbfKb74YlkIHp150Imz+oYQO/Z6DSr0JBb7kpghMCkX4ExoezLGQIT2fYOtmDfoqFDGClBczwwgl7cfigEvbketXtD8FmpIGhVZvqzernm1SecTjNlHERF1bAh/PbQqtrAzUpTpcrTKHAg7GIoCOFkxZwwF9yg8SIo9hD++w+amhp6kwvMUODlF5UaKAAp+BCRBNXOnHOeqO0Fu+U8MPphFGSTxM70qdASU8ugu8LETij8XMzxg2sw7notM9sRDZUFSlL2jLWqg0VCq6h6U5Gf8S7ltGPGJdv/siOXJMrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8iBDUcGFdAoUWj4rxtmqB3WcwSz320vHkiYSN+G3L3Y=;
 b=ncdR9w8lH/6+TC0Gexv53oEdzN60LtTMcUQpq1ILPoUOWTOBO60f48MRWRN2ak9tnoEPW21MlJSbY7IOX2FoKyrZDjAo7IDetWDSNVRrpHczkmaPz3CpRNFzweU5LmL5SkJT/qgpx7X7/mMyt9zJuGBTf4k/GsAnZDUJNVw2s6elLyz3S+HUiXZra5JHggeY2PypbLx6G/EdW8N7x4dk18pY/LYU5Bo3+j09+vLt5Lm5W3lw9JPx97KhQK5Ui/YjQAt18iKmsptX4/e8ded6wJ+kxwuUnj3fHLBL7q1xiT8FNS3xdcToHxcHirnmMfJ2Pd9f0mAFTIV9iXQ+moGGCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8iBDUcGFdAoUWj4rxtmqB3WcwSz320vHkiYSN+G3L3Y=;
 b=hOoEHyqC2Xu7MieAYXcoSR57dF/iO0TGssUgDXxL10zLS+sJHp4dbhpBBtWu61XZhByFx2ycgMpKv+nQQz7/4mToCkvW+BUCZR72IUh3rwV1nXoO4IsPE93wqy8iZ504BMhqoFW4uiOn6TpbeMlNUj8fUhZrVKmS03cyG6Sdris=
Received: from CY4PR10MB1463.namprd10.prod.outlook.com (2603:10b6:903:2b::12)
 by CH0PR10MB5066.namprd10.prod.outlook.com (2603:10b6:610:c4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.18; Fri, 9 Dec
 2022 06:13:36 +0000
Received: from CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::a99a:a833:4f4c:9e99]) by CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::a99a:a833:4f4c:9e99%6]) with mapi id 15.20.5880.016; Fri, 9 Dec 2022
 06:13:36 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 04/15] scsi: ch: Convert to scsi_execute_args
Date:   Fri,  9 Dec 2022 00:13:14 -0600
Message-Id: <20221209061325.705999-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221209061325.705999-1-michael.christie@oracle.com>
References: <20221209061325.705999-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR14CA0025.namprd14.prod.outlook.com
 (2603:10b6:610:60::35) To CY4PR10MB1463.namprd10.prod.outlook.com
 (2603:10b6:903:2b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR10MB1463:EE_|CH0PR10MB5066:EE_
X-MS-Office365-Filtering-Correlation-Id: 718124df-0da5-414b-4b85-08dad9ac81dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BgkKo+F96tffi918mFqHGvoc4nnqcvNVqPaobHl8zlR/PYqJYe+RqKNSr32zLiesso45Pwhbelq8BMFQEmPcgMN/JWR4t9ui/UiXFuGM0XIjoFCx913Et42kEibbwVzHpmZgkpC2miC9nmoWswtNvcZp2hm7UTXx9fmuEivaB8N/JnTHJUQKTzOE7JqSR2pg1uZKuokCGx857WHWKN1BhCWBR22HgpjX5aRhFxn9AUUb6LoV7Qv9YnhwcoPGE1Ej3C34XNWSHjdqSf3SR78UK45LuoaIFi2ssfOKGflXIQ0jieeNHFTiK3LasJo3YkdQmb26+1AvO5+qDQSwhLlDlpcf7igxyyVsI6h7qeZxgL4hku28oTSvP9LS96JscI2p6iNBSFQ9oWkDSSY/9wyKd8OWBzEaOiu3vRQJPkmtj5bnwc3PibvGxS/XO0eCz0Vfr2hruKFAUONl4cdV8AL6d2n6hwHQ4jkkwAwOf9o3luGCZO1/4BsPgldI8stA51cIFEQle1FvwDUXvr004qO8nk2xiHR8HHA647j4gxit45nHy0kBBb+brIW8xttO/tawXh2INLWnh2Py+I3Qsq8/uN84ZI9Y2Bkrq/aUyyWi6Yu7Z4grQMqTpxLIlOU7YOQdhOsWjEqpWjYcf/mj3kJkUw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1463.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(39860400002)(136003)(366004)(346002)(451199015)(478600001)(6512007)(26005)(2906002)(36756003)(6506007)(6666004)(107886003)(41300700001)(86362001)(8676002)(66556008)(66946007)(66476007)(4326008)(316002)(5660300002)(38100700002)(8936002)(6486002)(2616005)(83380400001)(1076003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wOEjLoK6vNH7icPiziiYBKXNkBs0wGuS2czVaVU2e91B/dyVfQBPqf6AotOU?=
 =?us-ascii?Q?BDmvCKQWKtxKLKLQsYdADijbpETQg/Sk1KJ5JqAX4Sbn3iKU7sOWepB/0gjW?=
 =?us-ascii?Q?9Kw2rzt6vVcEWJOwOBmvAlUZ7cFOydJHWVZPfVfFkJzIiXqjq5KQGY8NJrVc?=
 =?us-ascii?Q?9bzFUo4cW8PjJbQnOWYI99oc0a4eCB8pVDA+eVIVOT8iaQ19o5GAzMZuK8Mj?=
 =?us-ascii?Q?5jVjeAR+zynOb5sJM558vsqvrrGYnkCh/RWtlEpCtTRYUHkzzCVHGhBcsXZi?=
 =?us-ascii?Q?x7OSYwDe0N9RqKx/U5M3WqPYA+i++pJoNPxFIQ5fg6HnEH2S2iC77IRqnC1I?=
 =?us-ascii?Q?hwnOIbbdDOrlqKbjRd6DM5Nj0uHkGmSIfZ2Vox2JMPO+CecXDHbKDTpQE5PK?=
 =?us-ascii?Q?bfJBXgwE2KzAm0Pijf6HZRTAcKVkIiLSFVabk7k1mdoSrvV97Ye6lsUdesQZ?=
 =?us-ascii?Q?SauOY5jXvmjFNbz0B9kEQ2aAzoArB14bVVKuzujDUtZzyePTKZTGuFduhgkB?=
 =?us-ascii?Q?G5coXRxDTazc0pPq+08ybnK7MSfuf5UOCcO3oeCQK5PD19D5NRsNnYERNGCv?=
 =?us-ascii?Q?NIg1aX4EfMRBOQG412Ut9izxDBmUyp+ODwBCkF9GYj+u8wMWHGf8gXgjQei4?=
 =?us-ascii?Q?eXFv54ydPEYvAG5XmdcOnlJzNXYVFzaFe62gfQyWAn9KrftObiWdIr9KNmlw?=
 =?us-ascii?Q?2wQRM/nwvrJGHlLSYPWIMuxunPMw38UfX5G2E4W9uoU+32tnsC5nBKtLw1BB?=
 =?us-ascii?Q?HSX/p0mugA+I32k7wk+28F5yjjHjAWMstf90j5fiH55mxCa4bbWMTS8L6C5u?=
 =?us-ascii?Q?zHmubHSIElkR9+3yTDIAe/ZCSH24pMrtpWpZXuvv8y0KNXKhDbAoRlJXnlDM?=
 =?us-ascii?Q?gZVWNyMKEUM05KuL9/O/9XzjI2Bh7RvWjZ1BP16MzelVvdzXfvkQ3Ii1tNdq?=
 =?us-ascii?Q?BQ6UxOqPbLa7ZTGVx7Z1lKm1eDtJkuktVZPhj2b22EUbyelExzIYbrIxxIvP?=
 =?us-ascii?Q?tfT7292XQ6FHZWAXfCh2E7G1ormp0CPIo3YrcNb8S4bRyfoHqw6NaoUSBncw?=
 =?us-ascii?Q?yM4JEQVKGenYH3C/UgFx39YrOG8kLp0fF87AqPVwiw4kJAnhfexoqpYFtpM3?=
 =?us-ascii?Q?uemeRUc1ehFs6qoxJHoeEOCn0KzG029B8ejy3MiZsiYWQ6KKhKHkRv1omkj2?=
 =?us-ascii?Q?Y0PMqBzI0Cip6iPAoK9JRTcVg3pCC7hY2yxIF88uzccfZ2i9P1okC5mWxp9H?=
 =?us-ascii?Q?RiynuWF7sfWuL35bJk2cEmsn/RtXpRJ1chUkRubdlXv2Aiz14wBWUv8jB2jt?=
 =?us-ascii?Q?odjkWjT86zjPOcyDfwvWGl00PAsDplzbsPVyB67pmPFZTJJtcxnGeDqBeW27?=
 =?us-ascii?Q?lbNP3X2Eg50t/LnZtSe2CcF4Frs8IG9ZxrSXj2mcc4xI/8VENrcm3IL/JQAk?=
 =?us-ascii?Q?0NeJWmvnApZI0iqvLS6PraWSfDTJhxdTcOrROm9pA0n4L+T6TPzOTmyfj4f/?=
 =?us-ascii?Q?ARnyKWKXNz0X81k+MD1j6WBPH+eKE8Qtc4jR4doKqyHDuCVHXHxx9Qjq1NkI?=
 =?us-ascii?Q?WYSZvuz8SZrEkCKRvocOgt+ztfw0Vm6uR63t+gw30KTY0XxKT9C4gobeCLR8?=
 =?us-ascii?Q?BQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 718124df-0da5-414b-4b85-08dad9ac81dd
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1463.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 06:13:36.4431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DnFuLuPDP9wRO1ZArTvML41V1qt0drl9erwCzEW3VFBB0qFHId+/SSp4Jxh490ykVglMPSK6qnk4CZAhowA6iJs/T4wTLEyHvIDPvpAhv/w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5066
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_02,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212090053
X-Proofpoint-GUID: 6BzEfYiVrgiX3JGpM0akc1R_0qszJiKe
X-Proofpoint-ORIG-GUID: 6BzEfYiVrgiX3JGpM0akc1R_0qszJiKe
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute_req is going to be removed. Convert ch to scsi_execute_args.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/ch.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 7ab29eaec6f3..58e7d5ee1a62 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -184,20 +184,21 @@ static int ch_find_errno(struct scsi_sense_hdr *sshdr)
 
 static int
 ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
-	   void *buffer, unsigned buflength,
-	   enum dma_data_direction direction)
+	   void *buffer, unsigned int buflength, enum req_op op)
 {
 	int errno, retries = 0, timeout, result;
 	struct scsi_sense_hdr sshdr;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+	};
 
 	timeout = (cmd[0] == INITIALIZE_ELEMENT_STATUS)
 		? timeout_init : timeout_move;
 
  retry:
 	errno = 0;
-	result = scsi_execute_req(ch->device, cmd, direction, buffer,
-				  buflength, &sshdr, timeout * HZ,
-				  MAX_RETRIES, NULL);
+	result = scsi_execute_args(ch->device, cmd, op, buffer, buflength,
+				   timeout * HZ, MAX_RETRIES, exec_args);
 	if (result < 0)
 		return result;
 	if (scsi_sense_valid(&sshdr)) {
@@ -254,7 +255,7 @@ ch_read_element_status(scsi_changer *ch, u_int elem, char *data)
 	cmd[5] = 1;
 	cmd[9] = 255;
 	if (0 == (result = ch_do_scsi(ch, cmd, 12,
-				      buffer, 256, DMA_FROM_DEVICE))) {
+				      buffer, 256, REQ_OP_DRV_IN))) {
 		if (((buffer[16] << 8) | buffer[17]) != elem) {
 			DPRINTK("asked for element 0x%02x, got 0x%02x\n",
 				elem,(buffer[16] << 8) | buffer[17]);
@@ -284,7 +285,7 @@ ch_init_elem(scsi_changer *ch)
 	memset(cmd,0,sizeof(cmd));
 	cmd[0] = INITIALIZE_ELEMENT_STATUS;
 	cmd[1] = (ch->device->lun & 0x7) << 5;
-	err = ch_do_scsi(ch, cmd, 6, NULL, 0, DMA_NONE);
+	err = ch_do_scsi(ch, cmd, 6, NULL, 0, REQ_OP_DRV_IN);
 	VPRINTK(KERN_INFO, "... finished\n");
 	return err;
 }
@@ -306,10 +307,10 @@ ch_readconfig(scsi_changer *ch)
 	cmd[1] = (ch->device->lun & 0x7) << 5;
 	cmd[2] = 0x1d;
 	cmd[4] = 255;
-	result = ch_do_scsi(ch, cmd, 10, buffer, 255, DMA_FROM_DEVICE);
+	result = ch_do_scsi(ch, cmd, 10, buffer, 255, REQ_OP_DRV_IN);
 	if (0 != result) {
 		cmd[1] |= (1<<3);
-		result  = ch_do_scsi(ch, cmd, 10, buffer, 255, DMA_FROM_DEVICE);
+		result  = ch_do_scsi(ch, cmd, 10, buffer, 255, REQ_OP_DRV_IN);
 	}
 	if (0 == result) {
 		ch->firsts[CHET_MT] =
@@ -434,7 +435,7 @@ ch_position(scsi_changer *ch, u_int trans, u_int elem, int rotate)
 	cmd[4]  = (elem  >> 8) & 0xff;
 	cmd[5]  =  elem        & 0xff;
 	cmd[8]  = rotate ? 1 : 0;
-	return ch_do_scsi(ch, cmd, 10, NULL, 0, DMA_NONE);
+	return ch_do_scsi(ch, cmd, 10, NULL, 0, REQ_OP_DRV_IN);
 }
 
 static int
@@ -455,7 +456,7 @@ ch_move(scsi_changer *ch, u_int trans, u_int src, u_int dest, int rotate)
 	cmd[6]  = (dest  >> 8) & 0xff;
 	cmd[7]  =  dest        & 0xff;
 	cmd[10] = rotate ? 1 : 0;
-	return ch_do_scsi(ch, cmd, 12, NULL,0, DMA_NONE);
+	return ch_do_scsi(ch, cmd, 12, NULL, 0, REQ_OP_DRV_IN);
 }
 
 static int
@@ -481,7 +482,7 @@ ch_exchange(scsi_changer *ch, u_int trans, u_int src,
 	cmd[9]  =  dest2       & 0xff;
 	cmd[10] = (rotate1 ? 1 : 0) | (rotate2 ? 2 : 0);
 
-	return ch_do_scsi(ch, cmd, 12, NULL, 0, DMA_NONE);
+	return ch_do_scsi(ch, cmd, 12, NULL, 0, REQ_OP_DRV_IN);
 }
 
 static void
@@ -531,7 +532,7 @@ ch_set_voltag(scsi_changer *ch, u_int elem,
 	memcpy(buffer,tag,32);
 	ch_check_voltag(buffer);
 
-	result = ch_do_scsi(ch, cmd, 12, buffer, 256, DMA_TO_DEVICE);
+	result = ch_do_scsi(ch, cmd, 12, buffer, 256, REQ_OP_DRV_OUT);
 	kfree(buffer);
 	return result;
 }
@@ -799,8 +800,7 @@ static long ch_ioctl(struct file *file,
 		ch_cmd[5] = 1;
 		ch_cmd[9] = 255;
 
-		result = ch_do_scsi(ch, ch_cmd, 12,
-				    buffer, 256, DMA_FROM_DEVICE);
+		result = ch_do_scsi(ch, ch_cmd, 12, buffer, 256, REQ_OP_DRV_IN);
 		if (!result) {
 			cge.cge_status = buffer[18];
 			cge.cge_flags = 0;
-- 
2.25.1

