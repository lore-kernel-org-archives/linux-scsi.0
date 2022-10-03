Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F39D7C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 17:55:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiJCRzA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 13:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbiJCRy3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 13:54:29 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 933DE3A491
        for <linux-scsi@vger.kernel.org>; Mon,  3 Oct 2022 10:54:02 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 293GONB3006557;
        Mon, 3 Oct 2022 17:53:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=A6ZhTzLsw8G4Yi/nEZu8nSsBfMpQmeRCnCLGTZb3kXM=;
 b=Nw+SHmGNFJI3dgWscppjpX5xE/OOHN7uusFb59CzfkcitzdqRF7JRZmqeNtD71Vtgl8S
 SxMz47LJXqdzbh8weadMfI4Qv9CCJHit2wMsOUeqHPQ6W2mGGSRj2Kma18EFWtxl8mUj
 uwCsNjb+eQjcYng+O1p3xr5wzgba3/H4KUfzy8sVeQ3dS8NOYZHIjWIHX0k1IBW51ZgT
 AN6ftUoha7pS7jEpqhgg/lcHW/RwprdFZws7zo4OC8pRC5AgEXx3eSF08AZqIh4pv7eq
 P7QvOtf9yfiUbifeqslOUK4nHD48NDPAVQluaPvfDTWJLjAE6ywWZh+4dIbApxVBVfr5 OQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxbyn48tr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:53:54 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 293FPa5s014093;
        Mon, 3 Oct 2022 17:53:53 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc037ydf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:53:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dA0YwRpGzt2JImPzSRzmNDkAETikS9VydR5R01rC8W8NiOrdR+na3NmLL/BlrZH0TCfMeJW3bau/bVzjeXsz32UY8ZMWNi87VvIi2PYzyIytDty7zAlJnXVwBY4Z0yY5I0Abae6mEqRQHsjQZnkYdbLTtSLNM8vcSaycjZSY8LGsRqe1txwvth8RzuEJ063tKWqMkdfI/5/OWHNuSnmyKtrKEPyX0R3ew9UlavguD+G/kqCx7t4Ox5CYke6Z5ADM3EEXuEBDYxMAXMy/TPyBqFwXhw8UWjVoQNvEdSGfKObkX3ZbltTC8rLagVH9kNMWKJLP/zKO6M0x43JlzaMfrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A6ZhTzLsw8G4Yi/nEZu8nSsBfMpQmeRCnCLGTZb3kXM=;
 b=W25pvnyq3u23K0EX6BuFAmmNmZBuw83/jGSLHnLrgHIsIisInxxMc+xPuc86Lqxnb2edpg9zI380uWWkMltxnaenHFdgyGM/Zm2dUeja2Yr/zyLA1Sw+Kml3jq9CypVc+fMmsqeWV2djrs1Gn0sIkD6HUFBD88itP2hC9eBF2FRTR/KozcFRD88xYM7gPh/f7om0vDwuJvS2e2gmM/Rldkzh3YiC9pioZ1xUy/J5zXYq0JcNPVxVzA4CIllhBc3tJNiBkCKeK92pjITbPTucPwYRBXaLPlmtR4YEsXcbJJgEv1FgXgR3YeMlbva8DdBwl/5MuFRhW5vvCOnVap75+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A6ZhTzLsw8G4Yi/nEZu8nSsBfMpQmeRCnCLGTZb3kXM=;
 b=CAJC3HtAkKuJJboQI1TeL70hQJgz7FUkShgWgBzuyMp6mke1vCPtA6eA8PK75LhoSuNNJYg1N9dOlIcQV2BjUVZKraT9EFcB+TEvAxY5oJFzyD4PeOgn3lToLFk5XqUeH82Ua7HrR7xd6oMYRy1UwRPK6Qk7vdvSQgfDSgHZGWk=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB6824.namprd10.prod.outlook.com (2603:10b6:8:11f::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.24; Mon, 3 Oct 2022 17:53:50 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%9]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 17:53:50 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 18/35] scsi: cxlflash: Convert to scsi_exec_req
