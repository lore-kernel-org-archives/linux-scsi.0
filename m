Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A5A6C4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Dec 2022 06:15:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiLIGP6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Dec 2022 01:15:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbiLIGPw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2022 01:15:52 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34516941B8
        for <linux-scsi@vger.kernel.org>; Thu,  8 Dec 2022 22:15:52 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B8MIruj021284;
        Fri, 9 Dec 2022 06:13:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=jcnelLL82mZHIMuOTNnh1M/rC/UzYDWkFZPBCVJT9FU=;
 b=wK1DV8LaXuW+Z/8FXEJ08qQQmeRPFR8Z0rHbuaMP8XxNOzendmCW5MXnfzGZYIPIh3uZ
 J+j3uxwqXbVQ3iE7dvkVaURswO7VCm02OAGsh+HrkqXgsdzgmY5b6zolcsF3ZMdHwKr1
 4PBkoaCCMWzsutMbMyz//CuOH92NjUrnHNM0F491KlnaRmZ6u1D2XxBaQud7o5YOvu4H
 0UmF4Thti2BhK7dXMN6XQqJ6Z9edyoAtw1ezdGlZTzvpGQCbUW0Ejboqswjg8UnUCBAS
 2FuGlb1StR5WcLGpP4jzl7giNgbncaY+ezgbZHJzfnrIXukVmLqvNEmcm4zlUf2VGVR+ lA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3maud74jca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 06:13:41 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B93ReqH032684;
        Fri, 9 Dec 2022 06:13:41 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3maa7fdaf4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 06:13:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lLfVaSilP+BsM58wUDSBeNRUn9eBVSBcZhTCRT+4/N9YV0oF6E+C/TcrqHOFn1n/kdIEae3NckDaeEH5nyB5iUy6eqUyUo2eiDNWjBuuwxNqXiRARM/wufl6/RqGxXFqE5A71vhoTAZvfKx42L1RNg9WssstpVjaUY13FuOMY4HAJrVyNalZLUw1tdAaVRJfdiEjBKkO8MANJcWeuMK0pqAu2lO+ikLIzImoPuqg2iPSJKlwW5PQaKkxeoE7EZRFQ/oStiqOGcLXJE/7Tls3Ys/TE8CNk4gV7GLiYkHtyXQe3X8LkqbMvktOr1lG1jvFRN7OzJmBpeIuQtj40/ksUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jcnelLL82mZHIMuOTNnh1M/rC/UzYDWkFZPBCVJT9FU=;
 b=XiOVJNXbQo+zdV8lOy8of334NyOMYZ775mY21ku2789sGvKfbuYq/DDJ0AhLjG5lbGEn72CL+TfGyuwF12I9Ph2xMjv3pdlHGsE2qbW0dTnvnj6dO3qVq3Pq7z2ObODcjognN+TIykRCiFQkm8PpE1IWPqGAULZkfY4lVPyWR+Wnqa+XYIP9l06T2nlLicG6X8cPO3jojMMyUSxUNQHo5tEdHuoes9ZDSAs6Nb5fn5YCsdsQ+sZamegaChnjdYY66wKuW8eI+6HYZrPoawtOGZNiS7tO+x3ONJqtnWXQsXMzXuY3kR+7hoAdgNb0kAeQmjengZZyg2yzd+2wM7mp+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jcnelLL82mZHIMuOTNnh1M/rC/UzYDWkFZPBCVJT9FU=;
 b=BCOioSKx2vnxr+sVkn+/yCReoRquoCXQBC963NQNR2hdPiSD1Kfv17wy9rH68psjeKNFiAmsJDc4hJWuJuCF7TrQSlP4WrFwlDuEyM0t+m94hY7PcRrQ5Y8D7lPaeSB39yVTDPD2FSBN2o4KYC496G+p3wV7+8soNg+0wk4/Btw=
Received: from CY4PR10MB1463.namprd10.prod.outlook.com (2603:10b6:903:2b::12)
 by CH0PR10MB5066.namprd10.prod.outlook.com (2603:10b6:610:c4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.18; Fri, 9 Dec
 2022 06:13:38 +0000
Received: from CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::a99a:a833:4f4c:9e99]) by CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::a99a:a833:4f4c:9e99%6]) with mapi id 15.20.5880.016; Fri, 9 Dec 2022
 06:13:38 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 05/15] scsi: scsi_dh: Convert to scsi_execute_args
