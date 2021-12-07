Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71F45C43217
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Dec 2021 02:51:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbhLGCzP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Dec 2021 21:55:15 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:49260 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231669AbhLGCzF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Dec 2021 21:55:05 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B6M56v5019273;
        Tue, 7 Dec 2021 02:51:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=n9igVpBgk9JOAb2qnFZRgyxT2Xy2Czyi0qJcVvkU+qg=;
 b=PuFS1pdx0/A7nGWqCcsuiQp24SFXfc9Dtv5UdxyOlwh1BZsChpRSqhJFaAdoRqu5dRmO
 unWTM9OdLUeDs+vVRNF6NMkx6f+m4vid4buKMHznUTP3ncwDN6uYlMeRHk708GNAfeHE
 bPC1VDKRa/2icBc8ZP4VMg3l3RoZPjZgYIhTZkekwSpKpnhqMN+0g3H0USlcLKEPrDDu
 jBzNIf1GXqjb11PKbGuZyKO7FBuGH2zCmvOELtBvxLik5SsIMIjp0BU3gc07tb5QkjOr
 GFLapearbzmZY8jaHpMJWcJ7LIAEQr2lLd8IWiVx3nuCaidaGZlUhWy22WNEKY/u6dcQ Fg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3csbbqmefc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 02:51:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B72kgld153019;
        Tue, 7 Dec 2021 02:51:31 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by userp3020.oracle.com with ESMTP id 3cr1sn5w2j-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 02:51:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fU9EFChevjslWzDWF/wEQ3PkGtqtgs3eDjK2h/5t0630B56GnCo+2G4aycrjA2lORSQS/2lUOOHUgoFqK5vHjas6qOD2282PEKCTGIavi34bdOJwaWV1JErmvS15Te1UiCCBqWbhGaR8yE2M73d4Fh7pK8dod+eWpid9LyLoo4vNbbL+ecvjoR6xwrNEZ4sMBfT2bHb0L2cv9NRiZgHLkIqPZb3+m4phwLppFqTzNN2mZn3y1GYH0svc6zXxThqYKIrlztvjO/S2wrj6KtgEw2/v/QEqw/eWPlJoDGMqIV6k42NhPjn55W9iyorPYtW1Wl/P6/Ea3IpDX9+qhXRkbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n9igVpBgk9JOAb2qnFZRgyxT2Xy2Czyi0qJcVvkU+qg=;
 b=Z2qqWnErN8sLyyUoaoAV7bh3mP1uciLqLwQY1V66nV5s/iEAcchMTYUuGz6QS/WkqvJrGt4Wd4inQGdA0EF0qKwAlbnpkKiqRMyJJTe2PUaldX692128EqIFJKfay9aCvE/60lugImyj72Ttp7Ik56kQ9y5yXQr5+zjacmptf+vhbt3LZVhtIqnYJYWqMhN9vpmEoN6juzA2vpWwKAwfzGKxcTdjtDFECJor3pHFnQEkWD1L7dahBorEe+uiXzLTFytwiyUjbOy9im3xG1VvU2GV3WwdALrYx1qx7NIFdPmjl9hSgooCj2tumeISGSQhpiuzrARoVN69VDDhfuZeTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n9igVpBgk9JOAb2qnFZRgyxT2Xy2Czyi0qJcVvkU+qg=;
 b=q+It34C2+ZxZYh+mIPLtKTO8/j1vnHqXa58Iybsk3VjfCCxbL5WXlApBVCtYJ6h6hr8kcjObVpfeQ31+awhJtLhAYUAwx/GpCOW+iQsvwb7Rd8kWaU8MsLy69Ts8svwl6Yh3NMKqWB69lQoxpLvweklpoFqu6/D7Him3MgD/byU=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB4347.namprd10.prod.outlook.com (2603:10b6:5:211::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.21; Tue, 7 Dec 2021 02:51:29 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041%11]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 02:51:29 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V5 08/12] vhost-scsi: convert to vhost_vq_work_queue
Date:   Mon,  6 Dec 2021 20:51:13 -0600
Message-Id: <20211207025117.23551-9-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211207025117.23551-1-michael.christie@oracle.com>
References: <20211207025117.23551-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7P222CA0021.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::20)
 To DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from localhost.localdomain (73.88.28.6) by DS7P222CA0021.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.14 via Frontend Transport; Tue, 7 Dec 2021 02:51:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d20dbcb3-df89-42b9-c4e8-08d9b92c77dc
