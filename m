Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3C5DC4332F
	for <linux-scsi@archiver.kernel.org>; Sun, 16 Oct 2022 20:01:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbiJPUB1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 16 Oct 2022 16:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbiJPUBL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Oct 2022 16:01:11 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 573C842E6D
        for <linux-scsi@vger.kernel.org>; Sun, 16 Oct 2022 13:00:45 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29GE3cfJ014633;
        Sun, 16 Oct 2022 20:00:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=3L0BSh9DZlPGYkS24sOL6LQL/LxLyRQwmlrvzHZtn9s=;
 b=GfVCqa5t8asZ57/UrC0nfB3ycwAAHjVqXWvQXKYKu7GEEyDVXjBWibpBY0cAoq2eurtN
 XEKmkDfpSv3tbxMs/agQ/xZchpPCo1+pyyfZ1CVwGWIPHcI9MODKrkckkIOjXFVTgHeG
 ICutEyBi4tal7IAOfYvlrqEKNbjXXiTMvvzCggb1EBH/IyS2IaVXQ8RLP9hAOIFOXolL
 Y/lrEqOvz0lUsUWPzd/lYjq9NkLm5lovSwS3mGohF8PBVmk1FHI52MSERENRVhAZevPD
 HaUFV7DavG2LHanrzY1Z4gEvROFkZ+4Kcv6ONg6mU1NzOHqnEisp0weLvl/7NgSRaJjM cw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k85mfs5r9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:00:37 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29GCG8ve007018;
        Sun, 16 Oct 2022 20:00:35 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2048.outbound.protection.outlook.com [104.47.56.48])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8htdvdnr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:00:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EOVE5lf/wWQLXUHrpUFUKQMftFBs+QNq/REOiyVsv6tlvQVgaMrGC/CvkUckcSyNa8lnOdAkjeDAF/RUe8LBw6/pnvuKPnXhvbdblgX5spoGckbcFoYx+cYglRAHMwW799yluDt2crTnPBBq+CkfyrNa/V6on1Z2jf57HdWNbnxmNPXKTot03f6Pm+7sanhBlLH+91Oj8bnA87e74J0RUpfjyDU0uarjj8tmLZhq7qPaJ3tUMjpGgWmS2rbW2Q1ZRpyNUFqwh4hJWqSOALWQjan7Y60FwviFiwTofUks3yjoavZkoTzMXiMAxduZDep7h0KsnH9c3VXFIHplCvzkyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3L0BSh9DZlPGYkS24sOL6LQL/LxLyRQwmlrvzHZtn9s=;
 b=mkPfTPQVeiGPhpCqRWNa+dw4TXJ4O7mhusMD+NypQMxOjVnpKWCok8hB+dALOnMs55S/yQ/xwe4AGsTzhXPLUyOCVbah3I3SpFrV8mNd88glootWM2T6eDLo8PIr7MVaZXdK3IAK6j+i7JwYnY6pdfJiYERFCKr5dU1byzs6Aqr1dmc+wP9DxFN8VcXh9s9yn3qZcf7xWYWWOoUSErzeEZJ11KX5my+WUAIzlwE98KCQJ/Cbn+F8qlhhmVccISJeAbQSZcT5EwPJuc6XVQB9hK/dsCrbcvR2z8ZNTH9+xyxu8Qn/FMKVSLUqhs2UtSOqBwYKc6iXiM9mzwkmRXhWYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3L0BSh9DZlPGYkS24sOL6LQL/LxLyRQwmlrvzHZtn9s=;
 b=m5U1OV9UyydhAKUQk/1m6P69ZnqsJssmkb9S8yo0JNpeo/A0AzBNe2KCI1lkwAzYNq6Y9G6WZyjm9+1mvpZzx3+iWn/dVdhttkXxV0VI0TCOxIx6TgrNygmkPB6i0kpH8LjITugR6DE+A+1GgfNrvEgLqYhNBfZW5L1nnyPghlI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB6727.namprd10.prod.outlook.com (2603:10b6:8:13a::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.29; Sun, 16 Oct 2022 20:00:34 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5723.033; Sun, 16 Oct 2022
 20:00:34 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 23/36] scsi: Have scsi-ml retry sd_spinup_disk errors
