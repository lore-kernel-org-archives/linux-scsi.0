Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 664EDC54EE9
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 02:54:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234804AbiI2Cym (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 22:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234801AbiI2Cyg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 22:54:36 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5484A5F58
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 19:54:35 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28SNiQTS003456;
        Thu, 29 Sep 2022 02:54:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=3DhM9dTGQqYXWyJVPvxTY9dcyDBALZa4fcaFtTpuoos=;
 b=ZtvEjGa8LclVBHZIx9xtUhqfrYW6MQntgrNdiJ943VS1JzppMfjpg2ksi8UbUYf4XfiC
 sVup2c26F5RoNEvebhagt3chFWKIadXKWi1hfcmGz1NGAEzD/7dQAZ+NY4kauGWj/jjS
 j7GD5/65NJYqNvTBwn7m2+wyYnbssjLim8iRcxp8rIjguW2J8iNACH2usfqLaPbxc6vA
 tSORbUiPhhiYOneWh0u4/M/DnokNwu4CevUEUaa7FejDkLFt5zL8WLsYc96eeoH7PV/y
 vG2McsctszMU2Oj8W3hpm7zjZLTxTdYoH7D1+3IqEb0A1n7O+c/gA6RzpR8DiqK8yxYp vg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jssrwkjc5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:26 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28SM1cea039455;
        Thu, 29 Sep 2022 02:54:25 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jtprvtcqb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LJUrwnjf6WI3MuBQ8MewZnp4MQNhVcd5Zvc5d/l3lcJdg84m3rjJSgsSfX8YBR/qUAakl2tLG8Px3UeIlS1A32SlRiVQFUF8914UeLDRNVESWi2LjvK1IgXh/s9xG+aO5foG/WeIwcRxU9+UUf5iA+ker/w50SUb5MgcuCCYWxRNVvpocjSapRLxxQzg/u8jLfOY5HOFBh7sL3qhf+fVUl3tGl4ay9HJBYleQFNJsLC94v9LdEj090e9SxECoddR7NBEar+Y2a8HUNiDTuEwuNT2r1ayD5aqAKM/7riyQTRPkygWW379bxHJFubP2ZkVJ/fuuoil3pJGYufapjUKgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3DhM9dTGQqYXWyJVPvxTY9dcyDBALZa4fcaFtTpuoos=;
 b=QwLdYEAMr1EGqtCVZEMsTSC+Q7CO7PpFH7XGD1NK6QU5kGEmhha+DiXSfZSt/UlhF2lahXKs7e219Zvax1tbGpISivTm7L+CczCBTBuR14qn7+cAcVBSK9J0fakHQ2ZzeU/G6kXeQiJFuh0assH3dLlh+I9jte8qsY0sfDQqFQmfZar6kf54qEnd2IIHuwCCr6tZCzxKQmFd20BT4RvGAOZoixzPY6ci6Sgjct/8TEQwwqbtau7j32z66QN+NOxqL5+adXC8i6Mp0Rxf4txF63kH2IyG1JVIAcZDlH2n6eQ90L+pMJHpt5HHjNyoOPL9PyPcp+kmbCDNhYvhP2DfvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3DhM9dTGQqYXWyJVPvxTY9dcyDBALZa4fcaFtTpuoos=;
 b=xjo69cGU5NN6O2QZxAt34KarZLgxDuTym8WCNUNBi2ZiTze1gKf3cdc3VggS+laD7pNaSm7Aj4m2d9dGW1DiCRMaUZdbO/V1YPnFTVdL1mx5KTCj8UFTHNdNx9vfk/mJiCcJ7snGAlgzIphG7uDuvzE+2OIy1gAe4XGJbQSEdEg=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN4PR10MB5653.namprd10.prod.outlook.com (2603:10b6:806:20c::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.19; Thu, 29 Sep 2022 02:54:18 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%8]) with mapi id 15.20.5654.025; Thu, 29 Sep 2022
 02:54:18 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 04/35] scsi: Add scsi_failure field to scsi_exec_args
Date:   Wed, 28 Sep 2022 21:53:36 -0500
Message-Id: <20220929025407.119804-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929025407.119804-1-michael.christie@oracle.com>
References: <20220929025407.119804-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR20CA0011.namprd20.prod.outlook.com
 (2603:10b6:610:58::21) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SN4PR10MB5653:EE_
