Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C47DAC433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 17:57:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbiJCR5n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 13:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbiJCR5K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 13:57:10 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F255F55
        for <linux-scsi@vger.kernel.org>; Mon,  3 Oct 2022 10:56:20 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 293GOI63014329;
        Mon, 3 Oct 2022 17:54:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=Za8Itr0CAZag3b80qcmdCICYzTrGf4bru/pCUJ0tZMk=;
 b=KISlZBuiGdF7xu8Lx93QSw2i6mhKW1kmk1S9afrTpsjZPaK+0ETsJ5KawHEWPoyRML/P
 EiYNtctuci3j4V5VW+BLVVBJCvR9plWhXI1w1BfPefQ5D8IIPzYCcV4utSq+p/HZsdwT
 b+iSK3QPOr0c9vmFUMAGALQB6SEmYp72pNJSRYEQNZnu32iNADyrQkcThgnQ85TenNx0
 6mO5B2x6J06MduDiUZ+nohFcmaq7GIs161BRnsAxxSLxOjPnNIfxsh7nvPfcSdGvD793
 +P9gKxlwqpnHfs7D65S3WDoVYsnNfwL53T3r3/+Z0Vq6ec0He5UT8qmAf5Q8CzN9WvfY ig== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxc51vj3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:54:12 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 293FFNfb028067;
        Mon, 3 Oct 2022 17:54:02 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc09gdgf-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:54:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nrG/B31p4cLx1WSCgmoOS+5WvqtFdZSnHjP43B5r7jVRUkgMlB2Yi2On44pg3TBkv7eFUlmSoDNe9cPHzSFSJoDu6XQ2qRB4T16rC3AQqaLYcPYP+9P5LrfEb3zcS5LFl8Yw43FJwzhpaKe5Fa1CupIu6CYyH1yKieAZzsuv9XYmV6mWErcYkP3yt/SRz9Yd4h2tMP9zh+50dudvBEkn8zLlYoudAip0i6MyumK7S2DdICzIGQT/+aRuApkvRnXltiEthXcRUL/kB8i1EpHk0ooxvcIM6KzHTtHdK6frnR2RbWCgjynXaiAOfWOBUZgEZqCK1M3LqpChkP+54KkepQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Za8Itr0CAZag3b80qcmdCICYzTrGf4bru/pCUJ0tZMk=;
 b=SUsyQ8c3Hl1TswWUi8J1DD2eJl3+GIWHjLHbEj26XbdREpejVjqycsy3kkuXmU8rWvT7/YaeMRXW+qfO+4J2R+eVgJCq+iuMyoaz2qROiY+61WUilL7bUcl7EB32FdIse1KhoQcjCac9RU/kxko/3prNNz0CvThko4p2cC/jZ4rLo0uMeN5SkixvrgG2MDd6D9DV7L1M6CMVIjteSM17WLfCJGVAusgBSMBGuHygYvQSF0iPt0z4JdZE8vsuNQYGJNLeqppqoBGoR5O8qS/e/4Ckqzpqnl58rEmowfjxh6y3X7kFu0wyvhX1/gy0zVwz5GxF2CXhgsgsEfOjpxee1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Za8Itr0CAZag3b80qcmdCICYzTrGf4bru/pCUJ0tZMk=;
 b=a09dlnZXIQc+aMFEe6L6o/Kv9KS6Qh6VsLL6PBZv8CJekF3hRr9WUCWle9baHmdEWcmlo1dFwF3TZz9WRVD+NKmYZ1KymNJDswF0t15X6thGXDwwkZE3p52tg5KxoENXIg1dJIWyKEs/gtkgcSGPLismEB52YTdI5yFs7vUG4FA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB4456.namprd10.prod.outlook.com (2603:10b6:510:43::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.24; Mon, 3 Oct 2022 17:53:58 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%9]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 17:53:58 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 23/35] scsi: Have scsi-ml retry sd_spinup_disk errors
Date:   Mon,  3 Oct 2022 12:53:09 -0500
Message-Id: <20221003175321.8040-24-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221003175321.8040-1-michael.christie@oracle.com>
References: <20221003175321.8040-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0236.namprd03.prod.outlook.com
 (2603:10b6:610:e7::31) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB4456:EE_
