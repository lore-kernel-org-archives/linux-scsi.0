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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58711C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:32:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DE5D64E6C
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:32:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbhBQUby (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Feb 2021 15:31:54 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:51864 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234170AbhBQU3k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2021 15:29:40 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKOu4q109320;
        Wed, 17 Feb 2021 20:28:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=REChbTM+nyS84aN3X8b0x4n2j/YKp8W1E93Zib/qGds=;
 b=Q2XGforPBgHkC4Kv1rEr3Sv69ElSn0Kj2+5SYFzd1TAFvp0uZGYeFNdQ3vztql2nrqHW
 G1xKO3HwC6YIISTt8fMxO5/x/7QD0Plcmx04aCUYM4FM0zfwnjTazpUBIfb91DLaRbcc
 2i9nkRpgpDtf5g5JiaOkKTaVMYYMl5WoGwBMFGehZSIkRBFrhwFuQ7RPeV7Aq4aKED7U
 cNQ9dnoArKXBNY9j8jhViCRBZ0MylmJPA+UM0oKgBa5G5wjHdcbKs1DD2r8z3pxj8sZp
 0C5KaiTD6iB6nn3M6qjH0TgiVSkZ06MED31Bl7Mqpy7Q6dxiSP21vDQbdXhPBNDqlviF og== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 36p66r3s9t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:28:43 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKQNvS004046;
        Wed, 17 Feb 2021 20:28:42 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by aserp3030.oracle.com with ESMTP id 36prbpwwys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:28:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cEqph+j5ykK/VSE8vFJbrjA1pHgKv8Iu15xps4KV8g1R4q7KDOusuPg7h9cRsBXKjatVQTujKmUYH4gWJvUNi/uLgzfQTOVkCbPhyo3Jn3gyIVvw1TVHmjrdJ8iXGtkOwe/pquCQSrGvQUxMGRfaNfLBSoP3+QVDYml2jkee9S2ku2gh73FPSWLogyKmP/i9LLz6fjuUkncquZ4ijVv7SuHwZtu7QkHQXfRSUSL657iw7H1NrdFV8b/CakQueMJVXr/3JJsCZexN08JHnBjQ8PVq2io7EdOOn5rjt/LqZqIk9OLWAM5sKn1f4Abov49sdqo9EsYYLf1gBkXzrfCsHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=REChbTM+nyS84aN3X8b0x4n2j/YKp8W1E93Zib/qGds=;
 b=TqHUo9oKdMfojeVXPgPaDy0NI3sdnPOGdG92N8sVa3snOO4UKEB72ce2rhIUqJuutaPMI4EcqKDOv93huqClCyNgYADahO+5JUD9eSdm4sVSMxsL+fPqG8pWuNSwEH/dsJxBtTt1JIQ1taPp4r+9/Vh+u8UyMMlXv3PDe9dPAjWfXESzPzDMDM2k6FJxTv/y/sHyQiDTM60TeCx5wrAInDTQKM5TIiqv2KVHiOmgpiWHrarnfR37iLrXe75Az23VRoZN9YR2sJMNJJNyjdmyXb7plbXGCd0ty3C70RLWGcifM0zxueXM33gANj64xKFyEU9GXsGR6SnjBtoFK4L1mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=REChbTM+nyS84aN3X8b0x4n2j/YKp8W1E93Zib/qGds=;
 b=USy1oKdyvVIzrj/TR5ieWDmKq9tlZsno+6O8NsdWIZgy8/v5IRncHOTsf6OjYMYlE/eSIWjm8RtHKer7LJpRy5rn7avzXZplTz1zLEos0hUUHXtqZ+znVZz6DfTP1J9Z15veqBB2IKKYv4oGrAE2tqJ10L0JOdj2Mxzg/Q4JuK8=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB4101.namprd10.prod.outlook.com (2603:10b6:a03:120::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.31; Wed, 17 Feb
 2021 20:28:40 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3846.042; Wed, 17 Feb 2021
 20:28:40 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Chris Boot <bootc@bootc.net>
Subject: [PATCH 09/25] sbp_target: Convert to new submission API
Date:   Wed, 17 Feb 2021 14:27:55 -0600
Message-Id: <20210217202811.5575-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210217202811.5575-1-michael.christie@oracle.com>
References: <20210217202811.5575-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR15CA0001.namprd15.prod.outlook.com
 (2603:10b6:610:51::11) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR15CA0001.namprd15.prod.outlook.com (2603:10b6:610:51::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Wed, 17 Feb 2021 20:28:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c300b55d-b1e6-498a-92a1-08d8d3829c9f
X-MS-TrafficTypeDiagnostic: BYAPR10MB4101:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB410118F831D24DF7B8C217FFF1869@BYAPR10MB4101.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DVpn/P15RqCa//Fwax4R435JdyIu0CNSyJCqRyb69Pgehfg/xxNSToblOLz70ANN1w7i0s6lnn72+JRxVJabaRieeV7VG3rxGIDoq1SjPklqWvk8Srd8mbvrySnpsVPpcR6L4CZLhiB1bBM75V7hR63KqZAmD2cIGwQ1kQgyMOEMJucmFwWIzEUIC1HhH97myba2eqn0aTEihjH9Fx9dSmxfr4AJ4YvE8P48RPPvEODVvHgsskOfCQa/C7jL7XWLRPsQN/JDRhumogiLA0VSGcnsvjhmpmjnb/Nvjf/HOZRFDEkeQxGk/rcczMTyKAexODbCDV7qpJ0jKWx2v96iFAXBn2QLqUDUDi76U3qb8XiwTbswpNVvLwa0foo7E1jxVTkWgmBpQxBKMAVf/iAKALdgzcWv2UyrgKrLKogCuGZRP06RTrerDJol2SUbilhFUh5L3NPFcf9QTcFiDNKJnQWLGcZnHZCzqovBO+aHIHdGOfqmJAi0x8Bba8WNG0aXx9ggXd2Mlv3Dum9iFCE9sTBNOWSdFP4IesrTFTsZJ93xFEEcc8KWH4is4s9dLmPtCOSfEKUMxLaTSCjgTpLarg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39860400002)(396003)(136003)(346002)(1076003)(6486002)(26005)(316002)(54906003)(478600001)(2906002)(186003)(86362001)(6666004)(2616005)(6506007)(52116002)(956004)(36756003)(66946007)(8936002)(6512007)(8676002)(4326008)(66556008)(66476007)(69590400012)(5660300002)(16526019)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?S7NNSAa5CFO98Qcha8UTWc5by6FpcbWz00HcX07Ql597IrgRfMOE2sVNjM0Q?=
 =?us-ascii?Q?qc/UXs1p1L+1HmQ/DjInLW9R/3mcLHcHzZ2YsFSAYkesU+ug/O1zZlN+T1A+?=
 =?us-ascii?Q?x8KmQrQ0pQ0MkmuUJITok4G5eJWpiBQxoUOpSyLUchTpz6M51H2ZmSAmM7iZ?=
 =?us-ascii?Q?7XqgVRrPFg6Y1DhD/5aO3wAInlOeBntrx8H1MXmJhLvahEaxhHE3UJEXzhU9?=
 =?us-ascii?Q?TaJZ8IAHqcNw9FVadf7Fiq+AcbK6JLr0UtduZhuaq82SJOpVArI4FURLBhVT?=
 =?us-ascii?Q?YaW72d/sVo8IzFIAHUS3nqYO2xRrx2Wk9vmboNBFGuNIwNDgC08azBItmXkU?=
 =?us-ascii?Q?FEYlsnce0SldJ8xTkCFlxsL73g5m7UjouS+ftZCcR9O5mXAyVNy7YruvsoZC?=
 =?us-ascii?Q?81+Uf1V3S8KiivYqxvHSEFhM9ULtuRB608zyPULltrm+1wjORSgM3kxav24G?=
 =?us-ascii?Q?BzuuImN+peJkZVTz4ssLDbeRPugWFfeG4PhwkZctqDLOu8nvkP08M+urnDQ1?=
 =?us-ascii?Q?ljeA9hkdIKN+4TlKwI9vcAKNnzpi7IAL8ASeryIv+l/igvE1U5cS0AMxjcJI?=
 =?us-ascii?Q?wu4exJBOUmuQc9WU4Phmu4lKl3aQP42x8JmozGF7LSJCed0bScpQgmUuqynT?=
 =?us-ascii?Q?gH+480Xo7751cZNZ/sYcEWJACB0ipobpo9GiqVFOntWOve3B8JgNVSKDWAXS?=
 =?us-ascii?Q?dHVXdScKWhyp66cppbEgx1vafokiFyzFCSnh2htliZqGQAbr+yryGvCwpbdM?=
 =?us-ascii?Q?nnG/zkQZVkDRUW+U0hgA8jaLVQH64Qm9NCNJ6Oi3aYHJJnvRuNKpWbORItJE?=
 =?us-ascii?Q?CsNG2Wz50GTYypboHTU6hHjKoWAmni0CFTRHStFpQhQ2afnRP/WEputROYXV?=
 =?us-ascii?Q?r85bH0sfbmQkd6AOKTsaAfXcFbbe/JWCujDN57Hwptlnk6l9BLF381IkWkmN?=
 =?us-ascii?Q?4EgfTDF3vYFpFF9s3SiFVE+A39BAoEhBSwt2oLMf472lEChu5fhrnOucXlol?=
 =?us-ascii?Q?u2GIFKFh7QWQBzVHi9DKVboUslZOKZRmyHDGSWjjNUFbjdZ3+F3V5gXlr091?=
 =?us-ascii?Q?h8PsMpN7RSSSZUbz5HRKublI6qP1YR5L6hYHBLsV5FKzdNdlKPXVZHuwHNCr?=
 =?us-ascii?Q?hoR6iR9ylJ0CIGLMlZHEJqxLFs7E8+xW7k84OOBo4KJ/PQeVynu7lGNXUtr+?=
 =?us-ascii?Q?ZKgnDF7zd/lcJykWJQZ+tFmIQtRy1tPUtl4raCGp1qEeLMPkfLQZl5MdNwR0?=
 =?us-ascii?Q?9MGOHxuA8XLoGcQ2pY46BPjOPTnhpo25AWORa/2QaD+Rk/BBxo4It2oCTOPZ?=
 =?us-ascii?Q?78lDLM1LlDQapEfn561ivwHH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c300b55d-b1e6-498a-92a1-08d8d3829c9f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2021 20:28:40.2026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2JvZy2ILo7Pd1fvqerR+dZMBF8zFRHmCut5lth7DwpxUnWXO7SkAsLlr/1TiuabJOkEJsyXnOrv4lDQCmIklAY5swv5Icg9nxRWlctUPJII=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB4101
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102170152
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 spamscore=0 mlxscore=0
 phishscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102170152
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

target_submit_cmd is now only for simple drivers that do their
own sync during shutdown and do not use target_stop_session. It
will never return a failure, so we can remove that code from
the driver.

Cc: Chris Boot <bootc@bootc.net>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/sbp/sbp_target.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index e4a9b9fe3dfb..f467c50aee08 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -1218,11 +1218,9 @@ static void sbp_handle_command(struct sbp_target_request *req)
 
 	/* only used for printk until we do TMRs */
 	req->se_cmd.tag = req->orb_pointer;
-	if (target_submit_cmd(&req->se_cmd, sess->se_sess, req->cmd_buf,
-			      req->sense_buf, unpacked_lun, data_length,
-			      TCM_SIMPLE_TAG, data_dir, TARGET_SCF_ACK_KREF))
-		goto err;
-
+	target_submit_cmd(&req->se_cmd, sess->se_sess, req->cmd_buf,
+			  req->sense_buf, unpacked_lun, data_length,
+			  TCM_SIMPLE_TAG, data_dir, TARGET_SCF_ACK_KREF);
 	return;
 
 err:
-- 
2.25.1

