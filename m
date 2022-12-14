Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C55A5C10F31
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Dec 2022 23:50:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiLNXuX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Dec 2022 18:50:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiLNXuT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2022 18:50:19 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8DBE37224
        for <linux-scsi@vger.kernel.org>; Wed, 14 Dec 2022 15:50:18 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BEMwhII024225;
        Wed, 14 Dec 2022 23:50:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=2tFmdTKPwf/YIm4FvpBFQ36XRGVs1Ba8812i1m3ldCA=;
 b=eH6cgIWZTSkcdMHqmbsP8zPLKzUzwPnsdVPd0W04OutfOoxOIDEbgurMRpOYXEq5oBk+
 Bf6vOk0s8MVeyb881DSyF6CtnS+Ohh2zfaGJU3Oor7AgxsNoxUz8jq4EBszcBAAam0FQ
 Bkmv27kOmyaI5xY2VvlXzPX+sXBy5m23Q2lPYPB/Bcah4TF6l9l/wfaTYvgf9SWNo1fm
 x/JakKA4O74XsUGFuIGwWAfjstw8KBLyNxXjxVCaN++uwY0tttYnoRJh4b03lhzwnU4m
 Vy814Q3K3e3F4CfJU81G1ZEPAQ72WXJfs4MJX71Gk96jzvRhJXmd8W+lDT6cp0t+Wzyg Hg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyeu3r14-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 23:50:10 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BEMYoet025161;
        Wed, 14 Dec 2022 23:50:09 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3meyen35h5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 23:50:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V7852c2roC0HYlT2lNU0yqJ9x0+k/bviuEeGz6u2BCbl1wISZdt891wlNUI1R+C5xx+PnT9gNYnafX9+dUW91Zx6NetSXNYWHKSfAOSr90u9RBtGlfUU5fON3au4dg+tenT0KmqUs/mv19+THarip7zI5NA+piKKaK93UnsQAu/LIv5PX3xWI7Ch2IZ7PfpQ9VOaYfmZX786KrupWyL6kexZp+0byJ79PWQTPl4FjEHDblnjV1QzpHDWUk/2frZWOH2cqAqT84gUwuYUV6/hTPNw6v71kghGSMArwYcw8ijNSF0J/UQm7egt+HhXTH5fylNTBzgpuiskKDL8bcji9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2tFmdTKPwf/YIm4FvpBFQ36XRGVs1Ba8812i1m3ldCA=;
 b=fZZfagOazKT6+svr+AIS6lbcL0f7gNDDcIhVZxB8fn9XbywnJZ5rutbjR6gejKs8jQvo9A1IQSphLMRLXlUjOZvwlkjlBRkccTiLkL9peIITQBlVx4k7r6mXSiPEXeX63gfUHgs6csL2NuyVNxJBienOs7dJwqyNf+ZnWNj/p7fnLqpiYv4r2GbwzLN88IrrXskkg5aa7f/s9Uz1qn7L5egMRQ8SsZzviHZxmCB6L+187JcUwHn9y7rbgtDULAAFuZQJNjVIx6xXEhGv2u+BHNoWeswYgrT37K/6v8ZpvPGj7HSWlqXpekZRJVu5OwyxbsjnC3nyUxUdSfWZTzkHmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2tFmdTKPwf/YIm4FvpBFQ36XRGVs1Ba8812i1m3ldCA=;
 b=OVt/79diGm9ugFVmTScPnMFW+tDSkptfIIkqXOA8syArt/l1B9my2Lw0BNRpb+ktsalCjJQN9x5hH+I7pW9AhGb6UIHaweFVGP0iEvTxZTwpro9l3tHUlmGs7EOZCinmOdMh+SVIwembzHIuhH39ds92JrRWIubsG4ZDwow5c5g=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB6800.namprd10.prod.outlook.com (2603:10b6:8:13b::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.19; Wed, 14 Dec 2022 23:50:07 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%4]) with mapi id 15.20.5924.011; Wed, 14 Dec 2022
 23:50:07 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH v3 02/15] ata: libata-scsi: Convert to scsi_execute_cmd
Date:   Wed, 14 Dec 2022 17:49:48 -0600
Message-Id: <20221214235001.57267-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221214235001.57267-1-michael.christie@oracle.com>
References: <20221214235001.57267-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR05CA0055.namprd05.prod.outlook.com
 (2603:10b6:610:38::32) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB6800:EE_
