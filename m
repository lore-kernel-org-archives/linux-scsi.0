Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0610C4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Nov 2022 23:19:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiKDXT4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Nov 2022 19:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiKDXTt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2022 19:19:49 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7922BBCA9
        for <linux-scsi@vger.kernel.org>; Fri,  4 Nov 2022 16:19:48 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4Kj7cj012094;
        Fri, 4 Nov 2022 23:19:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=BCWIeFWexGM+EZzIcj0uH+GNpoB5fh6FpGLnaaU+zYc=;
 b=wpqqQAEZKduKDEBhO+6OhjovAqWm9AHC52W35+0xzyFQi3KGHwRmvtDV5Y3rR26scpcJ
 61D/gtALLYubY9cSJ2PQQVz84dQtS/j/CJ/iGcXXKg4wa1CVTthT2ltTMsN4kP4MCxeH
 Skwj9HckHmz261Xl2w+TlP60roUfgVnblkHgVLilSm3V7MerBFnHH0nbn3uh9Zg291M4
 INLEH+kk7IRPW/lfHYHf+mTYfp8p83OU6elG/STdP/r+uFJPNYcI4oGw5f0rjnqnxeu5
 bmDz7NHo8SFw7CFdZL55tVmIvbdByefTltK92vzs0awjOdgadfRrv1WCJ8O7WxZs3gvT 7g== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgvqtshtv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:19:37 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4Jx32U029754;
        Fri, 4 Nov 2022 23:19:36 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2173.outbound.protection.outlook.com [104.47.73.173])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kmpr9a7s0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:19:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iQGCY26zLx9zzDTsO4NTrZcupg1DD2dPNRqelZdOfECDPr1+57Abv4cGd21tFeoin9rn/0YRVr5TV4rNRNCP9jNNGuzpFLD4Q0s/5UKZy7/tVypfVAhM3SM9I2F9voSuyTJ9yE/fhtnpqi3/WiRUa5EgGapo50g8wflJi6to4wCw2KOBWfI+/VXEhd4tlOtEUYU/wnWJLWUHiLqeMlAOQ0oAPJOW2AjByPxMHuUAlI4TS1Fc+dOgzJcOuRN62vyEG47WCEtbQD9jg6I5tT3CraPNSPGc4M3FAdweR3To7D60cq3+gJ9OHh4xnHCh/BGwTL1s5aNe0NU7bQq6+XT7EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BCWIeFWexGM+EZzIcj0uH+GNpoB5fh6FpGLnaaU+zYc=;
 b=JmHdJaEUzBiFziBGx8GUbtwJ0VzI8eNiLFPn7EbW3dxGx/06VoINhe6Q+5RTXzopVWZtP7fmpyr2lCf0kLRYzUN+QPR36yU0JM+3y70SZMzIbW2FZGZjcgxom2Qrk0kicwfL76L0kfagt1H4mmzxSwJToyDEx/gF1MNSndl490v3o1y2yZRsVcYMnTNx/4I8t/OEQic/j7W3IkrSBnsHxvrL4MBvqvTQoFF0cXZPFAiYKvW3GcMYCJ+o8W8agJnqhXhCiNfgVmm1iEnSkXen74gdYU0WHPTbBjhkHUk7QIW+d6eZIe2T0m3sBCrNVkifRlQJLvUFkR2afiU9dtZUlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BCWIeFWexGM+EZzIcj0uH+GNpoB5fh6FpGLnaaU+zYc=;
 b=uXps/CMIFA6+HvL5OejH4nUa3bPpkBrdUYkCS41v8pQP1plJITaqFYG0OByqDdHBZkI5+jLk/xDxn9b69iFtYnetOwHQuq1mD2dU/20dXKoab/Nv+nIh3KxD+h82HL1VxHRez3yeb3GDOt5ID4JA2KVZgfVZGJgByBQqwlogB9M=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB4743.namprd10.prod.outlook.com (2603:10b6:510:3e::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.22; Fri, 4 Nov 2022 23:19:33 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 23:19:33 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v6 02/35] scsi: Allow passthrough to override what errors to retry
