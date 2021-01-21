Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AFD6C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 03:54:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39C08238E2
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 03:54:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730293AbhAUDyc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Jan 2021 22:54:32 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45140 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731410AbhAUCkI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jan 2021 21:40:08 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10L2SgIY094685;
        Thu, 21 Jan 2021 02:39:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=9uKeVR4ukZ9T3yShdCrMBVDvlFazIqB59VM00AeetmI=;
 b=LQEWnEIRuDWtVLzHoDSKLHAEz7xOIx8xEaQ0oasL+UMnVCk2CMJjlc7KHF2fUt2/3tuJ
 nEEHSvK/xgAk7kEpZsv5KCvdUN0UT0IU6O25Df/M3z2zbN4x5h8T+65wtbOgVOKdO83H
 r3pf7g9CuueujjzVVqFC3Cwfy+MmGPMHynMFkgRtfYvgvyUOaI0gjA/X0sEApGycUF1W
 MGCoQVLyun7y8ZwE9HQPGRR4Cazi0nZfVDiPwGz2yXsU6Xw9FtO0WpJ+p6YQM/d8BR0e
 tInZ6Q3P/yCFs6sedbA3oatKx9Bvro3NDhp13AHSsxUM02Thjf/tcU+pG3KO9RBCkGae bw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 3668qmw99x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 02:39:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10L2Zu3A080186;
        Thu, 21 Jan 2021 02:39:18 GMT
