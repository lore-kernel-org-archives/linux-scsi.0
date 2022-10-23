Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4C53C3A59D
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Oct 2022 03:07:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbiJWDHS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Oct 2022 23:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbiJWDGx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Oct 2022 23:06:53 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B5A6CF73
        for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2022 20:06:46 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29N2tKAn015631;
        Sun, 23 Oct 2022 03:04:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=GbK6EOCeB16Hxeh5BeQ0zE668MA1KGgbX1F5LCZEsSM=;
 b=IDHNEiaeuun76iXwoqnuAwG9xcaMI5Lmaq1F6nwYP/+qoz4D2Eoxdlk9HbdBlDlAAINh
 AzNN4/DuTV350EO0r2UcfA5TXP7tvBBIpqIeAdXusp6glfWhB62lofO63TEbE9bAak+J
 sZyos098PWwPPVsR5+VS8yW3tckuRoBtTQpsdDl/RODp1nmntJl7WlaFD5+uiufMV2Sp
 /20e5JzCXRUnJn5Wj7OQJCJnkKs2atyofMNXoJQiL8Ebk57jx34iDxf1JobdaWldE13T
 9Eklx5JgJoG32V0KB79I087w1zcI4dIKTuoerA/jpYGkLQKno94Rft6k7J8wj59tH4B0 ag== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc7a2s4q2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:36 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29MKH3OP032306;
        Sun, 23 Oct 2022 03:04:35 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y30ake-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ed8lwOj2WPrM49fO/6UV8MQvpwPJUc/YBxJ9V3979TKae8y2sZXmh5t/7iC7wKlYc29H8ORKsjftQ3OUn0NE9CNQjXTxxcRJuhSYdQDw/oXm5JHFTH4S828H/ZvS05ay11Y40hgAS9CJNIW2KCoYY0sUfBNe+mfXU0JL9YWWCmJ17T57pOQxB/9SC86i6amdM0oTxyWrTsMQngwQz9hqU9ShH0bOT/WxBdNVqMfQLxETVOjIEVYBwsc1tggZAWyMfKtrkX8RgcJGyejVoKobiZuT+QVo4J7Q/utCHwVvXZs3vtNkk20pydn5P75hhUzUhdABRu8ZK6SzjaIwxCWo4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GbK6EOCeB16Hxeh5BeQ0zE668MA1KGgbX1F5LCZEsSM=;
 b=gXokZL0f/46mlCBeQFi+/S5MZyGGOgSrc+4IV+OX1ERGa7GG3MFkEuMTMMeE/1t4a2fPLx0I9BrZnmdzvoWuwgHnzODAV8jAyerg804veCSQQalkTkR3RQYvFqqKEY6fwkO7ul+yPYYgcfQx8DD50fauEUc72+6YrrbxEtEo8oABjxt6vygJp2cMmsU3XP7/HfklXhvhFJuwJ7cCwRYCNCnKt3QAlBFQbhXOEIjPMbnBrGRKo4AxX6H4xCJJMz+GhpdIUIRfitzXnFUIUnfRD/pQqqiMgiCpkdwRiDyVolCBGZaDPdLf80xnCx5O4WtRJhXKCIisC5Fa0VL6nElfnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GbK6EOCeB16Hxeh5BeQ0zE668MA1KGgbX1F5LCZEsSM=;
 b=TpROj5yBHfzDUJdk9HsUUMkmGif4djDZzVdDqPs/sPVa1E5im7SFflm3m2RcbZkYo6rMqhnXwEUMCLhuw5bylxHXJrIh1LzGCKos8jg9oCscr5Al7zIRbC+Kdief7rWYz5aeY/WodSnMhttPJYu9fsvaXHi9HC7YWW/HFqsfmNo=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5150.namprd10.prod.outlook.com (2603:10b6:5:3a1::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.21; Sun, 23 Oct 2022 03:04:34 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.021; Sun, 23 Oct 2022
 03:04:34 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v5 18/35] scsi: cxlflash: Convert to scsi_exec_req
