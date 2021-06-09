Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6339CC48BDF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 03:39:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B6AC611BF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 03:39:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236559AbhFIDlk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Jun 2021 23:41:40 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:50358 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236543AbhFIDlg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jun 2021 23:41:36 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1592gTUE180143
        for <linux-scsi@vger.kernel.org>; Wed, 9 Jun 2021 03:39:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=TFcDVEIH4b+g1pEjoiW96kyt4PGXiX+/r5gFqcA9wGU=;
 b=aOSwrZobc7j/p2VHxMYwZ0OBy2KSNnBVRhbwkkHzcm+0JpOHkkJGCRobNzouKkkEK9lC
 +wlTYbNgsUNSAp9uZ/NQ86gm4vKol02sQ3oc98NApmtebphK2sSdaSarQ1Qh+GODUBcs
 tQkpovvikpzcHvVRDlrgXbZ8BYZnwq0L6ENEo+E/IMR1PvHc8gD614hpiL+Jr3NBt/sB
 cIgkrSKd1Mix0939oXavTHyQB+aEHtBLQKzlbZhM8mqAbeQJZuW3j8hxPoSYrC/vdNCU
 MzqQejAAMiPHovVLulhRe9KEbxzwxtV1I14uD8BnUifNmeUj2uglrWsxOrQFudRCesgR uQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 38yxscftdy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 09 Jun 2021 03:39:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1590Z3rh082718
        for <linux-scsi@vger.kernel.org>; Wed, 9 Jun 2021 03:39:39 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by userp3020.oracle.com with ESMTP id 390k1rhr1d-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 09 Jun 2021 03:39:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aJvd0rP3QRnD4NeA127LTeH7bYwprLI4YdcBxVnikAy+amXlt8jN5bSgGEqpcBJcvZD3HHomVJA9w7H6zGF+UiJyXzw+Aok4a65rnwAuiJSMN2aPbqYVTD8vLqV6ZaFShYi/aovSHakAe7f8alvDhh2HjuIqs6k7/WWr3DD+5+tWL2+h5F6feqz+rOg8itj1Ejtf9pJtU8MJ/BYs03qGs8zwUbu7LnVAuNt4IItJXz0Yoq/zmx79nzK2aKLByZhmZFXBdOYQTjemOQOytbXaBcXRExj2tTcFRBWAC+m6MoMu9pt/F1sHM+RQcNvSdqZinuiufdxkgI4ezhqjDL0Bjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TFcDVEIH4b+g1pEjoiW96kyt4PGXiX+/r5gFqcA9wGU=;
 b=G7ypfUVjjQe0fpRn54eifG2IisOkdwTPHsCStWhQ5EJB6lAknIx3Mg9iQ6KCnxEupj9sD+yFZ+arYSB+2WBFGzk/FyO8Z7yieNicbP5ykZr7RSspAVdkPDEcwKQZ3p0kKpXeqJiqIMfXBorqD3NQT96PK0rC9DNeJ1P2ZM+Vd2V8icwxjZalYQrEjdC5UKuCJiLbV1Jfx3i7eG/HSJdScQg+/X69CbfusBY85hRceNbRYvqNIudogtOzTGMmf1LKhPGrMJZx3BEKvuH+50dYUzlQcj+hGe4ZGV6m/NeJMUww620hGyYmmhteoEKmEhZcXTPLP7S+g5zPLnhtytl4xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TFcDVEIH4b+g1pEjoiW96kyt4PGXiX+/r5gFqcA9wGU=;
 b=up8smbluyP4Vpw0Hi4S5IGeUozpupM19aCKcMD6g37Gk9owmDlDJUpZtKf1UOAbM4AQMagyotgjpuYi1PWSTL8NivGRZRXdPT5kjsuXZ/njbyk68/8mPucLDfO5UAc+4n6jNsW47ZPG3Ygx4oRTL14drgon1INQf31Xprm8donQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4421.namprd10.prod.outlook.com (2603:10b6:510:33::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Wed, 9 Jun
 2021 03:39:38 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4219.021; Wed, 9 Jun 2021
 03:39:38 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 07/15] scsi: isci: Use the proper SCSI midlayer interfaces for PI
