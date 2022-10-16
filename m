Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A2C9C433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 16 Oct 2022 20:10:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbiJPUKU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 16 Oct 2022 16:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiJPUKT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Oct 2022 16:10:19 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ADF611C15
        for <linux-scsi@vger.kernel.org>; Sun, 16 Oct 2022 13:10:18 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29GJXgWk015507;
        Sun, 16 Oct 2022 20:10:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=GbK6EOCeB16Hxeh5BeQ0zE668MA1KGgbX1F5LCZEsSM=;
 b=R5w3RK0WapIsc00+vc6uEXICZiS5yPT22GrP9KH2dTpdUUX9zakypHMI9iGc+j8qR0g3
 Xj4AdKWb0ZqPIPRSSC6u4S22dvB+3rt6FKYUtOIpn/JSO8kzBHCKBzyhv1BLJcIlFYR6
 cNXNsIoV8n/Y03dRVuWtTt6BeaEVAZIrwjqXjI66YNdyaGCP6QnUznXkabBrwP1thdSr
 CQMs5smtnvJtGuQivA608iA3ncrYlIPA4aRJXvxCs9u5f3XnBa/Wh2wdwxYOIkCSzXFV
 U39sL1B9Sn5ZtFHdbFLKEchkTZ2OvVswbbpPL6NDr0Og1Xydj1QEzZv05H//Fj+XKib2 HA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k8jt2g7ke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:10:11 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29GCBdiv029532;
        Sun, 16 Oct 2022 20:00:19 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2040.outbound.protection.outlook.com [104.47.56.40])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hr84jhd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:00:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kyCpcEtYKBJ0jT29dUx0L9lrcgAPitGqMBm+1ZSimmjAKwKoYZbp/HLRu6ObpAwPXq5eGz5uL1QCzYCgqVGIbuWPAplaLbsXuRnl95jN71+ARo4/WEYaOc+Rdhn04t21luX4JRVzJ7flfpatGyBVF5Rh62jtbZDYjskCDyuVBFayB6/gtkcLmhlg6AU8n683vJ56kDACLw28oMQQcVhhclTpLX1279VGK3c+Yin6zOW86KE07tBZbwTXKhTyv40GzuumKXiqh15LClljs+nhBLs82XYgocABPEmdeZ+pMYUV7BQQyLMjvtbpUakFdEwQUM7YMP+NjoJZLlA+KHgPig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GbK6EOCeB16Hxeh5BeQ0zE668MA1KGgbX1F5LCZEsSM=;
 b=cciLO69lBb+ioDz+eM/BOmz7PcbuU+vlFmJZVqJCfchCMNP+IutTMEzXmT0QB8NOGKcM7d6/yl8089dwbYNLi+HzkIP29HeeI8vYAPEoc0NkFUnZ6btgfKAHchpUon4qJKRmJaymsoLcb6JXeEOv2ZaSQBwmd3vs5Ky32krFfPPb1OXT7S4TufU3QwgFvC5ZR++KZSl4PEEo5BmWVnVlK4N+3xG9EPAAblTwRTeWfY37UDuv8KK6HPHrMmEl9STUlQpzSd57rJXY5eh1IaivkBMRCMR4yo4f/JJ3qqr5nTafFaLFgjT0wE16oH2ZMkz70e2Y64oQlkb6YDAsUAlDjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GbK6EOCeB16Hxeh5BeQ0zE668MA1KGgbX1F5LCZEsSM=;
 b=WccFZzC4dOOugCMfLnuw2Z5Cii0dCRwEaM115HpYLi17csbkbUG55f0X/lNSUS2lD6HdRiuATl3FZXvPqLl/a5nmPf4YB1AsmJZuzFiBa4mf7GbknuEKkjRp9nKQfDre1ycJf2yXLGElurHZX/p1cByjGTyo05hsXoKdheRBLQs=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB6727.namprd10.prod.outlook.com (2603:10b6:8:13a::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.29; Sun, 16 Oct 2022 20:00:17 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5723.033; Sun, 16 Oct 2022
 20:00:17 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 18/36] scsi: cxlflash: Convert to scsi_exec_req
