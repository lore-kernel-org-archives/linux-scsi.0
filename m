Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDC1FC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Nov 2023 01:40:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbjKNBkb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Nov 2023 20:40:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjKNBk2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Nov 2023 20:40:28 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1EB1115
        for <linux-scsi@vger.kernel.org>; Mon, 13 Nov 2023 17:40:25 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3ADNsnRZ001053;
        Tue, 14 Nov 2023 01:38:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=NWLT3G49/rrR9aRboYfHvH2bMlYuyLiAHg5BiTX9x2g=;
 b=X0mhzmbPC1aU3Lowzc989xysooTTyFnIvVyRhCrIZK/XMmq3MFIVEp/ntZcr7e7V3enX
 rsgfzNl9oYhzVPzs4p7akf3WJ/UeO4jGIK5gdaApRJl24PFmrmTp+hd7XIKRnsqpTyYW
 IRR+Uf2CzKyspAeXMvS+e2HSoUu/yyRYw9xXjpYtuxmI37cBIW7bhp71mfBDKrNt+eHB
 E2P4Dm8EcWKuk99yva4jbzp2dcffi+Yhylbq+CXx2PPjjx8JH3Ortay5JowDd31WlqsE
 06t2pu/aVFq1xElBgrv7bv55qWd0cgh9LtrtsNpMa+e9PwqFYxulQOKqtwTBEW4PQeve ww== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ua2n3c3n3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Nov 2023 01:38:17 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AE1DjPY020441;
        Tue, 14 Nov 2023 01:38:16 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2040.outbound.protection.outlook.com [104.47.56.40])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3uaxh0h6q3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Nov 2023 01:38:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LZDbguS4LvWwHa9WXSqeN7OU46OUrMXmCGjkhHQEWzGo4IzJ0czHgAidxQKiQORXvX89YGo4D5wsUr87bsnpBqbn1sUDaDx/94EUveZHGhjDpSCMfi9vw8aTAeTDidxsDbR9bx4naLjgkpH6iOyjSEtuJjucawG0NyI8V2pkAISW1aOVNnnFFQqdWPUeOnAFbIk/lbCI4fHEyM80vUaP/FuwcC7PGWxgh89M6KZGJHV1KFEnAEwbUBv5zZw0VEcx7QuwnJ1tOgGpwTbN4jMg96Ku83wTHw4PNQ35JO5KFglSAD0isJQGKzlNbSSimcx69RC3snCA1fRy9sRnYixJTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NWLT3G49/rrR9aRboYfHvH2bMlYuyLiAHg5BiTX9x2g=;
 b=WJ1Tk4810hPeYC1M9XgmUeEj9N0ElkK6HI0UWBWwFtOF4tXEN/fiUB6i6BDWq41CVWw1p7A74KSuKJ2lP6dJXVCuCkakFSLTEtaDbBjD5g8sxG70Ch6Hpa+Dm4RwutH6FHHlAF+MTTLfRc1s7E/uNLXQVves/CK2owGuuob2FF/rqSVrXQ1b3mzdmuEaXyvIN65SQspTcCGIpbOfoz5m/y1kYsajjUFJGJCHX73S1E4xb5wRoQPBhreNa6V2QEHuO1p6UBoeYOWNxkKnEaTG2KMt2wI1Z1j0R6UmrWItJS7eWvrGU4DX7+XmAFZb/t6pVxYBXBjMqOiMxwT54xB5OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NWLT3G49/rrR9aRboYfHvH2bMlYuyLiAHg5BiTX9x2g=;
 b=XyUI+sAClHMgfzNM7Be9UlCQbbbt+5Bbe9ylQPjQMfpbK1PYFg4qPb/y1zHQvVjZdDL0yZidq8e6KkiEyxOCSQNbCgyYsN5XZaRlXliyhPZIH0QfzKjtJ0kvh+k/3cv5+vJVMC1zmdcLzAKqM3S3YBMi9ffg943t7/KDdBw7TVc=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH2PR10MB4199.namprd10.prod.outlook.com (2603:10b6:610:7f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Tue, 14 Nov
 2023 01:38:15 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e%4]) with mapi id 15.20.6977.029; Tue, 14 Nov 2023
 01:38:14 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v12 17/20] scsi: ses: Have scsi-ml retry scsi_execute_cmd errors