X-MS-Office365-Filtering-Correlation-Id: 8cba2a1f-f3d6-49fe-9ac8-08daa5683f5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QI2E1oJRMYRJ5Gga8KmkeH6yJtV5n9m0xWJSSxnuXY2kJ58fMkX+ZK0cOwhjeUnhtz8hQdciNZL0Jw+6n8Y+ZQvxugJnxxsPpyrV4atT4HY4TA0kpqTtogutGKRAxTwaFW7FhTilS9Z4ru/KipQD3izRzP6KzPsGzeT88wlKWjtKjp9qPt//A8NgXWUSy4qy/OlWA2T4Pwyvt3C6KGlWid6Sn+yRIp6/lv/aniBsMRjp1b74JEz21wb5ys/fM+v3GKwNafp+ff37kXyYNq/eygpItdSxtpWdYjX032klr/vJ+sqkjVJVnqDkvLydudCnqP/NVldBfaWrYPb4+Nagnm96uZqIcqy0RPSuqQVSqpgS4ex4gr1AWGvV2W+5xbKEyC3CJtOyWc1vUT5JgAEb5yvIsQC/RYhyQCAQhNBWNx2kn69z7GpzxaeFh1HMEjeXh7WzEu83D6MUislqXFX2N1gJvhg4BpIMn2Sel4hU2eZxZ9HhedhYTuot8ERmTiSTCo6ETMl0B6bfYZcx+NRGEztzRbfkSFlwGPHxHQdpwsBuuxUintuGWzwES9XEvDQn0I40tKRnUOtdaaUzKbLiBzvO+ag2RVBSaN+1TxfXhKDX6ga7yQk2Y+UT3wCRRzQXg0e256dSs2qI7lS53ElWNYnU8MwE94BmzVz/gvqATRuHP3z/wyn8NhYbC/eknw2u8fkOne7aYecB5A+jQiIN3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(346002)(39860400002)(376002)(366004)(451199015)(5660300002)(36756003)(66556008)(86362001)(4326008)(8676002)(316002)(66946007)(8936002)(41300700001)(66476007)(186003)(1076003)(2616005)(83380400001)(38100700002)(478600001)(6486002)(6512007)(6506007)(26005)(6666004)(107886003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vIORKEYnISIrbNI/UiqNdrMsjCGXEI1wTV1MjbmBRORMZ413ZteQvb+3ROo/?=
 =?us-ascii?Q?oztJ++t9q3bR4pX0nmTcqO+jY4A+A32kcwS1kdyh8tG8DEOcoKfsrsDw1iGX?=
 =?us-ascii?Q?d1TXcODK5EmWe4Fcfgm+WKn/eN5nlBJU69mebM+LzNtz/soE8E5PTnAMnXXr?=
 =?us-ascii?Q?yn43opo7GpA0cE7uxkdhjxh8P0EyBYiUIZVZKlSWO8wTJV6JVsVSXQ+6P1+I?=
 =?us-ascii?Q?YgO0BUwu1JJBsUu3Qb3WptRvfnoU7W81DhhEFo9nXBtFleNqa1st8uz7LNoE?=
 =?us-ascii?Q?+OsrdM/GhfOJfJcOLOWOlzSI+DfTuEupFFaS5Al0EJLoW0XHYtui5xbqN/PK?=
 =?us-ascii?Q?uGDlv/NFGyvhHcrG6L+VeTu03yhXblcb8QTF6gYPmoA+b+Ltnp0yJhw21Hbk?=
 =?us-ascii?Q?WQ9B0HQp1/ZZeclYf0WguaITuq+OBikgLOx4NX+z8Do31TWcuvl/iOPeBeX5?=
 =?us-ascii?Q?MqS0NHyLPz963r0anzpgxFmkhPS9A8hioOREyzXq4BZTZYjYzjj/lsOdrufT?=
 =?us-ascii?Q?cfbUdhy/CFDEX6VoM47vQ5+8qG3h1w3KBVuN1CjdPwpfcmFp5frymcv5XV3f?=
 =?us-ascii?Q?5XdQOnxokLHsLxJ8kwnydH41MDfv/707SIf9tLV9dceYNFpA/We8ZaGwKfmT?=
 =?us-ascii?Q?XBQYdeBvzzkP/CezYwWKvmPhV8xHQeZRK4vRVyV6Y52RcHNcaEHfrEe8vB+x?=
 =?us-ascii?Q?cGmnrJA9HgVSVNgxuDV0dtQJ7VnAGaZ7WzTwr4HDAPfwb/2J7utwF0+ogYX1?=
 =?us-ascii?Q?IoS4HURhh2uG7pNbLt1PutIBGDBxIXz9un/R/sy9zFghglXQOFYzn8HfvhUc?=
 =?us-ascii?Q?jFN6OCQpWyormlOh7rkMdQuBIHDEhAnFQyXju9wkQFl2Z4bDlzllBiUn3VpV?=
 =?us-ascii?Q?xcbksz/lPWqLVULtMtvMU7Q7sUTtnMn3NdU96rGihHt0J995Pjm64z+UiVF2?=
 =?us-ascii?Q?5gIvdRAu3e+9k2dQiCFv49SktuUsNUiyAdR+ZPyTd506kva6+v8qOEGdRCay?=
 =?us-ascii?Q?qf79MfJ5Z4qkAWgpxFCTYGMzOJ8BNf/XIcTBhEWjd0g8JDhOqk+e70CRTfl4?=
 =?us-ascii?Q?e1ZcJ+hDGNUOizEgb0IRaG2P4j5bZJ6vQNwy56ALRcsfFkIbktOYmtv8ErlS?=
 =?us-ascii?Q?cJnHor1bP3Rg21SyVpmiKCGI25ZN5+HBncHrlBHPwTzbLdgMzcGEihmy7ROz?=
 =?us-ascii?Q?kzsDlw10PQXXLu+2ZFpd68DuLf+v8C1649s5zExIavfuR//eRp22gqJpErJL?=
 =?us-ascii?Q?UYqpRQ098AVPdBhpzSNVm57yqs9IVDGqvqpEcwLh1/v0cTNQon1nzbbNUTSs?=
 =?us-ascii?Q?LLzJAKyf8MsDX97R4r49P/o8JZ/Dq+U2RqnuX+6ZwEhJif58e88Bo5aZI1PW?=
 =?us-ascii?Q?lMKJXr2fk4UOaRhRBZOE+gcYzGRM9n0e2DG0Lytz9oFgThcV9zv1FlfEMvLg?=
 =?us-ascii?Q?FUPORSMTGm7vgUtrRE6B1qnan4WEfpROf1uSf2BLQkFIz+UDWbg3hgFnnJYZ?=
 =?us-ascii?Q?XSmfp8hCbDKHw/3FSG1DnFVXCux2lENIWcX7OMNvslpU8TkaRDOPkdZaOyev?=
 =?us-ascii?Q?xThU/DH31YGklR/+gKylVmZ/Tv8W//KW+x+v1evMCkJFYpuvWrfEHy1+SQFH?=
 =?us-ascii?Q?JA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cba2a1f-f3d6-49fe-9ac8-08daa5683f5e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 17:53:58.6099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ymz6H1PPOqc3ujaEBrxQwu6NjeNacJbGWX6Pc3TenS5JH8rxXBf/RvzNVS+EZx4PF/ckz4Yezxk2yAMMJTrcuPG2pkl2lZCDgtrh+89jg3g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4456
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-03_02,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210030108
X-Proofpoint-GUID: 8KVlFFBrdeZeN4V5JGCEPe9roWNgLxZu
X-Proofpoint-ORIG-GUID: 8KVlFFBrdeZeN4V5JGCEPe9roWNgLxZu
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This simplifies sd_spinup_disk so scsi-ml retries errors for it. Note that
we retried specifically on a UA and also if scsi_status_is_good returned
failed which could happen for all check conditions, so in this patch we
don't check for only UAs.

