Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A5D2CCA47E
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jun 2022 06:59:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241902AbiFCG5U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jun 2022 02:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241837AbiFCG5J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jun 2022 02:57:09 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B43B66;
        Thu,  2 Jun 2022 23:57:03 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2536WAcW031063;
        Fri, 3 Jun 2022 06:55:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=CAfveKXmBZkIq875+TMSa9tVnDh8S6NP7VDkCxs6fM8=;
 b=Cty5c59CEV7rNOr0u+xekZnwjiW5oyycley3nPjIUT4xmC99qDY3+Gqe9+jtghmUxxak
 LRkwoiHZLGwnizx/dhNKTU5fTG100dWTtgfGNVHbZwY8JSRIDyCP7dOtGiXdmLQze2sw
 0HOWk7rw4syq+xbBJUAoauHdHMMO/KzkXkqH0gwQYk7fUa1JBxKsnxu1nR5316dMiVhx
 lEwIbWkXkP9v4gtkRkLCx1euOE2WfLiC5u0UzfmKWxn18uU/YnNX24Gv9thbhYwzyLlN
 NpU2szVX9WB/zg1ykMlvfMmRzZq/krwFx/0B295gxVuB+ty+ux0aFM8pcnUNUBzJ/WQ2 Og== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gbc4xv7t2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jun 2022 06:55:55 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2536oJOJ001834;
        Fri, 3 Jun 2022 06:55:54 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2048.outbound.protection.outlook.com [104.47.73.48])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gc8hyxp2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jun 2022 06:55:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kcfH3bpeo+lzQ3kZQqDI/Aqa1CxxFqd2ZIJH+/TEQ3Sfl7yICpfPqu4kRPefT/zOgHMx99GJoqCo0HEL3LHuZOU2Nsksj/QIQzieRqileuPVr2HWyH20gEy15RFRcCiDWT0xYEcEtQpfpJ0nh+uTCCZv6tmdQUkQLEy72NKLbnXxy/l0Y4vKVkiia/jHZCj9JwFFBziHFSDqziMk1L+wIa55Y6+wuAmqVIb9rNX/1j7NtaHjKlVSoMDRwJZkiPmnCm0Wkb2dtZA9rbLt+TlM+98jsFTkUP3zqec8uI7tFI2nThcmpZMmNPDuUybgmc9YhpFbZQAyfi5yJevWF/ZelA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CAfveKXmBZkIq875+TMSa9tVnDh8S6NP7VDkCxs6fM8=;
 b=HaqBLwDjrehB7zrCIZFqY+qBghT82AYPb3LA6ltzgpv/5+JraRZ25KeoWaupACju8JztjWQkxBajzDS/Uem653I6imL2IcEQtpUsuF3G9fc6tYXQFy8XQSwAj/Xp+Fn30vm1Arjzp9rEL34wlpMGJgNhPqi3eUHCWAEavP44LmhfwJrOhDddRsYOMg45U2jfD5PdXHKjhSEElpRq8yueTi6aE5N1ev8SFbbNuR9OU/sNfp9Gbi1V5o/wGDCh3SzH2b6oCECmuTbyCB17ZOW98OxXUm20wB4eOkPSf6LcV6M8LkxscAaA81wumcxe5GemJSUVD9zsutvUVraMgkbIog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CAfveKXmBZkIq875+TMSa9tVnDh8S6NP7VDkCxs6fM8=;
 b=sgXfPYtDvhOULWxdDbO9pEg9eMR4jJJNQuHLA3gkBoB0uxTvuO+q+8sbo6SlFvBfkqoddvLboxm9bL5ocIv2H59qmWmYS3UKCYMXDu4++TWbWvfwun5XoTXFn70Ec0xR73K8OuBsuQ/V/vpPx4Sw2UYVlHkSOBKVOs8jidDhjTU=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BYAPR10MB2789.namprd10.prod.outlook.com (2603:10b6:a03:82::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5293.19; Fri, 3 Jun 2022 06:55:52 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5293.019; Fri, 3 Jun 2022
 06:55:52 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, hch@lst.de, axboe@kernel.dk,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 07/11] scsi: target: Allow backends to hook into PR handling.
