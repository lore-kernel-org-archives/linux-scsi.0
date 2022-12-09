Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CF60C4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Dec 2022 06:16:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbiLIGQt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Dec 2022 01:16:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbiLIGQM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2022 01:16:12 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C636894193
        for <linux-scsi@vger.kernel.org>; Thu,  8 Dec 2022 22:16:09 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B94VB3u010444;
        Fri, 9 Dec 2022 06:14:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=Pp0kGeJk3emqQjvYVp6iORYkHfkjAVgRNPjBXR4dByo=;
 b=kd1MIcCGAHWkZt1FWk2l22/k65dDOch0ShtQc31YPjpWVdas54Cz6fO/s5vhIy0hv6K2
 iZylYpDcvTIPdUJ4eABCPOzTYqka58Zj88PYGwdOCH13hhQP+zOLMXRBeRmkSu6Q7tCO
 cPKdBk0EfeHbVzqc4/4tBfatc9faPVdhDf1LjswfGv9Mc57cHYS/ebVigUCkRB+SiIU6
 PVFaiWlHcG1VIRQqaWU/bVeLRFPeS59F7R/gly0wdwcvclh0tjQvGgZs2A0u6SgEo8s9
 FNeYRkr1uNGK2tleG9/fW5F0lbxfFLJK1uwOI+3wgXDbefjOTypDcuV1cjGDkX3ZyD+3 YA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mauduvcq5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 06:14:02 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B95fZbC019656;
        Fri, 9 Dec 2022 06:14:01 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3maa8jwbry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 06:14:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c+VgapQmkvLW/dIpUhDl92yng2euyDaUo3zSle33rCcuK5UAv0terp98yrGOEHCXEmEoYoXiLHDuop6lng4mVQ2bYo8v2f5pos4i70LnsHxKl0JaMbKSgHKYaPqycrkiHIjTbVQTBNa82x8pXPz7iff8gw0sXmvBmA7m2vZJEE2vy8EAsEpo9mz4m2DH1u8wJnKa/6S/MHczdUKwmNNWccu4hK5yMP08W61kW+vBV+wzSSMpHOrpz1oY2Gy3qWG3c/IKHAZ3pbewjf6YWfkbuTD2O+jc201OZvH9Vt4h8bZ8lBZx9Fds/J1jnyrcZkUxUMeIU6HA5xHE+fTu03aMLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pp0kGeJk3emqQjvYVp6iORYkHfkjAVgRNPjBXR4dByo=;
 b=jVp2OLtlQz584J+TFcbNP1yR7kGVt7QSW95rYY86UAuQZz10qvijTPbHUAqdHx1wEG7iD6Y1S4650/1Qmc/ZwJ+oBf0GNNopqghiOPFrSGjzPj2XSjLToONoqv5RGLD+F91+M+kKCYiWii5YmPmsMmEdLuGVsHTLDLi6BvmnM4x+ebdnrY179BXgVzoZx9Z40zoZN4KA9+v9FERaq41i/MKXlPBY8kz8bcmWiuaET7CdSisX/E5YdQ7WEpMIsGZHYFCeRJaPrMaEgSAIMylFic+7JG+ynFizPyZ+9qW3ZehPMM3iRBzsdrVH5812caqCP+aYShJZbEVL0XuZiTG/Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pp0kGeJk3emqQjvYVp6iORYkHfkjAVgRNPjBXR4dByo=;
 b=wF4FM5Pms/kC4XmqhI4CpwGfBFO9+GUqCdHt7swEFLQznjy9jUwM+GXf46csey1oGwx/ea61/zSWCOTxw/FfjTaBDt8G7REKo0a9T/oFDgeNabCPLcfMuxFttmg7Smr9knbCWSMHm3JrOsYd2c+fhBjFy7ZPNOOHUwodVatVw/U=
Received: from CY4PR10MB1463.namprd10.prod.outlook.com (2603:10b6:903:2b::12)
 by CH0PR10MB5066.namprd10.prod.outlook.com (2603:10b6:610:c4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.18; Fri, 9 Dec
 2022 06:13:59 +0000
Received: from CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::a99a:a833:4f4c:9e99]) by CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::a99a:a833:4f4c:9e99%6]) with mapi id 15.20.5880.016; Fri, 9 Dec 2022
 06:13:59 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 14/15] scsi: cxlflash: Convert to scsi_execute_args/cmd
