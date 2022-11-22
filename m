Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F75CC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Nov 2022 03:47:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232241AbiKVDrD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Nov 2022 22:47:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbiKVDrC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Nov 2022 22:47:02 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD3B27FF5
        for <linux-scsi@vger.kernel.org>; Mon, 21 Nov 2022 19:47:01 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AM3ibST003442;
        Tue, 22 Nov 2022 03:44:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=6aL55xrb3H0h1ElkbYyB/ze25mqKHKH49HREymFfPWE=;
 b=hUCbYtEBJx5wX2Zv7tDTIdKlIv3PHCAxPXbrluhXDHFApUQgZbcbMrDXPQNoZOA6uAdV
 pKCr6DfPtlf1RPbQ3+ysGWABXOf3C7z4J9KoM57CxPwTLBl+UwQ+ryNC/fVPUkXHEk9o
 PqVc6IhzOk37Q3s0PChrFtblGT7ZvNcyOobNdFCq78GhckV0AiuDNszzZOEMEMDIaBll
 C+ng6X/BCN9sdRIDefSTw3E5YA6+WUugVSeDqef4RgZWE1xiU9WJUORJ8jh/aZxunjny
 Ht5hFvKQ4ecRt1VjYvlUkpIamveK6Ph/BjiNKhb7yCYI9SvL2coQw/HBDt6Li2Km+HJZ dA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m0pf2r1e7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 03:44:45 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AM3ZkVE039550;
        Tue, 22 Nov 2022 03:40:32 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnkb0yd9-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 03:40:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CUIYHFnkzDhNFCIUhQmgzXlT7ZQ9vcyBDZLWqswGAcHPBkupyME9vP159grC9V4TMy3kWy2iWxYkRuQii+XIzWn8LtYM2awrgTtVMtK+TnHdmTQ4qGGLIJujXwydsoH1sSTsMXH9Ew4u6Emj9pDC2qG8Mjih5ArtWwNOz5kRWlieW0afB3s1QRHmDklMb2hjYAuXOeB/fhwAB26eFYWh1Oe91ODIV84HUSLqZ98sOlfJ69QBUncU85fMFKnPNrpUN/Lj5X0i8N4Vb6kHzLflyKzeumTOkuowy+D3bU2SxltiX7PSZ60LGeOLVQRtNc/RPtny2qyQYIicy6Kbqw/+vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6aL55xrb3H0h1ElkbYyB/ze25mqKHKH49HREymFfPWE=;
 b=Sdkn8+RZFzgkMB/Xk4akjo+uFxipBCsnCn9s7BVv5DnZS+0JLMIcg74oI9/BKemc6zle0oVCnDTx+Oq1C7iNy+PvCVZ/wIXARfOgLEAmIuogt2mBwA/UDqpoyNZpvthdtEI3d2nAB6MRV0cqE2hJx+JWqVwF5w3/eevVxBqAZxzBbnwu69OAf49sSjHVoW1fW0I8Pod89AINj7kKSIBx2hFQSgudNn5YpKElM37QMn94oBF/bkSNwzHQvpqQ+4fGVNKbJHPJOnKx5tL4+MiAfhQkbc3v7Z0FIYBizI3Vv5QRmFcdDm2TGsMX0mts06u5dFc/5FqZQeoBdFau/593lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6aL55xrb3H0h1ElkbYyB/ze25mqKHKH49HREymFfPWE=;
 b=GWteF0xtbx3ldno5xnQOV63K8NKBy6cl3+bau8AJvNHcpnQ/tQ9tk/aYxH6JsrnfVYcM+eUz76HZccdiu1ECvu5pu+uQJDhwa/vRC3knGABF9y8bCduHNfNiK4sE/9LrLgcRJqqGsEnjG6JO01fJNVcfUHlGdqqy/BUmUpYDfwQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB4472.namprd10.prod.outlook.com (2603:10b6:510:30::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.15; Tue, 22 Nov 2022 03:40:31 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 03:40:31 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 04/15] scsi: ch: Convert to scsi_execute_cmd
