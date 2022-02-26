Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59823C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Feb 2022 23:05:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbiBZXFi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 26 Feb 2022 18:05:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbiBZXFb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 26 Feb 2022 18:05:31 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E3115C66C
        for <linux-scsi@vger.kernel.org>; Sat, 26 Feb 2022 15:04:56 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21QI88mc008207;
        Sat, 26 Feb 2022 23:04:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=w36kmbvE03CotuJo4e7VJsDHPTfoezEt666a0noBitw=;
 b=lEjyR86ou8skMLnaxcjzKrgraF8YHeF3iqTPZ2wy9eweLvbTRnmfaziwMs88y3oWuHXj
 MjBS5dCT601/O3/UEGAeQW1B9cCILMVYYPREfS6RZ6sHiFQdf98dRvwXrg01MXrjkWI9
 XOdh3+CrETKsIePM1h55V+Q8iSM08DtsFw2jN2HfOETu1ZikylqCHX6KBZi7vglzpLqG
 0/IWfhm2mtJjKrgOrEeCvHD5p2LLX+c9e5ZEQirOVD65E8biXEp5DlWQqc4OciSqDvzX
 xcwokJErkFSvkOJU6H+efCi1gU/C5/L0qFLv9DSVV8XFr6qTnbDkvMqtB1Pv6OusTGvA /w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3efb02hbcd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Feb 2022 23:04:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21QMtm5I027402;
        Sat, 26 Feb 2022 23:04:49 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by userp3030.oracle.com with ESMTP id 3ef9at5krx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Feb 2022 23:04:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z0BStM58Y/QrorzE/JvegkJKDiP3QbUUS0pAoZjEvPQJiSUFHboijsQ2itZRnbNk0U2uz1uGlfSFC8ryUcDvIHIZSJnZ+avXH3e3j+afRxDpki8qlsyuvk/DaGYwhSLoThxuiE10vMbffJDDPoZQWk7P71cVsJR0Ig6ldYLlqOF1aaFBl1BMcDHTAFMSNLl9bJMrLMt9D54XWo9cW2vk9g4uLVVtTsj0lYhOXWTCZdm8AU87TGu80jruNeVK8OzF3ZaxR11FQpb3IID0ju1ti7OPGNg7eEZQGeW/uAkfUn+EVm+oqjy1/g9RF9Ri49xXI79uJD44ArWkpD9f0LFPFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w36kmbvE03CotuJo4e7VJsDHPTfoezEt666a0noBitw=;
 b=QdrdQBONXVZCH/PoZvhKbUY4BxYOGHNy/PbBkYUaUCIGY1b4meAJ1gbCa8q4jE+3l5OEG7JptNuAetjNlkEGhXs9TDvlnnihn2sJA4XM2fHamUVx9Yo+l+U+wM/qmAvg0JTrVPTF211ZZx3AsZ1bvmnNtVuUqgxL6irFdMoCx1KcB7R3xPLcSJVvU1wjZIudjFWd6gOOplfK1GyOV9GB4jmykLXmmSXNU5/SWi4+rjqsgOVdQsZ3HUqOZNL+fXPIaT9J7O7T5Q0VSmOy3scFEK7Uyee8B+Ws755bM7rRqQLQrSGa4AyZLZRYET58LMmCRMhv8sm3/yCANJEazY1cHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w36kmbvE03CotuJo4e7VJsDHPTfoezEt666a0noBitw=;
 b=XjqmmkrTipB6Nr7OxTtuf/yshjhIBRXdMoqfzajZVyvtvcZVYT4uv95+P8SlCqLSwLoQo8XT1z5xl2544m3Po6F5Jo9N3YdJHq5lLe/KPGWe5gMaFtXRN788XoXlXcdcn+6UR2Fox0nJiTnyaDIN8vTHdGKYT13LxyIs3rQq7QU=
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
Subject: [PATCH 3/6] scsi: iscsi: Remove iscsi_scan_finished.
Date:   Sat, 26 Feb 2022 17:04:32 -0600
Message-Id: <20220226230435.38733-4-michael.christie@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 58517632-d96a-4cf2-f4f8-08d9f97c60f4
X-MS-TrafficTypeDiagnostic: MW4PR10MB5750:EE_
X-Microsoft-Antispam-PRVS: <MW4PR10MB5750AB069B1B3DA0592627E9F13F9@MW4PR10MB5750.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zlPn/YNyNTkHMOu8+4SGCtAt/PbsZsavgS0dDKrr5gm0c09wf+lBPqEhsdS69mpSERZm63K3VkxP6IbARFQGEVgQ40lTO5E7slZZAZoMb2f+a/rIluyHnu5d8T9YwP5SnsjHra4Nbc4X40vGwHIFSpqpx87gMDvmEo1sv135gAD3iylTykiGg5O1z8ItHh7ZxpodkE8YI7MAGoAgOGGarZJ+Rm4oirf/q+wTRKxLa1E/TnW0tcm0AaxLHWg5s2QH1PR9jIcNRlGURmoSXp4tkSGjKgNMhE1rzAGEsuVFA0KzNV/gbgxhEZ+9GPr1oVDvRi/xfwzUi4cjyBP8rpFQO6U2Wg0tfmtyO76Ih9ieLzYZia1uAnaORXsPMijsmOWXahXTrk10otBbREJE8a0Imf7Zas/ubjqgg8khlOBwrdozVdKlE1ru5v9cYTIhvh7FF3vnOlAQIU6OgoEAvUKXJUFqhxFKqSlKb/woEB1RPF4LOEJ5saVtnoIs8RipMRegn8VjeqGuwUxr3Mwzte4AkdyYDxLXoB5AIN59gnSuxpYhg3ia6JTPe+gsRf9R9lC56hYPZTAA24J5M3jHq7wIKl4bxQGIwTc9pvTXAeBzJzsFMP71s2DEA6MYFdfbegHwNfRPh6/cJGRzSWpz7A87XHvPMBCY5UbchZDE4V1EfjYfCX9TwPylDIW964LN756NL+K9tsI+DjLP3hr4DaTyAQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(1076003)(107886003)(2906002)(5660300002)(66946007)(4326008)(8676002)(36756003)(186003)(26005)(38350700002)(38100700002)(2616005)(66556008)(66476007)(6666004)(8936002)(6512007)(6486002)(52116002)(6506007)(83380400001)(86362001)(508600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fx3/pkPw4BPVfciLZLtwxwA7dCCq9OQSEDzE+GmLYxWYwvv5Iyt6uqozY7O1?=
 =?us-ascii?Q?cNsDimDbFQxzNuTLvNiYy8twxVqDaGQj64Q9r/7bb0OUcwhDECNWSKg+jkCK?=
 =?us-ascii?Q?hAOQTzEdxOvXmR7UahI0Vy55i65OGzQIW75/qRk5pgzhjcp3a6olhdHNLJWt?=
 =?us-ascii?Q?QO0DJj1JLk0xhSSXfd7DJ230bRZNq4RirQo/c3IgiHoqD4dDj6oVDrVQ/oqh?=
 =?us-ascii?Q?k77AeM/a65q9GWCtjljfJEIRGkxulSpgPrqVWr55m8S6/Mb44AfHKjm3ZAzZ?=
 =?us-ascii?Q?uhkLde1iPNIs7EQRjpjshmUJTTheibQc66pYxpv3DtnHd4TeMD+/ErAIy3JP?=
 =?us-ascii?Q?cAIV4Gqs8iFqIXG6lXDNcd9eUFtgYPSaTEXme38X9aq8fRr5vbQsy2x6c5UB?=
 =?us-ascii?Q?DFiH60a2VPk+tMtNjeIUg8IzmQnL3iicChAueep29qdut1Vs7FfVAeDA9mba?=
 =?us-ascii?Q?myW1bD4fJNLxz8/UtUii/2fmzqQxboEKZ9Rzw+BLg+ZFRR/x6xWlfpzLatdM?=
 =?us-ascii?Q?fM0n/Dinzo54wJOibV1byXIiz7vOgNeyjzejQ9F3IceBV8zeZjMvmd9n38uE?=
 =?us-ascii?Q?D0mhC19DTsdEzqpn6aM0fTr1b8eZPwnJKyTaoqNBy90TE0pN/uz75s0evTdq?=
 =?us-ascii?Q?3EDRw31c/bWUm4jgp77y9LV5KlTo1/aHWvdo/JyQEg3mwsSghw3CXVBdYmtc?=
 =?us-ascii?Q?Tf5fTajDeTn8emGzdFxwSAu+wsslcEU7AKF0owtXp8lD51t96HLifX5RUTBf?=
 =?us-ascii?Q?pCwxap56E21oYCEttzkRo5/FeT9mKurKhi9Xo7SgwIfxaEjNN4rEwE6cGc8C?=
 =?us-ascii?Q?I6YL7c6FOQlZU5huxCpClmyceu7XhbL9FNoZ33qqro+5DNeCX00IMCdWTWxD?=
 =?us-ascii?Q?+DQaqYhoyGeRk1ug6ybTOS0qiQDtjaB+yWiEv3HrWcfH9HL64YIZmtRVIcvL?=
 =?us-ascii?Q?s5Qc3g8hHbx9lanJB+msKjbQneixRmVBf7PFqJpiF8NVH91DjULWZtSYzU2L?=
 =?us-ascii?Q?0+9n28MroxkRnPWwrSSshga+HqzOC74yjg8538CqVckoBJ+BiZE4iW4elPiH?=
 =?us-ascii?Q?R+ZauPfAKMG/UUB7/V3qTEoKezZaYhHQRAT2XJ+dUseU9jy8z9fxXKbSd7wN?=
 =?us-ascii?Q?Sv2PvQu7j2BXwd/agFAaMBlRBRosxsyP3hAn5Z3TOXVlKiJy7O/8hDgd01QA?=
 =?us-ascii?Q?kcG+H5esulzceJ8RVFnvES603GdIerUd4xClvMdtzLr9H0AA3Was8VRRd8+z?=
 =?us-ascii?Q?W4XGZu/QE8ssxpvpKb2G9AEpX4x7KOYrdqBhXgXMZA7/nCNdpMXuDFW7PC3X?=
 =?us-ascii?Q?Xb08UoDl0o/7KwcHJQROmXwdngqTruD4QDGujuEPmyiZKm1JgU783Q4nf34C?=
 =?us-ascii?Q?L8PF4I464vomt6yZArzK+cKhFpS7vwU98QMGgtL2DP/ByzruEZumHGDIjE9A?=
 =?us-ascii?Q?N24PhUbxEC4tRWMKBf2NyQCfirwNrtGImhvGpsC/ZF0NgWyjAPFojQ/ITbif?=
 =?us-ascii?Q?bCN34+9Vvke7TNZhjtEmAN28jzYiyG4GpblMxELVpc0Ls9Mkr+xHw5f+bM54?=
 =?us-ascii?Q?kSc0jxKQFGgvvvcYVlW/LS4HlDoXCk1yAUSqiicfNF3adAROuOOU4vwEuowV?=
 =?us-ascii?Q?ck2V3imbtVKeV5IAYap013PHYrHX4STrm80jfFSCBd/zrbWN02FnGvgAf60p?=
 =?us-ascii?Q?7em7IA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58517632-d96a-4cf2-f4f8-08d9f97c60f4
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2022 23:04:44.9281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ifAXL9dSWLzD5ZdY2h5QAtbyFUWL5RL2gwpJO1gF171BKhjuzc/Q3vzSzLfjfUWx3UpS2QrXY0Wv5beIKPADaz4t7yJTBB6AiObTDP+UnbQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5750
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10270 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202260163
X-Proofpoint-GUID: -VpFJys-r6rs9P_mTJ7voRHpthEoD_fR
X-Proofpoint-ORIG-GUID: -VpFJys-r6rs9P_mTJ7voRHpthEoD_fR
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

qla4xxx does not use iscsi_scan_finished anymore so remove it.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 39 +++--------------------------
 include/scsi/scsi_transport_iscsi.h |  2 --
 2 files changed, 4 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 732938f5436b..05cd4bca979e 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1557,7 +1557,6 @@ static int iscsi_setup_host(struct transport_container *tc, struct device *dev,
 	struct iscsi_cls_host *ihost = shost->shost_data;
 
 	memset(ihost, 0, sizeof(*ihost));
-	atomic_set(&ihost->nr_scans, 0);
 	mutex_init(&ihost->mutex);
 
 	iscsi_bsg_host_add(shost, ihost);
@@ -1744,25 +1743,6 @@ void iscsi_host_for_each_session(struct Scsi_Host *shost,
 }
 EXPORT_SYMBOL_GPL(iscsi_host_for_each_session);
 
-/**
- * iscsi_scan_finished - helper to report when running scans are done
- * @shost: scsi host
- * @time: scan run time
- *
- * This function can be used by drives like qla4xxx to report to the scsi
- * layer when the scans it kicked off at module load time are done.
- */
-int iscsi_scan_finished(struct Scsi_Host *shost, unsigned long time)
-{
-	struct iscsi_cls_host *ihost = shost->shost_data;
-	/*
-	 * qla4xxx will have kicked off some session unblocks before calling
-	 * scsi_scan_host, so just wait for them to complete.
-	 */
-	return !atomic_read(&ihost->nr_scans);
-}
-EXPORT_SYMBOL_GPL(iscsi_scan_finished);
-
 struct iscsi_scan_data {
 	unsigned int channel;
 	unsigned int id;
@@ -1831,8 +1811,6 @@ static void iscsi_scan_session(struct work_struct *work)
 {
 	struct iscsi_cls_session *session =
 			container_of(work, struct iscsi_cls_session, scan_work);
-	struct Scsi_Host *shost = iscsi_session_to_shost(session);
-	struct iscsi_cls_host *ihost = shost->shost_data;
 	struct iscsi_scan_data scan_data;
 
 	scan_data.channel = 0;
@@ -1841,7 +1819,6 @@ static void iscsi_scan_session(struct work_struct *work)
 	scan_data.rescan = SCSI_SCAN_RESCAN;
 
 	iscsi_user_scan_session(&session->dev, &scan_data);
-	atomic_dec(&ihost->nr_scans);
 }
 
 /**
@@ -1912,8 +1889,6 @@ static void __iscsi_unblock_session(struct work_struct *work)
 	struct iscsi_cls_session *session =
 			container_of(work, struct iscsi_cls_session,
 				     unblock_work);
-	struct Scsi_Host *shost = iscsi_session_to_shost(session);
-	struct iscsi_cls_host *ihost = shost->shost_data;
 	unsigned long flags;
 
 	ISCSI_DBG_TRANS_SESSION(session, "Unblocking session\n");
@@ -1924,15 +1899,6 @@ static void __iscsi_unblock_session(struct work_struct *work)
 	spin_unlock_irqrestore(&session->lock, flags);
 	/* start IO */
 	scsi_target_unblock(&session->dev, SDEV_RUNNING);
-	/*
-	 * Only do kernel scanning if the driver is properly hooked into
-	 * the async scanning code (drivers like iscsi_tcp do login and
-	 * scanning from userspace).
-	 */
-	if (shost->hostt->scan_finished) {
-		if (scsi_queue_work(shost, &session->scan_work))
-			atomic_inc(&ihost->nr_scans);
-	}
 	ISCSI_DBG_TRANS_SESSION(session, "Completed unblocking session\n");
 }
 
@@ -2192,7 +2158,10 @@ void iscsi_remove_session(struct iscsi_cls_session *session)
 	spin_unlock_irqrestore(&session->lock, flags);
 
 	scsi_target_unblock(&session->dev, SDEV_TRANSPORT_OFFLINE);
-	/* flush running scans then delete devices */
+	/*
+	 * qla4xxx can perform it's own scans when it runs in kernel only
+	 * mode. Make sure to flush those scans.
+	 */
 	flush_work(&session->scan_work);
 	/* flush running unbind operations */
 	flush_work(&session->unbind_work);
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index c5d7810fd792..90b55db46d7c 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -278,7 +278,6 @@ struct iscsi_cls_session {
 	iscsi_dev_to_session(_stgt->dev.parent)
 
 struct iscsi_cls_host {
-	atomic_t nr_scans;
 	struct mutex mutex;
 	struct request_queue *bsg_q;
 	uint32_t port_speed;
@@ -448,7 +447,6 @@ extern void iscsi_get_conn(struct iscsi_cls_conn *conn);
 extern int iscsi_destroy_conn(struct iscsi_cls_conn *conn);
 extern void iscsi_unblock_session(struct iscsi_cls_session *session);
 extern void iscsi_block_session(struct iscsi_cls_session *session);
-extern int iscsi_scan_finished(struct Scsi_Host *shost, unsigned long time);
 extern struct iscsi_endpoint *iscsi_create_endpoint(int dd_size);
 extern void iscsi_destroy_endpoint(struct iscsi_endpoint *ep);
 extern struct iscsi_endpoint *iscsi_lookup_endpoint(u64 handle);
-- 
2.25.1

