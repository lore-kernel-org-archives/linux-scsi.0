Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA41FC433ED
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80BAB6135E
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236953AbhDCXY1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Apr 2021 19:24:27 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:44924 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236940AbhDCXYO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2021 19:24:14 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NLnO6098586;
        Sat, 3 Apr 2021 23:24:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=zkNnC5Zr/pyTVSPyvFmOs3tX4G4i76Ec274o9Fpsk5M=;
 b=dWYDlE2NTXL+rPVKMSRWxSYL+yaEMP9xNOv5e9CLLKN5MHCqw9Yh+2eNS9byFlk3oN83
 dcqv3yXu3BfX6JDfhXO4YdblKJyullPXhg8ETk/I4bdpvNdx14259rN5yzZ1aF7fqJBc
 lDYr1mOW9g4TQVj+pA+ZLYXZ7rKoK8OmXbOvdHnTcx6J/5McskGBhBLHMxGdUDIYFyMF
 VgtAEXliIn9Cjv6RMiIaJPxwKXZ8wGcHlq7ib5MjxRDZ3IdgBov33DrmLpQPnGRMQ6QP
 rMxTKE/BXQDPraUk5dn5y0jpFtxi9WA1ViYpQv2T6rAzbXtbtfups8nRg/cdGmoMD6Wd Wg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 37pdvb8v6q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:24:02 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NKDHP132673;
        Sat, 3 Apr 2021 23:24:01 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2052.outbound.protection.outlook.com [104.47.45.52])
        by aserp3030.oracle.com with ESMTP id 37q1xk81k3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:24:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mezvyiIpVGMfeAV0OF97DXHE7vmMZELvNPbJ7v36RxdYOXDmDlVfpSD0uxi3G8LmKlH+Ja3u3vMKUO4gaab4FCKIvHdjRmgxKYGbjqrP5I+bWcIwhWhh6jxDYyFRRdZnaC4osJN41LrsIE54+lsGFLMkrpLquadD3EPSzicqyQ6Iw+kV1wvTmZNdlJDNC7R4qnyuL7dHUgwXAlGHOzyz4wrpvGftBdMDanVR3MNsqyuEqAog7eEFtRSuQeYar8jFmSyI+UD2E2nL7XnC0KZOtfWE+8D39IIX8H5IVxysqDpr4dq63hiFLwrY1ytZqbsffIZIo35VGRipmLpujurz+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zkNnC5Zr/pyTVSPyvFmOs3tX4G4i76Ec274o9Fpsk5M=;
 b=TeffIAm01xI4YmEGzVTqeEVaqzfJPXYan3D6aCJvEOcrh3CZ0h6uB5MODPisUOSFW4az+51QBdvHhszTcZ+MVqCAopi/780BD1ZnSRp7WPmznG9HzKpX30T25cNhGlYx/rzHBfbRMTp3aYxfMkoyn2aakAM31DpTQ33WAg78uqp/8IF8VPmMbJJNKYeZ3hc17hBQkOEfptRH4FfimXHMP+4JYmX7404CA3nT0u+XlXR7AQcnk7JV84vWh7CqE7a1M3dIyR+eYcZM79UOrYLtWs/oD4LWcUO4lHhPjKpzbf1FQrWIJ160HpU7K22O6tpoBp3LGm8DTzCRcDUKiFF0QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zkNnC5Zr/pyTVSPyvFmOs3tX4G4i76Ec274o9Fpsk5M=;
 b=v8GK3txCeX6yNSg4JD7dgeOFwSWbR5fjK4iRyiAEZDpmHiRAAGz4NTEHAeCA5Roh1FCpoCrT/7tDhLd2JWXgWRp4KUH8AqZ9Tp9JIsnY1nNcK4dscHjy3HrfQrsaFpgrvQiMck72paE3QG5qBpBeUje+maDfz6OJkM2uCIuXdmE=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3526.namprd10.prod.outlook.com (2603:10b6:a03:11c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.31; Sat, 3 Apr
 2021 23:24:00 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3999.032; Sat, 3 Apr 2021
 23:24:00 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, subbu.seetharaman@broadcom.com,
        ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 12/40] scsi: libiscsi: use scsi_host_busy_iter
