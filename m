Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5B6BEB64DD
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Jul 2023 21:47:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbjGKVrF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Jul 2023 17:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231454AbjGKVrA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2023 17:47:00 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2851739
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2023 14:46:56 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BID1qj015477;
        Tue, 11 Jul 2023 21:46:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=iB/M8qlFyCR1AgmN73Ve3GvZdF2veJjNkysZ6Xeh9Fg=;
 b=XNtAacoO2Hu5IDpT1yDqXnlzmBTtGkPedwTrKG0dUnftRbk97Gs1RXDYCMShOqpo/omQ
 siQwE31oyMICtt3mF/TVDiq6H6DUshDi0n5A57ft8eq9VcYyQg2PZ7c6QnEWkx1OjY9T
 BsqrBIgC/5UzDyFFMEBuYYy3wzdU7xcZPho+dlo6A7nFtt1zp1dbkbi0d1E1qkFuzOJR
 q4pocoFkhkhOqB9Jlnjj1PdJW+cGuLRYYSUv0Dm+LbyzukdklHubU3amuKpn1sozsMoj
 kCIMmwo4nubKS/1DNUdDs43GYKeFFeZG94XJHVR4khMP/miDcAYg0CLPPA/BBhnZHgSD YQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rr8xumf15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:46:49 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36BK0PiH000588;
        Tue, 11 Jul 2023 21:46:48 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rqd29sh78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:46:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j7SQIpVBrZ0dxIReYRkBMrtQ+vXV7q3/XB/1My946CchYt9bh0YhxrucRLN/IPVQjK+dyD1W6RN4XNl2jjERH6OH84S792W51YcM8BsZZPJCa2mUmfAFz7v25v1W+mIw1hdqB6E93UzWZbwYm6JoON6zoHsLsIzucVlH72AlwupDoQlhwu+2Y16/8bRqz/LnXtRmf0g5F1O+29jPavXiUqwzgxP9kEVZuKSoZwhKh3RiKe5PhXHybpYLwU2OmxzIwtowqjbGPMe3cookvYhcKjOPe39k3vV10rpN1PLl0C41a2IDtjD7/U8jeQlaFE4OZy7MuDko8w9Ay2H6NYccIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iB/M8qlFyCR1AgmN73Ve3GvZdF2veJjNkysZ6Xeh9Fg=;
 b=ktRGny1Y4Q2VPm0oIaHsonQrucmq/+AwIlmx/aw2dx2ocApcQdKs2V96PFdSGJDCMJ7srb5aEFtodD/eOvgEU96FrGFoQLkwgoWPA60+1ZR2sHUCh7Ry3osxPM+Ro+5mY29ZFdNZ9qoE015VSeCe+BeDGOYUrt1gYxHs4KkXAY4qvrMi4vXtiIize/yydK5Br/VPo12ainb4yncmevKYaxtEsSl6s0kQMlZBXe6YBK6TncShdpxjsKOu/Z+yDiLGagkKcEEsCL80oM7+AyvHXCuHzgWeLY7jaEaXKx8UvxnNMwuBtOZbqACI0s4/kdcm6Lerbmh9tsbE2X5CbTqSxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iB/M8qlFyCR1AgmN73Ve3GvZdF2veJjNkysZ6Xeh9Fg=;
 b=nyInw+KE8RxULiZ0wIAv+roSyJkDtom2FkAzLruSIVRK59snNzSSKxmww5EiYGSAcSEDk504863/THaQYpwZzzRbAzZEN6rxXcxTB1ZIQ9kfAbDFTUaiJWsk680om8u1Pgx7mMSFVo9p5n1GfobHMX2QDOwGQb0BtCoISYtTAcE=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CO1PR10MB4450.namprd10.prod.outlook.com (2603:10b6:303:93::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.20; Tue, 11 Jul
 2023 21:46:46 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6565.028; Tue, 11 Jul 2023
 21:46:46 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v9 10/33] scsi: Have scsi-ml retry sd_spinup_disk errors
Date:   Tue, 11 Jul 2023 16:45:57 -0500
Message-Id: <20230711214620.87232-11-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230711214620.87232-1-michael.christie@oracle.com>
References: <20230711214620.87232-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0138.namprd03.prod.outlook.com
 (2603:10b6:5:3b4::23) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CO1PR10MB4450:EE_
