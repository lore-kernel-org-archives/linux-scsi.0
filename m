Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27EC1C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Oct 2021 05:21:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DBB560E97
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Oct 2021 05:21:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbhJVFXR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Oct 2021 01:23:17 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:40828 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230451AbhJVFVw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Oct 2021 01:21:52 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19M2nhxm010959;
        Fri, 22 Oct 2021 05:19:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=BGDDUIOqDwyhFnOlbOmNwt4zkp0IVmaJ2y7UYayCi0g=;
 b=m45YG3YKgZAgwanPEKpwoIeEG63ACSHVVuE2ZKWy/5gSDV1ZjolsheBrwttGnn2WIBAa
 tF2ONkyCY/E9f+jJmgO9ki/CqiC5QvzJzKM4ZlE1n2gbZe7nsFbXd64oPI8pKAaPrpyG
 6oKQgi4ewsmePZ21AKkJY8G5tDMmYJjG6tOMgdQ8GZ9Z6oLbc9A6JY9uC0tXHVv4hdb5
 u6FdxG+dUwlAv15xCbnWn+uL05mXSxy7mFA22WLrszWv4KlKkkDaEQoRt/WzHvvAxaOX
 Ur0u3wzzaeP6zCOFN6aSi9q/wiqhgc3JbHxW+YXx9F3tf90m6a1/txeXrI/58FlekbjU vA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btqyps42k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Oct 2021 05:19:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19M5BHIh139141;
        Fri, 22 Oct 2021 05:19:30 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by aserp3020.oracle.com with ESMTP id 3bqpja16nf-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Oct 2021 05:19:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PqR9iLy/mYl97VnTVOAZrIvFIIC/SxY6rIZe8djRzW5jbdqbzeR3zhSRjmZaXkSd+HCbnXJpPZXpY9fQ87lBjgG+agqI4Z2/HVjH/GkjQBsSWOrSdlmEDJRBc4pVSfe1ANwjnK4pHjf6vQk1srN1n17trDwnEcjy2c7rFK14Knm9t6hssQRdnrit7Ze9+99e4SgqeMqL1FV6ttM/9Zq5J6wb4svO3LA9D1tN9gT6o2ulxEPFK+p9pT9EjAGugZAmmu7wpZCKcm1L6GhJzdXv+uGWaCT8cdeTKPwtSjIHaCiOb1y/7HiryTbchURJ7vk0t1rNRT9CzgWFc7glZucQ8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BGDDUIOqDwyhFnOlbOmNwt4zkp0IVmaJ2y7UYayCi0g=;
 b=D3+8xtvs+OPiHyboEFBQziIWPVoUlhEI3Vrdzvj8145l0jXkiHWJ+F3N/VBJW/Jpnv+k/eae7YV4USwVaIeTM8MifsJo3gd5Kd0H9EFZq2t5rNgaawBzOljjX27CQnOUDIbVz5DhVViMArT0dMJGWPalXTNi+vmA9N8PCiKmTIyQddQI3dCQjqCPar8Bdpw+xD6Zg3kgcmYYuKeILLviNMcXYOJWlzdrXOgJqnjfJWM2Eu83BwllYyCEU1XyN5dn0R+3DPg5h2Dt/iP0K07XK2zv0YZh6htY+CCzcthUjRlMYyvO091CsUvBH4tBbMea3vV75eOu6W3L4a6TCUA3xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BGDDUIOqDwyhFnOlbOmNwt4zkp0IVmaJ2y7UYayCi0g=;
 b=o4kTvd1fHDyezQj1Mk3DsAq7kNwH4fr97mqX0e4dd5PlcCf9YR9DCCGSVd11+bEFNMbZf/mC1gRVwYwv5K4yPRDCjFUF7u03XdrNr3+3FbgsdPQsk682eJoDT6WxKy4w8QZbWnUPyWOBigUuEk49yBexGVA+36GshiZ8Mkvg8Gc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB4974.namprd10.prod.outlook.com (2603:10b6:5:3a0::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4628.16; Fri, 22 Oct 2021 05:19:29 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4628.018; Fri, 22 Oct 2021
 05:19:29 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V3 08/11] vhost-scsi: convert to vq helpers
