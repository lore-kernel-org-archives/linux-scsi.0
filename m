Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB1BDC25B0C
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Aug 2022 00:05:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244543AbiHIAF5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Aug 2022 20:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244705AbiHIAF1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2022 20:05:27 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E160ADED;
        Mon,  8 Aug 2022 17:05:18 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 278NxAsO032222;
        Tue, 9 Aug 2022 00:04:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=F8IpO7pfiEfrdcP1LH9GktnkTV3mENXZ9yA8Iw024eQ=;
 b=2qTF6oC+AihBs3Sv8VOZzdnBfSJm6vDeLASwWtHk/7z+cyA0rqDAD2Nm5EZJRN2y5cUl
 OpMq93+tr4cfEf650UxwSH/c3B6xmrRRhl/sej1J319tJMkxh+abgA2xABBziq4J0TUh
 XajqIQb8mX4symBt7a45cfHwCL95dOw9P4HDQ3Et5tYtR8PZH7Aqqt5ck3hCElDUodr6
 K8RqVt0LyhUE6Yf9oIOzsAmVlqunmTf035+6WA1q+5R+ah6vOAWyRbs6xRR89Lrlh8kB
 pdOGtaW/psyun3VhSkMY3LQ/55/jdnjY7cDTDRpkM7EadSiwKcf8H1+BG5euy1G3qLph Kg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hsew155hr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Aug 2022 00:04:52 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 278M0h2Q011667;
        Tue, 9 Aug 2022 00:04:51 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2044.outbound.protection.outlook.com [104.47.74.44])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hser26u9w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Aug 2022 00:04:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IboQs/f2D8uw2QDNEMLhpitDZGMXU6JmGr3ULZQPwXy9tO6DDVxHv90XSroj8riz779fCBkLOExivFEQ405BsksMv8gn58VYwI0xCH3swEvtt4j57qLPqyZiYGugQzTuESgB7Kp5geeMlPrl1zbqc/EJ+YB4Tni4rFqCgbRzXIfrlId53eib0BzyFuIpw6xlF+S5gvI2hld937XpChEXP6nwLRM7AO3SicpldnB+tEOXbblviB3YiuCrAaNcgMsUxM8G5dqx1kaL1MfkXsEyIFJpIgzIuSoK+mSaYGAWO4GX9+AD5s9i2b8PwYX/xLMl/ii2hVGRyHuLj7Upgcm3Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F8IpO7pfiEfrdcP1LH9GktnkTV3mENXZ9yA8Iw024eQ=;
 b=Lpcot4s2qPkIreo9VvdD42XE1dZH5kwx1jpxIWV79pTDV3SRzNLELj0hVCLHlu7zEevE+IqFsXlLvycGHk0yH3xUaI8PJeSmMhDdeKKlQS8SkCku1VyCRfSkW0/twGMEDsZEbomdqSx576TJIbzhMC0TOvdAisfNtYh7/2up+vuVKBaH+BBMX3stowty0phgBEOYbqZ0anoKb3bk91jONTEBA3obTL5WCcB2d7gARhw3L9HimBCF4UiaLWgXE9QgxJOHPMB5h9opXgyAFXxuRFXCebuccRyDb/9R8Z330TmYPmu/DviCEnvdnYmpoGokne9xvXbneE3xL13rojbpJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F8IpO7pfiEfrdcP1LH9GktnkTV3mENXZ9yA8Iw024eQ=;
 b=p0goFVTbWTo04FSz7rvZvOs8ktHDxtQ6RrpIhWFVLmNqSsBBi91U1TMvaItrgvSqkVMKSTTBFEZCYAVU0kOLRmZXlcQF0knzxr29lrCLrvYczJxf6exSTSnH5BdeoUCvU6fEmGSqrMUAhomx9B2gEQhgPzT6qj8mWOdsD/f4UzY=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB4907.namprd10.prod.outlook.com (2603:10b6:610:db::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Tue, 9 Aug 2022 00:04:49 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 00:04:49 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        hch@lst.de, linux-nvme@lists.infradead.org,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 18/20] scsi: target: Allow backends to hook into PR handling.