Date:   Mon, 21 Nov 2022 21:39:23 -0600
Message-Id: <20221122033934.33797-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221122033934.33797-1-michael.christie@oracle.com>
References: <20221122033934.33797-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR10CA0019.namprd10.prod.outlook.com
 (2603:10b6:610:4c::29) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB4472:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c60a8d8-f18b-434b-8978-08dacc3b4e13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sehBbDR0rKUSziGPW7b7kNfhKemf9HNpFbmGNFR5zABbggAHA489QZL7K42a+CQgU+8w6w4K3UeJRf+7UMqISdXQkuOfaxP1G0IlaTBuw8XAowW038MjAn/YMqem2X6m5yHtze3RRsZIS5tTCloTiixghUsj054btW9F65tqg6AgYIT1pc+xAVtEc+JIwc+QB9XpSe+Yiq06WIzq2bF14LilVhUKOK0waaKqy0/fVTurBz7p6pA+ORRo87B9ggaTpu5Lo0Pjc1Dj+Yh8XVUx/zOGdRG1nmozJFCm7+j420M44o5OnSpBhrMdypx3vtz14rUWcUHdxhKq1nr/6Ij5TlpMhJC+VX6Plwz4ohqU5wTibP/SZVC0G+R9iiK0WhiYrM0ew73tgIut91NGdd2Bss8dPJyPtWVTpPKNuGSpkQ71N5JXK75fOaXbZW81W3iSdQj7LTkfEskZ+kpYFm3IS8T0XLhKojhMeuhIo1tDOnga5gBi06mMBHl5t7sjfINCz/uqRJUW+pphQ/LaL4wCZxGnCFj+4e4J3KThL3Yk8aJkmyy2ugy7krTXKXfKakns7wgTH+t6GHW6Psiw9R3pWPaJhQY9AuXLj401ANCjvRYQNrtsmyFUop8Wl/+lqExja+gHYiqa5I7tdcv40AyKcQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(136003)(346002)(376002)(451199015)(36756003)(38100700002)(41300700001)(2906002)(83380400001)(86362001)(66476007)(6486002)(66556008)(8676002)(316002)(66946007)(4326008)(6512007)(186003)(26005)(1076003)(8936002)(478600001)(5660300002)(2616005)(6506007)(107886003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eVBRIdpQWBlhdNjVnXDtC6IZyrpAlWSxCfUxPtpextJdzITwl0pXKNLOvKCY?=
 =?us-ascii?Q?6kekSVDUs6gnn8vF9bYDNonxfc87WQrcsZINo448nc33gmg3pAG4j3h8IAMT?=
 =?us-ascii?Q?Z0GGgt2renlqOmWbr3Q2fN/bCxx6c9lqEZ4BP4D7lAmeFttDGwS6owjxqT+E?=
 =?us-ascii?Q?1W0muMSgleXCYF4GVZ++AUi8XI8udjsh2OZpaEe+5MaHyZCAKJlvyZC5j6iF?=
 =?us-ascii?Q?EqXXo/AfhdJkbA8SA+2tah23jXYl8B/ecvFTaGmYg6S18rvv+oQIxb9wYDdi?=
 =?us-ascii?Q?CIaDiHVzmPEYz8zsrOdDEaXMQ6AzMnKDeLMfPFcj61xFyuE1hjuQJKxjft8x?=
 =?us-ascii?Q?tFN4pGO3eYo9td3cbL2R0YaNFUuu3l/ZEJSm9BVJadDm4mRKm/XoPNCid/9J?=
 =?us-ascii?Q?IShgcLbAYBodWt0F5cQnz1UtzVf842g2OlqZd9AY64RIDABjDsM0+p+sBS0S?=
 =?us-ascii?Q?PXqEWfLqPj2mTGEzxx6n+r4o61Z+yG56lFnR8yN8aCXSclnegED5qC8+GuiI?=
 =?us-ascii?Q?5pUipeLlX83f4fZ8VdUowvbZW2+zFmp045+W1U/qxTQIWBa/99J/17CgO/sy?=
 =?us-ascii?Q?6A59DChNFCjoJK6iB+vus3smgWYk95SvAJsYkqVr9g40gm4OJF4FD0lFQdsz?=
 =?us-ascii?Q?FXQUJLnW7C8ReyB2a0KAnRNA0NB4TJgouSd0AbdmVz9zItP/xHFmSmjOnK1c?=
 =?us-ascii?Q?zfFeUCdDN6oI8zPXqZMimukM4ddz5w2HIVc0ZPInjH6nPLbg11S+LSmu9js+?=
 =?us-ascii?Q?iF5ow+VBSrTmy1ODON+Yx5yNRhKG1M5JTrsCInoekWaJ15ZAk7dW5gS66gCe?=
 =?us-ascii?Q?FdYUCpdq8dKVUgLAcesMmYHQ60bwjDPBfcjlDxveX3OSNci3GZ3lENudQd6c?=
 =?us-ascii?Q?1oqBgRrQvZnx95O/X3dSTLSZCi8LO3yA/LCRuyIYTayp107Udjdat7vpLgY7?=
 =?us-ascii?Q?oBVS/bCxPskQR8KVfVDV+yvO65XG+DNQgJ74SZYTRm46s9g79aq0bMApuaTw?=
 =?us-ascii?Q?53pCZD42BJrWC2RDv3jtWXIFMFHTbHc8r3TPOfpdjNxxCwAWRaiyGeVKOHvc?=
 =?us-ascii?Q?xJt27PvpekCbsgMHdbe3Ys6uZmdMPlGGjNPNN2vYa1tPl4vtMtiWUpLxieY3?=
 =?us-ascii?Q?ZD0xDRhqecag1IqiDs+i2ZbFgUcpEEOzERdu/wTX+3zM89HpTM588AF2cR00?=
 =?us-ascii?Q?iuqN43ZDbwBAg6dJ3edfVB4/C4OMDhFaeeXK9PIX6H2570vaDccxNqCx8rh1?=
 =?us-ascii?Q?S7pEXYhL/6qHFQvu8PKNREs78fCWCbjQ5YYdP5Hsi1Pr3/5IS9iH5uJS6afi?=
 =?us-ascii?Q?qZ5mlIgbTMsYSvsV63SPU1qviQclo7MpIxghLt1AbaRrwSyiy8plRl8+Ajl0?=
 =?us-ascii?Q?JkJ8qk5q3KN5oO98hRYsrzG2Zs3Fmm4eRHx0NhLUCUt8J6plIP0aMAJjljLV?=
 =?us-ascii?Q?rh5x0aTxGEoE8EBkgMv+6LRFk7A2DU6teRoriY63O9qzEnt99P6KeCKm2vt8?=
 =?us-ascii?Q?9Kn9tBEaXRwPTfPrX3wWbENQ2d/PDbdLkb5UEJLVmoUdjk/ZWSxwjH2kpHf6?=
 =?us-ascii?Q?Mq25DL26ucuiyMN/Hrs28Eu36Iy3I1NIWwNmITrpeqhS+kUG2sqhzKa5HS8j?=
 =?us-ascii?Q?uw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: uBm01/ITEIQWtbCkrQ8qmdK73x30fcVhyiZuauODH2kxyYMWIps6yodMC3VJ3yoqqxD8Gz8EjgvY5w2c7WwrpQprvaSTgzjtxszcIX1SfFq5RdiKDUTBd+utsrsF/tz/r8AB+RQi/GeDZ4OX0n53aHsQE7QW7mvKuL01hlcWlVDA5EN3lu1WFkxpuSmGTnQq1zG3P1EahhSRgs+Cescpop6PLaZ4hoLdL1+aXfs9K9cv1nBwsGrSscQrJ8Uy4hOV0lX8zKlIZHfnD2Td2qVUARmmoHm4Sj726H1eaR9AKcu1jLG2lhixe/9Uyqw1mu3l+DgHT4E/zpgPg/kAyS4mWhKurt4DNlSLmicIaeFsG1yISU8NV7G9tQARw2+DBnTfsbRVaaGEcV89NYNFTstk42EHJQP2RJXS3ax7ppwWXoVdvV49SX7NEvc8yicjaU6QazXKIgQvoSQ7vjwFqLIx53YyshjTOvH+hZgBsTdYSPAroAaBsfQ5h9Ci1A7OWxXZA8zdNaW+fjDLYOrXMVGxrcb6ki5FOSdL70WYcbYN7dp5Yz4qK+ia41Rtgx9BjqA37NskGqa5/VQiF5CkbYE3j8HuJld24fGKUGsYXfsWMpEu60ZI3DfxYgpJzR/cdv4tpEL1r5fvtgtLHi+NvNV1hXcG4rV53P97B7RPtdnnrti5jlgyS/2/DlY4HmB+4zIrXg/zrcxzgpPJXNfdjZXkA3CZ7YGjfedxCjvr6FZmvSzectUQ2rIo//kkri1Nnu+NbaLATMbdv5ieliIqeEMeNmtf+42sFSqwFcVL7nEzu0UPqreVdOm4YFC+tY9/N1mnjJSPDTIztQT0tQW+F0Wz3XMAAxeM+Nj1Itb4hmYo8Y1g1W2NczzYh6WLn5UOQ+pr
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c60a8d8-f18b-434b-8978-08dacc3b4e13
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 03:40:31.2323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fj6EKL+DTWu9zF3L5ZKmwCd022cCtoNHdVQGJKQTE0PfLEnwVZc740ALa/umRfoTxMpTGcTZEh0CagMVOrk0JtK1Y7PE458hDcsfhTT+wuA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4472
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_18,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211220024
X-Proofpoint-ORIG-GUID: cq2JFVgU_UOr990KOlToUkbd9LN1be9K
X-Proofpoint-GUID: cq2JFVgU_UOr990KOlToUkbd9LN1be9K
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute_req is going to be removed. Convert ch to scsi_execute_cmd.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/ch.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 7ab29eaec6f3..dedfa84476cd 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -184,8 +184,7 @@ static int ch_find_errno(struct scsi_sense_hdr *sshdr)
 
 static int
 ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
-	   void *buffer, unsigned buflength,
-	   enum dma_data_direction direction)
+	   void *buffer, unsigned int buflength, enum req_op op)
 {
 	int errno, retries = 0, timeout, result;
 	struct scsi_sense_hdr sshdr;
@@ -195,9 +194,9 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
 
  retry:
 	errno = 0;
-	result = scsi_execute_req(ch->device, cmd, direction, buffer,
-				  buflength, &sshdr, timeout * HZ,
-				  MAX_RETRIES, NULL);
+	result = scsi_execute_cmd(ch->device, cmd, op, buffer, buflength,
+				  timeout * HZ, MAX_RETRIES,
+				  ((struct scsi_exec_args) { .sshdr = &sshdr }));
 	if (result < 0)
 		return result;
 	if (scsi_sense_valid(&sshdr)) {
@@ -254,7 +253,7 @@ ch_read_element_status(scsi_changer *ch, u_int elem, char *data)
 	cmd[5] = 1;
 	cmd[9] = 255;
 	if (0 == (result = ch_do_scsi(ch, cmd, 12,
-				      buffer, 256, DMA_FROM_DEVICE))) {
+				      buffer, 256, REQ_OP_DRV_IN))) {
 		if (((buffer[16] << 8) | buffer[17]) != elem) {
 			DPRINTK("asked for element 0x%02x, got 0x%02x\n",
 				elem,(buffer[16] << 8) | buffer[17]);
@@ -284,7 +283,7 @@ ch_init_elem(scsi_changer *ch)
 	memset(cmd,0,sizeof(cmd));
 	cmd[0] = INITIALIZE_ELEMENT_STATUS;
 	cmd[1] = (ch->device->lun & 0x7) << 5;
-	err = ch_do_scsi(ch, cmd, 6, NULL, 0, DMA_NONE);
+	err = ch_do_scsi(ch, cmd, 6, NULL, 0, REQ_OP_DRV_IN);
 	VPRINTK(KERN_INFO, "... finished\n");
 	return err;
 }
@@ -306,10 +305,10 @@ ch_readconfig(scsi_changer *ch)
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
@@ -434,7 +433,7 @@ ch_position(scsi_changer *ch, u_int trans, u_int elem, int rotate)
 	cmd[4]  = (elem  >> 8) & 0xff;
 	cmd[5]  =  elem        & 0xff;
 	cmd[8]  = rotate ? 1 : 0;
-	return ch_do_scsi(ch, cmd, 10, NULL, 0, DMA_NONE);
+	return ch_do_scsi(ch, cmd, 10, NULL, 0, REQ_OP_DRV_IN);
 }
 
 static int
