Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BF11C433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 16 Oct 2022 20:02:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiJPUCe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 16 Oct 2022 16:02:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbiJPUC1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Oct 2022 16:02:27 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27D62ED4A
        for <linux-scsi@vger.kernel.org>; Sun, 16 Oct 2022 13:02:26 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29GJ20v3011562;
        Sun, 16 Oct 2022 20:01:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=5AI+pzfkeFlpLrmQ46clNzkXWsL/x0YYvdRawOO34PE=;
 b=Mv+x+vQC1kYW4ZQyBANqwXC1PoV/T37UsHsPWbqDaW0Ae5v2FLIhO21JKt3MYUgzQwJF
 XPTuU0WOVWBccV33ihZ1Pi1tbat0Oo5HQ5QkwOmQj9KEhTce3u6Fe2demtpN3mQ9aUFF
 7Emq+NzEA/cMn64rpv8Ggq5PQ9AuiwbsiSA6VM1+fIFcuyoty/2Itb+hsyr3/xgRuH0W
 tCgckeZuye3NDN7BjcO+ulsBnDP3pSdjTl5kt87ji+z6BPX8Awb74zQpKV3V2n4gBgL2
 bJGFb06ZclhvTeYJfhCRRP7NykNXQnFYKu5bi/xSdGTjRwvIaRa3dcyZ4WujtkrwrYTI vQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k7mw39yed-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:01:20 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29GCHbSn034322;
        Sun, 16 Oct 2022 20:01:19 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hu54e0w-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:01:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DhyaYV//INZRpnV17EDgzi3X/85dZKWpe8r3tc5Y4uK53cJYEXB1qoOpxG/T3ctHJok6WNLIPuwUsLb6wNezVfVgYkchOBTl9FOD4WapGZGtoD0vkra8Yn8wSS1LRR2iHJio5TRj7onR0ctQ7339EsBNqHALP9d6IwHO7IuuEyGVuRRKid52uELWN+qMtbGt8cOXIYL3pX1BpM+JQL6WenKZXJowZCrLT0Ojad//OmRl+aHgC3uJId/nxrMc9ZMQ3zp1BNID4P3D9fhJuO8+17rAGMAwVCL9Z79bpyoSJ7kWMk3p1FdIRJR0ppIHwaNqH7nW8J9naIeLzs7I9t9bXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5AI+pzfkeFlpLrmQ46clNzkXWsL/x0YYvdRawOO34PE=;
 b=GsCkqSGsZN3r/xSBeF+/C1Wv8UYb3+UOcBLAzHeDWYaxSpkc+hAF+FZgMU1VZHXerzwbUZqPkbUozH936v87m0VMb/GMtZCeFa0lAKJpLo2PFgLyWOLic58SKhHSilfZxnmvlg0M19nJCU7y5CD00lsdDZ2Hu27R8iLp2j+5dr9Wym5Lft89DQ7tlN8UPS0YfuFKUNj90fRruRGSCGovCzQhj/GKuxBvRT6whpaq1Vk4ILkegYfzExJ8HTrMxXNrja7egTKXiMvOCtv0u4QyJY7T9nbqEHoSzKouBbVCm/qKNJC3rxktOo1mMluNBcfvEgUTZeBVK8EcsvfhmM+f5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5AI+pzfkeFlpLrmQ46clNzkXWsL/x0YYvdRawOO34PE=;
 b=f8/+SBI26JKckno9+FPZ+xcWGS6n+b9VlAvQSCXxF2ASrYmfFc3v6rewtOznMbWcWyGe6RNycvHAOZGoLmNvb5IqSfGDtZjc9eswEj7ejEyERUue1flv3ik0EEKgHYmnqtQi+IQjQlUsOURo4baHyWOUMxUhCElFtCqzjgh+6Jk=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SA2PR10MB4603.namprd10.prod.outlook.com (2603:10b6:806:119::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Sun, 16 Oct
 2022 20:01:17 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5723.033; Sun, 16 Oct 2022
 20:01:17 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 35/36] scsi: cxlflash: Have scsi-ml retry read_cap16 errors
Date:   Sun, 16 Oct 2022 14:59:45 -0500
Message-Id: <20221016195946.7613-36-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221016195946.7613-1-michael.christie@oracle.com>
References: <20221016195946.7613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR05CA0038.namprd05.prod.outlook.com
 (2603:10b6:610:38::15) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SA2PR10MB4603:EE_
