Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCD65C4707A
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B30F461205
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231979AbhEWR7v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 13:59:51 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35860 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231967AbhEWR7p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 13:59:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHuWVc120959;
        Sun, 23 May 2021 17:58:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=yXvDvcSucPU2YWH/vVFxBio3rnH3jgORZPLMOzQD2jk=;
 b=YFkWmBANspdhbl5vDg1Yig/pPkiOSH8NkhH0Qykt8V/UoB93owR5H1I3W/tt7JIYkkML
 R7LBCeH+2ujwmgI/YFMNAce/ND0tBOvdjrgmdBQ9vsN1osTPPsz8OtVttKG3E++JgH7o
 Vb8k/jrYmSwtt3cBdE9jqSEGTa9aH9y8OBuEmTfr28P066TQHV7hLctjHm3em4e0Vglt
 XBnGWPlbCQPs9p/nHiB/HBXsrGZbLCjeJ1R5lFIOHVhweBQc0WQnU//w/RR47IMNu3Ax
 SrEGCjCZ/6fsmE2lAeC4GxuOBs3TaxZXimkXkkYeSHlTeYHf5NzvuPVhMtmDU5EiM+nb BQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 38ptkp1es0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:58:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHuctv161854;
        Sun, 23 May 2021 17:58:09 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
        by aserp3020.oracle.com with ESMTP id 38pss3qbn6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:58:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GtdSbrpyML+/URbgWuK1BQYeVQW5Eku26K5QvDlCxl3wkeiOkQKhbl2UsUYdg6d1lMkdj5Sp5Bomf+SAQK4fqWjKFZTfNwTujHwPgFPKlH/tmVR8U13JyRELhT/uw/Xux3ExQWsphAMUljvJsbTFF06215bGOPYSlAX8gxYYIWFeHPeIQKaIKjbKL/ROD6v5wtOAuodGq4SnyIq0yK131vhpLNcDnKhEohstqvj4eo4mSfPNp5u6B4VCFHRfRGG8hyuN13CZ0wLF8YeIFp0lPRIs7BqrKAJGGxPxeJYq9pviSccItGzXERHcbH7uRV/59xFD4iGFtnal+3bx7q6gDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yXvDvcSucPU2YWH/vVFxBio3rnH3jgORZPLMOzQD2jk=;
 b=POwElUPHuO0sFg3x7IFWdcO4uNbAr4kpBvaR8PfE/pNxiQRgABMjWbL5eQhCl0D6GMdX9xlmCgOEHHEFfBj/pzDoZBd4IET5vMnUD9OyCbGd1TPHHm3H+5hmrNPHluhXUz1Xs7HFJGkPEPO6Neesse/h+RkPIp+WgGV1dzVSgeSm8P7UZ3hEUhY1uEcgMhH7v4E/M0wb45iQYdU9fiFGz79OzswfKCAI0Ft8ZaWewuX8ScJTpnqGRSby/h4+6+lt83yQ/mSIZIs4chzYNt8dhwEi/b1iswiqYrOmpmOCuBqkJU+VqYQilaZ+n/UnzcR6zZiVxy4O3tT5rw7lft5ISA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yXvDvcSucPU2YWH/vVFxBio3rnH3jgORZPLMOzQD2jk=;
 b=jrGG2qOM+pntMuM4fsERtMBajZP6P1TLyZHI2jwmK+ntxyyOzzT19Q0v/o3Wr5UQe+DFspzkXDfYlSGDyrh6KzIcDJxprIEqZtIP0mApztDrdAASRolPU89qnIjGu6/SFJ1ErAnuQqYmtXFt8zyhmnIaBZlU9z1Rmsx2YyoPdvM=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4004.namprd10.prod.outlook.com (2603:10b6:a03:1b2::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Sun, 23 May
 2021 17:58:07 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4150.027; Sun, 23 May 2021
 17:58:07 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 17/28] scsi: iscsi: Hold task ref during TMF timeout handling