@@ -455,7 +454,7 @@ ch_move(scsi_changer *ch, u_int trans, u_int src, u_int dest, int rotate)
 	cmd[6]  = (dest  >> 8) & 0xff;
 	cmd[7]  =  dest        & 0xff;
 	cmd[10] = rotate ? 1 : 0;
-	return ch_do_scsi(ch, cmd, 12, NULL,0, DMA_NONE);
+	return ch_do_scsi(ch, cmd, 12, NULL, 0, REQ_OP_DRV_IN);
 }
 
 static int
@@ -481,7 +480,7 @@ ch_exchange(scsi_changer *ch, u_int trans, u_int src,
 	cmd[9]  =  dest2       & 0xff;
 	cmd[10] = (rotate1 ? 1 : 0) | (rotate2 ? 2 : 0);
 
-	return ch_do_scsi(ch, cmd, 12, NULL, 0, DMA_NONE);
+	return ch_do_scsi(ch, cmd, 12, NULL, 0, REQ_OP_DRV_IN);
 }
 
 static void
@@ -531,7 +530,7 @@ ch_set_voltag(scsi_changer *ch, u_int elem,
 	memcpy(buffer,tag,32);
 	ch_check_voltag(buffer);
 
-	result = ch_do_scsi(ch, cmd, 12, buffer, 256, DMA_TO_DEVICE);
+	result = ch_do_scsi(ch, cmd, 12, buffer, 256, REQ_OP_DRV_OUT);
 	kfree(buffer);
 	return result;
 }
@@ -799,8 +798,7 @@ static long ch_ioctl(struct file *file,
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

