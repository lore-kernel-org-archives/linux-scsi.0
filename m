Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3735DC433ED
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:25:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B0656135E
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:25:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236950AbhDCXZN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Apr 2021 19:25:13 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45950 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236812AbhDCXZM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2021 19:25:12 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NOwFB041952;
        Sat, 3 Apr 2021 23:24:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=QjDqyc0OvUVrzoC/wGS7V5CgZzl6P9LaMdUEwhcilGw=;
 b=HZPodkEv3asV7paJLaUL0Fr1U86eSZqvFmOyqtYepHnldWf1s6xXJSudKcAup6RIKgrU
 BGmWAYvoO+o6CZ7iD9xYF1Y0aWTdD/+q/ogCxwb8tMkwOPuVejH/mcj2M9YiksDR4JFl
 cUO2ov2vzArNJMxEnfUDzja4ELLuaGUH1aJ2xlIrFxEDXloKD+SSf5/5TZdV30R0ArUI
 vxuqM0r6MEcMLbE4Q6IfGpPZBCYTe5coe5yw8CFjXlQOespAckVU8Q73xnIxo5bxvpFm
 tYHvhRxtcImCtDrxLtbpMmGw/zDNfDAizW4B+pq6TD40s5lxdGePRWparDNzwkj+DZ9N BA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 37pfsrrsh9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:24:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NKtBT117020;
        Sat, 3 Apr 2021 23:24:58 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by userp3020.oracle.com with ESMTP id 37pfpkbt0w-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:24:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aoHkv2y1SsGrzpEqTFQxEuJHgNCcd4UEoLu1ol5QIFyzzrazOhD7mGZUEl3JMjoVB8gpsx+3D8BedrW3mHKqh4OulTk/T6kQdvjF7uZWZZJeEy0O05HeuWGKXyky3ByO3MAro2wu8tRfVsZqvy7ZI9x+Z9/HrXg4h4MRQevuXDN91MqLbEq2+09Eb4rtZA0l/2J0yRIGDx17N89EKdgmnpm0D2h8X7RwzwfUQdnBgW7OBQ9/Cnb+K65wF4wuoduKsq+YzIqPXXnGxU+z1BwV+okV1xS4M4IEb3tYu2AaXTBCrvqTZzhgwjdpAgUPq/ziE0Nn3NIQ08Hz67Mab/Aw3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QjDqyc0OvUVrzoC/wGS7V5CgZzl6P9LaMdUEwhcilGw=;
 b=gDIj8ajs97vjQMBonF9MEIO9LMXrtVPmvtwfkHtFqDgsWr4j8L8dv7pySF0c6ooe00A63khhIFgOAL1IMNLktlwZvSwv0O1mO01DD6KT9U4Jssv4svf+awqrsp/l3+ScUIscxqLHk3lvBIW6VDZJnznvo2HJiPGZhV2vY3DD0mcQC4JnSbws4vFETc61mHAvmjwPh1HnfNhR1nLd2j6qa/6hTXWsSXEQ7FRUz2qfMgF+POCdcIfLFANlKMzDowUR2QvVlaNI7yXm9KwMuZmfAfBh7rOaARLSROCxpPsHA1IuTjloW2jPaabxlzYhK61kkuFZZpeBWuMeY1VcxIzf2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QjDqyc0OvUVrzoC/wGS7V5CgZzl6P9LaMdUEwhcilGw=;
 b=pDWL/ubrWEjqpE5E+W66ShS2C7nGNtyJcJgB3ZcdIrOOZBxa7v3poXkG9dmElgj6Y83I193QYoLpjgHll4rwX0hvt4Zv69fBv2cl1pYl7Pm0Z82IP5Af/rXTtuvkUMqgN2qqH6+hrR4G3Wz6jAqf4DzOBxbzpfNRlh46uK0QIR0=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3431.namprd10.prod.outlook.com (2603:10b6:a03:86::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Sat, 3 Apr
 2021 23:24:54 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3999.032; Sat, 3 Apr 2021
 23:24:54 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, subbu.seetharaman@broadcom.com,
        ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 32/40] scsi: libiscsi: improve conn_send_pdu API