X-MS-Office365-Filtering-Correlation-Id: d646caec-4e5e-4b22-6096-08daafb120ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xv3mRdaaPVJoYDHrBao8mL115MBGrrjHQts/fDUgfrCGmglZNKgcCc5V/Nq56z34J0l+TssxpAJZDFrnyHIqWk7+bZoGBqAZNTOjR+WQ4sSJPa5PfRRhRnEp2PsSjh4ypMYz214CjPjG4YzUuyyXP+zJgf/gtrlOdWqvJ9LrFDEdH7Q48kRLV3nLyGxLTPiV9KRgUtoiwuucOY19WYqh8eiGDbDJ/OgPR9s3F4Y07vvgDPhY1FwIJxgCvLB8ZYq+f/8aYUZa49RYouuM5/ox/yAZegbyO8k+wNICT7+P6yqTcGlDTa8qNxkK0pzskCGr9BCyvEt2x8l0fnKVN5YqTtF7BJE+tOlBkukcqN6+D6STC3af150EabyTO8vgaqRkgMRQXTpuvtVEOQqadhlRrstN0tGRuNyFq+AwyN/0LD4SYACzkkdn4+6KXMkxLvmRJfVXOk2ErhVYbTZOgDtw88dwfPTnWRSVfV1RKUy8qVquvACqXzYNuXOI45fZQRV8jd5kRr7z8AAYT9Vt42maMM/YU3QGynGbLmkieQdvG5uv1mRPRlcyPomu/gdukTDUnhgYNTHyiChiE2fNI2feyYRNIaQy9Jc2h5Ww20HQNBhoy1I3TDYtC2QIc4SE6dsJ3OMgrW6AHSmIr4+ZJ4wqfFGdGXjch9NR0b1t3YAlSi8YhjXEQvrA0hRb1U5dvvQFfK6x+tQnU3itlkPgmRLMFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(136003)(396003)(366004)(346002)(451199015)(6486002)(4326008)(6666004)(316002)(478600001)(107886003)(66946007)(2616005)(66476007)(8676002)(66556008)(1076003)(5660300002)(2906002)(6506007)(186003)(41300700001)(8936002)(6512007)(36756003)(26005)(83380400001)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/F/E00jrg4OYeCmcW1CcCxDTf9KHDH+geVeeolmJarIU7/PawzVzBxl0QQrX?=
 =?us-ascii?Q?DjkccGo71PU+A7+VqKfsc0nW/f1y4x6uXmFI7rwJip2ojZkBCPWWb42u0VZD?=
 =?us-ascii?Q?W6Zh0b6ETq54itREBKtl54/IY2usWGKCaXige+1XNtdIUGTG/stnIB1c2wRl?=
 =?us-ascii?Q?pEjnLdESyehZcBxKsJULDylcllEnlnpZuDXD2xK3t+wZBhgu6jwt0Ae1Sg3M?=
 =?us-ascii?Q?bAZY+CslHvnWImRu/LK03LMkv768O5kWmeiqt9MTUqiLPwOB5BG6qhH5e053?=
 =?us-ascii?Q?6Wv+EIWyTHF710l4PonisZ1lA10dru3k/mWgyx3q7/wsb470g8isi3V8ht4u?=
 =?us-ascii?Q?fI0kZZ/SmxpinVecD3L65zPMnZAB5ejm3szFzDC+7w9FjrFc5eSj8vKBe3go?=
 =?us-ascii?Q?xDMGAkgIXmq9dyU7gT1CWAmtTSdSq/x5RrcfotPKcgem/pWFFPhRJh690MgB?=
 =?us-ascii?Q?gzSRXJEdLUHNfeiU3GKQb5tjUtaqmBKwH5tNoxDXbTcU+cAA7qzUklrVZqg4?=
 =?us-ascii?Q?eX8i+ZMrAsND3Agt52XyVYqksQvzb05qpzhy/RRXE+r9dKmwWCd5+61hqXJ6?=
 =?us-ascii?Q?3V3axdZs9UlT3esOxpPSJEwOX0Z303y233xFYYPx8Wy0NJiQHUS716HWt/XG?=
 =?us-ascii?Q?6/cyrhLz0KWiExit4Qgs9l4N//G4c7oKpvXsh5VJ0A1UcHRxE8J22yK845tS?=
 =?us-ascii?Q?lHHfSHMAehhwJK8n50CS1lYu8jU0P/no0623hViZJ3T6g7NQhBSq0sK40ItE?=
 =?us-ascii?Q?cwfMpT1b9+FJvph1rCKngKlt0nzMIlhdH30y/xJv32BB0WYPL+lDhqsoERbo?=
 =?us-ascii?Q?F4DeFF+iX9+bRQpJJQu6oZBIihPgno0ELvfCgG87JxMZPo1nZAncNagd66Kt?=
 =?us-ascii?Q?o5uYziKSrNo8oi/BtsJ+WL8upOQf0irLB7kwtJ36/NxRENqvXsso8rC7F01D?=
 =?us-ascii?Q?7axJYtYhaT0SznzKw2ilql7rj1dJX+wtke0paCgjUqsl8MEwfB3deenweaNT?=
 =?us-ascii?Q?QdXlohMFQOLkzZSAr1kyGXDus3uK48tc+X+rwx8vmfAGc6n01zMNUjEZhmBr?=
 =?us-ascii?Q?aVPdSpEdybJ/Va4Mb4LcrlyndefjOTOvufmDHOLzzntDuAU8238qDfC/PVwX?=
 =?us-ascii?Q?9si2HEp2piDJePO6JIAd/M//Em1MxJuwMtZ8tK1k1lWHHhD6/tzJY3bc+VnI?=
 =?us-ascii?Q?IJadA57kSCLa9UMzO6smGIbGjThlOsQzYoupWUyaTipHiw62l95530pVZ43P?=
 =?us-ascii?Q?el1U0hn5e7oW6JMldoGnvJGGC7zWUdM5kbiun+BxdjSJNfFgwJlluEE11zdc?=
 =?us-ascii?Q?WefdTDUwm6Gl+F26ZMJj2mcU1VxekOFAJ6gUsQ0tyG2PFV6p971BzQGK4UJv?=
 =?us-ascii?Q?kz0eBL1nM7Asyp3VpMgrCKZEblFqAqGd7xPgRbaH3saESEkXk6C+kwvRpntb?=
 =?us-ascii?Q?zFZcSNbKxdnKI2iBa2hdFvaOkdydgiNXsfL07lV9j8SCNt4z+rLA19VwSt8j?=
 =?us-ascii?Q?Ulnx2v4gFuQCPFbpbMerP0s7hBMC1v3yH3QRdCb+wcEZ0FSnWEZEc1bDqonQ?=
 =?us-ascii?Q?Ev5npIhiehJspSZiFQOvPyhuiotYquZUKF9Dw5xcyr2JEF7FvUAMis30xQbS?=
 =?us-ascii?Q?Wg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d646caec-4e5e-4b22-6096-08daafb120ac
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2022 20:00:51.9523
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VCzKcbOXDVx1s61jbufaPwxfqdhyYTfzcN+NcGZz/+llI/OKBo5BOitE9yJCdrytf/6ExJvGHcCek4rpnnQ2xBAPero1Cf49EH10tPZRlRA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4603
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-16_15,2022-10-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 spamscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210160124
X-Proofpoint-ORIG-GUID: 2wKKP7fm2JkzoCzWfEhGupzQZIArJlUx
X-Proofpoint-GUID: 2wKKP7fm2JkzoCzWfEhGupzQZIArJlUx
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has read_cap16 have scsi-ml retry errors instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/cxlflash/superpipe.c | 46 ++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index 724e52f0b58c..8627c825d031 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -337,10 +337,32 @@ static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
 	u8 *scsi_cmd = NULL;
 	int rc = 0;
 	int result = 0;
