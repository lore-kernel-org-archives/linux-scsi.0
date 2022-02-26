Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96784C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Feb 2022 23:05:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbiBZXFj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 26 Feb 2022 18:05:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbiBZXFc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 26 Feb 2022 18:05:32 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D1015DDF4
        for <linux-scsi@vger.kernel.org>; Sat, 26 Feb 2022 15:04:57 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21QIIqVx030109;
        Sat, 26 Feb 2022 23:04:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=wYq8uOP3/EwabJNpr1OmCzpMvDmk4s1gK0zncuI5ls0=;
 b=v7EYjkGdDHrSNNawgfnPDGaiJ4kVTi3+5Aab5D8KqT0H4vmKkkciinPl+l1vTOjzqcoz
 HyTrZgruTSFM/A3eZYVWxM3+vWEEawFcw7oNrtVs1DmNZZ9unxTNaLSiBizKz/OFNh82
 umjRqYatc3fYfvsdS5gqacvCBF4cwvuy4HYnTjEPqjtkYJV3tppJxhfUOSFzTORxuLPn
 GiUVyyv1qg1NC7tA4FJeAI3XVREccC+YnNBuVS1aBmchMruo+9zuMqo+FeDLGdJBcGQf
 pJQJ/r4oA7D+Q/Je48lqBXAfCKodDgvALsl6Nin3cOcJ2JEsMw/7VZ8NRBVhPkgwg+hQ cQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3efamc9bkb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Feb 2022 23:04:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21QMtm5J027402;
        Sat, 26 Feb 2022 23:04:49 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by userp3030.oracle.com with ESMTP id 3ef9at5krx-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Feb 2022 23:04:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hcf+cW/1gTPZ1xIZlzheDexqjsRw//f72zrIg8IcS5moLxlaVGc9R9toS3e0vClE7wlbtuAQ+sUFN0FXe27M1yyjdar66NcRz6Xrh6B6FYmKiPNiUUbEq61A77z0tPiGU0C5FwLzkdZFD/ae44y2npGTVVy2kbLunA3d7PpNa+gthK1uRdqKgy3+n3FR1n8jPuwYOPMqX6endWO9jnj81Ht6VLyiUw56f1/hvEHffpTYvAvV4V1pQAsASHIPIWIMwByKb+mXUiBKBP0MY/UwWuqNY9jd0demZHncvSMRsQciSp0/M7gX/BDnpzVvdK75f27tYBIeQJr88U83OlOLAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wYq8uOP3/EwabJNpr1OmCzpMvDmk4s1gK0zncuI5ls0=;
 b=W0cf7F+y9vAI0W+ZbCQq5ukON8kp50pE9V6nHQaWX87hsbwK7OAajJ6o2oASlIzA3Gk1VkHrk6EkkT59uaPhcTK6zxQ8/YTsbWIigYv+qdOXBsoWjOirKtpbKmd5+50QR1oy8ztPc2w/lNp1wt+qx/LhQ7A2vzhUZcHE58setPUSRcw59+6Em4tgf11CzsqQL+xdSbrdmTXD5xA9mlUjQWNJdSrdiEJGIphCGvaHLLy38CxwKcZP/ANxlPsN4cFO7phnyA3w2iJwkKKUlWhUdMoQPntSwVFj4r6kG5W4i/2/tb3BpH/yDkeFXt3jat7bLRmIVQb3W1dT8VvCQMI2uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wYq8uOP3/EwabJNpr1OmCzpMvDmk4s1gK0zncuI5ls0=;
 b=RrNJz8NP5iwtbLKaLf32qE0S+sMHBknhwM3M+p3UXEIaqc+wQh4gE04EpnMi47cwNo+Kbr4O3/G0Cg9vig7pBbk65k0VfAHXCTGGnnN+r+AnbyAYFe5KzKnSoKQGKhF889dzRiU4GB53wcWK72exf+Cs+t2qgHdW41b2+AwOwj4=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MW4PR10MB5750.namprd10.prod.outlook.com (2603:10b6:303:18e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Sat, 26 Feb
 2022 23:04:45 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2%12]) with mapi id 15.20.5017.026; Sat, 26 Feb 2022
 23:04:45 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        mrangankar@marvell.com, njavali@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, lduncan@suse.com,
        cleech@redhat.com, liuzhengyuang521@gmail.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 4/6] scsi: iscsi, ql4: Use per session workqueue for unbinding.
