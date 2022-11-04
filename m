Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DEDCC433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Nov 2022 23:25:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbiKDXZN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Nov 2022 19:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbiKDXYf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2022 19:24:35 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F9823BF1
        for <linux-scsi@vger.kernel.org>; Fri,  4 Nov 2022 16:24:33 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4KhvO0026517;
        Fri, 4 Nov 2022 23:22:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=5VBOIbxCmCDCbH7p7/9/NxCP7ayVegHA6gbJGxtXhXA=;
 b=H8DxPdmWobdwDbb1Pp4oXujbNpdbLJrTzSBVEA4LcRIsbvZVocgEPXKmMlCi/teD602l
 /ULiY3oiOPWN0YriNIgJd99rfz3SvDJnwrChbtREmF7zkD+YOZZPyw20OavZuyhQ8rNH
 R7TmRO5wss+a0CccogURt2QdSB7Jk/6RKSWoNWDPixLfvZWac/E2LGbirZ34qr+0Wbf6
 H0NnXbId0F3AAKBEmHOO1OUOPWQqJcUQYXtMqHydG95xyknLxcOURc5fG+KGhlrKR8Nu
 R1juZ7GPbB6DqUpMuBKsakOWPxrfpHL3yin4d4kdRhRUgof5Aam9T0eAwV3vQBxMl+CN yQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgtkdgf04-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:22:26 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4MUQ5B029964;
        Fri, 4 Nov 2022 23:22:26 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kmpr9a9dq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:22:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dkS6x1rFmCnGjkEmQeXuKnt9GSUsNuDI1/H31l/wUYPQIdwPFIl2H9pq+z2vK5U3vNka46YjmuWTISLKu7q/igqsYOgl0NTJxTfGdVqy5BnpiL6M2rrOVyCA89BAHLzGF0BRFW6h0JO5aI1XQONychnNA/BhVYTHiMEjAFKgjaatdy9mD2uRSJYJNOYXbd41+S0nR223nxzPO25iIDzaDIEZU6jd2xfJta59CK50tkH/hytmNYM3dO/s+7jajzO3iQETht1LzcHbrok+S5y5q/IDH1NtrQd4/M/bOO+8NSENEJnxzICkSARdDOnv9tUMgThO+a4/Wb2cbNwS8tk9sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5VBOIbxCmCDCbH7p7/9/NxCP7ayVegHA6gbJGxtXhXA=;
 b=QmiBsFxt9hU+xY/tKrjR/cYe055uu5qUNI/J5xvTTFyZo9YYBHhpN7N60oeFIDzwmLWCL8sJ8qFXUblSupu8IGKrkqynEDAevAarytr1SF5BJJATPutNO08oEWtWsGQKFAxw9RA1m5m1INqGo60eDvI5oY+ctH5hWrWm1/SYZuZ7P1dAayajgImvuvm/2IvNiah0UZ8puj6xNa43FLJn7xCMqTrVKn5CXyrNbjjdm5o2icSQntDpDAjAGMrdlJNMm8CaSTj8wB8AWU6NMZFK7eX5Z7u4ac7Qs94dRIql4x2O4hjuSTz/6T8rRowoAHQdVA5MXGI4tTs67U+NvtuLFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5VBOIbxCmCDCbH7p7/9/NxCP7ayVegHA6gbJGxtXhXA=;
 b=yJcu7NFGuQpYW8kVGD8IqsO6E3gVWMY9WqHPHo+IkoTIXNikuMn0GHCmdJkoBYrC8fdLC8xBARcxv/3+xJQvjBICT17YC7sSsFqWalK0tzMKFt+rzAoNw+/lw0s2N0w2lfoQORIfZamZiTvxYqVjW1Z2kf4WPlTfuWuo61qAeso=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO1PR10MB4433.namprd10.prod.outlook.com (2603:10b6:303:6e::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.22; Fri, 4 Nov 2022 23:22:24 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 23:22:24 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v6 27/35] scsi: ch: Have scsi-ml retry ch_do_scsi errors
