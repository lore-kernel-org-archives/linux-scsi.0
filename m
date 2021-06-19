Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62D4BC48BDF
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 02:40:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4110961222
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 02:40:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234653AbhFSCmP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 22:42:15 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:24546 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229816AbhFSCmP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Jun 2021 22:42:15 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15J2UrIf027876;
        Sat, 19 Jun 2021 02:40:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=uEOvkZNBZwuSDQpB/FhSVBQN4l/1whAsJWQZXc4XH+I=;
 b=rm6lZhtLaQXVO+d2rMPEJ0hQv3W2xPtCXUVebFH9aqrvfNNyvZxybfpaLDlKH3nPpFB+
 N/SHWWTWcbpfL/06yJNPqzwuV4maCfTYy0/xnboYB8RyLAS/xLskVcaNQR70TGp4gWzL
 MLbBYd2Nv4cbhRTkvhAfG3fQflrXLyUyUtCSPRIeqd/dID6+7uuwFJfdCPYOEy90KiA2
 y5F13JjuyH56lC/9Rnzh9NW9qWGXiGi6hCeaveBzO/R7uAjDSyBDsqX3zgt8v7AdiAEk
 SkQwAixF5cw7AevaT6eN3s923bqcbolL6+6H3piehFRFeMlgSYYvmP96aLMOeU/FhoHr Dw== 