Date:   Sat,  3 Apr 2021 18:23:05 -0500
Message-Id: <20210403232333.212927-13-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210403232333.212927-1-michael.christie@oracle.com>
References: <20210403232333.212927-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DS7PR03CA0137.namprd03.prod.outlook.com
 (2603:10b6:5:3b4::22) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0137.namprd03.prod.outlook.com (2603:10b6:5:3b4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Sat, 3 Apr 2021 23:23:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef46426e-6090-4be8-ddaf-08d8f6f78fa1
X-MS-TrafficTypeDiagnostic: BYAPR10MB3526:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3526CEDE9EF6ED5A8DE03E8BF1799@BYAPR10MB3526.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:330;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pynhm+38Wr0OWBE42PK32vp5tQSNUtxNkNLuYvo4G0Teu3mh/SIpGLmQW0pOJTMiEruin3pULD7pflbF2xgjbWIjVOfJlxZAD56qPMLIO8nbLVsAzxySJqaCtcRiXyp8hONxHH11byKcgw7MRCDEaINsRaqOLIhtpBTAJe+V3pBm59JYY6ob4HBQ8JGzZPbP9stx/q80iYk8MKrIyZ1fX0QZEpbMNvYGzbjsPB52dfRki9/8WKuVGYciGLfTGUDWuxcJnNUm1EEX9LCROgo0rP8W7KY+uTXXs5uPqC+Sv6UWJOPaWcas2/vSnQbJPdFgUWCsyXxsqAmzWndVeIhlBhU+gHDPPwiBcPoYHZ+v6bnhO/uVZPgyDZBxUojdUt0r+TUL8hRX/VKYvpp4puJdfXz9Cz+Ilk/xDBcXH0hrddaoYsg4pL8kj7BeSLdWq0kyOORRTl7lKgc44CFrjaP2f67DcKzLKw5A6uhmspMAxEne2r4s1pvS9SqPqPnNMyIpu0/qyUYwhKftwa7w6Vx9iT8oKZ6OiaEdieD35KRiqUun/ed9tGL/T8FDUCIwdAIMxyJZ8KuFz8HdABVeok94HSIJ2k2yjr34giltxGI/8Q9qnoMrMa1wlUjMHsK/ryEG/F30/uNlxIdLU9sS/5hHyqGdZX5qB08LerQq6T6gE82P4iIhBC/ghkf9RRqYofDJO+L1NyUYqhwf5Z2EJzi6Hw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(376002)(396003)(366004)(478600001)(5660300002)(69590400012)(921005)(86362001)(6486002)(107886003)(1076003)(186003)(52116002)(16526019)(2906002)(26005)(83380400001)(6506007)(36756003)(956004)(2616005)(7416002)(6666004)(4326008)(316002)(8676002)(6512007)(8936002)(66946007)(66556008)(38100700001)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?AORdV6bhb62vHpZR5n0SLuIms2guf3Wzu4J7RR1deEOQGWyZVsL2r1Z8hWGs?=
 =?us-ascii?Q?a4rYw809FHb9FiSCIS9AosGFW/MjoOIU07n+eIKgcvap4J67XLsilMvq/thA?=
 =?us-ascii?Q?UAWo5p9eCyMZ/SYbQb2UqIbYJ0YglClzx2/ub6EdWPnCXZtU3mT/c1cc1Z4k?=
 =?us-ascii?Q?0Cxmv93tdiPPZhGg/CU6eSvD3z2Pw/JgpoEJ9sbrc/GDSFyoQN1R9MWyzdN6?=
 =?us-ascii?Q?k9yGB9AT7uN3lsqFkr03k0+VWufC7cJW90O5ULJYYcq57SM8smQ6J9ylna/E?=
 =?us-ascii?Q?nEPk+6mEAegI9FNbsewYerLjSf4I8s1onaeCitoAb1RkPOOr3OM2dWkiYvMc?=
 =?us-ascii?Q?f3szv0x175eN7B/nAWYb1TFtSq6V8vkplUO2/R8QD8+pitKwFq5vpCZIloT3?=
 =?us-ascii?Q?E41IuDnDwBDbfvTTmDJwMDTC6DzVT0uesT1ub7ARKm+3zYt8q+cONn0DssKQ?=
 =?us-ascii?Q?Qs+bSJQZgjDWWJFjQ6OUlubAgjz66iQ5B2AE0YDoGGL3gLwabC33xI9xnWSX?=
 =?us-ascii?Q?SWtp3k7Rbw9oZVCEC4Sv0/Ny/83mo0TEfqMQRCdAB148/ZcrWWmdqLhQKOpm?=
 =?us-ascii?Q?di3rrwKyrc0Hs+vesD/JeVulMeQmpZIDJQ5XLNCfOMwb3yHuvMLIF9lj8nER?=
 =?us-ascii?Q?w3qg6R53BhRTmxSMGid88Q6nOJDE8ytpIFTXRx8Ohdx2vi0NndP92ycxyMQR?=
 =?us-ascii?Q?Ie+OiJOx7LG6FqOVdPS4izLo5KMcpGRQg2DCzNuM3Ptw/rAYgiPmCdzcC5yT?=
 =?us-ascii?Q?4DLZ2WSm5PoxC8UuyzSp26C5eCYeb1qamj+TID4VkFgJSlF0vy7LqFxUs2vE?=
 =?us-ascii?Q?uES/0USVFAHnXH2uTIWgV+MUj6MIRdeMZ9s9STP/2ILCXLgl61yBpL7M71DZ?=
 =?us-ascii?Q?s2/69X2U/r9BDdHwG4BcktwN/5rqMKypEKTZlkR5J8GSDO0wwAwnEERa9LzN?=
 =?us-ascii?Q?0QpQXiwwGHE9/WSnnrjJmk4UT1HwWSkuv1sze9EJEiHjJLpriSoV0JznlnoL?=
 =?us-ascii?Q?Gj3YAd7ieLVcjkgeaCWcPqlNejT9Dzg4tcBJJia8+eg8HP6ffx5DuUEnzGp5?=
 =?us-ascii?Q?hn6cbuwIp3172nebOHRczTsdWWRbPixHzazTcbVstlE67e/rjoh5nGITw0/0?=
 =?us-ascii?Q?Z7kgLicrQii+LfEE596psANNwKf9h2yq0Ey+Ln/gxPQd2uE1BtCDthLpqZHO?=
 =?us-ascii?Q?38N0QLhqy5xYQUGZvxCeY1BfPy/nE8m83asFzLUKVHfoQxwo8s1QynDFz12I?=
 =?us-ascii?Q?9F/RotiopH76YWr/eJews7qDo2Lo4qGk07Nn475JHF+SHy7LDz3xbzA4jS3M?=
 =?us-ascii?Q?TB9yNLEWtvJGjE7ziS5zBlht?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef46426e-6090-4be8-ddaf-08d8f6f78fa1
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2021 23:24:00.2348
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8ylDBFujb552EcqKLT8vpQeI7DtSCn3wPCc/6NPy4/eiiea/1ntvTI8uD6ZhmIvMGtF3yjCgFNAWKPiHMoPpEghZVaym8I1KbF4Kk+Wv1xQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3526
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
X-Proofpoint-GUID: seokZxHB-D4dZSSiN_bnQ0K6Q4z70MIh
X-Proofpoint-ORIG-GUID: seokZxHB-D4dZSSiN_bnQ0K6Q4z70MIh
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 priorityscore=1501 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The next patches remove the session->cmds array for the scsi_cmnd iscsi
tasks. This patch has us use scsi_host_busy_iter instead of looping over
that array for the scsi_cmnd case, so we can remove it in the next patches
when we also switch over to using the blk layer cmd allocators.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 160 ++++++++++++++++++++++++----------------
 include/scsi/libiscsi.h |  12 +++
 2 files changed, 110 insertions(+), 62 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 07b23f3967a9..8a9a9f5801e3 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1909,41 +1909,69 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
 	return 0;
 }
 
