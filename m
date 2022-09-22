Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D559DC6FA82
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Sep 2022 10:08:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbiIVKIu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Sep 2022 06:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231335AbiIVKIH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2022 06:08:07 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06853D58AC
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2022 03:07:49 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28MA3qlH017925;
        Thu, 22 Sep 2022 10:07:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=Rl+JJ8mXCi0GCwTF8CGY5ESQ7fy+WClZo6A+7tjXwi8=;
 b=gCCgz2EfENDjeUJtme/r3EPaD6aDTUvr0dYXg6O5wq/CaVc990FqJ3zNFONmRHQe9YLY
 330ADP9R+J38mQKHl8xiLWLKGhyumCuh+0qRClKloym/crkpzIj8i7dTXHK6gW9nDfsq
 dNi2Np5fUUOCf3YnX3h1loImnkGNEI+IisfE4PtDPKLXZyWkqnqxkbH/aQRmyKSap9X3
 O/C/UMV8wBuTPHnBsKXuYZylBT1d/0ahHDpOwV0VOD2w+uWDOS9fO8W5qL3TgGlEDPwT
 B5fdhNhRB+ByuRxKJ4TGSOfsJ1SXzCuDBSp76UdVfZJG3FFgtmaDLvIVbDAqBi34urgZ Hg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn69kw1st-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 10:07:42 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M8lhls035354;
        Thu, 22 Sep 2022 10:07:41 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3d4e078-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 10:07:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CYCGePmfnhD56oimu5OrEmXtuicJG9rCQ+Xrx8Ss/E0XwTxGosBkXwYQiCf2bI+Yx/7ln76a1IJW6tSypTzZRFna6MDghKwG5etRzHbIcymeQq0k5krcZBcq8MnFvYgteF85MoXYjDTBddvM8LmhxjqQe3YDesnypz8iC/bIS+ZEu011KB7aAh2DvmD++Gf37mcMRpWZkdhOlrRjM3ilozvAaW8oGbCN4xafVVbt5xuwPmidLJUAabLNykq5QAbavTXat3iANTkkqXbVMcwLMxY/cOMi2cQ6rBH4MmecMNz2gM56kE4eYWS6nQ4hIC0scBy4/W1p+yvLIqwb0Mcq7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rl+JJ8mXCi0GCwTF8CGY5ESQ7fy+WClZo6A+7tjXwi8=;
 b=nZcVyB/gvS/3/2K3Qu9A3nOrZ2+zrDzFqebpNaceIy9o7aL8MHA0KpcBUKuTOz+MY8lWh3o8XGhJWlrgMSYv51h3FCpDczkVYhF55iEZkvF1mQ87fu6M5KqQ5jQJ2t8MGm2k9+3MoXPbfLEPde0CO5WudXzj1i5bszJE+Jpk+QDXo8pY+jnbajvSdvm+rZDxjLjQa03zS8ahm/oApSGHeHQNEI1+EnlAcxUmIg4QE0IFeU43tvbIIoFn73FPgZjRJOkqY+aDQtb0UaSkb3SQFftkqdzuAOmSJdnzn2PnJ0hULeXZAvG1lUULyIwPEMujIXHA+wOWfANevbxr4xHIBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rl+JJ8mXCi0GCwTF8CGY5ESQ7fy+WClZo6A+7tjXwi8=;
 b=aAfquA7KbLwqPyNac25iVFBGX4zxOMzJ3ibE3sOuDYk7VPzXD5IH1JewVPq7WwuCAmH7JaEH8xrlUzxM4lHdKKW51x6f8lhuJd23JKxhBIkIN3hyKraH6n8bbnDFXC+LbTDGXfLAHWqtQ77IF7ibM8pi6bQrBPmDKEzWmJewAuw=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 IA1PR10MB6243.namprd10.prod.outlook.com (2603:10b6:208:3a1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.18; Thu, 22 Sep
 2022 10:07:40 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1%9]) with mapi id 15.20.5654.019; Thu, 22 Sep 2022
 10:07:40 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH RFC 21/22] scsi: ses: Have scsi-ml retry ses_send_diag errors
Date:   Thu, 22 Sep 2022 05:07:03 -0500
Message-Id: <20220922100704.753666-22-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220922100704.753666-1-michael.christie@oracle.com>
References: <20220922100704.753666-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0213.namprd03.prod.outlook.com
 (2603:10b6:610:e7::8) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|IA1PR10MB6243:EE_