Date:   Fri,  4 Nov 2022 18:19:19 -0500
Message-Id: <20221104231927.9613-28-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221104231927.9613-1-michael.christie@oracle.com>
References: <20221104231927.9613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0P223CA0023.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:610:116::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO1PR10MB4433:EE_
X-MS-Office365-Filtering-Correlation-Id: 0009220b-b52b-4c76-8f68-08dabebb6753
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gvZb+I+c/iacqmmhIgcBRPi4ZD7zk2jeXePpnnDEFKR82yklTaHsnG0Ft8vX46AOurt1gHpdXAqblG++fi/SnFRDq8TuDd6KeXCJhnhzPbTe4ezvOz8w4gkhJzG3OTlPlsvFAMIvFP/jaIA/DqNWdOL/c6SqZR1DimOMWm8N4FyMeIKgJmUeEBXmfTcemgsXyRlj/844vhzi0n9aQ1lMtYpMNMduEdTd+BRFFB9vvZUowHvv6TCmTyG4T5t4YVxcQokbyBspXikzXHvDGWwDpOIt/ud4f9iidGRt+RmwFsUPUrffJm8VpZd2Yc1uiUufjTQxbu5fPrk2Sk5K4tQ8vrlbtdtgjPtKkqqeM5C6iKSM9Q9ZO418PPiqdvVmEL27buJjNEXFtd0TETRIfNyuVvbiHRjmNAxNl37/g9oL0zz6qIo7uVl7fFb6laYFWAP/Z8SAL2NFKp3Q/tJdGnFwcyoZQjVHLi4OPpP6FqM9OR8KCCBsby/uJRCRA8+adO4uAJcx6JO5FgzRwSnjMZQEKbVloeIPHLSxuAbapLzaQ2siiu9e3yU27Vg3dwm8rDIt220Ge8eTpkH/z6WrYN79Im1Y2j4ZKqE5pCVgss/SqX1C1xs2XGwlRnoZ7AaAlz4IIRcIlloF5QqS8eW+WZtZYfU0a3HBYbUlmXlDHvRuWpafgIuFZEzdcWYGbu4jFeiaFVH5LV4rZTr4kG1koDqulQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(39860400002)(136003)(396003)(366004)(451199015)(83380400001)(8936002)(41300700001)(5660300002)(6486002)(6666004)(86362001)(478600001)(107886003)(8676002)(36756003)(186003)(1076003)(2616005)(4326008)(6512007)(26005)(6506007)(316002)(2906002)(66946007)(38100700002)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DgUOW82DFMw23jg8b/o8z91bZ7ASae04neS+7MJjtbxEolg1uGDvtWfZaXgP?=
 =?us-ascii?Q?uUoIoM8r/T4Z90u3M6r4xUAAdcZ78QEodbl1WlRES+g2FccOZCgGZ+faV8cA?=
 =?us-ascii?Q?C2pD08Tf6M/fB2iaWV0jSNIYiBlwEkTALklztdZnBmVpChwqJAP4sArqa9lX?=
 =?us-ascii?Q?TakkWVsWcWE3hpkiPjlxG8NhSIytj5aUzPb05TdAcbWvZcCaFTmwuugriSce?=
 =?us-ascii?Q?taLjqNsxQ08kYZPfyDl7G4ynVkjYjpRL9daHKGJpjmqyVOYwxPUFwqELE8Ue?=
 =?us-ascii?Q?61U67pwo8viZvCKSRhVMzY5IvwTXhcp9BfIYrg6pgsOv8QQ4Li5gaWG09vLg?=
 =?us-ascii?Q?4zxoaOOE8SEyh/LHTl2nH4O3gGBdmHuhbjlHARpLHKMkqcLOdy7p01vd9N8P?=
 =?us-ascii?Q?opu+INGKSC1ThVyRzWAvq1ZMVSRdegACJrX0Ga+BUZGTVOJR2l03u+96oiDP?=
 =?us-ascii?Q?NmxLdAZsFOQi/US6C3CmWyaBZRYXjVBB7KL3+iN0sKeQXdgaixvl0KgD/t8M?=
 =?us-ascii?Q?h7pR7NnsqKZpAgzoiWuDWzg3jhZhSCuqlKDHw3dqWEcYmCIrJyCv6uG27tMi?=
 =?us-ascii?Q?X64OFryzyGzqDKGomXMdE24NGI7s7DIfNotaqrulstuVgj/2qHdmwRs8ia2R?=
 =?us-ascii?Q?+01BkD+XXcp7B6XIMY0TzoN7/q9dkMU0DPq3/BXwPFYGyvQo93yqmY+pPbqO?=
 =?us-ascii?Q?nSEKDRqKIuGbODbkrMNl1vcdFkllo48Y1yBLOCuLYtt1z4wASCLCucJtOblZ?=
 =?us-ascii?Q?N6TRZxGpZbwmU/PZPIoikCd0UnLZCrCcYcGeO9d9W32JxxDCgmpYAi/6p+sY?=
 =?us-ascii?Q?FJYD/dr6Kn4L03SBQH4DBUstcJvuR2KKDfpiGqKtor8JDNwI46UZXQgmW7hK?=
 =?us-ascii?Q?soZ2dGC/D1D/EZ7lfBrfOC99fqd7gs6U53A2xfIfqI867xYItuOINxkiy/iy?=
 =?us-ascii?Q?yaJmPmR/kCXZCKC/TzNauaYLw2Mm3kevPyiEWBVNArZ7J8rNUWgxTxK3hf4V?=
 =?us-ascii?Q?ysw6QdBh+i9BZmimjZaKU5Ks1uBBWbLULeDNrLj7wC58wq27GGNr9XiVrWIm?=
 =?us-ascii?Q?NNYDISjxe2PzrdAMg2nkttMP+X/nk9NbqbaeDSbNbm5VAQi+KVWqxjjngX4D?=
 =?us-ascii?Q?shYydXnyfqBx1IMalGoXFwHQeDaVkq87RLDEImky+p/bCMKMPQ2DfD1Woi9O?=
 =?us-ascii?Q?5X24cc4+acOGOyIagqhBlej+9o1U1PoF/VhfVGACPqnqTPztoRFUUGpCxecn?=
 =?us-ascii?Q?vOhmuBFC+e2FU/ddncCqO/2o8oOAxrC+DgYoMLClKA7yJ1EPKRnV5yz+baY3?=
 =?us-ascii?Q?NxxTo3JAw7BR++lQYFkUWJGL6GzcDX/Dqn74frjv218G5BR9l19UFuNkXVLM?=
 =?us-ascii?Q?6v8ixCnqJsYwGAS9gb2I8AOyBYEgV719xFCEF4tVsqDQnNmkKrNOWK5Q6Xq9?=
 =?us-ascii?Q?der/M1QaY15TlJsjRDON3hpGXgN3Bo2bPp1fptYxj9InYClpi+b6Nk4xpxzt?=
 =?us-ascii?Q?Y0u45nh31IaPv4IFU4kdfJYfBvgTteA2aKMFALxOiUri15sE+r6shzwZxX3/?=
 =?us-ascii?Q?mqgIaOkWenrM6TBPlZAZyjLEYT48x2Z9GpfrEkzMReQky+2JSZ0FPV9mUPq3?=
 =?us-ascii?Q?pw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0009220b-b52b-4c76-8f68-08dabebb6753
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 23:22:12.9287
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U/YsYOlYu8T2DhESvLV2MPeYVRHPCaEi4ewnDRU43ecYOyGYtTZOOXYbokH9vtAt8xkuAsSrTg5T+kUusgwt74if7uhjvsbitTbR3Mijzvo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4433
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-04_12,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 adultscore=0 phishscore=0 spamscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211040143
X-Proofpoint-ORIG-GUID: s4E3wrNSqaKeIfJLdX-kp6vwVpEHHTEg
X-Proofpoint-GUID: s4E3wrNSqaKeIfJLdX-kp6vwVpEHHTEg
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has ch_do_scsi have scsi-ml retry errors instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/ch.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 511df7a64a74..015cdc0ab575 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -113,7 +113,6 @@ typedef struct {
 	struct scsi_device  **dt;        /* ptrs to data transfer elements */
 	u_int               firsts[CH_TYPES];
 	u_int               counts[CH_TYPES];
-	u_int               unit_attention;
 	u_int		    voltags;
 	struct mutex	    lock;
 } scsi_changer;