Date:   Fri,  3 Jun 2022 01:55:32 -0500
Message-Id: <20220603065536.5641-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220603065536.5641-1-michael.christie@oracle.com>
References: <20220603065536.5641-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR16CA0012.namprd16.prod.outlook.com
 (2603:10b6:3:c0::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5790e06b-0eb1-433e-34f8-08da452e191a
X-MS-TrafficTypeDiagnostic: BYAPR10MB2789:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB2789018E213D8BA4707F4B93F1A19@BYAPR10MB2789.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /QnULvd01LXt4ttlO4Z+oDmHbHFdcYRYM4/lJpt5wnDTXEtFrsxufIBAQQcoOh2FFkiye3WRumnnvq3D2KbDkj18slzVfSMDfqv/mUYqlGtnjTwsNQowMteld1wmSWJWvMuL+rXrVJzSrwb9g3zd2HHQDZnKiSsSmrwimQ5exJPyywLtJ/S9IcYXPIfMhdoLT1n96V4Azl1DzQCk4Jb7s/mGjZGt+4W450zS2viVGp8gk2c3lZE9kUIwNwvPwt5dhtgCCU9d7zG02GnqzvmUvaSdLfjdV64TkLsnClZt+iDfs8jp888AJOa9AOqL9FvC1742ZbXpZrP4QWm/f6Sfi0m9hNeLZdS4eqRjTM+mnRIN1sc3z5GV2ILgtbglM/xVRagBQGX4UTtXfe2+jI4AaegdCu26QklUh3Ms5Xc6/DY5xbNnPsLIIZ5X+cO4fTayTkg4OTb/W/vxAHmSHFzZifD2TtjtON64vb/8PB/Wbe2Qw5CqBQN8MfyQYRoxMh4Oeh1+4sU53IetW3SM7tWk+enQV0WyHwpVH2tQrmXfwW9KoXIasurUH7Bmo9OkZ90vSD3a8+u2CBEQyArrRxR/huD57qzhnXEn0SGJ9YK6ULHyVLysiCpF361emN0XLZsyWGGY0eQeGf3p5wVjJ3hwTtQ5r6mgAvzz+BOBrsKqRf8BKxMbX67dr/7sgs/FL5HKjKnvxlQU6hUNZPGd31HoMA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(8676002)(38350700002)(38100700002)(66476007)(4326008)(66556008)(86362001)(83380400001)(36756003)(8936002)(107886003)(6486002)(2616005)(316002)(5660300002)(1076003)(6512007)(26005)(2906002)(6506007)(52116002)(186003)(6666004)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e4mIjZTeJCJ2fvBBlArfqVXaCtmDZ6NXVPuigh2mNORcPAX7/gxR40H1RkdA?=
 =?us-ascii?Q?EPwixfZ1st13+f01RiK+Xcrwf74/erVz/QYJ237vuEvCfR5wN2dK0M/EcAIc?=
 =?us-ascii?Q?0eLIAF6Q9lszdCD3U0psDf/XLdScKTIGKGoc0kTjw5GjRIP8EVcTKkt4rhdv?=
 =?us-ascii?Q?f3H8PHpRjhCssXVGivLnha4ObgUqXDj9y5i3hq/6VleT8dS9oTl2+ppxJ1EL?=
 =?us-ascii?Q?i4nr7c5ZJn2ImXXI8K7BrIfUSJ7V/0EtDmGUrX+99Ipz07WcOwMqPTuP3GwV?=
 =?us-ascii?Q?/gd1q3LsuubypFezzAJuUca4X2kPdm0tCQjpr4Si8H1jXtrrvHAsLNhFcznJ?=
 =?us-ascii?Q?U8Pvcu3X81iKjGhvkwwdXZiAGxmn3tU0DeKd99Q9a4kml72dqTK7YkD3ILgu?=
 =?us-ascii?Q?r544hQo/0zZiJpsnlXZtuB5M3LH80XhjbTPFhOvLg4Hp85tHbyZwBr5eb6x8?=
 =?us-ascii?Q?rbzkLntWe/f8S9kIuhlzik1Jt38KFmUUrpo6nlzeheGkMZv2sGM5dogSCSUA?=
 =?us-ascii?Q?Ay3Up1bmxYBd/8pS92jZTURFdfGjiKRh9YmZIOgK1Bl1O05mkWAuiUDj8fEs?=
 =?us-ascii?Q?hlv/cf2wf/HEpRqTYQQmQcfAwL6yrZHpNVokohbo+OgHaPdg4TME42Ez7h9s?=
 =?us-ascii?Q?kpW7XGFkCxm6eZENKQVWou6dTxrfd2hD7FxlITBx+HzZ5NAn95Q1CXGlUJcP?=
 =?us-ascii?Q?rubqFl4EHZON/YJX8Bi9ybRiGtolOjc//bsaEC/wCFeEtJSWASQZhG4nfgMy?=
 =?us-ascii?Q?+N810TAqUSCRftK1MbJXrYdg7woeeTBnXrZu50zevVwJ2xdL4ccXVjSsdFNh?=
 =?us-ascii?Q?+as18AhqSc5lVzfYlFUWekYjWYPDd8NctEUpNgJ6xaN5UzWBpD9T6K+/ujqR?=
 =?us-ascii?Q?IYFv/tJ+t/1ujvqdsSqHlLgHxWqEGEKZ9b5xV4oRHx9RRwOdA997OHrvH+d6?=
 =?us-ascii?Q?e/CV7h314gHIeXr/BD/jYRdz+MQRI6gpsazQPSUwP+luW/SvcV5rXI8Shke1?=
 =?us-ascii?Q?eGKGuksRpgK08lBobeOmpX/f6REqO/kuLeGhYh5PW3hBoCWH40H+/6AkykUO?=
 =?us-ascii?Q?3pEoIzeGMcPfFb9erEIdZWvdIXEJL4scUTkCKpv5V5835zbw+48wTem/k4kJ?=
 =?us-ascii?Q?xaBFOD2M1glGnw7OOGHc7xpHbE1Q1YDYlCmfp6L+P3lnv/TGafhV1rTO8DwI?=
 =?us-ascii?Q?AEiG5le9Pn/gPPYXM9plZ8vnJJFrfz56PRDRvzHLjhBc8H7nNMr02enFhVCB?=
 =?us-ascii?Q?jV+m1qGndIOPolRj2LCLrpoNGKyJIxUvhSykVGhmds5qq4YfQvghm0h64CKM?=
 =?us-ascii?Q?5KTTVHdov8w41DUJxGTE/m4LMJXrbW2VlrDLOwSV2P0LUoyQpd0eo8aqCjLs?=
 =?us-ascii?Q?sOLvCaF+kEg+cbF1SkcBNHvozzOqZTTovqwjQzhCNUlzRvpztqCLKgIlXp43?=
 =?us-ascii?Q?eri2srNuHna1JpHWherQcvmzrBPXx36yNlJmhLFJ0yywUNxA3nPhwp1GY7hD?=
 =?us-ascii?Q?qApPQtR6NDb8XMEj5GM5I/xZyTi/gR1Hmz1affaenxzTtdlU+CXc4QtsfVM9?=
 =?us-ascii?Q?idDxCVrhTu3RfBFSsZWYiBX5To1l8VsKSBc4PZulMF6K1ZHUtXgfr6Sb1DmO?=
 =?us-ascii?Q?H5OG6ju/GtOwr9SiUPgNn4Q0XO95DsjLXn18oYjW997u9AgOYGuwBVXXhzJu?=
 =?us-ascii?Q?MLksXMvf1cX1tCmX+LRboiskN1Zb3iVWS59HSlrrpkoqu/BPY6qHzNVxCWQE?=
 =?us-ascii?Q?WXfM33hiAtnGP5IRJVPmFZkcPKeQxsg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5790e06b-0eb1-433e-34f8-08da452e191a
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2022 06:55:51.9712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TzCDcBPit35isa/iw5DsycI1cHBUZ6XDWc9JiMLQ84MvorMFsigIhypvvItyHtrwS2G1b1Sksoc9DAIC7w55Bttq24Nwjcvzjk139WmmqZw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2789
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-03_02:2022-06-02,2022-06-03 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206030029
X-Proofpoint-GUID: 3Xn1q6a3uQs727qhJyalTg13ldZpLP0y
X-Proofpoint-ORIG-GUID: 3Xn1q6a3uQs727qhJyalTg13ldZpLP0y
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For the cases where you want to export a device to a VM via a single
I_T nexus and want to passthrough the PR handling to the physical/real
device you have to use pscsi or tcmu. Both are good for specific uses
however for the case where you want good performance, and are not using
SCSI devices directly (using DM/MD RAID or multipath devices) then we are
out of luck.

The following patches allow iblock to mimimally hook into the LIO PR code
and then pass the PR handling to the physical device. Note that like with
the tcmu an pscsi cases it's only supported when you export the device via
one I_T nexus.

This patch adds the initial LIO callouts. The next patch will modify
iblock.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_pr.c      | 60 ++++++++++++++++++++++++++++
 include/target/target_core_backend.h |  5 +++
 2 files changed, 65 insertions(+)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 3829b61b56c1..1c11f884e12f 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -3531,6 +3531,26 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	return ret;
 }
 
