Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83FE5C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 19 May 2022 00:36:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232257AbiESAg0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 May 2022 20:36:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232180AbiESAgC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 May 2022 20:36:02 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B6C0EE21
        for <linux-scsi@vger.kernel.org>; Wed, 18 May 2022 17:35:40 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24IMIl9s005304;
        Thu, 19 May 2022 00:35:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=3i4+9y7IW+DoD39ITDlWkaCbxM3nYoEfbu4eyizCAFQ=;
 b=q+lqmoMbfjn3N3X/dcPPS36k5oghaqQ4cNh0KNJB9a/Nneyj3fb+bK8mr5tIVY13sIc/
 qKnmyNBAt3EDu5gDoY2mpHwnMqJ8SqFiErbDGmKn/v0omAQwgTaKZBKOzbTBjO+Vn1I/
 u04lfzlRrx34zhE0Mv4PDOi/fee8Vyzlgp+F+7xXLz0dsAu3OFnrCPs8/swlzsunWBZo
 0djHPKlus4mYt9HqHQdfyAfrOKiiaenhHSWN8UcFkp4pc3F1sDVR6fZ2WvDnuP8T/pwW
 AfgETLrfIrIcGdnmOTnnzmOu23E4jk/Iy0a9akHBtpI0j1zYPWo7L+iBH0kiynNNsoCM Dw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g23723167-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 00:35:33 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24J0V4VH015306;
        Thu, 19 May 2022 00:35:32 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v4s0u2-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 00:35:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ITrzMsG3m5PLRBHwkZHrQOAU/6/jzp/fX4JrMKscbEgnWzzZYJkuQCTofgb3wuunQocPpd0lI8P0v4RDRz7+MbIYbSM9DQ9iZy7GzWgsbY+LJfCh06WfWPMir+KSuMnx/XTpA71N57Y7H3umUDub8N7g9ZPoZ+cPM+K1vmZkrSsvplZR4bRWNNoDDRAuuj7prlmgcM6tE3iC6AgxpdgYMTx9Vj/mWRXExqjk8VLi+OhhK2jPN8lD8LTrp56tRcnaiD21ySaosq/9qsD6MASqe2vT1TS6QFt36ELZKR7nOKI9hiouyyccuclGXfieiLukTqIeM7kXhwhZzyrhqX9rYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3i4+9y7IW+DoD39ITDlWkaCbxM3nYoEfbu4eyizCAFQ=;
 b=WtRGad0K9KvbBnizbuv8kwlv7+GMiECAhe8qSYtChTGZDpf1p2aUx5wYy6IMvYEJL53u7a4AuWdl24L2Bx1yQopuJTQKtjdOKNH5SCMZHmqAGaNQtl2MSXyqYrco81UniN6EXKHuJS5pMxpLat+oo8NgqBL+3Ac6ieXWVp99ASfqd3sfcJ8zGzeOl/A32r8G0v6s2xmP31B+hlxtZzZ2Hi3UbEXO0uzljnDBx2qFfSBB5tP9bmQqK+/PwGR0glP3jNKfOHEoIfOIokRmiJUqgafbODliYUePXeXcjNP9OsZ6aBAzxG/WcvjygzT/cM3ij1vibt+6Ah4ZDR76JYKyiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3i4+9y7IW+DoD39ITDlWkaCbxM3nYoEfbu4eyizCAFQ=;
 b=MrZ9TT2WDjGBNIYAvfzoddmo1QFaXW+x+wEPnYCXx6KP23+1Bhts5uQ7828z087bKy0sLLUuEFBJc4XLRvmxCRAzKPgG8rb0KLxwL3Kv9zvltnYYpY20R+KDTOuD0NHW998f4FRp6W2zvK4vg84UbvGa8xT98xnAxYSmNcnG5Ek=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB3020.namprd10.prod.outlook.com (2603:10b6:5:67::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5250.18; Thu, 19 May 2022 00:35:31 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5250.018; Thu, 19 May 2022
 00:35:31 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V2 11/13] scsi: iscsi: Remove iscsi_get_task back_lock requirement