Received: from oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39976000x9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 02:40:03 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15J2e2cH112519;
        Sat, 19 Jun 2021 02:40:02 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by userp3020.oracle.com with ESMTP id 3997wk05fd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 02:40:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N2KGNvQ111pRCZOVMGnFE/Ll9xC5meSfsZxphpC/iyOzTQFLuoNGMFyE974M1J61mbtIYVGOJ0uZ2ZL742CSVmaACunrrfXspJuNSIJf9K5iHxn1nrXf7XHtrB7m2GV+jUEBoR3ZCq9PGtDZ32oVeLKrRTfhsYb8C/Wn5u9K13p5CJH7S9m7Dh4DCE8b6NBUqY0bwGRYx0w9Zq2nEaCKG+KGEHUe3aXoNK05/WS4faLota1BTuliumVjoOxzcX5Pek67QagKCBrEb9D/uFHbY9LZoNj4DLiS32TmZ/ZaU1VmxlIj41wHCWGadW/sOgZduroOkUoMPr6a3LaOykhzTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uEOvkZNBZwuSDQpB/FhSVBQN4l/1whAsJWQZXc4XH+I=;
 b=UR9qfMXV95YeGg9D0w1cvtaOp2OT0ijRIDSppYBLg/tyJwE9DoJU4a2NmBc7QGb/WV1A7XPumVu/ulit9DazrPP1FzHUPJOHlZLjLLLclCqHmwqoEEJFRtTW3Bo0Q03SlzQCxN0V0PrxLD5O6wnlmrbFjPKS4ob3OEZUYoLylFKhjrz3NBCABGnTyIFGqvbvwVHODddG8kpAuPL0JAywnjdrCtZk8RICc2TvkcJv6Ew2pkiuX6ZzYEqbywyo4yYXOQDLDbrBgxi3VykvkZ6gTuakcvOkPBDjZIP5JSoSeFAU9cAzYKH8HjphPsNxXag6VRO78jNHf+9mB4MXpbZhSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uEOvkZNBZwuSDQpB/FhSVBQN4l/1whAsJWQZXc4XH+I=;
 b=uRiVrhLDjF4j2y6I3kuz0qshT06DRmOruh46pH7A7OKYBFW+dKzEpLzu+B8Ft39XTuOa+AAroocJLEeuk5bZroD7uT0O6mLSIedyfkuKCUryWIq6GOicBkSkS5i/lTebR5zwhFmgpJBjeJ1K9Hz0YchJSbRTDtG/0YNCp9EgLx0=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4597.namprd10.prod.outlook.com (2603:10b6:510:43::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15; Sat, 19 Jun
 2021 02:40:00 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4242.022; Sat, 19 Jun 2021
 02:40:00 +0000
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, ram.vegesna@broadcom.com,
        dan.carpenter@oracle.com
Subject: Re: [PATCH] elx: efct: fix is_originator return code type
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14kduy3v2.fsf@ca-mkp.ca.oracle.com>
References: <20210618231524.83179-1-jsmart2021@gmail.com>
Date:   Fri, 18 Jun 2021 22:39:56 -0400
In-Reply-To: <20210618231524.83179-1-jsmart2021@gmail.com> (James Smart's
        message of "Fri, 18 Jun 2021 16:15:24 -0700")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SA9PR13CA0076.namprd13.prod.outlook.com
 (2603:10b6:806:23::21) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA9PR13CA0076.namprd13.prod.outlook.com (2603:10b6:806:23::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.9 via Frontend Transport; Sat, 19 Jun 2021 02:39:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5151edf-80b7-4f1b-13dc-08d932cb8880
X-MS-TrafficTypeDiagnostic: PH0PR10MB4597:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4597C47817B68B140928FA638E0C9@PH0PR10MB4597.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WIw2Uq75tPW/xoj5p8g2RC4giar/cpF35lxyPj33tdH1EwK9u5trHBh5zp34+8bbTpw+JC0p5+xLWmNBQN00s3wsVLunckhMG8bP4lKb1kErTB74CQD0KDNw7wtXxUtnG60miEje0lLN0AH2IKT6FMmAZr4ZKj+jn63s+YzSq7QEV5r3fHLeXqeMwnJzzVbLW+5FuOvLqpQWEpJa6Z8IQeUj155IDJLAgxv+LG5ED6R/uxQt/90RybEDdL2VaWhJOmRgQAcFfqn1bDcGwK4XWRHozg0nQDAlzvIE/dbdItEBpJBJoHQEcCKzqASWhuFyF7QeXPJOy+BX/cFuOe+Nrc9dRHG2TCTVq8szP2LoMhC+u8Bp+B/jCd/Wi9X7qRmGBuj96L7kaJqGOo0rVgdr/Gn4U4hureP03TYIAyvJQXQOmsrNxGIO/4KEqoitrD2QdUDQIvGKU5tf+3kFoHJj1/GfEXXN/2WPDC/LFguxLN+LbeRc5HeagyjgoYpQVp3wYZrJCWoTrdLF65bP/XLKs+faxBPOViItbJ8ckPPz1d9VZxxuJdKRJEaN/P6VwO7vwXTenxZNae/AkEg0TuHdqU7WhYLAfF3Z1m35iJv4+Ri+9/su5kjAOEm20IYiCesGoOD0tWbib8UxVVX5zGRweg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(366004)(376002)(136003)(346002)(66476007)(8676002)(66556008)(66946007)(8936002)(26005)(107886003)(86362001)(36916002)(4326008)(7696005)(52116002)(55016002)(478600001)(6916009)(4744005)(6666004)(186003)(16526019)(956004)(316002)(38350700002)(5660300002)(38100700002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q2DlUeaT9UOCLrryAdVhSpix4yHStZp7WfHMdajIK8k8TbHJR7YDUCry9lMF?=
 =?us-ascii?Q?YyPmhi9PIAr8uk4nlKIoAZYwB7iXycLaHAyJDZeRPL3BGfJjKGRiCojkalzq?=
 =?us-ascii?Q?rRIx1LaS3cpA64vGxr+xTdFMysWRfKD6WTjf6zRcd0c3ZwdoKCu2Mzr87bTL?=
 =?us-ascii?Q?iuW/fwR13A/unbVcTIqNM6uJKqgVQYW3dk0fBRzL9+izKS3R9pcWui0SfTQk?=
 =?us-ascii?Q?CdDgASDGkZemmHoWxrLNLEx3TWmHfzM0MLxnq9uTHD2Y7/ySnw0JM/bR4zH3?=
 =?us-ascii?Q?uL+CHRDX/2WCok6Zr4E00KSb5Pp5PfpdaDMflsHjQcqS9A1Q43cfmsiwp6FE?=
 =?us-ascii?Q?hmM+LrrZEmVzz/H0JTUpq5skvyLN3oEfdfBuPCdhp9DTYgVFPLJTbhLzbmE9?=
 =?us-ascii?Q?GtkP3VLgyKJmLoo3Zk592uyKwvCzqxDif2vlluwuNkkShgplbxhLX6dmWs3p?=
 =?us-ascii?Q?XagEWlOCNn0qGus5/sDjRmuhdiiTFKFHr9BCsPxAoPGIfiuLuQOy4Kd4pphf?=
 =?us-ascii?Q?XWKHVr7VsFsSoaVkt96WDbChUL0JSRq1OarPT6dN76iKBo10s/MLtyKMd9N8?=
 =?us-ascii?Q?H/23PfPTmx66Gmz4fOK2ZLs+ckUB75oTwRB7vd/YGYO6hr8vU4CU38JFqEMg?=
 =?us-ascii?Q?RegkDLMpqL9WOhL47a5vjtTA4aeAxiFfqv1FwI6mDfyqRVqUNGxIAI2LOiTa?=
 =?us-ascii?Q?iJrmwmSIbdHR7rk0+3LjkZW+AGU6Lm1QSmQMi5E3+HFFhDlz+vPwp7asDbZl?=
 =?us-ascii?Q?z7fwjTQIAU1o15tW6fiYzea6y2rAgZ1NJaCE79xoQNWkEr4hDI+yU35TpOlm?=
 =?us-ascii?Q?aGM8rbuAb0dGmvwuyCZT0vUWsBNCTQnFGAdiNRckTrQkKH33f7iDf4CbNNvb?=
 =?us-ascii?Q?Lexvipzm7a6uAbQ0M+k6O+YoAf5XQWHhy7BT2+7gQ3xET/KMDwYzmkBTeXVJ?=
 =?us-ascii?Q?AbEY2K0q4SMggUdMsDcoxre2MXpEOVHrUZdZHDHUp0l3Gmji3fgqoTiFmxrE?=
 =?us-ascii?Q?Yhx+YyxWhD+jukTmQLEP23ctCyfiub8asYvHStdUgjRiPWYWcKYgXf/+HIoo?=
 =?us-ascii?Q?9otlUChesp8nAYez3LjfvqagwjS/UNwOyqnbQ7qBStfnxfxrBwrEpGosGx9w?=
 =?us-ascii?Q?sPoNbMKAxD6TxkHFB5Fp692NzNKob2ReFZ4q1utzHk6ChvevNtwVts4A9QkZ?=
 =?us-ascii?Q?NR09/Sz8AsleXD6tLBJ0kMtrmVSXkL8coEaBtQRNpZ5fAGe0e2rk+YwJMC9Z?=
 =?us-ascii?Q?rQWamYmg1up2LNytwmKmyH7azLRwLONs2BkW4df3o+COkYFhLjGfuXBiFI89?=
 =?us-ascii?Q?qYnlrWGmiFkY8fPYRX15++uF?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5151edf-80b7-4f1b-13dc-08d932cb8880
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2021 02:40:00.0356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +cZHPTE9chmUpE9OcqGM5JxJK9p2AkVBdTS42IqF89z4EqeHjI9QjR2EYwR8fkxJpaI0x6RB8Nx/WdYg+ViMRn725aVW5OC5SSy4ev36Tdo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4597
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10019 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106190011
X-Proofpoint-ORIG-GUID: VmMLqyhhO4ytJPf2EKB2enh0EO7mA4me
X-Proofpoint-GUID: VmMLqyhhO4ytJPf2EKB2enh0EO7mA4me
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> efct_hw_iotype_is_originator is returning a negative (-EIO) status
> which doesn't make sense for a u8 function type.
>
> Reviewing the code, the function only needs to return true/false, thus
> a bool status is most appropriate.
>
> Change the function return type and patch up the one callee as the
> bool inverses the if check.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