Date:   Sun, 16 Oct 2022 14:59:33 -0500
Message-Id: <20221016195946.7613-24-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221016195946.7613-1-michael.christie@oracle.com>
References: <20221016195946.7613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR18CA0057.namprd18.prod.outlook.com
 (2603:10b6:610:55::37) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB6727:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b0fee54-2b36-409c-9f23-08daafb1162d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u9cSIgReQ/cp0vnsHrPn6ADGv3IISyfk1iqAzzI4/IK6tdogSflFdaNhnInnCAoNqByToSTrnnOuez/63ZKw+sduWo9v3F70kxjdGEAsMxK8T50MmTvBipEiA5mCG3PnJAcwpjEJoozSrnvVO4s28dkwX/TRaA4+Hikdg0mG+aHtAwZdEpxdU3hmPRN/o5huvvLmOeNO+nnpDIbSFCaB39v/TIX7/ywRVx/79I6qW8EL/UWhvPOpFIpmCldcdM6ZiMb/cubfRtWNy+fCtgtmjFySitGbVjJBizOxUGOTKGR8B0sOTAXXzgC3oQk1nsog1FL9/c1lBgw76jKqd33vOSW9fTpyye+7VfZQyOEjihmtrXfmWdv5Q0PQpYfZOly0Uas1CTSEPTjvoT2zpswMKkn5paWycGRMhQ9RUf+qqLtGoT67iZr3Xzkj8kWXgnCknf9NMpbucM9Te2ti3ZAgVRQ3LX3F2gUpzEkkPc5xuFU9u2ofSYAJB23pQH7YOCvMUujzE3K/kWUMC0fNM2NkE28VIobqUeiNysUGPjTcS6otDgsPCNgQPKlKeg6khZ4We21Y3ig+N5ClXZ+yAj/b1/gCD3+k4jP6/Bs6GCWpgsH2H2Oc8gzn32QhTk7XdQu47Sl34GHaAy5sRkzuAXKrf1hSm5PHvzK1TkA0suvlwzUBMS/yTSAr0n4sLFojvPInVrQreU+qQuAUZTVL/uSAYQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39860400002)(376002)(346002)(396003)(451199015)(38100700002)(478600001)(6486002)(186003)(4326008)(2616005)(36756003)(6506007)(316002)(66476007)(107886003)(66946007)(66556008)(1076003)(8676002)(5660300002)(6512007)(2906002)(26005)(8936002)(86362001)(41300700001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wlFqjoa7neySu+2bIDo0uv7ZrCw/tMFRA+YpDjOBQS52wV8ZfCx939xGJ6z7?=
 =?us-ascii?Q?3gEq/1VjhQek1rNL8P/4kYZmvzdjxneuXEyI25VWXTlTnX0v+W4u058xrv9H?=
 =?us-ascii?Q?o2yV3jBzDy9dQpFMn8bdn48mKiss1xusbTv58UauIOPztgz+G28USRePkfdD?=
 =?us-ascii?Q?HGyE6T2bGPCKKILke1Aj714InBnCd+pBaA2HupBBdwvTyDqMbAC/UAof1puF?=
 =?us-ascii?Q?v15gHR8pWry2OqciZrSpW9YLZ5FZuXVthnIbgfCNoUTDY7dBMBrDpElX1L0l?=
 =?us-ascii?Q?K8HYC4fZjy3DcufypHywMyjTiBn9XbiOEBI9H6aMBBl1gx+oMGvDUMLyViD0?=
 =?us-ascii?Q?2kqP3WYXaYLt9DSut4l9vtmEgTf6NNQsuXhPnSTfm+d4PsfPhtNv9IQoHxzH?=
 =?us-ascii?Q?67DHGp5uHSnyIqiKLw2hGNUutSuvcOgpdTN1DEytrjDwwg40JltCC+7R582u?=
 =?us-ascii?Q?G8yG8dTz6zq5t82XTvT5oQHk2JnsmGffSdtea/+OABI/8BxNItFF1t6GvAl4?=
 =?us-ascii?Q?QFkqnuZ/W1Oh3eLGO6aVxs5c//83ImJwgHRQd7cBVecmPLlEuKHgBnXPaM6s?=
 =?us-ascii?Q?r6Gz9B2g+H5lTqlCf285AV7xwwRgpoP6tg86G8xrFely4sk9WbvAmVtJYh5q?=
 =?us-ascii?Q?mAUtrEaod0Lq+VFnYs/eUZPWQnjHHeNdJ+QITzb3uZ99OwTbQLU+2eKL3Svl?=
 =?us-ascii?Q?e+9YTSoQTsLq1ddO/dlvVNTJhAWTk/mVYKU+X9F134vUeCvY13cgC16o7O0C?=
 =?us-ascii?Q?GA3/hdhAiETptRO9Hohk4xxDQw6n9teCeUXx7VVVZONy9eU0hFHpkwyi9OrS?=
 =?us-ascii?Q?gMUbtLdvNgzLnsKOhNII+mSky5yL9OKm/7dlL9oipgCDuDXbUvpyqjtrc9DX?=
 =?us-ascii?Q?V5fKfIGRuFICkPo1m+Da3eUs8Xgl6wblI6E/yFGDzG4AcxP6D54WNtaz1afP?=
 =?us-ascii?Q?7UNn0zwf/OZqfKzTZ2pKwt1P3qE9VjfYqR07RIy4h8DEkyxoNFY4+jeBc8I1?=
 =?us-ascii?Q?fHs56yzt73Q2JWMhphdcxuxYnxQi3EcR0HZh5NJ6vqt9lJppelx+we+0MZ8g?=
 =?us-ascii?Q?pZmugzb9ioChjUm+2o4ZPVIGDrJ/CZt8DDqgrbYeL+dFsSbBfIWR2+Fjb8lI?=
 =?us-ascii?Q?4535YDUDHWI2vQoIdO9yTbFA5ai8/y2x+3aEjwHuzmo98iF+6Aq7SABMGm/9?=
 =?us-ascii?Q?wx0FIpwxlyjN8TzJ6bTN/0z+SeiSQRm6ea+JEYtjXBqi9XZrzM70+LjU6BO1?=
 =?us-ascii?Q?EqaLhZYeMlK1w4Ii9knuJrP+ZWuNWG/xXmKHDmDSxF9zRsbr2zW3//XiCVcZ?=
 =?us-ascii?Q?SSd5EvJ+saU+3wNXn/taCd2W1YspiGcATKTND7mygKQIlEGApW8QLI/kDWSY?=
 =?us-ascii?Q?6gQI1yxQRIoDRlWuGcL9YzkxGpNYgJ6aUjYCxPcxEtqWbdzLss2CZzVeVpLt?=
 =?us-ascii?Q?kEVonku8OPwHmO+mGQ8aYU7M0VxYTb6CsBhpX0u6g7Q0IB+oyLLNKCJoW+Yi?=
 =?us-ascii?Q?JDKtBjrKETo8vlu4LIWXEwj4ZKIUziW6EG8nVfezMqJ2bnbFwRgG10irZ4GT?=
 =?us-ascii?Q?gymD1CtYXMC+2fFlU5AD1jsKBaRCeKdnye7evEey55IMRZnqp8ba3hBfDxu6?=
 =?us-ascii?Q?Fw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b0fee54-2b36-409c-9f23-08daafb1162d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2022 20:00:34.3600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FwZqblkyC8ecbB54Je7Smso4Jn89p5PKfL7TZ+wHjM6TzdyJSipo/9/eWLIoZqecOnWv+51GAi+P+mLimhjh9xYxELV0LavtefJu8UV9dxY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-16_15,2022-10-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210160124
X-Proofpoint-ORIG-GUID: V3Bkb2RngT2pUh3A5RymQ6xRCvTR-kuw
X-Proofpoint-GUID: V3Bkb2RngT2pUh3A5RymQ6xRCvTR-kuw
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
 drivers/scsi/sd.c | 85 +++++++++++++++++++++++++----------------------
 1 file changed, 45 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index aedc37613c81..690884efce8f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2062,52 +2062,58 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 static void
 sd_spinup_disk(struct scsi_disk *sdkp)
 {
-	unsigned char cmd[10];
+	static const u8 cmd[10] = { TEST_UNIT_READY };
 	unsigned long spintime_expire = 0;
-	int retries, spintime;
+	int spintime;
 	unsigned int the_result;
 	struct scsi_sense_hdr sshdr;
-	int sense_valid = 0;
+	int sense_valid = 0, i;
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
+		for (i = 0; i < ARRAY_SIZE(failures); i++)
+			failures[i].retries = 0;
 
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
@@ -2138,16 +2144,15 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			 * Issue command to spin up drive when not ready
 			 */
 			if (!spintime) {
+				/* Return immediately and start spin cycle */
+				const u8 start_cmd[10] = { START_STOP, 1, 0, 0,
+					sdkp->device->start_stop_pwr_cond ?
+					0x11 : 1 };
+
 				sd_printk(KERN_NOTICE, sdkp, "Spinning up disk...");
-				cmd[0] = START_STOP;
-				cmd[1] = 1;	/* Return immediately */
-				memset((void *) &cmd[2], 0, 8);
-				cmd[4] = 1;	/* Start spin cycle */
-				if (sdkp->device->start_stop_pwr_cond)
-					cmd[4] |= 1 << 4;
 				scsi_exec_req(((struct scsi_exec_args) {
 						.sdev = sdkp->device,
-						.cmd = cmd,
+						.cmd = start_cmd,
 						.data_dir = DMA_NONE,
 						.sshdr = &sshdr,
 						.timeout = SD_TIMEOUT,
-- 
2.25.1