Date:   Wed, 18 May 2022 19:35:16 -0500
Message-Id: <20220519003518.34187-12-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220519003518.34187-1-michael.christie@oracle.com>
References: <20220519003518.34187-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR17CA0015.namprd17.prod.outlook.com
 (2603:10b6:5:1b3::28) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ebb10beb-5fd5-4f66-0df5-08da392f7a9e
X-MS-TrafficTypeDiagnostic: DM6PR10MB3020:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB30202D3353468065D990B78EF1D09@DM6PR10MB3020.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4ukLrxpuor1mKGNH6S8mBQXSDTn6TQlFXu7tigXhsla9pnwAPfXxQm/u/PL4qMDLp0jR1tGZOWoBoqw7rZW7IXWogJkqySrlWCDt5fwl7GC1Z/0HVUQZq0N1EAqhD00M2aW6DaKuMA73ilY0HsFc+Pwxqlqw6st7psUyKcnM2KFvIWN9KIednAVIIBw35mUA5zs26fuwukXxF//7SDB1OsOoCgxpLDl2Pq30O/QW3WF1mJRtfK8uA2K1p/dmnrRkH9uOI2GNlk3NCbIp/Z8RaOOTtAIANWcbQX5hFSHxwyqyUJ5n3g12oT/TuL8xy1kgIDmJfpwMUeaQvlOSz/pNYb2ZEjYIDzt2i3UlOtxo6RgqqZFNy8u8DieGcBk/oIG/+Z9gzzs9B/JA5A7c4CVsq+P4ex9WhFLqXPLC0VB6SlR/btqu4CSeSNqxs7Zd6A4Pr0DAVS+GF9TReN10ZDD8HomWalwn02s/VmdqR30x7/XrUd5B49ZSvuf5ljpTPB8aDfT9cdqNBdn9IJOAM6BdMuH4hAGzTb/IbqfzzGZanNkFK9Fvx5u0HbZF6j1rkEf8gdk1a17uXaAASwDSh4IulIqpYxUFM+svQvmS+hgPoBCrIQ5TqQwa5haN5ZHOzLeKPrf0P2qjY+RXKVuNXITVZrSF6iA+LPM0e1NUpGvJLSqSxxgSGB/a99ZV1quXKBqn3boRV/Au5u5fWhNYRGgkDA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(83380400001)(186003)(66556008)(1076003)(52116002)(2616005)(2906002)(6512007)(36756003)(26005)(107886003)(8936002)(66476007)(38100700002)(86362001)(66946007)(5660300002)(8676002)(6666004)(38350700002)(4326008)(508600001)(6506007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UignjSxdWGRrf2iWmdwTTF4KPn8ShitxN+QNEkcoef8Ns7dvJeSiHq6VI1Uk?=
 =?us-ascii?Q?04M3dW4ADJiNpzp/MiIs0tvYKuQhqS7HXUEsiUuuGSKKEVrHvk82uwZ94LdM?=
 =?us-ascii?Q?t8Kq4jEETrFtjPybrHs20iSf5TU/p20HEEvQseERn3rKEIlDj/gl9U2W55Lz?=
 =?us-ascii?Q?hDo7am51So68x3SQX92zVMnjohJ7Nr3ssuH1Xx3h18tnOylBGy4+LoVulfdU?=
 =?us-ascii?Q?2VqY304fq0dA2J9j69NBSaz+3erQ4WntDzUJL3pXN97/+YjCtPfPPETkLJdO?=
 =?us-ascii?Q?q8z2+l8NrnJKi4yOvLEDQIrnyN1ka7sDzpuEeodtnNcDWh42PRzWqxCkry2y?=
 =?us-ascii?Q?L2PSohFCJhUVvB/bPhZpa3bW6eQ1CUtcmL1Kf6j2khVzHBaHAenlj3U2XDVe?=
 =?us-ascii?Q?9UVBK4yin8/yb3c6Y7h0aKT5R78/fFRkNwjZusp39RvhF+XZEUXdKVkAZKcI?=
 =?us-ascii?Q?v6tB/WmqmoTy2hIzw/lzSaH5E2ioXRthW/jEURHZ3y91F314/Zq4qJ5gG9GN?=
 =?us-ascii?Q?J+cuNUqq+L9bz9fGj6gmxgVFotFFt0yYjdu379sIrTeMwF6MwpOLQzTOK30Y?=
 =?us-ascii?Q?3qrYaWvFQmAi2U8PPFX5NYwyVCsJ2aeqQb2M69aP8CLH4WFNTMoix0x8ryHp?=
 =?us-ascii?Q?RuiX/SacDaw7Zcn6CUIizFM6H+jyXny7XJ7k3Ppw8YEz/e8c8W8OpjX7j8mx?=
 =?us-ascii?Q?7i70yquLIXdpmhQNvIQEZfWzGhAnJXpIQubIlO9t7CwyWK7yAFqoKA43QS0O?=
 =?us-ascii?Q?CiBz8NA7VGsoak3lGIhOm+YI+5qxVHtHQN0ONAbI4k2EGsYX5y84ZzfSmQfW?=
 =?us-ascii?Q?TdA3Ey7K+owNrDpANeQXY4zgUVNP+nSC1fpfarODHEWDi75qQ0urodQhs3oA?=
 =?us-ascii?Q?+D8Ktpi0DnpOf80pnOqTcemY3RW/x6OtdA8Wa8OKiZuUicOpeoh88gcxL2zL?=
 =?us-ascii?Q?ksJe3iCwia/HGM/xwLHF+O/z+C2x/cyUHk89q/H8AZ61d1Jc84Dm6VkPv7Gz?=
 =?us-ascii?Q?H2TqgX3+a0lJG+q8Wu7zMK5BPV+uHfVUKH5VOnbZg/VE/OOeWMxRSZaR3kfr?=
 =?us-ascii?Q?2NVKOnuoqv8S3fJ87koxCC4JXFtKdVbzMOCr0jtrAscazH4BzCvsaD1opZmd?=
 =?us-ascii?Q?wWMzLapmjSlNFwnL4iHg8rYW5MrL6l8a2bz8s0xGPGOaNL46cl7A4NiRmt0F?=
 =?us-ascii?Q?iI3VrpSvAkjHu/Wr3+goJTJmPvgTe7xidh25Cfx7+gDchfutvnTDg2ZR8Bxj?=
 =?us-ascii?Q?yTSOXEgia53vVucF1LClnhsiwHKj6SjMjEVpAvvbZO9r5/V7y57xp5xH4+T7?=
 =?us-ascii?Q?mqXSUXzMJn22fBivI1iX8RtxRXyIYewCkP/1FCgVMnASvRjOLH4lfpsHBEcl?=
 =?us-ascii?Q?1FyyZJJJ65opQr4VWmJ3lLTze+yrHXav8BlpmGVPwDW6KaKwLqaD8+ea8f64?=
 =?us-ascii?Q?fxlKih4n8oyYKTSXoB85I3sqkTIUNVqXL4M2RLL13u9pZTlpKZ6r43IUGGjA?=
 =?us-ascii?Q?YE/qdcjzEoYOfm63KWOCfwbenL9pvEzKNMJArerhDA3zNDiP/2jvZB+kFr2N?=
 =?us-ascii?Q?BKX3PML7u5/jZwPj4iEu5alCnel9dZndZQC7Z5XfFBFcvheOOZUTOpppGFJy?=
 =?us-ascii?Q?a8iOGCDq3PgcHy1BpayKj5ww3sd1/AnA5er1Xlto58vGrOLuQiNrFDqoFW8M?=
 =?us-ascii?Q?p/e8muQBQE3W2XSyDUS63GAtiH6YNQZrI5TXPd2CZ8Bx+ffqS9+1XKRb+Zi6?=
 =?us-ascii?Q?27J+bIMZmkyw0plALVzgWl58aN75+gU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebb10beb-5fd5-4f66-0df5-08da392f7a9e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 00:35:31.1177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v7qA5bFYqEZ0em8fMNILKs6WQWIJC0GbahPBiLgWNXd/ogmR9dVF7oc7LuTDCWwzhYB3H58w943/z9DRATY3Zlzke7+XJTnylGHWAv199fg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3020
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-18_06:2022-05-17,2022-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205190002
X-Proofpoint-GUID: uSGd1BpRsxSBnIUD3leOPaWlM5rIHtGK
X-Proofpoint-ORIG-GUID: uSGd1BpRsxSBnIUD3leOPaWlM5rIHtGK
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We currently require that the back_lock is held when calling the functions
that manipulate the iscsi_task refcount. The only reason for this is to
handle races where we are handling SCSI-ml eh callbacks and the cmd is
completing at the same time the normal completion path is running, and we
can't return from the EH callback until the driver has stopped accessing
the cmd. Holding the back_lock while also accessing the task->state made
it simple to check that a cmd is completing and also get/put a refcount at
the same time, and at the time we were not as concerned about performance.

