Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 379B7C32771
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 02:55:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234801AbiI2Cz0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 22:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234411AbiI2CzE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 22:55:04 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71AE23FA22
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 19:54:58 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28SNiROU003466;
        Thu, 29 Sep 2022 02:54:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=3SeM4EOyoqhl6LIVj3aGwMMBHw7f6ZvB8Z0DENSb7jk=;
 b=IqmxI5l/RyqueNdPLOhuRSjIQfJP4RlJ2A/GqJcziYGgNqJ1DOrf+gplj2JBTZdmpCVi
 b8mVWC1U/NJD5BzQwXZjKkjd1VdE86wsSoedJMeozZ4t4Syi3r+sXk8FnlOVMERPgp5P
 k0pkiaE/KLnTQySBCmNp64a/Wpt96MTiX+Nglo0ybbcUBmat/sD+2mYlKfB/j5fPWfd8
 jJnyG4q3prv0m0AGDsxJP/3JVAGCpNeCnkUgpapoYx/iyND8VoV3H7RlOyXL9NiJDof1
 4E0u8FAYW0Q1yHFhCybgyha9xIlNP6Q+2abet91PpY7gwUj9SCNsxvbR08dOHssnd6o7 dQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jssrwkjcn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:48 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28T22VCT039393;
        Thu, 29 Sep 2022 02:54:48 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jtpq9jc94-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RKzToLfB4r6JMjuiqV5OzmROQcj9+YQ6Ohleq+2XU2UiOEesyGUJ/pty9MkNLmyl8Pe9E203ZIyZl+qMaR9+ROcrmW9F8OmVOquBUzxKUYI+gN2esaptoaOLLizFIBj1m860GoG0KQt5CTiF6BkYYPNdBPHlCSnyaI/XENUGdXSrTC0o9srGi9ImC5eB4J1G/e/Ut7VfWEjSi/y0zg7/MFRjlQcndt0d8JLMOOWu0mdjyWwKz9ytaJROnK412ehSKXvFxiAZtyblYOcPm0JhOOVe0s+F6FTTfqWoBYbu+tbCLcavAVfMqFV4jpKlKGlZV16NfV4/Sounsmv6yLtW/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3SeM4EOyoqhl6LIVj3aGwMMBHw7f6ZvB8Z0DENSb7jk=;
 b=YHGH5rL7L4dhZTvMHg/H0SVy/stAUSd/DrDSg6u0trv23hDfnsCxFGS1c+V7ggLPlFf5ZbglPKR6UjaKRnLXV1LQhWE8aI3roDTuqdUgQQrpAhlsGtdUkW5YWnAS1o1V4RMSkWoslhrQpW+aZQNsTkeQSkXnJIFm2OX4sR/xwTdq2Ky/KuN+JTqh8CyikT85uo8jrBDiMFXAgIm+Y7mC7ANwZ6yZCCAJOOaXF1Fcr8Jd0rQMO+2P8Fv/xek6XWOFmd4WwpH4adeFh42Ms40oGcfvmen6ppxGLkTpWARhkys0+stVG1g7PckJxO3W1syQVa+InyBqQ9RKrudrh5Ki4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3SeM4EOyoqhl6LIVj3aGwMMBHw7f6ZvB8Z0DENSb7jk=;
 b=fo6OQGlk/sxC6U6iXqlOt70mMXrPTl42EWAu/74MchnhK5Lk/6hv55aL3cNP2o4ZggLv/kTC3ODbfQ/1D07b3uMqGsc7hmMIYECinB9txvVBcNuK9ygeOAOQlOer3yQ62AVdckgWB0E4cqZ451TYArEvoMlYZzDGFxT4lcltKqc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB5872.namprd10.prod.outlook.com (2603:10b6:510:146::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Thu, 29 Sep
 2022 02:54:45 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%8]) with mapi id 15.20.5654.025; Thu, 29 Sep 2022
 02:54:45 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 22/35] scsi: Have scsi-ml retry read_capacity_16 errors
