Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29635C54EE9
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 02:57:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234478AbiI2C5G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 22:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234804AbiI2C5B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 22:57:01 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 435E111E5C0
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 19:56:59 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28T1TdN1004390;
        Thu, 29 Sep 2022 02:54:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=7UEhgmPMM4/dM4UDOsWLEokaOnanBShzcSYryCcvwxs=;
 b=vZ1uwDCJo+DA5r1+V1Y6TVEoKjDznDbZALxB5xVtJmvnC5jiHgtvniOS5BiQaHvA4USP
 CddujzQQQ7jbeilM0b4zkXoZwchMW8RxsmuEkJn/xq0hLEsnsB1Yc2MZC7MrPxPEGgwz
 79EUodbzFMuzN+CdFbvSi4H56jAWKTULAQGwqbivSErEpj78tGcw9oJnVu+a4cvaoS1f
 iUsauZyWzRl2Z4EI13j6L5hg+//Hw8DVJ+kgDjqim5eCmZtJMK8Tw5EtL/2NDEl1bJ4m
 G5J0EOwMhPQbKYXNEc3AFVQLapaabawlgU+qalQ1/qPK7PUaar89SOnciyt6hUGGjlxS GQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jssubkhj2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:45 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28T2Z5O4040238;
        Thu, 29 Sep 2022 02:54:43 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jtpubbpfh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kjz9hcJ8+WgzlILJ6x9kupe1jpWWnRNKH+vs7OLmdZ/KKqH2wgyjmDM56Bpn41a1NCGh7nHlUlV0viL+WNJD1fEHS8IfqaaCRjTNS5bmwjGLcFC5ZQcSzzqcBAPIMkQt899rSZv+kQGdnlxLbULhf7Aaf+FwgNrk8AMz7gmskSnL3c5qmP/rpRXX7JWWcoS6Zz7NiEvPWYyMsEbuFmZIvIJZuR7ItFUH7fUzfnrgOBcJ1+nYXspkSa8qhT59jawoO+Ws1x67pbfPZyvKAzlAlHtVnUvhrbiajRcWLRhUl5S1cvkTqyaCLhzBAf07GYZ0E9PFaPAavt7HcjPDa2QcOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7UEhgmPMM4/dM4UDOsWLEokaOnanBShzcSYryCcvwxs=;
 b=VO56jmHcJvaChoDJ/cCOjV1ZwZinpLNNJrw3zxPulbyxys+0vx5aVRuU7EzmxWBbPwA8tkH7w+caYwcGmoyz6807aY94BhyGuX5kq4Qn4WGB2lYN8dMUVH6QNgPSjnfx65GMJelz7omuazucbdPCfta/BsTPrjg9io2tdPjaZINqWcnjyfSaUC9NfH7kHgRk72l8boBlKP0C5TtSAXBIdDczc32EW0qngMTGlufJkhihr2WuGheuiLlW2A1V5vYtFpdJDA/T99bM30b5sUkpo5xeaWmHwbDm8TMnVvG7fXnN3iaWBBpcKF0qylS0pfBjQVYcMB2YNWsTUUkTH7stXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7UEhgmPMM4/dM4UDOsWLEokaOnanBShzcSYryCcvwxs=;
 b=F+Vgs01aIeklyeZUQNw0Dg8eG+rqV6F9tNguwP/UVhsI6Njp2HsafvrVyEu0WFmig18z0+Hc3DggFeC+igteRNnpLBgLzIGikVC7SZntDtV4XEzWD8UGUf5T1ETSNtXlOTe7C2BZ65YI9lGyYMEgvM/pLW8yDiLSGdFzGS74awY=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN4PR10MB5653.namprd10.prod.outlook.com (2603:10b6:806:20c::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.19; Thu, 29 Sep 2022 02:54:41 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%8]) with mapi id 15.20.5654.025; Thu, 29 Sep 2022
 02:54:41 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 19/35] scsi: Remove scsi_execute functions
Date:   Wed, 28 Sep 2022 21:53:51 -0500
Message-Id: <20220929025407.119804-20-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929025407.119804-1-michael.christie@oracle.com>
References: <20220929025407.119804-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR08CA0001.namprd08.prod.outlook.com
 (2603:10b6:610:5a::11) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SN4PR10MB5653:EE_
