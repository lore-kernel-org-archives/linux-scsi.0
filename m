Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FD88C433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 16 Oct 2022 20:00:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbiJPUAU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 16 Oct 2022 16:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbiJPUAN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Oct 2022 16:00:13 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ADAB2409A
        for <linux-scsi@vger.kernel.org>; Sun, 16 Oct 2022 13:00:12 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29GJ28Bw011941;
        Sun, 16 Oct 2022 20:00:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=wx55CpMcerkKOO4XlPesewojj9SabUqzqSEDbSnVQfY=;
 b=21TPFYgFwCwSwj4esI4UbHdXNiXRnG2jSzFux1kESn8DEKW8sHjTl3TVQa+s8ZkUNKps
 aLrDG140suDLG3ZBA8WJQTN0d/GYvqy9qqs5O9q74mKwAk9HyQ4geZMMUlRDTcrDBrG9
 pYM49m72VLCXgepUIdxZjkzwPiQRPRhGjEPa6O2jyIVmivBiAIIp3yTtRZEAavhAMkxB
 64CwKuUpXdd7l2nHk+ZhIhvNffSq2hpRH3kmkC0COYQftSwJb9CRkVaQdrl9xGzALzCW
 P3Tho7OxqxYcYs//RYAG3lSGJf6u3w24SWlcosdyH/rTr2bmpOFMhZA3Yy6TcfbmAQ+P yA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k7mw39yd4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:00:01 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29GCTlin040878;
        Sun, 16 Oct 2022 20:00:00 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2040.outbound.protection.outlook.com [104.47.56.40])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k8j0nc0vu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:00:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iwDRczEX2hhJgkhcGnWPIsoYe67UDZINHj6i9jgrpp/Gre7Ylda0XBaYFNHG3Fz2F970sZ92NwuAP7l1ExHiNjMwNnmzhdAnwH8SAq7G6onwvXVZ9h4Z6gMYzvOLXyL4/nLqgtiTO80XXwjfdlyG1SJuz0t4dX/IPfaHH1hULi7ERbaQ1iTIeFfkX3vsBCPg7yM1JDito4pldqWNPNhSoM2YDKVWkQx3DFW70h1IYujFT5KtZmQNybWWP4m8aGvokh3bLb5a19U4mUUpiLFyei1GDaqX8CKhBGjTPkJNVvMYeiriQxpmuFzkphYQMocEXghkU9jvsSb8Ej+ES/gZag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wx55CpMcerkKOO4XlPesewojj9SabUqzqSEDbSnVQfY=;
 b=WHD2/24aMSHbejOO984iYS4RThN7y+wO4XcO7908tYhelZSKegXqibw2R0xT24B/2r8cmyz0DZTNh1DCYaZ2REQeV2GdgDD2eSGUuBuaUQaTQ0DIGk+B/kKnpcaNJ0w6J8dt3Bc3cT+Pr5u0vG3Crn8SDGb1lM2sqR5RUKKxuVwHfg4ir0Hb+zd9+MYj01DfGq5VpzF/Lz5HZuEwyg+/yMNi5JqjYGZhtfpwQogzN331wqN5WFK6Y9h9cDvtZw6grOqSFF8xxWvZmrTgMP2MS5IwIaWAIHBtLOBX1dECu4/2rt5Mi2mJysfStV4sCXxrl9vHUNUFTn6ZLq4sGfk3nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wx55CpMcerkKOO4XlPesewojj9SabUqzqSEDbSnVQfY=;
 b=EMjmk8gyHWL+sxejjH6Ld5uL+NLjO33/BmsEB8qMD8QT+mV8X/auN0brdqCoBfldvMb2B43QSR3dvWVCywDSfLVcapSloTa5+VsNzp6MXMI0PcIFK0cnur9mmoEKWuepyVmZbq9ObZu0/Hvib3jZW2sVaeVvVoS0YWJvMgspXCA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB6727.namprd10.prod.outlook.com (2603:10b6:8:13a::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.29; Sun, 16 Oct 2022 19:59:58 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5723.033; Sun, 16 Oct 2022
 19:59:58 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 06/36] hwmon: drivetemp: Convert to scsi_exec_req
Date:   Sun, 16 Oct 2022 14:59:16 -0500
Message-Id: <20221016195946.7613-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221016195946.7613-1-michael.christie@oracle.com>
References: <20221016195946.7613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR15CA0004.namprd15.prod.outlook.com
 (2603:10b6:610:51::14) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB6727:EE_