Date:   Sun, 16 Oct 2022 14:59:28 -0500
Message-Id: <20221016195946.7613-19-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221016195946.7613-1-michael.christie@oracle.com>
References: <20221016195946.7613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR07CA0053.namprd07.prod.outlook.com
 (2603:10b6:610:5b::27) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB6727:EE_
X-MS-Office365-Filtering-Correlation-Id: bf9ba157-8977-4c0f-2333-08daafb10c39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0UnshJgJHnCy2//jio52SxXMD5sjp6fbpePBIssRV58Ydxd/4+cpaI+oeHzb7nu10hDGbvYz8C/wQISpeYsj0TOjPjG5vME33WR7hYll+aUZwMCmQ7CZr/nfvLqXEHoNV5F1ODkIItFVxylWoZnzvtkZpV7rk8SB+kmjGXEYQw2stcrRUcA4Du7gb9BO4dOP9Jc72/hRrCK4xEmumYAe1DEGITysEvpKGRkxjvG5YvZad7AnTQzufhywaBjvbkEiVeuE3xzoYYpiQGSEVqNxg8ufoQ03QKCaXIzEyDa3javAhsk+0tXB9XScjg6JsJdzsnQTfpGlsWybSdQc/VmTwCDCeyqyTU1ECquBSDgNU0nMEBcsnOA25n8tRs8tfpemL4RAnGEBbBpaZW6J46xIWmPhU89gKJ2YTpEIP7yYJLFoSwboXd6ZmpwA50zNURdLHaHLDXsqo7GBKNg2pro0OoWCphLGnaedHD02zEsJ8UhgrZYcTr5bj5q/UfV6ibHErJdwiWmzwzf7wsgW8p4DDiP6H3o1Sy++dr9S+e39tYZ4HA4KTNrs+PASVi1CVNakb7k8Q36AKyeOrepVMccbdLL4+acns3AtcQ+86d1bQK3ti2UTwyHptZmRTUBAZN8WtpMqwY8EEyD6+ax1+Ade5vMl2au2pk6gZA4vbOPajNHodKvwQHpjAFzGGf7R+RNYRxni57Nb3jdY6u3eWW1dfA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39860400002)(376002)(346002)(396003)(451199015)(38100700002)(478600001)(6486002)(186003)(4326008)(2616005)(36756003)(6506007)(316002)(66476007)(107886003)(66946007)(66556008)(6666004)(1076003)(8676002)(5660300002)(6512007)(2906002)(26005)(8936002)(86362001)(41300700001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+kX0mxl6Vs8mPvAFl+fzsf2hZWa3P6moriGxaJRh5OIuiSfaK3bAK1abBFY/?=
 =?us-ascii?Q?EudruywMLpp+VoAZCTAhFBmIdCxsJ7z8uriTwNevmdfY/OlIbGjf1q0aAqBT?=
 =?us-ascii?Q?fPIGU7d5+mptXkpnW1Ywp0P1YatJuZ8MRQCTZAQoEyyCUgB1QYQLkYMgaNqE?=
 =?us-ascii?Q?KIY4IyI1ng0RulURplfMKshT/0PZi4WasllFBhZwWl+NIUxQXWFuXrgfjUTl?=
 =?us-ascii?Q?Uxg/4vg21oLjo43DEoR3zUT94hZyMZ3Y5Je6tNlEOPhg1ARTkEfQsrAm9WU2?=
 =?us-ascii?Q?gVUNWfmLd73YJybh7Rs7WyHPUXrRiHcaBkkEFGIjYwDpS6Gbxg85DUvT1LzG?=
 =?us-ascii?Q?8qMMgfY1MX0FAtidQm0DZesgL7dA9IcMV8rOkCTsS8WF4IW3j+OAzW2lCDFE?=
 =?us-ascii?Q?vNIljiTWo1rbgQXgyVl1/ugQlR5UJb9BFtSOiq7qyYcQLJz+t9q8+3CjCWmk?=
 =?us-ascii?Q?cQ47v94vvzoVd9sIr6W30x39VxbwHsKjYNq+G3ruhV45Vk1UWFsjHwrzsQTM?=
 =?us-ascii?Q?vdcsmgLJXdleEXAXdYkOixOW6B+XdeGtoilIlHounwlYqUvzXOyKT5WhrEvF?=
 =?us-ascii?Q?o9MOv90YtpruIYESWCme+J1eidPliKPR96KWQntg9hpV6xRw8Dj4wiVqRN2Y?=
 =?us-ascii?Q?Q5bigp4K+veVIVoViG8oEfPtIxwS/FBc8Z48leEfpjpsNgZjz0rswvy7a8iz?=
 =?us-ascii?Q?v6bG+0QKxNwrdNdrByDbU1WDVsvb3a3ZMRjjSjVMfRL/EuZo5qrF+MRa05Hw?=
 =?us-ascii?Q?qJBS0/YW+iM4D92UGHCetDosZ7TxL9GzdRLahBb9yr7gTQZ575VImQRzCbE/?=
 =?us-ascii?Q?7A/u/cpqFx1amVnmt6/gsmNP3O4PgoSZp7OmgX7Wrlb2jvEvu7Gbpvr1hWH6?=
 =?us-ascii?Q?2lmWyr+kcdALkNPxd+Az03l+/lH4MMznvpxDqrZn5R3k7R8nwpVUFsttP0jB?=
 =?us-ascii?Q?BUK4yNO6YbA+7ZRQsxwp9IaxQcyoZRWeyJeIa/MdUat6yanfxYDH7J0VB4Ul?=
 =?us-ascii?Q?le+6ntFSkyRPKPWTiCSCjhEV5/52Hg6RAT38FLrZ9cxnz+yDXehliACehhKg?=
 =?us-ascii?Q?FDsQSqCbwb3m1OignFdHrcPHTxYs2ZtzkJO92B1FN7EH0X2iD6lMchHCsTTr?=
 =?us-ascii?Q?VOIXg8gG4DMNVTJlk5BsaIaEnk9TjTZYERthJQxOKyWOS0VqvQS2bgH6Y63N?=
 =?us-ascii?Q?lZT0Lc4tswduG0cMVdfOs4zcmabGt11g2n2qfsXZtFhswx6A3osPVuVMW5gS?=
 =?us-ascii?Q?rtfz5NCIX8cmQUtxtiufO0vdUmSC2e7GvwHf5qOVmByPZeAFBxySqU9vljEu?=
 =?us-ascii?Q?EAUm66it5KnwJPvirVfH/ARsKAA7GKfxpHjVz3UOfGn9lJqwDJNXH+2B6una?=
 =?us-ascii?Q?HVwYYCIMQw5rzm5otX8F3dYIgdW3vAptz6vz88FOQKTVxmw6fFMVBrrNqTIW?=
 =?us-ascii?Q?2HbBnbreVzs9IvYKidtJXkLBMX8QooWfM7fOtwe1pkQag0PrD9hYjB9ClsOw?=
 =?us-ascii?Q?TSI2Jxj+W6QuLpQGUJQjuG5+wgicce35Mc2fiDbnUJKbHCBCQIGn/efJVrjG?=
 =?us-ascii?Q?4xkP1UYyIv5LomkhJ4cKA4VYHLNCtfjWBFx6mc7qvCXiGneEMR0OwxIy8yZL?=
 =?us-ascii?Q?6g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf9ba157-8977-4c0f-2333-08daafb10c39
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2022 20:00:17.6739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qNdM+cZg6TTPs/RuNwVEG/aTqoGEU0oXlAGNaNVuHdOgkWY/U4TDWVkyGwG5TzAPWnZDCWgktVCM87NUpMIdLZ0DVCnTgedouOKfDixGsTY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-16_15,2022-10-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210160124
X-Proofpoint-ORIG-GUID: svVIycpQQ4NlZAHumVCbsSnSD9MZSDg4
X-Proofpoint-GUID: svVIycpQQ4NlZAHumVCbsSnSD9MZSDg4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/cxlflash/superpipe.c | 18 ++++++++++++------
 drivers/scsi/cxlflash/vlun.c      | 11 ++++++++---
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index df0ebabbf387..724e52f0b58c 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -308,16 +308,16 @@ static int afu_attach(struct cxlflash_cfg *cfg, struct ctx_info *ctxi)
  * @lli:	LUN destined for capacity request.
  *
  * The READ_CAP16 can take quite a while to complete. Should an EEH occur while
