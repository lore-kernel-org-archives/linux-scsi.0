Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2701C48BCF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 03:39:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFB98611BF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 03:39:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236550AbhFIDlg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Jun 2021 23:41:36 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41962 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236451AbhFIDlb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jun 2021 23:41:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1593JqRB101672
        for <linux-scsi@vger.kernel.org>; Wed, 9 Jun 2021 03:39:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=7Geu24OZxdxioTwSOoUiBlFQOW7G5uY8a8mCOeSav/I=;
 b=xZxOrncGm2Y28/jGZcbZMIq59iCkP/g3sSMwhgCNn5eLFKAWG0/vlCmkcalQkj7rmtDZ
 0rPclZC03LkgDxXGnWKwmqfqkJhqx4a+QosU9GAej1kqsAs2DBiQ/KwquQk+5qyFUIlI
 OI/1EubQOS1c6vpbhfwEHzPGoCbH20jzWOH7zXkWIyxdsNRO11LZxJk6DCvopRP3UgC7
 9ZaGV+F/2RrMkQrmCZnVz7FZPv4woipTOHX7ROyEnHHy0d2GcKB/0GRjthxbm4x+2mCa
 aDmFN1YPnK9EspsxjVhP83IjkzBj5sQYvpl6025d0b3YwYV0o3D8N2qllK2kBW8xha9H 4w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 3914qup8u8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 09 Jun 2021 03:39:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1590Z3h2082802
        for <linux-scsi@vger.kernel.org>; Wed, 9 Jun 2021 03:39:37 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by userp3020.oracle.com with ESMTP id 390k1rhr0h-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 09 Jun 2021 03:39:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k5nNqKmtDppKu5OI51l/OOKwBSijoyvthZVMhTfNuds2WamxCX1u7KVRgGF/crU4opMJBnmfSkgBqiIEP1mWYCV+YEN3aNHzpa/nUuq+0SGoNxR/kuZqsJ9SDIYxhi0VKwf1DaXw4DqheR4nwzGawFHmtREC+bHigP9NtfoB0EbtvSs/6c7VvtzBRKpnjZYJJu/rn/2eBd+Lbq/sn6FiKGN9oF3zqgVmZtQgzLdylb9YZTw+WoKdGcnpDXtpOl5zPHaIt7+h3lPIVBXFIG4HpKzFOh3s0bPM41bsVOBllPMs98HcokvEcUY9H3qNMdo9Xdo4+1hGuIgg1QUIFr/GIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Geu24OZxdxioTwSOoUiBlFQOW7G5uY8a8mCOeSav/I=;
 b=fpZfgj84rQs5bVQzQCy9x/W8NXlqfLR131yixsALsND8jJWGRtY8efbkNGwJEcXZkeC2fgbry9j3hFZO5S6LKL+l1MmnKOz/LjfF3l2yVpydNeFMkA7ySXDqeSyS2mgB+/5+Fd2gHXY+fGrhrOwpGVNS4rMxvobG0cJP8Y/14dpPAiVjPOdYgHInfNoewtexIQ3eisUCzy02lNSniu0SJXgijSzVaVFlfJ192MTp64K8SZ+LrJPJXMJ0NI3jUvNnbRIOdFIEsdNUjozCOR4zA2q4hUgrvlMf2f8DmZ1ltiW6yf477Bc0Gs4DVCHLRSXIjl69DWq/6bo2cNtq83X7og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Geu24OZxdxioTwSOoUiBlFQOW7G5uY8a8mCOeSav/I=;
 b=iunHVGEFvJztsZrs3SsKMl3cmXjJse1FsbY4eI566Q6MEETO7VG7oIyWDxrjQZqm0J1cNWowTry3+xwI6jo0VZ7r9wwBEF0gChAYaOpmbymcHW9LtJsGz3706hvLsw/MsMTFlv402WAl2hFYlQorduVOiiyexeIdwwbhMjKpQXE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4422.namprd10.prod.outlook.com (2603:10b6:510:38::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Wed, 9 Jun
 2021 03:39:36 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4219.021; Wed, 9 Jun 2021
 03:39:35 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 05/15] scsi: mpi3mr: Use the proper SCSI midlayer interfaces for PI
