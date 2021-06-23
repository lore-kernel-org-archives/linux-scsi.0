Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BC22C48BE5
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 02:25:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBCF760C3E
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 02:25:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbhFWC2G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Jun 2021 22:28:06 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:8924 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229774AbhFWC2F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 22 Jun 2021 22:28:05 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15N2GNNn016743;
        Wed, 23 Jun 2021 02:19:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=HdqjnvWwX0uNHUdtjsjVBhJjj7c9crBokJstUf/wqkM=;
 b=uwRv9Op8ZmjrRXnzNMCSVsNdCpkGeRhThidEYGpvU3pHtKFbksr9Q5Ujw9f84AEy1yge
 vO671vlpCYjKlUtxGKy42dfxZF4l+izdk8L6HZl51A6R99gZhKFqlvwEkiPKLGknHMFa
 Y3/opVAMK/RIgX44Ojy9YPrviA3Xh7DZgXDVlbIMLReO0YXJyE8GhkCpXwoX88blvpuh
 nl4e+5B6D5fz6YRgc/SUvbckQx2PzQw/ti23/LFpkUwFC+yOfk3ILgdkw7DW2D0Nlf3b
 iw1cqMK1Afs9MAhNvdsaGfe22B9Fm9nWpMLQaTYJa8XR56Az5qnSh+LeMhystpHRnzVU jg== 
Received: from oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39ap66mqsv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Jun 2021 02:19:44 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15N2GLYv099313;
        Wed, 23 Jun 2021 02:19:43 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by aserp3030.oracle.com with ESMTP id 3996meds41-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Jun 2021 02:19:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d26snqxOX28s7fNysvJdsB3X1voTRPjKVpLJ8NSAqKoeL6X76CjULHN1+gedvDVc5X9DYiVBaGhx0uUyU3ICvI+CDjoDIQV1RpHhvzqL5j9u73CerMSoKzw4CJtbujA6d646cZUMyLYJGWnbzHXPGZNs0yaAinkx/oul7NpZ8IyUrQcqSU2wCr8UHWVSHSh3MrXXo1u+dUIWmQpdD4PuTQKTuzo2aEj3o/owKQ0ROamPfKqWEwMWKM58SHgFA9QEXc7KiPQLYebWDcLE5rcm1nlRQy4seMYtccYdxisok8eysRxSStJB0uJ9fqGK7icWVDaneF6dIsy0ddyUrdH22w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HdqjnvWwX0uNHUdtjsjVBhJjj7c9crBokJstUf/wqkM=;
 b=KSHWmErnuwXmU+lj9kJGP0vW5iC5MNX0LLNlqfgDV5+voTntxGhlIFe/IOjISGhe61X+r4sBsxpWg29Ag6qiXpHuYQd5DHF+xOiAAH1F4gH2uRc7COsxooEZf8soVuE6XMuoyW0jTljJ11av+Sh/guUoNv5tF8LyiKbnWSOQnp8Y8sAQOV67UNCqpVesECj/Q3TwefxVS51rTJGswxH8cMIJXKLkxCL/hX3lhC2qfQZtScjX8NrowrkGvv04A1ECXo7Rr5b/KXPndcKaZJ2F3cfaNNy1yTiqx9gFlmmk7ijwZfKlrsI9C9TS4eONfCkaWqZjgW2SPJa5taQMG98dzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HdqjnvWwX0uNHUdtjsjVBhJjj7c9crBokJstUf/wqkM=;
 b=w95vYlHb+EdZ2a3E0mJVJ/E7NDRMm5m5TJZkFBadthbJ7nWWl5cHjqmsbqplO79UuHzp2FmiFPwudQZimRbnVViKPzpgvTxi+PAunEGC7NfZkwQqCX7Cl3twArm/bVm+EVGc2IcBz7k4CMEO++5j9eJyxWSfI1fUG+UOBkkIuMU=