The problem is that we don't want to take the back_lock from the xmit path
for normal IO since it causes contention with the completion path if the
user has chosen to try and split those paths on different CPUs (in this
case abusing the CPUs and igoring caching improves perf for some uses).

This patch begins to remove the back_lock requirement for
iscsi_get/put_task by removing the requirement for the get path. Instead
of always holding the back_lock we detect if something has done the last
put and is about to call iscsi_free_task. The next patch will then allow
iscsi code to do the last put on a task and only grab the back_lock if
the refcount is now zero and it's going to call iscsi_free_task.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/be2iscsi/be_main.c | 19 ++++++-
 drivers/scsi/libiscsi.c         | 95 +++++++++++++++++++++++----------
 drivers/scsi/libiscsi_tcp.c     |  5 +-
 include/scsi/libiscsi.h         |  2 +-
 4 files changed, 88 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 02026476c39c..50a577ac3bb4 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -231,6 +231,7 @@ static int beiscsi_eh_abort(struct scsi_cmnd *sc)
 	cls_session = starget_to_session(scsi_target(sc->device));
 	session = cls_session->dd_data;
 
+completion_check:
 	/* check if we raced, task just got cleaned up under us */
 	spin_lock_bh(&session->back_lock);
 	if (!abrt_task || !abrt_task->sc) {
@@ -238,7 +239,13 @@ static int beiscsi_eh_abort(struct scsi_cmnd *sc)
 		return SUCCESS;
 	}
 	/* get a task ref till FW processes the req for the ICD used */
