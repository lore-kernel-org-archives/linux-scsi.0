Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D6B5C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Dec 2022 23:50:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbiLNXuz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Dec 2022 18:50:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbiLNXum (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2022 18:50:42 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F3E4874D
        for <linux-scsi@vger.kernel.org>; Wed, 14 Dec 2022 15:50:25 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BEMwdaP010417;
        Wed, 14 Dec 2022 23:50:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=Fm1gZxlGjp7RBqRfD7qXpiFWjff/Bspbt8Xeaa5Ksxo=;
 b=wiWWBQgrNBZNOxrT0le4Yeljr0KAjssSDD002Y+F5WAg/BtqbW/HlO6kBcwOc4zpvz6Z
 I1/DfqGz20Ogh5Ebb0JZawSBOb3W1svjH6veS3O6cnd8ON4/owWkG38VXYWHIlXIb7pQ
 2HsgY3DNJrNTzEJikIGZ3Mb/mdKihUneogAj72Ws0T8QQPpfenWxDNA7BegkFSsjH8VQ
 U5SrT3B+Bl/CsKXH25YiGfmKYckghsJ2AmGN4IhW7M3LmpMGW9izJsKAVfBvGF567+J7
 rNsbYWVolxZR5AjRMliQxyPTe5cb3t7c66Uh4b35VWU6y7BuIudcidEl3jnCbAzsENIh ZQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyewbpmc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 23:50:15 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BEMAxs9004031;
        Wed, 14 Dec 2022 23:50:14 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3meyewunr4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 23:50:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VzpbwK79mefPaI75ynxE/MtpzUWBlupKLMPZ0pHhNegkYhb0DaObq8IEBW9T6J96f5+M59CrBkxDBxHlOr8g2yzmGBg6sthD2Mogfn4ji0ebPNfmmnZCJ8okTifBn+JELTNNEd3aWuGazS1P4cwtGJXhD2Pl9WCAGsrNypP1GIYzWV2FYJslF1hLVqErBK+KFlMzI+kO1Bp/YVTnCtJkwwaEyCR63S86AoydeiAKclvBiLRtPYYsYsnykHKiyON79BoB6mK7a1ppnD7qHF1YLXLe73gx1TjdjP9ab4zF6JwK8bhRDlD/GD7+V4gefBd7Xkp6oxvESQXO9TLB8BW+yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fm1gZxlGjp7RBqRfD7qXpiFWjff/Bspbt8Xeaa5Ksxo=;
 b=GCE7kVASjeatfgZzQod5atLPVFQCE4pNElGhAoD1gDT2zg6h0AcphlouS7NqxMIXQUdigjeA1bUyOGVXbVazFYtPM7dpBAV4s8r3qf7Sw2Vp2eJVL+Ub52TQHuDlwsN0PDmcuOqjhpZZDDsJicu4GIXjIe6+PRzqeUP2kLQTXI4uOwNvJJWwF2G8B5xC0KsR6xORUjJnWt7RVrsbkxv0sRt2dCGGtD/xB5mys40yNR5MqOF0phWv9eCdJR+y9f/WSD7zfOCfyr1n5AwQ/0Vgvd26BkfYo2tOnREZa5fi/5IBrdS6WwOgdSO23amJJy2F/LVVU86bMmyVx7hc1aQhUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fm1gZxlGjp7RBqRfD7qXpiFWjff/Bspbt8Xeaa5Ksxo=;
 b=I2dm+PcbR4AQaiGMbUnuYIUgBe9FNGuW6iNdo6FSyuRjKVguKnxK4CTyhK9Xc0LvB4WiKYB0abQ7UC/gTE89MsH9q88i86RLN7yEdMY4fhAL2ZavLAtGUkzyu5kojUrmACp61sQk85GycjdOJ3aXpwuXAqOCyJfXXZhHyGLCa60=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB6800.namprd10.prod.outlook.com (2603:10b6:8:13b::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.19; Wed, 14 Dec 2022 23:50:12 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%4]) with mapi id 15.20.5924.011; Wed, 14 Dec 2022
 23:50:12 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 05/15] scsi: scsi_dh: Convert to scsi_execute_cmd
