Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1B42C433B4
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 903556135E
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236957AbhDCXYU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Apr 2021 19:24:20 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54858 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236945AbhDCXYM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2021 19:24:12 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NLsnI086884;
        Sat, 3 Apr 2021 23:23:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=3kvsXUEa5a9XTG3RrHcCQ2U8kE3+vSkwXtzP5Z2bOSU=;
 b=a2b8lAl/8h52pPlzQb4pNIYRP4lZmBqc2+TnV+jlRHTaUs4I28LZqrPSlB48NwNQArSw
 Jjn+y24KEXhfamaaRqgtmAM3ivP3k9utdyLz89ZeoPNifbdT/JEUyK5mmpc7em9Ogole
 CVBwNev2LvbPYqXnjlC8T3Ee/oZdRFBEKPGLUhmKevGBHhgNGizEPdAIp2I3v/I7dgQ4
 d0Rk1M1TTLbDuJLhX+XPGsJbf7KCXNuyhbONAnXjIIOZ4Nqy+/6fQrxPioiThHJOlur1
 AhGtOH41pN/c66Hv6GnlMm4aBpkoB7esjbN06ZmitK4kLeN534mn6nLewX/Y851kd5yH Dw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 37pq66rcv2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:23:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NJrEV132118;
        Sat, 3 Apr 2021 23:23:57 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by aserp3030.oracle.com with ESMTP id 37q1xk81j5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:23:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e+9jIj4iQYupljzTKeNpikB7JWwFvykYLpocbIQY0JNYWwOLokFPXIP9m8HJqf1eK8GmDhSicVv1YiSKXChUa6s+ATUcukQnEbwj+R6iUUCXloP+ISSaC3CbpAZ1Mb/hse322+z2VLobrILIKPDc3TXUI2bq6pQGT0eKG658luU+pbJ3W6zrUtnjBfIiYUf/wqifEMOdKcTcFGC7jmSOH0hAzo94ZQa07BrKqLQUu/q/p79jiO4g0p9madcyydgvkI+7XvyqT3rwxoRquLrt+GpOGpZ4jK9nFJYAL5xCFCg17IfXP8Bpk7w/GWRbnTi8sHiTpkdomaDINjzlnkZRhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3kvsXUEa5a9XTG3RrHcCQ2U8kE3+vSkwXtzP5Z2bOSU=;
 b=PELLeDWwQ5NeRVgzOyvptgBL/UuN61axJTKAq125Itku8hYKJWie/HOfeJ68OJNCjMkVyHWLxV9MUqZTe6gZEHKLzAbUoDqbY5JEEj4pHxvdLsyuQSaLuZp2ECjmYcB6dt4KkEMigMx+l2luUkC8ZeRRzjFk0D3oncgDM1SLmPpTJhyYC5gD3hBwLGKhtFyLlNepA9AIpNCNAcE6A6lFn/Y9Ywb/rN3lSZVzXJOdVozJ/h5fCW130/hloXAtlhN9hrxgatnn/MbbzkuCTz0IdlluUk7a6oEibRqVqE9AYNA2X7tew4YVgyMN0GSmwH7aamLZLI5jHdvUbjvOwQAEUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3kvsXUEa5a9XTG3RrHcCQ2U8kE3+vSkwXtzP5Z2bOSU=;
 b=F0eogPO7jSakwszRMh0CX+kbjBJFzCJdCdPFrBtfh9r502ZsjCjGmG+G24EXJF8Fm6bCb3QeIfe3VcBGNNFON+ajXaG7dUUnednDimEhYyrctF5ZYAKTZRjWxpZLoXuK2ILxOrIi6OSoG2jCAvS43f55zAHiUkae90Q1EK68alc=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3526.namprd10.prod.outlook.com (2603:10b6:a03:11c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.31; Sat, 3 Apr
 2021 23:23:56 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3999.032; Sat, 3 Apr 2021
 23:23:56 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, subbu.seetharaman@broadcom.com,
        ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 09/40] scsi: bnx2i: set scsi_host_template cmd_size
