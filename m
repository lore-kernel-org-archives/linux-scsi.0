Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46A8CC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 04:31:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1896F6112D
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 04:31:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbhJFEdi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Oct 2021 00:33:38 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:60486 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229579AbhJFEdh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Oct 2021 00:33:37 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1963VqQL006306;
        Wed, 6 Oct 2021 04:31:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=fFWVYnrL+VlKohtyzm9awOFTPmvsmokJ+dKUuS+pIcE=;
 b=rrnO3mrhI3O35Zg2U6Rba/c6NGODF40/LzDfpBixVjFeTLtDpzm377lkuunYtSDOhEeC
 etXuvD6kStTVB0EJjk/BjeMpIS2QUJfSPn5+BD5/GESasKGK02xEIoe8i5jEFO4fRpen
 sOvdxTcLjpfQtybJga8uCygaKz7iuateemnylrCQB6ooyhA7f7kBw4vLbmqI/LfhFkDg
 xrMTeLi/3xl/ZX0tDDf8LvV3RGHzBoluZ+E0mozxAuUE+Te9bZYLhIKbB6++soY6iQn7
 GwIvUdbFaQJOhD6l92wYgs+HiQrBU8HGTBj2ZHzuvYFMjDzJLrwo02dSGQsefkwCUAfg Bg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bh24h0n8v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Oct 2021 04:31:33 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1964U0FI156033;
        Wed, 6 Oct 2021 04:31:32 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by aserp3030.oracle.com with ESMTP id 3bev7u93ex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Oct 2021 04:31:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P7H2pxUhvgRlEAn2ogjjnjPVuVqQy2CNbbPmQuxn4tdD7oI/YbCpgdYenqjEqcbDK08SoIMOz/AAvEyna/JS2QlMOFwWQCPbK8UXa03YpVYnieFKJAWlyPpXi5w7SsoNLeZTYYwGe+W2M0E8x4XpPx5rFg31rgxw2LZsEeqJezC3MBwm2v1mhn72iNlnLhOfgQS241V9nCB0I2pX/pgqK8ROhNKObidfJEtRRYgLPYXaMokJD8t5c2qxnYzGtQ4zgax2Q4w+QTMlwgAeMVQG6Zx+91+51rXSK8/ov9o1tiaidZfRDj/siQlTqkRmSRvB2nvRjr/9oORZlLVLirJAew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fFWVYnrL+VlKohtyzm9awOFTPmvsmokJ+dKUuS+pIcE=;
 b=ZKgqKJY7wak1o6D/RMowOKCpq0SP7BNR2VztlGEQl1f7hJwYjEN3cbXA1P4aSLyl4DKsFopmSQYEMqVecvs8Eki5VkTEb1qXUrbcdbr5kDsLCkq3E7Wk4TLfHEEV7SMTbtEnK2nA4c/QOTsa4E0muMqR2O69z8HKEBrtZ7wqgt8O0oknhVvARcy17OH1zTLDuCXPq/SQk7J5PyDpoLn7Ass7LTj8/GA6yW0h6oog/GpRzAB+Jvh2jOHm7UPuiW94p7QQPKosGYKkch25ejACDxOIA1wjvdpgCOecj21viYQe9uqRQBYry89GpIviHqWi9kH1PaFBEm1OULENQHF9uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fFWVYnrL+VlKohtyzm9awOFTPmvsmokJ+dKUuS+pIcE=;
 b=LVFok9M3V2MlxKb3VEJnb8SnPdwnpIHmLZMGgFUM/5+6Yq7ouohp1cjKk203USMJMHHKsjHKmnM3b/nByxTCoMwo9CfsA83F7GUkWjLMXc6CkOW4JcFjFz/FIl8dEqH6hp1rlLcLezR8EFIDcWsWjPxCAN5YeAWJifOpctZOjm8=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB3033.namprd10.prod.outlook.com (2603:10b6:5:6d::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4566.15; Wed, 6 Oct 2021 04:31:25 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4566.022; Wed, 6 Oct 2021
 04:31:25 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lijinlin3@huawei.com, qiulaibin@huawei.com, bvanassche@acm.org,
        wubo40@huawei.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 1/1] scsi: fix hang when device state is set via sysfs
