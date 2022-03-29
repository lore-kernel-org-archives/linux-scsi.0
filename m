Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA9C9C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Mar 2022 18:05:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240416AbiC2SH3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Mar 2022 14:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240348AbiC2SHK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Mar 2022 14:07:10 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85202B1A99
        for <linux-scsi@vger.kernel.org>; Tue, 29 Mar 2022 11:05:21 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22THsG7v029601;
        Tue, 29 Mar 2022 18:03:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=zWQOx5LiJnZqbbK7wWXDL/Wvw4RTT+5gnGvCkxuHEXY=;
 b=nbfi6Io+AolxTAwtS6yZYnFRZd8wyTfWoIVG8Qh7FwCJZ7T/uQ92/RX5J5vw4EJs+YaJ
 /TJ6rKH155MiJ/ElPY5s1pmb3kjreUePR4F7MAWqD48e+I+q5OLcgtlJ2P+ucw+swNKt
 U4lC/e6RN9iDapjSt26ipZ3SeCxSVTVrgnxBUfPxNdl2hUGuY/ZopQDFKm8n/rJB27M5
 QOJmTnrQibsE1RzG+6KOj5Uz8DDxlV6I5xXMqBhdf9yX+ZPpFGtqTASQ/wPfvE6Az/DK
 6+ppCryHLJY9TZhafc/QLGSQ4hLiiJJI6d6nQB6OEhan0QnDwzVj7YHY0VRn9p64JDhC 7g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80] (may be forged))
        by mx0b-00069f02.pphosted.com with ESMTP id 3f1se0fcv8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Mar 2022 18:03:45 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22THw2uI013210;
        Tue, 29 Mar 2022 18:03:44 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by userp3030.oracle.com with ESMTP id 3f1qxqfdqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Mar 2022 18:03:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i6vA1H6Ogyda5XfENANlTz2C3AZclzB1bOktl2wnqwftWrhmoY0bWNVwBFK0EQBsedgqHLSsaPjBDzUI2EUygE5Dy9HnyE3MXTxXQN5qDj1qLTVA85yTpBbVwyapFFgPoYZ2MvVWkR8l5N2o/o8SJza6cRkzWuGxBiiKu08Q+kmNRUyvaWK6xlK/T4ifWruU1dKvP0sJ/aWma7HhbLVweFK9Pbdd135OEbdg9S4TVzjbaFOmLs86+tvUiSPtBY83FfP1YlaSi8jg+PJxARo3vxfPx9zXm4deJHmH3QgPYKBpIJTiNLgqbRqBhKmQ9X8cRww7mLFsX1yyyWsDcML20g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zWQOx5LiJnZqbbK7wWXDL/Wvw4RTT+5gnGvCkxuHEXY=;
 b=MY6DRvOYillJ8TQEXCZx++vHSVlcRfdK7vj8Fyyhbw6NfTlA9GbPpg3VPSmu3vkkFeSC25hosvmm1cPxDKgvHiw2ipg/JOuW4ubRjt4UF8nmrsTH4Bl1UaOTUHE1suDFvHcs4eRFy0WVslozYQdB2Nq01scFEI9iquvUe10KU6XyBuf7xloP411JjI65/M2KfvKwDFX8NFfMUH5Kuz3SFmTYzY9W4gOFn7DeyAkV0BmIPXkRiSj7v9keFF86QwLJsh/eAAuE85bKQ7WtK9++orygibrtesrXb9sEo+46DFcEbM18uHeOHVXZEyS4//pdp622PEJMU1MakoWspviqRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zWQOx5LiJnZqbbK7wWXDL/Wvw4RTT+5gnGvCkxuHEXY=;
 b=QGKvEfNfA8CCti/eaRvyWyJ9HC4SyWUJ3Lfu5E5A/OVo2jQSg76udkCGWChsYT4c0QKriZK0cOcZWrS7MAuU39GHnRMC2eMGNQwU7qC9AWDYi1ihP5tTiyCzfHwXeUA0QNxtuF5RsoRDjJDEZIiWQapKM5GSQjBLAZnvESCIT9E=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MN2PR10MB3584.namprd10.prod.outlook.com (2603:10b6:208:11e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.19; Tue, 29 Mar
 2022 18:03:42 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::29a7:bae9:9b3c:c9f2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::29a7:bae9:9b3c:c9f2%10]) with mapi id 15.20.5102.023; Tue, 29 Mar
 2022 18:03:41 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V3 12/15] scsi: iscsi: Remove iscsi_get_task back_lock requirement
