Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DCA6EB64DC
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Jul 2023 21:46:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231550AbjGKVqs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Jul 2023 17:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231488AbjGKVqp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2023 17:46:45 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5C91731
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2023 14:46:42 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BIDIgJ015176;
        Tue, 11 Jul 2023 21:46:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=9PSKnlPtkOKH3NW94cepcvcYF4BkegtoT1TjWo7QSmU=;
 b=C997ESqpo3K3TMXsSJWE3Gd4rIfNkMlM1W3kM7n+RT+PIHGlBJ00dlEW1Fscs9HJihRm
 HP44+H2zemnBgOAg1cNzuzw0H7RQ+Be0psBOHeqHPmG17QsMdh2+24JuGFcsWcVsVL92
 sJ5ceqK7YW/0/D0s8xXLr0D1pD08hvw3BIIyylUeK3xYGHZr9IGuWrYk1uv+lMN05FbC
 YgwL1PDpxoc2Edcj/k1jgDdzAPIjabhow/8C1+OY4gFcDmjTLmxMOkcvKLf3IQOOur0M
 AWeLLvIzDqXL++ehb/yEyO24BLaxJXE2izN70DKiW6lH6nkTXQMxFwZOJF+e/Bf3UabG 3Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rr5h14kp7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:46:33 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36BJtCRn008317;
        Tue, 11 Jul 2023 21:46:31 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx8bsgs3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:46:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gMhnbpltLbUGDwNp0NX3THav7opkJjBc01+jf0hlT8fjJZ+wGl2UY93/rtG7L4JSSy6XQLMaWgVYd+PYPhWbJMrRS9Crv8r42JFyZSFxGNbm8uoU4YwvsWiq7b7zLNUlIZy/66AFvGfq3wZWmO9xSmHA2VidtoJGoh3WZrFqPFMdVR27O84Fz9tCSmfAZsrbXSCM/Q/JW4psuUX15PXhE1fLkhIQBhyrNhn/+wmniXs3doC4Twfe7/XZcZl7htQMUsTECf9AlMvBpzu/Ycur1ldjhAy8z2+0Mt5AvckGtGAIH561ANoUXyldrTUH9YNWtuGslqT3bT/B21M+/d/7hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9PSKnlPtkOKH3NW94cepcvcYF4BkegtoT1TjWo7QSmU=;
 b=Tw0448czgjDG2Q2Ja3qJMgmyma4jeGMRzlDGfzelINn10IbI1khfXBn5sjPjrHGdfnf2GNP8MVxyybVj65yp1vFqT3pZQkez2cBFb2iuEYZuPsczvprob71QRxHSLs7RsrDUmgWX5DefkR3PhbnPcjwbgg9uNp54BrMKWs28LFeFcmUuQdwZ7AfYuVtazLoiWcTSXukZtxZNaUQnGn8eI/rW00+u01fNsICIWIgKWQb/tm0XBm58dH36iR9BLEIjqbgLdROYSXQbdUO+kHZRHSgWGOFU830Ey/jZ7Tc6qb8utEffqPkY/KxA8fBurX6XZ5OR/zl0DWXmcFL2+nrwlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9PSKnlPtkOKH3NW94cepcvcYF4BkegtoT1TjWo7QSmU=;
 b=iztOiYjgxUrXiRPO1lFIHsl91aagoWgiUAUp7raI/rkjiweUYCb4bDV/Qf31qc3fz03oQz3ob/HGUT9stKLj+ojxgRwv2SXs75mSB3UKr2rufpzXVh+1xklMeA+TC00w5vEJUCqlwPK/UYDWdfc0De038KH3gIXQj+PM2Arbt2U=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CO1PR10MB4450.namprd10.prod.outlook.com (2603:10b6:303:93::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.20; Tue, 11 Jul
 2023 21:46:30 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6565.028; Tue, 11 Jul 2023
 21:46:29 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v9 02/33] scsi: Allow passthrough to override what errors to retry
Date:   Tue, 11 Jul 2023 16:45:49 -0500
Message-Id: <20230711214620.87232-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230711214620.87232-1-michael.christie@oracle.com>
References: <20230711214620.87232-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0058.namprd02.prod.outlook.com
 (2603:10b6:5:177::35) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CO1PR10MB4450:EE_