Date:   Mon,  8 Aug 2022 19:04:17 -0500
Message-Id: <20220809000419.10674-19-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220809000419.10674-1-michael.christie@oracle.com>
References: <20220809000419.10674-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0290.namprd03.prod.outlook.com
 (2603:10b6:610:e6::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: df5b1605-b635-4f2c-bbcd-08da799ac680
X-MS-TrafficTypeDiagnostic: CH0PR10MB4907:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SRyUywUhZVQSyOIpFl58obc+FDLbFHv9uBvVQvq1CRJhogEtrigxe6GsLHoxgP2JoHxEUP6m3NDLG6nzNIdH/etD+bw4JIuDZUd4GGbtThPd1mPq/mGU4o43xKK12EH18epGjfbimvnCUyndk7KQA72+2Smh7UvqI3M6qYfKmpdgkVhj7mPyr2ZgrQsEx8O7PIi3AVcilG0+9qlzwZYS7DnflZCH7R1R6JvVUVXU2Ynsix/XTGwMX4EMZAfx7w5udwWizeqykKmGX3/6tWMl3qFzSkWXSeXDIVScX6Q98atSWWPSZXEB1ltMm4pS9bZGbY4CakdsXv6XZPi89LR4IJXGXcnuDOoERoBHREV05MjoIeH7J1g2Jvsw2HPvGPKb5HwqJthHNsgiOzhoI6dXAOlYOSL/O/dPG9ogIHbeu8lHoR2mkwQEBF2uSDr7buvmT6jxV26LcQaCiA6KmtRNlkTIKoZCK+zHoL81P9ND73U5GV4L8rvFDDhjbgCIYqmnB1x8FY0qR654W/1TdwGoXvfbP7SDTBJo5doWM/XTJC3I/+XmYjmMy+HmdaL4bGzqitCMojwPa8Olfxjl0N32lIWoRzmRtQyaDyLauQ+eALFvJUz3ECdHnrzj1VI0foEGS4K/I9Ac7pDlLkNKnh0iGgbqUOWS4Dr6+pWP+NvMV6m9+GSsOCUk3DleJZRC1JQN7SUkWyw5GzQ9MfWyrV8evSBKIUePXi/fxcYcYouUmctRQse7cLBS313hV4dQAjFpGCC48Igu/h52YHYRRRqwvugx6q2cigDdhnXYO3XVhZ8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(366004)(136003)(346002)(376002)(39860400002)(921005)(6666004)(41300700001)(6512007)(26005)(2906002)(6506007)(83380400001)(2616005)(107886003)(38100700002)(86362001)(186003)(6486002)(1076003)(316002)(66476007)(66556008)(36756003)(8676002)(66946007)(4326008)(8936002)(478600001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y5E/RdMS9ib1MD3Wq1NEpj4kesMir6PCRPh99lpV5ywUMUKEZ1u+ZBQzLIYo?=
 =?us-ascii?Q?NS+0Ina+EJRSzfsiG6fDhG0+9BiMNqQZCfE2YPbB0NhypagPu/5jKz2nP9om?=
 =?us-ascii?Q?ulg8hOEyve3DdfoJ161g4sTrYCBF2EtpJiJ9kDxSmIzOdf7XSTb1Sd279aLR?=
 =?us-ascii?Q?l95kHflsWveSaAifWjvHvyAR8W5ebrshvrl1NP86LaVJlo/xYvJX6UGi3zJq?=
 =?us-ascii?Q?U4hh/tiTEx42r3o2lNeWuDsT5QYf9CN9+8BkanIXSCYdoWMG2+yMEVbVpmVQ?=
 =?us-ascii?Q?Is6FIYMJrhbBRqYXFQLwq22jnAZevLHgYUba8W+/MZA6W0RR04d6x7EWeKiH?=
 =?us-ascii?Q?2fSEcXOTpkrjIeiXl6ijuhnbbG/TU5uYegMIlbh/OQUrXxJPK9uqa8ljIJT1?=
 =?us-ascii?Q?B7TH8yAbN7vgG0832nRMR/sihrBgofEixRnM8AcwVjBNy4vOA7b9zUgEPBZ3?=
 =?us-ascii?Q?8H1/PNXLrXCqfZeR+/hZsDaskxJX756TcGkoszOY/WhCjMrLMZI4MucDVCyK?=
 =?us-ascii?Q?c07HjqQwmfptC0jgaRzX9Eb2KFDNuK+2sxqrqULM6KDdk5roBKMmR3lVnS/h?=
 =?us-ascii?Q?urPDhsv010DQ00zkT0z799k7oKya+8+rhfaCsS8+mriUOTCCnqT0aomiVojM?=
 =?us-ascii?Q?7QOFt/sHdf4xh3GHXPJ6bC4d/fD54BnwHOoruvXqi5xZUQXYuv/SioA6P8bY?=
 =?us-ascii?Q?I/zy55VqEDwBbHuiY0xmiGyhr8CZT4lUSqz8F/UDy3TG/Q0it4X0ivi4yzoG?=
 =?us-ascii?Q?FBs3gesIj58tdUzHJ7B4o6lfknFWnCOffHwr2pVvzBV/ETwJl0eZq3c8IuVE?=
 =?us-ascii?Q?CtzTRGfDRD7mz7Pg4PrwmH368pE8pQehccOTgYFDjWKxqFnnI7UCm2rL0ek8?=
 =?us-ascii?Q?XYT3lKNCmHgNqcbsD3ViXXkcgysC+QCwDLX35xLaKDmz34P9oUkNrRcZWOuO?=
 =?us-ascii?Q?VmBuNAAbwpFy1T+v0FskDWPvwW7taFWYxrz9dD9V1sB6iU2ZkZ3pZINiSHgN?=
 =?us-ascii?Q?LXrvSGZ3C0QI/yGyGb28MIIG+J+6+/p+uTeOSu9S0khmtG/1VPjkKnPOb+eX?=
 =?us-ascii?Q?0J/uRH1ZgKJR3+9p04mg4GQaWZhzWWMqvzrZ2wV6cl9Vp+X/kr10WYfqv5GW?=
 =?us-ascii?Q?sQPuCy1QzT5rQdbYlTwpn83NSQTvh/5tufUVjyy2kR+VehdvB1Nf8+7W6S6x?=
 =?us-ascii?Q?PWB9KXzOaRc0clzGxkhBs2gGZy0fRm34CB4DXN++Ayf3qUbAl7w4l8U2jw03?=
 =?us-ascii?Q?SVXEfI9ewllcET+lwyDeUFTLKsPYeDRtI3OufJAE7eYlKzukI1gXfStbT8J+?=
 =?us-ascii?Q?2wt1WDrW4Eo22ZqY7bZa3Qt+41LopB/ndkjn9lFr1Uc3LvIIfyGsRXl3HFML?=
 =?us-ascii?Q?C1ewE8ElQAg3fH4QIVL2DxdnCXkLZlKC/rAcDD/gBYPRFjKAYKt6MsjuB/k/?=
 =?us-ascii?Q?9rMUOnTNN+dR+sk4+/QzTAgEq1FYNxpYE2HTkq62kPhvnsN2g4f8V9mEE9tG?=
 =?us-ascii?Q?5MftoIHSndLInx3DNHaikOkEWmxH9sebEjHi+/AGgpMqARa1kyvbxEk0Ybur?=
 =?us-ascii?Q?mqFmdbIubZXiANEBYKOKgTfgBBlnqp9N+/3YaXFjOuxqfjGvf72UuMyNrcKc?=
 =?us-ascii?Q?SQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df5b1605-b635-4f2c-bbcd-08da799ac680
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 00:04:49.0471
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b42WbomUboO9n7kSGgbqTM5OPPgtRD4tBEKekiUrz9fSQzcuPCQ/kJJ1J/xaHj3hgJTsLyNz5s6K0y+DRsivWwbpb2l7eWXEVO6C6QseqQ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4907
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-08_14,2022-08-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 mlxscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208080105
X-Proofpoint-ORIG-GUID: N5_fbjBG0w_KIA77jhx5TAnC25NlXBlj
X-Proofpoint-GUID: N5_fbjBG0w_KIA77jhx5TAnC25NlXBlj
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
index c5df78959532..84bfdfb14997 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -69,6 +69,11 @@ struct exec_cmd_ops {
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
2.18.2

