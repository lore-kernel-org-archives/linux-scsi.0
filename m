Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73573C63703
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Dec 2022 03:10:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbiLHDKQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Dec 2022 22:10:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiLHDKP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Dec 2022 22:10:15 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03BAE7616E;
        Wed,  7 Dec 2022 19:10:12 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B7NO0vA016777;
        Thu, 8 Dec 2022 03:10:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=Aj8bW69fJwO/TjDmSHtW/CEHCu9iXHXjBGHhUvzFZR8=;
 b=ylpU0M4WAj6uX6QHdAmemJ6gyIPAw2S+rvvVYIzYaD+nMdXXUGrfBe1LOZ2AYczAonRv
 Pym0elLFJdvx/Qc/twuYO9/4SwpavdYlaJFV+AdSMSlbXqNvmxeUFvlC6/fBTY9nUMdY
 U3WqDysDDdIezyOi4sZG5WRVOYnBAayJmt5hMxlRjPcivZkNTzKe/VU6aP0PAZ4y6ge7
 W9T57BBttjy9MU7h8bWR98oYv32oqdsDn4s2vFr6TenMbhcC831aDa25AGufeBrqV4E2
 ELQoKm371pjKjCRrP1KmXOnGbvy7oULlT0IRqB/Mkkb7Ks5JtuYaYirrWSwHy8Kj9kG2 qg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3maujkht40-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Dec 2022 03:10:10 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B81ulYY009791;
        Thu, 8 Dec 2022 03:10:10 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3maa6a37hk-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Dec 2022 03:10:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S88sFgNdJPtjRGf+96A+bX1voc+B7mdqEIMhd+u6Ajxq7NG+LfCLF65Rwwy5yULRgNUG5Xl08R8+YZkn5eA+ZlmrthSpOSgXSaIvOy+X3scEQS8baljliap/ZUEkGiYRybF1CoLVGxqwaNIlRmRIdWFGozxqafrqmEPlo1mU2H/PJ92s5UV7ce0UzPu9cw87BXUpn0H3WuaXk9/RmedcVCqKLSYaSvZwwKhma+LLwQSJ2k9yjnpUU2zX/84ZQ0ecRNQ5dEhYci77mI3IrOTujudw+D/NbTT+6eRHc4CuH2HQRu5hvDJuaXL2HUMcOsWIPebZB8aq/n+bIRb2IcV1Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Aj8bW69fJwO/TjDmSHtW/CEHCu9iXHXjBGHhUvzFZR8=;
 b=iYZm4dQAXEbOPbCdsysypfgLSJg2yHXOV/vuT/Q6If0zbaP0vwCMfIeWTl/Q6m0IVLS3UgsLeL194sS6el0iI8GV+nVn6+cBb8TXEkSHAZVR23k1Z5RKHRS/ie5yLhlT1CFZeOfXkThO4Bt5hZN3lkrLp4KWrbQahtW6keCoEDaFPZNZUEqR6WC9GHs5t29SBYhhdwN+y63NdU0QN6TdqF/NiOdoSV0GcmMChS0ADiL80DVRp9W5FdDy/R5XrNcjfLi9Q1oRXW+AhwvUSYgtyR/Tjr1SOOeb3HJQ3Mrwx3Y9vLlYRmtprHoEretj3CTW/XHev6w2VtqDL3h4Wfr8Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aj8bW69fJwO/TjDmSHtW/CEHCu9iXHXjBGHhUvzFZR8=;
 b=0J7cTejURWO0ON1wfPD6GR/3OtmtPcAbgUfwKmSfYCVL+R3qc+Q/UFnRdwexnCJ9BOE8VHpbj+m5HGcsGLZCh3mr5Ih1Ji3KTY9N3NdeiJnaVDVTZxr7q4j8fHyyaNL/VP6fsTHf+l709yBAcNoZ5kD1zz5B4739kgjgiUzQGqA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB5132.namprd10.prod.outlook.com (2603:10b6:610:c2::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.14; Thu, 8 Dec 2022 03:10:08 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::2dbb:4791:5a67:4372]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::2dbb:4791:5a67:4372%7]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 03:10:08 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 2/7] scsi: target: Move cmd counter allocation
