Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BBA5C43460
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:25:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2844861360
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:25:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237006AbhDCXZT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Apr 2021 19:25:19 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50182 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236953AbhDCXZN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2021 19:25:13 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NLQmc160772;
        Sat, 3 Apr 2021 23:25:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=aibAfH1QqGR+7pphYEdkVkPxVPEMDycY5PWo7MqxCmM=;
 b=f4GJtfek2jjjc6V/dWel4RrrPqUHPH3iZipcBbYCXbMnNgbt1mcNwmWFJhRH+IgXRe1U
 ex3Oi4fQ/j/EitrmEeMfof5BZn/PirgkuO5W3Cu4CiV/FFxAZ3F5wm4NuKGZdipUMx0i
 kiXJuOpPeSJeJTtIU3qpSQEi/n4u8EEf1/Qc3gUJUmFQghE1WtMShDZQ/SRDr5ZNmfQd
 z/iPceDFafCIQSWKbVZEtbtB+hVybFIKdxKeoH5BoX3qgQROXnNXdg+tgB8KOZ9qHpyf
 s2emaLJT7faYPFxMbFctLLId4kHBhvJhyQkPq+9cjO92bVr6qY2hq+ksd6xG4xr5QCnu 4w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 37pgam8rpu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:25:01 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NKtBX117020;
        Sat, 3 Apr 2021 23:25:01 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by userp3020.oracle.com with ESMTP id 37pfpkbt0w-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:25:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VvRT+/rEZG1XzOqE0XLrvAdB6cZiIEpuGJyrLhoFeNXTFARWHn7/uupe+hfAeAx4bz/C/emxzVDAz/tzpkjrA7k4bvEERR1+2ifah6Uk6drLgp8hB1iKZsipCAqAIhXq9wWxTk2kBhaitZBilfGLdH6dV3ddk27pvLBcHoUUD78eBGOjEb1BeMdvbSVYeT37VmVTnE/GHO/2ZYt/oqdwIkrTxEpmGfGnC7udv+ZhdqQ0uRlOKdp7Q7dtz2M+MmIA1DAfaSW1+EtvyglxIqcy2Bq4UbuKgk4hsgI1zzZa5kJghra0xo/g8tU63VZu59GHuhI/EqVKtdgk3ommUcumtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aibAfH1QqGR+7pphYEdkVkPxVPEMDycY5PWo7MqxCmM=;
 b=Tssm6nZRvLOX4HCOcuZBaZ/i1ZtS6Uo2UXkFKCyfEzDqjV0g1Xtf/RKJ+j/CctwaHQxWENi6Y/cMqFWuVEVk05zR6gYNiRF8c3Z6MyBI2UKNyxiMI/p3SJ9jK8y2UD8W5E0IiV4HKJvwdzwVZBSwBiWFonCL+HjsPggAVsZB6uSdPOZdDO9VPHMYvGCvFPiWCidf2bZoqaZGl316EhKjIqC08chbgBeuP5ZvzkNjmfyfqY+fi4nARqPVWD5OLD3XH44x48q67M/gK6rQaFzovrKCgaPU/u698VpYOYQEesUUcqqOIvDDWPoJQUSC5T/a89pAQoJqC/uDDJfnmYY7gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aibAfH1QqGR+7pphYEdkVkPxVPEMDycY5PWo7MqxCmM=;
 b=b0cbPEhiZJ2BcK470cS6faenknD7oalPXILzWLRahLRp6keizKQ4M5j+TX3hvTEMM8JINOOd95dHj/cuV/G+5NU1MP7HlWjqB8tCj8mH2SWBewfJlMrkH8CeKxBzftugt1WeEkTxtsx9fLrvwO2pd7Ous06FJ62iqrRPrHEEtXE=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3431.namprd10.prod.outlook.com (2603:10b6:a03:86::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Sat, 3 Apr
 2021 23:24:56 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3999.032; Sat, 3 Apr 2021
 23:24:56 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, subbu.seetharaman@broadcom.com,
        ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 36/40] scsi: libiscsi: move ISCSI_SUSPEND_BIT check during queueing