X-MS-Office365-Filtering-Correlation-Id: 1463dedd-b777-4bc0-e785-08db825852fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BxIP8yFhhkv9cLGfGM27NYauBZnP/j6l4zbW1qteRpOKZcCYuESKGC2Yrzisb7PlMnZjgajpYyrOmT9DIBpofGePwQPWdhkONh8aP7U2WrLlNon6UMsbkHiYzMBhrpvLQYcqEaMLSRuPDUlCpQNUxoK4A8ayUyheioyv5bCFq5mWmyJpbmqoMrJi7KvZxv2BgLmx2Dtzd6d9RkBpo/KfyNvNbwpKcPypW23UJNXbwHZcBig8NwP4fj0YYiYAzKQX1Q0NNzUQr2i7PjszrG6cdffnUL2904fKAHZsSBpS8Jszcg0gMeZN8bqVpxcfTo/8bY7wg5NWK/tMW0mbeIZgJRag1Ejh8FmAo5E08yk8/QC5+/W2ZuL8eXObq6FjIG3qwUP/6rdS/N6PW61AjlFuS/E+CL6zSUHOjYX9JGAve17LQRdZcx2zDl84DEZ2MNM46TKhmwSyITCBWbnsfhY9e4GZp/06GvXgmHRbH8KaCa+rEA7xM1p7gf7zto32LLboX22fe0V0TUtBQjSXyfbsoMTInyp75cVJpfRK03+Bimr9Z0hmXehZhhX2RScFkaI1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(346002)(396003)(136003)(39860400002)(451199021)(83380400001)(2616005)(38100700002)(36756003)(86362001)(478600001)(186003)(26005)(1076003)(6512007)(6486002)(6666004)(5660300002)(8936002)(66946007)(66556008)(66476007)(8676002)(2906002)(41300700001)(4326008)(316002)(107886003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GTuz4lL2HnyReysQzWxwVCRTCkqyC0n+ZivboPIQIuJMqQNVlCUoIQEmRqsk?=
 =?us-ascii?Q?2DrONCcQHG6EuO7Or7JgYDvZqAeCP6AIWBVPLbrF0hSmp6QABwjzJ0v51oGA?=
 =?us-ascii?Q?PaEKraJ2pOpez+k81lLrTYiyuqKeSLT3hVPubcX/XbZmLnW+SBxYRT7igLv1?=
 =?us-ascii?Q?Pb2Gt6pWpIjkcw5bCgiDYCWhOKi/dcaeSDRn2ZRx9Ocf4wLQX7CbY5Pqxfya?=
 =?us-ascii?Q?MpmxAZlgrhvXDQCRZeBaG18BvsYaawmlxEiqw2zUvrAEzqZEcgo5KE3um/n9?=
 =?us-ascii?Q?ZXo0wzvFcPs33SvvaVreQVQSHEOEpVgqIOMqwN1EUi9GLp8AcWr7jrObquze?=
 =?us-ascii?Q?SCYPZjZ+RF7/tsMMA4qqwauAtsjCIAl3Ae6qrCjnOoMeq+X3NRqTalFVzTlU?=
 =?us-ascii?Q?w4ihyWJ892rur+tCPnP57ummlxAXv9RM4BaH9KfnudF2Y1/VPGh6/M5/FAFe?=
 =?us-ascii?Q?nJJ6cY+CMFUBqVpuSsdoymoXAEVANq5iTmvVKt969DHCRMrKeJ1o6NTlJ/sV?=
 =?us-ascii?Q?Q11TapLjLaSdo8ItXG0S4irFE3tV8tUQHq28W88q+wk73jRLulb+CnaviK7L?=
 =?us-ascii?Q?Fk0yeA90JO0eE4rH5leYwZPwkF/yqoWtaDQhpPNg7G7vV55uoTV4Zh/px2M5?=
 =?us-ascii?Q?cnwTxn58XSWZ9hwn4p3RuugdVIKKz7+LE/0PQwbqkKDAMXUb5dhYrfwu7Y1k?=
 =?us-ascii?Q?J58Wgq9KfoQkYywgnjjs452XcwnFsZ1M9GXxGmmtIdHN+tVF2JQZNU7UJ1ZN?=
 =?us-ascii?Q?aLeGMPV79R9s+ackWL8snjxHUasYzPucYMZBirjWWJFUc3AY9qXFrriY7RYr?=
 =?us-ascii?Q?YYNEn1aXAwIOmE7is3kOG1fWnucnfMVbgQr3kh3TGoRn3urpLYjaCuQ79lnS?=
 =?us-ascii?Q?MjvOIyo+eh5MM1098kYH8Tud0ttm97jhC45l1E9JDAmggCDeJQiljyWJS/CY?=
 =?us-ascii?Q?L+2xNac066ixoAb+RStj8s+Ll3vi77RbLHgocl0JtOubwaFWbeUdll6WFm4Y?=
 =?us-ascii?Q?xaMAPmGI1txHt+Y2tZZqTHuaIwFL1pTYb0QRGAXQGUe9Rm1+0kOOkmQwZwST?=
 =?us-ascii?Q?fuVfWlS1H7gGwgsGbhaB82X++Vpf/DjCuzcfLd3n9VVIoHyQHcVeC4SoWxAu?=
 =?us-ascii?Q?l1aMKpDIpKA1pIO3FWQWjxbejZmVpt3lNkFbZvK6n6h2fAiM56TxMwgJEnHT?=
 =?us-ascii?Q?8y5phiySISMZ+uEc2Lryfo9Wh+2FxtGusUDLnoliOGtmw++jEQ195HQH+0+2?=
 =?us-ascii?Q?SieUpcJv4c0peYtSYIsGJQmChbqxE56pOYzRLa9uc/LiGZ78vEZFBWwAN5Cb?=
 =?us-ascii?Q?+k/1KMjbGxY0mHHvsQc/IQ6DTox50aXyMUTRG+y5g5sZzcLAejTx9orvbz6r?=
 =?us-ascii?Q?lcfkhbZMTtaukzWfSDwVUwOvF2qEfOeaHWPFlAdAgYFvbjEWRHtzK1zLV+P0?=
 =?us-ascii?Q?cJ7bY7OXsIjOKcYMjMWSDb4b6Jf5k+FvCyeCG8EOsAihL3piJQcamk4C15oL?=
 =?us-ascii?Q?iujpbQ0NwhT5UGqNG/bOdycn9q1OdSMKoD8YHxZsA3EGC7QCG/2o6UOiGagM?=
 =?us-ascii?Q?G6ITQ7OhbYnIkBOc6NwFHnQUmXk9G7aZR0hvqXGKEap1lbRx8feQ3YdVevPu?=
 =?us-ascii?Q?8Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 2J3Mppb26zgaSJLbvqtfq5s51O75c4tBiXSseoKqkfNuvL2C7kxvfPV7AWaPnZXkW9wOJNXH7VAqtuDptEJvB2IWtgYN+fTg5vHeO6Ct7lN7B2HXILaJFrMIOhLjLiaQICuqgre9G/ye2mjPKPuyjMv/lfoFg/wHogqI8jSSc3IyFV26xbJ5C4RtQefPS3tfQAe9FPlnmaZud7/TIwnuU5vjpHMB9x3eIGlVsSedK3ZpBU1jdrPXJNWhXw8NV/w6btgAUWKoyToJjP6ips0iNjIKXm2L8wBIycSrdygEq7cMQVpRoAWT8PPf7Xpmu3eO7nyXSrrpH8VpHqLEdFEWi61PzFJ32wTnhKXzw16Aare7NCVvt6z4r95xjWT9JZpnWc27h+xJ1bNJdXf+h9ObF68rzLTksAtHK92e+4PaLqePr15alomgUBrWekjOV0im0JHt06O3ztA5fDrkH6zMjZQSaHxjrjL2hctZ57bRA5bdyabhkyufcSDdowTISD9wGFYpfCd4fpDD0J10mpcw4+ZkkIENK0nJS98PzaLQDVOfKr9tH4cjhwGyckRgFDEF7l9+VVn44vUXE83oeKxq6IzolHKLu0969OhJQIS333T1wyzvGZEw+ynpP+IWOACRmq7Ps9keXIHVFQ6Qpgq10QgYdeS5laQ/2VW2re71sQNFzOTvVNE2Ctzu59yXRqO+AvE5Qwfi0YfKU6lr7NwKKbFEczmgIqJ3JcNyBKb4+1Oeo04n+Xobpe2DHHXEjvqu5Nzw8/BLEPErZQe6ieqhM1qOO4yC0GTvfhHg6BHK5UhYAyx+NQ5WGq1bMrDrPWzPWpIVz23RfcTewitr/VmsHkpK4QUwaJ5GkURAiAz7z8ALfm6ho9AU9xArjCLZHPOR
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1463dedd-b777-4bc0-e785-08db825852fc
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2023 21:46:46.6343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NSZsm1Pxyuvhd2Wy1yWY/w9XXY9ckSPplRocRv3O9B3kdvTZA/gtzof3Ztu34NwCUuFcBDi+43FEw9n4Y9xk/M+S/E1dompj7LsI1EOurpI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4450
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_12,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307110198
X-Proofpoint-GUID: JF0dYaad9CkIh7EQSC0oR4r_QV5hbbyI
X-Proofpoint-ORIG-GUID: JF0dYaad9CkIh7EQSC0oR4r_QV5hbbyI
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This simplifies sd_spinup_disk so scsi-ml retries errors for it. Note that
we retried specifically on a UA and also if scsi_status_is_good returned
failed which would happen for all check conditions. In this patch we use
SCMD_FAILURE_STAT_ANY which will trigger for the same conditions as
when scsi_status_is_good returns false. This will cover all CCs including
UAs so there is no explicit failures arrary entry for UAs.

We do not handle the outside loop's retries because we want to sleep
between tries and we don't support that yet.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 73 ++++++++++++++++++++++++++---------------------
 1 file changed, 41 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e34cc9daddce..e67a3d163b24 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2191,55 +2191,64 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 static void
 sd_spinup_disk(struct scsi_disk *sdkp)
 {
-	unsigned char cmd[10];
+	static const u8 cmd[10] = { TEST_UNIT_READY };
 	unsigned long spintime_expire = 0;
-	int retries, spintime;
+	int spintime, sense_valid = 0;
 	unsigned int the_result;
 	struct scsi_sense_hdr sshdr;
+	struct scsi_failure failures[] = {
+		/* Fail immediately for Medium Not Present */
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x3A,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = 0x3A,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.result = SCMD_FAILURE_STAT_ANY,
+			.allowed = 3,
+		},
+		{},
+	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.failures = failures,
 	};
-	int sense_valid = 0;
 
 	spintime = 0;
 
 	/* Spin up drives, as required.  Only do this at boot time */
 	/* Spinup needs to be done for module loads too. */
 	do {
-		retries = 0;
-
-		do {
-			bool media_was_present = sdkp->media_present;
+		bool media_was_present = sdkp->media_present;
 
-			cmd[0] = TEST_UNIT_READY;
-			memset((void *) &cmd[1], 0, 9);
+		scsi_reset_failures(failures);
 
-			the_result = scsi_execute_cmd(sdkp->device, cmd,
-						      REQ_OP_DRV_IN, NULL, 0,
-						      SD_TIMEOUT,
-						      sdkp->max_retries,
-						      &exec_args);
+		the_result = scsi_execute_cmd(sdkp->device, cmd, REQ_OP_DRV_IN,
+					      NULL, 0, SD_TIMEOUT,
+					      sdkp->max_retries, &exec_args);
 
-			if (the_result > 0) {
-				/*
-				 * If the drive has indicated to us that it
-				 * doesn't have any media in it, don't bother
-				 * with any more polling.
-				 */
-				if (media_not_present(sdkp, &sshdr)) {
-					if (media_was_present)
-						sd_printk(KERN_NOTICE, sdkp,
-							  "Media removed, stopped polling\n");
-					return;
-				}
 
-				sense_valid = scsi_sense_valid(&sshdr);
+		if (the_result > 0) {
+			/*
+			 * If the drive has indicated to us that it doesn't
+			 * have any media in it, don't bother with any more
+			 * polling.
+			 */
+			if (media_not_present(sdkp, &sshdr)) {
+				if (media_was_present)
+					sd_printk(KERN_NOTICE, sdkp,
+						  "Media removed, stopped polling\n");
+				return;
 			}
-			retries++;
-		} while (retries < 3 &&
-			 (!scsi_status_is_good(the_result) ||
-			  (scsi_status_is_check_condition(the_result) &&
-			  sense_valid && sshdr.sense_key == UNIT_ATTENTION)));
+			sense_valid = scsi_sense_valid(&sshdr);
+		}
 
 		if (!scsi_status_is_check_condition(the_result)) {
 			/* no sense, TUR either succeeded or failed
-- 
2.34.1

