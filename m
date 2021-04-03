Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 848B8C433ED
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6302661360
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236919AbhDCXYx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Apr 2021 19:24:53 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49974 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237006AbhDCXYg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2021 19:24:36 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NKtUo160711;
        Sat, 3 Apr 2021 23:24:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=CariIWqCyjLXVqIAsJaDY65GTfRnVfmIoDnLetlH36E=;
 b=NR8PCjlKF4gzw1gjIFeHXpkh/t+0vQ9X9MPYu6cQeQGDQe6ALLuS9VtrrRgB3Z5K0YOM
 toq7CIdylkWGso1BiDOEU3Gsu3L77aRstVuGK1BraZEXUSSvUSPFU3OV3w5G+KQNTCTI
 m57CFfsWA9HO77LKTv099xzT3lQqPZP+7JXQXeAkNZM0qb+5cV8TJJOsDvLS7w5b/Ho1
 Xgs/kU58y+SJ2SzHIPIQsWTpmyCc0XaypHMcvQuM60LyVLwARj239C9pPyi+RBYrpvO6
 5DsXpLfRS/HclyEIkwawuBtnTKiWXcL7846q5xpFp5GlzfdCbQqkB7xU0qgJ+aY62Wwe PQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 37pgam8rpj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:24:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NL7JV130245;
        Sat, 3 Apr 2021 23:24:22 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by aserp3020.oracle.com with ESMTP id 37pg61huc2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:24:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ekjZF2d/8GckDhkQZNn48edU0GBdbBFAHF3t3ZCPDC+OZEMJB46dlyrJkx3bNjbd/VnACNHgSXmwRgIWzxIkzWhEPGfqnXmwQmM8ATF9gdyUFlIufdjPyb5vHG3flb3WTjlWe8dlkqkRS68g8fFsDxOpguwuw5NHUZHwshrzcbd24QH1Ahr66Q3uR/f2kZ0806HjMFQANiVRrMaDLK7uMaBn22W2T9/dQDCBZ/AgkZvFq3n6XbJDTz0GsRa5jW1YTLJY20lHQYy4lbDb+6Jum43xF/fDiv/O6dQxPioqrZUFjCSmnGrAZZ79zmLpLpkRFn6aXEDsxHcFuA2yC88EnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CariIWqCyjLXVqIAsJaDY65GTfRnVfmIoDnLetlH36E=;
 b=OrOI2+CZcn0efbedYBi4HDSuUJMEaNKzj1fnYMJF76D4l+z0myc6J5ZoE9N/IjhF6o6BVxxp9M3SaEkkgZUS9U93RcdC9AvCkbvaENrCeD5HfZ4mM0fBEGbCE8kWcLSAR8WBSHzmSqhgcH38QAYibk70UgulwWgy9lwKOFfDF7etvaoub0bTdweXio/w0Pjma57ZGk48OmTxqZmszjcQc/Yjt8D9jwnuZS1Cw2BFZQt+s6UabuKlry9RCfBbPj8+4mw2W+YXv/IWy5/Q1rvjUiaLTUYWhI8Ks/b7+wqcBgeZhKdLkK3Myh/aYfgvVSzS+ujrppD/AZbbu96SZJqbKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CariIWqCyjLXVqIAsJaDY65GTfRnVfmIoDnLetlH36E=;
 b=wUJwV3qAsOsQOy0g0Z/JBhGPn7QaleHSCpo+FUR+AyXX+D/zrUMTX4nbsyFCLRWvmbKcljeayOSq332Vq1R9cX5VUNenKMTHtBbaENI8VJGgE8HmHfMBdbHE6DWsRyn771QV1HB7wedG2ZXHGww/6cf190yBSJ4laIT/IiYWtao=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3431.namprd10.prod.outlook.com (2603:10b6:a03:86::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Sat, 3 Apr
 2021 23:24:19 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3999.032; Sat, 3 Apr 2021
 23:24:19 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, subbu.seetharaman@broadcom.com,
        ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 27/40] scsi: qedi: use task lock when checking task state