Date:   Wed, 28 Sep 2022 21:53:54 -0500
Message-Id: <20220929025407.119804-23-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929025407.119804-1-michael.christie@oracle.com>
References: <20220929025407.119804-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR11CA0015.namprd11.prod.outlook.com
 (2603:10b6:610:54::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB5872:EE_
X-MS-Office365-Filtering-Correlation-Id: 848f0fa9-11bc-4139-06c2-08daa1c5f767
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: My17MbKEpm0k20nmDR4X2S107nc0sTfh6Jyuf0mJMPcZUy9sT6jzCHO8jcwV6i5wYPSaYhvIjPEFqNLabDmWKlW09RDZLyF0CYmwFNs6Q85nxbv2O9H1LkYkG4f2dpA+4ANPVKdLDe2IGHaftBkskrSW3Pz5BsvT6tb8SXkAr5WBa13SLaWgkIgXm4ddarKrBq14lHSMnV/NJZyPwgNxlalCWDj/c4S5KxBHgYP01+ZNw4VTXfpg0mFqjI5KcOHGbBx+7I0oh2Hdpaist6uXP4rKt+cIenCUGNUrZzYtqqfHPczGs6ZfQ2QEtOFEBnG3UrYrSVfMWbl8SKYB/bzDvrkFIlLjtCmhFU/IbGuCz93HXec513zJOUALwf5EPkEs9e5PzVWrVTOdlgDGq2mX7WSEZB90Xjd7Oo9RFQh9DJlab266L+XGM8F0Jx/kOgzykvym7UbH32ZgY9J617TfgfqEzzxys930WUXlpn3bEpSIonMrgpdnrYozFXaVef0FyawT5u4xOJeZIf4Gfes0sNlwD7Bpzj3ZfkqubBgIQcE7JL6b2eYPwEeoDm9nCh0tPERr946Zcnr3PZMMNXS604QEXtp+d+p3TANqpU82Xymw7pml4AySj1wOnrGUjQYbiB3GnMnrXJnlLX6wuwysq2PBpwD7sUdTgkp0lxgl4BbDZBJsmPgUKq8v09dXv4/Zz82izfe9kszrlprAY7J+yw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(366004)(396003)(376002)(346002)(451199015)(2906002)(6666004)(41300700001)(83380400001)(66946007)(6506007)(107886003)(6512007)(478600001)(8936002)(36756003)(6486002)(38100700002)(26005)(186003)(1076003)(86362001)(4326008)(2616005)(66476007)(316002)(8676002)(5660300002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YS0u0ipm+ToX0JeztYDHJUioWmyc82gZ+jXaE8GtYIWAqUvcrRBC6wAtPuO8?=
 =?us-ascii?Q?a4WOjHf899txVprPTSNz7vCIqxpgMtSP8SdfC883WoPOAs0mBjtC+f32uAyq?=
 =?us-ascii?Q?og0XmBqLfYp69tsgko2KCAYcuKko/5pFAHIC9Iz+d9iZu7UXucbk+gukORMC?=
 =?us-ascii?Q?l9sQ5cx3gYvanFv6R2N6CHcc4APKS33qbT2Wil6WYomyjQdZv+U1gBJvLE/o?=
 =?us-ascii?Q?JT/DuZmDXhQsmYwsHx+XXOi5AHBKpaQXh07jyXw11AhBhrgZZ3e+eZeWd7tV?=
 =?us-ascii?Q?JsUlQ1L4Vb17cls5biLW/0zWMWrigtnCc+FuvejrSjDofJzkbRTyw6SdlH2l?=
 =?us-ascii?Q?ynDCe/5Yw+gX5tnQT5PInV/FHoVL3++GvbZdWp2TfPe8gdKxzQeJ/WwH7Rca?=
 =?us-ascii?Q?l7UzNMRT7Oica7rYp3d9VRABVwsvsPF3A8KUe+UNE1lw4z9guexCzmO3A/Uj?=
 =?us-ascii?Q?Jfe15etPAwy41z+3t9MafAB8X5VwJk2KlOVJ3NqufbGZVp5v09pfwOh980gr?=
 =?us-ascii?Q?et2zeeeCEn/Pn14A+8lINqTcLv5ZIcjTrN/uedpZj6WOCNRkGYfnrB3YwgI2?=
 =?us-ascii?Q?f0aTLAN+OekEBY1KXdG2Y1/uLKz/frF/TK9sazDtvmWaUfWn6vIInSuZv4fk?=
 =?us-ascii?Q?Vv32POGjoc7Lag9pZRSoGVHdw1sIVLfT+QYQtYGcRjqAcixHSkFmLSzvZx5M?=
 =?us-ascii?Q?Io+XWr8R04D7D22Cq4b7SNkPMhj3mxqo8w2PYQoiCb1uLW7jWEd4VFSiZwuW?=
 =?us-ascii?Q?Qv1mhtu1vb6ONyzk85ilypjKsklm4SblY6S6rMHJsDhDQMz14ESXmVrOyqjK?=
 =?us-ascii?Q?KGmaLLk+iQVFAUH29xYV4kosnkXaItS/CIXlkdmBkIekmuOIsKJ7zKT0Nnad?=
 =?us-ascii?Q?zz0yw9+L2AHQh1itX/isH2eq/vvzR1MbxSBaX8GtuOb+TCx/ulLuYKGy5My3?=
 =?us-ascii?Q?E5wSA0e2WuibWm6nQIpFis847c0Zv/uZs343YZqG0owhio3bJO+MChUPOFP6?=
 =?us-ascii?Q?HUeGQTWqbDVlF1a5CZOO6iFKwRTBG1oNXdeuQKqYQktyOLEBXOGv7mffkx71?=
 =?us-ascii?Q?E/bjXDDafzHlkYokvdCOKwxXkcDfD3iiro/+sGphOsUw2jl6xdIP7rQygJmy?=
 =?us-ascii?Q?c/EX4HSQnII4Q+sJU4iNOjFDT3cpFNjtSySoMvEDCa6ClaM9YvyZ0qXK2Pb7?=
 =?us-ascii?Q?YOSKOXneld3ZvkZM8QqPqtFGIfcl4BIHXJBgkR5QquL8kDrVRUWxpgCy7ZOv?=
 =?us-ascii?Q?ZTe0E7e1uk4L3LnVIV0pa2pyMXb26Li4fbBhfkLUuNZYutZTVi0dTvkB9tO0?=
 =?us-ascii?Q?1JRz1Da7vKuLtkn5NnV5emWCRevHXOcCEbGcPJOoe2TOkPpOcWwTOjxwaTCt?=
 =?us-ascii?Q?1yzlCxxn3+5HS7wGhcYM2S13l4kQfNmNoPZ6NWG1AsyKFxAOHHz+X8taF15w?=
 =?us-ascii?Q?czwCxW/nwKGpdTV0Fpz7zuf+HeoJy6oPHYyqqZ+lSQP2+utLibuU48qBnaFh?=
 =?us-ascii?Q?xn6grv/WPr5K0T6CBCh0nGRb2pK9lQD3IaKF4omJyeIXoh7hHYqarwWnYlLN?=
 =?us-ascii?Q?v8z9KnpkpKwN6BfGWJhDeyfDF3tmMeG5IelmZkcs4XX9HEQFNHfsslLnk5pL?=
 =?us-ascii?Q?ZA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 848f0fa9-11bc-4139-06c2-08daa1c5f767
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 02:54:45.8481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Ca+mhbaRU8oG7EPB4alze80XKjIeTilL7M1MN+rHjNmHQ5JePY5kGwyQ/P9j+/t6bOqavv6E3Un9D+L+yOusE2yPSaKYiFoEIb880+K8Ew=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5872
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_02,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 adultscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209290017
X-Proofpoint-ORIG-GUID: 1Mn-rD6y8UNJdq-u_Bha2Q6lXNnIm0bU
X-Proofpoint-GUID: 1Mn-rD6y8UNJdq-u_Bha2Q6lXNnIm0bU
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has read_capacity_16 have scsi-ml retry errors instead of driving
them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c | 82 +++++++++++++++++++++++++----------------------
 1 file changed, 43 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 37eafa968116..a35c089c3097 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2283,55 +2283,59 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	struct scsi_sense_hdr sshdr;
 	int sense_valid = 0;
 	int the_result;
-	int retries = 3, reset_retries = READ_CAPACITY_RETRIES_ON_RESET;
 	unsigned int alignment;
 	unsigned long long lba;
 	unsigned sector_size;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.ascq = 0,
+			/* Device reset might occur several times */
+			.allowed = READ_CAPACITY_RETRIES_ON_RESET,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.result = SCMD_FAILURE_ANY,
+			.allowed = 3,
+		},
+		{},
+	};
 
 	if (sdp->no_read_capacity_16)
 		return -EINVAL;
 
