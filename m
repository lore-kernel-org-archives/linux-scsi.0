Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 473D2C433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Mar 2022 00:44:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244490AbiCTAqH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Mar 2022 20:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244474AbiCTApq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Mar 2022 20:45:46 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 539B4241A0C
        for <linux-scsi@vger.kernel.org>; Sat, 19 Mar 2022 17:44:24 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22K0Dvoh004455;
        Sun, 20 Mar 2022 00:44:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=ZjdfNRVMifRXlU0ualN7zVfAC9/cTczit1pKLZrpJ40=;
 b=NQv0vvPM/CMEpVgmqO3ApW3o42klH+qwndrdyrmK/WLNKKZlwcvw6+8uPOxIdA+4aqFO
 XTAVw/QpIKnRJ2KacULY6x4rCEO0+geT2IiH5P5naKoVEH4HwvrTHqvxpyuWiY5N4drX
 /eiz6RozeO5tfxZy3dXRZH4LL6pV8rMsjivz2DipV7cPifiXFx+P8/rfssVVeEHBua7w
 xwsZa/UD2Q/xHncDzfVkHcBFkHIdTOYsrDIFWXj5yDGVB1CObT0qI3u1ItImga2l9d8c
 U+KJgT/0UmacFkgMY8yakecnRuYouzC4nRAbz6QTe558tjG8UCDS3uwdO+yb/txu2uYM Iw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew5s0gx7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 20 Mar 2022 00:44:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22K0ffao137063;
        Sun, 20 Mar 2022 00:44:18 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by userp3020.oracle.com with ESMTP id 3ew8mg6mq1-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 20 Mar 2022 00:44:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j1dzCrWZbRzm4WBrTeSLSVfO5vUdAZl7ODYB2G3tSCREdKTgjNpY2CYTqM22zgW/LbvYtzjYSH+0/0KTGEKmY85vWwuWwkUbaj3gVVQPYRgGHXYJOz72dYMfqOf1iSHtUaz9aGAl8+E2MU5Yb9pBTnf4nmW2Y69XJoPSIBneYKt2xsbKGUsfTGNMzs9gkOBbynvV0+9ZyqpUsQqCjuJT2kjBUO55armIwhK1gu2CpBxG501IGQekOZMFyCSvoLDWZJH6NcoDP/KK26u8E6qusF90d7J8YvNdqiVV1flWN2jJu56fcEweawVfC5KqJ8/YGb/UPq9jDZzcpyebPMBxAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZjdfNRVMifRXlU0ualN7zVfAC9/cTczit1pKLZrpJ40=;
 b=nMKFs4igipxNIEZAz5Mpf4WdADyAlpE+Dx4CzyGz8ndb10YH49NEtjO+65c/QuKe0OYEjWQ/5rd5WK4DMWaQDccZAbylPQ386t01L1Na6KFV+fXIOuHG7DpfZgqxeURcFtpZvcoPDk1Vc5HBQ5WGVfky4rvH3+tviinKqVkqU6fWbmcDPx+ZALCLLhTVqTjayugMOzhoiKUG0xyY/VLJCB4k/twCILetdYlfKkEM18ZMuSf+LjKZZAi0VAEvfjmQXfMJxHUKs9dokfUl90SHL0+EI2t00Y4QaL3hfcwcMA7ALQPySl7Yv0IpsOoUPixdzQdNgB/I4MYo9PK5BENfuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZjdfNRVMifRXlU0ualN7zVfAC9/cTczit1pKLZrpJ40=;
 b=ZKCYP9y0UolcfB1Eab5mGlSo4bYhEz5frp68FADbyQvA9CUTAzzR2LLav0Dq8zAVGzypxQrC8iBO0PMr+t9fbaPJP4+F0FLbOeyvTBxlxggEt8++EXXyHAzUozYLYj0gw+1Z7vjAENMdiAZrofgW4K6f/bjKgYjC/hmUHGRB9Sc=
Received: from CY4PR10MB1463.namprd10.prod.outlook.com (2603:10b6:903:2b::12)
 by CH2PR10MB3992.namprd10.prod.outlook.com (2603:10b6:610:9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Sun, 20 Mar
 2022 00:44:17 +0000
Received: from CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::78b1:38c1:cfb8:537f]) by CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::78b1:38c1:cfb8:537f%11]) with mapi id 15.20.5081.022; Sun, 20 Mar
 2022 00:44:16 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V2 09/12] scsi: iscsi: Remove iscsi_get_task back_lock requirement
