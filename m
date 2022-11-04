Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2699FC433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Nov 2022 23:23:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiKDXXr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Nov 2022 19:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiKDXXo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2022 19:23:44 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D1075FF9
        for <linux-scsi@vger.kernel.org>; Fri,  4 Nov 2022 16:23:43 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4KjBBn013373;
        Fri, 4 Nov 2022 23:21:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=IG38ZcaDktcxHrevnRSqilXMxFKxUPtrHC0YVxkm2DE=;
 b=LwnCb4cdqTfYunFjw0ZwCtKMjD+rztgq7fvPbMKtUdfDLXegwqKsJKd6+cldsD+f1fXr
 VjeJTcVUBwUvpOwDnGPv2KRR9qzVIYHbbVrGvpAkjDO8Wi/g7+ZLdy7x/Y0X6RqfwW1L
 P92JOEYVdTVhwt59/v4r8z3oDCQZIL22T6kZIY39bwH/po1Z648v+YHyJ+JQXbbRH4XT
 f98X/OLFspWXnlr5e/l2ZNbrWojoUQFQooSvOL7Nu+b+DGC262YEO7JToHBFA0lIli9o
 TZmtxn6JJ0LyWL6HNrkgTFgYcrkxO8Po196US4aGMfBGZPhwRW35qx0KSWVIzsbF+Uvv Wg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgv2as1jx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:21:34 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4MI2F4012011;
        Fri, 4 Nov 2022 23:21:34 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kmpwn8cpa-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:21:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OglHEEhvtiQvR4QF/n4vawHULmcKaivbLXybCr2DdBeXoVlkuCAAlLkcV8QEPLSWJp6incuoBL6bjYjUxs7OH7V1S9qlBGzyBFenfvsOs/kj4rmOuVT+iIi0MjT1Jva4x/pkJgQBk4ZJY+qQEPgILtWkEoyBCdeMgLs36k+FFKcf1k9DaDSLIwK+YgDoebYMIzpsRmZPLuIoOF1skHFtKWNDuKCANYg5QJZgA+jY2El9gN86nKDXGqcZ3jFaeGIZPlj6Vg/AfsC7pOn9dBXtUd2FOJVx5qJtxgQCw8MdCXpICqbLsXt2uU8G1B41VyPXKJ5pjncvrS8aqnn7wkBNQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IG38ZcaDktcxHrevnRSqilXMxFKxUPtrHC0YVxkm2DE=;
 b=diQLCbW5CwvGwqr/f1RRKeXPmT5WxwF6+/5ydiIWsqdGbgbJhrOtl1o03+v8K29j1gp+j6/VVRGRg7u2dJMY2rcBSZ5K/zHLSx+nZtzGRylyGEJ2xKQQJGkRlrbwiAC2DdYVsX+bInOno+kWCcMtgObRuZfsPHckaYTKUrM/OfMfa8iuGXO+E85rDvPfq6swBaDy8kPUoNH3ZRPvAxukkEyRY2K6Ud4wgSphA8USKaQcNtuPEsLkHyQnG4jODuwwL2xLqN2xlYsdcOhW17MdT4o+3tkQCAFsiH8qSZbIXoLCTOtu+8ZVCcb+FY5zPKAUOOBOzYZ+6Qzmf0qqUhKZ6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IG38ZcaDktcxHrevnRSqilXMxFKxUPtrHC0YVxkm2DE=;
 b=DNvirf1G/9Slh7tbu9dXr/1+x0moC6+fHSNGhSxNAN5HmfdoC8/U/tjM1E4/KZMT1R2w2QAHJDCLD6LGPXMVPh1e51JDOeg/j2DJehxwDsZWQQNQN1YnWey20EuKlGitl5tgnnG+DhxwkX5PjThKiqXjMhk3j/53L3Bjl0sRl6s=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO1PR10MB4433.namprd10.prod.outlook.com (2603:10b6:303:6e::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.22; Fri, 4 Nov 2022 23:21:31 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 23:21:31 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v6 04/35] scsi: Add scsi_failure field to scsi_exec_args
Date:   Fri,  4 Nov 2022 18:18:56 -0500
Message-Id: <20221104231927.9613-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221104231927.9613-1-michael.christie@oracle.com>
References: <20221104231927.9613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0061.namprd03.prod.outlook.com
 (2603:10b6:610:cc::6) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO1PR10MB4433:EE_