-/*
- * Fail commands. session frwd lock held and xmit thread flushed.
- */
-static void fail_scsi_tasks(struct iscsi_conn *conn, u64 lun, int error)
+static bool fail_scsi_task_iter(struct scsi_cmnd *sc, void *data, bool rsvd)
 {
+	struct iscsi_task *task = (struct iscsi_task *)sc->SCp.ptr;
+	struct iscsi_sc_iter_data *iter_data = data;
+	struct iscsi_conn *conn = iter_data->conn;
 	struct iscsi_session *session = conn->session;
-	struct iscsi_task *task;
-	int i;
+
+	ISCSI_DBG_SESSION(session, "failing sc %p itt 0x%x state %d\n",
+			  task->sc, task->itt, task->state);
+	__iscsi_get_task(task);
+	spin_unlock_bh(&session->back_lock);
+
+	fail_scsi_task(task, *(int *)iter_data->data);
+
+	spin_unlock_bh(&session->frwd_lock);
+	iscsi_put_task(task);
+	spin_lock_bh(&session->frwd_lock);
 
 	spin_lock_bh(&session->back_lock);
-	for (i = 0; i < session->cmds_max; i++) {
-		task = session->cmds[i];
-		if (!task->sc || task->state == ISCSI_TASK_FREE)
-			continue;
+	return true;
+}
 
-		if (lun != -1 && lun != task->sc->device->lun)
-			continue;
+static bool iscsi_sc_iter(struct scsi_cmnd *sc, void *data, bool rsvd)
+{
+	struct iscsi_task *task = (struct iscsi_task *)sc->SCp.ptr;
+	struct iscsi_sc_iter_data *iter_data = data;
 
-		__iscsi_get_task(task);
-		spin_unlock_bh(&session->back_lock);
+	if (!task || !task->sc || task->state == ISCSI_TASK_FREE ||
+	    task->conn != iter_data->conn)
+		return true;
 
-		ISCSI_DBG_SESSION(session,
-				  "failing sc %p itt 0x%x state %d\n",
-				  task->sc, task->itt, task->state);
-		fail_scsi_task(task, error);
+	if (iter_data->lun != -1 && iter_data->lun != task->sc->device->lun)
+		return true;
 
-		spin_unlock_bh(&session->frwd_lock);
-		iscsi_put_task(task);
-		spin_lock_bh(&session->frwd_lock);
+	return iter_data->fn(sc, iter_data, rsvd);
+}
 
-		spin_lock_bh(&session->back_lock);
-	}
+void iscsi_conn_for_each_sc(struct iscsi_conn *conn,
+			    struct iscsi_sc_iter_data *iter_data)
+{
+	struct iscsi_session *session = conn->session;
+	struct Scsi_Host *shost = session->host;
 
+	iter_data->conn = conn;
+	spin_lock_bh(&session->back_lock);
+	scsi_host_busy_iter(shost, iscsi_sc_iter, iter_data);
 	spin_unlock_bh(&session->back_lock);
 }