Date:   Sat, 19 Mar 2022 19:43:59 -0500
Message-Id: <20220320004402.6707-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220320004402.6707-1-michael.christie@oracle.com>
References: <20220320004402.6707-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR18CA0065.namprd18.prod.outlook.com
 (2603:10b6:3:22::27) To CY4PR10MB1463.namprd10.prod.outlook.com
 (2603:10b6:903:2b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d3a561c7-a15a-42e4-d541-08da0a0ac332
X-MS-TrafficTypeDiagnostic: CH2PR10MB3992:EE_
X-Microsoft-Antispam-PRVS: <CH2PR10MB3992DB44D01D11D14E2C0A39F1159@CH2PR10MB3992.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oCQnHetL4m1IEjee0z6D4P87iJckDmNtTotS3qQ3B7LjcRxteYusqmFvygd32dHiEy8MRGhvVyaQkh/qR+VPv3ylvft4HaN19XhFwgnrEh2+1GcCwPdFftMUgitJZRVxCYHEzBNvrPlcDOZjbHKEuZtte/WPKd4rn0sl2BbmH+N9Cz8qjny3Bz0QYbpJGSbn+ue2aPuxB4NWP7YFkMGHrpDog/e39HJvAG4A8+yaSIKbO6Oa/5iFkMO10YblJcWHRvrh1BTbkpRufcelbb4Gc1WrXt7vN2gQc9Vw5eL9zvjL4fuVxUuNGLfYDOrRb+VInS0M6+jgZzcR2ivxSdYIOZmA/y6AHFKybP9rBllSvO9Wt0SLGoTEU5g+8pk6IJlF68tbKXpMMrQffh/y1La9A8Ob0W8yuHZ2kQmpIpFA6lEai7M+eRx0FjIt62JkcRO7t+qY+zBOXwYhIej3a2pZrjsKetNSNzDx8l9uq8Ks/Jh0/wCIsu5iM8KuJ2/VTeRLRCpN//P8Dhm1nCQ57cK08cakH/tXpa8r1XSPjbqOxusY8iAmKfCM97j++lFrZTF221+bAdl4oCys8ZUXQVsvgKeeVXVBFxNw3Eix2VjRLIbOJa92mBhmmLcxAVtJbgzD8gsvPP0HdE8W2KUSV+M0eq+b3x58trVdOaWiFmnwSXPUYbMpyfAT0Nys4egx4PcZZFGoaYlxngfKdxHcyyuCVA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1463.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(66946007)(66556008)(66476007)(4326008)(8676002)(86362001)(83380400001)(5660300002)(6486002)(6506007)(6512007)(6666004)(107886003)(36756003)(26005)(186003)(1076003)(2616005)(8936002)(316002)(2906002)(38100700002)(38350700002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TDf6by2QNi4O6yCRANkMYraplFXMAgVhZGJ9fEmUGNu/6cKZb9TP1bQhLIU0?=
 =?us-ascii?Q?zI2ExooWbo6WxGVGDyMgg3SIZwoimBgKxxOUrc1gypXrNLze5TwtGrPAv5Z5?=
 =?us-ascii?Q?2XfDiNH6XYsrt5CnN9uVGLBTPtJNUjeY9+ELn2oW3i0QU9atPbOWyHZyohCo?=
 =?us-ascii?Q?apZiD9stZEm9DU4mlhu+vjI5MlM3YZVNxbcFaYh2ehymXuBNOn1rpcmsJMG4?=
 =?us-ascii?Q?OZ6mtrBiG6SHhhjlxHelbShif+OYZU1/0b5AvjEsdGp0ldOFFWeJzyOOFGDG?=
 =?us-ascii?Q?e1/2Sce3EVaVl39BzBi9JZUcsiRiKlZTOz5VzOP9KD2j6w0t00a8o653dJDH?=
 =?us-ascii?Q?3T2SxsLetM0Vp8xO7dF53Y9Y6ln/NDnpEh0oSBiVmQMXO/5j383M48Mqpn5l?=
 =?us-ascii?Q?+X3J4sv8JTgs0cJ3Mbim5oH52z9NIIMB82zrd3mLgwEP7gO3z/WCFJnPecB0?=
 =?us-ascii?Q?qVy2C2xK3x9pYFH7Z2KTG4XAbiugXWTVUTV3hrZ0NvXZVgDOldGLvg2twdvL?=
 =?us-ascii?Q?iMkAydUSBFol8jVuTtIgu23Zqwp5Do3xdqY/PIRFEdgWiXT66/9shKrKqxRC?=
 =?us-ascii?Q?UXPS3HMzk0MVFv5HvTggBDs61bC5LArtyNMVaY3m4yKu5XRFj3zWzP3cSNFh?=
 =?us-ascii?Q?eYPGIbmzWcNRLTiiJzSwPoqfpRIMV6KomNKAcG2fd1b53IziFN3FDZS5sPug?=
 =?us-ascii?Q?MpzeAOJlfxoN3jcq/JZX6y/i7+gu5SqzWS5Gyqh5mmpNMsI0tSow+M4ZkjIs?=
 =?us-ascii?Q?wsOqaqXjNGNHjrdqzhms4spwWf0uIQzE/5/1be6irVXyYZ/eydnfxVgcTUNv?=
 =?us-ascii?Q?CQ8WhLl3mv2fWLQsJSxaH/uUgHc4W0pNEh4Mg56zEabGBaQ+rNRr7Sy9SGmU?=
 =?us-ascii?Q?vG/GIhLavB4vybE6dKTSBiVx9u43tfJjxAUoCjl3se+jOAtaE3hvrxP+LmfZ?=
 =?us-ascii?Q?mMqvxJ+VLmtsHg7M4qu8MlwsEnrBqRKsBqxLwq/Ah70CEZ3CfNd/+SW0dkEt?=
 =?us-ascii?Q?In/AZHN4nbES5D6xMZ1Zf5O8X20+saMQDObdoXDZ3DtH1etVMr6LAdJm/CU4?=
 =?us-ascii?Q?6OcxpXedDt3ymX9q/G9qdgg8yibdGJmwq/4imu4cN3qU0r9qjQf1xjIjbJQz?=
 =?us-ascii?Q?UeVGkcj3rKVEAk9DByYrOT8MuC0N3pUOCX4crB2vSzE1TINDJsuhxTvFkk6B?=
 =?us-ascii?Q?jbLewXtck9PcJv0jRS5lDKRGYN+r1mW+VN8qJ7OzCezxAQUy7IO9EPkB8Ept?=
 =?us-ascii?Q?ymRHf8XXWdO99VkLB9OuabfEZdDT7ZRwzQHVThEgMs4k4+WRvyZ5ZY/TXTJo?=
 =?us-ascii?Q?iNBrxQlzBbVp23bKtQKJFWn4RKgmrgFj017XRQ/UtyGBQZSTsEiYvtFLBcZn?=
 =?us-ascii?Q?OSpVnR1dNh/Obv3Gj+aSCSZfChlz4BFEgJMgMXwPOAyH51uZwj/V6kudXcN3?=
 =?us-ascii?Q?ljP9+oHnz7h/xB6aGHZbx4zOwnEspbm5H3cDQi7dEab+ocAhKAlxWQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3a561c7-a15a-42e4-d541-08da0a0ac332
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1463.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2022 00:44:16.8904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: trnotLAjZvcsBJTBTc/CfvTqygDhnICftDK0TKqwYxHTQ6D/kNsD7vqglIb2PLFza4q/5W9IVQr6YWm4OWZeao+BKY/09hi0ZN4dfnzMVbs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB3992
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10291 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203200003
X-Proofpoint-GUID: Aq1SnkqxHI_7qcK5Cm9N-WaPvqsDOXx_
X-Proofpoint-ORIG-GUID: Aq1SnkqxHI_7qcK5Cm9N-WaPvqsDOXx_
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
index ab55681145f8..26e5446ac237 100644
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
+		msleep(1);
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
index 5c74ab92725f..a2d0daf5bd60 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -83,6 +83,8 @@ MODULE_PARM_DESC(debug_libiscsi_eh,
 				"%s " dbg_fmt, __func__, ##arg);	\
 	} while (0);
 
+#define ISCSI_CMD_COMPL_WAIT 1
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
@@ -1449,8 +1456,17 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
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
@@ -1492,7 +1508,7 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
 		 * get an extra ref that is released next time we access it
 		 * as conn->task above.
 		 */
-		__iscsi_get_task(task);
+		iscsi_get_task(task);
 		conn->task = task;
 	}
 