We do not handle the outside loop's retries because we want to sleep
between tried and we don't support that yet.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c | 68 ++++++++++++++++++++++++++---------------------
 1 file changed, 37 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a35c089c3097..912cc2623d47 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2064,50 +2064,56 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 {
 	unsigned char cmd[10];
 	unsigned long spintime_expire = 0;
-	int retries, spintime;
+	int spintime;
 	unsigned int the_result;
 	struct scsi_sense_hdr sshdr;
 	int sense_valid = 0;
+	struct scsi_failure failures[] = {
+		{
+			.sense = SCMD_FAILURE_SENSE_ANY,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 3,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.result = SCMD_FAILURE_STAT_ANY,
+			.allowed = 3,
+		},
+		{},
+	};
 
 	spintime = 0;
 
 	/* Spin up drives, as required.  Only do this at boot time */
 	/* Spinup needs to be done for module loads too. */
 	do {
-		retries = 0;
+		bool media_was_present = sdkp->media_present;
 
-		do {
-			bool media_was_present = sdkp->media_present;
+		cmd[0] = TEST_UNIT_READY;
+		memset((void *) &cmd[1], 0, 9);
 
-			cmd[0] = TEST_UNIT_READY;
-			memset((void *) &cmd[1], 0, 9);
-
-			the_result = scsi_exec_req(((struct scsi_exec_args) {
-							.sdev = sdkp->device,
-							.cmd = cmd,
-							.data_dir = DMA_NONE,
-							.sshdr = &sshdr,
-							.timeout = SD_TIMEOUT,
-							.retries = sdkp->max_retries }));
+		the_result = scsi_exec_req(((struct scsi_exec_args) {
+						.sdev = sdkp->device,
+						.cmd = cmd,
+						.data_dir = DMA_NONE,
+						.sshdr = &sshdr,
+						.timeout = SD_TIMEOUT,
+						.retries = sdkp->max_retries,
+						.failures = failures }));
 
-			/*
-			 * If the drive has indicated to us that it
-			 * doesn't have any media in it, don't bother
-			 * with any more polling.
-			 */
-			if (media_not_present(sdkp, &sshdr)) {
-				if (media_was_present)
-					sd_printk(KERN_NOTICE, sdkp, "Media removed, stopped polling\n");
-				return;
-			}
+		/*
+		 * If the drive has indicated to us that it doesn't have any
+		 * media in it, don't bother  with any more polling.
+		 */
+		if (media_not_present(sdkp, &sshdr)) {
+			if (media_was_present)
+				sd_printk(KERN_NOTICE, sdkp, "Media removed, stopped polling\n");
+			return;
+		}
 
-			if (the_result)
-				sense_valid = scsi_sense_valid(&sshdr);
-			retries++;
-		} while (retries < 3 &&
-			 (!scsi_status_is_good(the_result) ||
-			  (scsi_status_is_check_condition(the_result) &&
-			  sense_valid && sshdr.sense_key == UNIT_ATTENTION)));
+		if (the_result)
+			sense_valid = scsi_sense_valid(&sshdr);
 
 		if (!scsi_status_is_check_condition(the_result)) {
 			/* no sense, TUR either succeeded or failed
-- 
2.25.1