Date:   Mon, 13 Nov 2023 19:37:47 -0600
Message-Id: <20231114013750.76609-18-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231114013750.76609-1-michael.christie@oracle.com>
References: <20231114013750.76609-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0235.namprd03.prod.outlook.com
 (2603:10b6:5:3ba::30) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH2PR10MB4199:EE_
X-MS-Office365-Filtering-Correlation-Id: 98985c7d-5c4d-40f2-74f0-08dbe4b25ec8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OoAPhIAT7HyCUoKtGXQ1N2Z+YEp09qp8IJSE6SikVo6WRCcoKGHWNaSvHixis0SbYrgd5owjvMtI7RtTqLpgHsfR4IeKykUN2SUDYyc9zuXncQB/7oyhNTl/TbBHZXuWsUFh0AE35/X0OUVyCoCgiIApHNvqjjIzU6+SIlkpAWCie7+doCJAMo1tOQUZ3qKD4bHtHceeLxkVfOg3dgGe/Z0rlaRIDH8kUgkCPFG0PHPMkMj0ajCIlKnpki10awwOCwfZ6KkFAEFqDt+r8yqgIkJB5Dd0liiPu5uS8kcukzjdm1GP51/2vs9zAGVVSmeOSMnuLBSACtrUQ6KH9fEY554cFIDYQVPBEsT+aIIzbDv9qPYI5MJ/3mapcmKNCyyWuepJh9BLYNbE8o9e36GH1TnrFB3rWmejqU5L1qXIXwFZC0WaBJtBDmt0Vjdo0OzcZWjDTp3Gzm3Eh2P2b0h3u0Xoh+3EMT0Y26nut+BhXboUQYH4RMyG3nt9cRlzEcIM+OLNIEA0JeTi+MMhDPB5WLs4Ffbd4ZwKHAs3nyd5ILDwLmBuHB2kCVJKiiLZXqGT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(136003)(366004)(396003)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(83380400001)(107886003)(1076003)(2616005)(26005)(2906002)(38100700002)(36756003)(86362001)(41300700001)(6666004)(8676002)(8936002)(4326008)(6486002)(478600001)(6506007)(66476007)(66946007)(66556008)(316002)(5660300002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ko+XrSs6P+h5SKQc2KlUbvQHZ1lalq11Or6vclKeIgd55PIKsA/O5M3NgZ4G?=
 =?us-ascii?Q?1kn1pFmbGrxrvG7gcos/+OFeHXMtFb2Kifc2ZRwrGnxhMzOm0Q371PNOmF++?=
 =?us-ascii?Q?gcBA+Opv8QdTo2yQSTzS6av+jTG9CNe2bedFIh4nR5cSXe9hTL62FcUVb4Oc?=
 =?us-ascii?Q?gp8j84sBI8LXdSI1CrthKwmIig9MSrd71tiIFnfFpGv2YD7QYhFvEC6OHEyh?=
 =?us-ascii?Q?4vVDohSvY1GcAoKlsXaLIfcKOW6mPuWkR2FPpbkIuVJr2WMWfz3xqEDH3jiV?=
 =?us-ascii?Q?XUo+sKH32lyro1LJ6JbNkYFsk89pN+USvvhz9oq6Rj28e1Se2HAa/sqTZmZH?=
 =?us-ascii?Q?A45PUz3aIMXvo8LULDqGVP1FWONkGooHzUTF7MLvYfHXAe3EicyfDIYHH5wV?=
 =?us-ascii?Q?p53LPYkeyAGlPH9+GqZvP7cC2cFWXhorMmvIL7zwocYYd6U6Oe3aUVG8eTRL?=
 =?us-ascii?Q?8AMXMWBKYi50Af8CjXTY5u+QsQbo+6ZOF+yIrtVaUhyQjIydSn1DyRmwofVP?=
 =?us-ascii?Q?DGmumngJ4zGvn2a+vgijNQiLNSiiqvuekG0l6lrkqVAh64n1T9t2tdR/l1Iw?=
 =?us-ascii?Q?fb2qXKuFlTBLPH63+7ZBDKDJeCYc1OZwa9XJd1DFmMN8s5G+shgUMtM0Ngtm?=
 =?us-ascii?Q?fK5qdNzq34KEaM9dJ1ZFUuOjseYZZrxOlG9Abfj5caw1nAT9YCY0M8JNQxkl?=
 =?us-ascii?Q?PO63SMXyid8IUsehxr8y1N9/SjUXW/nKqybCFkKo+1Sh0QXJKwkm9PHfzPOB?=
 =?us-ascii?Q?JVCNv+Wc5lXNfQL+VvfycZKLS7cBNC6C9T1wLfF9QhSUymq16VIge7/lftZ+?=
 =?us-ascii?Q?2GBYjs1vA4zBDY721JderxW2e3SdRRyMGQ0UW35oGNPSk8TKmLqZYBgxoUQb?=
 =?us-ascii?Q?XyfiFtNoxetZWfiyM2536UgdlU3bygYEsiLCq5Pd4qJTA67l/DsDVdQicL7G?=
 =?us-ascii?Q?EsGyhd6dqnnmRcdAksU5sqCSSZDd31U0P6JEwARmsi2/nT1LdWVSpyBCZieX?=
 =?us-ascii?Q?Ug867t81EiKxDhc83Os7zBBjc7sOl9gzGCZB3zcuKwRdcUyO/gwotYR/d4b4?=
 =?us-ascii?Q?UlZw7E8czncNmQjOE8sYIEv5/cRJSphPimdy4BMAC752tbnu9DNoWKKmpM1s?=
 =?us-ascii?Q?/QhLksPNZU2hgs9cQFN+svs5/t73klUd2g8pr0pcNtFrJYQHsNEmKIMrN3Cw?=
 =?us-ascii?Q?rfsmI2Pco+2QCENXwtrQoEjWmBaM91hG06qPejHr4H5ZLwxte67yfpEFxN9h?=
 =?us-ascii?Q?13ETaxK0BgzRmO2NkAXncG+98Pr7JlHRxhYEe4Drk3t99/y/PyxaIbdfvopm?=
 =?us-ascii?Q?mFFcqSWL3cPp6Pf5H9TgKyXNb9QELDw9EX+s/IQl83SXnpBqDlxawd4auoq2?=
 =?us-ascii?Q?i5QRRcnCqRgNCBpLqO+IMXjsmwoKlNeXZ4hrh2SsGaqkVwR+flLQbFdIsEBy?=
 =?us-ascii?Q?O3SuouzMd3lDEit3yyKBVRWFAY46bXvB7wL8lcr+I49c1kdqDfIJwj8w0hU5?=
 =?us-ascii?Q?TM2IctczffzQjsAG4Sa9b7bHdUDm44Em0z4bK/tp6/uZQ+QjWn0Ov7T6Vfh0?=
 =?us-ascii?Q?NaoQyZzyarTAPmvvu1NlEVmid53QDxXMPeD55qrL7SKtGHh+zFWfNBO9Ighq?=
 =?us-ascii?Q?QQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: D1gSiC5Lvo5QloORXLtVJooBb2cb8+fZvblKodeqZGfrGYt2GQoxycChJQzhWqogh0a9GnCQ9u1tMkZ4UbE6k8PTksncVMQKN2+sY1GRducU6yo74fz+dPoDRqGSQB8akAXlXjPwJeLnqi5Z3lJ8HJ9syoQqU3kO7gLCNd1gi8nD7tJYjg0TsYbP5F2A24+ORk7Y+E2y2CNTWugvawQ/tqzk68BP/XeIaBLBJCiPlC1VC81dfsGM/NPgVKnS/6N3ivkVUBEQfNeC1CtygGH6kqprbKijBSOokT8Na5lNhoe9fv5mOjsWO9GoI8ZKbVqRAv0bH1oLeMZUwxQxpAqAIL5qzg5/3uLy9IQOP4DeNMPd9LyjipBzrnTbfr6zkfA1i6FRVEYsZXPFUJ6gdHNl1EuALsjYPZJQhB+T1i6dd8PxMheDREeO8LMw1Fw+y+LTt1/+yZ8dAxN5KUksabnG53vUWEQ0yR1ctckOq4zXPB5uzCuaDAuwLDu7yCMJjfivUAqMpaixQEA/vlAeR74Q/uJcKrqstSoKE/GJI4PHzrKOpiVSKARMx+lDsEz1Rg+5qn1DUn4HX8W4umtrH6H9M6V4c2TeG7EuCzW3exXIY9Vvpl3KPpoAF201t5EkF5V0f5wWPMVWrJ1bxGehcbX0vQPtqvtM56TkBL+6xPvdqSWckl8oAPL8JBjySLJLIjRRqtUVQ/gJioJzezx5oGGLbeXXSXNhtCCF6CCNNw7A9BAnK/C5LsYtesePIv8iZVvtBrilkv3ccggJZHgPQQr7qAzWoqwZY6bxk0Bb6cg5rtKIXqtO9z7BHmxUcTcLQpaYRbCwmUJy/gn54f9DNUatgBwnRfF8EpnX5dyIhU9sMrIl79L5wfqxmuKLVDaWjlum
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98985c7d-5c4d-40f2-74f0-08dbe4b25ec8
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2023 01:38:14.9534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kFK8/ulpcUbiDZGuwGz539SIoUQqgjv2kXyh3I51RR2L8pQXmQN0yA3z2cR15dv58g5Qw092Vb1VVHPXDPw3ffxmnmkAAPhui/T7fNhg5yY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4199
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-14_01,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311140010
X-Proofpoint-GUID: YR3sLbU3oTpuRUvTEhGV98xyo7EkahgU
X-Proofpoint-ORIG-GUID: YR3sLbU3oTpuRUvTEhGV98xyo7EkahgU
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has ses have scsi-ml retry scsi_execute_cmd errors instead of
driving them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/ses.c | 66 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 46 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index d7d0c35c58b8..0f2c87cc95e6 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -87,19 +87,32 @@ static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 		0
 	};
 	unsigned char recv_page_code;