X-MS-Office365-Filtering-Correlation-Id: 0751fbe6-6ab5-40fe-8a42-08da9c82486f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wqqjgr3jTDNguh/x5E30uOg+KLpJab2mKEKt75czjP2S8Cf4Zx4L0a1An76vyCH4a8T5UpFty9YJL2Nog787sFjkvg1P1pZOxDOfdMzzTXFKLxbV7xWOwLfSqZLsaz7xa5OO461zNciHbTyGx5uGdNYLoCMYOWlwAQaE6dQtDEuCKUSwa/eMb+gfVyoype0P4eqQkOuD5fK//ei77eiW6sUyjUrjqo5TdU4rByXH2HPfLCLO1zHplYjLGRxXol7bjfeq4oXWNw9BmPBdTtWakrdTmxv1Qgn7tiznj1xauTVMQ8H+Ilcek0qpZXRZ7pHULX6DYXXO5JPCO2SI3oE5j1eLOTozTx8VDFpUU0G1PW+EwVPkn8rgJ+0ls1UBgCBuO7GCjsaMPql5Mb6YeK6/gKhtbYtwfq+levCzRYvRBaFXYimAG4xwspxNtgt64MJNGW4KWD3511Ty9cVhAyUXGBhnQlWI/U76VUns89+gNxRtQVv+Bd4JICfbxKXYahAwjtV2WSdNdIQ1O5U/QMKUb6j8FToLO7UOeOIsqEPTkWqYRyWV5Iq9JOLvtJ+0EXVvShWbAhHHGmmNmS5pcHUpvJKvrUmh17NbXLhjYwiWs3ojxqAM+evzIhDp4fci1Cna4VrJEKxsTuDRkqOdgUKyhZ/qVVsieI1j+g9mv9lkUoJZHDh/Kt0xLSjd7doVW2D8eyJ3CiGsOLsUzTolRuyP8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(366004)(39860400002)(136003)(376002)(451199015)(107886003)(66476007)(38100700002)(66946007)(4326008)(41300700001)(6666004)(316002)(8676002)(66556008)(186003)(1076003)(83380400001)(8936002)(2616005)(6506007)(36756003)(6512007)(26005)(86362001)(5660300002)(2906002)(6486002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?c7bER7iynfGsbSxQiAIn+kOi598Ya5eDBdr8i+eHxm8V/Pgleg6Fw4daIxZC?=
 =?us-ascii?Q?9g0CcYs0tsyvCs2o4k9Adj5YuOEepR1bJBVUaV3RUZ1mkLFAIcJkFMOb91aD?=
 =?us-ascii?Q?mAysbMip9EwGZDP6I3ChVstt8CZUzb378KPfJo+jquCBbsUc/x4MXzwQwBsh?=
 =?us-ascii?Q?Lgtc6yuQYpQyUc1E7kWt+UMOsNFVIYSKDfh2YYe+m+AW4uGwBUZJyAJBG+uT?=
 =?us-ascii?Q?F5Q9n0h7W108te9XApjheIrcjMiQWVBBBi+LsrTJIAZyP51hrIjI57CtGp/b?=
 =?us-ascii?Q?KuDlPOL7xWWQ9pRlY9MzfFkcLHeXRGg1wg2XOUJDYodgc4aBau0HxrK1cXIl?=
 =?us-ascii?Q?8wDU5LLy0G8iwBA+A3uiEYqpXl5nkwdYS4TMQVAuOAH2XyOhgnhirFbdo2Wr?=
 =?us-ascii?Q?XOaRNhbc89yqkd8CNCDuN+3u/wln/c5CxZMOhax/TUHBQgIviBVfyLUgk4x7?=
 =?us-ascii?Q?3YG352JO7tlz4SNJU0wS6EXcvrSHfo361bzHryEp6fy9ItEGimbk62+5syKE?=
 =?us-ascii?Q?9rOwOEBSGcBcS7Dc9qs0XAM6/dDL+/ownOg/hbX/qRNr25diuLMgjyyy12m6?=
 =?us-ascii?Q?aROqqu2ig/aa3SdBTffctLI7wLNj7d5m3YPYiJ26qzxZWzANidw4QtgavY2K?=
 =?us-ascii?Q?Ck3xbhkMZjt52c0J/spYgNriThbH9dcsU4eTLb9Bum+0c0QpE4zWffaMrc6z?=
 =?us-ascii?Q?lwINPlKRKnnL19cu1T27cxYPq03QoOwjzwioYJDcq9EfyX68Ug6ZT7pgcON5?=
 =?us-ascii?Q?KItwQuGh80+Zf2Gr81SSPv7N6Q/DcmjJqsiLswntCzkzYyTpYMngeFLFXMop?=
 =?us-ascii?Q?kHnaINhi4w8lZGHtPyKL68c7XiazdpEnm4b2EoLkVvn1Z52PZp18+SojCmrk?=
 =?us-ascii?Q?2r9MuZDsjLEaM2v0Muo+uF9Oi3qeSeXrPPV/8eRJqLs8nDz+UvhL41WQF4IJ?=
 =?us-ascii?Q?42D3xRQFRLxqI0m/DSGsoGzABKg8uJ73HLaOhZqXi6CX2NxPmsCMY0mZj1jT?=
 =?us-ascii?Q?Zscr1eDWAMGEDn7kckxAKzErjwVM1VAOGL9QTLkPrnhMcNb8XTpM6kHoIMEP?=
 =?us-ascii?Q?JNUy1O7/DTXuzokYwa4FS2jXtf4nsCdMuoe7V6uhewqf9ILHenJuQ8XYjx3I?=
 =?us-ascii?Q?KPx8BDH4p5FCm1IYWuUnHoVKrl8qwkhAD+gA5BDB67F/dIIRpD3TSzno/rXI?=
 =?us-ascii?Q?TQs12gVChi9QHNFlPvykeXqy8emLVqOhSPe9YzQEjPFcGJFBvjZXoh4Z3Q/s?=
 =?us-ascii?Q?JfsEiuS7/B9BmYTwyK6XWZQhnLebTLtndei3atplRO2XC/v57DfRks87QD/h?=
 =?us-ascii?Q?XpShxPvEqacAdBPj7uy40ZbuE+hX+pQH5A6Tk31MEK3uo1KiRfxMtlHAvJ7E?=
 =?us-ascii?Q?WPc/30HtaEE75evMH/PheoqYdp0hUsGZw0fW7mfFd30dvhSxtx7lqsfdOrox?=
 =?us-ascii?Q?n+3PmI0OVzkhUWUgfNrNf3iUm338J1LxrGbXKFsorechU5R3N0Q80FFustO9?=
 =?us-ascii?Q?xngAc7tMPtZ/Kn6fiTsJHk+huhjKMs10LLAGhwoz9/TpqGXHbQnGpW8CbDGT?=
 =?us-ascii?Q?410IIb73+dbGkySwlXJAcnRRUw26ilOQ4PzZvBNc0tQXtyGeU7pqBNUyswkl?=
 =?us-ascii?Q?Hw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0751fbe6-6ab5-40fe-8a42-08da9c82486f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 10:07:40.2547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8HjlJSToPDscqX1Shtw5zHeG2ooeBgeNoQ7xPDxyA8pKUCjFH6jkEzO+K9IVWd+7I6irmo0Wr6DtRON9I9/XDAWaG6avUBuxsFK3LSNlOoA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6243
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_06,2022-09-22_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 bulkscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209220067
X-Proofpoint-ORIG-GUID: CZIon6qvbYLygLViIXlK6mSNVhrP-bLq
X-Proofpoint-GUID: CZIon6qvbYLygLViIXlK6mSNVhrP-bLq
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has ses_send_diag have scsi-ml retry errors instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/ses.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index d5de65dc034b..6bcc31104486 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -140,15 +140,26 @@ static int ses_send_diag(struct scsi_device *sdev, int page_code,
 		0
 	};
 	struct scsi_sense_hdr sshdr;
-	unsigned int retries = SES_RETRIES;
-
-	do {
-		result = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, buf, bufflen,
-					  &sshdr, SES_TIMEOUT, 1, NULL, NULL);
-	} while (result > 0 && --retries && scsi_sense_valid(&sshdr) &&
-		 (sshdr.sense_key == NOT_READY ||
-		  (sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
+	struct scsi_failure failures[] = {
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
+		{},
+	};
 
+	result = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, buf, bufflen,
+				  &sshdr, SES_TIMEOUT, 1, NULL, failures);
 	if (result)
 		sdev_printk(KERN_ERR, sdev, "SEND DIAGNOSTIC result: %8x\n",
 			    result);
-- 
2.25.1