X-MS-TrafficTypeDiagnostic: DM6PR10MB4347:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB43470240F8C6B6B1DEFE1B5DF16E9@DM6PR10MB4347.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:551;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ghT9Zmr2WUSxsyYi0tHgI4MY/0vC6FTWLT3Ujk056cmSIKfDYFNsCuFXkFIwiS+oW/8J8ExvvzxlF6zZcRNISWjXDT1qeVV/bJkiWEqp/x7RK9Sghomp3oYPVR2EtF879xi4Bc/Neyzlan4rWoECZTRvKFmRV+Fzm2BwncjnrpUcGDot+86rcbAbJr/vO5atpgKAfTTiI47IzkOpO7mBJNKzqV7oIFEmCYvGStqVTd650PGxDdW6JJnKeKGNP19XLNkT/U2QsRueoOPKJg5XCeCx3pnMYC62Bmp6IzOd4vyNaPeowEdYZyjstf2UXtGnas8rTf/b1Iw1vETDaFTDd4kO9REVcQ/aDaJhA9mlC3NpzomG8ihWebQbxzV5m+Rh2vBGMhX57klwhZOZ9n6zzyCCn+ThZHFQRcpU1cOnrxjXaPjKidvVXTlVICy13eTjDQhkri9ubo/ycxKWuMY/snAvWLiqYsUuDdbepaIeehyREWx+yRd7vZ7ybMFn65pl3pIKqh34pN96vF59minp4kelu9v0lR7u2fRRy0pxxRgCnylKUFcyuHapQWzLFKlNtrOJfLcNA0gLZD6IiQ3bG0LVyT20K/e/fppPfXGXF0IxVOU/KcyLrTRXy3ofENlrEtvUFesEshkHfK7xMczhQbPr8c0zTxrHxV1Zs8GS2WF/4K1frKMPUMCMY2VoK8DG8K1Mj0CuNPhrVFVNhkZ40A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52116002)(6486002)(956004)(107886003)(83380400001)(4326008)(5660300002)(1076003)(2616005)(508600001)(2906002)(6512007)(86362001)(66946007)(8936002)(6506007)(316002)(36756003)(8676002)(26005)(186003)(66476007)(66556008)(6666004)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AUi7kHlSgtfFdr6FFQkCJPki5ILgy4rioXyljdp5W+6/eNrMo184xdQmGRRi?=
 =?us-ascii?Q?uX6TNHYqK7nBaEtVWicvBHBtRW9g66otJ18CrdzYtS9pisdCPKKVKHqg2Eqf?=
 =?us-ascii?Q?dPf2D1FQb3h7SGaVo5o5MBQIAYO+qW5yIEJKpemHw9KLTA3cP1y+/kc9r7bR?=
 =?us-ascii?Q?VMXC4z0bPDjeyoEZCViGydFhykj8dsd6yjWnMrVfbvzjrZrZphboYyCTfGyL?=
 =?us-ascii?Q?mY7D2idXMGd1dx3kX2xhVFP6k3dRRrGAEUjc9rP03KDNMvYQYp4YLl/zb9g3?=
 =?us-ascii?Q?mxXOSjSsjBEKsxRGbrtKpze43uWyOk7AxYimd5qxly/UdZHBZBzhVL6W4/Hf?=
 =?us-ascii?Q?abkyVEm2JMEBci4tbwDwWtv8RKRU5JvIZLkXXydy5RUuq6l8gSdK9i6tz0To?=
 =?us-ascii?Q?14GP+LHomqElvnCOUmmgalIvU5m2vTwkWf/7zLxKcgJ7c/Zt0rCCUKW9jGFC?=
 =?us-ascii?Q?TItYcboHl9fWeKEjBTIYi8vbcCmzhQGFqLB0nQ7OWD9hXlG2BfWJMOEO754G?=
 =?us-ascii?Q?tpd/6zsCOsXLJLQaHhGdr60qKimccT+PJKwDiOrD7teheSjsDUhUuhkye3hG?=
 =?us-ascii?Q?6CLBgU48NN+7DvtIabTmjGAT9mXbg7sK7XxDnpSNqUYLkKRyFCaZEjKUxLYu?=
 =?us-ascii?Q?f1nVUB8bDuWl2MclLgeKK8lwajESI0jDSypkeNSmChzQT3MVT6oZkniz3Tv5?=
 =?us-ascii?Q?FM0pngGZ3TrlVUjkkHrQnhoxDsOabdj7h/whcHMfEOPM41NHR1LoGO1k1oIW?=
 =?us-ascii?Q?M0hAONoa0JU37aAveKEFn4fI0asnaMoUmegBYAbXde7fGclbyRmv1M6ec4RG?=
 =?us-ascii?Q?9MxLzS0BQn6pRzi8FV0LykYCnRF9ven+Ew21kq1R1RfDC+gl/yBWUj2q1ixl?=
 =?us-ascii?Q?S1iE7Ile9x0sv3R0keJJvzSVaB04X3e23yHTWBI8oP6balZ5mf9cmo3hijZM?=
 =?us-ascii?Q?NdjY277hlynfZgJQ4oaToBr8p01j8LlA0n5kvZK4Il3gVQWs+zYcuNSJxcRv?=
 =?us-ascii?Q?KZGwYAHyU14bjSTedYUHFjRjPuEeavgOuKcPVdXQHvbGK8rsvpLJevWKUpIa?=
 =?us-ascii?Q?ZSYzgGTtcpJMzTGDdeHKB3EMPDxJ6uLSrmoLxPYxBS7X51d9BI5nlbz5fxNJ?=
 =?us-ascii?Q?FM6w9rhttgH+YEZT/aCXC72OoBaQpUf34+7WwdrEpRksZb476m0VdV2ZfDK9?=
 =?us-ascii?Q?GKO5GrZndqIOtf3rPmwoGb461i/Vc5Z+bd/mJzVZPY3rTvdOkTMUGyfE3fSQ?=
 =?us-ascii?Q?tSz83ZrX3ptcBXPZRrqvkc7j4PoxQh0bRAOyAS0JUl179mMpAwePpIF+ZXY5?=
 =?us-ascii?Q?DwPcUcycXIhiLVKdwIl0RWcccw6zp3A/ciGZcgmDE1qFSe63sCGth8Q4Su6y?=
 =?us-ascii?Q?9p/ZBUSLwaMhlN1SlGhvxHrvnz2vKAD7ZuRvf3ExxfA83Xm6cl6A1tlmCC8+?=
 =?us-ascii?Q?LOJgsIeNx6mef8+TFKBPp5vPZi3uAlxTXB/11zzpIEhoZUBS/HqnS41tNjD4?=
 =?us-ascii?Q?ngNZPwTu8iJWhDuld+0UU3UMFq3LcoPvturEhCS9/obexoQW8uNhPhtJrgHA?=
 =?us-ascii?Q?apcM3p0gCXNoXpHHE2WehB4Q9SkCMXRcgbmiaZSgNvr3PMy5JqVo888lyng/?=
 =?us-ascii?Q?YzMQH8rtQfMc+ICBGRqSKgQ6R1aDMxO6VXwNDaZSP9FsiZqzs5xu2p8A1eGN?=
 =?us-ascii?Q?PxjhbA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d20dbcb3-df89-42b9-c4e8-08d9b92c77dc
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 02:51:29.1761
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TLoc79Uq5SpBM1SrKFCkWrlgtmMlWqLWPCEDXtaZXV97ZLkIP9IK5l4aBRp4gC8dhraVivCA141FulTaGc1VYdHUiMY+F+z7mBTjkSJ6Cfo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4347
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10190 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112070016
X-Proofpoint-GUID: BC8Yn1-zKo5nlKOmCbcUtkEJR6Mb-LcM
X-Proofpoint-ORIG-GUID: BC8Yn1-zKo5nlKOmCbcUtkEJR6Mb-LcM
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Convert from vhost_work_queue to vhost_vq_work_queue.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index b2592e927316..93c6ad1246eb 100644
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
@@ -1965,8 +1965,8 @@ vhost_scsi_do_plug(struct vhost_scsi_tpg *tpg,
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