Date:   Fri,  9 Dec 2022 00:13:15 -0600
Message-Id: <20221209061325.705999-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221209061325.705999-1-michael.christie@oracle.com>
References: <20221209061325.705999-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR14CA0013.namprd14.prod.outlook.com
 (2603:10b6:610:60::23) To CY4PR10MB1463.namprd10.prod.outlook.com
 (2603:10b6:903:2b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR10MB1463:EE_|CH0PR10MB5066:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ed1924a-e0f0-4aca-36d0-08dad9ac8313
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZqZkSnMseBkFIUjYsei/AwvuylwKf0sR5tNysxeShysFuegG5oWsC/gkyerOxZpeH/u3S3P1kbv7yx84SRnL6xLDsbmeqtuTdpLPXLpfpgZcn4jlyEE8G6NMcmi5nhpNL1NeZ1M3EFN8knRfFz+nL5FFvoiGSJjYBmEv2uzsP1wyN6bjrHtP68gGyym+HnjKTn6GYn38i7nu6MNasmzHZGXRRsWLVdEaCUz0ET9MUNRwACGaG6rIh+0UUjNk6iqVFm1yRR1nsl+rQLBs+Ivt/kt+Ncf8331Ihb8Kj3IwHVNEDyxJKTqDHB2zste7ZZVB/KqamaSsA3dUSXseZbyuPEGKLBNnUUt27lNKOcbaDW4oxPU9IGFreLfQbGFCx+bPJjMrp4XkVOCRWuyGN8r7uOjRZQaJo8rrdOt/LuPfdybcyq3RQwfUxrKvU13G9YUePORHVnSOtyCpNjT1RTcUbKcNXq1KEeaSC0EjAl/7muNJN9lT2VcPv1MaywKTIelNo9qNL4uQTPDxdsY1Z/DEkRr5QV4zVOveFT8txUb/Ubx4OjbE1CIogrq1viAFcbAZ9xLSTbG59ySZeOjkIBkYbMjyNhdhxMoBTrm9a+hvPxWQr9xBDWzk1NUDRHwiR8z85mRPyN6HAdrVvVgKef4zvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1463.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(39860400002)(136003)(366004)(346002)(451199015)(478600001)(6512007)(26005)(2906002)(36756003)(6506007)(6666004)(107886003)(41300700001)(86362001)(8676002)(66556008)(66946007)(66476007)(4326008)(316002)(5660300002)(38100700002)(8936002)(6486002)(2616005)(83380400001)(1076003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iE6o246PiZdg9mSYsODx3DOen6w9zd4w4pFfeGzr5uPck/RD7iJ5ISs3mo3v?=
 =?us-ascii?Q?1JVufL0BtRDXAKPA6mRA2iSYmiD1lwZR4VGCU5h0fk1u98Vmfoig/tJDc94I?=
 =?us-ascii?Q?faWWoU0WVk2daA5dg8oUOJVjwOSHBPN62RXzOr5hPijvjg1gLFcztVtvDy0R?=
 =?us-ascii?Q?AtEz8LB/ka8RefeaVfFMHupZ+N4220BLJXojFW91lm6GfH5zHdmJ3HXg/mBH?=
 =?us-ascii?Q?7jFtlK7fTc5fUqwPpkU5kN2rfRmNLRbYLw5Ic9tg0Kur4AVSYT5HiPrxwN3r?=
 =?us-ascii?Q?raBqHrNpASCBa0Uh7EC6D48jrYEp0nAsGwhvay3hCzK5TFxCd0okDKZ2jUBd?=
 =?us-ascii?Q?ruIV/IVLRIsvZUSH/3t7FWj3tgv+z/EGudv8/F8SYlb8b5UQNe270mFkYNLf?=
 =?us-ascii?Q?xDF5U32xc2PGXFOs81S455j8F4dfSS61LzDliToKbN+2I7t7+NhDQtmVh6kH?=
 =?us-ascii?Q?mKMFo9ch+Qe3DvyjDLU9Y0HDLR3tSiogWLXwYAcIEjblENR6S9vp87Iu918R?=
 =?us-ascii?Q?+6f9GpWjmE3OVYNoL7uCe8wlq/FzBZi2JVCiX3ZoL9xyu3/9y7jRfU7uYIRk?=
 =?us-ascii?Q?WgHBomZImFMoemgILH1RacgobZSSYMUPIpuyCFC4Hc31qdCu1mFG1h97DwtP?=
 =?us-ascii?Q?ocuXrJjMGrk6qtzCwOcxKE9PGUji3+lTX0FaZPFjbGRIv7P7Zu9i6qVFeecZ?=
 =?us-ascii?Q?2DI4s216yLyLa5qXc05fqUAfxCmtHf1gvgnFdbyHY8PLjG4ifxxMrsH/Hp6Z?=
 =?us-ascii?Q?wi3dE2ldMkOLuI5+68AjCaQjS9YnXhROi2dBM9XnHp0qkfrEzkC50D0DdXqw?=
 =?us-ascii?Q?AcB+9w7boswF36lXwheG9rqDrkvTpPyxoanTspB3h8FxsCoM4diDqz65gdzY?=
 =?us-ascii?Q?XP5cC1wBOJdpzvnVH7p6izIPUk/VAATBsPCf9iwSBsLmFrU55Zr/7NLP1MS1?=
 =?us-ascii?Q?Vfyf+eCV2GiOzRKW/Ct5sgamYO7GQoDsyMEadEAaSgEs+yb4f/CLLkfTjrWA?=
 =?us-ascii?Q?nRMAPZg4wTuiRxkmvlTloTRv50miTBgs9xwX3yw2JMXUS6+beTQU4031WY54?=
 =?us-ascii?Q?b9kuPrMFPpCeVQCiiZKT+6Rh16oCvip0CkERXHDnBENUU9axXFDYniHVF/9A?=
 =?us-ascii?Q?UzDbyx4Nd5C/obArxQmSwMj7AKAod9sXGV5s5aK/E2Yqs/3vv/G+b3LuR1LF?=
 =?us-ascii?Q?DX2p9eMNpz2PmF2WTNZorory2ObmfbUnkgp2mkOAEuLjRseGh5GUPw8rbjup?=
 =?us-ascii?Q?GNGtvaxS/zi1AYomMmMnUnnmaltQCJMgVFdhEsSPzZUl1hf2mWRiD9Yyv2Gr?=
 =?us-ascii?Q?1XkPKH2XMmc9nYiIfZB5Mgnwvrp7LS1HBLbGqt7rpkoPn4BNYNWxWDca1sV+?=
 =?us-ascii?Q?Rg0lqubvN6AdHoQuVUyyzed36ntPy4fVlpMfMYPfFpn25cKALfHXJlguxg4n?=
 =?us-ascii?Q?igbDhKKs1GpaP4ONXlWEfTtD0GBpZYj9uXYlMIIp5qU4aS+kbdPk6T+XWp35?=
 =?us-ascii?Q?gLtMYdsBcdna1IlyMh2kg4HPAfo6tyGGH0bzoA+TPYc8adASw1D6gcpBnoIJ?=
 =?us-ascii?Q?WOs5Ti3nxSQN/LFgxbM7k4yD419grsuNbGH/WmkFA7X9jD4INWoZsu4EQ22v?=
 =?us-ascii?Q?VA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ed1924a-e0f0-4aca-36d0-08dad9ac8313
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1463.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 06:13:38.5054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1b6R+AuuPuHwURETR4TLFwhrECq7wpcX1kt1K2aYzLy14tl+MFAcBjA0y3EAsMbPnGIkrVb5NdWhVWOQ0MZ0STYY+bk42ov6bl5HFcTIu3s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5066
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_02,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212090053
X-Proofpoint-GUID: SqNTLncFRuNq1nzC64TI3MkJvxGpJ9f4
X-Proofpoint-ORIG-GUID: SqNTLncFRuNq1nzC64TI3MkJvxGpJ9f4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute is going to be removed. Convert the scsi_dh users to
scsi_execute_args

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c  | 26 +++++++++++++--------
 drivers/scsi/device_handler/scsi_dh_emc.c   | 13 +++++++----
 drivers/scsi/device_handler/scsi_dh_hp_sw.c | 22 ++++++++++-------
 drivers/scsi/device_handler/scsi_dh_rdac.c  | 12 ++++++----
 4 files changed, 45 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 49cc18a87473..c5bb04a8992b 100644
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
+	return scsi_execute_args(sdev, cdb, opf, buff, bufflen,
+				 ALUA_FAILOVER_TIMEOUT * HZ,
+				 ALUA_FAILOVER_RETRIES, exec_args);
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
+	return scsi_execute_args(sdev, cdb, opf, stpg_data,
+				 stpg_len, ALUA_FAILOVER_TIMEOUT * HZ,
+				 ALUA_FAILOVER_RETRIES, exec_args);
 }
 
 static struct alua_port_group *alua_find_get_pg(char *id_str, size_t id_size,
diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index 2e21ab447873..b07bc996b3f2 100644
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
+	err = scsi_execute_args(sdev, cdb, opf, csdev->buffer, len,
+				CLARIION_TIMEOUT * HZ, CLARIION_RETRIES,
+				exec_args);
 	if (err) {
 		if (scsi_sense_valid(&sshdr))
 			res = trespass_endio(sdev, &sshdr);
diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 0d2cfa60aa06..4cb78a2f825d 100644
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
+	res = scsi_execute_args(sdev, cmd, opf, NULL, 0, HP_SW_TIMEOUT,
+				HP_SW_RETRIES, exec_args);
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
+	res = scsi_execute_args(sdev, cmd, opf, NULL, 0, HP_SW_TIMEOUT,
+				HP_SW_RETRIES, exec_args);
 	if (res) {
 		if (!scsi_sense_valid(&sshdr)) {
 			sdev_printk(KERN_WARNING, sdev,
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index bf8754741f85..c5fe40f1f845 100644
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
+	if (scsi_execute_args(sdev, cdb, opf, &h->ctlr->mode_select, data_size,
+			      RDAC_TIMEOUT * HZ, RDAC_RETRIES, exec_args)) {
 		err = mode_select_handle_sense(sdev, &sshdr);
 		if (err == SCSI_DH_RETRY && retry_cnt--)
 			goto retry;
-- 
2.25.1