X-MS-Office365-Filtering-Correlation-Id: 5841adfd-956a-4613-aabf-08daa1c5f4d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jA1kBnE9VCDuPHQq4tQpiiUH+nn0hX7DabIBzL0bfWx8+XbhBFFKC56TT7ceSZEc4MwCYXNu2nCP4Y1cYCYXWWKOTRr2KgOyJRIQUicg5Pba15hoW5b4ngg4I7/qkjILJjhOawQ9o+7dGLXuyslY25aFsvWcRrT5u6FCSyvmoLL5BT9hhvK3ULeNIyCVdnQt1ZGfi1e38wWzbM3M93sMVdItSgpj2YIymWcuZHiSn2B3OBteZRIvSxr6xycirZCQIBMcGUklWDSwLGO3uOqtt4dle45+S2menqumduad+AYS/vNVuvQ7jumNVbA7ZcuSZl15aaReEJFTle7492el6dJlv041R1eLnX6VjXo+oYVP9pwT3Mz+/pu91qugHxSJhjc6ZTwbbgYQEpU7blX5MsipE1UO645NIJoTPnMrwSS35yVzP9EQfzqHMgoTJi5unN7Bzcpy2+WW8KQrisJ0RF3s1QDvtDscXfVjefxdE5bvejnENm6DD5neCYCWL+75uTgNJhISfLmcVigdh/WZqxRG5qxegKyswNy5+gXbDbO4L2InEjQuKsUMF3sYCWNTnI00sYDAv0k24A3W99CVjaVhpi0q9/KQnBt8OhyzOYcGKhqh/zUW+jGhPCGjT2qUlALzH68OwoOb+NeSiHZYHHVB2WBa01gVUHf7Is9B++7cDXkJ4fD2Tizywmd00k7hHMIfv70DgG+gJCyk41JPOA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(376002)(136003)(346002)(451199015)(66476007)(26005)(6512007)(1076003)(186003)(2616005)(36756003)(478600001)(6506007)(38100700002)(316002)(83380400001)(2906002)(6486002)(6666004)(107886003)(8936002)(5660300002)(66556008)(4326008)(8676002)(66946007)(41300700001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N5YGnehOjFdpOQUjZ16rZcME7CDUccjyTwvnpKXX8889ghlXTWuOJwQL1ELg?=
 =?us-ascii?Q?jd7KCoR8gF6QV9LPN/BPBe7hqMrF/2lq+8ieVFuCtzXiLShNKKP4mHb9a4co?=
 =?us-ascii?Q?oFNmXyNidWIpIgxmG8rf+MpELNnOEuYYEFbt6YiOxBZT9cZWHvVbMQfMvjs+?=
 =?us-ascii?Q?EyiygyE48C+vGlvu9flsWkf2YXFvBJTWe6MsquM+h+5cypGg5b6TtNca1ip0?=
 =?us-ascii?Q?1GcjHQUu5QowUgIjE+28Pwgw42SX4UPag3UJ/OPYzQkmQaU6UFohY/Y0duEn?=
 =?us-ascii?Q?3RI4Ty1gJLkKI5DLO6EEM7OTH9GCdZthEPd2MDKxVu1FwMBweF46Nv/3MYXQ?=
 =?us-ascii?Q?b0YjnLvVj+6D9pXBCXJJ8sp/EHp8JSFu4WRhGDPi4CHHJqyqLx73rYUon1aF?=
 =?us-ascii?Q?3B26727sdjsXRyGOGpALaQPeSH1O2YOYluHiA0zSWPJAbUunttAMN8S9JhLw?=
 =?us-ascii?Q?jNj3BahMw4+Hs6fTkBYYYkVZh0zvRnQvqP2FYiSCEpxatNl65/2MjBBbkNgG?=
 =?us-ascii?Q?ebZGcbuypn95wjZ/hvgI05YHCAy2cAz+vcPncrEOwCdvPuiAsTaAAuec5CZW?=
 =?us-ascii?Q?J9H1XjrfnNxwUOoVBn/2DTJLXG+5VXvXpDc5eFKpEDNZxmr+KO1dTy+KtZxQ?=
 =?us-ascii?Q?SW+tWXTYNz+wHSH+nu0YfpTOLEWBYDq50kkWUIIgXelA9wCvTsp1XbAZ13wp?=
 =?us-ascii?Q?rHn3cOO6VyHB73/igZ6rMDOYbujGhrX9G5Sdd025ys6qZmkWatLaoL7OZkpm?=
 =?us-ascii?Q?4+nXeZIeu6SpCoM9KE1VuoGyaG4SVgEbUuIflmY5Fd5w9BY416hgJU3OGEql?=
 =?us-ascii?Q?0qV0l0Eo7wlmyNan4srwK3XV498dNfjDmb84QM+BS+ZulHvQxpmNfLVnj41t?=
 =?us-ascii?Q?K5rdLXMk/QE2n2jOEXYLYrMwOQ36wF+GxsCjBbc3xpAgtsPRmRC/nJO/djy1?=
 =?us-ascii?Q?58Rsxsblct1j8zje70tw4c84MB1GqHJvqhR6T67M80GodXubPiaIwPJb8xbP?=
 =?us-ascii?Q?ZZNuDgs2b/DkEhTIpI5iSC0g/gqw7JyIxrv9knWFAC1byfrR32KLAe6zK/ei?=
 =?us-ascii?Q?n/uiFqqzO0PRJcWKHMKWJC0u8y9Siiv0sZyxcrGSoeQ6LpsOiwcsK6IPsGAo?=
 =?us-ascii?Q?u5Ugfqo+y9O+ZIi2oVZGbryhXOQ2i5NDN6Vr574LTw9CMgQmktUMIxQJxEZl?=
 =?us-ascii?Q?bWNnkOiD4ysj+nqEPmmkxqh7kOhb/iryjZFwXAg/WnDrq2CpkYUZg65m/THh?=
 =?us-ascii?Q?DaNCwCnvu5bx7HAMD2YPtW9Vml8GyoklRkZdA1jH2BNa6+2+CnlP1KM8eJY1?=
 =?us-ascii?Q?uppZa8UY1IffOWWRCHIe2MCctYmKBOrv+NYhnkZmW3UIYRYgrFtYkLwrAALI?=
 =?us-ascii?Q?NOnsmvhigzG4F8Yihn6SPlHdClcBrvcpkhKrcYgtOjD7E/6FVrjjIMkTA3vE?=
 =?us-ascii?Q?RB0FajBvOinIy0zrCZG1XRorClEGHd+2xMdB8q6++xLXcYmmpt/NU8WaZ027?=
 =?us-ascii?Q?YNbbkhal59YaeQhEKmfkVhnVMM4ftAgzXFH1AA9vCyCLm9YPJE8FeR9glDp2?=
 =?us-ascii?Q?AWW8mUQS8AoVCIozSYcd5UjoXugVqU5Dh44N00mefmO41DVu6tBOGAai4GoF?=
 =?us-ascii?Q?aQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5841adfd-956a-4613-aabf-08daa1c5f4d2
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 02:54:41.5673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qGLIPtsh5o5epGOaiWCR55hSuLKLEzPB6PsZHZuV/bg6RYB+IVj0idWDnPMVSnyUXHxl5Am0KR4L3wUu6XDeUCOkcgl0ZVOzNQu7eYVOEa8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5653
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_02,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 suspectscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209290017
X-Proofpoint-GUID: drfvJDdvqt-AG8cGjoSA9q8prSl5X9tF
X-Proofpoint-ORIG-GUID: drfvJDdvqt-AG8cGjoSA9q8prSl5X9tF
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is no longer used so remove them.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 include/scsi/scsi_device.h | 39 --------------------------------------
 1 file changed, 39 deletions(-)

diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index d623d3e62f92..77bbd311ba34 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -481,45 +481,6 @@ extern int __scsi_exec_req(struct scsi_exec_args *args);
 		     _args.sense_len != SCSI_SENSE_BUFFERSIZE);		\
 	__scsi_exec_req(&_args);					\
 })