X-MS-Office365-Filtering-Correlation-Id: 4dda0f8b-cd94-454e-60a8-08db825847a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W5AyHjcrShKQMHfepPJ0xQH6hr3KnU4dDej8FT128YscGEsNuKKl04aA9iTtJB/vhB8t3JpErl4glQaWzwMBFU1ThjfyAufWEbc0xQGRUeHhvvZyg5rE4eR/tPtFOhC6cV+lrhpdOKwYFDYpbUvtbqTqLHoXWP9YmjLVUCiOZaux7+Zqx1n6akzaApAeJzco6+D8tG1sNLmXNKvxhKR6mrslIjebL23CDGj5b+JzCQhju1aibL+gz6sQd0FUr19EjGV4SbUsHfVZ8bSfyr8P3z2wyH56rE5XmlTeBk816q34I6DMSJCuWJCbObHNyoZ43T5LqjyB/EShaYlWtRwjy0rLmxVq6APo6QoOOy0m5MJeqrIoG0vCsZd2GJCaC9QSkdDs4QRXzxqYFgWUAiszv2kMxwZULZPaLY6TldYsTn5lrSqwmNzbxFJXUuDSjKh8u0rv+Al3m3i89nFDpFH49nVMI5/gwy7TQu9D7sVrDiI0LfM4PcDj6Ah6KbnQyaECD9tDZQkc0do5y2Zuae6xCOe8dRCgsAwbes7QAh36EjnfHt92Y6BpivU9ioXXKQiS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(346002)(396003)(136003)(39860400002)(451199021)(83380400001)(2616005)(38100700002)(36756003)(86362001)(478600001)(186003)(26005)(1076003)(6512007)(6486002)(6666004)(5660300002)(8936002)(66946007)(66556008)(66476007)(8676002)(2906002)(41300700001)(4326008)(316002)(107886003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XRU1MPghZNuIAMqCk5Ujp9ix5fRiEZckwHKm/sr1599HxUv3JlBF92WsqRGd?=
 =?us-ascii?Q?h5JFMbHC/5CC0+jY54fdnJ0DDXYQRHRzgg278LVnXiF6v30xqe6971qpjXp0?=
 =?us-ascii?Q?j6webOquuEY+q0k2YmjKGFfo6s4p5SrF6iefDiEmnfmQsSBtxA3MKTWNnWk7?=
 =?us-ascii?Q?cZlK4CMnp5tnMs7ZfkbMaa+K6NDz7+WmPMnP/SFPLJSSktHgwGXOF7INxckI?=
 =?us-ascii?Q?CSsnOxtBUiqbkIfqZ4N1camHVfYvlVWW4DubQZ9jqXyADtKB6qLL4xo8maAo?=
 =?us-ascii?Q?pYqaRB6aOUYxOchJxD4NG0FJxu8+Ly1YMBbyMt+rZ5iAhrEcR+vF8CPHPTUn?=
 =?us-ascii?Q?PcqllilcDvr9RHrFoTTolwJKBhTb2tUPGth8Infv8N0inlL2yXfjWliksJ59?=
 =?us-ascii?Q?8qZfqlDxhgpcqouH7zSi9mrLUCKAYDk5Z1v7t5o3+k+oANbWLr3E8lJzhq/n?=
 =?us-ascii?Q?5Z3un+MYT9tHzs+/u983nIWp1+92UFmSEtEMogEEGuek0YuY6pg1nypBV/vI?=
 =?us-ascii?Q?n045COBMEkftMnx0URhgTQRMq+TviSotQmVjVPTn4QdRKv7D5CYgfBSnZToR?=
 =?us-ascii?Q?jp1hpB+pDT4DeYBwY3yOYC8oW4IoR9Xu60NBOtMayywIqatBqHUYBfvTk+/5?=
 =?us-ascii?Q?WuBEbcR5vVGHpQY0nkvXwHIECE0EExwifuzRzq3F9OqMhHkP8n4xhrz+YdZe?=
 =?us-ascii?Q?UiQ1flGQDZZ6YTP710HWVi1CrZvopCXjH9c6EX5M91eD3ttLJyFX1Z+9NQ9u?=
 =?us-ascii?Q?pux2xAVdnaA2PDdax1qUVbTGQM31e3UiE+jFcM5c7842Vr0rJkNmOJq/AvkI?=
 =?us-ascii?Q?C/HHwk8HOV5ZXBpet5HsCJO+CKtjMXfZsWd3vV+Ossc0dfPqwuPYTZ6wN9Cr?=
 =?us-ascii?Q?Y8Mtt0c3AYAwYcviDAvqtpJaM4rJfreh6n1i0iJ4nlaG0t20834OrYzR1R4L?=
 =?us-ascii?Q?Po8SWuM4AVgeHss0IRFkr/8qLsYnAXLClB6Zm0c2rEZfaDoy+9izCFBz2eWb?=
 =?us-ascii?Q?THfueAHidUtItTfoz+ZdkryHia7m7W+vZs/Gydt7lFCb191kG7yuPSskg5wU?=
 =?us-ascii?Q?ba3Vmvo2uZaNaWEksC6P9Z6H5PVGc2VFAsZOlRKGDZfuPTw/g3pdfL9rErZ8?=
 =?us-ascii?Q?W9/qL+aVuG4DPny+SFyPK4raQJufjBB7pYNJJ+FP/hbconbP+OgHs0ZjRSBo?=
 =?us-ascii?Q?Qq264Ht9yMDmopqW0NaRbvLnb1R4Kk+GJB7uXFwu2guUJ45zwrIjNkMSlQgy?=
 =?us-ascii?Q?VV8MPYoUMNRcNsEBuhI4phTkBa0Syt3YlesEH/nl/99INHMMUPK+9WaqXotm?=
 =?us-ascii?Q?jcPbQDAUpUQSc51fBWT0mOdKXp4bVDEqSBai+T0XF+svfAZ6GH1lmOKSs2os?=
 =?us-ascii?Q?AZTq4Vu949gDX58YERuhI+l6P+AQkx3zOvVRkkVj/YxzlgwxA0J++yMpx4Te?=
 =?us-ascii?Q?5/S/bB/W2jH3jUVBPwWnFa5312MYv5xBFSE0N1UdrPs2yM7ZlgdwdfTxw33Z?=
 =?us-ascii?Q?mck7kFkqNhB4CYaDR1vDh2R3H3beH7xJ3AIbV/U0aM/xVoDEbVA2s8GmrSsl?=
 =?us-ascii?Q?C1s+LDSZZ9vMKIktfOX3To5xR4M89Fsn0xvpXs9NpHveZVhrlaBnSPjgRRDl?=
 =?us-ascii?Q?Pg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: d+poRB2x60cKV2J6DaXtOwlfnwOxUKCHttgRtpra6kQcbjrrVYxLnxjl41Qh1B/j7/Lvvp4AJN0oCskTYHVGC91LrZOdYEdE8NRuDnOMzD/VXJwdVBnpE6JkKdbPRqxWtkdMfq8vRlE7kqPATGQrlXd9fcuYD8dzsj5or++ZSrhyholQvk1fVh7SQSgiIqbTiRHihE2MJ8Y/axNCF5TeR0Qkn7f66Uw6J5ZOQM+nzp9OHtOLAHNM+dCrrSJnnSAT/IP99/zGTElANj5lwoOdPtYUhS4zFbODzzwjzA1PhjA75p8WV9HhRsB5axOdo4RPBc6oXc3XY41Wcs1VQltSsfyFkrCA7ypdIN0EkKpUc3EbyMayrOVK9zfB6ikJqbRe6c3m1W2f2/FkymzibGe6IJCWNf1DWkBr+s2uKyC3HZlwn2FNJbKfHbNSZXfJSLEioGpE3DfPxxNNkm1pUjqS3p0v5i1IfqTBPWdeHz7XtWnpcw1W+tU7GItptpB28TvxqfJYfqZIiko42/AOXIDspPTrQna+H3Q+O7ozEY8sc/FuQEAw4esvpALI6z2WUygegs1KxLx+0EyddUUpuMUmHQRMUJ3CzZRVtUiOq0eRMxF/c6y50qmkt/Y+WSzcmlMt2zakmkw7RXXIQZhivin+m5H6SoDYXEQFwkV62LAgrrsz71qc1gBUY03/8aVgdAql3VN/wH9WAkfAGciehKW3Z8EOHiWqyat+0+efU4opg8DZ3J7huRmOEgJlQr0vfon0jcfKFTPO+bmfs7E8gDhyMw+d0XuzXxgtMhUwR65z+JXPRwsNnQt1p9KifWtY43L7UcmFvubhw5aV33HrUWSsB5etTnQaLquNc9uD1j8eyMzUxQCZ1hroXJQg51piEW9w
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dda0f8b-cd94-454e-60a8-08db825847a9
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2023 21:46:29.8194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EI7SvEsLbYuBDpaCRotI7jXR+BHbxooDp8MTDleKvgSjhZwVzlHsPO6B/Qvt7b0bXcTaMNNisZDoHojtNqMojbnLoP8DEXwPGQIE0tD54so=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4450
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_12,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 suspectscore=0 mlxscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2307110198
X-Proofpoint-ORIG-GUID: I2vWxNPnPwGdoJyLC3NiZ0qPES0QZiqt
X-Proofpoint-GUID: I2vWxNPnPwGdoJyLC3NiZ0qPES0QZiqt
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_error.c | 80 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_lib.c   | 10 +++++
 include/scsi/scsi_cmnd.h  | 20 ++++++++++
 3 files changed, 110 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 7c3eccbdd39f..d2fb28212880 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1872,6 +1872,80 @@ bool scsi_noretry_cmd(struct scsi_cmnd *scmd)
 	return false;
 }
 