Authentication-Results: wanadoo.fr; dkim=none (message not signed)
 header.d=none;wanadoo.fr; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR10MB1568.namprd10.prod.outlook.com (2603:10b6:300:26::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19; Wed, 23 Jun
 2021 02:19:41 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::89c5:ded8:9c91:30d2]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::89c5:ded8:9c91:30d2%4]) with mapi id 15.20.4242.024; Wed, 23 Jun 2021
 02:19:41 +0000
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     subbu.seetharaman@broadcom.com, ketan.mukadam@broadcom.com,
        jitendra.bhivare@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, minhduc.tran@emulex.com,
        sony.john-n@emulex.com, JBottomley@Parallels.com,
        jayamohank@gmail.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/2] scsi: be2iscsi: Fix an error handling path in
 'beiscsi_dev_probe()'
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r1gtqq4u.fsf@ca-mkp.ca.oracle.com>
References: <77adb02cfea7f1364e5603ecf3930d8597ae356e.1623482155.git.christophe.jaillet@wanadoo.fr>
Date:   Tue, 22 Jun 2021 22:19:39 -0400
In-Reply-To: <77adb02cfea7f1364e5603ecf3930d8597ae356e.1623482155.git.christophe.jaillet@wanadoo.fr>
        (Christophe JAILLET's message of "Sat, 12 Jun 2021 09:18:34 +0200")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BY3PR05CA0036.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::11) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BY3PR05CA0036.namprd05.prod.outlook.com (2603:10b6:a03:39b::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.7 via Frontend Transport; Wed, 23 Jun 2021 02:19:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0501224b-2f51-4023-f19b-08d935ed5be0
X-MS-TrafficTypeDiagnostic: MWHPR10MB1568:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB15686CE219E9DFFB3D66CDCB8E089@MWHPR10MB1568.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sv/dEhXPk01+4bfvGUx6CkoUfJdyDN9JhrHHjeE6t2WWLY1K8Ub2fXXa+nnAQHGnIBnHGnZB0fNnIBfa8h0IJTDDyakRMEMjBwV7XbH37+6s/NCzyXne5UKdtNk3Zxi5ejvfDmShbV6xxp9tzmhzDug0zlnNQW0zYmXdxM1YmMOn3rI/1VPfT1Z7RtS/adS788YZS9hb19XiYR/MOUUHmaa5vR6Oo5P40atajw5+2NyX6QdoMqrc+SYiKhwwMCYdblU3Qz/UruJSoBQkl0G+BBtGKQrrrdwCwLMwakcPCmxxw/iOJh+SfwHWuvRfU6eIpQuez8bWYe4Uw8ffohVRSzSb/gS2CC/eP4yjA+QklqcTsbg2VxrucGyVjDv+abWbONfayVZtuOh01H9GXX2NZW3A/sJLCIZ9AiKGgkwt98CjsY9kLoKS4I1cARHTN+5UsspTHmINIB/HxL1j1pbpqSCH/G9f20kMQAi0LSRxcatHmzmnD1lrKXrni7NRLsA7/0/G3SOUbjDf7fRmn6BDO+7qyRkEwIgN9MmUF8RmXootBmmigAz4YvHpKi2G3OX7lw7XUTVrxPIgAXFS97ME0KG4VaSblrvXkHLRQa0NbcoAk4+qgSfOivUcz3b7/tcRfzFtRbol/VycfFm7sITdnQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(136003)(376002)(366004)(396003)(36916002)(8676002)(4326008)(26005)(55016002)(316002)(478600001)(7416002)(5660300002)(86362001)(956004)(558084003)(38100700002)(66946007)(2906002)(6916009)(66476007)(38350700002)(66556008)(7696005)(16526019)(186003)(52116002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RtQWNYRE9f3BEjoPMUW/KzozsiXQ+rpO3DiP/co5cYdogjVfJOcwdHiGaZoP?=
 =?us-ascii?Q?ToGK3BtbF+M7uHALmBAiKBMQ/aTT2H2oFnjAXvmPTa4RiReTcUl7eqsvv94d?=
 =?us-ascii?Q?CXqkuU1VEHLhosNjasox8NzCXFclBQk0dvEREUODHj97YxuYEOvDMHA6KQjs?=
 =?us-ascii?Q?JJ1M7v4Thpri27UAC6gyl/GwICdbf5cBn8+x/OsZQuQdOuHCP7Dw6xe8Xa7r?=
 =?us-ascii?Q?B2PH66/feWyNjUHU2C4XHeAEBW7zRVkTporjup4Li6M8IOBv1Bu3xdL70Cyo?=
 =?us-ascii?Q?X37/PdUx+k099NsF487JTqly5djM3OSfVoY9fRZlVaXwJKVhxoJTozl3XmUt?=
 =?us-ascii?Q?EDXaFku8CLV7KLrH3P1hUC41l8Kucql4RoupGEWw8A/XGFZYkp+/hfplpLv0?=
 =?us-ascii?Q?9uNGSvNSZ83nwvXkc0HF+jJFtf1TXoe22qYWb3e8n6ums80ZhfQadosKLtgY?=
 =?us-ascii?Q?VBBY6oFRlyyVWVqv5k9hmv/vR03QCr2vpkkYgaIQWkzuUcZrBfHr3MAs8cBM?=
 =?us-ascii?Q?2CNo5T54CWer3T+z9LoSw/abB6A/NKlsEYcZErxFXRR6cYc1NSjSH33bQXI3?=
 =?us-ascii?Q?rek/+6c3WpTFqmekMBmXbp+WJhF2/8sQs/DdKffdkwp0kDhx/4in/tPLhWX8?=
 =?us-ascii?Q?/OlTTjEOmbs1yVjZer/qmnQUnzKNIpR9BVkpg9/P9Kk06Hc+ud2x7wWCubee?=
 =?us-ascii?Q?sBgsN78budFd98HOB3htBhVDXgGyCsoB5qS9cotu/xC1cIJHmINp/Q4opaMi?=
 =?us-ascii?Q?LrQK/CjFVPV5wXWAvnsUZRmbrZ635C6NKMi5msIEHluHLPu0kcMExkKy17XQ?=
 =?us-ascii?Q?ooLpqyI18dJMy+jr7l5TrA2OeiCxSGB1K80XuuqGfYefCt9I2OTCpA+Ig73c?=
 =?us-ascii?Q?9qKbzp0RQtQJB5AWn/0ICt+8eOgl5r6uJu3IpjmW8tTrG/VCQCOgfqIe8nuJ?=
 =?us-ascii?Q?m9nJf8lAT7wageEkhJ/p2i/sVZkdBNQ+u81/xa8ZFLh2HXRaaxYEfLH3dOBs?=
 =?us-ascii?Q?HXySNZ/9RvLZ+KrdY4s9kJQcGFb7M1MbxPqr0wwU9+kx5A8/ZHxDxRul1ksY?=
 =?us-ascii?Q?bMiI5GSTjuZEhLQUeTGMbmEChNd1VYMyo0pT6zXBh+pf2BfC00JKlYmnld8G?=
 =?us-ascii?Q?S4ORyLINlZC53f/MS4Ccr/Zavjo3vZ/0R394Go6WRW4l0fFowATkeAAlsWxJ?=
 =?us-ascii?Q?KFVU87+5Z0BS7qpHmaM+t6qZfcU4Cm9CKAXP1kWjRmF+ye2kHXGrJEsyAC1O?=
 =?us-ascii?Q?SHIc7bnEx1aUG9BloXdtrSDk71V9DJKqSKKSRu5P0Xbo0hXfETsbKC3Gyc5u?=
 =?us-ascii?Q?LjZjBzsLp9UfrkfM+5sogb6j?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0501224b-2f51-4023-f19b-08d935ed5be0
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2021 02:19:41.5760
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C2Jl7SkQfrH3ZNchF/19C8dR0Dxtbl5wwzyupT94sjQ3DBN1FB3Fa55E+/5LxVurx2X+PczbMSIGfCp0MkGHIeakp0IZNyT4vfUGowEYZto=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1568
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10023 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106230010
X-Proofpoint-ORIG-GUID: ub1wfbhwZ-_asq6isXSjlCvjRLzogAOU
X-Proofpoint-GUID: ub1wfbhwZ-_asq6isXSjlCvjRLzogAOU
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christophe,

> If an error occurs after a 'pci_enable_pcie_error_reporting()' call, it
> must be undone by a corresponding 'pci_disable_pcie_error_reporting()'
> call, as already done in the remove function.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
