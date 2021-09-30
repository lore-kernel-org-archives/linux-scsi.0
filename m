Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A28DC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 02:04:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E82461880
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 02:04:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346862AbhI3CGS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 22:06:18 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:45524 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233113AbhI3CGR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Sep 2021 22:06:17 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18U0SAJA032191;
        Thu, 30 Sep 2021 02:04:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=WHARaM2rSyrT+ZENzReQKaSW2MwmQLkBeq+SyIM+kQY=;
 b=EBbidjhOC5dZmApfCLcrGyIBuK7MTqLTK+gbzecbgfblcDdid7Mn0CIiRlnM2Dp4aaTp
 68VJR0AApx8ojCrX6EBf8tpiuk/p75U/PTwxnowYRxZvaLSImLyuG34ipCRenotIQcJQ
 fX7a53It/85uocT04yZD+uakXGcPtwOt9Bp3MG8v8RIQiu8E5VJDgaJQRPI/+20PaCci
 VhFOqyeJS8QXKsEuIjja2jCWYOqr82TA8jS3HZO+3VjJG5BRhp38dbJGgQBJrwaSJnIA
 tJsppuCOhaRrY26Xem4z1aWZZ6wCV7LWgFGIOkYzAQk29YEPF/UeGui/tMRq8hrbPNjY gw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bchfkynbn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 02:04:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18U20UQg108324;
        Thu, 30 Sep 2021 02:04:33 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2044.outbound.protection.outlook.com [104.47.56.44])
        by userp3030.oracle.com with ESMTP id 3bc3bkv6f2-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 02:04:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H+JD4GqdOETPprHOhdgmPFyY5zYlEwgRk1INXM/w08Sxyt/JyN1gwjoHlAZku+uRig2N4MvLgkznTficCxsEg6aXjMh/Rt7/r4YiHDLubNbKDN6t3M9qVEeAblhVtGlQlCkfzeXg0yyiNWFUDfOqCuRdkSnmnVXpqQZ2d4CH+X1lctyjD9Muk6hjIG4cpcPe6t3x/qaRFtr58ZL5fltNCPY24boDqKQOhCDghRdP+ZvnhS5oN5c77xerGZiFatzOOu7izGQqRZOmBrchnst/8vv0v6OGm6lYS6o2kQZOYJTUL2xsWxpRUFActL9R/ZEb0jPfZHDzytHpuqyLU59QIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=WHARaM2rSyrT+ZENzReQKaSW2MwmQLkBeq+SyIM+kQY=;
 b=bOib/pFV/MnncRDNzfFoOLcxcKTniMmecMYMvZQownoyrTcqOLLT8NeK1VDTyY+p4GkdoSI8N2xDkPihzaHD8tuxNr9FsxTXZfRGC78J629kjMx7bRNXqmZCCd81S6HcFNLoOPbJnVJhSP29cE88EXdL7Z0BDmnOV+NZs82Qt+1kM6jXAKIR5sCXdCyigCPxcFmc9yOhcz1SJzBx+gq7F4foxXWxQPBDDW7ws2vBygbLOW60B4G0O2QDKtuUa0pH6ndRK+Y7Xzw28ovwX2SWwNTnw+XBqnK/oVdjl5ynsrzXu7pTrfmwHOBrhf3LK23DD27r96MXNdVPCaOPcBwwuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WHARaM2rSyrT+ZENzReQKaSW2MwmQLkBeq+SyIM+kQY=;
 b=ikvudvxPczD2tsEJkOuuZyn3nQzFuGzIveI7lkObD5kO0PF5SIw37mJePNTdP3J5m0YwJQx2UeXw0wXKv2r/YcFBu+aywEoqnwaaunTA7mKvxHJO2bztyi6HaJS7vDAopvRAZy7KFXP24JwdWlR7HkS72vJXoKKHzfdTfLIoIKM=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB4909.namprd10.prod.outlook.com (2603:10b6:5:3b0::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4544.14; Thu, 30 Sep 2021 02:04:32 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4544.023; Thu, 30 Sep 2021
 02:04:32 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 2/5] target: fix ordered tag handling