Date:   Sat,  3 Apr 2021 18:23:02 -0500
Message-Id: <20210403232333.212927-10-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0137.namprd03.prod.outlook.com (2603:10b6:5:3b4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Sat, 3 Apr 2021 23:23:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb5d2edc-1006-4104-17d6-08d8f6f78d36
X-MS-TrafficTypeDiagnostic: BYAPR10MB3526:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB35267857360F418F789744EDF1799@BYAPR10MB3526.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bcg6nmjS6Wn19TcAuwIn+EAdpO3ADocp/y4L+cigS0eZR94EnvIFehLeoIC8sdXAAp1ugF67G64l6SwOZ0L2yOul8DINGMQ5ORNrYN6W6FYs+Z9XLuLMig+/gSf9IALKTixxgj3DVSV3n4JaEc91h2ea+S3ecwkmvy/uWfqHbTlWLfcFsHdBaG0PMIuGvzv7MtHTkyKhqiUM2can5hcd5JS7q6iU9Ra0t5MrlYe+TAEVN2NC5GpJymshmvx8ZNkzqkPHt5guTgOn4lrKcw0sS4Keo+Wt1woVLgGcCKorPrNN8rkVbDNaeE4Z5+NT4fvbd2CJj3HXQAEIwGDh4n8nf8EfwLkMJIycTrLcM5wsBUuKS03kecWgP+WeSIeCms8Smb5pCtZkMLF6yHBixcp9XWJUAboYYI9Itq7Sl5RllI/9npD34hiSfcChzOCN2Q9M4zGt0zG+ux0RukaOlif5s6RzO5mp0SxTc2PV6p5zMLCWgSfwEDBCZbsu/doXpT1Yc8L6QQAA3yeDuA12aTgAZObaiJRrrvqEdACsW9PwKHdiYK2G05DGNjLzCooQGzVpIFoe5k29NrzNJqAVEP90inmjt1+22E2D/Ufx5c2iGrYUWQmsYh8ef5tv1hUTE7vVBve/i4PZAP11oxvpYFXZ1o3HRZdXgM3DReZCavq9hhT+PqNL/34FwKxmxn3bEeUT3Ite9EJIoxUEr08lpGTwOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(376002)(396003)(366004)(478600001)(5660300002)(69590400012)(921005)(86362001)(6486002)(107886003)(1076003)(186003)(52116002)(16526019)(2906002)(26005)(83380400001)(6506007)(36756003)(956004)(2616005)(7416002)(6666004)(4326008)(316002)(8676002)(6512007)(8936002)(66946007)(66556008)(38100700001)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?3UPzNirz8mpUQI9t6WgUot6fo0G1Cbs1lVEkZE7Su+CRV7umMubullrRnBHg?=
 =?us-ascii?Q?7DuyJeJ7DTf7AyWojladhFYKzey+DBBxqld5NOQoy9eN1nGhaskMji7CuubZ?=
 =?us-ascii?Q?UVpo7YgDPCtGvgcUd/lbhllHDuHz+LgCFvxVSeNzFU/cCe/9sHloAdFtbq4w?=
 =?us-ascii?Q?hHVTnbEYJfoLqJqXQOd3NItg7THT/HCEAj1ylG1Xbv7Mn2VdbvW7Fw4gg+vC?=
 =?us-ascii?Q?nJ9fwGf5J93x5UGX9K3oCwyMH5FRV5esFlggL41F55A1j5o277dWwgM7LxQs?=
 =?us-ascii?Q?ehSWtY60vW5Fw8rYj8CAxwqAKX93Fa6IcBc+68QMI4UrAUXlKR+ScAx4/598?=
 =?us-ascii?Q?/QsaifwhtjFxJebYwkq4sBn661+qNTYd5dT+Rgp65o+avL1XfeGrarNrL4sx?=
 =?us-ascii?Q?ApDAQKlFSrs2SeJXTciC427VM0TTZGicEEOUhlpPjTzBScWpBmTH2Moq7CKp?=
 =?us-ascii?Q?c7suJcfdGPEYkz49PoYe01xyoees845lqmRRRwKOqO7NkvhQEack9ADyF+9Z?=
 =?us-ascii?Q?kZ+qj5n/gAjgzVERAOHq+rXT215HdmPoHZP5Are15FwO1opNWYkKHUsOQ34u?=
 =?us-ascii?Q?Y/qAZmFqanNmK3KeU1ObTMyt7ZO0AdeA6qYaZD5tJFsQHGJnEKiduxuRsoRD?=
 =?us-ascii?Q?hBWyRwvkwjaPn0EDHEHov4GawL6vJ9sxFRVkxUt9s45bJvqPiOqPqABirxdJ?=
 =?us-ascii?Q?/aeldftsf5bZNvUEoYBKZ8rWUJbQ5DQpRSQPKS8Rn9qu1RdYGaYS4jIAgCL8?=
 =?us-ascii?Q?PA0IF206EMeSzUDLINJy8tiRfWdmHF1omHMhBtDUWhhhlHplRCN3XRKzRAa5?=
 =?us-ascii?Q?v0Aepd5/1m/sS7tonKY9SyR0RyESyvV4ZMyCFNC0xq9cNFM8TdCTxcTP2QGH?=
 =?us-ascii?Q?rjruEiTjFGvdIeJhO2/7kWNF7xLjqEl8utVC9E1xdQQTElqm2u0D3RI/1oXh?=
 =?us-ascii?Q?9WbPvu+md+IUDKMDV+vdcIM1s7HGVm77jJlpwzrS6GonMegPqFPkNcAHsG0J?=
 =?us-ascii?Q?NhqwIQxdtzY81VkFSAWqUR4QRM9tksviC+CHVUVLlRd7emejUKNeHQsP8QoI?=
 =?us-ascii?Q?3rxrmKVK5/Td6ONC4sHdQKmkyQ7QH3Sg0lSKJAc/t8wSSmDX6gs6jqkUsPT8?=
 =?us-ascii?Q?oPFbmhWAQme8tpG03yRJ7jbfyKAj8hVc35AuyWodThfSSOc+Pd7QDtkIbIf2?=
 =?us-ascii?Q?ORlE3+lqJsHiWcGgZl0pGoDqaXdz1xX5vKSdTZbHcoEBEW6hkxUX1JHWjoB4?=
 =?us-ascii?Q?AQsrdc7/E8+t4Fhkb7fzPMiO5b5jm2H2WlLvZLqg7seVcfuW80dgzrLTT4Bo?=
 =?us-ascii?Q?PBsfu4eVVJGB22gQba1VhEDV?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb5d2edc-1006-4104-17d6-08d8f6f78d36
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2021 23:23:56.1151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4tSwRZVwb0vGVoErt3M4YU1B+9JIVULauyJQHCbRX+UaVEgauGUM0rptczxI1SrhxcxNOAAYM1nJIIvWKNKM/rTLCoxFiIfvH0BwRLg3T9I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3526
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
X-Proofpoint-ORIG-GUID: wLvD8zwTxpS80GzhFefcCLnt-LcBDyR3
X-Proofpoint-GUID: wLvD8zwTxpS80GzhFefcCLnt-LcBDyR3
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 mlxlogscore=999
 phishscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0 bulkscore=0
 mlxscore=0 impostorscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104030165
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use scsi_host_template cmd_size so the block/scsi-ml layers allocate the
iscsi structs for the driver.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/bnx2i/bnx2i_iscsi.c | 55 ++++++++++++++++++++++++--------
 1 file changed, 41 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index ce98112799ed..a964e4e81a0c 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -434,6 +434,31 @@ static void bnx2i_free_ep(struct iscsi_endpoint *ep)
 	iscsi_destroy_endpoint(ep);
 }
 
