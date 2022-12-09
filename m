Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1A36C10F1B
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Dec 2022 06:13:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiLIGNt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Dec 2022 01:13:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbiLIGNq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2022 01:13:46 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B0E6BCB8
        for <linux-scsi@vger.kernel.org>; Thu,  8 Dec 2022 22:13:46 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B8MIgsn002832;
        Fri, 9 Dec 2022 06:13:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=npyGHWv/OFlafYI6bTJF/osyKXDm62/Qkk2tOz5qabc=;
 b=YMsMEXXb0TIkHESA79ygIezKCZAE/dNgyG/DNtPOGij0yNLBYKXA8s/+3F2GBK/RRrT+
 GCp2pyMlzkDjyDFw+Sgiw6/Nz1SagGlOeOgBQRd9kF7jkfbH0XS9AuSfBLU88cxpHzUS
 yZb2QnOWh8ZE/4RoU6zml9q65JSdkapfPGiQnF4WaD3z1eYly6+63CfHFg/nbD5sHmby
 re9Df51VjmlEAIRrQT0DAo9wToD6Xh6zIpsGP0K1CuzxN9o7zY/gma/zKZv59JUTT/ET
 WB06c8T9owrKCSN70nPaa4FM84x+5mPYkFGXfQSmrBSShJ/Z1dos0TjJI3FJ3j+KBcS4 2w== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3maudkcjdu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 06:13:36 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B94vaG6019666;
        Fri, 9 Dec 2022 06:13:36 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3maa8jwbds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 06:13:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fvmF42uPnM/FgHqLZRWYm0+fpTqB/TIkt2Hv9wFCpNk5kBlBqQVPrwdfXPG6cVz5G0cUYqhn2drb3baJXF59to91OvcKcF5Tuk56uMWuCKrauB7fnFenW/NxD/r3Q4GfF5YbkZ406ox7LYA5Ae5oBdsTvEc7vjVHFttZBlpOqf5eYAysDeIpLfo+GvF0Pg3QPBWq8zmUNBcNP+qH4tZDsxGiV2mJ6uuyvV6xlQ8rTcE2a8cpfZpwWTTZWimw6eGFsw72/xg0lB7RSXmEmI2gcvxx/GUlNLf7ZX4h4WGI7WuRbqfaSqBF+XpCaaMBay6y6WbdgVQqcZhC5IeWQd7lBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=npyGHWv/OFlafYI6bTJF/osyKXDm62/Qkk2tOz5qabc=;
 b=D0x/P5oYqGdiI7X5d0TswmO0hH4mEUVXWsTWc3uozw8+m3iR1JUDIILCwUacvaj+k4m64aYP8/RJZBfyRMIJFAoZS3MEaPHjBkp7DY9C5wOS7AAigo6GKu3AvGGqt4p7gJ7SLHfQnheiqpotVWkamHg7sx7EzI0U7QZOI9NLBc7ptIW8cyQZSjmc2ZwrC4DXY3MLht14K2FyZ0WkUvMUr5edTc+1hfQUbErJfGthvmqb4g+u7IJvvIAqYSUvCUw8o7dQnFkPrfK2cgIXq/ciXNv+ZxPisOIl50l4DnmgqIciQIKmLTfPpIXKY83eATXnhXOwMXxJ7VKqu4vF8kWfSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=npyGHWv/OFlafYI6bTJF/osyKXDm62/Qkk2tOz5qabc=;
 b=ITjXVCIAiDym/05lvXyhzYoskKtlcGJkPkB4jj195iXfH9Xi9qMYmR4FTl/DjFTxC6/qBP4/7NG/gK0voRO8nYBeKQBw/Uh6vDX2yq6rDfJZR7Cum7/2nie6q1nemqFbFETX8d2GGLyXExv73Tf/i7LUNcIopmtNAqjFhzROcyI=
Received: from CY4PR10MB1463.namprd10.prod.outlook.com (2603:10b6:903:2b::12)
 by CH0PR10MB5066.namprd10.prod.outlook.com (2603:10b6:610:c4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.18; Fri, 9 Dec
 2022 06:13:34 +0000
Received: from CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::a99a:a833:4f4c:9e99]) by CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::a99a:a833:4f4c:9e99%6]) with mapi id 15.20.5880.016; Fri, 9 Dec 2022
 06:13:34 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 03/15] hwmon: drivetemp: Convert to scsi_execute_cmd