+static sense_reason_t
+target_try_pr_out_pt(struct se_cmd *cmd, u8 sa, u64 res_key, u64 sa_res_key,
+		     u8 type, bool aptpl, bool all_tg_pt, bool spec_i_pt)
+{
+	struct exec_cmd_ops *ops = cmd->protocol_data;
+
+	if (!cmd->se_sess || !cmd->se_lun) {
+		pr_err("SPC-3 PR: se_sess || struct se_lun is NULL!\n");
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+	}
+
+	if (!ops->execute_pr_out) {
+		pr_err("SPC-3 PR: Device has been configured for PR passthrough but it's not supported by the backend.\n");
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	}
+
+	return ops->execute_pr_out(cmd, sa, res_key, sa_res_key, type,
+				   aptpl, all_tg_pt, spec_i_pt);
+}
+
 /*
  * See spc4r17 section 6.14 Table 170
  */
@@ -3634,6 +3654,12 @@ target_scsi3_emulate_pr_out(struct se_cmd *cmd)
 		return TCM_PARAMETER_LIST_LENGTH_ERROR;
 	}
 
+	if (dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR) {
+		ret = target_try_pr_out_pt(cmd, sa, res_key, sa_res_key, type,
+					   aptpl, all_tg_pt, spec_i_pt);
+		goto done;
+	}
+
 	/*
 	 * (core_scsi3_emulate_pro_* function parameters
 	 * are defined by spc4r17 Table 174:
@@ -3675,6 +3701,7 @@ target_scsi3_emulate_pr_out(struct se_cmd *cmd)
 		return TCM_INVALID_CDB_FIELD;
 	}
 
+done:
 	if (!ret)
 		target_complete_cmd(cmd, SAM_STAT_GOOD);
 	return ret;
@@ -4032,6 +4059,33 @@ core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 	return 0;
 }
 
+static sense_reason_t target_try_pr_in_pt(struct se_cmd *cmd)
+{
+	struct exec_cmd_ops *ops = cmd->protocol_data;
+	unsigned char *buf;
+	sense_reason_t ret;
+
+	if (cmd->data_length < 8) {
+		pr_err("PRIN SA SCSI Data Length: %u too small\n",
+		       cmd->data_length);
+		return TCM_INVALID_CDB_FIELD;
+	}
+
+	if (!ops->execute_pr_in) {
+		pr_err("SPC-3 PR: Device has been configured for PR passthrough but it's not supported by the backend.\n");
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	}
+
+	buf = transport_kmap_data_sg(cmd);
+	if (!buf)
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+
+	ret = ops->execute_pr_in(cmd, cmd->t_task_cdb[1] & 0x1f, buf);
+
+	transport_kunmap_data_sg(cmd);
+	return ret;
+}
+
 sense_reason_t
 target_scsi3_emulate_pr_in(struct se_cmd *cmd)
 {
@@ -4053,6 +4107,11 @@ target_scsi3_emulate_pr_in(struct se_cmd *cmd)
 		return TCM_RESERVATION_CONFLICT;
 	}
 
+	if (cmd->se_dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR) {
+		ret = target_try_pr_in_pt(cmd);
+		goto done;
+	}
+
 	switch (cmd->t_task_cdb[1] & 0x1f) {
 	case PRI_READ_KEYS:
 		ret = core_scsi3_pri_read_keys(cmd);
@@ -4072,6 +4131,7 @@ target_scsi3_emulate_pr_in(struct se_cmd *cmd)
 		return TCM_INVALID_CDB_FIELD;
 	}
 
+done:
 	if (!ret)
 		target_complete_cmd(cmd, SAM_STAT_GOOD);
 	return ret;
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 4e6cf1bf3b87..0b7f540be84f 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -68,6 +68,11 @@ struct exec_cmd_ops {
 	sense_reason_t (*execute_write_same)(struct se_cmd *cmd);
 	sense_reason_t (*execute_unmap)(struct se_cmd *cmd,
 				sector_t lba, sector_t nolb);
+	sense_reason_t (*execute_pr_out)(struct se_cmd *cmd, u8 sa, u64 key,
+					 u64 sa_key, u8 type, bool aptpl,
+					 bool all_tg_pt, bool spec_i_pt);
+	sense_reason_t (*execute_pr_in)(struct se_cmd *cmd, u8 sa,
+					unsigned char *param_data);
 };
 
 int	transport_backend_register(const struct target_backend_ops *);
-- 
2.25.1