-	do {
-		memset(cmd, 0, 16);
-		cmd[0] = SERVICE_ACTION_IN_16;
-		cmd[1] = SAI_READ_CAPACITY_16;
-		cmd[13] = RC16_LEN;
-		memset(buffer, 0, RC16_LEN);
+	memset(cmd, 0, 16);
+	cmd[0] = SERVICE_ACTION_IN_16;
+	cmd[1] = SAI_READ_CAPACITY_16;
+	cmd[13] = RC16_LEN;
+	memset(buffer, 0, RC16_LEN);
 
-		the_result = scsi_exec_req(((struct scsi_exec_args) {
-						.sdev = sdp,
-						.cmd = cmd,
-						.data_dir = DMA_FROM_DEVICE,
-						.buf = buffer,
-						.buf_len = RC16_LEN,
-						.sshdr = &sshdr,
-						.timeout = SD_TIMEOUT,
-						.retries = sdkp->max_retries }));
-
-		if (media_not_present(sdkp, &sshdr))
-			return -ENODEV;
+	the_result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdp,
+					.cmd = cmd,
+					.data_dir = DMA_FROM_DEVICE,
+					.buf = buffer,
+					.buf_len = RC16_LEN,
+					.sshdr = &sshdr,
+					.timeout = SD_TIMEOUT,
+					.retries = sdkp->max_retries,
+					.failures = failures }));
 
