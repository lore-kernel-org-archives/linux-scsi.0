Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 877EDC433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 12:34:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EBBA64E8A
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 12:34:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbhBKMdt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 07:33:49 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:43084 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbhBKMai (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2021 07:30:38 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11BCQ4H2051003;
        Thu, 11 Feb 2021 12:27:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=fIz/kU7AU/Dmnv3suS4j2gfgz61wIwvzWUt9pA7gW1g=;
 b=VainIfV9r4DsDrjgwRuwDCD9Xh5+hQrpbaWgZ1C+ec8eJvYn5ShIJtFGoaUODAkL/J0o
 kZNf5GoQXFTIHZ2+pFRLhEK3Cbc3hI4aTmupsiyT3h+y+pI1tUqLKG5nS1r39eFvaIQG
 po0MwCV6Q8gVEADxTU0+v51IUTYtgA6FRAR9jU1s0rWHYGX4/5VoUPwO1JQ7Ug1Cg3UD
 UE6SXWDgFcIIvFwE37VmU+SLqTSEFnywL0jZ5qi1xJu0TY52WPpFzadrSuM7t/hckKHe
 sAJ1SwVDqP+SUZMKuXLipeA6b915ctSrxUkOrk7FrrZvH9C65OnHOZGZtSKXdiGC7pYC Yg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 36m4upws4k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Feb 2021 12:27:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11BCP7qN052228;
        Thu, 11 Feb 2021 12:27:46 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by userp3030.oracle.com with ESMTP id 36j51yxtx1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Feb 2021 12:27:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hgE8fbrK+BITFyZU88BqKIc0STcgO3HVlwbqH+TsIptM4BFPmHAt91QX5G1pLh336XMvsCPjDcTfslapvenfh07/LTOuYpGAu+/Wsuy0GF18F6b+cbPFSDneQQqZWg4JgL5AvzfsGMACvmd5t4HoNO8k9uahZQs10b0WRHbMNPuvyHv1Oeo4lpC4mdrs21a4tRyldwkENbX9y7yTX5PMUh4/RWRdI3rpBdsoxdYmzgRXvYgbn55LYdgcCWop+Ol3Xo8fZcvJk+b2cq4vi+LNKO6XXq3BT93wxnnoX/Js0CH37IsnVaJPVwRD1RovyUQ9J6oKaojjydbfWdw3WCkXuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fIz/kU7AU/Dmnv3suS4j2gfgz61wIwvzWUt9pA7gW1g=;
 b=VmXPPdV0hI8tcaWL6jFIjmVam54ZN6iN5FwtRH42dwG4ibjxiSqHzUdssc0c0H7kdVNGqg31DGK1sinc4biXanvlO9Maxqn2W9mfdp6NLaKFY48PtsfjQevqdGdJVGZ2UO69LxkMOJ9HLuLbo2lyEERlhf69bveXI38OqIGwnwX9Ovfib/jyUfsaSW0J2/t7ke12yNp0lSw8Jqh0m6exCTtSBHAsDGEEXqXo4c9jfJwiU2MM+cdYurhszljIdYQkydYc/AvhKk7ZAv2RtiFggdkSRQFLtq+ZPh8MEEVmNYPEtKCHrlTSqs61+byFGo2Z0zJceXNvUPIaxduMFuzp/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fIz/kU7AU/Dmnv3suS4j2gfgz61wIwvzWUt9pA7gW1g=;
 b=bTiyp1LHxGBSM/e9QboI8WtQiI1jf94xYHH2ppKOg4L/1UTdTEZj1eA13BMgos1CO6T1WEBafHH0iPLYvm58mNBKZLnjdV1djMeiJaKuAZxPWE77AcJwr9QtgrzLN5wXuDKOLoRC9c6AJuCsHw8jdQGJ5DRbO8AcQoHuiYkafJ0=
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4339.namprd10.prod.outlook.com (2603:10b6:a03:20a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Thu, 11 Feb
 2021 12:27:44 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Thu, 11 Feb 2021
 12:27:44 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     hch@lst.de, loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, stefanha@redhat.com
Cc:     Mike Christie <michael.christie@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 05/14] srpt: Convert to new submission API
Date:   Thu, 11 Feb 2021 06:27:19 -0600
Message-Id: <20210211122728.31721-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211122728.31721-1-michael.christie@oracle.com>
References: <20210211122728.31721-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR04CA0060.namprd04.prod.outlook.com
 (2603:10b6:610:77::35) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH0PR04CA0060.namprd04.prod.outlook.com (2603:10b6:610:77::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Thu, 11 Feb 2021 12:27:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0981be8f-9c8c-4c8d-e267-08d8ce886ea9
X-MS-TrafficTypeDiagnostic: BY5PR10MB4339:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB4339862B1B59947BCE16B3DEF18C9@BY5PR10MB4339.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kVyRqqyq7pDxdZsl2h0kpGD3FXaqyiQDiKaLL4FgYGkAIKdPFoL+3d+lX/e+nnmBV3egUNTDSChxskHFKLVHAMCW1olUhek+fpoH2QNlovsT3Vlk9ebQccuCy5yJa6TkxYRFyFoOePiO5UDrL4Xay435AlA9uUT2U9SQjLSWLFzEmfZ0B0W8m+boAk73EbZn8F1aHWodXqmbRfukDttgq6ZtvAjyRvcWMgzgLNMlzxdSBmgsI2uapLrs4HUeRMCCgReDFPwMAZYXPrj9YJ7CA/EkEhWXinu8bhOEABdwomq2NZymwtHS1ZFvSQsbBdxcUUK96BR5PA3hR++/R4irim4UaDSWg7II9rEZJG/70VZy4qbGc2X9LVHrntnSh17xoRKX50itiF/9a5GlReRmbLpDNPYqqNG9mbdn557jHy0sGPLAasWz9RE65ULUCLUKSFlWsBtvqRsHXpTy9nIcuWqcGGBMo/VeKifUL65w7Zd/lt70Rp0GpVOcA+P0mnnr45xul7KhdtFSBjCq//GMEkwSCXhXCWz8ngDUa2cUL1g/GYfEnbCeYDG3Isq+08942VTN9ev6mLJndqsC10H80Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(39860400002)(136003)(376002)(396003)(83380400001)(1076003)(6512007)(16526019)(2906002)(4326008)(6506007)(478600001)(316002)(186003)(6486002)(8936002)(26005)(52116002)(66946007)(86362001)(6666004)(54906003)(8676002)(2616005)(36756003)(5660300002)(66556008)(69590400011)(956004)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?YJu2FtS0yqj+hncFHkpRIrar/Mm9Z3VBdc41jLzifTnDvLvS/YC4pcS7XFLj?=
 =?us-ascii?Q?L0VGdBFyN4BilROhLjjKTYV9lGgXlG1f0nWjRCQe4OJTi9JwxFuA9pQnDdqO?=
 =?us-ascii?Q?D6+RHpIRUTJhccZ2DNPPIQ2Y6uxiFu8Q8F1Nb4knEqgbcIu8a/Vzg7ahf/Pi?=
 =?us-ascii?Q?YgoaANu5zLPvasvbk+k0tA19bYaJvE0N1R1udb61ag3pQMMQgPUHhVzSCpiu?=
 =?us-ascii?Q?SJ/CSIwGn9eck6ng+OmkuKiDzLgIa2jKRDEZ7gDJKpy3nidlMfmeNXKsadR8?=
 =?us-ascii?Q?lnfkhW0KV6LiWZj4zxs9bdpdZ1qyFnSNasSan/RsRFWF4+NvF3r6PO5/AOfV?=
 =?us-ascii?Q?zr6nDW8lQqigFKoia6IpZHirDmDvdnXDesdomBbNx1iu5VywsukoGOgCBv/Q?=
 =?us-ascii?Q?v65929m59i7rsGXcielaakuOFtXrM/MjsqM6T0umQ7kaORFCmyEhs/zdErfc?=
 =?us-ascii?Q?JgvRXo1KVaXeeXur9/Wd27AUqtZwI81oeqOR24x5M84EdGUcoBk2rec4YnkC?=
 =?us-ascii?Q?EGdkysn+e6OHpmiUoPzmb0MhyK4JjtzDKvkZme8I0RQSxmDatYmqyUDb2MwR?=
 =?us-ascii?Q?z/6hSW2/VZaVJ07cwt2pzGNRHrdZMJQxwNmbOn0Cj6v+x0RH/NVYIeLvxOhT?=
 =?us-ascii?Q?OcmFyxCJw2I68qYc3IL+BVjcFy50UxIOkZE/hEa3XzhcLgN9gJd43pN6RuPS?=
 =?us-ascii?Q?pksRHsKLg3pN9OnJrZn+VK7yxAV3TJLQ1fI1V2WYSGO5MUCWb2kTlLI15Ohv?=
 =?us-ascii?Q?KztmdL4RxJEajyTkMTSrFKq3AU2cCiU6pYv2IobATkNgEhs44pMSU3s3My5M?=
 =?us-ascii?Q?qXSdKLZUb7AahKMmY8TZ7RjZbSSLrdNRcukmJ9KYVvKrIh0B1Ijhn62RD/r1?=
 =?us-ascii?Q?ioA5igOGOimBAA57W+1LGCnDrjxF/4SXVwMP/rQwG2pHibupvnZIsdr74tEd?=
 =?us-ascii?Q?XSBeMiIbJxoaQCRX4k5hCMfZyeaZ1g4OPUUcqYfefjn4CHJfK+q+5wDzSnRs?=
 =?us-ascii?Q?KUgiGDRnIhC1tAqfBj1ggnCgWoL4b237d+yYXijJQj+Ma5lbmAw3CWzG2zPQ?=
 =?us-ascii?Q?U1I4JsiZtvhCMERmpBHIWKeQZS3lZyyZjPOWImeeDCVxLjGNcRbsmOz7LuvY?=
 =?us-ascii?Q?ZYmNAvRaHX889JDGkqYcPgKZ4+vNuhiPqPBJx8rCWJeYOk6JQhG27Nb1X3Zh?=
 =?us-ascii?Q?pIN4qVr1JbaYLz9xOSEM805UQdisVz2I68feRAGdf0AY3YmO9EecA9sU1gNA?=
 =?us-ascii?Q?Q+uhe/CSEnsBMQrAzq+ALk/XWVE7AJkMt6/4CsT55kn1vjN+ELlU0Ba/4Ru1?=
 =?us-ascii?Q?K2aWLqq2kniSWqJxlerJG9F3?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0981be8f-9c8c-4c8d-e267-08d8ce886ea9
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2021 12:27:44.2495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MDE55xBCo0M7mbupA4jnmZJQOCuHnQoPyxR+i2dVRKuHAhmlVQMUOWWU964C6tUn3uzQDUgEOJc3vx6szy4IEBPXSG/u2PCIARYgYIAG2Fk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4339
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9891 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102110111
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9891 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 spamscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 suspectscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102110111
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

target_submit_cmd_map_sgls is being removed, so convert srpt to
the new submission API.

srpt uses target_stop_session to sync session shutdown with lio core,
so we use target_init_cmd/target_submit_prep/target_submit, because
target_init_cmd will detect the target_stop_session call and return
an error.

Cc: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 6be60aa5ffe2..87741e0b4bca 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1528,16 +1528,19 @@ static void srpt_handle_cmd(struct srpt_rdma_ch *ch,
 		goto busy;
 	}
 
-	rc = target_submit_cmd_map_sgls(cmd, ch->sess, srp_cmd->cdb,
-			       &send_ioctx->sense_data[0],
-			       scsilun_to_int(&srp_cmd->lun), data_len,
-			       TCM_SIMPLE_TAG, dir, TARGET_SCF_ACK_KREF,
-			       sg, sg_cnt, NULL, 0, NULL, 0);
+	rc = target_init_cmd(cmd, ch->sess, &send_ioctx->sense_data[0],
+			     scsilun_to_int(&srp_cmd->lun), data_len,
+			     TCM_SIMPLE_TAG, dir, TARGET_SCF_ACK_KREF);
 	if (rc != 0) {
 		pr_debug("target_submit_cmd() returned %d for tag %#llx\n", rc,
 			 srp_cmd->tag);
 		goto busy;
 	}
+
+	if (target_submit_prep(cmd, srp_cmd->cdb, sg, sg_cnt, NULL, 0, NULL, 0))
+		return;
+
+	target_submit(cmd);
 	return;
 
 busy:
-- 
2.25.1

