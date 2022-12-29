Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67194C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Dec 2022 19:02:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233877AbiL2TCr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Dec 2022 14:02:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233956AbiL2TCS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Dec 2022 14:02:18 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55F4213FAF
        for <linux-scsi@vger.kernel.org>; Thu, 29 Dec 2022 11:02:17 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BTJ05Z4027436;
        Thu, 29 Dec 2022 19:02:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=Fm1gZxlGjp7RBqRfD7qXpiFWjff/Bspbt8Xeaa5Ksxo=;
 b=hVZtHCAoRYm4IShVfff4xmuuw2XowbQTwBB/tD1J9dmxWmZgt/zdU0jtazHt8WAV/I/h
 iGQuGQNplJ3q+2XRukEWtDDeoKXtsywiJme4D9A4fNHoXB/qJpd9XlJUH2+MpRtZvzMk
 4C2tQcW9EV+G8calwVmulpHSseBbXwr5T516yQLFlyglpwXTmTTR1fM09UplirUqOKEX
 +ySWK9Ul8IlgQHkbzdM/vv4JB1wDBuVZ8RRiFccJ8TfgCHN9kn/2pK/GWHEdOr6ScHID
 6bIiqH9PqG1pUhX5t6NboBWZQ/VpYr5iQuPvOEKnL0TkGtPfl6kOW4Z43Mdc/QlkU0Tt Ug== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mnrbb7apy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Dec 2022 19:02:08 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BTIuu0J024213;
        Thu, 29 Dec 2022 19:02:07 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2047.outbound.protection.outlook.com [104.47.51.47])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mnqvd2cyn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Dec 2022 19:02:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RRZ9eqVRCXUYJw/Tfdci4mI1OTKXWKtNN2yEPr7iBsJl5O3h2/lCq1MBr9oNDbV7gRA97SxMKPi6Se9kxVQ5nkhjleyhWPc4qYesgFY2vVDHVMtfH/PL5UL5GBV0tXI1qmmAG19NOEOJeIAP3ml1w+Oe+U/jQPmHEOCoxt1cRNCa3ya2Iwusx0u1qF7Zr669oHExjSjUCKKmOlN1Y842LDYu3h6dEBRFIf+708kZPIygEbv3e9jzpmuvbq+HCbTo2VTgUVsa1FAfbJJ2HodoWgpwx6EQSaE78hJdyNfVAQswz6VBztUV10QBhT0xhkgR01bFIaARTzFhgt/po6R11A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fm1gZxlGjp7RBqRfD7qXpiFWjff/Bspbt8Xeaa5Ksxo=;
 b=cfHt6YxydVa8oakKX/afXh+oGKAVqudTM4xq/xidPfVANsVJ2agIM451w5LgZuHvyJt6IpgNyBAK/hFoBvakLJBEmh4rQuqMa6MpCWFHQ3T1v3w5O4Rcs1Lq8k0kWAmllk6SDjuVxWwZBf0tzi8zHhjbrsEZAWrEymiqAhFv6sOcBY7aFcTYoPSaVDOCru4gcw0cOnxvgTE1u67t3y+9dCI6uUHodKIGVwTZE69lPgw9kYSAi+QvLB5X256pASRUTLlGEyEjiob8iGpo4w03h6qTXEPSacPvczCx7RJ1y4hZ12IVLFiKV6Egzo1GOswdWTbissyAl8GabvZC+a57HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fm1gZxlGjp7RBqRfD7qXpiFWjff/Bspbt8Xeaa5Ksxo=;
 b=MCthX9uOyZUyULd8JFqqsNKTXGdD2qIa0Hbks6iomYrD42m1qoAvomfagM0DFWLVVlahE0IPiy/eTKIDPuJWfqXextEh4HAmYQGYUbgV/GNuouY5L1FRscqxk66085gz5id56nEMLoi9BQCC7WqzaXmqTM5pLn5A1ZwXa7s4vqA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO6PR10MB5570.namprd10.prod.outlook.com (2603:10b6:303:145::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16; Thu, 29 Dec
 2022 19:02:05 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.5944.016; Thu, 29 Dec 2022
 19:02:05 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 05/15] scsi: scsi_dh: Convert to scsi_execute_cmd
