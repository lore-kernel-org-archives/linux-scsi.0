Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E08DC4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Dec 2022 19:04:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233856AbiL2TEl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Dec 2022 14:04:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233915AbiL2TEd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Dec 2022 14:04:33 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CCC9D9A
        for <linux-scsi@vger.kernel.org>; Thu, 29 Dec 2022 11:04:30 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BTIwqT0000392;
        Thu, 29 Dec 2022 19:02:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=S9IfsMYSeF3M4JrFom+b3k0PUjXzoQOIqi26pEpqvsU=;
 b=o2JaBiJ4HGK3opTHu2volVkDiiKMcbR0X52Tbl5D5eCv1H8WIlqeMHxUB6HCv424wCrA
 yIeeRYdCkAjuuIOpDfm8h9JEJ/vjCvxxsaLHK7v2aOFe4yqSkMHYIfzfvhPRPL5vmOD1
 0V859CHhWWc7sAgkqfG7W2hgDo5LQ8h4rzR/nvYoBlHHIujlFVLmUMziiqbxTYM4KLzU
 jE/kOEVTfNFqteuVX9IclXJSSRcz6/MV8/58VyJJhVpbZAl5vceHU8fBRy8SzsEKKIWN
 zesqdt32BEZEoOGhIGI3fOADwcEDtvyxix0tq3lgPHefFak3m46sFeoNYR/GlebS4cTO 8A== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mnr73f7qu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Dec 2022 19:02:23 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BTH7v4D024094;
        Thu, 29 Dec 2022 19:02:22 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mnqvd2d4r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Dec 2022 19:02:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZGmQAWNm1Rv0x+8leCWvYpZjQ49ndOofeI3AdoKmVkxoE0qObNplo6n7TJ5sQb9gxDsLj1Tbl5ZJ3G1VIs0zliMCE5BPvLneKa0cINRwMPrvRZcUfHHbNfaruMNUJ2Yvsw1qXOJQ5Muwv/A3RLN9jEZSATWsKaUiPHT9z3Md7/7A353xj4dBLv3IWENC5opgz+IlqhP1Nxm8pJ1vFsrUsZlufkVS+gSxBunILlH1QNsht31WF7gmr76zh9PyU6nhaybsXiDEqsRT9GvvfWlqLVp1M4xFug5Tr5zaXtpQXsrhobXtuuPDVbIssmYVSNiqeiPkkoFqiQrGwAkBJ1g4kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S9IfsMYSeF3M4JrFom+b3k0PUjXzoQOIqi26pEpqvsU=;
 b=khjApRJ4znOlBrwzasZGfn02/RZ+Zm7NS7pFSqoz2Ehsr/+Qj+Fnf/vywHzGyW+UyF/isHhdboZXkZrI2gqzYaYZXidtbcIvguhoxLSNFNZjLyKfx9sA2RjoMLE1Bkc0ZC21mqwgPlO9Lup+ru2D6VYQOZRjg8KnqytqQjbCDavB4Ltgx3C/i0QW3igZXtG6eHPJ9P2eF4aFy56WHNue5rCjiuqqBWnDlM7KphltSKLSiBcVPVXn/6Y/IL5TM5NXzKD/33IjNYbOQbltIDzPxZkC1mZ2nyuCk1KVNPuJ3GtWTQQJDpIJcNW3MUOoIxEVwJLKDEFKgAcSXymymFLwZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S9IfsMYSeF3M4JrFom+b3k0PUjXzoQOIqi26pEpqvsU=;
 b=sAJ4pdzeYGaemSGoyDeyjVTR51e/9EEQA9RLfkIE60PFCpdgHVZH/Wikd41tViaRVp3FWMJ8SeH5IXsucma/H96HaFvs9A4vIj5Rjk279QHYHSgDPq6JZsiT46k9e92mCf8VfuzE4J05HKqxHvjKPEGJhNec3wLStVxUhzDwJYk=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO6PR10MB5570.namprd10.prod.outlook.com (2603:10b6:303:145::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16; Thu, 29 Dec
 2022 19:02:20 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.5944.016; Thu, 29 Dec 2022
 19:02:20 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 14/15] scsi: cxlflash: Convert to scsi_execute_cmd