X-MS-Office365-Filtering-Correlation-Id: b8a3c58c-397c-47d2-02de-08daa1c5e708
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BeZq4rdcdMyy3Beec4Way9oe5gHQ4A3e5O0aDiH1cbeQaKdUsmeRFH4JzhR/Gp4E4+gIDX5Vyet1P7UOO3bTNK2BXJidQHCILfX6D+6RIhn1vamaY/xm8A9ji6JE/cfj/amV2xDmkv0St/XU4npLlvTBxTikyYljUJU5Lrg874AnxEWbZz4ewCETKBVd89weh3uksV6bXHNyTUuoJUGPLhstGmDg9MjagoaNuM1zYWzKBhwrW2Ps/dt2lEeCEm0vgNA+yPDUo+5XIn4Cbk2w3gAWB4vBmsJxy7xgrFDjZKQ/Q7xxpa8S0acmyOv9J7sqZlEoUzb7PPpnlgRVEiPKtCPqTGtHTBqs+th2gI/BZ0VUAbMRRCgZMiTfJ7PrWaffM1Xb9xcNCeCDcxokTlOJppxUy3Iygk4GmnsVPh57c2EzMys93Pe+eUldIONd0emYn3FkVqiicEPHR8vOfx6ZmUCuvC5/nfDeekZRe22JfIItOfxqfU3zTtwyuWgIhoKVTmyqrSS8bOlkg4viEGcDwtq1RmvoVCux322tHK3do5Fp8c9c4o0/A6ceO1IkinghjYqmrKXJPmnfe3l4flNmoPHd+jV0Pz6ozQXWbdovFVgQPTvz7DuFOmTme74Tpv8XcIUAmFO8qKYHS+JigITGFWmj8KgC2xBVhQLUxGISXKiFXX6fYiUE0Q3KKESnlJVP4yZuLp6STkZ+qXSKH3GcWg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(376002)(136003)(346002)(451199015)(66476007)(26005)(6512007)(1076003)(186003)(2616005)(36756003)(478600001)(6506007)(38100700002)(316002)(83380400001)(2906002)(6486002)(6666004)(107886003)(8936002)(5660300002)(66556008)(4326008)(8676002)(66946007)(41300700001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TXS7QDrTcqJ83U0vVgHKvXb/qDbstdMym54PCQyEZYqI3KSyelxxk2qmr6fD?=
 =?us-ascii?Q?FsiuozjhnG/4xYVOlZaHDSymBOQbx1a6VpNwmzrpv5KdOBBliUnhlt5XxWBU?=
 =?us-ascii?Q?yHXZ/TY/85c17f/60RuIsrdijLwo7oTeHl8dX8E4Qp/bVg3DCLkIKlCXYyXe?=
 =?us-ascii?Q?dwcVGu4H1kNVaGM6kDMrQOC7Hy/wC93QEtj6WFc4FCazsOiwCWRUMCh6gRFj?=
 =?us-ascii?Q?4D8if3XjFolauqREiQ6y8y3shHqFITdlrYWRaNIFWey/L/PSHjsD7VACmZ3S?=
 =?us-ascii?Q?i48D4gPe9CXvMYHrvVAVw/ISUaQ9tpkZ6dTkCh/q2xmy18cZQ3GRNk3/KQNd?=
 =?us-ascii?Q?hFVA/OPbRRWxgiwG0jkVBL6xLN36IHUIsaq8PqBZQOC2ZcmmJNPxfWGQZWoO?=
 =?us-ascii?Q?QpVRieikLLaieGKU0UwfaPa8VOYUvyNBFvP49ciNycFVqVeigS0YqaA6PMd+?=
 =?us-ascii?Q?WD/WzHpu+bgCMN4sl1qNIWlUgrYZTQ/PUwWYkZxEzhrpr0V6Uex/oqV/gkbV?=
 =?us-ascii?Q?MIqIjJy3SrpokzMXj4UAXz50ugqqZ9VqbwzgcwLwjGC+ZlyRmxCk9TlKq+Mj?=
 =?us-ascii?Q?a3Y53w7mw0CRtM1Ibo5dBAd0/yGakcelMheKfyjSZvW+JGv0sGzjS2BvnMzW?=
 =?us-ascii?Q?aNqk0WuIjAUpHkWNN3jGrupOuRUMMVvAPy3XxS0o9wZVSkXkYvuc3+6CTI++?=
 =?us-ascii?Q?vbycSUwqWIvFwxsbUPv9DmySg+ogo4PPIUXTWaDEHBkAogJpaGRbrN6t/66/?=
 =?us-ascii?Q?6crSXPQwARGLzmOQieZBRkZpOWpDUgCMV9AsGdNydcHslscdBskbYGMxCXNI?=
 =?us-ascii?Q?jrwWh7EeNnC2whCnYG5azU3XCSp2gGMtakdQAf234Wspp7fO9/AneKc52N17?=
 =?us-ascii?Q?tEbiqDJr2EewfDF5ArUoEUT2OvjraaO+b3xYSWgxYn2owvmLirXDtwIv/GSI?=
 =?us-ascii?Q?mRemcGIFgUjHio6qRfYh4DiBE7P5n2snwjOJoK+NKDfWe2QThOkzo0efjNld?=
 =?us-ascii?Q?fWl5Bk7nZCC2/zVPh1egCjAFYDOdtQJjMlXEEnKBK0McecNGKz41YHAocGOA?=
 =?us-ascii?Q?hOC7JZZlFnycW4YAql9J2I6OPHgm+DiUrrzmj+FtmqjtsviM91bomWvTTmjB?=
 =?us-ascii?Q?qDjelHdkqTofo+W46/qbYjqypVuElAlHzgfnryH/v4J9LW8TyNmfvxq7w7yq?=
 =?us-ascii?Q?ltUSK425aynDubk5B0zakhq8lPeZ9egh9eW9qAYzw3UfKBkxgkBlmWHNH876?=
 =?us-ascii?Q?VvNRuD1SkkRB3n5/Bn0rTf7QfXA6Grnth2afY03TWpYyLauu9bkUfC2rB5+L?=
 =?us-ascii?Q?b3UVbKzfwSYWyEnst70BwWE0y0lBKOMOWlrMofBkTv/TAaprSRhSmXLrBKQi?=
 =?us-ascii?Q?PeRqO0wdKeGLQMevMXjJFf7Gbb0kHhflFWrgubuNGErFlmd+uzlPO36wQQlM?=
 =?us-ascii?Q?Q1Xwgz6brDyoGgcSwrE5vkSd6Pd1006VHK1NPTYP+nQ6c2BCvmPD1AlTqbCN?=
 =?us-ascii?Q?qlzguSUn/7qQbxxZCwfm5M/J2sRkQTern4YQx13gqQt8GibdYY4ySphHwHtN?=
 =?us-ascii?Q?PBlve3t8vr2jf/alf5UpSZggln2/528oGPuG/mAia0B2anuTSKmaYuW3ZSj5?=
 =?us-ascii?Q?Iw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8a3c58c-397c-47d2-02de-08daa1c5e708
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 02:54:18.4131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L6YueR2vGlZMqwEBm42OlaHQxUwBElERQnzXLZK0Ux3OlPyKG4tNwPMOsiels/38b9HhrojFWMLkRYfvzvptGdesw2pnAYuy5+chmEQlbmk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5653
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_02,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209290017
X-Proofpoint-ORIG-GUID: HrLz64eZLqyJ9oejoUT-yOf847wWotC2
X-Proofpoint-GUID: HrLz64eZLqyJ9oejoUT-yOf847wWotC2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Allow SCSI execution callers to pass in a list of failures they want
retried.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_lib.c    | 1 +
 include/scsi/scsi_device.h | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 18cdcefc7f47..e1c19fea24e0 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -215,6 +215,7 @@ int __scsi_exec_req(struct scsi_exec_args *args)
 	scmd->cmd_len = COMMAND_SIZE(args->cmd[0]);
 	memcpy(scmd->cmnd, args->cmd, scmd->cmd_len);
 	scmd->allowed = args->retries;
+	scmd->failures = args->failures;
 	req->timeout = args->timeout;
 	req->cmd_flags |= args->op_flags;
 	req->rq_flags |= args->req_flags | RQF_QUIET;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 44e5986b8ab0..d623d3e62f92 100644
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
 
 extern int __scsi_exec_req(struct scsi_exec_args *args);
-- 
2.25.1