-	__iscsi_get_task(abrt_task);
+	if (!iscsi_get_task(abrt_task)) {
+		spin_unlock(&session->back_lock);
+		/* We are just about to call iscsi_free_task so wait for it. */
+		udelay(5);
+		goto completion_check;
+	}
+
 	abrt_io_task = abrt_task->dd_data;
 	conn = abrt_task->conn;
 	beiscsi_conn = conn->dd_data;
@@ -323,7 +330,15 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 		}
 
 		/* get a task ref till FW processes the req for the ICD used */
-		__iscsi_get_task(task);
+		if (!iscsi_get_task(task)) {
+			/*
+			 * The task has completed in the driver and is
+			 * completing in libiscsi. Just ignore it here. When we
+			 * call iscsi_eh_device_reset, it will wait for us.
+			 */
+			continue;
+		}
+
 		io_task = task->dd_data;
 		/* mark WRB invalid which have been not processed by FW yet */
 		if (is_chip_be2_be3r(phba)) {
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 72ed303184cc..dee6e2d5c86e 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -83,6 +83,8 @@ MODULE_PARM_DESC(debug_libiscsi_eh,
 				"%s " dbg_fmt, __func__, ##arg);	\
 	} while (0);
 
+#define ISCSI_CMD_COMPL_WAIT 5
+
 inline void iscsi_conn_queue_xmit(struct iscsi_conn *conn)
 {
 	struct Scsi_Host *shost = conn->session->host;
@@ -482,11 +484,11 @@ static void iscsi_free_task(struct iscsi_task *task)
 	}
 }
 