Date:   Fri, 22 Oct 2021 00:19:08 -0500
Message-Id: <20211022051911.108383-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211022051911.108383-1-michael.christie@oracle.com>
References: <20211022051911.108383-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR08CA0012.namprd08.prod.outlook.com
 (2603:10b6:5:80::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from localhost.localdomain (73.88.28.6) by DM6PR08CA0012.namprd08.prod.outlook.com (2603:10b6:5:80::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Fri, 22 Oct 2021 05:19:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1775d962-ee9e-4a62-73ea-08d9951b857e
X-MS-TrafficTypeDiagnostic: DS7PR10MB4974:
X-Microsoft-Antispam-PRVS: <DS7PR10MB4974C85837649F862CBC3A83F1809@DS7PR10MB4974.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HiEu35uMP1ug477/fbdzjo77qcT5bwUAbCqRxEMzrbstDM1X4Hg213A774wwiQPMP4vrbPU7nm/Hm/KA6gLUayFlqTBJt7ypwcqu379ph0kpK36SgHvXwIe7cCTFjQ64SQI5OzJqtNJjZ3k41e2vN00YGTBqZiVhPCs/RbuuIm2C1/tVuzoNt+KtO18SRpPExWqUG8/sUVbe2Y7O0T7YVhwWlRxZSZGdRcdWQK9qtoSmXUo7M/r0NxKcfQy4cr1bMSUu/dtZdYtN1sh9tGDnik6JtAuoGrGYqTDpN/hUugsH4m9o+tYufj1Ll/kVNsVVAOV8+oeDtkMHv5iG4qgneFDtIgHKU0YwdWzoeUUiPKgbtset/CZKwiaLVD3VUVGwkdpyjHLVbMxvHjcptzBs0s9MLLiuOTRb/tDQtCEUzJOKBmpFj7sxWTEs/G9MBJ1oRaQm9o1+sT5ZeQshgD8rqTTODGnmjLmDiQpVI1jPnKNGJ34Ske6UulkLH85MO+oAIjdz63fuEsbF40AK+6RqRE+oOhtCdU0Naov9yrY7LGQejZinp2mkc188x4NinlPJ7aNOk0edUp1aGW4Qu9u0RlXpIGT8+U5qeBNc1H4PeePNgYBpDb8mufLQHXneNl78xTYaGNFXz+eIOMutSJd74yU90CCzGTGkW2Rn7uypoVqZDr0wRhhrMRUUX5bAYrZjS50pVwA6Cb0JukJWv1tEjA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(107886003)(38350700002)(66556008)(4326008)(36756003)(6666004)(1076003)(508600001)(2906002)(66476007)(66946007)(8936002)(38100700002)(316002)(6506007)(186003)(26005)(6486002)(6512007)(83380400001)(52116002)(2616005)(86362001)(5660300002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q3B6HX5rR8kxxHJ2rKBrKBxITvJ3l2YalqHtJ+3f7uwM7tHEKIsFecjMTwHQ?=
 =?us-ascii?Q?GkFuxpHoyUkkK6DJgLeXhjtvTD/VDxgUGj5+AjRsaqLgNh0rYSjoRmUC+Qgi?=
 =?us-ascii?Q?sBmCxM/B0fG7lS1CaPUYsowUlK6pYVCb3wyrMp67r1YtNyumMziMWKnupJ+C?=
 =?us-ascii?Q?wMn7QvMq6Sadt/kfRvkUug8+nSBZZr+YYXNDhBLs9Q8LHevhMDRquD7crDl5?=
 =?us-ascii?Q?klC34BAWeMZ+CsN50GGE5CymjJCjaRkG2dS6qFtX4IzY8sJ7sxJtlHLQehF5?=
 =?us-ascii?Q?Aqc0qutc3hdjbFYrXoH49AZLy/TaQ8gvgO3OXcGmX4IMGqfP8VXboy4OJpwS?=
 =?us-ascii?Q?7jAxCpXo0TLCKcRfdJAACWKOo8Uh2I0OyfcYRMFVHLjHikyiawudF/QkjCRV?=
 =?us-ascii?Q?SaJkglYBcladZM1olxXg6yVgCNx16gkfHi3XRkqYvi0jU2OUYg34Zfx7cA9f?=
 =?us-ascii?Q?X1EUtkU78EYEzwusybAvCcQAi2L70qIwXH5iuA16blbXIRhm+2NFEOsR6d7m?=
 =?us-ascii?Q?S+Ca8gkKFK1MhUfNGRCpXMvi9QD/HgwVMHEC+TazZBFb+smuR7991fiFy0pY?=
 =?us-ascii?Q?8SSv0Am4yvLLdLgsRJ2Z+q/GWLRPgS+HWJUpUbE6y5SCrrWrYXPUaDYy2c5p?=
 =?us-ascii?Q?5VrTKncJOGZZ8zvtDcY4wqyryi7d24ngJKtq6N9PqbtvT0fxg+xYYz1lsVAg?=
 =?us-ascii?Q?F1gruRn8h05CtMgt8vYAlVciW4yOuU+73bstpXalfZIWQEDt/N5o+xpKtdtC?=
 =?us-ascii?Q?VJSOZ8MqzwBDQW36y3wnc7npTMwRBkbgGhGbuPnWeTHp1dS+Silye7a9BxWD?=
 =?us-ascii?Q?upKTiIV3WT82F7zbDpCIPhpl2BtVgWAcCVEhbqUkp1g/CQNh1KQBDDosHEzE?=
 =?us-ascii?Q?2Yg1Nx9bx8WSTmObya2c7uZ918Rs/rwJfoNRWjE2S4NcaTfuO/KRJtm87tYL?=
 =?us-ascii?Q?k5gbIzX1cl+o2IS3lwBktgytDmfFceYLpSJ5gD+AgbV2kMbRH+zWNF126egZ?=
 =?us-ascii?Q?2aaxFbCklTRMFOshKMzR+tWA04RoguRHkwf1i4qiY8Zo3Unq12i6j9FrusE6?=
 =?us-ascii?Q?ZKsd9yITlfyHJAVEa4XMSMAqKQybCpBVcD07sG8bbKiLBLvpzkpGtUY8dsFh?=
 =?us-ascii?Q?y5a6SNatdUdUCVPQ0qan85zF5OvmcuOFy+sFL7XRJ2+aG3c6dOJf1o6Hi+mb?=
 =?us-ascii?Q?9w/ubgu8RDVcXwI9YtevEPbOHP01n89ljGamiKG1kNR+gBSZwV/uKYj6M3+m?=
 =?us-ascii?Q?ErqDnhXjn6xVSGrw6jDlL5SfH0Db1GhQAon7CkDbmzpEBDVKTP4y59zlr/j9?=
 =?us-ascii?Q?2lAGtjkr8IIm9zT0GqhJ8xR4QZvUotaMXg7bO+MV26+TrG79nbVaoCvhc7Zq?=
 =?us-ascii?Q?XfxZkoWVdLlYSHc/eDPN9zlmOTv8RbdS1j45JDfsvROtd0sO9kqC/Ee0AWk8?=
 =?us-ascii?Q?nAS3CDpdxvXrzLuf6Ks3gbDxjs1kGpLo?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1775d962-ee9e-4a62-73ea-08d9951b857e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 05:19:28.8887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: michael.christie@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4974
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10144 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110220028
X-Proofpoint-ORIG-GUID: 3hpEvaGvrUQG2WsglbfQLxeiY9sw1qDj
X-Proofpoint-GUID: 3hpEvaGvrUQG2WsglbfQLxeiY9sw1qDj
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Convert from vhost dev based helpers to vq ones.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 0d85ddb68420..08beba73ada4 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -361,8 +361,9 @@ static void vhost_scsi_release_cmd(struct se_cmd *se_cmd)
 	if (se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB) {
 		struct vhost_scsi_tmf *tmf = container_of(se_cmd,
 					struct vhost_scsi_tmf, se_cmd);
+		struct vhost_virtqueue *vq = &tmf->svq->vq;
 
-		vhost_work_queue(&tmf->vhost->dev, &tmf->vwork);
+		vhost_vq_work_queue(vq, &tmf->vwork);
 	} else {
 		struct vhost_scsi_cmd *cmd = container_of(se_cmd,
 					struct vhost_scsi_cmd, tvc_se_cmd);
@@ -1360,11 +1361,9 @@ static void vhost_scsi_ctl_handle_kick(struct vhost_work *work)
 }
 
 static void
-vhost_scsi_send_evt(struct vhost_scsi *vs,
-		   struct vhost_scsi_tpg *tpg,
-		   struct se_lun *lun,
-		   u32 event,
-		   u32 reason)
+vhost_scsi_send_evt(struct vhost_scsi *vs, struct vhost_virtqueue *vq,
+		    struct vhost_scsi_tpg *tpg, struct se_lun *lun,
+		    u32 event, u32 reason)
 {
 	struct vhost_scsi_evt *evt;
 
@@ -1386,7 +1385,7 @@ vhost_scsi_send_evt(struct vhost_scsi *vs,
 	}
 
 	llist_add(&evt->list, &vs->vs_event_list);
-	vhost_work_queue(&vs->dev, &vs->vs_event_work);
+	vhost_vq_work_queue(vq, &vs->vs_event_work);
 }
 
 static void vhost_scsi_evt_handle_kick(struct vhost_work *work)
@@ -1400,7 +1399,8 @@ static void vhost_scsi_evt_handle_kick(struct vhost_work *work)
 		goto out;
 
 	if (vs->vs_events_missed)
-		vhost_scsi_send_evt(vs, NULL, NULL, VIRTIO_SCSI_T_NO_EVENT, 0);
+		vhost_scsi_send_evt(vs, vq, NULL, NULL, VIRTIO_SCSI_T_NO_EVENT,
+				    0);
 out:
 	mutex_unlock(&vq->mutex);
 }
@@ -1428,11 +1428,10 @@ static void vhost_scsi_flush(struct vhost_scsi *vs)
 	 * indicate the start of the flush operation so that it will reach 0
 	 * when all the reqs are finished.
 	 */
-	for (i = 0; i < VHOST_SCSI_MAX_VQ; i++)
+	for (i = 0; i < VHOST_SCSI_MAX_VQ; i++) {
 		kref_put(&old_inflight[i]->kref, vhost_scsi_done_inflight);
-
-	/* Flush both the vhost poll and vhost work */
-	vhost_work_dev_flush(&vs->dev);
+		vhost_vq_work_flush(&vs->vqs[i].vq);
+	}
 
 	/* Wait for all reqs issued before the flush to be finished */
 	for (i = 0; i < VHOST_SCSI_MAX_VQ; i++)
@@ -1967,8 +1966,8 @@ vhost_scsi_do_plug(struct vhost_scsi_tpg *tpg,
 	vq = &vs->vqs[VHOST_SCSI_VQ_EVT].vq;
 	mutex_lock(&vq->mutex);
 	if (vhost_has_feature(vq, VIRTIO_SCSI_F_HOTPLUG))
-		vhost_scsi_send_evt(vs, tpg, lun,
-				   VIRTIO_SCSI_T_TRANSPORT_RESET, reason);
+		vhost_scsi_send_evt(vs, vq, tpg, lun,
+				    VIRTIO_SCSI_T_TRANSPORT_RESET, reason);
 	mutex_unlock(&vq->mutex);
 	mutex_unlock(&vs->dev.mutex);
 }
-- 
2.25.1

