Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD0F3C433E6
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 04:48:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8960F64E92
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 04:48:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbhBGEsV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 6 Feb 2021 23:48:21 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:38684 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbhBGEr3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Feb 2021 23:47:29 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1174js3J168228;
        Sun, 7 Feb 2021 04:46:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=S/2UGkixiZtBVS3dPLVmX3uuS/lusXXb171MjXJHbCQ=;
 b=so5a0OHeePNmE28WSoEmgN08vAMBqiXLBAszcWptCrVIgpGa611iv0R1Ijl94rJm5bQZ
 n/rdI8pufBO09QNV20ERjMG+EJg09DeFzgPghJMcxK85B26H0qYmurUUdW8x6lxI1k7e
 5eMULXL4fZi6ZKydFKwWZ8XWL0uf9mMJEWOLjj9Tf1fUxPHVtIT2xyzmz8tFM96DjQml
 ZWBCB6yiJqHdP/j460kgDtG7J3vwXEoVg5IGrP0KE3/9i8dyhzLsWDsOeI2GD0E/JX+3
 DYIwaZTTgUzF2CUdXu++8LrjLohqDil4s2Pnxe7FjeeEki7qz30VSMHTDUdYQ5SEmipQ Eg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 36hgma9fny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Feb 2021 04:46:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1174inaM004118;
        Sun, 7 Feb 2021 04:46:31 GMT
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2058.outbound.protection.outlook.com [104.47.38.58])
        by userp3030.oracle.com with ESMTP id 36j51tcp26-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Feb 2021 04:46:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R09qbYwXVsf+OVFEpVKZYElp5cv4BrdmAhlYl7uipc9OMviECg6bZv7OB3T2RLNc46B6Bh17YE1UgjU4wavZSG1kYreHbL/yNXZ2IJ8AUZOv3aaqrTOPyqh49UDjyBpaYYUQGVNzHIogSOQoqFNdu6BJCHFNHYnsa7dx6GrADXiidvkB/ZTQft+bxkc84vHXIN71X9Y0hEio1niqsag4dQ56i2m2+6HYn5ibMZ8d5iaw/zV/vTfHBVOHGhYdKpRdDdiZpm4K9E6oCWlIlyKvQVM4W5Sgpc2CWg2XBtSB0K9a6dji73QmIPH2tkAr4dlPL4nRQt4q9KmmWZf+Y5/jhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S/2UGkixiZtBVS3dPLVmX3uuS/lusXXb171MjXJHbCQ=;
 b=RbeAC/ZpJYSj6KAUWlGy7p/Wx2nOgXPET5ce+eW5yGnVzz8FEHZ4lhikqVUfADakd/B0/hdy7tLy5SYKA5bD+TLAJjG6i3WXTofa99HQc1Tp+e6tAElF0dCO2+IbIn5dmzatpXO7PTQQdDeHy9yFrIOcPJ23qQhq/DEvVd1zgkpq1K2efh+b870hM/5Vi15aywFGRUs9MskeRY5Xp+aiaGP93faWRz8v5L3iYwrUMynLz8uAM7ezkKYY8qeI5vqjyc29Mv1ji6Xrma4cnal7RfRYBVzqYfwi90XSLh2K2oW1Tb3/7RKVgJ/8XoNhBQiuZEDbQvhIZ3hiycDRz7SLZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S/2UGkixiZtBVS3dPLVmX3uuS/lusXXb171MjXJHbCQ=;
 b=acbklflbvdfB1oRmnLBqvmfwEd25/TCnfT6r4lrSOp8nlOMr18Qq5RYWROzmWS5XaYlVrGZc6mMKMfROEblEBX5qt57YuYhbwaOc+IeZkEheW1lkdAT4cjlabCsP91NtmlkG0D4LAbBS/HaKMPROwBAZ17KtXD4zsMnfXMWIEwE=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3429.namprd10.prod.outlook.com (2603:10b6:a03:81::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Sun, 7 Feb
 2021 04:46:29 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Sun, 7 Feb 2021
 04:46:29 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 6/9] iscsi_tcp: fix shost can_queue initialization
