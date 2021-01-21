Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 265CFC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 04:43:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD1CA206FA
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 04:43:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732137AbhAUDyw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Jan 2021 22:54:52 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46158 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732243AbhAUClr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jan 2021 21:41:47 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10L2f0st102740;
        Thu, 21 Jan 2021 02:41:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=NXB2FR2SMTW9I1ozQk3pRutnQGIfOpBpdvtcUbYNR3E=;
 b=jh7mxeRIHnbUewiRTpG/MmIPaQn6DoDA4H7Ka12Pg4Hv1kV4hwcLtD5+6y/KenmUppQV
 KCj+zyET/mDuCp5hJfMMhGZSUbzNY7RcGIV39Hy1YjdzjSi35MbK/gcXwxzV3ytYVN1v
 AghrbDriP2qyImIbx0ibctNpI/aucKDPQINYIua4kpOmmkVIyLeJbEIsYxgeyqyCJKjU
 IBbdKTrqTw2jjeP71DrjgV/duMN8+ZEG5cYPS49eyHezQTamsIUBzyU/Zml6aOzEt0vo
 SrGKP5pdp9A06GhUO7V4ZI4fxZuGHQL58ke+mrhSC1M2CYvJhSjLBfDCb//yfuYAclu9 xg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 3668qmw9cu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 02:41:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10L2YgTX019348;
        Thu, 21 Jan 2021 02:41:00 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by aserp3030.oracle.com with ESMTP id 3668qw94qf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 02:41:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bkRjnJEKPtUIlLbzAVg/lgTKaUzDKU6219YV+qNcNOGFoz05kxTnK6rBP8VEoN8JiwdI1zPn+gSt/077KbWvRBnLcohMzDEO+rKqRmeYydVJFfwI8zLszlfMz3D3ebEc/JyNdn2gqdSTQPsBuNQm9TGAKI+efC54lQd2PfVUXA22e4AzYgzO6nccifHAJqc9GdGr9qugBF15STeY5JXw3mjqfqzedfHyuiY+aDeDjiwY0veeknnlxZV4WnFSSV62wpIGi0SSU+j4W2z06wzis84EyCPHyhhcSC6bBHr80oi7A4IT+vRBVhjUatq1tv6yaVPohGamZCkv8X6yxWIWaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NXB2FR2SMTW9I1ozQk3pRutnQGIfOpBpdvtcUbYNR3E=;
 b=aNkLs5Edl6ky0uDdm+8p50jxyukXSsoKofLdZVvBjY1t0hD+2YMbfVEfZ84EZmbS08o3Zjj0XdyKDTKFFEWizp9l9lU7+W89YKFdC53Iq4rDIRycqZ+EdjSTU8iH5M7Jtz/Uq3ErQDOwqCC8JVBozRBGlYSLil7s7LIexcKhKt3rjwIvQdZsfIBBZ1iM8d0ZGs+jvNm9OEBGoErsPIvEsuulaOqqBc5D6NQwdAJhy4GT3D12qGxz1DWxpFllYOrQ9rOgYexVaoq0Zq7Q8ZDgw64TggkVn2CrMm0nVK70VOHG0gZ+EIdoYuDNhXzmYCCo+3PJmK9NC0CVIbjKHI+0Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NXB2FR2SMTW9I1ozQk3pRutnQGIfOpBpdvtcUbYNR3E=;
 b=QsIUpcjWY5TwyK58FWRpfvBfTCy09f0FCil8wSx7U4xh/kSIk+mRNJIJTzPyBBTqHOvREMq6HhHuinTBWEQNSvVpbYLqY4QN/DNmd0DiKBErYhtllRr+h8XUwlqbgqlaBeyx4cmx2iMU8MZQiOOo4Cojkr3ZRng4sv1I7z4GA8Q=