- * in scsi_execute(), the EEH handler will attempt to recover. As part of the
+ * in scsi_exec_req(), the EEH handler will attempt to recover. As part of the
  * recovery, the handler drains all currently running ioctls, waiting until they
  * have completed before proceeding with a reset. As this routine is used on the
  * ioctl path, this can create a condition where the EEH handler becomes stuck,
  * infinitely waiting for this ioctl thread. To avoid this behavior, temporarily
  * unmark this thread as an ioctl thread by releasing the ioctl read semaphore.
  * This will allow the EEH handler to proceed with a recovery while this thread
- * is still running. Once the scsi_execute() returns, reacquire the ioctl read
+ * is still running. Once the scsi_exec_req() returns, reacquire the ioctl read
  * semaphore and check the adapter state in case it changed while inside of
- * scsi_execute(). The state check will wait if the adapter is still being
+ * scsi_exec_req(). The state check will wait if the adapter is still being
  * recovered or return a failure if the recovery failed. In the event that the
  * adapter reset failed, simply return the failure as the ioctl would be unable
  * to continue.
@@ -357,9 +357,15 @@ static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
 
 	/* Drop the ioctl read semahpore across lengthy call */
 	up_read(&cfg->ioctl_rwsem);
-	result = scsi_execute(sdev, scsi_cmd, DMA_FROM_DEVICE, cmd_buf,
-			      CMD_BUFSIZE, NULL, &sshdr, to, CMD_RETRIES,
-			      0, 0, NULL);
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = scsi_cmd,
+					.data_dir = DMA_FROM_DEVICE,
+					.buf = cmd_buf,
+					.buf_len = CMD_BUFSIZE,
+					.sshdr = &sshdr,
+					.timeout = to,
+					.retries = CMD_RETRIES }));
 	down_read(&cfg->ioctl_rwsem);
 	rc = check_state(cfg);
 	if (rc) {
diff --git a/drivers/scsi/cxlflash/vlun.c b/drivers/scsi/cxlflash/vlun.c
index 5c74dc7c2288..4fb5d91c08ba 100644
--- a/drivers/scsi/cxlflash/vlun.c
+++ b/drivers/scsi/cxlflash/vlun.c
@@ -450,9 +450,14 @@ static int write_same16(struct scsi_device *sdev,
 
 		/* Drop the ioctl read semahpore across lengthy call */
 		up_read(&cfg->ioctl_rwsem);
-		result = scsi_execute(sdev, scsi_cmd, DMA_TO_DEVICE, cmd_buf,
-				      CMD_BUFSIZE, NULL, NULL, to,
-				      CMD_RETRIES, 0, 0, NULL);
+		result = scsi_exec_req(((struct scsi_exec_args) {
+						.sdev = sdev,
+						.cmd = scsi_cmd,
+						.data_dir = DMA_TO_DEVICE,
+						.buf = cmd_buf,
+						.buf_len = CMD_BUFSIZE,
+						.timeout = to,
+						.retries = CMD_RETRIES }));
 		down_read(&cfg->ioctl_rwsem);
 		rc = check_state(cfg);
 		if (rc) {
-- 
2.25.1

