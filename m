Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2876C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Nov 2021 04:04:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C320361215
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Nov 2021 04:04:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241959AbhKIEGv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Nov 2021 23:06:51 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:15564 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241554AbhKIEGu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2021 23:06:50 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A91tiOu019145;
        Tue, 9 Nov 2021 04:04:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=oKlTQgjr2qzFiERmYS4NWRa8pQJZH2FJ7Eq/0CreHVE=;
 b=ddkNb+b/VfHMtUPqKR/3pWwNbGZZDxzXNYxGMvNtO1iO5+UGWWkDiOWkn3eNPxrJpoYc
 TDDUN7/8gNRIqzEY5dFQ3wPVwv7HchuYSvs8M1FbJaz5rUhTzMHipIjUsq7oxOVKBq+B
 cfmdOGVBEA0qpF5BrUFAbikU4knVo+eXysOtVCtnL4n6Iczu6ZOZbQfoFXCzjDWe3x60
 gi8uKp1sEbij186hsG3d1G3DCFnILk6e2M0MKfeJtwGYUvgp3iwklsTRrKlv61a84ve9
 on8vHOXAI5R2ek0m4Z4URafn/vZ9u1w2YH3hv7fmEpQnxMizn7vj21PaBKrEg19ZVDU+ FQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c6sbk82kk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Nov 2021 04:04:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A93ucd1076483;
        Tue, 9 Nov 2021 04:04:01 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by userp3020.oracle.com with ESMTP id 3c63fsay1b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Nov 2021 04:04:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eVt3uhelCiX3MmPxLMvMJEGjwQ9dus8Z898jVHyyJWT7XJADoPHb+wGsmA+O8qctj+RmRiG+EbB5f+U4xNJNNjJejFI5bX8jYdKIDWTqoc+FeGmVaUC1r/XRuDZs6qt8744u9hlIVayyQHGQoK8JSlB9YAMWdxWG5bZFL8T/kmhPGDpoLATa03DwA2zyeghMPpo+mxg0anz6diKrkMY0quDrJfNwNCEQC1pA8oR+LL7sh5oXxrGinl2RN7mF7H3ydr1C8XB6WTLbNpQkxoTs3cHKzqjc3epGjCI0LBaQ6pCg/9NnofP3PI4G5eIPiucP5uzWnTCz8Vk65sVmPfXkIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oKlTQgjr2qzFiERmYS4NWRa8pQJZH2FJ7Eq/0CreHVE=;
 b=hkf1bfksLVCcdhhnVXoW/Lp7AtikW7UqMl/yU6E8daCdPYHIhWCaIYbBPnfCLFZCEkPoG2JUN7euU5uFtFhjsReXxZLP0SfK1xU6ap37DFW5Mj7dZXRxFAqTvdP8ozWwcoHjOH1swR/XSszcwBzd/l+Fj7v3DDCl8s8hCH0RH9yDIacip1cyiQbDWF1RwYfSHKeu6oCsVkf5RV8cfvIDBe8BxadAsgNMHaEmo3n8yYqztnSeue/BQ5QrdqEAgv2Efm1bbRdt0lEqBOHIwKZzr/fh3gdMtNR4BNC0Jmr2g9ZpS0aDg3K4mAUm5c7r9WPWElVOYpepS0envkbIMr6J0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oKlTQgjr2qzFiERmYS4NWRa8pQJZH2FJ7Eq/0CreHVE=;
 b=f4iVSkXa9ubNnsJ1QKoetWqH3QTY0V6Yrp1q8P1eGWOK79O/xhTnT6RYSPt5A8EjYKoNo9kFOIcknzmC+w9nZ/60LMK3OzL63kCDc0Ylt4sVKCsFxHwJTmoADY6lJrOe4yffs8yN3+rasDOHlHHVshdlHJTY/MtkE1CzFEsIvW0=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4519.namprd10.prod.outlook.com (2603:10b6:510:37::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Tue, 9 Nov
 2021 04:03:59 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%8]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 04:03:59 +0000
