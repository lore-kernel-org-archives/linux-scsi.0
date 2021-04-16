Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01665C43461
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:05:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C21B861158
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:05:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238021AbhDPCFt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 22:05:49 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48538 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238052AbhDPCFi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 22:05:38 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G257TT099275;
        Fri, 16 Apr 2021 02:05:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=qCcK33geJ7TMTh6rP31FrGReBAGDdl8gbwQdLfmpQMk=;
 b=hEP5u6hsIW9itUolOqXBpoALGnk5mlH2uO7o8kTGOh6abUVDb2CgIs2PfU+qZUD9A5jT
 RflPuL11z11f0+kLFXNh2DgGpuUrw0ymhU/xoQpXqobk2qGfTq/KT0I33LDevfUK/+2t
 PujlHNIYz+a2LTNjTzK49e6ePHezKIq5GVZbn1jFg5JK0/Y8LxYK2fVhAr5ROvZxatNZ
 UhO1Q/A8Oj1ESZzVKZE2R32c8r1hbsqxoJOldm4u1738JLZv0o1pgbxq6ABDiID2Mc+W
 jgdORPS65BjBVSNeky1J/s2tCpKuVGFMoILsSkbw9YaXOhhRp1QUj86HDK3hNQb7LylL 8Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 37u3erqped-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:05:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G1xofN008598;
        Fri, 16 Apr 2021 02:05:06 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by aserp3020.oracle.com with ESMTP id 37unx3sp47-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:05:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ByaKmYs9Kab34T6m4BVv5/3WTC8yDSqYbntD0r7dyNeTec7xYj764u8EF23in10NKH1z5scRfYJmseCZ9iNDlKZDOx8vo3v5NBOFo6dpjtMVISKq+1wQJrpTs+Aj+yYela5NOLJeMKyaFCX80EmhU0Ah43JpCv8s8jIwC9kg2vQeM7RuOYFvxjP6OiYmMYv2+s8mLy3dFLxzdjiqWpZTZUjyhhCUqVUJA8R9sqBtHhkGNQGX+OI1VmS2pvqVh4VYr8OfUOo9jda3BF4iKobCx8kA/TXM7rIqKcxF9z4RqZvV2P813kCMmonWy8nyXlA1m22gvKgSos7nN713pEU8oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qCcK33geJ7TMTh6rP31FrGReBAGDdl8gbwQdLfmpQMk=;
 b=TSKXl0SFgAKEkLP5UoD/Hbu0C5gc4COdm/Si4FL95rT/tE72tEpogxSDCI6GNoAiEQxd4scyQXoj9aZk/3Av2AnYA0ebGFy4IeqLb1kXXsrwlbXewC0sInuJlvvvgtRuUf8i28PTmpOd1P0UUDJnMDOZ97me9QEuEwv0k5hqVkUvSpoRn9XRJuv1YjYm94Wsfle5Xife34KkSPvfElP4S0TvtujchHaZbRIjsHdVNVDNDwg5BiWgBYwdS9JCczi9Ygbl/yzQzWa69ndjghU8StlbXf6hv6PB/3Uxau6dmSPFddQH0l+IgyULI3xKP/vnfxGRkVbinROYE4xbqxCuPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qCcK33geJ7TMTh6rP31FrGReBAGDdl8gbwQdLfmpQMk=;
 b=npqbUHolaw6XQ8Z9CxojqlpCDo3nnN+RKAKNlZQDO/ybEKaiK3y/OfoN7LPWYfpNiyABtVTVH7muhto4Mhz/JGVtIqMIBm90TttjLKuzQOfPHnmvaHu9MGcqa2glaQ/tWsxY4MPHDLrh8oN68xSAU+HDdP3sNJJI/3ovlsQVKXc=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3318.namprd10.prod.outlook.com (2603:10b6:a03:15d::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Fri, 16 Apr
 2021 02:05:04 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 02:05:04 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 13/17] scsi: qedi: fix TMF session block/unblock use
