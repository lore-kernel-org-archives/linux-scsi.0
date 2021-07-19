Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB183C636CA
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Jul 2021 01:43:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A79D061166
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Jul 2021 01:43:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233759AbhGSBqY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 18 Jul 2021 21:46:24 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:42418 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233713AbhGSBqY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 18 Jul 2021 21:46:24 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16J1gRHQ010305;
        Mon, 19 Jul 2021 01:43:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=xrWPTiUgRQd+pOxtnChnHCOASmAcYZdU4wP6XqHefkU=;
 b=hhs13s1eS5LeMBfO+7ND2ho6RG0ytkYo2+cBCPYdt/YhnEGI6mYUkg1/Ww/bn7zcQW60
 hvcSiGFRvh7e68ZfmEITllJvZPppsSvyZbYDfeCBh0rj4rDI8719WdE7eTa5clMMo9Al
 Xyr9693T5xtx4tevz40lB5P1JmFHUVXwp0i73XUXSCbEv9afeLOdkBvylADPHKyYT+rZ
 XgKMMMj9VgDMgDNSlZqnSRujv0fipyhQXKWfsDF5sYONf98WZgJjnpa8mzIw1PJOADus
 UYqMYsCapralk7Tlg62TbWpgFDos+MEVKDIALJxYnkWE/oGw9rXoZbyPpdY2b0Dsd/sl Sg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=xrWPTiUgRQd+pOxtnChnHCOASmAcYZdU4wP6XqHefkU=;
 b=rSgQvU9ClgKhwoy6+zisMzsq/N8X6GnneEfGZwtTF3woqlrqbRaA55HxAJv4QfwcMzcR
 DMFYTsPWH9XDCK3r3l5b+FYGSBHJUDvsYwfKLxhlikXWPJxEOpdF34ennzNv8u5HKLIf
 9nD8wamCDVc2BOMhp2pniHySowuMpuJrJXEDGssOud++CZxXrkzrBEKhAEsim+wrdzaQ
 BFIH9aohQXVXwZgY/DJYKmKdvtBF+q2ukX+l59BaaC+0uf/XCr6iP0iY2/DyoUpxEX+H
 IORX/3iJ09qU+xx2F5j2C/0c7W0KnoQyz7lNn+lbCN3pA6EhCYToqhtYgCASS3i87xlE pg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39vrn5g8mf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Jul 2021 01:43:24 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16J1exWw080358;
        Mon, 19 Jul 2021 01:43:23 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by aserp3020.oracle.com with ESMTP id 39uq13t0t8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Jul 2021 01:43:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EPc6rCiTM3FfSDFiXdzIAYfov1xr+k85+e0olLumm8ZUlvN95Wr5fnya1wxrGeMUHM/395+h0AfmU6bbmFOxvO5+EHOXUs6DHNP7FkaAFqVRUkgytjvTKe2t7KTPQai64pVP2BJ9wE+m2gv/sesBVkMGAFWXDCl1+VNfXAKNbaB9S29xJ6Il54ym5/VkdJoZoqVAftm5JV5OOntD7jmQOyYoaDlcaKKMyd5LoIJNg7DBN0fH/VpXaLbpPLPq2gqlueP9CUAc994r0d4+zaFnSz+W+Q8UwN0aD+IwHzdmfFJs2HiJr6jFZWWD/6QJaCnAMCbd574ftT+Bqallu4f0dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xrWPTiUgRQd+pOxtnChnHCOASmAcYZdU4wP6XqHefkU=;
 b=brNqoFqewKYeRm1umIFDcZPU4836PZwaSBr4jaT2SV5EopVuYFdyj36PsEFLgme4XjR1xbNk4xIxaEuXyQOJQzX8D8weqQr2vphv/7g4J4KXqIrEiV19A5E/C/CuqvKUvyTSUtJN4s9OwhrlUadu535WD6RIGtbvksJyJbz/BaLyslAG++dsPGQTjvE4gXH36Lmj7+CilsFLlWgJahD/v2jhQ+ISLNVZCtIqTItSKatI5QQD1F1vDoxRfoJYj05G8/oIw+02T7aB+WwWJCtcHcr68JyziX0kvi5DY4JiywR7fa/rbMkNxQIDIiZOWOsBJOj9e/pfwQ4lm3JAsdlb4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xrWPTiUgRQd+pOxtnChnHCOASmAcYZdU4wP6XqHefkU=;
 b=frYTvYF4yrVvRAvG+VLvWrOXwwFjAJKbWh5Ut5dbRMUbb14dAirYGDwKC+7dhMfiorbywKvBukG9VRXeVNUx9twFmXHvGKSo/djpD2+wTq9rWwy5eAQzCnkts2KSh87bv/lfrb0woSiXgkwb1E9m4Be3eRT5n1Sdt/LkAeT/eKw=