+static void __bnx2i_free_task_priv(struct Scsi_Host *shost,
+				   struct iscsi_task *task)
+{
+	struct bnx2i_hba *hba = iscsi_host_priv(shost);
+	struct bnx2i_cmd *cmd = task->dd_data;
+
+	if (!cmd->io_tbl.bd_tbl)
+		return;
+
+	dma_free_coherent(&hba->pcidev->dev,
+			  ISCSI_MAX_BDS_PER_CMD * sizeof(struct iscsi_bd),
+			  cmd->io_tbl.bd_tbl, cmd->io_tbl.bd_tbl_dma);
+}
+
+static void bnx2i_free_task_priv(struct iscsi_session *session,
+				 struct iscsi_task *task)
+{
+	__bnx2i_free_task_priv(session->host, task);
+}
+
+static int bnx2i_exit_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *sc)
+{
+	__bnx2i_free_task_priv(shost, scsi_cmd_priv(sc));
+	return 0;
+}
 
 /**
  * bnx2i_alloc_bdt - allocates buffer descriptor (BD) table for the command
@@ -456,30 +481,28 @@ static int bnx2i_alloc_bdt(struct bnx2i_hba *hba, struct bnx2i_cmd *cmd)
 	return 0;
 }
 
-static void bnx2i_free_task_priv(struct iscsi_session *session,
-				 struct iscsi_task *task)
+static int __bnx2i_alloc_task_priv(struct Scsi_Host *shost,
+				   struct iscsi_task *task)
 {
-	struct bnx2i_hba *hba = iscsi_host_priv(session->host);
+	struct bnx2i_hba *hba = iscsi_host_priv(shost);
 	struct bnx2i_cmd *cmd = task->dd_data;
 
-	if (!cmd->io_tbl.bd_tbl)
-		return;
+	task->hdr = &cmd->hdr;
+	task->hdr_max = sizeof(struct iscsi_hdr);
 
-	dma_free_coherent(&hba->pcidev->dev,
-			  ISCSI_MAX_BDS_PER_CMD * sizeof(struct iscsi_bd),
-			  cmd->io_tbl.bd_tbl, cmd->io_tbl.bd_tbl_dma);
+	return bnx2i_alloc_bdt(hba, cmd);
 }
 
 static int bnx2i_alloc_task_priv(struct iscsi_session *session,
 				 struct iscsi_task *task)
 {
-	struct bnx2i_hba *hba = iscsi_host_priv(session->host);
-	struct bnx2i_cmd *cmd = task->dd_data;
-
-	task->hdr = &cmd->hdr;
-	task->hdr_max = sizeof(struct iscsi_hdr);
+	return __bnx2i_alloc_task_priv(session->host, task);
+}
 
-	return bnx2i_alloc_bdt(hba, cmd);
+static int bnx2i_init_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *sc)
+{
+	iscsi_init_cmd_priv(shost, sc);
+	return __bnx2i_alloc_task_priv(shost, scsi_cmd_priv(sc));
 }
 
 /**
@@ -2203,6 +2226,10 @@ static struct scsi_host_template bnx2i_host_template = {
 	.sg_tablesize		= ISCSI_MAX_BDS_PER_CMD,
 	.shost_attrs		= bnx2i_dev_attributes,
 	.track_queue_depth	= 1,
+	.cmd_size		= sizeof(struct bnx2i_cmd) +
+				  sizeof(struct iscsi_task),
+	.init_cmd_priv		= bnx2i_init_cmd_priv,
+	.exit_cmd_priv		= bnx2i_exit_cmd_priv,
 };
 
 struct iscsi_transport bnx2i_iscsi_transport = {
-- 
2.25.1