+EXPORT_SYMBOL_GPL(iscsi_conn_for_each_sc);
+
+/*
+ * Fail commands. session frwd lock held and xmit thread flushed.
+ */
+static void fail_scsi_tasks(struct iscsi_conn *conn, u64 lun, int error)
+{
+	struct iscsi_sc_iter_data iter_data = {
+		.lun = lun,
+		.fn = fail_scsi_task_iter,
+		.data = &error,
+	};
+
+	iscsi_conn_for_each_sc(conn, &iter_data);
+}
 
 /**
  * iscsi_suspend_queue - suspend iscsi_queuecommand
@@ -2005,14 +2033,51 @@ static int iscsi_has_ping_timed_out(struct iscsi_conn *conn)
 		return 0;
 }
 
+static bool check_scsi_task_iter(struct scsi_cmnd *sc, void *data, bool rsvd)
+{
+	struct iscsi_task *task = (struct iscsi_task *)sc->SCp.ptr;
+	struct iscsi_sc_iter_data *iter_data = data;
+	struct iscsi_task *timed_out_task = iter_data->data;
+
+	if (task == timed_out_task)
+		return true;
+	/*
+	 * Only check if cmds started before this one have made
+	 * progress, or this could never fail
+	 */
+	if (time_after(task->sc->jiffies_at_alloc,
+		       timed_out_task->sc->jiffies_at_alloc))
+		return true;
+
+	if (time_after(task->last_xfer, timed_out_task->last_timeout)) {
+		/*
+		 * The timed out task has not made progress, but a task
+		 * started before us has transferred data since we
+		 * started/last-checked. We could be queueing too many tasks
+		 * or the LU is bad.
+		 *
+		 * If the device is bad the cmds ahead of us on other devs will
+		 * complete, and this loop will eventually fail starting the
+		 * scsi eh.
+		 */
+		ISCSI_DBG_EH(task->conn->session,
+			     "Command has not made progress but commands ahead of it have. Asking scsi-ml for more time to complete. Our last xfer vs running task last xfer %lu/%lu. Last check %lu.\n",
+			     timed_out_task->last_xfer, task->last_xfer,
+			     timed_out_task->last_timeout);
+		iter_data->rc = BLK_EH_RESET_TIMER;
+		return false;
+	}
+	return true;
+}
+
 enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 {
 	enum blk_eh_timer_return rc = BLK_EH_DONE;
-	struct iscsi_task *task = NULL, *running_task;
+	struct iscsi_task *task;
 	struct iscsi_cls_session *cls_session;
+	struct iscsi_sc_iter_data iter_data;
 	struct iscsi_session *session;
 	struct iscsi_conn *conn;
-	int i;
 
 	cls_session = starget_to_session(scsi_target(sc->device));
 	session = cls_session->dd_data;
@@ -2091,45 +2156,16 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 		goto done;
 	}
 