@@ -187,13 +186,22 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
 	   void *buffer, unsigned buflength,
 	   enum dma_data_direction direction)
 {
-	int errno, retries = 0, timeout, result;
+	int errno, timeout, result;
 	struct scsi_sense_hdr sshdr;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 3,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
 	timeout = (cmd[0] == INITIALIZE_ELEMENT_STATUS)
 		? timeout_init : timeout_move;
 
- retry:
 	errno = 0;
 	result = scsi_exec_req(((struct scsi_exec_args) {
 					.sdev = ch->device,
@@ -203,21 +211,14 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
 					.buf_len = buflength,
 					.sshdr = &sshdr,
 					.timeout = timeout * HZ,
-					.retries = MAX_RETRIES }));
+					.retries = MAX_RETRIES,
+					.failures = failures }));
 	if (result < 0)
 		return result;
 	if (scsi_sense_valid(&sshdr)) {
 		if (debug)
 			scsi_print_sense_hdr(ch->device, ch->name, &sshdr);
 		errno = ch_find_errno(&sshdr);
-
-		switch(sshdr.sense_key) {
-		case UNIT_ATTENTION:
-			ch->unit_attention = 1;
-			if (retries++ < 3)
-				goto retry;
-			break;
-		}
 	}
 	return errno;
 }
-- 
2.25.1