-		if (the_result > 0) {
-			sense_valid = scsi_sense_valid(&sshdr);
-			if (sense_valid &&
-			    sshdr.sense_key == ILLEGAL_REQUEST &&
-			    (sshdr.asc == 0x20 || sshdr.asc == 0x24) &&
-			    sshdr.ascq == 0x00)
-				/* Invalid Command Operation Code or
-				 * Invalid Field in CDB, just retry
-				 * silently with RC10 */
-				return -EINVAL;
-			if (sense_valid &&
-			    sshdr.sense_key == UNIT_ATTENTION &&
-			    sshdr.asc == 0x29 && sshdr.ascq == 0x00)
-				/* Device reset might occur several times,
-				 * give it one more chance */
-				if (--reset_retries > 0)
-					continue;
-		}
-		retries--;
+	if (media_not_present(sdkp, &sshdr))
+		return -ENODEV;
 
-	} while (the_result && retries);
+	if (the_result > 0) {
+		sense_valid = scsi_sense_valid(&sshdr);
+		if (sense_valid && sshdr.sense_key == ILLEGAL_REQUEST &&
+		    (sshdr.asc == 0x20 || sshdr.asc == 0x24) &&
+		     sshdr.ascq == 0x00)
+			/*
+			 * Invalid Command Operation Code or Invalid Field in
+			 * CDB, just retry silently with RC10
+			 */
+			return -EINVAL;
+	}
 
 	if (the_result) {
 		sd_print_result(sdkp, "Read Capacity(16) failed", the_result);
-- 
2.25.1