Date:   Sat,  3 Apr 2021 18:23:25 -0500
Message-Id: <20210403232333.212927-33-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0137.namprd03.prod.outlook.com (2603:10b6:5:3b4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Sat, 3 Apr 2021 23:24:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78ba4e7a-5d18-4906-e449-08d8f6f79f6a
X-MS-TrafficTypeDiagnostic: BYAPR10MB3431:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3431028F3E1BC653352AE73FF1799@BYAPR10MB3431.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UOYboiJK37hpc5WZbn07OOrkloL5PJf+09rlwIfUabcctzJ4ihLkcK50bH9KM5YklGuq9AQtsE7Ul/UDbHS08swfYDlMmLbDLwpcM1d78yxnx4CGFfsqA7R1/+gxr4j+vPvm0lwUWmApwum7lhJS4xIi3pr10HElefJgRU0kOTPYnO6ezFd7MXpsyFXhLb7acOJHA1w3SIISfnqPgBOncHKONrH81C3jfKzhPJdmblLEyZKmkXFvQ2MDwOKF+2gvu1EyTVO2nn1ATDqx4lVPZGDeImnHmc8dlUMDOU8hFMhg/4bpgAZjQIddPTaEGVKoZ9PiSiGE1Tm/hBA9PTwHld6hCAWCF+R0szWdQbW2VnekPO0yywuX4r2bBWinOZKzbMHVQuwtUTbixjiHTqquenNFqg9FUR4kxgi/Th+sZKw2OYb+rFvYz+P2la12wbe3tI1NDWlLoZx+544t8HahKZfpvFfP2btDCZ1WhiJeNhn5YWnjawt/q5ISefSv9uAvV7+94bv0Iz1hmhOpeCsGgZ1txQeEBmVT8/WU7O+gtNFKtmgqSql2KB1T+yTxESoofhawF2KXOklEhH1r+i2GBRXjf2uw2XgsWPodX+QMoyIf8EPQCHCRzZbUOxGpOCvOYMS+SJXOLTeBUWZs1WHT99lBy/VClejUZWOjlififIFdppFYMH2QUY+WMBhYj7/6ckBuWHdMm32mPuqQl6JKMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(346002)(396003)(39860400002)(8676002)(186003)(8936002)(6512007)(2906002)(956004)(107886003)(66946007)(1076003)(5660300002)(26005)(16526019)(83380400001)(52116002)(36756003)(6486002)(7416002)(86362001)(316002)(478600001)(38100700001)(69590400012)(66476007)(6506007)(66556008)(2616005)(921005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?GCkhLiRuzDJGBkStNKqYe6aZNZbScACdmWgM1eFwLhBPzgNJySwkyp6pQjdV?=
 =?us-ascii?Q?k2UonBulxIQWtsdXRAum/GvnQqByCprEq3U4EOWwxeJIMUcpb1NgaNzZapf4?=
 =?us-ascii?Q?viqdeKzH5zQHOu1i2R7DcQPkS8B1K9jVP6J/WW5QfiY1i6P/agFNj3M9AvJs?=
 =?us-ascii?Q?Y2hydcyvo3W1Yvvfy6RVU81e0OFcz+1Gcz2a2gKT74IMXJHXarzJqLnYn3cF?=
 =?us-ascii?Q?nVQ/kkaevNDKZTjdU6/BNi19dfYYgC2p1DXu2wWA7O0JHjawfhNiYkqN3FSl?=
 =?us-ascii?Q?EW5WRec53yiEFMg005Hj3IcNA/U3EA7xHR1BtCT5gK7LRy+bPT8+onA1ccxt?=
 =?us-ascii?Q?QKYCEBiGD9PQdJtk+0/+0l2IWk6dzYxFy+zKibZuJGm4dIrnsTtEWq6kGj3F?=
 =?us-ascii?Q?5AP4iojRK17CoXkM0V4W3fTZLBnGALUI8XRFV8FE5MkqedMRgnCH+OCmWVvA?=
 =?us-ascii?Q?eozr/tWnlElSwlJ0qvmH4VYB3/TBSQAjfQH9Dn1JKPLKiydUVADBP2F9e+W5?=
 =?us-ascii?Q?NlgU4xkMk/atlZdi27G0xtE736RX+vtSMOJEn0tJpuh8VI445dBI4PLNh4HF?=
 =?us-ascii?Q?MEbML+Q+2K0CwMrHdSro/YAksUigDW3q84PhBjZ9XBdes9tzmuRECmaLWNQ5?=
 =?us-ascii?Q?vtcqqTmmkw1FD4SbkNM2A70WUjM6oaH3bPmwVpQI1NXvCjacicfy4PHmnbM+?=
 =?us-ascii?Q?yKM1AX8DPSaqc2qqhWK6Mv1El1KH38vr/Y5pZuI79hNEa5lP5QB5ha5jcpw6?=
 =?us-ascii?Q?hY/j1J5u1ngDQx1p2QPoTHfH6UnaOtN75TRPqSns9Dw1hIYtXDCSNzEYv7P7?=
 =?us-ascii?Q?bTo8YaLQJzQZOlIqxKfmZlW0kOVALw4WrikxmwiuMYuuMo04taztaJdW9hiq?=
 =?us-ascii?Q?9tsgFZRwczm50C5hubP+1thgX0nssKoymGgvFVJy9lr9jWUr8Pu9BsSoBfWq?=
 =?us-ascii?Q?DgiLBKMyPAbI2ZSI7dJqu7+yVlaqYL+FLi0WQoAhMM5oBOm4yKU9/xB1OL6e?=
 =?us-ascii?Q?oy1sub1k6hLuaCnnH/EABcJNNJnq1k0IxkrrAyRtNr3RJsJBKEU3IkuIrI6k?=
 =?us-ascii?Q?MHt8MLGiJVeIMqmcl61DiN8kONuBDbOo0tIgYbfJDQj14auWsnhi0vns73f9?=
 =?us-ascii?Q?e6vi7lFxwKswTjyWP8ZUGtp3E5vIPHIlSDiX84b92nA6uvslL6DDLVNmW3pV?=
 =?us-ascii?Q?INLaLc3ybYF8hIA1M4RAhuPVbMxSJFeH2RBwHF578S1Tl+1lo+S4LJB5qOeD?=
 =?us-ascii?Q?UDLvA6PrGTzEKsCyCB5He4UidJUqmkjBi8nxzrNQsA6r9B5ge+nLPRfVZTP7?=
 =?us-ascii?Q?36xnpidBN4qBMhHYWubxI/nj?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78ba4e7a-5d18-4906-e449-08d8f6f79f6a
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2021 23:24:26.6651
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GDgHeifowTxICao6ImhP43zaNwJ/4EEzbBVP7QebRRRh9nfRZd1Kdgn+XGwWoR4AoBanIfx7I7Km48cNms3cRcduscgpg4NUmhY9R5gVsj4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3431
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
X-Proofpoint-ORIG-GUID: -ReBBC1kwAzgLY3fUCGpXT-5NxrtN87H
X-Proofpoint-GUID: -ReBBC1kwAzgLY3fUCGpXT-5NxrtN87H
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 impostorscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The conn_send_pdu API is evil in that it returns a pointer to a
iscsi_task, but that task might have been freed already so you can't
touch it. This patch splits the task allocation and transmission, so
functions like iscsi_send_nopout can access the task before its sent.
We then can remove that INVALID_SCSI_TASK dance.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 68 +++++++++++++++++++++++++++++------------
 include/scsi/libiscsi.h |  3 --
 2 files changed, 48 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index d4709e20b05c..33f8702faedd 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -671,11 +671,10 @@ static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
 }
 
 static struct iscsi_task *
-__iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
+iscsi_alloc_mgmt_task(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		      char *data, uint32_t data_size)
 {
 	struct iscsi_session *session = conn->session;
-	struct iscsi_host *ihost = shost_priv(session->host);
 	uint8_t opcode = hdr->opcode & ISCSI_OPCODE_MASK;
 	struct iscsi_task *task;
 	int sess_state = READ_ONCE(session->state);
@@ -760,25 +759,50 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 						   task->conn->session->age);
 	}
 
