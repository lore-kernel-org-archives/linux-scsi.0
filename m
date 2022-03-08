Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C9EFC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 00:40:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244220AbiCHAl2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Mar 2022 19:41:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244091AbiCHAlS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2022 19:41:18 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A0213DDD8
        for <linux-scsi@vger.kernel.org>; Mon,  7 Mar 2022 16:40:23 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227LKdsW009310;
        Tue, 8 Mar 2022 00:40:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=QJY515DfdAWLYH7NeLKujgL2Merle9nsQNIHzHhMn2I=;
 b=GohQnRC4cs7qXpUYteXgZp0FmkF120gjZI8UmNpczoZmGyuC94DTUu3aDX+Xgv9qZTDs
 b/0u0VH5S2PmqpSZ+r+LED6O4jAB2S24IedMLh+p61anZVBOD8W9dn0lRjwAGN6FQc3t
 YUgGxBrXoFUDtf2zgdXkO1RW6Th163tEFy40AEsjwwXcp8Xdm5ofsJRoBW1gzgPITQVv
 28YxnZGDBWjEfkq9XFni7ioeR0o7hSUQ0MlAAI3WEjUaUVUHW/4U8v07QE7+mYzSYHus
 4Z3MFhLJt1dwPtlWjDFCVjj0QVWLxiQYytQeaJQ/D+fxccGqnZ3gLXgq2KjesAER6iQP Gw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekx9cdft1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 00:40:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2280alEE119127;
        Tue, 8 Mar 2022 00:40:12 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by userp3020.oracle.com with ESMTP id 3em1ajmyke-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 00:40:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X1pbeq8GoT8c8Ct5N10o6OlsZwZXGbEkoH1NjpxFAuHBbDFxRch8UOoaAAnmmFwNE+htW2dgK3+gvTQTZ1/X04WqiDNEMUfpgWaJEhYuK7IewUaZffYQLs7TIGIsaqsyGubK+ySBSNf8upKY4S7stBKSM1mvaqKVlGkJCzQYZsG3kuLfCOLIVoWHFYGsviBpFkr4yg4OJw9yLkh5Ix2Mx52lagSId+1XasqDyIMYijqROdSADs25vyWBipKQuSwdMqJGXRCGSbKSRL7aGUvDl0wnasziGy6GfA/zZverU9zuM6utIte82qAEc6de632L2Z8umz8NPLT0j23j2jkK7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QJY515DfdAWLYH7NeLKujgL2Merle9nsQNIHzHhMn2I=;
 b=TAYkTBFayboFdtcevqQ3IYnmxB8LM8oEgWFhtsF7MZeRG/B9LeTj3o2jIPDVm+T8dWSN0sFA4vB5NWqLtIhax5qPgTITRw+DCIDtUMEdF1uZ6bWrmccGU/7nUcbVUQmXsOppPbS7eMh97Kq1dEbj0Ws+0RGCZ7dXztM3wUWS1dbinN/IsnGY+rV7bCk9sGXPT70+nCh3tK/btr08dZgab2LQwJckbXItD+JZxmFgZXQkbAKy2dA45DjQMnye3duE6D5xGGTHasCAbcfgQdlIZ9aZJTMSs3GlQyirTNUuFVYAfCdlH9mjqV8Dkv/qhzB18/YYUTlq3pTqgCRdBHfKOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QJY515DfdAWLYH7NeLKujgL2Merle9nsQNIHzHhMn2I=;
 b=EtnqbI98btqXZqKeZZ3NC1hxVBqIidI8wzWlResbe6Kn9GOfIW5SGhqpwZNUKqJjkgomgmaEMLstf+khbEdxkZyGm/v4duYwZs2OcIfzpC4x7DuKdm2ZcIxCqPQJkKAuha4836WENGsq/4bluoLuNpSt1X9dTyfmbAnu7HixcDc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (10.168.103.135) by
 MN2PR10MB3680.namprd10.prod.outlook.com (20.179.98.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.14; Tue, 8 Mar 2022 00:40:07 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2%12]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 00:40:07 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, lduncan@suse.com, cleech@redhat.com,
        ming.lei@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [RFC PATCH 4/4] scsi: iscsi_tcp: Allow user to control if transmit from queuecommand