-
-/* Make sure any sense buffer is the correct size. */
-#define scsi_execute(_sdev, _cmd, _data_dir, _buffer, _bufflen, _sense,	\
-		     _sshdr, _timeout, _retries, _flags, _rq_flags,	\
-		     _resid)						\
-({									\
-	BUILD_BUG_ON((_sense) != NULL &&				\
-		     sizeof(_sense) != SCSI_SENSE_BUFFERSIZE);		\
-	__scsi_exec_req(&((struct scsi_exec_args) {			\
-				.sdev = _sdev,				\
-				.cmd = _cmd,				\
-				.data_dir = _data_dir,			\
-				.buf = _buffer,				\
-				.buf_len = _bufflen,			\
-				.sense = _sense,			\
-				.sshdr = _sshdr,			\
-				.timeout = _timeout,			\
-				.retries = _retries,			\
-				.op_flags = _flags,			\
-				.req_flags = _rq_flags,			\
-				.resid = _resid, }));			\
-})
-
-static inline int scsi_execute_req(struct scsi_device *sdev,
-	const unsigned char *cmd, int data_direction, void *buffer,
-	unsigned bufflen, struct scsi_sense_hdr *sshdr, int timeout,
-	int retries, int *resid)
-{
-	return __scsi_exec_req(&(struct scsi_exec_args) {
-					.sdev = sdev,
-					.cmd = cmd,
-					.data_dir = data_direction,
-					.buf = buffer,
-					.buf_len = bufflen,
-					.sshdr = sshdr,
-					.timeout = timeout,
-					.retries = retries,
-					.resid = resid });
-}
 extern void sdev_disable_disk_events(struct scsi_device *sdev);
 extern void sdev_enable_disk_events(struct scsi_device *sdev);
 extern int scsi_vpd_lun_id(struct scsi_device *, char *, size_t);
-- 
2.25.1