Date:   Fri,  9 Dec 2022 00:13:24 -0600
Message-Id: <20221209061325.705999-15-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221209061325.705999-1-michael.christie@oracle.com>
References: <20221209061325.705999-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR18CA0024.namprd18.prod.outlook.com
 (2603:10b6:610:4f::34) To CY4PR10MB1463.namprd10.prod.outlook.com
 (2603:10b6:903:2b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR10MB1463:EE_|CH0PR10MB5066:EE_
X-MS-Office365-Filtering-Correlation-Id: 9785d0dc-13a9-4f76-32a5-08dad9ac8dac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4JzNiuwdfMWHqKwuc38Dv+kX2RRdssiNgKTBc6EPGOsLmSi/1wyuQ/J/MMGVAo9OdPW5Y5RkxKarMXWCrd9y+ATdi1RXR1iK5uxWH5a8zDxe/SJDIqhn7rm10kFmJw+Y6tby2PgX3QDgCR9OLBaqVryEbFe5u+i42e0NCPOxKcJrglnmcLBMIWlFOlcpqHvY+GAQpoUXh5yez+mLVZiPLIzTgBaJ/BTgjEdq3y7DBBJMmbqB2P6Byfix1aqA2rAXm9nATtlveXFZ6+rgliFQwZW00LnSY+m7awWm95lUyizmhm1DjjfFQzS88bDaUjLdBdo/a9EjsVZ12NiobA5WZUsIkTsdlqe6SZtFafg70Bd9eX2KPJLQO1Z6srmnYDBsi+zLyS8fbrPKa3nybrIq+W/93DxmngIPqbkYCGVCAsggKMRrXrWLOUz1XZBzS0IDZ8TmPeTKuV+dbgjyvgAG+z7UZ2qKS92b9O1lXBuAJTq7nW/xhNcsRDxvRNTsqla6rq1zvWDXlO/vrsfvD9gakOYMllzgfrpT/sSz5SGo5yVwHH4d1wjGUe5RnilelCXlOkViP2S5nnoxQkJ3oYK0fhFY+Bbt3d3ZPAUvS8Irm/rlsENcNsuecQfT/qCpaiiB5iVXBLUVNf9RPEqrMXPr9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1463.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(39860400002)(136003)(366004)(346002)(451199015)(478600001)(6512007)(26005)(2906002)(36756003)(6506007)(6666004)(107886003)(41300700001)(86362001)(8676002)(66556008)(66946007)(66476007)(4326008)(316002)(5660300002)(38100700002)(8936002)(6486002)(2616005)(83380400001)(1076003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lIL/GX+KNOn44YF0sBfTYS9B+izUYh0OXx0s2mPvxcBQ/Jk10JsyqH6oB8Vz?=
 =?us-ascii?Q?ft8MAyr/+Zrmhyi8CMMXgmophyhRybWIUr5zl4m80iWMiFObD0eX5DfAyKWd?=
 =?us-ascii?Q?TkWTOkPIDddRPDeQUkEIggfht+82lU7neStiSBQW1ufEJv1Hb/DhNryTFhhX?=
 =?us-ascii?Q?a2DHHkKXoGjNqSL9d8lIqdY3oEe7Fa/LSQuP0965TXZMSrGJGdmOqNv5yixg?=
 =?us-ascii?Q?jesmchltdSF1/6D62HGxIOG/2Kh56zZzBKkzKKyU+ZOPLkj3lsg5lFfSB7Tk?=
 =?us-ascii?Q?aRCt7nWdkEUmhN2w09IvXxG+XGz1ZrqN/AZxwiX8xa2+gnB1P3PHXRP8J5qx?=
 =?us-ascii?Q?hW1JAwsjMROC/IYjjcM8689TjVJcaLk8L85dPpfvCvM8e19g7phekpPnZhZO?=
 =?us-ascii?Q?ju6gRM9++5HY4pUnaVcZ0tratFmJ0BZwaZo1xnqE+V/jppWZ+TuOEzB4pC6c?=
 =?us-ascii?Q?NN/+jidi01ENiYu7s7GD/BxWk0b9EEBNaYep/zfFMnAtZnF3Pl+crFv6/gHd?=
 =?us-ascii?Q?z1k4q7MDWx/epMWHROtUPNGUsVLyvrSr+T3uJXE6G+DUJYzVlB2g2Sav71BS?=
 =?us-ascii?Q?SWaYeCoD0yHIN02G3VXuk0WVxjgnzup7oRdmZk8lteIRbjbGgSFK8N9+hXy0?=
 =?us-ascii?Q?xP5j+0CS55gf1ODGlDugEajNnWWK3S+0FSZmEoAJtLjvIVz/CLmInEE9MR8Y?=
 =?us-ascii?Q?kt/scWSXpffo0hDe2flueEJujXJ5RndH9rt/hHz2a4PNnlb6u8PoqdYwoSfA?=
 =?us-ascii?Q?ozRPJ+D+knZbgI+tnIsCWuF8SklgrPRqn9j636cIsGM59odbxrUuODAHAd9K?=
 =?us-ascii?Q?T7scGr7tcTTg2LLGjFE38O0QkcPa8XLIxtV5fiqiR8Kl6jvJr84j1pMIJtcn?=
 =?us-ascii?Q?l/l0bi22hlBYiWSVF1YYrawwhnw67EgtFTQH2zaorjaDcRsRG/qzmA/PKWpT?=
 =?us-ascii?Q?n0Hc7JL4im+HbYKsX/Wvw4o7EPThOqo7guQWOFZT+HWGTvT/hPx5LV8/iDMe?=
 =?us-ascii?Q?njep9OVdn/J+kaI726oi6f+WxgeLYVegVgQy2C+WZXmP6VBeVyxd3/DlDAdi?=
 =?us-ascii?Q?vZShKZNUeN0oAzPmeoHKM9OXUVP5u/LzCqy+wx4IzgfzFaznH/xq6n489c9m?=
 =?us-ascii?Q?iq6TSBtDn9/zYbme5W3RI3x+BaCbbC93lKaaSvaCntgaFxi2Pwe3QgDVUOPI?=
 =?us-ascii?Q?F98ZdbT8p3NBUWWGEaRxfN6xyU++81hbuE+YVA4/Ao5QrL4tbW6m//Jf3xYN?=
 =?us-ascii?Q?2O5uEwcvxoN18NqpGCG5+ism7JJmt7FHIeY4Vr+sKeevqgQSqXq8seQvmQBg?=
 =?us-ascii?Q?YHIiq1ao+KtL59EHFRaKhvcB9yTqjVKQCGBXBOqxGjtSibBY0wxvG76W2eCz?=
 =?us-ascii?Q?II1vawh4ftZsgdzrEYnR2mQx3Oj8U9YjrgvowCTnBbpAuILaHg3TnEPOez5m?=
 =?us-ascii?Q?kHdpFJ/fLFyfkrJP2YISKi4EA/YK8JJmIIJeAX3riiHw+ZZNRHdv2qkHDDVM?=
 =?us-ascii?Q?U2FlQLYrxxH92Ph3qiSwweQh10Ci6Qpc2XBDx50bJUWzzfh/HLM17n1vgV/t?=
 =?us-ascii?Q?V1j1F2v2uEFNfQxLxaXBbw/nx+lZL6KZVaEMASCYSDmd0wGIzmvQ1nz/TCM9?=
 =?us-ascii?Q?Bg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9785d0dc-13a9-4f76-32a5-08dad9ac8dac
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1463.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 06:13:56.8477
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rhmr1OjBaF0mXqeBadslQqmHo4h/XeWD75PbWVjfdRaSJAitZSFiGyswoqm8mnHtgLBCE5fobUfRn7lhUFN5pcrnAu6hHZUw6JY/OLtwhuw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5066
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_02,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212090053
X-Proofpoint-ORIG-GUID: Lqy0_HhXZJpGInfKu6t7X78LTggTNMJ9
X-Proofpoint-GUID: Lqy0_HhXZJpGInfKu6t7X78LTggTNMJ9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute is going to be removed. Convert cxlflash to
use scsi_execute_args/cmd.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/cxlflash/superpipe.c | 34 ++++++++++++++++---------------
 drivers/scsi/cxlflash/vlun.c      | 32 ++++++++++++++---------------
 2 files changed, 34 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index df0ebabbf387..e34a129b4f87 100644
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
+ * in scsi_execute_args(), the EEH handler will attempt to recover. As part of
+ * the recovery, the handler drains all currently running ioctls, waiting until
+ * they have completed before proceeding with a reset. As this routine is used
+ * on the ioctl path, this can create a condition where the EEH handler becomes
+ * stuck, infinitely waiting for this ioctl thread. To avoid this behavior,
+ * temporarily unmark this thread as an ioctl thread by releasing the ioctl
+ * read semaphore. This will allow the EEH handler to proceed with a recovery
+ * while this thread is still running. Once the scsi_execute_args() returns,
+ * reacquire the ioctl read semaphore and check the adapter state in case it
+ * changed while inside of scsi_execute_args(). The state check will wait if the
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
+	result = scsi_execute_args(sdev, scsi_cmd, REQ_OP_DRV_IN, cmd_buf,
+				   CMD_BUFSIZE, to, CMD_RETRIES, exec_args);
 	down_read(&cfg->ioctl_rwsem);
 	rc = check_state(cfg);
 	if (rc) {
diff --git a/drivers/scsi/cxlflash/vlun.c b/drivers/scsi/cxlflash/vlun.c
index 5c74dc7c2288..c6c72e470985 100644
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
+					  CMD_RETRIES);
 		down_read(&cfg->ioctl_rwsem);
 		rc = check_state(cfg);
 		if (rc) {
-- 
2.25.1