Date:   Mon,  7 Mar 2022 18:39:57 -0600
Message-Id: <20220308003957.123312-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220308003957.123312-1-michael.christie@oracle.com>
References: <20220308003957.123312-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:5:40::33) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ad5883d6-006e-4455-e2a7-08da009c3154
X-MS-TrafficTypeDiagnostic: MN2PR10MB3680:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB3680522CF700445FF2B46145F1099@MN2PR10MB3680.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1IMkAqCvkxvt7DEW60EU0ld0/THfZ0XXBrp0TLOMeCLWmSL/D2zNW7M/RqRA6NR9ZgEQR4so0HvSbK+4mt9jVc9llowfNVy8+xow7dBa7p5OsRlpvyr+dt/b5m6yRI0/KkcZ8mzQlLNbehAsYcz8txQUYBAhzKbMcCPqFqtDccJv6KeIaWkTcAXYkWFeMbr8H5Uxl97thl0NMBCKp3DfKHlNLeaKu3lnnpEYS6COfL1hYGea5HnCaoYKBhGqyycZAxEt/ANbMRijERFY+VSrmoJMrjVqAFge7dKQvFWR6hrPoVQeTBPvhMXcRK9mJpV8PUX3J7miT5n5JodRFwzT1r1+bsEl8yPxETJOnrqeLoqFhye4yDgZ1vVpbrNoy2YOylFGXhb2531vnupeD87yxZAIswVrvcdo0St3x+RftltnSrvCpoT0vjIXLGkFmSqODyL2GlVc930NynM901Jv7bkyKViOPLkwe4ulLsHIkHu3lYM6o7IpQyAq37HZmA7zUq3YxEl1UJW+a/kBaaHdMvgwZG3YsRDWgCN9trAou2+O9T1AK2fPZDdQweDSrmZMuOsayTevADBg1fyU2lksAhBNz3jxFpIdbay0qQIwY8Mo+OB/lBg9WOTNgqK1MltCUgyF+U27/SB7Pzei8Dxx0g8fDwOdFarFVr6YYgbg9ZE+GonQJYM7Xh9wKW1pcUaQkEJ+tKqoXkBWbW8WwDw2ig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(508600001)(6506007)(52116002)(86362001)(8936002)(66556008)(6666004)(8676002)(66946007)(6486002)(6512007)(107886003)(1076003)(2906002)(26005)(186003)(4326008)(66476007)(38100700002)(38350700002)(316002)(36756003)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OnUktDZYfAKG8B0jZmw2yX4lvO3Nm7l75RGcw/6Fqr999sw4g7Wf5R0Llq7v?=
 =?us-ascii?Q?d4emDg5hXEpiw20JoNUZmkXzPnWdb90VaXkXuVLbIe5/zzYq87MHa/GPjX86?=
 =?us-ascii?Q?lX9Wn6cOIxe2doQ3jRG7A0/92BeaSm9ocXsRkEjVc9IJrpxp8sojzS2BkJzh?=
 =?us-ascii?Q?S5exJ1v/B+tVI0u/sHifoYcbs646n1kuhQTsafwi0bWGjdr9JezWoiI3Ds1F?=
 =?us-ascii?Q?SSxPZQtWj+H6gIT+j4UYb8enK+izIBe5vF1+KO/4RNNqnuSs3SpWSPo1svBz?=
 =?us-ascii?Q?wJwP1js8w5AaS0tuzufS+65cCWsShC4qCpq82VdZypvTXTyyyC9KzDbKwRuZ?=
 =?us-ascii?Q?OeF319yUbuCDM+Gc6Z0t+FKct0sF6olnD+O1/HnHr/3DQ/q4MDlGXTZTDwdo?=
 =?us-ascii?Q?a9F123d59I0ULZ79VfGHhuFtDNpLCnatmVzchUXpsVpMJc67m9BQNzAVg1cJ?=
 =?us-ascii?Q?Jo4EzT9LCoV82FWgYmzu9y6uuDep+wyuqAGHvnHicSTGY4jX7RnI9nkEF3FT?=
 =?us-ascii?Q?pzvr8HxmtJYMTZqDtNPcfxROhT8mY5dlFn+ZPQ8nIDJwtsUGQn+NuZWC2QNZ?=
 =?us-ascii?Q?M4joCEEeyR7vHt8T7o/FDArSukFGN4sktoN6jCIBZIjZbuNYE0emYCSJpoIx?=
 =?us-ascii?Q?NN0pZMaKX9XJOcQnZSb9F1W9tfkj/zsAvJuglaMqw4Ebn8lYnNkPdTgwq2r8?=
 =?us-ascii?Q?A3lvOVOH2wqVycU669Rq1G9dCRphL+ByyVT4zWfIJez/6FqMydV53YgF5eFZ?=
 =?us-ascii?Q?B+THTr989KLcopxFsFo6/bffU5bxlFz3EB8juu4jYNS2R9xoI5Dadr23Bkd9?=
 =?us-ascii?Q?eozvjQR6/bbihjb5Th4x6sir93wMGJ8Ai8mTOgbUQq7pb92iD6TE4i3qjVYy?=
 =?us-ascii?Q?LcSnLA78N7yLvgT1gVizt3XtqsutQc3KoWBpvXDuLFBmWJ/iSLH+3AzoMI76?=
 =?us-ascii?Q?BQswUUJBJ492FNWskomBKwPkUW+HliWF4QL8fH1WR+yJyS9xvk6jaiPXe3l9?=
 =?us-ascii?Q?hawqS80MZmw8/o0kyjpYR/h8mDnTRG41PyweYWe3zw9A89CdHrEIL1g2H3UG?=
 =?us-ascii?Q?T6C7+c6mr7GqcbkDFHgeNGkwN+sdlSP3BCAgCFTtiUJDRGp723ilGAfAIYwh?=
 =?us-ascii?Q?OURCRpS79Z8IW+zDIhc9pwdwosc6C8PZIrygGUeMdEhclAkMJMNO395cYyan?=
 =?us-ascii?Q?cpVdacShBXN3KM6Vv6mr63zHA22mgEKC8FC7LN5gB4q712DSr48UlZ/rPK7E?=
 =?us-ascii?Q?l2L63wcgu4TxzN80yQh1z/xmFBSnkhlegfsvszTRU/6aq8AeMKzidyYLxdkR?=
 =?us-ascii?Q?Fvbh849F8A/sRo81+o4qtdiCDiLhlIgigTeLAnPXX5nezjlzfM/wYgV/1+3K?=
 =?us-ascii?Q?DhIwTqPzC5PBVoWq/+M+FiZulVL2lwf5WBXse51WMB0MhkeAdgWNOombyZBw?=
 =?us-ascii?Q?KwfRpLU5HYEnHNqgLZKtye9c4AgwTv1acLTeddBIra+ehdmR/yTWBFQufJ/1?=
 =?us-ascii?Q?OS6EdCG20H/9uMPmZRT2kvmg/6YIHcTJHCqPSrOqQsggqi/m0+woy7Y/6toY?=
 =?us-ascii?Q?zzCqFJR/V0BsLQRynTVr/9IC+/81SUnNsN088DEn6SHJxLV91lbbAvcYBBs3?=
 =?us-ascii?Q?d2uof41FjFr7GfGtYl7sgFdNNyuHRPxM0G9JHDxNO21Ay3o3Y8K2aHRvZp6U?=
 =?us-ascii?Q?eriwHA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad5883d6-006e-4455-e2a7-08da009c3154
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 00:40:06.9985
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SV/4i3+Xkfr/Ze14I3ibNChu2PqMiU+Ql3AUbVl5ZguDSUB2BkjZqw9xt81Fwozk5o/QeIh4EPpR0fzmi+pc9r3qEa53cMlDCtF0/ip0biM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3680
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10279 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 malwarescore=0 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203080000
X-Proofpoint-ORIG-GUID: 1nZ41RwQDLoc5CSl_Qs7f-4JC-Se-S7N
X-Proofpoint-GUID: 1nZ41RwQDLoc5CSl_Qs7f-4JC-Se-S7N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Transmitting from the queuecommand is nice when your app and iscsi threads
have to run on the same CPU. But, for the case where you want higher
throughput/IOPs it's sometimes better to hog multiple CPUs with the app on
one CPU and the xmit/recv paths an another. To allow both configs this
adds a modparam.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/iscsi_tcp.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index c2627505011d..c48707b53746 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -56,6 +56,10 @@ static bool iscsi_use_recv_wq;
 module_param_named(use_recv_wq, iscsi_use_recv_wq, bool, 0644);
 MODULE_PARM_DESC(use_recv_wq, "Set to true to read iSCSI data/headers from the iscsi_q workqueue. The default is false which will perform reads from the network softirq context.");
 