-	int retry_cnt = 0;
 	u32 to = CMD_TIMEOUT * HZ;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 1,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x2A,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 1,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x3F,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 1,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
-retry:
 	cmd_buf = kzalloc(CMD_BUFSIZE, GFP_KERNEL);
 	scsi_cmd = kzalloc(MAX_COMMAND_SIZE, GFP_KERNEL);
 	if (unlikely(!cmd_buf || !scsi_cmd)) {
@@ -352,8 +374,7 @@ static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
 	scsi_cmd[1] = SAI_READ_CAPACITY_16;	/* service action */
 	put_unaligned_be32(CMD_BUFSIZE, &scsi_cmd[10]);
 
-	dev_dbg(dev, "%s: %ssending cmd(%02x)\n", __func__,
-		retry_cnt ? "re" : "", scsi_cmd[0]);
+	dev_dbg(dev, "%s: sending cmd(%02x)\n", __func__, scsi_cmd[0]);
 
 	/* Drop the ioctl read semahpore across lengthy call */
 	up_read(&cfg->ioctl_rwsem);
@@ -365,7 +386,8 @@ static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
 					.buf_len = CMD_BUFSIZE,
 					.sshdr = &sshdr,
 					.timeout = to,
-					.retries = CMD_RETRIES }));
+					.retries = CMD_RETRIES,
+					.failures = failures }));
 	down_read(&cfg->ioctl_rwsem);
 	rc = check_state(cfg);
 	if (rc) {
@@ -383,20 +405,6 @@ static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
 			case NOT_READY:
 				result &= ~SAM_STAT_CHECK_CONDITION;
 				break;
-			case UNIT_ATTENTION:
-				switch (sshdr.asc) {
-				case 0x29: /* Power on Reset or Device Reset */
-					fallthrough;
-				case 0x2A: /* Device capacity changed */
-				case 0x3F: /* Report LUNs changed */
-					/* Retry the command once more */
-					if (retry_cnt++ < 1) {
-						kfree(cmd_buf);
-						kfree(scsi_cmd);
-						goto retry;
-					}
-				}
-				break;
 			default:
 				break;
 			}
-- 
2.25.1