Date:   Mon,  3 Oct 2022 12:53:04 -0500
Message-Id: <20221003175321.8040-19-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221003175321.8040-1-michael.christie@oracle.com>
References: <20221003175321.8040-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR18CA0035.namprd18.prod.outlook.com
 (2603:10b6:610:55::15) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB6824:EE_
X-MS-Office365-Filtering-Correlation-Id: 53641ad4-d936-4167-b059-08daa5683aaa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wCKFHjxBedGpQc0275eojFTES9DKCKW2V6SSVGTwhkx6sAvgTPDiAooCB9Zr6T6yn9OEGEh8CpQNfQObhEivJqM0bRJAFp0DwvH47X1AAI2nkJWq2hIMCQWs14aDqfgK9Ha7e415Dk7q1K3SbUjMS4in+Z/Z57RVsPRmovxgLg0YWuZ+CVv+zMXny6H+cg5vvD1hFo4T4x4uxNEhGDxRayHXuw9Cb/kSxc8e0Akh9m+m8+OKIqSU5L6nRGkmfBFqCe/Qp819iEHHPnwbLXuup517Zo/35+/AnjBmcPbqheRDIWTnuRi9rJAQ/Peg9lmwjCq7J+CCmD5l7tqFlzNOFZT6h+bgnpypZgdzXH+GFg2u3pXf0eEJUwGJxv3noqws5iTi88Z4JH7VG/FJttNhG7DcREPfZteumwYa7wZq6lBoyxLso927x+11qP/AJbpjEs4O9ESaR0JO267bOl2r5Uq4vfPWBKW0Tsxlag0O6w+BZfv/chyNsEi8jYi/17PA3SojpAkLKgQlDRwbV8Nbb/oICLC3QDkm9fQGmfbKvtsa+rLK0rKhu14Vr5OecjuCGe2Gb98jwWX6uLnaI+htr6un4A6Tc4dncj/LboDtjeasiOwtVt3BZ6bZVNNbigFCbttU58GMlHgF5Ga24hRJOnxJLU3/+0l8uzGtFNtPLoUYM3Y4rdZCeehqKj2ugd3HLVMgcgIvIX8MUj8cxmYTCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(376002)(136003)(366004)(39860400002)(451199015)(6512007)(6486002)(1076003)(478600001)(26005)(38100700002)(66556008)(86362001)(316002)(107886003)(6506007)(83380400001)(6666004)(186003)(2616005)(8936002)(8676002)(66946007)(41300700001)(4326008)(2906002)(36756003)(5660300002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P5Z5goAWKmxDlYqbXMBA/T+yaWfNCamGOhS/7WMD2qIwb0GThVQ6bz1WDixb?=
 =?us-ascii?Q?Y31JKhf7renOja7PAHTzhe/IjIt1W//sU04ugtVpnVrLLW92kTo5wy0wZQjN?=
 =?us-ascii?Q?fLHoZuDm+tdS8kowprThzJv/iqULl7ueqtj8cRRjySa6M8D1LXaG9A9iDSKZ?=
 =?us-ascii?Q?mDkeiN/wjPNDyZfzpXeUDL0hEH6jfH7yGCzMC5wb5H3l7Rl64gnctVhe20LL?=
 =?us-ascii?Q?an1JCI3VunlOcbGVjdw2s78IZNFr79+ukZ+SjGWGBbCgQ4aixGD9kWDzl32B?=
 =?us-ascii?Q?m/6KmWcgTNbuCd7Ea9NfjLK7ZWpD4j4CPM+X+UEWArzTnyvnDhmjGhmvYliX?=
 =?us-ascii?Q?hBh/HcTs0+oKkvJMY09u4IUYbcwtItbS17kI7ZlEf0QPcmD4VGh0Rf9K7PDP?=
 =?us-ascii?Q?ZmPDx/lm4bZsnqn4uoZypCAClwWGXxxctuIR6/3Cz5HR5tjjsVT2D2kthwKU?=
 =?us-ascii?Q?T5igcZihVhkk5MAeeg+yml0Xz9tIz51GbcngsoNDtLfNPC1xpqXpS7YrzChV?=
 =?us-ascii?Q?/wGQ68YE0TED4DAjrBbJcGREI6mNUwwpfDddSnz9DoHEh5gi/8N2aQTjar0/?=
 =?us-ascii?Q?+HOErDxpImF5Ynhol2yUSZq24I4jH08J6bKnqOLZRD9/458eVwsuYCXDM979?=
 =?us-ascii?Q?54movXRlr7fpn56+LTOlB+b4QZ8JIfnAO5HY7eDHs3LsfH9y+dgziuC1KRWT?=
 =?us-ascii?Q?MvcPKxE+e0COwzOuxGf0pAv7yxuH3PFXmkriTXHUr3LkR4I9yoNhWkshZmQt?=
 =?us-ascii?Q?5di5uHa90UolFWyWyhO4wSIZnm+3xWTyVSaiYl1N2DUIx1As+esqX2/cgGlS?=
 =?us-ascii?Q?jD7DUtGwCEuThvi6pfVIfrCdeL1BLf6cxV9JB/4P1A1Q4s5JujfwSCigGeGz?=
 =?us-ascii?Q?H0B+H6j2RlzYNo9onH7rOSD0mll8a1Sv/VmBJJ9Q+tOM3RRkztHSIu6fSaBu?=
 =?us-ascii?Q?E46ykrSI3JnKUtGSegp30ZHc8CGOb51dRhd+MebUeFMcj6zPKku8BhSBaA8o?=
 =?us-ascii?Q?Y9d+Pv7dEfdONFCRtxq9YAf1HheIr1T4TEXzv62j5qO6X1kczPFevIDTviy2?=
 =?us-ascii?Q?cJyGGpmU7AJsI/d13aOkJwEP0h5PvdjlsSfnyiEGmraV2o9OwYXieeFVcV63?=
 =?us-ascii?Q?7xAFEWXDdNjExe8Zmhtmc7gxVfx52PKF2xzA3NrXtXuhJl/MAWF5SsF5IjUB?=
 =?us-ascii?Q?V4syskmm5EitHYl/pTrt8R84x8iHVkzNYVuPb555AsQ945Qq6Ts4CI4nizwP?=
 =?us-ascii?Q?ELosVx/ZqNpz4a6FRIkifKsXGENsT7GJ8EUr4JEZN0FGU1hx2+INEOP/F5ec?=
 =?us-ascii?Q?jBkOKRPBXj4JU0RKiSwXQJhd3ddmRAS2hswwRwESYdx3xAPe4PMHki6PzphI?=
 =?us-ascii?Q?w++tQr0utUOG2b6oIlN2uokGVv7t2db+dCuKQRAsdzDtQ/ftiT/33Vnyu/Nq?=
 =?us-ascii?Q?QX8LxoP/VCrHoe5MPnwF2J9QRu+ZWkYRkcmlfdMiWOc5DNzBTsl0gKYv7AyM?=
 =?us-ascii?Q?kxavYyZA1hIGRz+iAQ94uheG6xsNEyPVoMz5PETr91cdIjVfyP7urBagfVJ6?=
 =?us-ascii?Q?5FANNUhhMXWEsfPBNd9FeQLTbmC+zVoSXVpJhkslKYhBT60m+WbQ3yve/l+Q?=
 =?us-ascii?Q?rw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53641ad4-d936-4167-b059-08daa5683aaa
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 17:53:50.6730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iJ9L9qsj9KfJpLxjQSZFYbryR50O+/t3R7Adnwun20OzY2dWmZ41X5vtySm9GBljgxjs+NkskVhfEJ+a8efLFAKUhpKquLEoWoLUKXdAdjY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6824
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-03_02,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210030108
X-Proofpoint-GUID: 73-IAO9fxbzeZfFA80WyEQA28xyz6BLl
X-Proofpoint-ORIG-GUID: 73-IAO9fxbzeZfFA80WyEQA28xyz6BLl
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
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