To:     George Kennedy <george.kennedy@oracle.com>
Cc:     gregkh@linuxfoundation.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 linux-next] scsi: scsi_debug: fix type in min_t to
 avoid stack OOB
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a6iekmap.fsf@ca-mkp.ca.oracle.com>
References: <1636125055-10909-1-git-send-email-george.kennedy@oracle.com>
Date:   Mon, 08 Nov 2021 23:03:57 -0500
In-Reply-To: <1636125055-10909-1-git-send-email-george.kennedy@oracle.com>
        (George Kennedy's message of "Fri, 5 Nov 2021 10:10:55 -0500")
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0001.namprd05.prod.outlook.com
 (2603:10b6:a03:254::6) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.57) by BY3PR05CA0001.namprd05.prod.outlook.com (2603:10b6:a03:254::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.5 via Frontend Transport; Tue, 9 Nov 2021 04:03:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a27d75e2-c843-4d1c-93b7-08d9a335f551
X-MS-TrafficTypeDiagnostic: PH0PR10MB4519:
X-Microsoft-Antispam-PRVS: <PH0PR10MB45197D52814A746CB02BBC978E929@PH0PR10MB4519.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RfgtnVsQrzPyRQYs8aIKDs7PldG2QbkKiCSUXqnsikf2rBpmaRBon+H8Y6kQo9ZknAVPQmKhNlEreHOc2NqxqukK4wWywLQDZSz5WulojoOTjaBC9Y7oKx542Z1UCqKLC+qh62aPNs68iDJa4IdDZ2MmBguwMa2h4QXftPFEDX4NAWVCjlpdyql4e8FtcOkmxvIejtF5i2oFwSuFYNfVTM2EuG+CvXxJJeZoBNqkhNxSG6ZcmivwjnAFQ2ODmvYbcykrrpLg4U+ks4hW/t8mEJmkbemXfuUwqkE9efL1GJgOtAZCkhEJcP7B8HaqDG5AfcPqAjtauDEdsbIeMt4263H+1/40uy0MtNaQ7YGQQLDY5FMErQcLI8p72WmDut6wP4AQ0vor5zBi0DWPr8ureCHM+srEdRYTxFbOWGKNOK0QkHbd4d/mMSvNLKjVqcUij6k+mn/6zHynUBYy3dVU3DaxWZ6YwCXwbGW5wxuUb0vVapk3LunTbe1boIsnfIa/KPFoaakeHZ9zOUefnhC7PQxl0OnEG8wY+u/l9xcvF02GUiArSQDKR0XOf+O2atbx4wBfnh1IMnYIwCi1d9zwxD0F0y27Du6rHNrdlhrq5rAKm071I73X+r0Ap4dk2iSYSPD8/lYG9ufC5xOtNju1aWSl740VRcXCji55SFrr9I7dAwWfXCMMT21+GvUROk1reYsa8uluP8mSRTzaWk0qFA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(8936002)(26005)(186003)(558084003)(956004)(86362001)(66556008)(6862004)(6636002)(66946007)(5660300002)(66476007)(2906002)(38100700002)(38350700002)(316002)(52116002)(36916002)(7696005)(55016002)(508600001)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GGxIEW3zsdBF71C2MlygOUI3H9uk8k1fpARFSRugXBmKNmP59X5yO61+CIot?=
 =?us-ascii?Q?BcUHGCVTfP2MfzjGYNekRSj6y04uK/t9q8ry7vcFkB2yrgAnAkLq7e+GUQcA?=
 =?us-ascii?Q?7tzSWLSSkbGwWLIznOctVwi7WIvedyYoI12Qpq7hteKr7Pl1ih8DqKryGMQ5?=
 =?us-ascii?Q?vylAKL5rPOfCB5AG8KXH7gya4pYk8K43VvTjPgkSgNqFqoKp1p/SpnLuBP+x?=
 =?us-ascii?Q?X0i6lwZcf/TvfijfZRsWv1OWQ1rE5OT6keB2RnclF9LB0BOi/we/vVeuMcnF?=
 =?us-ascii?Q?FkSh+u5qQV1Ll7wyb5rJo1xsf3h3CuqcCadGdtwZqxuxsc7ToBAXXMjc21LD?=
 =?us-ascii?Q?6cG4p67n4ZCTnvo0XjZIJuAjFMHmyATZng2keb6Zyzl79ZzpMycvcjUsFFee?=
 =?us-ascii?Q?BzQo6EJkLOo7LQRvWCsegN3rRyxH0fJ6fiGLyz2sLNN4Ini1klp34KFdsAF5?=
 =?us-ascii?Q?byZnaN8xpbnRY02wZKfhjMxjSV5UcjukBOtefjR+dV5HYK1HTqsf5SNmhN+q?=
 =?us-ascii?Q?UP5uGjObWNmJSZDW9+kESdzqommI+NPNQnzDc5muLNre+ApYyHV+JsUPUSWT?=
 =?us-ascii?Q?4v+S1HvlcRi5YKv+PdcSF8gM0DEncFC8qzUBpPX1/sHeAXc18T1/NrSJoiLe?=
 =?us-ascii?Q?5sQxylAaszpsaJnKq0mtPrWGKIAesaR6F3HlkdUdsDK+if5oiHLZoHrofmpr?=
 =?us-ascii?Q?DUTusiEcfKKfV3wAWozHOMuTwEQgQUfMeIXKR4wfwshHYtVSe70bcFilZHpL?=
 =?us-ascii?Q?pr8AudfAZOa07pX8mu0hzOIWh7JyB7Crsof1IQerc2t7JhasHCIdpsweUb0s?=
 =?us-ascii?Q?A/aWBHA5uzcOn6D2L0+W897FEF91OYiZJcK1T1idGKmWyy7gk78NAuzcTpYE?=
 =?us-ascii?Q?B3qXKEDY1YnrLTXSCQ2w16oeQHIBAPf1zWIAbx9RZvBYVt8h6Gr4SVzLyZKQ?=
 =?us-ascii?Q?OypvR0ItPz+nUo6ARARrhycD9464b3lXAs8HJiKmw7YWxewShepWesTpY97V?=
 =?us-ascii?Q?bUjczNES6+ZMINM3++6lnw28oc49UQ8sgA0loeUAFrXJq0KNIkPwYnHt3DkN?=
 =?us-ascii?Q?Z1QqkYW3NNI+RVD7BoEQGQZPbMbQB8eGAy10GaqVf0sNmWTst5PdOlKGLbNZ?=
 =?us-ascii?Q?5mKizKOWD73WMWIrtDKnBn/WExahZNd0Kad2fKWNgHqnsX5OE261SRe7kBQ8?=
 =?us-ascii?Q?2j40TzNYztP3KB60TeBPrEy6gXm9hNUsVyUL9FC63F3OoCnkWnjtJcHf42bM?=
 =?us-ascii?Q?Suy/n+N/bKpjaee61iuO4cF2IDucHBwit4KQkXmDKWu6Bouo3nU1lyeD+mbw?=
 =?us-ascii?Q?qVdh7cZ3SC/DMOh4OYDTfVISZXQo9hhJ+OARszQBpo3Yp4fxsV5DbmlfOn9O?=
 =?us-ascii?Q?S2IvdDlLg9JT4L/aNilwa4Mu2HJtqT2VoRdz3qyoyvCVd288C96kxJxG+hBj?=
 =?us-ascii?Q?Eaoay1PwZ2OU5tFTmdZgkV3ov7vXOGldcLKRH3OpcV17QFwbGi11yRNBsBE9?=
 =?us-ascii?Q?SUr6tvRx62rGmNMbF9NNv+92GrG4V4KqrqErkvHMos7emteAiQDmy6EwTYhX?=
 =?us-ascii?Q?a7eJAd06gXul77R+GUjViyymZYYOWgs21GiBEofCHzfh+ofhjm0V6ICJUfHd?=
 =?us-ascii?Q?Ed62mQlpUu12etSu2lajBSAPn+XZis4BFbbYGg4k0teVYl70SjisVd9/6e4j?=
 =?us-ascii?Q?8VTxAg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a27d75e2-c843-4d1c-93b7-08d9a335f551
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2021 04:03:59.4930
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M46vfkoobJ4PVzepHSwOf4q/p9Hv/nyJZ50gcGw+ENjLgqC+9wGAIocwoFFYkuuw/6otzwYSxlBvSg6Vx6tSTc3EZ4wCCFFs/Yk4qtduoDM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4519
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10162 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 bulkscore=0 phishscore=0 suspectscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111090019
X-Proofpoint-GUID: Zcvp6u-vxxlkfMdIBrPgJLRwMWJPytEL
X-Proofpoint-ORIG-GUID: Zcvp6u-vxxlkfMdIBrPgJLRwMWJPytEL
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


George,

> Change min_t() to use type "u32" instead of type "int" to avoid stack
> out of bounds. With min_t() type "int" the values get sign extended
> and the larger value gets used causing stack out of bounds.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