Authentication-Results: wanadoo.fr; dkim=none (message not signed)
 header.d=none;wanadoo.fr; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4662.namprd10.prod.outlook.com (2603:10b6:510:38::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Thu, 21 Jan
 2021 02:40:58 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.013; Thu, 21 Jan 2021
 02:40:58 +0000
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     jinpu.wang@cloud.ionos.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: pm80xx: switch from 'pci_' to 'dma_' API
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sg6vgggm.fsf@ca-mkp.ca.oracle.com>
References: <20210117132445.562552-1-christophe.jaillet@wanadoo.fr>
Date:   Wed, 20 Jan 2021 21:40:54 -0500
In-Reply-To: <20210117132445.562552-1-christophe.jaillet@wanadoo.fr>
        (Christophe JAILLET's message of "Sun, 17 Jan 2021 14:24:45 +0100")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: CH2PR02CA0015.namprd02.prod.outlook.com
 (2603:10b6:610:4e::25) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by CH2PR02CA0015.namprd02.prod.outlook.com (2603:10b6:610:4e::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Thu, 21 Jan 2021 02:40:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc7cb832-b77c-4179-3882-08d8bdb5fbbc
X-MS-TrafficTypeDiagnostic: PH0PR10MB4662:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4662E873721A667632635E888EA10@PH0PR10MB4662.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M2QlrKaCwrG/OU/IzWmjIACVDVS/M/0VxcewdAdoTGzM3dfC2V2SVwNLYshsN19DmUVPGTIEFJuQkcNVsedqvt0PEhzuV0+hHWAo/9/YHiA27TnlbrIH5lxc/0Y/ygqkKRNid7DpUXciwp1UUZoLK70HJsgY/liSk/OK9IN0HixbuHafSeehpDSQUxANn4Y64yxPn9rLxbeEllSCGLdLb75PfOXCkKDQGrpmQOP+879orjej2Ql0OIUs0D8t10oZ2ZCzeceuATLvTApmNUGuGXeNgclQU0gz8fAEbzcuWaSPXUzEFPc0+wLB2swpasoN0+m3tMUJhRNx4dhVPF7L+AqYEFTG14c41MRasPwYlGp7bq9CFsNQK3/ywb863kaO/1Mlfy+18pCJMEfEMMbCKA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(376002)(39860400002)(366004)(136003)(316002)(8936002)(2906002)(4744005)(8676002)(36916002)(66946007)(5660300002)(86362001)(7696005)(6916009)(508600001)(55016002)(186003)(16526019)(6666004)(26005)(4326008)(52116002)(66476007)(66556008)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?iuc2hOxv4DACE/t/wkG4Gj2SvGtSp2hUwCsXyAJWFZjfUgDa/xo5Z+wJXDjS?=
 =?us-ascii?Q?0iyc0C3II7AWg70Gun7qPRD1xEtAJIjJW3f7RNI+1CDlIpUH8t2hVIlufChV?=
 =?us-ascii?Q?zTeVSdBEGaSbndtEl1Xe23Wpx7zj9S+gqM6oeisdmyz9aYWlRS4DE++YhaB4?=
 =?us-ascii?Q?uzEQjZ2dIEKStdyndiU6cPFnsQPbI2T8isjEAIpRH+qxrZbmAWAnBZOT3j6D?=
 =?us-ascii?Q?QEkz6FTLAjejj+Uxhx5/utRVuVy3XbAHS69y+mgoRIb59OlcWeIKUXpsrxkj?=
 =?us-ascii?Q?9S7xQXB7h7wM4VCIp0oGCmLTwd9ZtQhyFU+iW6JucXyr6EamvVl4VPd/IfNB?=
 =?us-ascii?Q?WXEnr/FO9c/PZwEuNmDEd0zovqBChIs82Dp2oNvOoZKIDBcWZlJuy1K/VAQw?=
 =?us-ascii?Q?+3TeguVyMSYrgSWgOA30y6SG7vnWCVqz7EMubV9fQQ4aAD4ADbOGzheLhGkJ?=
 =?us-ascii?Q?ixguBHiigKGdSZ7a5fZFmC/UcVpZ/C1FQRpU2WAx4HGqfzPETWGQNAI23WGO?=
 =?us-ascii?Q?2QEH1jh0QwqjqxF7kRVRMVPTJbtHuNc4aLXg4pvNEo3X/CzKtkKoBytYkHK1?=
 =?us-ascii?Q?H++AYiBamXHOgFX+NQaCXd2cqcyOtNOPbxG6oEFzUfD7YXGuISLfQGsTgrq0?=
 =?us-ascii?Q?lYmUCrf6nTb+4fmGrzsdcKLAxwvKtvwpa5lCt5uS9vPZaz6CQ2Cs/ID5Ybau?=
 =?us-ascii?Q?737Wnc/Zy/8DeLzqtOb330sLF32Bs5X552MYMJP6ZTovOMqr+kitO7kpNSD/?=
 =?us-ascii?Q?2gTu5hT8uRMSmDf76YX7CQdPLL9O1FD/w1yt+NizBdxNbHlqx/K9Bc8k/nIL?=
 =?us-ascii?Q?QqusrbfWRyQEiki4RPDUENxViKe53XQBduglsnKkuEWf/w/ByXP9WrNKsb6L?=
 =?us-ascii?Q?sbR83wWkx8W2IlepMbexISzvweZ8L1Y4tSlqT2Lw8wDiR8OcrvFl07bBbFnM?=
 =?us-ascii?Q?IAp1vrHBX2sDizFdbeKY0kjBkQrxNm3RyX0pUYm7ZXqBkvFN6Ci3v2fyVxid?=
 =?us-ascii?Q?0uAw?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc7cb832-b77c-4179-3882-08d8bdb5fbbc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2021 02:40:58.4117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tcab7KSIY+oLC3UguH8R3el+dpdDX4cI5LtHJmJ6HwpY3hUU430Lh7cEgLrcLcodcl8m68EpPdiFKxWgG1teS2VqWusRcUeFbStc4YydqQ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4662
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9870 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101210010
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9870 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 adultscore=0 impostorscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 phishscore=0 clxscore=1011 bulkscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101210010
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christophe,

> The wrappers in include/linux/pci-dma-compat.h should go away.
>
> The patch has been generated with the coccinelle script below and has
> been hand modified to replace GFP_ with a correct flag.  It has been
> compile tested.

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
