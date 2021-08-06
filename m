Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B57BC432BE
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 04:00:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2819E611CA
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 04:00:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234933AbhHFEAv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 00:00:51 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:49056 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231388AbhHFEAt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 00:00:49 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1763v3ZS021412
        for <linux-scsi@vger.kernel.org>; Fri, 6 Aug 2021 04:00:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=9Ypisb0+vvelrTwcgD35F6/OzT3ZOBfnw9z47Pipow4=;
 b=UFSRLXV4gazkQmapi2O2hgBCIJdw3pRji2L5HVeP4C2TYbgKOmlXck+ZK0OWhGTbgZJq
 V7enL3ijStMLZVZSTnFD2JX31UHjHGpSzjiu/8prhOpJP4EAGmmowKhGczN8h0o10ELs
 u9n7LzktUOSxeiZi5rICIx4QDUahewXmhe4R/pL4OOVIIwq8oGEH7AUQH64jPxQd1J9g
 uTwxgSgFXW5a40Sq1ZMp8+KxtbqdsRTXKsGXKK5/SdJqh6GWmoa8NWFGc8a3kUPoSG5P
 V7spzNOuti6I52PTfdcu+gu7JJpiFI9+7VA4t3vHaytNXw+htABSsw+v/fZi10wnGokc UQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=9Ypisb0+vvelrTwcgD35F6/OzT3ZOBfnw9z47Pipow4=;
 b=yGzfBOosmC0H1cTbp45nVHAGVyT9eiggw+3wt9x8PRg5kqmkgWNk+zjj9bG3XWGrCWBQ
 QfN1aZQh5AKqsOE4lhRlMfGkEJmipJVepIS9alXGEFzS92ZNuMka0AHh0FisUNPlx+zv
 GHMI5FvkJUwXR6P7ceRZmz1QbzAVnaKLT63nuL8JYiZ4+luvFW8LICL+A8RfEroN7AVZ
 SSaiB98IWm/Bdzd5GXYTpPfImjD7/0s3r4njI7neKjQ6FxoxB0WfBeHIAoZQOq+1luIb
 TmB1TxjTgDGW71C0AOa/IWIdfUm4ZIZ7eAM1hHy7MoiKW8Ka+jmMfGuL6/WSaX5o18oC yw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a7wqubvm3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Fri, 06 Aug 2021 04:00:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1763tZHI085580
        for <linux-scsi@vger.kernel.org>; Fri, 6 Aug 2021 04:00:33 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by userp3020.oracle.com with ESMTP id 3a5ga1g8hs-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Fri, 06 Aug 2021 04:00:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FoP7EiJ7u+n9uYyF9ciMUhKO8hMkdUfgL3ruunSvk65KhA01TeHXTF371K1+yxDs9nAJCpph0T35D8sfZ0oyu4l0/ED/K4dglT6se68Tq+JlCSrd5C2X/sz7hzT68dgpYJf55JcSnsQzkArrFL7uPcS5cuaan8o5lh8VsxPbsNJWdHca0Df9iEkvlX/hmYdIKoz+MdurkCPQLVFKeDvnF7i7Cju3bk1xb0YPM1WpVOeLPXwy+Zm7eZXW2yQoubRPnWYlRuaQzC5vKGK3Lruad7pwEqUpj9eLq0W+Ewsut49odIS7qROlw1ccNZDbAWT3wo6cuMYVZrsJZz/7ZRieRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Ypisb0+vvelrTwcgD35F6/OzT3ZOBfnw9z47Pipow4=;
 b=cmD0kGUf0fE2PyjFPTgv9G9TWHDlg9FBTu11mQ39hJ5P35SuALIm3vGlwfmAQFEjJPmM4oPO9CD3/8kxV5LReCBmQr2RnSAMwHkhK5eIJCu/3GoaJzG6a+yzVCsZp7UvoG/KLoQEx1LcjhWD1Ix3NkxHLh0lGUIwLDVURSGslHaJ0N3DGLXqhBFlI+hM6PHIDKB5nt9Y7ia0XInvp89wdCL41LvOeZH9BDthNMu4ydlBs9dYjj0xD6Z3OiNW2fRicjGRVWzh2bZaEMkYAAJeyZgb31bHoR+X8i810Y0LB5G3Gy5dL8zox1GaxEElT21aR0GrfrLXYZTpuS1hzBy24g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Ypisb0+vvelrTwcgD35F6/OzT3ZOBfnw9z47Pipow4=;
 b=IDot6fZHQ04FXSnrLHUbmSZLlCbaENmD4Sb4c9qo+NAtEI94kn0EfQZq20FdjAwWjOQz3CMjKxi/UVL4KaNj5H6s91s/LZ6pDpMHvS5wbNKc/TObVn0f+N/0eYB+gGXQvWKIinsnW2PtJVgmOfCKxjc2MYEXY0PQvIwKO08RNAo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5515.namprd10.prod.outlook.com (2603:10b6:510:109::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Fri, 6 Aug
 2021 04:00:32 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4373.026; Fri, 6 Aug 2021
 04:00:32 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v2 2/5] scsi: isci: Use the proper SCSI midlayer interfaces for PI