X-MS-Office365-Filtering-Correlation-Id: 53edb85a-d2b0-4e9b-1633-08dabebb4e3d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i69oOVRogv1vdUQA/6utyf0j2Yi7T3ZJsOGC0iHj7Vv41hzzt7RzKvny2ZYlkCdE6AvQFNyYJassevfcp5HKd/fVxfeSVVxUN86Kfj/ZIdAnoLnYmf+K8Xgg5Pr11rqSZpfBLecDXyXCyEfXVchwGUNzedgfbWNDZX4HcYmNMARq8R05l9BTuIBdA7FoN+/dGM3G9dIGB8PH4+Gr+V4UaRZDHjiitmR0qRyt89ELh+VdCW8Hpvz/2Giizm6sLZhtobxhq8gnoEm3Y7Roz/GCoXTJ23hLolYvfpuZi65dFLUbqs0iuyZ6Db7dntgiJi260cetJ9l62ZJYNLMsUBHTv5naG8il+wac0SXiH8Y23mi9HcIQyWMTnB4eankMvD2CK/RUUxzln1BnLLjzTZb+l8jdpzO2ari9EDEKxEMOAl9yMvX+3i7lYpUpKdt7777mk6ZW96ICgz5UjFqND0hOvkoZF7eqi3ewOQftC3B/F21R+x41olCM5No6w1AmGMSLTyyAz6g2/e2kRgozZfR2FiY3nhswZTjSqNd4d3KV6LAw8my3mPuwOiOXhcXtU/4GKnLuomWF0M3xNF8BRGfoeG3cRPUQaiItM7AdVZnSlw3gihlYbvHcbMR27mZ+LKWMvLmYUhwHt4ORcxTCSmTD4zRnEzJSji7gzVPZD8etbCcoP1HwDSwZi2VvvcyG96Cx1pq68ujjCP8zDHxliUujCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(39860400002)(136003)(396003)(366004)(451199015)(83380400001)(8936002)(41300700001)(5660300002)(6486002)(6666004)(86362001)(478600001)(107886003)(8676002)(36756003)(186003)(1076003)(2616005)(4326008)(6512007)(26005)(6506007)(316002)(2906002)(66946007)(38100700002)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+zz0I9t/nWBz5X3nBswcjwfCF4UhD/EEseXR6Z21uuNEepwaIjSzFSNJBw2T?=
 =?us-ascii?Q?Z3WBWh/+Ou/NT7yxJlJDezrq4TW6DRC7Na6ZcIt5hbCvcLlHTWnkm/xq4diR?=
 =?us-ascii?Q?z5ig32G6AOsAn+urwxibLc26X7isvJAdEahgMOb5kaB3CPrFok14rN3veP16?=
 =?us-ascii?Q?E5hhLgBkFwIpzLoaaFrxMpy8v4uBGhzkxUaO8U71MTBGLGck1LgCtwmoIPjL?=
 =?us-ascii?Q?8sV3cFZ/BVmIXsukJYEissv5iVyF+vytWBoWbkr5J7s3vx5r7UwbQU29EKXy?=
 =?us-ascii?Q?4fMSfdG46YXHOhEujG23szDfZWApDgqwxtpSMPRIv/SotnhcHj9Nn47Gv5FL?=
 =?us-ascii?Q?fMbcillCAnSZdJted68tJYtCynOQWU19LvUDDrh0ATDHZCgBNR6F6cFppp+D?=
 =?us-ascii?Q?MzR8OtgLJulDe2lkJXJVfHbJkNNSg0A8ecjhkbk+u1YdMhXlRs/lL1v2Wfeq?=
 =?us-ascii?Q?eGxzSoYtU5TBhqSn+HgbwoB2dVTzT1TUSAeeaOuoq/7JVwbXrP04munDAZqb?=
 =?us-ascii?Q?80aiwsHZPPdXd3+sqFEuew6hNNAtPnTV+zrn2SmpexPS48oR9Nts4uHCFLMQ?=
 =?us-ascii?Q?Z5s16sUc6+bZuEXwdTowu1aappQWgAk0eyn4zxBqRRpjATxG2vIqKBTtDaDg?=
 =?us-ascii?Q?CcB9A5br4FmEpwpdBVDXc53E+XxFCE6mkoPAxsuBW/0WNKXDKW1ZEMV+EJ3G?=
 =?us-ascii?Q?7ExkidG8OZwXC2uuE/+f1LSWWoWkBy0hUBEa+fjR1HylsFTg5++ImbIeFUXC?=
 =?us-ascii?Q?C1gcu7rCMcsU12jI45WLFETVxM72hf3SDJqwV+M2lk2kG+/xNIe+Po0oQhtG?=
 =?us-ascii?Q?GyeVJqFoxPRtfw1ieMWI3tswzxC6olxC5PLoUf0y3YW53o0DyBo+RN+9PyXg?=
 =?us-ascii?Q?U+rolXO1cjwHWt4LaWeNkfu30astJMGz37uf9QbOFN3/a37v1TiQxlfUcTgF?=
 =?us-ascii?Q?dG7vGqh9aUtRZZH03NGT+jYemkoOYtqe421/qWodH5L8G49krPyh3CdJfZNi?=
 =?us-ascii?Q?xleW/Sff6IBDW3bn5oWauwzCF0n+2UJLdZfVOQ0sRfMoq4UoozFNaAT+ItcY?=
 =?us-ascii?Q?L9kFpZ/O0ymP1eW6bpqWkwIKJaWgSIG3F+0nopywylqLTsL+qfMUZJinEW2B?=
 =?us-ascii?Q?THe4In8jdm3aEA6OaYlhtmR08d9KqqyreIBT1ujbwCFd29F+4mjmxkvOduDk?=
 =?us-ascii?Q?DAEs8CHHcmkzG4z9+sjX1ul96zuDdRlhcBbaHe3UClznz0CU9/D0UkDI4ngW?=
 =?us-ascii?Q?rbXzaypkW1WpEe/O8g1h66/SNXTfk91QNCJjlRzkf9RdnUG+ZmjkRIlydhej?=
 =?us-ascii?Q?0aq1Ph/kEbzE8yDmgym5G4+iFTJXW3kRS4XobU9UoCDkW/pVsjhu2ePCdhdw?=
 =?us-ascii?Q?viVjX6iZECp9Cqv7Px1+xmJzYfP1BdUCNu3mhfOKWwt5WE3EdDgz8QgD7JlN?=
 =?us-ascii?Q?P9h9KI1ezOlHCzqmz2wc6BSUtzh0zPrCLVqdpC93k0nOBk0j5uBKw/cPza4i?=
 =?us-ascii?Q?Re3O1mp8oy8WdFycIJfr6bBMPHl6bZ8o60+gq9tuWADofZd4c0QCQWD+1k/O?=
 =?us-ascii?Q?4x6cjSF0y7epwrivCSjL1BcyrbFlDoEZiyg254aqb1HnA306fT4jHP0trMKJ?=
 =?us-ascii?Q?7w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53edb85a-d2b0-4e9b-1633-08dabebb4e3d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 23:21:30.8384
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rpkmUt6o9n9DqXMDH4jelkZyU8xZS7h6nUaRJJsqE6WXpetY8nIOVA0AusVM36ZDTkX0c12Hzcjrzwkppno/3lM5f/WJQZMdqKvC5tVMm4k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4433
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-04_12,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211040143
X-Proofpoint-ORIG-GUID: lWd84MFBFvS_GItBwYXfXauCMlHypsKz
X-Proofpoint-GUID: lWd84MFBFvS_GItBwYXfXauCMlHypsKz
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Allow SCSI execution callers to pass in a list of failures they want
retried.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c    | 1 +
 include/scsi/scsi_device.h | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f832befb50b0..9b6dc47bcdae 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -215,6 +215,7 @@ int __scsi_exec_req(const struct scsi_exec_args *args)
 	scmd->cmd_len = COMMAND_SIZE(args->cmd[0]);
 	memcpy(scmd->cmnd, args->cmd, scmd->cmd_len);
 	scmd->allowed = args->retries;
+	scmd->failures = args->failures;
 	req->timeout = args->timeout;
 	req->cmd_flags |= args->op_flags;
 	req->rq_flags |= args->req_flags | RQF_QUIET;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index cd3957b80acd..4ae36274b6c6 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -14,6 +14,7 @@ struct bsg_device;
 struct device;
 struct request_queue;
 struct scsi_cmnd;
+struct scsi_failure;
 struct scsi_lun;
 struct scsi_sense_hdr;
 
@@ -469,6 +470,7 @@ struct scsi_exec_args {
 	blk_opf_t op_flags;		/* flags for ->cmd_flags */
 	req_flags_t req_flags;		/* flags for ->rq_flags */
 	int *resid;			/* optional residual length */
+	struct scsi_failure *failures;	/* optional failures to retry */
 };
 
 extern int __scsi_exec_req(const struct scsi_exec_args *args);
-- 
2.25.1