Date:   Wed, 14 Dec 2022 17:49:51 -0600
Message-Id: <20221214235001.57267-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221214235001.57267-1-michael.christie@oracle.com>
References: <20221214235001.57267-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR20CA0028.namprd20.prod.outlook.com
 (2603:10b6:610:58::38) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB6800:EE_
X-MS-Office365-Filtering-Correlation-Id: 56f56778-faea-41fb-6f02-08dade2df0a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sfWD+MKpBAwqLu/SO+d/Qwu05mBLMtZ0sje7nt16rPmSTJu51xCRA7l++OK1jVraZPzKp1g1IO3dtFCJKEHyn5pOyzXk4/XpGd6L/yn9DzIJQS9dasq+ZoAb0zQ69TB8np69KHHuclYxwTWfszbDnTUiUIW49nblI6lvD8WwxdK/huQFtBGhiJrYATPO89Bqvy4ghzjl5INKlqf4IG/7X12to/szZOXwh9yggY0tO0WitOvdhq6A3xUlhIKsTHdCCpuZsg4I0LnrEvpvTyJgs5SW1SMpCCF5h4KmBy5iJCtRiqNT2qJKjiWFbM6GNWvcPXp21hI5ada2vtPGXxDeca2SBHKxmTP2Y+Akrozx3VvrgrFiJ2HoOuWHReB15djuaJkGYeGFFpz+90ARWwpoRz1vgFc+ScgXhVUcD9NtoXnnWlCKcjU9bWOQPmKQ2cmDRgUgFsBjYHl/feQ/QKEzvLNixy+7RmTecf3Jh6DOdC0KfK5HOxc0zppSi4RPksAKdWQph0LW0gjtIQOc/IFP3UK58UYDeIzrUoF2dXsZlN9eWOoI/QF7RIVpF4dD7hPcRCswaSb9XlgTSP+kp1xszyiaiqbz3EV9Gzp1XK+MG7z+zWpbEcMjIM2XhZc9BNNuTGMJ6FQ00GepZTEQ/gRatA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(39860400002)(366004)(396003)(346002)(451199015)(5660300002)(36756003)(2906002)(66476007)(66556008)(86362001)(316002)(2616005)(478600001)(83380400001)(4326008)(6486002)(38100700002)(1076003)(26005)(41300700001)(8936002)(8676002)(6512007)(6666004)(6506007)(107886003)(186003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZD6Bcb8D+HjqYW1UPejg/ey0Ig9jweKF4aMBWC8SdkBAPsjuucagt4z9RhM4?=
 =?us-ascii?Q?9eReI7MGAshYfxZh/0NCaU166WSpsUS/hzpCBy3Y3BGPfwjCqIAVtUrK90Xz?=
 =?us-ascii?Q?zjgCUbo+H7HJJ0uYZuTyUe0nET7AerKIFf+vL5oraA3Q1JExTxMQ7ctlrOYa?=
 =?us-ascii?Q?86ATChhCgvxlUaZnd4MnkwNCW2Ac3w4zaDEY/iRlzZK0aZ9HwvDHZKLdnmun?=
 =?us-ascii?Q?7pr237HcXu9tWThmF3WHlPuV/uWHK7a/0bjpI83PlNRWfYJS6GFPNrcG0SkT?=
 =?us-ascii?Q?QFO+56blsHw0h+1L7PIuGKN9RupHna1VeQUguOJXzdW13Qee3PEHWp3fIG+N?=
 =?us-ascii?Q?bcpMCrT0CwVSkiPPZwODJoDZgYqkMnLvUTw6E6iEFGF7LHWU8TcyMvjQjzMl?=
 =?us-ascii?Q?Yniq7FPsBq+0PVI4qjNiCwXCiO0E7QnRmRVNsihr1URACs3jXb2Y28BZYwg3?=
 =?us-ascii?Q?V7FV6p2uYJoZxpypcQc9x3TAmfQWUe70IgQFo8q3ItGFafUYGqUD51pHpVaA?=
 =?us-ascii?Q?iTxR2tvZwh8VmGUPgGcKm14jEaQo3dbgupw/XyJP2yrLlUOJZpPFMZdosrs1?=
 =?us-ascii?Q?SEOf5lOoBGMgfQ+GR3lHlUENweL2YSlV25zfDuOOCuTHIpF91ClVrHmbLZxU?=
 =?us-ascii?Q?NhI5BZqM6hXPw56U/cMfvtKg+po/MFaxVS+Gqoj45WDwdme4abRTRbIjU6vO?=
 =?us-ascii?Q?8Fj6j/q1x3O/MGa0lmjT0YEidLGJVF8xIABbNZnHuSWubeTSi0VyibnwbEqL?=
 =?us-ascii?Q?KN4yX6ckdx7uN1doae/liQQnRO5mLXtVRF1PSdpSRzhs3PTjdmgY/y0NTEpT?=
 =?us-ascii?Q?gtpsynxZFYtwToVYtGZBlm0Q2Y+iDfuzTIGELMxF0V7nk9yFm4nLMH0N7Nwe?=
 =?us-ascii?Q?nzfwYqAv977eHTawf7yHKuGFqGC0gg6rnNsK2bXNjYWieNfi25MmGdBwMvW8?=
 =?us-ascii?Q?AxdOKY1qOLKYC3i5h7E7BvC2A422fjkoKFFo/yDyZR1GBb7vtKULd0DVRCfj?=
 =?us-ascii?Q?YHWOU/UsTKWs4KuIZby0pAqW6/ucG0zjgiFM62gqbkkMaX7G/Tmozpn3231w?=
 =?us-ascii?Q?ePB+JpA32XMJHAu8Glc+dKTpSNK6tI+v05d+Hp9jiKwAveDzZQHdCl4cEmVr?=
 =?us-ascii?Q?34ZpeJR1YDaeXV2pPJQBrClrJZ/QdY3seJ1yhnC7XSPbNJH0yws74ucLlMYz?=
 =?us-ascii?Q?6i54oUqqIWr/5Mmfnb9/VnS9WUojzeLdYl/knZaLGbK6VDuPflKmg5HirulD?=
 =?us-ascii?Q?Ps1MTR6xhONa1MSUgFbonMiBW5gd0LS1njEAZzq3IpJ2yUVoLP8lRDtZB5NE?=
 =?us-ascii?Q?bhNQKcof348pvyRhKR2U3Ah6/hSVOdH7E6lTkSM6lP3mBIUN4tQvRUrcv3C7?=
 =?us-ascii?Q?N0L8S+Qu/GfhzxFF4X4uuNYPVAp3GXS6/IypBOIwJ5f4Fjn6WmoV/SWhUhUv?=
 =?us-ascii?Q?4idfTQC9EeRNEg7Zu7Jx0fnMoyoWpljN0divB6KxXAiRBm8q1SwoQVi7fbWh?=
 =?us-ascii?Q?jHdKyTCkhtAlphAK8Q0VFMYx5Z/D22WTRZbSKr7RtYwc6QErSb2XRTpY0t1W?=
 =?us-ascii?Q?XqugxaPT3EdbCXxR+tm7NjSdswNwYTDubZ4VE/oEU0UaRdTFEpVIK3lTDP8g?=
 =?us-ascii?Q?7A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56f56778-faea-41fb-6f02-08dade2df0a9
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 23:50:12.0126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wh97KNXoF0ikQyknuXfdUeb03eNabyb4pAeCj58GBjgAIUZDPPp91kqAxjKm5b1g9GHF3nGqc52ZsmbYaib0s5elTQsfyqY8Z+pshLDCGrs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6800
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_11,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 bulkscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212140196
X-Proofpoint-GUID: oeZP7vEE57bnJ5BjjRmcxJj4b0PRmQpt
X-Proofpoint-ORIG-GUID: oeZP7vEE57bnJ5BjjRmcxJj4b0PRmQpt
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

