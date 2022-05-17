Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3932C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 17 May 2022 22:25:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbiEQWZu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 May 2022 18:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230505AbiEQWZP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 May 2022 18:25:15 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0747652E48
        for <linux-scsi@vger.kernel.org>; Tue, 17 May 2022 15:25:14 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HKgGli031659;
        Tue, 17 May 2022 22:25:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=3i4+9y7IW+DoD39ITDlWkaCbxM3nYoEfbu4eyizCAFQ=;
 b=IDaAwX+tMVZ3fURZztmqoTC9QcQ5XcqkqLa0ntXVYM3bN/1r1ANH6Scah4hXwIA+s6Xe
 GuzzQ2PNnQLBUQyt1gXGPrJ688EjJaYa8mrtJbF4TOuuC+9N4y20oVtC8SLYBglnEzmT
 d7NOrGDy8ncfhi/QXWFYJ3thZTsfHWqTKPk+GzyvGcR6PHUKjh1/72jysG7643i3jKu7
 p5DUQbW00OTeomRlm8bWwC1OFV8+vlXDz/e4VrIcXLgODICjJna8DScXQTyQW1yen3eD
 0LQkc74aRMICFcXWtmkOO48u5RzJcA9onPcqnP4yjwfKoGmgH70CGfbGg2i5whzXwWMY qQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g24aafjgs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 22:25:06 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24HMP12J008394;
        Tue, 17 May 2022 22:25:05 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v3m138-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 22:25:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KiCAZMkXMBO5GVS3ArfSm9udG4FKXdf5XaBHda1A+N/BelN+E6YxvYRhj2WJdBa62zURXPqFR9F/PJlvrD+urCZne0ycmzKXagtDXoe8fEDJoU5GRoPS7xoLbKzU0IHqP1Y+O603MC1PW6FPWNfA7DIl5aIrc48djwvk7fEZEkOd3n+puzElR+FHXlsk+ZrTaV/UXNkHRplijpQ9LOg4JqC+ZC0ePXv3RycyLlj6VEfnLEedVK2FCSjXROoUgrYL/AY0EMRMdmdPQr8/E1/O5tKhp+Arcos5HpRXJ6niGcng0hlKDT45Y/5WlH+XdIYGkAigKGH8ex3lMwyKKXeSEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3i4+9y7IW+DoD39ITDlWkaCbxM3nYoEfbu4eyizCAFQ=;
 b=fvKhqFjM+mtYbCy9I6aSTi898QpCC7wYBKXRQRYp+m+wn9l30ZE5p6zJnxYEfpw0KqoucBivOTIy+4JSSWsI6O3fy3SzUt3CgAcuyJxiEkUXSkVbPJpihs1bP65y+eAch5swvcXEyFDq57zZ38euJENbf36Yq9IJulxF+z976JI2Kzmf5J5tLPSsyIfSENnq8RK4jrWgiqTCEtldkJ/27wvqJj/RBptwTU3/kvhgy2VKa3t/udNA9A0iMX9aTxTNt8K9/i26PTawAhcDsexr3DXFArnrpP4aiRcVDCEs5xvdinxyLyeNtwhtltvx4AYonXOg8nJiUEvtWZaU3EwmgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3i4+9y7IW+DoD39ITDlWkaCbxM3nYoEfbu4eyizCAFQ=;
 b=fnjJiKoVM7fXVxbTlvF1Ljb1SFeR/wrH5xTxQo9lVzr3VJ3myJ5CT/3wIf5uV8M8ct959bbmoytEwrI5y0ldpcsAIpTtJzF0d6gfvJfNw3mNAQrXhqX0j/b2Ysst4aOkZg/EJxC/KO06Vy9WNwtrKhN4p9v5luTwuYptPptxmPA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB5517.namprd10.prod.outlook.com (2603:10b6:a03:3e5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Tue, 17 May
 2022 22:25:02 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 22:25:02 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 11/13] scsi: iscsi: Remove iscsi_get_task back_lock requirement