Date:   Fri,  9 Dec 2022 00:13:13 -0600
Message-Id: <20221209061325.705999-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221209061325.705999-1-michael.christie@oracle.com>
References: <20221209061325.705999-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR17CA0030.namprd17.prod.outlook.com
 (2603:10b6:610:53::40) To CY4PR10MB1463.namprd10.prod.outlook.com
 (2603:10b6:903:2b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR10MB1463:EE_|CH0PR10MB5066:EE_
X-MS-Office365-Filtering-Correlation-Id: 49b110b2-b58e-4a6c-147a-08dad9ac807a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CwvE81r5gWTr1qJSzMtyfnt1PmkQh8f4fSpWeGPlWm6xM+PJKJ7ziAvoxC7HQ7nOIGkU8HgiQEiQr2+GcRohpDJibgxNG9+SU7B5scJgY4lQ0/mZB5UEnRPcY5tvVE3YBh+1eWGas2ugo7Oa3l4ipiYArwuJeESi7toJacQPqmIibHpS437UnKbVp2sHgxC59Oe20FTASwTMACnCP9hfcKMceNNSglLJJAWptGNru0IS7I6870n923d4zFzvdn+2YxqLXVRrYDwbOknKxF/pAsxqVYlUvxUVm/dU/w7LFBF3ZaarW2xVtJRKrbgkyO6S4+aT/hJt34+C6QeC8GTL/7klRek5raUJbjuPfwFlXu3PcsOzzuY8Y85I30vUJZ07nQ+/+MImhQAzczoXFFnWYNpRok1r5X34kT3XtLOKoA9wSOPxpfGrHwCko0QMdaAMq2W0jDVg5tlO93Zo2JObBAA8XuKFiv0R3/yzPifSIh9KEOJCGNOHiBDHp7uPeSDbxFfbTZ+LuT/cHNQDi9oqSRvzHHXtKCdf/2ddqAQIDXt8jsNhWnzi9qk/9ZoG2UveQZqkhCuROeI0SlTyDHp5YxfIbsUjtqN3RyVr/fcZTYprrE4wbzuo1NaqzBtd/qQdJeHL5xzdS/XLkbIypZ3odg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1463.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(39860400002)(136003)(366004)(346002)(451199015)(478600001)(6512007)(26005)(2906002)(36756003)(6506007)(6666004)(107886003)(41300700001)(86362001)(8676002)(66556008)(66946007)(66476007)(4326008)(316002)(5660300002)(38100700002)(8936002)(6486002)(2616005)(83380400001)(1076003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ieG3iSKLRENT7LqVzY0t6BllyfOCbZG0IcwqSmPqVZuGencxpecFogUAU9G/?=
 =?us-ascii?Q?vu8GM60ETd29E96Y2rJwYLVbIKr4XyKa7lXrzNEw9/bfI7zC5nuOpSQmR2Oc?=
 =?us-ascii?Q?FcpfwnThKy87iJfCjpez/fG5m/P7z6sYY6D6iohAm4OV9VkqWWug3YZMJId5?=
 =?us-ascii?Q?pBL9cU5id+Y1hTsu9gmgxj+RR9QMaiW9aRwehUxGjQ6kAR36pj0sMdba/0vH?=
 =?us-ascii?Q?55YJFdxOnB4ifSq5auB0gLiFhj2+fW59sBrmmr5KWoS6T+h/yigSRihq2Z6F?=
 =?us-ascii?Q?AhY2Sn4LAhumgMaxcZmrW0cez/oGcukR48UqVu1gDXSy+hlIDPeSqapDQkPv?=
 =?us-ascii?Q?c7qyTieQcOvXfmr+nHHI0vEiHjBjQleIHALml1Kht9MbNFCwi1Q8rXIFSKPQ?=
 =?us-ascii?Q?G/Dt+aEAyUNTUEzCowCsb4qKYuCvttrmil86bxZ6z4HHo42CPPX/caPKrCIu?=
 =?us-ascii?Q?O+aRKfawiZWwaH/LxEUTNKrFaM2pEhSiOTiys2xqRXDLLh7xQWYuVhJAGswK?=
 =?us-ascii?Q?oenK9fxlNQ5eb9eGUhi9/6sG8lnc+4E5uurFye1Y3uhwvvNDAm8Rlc+JPiwC?=
 =?us-ascii?Q?O/I3nDPd2cE7zElesqESEA2GLJ/527CTdgjXHDJ28BpjOabSn0asCBmICqvD?=
 =?us-ascii?Q?8p9wBC3wOTkryMi8bKC67OfYI0QsvGwDw+Xv679jFBDWJ/9N1bpqhH4ielAN?=
 =?us-ascii?Q?wJsaXAMfiNKwZrV9JudcY1/3vTuH3NsOebuEPYYDRdGvr83dnubcu7uFm4Ul?=
 =?us-ascii?Q?HN45P+a0yGYe8WOtJuSLW1DO4/iJpnIQulJHLeLWTxar+vyGXfhEZaodFJIk?=
 =?us-ascii?Q?ighDuET7MLSeLqpJ2eRkcD9CW28dRYZBQTc57ofDf9yVgGlJw1fSSNYroJGk?=
 =?us-ascii?Q?FTUS+gT08A7by9kTcfPzjfNTrln3T9Fs2DafmCK/Ujm9czHPpdKfFcVuUTHE?=
 =?us-ascii?Q?WM41lEFxNiRrDE4TMC61eCMm+7Xz52/8VuVsM9Dl6tduf6YwYbGkL7//eLA5?=
 =?us-ascii?Q?R1V1wzZMN3+GAfGfbsvEt4D7H+Bv0SFT+gHhEO5zgg3Mtt19loC14TtAkDaH?=
 =?us-ascii?Q?Ljhg1iNnQOBVEwBcmvldHUidD+7jWqKn3QoN3UKZPItCN3M0PGibexcmB3a7?=
 =?us-ascii?Q?qndeTUcytEmPtQoYVK/NwU8bDjHOITThjg1G0Z3Mc0TT/9RUz0h643nsaIkl?=
 =?us-ascii?Q?2xPy2ATpl8CKLfywCHWyrUoQdC58HALtSguGcPXVkdew0WEfGZtlrypnhlCq?=
 =?us-ascii?Q?IJXYdeFEytbjTPZjuM1XW6a5GYbbveVpmmA+zGYsikpoODdBMHucy9iWYebm?=
 =?us-ascii?Q?8WnJlhXmcd/C23zoIL4WhxpeG7r6S8qzUD5H6VPgAKLAJSRPmnqJq/KpAs2p?=
 =?us-ascii?Q?9U2mgI2kTBRagl1i+92VqZHe3pjNrncJ82mIyBlNYH8MP/cocFGWp2LLxcth?=
 =?us-ascii?Q?qOr7X/Go3HWZXRaON850UAPuLfHzIXgZqJl9j3VN0fsT1LMVf1hhDCKwMVJ5?=
 =?us-ascii?Q?EhU+OLa6areeRJWEtEa0Bu4dNr266mCKIpKO2FTI6vNVOGLjBc023Wj5c2GE?=
 =?us-ascii?Q?c4gxT7o2nAdBFUcdAF/dkrmlpgociagJDHB0aN6ATJKmN8s2lN4T8+kF9gpI?=
 =?us-ascii?Q?HA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49b110b2-b58e-4a6c-147a-08dad9ac807a
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1463.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 06:13:34.0995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l52pPms0H7ovGMsNmP980WM4uRYMn4+Szh07cxWH6FA4XcCTcgy/xI+uqT7O8oH9NHCqJuNg6/zVWiU7fG6z8SBSq6iB6duYr/YVHaMcdHk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5066
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_02,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212090053
X-Proofpoint-GUID: g5i5rK6gTB51T_acqwM4qR6kOfxk5lvB
X-Proofpoint-ORIG-GUID: g5i5rK6gTB51T_acqwM4qR6kOfxk5lvB
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute_req is going to be removed. Convert drivetemp to
scsi_execute_cmd.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/hwmon/drivetemp.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/hwmon/drivetemp.c b/drivers/hwmon/drivetemp.c
index 5bac2b0fc7bb..2434ddb000f0 100644
--- a/drivers/hwmon/drivetemp.c
+++ b/drivers/hwmon/drivetemp.c
@@ -164,7 +164,7 @@ static int drivetemp_scsi_command(struct drivetemp_data *st,
 				 u8 lba_low, u8 lba_mid, u8 lba_high)
 {
 	u8 scsi_cmd[MAX_COMMAND_SIZE];
-	int data_dir;
+	enum req_op op;
 
 	memset(scsi_cmd, 0, sizeof(scsi_cmd));
 	scsi_cmd[0] = ATA_16;
@@ -175,7 +175,7 @@ static int drivetemp_scsi_command(struct drivetemp_data *st,
 		 * field.
 		 */
 		scsi_cmd[2] = 0x06;
-		data_dir = DMA_TO_DEVICE;
+		op = REQ_OP_DRV_OUT;
 	} else {
 		scsi_cmd[1] = (4 << 1);	/* PIO Data-in */
 		/*
@@ -183,7 +183,7 @@ static int drivetemp_scsi_command(struct drivetemp_data *st,
 		 * field.
 		 */
 		scsi_cmd[2] = 0x0e;
-		data_dir = DMA_FROM_DEVICE;
+		op = REQ_OP_DRV_IN;
 	}
 	scsi_cmd[4] = feature;
 	scsi_cmd[6] = 1;	/* 1 sector */
@@ -192,9 +192,8 @@ static int drivetemp_scsi_command(struct drivetemp_data *st,
 	scsi_cmd[12] = lba_high;
 	scsi_cmd[14] = ata_command;
 
-	return scsi_execute_req(st->sdev, scsi_cmd, data_dir,
-				st->smartdata, ATA_SECT_SIZE, NULL, HZ, 5,
-				NULL);
+	return scsi_execute_cmd(st->sdev, scsi_cmd, op, st->smartdata,
+				ATA_SECT_SIZE, HZ, 5);
 }
 
 static int drivetemp_ata_command(struct drivetemp_data *st, u8 feature,
-- 
2.25.1