-void __iscsi_get_task(struct iscsi_task *task)
+bool iscsi_get_task(struct iscsi_task *task)
 {
-	refcount_inc(&task->refcount);
+	return refcount_inc_not_zero(&task->refcount);
 }
-EXPORT_SYMBOL_GPL(__iscsi_get_task);
+EXPORT_SYMBOL_GPL(iscsi_get_task);
 
 void __iscsi_put_task(struct iscsi_task *task)
 {
@@ -600,20 +602,17 @@ static bool cleanup_queued_task(struct iscsi_task *task)
 }
 
 /*
- * session frwd lock must be held and if not called for a task that is still
- * pending or from the xmit thread, then xmit thread must be suspended
+ * session back and frwd lock must be held and if not called for a task that
+ * is still pending or from the xmit thread, then xmit thread must be suspended
  */
-static void fail_scsi_task(struct iscsi_task *task, int err)
+static void __fail_scsi_task(struct iscsi_task *task, int err)
 {
 	struct iscsi_conn *conn = task->conn;
 	struct scsi_cmnd *sc;
 	int state;
 
-	spin_lock_bh(&conn->session->back_lock);
-	if (cleanup_queued_task(task)) {
-		spin_unlock_bh(&conn->session->back_lock);
+	if (cleanup_queued_task(task))
 		return;
-	}
 
 	if (task->state == ISCSI_TASK_PENDING) {
 		/*
@@ -632,7 +631,15 @@ static void fail_scsi_task(struct iscsi_task *task, int err)
 	sc->result = err << 16;
 	scsi_set_resid(sc, scsi_bufflen(sc));
 	iscsi_complete_task(task, state);
-	spin_unlock_bh(&conn->session->back_lock);
+}
+
+static void fail_scsi_task(struct iscsi_task *task, int err)
+{
+	struct iscsi_session *session = task->conn->session;
+
+	spin_lock_bh(&session->back_lock);
+	__fail_scsi_task(task, err);
+	spin_unlock_bh(&session->back_lock);
 }
 
 static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
@@ -1450,8 +1457,17 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
 	spin_lock_bh(&conn->session->back_lock);
 
 	if (!conn->task) {
-		/* Take a ref so we can access it after xmit_task() */
-		__iscsi_get_task(task);
+		/*
+		 * Take a ref so we can access it after xmit_task().
+		 *
+		 * This should never fail because the failure paths will have
+		 * stopped the xmit thread. WARN on move on.
+		 */
+		if (!iscsi_get_task(task)) {
+			spin_unlock_bh(&conn->session->back_lock);
+			WARN_ON_ONCE(1);
+			return 0;
+		}
 	} else {
 		/* Already have a ref from when we failed to send it last call */
 		conn->task = NULL;
@@ -1493,7 +1509,7 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
 		 * get an extra ref that is released next time we access it
 		 * as conn->task above.
 		 */
-		__iscsi_get_task(task);
+		iscsi_get_task(task);
 		conn->task = task;
 	}
 
@@ -1908,6 +1924,7 @@ static void fail_scsi_tasks(struct iscsi_conn *conn, u64 lun, int error)
 	struct iscsi_task *task;
 	int i;
 
+restart_cmd_loop:
 	spin_lock_bh(&session->back_lock);
 	for (i = 0; i < session->cmds_max; i++) {
 		task = session->cmds[i];
@@ -1916,22 +1933,25 @@ static void fail_scsi_tasks(struct iscsi_conn *conn, u64 lun, int error)
 
 		if (lun != -1 && lun != task->sc->device->lun)
 			continue;
-
-		__iscsi_get_task(task);
-		spin_unlock_bh(&session->back_lock);
+		/*
+		 * The cmd is completing but if this is called from an eh
+		 * callout path then when we return scsi-ml owns the cmd. Wait
+		 * for the completion path to finish freeing the cmd.
+		 */
+		if (!iscsi_get_task(task)) {
+			spin_unlock_bh(&session->back_lock);
+			spin_unlock_bh(&session->frwd_lock);
+			udelay(ISCSI_CMD_COMPL_WAIT);
+			spin_lock_bh(&session->frwd_lock);
+			goto restart_cmd_loop;
+		}
 
 		ISCSI_DBG_SESSION(session,
 				  "failing sc %p itt 0x%x state %d\n",
 				  task->sc, task->itt, task->state);
-		fail_scsi_task(task, error);
-
-		spin_unlock_bh(&session->frwd_lock);
-		iscsi_put_task(task);
-		spin_lock_bh(&session->frwd_lock);
-
-		spin_lock_bh(&session->back_lock);
+		__fail_scsi_task(task, error);
+		__iscsi_put_task(task);
 	}
-
 	spin_unlock_bh(&session->back_lock);
 }
 