-	spin_lock(&session->back_lock);
-	for (i = 0; i < conn->session->cmds_max; i++) {
-		running_task = conn->session->cmds[i];
-		if (!running_task->sc || running_task == task ||
-		     running_task->state != ISCSI_TASK_RUNNING)
-			continue;
-
-		/*
-		 * Only check if cmds started before this one have made
-		 * progress, or this could never fail
-		 */
-		if (time_after(running_task->sc->jiffies_at_alloc,
-			       task->sc->jiffies_at_alloc))
-			continue;
+	iter_data.data = task;
+	iter_data.rc = BLK_EH_DONE;
+	iter_data.fn = check_scsi_task_iter;
+	iter_data.lun = -1;
 
-		if (time_after(running_task->last_xfer, task->last_timeout)) {
-			/*
-			 * This task has not made progress, but a task
-			 * started before us has transferred data since
-			 * we started/last-checked. We could be queueing
-			 * too many tasks or the LU is bad.
-			 *
-			 * If the device is bad the cmds ahead of us on
-			 * other devs will complete, and this loop will
-			 * eventually fail starting the scsi eh.
-			 */
-			ISCSI_DBG_EH(session, "Command has not made progress "
-				     "but commands ahead of it have. "
-				     "Asking scsi-ml for more time to "
-				     "complete. Our last xfer vs running task "
-				     "last xfer %lu/%lu. Last check %lu.\n",
-				     task->last_xfer, running_task->last_xfer,
-				     task->last_timeout);
-			spin_unlock(&session->back_lock);
-			rc = BLK_EH_RESET_TIMER;
-			goto done;
-		}
+	iscsi_conn_for_each_sc(conn, &iter_data);
+	if (iter_data.rc != BLK_EH_DONE) {
+		rc = iter_data.rc;
+		goto done;
 	}
-	spin_unlock(&session->back_lock);
 
 	/* Assumes nop timeout is shorter than scsi cmd timeout */
 	if (task->have_checked_conn)
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 11f0dc74d4c5..5a5f76adbca3 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -469,6 +469,18 @@ extern void iscsi_complete_scsi_task(struct iscsi_task *task,
 				     uint32_t exp_cmdsn, uint32_t max_cmdsn);
 extern int iscsi_init_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *cmd);
 
+struct iscsi_sc_iter_data {
+	struct iscsi_conn *conn;
+	/* optional: if set to -1. It will be ignored */
+	u64 lun;
+	void *data;
+	int rc;
+	bool (*fn)(struct scsi_cmnd *sc, void *data, bool rsvd);
+};
+
+extern void iscsi_conn_for_each_sc(struct iscsi_conn *conn,
+				   struct iscsi_sc_iter_data *iter_data);
+
 /*
  * generic helpers
  */
-- 
2.25.1