Date:   Tue,  8 Jun 2021 23:39:21 -0400
Message-Id: <20210609033929.3815-8-martin.petersen@oracle.com>
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
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN7PR04CA0034.namprd04.prod.outlook.com (2603:10b6:806:120::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Wed, 9 Jun 2021 03:39:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a59e0967-2599-41ff-41c3-08d92af834e6
X-MS-TrafficTypeDiagnostic: PH0PR10MB4421:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4421B4BB5F4F7D7161F95B228E369@PH0PR10MB4421.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SJr5X7uPkXVvy44vNVzN28hP/NgOx1MgpIHxY4wjwGLOrIgpjMep0/SeicVOCsZZnFVjlRstveJuNKH2xvj0ram8hLyxJlFpwMetT9EFsL54xy0tOAmmCbmp8gZewEF43bbj2xJ+jNq982rquRh1tVwP1XCXojvoCqt8Kf6NEjp1i2CmczyWEuxHCKWr5sQZy/gIzibJG9XUK8P99Z94zROjH5aW/HKw+WioGTsUWWDDsBBokqaVURrk+HfgBhCy3VyGJfcHcRUrKP6vSXTCzwgEXUPa4yhyMGTRtid5/Drcc1qvR4F6QaY7TbycrPcidCYAbtVUKwaD9LeT6pLbeNs05ceOSIxAWQNPupFFb3WAZIo3eMAUFQ5aGOaqdMiRW+Kl1i/w55AkiZdH0FO4fCM7oJJHzJahEDmXWFosObEdCO/3MOHcPZL4mWf2Ljr3EDaGr9kooSFg+GVWrvXT4iAmyx8sBYtw+bdasDTJ+Lf8oJH7Pwh6D1sxjMr2yyfQLOdtQ04oQv7NKJxYbYdrLPK961Fb4VvEsSB03Pjw5OXYmqcy8gfbEQDXgZgUkqLHoMuaj0Dgn3eqWHooq1x49w/1j0UPh1VuRaLKjETGzfwuGeRAsl4Jcml+sgfWsWR946ZyCrhCUwPArteRHlSqaw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(39860400002)(366004)(136003)(8676002)(956004)(2616005)(8936002)(2906002)(6486002)(107886003)(86362001)(66946007)(52116002)(16526019)(66556008)(6666004)(66476007)(6916009)(83380400001)(478600001)(26005)(186003)(38100700002)(7696005)(38350700002)(1076003)(5660300002)(36756003)(316002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lNo4cWFKEeJ2azs+tnwN2qFXGYFvxe/WwY6ZfVxGPCHuFOdCrjOqsgUK+hiT?=
 =?us-ascii?Q?haRV8fBYDKaK5ui3U2t/eXoUshkGN3sfAnb31Og6SdChkPpTko8lkzFoRL9v?=
 =?us-ascii?Q?9b/dvGRBWxi6cQtn2o+W/2VZ0iBCqPSKr5gCzcZ3clfIQRZPn4MD1rW/BGA6?=
 =?us-ascii?Q?luq3qsvJHvvTY/XZ8bO3hhRXFdlXMKEljTtmNK9miwZIrBuTJf8MAwMeOkHj?=
 =?us-ascii?Q?VzT4e4C/+8aAApTcKJPDgJQBcoMWOz6poo0LTTakBlR2z4m1WYy3UheNVkcR?=
 =?us-ascii?Q?IUwaa4C021sPMV7cgal/VQYkYXAUh+5+uXfHtKss1ej1cUuqJySRcAbUvvge?=
 =?us-ascii?Q?Xp1EbpA9250Bcv2bHMfwJm2MpPqxCLkG9svkrEDiwRcpy0xXSec2IN3OJO09?=
 =?us-ascii?Q?5HjSB9LqfK2h8mEN9TbZjBSdxKvuD30xtdikXx/oZ7NWBGccuJQ1QIoF9Sgk?=
 =?us-ascii?Q?UG1Mn2miiSFKGK1nIRe7dfwsi4ocy8DX3mA0VSk4jxvKuXgxG15R+w6FdlqY?=
 =?us-ascii?Q?1ccWGI07XRd5PIVDX0sD45GHCWt/lQ7c4S2DCE9E+7CgfnBoDXUUspMvlse0?=
 =?us-ascii?Q?1CaYYa9/3+HSzWd+wvRzwCmy8lWOw+uuVWneScnGrLN/NRTjL6FTLDOlZE4J?=
 =?us-ascii?Q?/601yuMFhDlhX69PkBoePbhLYtE8FxwnXDEoxbRu5gPK0wyzTC1hY0n1t5Fo?=
 =?us-ascii?Q?yBbN6SMQf06oEcPnyHcr4djGN0yVjyb9dLt2RhzCybVZPYZ30QrVhYkcwQs2?=
 =?us-ascii?Q?fsGUR2k+BP78viibBYKtQO7KSRopcbZOL32eCNEqDCW3VrbCpOAZeTi+cu7O?=
 =?us-ascii?Q?RLHCcDRcU58YO89ZGEkFUW/PPsFnzWeQqfl6rCHXY59BnR9yeQPQGoqOrr0H?=
 =?us-ascii?Q?9l+z8fhKjctKPs6+kkNDRfvJ0/axAkTWsfQIJPt6mc+7sw4vmmFidm+jHHIj?=
 =?us-ascii?Q?Z6w3QoNeH1/qZ5aj252BVS9zAz24khAh0yTma3PUauEji5XHdXWTmt5exAfk?=
 =?us-ascii?Q?Bonc7QJ4cVZKZqgK7hSvEtmSUBTa0LFUOEbZQ8W6bw+svh4y0o1BdAOEVTxb?=
 =?us-ascii?Q?aFAJauyyGaDR7Y6gLhifdQgT0/BFst7NDnRfMKXHz/8vhFOl4/VVFL8r8Uk7?=
 =?us-ascii?Q?6jLeEfXh++2+VSUuQWfm44oeUh4zY4m7qBmLD0D3rOf6k9ApyzbRLI9ER4f8?=
 =?us-ascii?Q?2n4Mjty5lREgECykocuJ4eQmedborVfhdiVswFqQd5oOOlnMHI5RZ+//Sdzb?=
 =?us-ascii?Q?hTjdobsxxbAJ+zNhFCSKnF6SK9j0JkjauzNDNdDZAF4UVdnALWzFzvDstG35?=
 =?us-ascii?Q?M0AzRs5Y15Xe65RlCjw7oT1+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a59e0967-2599-41ff-41c3-08d92af834e6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 03:39:38.0015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B8QyLRWEow5XH6Ryr8qZbLQc457DX2tM+uEyt4Ozaj33qw0dezeD0I6I01sA2Wk2YHjC6EKty0F7ELpSDkTxwdUP25CtiuEp/dXZOQispGA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4421
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10009 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106090001
X-Proofpoint-ORIG-GUID: KdpEHmlfs9YX-YM1MI890XF6gE2FjBGh
X-Proofpoint-GUID: KdpEHmlfs9YX-YM1MI890XF6gE2FjBGh
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10009 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 suspectscore=0 bulkscore=0 spamscore=0 priorityscore=1501
 mlxscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106090001
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use scsi_prot_ref_tag() instead of scsi_get_lba() to get the reference
tag for a given I/O.

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
2.31.1