Date:   Tue,  5 Oct 2021 23:31:17 -0500
Message-Id: <20211006043117.11121-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR16CA0048.namprd16.prod.outlook.com
 (2603:10b6:4:15::34) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from localhost.localdomain (73.88.28.6) by DM5PR16CA0048.namprd16.prod.outlook.com (2603:10b6:4:15::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.20 via Frontend Transport; Wed, 6 Oct 2021 04:31:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 660a8577-c531-4868-71ab-08d988822814
X-MS-TrafficTypeDiagnostic: DM6PR10MB3033:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB303394BF99F116C269C2B971F1B09@DM6PR10MB3033.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:595;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R6PvkPCuWIt/DOSBaPp2Wi4Pq7S/+744mMqda09ic/dPTJxp147Lt8hQ62lxw/vTby2aAVbOnF50SvOtya514sG1B3KSu/sgtSvyP8aNXZ6aSdguskAfgdT8GwRmegINBvbBgBD772Iuq85hIw0Oa2dhBthjV3q4wO6zCkvy7E/3H/1RpzyKdRQmR72ncizX3t4Lz5VkyM0qjmwIAEGFd+MPw3FWGWye8nzoxmeca+9ZG54cgoPqkugQVU1zcFWFK8jOLLl6ks33jvVzxJSaswnffidw83xkif5tXhepE6kygP9gq49Rej7jlxn3668cizqOdjJYE2/h2rehfSmoj0wSWv2vgpD8pZvz2Vvrf9thAP3E/re8Zd9GsekXecmChqn5FLqAG2dWPg/FS/dC7icHZI8FmjMem4SFzFdldqmgZaGOLkp6A4iGQ9BDkzacX3PAlp8wY/ujT2Y3esqKCRxrJcLaK/0QZ1Fy0eqUyi7lx43LkZw35I0EWbnbgaCF+tzm6Uv4JpDN72FieRhLYxswnGw+rTI/zY42R6699ssIFDoT60vINywvyPJ7zCEN+AmAKDrlGK8jDcsrida5anKFWWBYXJNXtXRZaYE/cM+iViIfWcBBi9buUeJsMG0deRq0qAFIXP1H0g4sVVd3vVsUfzwgIdeqknySP87HNs+UolcCgcPnzy2PaR8iCkMelbrzQqKeA8egqDiCiNDyow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(36756003)(6512007)(66556008)(52116002)(66476007)(66946007)(2906002)(38100700002)(38350700002)(6506007)(8676002)(6486002)(8936002)(83380400001)(26005)(316002)(1076003)(5660300002)(6666004)(107886003)(956004)(186003)(2616005)(86362001)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uXbnpaDWWaLOIwLnqkCDqHy4dhQ74gKGRnqu8P7GVhuFg9w82fp3c4jSeNEW?=
 =?us-ascii?Q?FEoTkXfFCIjrFCRpy0kEWjhGjXRoDRxIHn16IoW67ozdEIpCGfkdsreQin0H?=
 =?us-ascii?Q?rnD85xsQQfNUdjAoXhDi8HpG5Vnz0EhT3bZG4Jpzcjtkd7UvBJDgnKzqr6h/?=
 =?us-ascii?Q?xpKWy4YAkOsbQ5td4yg79DbZ4zmUjdrDUyHXORWctjnSiTyDxk4nNA6ISZBV?=
 =?us-ascii?Q?kqFPN0Ywy7GgQFMo4QFiDP1FM9UyiKgT3IZL1LG+nnkOLxwFsO7+OoF/EtVd?=
 =?us-ascii?Q?mD7A9rbnJ1jUJXl81XufUIe/MBMX5zWVVPLN13e90C/I4+ttVvYdR/7fATc7?=
 =?us-ascii?Q?jwE/KZ56SXaLCBtpPdKFUnVWD7y9Hmd3+KUTRcAke0UIMxdrI5hHOJnuYiW8?=
 =?us-ascii?Q?uHN/0w8nXDJblZWfAvfL+a8lmffn/pUHSGAtIPSSbvEiuvh8MyNj0Wgi+FLU?=
 =?us-ascii?Q?2Yu5sco2pLDP9HN0IAVRHWJmFyIKxnIrYPEigWNxN9D4WuzE1tV7x2ubqJaI?=
 =?us-ascii?Q?F9hjkFyU2J9oGnkNUEsRgEQ3IQSpVDKy2ZgVDkzKc02Z9C8/gYxaACJ5QTs6?=
 =?us-ascii?Q?jWI1OId8QzKUg3YmbDB4+VNQklqjL/ByG8fUhITLB4kB7AxZx/kLpCoqQVT5?=
 =?us-ascii?Q?1VGu/zlJBYm61g3RLtw13h/nYhZIXAx6OybWMIjWAgiAXhyd7ApKMAC7hQKg?=
 =?us-ascii?Q?ve7DbTRzJvqg6mcMTcINemdb4nUepMgCsNwVUBtUWqiVybpld24oSEZuCyfL?=
 =?us-ascii?Q?orUZgKgMOaTRTp/sr27veXCTivDdhVSH0RbwfvSqDjIeVnS/+zqmOqqnbn6M?=
 =?us-ascii?Q?l2Si8f4+ApvvxzkKc10YYjqxv49/ZcRUIIct2w4/RStvKIcakdOm3Ts/g0Gy?=
 =?us-ascii?Q?ntxTQMVFpEexSlPPh0sO4LBSySm2qdRx4FC1QY9Ix6nlxnWv+jNLq1wxQxBc?=
 =?us-ascii?Q?GIKxJvr2/k2YPFomds1ekPjZZK3gs00vmg0ZLoU2OnxEbY60QJgXtcKH2Fe0?=
 =?us-ascii?Q?4vs3FOAIx8cb/5mbviTYrB5E2QwL2W5OrfvEKmyd/zDkfcZxt8t3o/QXwxRB?=
 =?us-ascii?Q?AvWDr4f7GHwjc55+DKX59O1iZcfedeOELHXah6kW5G9+vkw/w04HpRVpEeS3?=
 =?us-ascii?Q?7oDmDhgREBMdXc7kzNz7c4ofu/3TtGrjCTb8l4KX/ibbDlZ2rkzO+gplsT+L?=
 =?us-ascii?Q?s1uCj6LeXR8t/v7lrBzNc1ulOlYMCn/kYdk2zeg6oEJGUJ8LjZebkNh17L5U?=
 =?us-ascii?Q?DdZyRsfp+gPVP56do4+ULDJN5lRkuJlMgusm5F7XdfbkxBM0Hi2KOMxcTUEl?=
 =?us-ascii?Q?v2qFFkVO0MDYvC6nTSFWN68b?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 660a8577-c531-4868-71ab-08d988822814
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2021 04:31:25.2378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rHD8MDUwb5Em6LW6iBTU3Qf0C/au92yAOwKZXACXoRi79zrPvgC8csAhjDibx8VX2UARE6mTwttCgAfzTDYx+RQmJoAMiyKKb/Qgz1Lz5og=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3033
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10128 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110060026
X-Proofpoint-GUID: 2vWK2a0E58VQkgZ9MDbiVJ3bpXJmWgJP
X-Proofpoint-ORIG-GUID: 2vWK2a0E58VQkgZ9MDbiVJ3bpXJmWgJP
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This fixes a regression added with:

commit f0f82e2476f6 ("scsi: core: Fix capacity set to zero after
offlinining device")

The problem is that after iSCSI recovery, iscsid will call into the kernel
to set the dev's state to running, and with that patch we now call
scsi_rescan_device with the state_mutex held. If the scsi error handler
thread is just starting to test the device in scsi_send_eh_cmnd then it's
going to try to grab the state_mutex.

We are then stuck, because when scsi_rescan_device tries to send its IO
scsi_queue_rq calls -> scsi_host_queue_ready -> scsi_host_in_recovery
will return true (the host state is still in recovery) and IO will just be
requeued. scsi_send_eh_cmnd will then never be able to grab the
state_mutex to finish error handling.

This just moves the scsi_rescan_device call to after we drop the
state_mutex.

Fixes: f0f82e2476f6 ("scsi: core: Fix capacity set to zero after
offlinining device")
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_sysfs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 86793259e541..5b63407c3a3f 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -788,6 +788,7 @@ store_state_field(struct device *dev, struct device_attribute *attr,
 	int i, ret;
 	struct scsi_device *sdev = to_scsi_device(dev);
 	enum scsi_device_state state = 0;
+	bool rescan_dev = false;
 
 	for (i = 0; i < ARRAY_SIZE(sdev_states); i++) {
 		const int len = strlen(sdev_states[i].name);
@@ -817,10 +818,13 @@ store_state_field(struct device *dev, struct device_attribute *attr,
 	 */
 	if (ret == 0 && state == SDEV_RUNNING) {
 		blk_mq_run_hw_queues(sdev->request_queue, true);
-		scsi_rescan_device(dev);
+		rescan_dev = true;
 	}
 	mutex_unlock(&sdev->state_mutex);
 
+	if (rescan_dev)
+		scsi_rescan_device(dev);
+
 	return ret == 0 ? count : -EINVAL;
 }
 
-- 
2.25.1