@@ -1907,6 +1923,7 @@ static void fail_scsi_tasks(struct iscsi_conn *conn, u64 lun, int error)
 	struct iscsi_task *task;
 	int i;
 
+restart_cmd_loop:
 	spin_lock_bh(&session->back_lock);
 	for (i = 0; i < session->cmds_max; i++) {
 		task = session->cmds[i];
@@ -1915,22 +1932,25 @@ static void fail_scsi_tasks(struct iscsi_conn *conn, u64 lun, int error)
 
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
+			msleep(ISCSI_CMD_COMPL_WAIT);
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
 
@@ -2035,7 +2055,16 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
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
@@ -2282,6 +2311,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 
 	ISCSI_DBG_EH(session, "aborting sc %p\n", sc);
 
+completion_check:
 	mutex_lock(&session->eh_mutex);
 	spin_lock_bh(&session->frwd_lock);
 	/*
@@ -2321,13 +2351,20 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 		return SUCCESS;
 	}
 
+	if (!iscsi_get_task(task)) {
+		spin_unlock(&session->back_lock);
+		spin_unlock_bh(&session->frwd_lock);
+		mutex_unlock(&session->eh_mutex);
+		/* We are just about to call iscsi_free_task so wait for it. */
+		msleep(ISCSI_CMD_COMPL_WAIT);
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
index 522fd16f1dbb..9032a214104c 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -470,7 +470,7 @@ extern struct iscsi_task *iscsi_itt_to_task(struct iscsi_conn *, itt_t);
 extern void iscsi_requeue_task(struct iscsi_task *task);
 extern void iscsi_put_task(struct iscsi_task *task);
 extern void __iscsi_put_task(struct iscsi_task *task);
-extern void __iscsi_get_task(struct iscsi_task *task);
+extern bool iscsi_get_task(struct iscsi_task *task);
 extern void iscsi_complete_scsi_task(struct iscsi_task *task,
 				     uint32_t exp_cmdsn, uint32_t max_cmdsn);
 
-- 
2.25.1