-	unsigned int retries = SES_RETRIES;
-	struct scsi_sense_hdr sshdr;
+	struct scsi_failure failure_defs[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SES_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SES_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.failure_definitions = failure_defs,
+	};
 	const struct scsi_exec_args exec_args = {
-		.sshdr = &sshdr,
+		.failures = &failures,
 	};
 
-	do {
-		ret = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_IN, buf, bufflen,
-				       SES_TIMEOUT, 1, &exec_args);
-	} while (ret > 0 && --retries && scsi_sense_valid(&sshdr) &&
-		 (sshdr.sense_key == NOT_READY ||
-		  (sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
-
+	ret = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_IN, buf, bufflen,
+			       SES_TIMEOUT, 1, &exec_args);
 	if (unlikely(ret))
 		return ret;
 
@@ -131,19 +144,32 @@ static int ses_send_diag(struct scsi_device *sdev, int page_code,
 		bufflen & 0xff,
 		0
 	};
-	struct scsi_sense_hdr sshdr;
-	unsigned int retries = SES_RETRIES;
+	struct scsi_failure failure_defs[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SES_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SES_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.failure_definitions = failure_defs,
+	};
 	const struct scsi_exec_args exec_args = {
-		.sshdr = &sshdr,
+		.failures = &failures,
 	};
 
-	do {
-		result = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_OUT, buf,
-					  bufflen, SES_TIMEOUT, 1, &exec_args);
-	} while (result > 0 && --retries && scsi_sense_valid(&sshdr) &&
-		 (sshdr.sense_key == NOT_READY ||
-		  (sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
-
+	result = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_OUT, buf, bufflen,
+				  SES_TIMEOUT, 1, &exec_args);
 	if (result)
 		sdev_printk(KERN_ERR, sdev, "SEND DIAGNOSTIC result: %8x\n",
 			    result);
-- 
2.34.1