Authentication-Results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4661.namprd10.prod.outlook.com (2603:10b6:510:42::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.25; Mon, 19 Jul
 2021 01:43:22 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4331.032; Mon, 19 Jul 2021
 01:43:22 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 00/15] Subject: Protection information and block size
 cleanup
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a6mj13n8.fsf@ca-mkp.ca.oracle.com>
References: <20210609033929.3815-1-martin.petersen@oracle.com>
        <c1c075c5-5b2d-afbe-95ee-c5c02ecba1a0@acm.org>
Date:   Sun, 18 Jul 2021 21:43:19 -0400
In-Reply-To: <c1c075c5-5b2d-afbe-95ee-c5c02ecba1a0@acm.org> (Bart Van Assche's
        message of "Fri, 16 Jul 2021 14:27:54 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SN1PR12CA0062.namprd12.prod.outlook.com
 (2603:10b6:802:20::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN1PR12CA0062.namprd12.prod.outlook.com (2603:10b6:802:20::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Mon, 19 Jul 2021 01:43:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0a69c97c-2c43-43fc-7763-08d94a5697af
X-MS-TrafficTypeDiagnostic: PH0PR10MB4661:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4661DEF2AD07FB27376737798EE19@PH0PR10MB4661.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EhYp6nZ+YwFuJoWdXj5eLpF7WlO9zo0WDEYp1Ks4XlJMmcwy5/LEo8BlGx3qTa9NSusL58oHmIstCq7E6IDd1tOtaa0wr0lfr1ThZjPp0R1UC71aDrTwxrYXMCopzOsmU8UX43+5BRay1SfA5/CIvdJ47HAom7w+JPeLTPG43PR/Ah7oB/dIbTXzKtMpftKMi54T06oCIXTuQJZNDKlecjJrlqpJN72u8hjThq3qNgNpMF3EwVZ3mZVJnm59vyTUYNmNaCKciaMclI6liugrnEJaWo+vXBGuOPDq8+JpTDWYxlaIE56R2bwaMqV3h0MjARq/owLCKlywS1TRb+b1KKKRSYQVEfnvYmoL/APf0Gb4UpTV+NTItKkNXgPCsAE3YNym+1oPuDD+iow+qKALYi0c63m37xw2Z3kV7zHOeLFsX1niFqon0yyHwWF9KcJ3ejnANqvGUny1ZEUGwaqdzMHZTJJSgjRFl9pIqnBrQ6whJ/wy8rojVwRFBNY9vb6VC4qRDdLtD2CSVN2JZz9qbszZyWCfVN30F6kdIZP4EzhLCwpLYMjgLm1QgjWONkit8djKKRCeJ0/EUMIwZ2Ox1Qh2WLCNdCEQyPGqSTAVGSD0mDejUVqx/GLrbYtk4e1bh+uAAiJFAfUlBXYq88GPyhLO5PT8pQHOfu0VM9cwVogA2mdlMygEcRjFHgFadw4mV8rIS82YxdZ2bpzLnDTr4w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(136003)(396003)(39860400002)(38350700002)(38100700002)(86362001)(8676002)(7696005)(36916002)(316002)(478600001)(8936002)(6916009)(4326008)(5660300002)(52116002)(2906002)(956004)(186003)(26005)(558084003)(66476007)(66946007)(55016002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1BCpBiC/Oupnne2WYapqzIbsbW4ssaxoLjnYG7NdLlSW08OYmQERplL0qg78?=
 =?us-ascii?Q?98xKzTl7kmX2c8jz0rT4TYNK9ScxBbTlKDPF2PUzWucvQ/PHYxKp2kJHo4qN?=
 =?us-ascii?Q?lDwbSEbOWA2KTWZ9Ut7mZkFvINImPpdrDFVfErSFm5saHfLcP7psnlVg2unX?=
 =?us-ascii?Q?huRvNk+66aWwLkAQhQOgbqGyBIguDpjdLSiWQqvbvl+euAZQ5M/L+u5IHea+?=
 =?us-ascii?Q?+mmmpTuzeetoKuy+E2m25WP6L1DIGiiYypWEsueDo76p2wRj81G6cq34pEzE?=
 =?us-ascii?Q?oi6+ILgH1/PT3Lrqsmalu5BL0fLI5eOqA3b1e3B8PiDVI/T2HypLH+w2iF+C?=
 =?us-ascii?Q?BObnJ2oSAU764FghtnFIoiwpzGVfnqXm8E1Gfsfm6ASEqPIbSJY/KrUoNQ4i?=
 =?us-ascii?Q?M6WqDVwtN3M9S6EI/bJvgggTudKZrP6CQaNgK6q1Q6PSoAWaO/cWQBZTjpio?=
 =?us-ascii?Q?3PJU24hEr4T72Coyy4Ta4tKJfgB0HQ4bk94voiwc/iCOq5wvDnfr+FM1h2B2?=
 =?us-ascii?Q?R0AfQRPrRzmOmd9pyZePH+/ijSojtGiCrYPkKVPX4YcjA47f4SXKOyFZUWz4?=
 =?us-ascii?Q?PM86U8cGkH8HL+B2cHHIlvJGZY4OQ0EjSF+5ShABGn6/WSLc9Lqq8FNKr+Ev?=
 =?us-ascii?Q?J0seK2trLwCPSYh+3hHmwATUCbdCwn9/EXD71U72sfNu7srNrbepEdixiVjl?=
 =?us-ascii?Q?MLnYAyrh3M9eRRE9Z45J0kltxhoB8pfG5WHrx0s/n+PAB3y+5Rkv8aLSoOfC?=
 =?us-ascii?Q?1C1H5TUbqmMESEFMto348eYFyJkhcquNZ/iM0FS8N47tJEkhEkbzfEXKwx2a?=
 =?us-ascii?Q?DJRbpo0cFDW8DuUIiMrBxySSBQAMn20D+R4MKLrAVnkkxcnBZ82mjnlzgxpx?=
 =?us-ascii?Q?1/N1xZ2MHtn0vvhiodGa9tFjZ2Zpof0TEVGpKEODOdjuBIDxI1hCYWdBC054?=
 =?us-ascii?Q?Q7ds8w+blOSM1voKJu2oRj/WPSQhgHWitNsVh1YmpAlxERfFkIzN+8RnSkW2?=
 =?us-ascii?Q?0V1+ee6uAcdkaGQXlLLvHUdfsPY19+AE3GxLiCbNgNu/syZGkKH6fFS/gAe/?=
 =?us-ascii?Q?9qpB7ksOoTcR4fdHkObwCUiLX1oIZdv0wK+83QPjUffke1/s6YdV78q+HDr9?=
 =?us-ascii?Q?Q3liT+dKtaXDPSatdMWai7VXQflKsy/zfDMAVpBau+pF2QsBVLp/KytaFzkc?=
 =?us-ascii?Q?FOv7BdIe5HgUp0rEiE4atCDR4H5+W1K+0sdeBPSa7c4IWI3OAkmZd12QDXW6?=
 =?us-ascii?Q?r/ZGJiCzUMTKtGdFcNSNxbcV+qxLy7WuMjsxPkTIubG2gOKeE3SSUuTzm1It?=
 =?us-ascii?Q?r9RPwn/VpqPYoJ4FAAa+iW2a?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a69c97c-2c43-43fc-7763-08d94a5697af
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2021 01:43:22.3621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q9ZhCWk7OWJIPCLgrPseUP0wPJR1uKVQns9c5TRTW6H/ArCOVNe+yyOvunKVYVaISRSyW2ZzhzJ2QqJ8f8kwPXBaGlS3DQPstiVMAsd+2iA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4661
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10049 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107190008
X-Proofpoint-GUID: 3o9pr9FjnqqWypZIoqANQi2l99FYmvm9
X-Proofpoint-ORIG-GUID: 3o9pr9FjnqqWypZIoqANQi2l99FYmvm9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> Do you plan to queue or repost this patch series?

Yes. Still haven't pushed my 5.15 tree because I had several issues with
-rc1, including the configfs bug which broke most of my test setup. I am
rebasing to -rc2.

-- 
Martin K. Petersen	Oracle Linux Engineering