Date:   Thu, 29 Dec 2022 13:01:44 -0600
Message-Id: <20221229190154.7467-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221229190154.7467-1-michael.christie@oracle.com>
References: <20221229190154.7467-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0444.namprd03.prod.outlook.com
 (2603:10b6:610:10e::12) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO6PR10MB5570:EE_
X-MS-Office365-Filtering-Correlation-Id: e9008444-db9d-4fe9-a1e8-08dae9cf2d76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DlAbbzsl7lICwr0tE8lHUd+cA1nRwRQT/wFtc2nw8Rl4Yub8JCQ0BP/aFFyfjkFIAUC2hxoofJ1OThMyB+yCY69UW+xb/ptUnhK9Des2jwmi7qe3DrXpX80M7sWNzYh3UIgFqmfK/Ir0XSW7762UAs0w1kYo+9K7G5/qyNLRRjf4Jkiqc/qXBgICFPL+zLBOoC4+HsieScOXnUo3DhENGp1WrJzEVP8MfYU09Vj51tqhZjtShuW5pxwpN/OO4sSa8r5FHrN8f5HEVWwVpwpMRrtHulWe5MYmYjR6E8HNIxHDBygHyiH/0Ac6ct3rNkrq8le2YOl9EYdv3I4jJz+uy58OONykMpqKZQ3BXEab+ytFancAfE/G7v1ccmLwj0ERZkWse6cqBpY9bwU9ym9klTKP5H1s0OOyLZdp0Szf3ZNl2l5zLk/kAv1+xYjedHC3MRe3EWmrst3+XK7f/LMQX/DSl4YIKIOs1JkkYdQAJEjN18qJvix1quALZUvwCM5j1crcJ28H7RfLuMMyyvC+anaqSqv2x902uqNmccpK5VrEveHWiCpSiRljz8HmAxLweJanCAfy86/0LA2emAeIOa0DkcL0Q8QUitxurpwEG6RqyVMCtzrNuAkafP2t0OMnKg7yXidW8cPzLGXgT2Wrmw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(346002)(366004)(39860400002)(376002)(451199015)(36756003)(2906002)(38100700002)(8936002)(41300700001)(5660300002)(86362001)(83380400001)(66476007)(66556008)(66946007)(107886003)(6666004)(478600001)(6506007)(1076003)(4326008)(316002)(8676002)(6512007)(26005)(6486002)(186003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zOMLIPkjq72ZW02dEtM0F/wXW3tyeYHO+BV7RCpfTYcY3bM2QJ0AfRoKu/+Z?=
 =?us-ascii?Q?AU57tTVuLTJtrA7Kg8PX45JvHspz9052GqEZZFVxJeNDHUVRGwWc3gB4psPI?=
 =?us-ascii?Q?iOFTzadDtv8ko4ISetSXdbrINRyXaNdmVY0/MEGEcqLDTTRE+KLNS5uGIe33?=
 =?us-ascii?Q?lKOeYp09n9WJ3+Cfg8Ubyjlwmfxc/jVpqJiKzhN1LDmKzF4k44bkjjJd2ogq?=
 =?us-ascii?Q?oeA1Hco98gTZJzs9Ph5j1dU5L3T+QNfjE/006ae8BFUaeJqmMbxtwCrpFj8x?=
 =?us-ascii?Q?xx1vTxQcGRws6SfQhtR+Pm6DXOlqVYE1krWJTfki9tpzAI4fIL+zY3LhowA2?=
 =?us-ascii?Q?t9sN5Uo0b8I/qZdLQbuSr8oHzXd/+7ViotmIKmAfrxKwwObMP63azih5Knkn?=
 =?us-ascii?Q?9ZRo89ug2aUwBhVE93QB2x2Hl1HhcVSKJ65jpGY9NFOc3ypo2N59/8mJ4BRg?=
 =?us-ascii?Q?R1dVFrAx8P+q+IXg6X6k00K9lCMd+MUr/3Kj120Szqyfx51L+KK8qK6aC0vW?=
 =?us-ascii?Q?naDrwzYkmdtu86danARV7H8+OyLB4F6Kb3yXYUHyQGdNMXrFau4d9F/cEwGW?=
 =?us-ascii?Q?XIKvgj9tDxrg65A6uJkkbWf93CUPwza3TzThVMk94MmNFJNPQTHwH5AmPODZ?=
 =?us-ascii?Q?n02RMSwuw7i4nwSePDZPCT2LBEVVyWEiMBZtovSGoU29j3MFYSZLSCxqPyQW?=
 =?us-ascii?Q?CxvGcvHtjgfwr5J4gcezTwZ5VWhzcPTHzrUSxC0xJA5xIjn2jgwL3QX+nkXx?=
 =?us-ascii?Q?0bOPogH3XpOp8Ah678X54anXrNEnvLIsJfQLg+FKX1aHrr3ihJyvGi3tZY5+?=
 =?us-ascii?Q?IXHwlnxN0g/rqnEit41niS1k/BS9RL0zBkzbYmN2bzE/asRuBG9GPh4LKAew?=
 =?us-ascii?Q?k2mVFzdTK4D+IJdpw9YLPijQwRPkDaw6yjuEEHOvQb8bNf9ic/S1EA78tuDS?=
 =?us-ascii?Q?YBHyu2DHFv07ABK+1Y1Dq0QjQmEETDTlFp/TUXRhUdp9zYiLB83Pkt66dGNe?=
 =?us-ascii?Q?krNNrNnCBlnxMUiPRCVzdajuAutZkmjwzbJomIbguAloK5OqpSNkm5K8dFGs?=
 =?us-ascii?Q?iXuBx7LQNC/DJFU3lO+Vc5QTo+T1AslGu+xZv2a5opUYu3eiq/5xV+gWz5xO?=
 =?us-ascii?Q?qk1iceQ+A12TtMig6+0h6l7C9DaXYIZHNaRYpxKT1zIhQNIqcrx/rNXuD00n?=
 =?us-ascii?Q?Afg/hyBp6tno6zj+ZCe4jQBQmWboHv5kyYlZXhvSKC6bcVWlVf9/YOUZfk9n?=
 =?us-ascii?Q?KouxzbM0Hmik/2lAImlPwXyMtPfVKKiTVRcleB/6SpP+eyii2XbK6l4g0Bt9?=
 =?us-ascii?Q?oJdDl+pMXYOUwohJnT5BXtvG6KMUJXMAniUH0dLHx+Bupb42bZGhFuAx1sHx?=
 =?us-ascii?Q?TPg00g4KjeBjmtoM1NCE92Q/JfGwXr8bNeUwIKCZThvlRJUtbZBIeGSkoBn6?=
 =?us-ascii?Q?Diu+IUnOQzvSC3TPYtQRbLFKR6YxdgyoLGQ3biy0vA5YUaUuGRbYTHbp+K6M?=
 =?us-ascii?Q?uCK1kUNlMID3eh7IIdoA5QR8PmcJW0f2HXZnxarovhdFb8NcVO+qAP6kpanJ?=
 =?us-ascii?Q?MpXt8sAAaOawLaSCgM7tM6iGrxxPywrQBNJQtf259Lc+GyzFzghjsIJwZpbp?=
 =?us-ascii?Q?6A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9008444-db9d-4fe9-a1e8-08dae9cf2d76
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2022 19:02:05.7847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /K1GIWRGCCMVxfVAXiBqv7mfYlYRLT4lLRBwfoE/HrlV/1glZAslnvhR0aoRy510C8hwUw4PdYO5Y5lAAxUfgLZZrQMWQ/el2/AIEYroBi0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5570
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-29_10,2022-12-29_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 mlxscore=0 phishscore=0 bulkscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212290157
X-Proofpoint-GUID: u64bIQ9ftjQ1j-z54xspQGHF0gNp-off
X-Proofpoint-ORIG-GUID: u64bIQ9ftjQ1j-z54xspQGHF0gNp-off
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute is going to be removed. Convert the scsi_dh users to
scsi_execute_cmd.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/device_handler/scsi_dh_alua.c  | 26 +++++++++++++--------
 drivers/scsi/device_handler/scsi_dh_emc.c   | 13 +++++++----
 drivers/scsi/device_handler/scsi_dh_hp_sw.c | 22 ++++++++++-------
 drivers/scsi/device_handler/scsi_dh_rdac.c  | 12 ++++++----
 4 files changed, 45 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 49cc18a87473..55a5073248f8 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -127,8 +127,11 @@ static int submit_rtpg(struct scsi_device *sdev, unsigned char *buff,
 		       int bufflen, struct scsi_sense_hdr *sshdr, int flags)
 {
 	u8 cdb[MAX_COMMAND_SIZE];
-	blk_opf_t req_flags = REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
-		REQ_FAILFAST_DRIVER;
+	blk_opf_t opf = REQ_OP_DRV_IN | REQ_FAILFAST_DEV |
+				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = sshdr,
+	};
 
 	/* Prepare the command. */
 	memset(cdb, 0x0, MAX_COMMAND_SIZE);
@@ -139,9 +142,9 @@ static int submit_rtpg(struct scsi_device *sdev, unsigned char *buff,
 		cdb[1] = MI_REPORT_TARGET_PGS;
 	put_unaligned_be32(bufflen, &cdb[6]);
 
-	return scsi_execute(sdev, cdb, DMA_FROM_DEVICE, buff, bufflen, NULL,
-			sshdr, ALUA_FAILOVER_TIMEOUT * HZ,
-			ALUA_FAILOVER_RETRIES, req_flags, 0, NULL);
+	return scsi_execute_cmd(sdev, cdb, opf, buff, bufflen,
+				ALUA_FAILOVER_TIMEOUT * HZ,
+				ALUA_FAILOVER_RETRIES, &exec_args);
 }
 
 /*
@@ -157,8 +160,11 @@ static int submit_stpg(struct scsi_device *sdev, int group_id,
 	u8 cdb[MAX_COMMAND_SIZE];
 	unsigned char stpg_data[8];
 	int stpg_len = 8;
-	blk_opf_t req_flags = REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
-		REQ_FAILFAST_DRIVER;
+	blk_opf_t opf = REQ_OP_DRV_OUT | REQ_FAILFAST_DEV |
+				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = sshdr,
+	};
 
 	/* Prepare the data buffer */
 	memset(stpg_data, 0, stpg_len);
@@ -171,9 +177,9 @@ static int submit_stpg(struct scsi_device *sdev, int group_id,
 	cdb[1] = MO_SET_TARGET_PGS;
 	put_unaligned_be32(stpg_len, &cdb[6]);
 
-	return scsi_execute(sdev, cdb, DMA_TO_DEVICE, stpg_data, stpg_len, NULL,
-			sshdr, ALUA_FAILOVER_TIMEOUT * HZ,
-			ALUA_FAILOVER_RETRIES, req_flags, 0, NULL);
+	return scsi_execute_cmd(sdev, cdb, opf, stpg_data,
+				stpg_len, ALUA_FAILOVER_TIMEOUT * HZ,
+				ALUA_FAILOVER_RETRIES, &exec_args);
 }
 
 static struct alua_port_group *alua_find_get_pg(char *id_str, size_t id_size,
diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index 2e21ab447873..3cf88db2d5b2 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -239,8 +239,11 @@ static int send_trespass_cmd(struct scsi_device *sdev,
 	unsigned char cdb[MAX_COMMAND_SIZE];
 	int err, res = SCSI_DH_OK, len;
 	struct scsi_sense_hdr sshdr;
-	blk_opf_t req_flags = REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
-		REQ_FAILFAST_DRIVER;
+	blk_opf_t opf = REQ_OP_DRV_OUT | REQ_FAILFAST_DEV |
+				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+	};
 
 	if (csdev->flags & CLARIION_SHORT_TRESPASS) {
 		page22 = short_trespass;
@@ -263,9 +266,9 @@ static int send_trespass_cmd(struct scsi_device *sdev,
 	BUG_ON((len > CLARIION_BUFFER_SIZE));
 	memcpy(csdev->buffer, page22, len);
 
-	err = scsi_execute(sdev, cdb, DMA_TO_DEVICE, csdev->buffer, len, NULL,
-			&sshdr, CLARIION_TIMEOUT * HZ, CLARIION_RETRIES,
-			req_flags, 0, NULL);
+	err = scsi_execute_cmd(sdev, cdb, opf, csdev->buffer, len,
+			       CLARIION_TIMEOUT * HZ, CLARIION_RETRIES,
+			       &exec_args);
 	if (err) {
 		if (scsi_sense_valid(&sshdr))
 			res = trespass_endio(sdev, &sshdr);
diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 0d2cfa60aa06..5f2f943d926c 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -83,12 +83,15 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 	unsigned char cmd[6] = { TEST_UNIT_READY };
 	struct scsi_sense_hdr sshdr;
 	int ret = SCSI_DH_OK, res;
-	blk_opf_t req_flags = REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
-		REQ_FAILFAST_DRIVER;
+	blk_opf_t opf = REQ_OP_DRV_IN | REQ_FAILFAST_DEV |
+				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+	};
 
 retry:
-	res = scsi_execute(sdev, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
-			HP_SW_TIMEOUT, HP_SW_RETRIES, req_flags, 0, NULL);
+	res = scsi_execute_cmd(sdev, cmd, opf, NULL, 0, HP_SW_TIMEOUT,
+			       HP_SW_RETRIES, &exec_args);
 	if (res) {
 		if (scsi_sense_valid(&sshdr))
 			ret = tur_done(sdev, h, &sshdr);
@@ -121,12 +124,15 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 	struct scsi_device *sdev = h->sdev;
 	int res, rc = SCSI_DH_OK;
 	int retry_cnt = HP_SW_RETRIES;
-	blk_opf_t req_flags = REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
-		REQ_FAILFAST_DRIVER;
+	blk_opf_t opf = REQ_OP_DRV_IN | REQ_FAILFAST_DEV |
+				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+	};
 
 retry:
-	res = scsi_execute(sdev, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
-			HP_SW_TIMEOUT, HP_SW_RETRIES, req_flags, 0, NULL);
+	res = scsi_execute_cmd(sdev, cmd, opf, NULL, 0, HP_SW_TIMEOUT,
+			       HP_SW_RETRIES, &exec_args);
 	if (res) {
 		if (!scsi_sense_valid(&sshdr)) {
 			sdev_printk(KERN_WARNING, sdev,
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index bf8754741f85..c5538645057a 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -536,8 +536,11 @@ static void send_mode_select(struct work_struct *work)
 	unsigned char cdb[MAX_COMMAND_SIZE];
 	struct scsi_sense_hdr sshdr;
 	unsigned int data_size;
-	blk_opf_t req_flags = REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
-		REQ_FAILFAST_DRIVER;
+	blk_opf_t opf = REQ_OP_DRV_OUT | REQ_FAILFAST_DEV |
+				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+	};
 
 	spin_lock(&ctlr->ms_lock);
 	list_splice_init(&ctlr->ms_head, &list);
@@ -555,9 +558,8 @@ static void send_mode_select(struct work_struct *work)
 		(char *) h->ctlr->array_name, h->ctlr->index,
 		(retry_cnt == RDAC_RETRY_COUNT) ? "queueing" : "retrying");
 
-	if (scsi_execute(sdev, cdb, DMA_TO_DEVICE, &h->ctlr->mode_select,
-			data_size, NULL, &sshdr, RDAC_TIMEOUT * HZ,
-			RDAC_RETRIES, req_flags, 0, NULL)) {
+	if (scsi_execute_cmd(sdev, cdb, opf, &h->ctlr->mode_select, data_size,
+			     RDAC_TIMEOUT * HZ, RDAC_RETRIES, &exec_args)) {
 		err = mode_select_handle_sense(sdev, &sshdr);
 		if (err == SCSI_DH_RETRY && retry_cnt--)
 			goto retry;
-- 
2.25.1