Date:   Fri,  4 Nov 2022 18:18:54 -0500
Message-Id: <20221104231927.9613-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221104231927.9613-1-michael.christie@oracle.com>
References: <20221104231927.9613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0250.namprd03.prod.outlook.com
 (2603:10b6:610:e5::15) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB4743:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d806aa9-848d-4b8f-3907-08dabebb0878
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ObDOUn4FDBa8n7x3VXJh9XGAk0+h8w4LOwEB7SsOpx+6LfrrvFydigw1k7EM8pYLF6dYFOEb9W3qS39dJ75jRDOVdAXu2tBAtK3xIEEhTSn00Eue4JD51jNuepzoBeJrf2oEOy+viRZT9erS9qj5fzi/RrHt9k2/k/IISAuUvZKwWbp28gbVf8w8Fum7q13KW1iq1ZHgs1l/MmFOQw5A7qjpwKblYQ5vmRKUNSSylkQ4tpD+u808seTH63sTo6FScw8ZoGPqtT+c07lf1EjIGbdzQ2ly03k3o0swrGrP7dfmPE0MAnQfsgKk46gQc+LyDS7duRurD4wjHaRIqSmDvX+WYPAvIiLchubBzQKE2YyelhxFuR30IFAjSNaTySJu5BhbcgU+ZbB4m89PmnPdqwWR5990r6EqD6qtlenwAe5sFv48kk9ZPKubmY7XM7dGYsU9mPOSlAAU3ZF4KXldQCgXJIST+vcpze+TDc6vbFTQbgVunE7UplrBZY2DRYC1L5H665I1IjfzLqTnlz/zvLJ0JCZoEx3NiY6ernTRn5BQ5yIDsGrxXMDqh8Y3VaWHfGsQKG9SlemAjSBBDBMk/UvsGFOGYQGN4YbVjsIHuZw0CZeEfZcgKkAxivWwB0zj1H1yWbzOu2ZQwL6D3AsYqbuqJNGFi45mTmZ5S4gNch7jUnzpK5n6pTWNhXm7tRB3DWY8HckKCuBFNVESjyMqRw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(396003)(346002)(366004)(39860400002)(451199015)(186003)(5660300002)(2616005)(1076003)(478600001)(6486002)(86362001)(316002)(6666004)(107886003)(38100700002)(36756003)(66476007)(66556008)(26005)(66946007)(8676002)(6512007)(4326008)(8936002)(6506007)(2906002)(41300700001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dsUOQF/pH6UFBin7vOqEV8VdVuU39rKeIgFBOSCbwvLkSXptfuri86rNhqHC?=
 =?us-ascii?Q?pKIRUnTum7uQLYK+3qxB16F2xFdvbo6Thj2KvpObv5XG+pK+INvdbrvxABSb?=
 =?us-ascii?Q?W9mXcXeW7vc+a1nmD/sIq9VsIic/XE7G59qhKPAhnewJRRy51sp2LrXuClKJ?=
 =?us-ascii?Q?2KFrLre3MKLeSMnlVZ6Yb8SchKOX6+LgkmRypB1Q1D9wjkH2ruVqOeYVFQ5j?=
 =?us-ascii?Q?dPOYpVWNBmKtjwHIZirV+YwN7sd/Q2rD8lFFLz2Hev1/4ostyi+7+br+9L7R?=
 =?us-ascii?Q?3SL52z6k24wKMUlwdQTR4Lf2e32ec0y1TCSahTZP22ZnrwM68QcR+NspV35V?=
 =?us-ascii?Q?UMOW2NcW+EJ3eQnLirDi+i2wk8iD77qa9B9RFOEKGpG4auoKt9DUSGDrV99+?=
 =?us-ascii?Q?6tgEUoFHCAHyYDJ4GY/73CuZpZbWh/M2R6Rpf72s39QTToOu8UUsRw+L7t5A?=
 =?us-ascii?Q?3wsb+PjR2g5YjPFW4nzQ/aIJ+ILDCcz3WlM5YBq1+ePuFEkCXONlnAr16Lba?=
 =?us-ascii?Q?VZ9migMSMtwEaEwFEerk9TwXnmpiXVPbXSLt14RUZN96sDeIMtRoV4uP2Rp/?=
 =?us-ascii?Q?ybF7eYQbTBYwB747lr84l7JnMXb+CKXrwxPO5TJbqSkiM5omP4Q9YugL/r7d?=
 =?us-ascii?Q?8p++fO63ZOJPqWmvQf6QNz2++Koq0vb8ERD1ShG5sS3b5RnpbfA+ZMVbP1HE?=
 =?us-ascii?Q?HEksdcOhw4ZHWqRDrWwED0XMq/njLik4IDB/e3B6EyR9fYXzvueUgyzT2tGe?=
 =?us-ascii?Q?nADA6pZQ03hbD5nn99GBXEAPM60ByglIVkdZYyui4Cwd8pGQxrhw1F0PUpBR?=
 =?us-ascii?Q?nESSnwN95mWz1tb4lCzA8vqleEbhXgllyjYm81sXeTCa3TeSaSS66mPS8PTr?=
 =?us-ascii?Q?PHVqdCj4ikuPqtc9UzyGOsDVcv0d4FIsaqBA5Tq+DASRimB5LYvaBmHOUE6z?=
 =?us-ascii?Q?ryeNb8r4vlBVGU1yXaVm3i9xWrwL0L5FF7ytADKkB7qiuQ9xVYuCfWurreF/?=
 =?us-ascii?Q?JZkntUB8YTg3qwnhBEQ1nq7fwLRFLmGk5MpAgRoNP6/ea28XcXY57aevGs1/?=
 =?us-ascii?Q?72W83lJRZKaV8U6DyYnLGdJlP6ekqs4X70y3jYxCWi9yCwRgTEpl5GOzsq+T?=
 =?us-ascii?Q?7x9BvQMNm0KAVpTaGdTFUZOl/78Sr1fMQYQQVFvPSK4aHSwY/zYV6N4e0xz9?=
 =?us-ascii?Q?dFcWpH6faZnRsbdIDbvaS8I+aRRnqVr6bwaGKwFyoKr2wMuD/7MzN97LZY1x?=
 =?us-ascii?Q?2jhfJAZPhpkL9HnJ53R4vFdxU1G98e3fYXFaJESdQFMOloTBLDG8Mwhc3LOY?=
 =?us-ascii?Q?I4/dI8P+IpJJlzZl2oL9t1vT4S5cnftj4Gi9FOpoiLa1dEDj0vWyrxDm/SxR?=
 =?us-ascii?Q?3wfmtNWL2G/eAvT/71ODiBGM7c4qdxbGARjurOpuc9MG1TfgK6jR+9PNM7uE?=
 =?us-ascii?Q?HwK7saO0BSvrnDdeqsvor5hJ+w4qTIGKBERXoQhJOHtwBRWoyhdl75nVInCw?=
 =?us-ascii?Q?nOV1CBdwIv4+B7sGXQCRIyfJkSAqsJIG7Q0ABIjqtaKtSOo/PBkvFFGepZJ0?=
 =?us-ascii?Q?MHH2+cEEXPniYYsEgBIEE4XUTv3ZC/vVQOhdQ20q8MP6Vrp/uOnVktmjRYNk?=
 =?us-ascii?Q?lg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d806aa9-848d-4b8f-3907-08dabebb0878
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 23:19:33.7854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5N0YNLVqtZ5lBfVDLWwT4Qyo/gwBbSTTXSugj+kRJewce2pRWEgh+dyXWmfKcaOaaluWru3dt4lKcGxxxHokI6jG/7Exz0NbsZZYXS1s3Eg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4743
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-04_12,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 adultscore=0 phishscore=0 spamscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211040143
X-Proofpoint-GUID: mb043vnkJaJrHRgKBY_rg2plmwJmconG
X-Proofpoint-ORIG-GUID: mb043vnkJaJrHRgKBY_rg2plmwJmconG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For passthrough, we don't retry any error we get a check condition for.
This results in a lot of callers driving their own retries for those types
of errors and retrying all errors, and there has been a request to retry
specific host byte errors.

This adds the core code to allow passthrough users to specify what errors
they want scsi-ml to retry for them. We can then convert users to drop
their sense parsing and retry handling.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_error.c | 82 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_lib.c   |  1 +
 include/scsi/scsi_cmnd.h  | 26 ++++++++++++-
 3 files changed, 108 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 994b7472fc56..77d7ad07645a 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1829,6 +1829,82 @@ bool scsi_noretry_cmd(struct scsi_cmnd *scmd)
 	return false;
 }
 