Date:   Sat, 22 Oct 2022 22:03:46 -0500
Message-Id: <20221023030403.33845-19-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221023030403.33845-1-michael.christie@oracle.com>
References: <20221023030403.33845-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR08CA0008.namprd08.prod.outlook.com
 (2603:10b6:610:5a::18) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS7PR10MB5150:EE_
X-MS-Office365-Filtering-Correlation-Id: 64fb3da4-b2f7-441e-8d8f-08dab4a34fce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +gobk1FikYBHXg7MLJbv8usg571+EABJ6DeY3WUtDzg7bbJT/O4TxBcUjaP//NN4RaZE7xmCmh+ouHOhSi/SMT45ZN8lcZkCXNQeP1yry/Mq3s4RGYMDNxZTQAC5T+kYT5ZABBnHXAeYTpvpjOsqwbwdqkP9QmGO7zmnwjIdYfi5jvtsEHQMxbz2d/agfXZv8R59oITz+3TF2k+Q4XoqA+mUkm0U0Xuwkyj9MOZ5n5O00P0nb7xiFa8HxNWARtmWcQqTUuOyb0G4t6aOL39rbeod0NK8PWsn8YrfmZWfNGdlDzM+wULP/bneLSwmZ+lNU/07VU6raYXwkBpJd8pSEh7BefSZf+Ww7t3rF7ZFgBb1xUw02+9NMSwZrFPmdd/N3kdy1ps/Zng6V4pN0jf4d3rRDEswsLg/8gGbtamM2f5+qngdAEcx/PqywXXAVjhjsSMxbcc20G8eKlLKkmHTywlcETxoIyHnS//FPTkSI7hqXgWx5twNffu+0CZhboKrkILROGFIU/1e+t6w/NpXBfoaqcm+cDCYOSZd2Lvevg595iYWtE4usyoBrC/1F/3n2QRvqCCjJNXkHO5K4/tW+kAAUPwzHJuz3Z0r8FU+1ZTawNKTOJnY8Xu4/K8JOPnJuFyWIWn7Jv8rkGC/IJwsCFAQrurVn91NUbGlgXJ5YCJ9+QTaA3n9Fmv0huZKmM/Tyq46zInhphGkapCM1XeDNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(346002)(136003)(366004)(376002)(451199015)(478600001)(8676002)(4326008)(36756003)(186003)(1076003)(66476007)(66556008)(86362001)(66946007)(38100700002)(41300700001)(6486002)(83380400001)(2906002)(6506007)(26005)(107886003)(2616005)(316002)(6512007)(6666004)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SaHD6dyZ54NZQTCTEIoDW56Hcbx1qgQx47dCt1lC7NdarnYI90S7RMKF15dV?=
 =?us-ascii?Q?B3gMW7u2qlm55wxqGjF9KWxY+l9kce7h2cvBKEqjfs2k6OmnRp8a7ba7fo82?=
 =?us-ascii?Q?ckoXkbJAUv3vuv8lt3sgZKifHwHAw4mWT6NY7Crcr8+HSHxtUoo/92TuHRmP?=
 =?us-ascii?Q?HuykWfVuliMzZt60GIwyMIhvf0otKa8o/s03GHvxQFqfvJatgKruofpfpPvs?=
 =?us-ascii?Q?HWFD7UZEbfaX9HFN2HqJWfsxNRErr9nFY7vnYjdr74zJCtiiMdXw8tmEQZzS?=
 =?us-ascii?Q?GO5zcVMvwkcDTy7f8GD6p08vl8OiA7RxWuVFBxCko+CHsFF5QXhs4qjjOxcb?=
 =?us-ascii?Q?Rtwm6I6dhfu6NauCzhpcXZu1MtRiwsFMBDho4vNvbW0wcrB6tAfOI787tBIT?=
 =?us-ascii?Q?67BGMjn7bpaP3GmUDjyHlSP3t9o/djDugl653pfJl8pKb2jLIyYy/Woi8f/Y?=
 =?us-ascii?Q?7Ylb/PKXbj6MMZeQ1JokCULEJ8triYxcm9A71yA8LAUmjFMSxATJUAppE2/M?=
 =?us-ascii?Q?caopTjpK0YzCOWD4yI12H7uDWB6gdUXDesa/a/9QJoYGsdlnqBFeppBqhohl?=
 =?us-ascii?Q?S4hGV1hSKQAQjuQ7FxPKx7GIOkomSDgv3InSlz2mBVHJb5Iy6OVsYfBRfh7D?=
 =?us-ascii?Q?OjLCl/Km5J5Q+bsQU8uIoENR6kvuByVdHsmHyQkDdi3NUUCXzbWITKas7nPs?=
 =?us-ascii?Q?CyfcugxdHebaOZrKowJLijsddwqMp1Y6TZ6FEs14N7htT4Lb4ujl2Qa8MKt2?=
 =?us-ascii?Q?jGO8WUf1XApB1T/2tzHv6EigDKtonhhyJ04tcfnc9SKcVcN4BE+zJs7D9sYd?=
 =?us-ascii?Q?d+NUYLLV6a0bylYRC1E5v6SMq3aYedbpUSa4IGWZNpy8/hH65s7ZObBLIc+L?=
 =?us-ascii?Q?K6N5hWHDQ8rEC+TklMRNpVuwDui5pHFsK7BVfLnlNPDULPbhkZNZiwHDTPTY?=
 =?us-ascii?Q?X2AppM/LMPc50vJlK+7dmVJWR46QEIL2O3VKjnfik8mOXTTbeQwhOgM5MwXL?=
 =?us-ascii?Q?etcl6ATnCh3hFffSeQ0eXKJ7yOCqjbRwqC2/v9QtRAyQCH+kSP3onJoKz2Cj?=
 =?us-ascii?Q?BwyfRrwwZ6fBmXWFTjjB5abgZVVIwNvFPKIV3aMAMCNvLmZURMFDMu1M5lrT?=
 =?us-ascii?Q?ZmFHZjzKtJvdbuN34pAZpLN0rYYOr14eX95FApVICtb952v0g+9uaq1wxZDi?=
 =?us-ascii?Q?2b6PVtChjzE0rmC8h8CVLrdNfwrQFYAXOEfF6nmN5kQbfUdHjQMc4N3ptJ3C?=
 =?us-ascii?Q?9N6d0kyhHu/MOn9QISYNumPAC+kkS16qcyTEjuOlWmtechwz6Fsrrdg55Woc?=
 =?us-ascii?Q?JHD3ku1Ep+WQ9qjcXDPi2O7xKC7nbS0Oc3aHJUXGl8Wv+cQY/xggVZOdqUZf?=
 =?us-ascii?Q?idJ+T2lie/zuUf7PGxLEbcQhlhC1JADGyD9Wy0qGRlQg6cS+dGYwuVa/xQSh?=
 =?us-ascii?Q?Lro/kYcES7i7yxPeCLugnFEGN1HXz3YBoalK0nFJEFIrbdRHDPEzr3k7gON8?=
 =?us-ascii?Q?YhCKxTdyTDXOVX2Baeo5/LjsYVYFUfaDiz6DDn75DKfbjZPYomaoUlXc83wE?=
 =?us-ascii?Q?q75H4n3xB7BcRaWms/a5WOqTohYzh44gELjIhp/Cuu919duOg0S04zTyCk6Y?=
 =?us-ascii?Q?1Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64fb3da4-b2f7-441e-8d8f-08dab4a34fce
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2022 03:04:33.9202
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EjCUuDqyr8g85rumk2A8B+NF06e+Sxuw722u3qlM0JU1uaOY5tB0rfWVmzj/SHPd9p262wslyk1hPjSVVu73nyDafO1f447fZvNlxqg2bfk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5150
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210230018
X-Proofpoint-GUID: kopLNvCAKjQ6N8_fZDrDTxbUQNOjYiT3
X-Proofpoint-ORIG-GUID: kopLNvCAKjQ6N8_fZDrDTxbUQNOjYiT3
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