@@ -2036,7 +2056,16 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 		spin_unlock(&session->back_lock);
 		goto done;
 	}
-	__iscsi_get_task(task);
+	if (!iscsi_get_task(task)) {
+		/*
+		 * Racing with the completion path right now, so give it more
+		 * time so that path can complete it like normal.
+		 */
+		rc = BLK_EH_RESET_TIMER;
+		task = NULL;
+		spin_unlock(&session->back_lock);
+		goto done;
+	}
 	spin_unlock(&session->back_lock);
 
 	if (session->state != ISCSI_STATE_LOGGED_IN) {
@@ -2285,6 +2314,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 
 	ISCSI_DBG_EH(session, "aborting sc %p\n", sc);
 
+completion_check:
 	mutex_lock(&session->eh_mutex);
 	spin_lock_bh(&session->frwd_lock);
 	/*
@@ -2324,13 +2354,20 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 		return SUCCESS;
 	}
 
+	if (!iscsi_get_task(task)) {
+		spin_unlock(&session->back_lock);
+		spin_unlock_bh(&session->frwd_lock);
+		mutex_unlock(&session->eh_mutex);
+		/* We are just about to call iscsi_free_task so wait for it. */
+		udelay(ISCSI_CMD_COMPL_WAIT);
+		goto completion_check;
+	}
+
+	ISCSI_DBG_EH(session, "aborting [sc %p itt 0x%x]\n", sc, task->itt);
 	conn = session->leadconn;
 	iscsi_get_conn(conn->cls_conn);
 	conn->eh_abort_cnt++;
 	age = session->age;
-
-	ISCSI_DBG_EH(session, "aborting [sc %p itt 0x%x]\n", sc, task->itt);
-	__iscsi_get_task(task);
 	spin_unlock(&session->back_lock);
 
 	if (task->state == ISCSI_TASK_PENDING) {
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 883005757ddb..defe08142b75 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -558,7 +558,10 @@ static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 		return 0;
 	}
 	task->last_xfer = jiffies;
-	__iscsi_get_task(task);
+	if (!iscsi_get_task(task)) {
+		/* Let the path that got the early rsp complete it */
+		return 0;
+	}
 
 	tcp_conn = conn->dd_data;
 	rhdr = (struct iscsi_r2t_rsp *)tcp_conn->in.hdr;
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 1e7c5c7f19ac..7baffeac279f 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -482,7 +482,7 @@ extern struct iscsi_task *iscsi_itt_to_task(struct iscsi_conn *, itt_t);
 extern void iscsi_requeue_task(struct iscsi_task *task);
 extern void iscsi_put_task(struct iscsi_task *task);
 extern void __iscsi_put_task(struct iscsi_task *task);
-extern void __iscsi_get_task(struct iscsi_task *task);
+extern bool iscsi_get_task(struct iscsi_task *task);
 extern void iscsi_complete_scsi_task(struct iscsi_task *task,
 				     uint32_t exp_cmdsn, uint32_t max_cmdsn);
 
-- 
2.25.1