Received: from nam02-cy1-obe.outbound.protection.outlook.com (mail-cys01nam02lp2050.outbound.protection.outlook.com [104.47.37.50])
        by aserp3020.oracle.com with ESMTP id 3668reym0t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 02:39:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a6NaRVLDqsFMYO3GMVJJcIE/AfQPH3+ec2Cbo5J7mwcMoirJFas2Etucc9Qpeu0+siajoGM+iQPDEdmZw/6gPrqTXEkMwu6Jt3GZZ/8EsWGLOKrMAeGWP+HeD+pIpj54LSVP7AvaJSkijozJ516ESXTsddKnsPkvy9VGFE2abymclwO6sQNM94TWxBPqSIwaI2sSDOvIhNHmatlXQ8AFa72xN6DHKDqdIqJODkMezUvRCpszq7K+iZqzPboa6eEJNFdgeco5Gp21uqNleKuWVu6ypfLHCaPwyJOzXNry80ghJuRDgO1v+Ar82eUeEi15mA6T/Gd9yTaLNeTBKR9eHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9uKeVR4ukZ9T3yShdCrMBVDvlFazIqB59VM00AeetmI=;
 b=NhOUIUyeJN7ms5zVjltCa6gjs42XVfXIBdaROn68dZdXPzmbnMmxtL+OgX6nIFfQxddWzFLCHXkZqvx4V6YEC4Jb0zZibGfIFSBWmSPgeBRHJ8i549tPcPANqhHhpDoRtTT4u2lQMKs1Z5SWdo+6QrXpR0SRx5Q5veo+t2bn8eC5X5sANqa5TJ8aTS9yLIUWe+zPYHTW3vgWKp8mVEz9em0cLzstJvNBaEsj2dxWKqwhcs50c+DB945CfbALzirH/lP+U6rWy4uTG9WDKw7WeS/UF1RmfCZpD4iRdgumgUdhkQsva4qeJmi9RvyvuEFPzAKIo+lwSxX3AdoFmklV3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9uKeVR4ukZ9T3yShdCrMBVDvlFazIqB59VM00AeetmI=;
 b=ofAuKe1vflu4KLRrJsy3gKqp1YxcXskYA5viE+Qf+JKfrQ3FuP+nMn2PF/O/98Vgac0uZi573PsZWQbJyNgPbiQwU6GcWkXqD0xGFWLPuXCuB7KGz/SSLFoWzXxVEzm2vTxIwX2fDVfFi5lfqfnz4JQ+8akAT2NlnSABShKLdVw=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4662.namprd10.prod.outlook.com (2603:10b6:510:38::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Thu, 21 Jan
 2021 02:39:16 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.013; Thu, 21 Jan 2021
 02:39:16 +0000
To:     Colin King <colin.king@canonical.com>
Cc:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] scsi: pm80xx: clean up indentation of a code block
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1y2gnggjc.fsf@ca-mkp.ca.oracle.com>
References: <20210115095824.9170-1-colin.king@canonical.com>
Date:   Wed, 20 Jan 2021 21:39:11 -0500
In-Reply-To: <20210115095824.9170-1-colin.king@canonical.com> (Colin King's
        message of "Fri, 15 Jan 2021 09:58:24 +0000")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: CH2PR19CA0026.namprd19.prod.outlook.com
 (2603:10b6:610:4d::36) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by CH2PR19CA0026.namprd19.prod.outlook.com (2603:10b6:610:4d::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Thu, 21 Jan 2021 02:39:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5ce18c42-4489-4bbc-9cba-08d8bdb5bea6
X-MS-TrafficTypeDiagnostic: PH0PR10MB4662:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4662C2FED889700C38B850C08EA10@PH0PR10MB4662.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:883;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NwLUBIaw4swJcq6hYX9iuADupEFg20Hf5//9yKaaUVYxARy67Ya/uFyb27y/3EcXFCdbx6n4lO8baow/4tysOpuqlGcgfXq4b7KT4AOZfzaLVRo9ICBqfBr8aKL3vZMZ5wPhFI5E3ts7G3waAWHUcdUHJ0T0gMbt57Qeh0pAB3d+RFOrdEUMOfFNM0s0cOSDzYU59T484FgC75reeuDa0Zf+A25QrHaKBCSd+QJZ5Sc1/vV/X0HZn9VgP4DIFkF8vxxv2JggrqlCKnEzdkx2Eick4uaDO21nG6RZups49oSiG8wx4Ht8j9ds9IOGurNvOZgBUOndM+NTXOm2gAU3eFY0VfnRHa8I/C7G0kEnaN2+fVDyXYy9V2IDKSm7CH8X3tcRm2OOLy2S4EY6p2t9Pg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(376002)(39860400002)(366004)(136003)(558084003)(316002)(8936002)(2906002)(8676002)(36916002)(54906003)(66946007)(5660300002)(86362001)(7696005)(6916009)(508600001)(55016002)(186003)(16526019)(6666004)(26005)(83380400001)(4326008)(52116002)(66476007)(66556008)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?33KxIUY+/LvgqNBVqlMKwJgwm02RCUtuUrbyTOIoIdxTVbubarlzDwSLXYvZ?=
 =?us-ascii?Q?VuguRtNDarZ67umVlX+kVFeA8oo43/DJ7Clv6PVT0ba+32RYtCVrZp+9PCBz?=
 =?us-ascii?Q?zMp13747+qv3GmW0QDSXUDngzU7tE8sjr2ZbD7f9xlWEUHUcEhXBEBh5eNGX?=
 =?us-ascii?Q?l2/ncbnKY3KK+p/CP0WNr8Ox7WXWCM6RvKDwkelKTrCMKwBfKqBBg0Ds8tDB?=
 =?us-ascii?Q?KDcccNrSEBxOJXdNMLfvcIpJ9uJMIYDvoZDpEl7jKr1X3DWyG4CISH0hoWZL?=
 =?us-ascii?Q?DuCoA9ueoTCKcpnGBAKI4kX1OsYma1G9RefIClkQ5a5j7HpEVBE2w44KwJQv?=
 =?us-ascii?Q?sFXn0ME3ymaO5cqJ89hgYZX/0oRhjv9UvFYtyC2nmDdW0YGDz3Ud5FUcvdD+?=
 =?us-ascii?Q?0hpsWcy3T4qRFJ3dMeDGRsRtLBU1yK5vyc4cyYXMIGNlEl0r7YnfZTOIV/fM?=
 =?us-ascii?Q?9sKeQtKyhT4whNhGLEe/WnFXjFjIKf4K5Ngm8shAf9xb8R+kMYpqtxcRgHrz?=
 =?us-ascii?Q?lIahEx48L/bDl8cGPBGOuNDQdiIIZhjLQYsx4enP/35I8bDkvbKiuYqCaWEn?=
 =?us-ascii?Q?5T4TsORVVCxIlCLHegFY0njcVgsxrYorvKSOTnZWg8qUspCeaSakXacTqMHg?=
 =?us-ascii?Q?lXHKmf9o+MYpn00B1LUUUDmksdBtz+UA39IVzhkUikQuOIeDPVyxkMTUyTLt?=
 =?us-ascii?Q?HVtD5mK5obpQHMZU3JEmlUJ0dGrjNqt8qo8+KwgqMHBoL0FQKmmce9IbwOYa?=
 =?us-ascii?Q?8cxqSJ+iKZiWeV5DMeDoMDWaAOcMTpk8mJqe4vl8mO7oNUD1QDazJvyrAM+d?=
 =?us-ascii?Q?9K3MQhiqFsvxSMc3lTp7vLjznn/owK+wCYm9aKmwl3KClJDzS/sGuyL9Tt5E?=
 =?us-ascii?Q?t0fJXRbxRW29MCwryLOjeis2pMoRhoaiMJQa/CEI8pf5qO+avmYSNK2DRMjP?=
 =?us-ascii?Q?pUdpein6hjcO6v/1zV773wDyPJ064c4MNQBTOnHigixik1RPo0Tv3zL6a80M?=
 =?us-ascii?Q?tZp+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ce18c42-4489-4bbc-9cba-08d8bdb5bea6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2021 02:39:15.9101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nAGn5feLEKYmKoxbunkJDVygyEivPkjyf5bYeO0W7UUgsh2+m31MfriaLI2x9AhxCJ4JTuWlD1inIeMMPEVne4jyfloqp2tYkDmQkKYQZsM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4662
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9870 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101210010
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9870 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 adultscore=0 impostorscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101210009
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Colin,

> A block of code is indented one level too deeply, clean this up.

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
