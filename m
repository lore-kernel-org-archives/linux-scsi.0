Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DDADC433ED
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 433B16135F
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236955AbhDCXYR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Apr 2021 19:24:17 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45260 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236752AbhDCXYL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2021 19:24:11 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NJdJU038996;
        Sat, 3 Apr 2021 23:23:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=5sLtsUnPIHnwcvm8n80YNvEmn2MlZZ49l8TRIRFS66M=;
 b=bkkepWSIlEIEYaN87cdMWOFuCk46fs2gRX10g8rN8masmkbJYjN6yq9XtZVWE7iwutd1
 na9nc/tnzA1uqlm7V5HhpfUHdskuX8363j4ZJf/+QHUO8szx0gGEdl0oB6A3uQ7FakhK
 CsodBxkv9vw3nlz1c5hSOUM+Qk37gL1Wf3/TUQkld4vbsuu6nkuFI3kTNUPwI0g6eKHw
 BmiYdxxwyT7A4gTDI1i8ONSyUYhBPdQ8ZK0R+pX/JmA/VhXJRl3+lqNbcJrGPWIv6CN8
 4IXmb49DZav9uqbNy1xz6PIRckvLkIquyKEGXOxJ4jElsfPE08+AiEprbsyaxZ7QgYji 9A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 37pfsrrsh2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:23:57 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NJrET132118;
        Sat, 3 Apr 2021 23:23:57 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by aserp3030.oracle.com with ESMTP id 37q1xk81j5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:23:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Aq0tVDHEzVKasLN4QS5UoyY6BGNxo5hBVmzMMGTiRsHY1PlA3PUnX0KhZardRRNJT3cYb7Di6GatfRpyBr8GE/JbaQbnBGclLreR8mOUuQNWyUrWKtJZ2Hlziwu1Nv7ZQBAALaFDfCUUWmX6bpBFvX51S4fjBppr6UTxEUdD1PniNYL2DeZNFmis12kFMPC1setps97VP2307Wk3BNhe4gJQ0YIwPWdfsMNSG761DX5cwKsQZQdk5Y4Kg//K+Z5lPDo+ZM/HHTlnqV9N0GN/Lq7uPhi858hFtM85UXraVuCS/QwqhtSzWeOz5ALgo9DJrrP46kFZCzMzU1FLleNdhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5sLtsUnPIHnwcvm8n80YNvEmn2MlZZ49l8TRIRFS66M=;
 b=gWicBlvv5m9OcKOVNwqkwX65Ljz3KmzdxTQENxMwI2jwzDsByej0jwR4LFy1D8X0eQ3R4g23+m2rdpTZQInip1oX8rmS695LATEZ95AHITeMRasnRul5l0evw2zS4BirZ68aVhV1vPRA8TAQDOZBmz6UgoqSiS2Hs2RW0hDQbOg/fW2T9NEAfR91qKOKS2/bn25brLK0g4fHYTunMW9CapVIjWBZKTLbNl3DKleqlLuZat2MoIy6sneSMwYOosiPa3iQy5VsCqOn41f7A3NjLdhjAMwX0XKKGcoZVjw+VGwHmf6U2skAti98oLmWEuibS2vKISQn5duy3p3rHZrkDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5sLtsUnPIHnwcvm8n80YNvEmn2MlZZ49l8TRIRFS66M=;
 b=DMDnUe7uQHeY3VKRYgCV5Xs6x7YKx/OcvkCauRJSRen3Vilo+zZmS4pc6ClaW99KtrIZ1PzX+6YSccogtBdI/4qx4Admhf1DAjuxOpTxqSwWoarNivqCs6AXsg6xFJ8DzW0h7+G7hxUAY/GnTesA9rJOBhrjE7xm0Tj4i6rmdqM=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3526.namprd10.prod.outlook.com (2603:10b6:a03:11c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.31; Sat, 3 Apr
 2021 23:23:55 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3999.032; Sat, 3 Apr 2021
 23:23:54 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, subbu.seetharaman@broadcom.com,
        ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 08/40] scsi: iser, be2iscsi, qla4xxx: set scsi_host_template cmd_size