Date:   Sun, 23 May 2021 12:57:28 -0500
Message-Id: <20210523175739.360324-18-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210523175739.360324-1-michael.christie@oracle.com>
References: <20210523175739.360324-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR03CA0033.namprd03.prod.outlook.com
 (2603:10b6:5:40::46) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR03CA0033.namprd03.prod.outlook.com (2603:10b6:5:40::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.24 via Frontend Transport; Sun, 23 May 2021 17:58:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a92568bb-395f-4499-b5bc-08d91e145208
X-MS-TrafficTypeDiagnostic: BY5PR10MB4004:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB40045969860949D2033182FBF1279@BY5PR10MB4004.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DGs9qeLob/zsSqqmM6NjDFg/wGZu9E0GLyampAAIEzYUANPMvyxTZ/nyrmipc4LeY4CxSuHy27ullxrDRJ42NJ4jBANqJl7VIuGPYjRKMA8PbcsDb+j8Vj+vbKWX9CmRzXAeH5hPojb3HiUxF79YwHXlqFtjbPMK9BTWDl32zXnXfIkpH7X1cj1i3TS9NPbWh4ChUCF4ivJASYUAr6MR3Q0ivFwYAZkrVLA6CMy4EOghvWdLHvVI/+f0m4mUcC9AB6RfXw2yW60eq/sHqK90t4Y9OUCB82JLRyrL0fHzmeveJMxSJ+wIQZ72wiwJ/31UQA8FqGFR6q0LGhpuBVI7JvQs/RhUiyhj5CmVRwxyECGiArwgz+1FdDuCby/9fvxdD0UevqvOqvYL7nIjfmk9a8r3kxMNMsfYw4F8+l6mxWvlq7hCvIxiyz+FBOHD3BhTHxqJ3Ogshxlub0IP8BQ4rI0RDrBwqK3Nv1YAhrMV/4AK8KUo1jMQSyuv4DkV86BeKMyJMeLuVVAq2FJXUl4kxU35JzHDPceKTn3ArMCA/fGarg1+ZUKQ2cvtvCWqYvV7Pt5qFMoxaiIONFUzFGMy26j27pJ2F4SJSNT41t8N2MAg8nhiBRJjOZg5EId2Dc/4V8wG1CEqY66cPSTVXYIRN0s3833vBZiP+R+oFrzhJO5OdqJlUNx3RPXGXpALf2Yu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(376002)(39860400002)(346002)(66476007)(66556008)(956004)(2616005)(66946007)(16526019)(478600001)(36756003)(2906002)(83380400001)(86362001)(5660300002)(186003)(6486002)(26005)(4326008)(1076003)(8676002)(6512007)(6666004)(8936002)(38100700002)(38350700002)(6506007)(107886003)(316002)(52116002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?kCBCgM01duprhk+y5VMy51FR64HmkOpzC1lgX0vRM79h7FLUL5lS0GKqkChc?=
 =?us-ascii?Q?rAs7JlSiSLq+TNMNnJp78COhGQlkU1gfGQpVC4obHHCM+H+uV6EFHYtdX4C4?=
 =?us-ascii?Q?HbeJLSyHgad4XxsRqxrzRzlQoRAmVzmLHBkQuV4rEFYNS/WmiYURF9EDW/aY?=
 =?us-ascii?Q?W/2OBTWV34AD97ev2eQ9FHHf1xXSdVAyw4OV929Jikw+cPr/yUvF4XwpGLbc?=
 =?us-ascii?Q?c3k1en6ZWsKengCcFlpZPL8HXoqtfcRYaPnJRF6i7oqbta8zqA7pZefB25S/?=
 =?us-ascii?Q?yM+NP/V4w5A9dTSt6ybgjld2cHcKNeiPfv9dN5skEfPNA05CxXxbJWeLn4br?=
 =?us-ascii?Q?eSe8iiC/l+cYctHNFz4FaIM2Get2oqWliSEMXbHgCCqGSn1gXSA704JuXVkz?=
 =?us-ascii?Q?0P+j4sRg7NpUgYn5+6VPqtCLuufLwpQsTQA5Qfe8pFIyE/0bllPZOyj8sSwo?=
 =?us-ascii?Q?G+d5Viy5GvBCVyry7siCWmMCkJslHA/6/nN2Ev6fWLO/h9v7t4tewY8fv7ff?=
 =?us-ascii?Q?Ih/uCVx8+XGTuVKjEHQgxNStGPPTaLvStV62m2kdY+YMDncFvOrjh03waPXi?=
 =?us-ascii?Q?F8nDA42VksopuTgMGPAiIa5hEdp3yPqDzQfPbYp0sfd+eFnjXLm/l4EK7oUI?=
 =?us-ascii?Q?VbXSh4dLjmVWQVZpowqTK74QzhNoytadEYbkiKHsO4c6mkrEq75+Q54zW4gc?=
 =?us-ascii?Q?YyCMvhvLgiTWIoX+4/ViD4y3NzNOjp3aXZj4fERoAYJSFZqvxIaN5afw2aQC?=
 =?us-ascii?Q?trfd0W8xHd/9VQdoHw3Cbo01Ld9r6tDTX7WikTwYrc0rfwvMh7XiujI4zmoW?=
 =?us-ascii?Q?+/x5Glty07Zi0UKT8Sl4AEbjGPYTPgIaHYpzINoabFjTrjZu+iP64jmhZIf8?=
 =?us-ascii?Q?TRJIVCG6REQ57cMfu6+KJsc3HA+dyrR2GXrIE9DVGyx17lGLQNRbMTg4DrzT?=
 =?us-ascii?Q?db0JykErjC8rJC/HzvX81AskkDkZTzix9nVzd0VePJNSWd1ErwyFMO18Xiys?=
 =?us-ascii?Q?RK7R6nuu5j540OqP+nhLTfUV7zRmjRZIMPKh8SEw9Y3HDFZ591Nj79BCQqHM?=
 =?us-ascii?Q?K9EL6+MwWR4zirLdudgm2FvhkmOS4u2HsrYP+ZZGJFE1G6L64FrxW0ulqRkS?=
 =?us-ascii?Q?JZBYHVNB3zF15GmD8PUQIkARjc65H+79miewOs0sQ0b24yBYz4dtCb+2UFpQ?=
 =?us-ascii?Q?VOWsGep+IU7nbHGmoQvUWwvek5zS3obOCEOXVihlM7pdlwcHoKkqH/JkLyY1?=
 =?us-ascii?Q?xSbQKPIWVy49ELtZwmcPskjpHD29/EDS0C08aG4oOPswC2L/oi0SZyxzYzDm?=
 =?us-ascii?Q?XsBOIxW0kwe2cWG5RwkI9y7I?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a92568bb-395f-4499-b5bc-08d91e145208
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2021 17:58:07.5386
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cqoNYb97Gyw8OwwlM+8IjAXxABKbHwn2Qm52mLobtDB9uI9g8E8tpjIs8aKX859MN7CoLtYQnoY7XFXtb4BFk/suABy9noJgaTYwJIlbbuM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4004
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105230136
X-Proofpoint-GUID: DHUx88w8sNhEPERpLLkwLipDUOB_tQ_S
X-Proofpoint-ORIG-GUID: DHUx88w8sNhEPERpLLkwLipDUOB_tQ_S
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105230136
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For aborts, qedi needs to cleanup the FW then send the TMF from a worker
thread. While it's doing these the cmd could complete normally and the TMF
could time out. libiscsi would then complete the iscsi_task which will
call into the driver to cleanup the driver level resources while it still
might be accessig them for the cleanup/abort.

This has iscsi_eh_abort keep the iscsi_task ref if the TMF times out, so
qedi does not have to worry about if the task been freed while in use
and does not need to get its own ref.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 15 ++++++++++++++-
 include/scsi/libiscsi.h |  1 +
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 8222db4f8fef..9247f70d2daa 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -573,6 +573,11 @@ static bool cleanup_queued_task(struct iscsi_task *task)
 			__iscsi_put_task(task);
 	}
 
+	if (conn->session->running_aborted_task == task) {
+		conn->session->running_aborted_task = NULL;
+		__iscsi_put_task(task);
+	}
+
 	if (conn->task == task) {
 		conn->task = NULL;
 		__iscsi_put_task(task);
@@ -2334,6 +2339,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 		iscsi_start_tx(conn);
 		goto success_unlocked;
 	case TMF_TIMEDOUT:
+		session->running_aborted_task = task;
 		spin_unlock_bh(&session->frwd_lock);
 		iscsi_conn_failure(conn, ISCSI_ERR_SCSI_EH_SESSION_RST);
 		goto failed_unlocked;
@@ -2367,7 +2373,14 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 failed_unlocked:
 	ISCSI_DBG_EH(session, "abort failed [sc %p itt 0x%x]\n", sc,
 		     task ? task->itt : 0);
-	iscsi_put_task(task);
+	/*
+	 * The driver might be accessing the task so hold the ref. The conn
+	 * stop cleanup will drop the ref after ep_disconnect so we know the
+	 * driver's no longer touching the task.
+	 */
+	if (!session->running_aborted_task)
+		iscsi_put_task(task);
+
 	iscsi_put_conn(conn->cls_conn);
 	mutex_unlock(&session->eh_mutex);
 	return FAILED;
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 9d7908265afe..4ee233e5a6ff 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -276,6 +276,7 @@ struct iscsi_session {
 	struct iscsi_tm		tmhdr;
 	struct timer_list	tmf_timer;
 	int			tmf_state;	/* see TMF_INITIAL, etc.*/
+	struct iscsi_task	*running_aborted_task;
 
 	/* iSCSI session-wide sequencing */
 	uint32_t		cmdsn;
-- 
2.25.1