X-MS-Office365-Filtering-Correlation-Id: ea5c461c-9bbd-49d5-ec61-08dade2dedee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g29BT9c9+/P+zOjdYn0cHR/60wY2ngmFXfIauudAc4frexh1VZjj6MRXzkEzusjySBQW34c13bH1Jdb9fN0iWUFXccm/6qNNiVBg4fEZ79xAE43v6lj5e0XQ1IbdcuBcg8jTrYNdKlF4ThXVcjeYbFJoiH8nbZFJx0OJqw7jcnayli/qSOYk1ehuSJAPEkoyqXXIWWgnwW4ozDoIprvYhVBsaEsrNMqVcF2KmkBAaPI3Ay1XWyzqL4Mg+Ds2+00d8dsPbTMvf8qZOsosYdJDeC2WdEhTyUzDXyBFEVeo5D7qCL0Ywh42IcVGyWNqUjvIyKhUg0zckW2Om9dohhdL7jn9yKuBhw1d+U+7FpKXkZ0I4A4hgS5CdCJux1ZAhGt+blcXNNCukhCX0+mcdwRjLYVWJCAzzV968820KtGmclMuRPiYi7lK9KBu4KTgFwktckAev9hcvngK1XJcpbXUnSeOEiOfeeV3ng6CJUUYLudnVdswXOQT4EOvo0WEZV3dv5OUfcHGHfA+wllL3WHTYDR1nVcmHf1DNErvZFfEpa2Lj/4i9q/Wxi0uc/q+byLH7vp6hgq66X4XwpwFSczsukOzt2GAfavBBObxl9ZGg7NyTRpWmur9nzr24BIDtGkHFzhzxd9V0hO4WthfD6OfMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(39860400002)(366004)(396003)(346002)(451199015)(5660300002)(36756003)(2906002)(66476007)(66556008)(86362001)(316002)(2616005)(478600001)(83380400001)(54906003)(4326008)(6486002)(38100700002)(1076003)(26005)(41300700001)(8936002)(8676002)(6512007)(6666004)(6506007)(186003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8RB3uPu+4MMtcM6Gx+c4rvj/VyjGhy3QL/nWHLp/vB7IPu04IpDfkBwOzdre?=
 =?us-ascii?Q?kMcwc6tQoRSQeDOo+RNik79uTZ2cyiQqX9DVZ03SfbhT7tJH4HmpaUVwwUwW?=
 =?us-ascii?Q?JR1iZSK/tYStLhSom7B5AFAC5DO7tra3j8/YnMue/OyE5nInSvr4cq6M3wGX?=
 =?us-ascii?Q?6f/0XFymSnqo0qsJ0CSA7bLUmoDMeErIctGQvO7ByxTOiSpujCKIaTAl5Dp0?=
 =?us-ascii?Q?581f7tEBaSvnT/K/g8ICZDV/vAPzXmmkWNisph8r+w91TCJvtA60YjG328ma?=
 =?us-ascii?Q?crIkMgBAj5+PoVyxaofAzZ1l5B/ROrxV6puCSed7UIOe3EenV5PmkuqpMKfB?=
 =?us-ascii?Q?tCb2EO9WI3GKUAmWflEO+nqVYCs3hiWiRX0ITjuHdi0sCn0DtrTe3QkbuHIj?=
 =?us-ascii?Q?pGXjYw1zq/bjSnVbZNujrvNm9oHitckgyhmxRwMQp0dcTKbnsGahD/4Z13Ue?=
 =?us-ascii?Q?hgTbkZZs1czPmk6cOGDhf/jh2Lgy7MOTWplAXX0eLGEKtKM/qnA0tc7BjQdv?=
 =?us-ascii?Q?+KWs5dHCchHXa1qQO9jFkOV2K9S5yvl2y7ipNsl3UxwaJgRkqqum+tb5lKF7?=
 =?us-ascii?Q?XHdi8RecHzy0CCCA/j5Xkh2GbqDC2ToIvzMQIyTZFF0GNxj4c6ZtjZ6HGz3P?=
 =?us-ascii?Q?6/wOOq6/QW42KIJQcY2e9BPh1ac935UG7tzZy2gKA6KCzEtZm+x7qH3tBthk?=
 =?us-ascii?Q?MLs3GiGkgXz1RoV71zWtEcAeNJLEGwaLGThGL/UQNmdIz5XMykY2E26CuG/k?=
 =?us-ascii?Q?wkYcmLuQqWpsUEwuQ1g3l8e+7Sig0zBOhn3VLGUwD4SJIh9Y3gIqFInx2+vI?=
 =?us-ascii?Q?WJzHA2A143ZZLHDe2tPmK/UgUhdYw5ANeK3A6PCetY/B6EyWWCQBuk1Kqr2p?=
 =?us-ascii?Q?FSUqt+vd5qayr1X09D4/BTnYvgLM/JRAhD0jnMCWjKyGmOeGTuRuGm6B3Ozq?=
 =?us-ascii?Q?vfJyZNE6V9Z6yYEzkl0+TkLMoWNqzat3pSgraRtkNn1c1RWW6fDFYMybJKBj?=
 =?us-ascii?Q?/2aGsfjFRFS66H25IYqF8J055ozvrJKVHDnaTjvIWyq1NOwSPcrSOQiz9KAx?=
 =?us-ascii?Q?Ox5dA1QExJruRmVf68oay2scyjzuqzhMjisvH9meEs8oF/tNawVoVvyXXJz7?=
 =?us-ascii?Q?lsjILHlW6Cu5wKIgD2+/TbjtA12j+PFAfI89Wb5ThX2ac4RtRfgoCR+pQnzt?=
 =?us-ascii?Q?vVa0zFaMjUfyjBij/Loc0/NExItfBecw72d28r0YAwf/eJUWXE3FMvMhAwbX?=
 =?us-ascii?Q?qhUiO7ophGZEZe7jQwOI4i6YMeSj3be0RtYNrmMBYBj2eu/X22H3us73WkRY?=
 =?us-ascii?Q?MuEzKi9imn4lbsBrcZIyoK2hdQJJhRQz02BSUFdXBrUD4jlln1sMU2TjKDED?=
 =?us-ascii?Q?P05WdHg9Y49WGqwHq4L+KGNHNrHB9GagasavtqQ6LBhZ+Z0t9mtDYh81x+PW?=
 =?us-ascii?Q?RlyN67wuBt7WPTUGi4SLpnzsZL9a6JI1abmCKzE4qlrpYMgBcD0AdYxw+xZB?=
 =?us-ascii?Q?1K7XOXc9TsqJk3ZH1LvKpx83PJkNN8cGZ+1DGz6JMyDoepALpca4AIWo3MFG?=
 =?us-ascii?Q?/bzeQi+bOy5M/ErVXXmOXIDkOgGOyA3q9D58d0IrC29uHXGr7HcSEzaFaYr7?=
 =?us-ascii?Q?RQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea5c461c-9bbd-49d5-ec61-08dade2dedee
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 23:50:07.4349
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GfErKFZ/D5wrLj9AQUC1sW9EF4zFw7zol/LHUKZ3laF7PC3ZzsUcbsCxpdnqgOXG4kRxkFLlB+rP5WDpJ5MPZ/b1HcnrxneNlqmaY8DpuHU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6800
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_11,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212140196
X-Proofpoint-ORIG-GUID: fYZwYfwAz-UhvexObbdzVACOcC-9Z51l
X-Proofpoint-GUID: fYZwYfwAz-UhvexObbdzVACOcC-9Z51l
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute_req is going to be removed. Convert libata to
scsi_execute_cmd.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/ata/libata-scsi.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 06a3d95ed8f9..d143d80b1f03 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -367,8 +367,12 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
 	u8 scsi_cmd[MAX_COMMAND_SIZE];
 	u8 args[4], *argbuf = NULL;
 	int argsize = 0;
-	enum dma_data_direction data_dir;
 	struct scsi_sense_hdr sshdr;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+		.sense = sensebuf,
+		.sense_len = sizeof(sensebuf),
+	};
 	int cmd_result;
 
 	if (arg == NULL)