+static bool iscsi_xmit_from_qc;
+module_param_named(xmit_from_queuecommand, iscsi_xmit_from_qc, bool, 0644);
+MODULE_PARM_DESC(xmit_from_queuecommand, "Set to true to try to xmit the task from the queuecommand callout. The default is false wihch will xmit the task from the iscsi_q workqueue.");
+
 static int iscsi_sw_tcp_dbg;
 module_param_named(debug_iscsi_tcp, iscsi_sw_tcp_dbg, int,
 		   S_IRUGO | S_IWUSR);
@@ -909,6 +913,7 @@ iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
 	struct iscsi_cls_session *cls_session;
 	struct iscsi_session *session;
 	struct iscsi_sw_tcp_host *tcp_sw_host;
+	struct iscsi_host *ihost;
 	struct Scsi_Host *shost;
 	int rc;
 
@@ -928,6 +933,12 @@ iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
 	shost->max_channel = 0;
 	shost->max_cmd_len = SCSI_MAX_VARLEN_CDB_SIZE;
 
+	if (iscsi_xmit_from_qc) {
+		shost->hostt->queuecommand_blocks = true;
+		ihost = shost_priv(shost);
+		ihost->xmit_from_qc = true;
+	}
+
 	rc = iscsi_host_get_max_scsi_cmds(shost, cmds_max);
 	if (rc < 0)
 		goto free_host;
-- 
2.25.1