Date:   Fri,  6 Aug 2021 00:00:20 -0400
Message-Id: <20210806040023.5355-3-martin.petersen@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806040023.5355-1-martin.petersen@oracle.com>
References: <20210806040023.5355-1-martin.petersen@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0601CA0007.namprd06.prod.outlook.com
 (2603:10b6:803:2f::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0601CA0007.namprd06.prod.outlook.com (2603:10b6:803:2f::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Fri, 6 Aug 2021 04:00:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 36a394f9-1da9-44ff-0a03-08d9588ebc70
X-MS-TrafficTypeDiagnostic: PH0PR10MB5515:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5515AD9CD1DD39AED50218B28EF39@PH0PR10MB5515.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DQnDw28IxdHR9/f6/hxZ3TRR5rXck4xsfryVtMV8NjNKdOKV0DkqQ828t50KvKyuMv6/xWtl6R4wShT+jGw/BgFLso40vXPUCXtqMC1oKLIqpi9tvr3MvPVihtiHjds04Svn3wri7UYpzSvwRJf3Vi53JfyzeRCdPQPhZQ1xPlpa9D/coelOpKu2FpdaVLftN6LJwavhSePe3aAH45L6DZYie59tuetJtBOsCvT07mCzSdSle/GDcMIBPyC8ITqtxUEaC7I0wwTE236VjhhEOxmV0bKtywAESf2iOZi10V6UTo/ADIf/9G0s85PBxOgUP4ucdkLp2y2PDOX/H3qJ5uVNwJXJ241HmPpTzMEJuWspLnifTI6RvbiwqX/laz2BO+DtNMZJ2NqRkW5pUuBTcUJaM6roYrxyZKqQA3Aq5tBsu/R9D2XlCjCtmEYRoZf4jck6zHWfM9ZP/nWAcLYyxDaTeCzgPgviQR2ZgWQK7KigVBciQj7uKItMs4eO0V/0YH9qJTBIZITqiypW9a2fIp9Ixk2kYkU7sVAlJ32/9ZwFmyMhICP2xkACP6Xm9MTSZymhRGhCaBVecStlvVg7FcyNCRRiHsDKsWMHJKppzjKZhFt903gR+CuN/CCGzy4t8dBrOdW4xz6m9EC5K1dA36wCLWZZpFcQwkGaqLhs/tse57jsi8yRAuCzaPqc6dPIynY/7oeB+UXcTQw1jZ3GHA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(1076003)(8936002)(66946007)(8676002)(186003)(6916009)(4326008)(66476007)(66556008)(26005)(6666004)(83380400001)(38100700002)(508600001)(956004)(316002)(107886003)(2616005)(36756003)(38350700002)(2906002)(7696005)(6486002)(52116002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XAtBPF6kOj6xZMKssqzzZ2vzEei43XCfZ5rQP/z9xSgGqkwOPaJY209CJsGH?=
 =?us-ascii?Q?1RXTszIieL4s5BLHZpxABWiUTzTuxBh7HBNoaZKvs3hGeVyidcszbb6nmtPw?=
 =?us-ascii?Q?XrDZ1F4QtK5MqQegttkDAFK5YpSq0+YqtVSljsnAwYzKEbr+pYIDM/4KtgNL?=
 =?us-ascii?Q?r0vowTLQHpZVDqMxInwRT2MxWWV8iEFTJlqvV8ToJCxFzyCr6D5hYd5fGt5t?=
 =?us-ascii?Q?29quR3RXxNi02fuphm/Istj6zUrbI+PtTyFk6JST6OeUt7wL/NitqawCj7vz?=
 =?us-ascii?Q?Cn/bprfHbMp0O55KXTKGUvsA9z7iXwHOjIIfFVtGJiN634WA3pu4BSu1udxI?=
 =?us-ascii?Q?45aEHjWd/+jSK79eVzDTRDPPvlx4T2meHPD4EVkE44IirPvi1JS3CZgey6qi?=
 =?us-ascii?Q?uuoMQYE5kMHqr8rDTWTFdamDZv+wBTX/aYQlrdWUJJhpR8OS4kULzEWJslNr?=
 =?us-ascii?Q?CSxmiNh7erSKm6LiTBh5/Ss900j1eUBsRrxAywAEBjWglru15ppTUNQFAsKS?=
 =?us-ascii?Q?ea9v9fNEtQswbipwM1PZlr1Rsr/WUMJU1hrZBH6+sHZhIDkWKgaBPqr27Ex8?=
 =?us-ascii?Q?Gak9Vz7r6GLAWw+9RhbhwAPJ8DBKY4M7gHwGNth6s+XVNIxQQJjkISU1Vljs?=
 =?us-ascii?Q?UruUsri5pPx+Mzj7Qkn/iCV1/mNYZLRQXNvJt1gWISsD0qbgbtDj+If1NCbJ?=
 =?us-ascii?Q?6/Z7Z3xck74dDO1BranfCyWrK1lKjid+uLSmjWLmAlUIc5XMwgaGjYYuSTrv?=
 =?us-ascii?Q?0m54gEsOFBiL/qXQSgM6k3MxN5xxVtzh2vvTx3MiHgGaqEEmUtgx6pjax8Q7?=
 =?us-ascii?Q?6RH7DTZl4e7LMq+RvXf/2fJByLbP+eZP4R8ZxQvMe/07k8CGTPT02L4WyDOK?=
 =?us-ascii?Q?aYDWCKQK5menJGgL3Refbr9m8xpzzruRhlgz0N1ISbvkQXp0aSthtknw7j6g?=
 =?us-ascii?Q?K3L4FBcR0Eokf17o4hceM7EGCtyTK+d97SOHvkUAU4lB57C31lEGZ0DuGc8c?=
 =?us-ascii?Q?LrM+WlV4x+UeDpSusR3Lw0n2IgtNIxW0CQlUIrvgpQxQTSIzTSf3bxWeKHKG?=
 =?us-ascii?Q?A5LUTb6NEoabdqRTUvtgB+jnQEG1wFI8DGq0jy4rDSLwMLtKUTDjPULKMT/M?=
 =?us-ascii?Q?DBImGJe2AefuVapuYMRXt+YWmbJbe03YcGIaj/2a77pCI3tryjlovIPhrIeP?=
 =?us-ascii?Q?KzNW4USx6oRfRLqI+UCNep/3WrF/a+U50bn+B/OfItrNby3ViJ0F63D/MHaT?=
 =?us-ascii?Q?NZ7WyfhZifOCgheFusu4qfGYr4flPvMKcizGlu+e6SvzrckKYD1GF0w2HRnO?=
 =?us-ascii?Q?oT16aOLq5NUiLlxsVCGXLMLW?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36a394f9-1da9-44ff-0a03-08d9588ebc70
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 04:00:32.1706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: juc4uDwh8k+7Kc3OfKD8X5yIzJemKcJT0Vdz2YXFbmgeWfCJ+SvGrBxSy37GTAr76TDxpRhXWEpltYP0WrBtLldjO9P1vv7H8RSJLlLHmLs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5515
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10067 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108060024
X-Proofpoint-GUID: 1DQbo6mwGZCDzMgIJ_gNEmEHvq-ZcX2a
X-Proofpoint-ORIG-GUID: 1DQbo6mwGZCDzMgIJ_gNEmEHvq-ZcX2a
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use scsi_prot_ref_tag() instead of scsi_get_lba() to get the reference tag
for a given I/O.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/isci/request.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index e1ff79464131..fcaa84a3c210 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -341,7 +341,7 @@ static void scu_ssp_ireq_dif_insert(struct isci_request *ireq, u8 type, u8 op)
 	tc->reserved_E8_0 = 0;
 
 	if ((type & SCSI_PROT_DIF_TYPE1) || (type & SCSI_PROT_DIF_TYPE2))
-		tc->ref_tag_seed_gen = scsi_get_lba(scmd) & 0xffffffff;
+		tc->ref_tag_seed_gen = scsi_prot_ref_tag(scmd);
 	else if (type & SCSI_PROT_DIF_TYPE3)
 		tc->ref_tag_seed_gen = 0;
 }
@@ -369,7 +369,7 @@ static void scu_ssp_ireq_dif_strip(struct isci_request *ireq, u8 type, u8 op)
 	tc->app_tag_gen = 0;
 
 	if ((type & SCSI_PROT_DIF_TYPE1) || (type & SCSI_PROT_DIF_TYPE2))
-		tc->ref_tag_seed_verify = scsi_get_lba(scmd) & 0xffffffff;
+		tc->ref_tag_seed_verify = scsi_prot_ref_tag(scmd);
 	else if (type & SCSI_PROT_DIF_TYPE3)
 		tc->ref_tag_seed_verify = 0;
 
-- 
2.32.0