@@ -391,11 +395,9 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
 		scsi_cmd[1]  = (4 << 1); /* PIO Data-in */
 		scsi_cmd[2]  = 0x0e;     /* no off.line or cc, read from dev,
 					    block count in sector count field */
-		data_dir = DMA_FROM_DEVICE;
 	} else {
 		scsi_cmd[1]  = (3 << 1); /* Non-data */
 		scsi_cmd[2]  = 0x20;     /* cc but no off.line or data xfer */
-		data_dir = DMA_NONE;
 	}
 
 	scsi_cmd[0] = ATA_16;
@@ -413,9 +415,8 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
 
 	/* Good values for timeout and retries?  Values below
 	   from scsi_ioctl_send_command() for default case... */
-	cmd_result = scsi_execute(scsidev, scsi_cmd, data_dir, argbuf, argsize,
-				  sensebuf, &sshdr, (10*HZ), 5, 0, 0, NULL);
-
+	cmd_result = scsi_execute_cmd(scsidev, scsi_cmd, REQ_OP_DRV_IN, argbuf,
+				      argsize, 10 * HZ, 5, &exec_args);
 	if (cmd_result < 0) {
 		rc = cmd_result;
 		goto error;
@@ -475,6 +476,11 @@ int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg)
 	u8 args[7];
 	struct scsi_sense_hdr sshdr;
 	int cmd_result;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+		.sense = sensebuf,
+		.sense_len = sizeof(sensebuf),
+	};
 
 	if (arg == NULL)
 		return -EINVAL;
@@ -497,9 +503,8 @@ int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg)
 
 	/* Good values for timeout and retries?  Values below
 	   from scsi_ioctl_send_command() for default case... */
-	cmd_result = scsi_execute(scsidev, scsi_cmd, DMA_NONE, NULL, 0,
-				sensebuf, &sshdr, (10*HZ), 5, 0, 0, NULL);
-
+	cmd_result = scsi_execute_cmd(scsidev, scsi_cmd, REQ_OP_DRV_IN, NULL,
+				      0, 10 * HZ, 5, &exec_args);
 	if (cmd_result < 0) {
 		rc = cmd_result;
 		goto error;
-- 
2.25.1