Date:   Sat,  6 Feb 2021 22:46:05 -0600
Message-Id: <20210207044608.27585-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210207044608.27585-1-michael.christie@oracle.com>
References: <20210207044608.27585-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR20CA0009.namprd20.prod.outlook.com
 (2603:10b6:610:58::19) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR20CA0009.namprd20.prod.outlook.com (2603:10b6:610:58::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Sun, 7 Feb 2021 04:46:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f249bf2b-4ba6-489a-9a38-08d8cb235581
X-MS-TrafficTypeDiagnostic: BYAPR10MB3429:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB34299CF8D47C9895DEC3FF53F1B09@BYAPR10MB3429.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bv4IBcedtXyfPARUAHYnybtA/BkPXFl6eFBPzLIHbqyprfV1OVldRS65S1YXtGhRDBUnjAPh0ypMb7x50dcO851DsxsXAkAhJsLbT+orVZlP6Dc1eOBEFisVNJDftk1b08Ukv7csPQQIDE2I9bNOol3rPJNjRNapARXXdZiXXc/x7W86lneq8SzCuYvwcL51FSOcV6Tvhu99yvAbEMIJCNSo+VDi+BUsY6eTqt/pRW4mgE5aPq6q/EraclwYx1SV5QKOGHwLAFZZrs8BkuUilCR4L7sogKEW4rrNEB42cvP4CrK+fY0dVy/UtJuJ5sbhy4ERmqeFBBo1fZik8O/eT+vVR8oWStSMPAwG5cEcVrYsX/TQE4ESk62cYbcVvnY3cciTu/linMJc2diG39FDuSfORM5Kw0e8q1c+AaS6geyLOedtZV6KpXXKDuK1VgTT0eYi8ai9ZQmmdgFj6fjf7vOkKFhkeABMHI7UDoXOSQtN8/EBwveDnXdZDWxXynVjh2k+ziISV1NnqTw4o/gG/DckV3SX24lFFrnR2qyljoIwewpei2UZ2s4LyWKfyHE02mVkV7yMjHRxbBtapC4s9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(396003)(376002)(346002)(136003)(1076003)(6666004)(316002)(956004)(2616005)(5660300002)(66946007)(66476007)(66556008)(6486002)(69590400011)(83380400001)(86362001)(36756003)(52116002)(107886003)(6512007)(26005)(478600001)(8676002)(2906002)(8936002)(16526019)(186003)(4326008)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?9AITIo62H2jbKCzTzLvhbkJP38FIkA3hXPEIaR43eiTPQSJLyuVdAqvcAJW8?=
 =?us-ascii?Q?P299pbwAvoMtah/MDcfQ5ocMSTQgiadY1m9wRGz0VZob32od2uoSVBLCk3jY?=
 =?us-ascii?Q?ERV4aZdM+T9LQ0iQjNc7FNIQrJDmUqLDcDF/phMFoeR0z1Pp2bFR9rRrn0TO?=
 =?us-ascii?Q?FJchb0CGkF+zbjFcQmot2YZEMvdbal1eLP7JlTSf6BbvxD74gJubTOE0/yge?=
 =?us-ascii?Q?nt2Y5FkyFmix8AP7EXa5R2+JrVkLT6R21ljElKpfRGdsxCng4owVlC01GNek?=
 =?us-ascii?Q?IP/pVltI8E2fq1F54sneshhMqoh7HA/pgYW56llxNwtAecrZd1yr5gW2FoPY?=
 =?us-ascii?Q?jzWS6HW/fPHUVYEVy+TVd/F+3diITszYTwz9NMeW0I1pclnwAeY1Zql93Kpz?=
 =?us-ascii?Q?h566IBYVhLgKPGFD6s7YAJldtLI1joCPQA21gBDXOVtyOKgcErF0wjv7/TV5?=
 =?us-ascii?Q?A5Q/zHBA/1FZqYwAlKM6KVUKYTjOee4JfhazS/t/l7pP/Zn2YDOO57LL/8f5?=
 =?us-ascii?Q?lTnd8MXF/Gwxfe7g0rQI8kwfYFzP3elVbWab2E8DQSdNnbMETP1fTZqpf0J7?=
 =?us-ascii?Q?p2t1f89SZ44M3AqVux+xALjXBdhC83690VCGqTqbr4DL1SVD0c6zAZWzIrBy?=
 =?us-ascii?Q?k5mG9DVN49IDk6yorurx+einJ+63gtq71WU5G9HqWaXsC5EfsjRE/p3w57aR?=
 =?us-ascii?Q?PKZRzoo/nivkm5aGcpt43+HgFSS2sO8fs8ygJGLjOENqoG/gQbwldo9/vpqo?=
 =?us-ascii?Q?gpuhKwZxKBzvCBWHLdEtOnCUzJJ/sHanJXaNgyD9Z0dwAnkEDOYotg0O8Ky3?=
 =?us-ascii?Q?3ZRkyG6OZl0WCyUQqgbgw13NI7v/17bAvJmW8ZDy0NcvBQY30sI4gPLI5qUl?=
 =?us-ascii?Q?9B2KrZwvlq4g10A4+zcCobJqBVhQ8muOvfn9e33hNC/JeMDb8mAkSMK37mzI?=
 =?us-ascii?Q?9xOjQMXd7ZY0oHgh1sIAJIYhl2NfDg1D4TdK5dRUgy79hCXFP+fu64Cx3KF5?=
 =?us-ascii?Q?NeNgWXH6Yw3D55JUVuY6Lt8Z1LAKtimGKI5aWNp5GNcIdmMgegtv0GfGOARS?=
 =?us-ascii?Q?G1HW64dVIvDpW682ERL+VqsGSxrFxgXC7AVTOBGxNTFE96Y88uENnfeN+LHA?=
 =?us-ascii?Q?dePz4OgDnfg3U3BGGtZPx76rLrQYvTMpXQWzH0LlHyENyva5n5SRxbqhRvZ/?=
 =?us-ascii?Q?HtXjbo3JOUXFAc39TdyRpr4mEe+ToIcqROG8TUpdxjx6xFlBjY9E637gKGoz?=
 =?us-ascii?Q?J6RlTD27kK7GGIWNXp5nWCDx/MwcZe4IeO7qdQakfZci27inrwDrtI7lH61M?=
 =?us-ascii?Q?O/qfelrnpZiUhIMFHKYc2uF3?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f249bf2b-4ba6-489a-9a38-08d8cb235581
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2021 04:46:29.3794
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2VhgOhZkNviGZCnDU4/FaMPoCEMtrya1t0AggnPWopAKvz+Sk+obt7k4rNOF5AINIQOZCPo5ovweNPFMFylhsf5Yw9VH/ZZD+ZhcavWYMBY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3429
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9887 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102070033
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9887 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 impostorscore=0
 suspectscore=0 mlxscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102070033
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We are setting the shost's can_queue after we add the host which is
too late, because scsi-ml will have allocated the tag set based on
the can_queue value at that time. This patch has us use the
iscsi_host_get_max_scsi_cmds helper to figure out the number of
scsi cmds.

It also fixes up the template can_queue so it reflects the max scsi
cmds we can support like how other drivers work.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/iscsi_tcp.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index a9ce6298b935..dd33ce0e3737 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -847,6 +847,7 @@ iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
 	struct iscsi_session *session;
 	struct iscsi_sw_tcp_host *tcp_sw_host;
 	struct Scsi_Host *shost;
+	int rc;
 
 	if (ep) {
 		printk(KERN_ERR "iscsi_tcp: invalid ep %p.\n", ep);
@@ -864,6 +865,11 @@ iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
 	shost->max_channel = 0;
 	shost->max_cmd_len = SCSI_MAX_VARLEN_CDB_SIZE;
 
+	rc = iscsi_host_get_max_scsi_cmds(shost, cmds_max);
+	if (rc < 0)
+		goto free_host;
+	shost->can_queue = rc;
+
 	if (iscsi_host_add(shost, NULL))
 		goto free_host;
 
@@ -878,7 +884,6 @@ iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
 	tcp_sw_host = iscsi_host_priv(shost);
 	tcp_sw_host->session = session;
 
-	shost->can_queue = session->scsi_cmds_max;
 	if (iscsi_tcp_r2tpool_alloc(session))
 		goto remove_session;
 	return cls_session;
@@ -981,7 +986,7 @@ static struct scsi_host_template iscsi_sw_tcp_sht = {
 	.name			= "iSCSI Initiator over TCP/IP",
 	.queuecommand           = iscsi_queuecommand,
 	.change_queue_depth	= scsi_change_queue_depth,
-	.can_queue		= ISCSI_DEF_XMIT_CMDS_MAX - 1,
+	.can_queue		= ISCSI_TOTAL_CMDS_MAX,
 	.sg_tablesize		= 4096,
 	.max_sectors		= 0xFFFF,
 	.cmd_per_lun		= ISCSI_DEF_CMD_PER_LUN,
-- 
2.25.1