+/**
+ * scsi_check_passthrough - Determine if passthrough scsi_cmnd needs a retry.
+ * @scmd: scsi_cmnd to check.
+ *
+ * Return value:
+ *	SCSI_RETURN_NOT_HANDLED - if the caller should process the command
+ *	because there is no error or the passthrough user wanted the default
+ *	error processing.
+ *	SUCCESS, FAILED or NEEDS_RETRY - if this function has determined the
+ *	command should be completed, go through the error handler due to
+ *	missing sense or should be retried.
+ */
+static enum scsi_disposition scsi_check_passthrough(struct scsi_cmnd *scmd)
+{
+	struct scsi_failure *failure;
+	struct scsi_sense_hdr sshdr;
+	enum scsi_disposition ret;
+	enum sam_status status;
+
+	if (!scmd->result || !scmd->failures)
+		return SCSI_RETURN_NOT_HANDLED;
+
+	for (failure = scmd->failures; failure->result; failure++) {
+		if (failure->result == SCMD_FAILURE_RESULT_ANY)
+			goto maybe_retry;
+
+		if (host_byte(scmd->result) &&
+		    host_byte(scmd->result) == host_byte(failure->result))
+			goto maybe_retry;
+
+		status = get_status_byte(scmd);
+		if (!status)
+			continue;
+
+		if (failure->result == SCMD_FAILURE_STAT_ANY &&
+		    !scsi_status_is_good(scmd->result))
+			goto maybe_retry;
+
+		if (status != __get_status_byte(failure->result))
+			continue;
+
+		if (__get_status_byte(failure->result) !=
+		    SAM_STAT_CHECK_CONDITION ||
+		    failure->sense == SCMD_FAILURE_SENSE_ANY)
+			goto maybe_retry;
+
+		ret = scsi_start_sense_processing(scmd, &sshdr);
+		if (ret == NEEDS_RETRY)
+			goto maybe_retry;
+		else if (ret != SUCCESS)
+			return ret;
+
+		if (failure->sense != sshdr.sense_key)
+			continue;
+
+		if (failure->asc == SCMD_FAILURE_ASC_ANY)
+			goto maybe_retry;
+
+		if (failure->asc != sshdr.asc)
+			continue;
+
+		if (failure->ascq == SCMD_FAILURE_ASCQ_ANY ||
+		    failure->ascq == sshdr.ascq)
+			goto maybe_retry;
+	}
+
+	return SCSI_RETURN_NOT_HANDLED;
+
+maybe_retry:
+	if (failure->allowed == SCMD_FAILURE_NO_LIMIT ||
+	    ++failure->retries <= failure->allowed)
+		return NEEDS_RETRY;
+
+	return SUCCESS;
+}
+
 /**
  * scsi_decide_disposition - Disposition a cmd on return from LLD.
  * @scmd:	SCSI cmd to examine.
@@ -1857,6 +1933,12 @@ enum scsi_disposition scsi_decide_disposition(struct scsi_cmnd *scmd)
 		return SUCCESS;
 	}
 
+	if (blk_rq_is_passthrough(scsi_cmd_to_rq(scmd))) {
+		rtn = scsi_check_passthrough(scmd);
+		if (rtn != SCSI_RETURN_NOT_HANDLED)
+			return rtn;
+	}
+
 	/*
 	 * first check the host byte, to see if there is anything in there
 	 * that would indicate what we need to do.
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ec890865abae..fc1560981a03 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1128,6 +1128,7 @@ static void scsi_initialize_rq(struct request *rq)
 	init_rcu_head(&cmd->rcu);
 	cmd->jiffies_at_alloc = jiffies;
 	cmd->retries = 0;
+	cmd->failures = NULL;
 }
 
 struct request *scsi_alloc_request(struct request_queue *q, blk_opf_t opf,
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index c2cb5f69635c..016a371715b7 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -66,6 +66,23 @@ enum scsi_cmnd_submitter {
 	SUBMITTED_BY_SCSI_RESET_IOCTL = 2,
 } __packed;
 
+#define SCMD_FAILURE_RESULT_ANY	0x7fffffff
+#define SCMD_FAILURE_STAT_ANY	0xff
+#define SCMD_FAILURE_SENSE_ANY	0xff
+#define SCMD_FAILURE_ASC_ANY	0xff
+#define SCMD_FAILURE_ASCQ_ANY	0xff
+#define SCMD_FAILURE_NO_LIMIT	-1
+
+struct scsi_failure {
+	int result;
+	u8 sense;
+	u8 asc;
+	u8 ascq;
+
+	s8 allowed;
+	s8 retries;
+};
+
 struct scsi_cmnd {
 	struct scsi_device *device;
 	struct list_head eh_entry; /* entry for the host eh_abort_list/eh_cmd_q */
@@ -86,6 +103,8 @@ struct scsi_cmnd {
 
 	int retries;
 	int allowed;
+	/* optional array of failures that passthrough users want retried */
+	struct scsi_failure *failures;
 
 	unsigned char prot_op;
 	unsigned char prot_type;
@@ -331,9 +350,14 @@ static inline void set_status_byte(struct scsi_cmnd *cmd, char status)
 	cmd->result = (cmd->result & 0xffffff00) | status;
 }
 
+static inline u8 __get_status_byte(int result)
+{
+	return result & 0xff;
+}
+
 static inline u8 get_status_byte(struct scsi_cmnd *cmd)
 {
-	return cmd->result & 0xff;
+	return __get_status_byte(cmd->result);
 }
 
 static inline void set_host_byte(struct scsi_cmnd *cmd, char status)
-- 
2.25.1