Date:   Sat,  3 Apr 2021 18:23:01 -0500
Message-Id: <20210403232333.212927-9-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0137.namprd03.prod.outlook.com (2603:10b6:5:3b4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Sat, 3 Apr 2021 23:23:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e13ea49b-8bcb-4050-bdc5-08d8f6f78c60
X-MS-TrafficTypeDiagnostic: BYAPR10MB3526:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB352678CA3B6D38D6575A3E6FF1799@BYAPR10MB3526.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v3MZMDbQmhfs6jLayu7gPjHngr0fcDWdLwQJQ6DzJ5NnKdyYxtzPoBP1iZu43RCnrGjJgnjwIcS2dOxj7YcEHYnIaOnnc1+vbil7/M3cIXLJ7UdbUbZIJ2tyzganbOjfscUb8gtBGAfSYuZtULSBlCCHmNMCzw2Pg/yMxzxlnY8X3xbUkTpy3TclEEVshci5kTjw2lpKU1oKmYU001ZsNhJIOHAdpGeMG2vy3mCOEyRLFk55gvAAFgZieiFmpw1sHgBgQSzIiyo7wtEtIHYEfA/T/zLGiLJ4MfRH8X/AYuGbuEFd+PIavAq/kEl3qF088f5wu0VyutcMUQmd/xwve345wxueUOixt4juU3OW+/jNttmXLliIoHc7xWmczs+Y8o6YVk+ARrdzT0uSyMm9XxzxK1NyDMfgk1/Ng8giM1PQZS0jvbQ/Rt4Cn784q6YNGzWdhJOmbT/VcBF9NfD3M1paFoejmwasH3LeTiu2596bS7hzAu4HedOvMRH+HGVo+P/2ynHDhtpI76y4Ts6gno6XSBqFkAt5nTbosVkLATYSrILPovD94gzyaSZISiwRsEYGzqvlOPu8suZOHGJAkzklhb0uj6JxucL6Hrqa3yNTftj/kZCjtMlNGO4utKo1/VGes6FbDUlK5UzxziVF8GlJ4nRkmuTRVS3CdW0o9Kir00+7fkHzY2PXu7I5WXk+CH632zPphldG8faTuXw0USBbepgiE+0CD3nrza8Brw0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(376002)(396003)(366004)(478600001)(5660300002)(69590400012)(921005)(86362001)(6486002)(107886003)(1076003)(186003)(52116002)(16526019)(2906002)(26005)(83380400001)(6506007)(36756003)(956004)(2616005)(7416002)(6666004)(4326008)(316002)(8676002)(6512007)(8936002)(66946007)(66556008)(38100700001)(66476007)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?bKUKVAeyZU59pxdAT4TP+I9MAYkw4xrcchZ3ef8PtAyyI2k3hKDEel+0wnXs?=
 =?us-ascii?Q?p2a7q5pSPbMvyGxh1oBmgQ61yM1OObsScrF5EHZySoV5a0wL0oPxzQu4Vfpj?=
 =?us-ascii?Q?s9JidIXBinDy19E4a1JsEvuPe5Di6atMeKOZyWnsGyIhBAQed9OsmN1DnuVa?=
 =?us-ascii?Q?8Vd8tF1u2tNt/ZAy6p4UFejFej+JjeBtK81WOkWqwO6XO+hpkxsQ60QMnupq?=
 =?us-ascii?Q?UzdmOjgPHq87il3Ffg8E9J6m8tfMYWWbyGffffz8RiWNwti/ZHtfjQHQM4+K?=
 =?us-ascii?Q?iilNIdx3xuS9WTCUr/aelCE6kb6P0rzoFLZM6NvZE/9FHFMqktcldClixhkA?=
 =?us-ascii?Q?Zkvhq1ZqnQIM+go7moTzTveb5ENX9erBn5v4+8j+tltyUgMSI9nAIZCZQ4U5?=
 =?us-ascii?Q?XJivjtZZzZMZIxAYVVNhs+3nvN3yiIk+vqvJN6M3e5Tkp6Iq7YJpB+Yorc9g?=
 =?us-ascii?Q?qaP0SPrW2fPhwLtQvSDZw294a4wKmC805vfxdF/qtDhsIz68K4V4+OWJlqpn?=
 =?us-ascii?Q?ikbgDt0iSr3rycPOc5gkDmtgq1nKk/qkmp3BZ7hpkk6swiJBTKQGjooO3ial?=
 =?us-ascii?Q?cnebZ8ZQP/Fum6GRDn+59MM6WNHE+gaSY1UshkxOq0YJcQLowo/qzDP4/50J?=
 =?us-ascii?Q?ohgvhr+hHTgX7F5SkK8gkKNKWhK+SFp71vx8yKYZaOymETdzgwm0P5zczUic?=
 =?us-ascii?Q?FC/oig5J980MCpGRS3j0z1jeU+LWe4T0XhZt91JK/5NNEVKLxGL6DfOXIcv0?=
 =?us-ascii?Q?jCrGIq9vl+tfJIsYJngEeJEL8jTTlh9/UNSpBGWEjZlG8DE4L+8D6RtSYV9v?=
 =?us-ascii?Q?13U+kA+a2qdGZT/6FMxnDfvCW8a5AyOqjPSCsbkWXQRqS2IAREBrgQf6pGc3?=
 =?us-ascii?Q?greHGcecE2lPU8uBGo9vm7jhpUKuFf7xvgdpk/optbqxNP5gFrX8UGCE6hhF?=
 =?us-ascii?Q?q59V4eqkGdhmbWasmXY/o0V5NiclPpzNaPITNLqCymnBXkCupqZrwjBrkDTV?=
 =?us-ascii?Q?bywJWTY9O9D0p59UmoQe6YH6JvFBVPHkL7cMj8seNqWx32oZA3+CSBcSllWr?=
 =?us-ascii?Q?YnFwKM2Zg8rODjqA/CwJxJlBBdVyvGCLCZE+un5ev8XucyhEfS5h4GSc7b6M?=
 =?us-ascii?Q?YkbatvH6DhrMUok7Sdi1qNIVKcrYjgze1dWxXDpvjmrw3mD//QHYKYgPY+iW?=
 =?us-ascii?Q?Fjf61eZmWOnlTYWBTIFs1pCLOErE5ettdwlghOaZy714CjK5VRUU7y+Ik3hM?=
 =?us-ascii?Q?TJp2nN9CSQLt2lQeICAFELSIb/M/B/pqeU0axCzGqz8k8+NFr57Y0omf2fYp?=
 =?us-ascii?Q?naTlgFCZ7Uuycf4z3RCnSCMk?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e13ea49b-8bcb-4050-bdc5-08d8f6f78c60
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2021 23:23:54.7899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M41h9TG48rhx+0fcvLTOPRxYvEu8sG8Wlu77lwNW9cEl1BZCgdDsV3LAg7NNWQ8Hj8Ojgnb4WlxI6wACEgGvfeqexALQZxdYmnTcdWBPXUA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3526
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
X-Proofpoint-ORIG-GUID: x_8NKDEzWaMFJl4TnpwFD9CAGRZ6Jabf
X-Proofpoint-GUID: x_8NKDEzWaMFJl4TnpwFD9CAGRZ6Jabf
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 impostorscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use scsi_host_template cmd_size so the block/scsi-ml layers allocate the
iscsi structs for the driver. This patch includes the easy drivers that
just needed to set the size and a helper to init the iscsi task.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |  3 +++
 drivers/scsi/be2iscsi/be_main.c          |  2 ++
 drivers/scsi/libiscsi.c                  | 17 +++++++++++++++++
 drivers/scsi/qla4xxx/ql4_os.c            |  3 +++
 include/scsi/libiscsi.h                  |  1 +
 5 files changed, 26 insertions(+)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 8fcaa1136f2c..1f8997f29516 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -990,6 +990,9 @@ static struct scsi_host_template iscsi_iser_sht = {
 	.proc_name              = "iscsi_iser",
 	.this_id                = -1,
 	.track_queue_depth	= 1,
+	.cmd_size		= sizeof(struct iscsi_iser_task) +
+				  sizeof(struct iscsi_task),
+	.init_cmd_priv		= iscsi_init_cmd_priv,
 };
 
 static struct iscsi_transport iscsi_iser_transport = {
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 18d0591e4dbb..bcb12e674795 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -402,6 +402,8 @@ static struct scsi_host_template beiscsi_sht = {
 	.cmd_per_lun = BEISCSI_CMD_PER_LUN,
 	.vendor_id = SCSI_NL_VID_TYPE_PCI | BE_VENDOR_ID,
 	.track_queue_depth = 1,
+	.cmd_size = sizeof(struct beiscsi_io_task) + sizeof(struct iscsi_task),
+	.init_cmd_priv = iscsi_init_cmd_priv,
 };
 
 static struct scsi_transport_template *beiscsi_scsi_transport;
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 926d33b2c9c7..07b23f3967a9 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2850,6 +2850,23 @@ static void iscsi_host_dec_session_cnt(struct Scsi_Host *shost)
 	scsi_host_put(shost);
 }
 
+static void iscsi_init_task(struct iscsi_task *task)
+{
+	task->dd_data = &task[1];
+	task->itt = ISCSI_RESERVED_TAG;
+	task->state = ISCSI_TASK_FREE;
+	INIT_LIST_HEAD(&task->running);
+}
+
+int iscsi_init_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *sc)
+{
+	struct iscsi_task *task = scsi_cmd_priv(sc);
+
+	iscsi_init_task(task);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(iscsi_init_cmd_priv);
+
 /**
  * iscsi_session_setup - create iscsi cls session and host and session
  * @iscsit: iscsi transport template
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 7bd9a4a04ad5..af89d39f19e5 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -239,6 +239,9 @@ static struct scsi_host_template qla4xxx_driver_template = {
 	.this_id		= -1,
 	.cmd_per_lun		= 3,
 	.sg_tablesize		= SG_ALL,
+	.cmd_size		= sizeof(struct ql4_task_data) +
+				  sizeof(struct iscsi_task),
+	.init_cmd_priv		= iscsi_init_cmd_priv,
 
 	.max_sectors		= 0xFFFF,
 	.shost_attrs		= qla4xxx_host_attrs,
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index ddd4b9a809a1..11f0dc74d4c5 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -467,6 +467,7 @@ extern void __iscsi_put_task(struct iscsi_task *task);
 extern void __iscsi_get_task(struct iscsi_task *task);
 extern void iscsi_complete_scsi_task(struct iscsi_task *task,
 				     uint32_t exp_cmdsn, uint32_t max_cmdsn);
+extern int iscsi_init_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *cmd);
 
 /*
  * generic helpers
-- 
2.25.1