-	if (unlikely(READ_ONCE(conn->ping_task) == INVALID_SCSI_TASK))
-		WRITE_ONCE(conn->ping_task, task);
+	return task;
+
+free_task:
+	iscsi_put_task(task);
+	return NULL;
+}
+
+static int iscsi_send_mgmt_task(struct iscsi_task *task)
+{
+	struct iscsi_conn *conn = task->conn;
+	struct iscsi_session *session = conn->session;
+	struct iscsi_host *ihost = shost_priv(conn->session->host);
+	int rc = 0;
 
 	if (!ihost->workq) {
-		if (iscsi_prep_mgmt_task(conn, task))
-			goto free_task;
+		rc = iscsi_prep_mgmt_task(conn, task);
+		if (rc)
+			return rc;
 
-		if (session->tt->xmit_task(task))
-			goto free_task;
+		rc = session->tt->xmit_task(task);
+		if (rc)
+			return rc;
 	} else {
 		list_add_tail(&task->running, &conn->mgmtqueue);
 		iscsi_conn_queue_work(conn);
 	}
 
-	return task;
+	return 0;
+}
 
-free_task:
-	iscsi_put_task(task);
-	return NULL;
+static int __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
+				 char *data, uint32_t data_size)
+{
+	struct iscsi_task *task;
+	int rc;
+
+	task = iscsi_alloc_mgmt_task(conn, hdr, data, data_size);
+	if (!task)
+		return -ENOMEM;
+
+	rc = iscsi_send_mgmt_task(task);
+	if (rc)
+		iscsi_put_task(task);
+	return rc;
 }
 
 int iscsi_conn_send_pdu(struct iscsi_cls_conn *cls_conn, struct iscsi_hdr *hdr,
@@ -789,7 +813,7 @@ int iscsi_conn_send_pdu(struct iscsi_cls_conn *cls_conn, struct iscsi_hdr *hdr,
 	int err = 0;
 
 	spin_lock_bh(&session->frwd_lock);
-	if (!__iscsi_conn_send_pdu(conn, hdr, data, data_size))
+	if (__iscsi_conn_send_pdu(conn, hdr, data, data_size))
 		err = -EPERM;
 	spin_unlock_bh(&session->frwd_lock);
 	return err;
@@ -964,7 +988,6 @@ static int iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
 	if (!rhdr) {
 		if (READ_ONCE(conn->ping_task))
 			return -EINVAL;
-		WRITE_ONCE(conn->ping_task, INVALID_SCSI_TASK);
 	}
 
 	memset(&hdr, 0, sizeof(struct iscsi_nopout));
@@ -978,10 +1001,18 @@ static int iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
 	} else
 		hdr.ttt = RESERVED_ITT;
 
-	task = __iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)&hdr, NULL, 0);
-	if (!task) {
+	task = iscsi_alloc_mgmt_task(conn, (struct iscsi_hdr *)&hdr, NULL, 0);
+	if (!task)
+		return -ENOMEM;
+
+	if (!rhdr)
+		WRITE_ONCE(conn->ping_task, task);
+
+	if (iscsi_send_mgmt_task(task)) {
 		if (!rhdr)
 			WRITE_ONCE(conn->ping_task, NULL);
+		iscsi_put_task(task);
+
 		iscsi_conn_printk(KERN_ERR, conn, "Could not send nopout\n");
 		return -EIO;
 	} else if (!rhdr) {
@@ -1906,11 +1937,8 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
 	__must_hold(&session->frwd_lock)
 {
 	struct iscsi_session *session = conn->session;
-	struct iscsi_task *task;
 
-	task = __iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)hdr,
-				      NULL, 0);
-	if (!task) {
+	if (__iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)hdr, NULL, 0)) {
 		spin_unlock_bh(&session->frwd_lock);
 		iscsi_conn_printk(KERN_ERR, conn, "Could not send TMF.\n");
 		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 8f623de1476b..6853b1dec0e3 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -153,9 +153,6 @@ struct iscsi_task {
 	void			*dd_data;	/* driver/transport data */
 };
 
-/* invalid scsi_task pointer */
-#define	INVALID_SCSI_TASK	(struct iscsi_task *)-1l
-
 static inline int iscsi_task_has_unsol_data(struct iscsi_task *task)
 {
 	return task->unsol_r2t.data_length > task->unsol_r2t.sent;
-- 
2.25.1