Date:   Wed,  7 Dec 2022 21:09:57 -0600
Message-Id: <20221208031002.106700-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221208031002.106700-1-michael.christie@oracle.com>
References: <20221208031002.106700-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR04CA0113.namprd04.prod.outlook.com
 (2603:10b6:610:75::28) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CH0PR10MB5132:EE_
X-MS-Office365-Filtering-Correlation-Id: 7658c11c-e96e-4bcb-4e62-08dad8c9b64d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +7wAmDpxHoeiR2fwGiRVXhx1VSYELaqVhcFctMlG3wg5oeWVi3H9wCeXDzJYtpNKcHjdD1MZgo5MiK9wo9bKP/qfxxEo4e4+sUFYDPj/+B6+A8PpVIIoRi+lqlXTbTmaNw/ryztxdI62wvqmNYK3MEmZMFHNcYdAo0wrT1euC2J9LXoih5T4rDVczejhb8Dr8E1q4zl/FZLEVU9k56aZhCge+7ODtp5bIln0CG6X7cz3rxFit6yWJXKDWceVxSFTpUQ/meCeuZXJDmMWXRGq3AdSUZ9yWKYr3TWCIyHTYSWsG+0+HjMZ7TyAXmItrEUWc6tJPPOv8IdThOXvI2R9dJOdGPwXq2+XyBt9YIjccKOqxOQwtAUZ3RH9FMqwHhak9zbQOZFBmaBqMs0ZH7MscKPHnuIHe8b6PY08adCMx4s4CuGndJ0R+sb8FWfSSHsZZPA3RxVfYkvLAMUv4eBwoKagga8dX6MMGk8hIiyNwik1+nlQYT93kTt+UVKvNiQUzcUsXzCNWn3cQYYH8lWW+DsNCHfRSGp/mE3RPx9+hNBY8PLY01CCYSvd1+bHKRX0dTQMi8zeD3P+kUavW7EdaypZ4ibHF8LD4SqxERZxYaHVUkZphNrMaDVjE/p8DudYf6kiw4S3IBNB+UI06KDfCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(136003)(396003)(376002)(39860400002)(451199015)(38100700002)(8676002)(86362001)(83380400001)(66946007)(4326008)(41300700001)(2906002)(8936002)(66556008)(66476007)(6506007)(478600001)(6512007)(26005)(107886003)(6666004)(186003)(2616005)(316002)(1076003)(6486002)(5660300002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YrbWlSZaLeGsnobLIgVGyHryBrWCU9kgH+zSnd6RGwjOwaQX9K/4EsREXfxs?=
 =?us-ascii?Q?7zIV3qSdTlYbkQM2kLMry6PMbmrv40Bbeb4yina71WamK/LoKqS+hInRQJ5B?=
 =?us-ascii?Q?2cmCuvA/QOxY2ecg0iLziOpLu5Fo+TuSavCbE4qKM1rXTLzG1Uus4T1bYL9D?=
 =?us-ascii?Q?OIOoCyQxcdLpmoCa5t9S0qmwkrw6Zdd0NepHNlCpdpqaiQDYiS2Kgo0tKKlt?=
 =?us-ascii?Q?qhnS18JzcPfGAWn8o0mbnzJNRylx5z3yzznxa0ASaCsE6q2QO137iSkJpwi9?=
 =?us-ascii?Q?3/xExGhdGvfr6DOTaZNMCyYkOJjpxETSx+oN6KEE/DtlCYLV1+IGMToa7S7r?=
 =?us-ascii?Q?aUBzRhsWyjL2bkhwfhzqynPwvSRBnUOPwafn857VtpndT2j/xFFNZ8robzBx?=
 =?us-ascii?Q?C7viI2sB3BACYwCxfHBjsjX7tDhEdPpDiAR7xHbfNc52BLpfC3ZmuP8qyJFN?=
 =?us-ascii?Q?4+AxHTkwe13WnPZ87hV2yRXbiIHB9W99XhCUuwYALvcOtDWgR57Kkpeo+/8u?=
 =?us-ascii?Q?9Q1CJPCIOwZj8zstu+zNYUoo8J907+TCmMxKw6G6Vdrsgqf8IRmG3Smb6bt9?=
 =?us-ascii?Q?pEAf0M1IjxdjzECFF1a/a7FTn8gtAyX805PIvvv9+xLEEggVk1Wc5Vkjht38?=
 =?us-ascii?Q?orTDNdQmKLTPZbEDznb8d8G7IoIufN9klDWuXXxDGkz+kLsNw4/2564ucjIi?=
 =?us-ascii?Q?YGBlgn9SFltS3pvKf0DYjjGFKOrd44Y9jiBgknD592tO7lwn5EWMzkITM+Bb?=
 =?us-ascii?Q?SrHQ9z16KtAOVpGBA0/RYGIuSYdlzSxaRXIp8s14MKLf6yp8LNXPC6TiLXVl?=
 =?us-ascii?Q?LCpkXUMVScG2N2Z/N34za5sUxsMdq89Qj+LL47PJ5DVZE9NXXGhsspkwR2I8?=
 =?us-ascii?Q?RSD30SJe54J4VL0oxy/QXlOzgpxOd4lJuN/pGOJ5IGVvuZS/QUoGm7VSdX96?=
 =?us-ascii?Q?G8dczY8PyHi00ERqQEpyh6YA3E8SjzrOWHx3e7Pd2FVOqmpyIUDd+rdAYldZ?=
 =?us-ascii?Q?dRTkIo1l+Ex9e8Zvq2H7mIOqqj9HOWnfIWvADzdh8+YoNxSmBINSMAzFz0ar?=
 =?us-ascii?Q?5WSpaPtgP8cqYPG28dF/pqEQvWBBrMHRgyN7vVmleXE14TlDQ03420RWE7ai?=
 =?us-ascii?Q?RyHGrKc4YfFSywJ9vHZI2msERvkzYPzoBA29jO9IxI2HMlFpSy34Iq9ZZZpP?=
 =?us-ascii?Q?p0qQFRcTsV5cAc+ZLFRESCugB3V7A3KNMRkLZ/M4sc6gZ/NMtwGP7QBM14XC?=
 =?us-ascii?Q?XR0A2JLwal5wg5llk8+2wCdiAMW7fsgFxS3kZcr4yVSLUIm+sOnVBbNvD5FX?=
 =?us-ascii?Q?vY1jEixHhUU0YvHjpzg/ziEZ4P30C/GGXedzCf/EINvF646ZAmupE1nM1TfM?=
 =?us-ascii?Q?DWFwFuA7zBiKx3G9XlyaCSfPx0FPiwMHJVe7xnBoQrkpz89nzld3pCPneTbT?=
 =?us-ascii?Q?7msXGOIEASFGrh9vGXMZjyzew+/L4RHj3SF97V80HJalp6tH1r1kLbPZTB6M?=
 =?us-ascii?Q?1ykdvWrMRrKzj+yQqYAQ7TuK1md0WuSAWYYmMqHQG5TJWbcLVGuVYd4d2Crx?=
 =?us-ascii?Q?Fidx+/GOpLsq/IVi8gNdWu9j+ITTP3wr/5xQiXwGA6UXsCk3JYjya45uyeo8?=
 =?us-ascii?Q?jA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7658c11c-e96e-4bcb-4e62-08dad8c9b64d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 03:10:08.6298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uAwr3zSP20qpWPKwyXw4x0e93MJ0F5P6yQgoxkBul3lJ73lxpECOIOPlXQ4lkaIMUSLTSIgiIy7FMNBebfjKVZXzMO167/Fc/VFAMGxw4jU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5132
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-07_11,2022-12-07_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212080024
X-Proofpoint-ORIG-GUID: HlCWW4Jofqq11ZCZB-IgJnYNio11U_Je
X-Proofpoint-GUID: HlCWW4Jofqq11ZCZB-IgJnYNio11U_Je
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

iSCSI needs to allocate its cmd counter per connection for MCS support
where we need to stop and wait on commands running on a connection instead
of per session. This moves the cmd counter allocation to
target_setup_session which is used by drivers that need the stop+wait
behavior per session.

xcopy doesn't need stop+wait at all, so we will be ok moving the cmd
counter allocation outside of transport_init_session.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_internal.h  |  1 -
 drivers/target/target_core_transport.c | 49 ++++++++++++--------------
 drivers/target/target_core_xcopy.c     | 15 ++------
 include/target/target_core_fabric.h    |  2 +-
 4 files changed, 26 insertions(+), 41 deletions(-)

diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 30fcf69e1a1d..23e5d7847a1a 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -137,7 +137,6 @@ int	init_se_kmem_caches(void);
 void	release_se_kmem_caches(void);
 u32	scsi_get_new_index(scsi_index_t);
 void	transport_subsystem_check_init(void);
-void	transport_uninit_session(struct se_session *);
 unsigned char *transport_dump_cmd_direction(struct se_cmd *);
 void	transport_dump_dev_state(struct se_device *, char *, int *);
 void	transport_dump_dev_info(struct se_device *, struct se_lun *,
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 60fbebe8c675..314e384f4ee6 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -271,24 +271,14 @@ static void target_free_cmd_counter(struct target_cmd_counter *cmd_cnt)
  *
  * The caller must have zero-initialized @se_sess before calling this function.
  */
-int transport_init_session(struct se_session *se_sess)
+void transport_init_session(struct se_session *se_sess)
 {
 	INIT_LIST_HEAD(&se_sess->sess_list);
 	INIT_LIST_HEAD(&se_sess->sess_acl_list);
 	spin_lock_init(&se_sess->sess_cmd_lock);
-	se_sess->cmd_cnt = target_alloc_cmd_counter();
-	if (!se_sess->cmd_cnt)
-		return -ENOMEM;
-
-	return  0;
 }
 EXPORT_SYMBOL(transport_init_session);
 
-void transport_uninit_session(struct se_session *se_sess)
-{
-	target_free_cmd_counter(se_sess->cmd_cnt);
-}
-
 /**
  * transport_alloc_session - allocate a session object and initialize it
  * @sup_prot_ops: bitmask that defines which T10-PI modes are supported.
@@ -296,7 +286,6 @@ void transport_uninit_session(struct se_session *se_sess)
 struct se_session *transport_alloc_session(enum target_prot_op sup_prot_ops)
 {
 	struct se_session *se_sess;
-	int ret;
 
 	se_sess = kmem_cache_zalloc(se_sess_cache, GFP_KERNEL);
 	if (!se_sess) {
@@ -304,11 +293,7 @@ struct se_session *transport_alloc_session(enum target_prot_op sup_prot_ops)
 				" se_sess_cache\n");
 		return ERR_PTR(-ENOMEM);
 	}
-	ret = transport_init_session(se_sess);
-	if (ret < 0) {
-		kmem_cache_free(se_sess_cache, se_sess);
-		return ERR_PTR(ret);
-	}
+	transport_init_session(se_sess);
 	se_sess->sup_prot_ops = sup_prot_ops;
 
 	return se_sess;
@@ -474,8 +459,13 @@ target_setup_session(struct se_portal_group *tpg,
 		     int (*callback)(struct se_portal_group *,
 				     struct se_session *, void *))
 {
+	struct target_cmd_counter *cmd_cnt;
 	struct se_session *sess;
+	int rc;
 
+	cmd_cnt = target_alloc_cmd_counter();
+	if (!cmd_cnt)
+		return ERR_PTR(-ENOMEM);
 	/*
 	 * If the fabric driver is using percpu-ida based pre allocation
 	 * of I/O descriptor tags, go ahead and perform that setup now..
@@ -485,29 +475,36 @@ target_setup_session(struct se_portal_group *tpg,
 	else
 		sess = transport_alloc_session(prot_op);
 
-	if (IS_ERR(sess))
-		return sess;
+	if (IS_ERR(sess)) {
+		rc = PTR_ERR(sess);
+		goto free_cnt;
+	}
+	sess->cmd_cnt = cmd_cnt;
 
 	sess->se_node_acl = core_tpg_check_initiator_node_acl(tpg,
 					(unsigned char *)initiatorname);
 	if (!sess->se_node_acl) {
-		transport_free_session(sess);
-		return ERR_PTR(-EACCES);
+		rc = -EACCES;
+		goto free_sess;
 	}
 	/*
 	 * Go ahead and perform any remaining fabric setup that is
 	 * required before transport_register_session().
 	 */
 	if (callback != NULL) {
-		int rc = callback(tpg, sess, private);
-		if (rc) {
-			transport_free_session(sess);
-			return ERR_PTR(rc);
-		}
+		rc = callback(tpg, sess, private);
+		if (rc)
+			goto free_sess;
 	}
 
 	transport_register_session(tpg, sess->se_node_acl, sess, private);
 	return sess;
+
+free_sess:
+	transport_free_session(sess);
+free_cnt:
+	target_free_cmd_counter(cmd_cnt);
+	return ERR_PTR(rc);
 }
 EXPORT_SYMBOL(target_setup_session);
 
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 49eaee022ef1..49a83500c8b7 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -461,8 +461,6 @@ static const struct target_core_fabric_ops xcopy_pt_tfo = {
 
 int target_xcopy_setup_pt(void)
 {
-	int ret;
-
 	xcopy_wq = alloc_workqueue("xcopy_wq", WQ_MEM_RECLAIM, 0);
 	if (!xcopy_wq) {
 		pr_err("Unable to allocate xcopy_wq\n");
@@ -479,9 +477,7 @@ int target_xcopy_setup_pt(void)
 	INIT_LIST_HEAD(&xcopy_pt_nacl.acl_list);
 	INIT_LIST_HEAD(&xcopy_pt_nacl.acl_sess_list);
 	memset(&xcopy_pt_sess, 0, sizeof(struct se_session));
-	ret = transport_init_session(&xcopy_pt_sess);
-	if (ret < 0)
-		goto destroy_wq;
+	transport_init_session(&xcopy_pt_sess);
 
 	xcopy_pt_nacl.se_tpg = &xcopy_pt_tpg;
 	xcopy_pt_nacl.nacl_sess = &xcopy_pt_sess;
@@ -490,19 +486,12 @@ int target_xcopy_setup_pt(void)
 	xcopy_pt_sess.se_node_acl = &xcopy_pt_nacl;
 
 	return 0;
-
-destroy_wq:
-	destroy_workqueue(xcopy_wq);
-	xcopy_wq = NULL;
-	return ret;
 }
 
 void target_xcopy_release_pt(void)
 {
-	if (xcopy_wq) {
+	if (xcopy_wq)
 		destroy_workqueue(xcopy_wq);
-		transport_uninit_session(&xcopy_pt_sess);
-	}
 }
 
 /*
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 38f0662476d1..ff2ff7703aa6 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -133,7 +133,7 @@ struct se_session *target_setup_session(struct se_portal_group *,
 				struct se_session *, void *));
 void target_remove_session(struct se_session *);
 
-int transport_init_session(struct se_session *se_sess);
+void transport_init_session(struct se_session *se_sess);
 struct se_session *transport_alloc_session(enum target_prot_op);
 int transport_alloc_session_tags(struct se_session *, unsigned int,
 		unsigned int);
-- 
2.25.1