Date:   Thu, 29 Dec 2022 13:01:53 -0600
Message-Id: <20221229190154.7467-15-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221229190154.7467-1-michael.christie@oracle.com>
References: <20221229190154.7467-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR05CA0059.namprd05.prod.outlook.com
 (2603:10b6:610:38::36) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO6PR10MB5570:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b9b95c2-fa3e-4fab-7fa5-08dae9cf3643
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x8/IUvtQm6HmeIpE/wBba9LUxWUHzv0O6jBO6FLu0/Jv8+DIgpmOZiecotefRhVEIVVXNBc3ETI9YGM7ckiZ4P/XDblqK2UQrQzfvq5yi5SSg6HOlt+0HjkzghHAzxYssC2ao8GhlHhYiCJsbAywWuMcL5oGF91L20aokCCaD4y6Da9L/4CePovbrhyWDbliNsVvSEzVu6+6BmtzXMGDIc8YruRNtq+tCfoUmL0cyuo6SMsJ0ZIXGRLliBi5atlBuxYqJ0qjf11P2XadSXKPhH0dOZ0XsIj/qjuAxRV3YVZiQoa0AEb/Th8FHK+dyRSke4em/Yi8XrpO+wBuiTMyndc7J6DGkGaZa+DIWP387wBPxRl7h2D3g2SQnk5xZv8v9SH+jDai/osEknzmDMvwFPH4+52yalaQJfdFxe+Y3mWux8k7mvRFMFo5IB3QHgG9z3qdtGHvyITP4mp0Iy7wnicqVBaZ6wWOLzn7vErRq/rBWvKFtQNQo2VcLBYALw3V/w+/MxAX1iTrcQaOogniZBMCawxby2TLrKobwrfgIl/KMDSpVmuqzz0yqQAJBcnUnox0eap8Od10hWdYWSynaEL20MTAS7V3l863jM9YZmk02inO9yJOaB0TX6MOa+3a+rp8Enz49nqDLj7DCj6AQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(346002)(366004)(39860400002)(376002)(451199015)(36756003)(2906002)(38100700002)(8936002)(41300700001)(5660300002)(86362001)(83380400001)(66476007)(66556008)(66946007)(107886003)(6666004)(478600001)(6506007)(1076003)(4326008)(316002)(8676002)(6512007)(26005)(6486002)(186003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BT8CWc3VBcj1H6KW0lWpHYRwCewHLRFd3LdPceJ3Pf30PqMyyr0VKrOpUwTu?=
 =?us-ascii?Q?iN7W1/rq7gCmCGkvF1wOBbnxz63JbrzYuIOxVTOZXCfIOuo7bGu4gZUfeGsV?=
 =?us-ascii?Q?z1wl4d0bHLbVlxhSBRsUyy29k2xtRO974BfCQHRnCJmoc49xpd+C0jCEg9N1?=
 =?us-ascii?Q?g1WSFWhm+kMecRpvuVpvKywdGF0C8KngOHU1y8z0f9BJ6rmvLD931dpPQYT7?=
 =?us-ascii?Q?8w0EdwN92NaV1yVui80M2NsBS3pSDfhP5zOJop267AZ07rHfTvIBirHGCcAZ?=
 =?us-ascii?Q?B6SQqgMmtCq2rSyWW2hqfQNBSdCwLI8h2yNMliEgfKqE5mGubTrIOZ5y/ahJ?=
 =?us-ascii?Q?ZtUnaWU0b59DbiSPgUtRaBKrnzzatcYvLZAFTPtvtpYpABNaDNVd4x9M+5uv?=
 =?us-ascii?Q?a7SsbDJW734COEeeYvOm/lgy7oKdMb488B5dJR+cKFqV6XPROAf3hOk3uira?=
 =?us-ascii?Q?vtL9byso4PXcwTV1+N3dkbilV0XzTV6y/i4dpxG+ked8R+w4mTPtCGWiLYQt?=
 =?us-ascii?Q?g7Q8TN7K2RI/HGyeppY6aiIkiqLK8LBmFVCDqfoH20jAX7vDgOMxlTo6FKCY?=
 =?us-ascii?Q?U2A+XXe7nEytdDvU75jMOfrMNWpl/4MeOxu/fiQpW3gCxw0oZF2Yg73BEAOz?=
 =?us-ascii?Q?I06OK12hfokBHiVFsL75mkFmtESYfUEzyBcLAX05QFcor41iDdXzx7gKAnZN?=
 =?us-ascii?Q?tvu2j+Z+jIJu/JNfLa2obbDguZ8pnWndl2sNShPZTcSzSXDdrmiTBXdLV3Ow?=
 =?us-ascii?Q?r9rk+2M48DXWLZB5DSAPzbDoiOQ/jSzTrB9GugMOaYNvKCI/pDr+8SDNCKLU?=
 =?us-ascii?Q?MuSHJ2OarHCWuSlPkBHqL6dizlomVshbmjkHewZfeZOId1XoY/mIgFY4kx9L?=
 =?us-ascii?Q?v5u0cAwsISjcG42JsykA2/OqpWVeCyDuOoBmLw1tr8R5PiOf44Be3mrw53F4?=
 =?us-ascii?Q?Hls4R6d81aEe/woC94fp/oHnqeuj2tB6stYPwlvFHCWIs67gxsin8Zqd5RAL?=
 =?us-ascii?Q?rZRfs3BFR7QsBGELM/ZJLsqaXx88KJEDVgn08OdpGinYlD55kR3hR0n+XFtt?=
 =?us-ascii?Q?6ZxIabJNcDkB+jpzR5So5s9LklmvyxPizUpH4H8LSXk++hFg0Uqo5Vpwwdeq?=
 =?us-ascii?Q?R5yxeJJvCEvMbEJecarpenpE9db7zgoS3hMsIU1mPQPmvy8v1Dotjn+Zg2ik?=
 =?us-ascii?Q?Z4aMEQWZvF4dlB2YYg+PQcFWsbfpkKKWGdIRyQ3YHUtZlJD+ix54ghpBH5ZG?=
 =?us-ascii?Q?l1onsHfmNo3O7l7mexmXO4+CawswtPnKRkTrdt6TKg+SATp0VarbEzn9JSZb?=
 =?us-ascii?Q?bR5B5NTuh9njGmShn3+iAc4QoIMtJ9V+Rs9mRreq/JatnPSDQFBwcL003xUJ?=
 =?us-ascii?Q?Rh2lOXNIhLqUohJlOWvaSIdilC1q18ygqKZYLShQr0/rOYwM9kNyHQSN5Baf?=
 =?us-ascii?Q?j97SuUMIfttzRX8hR0Wm/tbtVdxDYRhsIOAnnpW3L7iDgj8ygl6ndZ8CHdXo?=
 =?us-ascii?Q?/F0WQMIAcx5RBGf+NMucO9rqhk+YNDeEeCrE1SmPxkFjwK6PdtKT/9IzvfHS?=
 =?us-ascii?Q?vrSwIBExJu64S4QTJecJuZ44b0wT2vtaSQVMI6KE+YkfdkrUBhpvuZwV6UNO?=
 =?us-ascii?Q?Yw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b9b95c2-fa3e-4fab-7fa5-08dae9cf3643
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2022 19:02:20.5491
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Px5cIkA0GEklHnPzfYClmc1JdeWACRFje//xp7mBQvzPRVTRgWfCj2umzMQxY0y7GxNUITGb1vgkyPa6EY5yCZa/X5bN4BpMipM4ALPlkrE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5570
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-29_10,2022-12-29_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 mlxscore=0 phishscore=0 bulkscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212290157
X-Proofpoint-GUID: StgKLXpTI9LTUYojzN57QxvvRLekhhJO
X-Proofpoint-ORIG-GUID: StgKLXpTI9LTUYojzN57QxvvRLekhhJO
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute is going to be removed. Convert cxlflash to
use scsi_execute_cmd.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/cxlflash/superpipe.c | 34 ++++++++++++++++---------------
 drivers/scsi/cxlflash/vlun.c      | 32 ++++++++++++++---------------
 2 files changed, 34 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index df0ebabbf387..9935c47712dc 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -308,19 +308,19 @@ static int afu_attach(struct cxlflash_cfg *cfg, struct ctx_info *ctxi)
  * @lli:	LUN destined for capacity request.
  *
  * The READ_CAP16 can take quite a while to complete. Should an EEH occur while
- * in scsi_execute(), the EEH handler will attempt to recover. As part of the
- * recovery, the handler drains all currently running ioctls, waiting until they
- * have completed before proceeding with a reset. As this routine is used on the
- * ioctl path, this can create a condition where the EEH handler becomes stuck,
- * infinitely waiting for this ioctl thread. To avoid this behavior, temporarily
- * unmark this thread as an ioctl thread by releasing the ioctl read semaphore.
- * This will allow the EEH handler to proceed with a recovery while this thread
- * is still running. Once the scsi_execute() returns, reacquire the ioctl read
- * semaphore and check the adapter state in case it changed while inside of
- * scsi_execute(). The state check will wait if the adapter is still being
- * recovered or return a failure if the recovery failed. In the event that the
- * adapter reset failed, simply return the failure as the ioctl would be unable
- * to continue.
+ * in scsi_execute_cmd(), the EEH handler will attempt to recover. As part of
+ * the recovery, the handler drains all currently running ioctls, waiting until
+ * they have completed before proceeding with a reset. As this routine is used
+ * on the ioctl path, this can create a condition where the EEH handler becomes
+ * stuck, infinitely waiting for this ioctl thread. To avoid this behavior,
+ * temporarily unmark this thread as an ioctl thread by releasing the ioctl
+ * read semaphore. This will allow the EEH handler to proceed with a recovery
+ * while this thread is still running. Once the scsi_execute_cmd() returns,
+ * reacquire the ioctl read semaphore and check the adapter state in case it
+ * changed while inside of scsi_execute_cmd(). The state check will wait if the
+ * adapter is still being recovered or return a failure if the recovery failed.
+ * In the event that the adapter reset failed, simply return the failure as the
+ * ioctl would be unable to continue.
  *
  * Note that the above puts a requirement on this routine to only be called on
  * an ioctl thread.
@@ -333,6 +333,9 @@ static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
 	struct device *dev = &cfg->dev->dev;
 	struct glun_info *gli = lli->parent;
 	struct scsi_sense_hdr sshdr;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+	};
 	u8 *cmd_buf = NULL;
 	u8 *scsi_cmd = NULL;
 	int rc = 0;