Date:   Thu, 15 Apr 2021 21:04:36 -0500
Message-Id: <20210416020440.259271-14-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210416020440.259271-1-michael.christie@oracle.com>
References: <20210416020440.259271-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR02CA0100.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::41) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR02CA0100.namprd02.prod.outlook.com (2603:10b6:5:1f4::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 02:05:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 669ef0bf-6928-438f-b3ed-08d9007c0c8d
X-MS-TrafficTypeDiagnostic: BYAPR10MB3318:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB33183C6F39A44FF612BD7393F14C9@BYAPR10MB3318.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kjjT5s8z0956xsHomliAq03TcO94KZCTtc2SbZ2UpNv4/IeutyVmLNmUHjGZF2Fr85Uk95qQGgUBs29F+P2QPk1a8YoUaCcdsLj4HOeifSftzd3dy195gaC1rwK155WpJqPZTwYrH3Iv+npsJ9mcv3AHmdgZO9G/fEGAjmOCAU+9pmFhnD50jek4hItT0vFC9XMaUAs4Fay8OxxtdJ+HAWbMJKhjei7AK40V+HQtytDtD09DhxlHzQKvgMxUEkitKE4CJxrh6OwGCdf0tTe2JgJasW2Ezfs09COH0hZ1hAUQFl7c6ltGfOpNp4ISjEVNkvK6AH3Mm0CnvRyow3B/hjR41kQOvQZbsJuAP8a+w9xlQm142GoFJYgQPmk9sgG4QBEdKI2nycsv8ogvYodOj4f9JPNhqb2b+Ct03Cs+Umt9NmvYBil7vFG11HoUXGvnvyH3AnenEjVipYD+FDAqPHhH7v8KIqoWKjhXdk91B4SQsSy9VtYyzgFHEXENBCvE08gnSp8KFkHytBx2EnO1ST/t3cOYiLWZ9N5B7YBW2EnzeJhFtvh2nM9CqGAETxU5/KIKWvL0Zgi1nqgOtgpVMlV6/tLJtFn9I2tS1Nq9a8ODnF1p2VQH3TLXiA96yWih0yVRGsQO+oXCUucFvYR5wb1A9IZNBp/cb0r6wMoQqtjGV/wyS1HM6SgiiMMWQbmx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(136003)(366004)(396003)(38350700002)(38100700002)(52116002)(8936002)(6666004)(2906002)(107886003)(26005)(186003)(1076003)(36756003)(6486002)(6512007)(6506007)(8676002)(86362001)(69590400012)(83380400001)(508600001)(5660300002)(956004)(316002)(66476007)(66946007)(2616005)(4326008)(66556008)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?pby4of3sE1OQFl8K2n2e1rG2ZRqsYS8p6daYXFV8JoZAZIDs06XzeWY6p/mB?=
 =?us-ascii?Q?0kKv44FAC6+izs45A2E3MDNhhzD2qyym4s6S2p8cCqnXzfLFXW6u89fUb17L?=
 =?us-ascii?Q?xK6Gf0kK2XjM562iHr6msVWrXHwP/XOXh7M1DHPtl+ayhfStKQqaq1au4YIu?=
 =?us-ascii?Q?L2nRTultvjWYk0zx+b2gTIt+X33ogC1gIv8z3eL8+UXkYIx0uD6/fg2L6t84?=
 =?us-ascii?Q?6weOGfubm64xz87LplVfhM2lXJdyB4W0mi2oBezKevvBYlxoPue8lmHEHPoM?=
 =?us-ascii?Q?YmaqBhUF0ZNpz/opmQVVgYqKaeTFTVmCxYNd7ILUYK2/VlZiYqhQ5HeBim/B?=
 =?us-ascii?Q?RexyMhhoqzRjdwEYBDvRuWwaPeqHEHPKY+gY67WRfA22woMOjWiuN3J+khuq?=
 =?us-ascii?Q?UvwWPCiRM49g7dQYCeQa5p2iYJP2UzD8CTAlFe3Qri4DU93WD/j+CHShuNOM?=
 =?us-ascii?Q?eMggxsXcAR7CKtB3ta4LThc84grVzjIFRiJ67tlIRqDQf40JcNXq7Tb7HNZb?=
 =?us-ascii?Q?+K74HGnn42WC1By34+dSKBREgZ9aytEu7oqrnYblOHgqsstxUuyWAF2W1qfs?=
 =?us-ascii?Q?QlZGT1Z8b4NPeAIeJKiGAk0PbGEYu9oNVOBB9o9caeGiqQ9NhTkFdWE9QZwd?=
 =?us-ascii?Q?dqu3ZlkdM7mXK5kCbRuZ7MDgrDXhNyAiZs4pPUipirRJHghNU9FDKRLU1nBl?=
 =?us-ascii?Q?GT0lLIXXyqVKB9CZx7TJvhQ2VhG0b/SdWD73QO7onsuVem6Fj0CJ0uy07/kQ?=
 =?us-ascii?Q?waEPYCbAO7HWThhz/ZO1AkPyuQsWAhoDBPSSb0fIY+U39Tkn1ODqh8D0bEeB?=
 =?us-ascii?Q?sBXqnuPd3pk1dO1Q07Un0UloVEs2EWoii78TeMMWRNythcg9Jg2YZo9zlnLJ?=
 =?us-ascii?Q?yuk1F9NCW9gWC4vt6PKU2lLZTnD/8PflGmhZmIXq6akxlK+qP+p5/o18gJ5j?=
 =?us-ascii?Q?oO/G3iYrDznB6QNGxlC1pXT7XwvwES+A7cU1k7aDRvrlET++kkxUOuFzxnyE?=
 =?us-ascii?Q?ueEcFdP4JLWIJ2687hFcgrcRF/IbCZQT99t6dFHIO1q0bvxDqZbYGmQ6PTrc?=
 =?us-ascii?Q?aP7KHjpo5pHCQit1fr7i45txzO0ptMSEofjjU4MTDsScJ1aSkP7J1V6fwKjJ?=
 =?us-ascii?Q?+NQA+hJ4YUalN/qrR/K7Dpl6dYaGBnx6oXkaCezhxbgEkQKIb+X3B+AHxte0?=
 =?us-ascii?Q?68LCjJnGLz6+XK0ag3/J4H2Uj4ix/jgGO0TbsgXO3pVtQ/lNqS9dObK/x4Gd?=
 =?us-ascii?Q?SqBNttlSgcoS6X5I5E6bveuS9FZqUJgKXY2sYWJMNteg5K1sHCcR1p5BUezV?=
 =?us-ascii?Q?8Qh02r6qaC+IoL4PucfIuC1p?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 669ef0bf-6928-438f-b3ed-08d9007c0c8d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 02:05:04.0351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kTeEbF4G5qC1pQXnYkAs2GY3YmuhqpN5KE+2+8+VFGRAuxDQYips0lSCZJbaeD6jIi90uugE9iOHQFGjuymOI1BBA9An0gf9e7NIlKH/ri0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3318
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160014
X-Proofpoint-ORIG-GUID: ySOXYb6vb_EhuYZPNVKZNjMslhpuyLnc
X-Proofpoint-GUID: ySOXYb6vb_EhuYZPNVKZNjMslhpuyLnc
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160015
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Drivers shouldn't be calling block/unblock session for tmf handling
because the functions can change the session state from under libiscsi. We
now block the session for the drivers during tmf processing, so we can
remove these calls.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
---
 drivers/scsi/qedi/qedi_fw.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 84402e827d42..f13f8af6d931 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -159,14 +159,9 @@ static void qedi_tmf_resp_work(struct work_struct *work)
 	set_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
 	resp_hdr_ptr =  (struct iscsi_tm_rsp *)qedi_cmd->tmf_resp_buf;
 
-	iscsi_block_session(session->cls_session);
 	rval = qedi_cleanup_all_io(qedi, qedi_conn, qedi_cmd->task, true);
-	if (rval) {
-		iscsi_unblock_session(session->cls_session);
+	if (rval)
 		goto exit_tmf_resp;
-	}
-
-	iscsi_unblock_session(session->cls_session);
 
 	spin_lock(&session->back_lock);
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr_ptr, NULL, 0);
-- 
2.25.1