Date:   Tue,  8 Jun 2021 23:39:19 -0400
Message-Id: <20210609033929.3815-6-martin.petersen@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210609033929.3815-1-martin.petersen@oracle.com>
References: <20210609033929.3815-1-martin.petersen@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN7PR04CA0034.namprd04.prod.outlook.com
 (2603:10b6:806:120::9) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN7PR04CA0034.namprd04.prod.outlook.com (2603:10b6:806:120::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Wed, 9 Jun 2021 03:39:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a4e511cf-fa89-43c9-7499-08d92af833ad
X-MS-TrafficTypeDiagnostic: PH0PR10MB4422:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4422E14F4A1D45974022B7C18E369@PH0PR10MB4422.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1247;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P7h9W80Ioeh1DtPduUql6Vr5JQ3uE37AxLW36t2Q9e/gy49t4mCF/OColT3TOf7wzW8kC+ZI1D2uVT76z0GdNH3VibhQvHlX47KkPFEc6QVuv16p/oAGsLkXRUpzsMAUWSM9U2w0yl0KRBwLahq2qZI1N8cuxX3N01dKRGu8aISJCEvlHxHo7GsfiGXfmfOTy5Q2ngiHHCcWa5upP4JZKIuNV5sD204XBKlz73xeOErxnSQJeC3vRnk8RdyhNWBysQHb7byNIWpzO/F1nw/F6QObNQS698eqbRz2zsF27MvjnKFsoXDU4tN4951cTfGPOe6+exHAaR1zd57Bhv2T6kut95un/7PcUF5HFBOAXKIkh0ZpwXuZXrYD+hS1ljqQbGO0vkI2Xanvf1o6d5ml79iMEE65lhwbT0FVQrmhC7+cykxVf5dcZJyUJXIAVvsI/aOP2+r6papffEsYR14+jMNRw0nJcCPWIoRaDRkCYXQUVnr+59O3j7fFy+VJF6ZHYCjyrUJyqgqcs6e3fDiAEdeWmTeEDh0mrEqAr5qnanvmfXbR+jdnHhTXlTlG5Hmi9eTPaLnlv686CRbynQvPUZiSfKED4au5EDcy7GDm5luVOdNSFoBJRNN585VNAQfOhJn54jVrjZRLdmscCmOgywVoV2uu8nBAylgdDZJqjC83KJda3u3CJ1JrzM9kTtWX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(376002)(346002)(136003)(396003)(1076003)(4326008)(6486002)(316002)(8676002)(8936002)(66476007)(186003)(16526019)(107886003)(66946007)(38100700002)(6916009)(26005)(5660300002)(52116002)(478600001)(956004)(2906002)(2616005)(7696005)(83380400001)(66556008)(6666004)(86362001)(38350700002)(36756003)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6Gox9GmxuePGWJc97O8yV329sYuq39C9wa0Pu35GsRdraCVvx+voBDtK1leO?=
 =?us-ascii?Q?2cJAsFQ/nWSHZY8eOawLlgL5S6jDAOsVh4NEcYBsPtR8YW1FcsuvfDacRvbr?=
 =?us-ascii?Q?vpxTwubZ4ejB5O3clrcHF51JTBi2+f2CaPQMFj9SJUcqBcNccK/4vOCFfMMG?=
 =?us-ascii?Q?f5hsZ3pRvx5bv9ioQKeMkFFBWWFoDXuOBs5FNc0ZVgEUPPkaVsnjlu2+iooS?=
 =?us-ascii?Q?su1v7hIjsZCc7FWc8RaNRYGPbWiCa0ljBV2c1V3KChani6H92kJacfqyRktV?=
 =?us-ascii?Q?hHkAts/GYnReVz7ZGtKdPOPOAoWeMLWBq3TUTDg36ryp2QYcvaxf84YmOGaa?=
 =?us-ascii?Q?ghcP4DR6RbuFYJRQl9EKHzE9wRx1goGOQhB2isvDvwWYVictQbA+70yQNaCq?=
 =?us-ascii?Q?UWrqC34UsmajMrdmKKxSHb8Z0zSnX5ktl50n7dWNuDt5/rb9t8RWzrl5tOVQ?=
 =?us-ascii?Q?iNGiZsrPA9vY/f7wNZvvDgOpTt2m5ECxTMXrfY2JbGMGLkadlTMF/qDac7iW?=
 =?us-ascii?Q?fryPJfFGzHownHpV+shxXcyLDG6Er1Gmj4XM/fpacehPN19XYUQTDPzrxWio?=
 =?us-ascii?Q?ZLd5K3shT7q8ir3lyl1DAn6nSgOttEwUWVFoSUQb/KIvEidmf9stpzgWZKCo?=
 =?us-ascii?Q?amBjun8z3dtjAXkNej2oBgrmAaXvnjzotcOo25qP3Qj2EjgNfyY9yrkfTP5F?=
 =?us-ascii?Q?P/3jRiOgD+/8HjbX00Ou08vf0PnI41ufjy7m1JNAuSSWO4oFp8RFC5XwF8j8?=
 =?us-ascii?Q?vn3rLxeHl7grnDCMwonJ83QqyXk7SBAqdfn9rAPbAWcNpxLoBZzDdk98CsFd?=
 =?us-ascii?Q?chQgX6JVcHa3dhg0a81J+/avqchRn0ZSsRyiE1JLZB762EpnO910BgwUfLeO?=
 =?us-ascii?Q?T5sZdsw9tbQyewONhVCsgCtZeIX9yVD0IF6AfIo7fGDV6Bx6OS7bWnQMiSPY?=
 =?us-ascii?Q?5fY8pTupODkNybRVsqFnKr5aZhmHpIBoM/dfjjFNuBmCKbcriXGtAAR7pd2g?=
 =?us-ascii?Q?qoQq5OpXFg4abipWkxhIzPD+6q7gKqdBGp1llR128X2qnOyBolmtIfR3W8A5?=
 =?us-ascii?Q?MoFTjzF9nyzfxOIdzW2db2UFEjZpRkZ8i9gJ1PH7NzOHICWHJh2CyvLfr191?=
 =?us-ascii?Q?2ueRLsLC+9QfnUov3eBplx3whvgNcGk+AAPnl9bdZRJJ/UIbTtWlBzfNkL/6?=
 =?us-ascii?Q?3kzftSfxz+1QmGS5/dD8DLkgYJhlO9bcyY5s3V2H0nTZcF5/JKMDu8++WP4T?=
 =?us-ascii?Q?fL7qfayX9b+TxR++PcQUEDKbOeVSDJJl8yMX52IYkJjQ5gzUOVcjhJO0Q32D?=
 =?us-ascii?Q?gOr0vu/ullRkBXuI9fnvDth2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4e511cf-fa89-43c9-7499-08d92af833ad
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 03:39:35.8609
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /ayIVxFquR4rCNM4+2rB9n6XgAW9YSCtXv3wNr7OWZumpnNd/Y5lcAPBJsg7mlaKevEXmRu7ULLbDkn/C4gXWA8DIFZ1nuled7pysIyF/Es=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4422
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10009 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106090001
X-Proofpoint-ORIG-GUID: iQtvgsuPJwbFPPoZb9jN14pIrKMppTXR
X-Proofpoint-GUID: iQtvgsuPJwbFPPoZb9jN14pIrKMppTXR
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10009 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0
 spamscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106090001
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the SCSI midlayer interfaces to query protection interval,
reference tag, and per-command DIX flags

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 59 +++++++++++----------------------
 1 file changed, 20 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 4ab0609a1b94..11dcd6930215 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -1962,7 +1962,6 @@ static void mpi3mr_setup_eedp(struct mpi3mr_ioc *mrioc,
 {
 	u16 eedp_flags = 0;
 	unsigned char prot_op = scsi_get_prot_op(scmd);
-	unsigned char prot_type = scsi_get_prot_type(scmd);
 
 	switch (prot_op) {
 	case SCSI_PROT_NORMAL:
@@ -1982,60 +1981,42 @@ static void mpi3mr_setup_eedp(struct mpi3mr_ioc *mrioc,
 		scsiio_req->msg_flags |= MPI3_SCSIIO_MSGFLAGS_METASGL_VALID;
 		break;
 	case SCSI_PROT_READ_PASS:
-		eedp_flags = MPI3_EEDPFLAGS_EEDP_OP_CHECK |
-		    MPI3_EEDPFLAGS_CHK_REF_TAG | MPI3_EEDPFLAGS_CHK_APP_TAG |
-		    MPI3_EEDPFLAGS_CHK_GUARD;
+		eedp_flags = MPI3_EEDPFLAGS_EEDP_OP_CHECK;
 		scsiio_req->msg_flags |= MPI3_SCSIIO_MSGFLAGS_METASGL_VALID;
 		break;
 	case SCSI_PROT_WRITE_PASS:
-		if (scsi_host_get_guard(scmd->device->host)
-		    & SHOST_DIX_GUARD_IP) {
-			eedp_flags = MPI3_EEDPFLAGS_EEDP_OP_CHECK_REGEN |
-			    MPI3_EEDPFLAGS_CHK_APP_TAG |
-			    MPI3_EEDPFLAGS_CHK_GUARD |
-			    MPI3_EEDPFLAGS_INCR_PRI_REF_TAG;
+		if (scmd->prot_flags & SCSI_PROT_IP_CHECKSUM) {
+			eedp_flags = MPI3_EEDPFLAGS_EEDP_OP_CHECK_REGEN;
 			scsiio_req->sgl[0].eedp.application_tag_translation_mask =
 			    0xffff;
-		} else {
-			eedp_flags = MPI3_EEDPFLAGS_EEDP_OP_CHECK |
-			    MPI3_EEDPFLAGS_CHK_REF_TAG |
-			    MPI3_EEDPFLAGS_CHK_APP_TAG |
-			    MPI3_EEDPFLAGS_CHK_GUARD;
-		}
+		} else
+			eedp_flags = MPI3_EEDPFLAGS_EEDP_OP_CHECK;
+
 		scsiio_req->msg_flags |= MPI3_SCSIIO_MSGFLAGS_METASGL_VALID;
 		break;
 	default:
 		return;
 	}
 
-	if (scsi_host_get_guard(scmd->device->host) & SHOST_DIX_GUARD_IP)
+	if (scmd->prot_flags & SCSI_PROT_GUARD_CHECK)
+		eedp_flags |= MPI3_EEDPFLAGS_CHK_GUARD;
+
+	if (scmd->prot_flags & SCSI_PROT_IP_CHECKSUM)
 		eedp_flags |= MPI3_EEDPFLAGS_HOST_GUARD_IP_CHKSUM;
 
-	switch (prot_type) {
-	case SCSI_PROT_DIF_TYPE0:
-		eedp_flags |= MPI3_EEDPFLAGS_INCR_PRI_REF_TAG;
+	if (scmd->prot_flags & SCSI_PROT_REF_CHECK) {
+		eedp_flags |= MPI3_EEDPFLAGS_CHK_REF_TAG |
+			MPI3_EEDPFLAGS_INCR_PRI_REF_TAG;
 		scsiio_req->cdb.eedp32.primary_reference_tag =
-		    cpu_to_be32(t10_pi_ref_tag(scmd->request));
-		break;
-	case SCSI_PROT_DIF_TYPE1:
-	case SCSI_PROT_DIF_TYPE2:
-		eedp_flags |= MPI3_EEDPFLAGS_INCR_PRI_REF_TAG |
-		    MPI3_EEDPFLAGS_ESC_MODE_APPTAG_DISABLE |
-		    MPI3_EEDPFLAGS_CHK_GUARD;
-		scsiio_req->cdb.eedp32.primary_reference_tag =
-		    cpu_to_be32(t10_pi_ref_tag(scmd->request));
-		break;
-	case SCSI_PROT_DIF_TYPE3:
-		eedp_flags |= MPI3_EEDPFLAGS_CHK_GUARD |
-		    MPI3_EEDPFLAGS_ESC_MODE_APPTAG_DISABLE;
-		break;
-
-	default:
-		scsiio_req->msg_flags &= ~(MPI3_SCSIIO_MSGFLAGS_METASGL_VALID);
-		return;
+			cpu_to_be32(scsi_prot_ref_tag(scmd));
 	}
 
-	switch (scmd->device->sector_size) {
+	if (scmd->prot_flags & SCSI_PROT_REF_INCREMENT)
+		eedp_flags |= MPI3_EEDPFLAGS_INCR_PRI_REF_TAG;
+
+	eedp_flags |= MPI3_EEDPFLAGS_ESC_MODE_APPTAG_DISABLE;
+
+	switch (scsi_prot_interval(scmd)) {
 	case 512:
 		scsiio_req->sgl[0].eedp.user_data_size = MPI3_EEDP_UDS_512;
 		break;
-- 
2.31.1