Date:   Tue, 17 May 2022 17:24:46 -0500
Message-Id: <20220517222448.25612-12-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220517222448.25612-1-michael.christie@oracle.com>
References: <20220517222448.25612-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0078.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::19) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb5946f7-d374-46f0-8856-08da38541535
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5517:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB55170057EF2A5E88B06F5952F1CE9@SJ0PR10MB5517.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NG1tZzvbsOZkinnQ3/7oev11NkeCAoIaJUct7zABVeOcte/eNfgBKhlRiBLFzna3Fn5PpZq3AsU4tP6M4xJMw620ErO7cTpNFyiFfDQzNlNnvsELIOgef2hvqL8vgxJmv5AhkXXiRaB0rUoueLiz7sf3XvP76rP5b8xL08qd8WnecC+WZ49+7gRFUz12UavMmVblcE+rAMs2DEw8/ZUgmOwp4uFBM17qpra2xw0mvOKmjyGVyKVOEIdLqQJoUolSZmFX/f+oldZWYqdItGGdT7BL3/MfLim0sF0cXkVV4YRJAmk9A6F93QjhzyrUIlKz3yB0BtCFlUUd10ju6SO3h/QgAA+4HxDhvQ9cIrWF0EF8Od1LZawST2bfEN7KCKoEGg2cRLjLE8Rf5HdcuVRZntAHXobZjONmihIkSXDoujRk1em8cNWrwbjJK8FkNwGPGKt9j4Q60+aNyd4CZp0mGwSNgFjMMpU7Yzra67KSXoidh3iIgHKF3yt1nrWwfsKUE3h77Ee0s7rU8yVueFjvBtAfFN05cUf/akabP9n9HXl/GOCZNYT7rh76SQcbkt2rklGA5+a0q5kmJjADuPu1xhEctTXjcRYcu1u9ZtlacxIiCRMiLAMd/7LmlFqAYmUKetqHSkh1mV5/1+K98FZf//1KSI8ayovUYz/Vr1IcLbn+Seq2o5BAtK++Nkyd/0xflUxEY+hqCllA1EiMVGDjug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(66946007)(66556008)(66476007)(2616005)(8676002)(2906002)(26005)(6512007)(6506007)(1076003)(316002)(6486002)(186003)(83380400001)(8936002)(52116002)(38350700002)(6666004)(38100700002)(86362001)(5660300002)(107886003)(36756003)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oYg+obMmIhZ8DuurPwsuT6rUYstXsZU7B+fu9B075/e+1GtT2WrJm65KC8xm?=
 =?us-ascii?Q?kGEvCa8mdR4R2Xc5Hzqh+smXu8gwEBmLufxfW0zyomVoHUZLcdkM3dwQHmaU?=
 =?us-ascii?Q?2DbtLrhxPMkN8SeUjdvDz/F1X/dvG9EV0MAjXooyNDwgiBmTJIsmp8otPxae?=
 =?us-ascii?Q?0/fJq3WKeGSVam8pSpDwp7ag9uF0IbRfmQG217LMt5TFNURYdjWZNZjhtA8J?=
 =?us-ascii?Q?Mq8lZEtW/yGWDAC11+Yh0jwdT87pGMMsRGjjw/vmVth2ewBNuRVvRjHAiOLc?=
 =?us-ascii?Q?tzH2nx7oWiHzdSXLlBBnbuWYlV0nsRcdRggS0M9bO4r5/Cp37EZnOBsUVAio?=
 =?us-ascii?Q?mmV6PqyJywuY9anwVAqCVIEaLLdTWtRsCy1S/JCOEg0ze5hZkO2UvUBvotiS?=
 =?us-ascii?Q?+wIBJF19lrFqJZMSOEMQ1HiwCBxULYTmFcsG0877G9++k7whUwVlFrFNlPG+?=
 =?us-ascii?Q?4OT1xBaTmTjhB6WIex7gdV7mdbZcaY5I/UZtoUUlcvTPeCy30hh1NFuUtq22?=
 =?us-ascii?Q?NVPfGS4Zw6ThUsoWc7Ei4MwzzxWl0Ce3wki/byhT4uqHYdSWwUPuWlUDrSMS?=
 =?us-ascii?Q?/UhN0by4yYOLnC81uITlfgWp1+cTfhuE1UivZvUCEwTopzvbacclmUAuA/uo?=
 =?us-ascii?Q?Y0A2zpFX+JqK+JlkxSzrTEkMLBkZO/kiyZNdETTYE3MHkVHz54OyJ7LQC39o?=
 =?us-ascii?Q?ajSHONMV/ZCkNf3UH8F+2eTsqu3YgaQae/ebsLy2O2DsWDh1LTPPHynjVrK3?=
 =?us-ascii?Q?EG/enu+pU7T5yClVm71OmxfMBmLHciNVRkuwbnhl4/Rk31FTFVsf2CC+A0QQ?=
 =?us-ascii?Q?iZgxrxc0/b1ZVf+ylmu3sFS8i5GhhcBZHxej+9FOLfIErExRCkOlDBHbIfU2?=
 =?us-ascii?Q?bTjj6fFbTGeyX52cRZfik/W1T8Lzq1PitGpfyG59gOKeFqXCTxs6I+iDBPIh?=
 =?us-ascii?Q?ZgQobjNTEIa04Sj6JeU3IKIvhtKzYzpo9DPjUqjTRdGyEcz5Oqre2CxyJirr?=
 =?us-ascii?Q?nE5LeARwPF2QqlhvXm/YNtMo/maC1qrKAGUTviOCgA4ijI2TRvArH45bpCYL?=
 =?us-ascii?Q?OUZknI1gv1kEOtPRxrg2bXKy3wVNSvgX242d1dfJmCCow3nlVAtanjAN+Wsk?=
 =?us-ascii?Q?qJPd88jgH6h879+p9zhmWc53M0o56alKdUK89oCy/6V3Y/FDY/ywLhK6DdZQ?=
 =?us-ascii?Q?R8/ku46Oc8F9e9JDDbUnbSJvcrRuqajhJ89aHPEqzHG/+5bfVw3dVid6ygPm?=
 =?us-ascii?Q?dXBE7RW28JoKpFrzO4PjPXMlAPs4TBLQwCNGS2eaKUpny3hyl0ZWwY1GnFbt?=
 =?us-ascii?Q?TDL27cerk/rtehgcgKfvTCfDxAiWFbZd6BfVIFuJ0hsCqXSJvYw1f3iHHjQe?=
 =?us-ascii?Q?lndqzWRbphYrNX3Tn3E0ItX3LMgHC8m/0JxVK162O2jOjdv1oo02kRAmJGlu?=
 =?us-ascii?Q?25mQ4VWyG9CpCFc+lHgWdrs2PCBez+ymIZHL+4t0uHskXHAqKQq13qXk+2UK?=
 =?us-ascii?Q?dSLmtDumSvrWLN4uiAUZQPvCf4baXDOIoCIFvWgCcvv9iX1vx8W7orlkvNX0?=
 =?us-ascii?Q?JQLPTtOKfMJ8+DgS4GZivD2oNtMJge7uQXMpSTdBb+KUz5GR0oVDC0dggdPi?=
 =?us-ascii?Q?u6VQKtKbsBxBvGVJaETGPbHoQY74y1/b9nZ4v9+uRTKuPS8I5Y5oxJEBjre3?=
 =?us-ascii?Q?9gAg8jIhEphGdQuswkYI3pchcjACa7bRXyoWd39lu0Nqofj2f4rywP1luE6c?=
 =?us-ascii?Q?5bo7b8ZtwUJ8lQPY4kFVNaSMrnlEocE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb5946f7-d374-46f0-8856-08da38541535
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 22:25:01.1834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oGklpm/1iefrNf1eMvU9gdz32M28LoxduAMZFGhERLkZ0Ga2ofSMT5GuSRxzjkdj7m8YUnaTWuX13owUZg5sMaU29Jdjk3FTv4KIiDNKWGY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5517
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-17_03:2022-05-17,2022-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205170130
X-Proofpoint-ORIG-GUID: KMgcPteQfFzyD_oh9iphMT2qb_fODH4V
X-Proofpoint-GUID: KMgcPteQfFzyD_oh9iphMT2qb_fODH4V
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