Date:   Tue, 29 Mar 2022 13:03:23 -0500
Message-Id: <20220329180326.5586-13-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220329180326.5586-1-michael.christie@oracle.com>
References: <20220329180326.5586-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR11CA0002.namprd11.prod.outlook.com
 (2603:10b6:3:115::12) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e8ca6efe-7a5f-4724-de2e-08da11ae74c9
X-MS-TrafficTypeDiagnostic: MN2PR10MB3584:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB358432D9E39E1775868DABE5F11E9@MN2PR10MB3584.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: liBanBX3cFyGrVhZNURNxBekb9pTpNJ4OL4c5H4tWuitWjPdRHPFA9Rt+7azkO7ZbGx+SIG/2niZHBmwnZZ36E5uNtqqwjd9OozWnDIXff1iyaMl9Wc+lXt+lpBTsVBneHxqybZlxRNwgYZcmevub8l9rAotQsa2QZxW7P5iv9Tde+5AhBMRqkr5Dsth5+ou18zu66BptmwxxnahZ/pGsZNXeuXXzkEQji1bCLQzzhXyX4929lYNv6VQQkhbwVMhi7y265Okb0yADO3zSghOIUrr4CStv4G7dNdgjRd59uot7ZVHcHO3Qs8LArpaNpaYd+agYIRSCHw0FEjpbZzWliCRsfaZCp6lP6JOvtPkQqdXQ4mmLKIudwBprixgkVeTgkqQpF+cGOP69kmf9L8TPZ5+zsL8DpUMYMHJk73/+6x5/7hSOQZewH/nboLwA/uLh71xxGrGDTYdQBmWQxLR7ZAM2hLlljsFMUZXy/YCJzm6q1bYlJK/iM6PI6LeJO59POEbJXuKmzG4lY5ze98Hd0+/18iFWrs1vwdiCuz7CXfTmjX9NjTqjEwr8yEscabxlGDO3+H6CvVYG4H0MW1rSRFGuokdOCqJzDiPMrWB4+f/wo1Hdssc1R0lNHhpJpHnb5Z+0FrsxxoEDhO1YWBhM2Vd/hz/sUEt2cu4HOF1qfAqz/9Av7D3o+BCSbwWqrp56ji9MA8DwBMGqYiXHMFxag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(66946007)(316002)(8936002)(8676002)(6512007)(66556008)(38100700002)(2616005)(36756003)(508600001)(26005)(6486002)(2906002)(5660300002)(6506007)(107886003)(52116002)(6666004)(86362001)(83380400001)(4326008)(1076003)(186003)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5oFQiDm5lmPjslgSoVgcurO4kzeEGhJoToaqFTnkyHS99+JqvPVnGf8xM4Mp?=
 =?us-ascii?Q?fZHK+c0wL71MriSpM8NbUnWLYfEWTFKUAV3ikOCe8V4xYVHev71lGGRcwuCK?=
 =?us-ascii?Q?NT1sndrLoX2jQAfwJ6vcVKx3w7kNEi1jVNeicLFj3Uu07lasIrzACYXT5ILf?=
 =?us-ascii?Q?BcwG+GA3Z7RqhkdpJwxNkivrD7s2++VVEqmQCnc6yVPA9xL313Mas7ZFdoyE?=
 =?us-ascii?Q?amxkevTrihGsK3yrYvbvIZvxv7LB1/rD2qRYBqXVJPk8HSVPiAvfVKiuRwWn?=
 =?us-ascii?Q?+lP2fALXkiKKTu8/1FWjwTZH4J2jjSEsTMn2TGjAfe/fLRgcpZ3W09l4jN7s?=
 =?us-ascii?Q?jhewA5GzhVEgs1FSHg0Gchi3mltrdw8HUnStrKGnUJPI3J3Dr2G2ucf8527O?=
 =?us-ascii?Q?iTRgbjMo3D9PpZG0IFhNnnrsxjI5CjF7kGhEj044cyyuE++OJ9gnRnROqfJJ?=
 =?us-ascii?Q?XoyyjWKgaSaxFtywkByFXzH3OtXC0dY57cQrGGc6ABmJybgztyC6htc9RAn0?=
 =?us-ascii?Q?x/istNPIbCUwYwsD+EEebGjy3DEjaGg6alWwi6sOYUZt01LGevNtPjqRU439?=
 =?us-ascii?Q?1F+A6fHZCnhTbVQBFgRcyaUPcuV0tunZT+xCqhtyW5gmqlRPopx9FLnQ3A2z?=
 =?us-ascii?Q?sZPgug9t7rz4nFfZBB1O2ZjxEudrnl9PQkd+FVLZymnHH0tpj/dJzgkP0axy?=
 =?us-ascii?Q?6UQz9fqrio6GHVpJS1N5oKi8b7ZTp5IZ2GHbLIB1SGdGXCSjiq6Sh3GAt7tl?=
 =?us-ascii?Q?vC7SaKIQAyqCjrHFhsf2ykcLMtZc8/jRrWDytxp1OfyFrutGiKY2oVU7y8br?=
 =?us-ascii?Q?YjAeMEW+hrD+mM6i10SguvHHHwWv11+5J+l4/pqiEkKKt8QZUSlTRsosVdZH?=
 =?us-ascii?Q?eV/gDCUC2d4w4BAI9hB3b1VKRgttTH2vFqezkEhUoAC1Oo/WyOamnXds8Vkp?=
 =?us-ascii?Q?tLETmLSCFk9Aiq4aJf93Sq2g3eXG0SFMCTdpufOtrwRDgZpvOylT3za+drUx?=
 =?us-ascii?Q?wNlnwk1ms3ALwioGoqto9H77TFawGJtcOZmfVGopkoyZ53eDolSLPy8NcfJ6?=
 =?us-ascii?Q?HEEv1tIeBusZIvxV6pKSjPbZO1SKH1AS4Bn3MKQy4CIJpIqi6XIjjQYht/Pi?=
 =?us-ascii?Q?JNYZ/CZVJPVXJQoLaV8iac0Z7kPpwle0/ogAJpYT4hWnOB5fZ+qgFAb0Ml3r?=
 =?us-ascii?Q?b1GFdwSLhuEZyvMHhP36Hq/QSnU1AmkmBCQnQ0cbrdNJHX5hLxZsnsknNeie?=
 =?us-ascii?Q?vIBt5uYIAwGE2NDj3KV+TPXz7uVND6irRjNjs4te7/Y/+9wdPRd79K9Twzvg?=
 =?us-ascii?Q?swAAQhJ+UFwCIitXVeEQMVU+zOlW8KFwIbb+xgOVeY8B4903+dOB70Vd20RL?=
 =?us-ascii?Q?zKjRGJnaNRFViXLOZZqH4UpsU0xFSYES3hvn0MvP2Uiy8leZMBO04w21nToR?=
 =?us-ascii?Q?/Cb/5z4VShTiCkbVSUjsg5zNA1kQ+ItkX/tx/X/WBr84WzePxEKZl8dHzXC7?=
 =?us-ascii?Q?oKQ2TQcxb9GMVp+m9dczd3hLNutKJLYAKLzIR99yCJ45Er+NRVCMfe8lsWej?=
 =?us-ascii?Q?/1UZkiX7kSdIeMkqDPedd7KGchQZ46BohuVcwOtqsgwmwXtfu0dpEB3E1fdu?=
 =?us-ascii?Q?v0bo4qaS5JmONTZTNdRWSuT2n5It6IPV0qGFpgqYdR4fJtxGkoNUOTyi5S+x?=
 =?us-ascii?Q?85QRSzcqgVXS3fffP+NmzW1WZEUm5PWtYdRVxrEo4t5fhp4qTATbFe67Xos7?=
 =?us-ascii?Q?AZhPdpersOJIcVupEvmK1nuQoiXWRss=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8ca6efe-7a5f-4724-de2e-08da11ae74c9
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2022 18:03:40.9746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BwexW46G2Nbgv5v3fjnr3y2gPyrBX7Avb3zBbVXutWtl28AgF+rNUkdFgoI6gu9+SZ3VILFZWSI0Y44UHqlyHDOxl/DDiUVgxh8pFwNJpus=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3584
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10301 signatures=695566
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 bulkscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203290101
X-Proofpoint-ORIG-GUID: r0JdQ45keSitvdNxdFJk2FFxQXk7czzy
X-Proofpoint-GUID: r0JdQ45keSitvdNxdFJk2FFxQXk7czzy
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
index 3bb0adefbe06..dd32a90ef9c2 100644
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
index 03a0561ba768..544113f3a9c6 100644
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
index 09bac9e3efaa..97eb793f4c55 100644
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