@@ -357,9 +360,8 @@ static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
 
 	/* Drop the ioctl read semahpore across lengthy call */
 	up_read(&cfg->ioctl_rwsem);
-	result = scsi_execute(sdev, scsi_cmd, DMA_FROM_DEVICE, cmd_buf,
-			      CMD_BUFSIZE, NULL, &sshdr, to, CMD_RETRIES,
-			      0, 0, NULL);
+	result = scsi_execute_cmd(sdev, scsi_cmd, REQ_OP_DRV_IN, cmd_buf,
+				  CMD_BUFSIZE, to, CMD_RETRIES, exec_args);
 	down_read(&cfg->ioctl_rwsem);
 	rc = check_state(cfg);
 	if (rc) {
diff --git a/drivers/scsi/cxlflash/vlun.c b/drivers/scsi/cxlflash/vlun.c
index 5c74dc7c2288..9caabf550436 100644
--- a/drivers/scsi/cxlflash/vlun.c
+++ b/drivers/scsi/cxlflash/vlun.c
@@ -397,19 +397,19 @@ static int init_vlun(struct llun_info *lli)
  * @nblks:	Number of logical blocks to write same.
  *
  * The SCSI WRITE_SAME16 can take quite a while to complete. Should an EEH occur
- * while in scsi_execute(), the EEH handler will attempt to recover. As part of
- * the recovery, the handler drains all currently running ioctls, waiting until
- * they have completed before proceeding with a reset. As this routine is used
- * on the ioctl path, this can create a condition where the EEH handler becomes
- * stuck, infinitely waiting for this ioctl thread. To avoid this behavior,
- * temporarily unmark this thread as an ioctl thread by releasing the ioctl read
- * semaphore. This will allow the EEH handler to proceed with a recovery while
- * this thread is still running. Once the scsi_execute() returns, reacquire the
- * ioctl read semaphore and check the adapter state in case it changed while
- * inside of scsi_execute(). The state check will wait if the adapter is still
- * being recovered or return a failure if the recovery failed. In the event that
- * the adapter reset failed, simply return the failure as the ioctl would be
- * unable to continue.
+ * while in scsi_execute_cmd(), the EEH handler will attempt to recover. As
+ * part of the recovery, the handler drains all currently running ioctls,
+ * waiting until they have completed before proceeding with a reset. As this
+ * routine is used on the ioctl path, this can create a condition where the
+ * EEH handler becomes stuck, infinitely waiting for this ioctl thread. To
+ * avoid this behavior, temporarily unmark this thread as an ioctl thread by
+ * releasing the ioctl read semaphore. This will allow the EEH handler to
+ * proceed with a recovery while this thread is still running. Once the
+ * scsi_execute_cmd() returns, reacquire the ioctl read semaphore and check the
+ * adapter state in case it changed while inside of scsi_execute_cmd(). The
+ * state check will wait if the adapter is still being recovered or return a
+ * failure if the recovery failed. In the event that the adapter reset failed,
+ * simply return the failure as the ioctl would be unable to continue.
  *
  * Note that the above puts a requirement on this routine to only be called on
  * an ioctl thread.
@@ -450,9 +450,9 @@ static int write_same16(struct scsi_device *sdev,
 
 		/* Drop the ioctl read semahpore across lengthy call */
 		up_read(&cfg->ioctl_rwsem);
-		result = scsi_execute(sdev, scsi_cmd, DMA_TO_DEVICE, cmd_buf,
-				      CMD_BUFSIZE, NULL, NULL, to,
-				      CMD_RETRIES, 0, 0, NULL);
+		result = scsi_execute_cmd(sdev, scsi_cmd, REQ_OP_DRV_OUT,
+					  cmd_buf, CMD_BUFSIZE, to,
+					  CMD_RETRIES, NULL);
 		down_read(&cfg->ioctl_rwsem);
 		rc = check_state(cfg);
 		if (rc) {
-- 
2.25.1