+/**
+ * scsi_check_passthrough - Determine if passthrough scsi_cmnd needs a retry.
+ * @scmd: scsi_cmnd to check.
+ *
+ * Return value:
+ *	SCSI_RETURN_NOT_HANDLED - if the caller should examine the command
+ *	status because the passthrough user wanted the default error processing.
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
+	if (!scmd->failures)
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
+		status = status_byte(scmd->result);
+		if (!status)
+			continue;
+
+		if (failure->result == SCMD_FAILURE_STAT_ANY &&
+		    !scsi_status_is_good(scmd->result))
+			goto maybe_retry;
+
+		if (status != status_byte(failure->result))
+			continue;
+
+		if (status_byte(failure->result) != SAM_STAT_CHECK_CONDITION ||
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
@@ -1900,6 +1974,12 @@ enum scsi_disposition scsi_decide_disposition(struct scsi_cmnd *scmd)
 		return SUCCESS;
 	}
 
+	if (scmd->result && blk_rq_is_passthrough(scsi_cmd_to_rq(scmd))) {
+		rtn = scsi_check_passthrough(scmd);
+		if (rtn != SCSI_RETURN_NOT_HANDLED)
+			return rtn;
+	}
+
 	/*
 	 * first check the host byte, to see if there is anything in there
 	 * that would indicate what we need to do.
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d32f1014465f..53cb649b2f28 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -184,6 +184,15 @@ void scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
 	__scsi_queue_insert(cmd, reason, true);
 }
 
+void scsi_reset_failures(struct scsi_failure *failures)
+{
+	struct scsi_failure *failure;
+
+	for (failure = failures; failure->result; failure++)
+		failure->retries = 0;
+}
+EXPORT_SYMBOL_GPL(scsi_reset_failures);
+
 /**
  * scsi_execute_cmd - insert request and wait for the result
  * @sdev:	scsi_device
@@ -1129,6 +1138,7 @@ static void scsi_initialize_rq(struct request *rq)
 	init_rcu_head(&cmd->rcu);
 	cmd->jiffies_at_alloc = jiffies;
 	cmd->retries = 0;
+	cmd->failures = NULL;
 }
 
 struct request *scsi_alloc_request(struct request_queue *q, blk_opf_t opf,
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 526def14e7fb..9a3908614dc9 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -71,6 +71,23 @@ enum scsi_cmnd_submitter {
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
@@ -91,6 +108,8 @@ struct scsi_cmnd {
 
 	int retries;
 	int allowed;
+	/* optional array of failures that passthrough users want retried */
+	struct scsi_failure *failures;
 
 	unsigned char prot_op;
 	unsigned char prot_type;
@@ -394,5 +413,6 @@ extern void scsi_build_sense(struct scsi_cmnd *scmd, int desc,
 
 struct request *scsi_alloc_request(struct request_queue *q, blk_opf_t opf,
 				   blk_mq_req_flags_t flags);
+void scsi_reset_failures(struct scsi_failure *failures);
 
 #endif /* _SCSI_SCSI_CMND_H */
-- 
2.34.1