Date:   Sat,  3 Apr 2021 18:23:29 -0500
Message-Id: <20210403232333.212927-37-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0137.namprd03.prod.outlook.com (2603:10b6:5:3b4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Sat, 3 Apr 2021 23:24:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e9452324-2c94-431f-0a2b-08d8f6f7a28f
X-MS-TrafficTypeDiagnostic: BYAPR10MB3431:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3431D531FA9305FDBA52BAEFF1799@BYAPR10MB3431.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XTKxsRS0nKIuhldkvRVfQYiEWGSEpSsRpA39WzW/SnraCJj1o1MJrwoRue7b/WmcbAnzdyiHb8MHQL4MjFUCS+kDgzOlmBxLr8tPeYUhihvfMuf8uWeJAYWlSMcu0GpZrqbwJsB2l0Qm3PTqi4Fewfi0rxDAT03VC7Q8KN6XIPdsrIA6YvRzGf493YwJGk02ZsieLdtyaOnXdBA+P8AkU46lw7qUEaZ2m7DjFDldl6SAoabOULSfpt0h2wANf8nAnrIY+Lx12nfvhIiMi+4e7H2G9p5wLHHfumBNNnIwRD6lkc0TeQ5jxmtPpKyjHtAD0o5nZcg7frNylxC2d9/oNk6gVPbhRLYSxsg0HJNNVkq4Zs78e8sfII6Twj1+aR0XO2ALMUSqxXdPz5j1zlBXkom1hXtjktMNb+OMM9ZFgiw6WNnaFezZHQioSMRV9+ti9nEyhqLmBDGmnH6E0MIx3TxSgd3IQs/AHaNLId4me5CZbFJbGRw7wtfc4fW6iAiaqtXigpGMf3srtJIViSWAEs7RpBqq4RE70gxYj5Kk5EflA5HkMFhdjlU5E0nQbhk1Ma8c6Y8ZRiMFH+ZAPcdSJMYHCrHmBLz8BSztEUQKUJU+1lwyYBax30P3TTqoqhMQEkACNJ9uUb7m9r7cT5GV6jEXBU15MbBwySolx1Kazi+F8EgBOWPfht8L+73fiL1xEa+8hCbyrY2N9OyYaCs0oA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(346002)(396003)(39860400002)(8676002)(186003)(8936002)(6512007)(2906002)(956004)(107886003)(66946007)(1076003)(5660300002)(26005)(16526019)(83380400001)(52116002)(36756003)(6486002)(7416002)(86362001)(316002)(478600001)(38100700001)(69590400012)(66476007)(6506007)(66556008)(2616005)(921005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?svBUmGBgSB9D1m/k3xuiSquN/Ni5nW8EhMj4KHSiCfVTB0EvcoimzeygN5ST?=
 =?us-ascii?Q?8SAXXP7qw+KPWK+a+eI23F++434KUyY1PTF2pHiCrjUumRdluo3ezfaEcsBy?=
 =?us-ascii?Q?JQXl2nxphOLCEBNko7cCW8M6pM6fWvu2KrAuxDWX94KeWmDTgF4HwskxMmfl?=
 =?us-ascii?Q?ZDHmdd3JeY05VRAIEH5RsEXaXQo9RM9BKWsaD7C/Pv3JV7ZaZH3Aa7fskqBP?=
 =?us-ascii?Q?wUnPliDPJ7iFVLTNrzyiZpoUumiBpJKCR9EvNGlLKHqcz3OmPJzHPnD4y4a0?=
 =?us-ascii?Q?Pf8yIado2hk3HvoDZSatVqeypS/rQjednuFE9wUz4DrUwwHIReckAv9dkdlA?=
 =?us-ascii?Q?s0CZXyOxOvjoVkuLdK/JOKW/hGd/MP+fjs7p2LcPjDuOeSzkpTNNKp3wSVRR?=
 =?us-ascii?Q?zdXp01zEbeGQSdH/05tQwXliX4p9/xJ9NKvP7Xm+ZdWhwwZT0U7345nZkffu?=
 =?us-ascii?Q?Jm+bFrfJnFnRUaWiYnZya4fOR/bjn5KfRgoBr0E3SO++2H3gegmPnGc6oo81?=
 =?us-ascii?Q?gPyohfejVEb13+4JUyGZ7OKh99VzSXjUMgP00+xuLcPMfv6C9Wjc8YyRufTM?=
 =?us-ascii?Q?5LrosDO61m1eHWAa+Dne4ZkHHWfo8T/dafKGQ7mnpeGmtmY2FknrMcNF4j5R?=
 =?us-ascii?Q?C5hcs9lqEL8KCYL+Ihcs/ti874sLQm7Tz/j+Hy/9ztcpbzeVlrr2WnziHKne?=
 =?us-ascii?Q?z330BuVdDQWFS1LAToEzb+Sc9g7htCKJtiRWYdHcxe3Oi0rK1uMY6R7aAeiK?=
 =?us-ascii?Q?dZw7OZ6lth7I4DIuDa6L0/8bZ0sBF+Obih6d/BGuxjqRW9zHsBuGcPbirxBS?=
 =?us-ascii?Q?YQPlzF+D9KHrUpboxvQa14v4lLJD7Wq5EMaRGVgnZj2xeRFNpycdSnbNZY+7?=
 =?us-ascii?Q?lq3ss3mZZQPuEcpd4yghHrFn9jrNGH2LFiDDY6fHYmuOCkH987BCJgFtIMXQ?=
 =?us-ascii?Q?gSllg0cj2qsoflvYgZG/ZZEPwvG+/4O27eC/1lNh/o6NjYpH/DoU2g8XaFsC?=
 =?us-ascii?Q?HEhdLBsnQQFXDkyi5BOo2SARELohlNbhS7pnPDED9zFacmcPXMkOtKb/9/6g?=
 =?us-ascii?Q?iGqwtTPvP5D0H6VigQUV/VVID5ynj8eF2Gz5L/qKIoVjN85jM06iyXhWe4zN?=
 =?us-ascii?Q?XI6/lkjaOZ+Ha49ftsNs6ZVDcevNlu5JB2GUbAyTECM5k5SiQ5goBWmHDTY5?=
 =?us-ascii?Q?Dc5yfYe54aXHkeSuF6gmMiXCGFlRHa9eEhKetIO6nHw/TCXPfwuDd8U/8FB7?=
 =?us-ascii?Q?AwHX4/+ZDGDjx1pOM/OapXDbs7qXI6KC53Af0+p/ZqEJL+gz0NXQZXZUXWU/?=
 =?us-ascii?Q?7CVGjKsYWIBwhUgu6DXLqpy9?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9452324-2c94-431f-0a2b-08d8f6f7a28f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2021 23:24:31.8942
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j5pP1yGk/rvvFBMVnQeze8AYp5ZCB7GhbUb5zfwrw8M5d5LZBeFRFdJTKDLQ2Ngfnzo7JtuLPF6sNc3sxaR/RkP7sIsXwMOpvmcFdbhWwlw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3431
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
X-Proofpoint-ORIG-GUID: a5QIxqD7HpyMKDNWAjF76NjvfMPyqBmp
X-Proofpoint-GUID: a5QIxqD7HpyMKDNWAjF76NjvfMPyqBmp
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 spamscore=0 bulkscore=0
 clxscore=1015 phishscore=0 mlxscore=0 mlxlogscore=999 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104030165
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Drivers that use the iscsi host workqueue already check the
ISCSI_SUSPEND_BIT when we run iscsi_data_xmit, so we don't need to check
it in queuecommand. This patch moves the check to the full offload case.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 211c56fc6488..136531200643 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1821,22 +1821,22 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 	}
 
 	spin_lock_bh(&session->frwd_lock);
-	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
-		spin_unlock_bh(&session->frwd_lock);
-		reason = FAILURE_SESSION_IN_RECOVERY;
-		sc->result = DID_REQUEUE << 16;
-		goto fault;
-	}
-
 	if (iscsi_check_cmdsn_window_closed(conn)) {
 		spin_unlock_bh(&session->frwd_lock);
 		reason = FAILURE_WINDOW_CLOSED;
 		goto reject;
 	}
 
-	task = iscsi_init_scsi_task(conn, sc);
-
 	if (!ihost->workq) {
+		if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
+			spin_unlock_bh(&session->frwd_lock);
+			reason = FAILURE_SESSION_IN_RECOVERY;
+			sc->result = DID_REQUEUE << 16;
+			goto fault;
+		}
+
+		task = iscsi_init_scsi_task(conn, sc);
+
 		reason = iscsi_prep_scsi_cmd_pdu(task);
 		if (reason) {
 			if (reason == -ENOMEM ||  reason == -EACCES) {
@@ -1853,6 +1853,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 			goto prepd_reject;
 		}
 	} else {
+		task = iscsi_init_scsi_task(conn, sc);
 		list_add_tail(&task->running, &conn->cmdqueue);
 		iscsi_conn_queue_work(conn);
 	}
-- 
2.25.1

