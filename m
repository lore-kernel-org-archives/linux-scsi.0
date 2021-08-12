Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A36EC432BE
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 06:33:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA6D560F91
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 06:33:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234209AbhHLGdv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Aug 2021 02:33:51 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:29420 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229956AbhHLGdv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Aug 2021 02:33:51 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17C6UnVm002891;
        Thu, 12 Aug 2021 06:33:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=blB8pe9MoaCSvR29pX0HSWDQRosZtembHYWdTPxbL5g=;
 b=kkzQVMgbT6OV/0aQ6LgYAzkCAyHaqDnsV0r4TGGwDv83xK+LpEPgsk6oY4DkBCt1CLbD
 So39/qiT4PwSiMnvktJ6gCa6dkHwmYn4RJUIswdD+ab0tbmAF9/v42cfdGBJHfMWL+66
 ris2enG9q0jmZtIy4+bLd61+aM8b2RJszZ7n3s4Q3HwjLmW+FxBGL6XVAe3Ar4kvZ7xW
 l0OoQW2SE6WrnnhB1E72FaRTfWKCE7hoIM2tnuBXP94VNCkHctiEJ5i/2dwbsfuhoaNA
 bQcE2QGfsLlQbrUTsdRf/I9DxTubsuipcIlw/80zxKTqKFf7r3Jfus1OsAIH7BYdaTuZ Rg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=blB8pe9MoaCSvR29pX0HSWDQRosZtembHYWdTPxbL5g=;
 b=bMQ3viQAI8rdpF6TweH1YsHFv33OR2b5LIXnTas+y/JmnwFpTTG3JtjgoX2yy4J60gvv
 BVEjPTNUqNTGMtU0kUJrWkyLwlHDv66z2+r5UkpTZ+fGj7W0wdTPg5HRA7ZD8kdFezCc
 1YWFpzp8pA4AdGV9iuAaj8hlZ2XzSsM+oqXAVM7caV1jnfIqKcE/ytp56RhZiopVVt1g
 nE6mEtWE+usFWGqLaZLwlbCcp+4sN/M+W24klGEjNg7xKOnohsio/8iB2SWlMB0ZUVKv
 DJIXaQcuzGvamPxJgsahVVD6zSonoKPkUmWKgRzNzsmDF9rKqXuMxycEHhQd8uFpmDeV 5A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3acw9p04t3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Aug 2021 06:33:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17C6VCtE108623;
        Thu, 12 Aug 2021 06:33:21 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2048.outbound.protection.outlook.com [104.47.51.48])
        by aserp3020.oracle.com with ESMTP id 3accrbjse7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Aug 2021 06:33:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VOQm07sTRJMhGB/DGlWhxIIrsFeeTOIK6oVcHMP0dtxmQew8VyPP/JvXU7hQPvD7/fJUErqhp92gm7kbekWC/LzPRzbw+rOwMjBazNNq2piiTMETnUEXrMnaA5LcVHho6pHnfPj+11dyTB8deBsiCxw4nmo+ugpb6+UNdz/l9qcrwQQ60oafncuACTmnfRAeFuBkgDenKcmEpmOZh/2K2CHjfhF8msagt2lRR0AyulDO9qe6IzZaYw5AQ0d39XVcZ9Q7epqkir+ucIFi7orgeBBXQGHsYBuoQVhGkNCWom6Tt6QyooH8UB8GS3k821WpHHxumtyM1IO7xDqZI2VylQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=blB8pe9MoaCSvR29pX0HSWDQRosZtembHYWdTPxbL5g=;
 b=E436UfJXETLeHoKyEqteKWO1dYZNkA2jHMJJ603QEkaw1KQpCi90w0E/C/AIsQRz5KMc1ax3rQtzit3Ll3CKZlyy90v7dzzpqLW57lW83dN8/NOZDS60WaVoQQScf0CYXNrznFleaK3VDV/MpIl3HeFxqYlUP+TyPpHFxOrOvM5N/aruvCk+bHy8j98xG/SFJNEgi2nii8OVZqqB/up5DG9kTdohrK1zDCbW78xoQ4qAYfMa+gvC3r/4brMOyD1mDpuzNvqjxrTA/Vh/l/zUAfsPtNOow067S1mNlUeTEj2yhUOXqQ+iyY9WBbEe+ZUMXgO4fRpWj/eg0TfmxYnS/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=blB8pe9MoaCSvR29pX0HSWDQRosZtembHYWdTPxbL5g=;
 b=zADf7eAcC8h9soyUHTr4Hapn2agOhT4s+k7S3+gBw1J3ZSI0INDV3aY5R2oSv1a2eeTccmTRLkwHmsoqLIu2TTO74gcVX+rzB9fYcoxD/O0V7XkqpkWtvx3Vkf4cnJ3iGWJQzAPEPKMN7n9lmeiGXRnIkGnr0MubBwQlFhsRmno=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR1001MB2095.namprd10.prod.outlook.com
 (2603:10b6:301:32::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.21; Thu, 12 Aug
 2021 06:33:19 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4415.016; Thu, 12 Aug 2021
 06:33:19 +0000
Date:   Thu, 12 Aug 2021 09:33:05 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>,
        Shai Malin <smalin@marvell.com>
Cc:     Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: qedi: add missing curly braces
Message-ID: <20210812063305.GA9100@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0093.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::8) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kili (62.8.83.99) by ZR0P278CA0093.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:23::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Thu, 12 Aug 2021 06:33:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1cfcd461-1ae2-4a36-0107-08d95d5b12eb
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2095:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1001MB20957A9F2445240935A123BF8EF99@MWHPR1001MB2095.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M1/r5ohJDpKYbH82KyBMp8eXf/lffDqJRho2MOZ8DCyIZQBnCMdUkEDxXOagOD6SzSYaZRVQ9ooq4DZRY/KL5W1AYpF8TAfTjMPgjUlPAk0Evz7gpZR9DFl0eiH7VjOFJimYQPAomeITVDse3AQObU+aBSX8ANxOyzO80A9v1gHUSaC3VWgDd7iQKebZkG7NMM7FHrGr8sGLZb2pQ/UgbLh6QI8+bFVmphnI+d3lkBLb2YpUwgKWnm3osBv58x/mpZ2bt1gYDQ13FoP5gHSu4ZYmnzDu+MJfVLV4dU0cVOjrNnFxyf77X3Dt5lQcL3VV0KZCpHdRxTy8fSEJueK7fu2gbZdMQFt9kddx0wkxw4RRCSj1mHQE/7DkXZ7JP1HepzvqGdgXtWBUDPp9ubjwxXSlvqNJJ1xtN0SuEhkLeAwQtCQ19U+OH6biIZT6IncQeIPBr0VF7UfYP/oGpFkZvkKv1AEDtom+KLtyCfLBXfB5boGdALGnMSW4kw6yJNb33c7qm+/yFXaSFNKYV0o1jFW2KlrD65Q9zDVJ2P5M42IHa50A3v7nnazNQXU49AmXN5qli6G0ym5uNr1eTwUXnV/sRMQMo7McJewxZuKpXiyK+GclPeJtOp9w8qKLI+PJI2vzRk6ms/lWTCEAEonR4Tzy8VHgn/lVUOH1R66XZRVN6DN2AXOdxlrW2EMD5fwQMSeHqokW4vTWgGqTDdF05w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(136003)(366004)(346002)(186003)(478600001)(5660300002)(33656002)(26005)(52116002)(6666004)(8676002)(8936002)(6496006)(1076003)(2906002)(33716001)(83380400001)(316002)(54906003)(66556008)(9686003)(110136005)(44832011)(86362001)(55016002)(956004)(9576002)(38100700002)(4326008)(66946007)(38350700002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uwIovrTjhi9Xy9MbCJjOAR/Hq+ul3AUlRqffT7pnj7E9enerxT+s1iuScSwr?=
 =?us-ascii?Q?L4drUwIRm5N3PeL77FfeKTzRW1i/YHR2KnxeKg8xFJzNuCK+5qmqGlq+JLAY?=
 =?us-ascii?Q?EQbpXTzLmA9XOYjceXpod5/UXKP1KVBXvHasN9JhqQnh4Dmlu4akSf/IfQ6V?=
 =?us-ascii?Q?TNd9GghQX1Chr93LC8l5pJHLlU9v6Ae8e6wSrqVobqgb1Am+lMLz5ZK8quyk?=
 =?us-ascii?Q?bux8fWHe9W6onpPQsmYfI60zrfaz/un16m5yc3csn67BLalg8lRa9BAIUKvr?=
 =?us-ascii?Q?mKtxEOewYPJklfQjHK1N/4Nj7YGepbSYWIxqH6VTyAQZfvqnGXJbtjU/roqm?=
 =?us-ascii?Q?BaC8NedpWjfOoY6phNRLA7aNyazWuDlTkrwAuYcxzXHy8cshNFgcAuQSgMB9?=
 =?us-ascii?Q?wsygW7MUA3MPb6UWOdLqrpsdGlvVQbrUEKjkIpI2YhpBWmmYyzjS9f9eHJkS?=
 =?us-ascii?Q?WS2TfglunfidOOkRFge/HXkrTqqy1qYZPUc2r7+/ggvnKyD1SnyAOoHWC1j0?=
 =?us-ascii?Q?0flzeY0MBtcXqv3qL5cS0AftaTL4G0N4sp0Lwy4LPVewlmH/HuQvULSmQhbQ?=
 =?us-ascii?Q?JsV3jC/1kPNnp6O58UjY9EY9N1L4Af0fkoH3StWDkZXCTWwPxMOTh4yCcfZ0?=
 =?us-ascii?Q?n9qr3NMs1fH/4IgspppNxnDXQmOMP4gIP00l7rhU6VFrbsqoIw7ia7ZM/Lg/?=
 =?us-ascii?Q?dStJwHSl2gQfCWA1Vnuw+0tWdI15J1WYsRUvI53kF9DEEGKxR94gGnQXPuIS?=
 =?us-ascii?Q?pbp/+pRjfU7mVLq6wIHf40Hm3aUbkTxu1oqtx+L6t2g4UbXqu6qM4+KhGeer?=
 =?us-ascii?Q?mCH54suNNhpsY2f88eLSGuPvuj0hvoIBdjbjZ4ajoU6xPeMEZtAiM2PoPRsi?=
 =?us-ascii?Q?76auIa8OdFhoWUr0zi2ce/PjovhaeRw0oiKGDIr+cbb7KQ9O3bGQZ9gGZwcN?=
 =?us-ascii?Q?axwOyM3zaPIVzrmquMbg/25u0x2IOIUzC7dgH7YtMlXQ+MytOeCCAcfOvW8j?=
 =?us-ascii?Q?QSD6uzsHkhW8yA5ncPrGTVIPIVSOdVat90VzkPVKoD49L5nacwx/frLdRHSI?=
 =?us-ascii?Q?pA2+YSZaK75zxlNTC11BaGgqfvXS+HOnZqboaoz3WMyWtjjYPPQbK6GRvyBD?=
 =?us-ascii?Q?A3cO5FHxtzyUixeIbzHWenirif5HXSooEsXHye7zLMG0YKZkoamj75T+BAZX?=
 =?us-ascii?Q?m+1AkThbWJTh1Z7Uwn5pclaHzXmj620ZLNCpRj7lWNqNK1UdogVRLD6PBwQz?=
 =?us-ascii?Q?X9cXIj45nurNges4oDfYtIB2K2qJOG5/y2HbSZfVyMzLPySmIDKNPKJiF+w4?=
 =?us-ascii?Q?Oscg2webUt8gngWYyPHb/A7S?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cfcd461-1ae2-4a36-0107-08d95d5b12eb
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2021 06:33:19.1783
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wW57eag3gm94agLLL0g4RnzZqbVrSJthIf7iV+EBr/3doAw5OgJYG+3MdKd4EHEGAgMyfcHwqzEtZMO58gQfGO6KuZThn3MkEYmio2jLmtU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2095
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10073 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 malwarescore=0 adultscore=1 spamscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108120041
X-Proofpoint-GUID: 5p5K8Ahyl54-vb68GJgDUNT03lToAqcg
X-Proofpoint-ORIG-GUID: 5p5K8Ahyl54-vb68GJgDUNT03lToAqcg
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This if statement has missing curly braces so it will always report an
error even when the call to ->offload_conn() succeeded.

Fixes: 072ae05a044f ("scsi: qedi: Add support for fastpath doorbell recovery")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/qedi/qedi_iscsi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 8ac8aabc1ef6..c5260429c637 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -599,7 +599,7 @@ static int qedi_iscsi_offload_conn(struct qedi_endpoint *qedi_ep)
 	}
 
 	rval = qedi_ops->offload_conn(qedi->cdev, qedi_ep->handle, conn_info);
-	if (rval)
+	if (rval) {
 		/* delete doorbell from doorbell recovery mechanism */
 		rval = qedi_ops->common->db_recovery_del(qedi->cdev,
 							 qedi_ep->p_doorbell,
@@ -607,6 +607,7 @@ static int qedi_iscsi_offload_conn(struct qedi_endpoint *qedi_ep)
 
 		QEDI_ERR(&qedi->dbg_ctx, "offload_conn returned %d, ep=%p\n",
 			 rval, qedi_ep);
+	}
 
 	kfree(conn_info);
 	return rval;
-- 
2.20.1