Date:   Sat, 26 Feb 2022 17:04:33 -0600
Message-Id: <20220226230435.38733-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220226230435.38733-1-michael.christie@oracle.com>
References: <20220226230435.38733-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR08CA0048.namprd08.prod.outlook.com
 (2603:10b6:5:1e0::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c015a4bf-4d8c-47e6-8e39-08d9f97c614f
X-MS-TrafficTypeDiagnostic: MW4PR10MB5750:EE_
X-Microsoft-Antispam-PRVS: <MW4PR10MB5750084555DA782E055FA321F13F9@MW4PR10MB5750.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PvRmWMWhj0mbhGp1JakgSJ4+T2QJoUpBgTbMFQT0oPyKx6XtKiwTT+zCQ9aj10gezNKWjqmbnGoAMs2VGHHjNMw+/ApZ3ovWgbV2brlvVYclnmbdb2z7emu/WysA/UUsILZDBqlJMg7hppwZLo/GQezGw5W2fC//VY0i9BhezM0WDIUlaxzA0BMzyxs5xf/oDMagN4DSoAjgWqZH6OgI+saS/2HXBo6qMTTLfvu/I5KHWg/B81uqrqvIw3CIAVb8oWasMYuu2o22QdpaNhDdY6N3jypmYzyMsj/VAdH0A78ay+0U+dWkKfly6zlnBkAoE3qt7FDhtWP/obVWHtREtqw7Bk8lgsAf2bh3kBnjgdBZMG7DRaJpuz9FpztXqXiWRGUGD5x0cWLHDz8nBuUZieMykG3OcD6LB1/AS/Iyz2Ivd5d2N6uL2GyPhNYY9EwWhL0t2mVpQCZnL7qMXGVnjq4g9hNMKKVsV5n+dmn3Yi4DTkKo0NynkcUYPb0J70ShmhVwZL2niDRogtcQXVdz9T7VpjRgN13mx0mu0A9zOKFWMMyfittY8nNutyhxE2Y8wKTd0xFiu0N33JyC+ErQVIfHfyeYIF3lgh0daePrmLVlaFwAy6PBm4BW8abDpD4iu15oNkcyadAWB7fQAnXgO0PUdBmdrhwbt/jDDmNx0T7eP3A2JqzF/vEOX0wAR08RGWfWNyfx5gOyZgwzeHVuVQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(1076003)(107886003)(2906002)(5660300002)(66946007)(4326008)(8676002)(36756003)(186003)(26005)(38350700002)(38100700002)(2616005)(66556008)(66476007)(6666004)(8936002)(6512007)(6486002)(52116002)(6506007)(83380400001)(86362001)(508600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?99qZaRDBsWR4rJm+QPfGeJ8Ioa/lBeWBwpgiBWsMdaZ1T9qAJcEz38m/5+ug?=
 =?us-ascii?Q?M0PiPQMOgVCaolqBdEIWe6dKDiNyMGmr9TpY+AB4bsEmOTuoG66nf9Lkpr5m?=
 =?us-ascii?Q?kdQsGhyW7OW5UJExSfyCO+h+Z0JInOuBexcqLnEKur4NTMM4yrNoFeneYjBt?=
 =?us-ascii?Q?BuDbIwWh53IB2eKRSpqQJQNJpE6j4h7/zq+XigJTvBVUgWnbhjrp3Tw9rzKJ?=
 =?us-ascii?Q?FjeCvnindsiCA8B7fabXQP+TKAidfQtySDTmh1WBGaG/DWgZxlNeQaMk6h1L?=
 =?us-ascii?Q?NAbwU6G15vq1F8ZCHW6P3gP32cwE9t//vUT1l74sZfRJnbHWQ/m9d4uPUBVL?=
 =?us-ascii?Q?JbTyooGgByoIl0Poiq50bCoGb60FUFx/j9F2FJJUhtsxVQnZuLh1GMaGst63?=
 =?us-ascii?Q?HAXEDKL/dz9Q6Ota1SWelyfhZPPKz1rCF6nrwQICRX9yzdm+Y2lxiTr5+02Q?=
 =?us-ascii?Q?elyoFDXIhoX/4YtWNvMzw5A0kWt/JuwhvnQQpuQEfYpnMN+7pG+68oAIqRXm?=
 =?us-ascii?Q?poZDRuiGo6FjEp7l2r6r0bvn9n2OvxcE7KQE+8dXgtBfgdtTnZ0LzIqgNx2J?=
 =?us-ascii?Q?Kp2N1AgaZpVlTZ9mogqP5rFQ0jr7nQlwzVQY1rrHrNOUcnndjeSEh8bJJ1KC?=
 =?us-ascii?Q?fLi2tc6nbL6jatKIhqIrBSZfUGxEwPMUc/DFnnlaVvPliOebq5j+ewRuvFM2?=
 =?us-ascii?Q?c6iuUQ6gsm86EU7TDP8ZRXqMU9UWt4pNYW/LpPdfX4V5EQVZLcM/rLxKw1V4?=
 =?us-ascii?Q?fccufSMbEVqOgmVAI7l07dsIcnEj/udbniNjddCIYKXfl9bYwrCl6ETPA/d4?=
 =?us-ascii?Q?ORlJ+Uz0JOBXXwVaZHW9JE7M03siqRXqihEjVJMtNHS5DlF+ithMdw+HYWmL?=
 =?us-ascii?Q?CAi0f1zzeP5yr/da0OxY7Dlgn2rsFOrhr3Yk/KOvTuJvgnSkDhRHz/D1mkPE?=
 =?us-ascii?Q?vyJghDnezO8sS2JVilMIMfai0nAB1Z/HK07CH/DOoA7UogJFa+7DEVS3fZXW?=
 =?us-ascii?Q?O2f/BrwLeOdA67BuMO2IfIEWI2pVTY+JS2eMCKD9Y9xgaAoQEBXAekZlPVNo?=
 =?us-ascii?Q?1CenLUBg3VjGGPXxux/pZ2224LBoK01aPJFneUubx82TQQYdRGh5bnxYTSu3?=
 =?us-ascii?Q?Ul/04J4wSbs0/6o954VSD+pceVSkQTfbFDGSvJGQJYM1PM2szIxA43ubkYRL?=
 =?us-ascii?Q?Yb6nWYvy2jBx766QqSrod/eiIgyB0FOfmK66B1zfFmPYmyozPAtE8rY7hWSw?=
 =?us-ascii?Q?QRxMR32/GfptlQ2vbT4aec9cACsFZmdsnzK+KHJbNTLaXup0qKsePbwFVlFj?=
 =?us-ascii?Q?MLp7cFmKPmIWH+1DTm/ak7be1PNyFJQafqKVz3TS5CUsQMDOu0MdbGFuDdiy?=
 =?us-ascii?Q?WjLjErMRDmhLUvfunrPmMOoTab+/yd2vWl5utFJzxF5ke34iUtTHZOjve5OV?=
 =?us-ascii?Q?59mcDp9/22rReLF6QcnxibNqDrRpNNpChlzn/pLHKABmCm6wrVuCLctFC9am?=
 =?us-ascii?Q?GB1t87LcZN1xXvTjr4n8DDAj+u53SEN0XM44fXVcwm8GuqxbzCqe4EKnB1Cb?=
 =?us-ascii?Q?OX5hmamVadlRjEPLlJK1JDSgAKBO0ik2sbyLwA65cYZ8yULxGoCkGAPGERyh?=
 =?us-ascii?Q?qrD6FUJ47EYSxg9GD89Lyq6qKHrftNMJdUyiLEBy/ONYIOhjVjet13Z8ehQY?=
 =?us-ascii?Q?q6txnw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c015a4bf-4d8c-47e6-8e39-08d9f97c614f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2022 23:04:45.4750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2xcXMrIsZdqzvaphJ3gBSxp4ywJzg+SjuxCFLT9q5d/dmhNTKZ4DGmVDVSzsNcH+l10pl3X+EBg2Di8iCc41TSItxWAro6BVAW+Rd/DgoK8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5750
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10270 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202260163
X-Proofpoint-ORIG-GUID: f0QiO9GEokEzMYJLEuRNOa_NwhHCE-oz
X-Proofpoint-GUID: f0QiO9GEokEzMYJLEuRNOa_NwhHCE-oz
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We currently allocate a workqueue per host and only use it for removing
the target. For the session per host case we could be using this workqueue
to be able to do recoveries (block, unblock, timeout handling) in
parallel. To also allow offload drivers to do their session recoveries in
parallel, this drops the per host workqueue and replaces it with a per
session one.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qla4xxx/ql4_os.c       |  2 +-
 drivers/scsi/scsi_transport_iscsi.c | 19 ++++++++++++++-----
 include/scsi/scsi_transport_iscsi.h |  2 ++
 3 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 0ae936d839f1..955d8cb675f1 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -5096,7 +5096,7 @@ int qla4xxx_unblock_flash_ddb(struct iscsi_cls_session *cls_session)
 		ql4_printk(KERN_INFO, ha, "scsi%ld: %s: ddb[%d]"
 			   " start scan\n", ha->host_no, __func__,
 			   ddb_entry->fw_ddb_index);
-		scsi_queue_work(ha->host, &ddb_entry->sess->scan_work);
+		queue_work(ddb_entry->sess->workq, &ddb_entry->sess->scan_work);
 	}
 	return QLA_SUCCESS;
 }
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 05cd4bca979e..ecb592a70e03 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2032,19 +2032,27 @@ EXPORT_SYMBOL_GPL(iscsi_alloc_session);
 
 int iscsi_add_session(struct iscsi_cls_session *session, unsigned int target_id)
 {
+	struct Scsi_Host *shost = iscsi_session_to_shost(session);
 	unsigned long flags;
 	int id = 0;
 	int err;
 
 	session->sid = atomic_add_return(1, &iscsi_session_nr);
 
+	session->workq = alloc_workqueue("iscsi_ctrl_%d:%d",
+			WQ_SYSFS | WQ_MEM_RECLAIM | WQ_UNBOUND, 0,
+			shost->host_no, session->sid);
+	if (!session->workq)
+		return -ENOMEM;
+
 	if (target_id == ISCSI_MAX_TARGET) {
 		id = ida_simple_get(&iscsi_sess_ida, 0, 0, GFP_KERNEL);
 
 		if (id < 0) {
 			iscsi_cls_session_printk(KERN_ERR, session,
 					"Failure in Target ID Allocation\n");
-			return id;
+			err = id;
+			goto destroy_wq;
 		}
 		session->target_id = (unsigned int)id;
 		session->ida_used = true;
@@ -2078,7 +2086,8 @@ int iscsi_add_session(struct iscsi_cls_session *session, unsigned int target_id)
 release_ida:
 	if (session->ida_used)
 		ida_simple_remove(&iscsi_sess_ida, session->target_id);
-
+destroy_wq:
+	destroy_workqueue(session->workq);
 	return err;
 }
 EXPORT_SYMBOL_GPL(iscsi_add_session);
@@ -2177,6 +2186,8 @@ void iscsi_remove_session(struct iscsi_cls_session *session)
 
 	transport_unregister_device(&session->dev);
 
+	destroy_workqueue(session->workq);
+
 	ISCSI_DBG_TRANS_SESSION(session, "Completing session removal\n");
 	device_del(&session->dev);
 }
@@ -3833,8 +3844,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 	case ISCSI_UEVENT_UNBIND_SESSION:
 		session = iscsi_session_lookup(ev->u.d_session.sid);
 		if (session)
-			scsi_queue_work(iscsi_session_to_shost(session),
-					&session->unbind_work);
+			queue_work(session->workq, &session->unbind_work);
 		else
 			err = -EINVAL;
 		break;
@@ -4707,7 +4717,6 @@ iscsi_register_transport(struct iscsi_transport *tt)
 	INIT_LIST_HEAD(&priv->list);
 	priv->iscsi_transport = tt;
 	priv->t.user_scan = iscsi_user_scan;
-	priv->t.create_work_queue = 1;
 
 	priv->dev.class = &iscsi_transport_class;
 	dev_set_name(&priv->dev, "%s", tt->name);
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 90b55db46d7c..7a0d24d3b916 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -251,6 +251,8 @@ struct iscsi_cls_session {
 	bool recovery_tmo_sysfs_override;
 	struct delayed_work recovery_work;
 
+	struct workqueue_struct *workq;
+
 	unsigned int target_id;
 	bool ida_used;
 
-- 
2.25.1