X-MS-Office365-Filtering-Correlation-Id: 11418e95-b344-4d35-d0b5-08daafb10102
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qnnCuRnG+gg9royOcIC17V0zCQTU9ggsCkyT0vqq5e2dVn8PKincCKoeZeUBPJGXS+dRClkPXZqfzbz8xozGaZQ+ohNG+Pk/nxr1/kTcksHoiNPjnz4YcWguKwkQBxZehhpG/1d5vV8PBU3M+tjk7rk5lS8YrlAr29ffsZX7fC0WScieDfOBBZcNA52laPc6G6liipKYkjylMi9tRkmWzFvItwO8ExtXojQG2MNMCQ+o4P1NdJORuSo4G4+7QiqnBv7cV9/szAANCmet0VuDW96DYhbxwHRD05U+S8VP3pbURYHVY56gCa7JUifekHYlqPq4oTHmaYyhb68LvFDSlstBjqXa9MxjrOlOfNJxAKTAojIthoQhPqPMtua38+sgtXUojh0DMCE+EsiH6oG6LA+AaINJ4+nkJZZem++q8HLgYTQGFZOWb/Ri3fsUHph8lMvA5BDhixltJMjGeYmgTUWLccXb2BLSiw1sD/mV2LrUvxNUOtq9NmigtWchbI1Go2tO3cQqQoPh7tjkdpXFC14rxUAD7d5PuRs48nkvNQyNdnsnj2GRR1JnPJdgRjiyQpE2US6ixT/ROTm4Qp3PNYBFGyUQAphOuS6G2DVGK+r/3CfmmM8TqQVUQqVE9FjF3RizIK7V7Zv+kc/tr8+Ss/XfJrkv/n/QaM34QJ7xWVT95H/DV8NPFWn3TE0+OyBwaQKzVrKmwtnp7CFmFsCZZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39860400002)(376002)(346002)(396003)(451199015)(38100700002)(478600001)(6486002)(186003)(4326008)(2616005)(36756003)(6506007)(316002)(66476007)(107886003)(66946007)(66556008)(6666004)(1076003)(8676002)(5660300002)(6512007)(2906002)(26005)(8936002)(86362001)(41300700001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LN9v4yrrTyg9XW7Uoyhdjm18Zc4Kf/qCPZoJ+pCIr+nqDVDi8KjIuZ9ht6ic?=
 =?us-ascii?Q?9hUBh99iSD1FMO29WVpdYiXzU3GAyUYhVxJpFcmryp8bawewtD9z50gIjCGp?=
 =?us-ascii?Q?ZoFfTr+rW+6wctlgeefDKgQ0OcabA7ZU8IyHVtWNzDvS7F1ek28BH0ISjGkq?=
 =?us-ascii?Q?R/5RDvmxI+S/4d0beS1susk8hNjvn9N6y48eC2lLJQI6MELuvrv9FzS6/YIy?=
 =?us-ascii?Q?BX7KbcaiicF19erU8ybOM6V5vWpcVi7DSLgGtcw+aC1pm7Z2XQb6DBq5QB2d?=
 =?us-ascii?Q?0Db3FkKXIa1fShkk2s0L/Kgdj6EWuhC8z8DiXpgbXeH0ac89yvo9QToURneQ?=
 =?us-ascii?Q?c8+xmEhY2RwchcX4+DHcbOHNPle6M11fhOapWglh51cmh6mCRInDAUstuzDZ?=
 =?us-ascii?Q?nCcp/ra8puzNfetGnOlGDpTP3nHEzwUKxcj5qyRW+to6G70WjY6Ixv3yZ4MP?=
 =?us-ascii?Q?mU+M6NjjFW1UU0tyz619fgmggp4oYVxY1gUWobPxF9VW/sijjlLO95XT7sI8?=
 =?us-ascii?Q?C/lO1XxM+z731PJOuPPcEQLA5sPTkAORaFx4eE003dwVRCkDTdSfujc6OFgA?=
 =?us-ascii?Q?2tcTzjeLIx+fD+ak6qkezyEoOPZZAWRcBhfRyoPsKzcImtUZ4zzyfOiHFp3r?=
 =?us-ascii?Q?YD9+la/7uCoofF5O1miDeJWFaln72wkVvudXnRM2uCHjJ79Czc2ZyGsofiZp?=
 =?us-ascii?Q?sItef2aMuCBlihkVWr2luaSD2QiqLL1lHGWXjpakosQu0Gk1w2qfPaI91rVl?=
 =?us-ascii?Q?JKiopDrWhwMgTrMgzfZH+4tTm+KLNAkW8H60tenYJTfZOt3aOhZTKrc+Xcrj?=
 =?us-ascii?Q?YMjH8lMu2vcznDOCnZtQ6AVZxlnd36sEeBZ5xOf9QLd9w8TGW0wwV8EQcCvA?=
 =?us-ascii?Q?cbrQwX1lyOQnHY5zd+EL9RPzQxlzwI4lNXSLjd4TkncafsCdfsn6hlwagGv6?=
 =?us-ascii?Q?rRgnx92txYCOxAbGiW4QRMjCoqqvbiLZPj/752juNIzPvQX0nxqWbr4IHGhA?=
 =?us-ascii?Q?MKq7MeycdE64uAwBtAUrnxIUqmxg9PbZg67/JOFzxyS21bIyOcp3Z4+NzDnn?=
 =?us-ascii?Q?pE3+EwCpnJ9rViL7lSgwSfyieOskknXNVl3DNsIR43ucrS0oymE/q8d2vwA6?=
 =?us-ascii?Q?tfChTDC0dJ8JfXdJR6yUWEAUO6IioivRoQ6iRiyNEQ6GOxjrruZYbzoxIryk?=
 =?us-ascii?Q?JWG7rDhiXA2INGs/fbdCoft5w+ZPufw0y0+bjMlgutfNa/QgOcOMgCyzHOyi?=
 =?us-ascii?Q?q+HdrphZ3ngoApxolNBwoB7farfsAXUFcmn+ZSnz0/CDJ7paUryN6hik8nQb?=
 =?us-ascii?Q?/VeUyWPEVzjEnvtAPi6HoeOZ7VK7Z0z9PS5dLl80CaInn1VpokbAFZFJXzEo?=
 =?us-ascii?Q?tNB6CntSAFzYkUzRrBdydPLF0xrGyVFiS8FwEAgk+WdN1ZvW6jJsmtUAIuRc?=
 =?us-ascii?Q?r4M/Xgpn2TUc2R7J9pQSiKDrEmVQfIQbMicNnQzQcG0yuQoUChKsS4X+CO0U?=
 =?us-ascii?Q?gRuajtVySwfd6X6cLLwgCpLPa9b7zogjf9IeLO5U76bQtTeJKo4pvdjZ8+eE?=
 =?us-ascii?Q?c5ckmrUaIQf0WVYVsu7BgiKdcKddB4X2VG5L5M2kgJEM24+bn6NxOOzHDMea?=
 =?us-ascii?Q?wg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11418e95-b344-4d35-d0b5-08daafb10102
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2022 19:59:58.8786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: talELjnCfLkJB/gR153lCLbsfSVjma9cxmqFY3LUH0z+f6w83LoMpV9puvn8jOAN69uB36p9c8zYId/vW4rElf93PDJElC+y9FeDPjmjouk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-16_15,2022-10-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210160124
X-Proofpoint-ORIG-GUID: _B1MAXabBsiydrmWOJcr-E8cLLKFsyWb
X-Proofpoint-GUID: _B1MAXabBsiydrmWOJcr-E8cLLKFsyWb
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/hwmon/drivetemp.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/drivetemp.c b/drivers/hwmon/drivetemp.c
index 5bac2b0fc7bb..ec208cac9c7f 100644
--- a/drivers/hwmon/drivetemp.c
+++ b/drivers/hwmon/drivetemp.c
@@ -192,9 +192,14 @@ static int drivetemp_scsi_command(struct drivetemp_data *st,
 	scsi_cmd[12] = lba_high;
 	scsi_cmd[14] = ata_command;
 
-	return scsi_execute_req(st->sdev, scsi_cmd, data_dir,
-				st->smartdata, ATA_SECT_SIZE, NULL, HZ, 5,
-				NULL);
+	return scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = st->sdev,
+					.cmd = scsi_cmd,
+					.data_dir = data_dir,
+					.buf = st->smartdata,
+					.buf_len = ATA_SECT_SIZE,
+					.timeout = HZ,
+					.retries = 5 }));
 }
 
 static int drivetemp_ata_command(struct drivetemp_data *st, u8 feature,
-- 
2.25.1