Date:   Sat,  3 Apr 2021 18:23:20 -0500
Message-Id: <20210403232333.212927-28-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0137.namprd03.prod.outlook.com (2603:10b6:5:3b4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Sat, 3 Apr 2021 23:24:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 542cf57b-5622-41eb-3f0f-08d8f6f79b56
X-MS-TrafficTypeDiagnostic: BYAPR10MB3431:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3431B58C784B3DA759EBB4EEF1799@BYAPR10MB3431.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m6f6Ull+aic1JeH8mgAqIBvKXkl3PKda/pF1v/AZuc+Ier2QwhL4xf7fTzsnugFMrpDcqOVsavAX8NUMzOts0/qeThEThlzd/ziPr23c84oWLRFzgfC8Kr/0nHztVHi5gRS4OHegCZVuXt34s/ckaQeOnR9vLnbXXTuk9UkCSDUOWdjnY/8D96XctPRLuin6KQwa5rHEeJNlV6kC5FP/6Hf4Av0v2YSHg3KpkPzUndDyQwp9fx5nwPyuu4s/OTzO1wyt67hCiFbu6Ss74u8rGLBO5n2l2+zNsgJ52PB/l8nhz518SN35UGzCZ1PTDMl5eypm0CgCbZywogc852cLEtaje+gmMNdn2VV2ieSgoFjTn5dJhHpf4yPukaHI1mLBOx4MOePhGPXabV+ohR/vrGvsPAef5Os5lr1Bv1A6277Kh1/cZDIYdWmWCYqUeUKcrUqTQQ7o04h0uHPK4UMy8L4DHhaMnm7OZE6MFzTkNv+fFXiDatimF5yuTUTdcjdAephQ7eO5v2A33Z7o64klJW4Y53aYw5b2fqlLrICW3+VkCUQyf22JVbffKp7Buz9+kgmf7xbA0Djx7RNF2p0TAl7M+6EY+RBTHKrX34PZH4K+WnCfBBiLNiruCNz9HAva3PD4j236ot3xF5Vpyv4eBWK8GmfA7GdCbLHROCFEPaoSqwoMUkH5iK5s0L1KxY1kMqg8udEBQoeajT9yqT+3Dw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(366004)(376002)(136003)(38100700001)(69590400012)(316002)(7416002)(478600001)(2616005)(921005)(4326008)(66476007)(6506007)(66556008)(86362001)(2906002)(6512007)(107886003)(956004)(186003)(8676002)(6666004)(8936002)(6486002)(52116002)(36756003)(66946007)(1076003)(5660300002)(26005)(16526019)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?vPTBxpFOdpbow/w1nOZ1UK247WIZVavPqbax/d6qqjmh6PZvFYOG39lvOoAq?=
 =?us-ascii?Q?Fei/ldPHjgVdKBxiN95SFVulM0iVZasBkq8MBxsjMHScCFn+du1Kjkgs7nBI?=
 =?us-ascii?Q?bLqAK7X5f4pa5wzV7kz0pB14mte3a6O4vIeRYk7KXbZ72oBRz+b0GVfS6C1B?=
 =?us-ascii?Q?9X2j+EoeVTkFJH1Gxaqv28Cd3HBpUCGYzmpbURq4wXy4m0gN7zVCA44TfQ7o?=
 =?us-ascii?Q?Wn0NL0Jf357VOJG0YHKSOdejs5TptRWL2kj13jdHxrzxBETbIo5rHEv/+JrM?=
 =?us-ascii?Q?tclzbN3vli7c1zkdiUs347pJ4BwpB467YEwwT2TIHfTwyhgrbw2pPwuyn/AN?=
 =?us-ascii?Q?xjXuqKrjTUvFt3DqkQ3yt5LL2+LnzalDGvHKjbQfpsxbBBaumZBdQVfG+1J1?=
 =?us-ascii?Q?4eEy580eYx9bfXLj25vRo+SYqih8DV3K7RKnBRxaFlArbLROcsaX4UIqHWgA?=
 =?us-ascii?Q?hHxmzy6cK9TNhm+oWBi3A//KqSY9lkb8gmLsedH7M5lbe+PAlMI1i3Vimjdt?=
 =?us-ascii?Q?TdRCw8FK/RD8P6mgQYhLHsZM+nNQi+CGhGFPjE/ls7vvvfv7GibdKHqiz2C1?=
 =?us-ascii?Q?ovdJ1WRy3dZbHwMj1wdy66RxF09jffNzCBEOGhCiF+CWtzRyixt2kP/jqMUH?=
 =?us-ascii?Q?prVuNup0Dg5YChwu0lct3p9Q06Tx/xIplJb2wlmqnaqIX2GT6gxpfWvFydE/?=
 =?us-ascii?Q?OLy1cgutu0R3CxRnEAvP3xJFJ+BE10D8d7Q3bBCcMJCMZfOypjFnfA7J7hlr?=
 =?us-ascii?Q?jmUckDhehpEUWnnwIjyFJ+Vf5qZkrLrabl4bhtW0TInxCtEY4Pn9W2fuhxju?=
 =?us-ascii?Q?jMA5xjLnRqzcAIEM50TCLRj/PMK2ZF3wNbOX9jdKFftXtweFIC0Gks2gDsW+?=
 =?us-ascii?Q?VCJiOF2FGXTlMjqprH647tHMyMxcDrL7Pv9S6dcdSm6MgHCFTOFU5TkHhZ8e?=
 =?us-ascii?Q?aF3k4YBxQTNdBQ5x9vJKapyqLWjxJSMU/C8qQD72AApr/ipKZ8g0DAOmV6e3?=
 =?us-ascii?Q?QKT9vJ/iagsc/BkpupdmFI5mPz/mQhWIFk88DI4eyqK7DX97YwPvxRrzpWaU?=
 =?us-ascii?Q?U7On47sE4D6QFFt1Dwxle68p1V91gT86ZAVjoKi41XXOnRaJRiRcXjdyrFcV?=
 =?us-ascii?Q?nvvfJQi6SDryF2aH3qCdtGYD804QvBvm/D99SeKUCmnCaN2eE4Now1PQdjZP?=
 =?us-ascii?Q?cs/vOFE/HwCvT83hybd/XQfWBFWVytPNmxQJkqv2wbAegXwKb8tdNvr506N4?=
 =?us-ascii?Q?lEB34eHr0D7xWamNfi+3y8ohS5xlv6vmD3WXCflRYEyZEEvEsyxG76/JPYrS?=
 =?us-ascii?Q?gSomkY1Xe0AaT4r99IsqdB8e?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 542cf57b-5622-41eb-3f0f-08d8f6f79b56
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2021 23:24:19.7880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oprztvs8R860GY4d4o954K5ejs5/vMzaWQOZy7ZruM/+O1QwQl8Z1qy+gPTqA4ILMzDEgdvVNzqiZsgLDkROuok7BG9HF3jewMR70H/8mVU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3431
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
X-Proofpoint-ORIG-GUID: wW6enn3mOAwNXSWgKQF9hW-QTJfVl9h1
X-Proofpoint-GUID: wW6enn3mOAwNXSWgKQF9hW-QTJfVl9h1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 spamscore=0 bulkscore=0
 clxscore=1015 phishscore=0 mlxscore=0 mlxlogscore=999 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104030165
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Convert qedi to check for task->sc instead of SCp.ptr and use the task
lock when grabbing a ref to the task.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi_fw.c    |  2 +-
 drivers/scsi/qedi/qedi_iscsi.c | 15 +++++----------
 2 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index e28dc249c9f0..de5133be1c4b 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -594,7 +594,7 @@ static void qedi_scsi_completion(struct qedi_ctx *qedi,
 		goto error;
 	}
 
-	if (!sc_cmd->SCp.ptr) {
+	if (!task->sc) {
 		QEDI_WARN(&qedi->dbg_ctx,
 			  "SCp.ptr is NULL, returned in another context.\n");
 		goto error;
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 0f3704c4c985..77f0445c0198 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -47,15 +47,10 @@ static int qedi_eh_abort(struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *shost = cmd->device->host;
 	struct qedi_ctx *qedi = iscsi_host_priv(shost);
-	struct iscsi_cls_session *cls_session;
-	struct iscsi_session *session;
 	struct qedi_conn *qedi_conn;
 	struct iscsi_task *task;
 	int rc;
 
-	cls_session = starget_to_session(scsi_target(cmd->device));
-	session = cls_session->dd_data;
-
 	if (qedi_do_not_recover) {
 		QEDI_ERR(&qedi->dbg_ctx, "dont send cleanup/abort %d\n",
 			 qedi_do_not_recover);
@@ -63,15 +58,15 @@ static int qedi_eh_abort(struct scsi_cmnd *cmd)
 	}
 
 	/* check if we raced, task just got cleaned up under us */
-	spin_lock_bh(&session->back_lock);
-	task = (struct iscsi_task *)cmd->SCp.ptr;
-	if (!task || !task->sc) {
-		spin_unlock_bh(&session->back_lock);
+	task = scsi_cmd_priv(cmd);
+	spin_lock_bh(&task->lock);
+	if (!task->sc || iscsi_task_is_completed(task)) {
+		spin_unlock_bh(&task->lock);
 		return SUCCESS;
 	}
 
 	__iscsi_get_task(task);
-	spin_unlock_bh(&session->back_lock);
+	spin_unlock_bh(&task->lock);
 
 	qedi_conn = task->conn->dd_data;
 	set_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
-- 
2.25.1