Date:   Wed, 29 Sep 2021 21:04:19 -0500
Message-Id: <20210930020422.92578-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210930020422.92578-1-michael.christie@oracle.com>
References: <20210930020422.92578-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR07CA0159.namprd07.prod.outlook.com
 (2603:10b6:3:ee::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from localhost.localdomain (73.88.28.6) by DM5PR07CA0159.namprd07.prod.outlook.com (2603:10b6:3:ee::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15 via Frontend Transport; Thu, 30 Sep 2021 02:04:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b9dde67e-6764-42c0-0f8c-08d983b6a491
X-MS-TrafficTypeDiagnostic: DS7PR10MB4909:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DS7PR10MB49091CF38A9A85359F19250DF1AA9@DS7PR10MB4909.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1tQIuuta/prdzUW31AfUxYF0UsuRBL6H9mloato/JCJMMB1PxNfrLVK/zdNPOrGl7jNp4eblmUosyIKb39G8k4RE5oHPhKHSBiWjQVWERMxOpd4oNEiGqmvsxTb2n2NuHa4b8DFgmIvY2tcyt2ME+s1P3bJA77uKMhOIy3OKkfbjjPU9i84e+sX9FHcLkGuTCe2P8uP4mv+0Zhum9r3YgIzRu74Lra7H9NNoFQou8q0IduZdguWZtKhJIUbia1+CT409qnO1tYAt7Cr2p9A6S2YtUG04qgKFc23Yd25sS+xE/1uHcgCD/iSCxlLZuQ9C8YQzxH7/5Dn3x9mnVF0ioonY3yG5gDhCpxI97yEcKqP3pBw/ykpVCmKGfEA/qX2NT536ciGaYMZD6sF5inIB0kqI0mAEyCZF0Gb07ac4xHkWqVHpqnejitz+5w0Z4WTo8APsDbxk3H096fbDe3ArZ4ObyZYtfiF6qo0AOELxbhD38/Wdz+KQtbP5VQqA8FZX1GnSKFTwkM8NBBXnrJABTTITw4qdWo1OrmcPkE+y/uMIpdTWTY8pE7EE7V6gcfA5TOisN3FlqWdmmSxvbBDVbcpkWRkzYczINrBXDiMFnFW/NaEe7I5WW07ZlI+ehnmzgj+yrzwkD75MTqswpE7fACYY+zK5eYFIDnhzC08uPsmf/tclBZQs/oiD/AjYJ+Aj7noobZQeiTPh2+H4HOicdw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(956004)(38100700002)(38350700002)(4326008)(6512007)(6666004)(6486002)(8936002)(83380400001)(316002)(6506007)(66476007)(1076003)(107886003)(508600001)(2906002)(26005)(66946007)(52116002)(5660300002)(8676002)(86362001)(186003)(66556008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?64gs5EUj+VAbjQrX2Y1AHBl6pAFuDMR28/SXgmA4Fe+Ewc6x+n7Bc4F+FnMj?=
 =?us-ascii?Q?iLgUoGSba4VCy8uib7AvAHNJq35s/Wz8U1BNQzO9UC+r7HMf3S8FsS8Mn1dQ?=
 =?us-ascii?Q?y9bULUtajrAgdYoHZ74Tud613H7e2MpvAN5Z4iyJvZS7uezszXpsf14eePwc?=
 =?us-ascii?Q?xeiFMbH87QJ3d3LA5syaiPVZ1ckTVni4UL/FX9mnRL1uhA+lTaZ3C8xNN08n?=
 =?us-ascii?Q?fklu1zNhg/30ferX7xumzk9L6e4bzLte2lC5L71JBzXwAYA6628VcoaopNF7?=
 =?us-ascii?Q?+PjJQ20s6IaZ9m/rIbtVvLaZu2MgyeI8Sh3FRfTq2EpsLyAuVJRUmR1hahTq?=
 =?us-ascii?Q?47wIDVovsf547GZ5cFXud8jLze6MBIGl0MLBSkZCf9rxK+5HN/bynd+UK9eo?=
 =?us-ascii?Q?gV2tT/DmcVD4cUwXFeuBQlQInDsYRe3QabI8fF5geQDASas0MttL4QzYBWho?=
 =?us-ascii?Q?6cvJ0wdS6tAUaDRzXSiR3QtVg7dZ5jbmyNjwK425jKfW76jUTyGjK9MnN/r4?=
 =?us-ascii?Q?aN4DURRDgl4JFKjjNcMC46ZO8AZYxnvSh04pgQllAALK/kRHWufIJBnnuzfF?=
 =?us-ascii?Q?ScFzkQbuh4SmEGsMHJVIDWzQCQCo1XgZgAcU8d7fYFoVShehDfVxM5ZqUt7X?=
 =?us-ascii?Q?10AwFm7jnenL62EZ7vaYO66q1RgMhevt30Kt5vGsC+VHHJReors/I1nSBY6b?=
 =?us-ascii?Q?6j7v5lTqOzhwnA1zWFeLllSc1yjprN3RteBhDdJppR1ZQdtM/XplLRjdpsRc?=
 =?us-ascii?Q?+VLch3i52s0MOLKMPBdW/QRI2wn+NjB5q6DxL4zl3DbLWYwBO1ldWb2M4T1E?=
 =?us-ascii?Q?iQnF2W/+DexIyBYGToEM3wmHjikZzVwVbKhyx1ukKhN5krgEDj/zvk0gjHI1?=
 =?us-ascii?Q?Abl2XsjNV19YcDNKfJYB+dhAyjhywKPI7fl4EIEBzfRpit+svNoOwu87m6pe?=
 =?us-ascii?Q?AEx0oG8l0PEY+rI1pqbEInWU1ea6lFg5aY6pmXW+3DK3XzF0mB7RvXRZcJMy?=
 =?us-ascii?Q?+J/8H/lpycF3Ib4ZGt2Qu9qkHblF3NgXPSdCtbZBE+zmd/Dx64f6rzUmVijO?=
 =?us-ascii?Q?L3MonqMZCLnJ01X5BJ9Vms5oAe3wQm9vFJkKwmXlY9IpCbpFT8rtSsek2RUx?=
 =?us-ascii?Q?PSEPd8wOr6qcE8AB4W5PGl9rghoWbe+pES6v9H3eoL//OzLc2XnS3oOXY3aj?=
 =?us-ascii?Q?51JTLawBNOS4tThm8OVI4zJxVpe2Zbr7HSuH+ObrdFo14PZ+SXQL0+v5iizF?=
 =?us-ascii?Q?jNi3AUWymHxI7o8jNAPVvX2AFsWgkhz8PGW/QkZGbgtPd9Gj8BNdAMtFp5hJ?=
 =?us-ascii?Q?NVCH+7eDyqXD4xilf/Ja6ciW?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9dde67e-6764-42c0-0f8c-08d983b6a491
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 02:04:31.9511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9HO5j+8KcslX53eIHmVgljcBf9es22LONpfT6XSjnaEiJ0rKziRHTj928LbLAvL0CYZlB9g7MioMBxbE9hgrXD6GcI4YzgWhoCooaqhCoIY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4909
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10122 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109300009
X-Proofpoint-ORIG-GUID: aQbrtIMKfllHJljSPM8b-a7udI_d0xfr
X-Proofpoint-GUID: aQbrtIMKfllHJljSPM8b-a7udI_d0xfr
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch fixes the following bugs:

1. If there are multiple ordered cmds queued and multiple simple cmds
completing, target_restart_delayed_cmds could be called on different
CPUs and each instance could start a ordered cmd. They could then
run in different orders than they were queued.

2. target_restart_delayed_cmds and target_handle_task_attr can race
where:

        1. target_handle_task_attr has passed the simple_cmds == 0 check.
        2. transport_complete_task_attr then decrements simple_cmds to 0.
        3. transport_complete_task_attr runs target_restart_delayed_cmds
        and it does not see any cmds on the delayed_cmd_list.
        4. target_handle_task_attr adds the cmd to the delayed_cmd_list.

The cmd will then end up timing out.

3. If we are sent > 1 ordered cmds and simple_cmds == 0, we can execute
them out of order, because target_handle_task_attr will hit that
simple_cmds check first and return false for all ordered cmds sent.

4. We run target_restart_delayed_cmds after every cmd completion, so
if there is more than 1 simple cmd running, we start executing ordered
cmds after that first cmd instead of waiting for all of them to complete.

5. Ordered cmds are not supposed to start until HEAD OF QUEUE and all
older cmds have completed, and not just simple.

6. It's not a bug but it doesn't make sense to take the delayed_cmd_lock
for every cmd completion when ordered cmds are almost never used. Just
replacing that lock with an atomic increases IOPs by up to 10% when
completions are spread over multiple CPUs and there are multiple sessions/
mqs/thread accessing the same device.

This patch moves the queued delayed handling to a per device work to
serialze the cmd executions for each device and adds a new counter to
track HEAD_OF_QUEUE and SIMPLE cmds. We can then check the new counter to
determine when to run the work on the completion path.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_device.c    |  2 +
 drivers/target/target_core_internal.h  |  1 +
 drivers/target/target_core_transport.c | 76 ++++++++++++++++++--------
 include/target/target_core_base.h      |  6 +-
 4 files changed, 61 insertions(+), 24 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 8cb1fa0c0585..44bb380e7390 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -772,6 +772,8 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 	INIT_LIST_HEAD(&dev->t10_alua.lba_map_list);
 	spin_lock_init(&dev->t10_alua.lba_map_lock);
 
+	INIT_WORK(&dev->delayed_cmd_work, target_do_delayed_work);
+
 	dev->t10_wwn.t10_dev = dev;
 	/*
 	 * Use OpenFabrics IEEE Company ID: 00 14 05
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index a343bcfa2180..a889a6237d9c 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -151,6 +151,7 @@ int	transport_dump_vpd_ident(struct t10_vpd *, unsigned char *, int);
 void	transport_clear_lun_ref(struct se_lun *);
 sense_reason_t	target_cmd_size_check(struct se_cmd *cmd, unsigned int size);
 void	target_qf_do_work(struct work_struct *work);
+void	target_do_delayed_work(struct work_struct *work);
 bool	target_check_wce(struct se_device *dev);
 bool	target_check_fua(struct se_device *dev);
 void	__target_execute_cmd(struct se_cmd *, bool);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index e02173a4b7bc..913f31561531 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2173,32 +2173,35 @@ static bool target_handle_task_attr(struct se_cmd *cmd)
 	 */
 	switch (cmd->sam_task_attr) {
 	case TCM_HEAD_TAG:
+		atomic_inc_mb(&dev->non_ordered);
 		pr_debug("Added HEAD_OF_QUEUE for CDB: 0x%02x\n",
 			 cmd->t_task_cdb[0]);
 		return false;
 	case TCM_ORDERED_TAG:
-		atomic_inc_mb(&dev->dev_ordered_sync);
+		atomic_inc_mb(&dev->delayed_cmd_count);
 
 		pr_debug("Added ORDERED for CDB: 0x%02x to ordered list\n",
 			 cmd->t_task_cdb[0]);
-
-		/*
-		 * Execute an ORDERED command if no other older commands
-		 * exist that need to be completed first.
-		 */
-		if (!atomic_read(&dev->simple_cmds))
-			return false;
 		break;
 	default:
 		/*
 		 * For SIMPLE and UNTAGGED Task Attribute commands
 		 */
-		atomic_inc_mb(&dev->simple_cmds);
+		atomic_inc_mb(&dev->non_ordered);
+
+		if (atomic_read(&dev->delayed_cmd_count) == 0)
+			return false;
 		break;
 	}
 
-	if (atomic_read(&dev->dev_ordered_sync) == 0)
-		return false;
+	if (cmd->sam_task_attr != TCM_ORDERED_TAG) {
+		atomic_inc_mb(&dev->delayed_cmd_count);
+		/*
+		 * We will account for this when we dequeue from the delayed
+		 * list.
+		 */
+		atomic_dec_mb(&dev->non_ordered);
+	}
 
 	spin_lock_irq(&cmd->t_state_lock);
 	cmd->transport_state &= ~CMD_T_SENT;
@@ -2210,6 +2213,12 @@ static bool target_handle_task_attr(struct se_cmd *cmd)
 
 	pr_debug("Added CDB: 0x%02x Task Attr: 0x%02x to delayed CMD listn",
 		cmd->t_task_cdb[0], cmd->sam_task_attr);
+	/*
+	 * We may have no non ordered cmds when this function started or we
+	 * could have raced with the last simple/head cmd completing, so kick
+	 * the delayed handler here.
+	 */
+	schedule_work(&dev->delayed_cmd_work);
 	return true;
 }
 
@@ -2243,29 +2252,48 @@ EXPORT_SYMBOL(target_execute_cmd);
  * Process all commands up to the last received ORDERED task attribute which
  * requires another blocking boundary
  */
-static void target_restart_delayed_cmds(struct se_device *dev)
+void target_do_delayed_work(struct work_struct *work)
 {
-	for (;;) {
+	struct se_device *dev = container_of(work, struct se_device,
+					     delayed_cmd_work);
+
+	spin_lock(&dev->delayed_cmd_lock);
+	while (!dev->ordered_sync_in_progress) {
 		struct se_cmd *cmd;
 
-		spin_lock(&dev->delayed_cmd_lock);
-		if (list_empty(&dev->delayed_cmd_list)) {
-			spin_unlock(&dev->delayed_cmd_lock);
+		if (list_empty(&dev->delayed_cmd_list))
 			break;
-		}
 
 		cmd = list_entry(dev->delayed_cmd_list.next,
 				 struct se_cmd, se_delayed_node);
+
+		if (cmd->sam_task_attr == TCM_ORDERED_TAG) {
+			/*
+			 * Check if we started with:
+			 * [ordered] [simple] [ordered]
+			 * and we are now at the last ordered so we have to wait
+			 * for the simple cmd.
+			 */
+			if (atomic_read(&dev->non_ordered) > 0)
+				break;
+
+			dev->ordered_sync_in_progress = true;
+		}
+
 		list_del(&cmd->se_delayed_node);
+		atomic_dec_mb(&dev->delayed_cmd_count);
 		spin_unlock(&dev->delayed_cmd_lock);
 
+		if (cmd->sam_task_attr != TCM_ORDERED_TAG)
+			atomic_inc_mb(&dev->non_ordered);
+
 		cmd->transport_state |= CMD_T_SENT;
 
 		__target_execute_cmd(cmd, true);
 
-		if (cmd->sam_task_attr == TCM_ORDERED_TAG)
-			break;
+		spin_lock(&dev->delayed_cmd_lock);
 	}
+	spin_unlock(&dev->delayed_cmd_lock);
 }
 
 /*
@@ -2283,14 +2311,17 @@ static void transport_complete_task_attr(struct se_cmd *cmd)
 		goto restart;
 
 	if (cmd->sam_task_attr == TCM_SIMPLE_TAG) {
-		atomic_dec_mb(&dev->simple_cmds);
+		atomic_dec_mb(&dev->non_ordered);
 		dev->dev_cur_ordered_id++;
 	} else if (cmd->sam_task_attr == TCM_HEAD_TAG) {
+		atomic_dec_mb(&dev->non_ordered);
 		dev->dev_cur_ordered_id++;
 		pr_debug("Incremented dev_cur_ordered_id: %u for HEAD_OF_QUEUE\n",
 			 dev->dev_cur_ordered_id);
 	} else if (cmd->sam_task_attr == TCM_ORDERED_TAG) {
-		atomic_dec_mb(&dev->dev_ordered_sync);
+		spin_lock(&dev->delayed_cmd_lock);
+		dev->ordered_sync_in_progress = false;
+		spin_unlock(&dev->delayed_cmd_lock);
 
 		dev->dev_cur_ordered_id++;
 		pr_debug("Incremented dev_cur_ordered_id: %u for ORDERED\n",
@@ -2299,7 +2330,8 @@ static void transport_complete_task_attr(struct se_cmd *cmd)
 	cmd->se_cmd_flags &= ~SCF_TASK_ATTR_SET;
 
 restart:
-	target_restart_delayed_cmds(dev);
+	if (atomic_read(&dev->delayed_cmd_count) > 0)
+		schedule_work(&dev->delayed_cmd_work);
 }
 
 static void transport_complete_qf(struct se_cmd *cmd)
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index fb11c7693b25..2121a323fd6c 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -812,8 +812,9 @@ struct se_device {
 	atomic_long_t		read_bytes;
 	atomic_long_t		write_bytes;
 	/* Active commands on this virtual SE device */
-	atomic_t		simple_cmds;
-	atomic_t		dev_ordered_sync;
+	atomic_t		non_ordered;
+	bool			ordered_sync_in_progress;
+	atomic_t		delayed_cmd_count;
 	atomic_t		dev_qf_count;
 	u32			export_count;
 	spinlock_t		delayed_cmd_lock;
@@ -834,6 +835,7 @@ struct se_device {
 	struct list_head	dev_sep_list;
 	struct list_head	dev_tmr_list;
 	struct work_struct	qf_work_queue;
+	struct work_struct	delayed_cmd_work;
 	struct list_head	delayed_cmd_list;
 	struct list_head	qf_cmd_list;
 	/* Pointer to associated SE HBA */
-- 
2.25.1

