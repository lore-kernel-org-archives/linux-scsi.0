Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E1B1C433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Oct 2021 02:57:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CBD660F70
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Oct 2021 02:57:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244921AbhJQC7Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 Oct 2021 22:59:24 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:46564 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235798AbhJQC7X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 16 Oct 2021 22:59:23 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19GNwANS011812;
        Sun, 17 Oct 2021 02:57:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=3tD9b8ps3XA2yr7x34HAsjd20M5WiJi6MTpTJ/2txQY=;
 b=TcVCEcVRzAeTIiOftyyGJR7qZdCxPNcq29tZUkxmSu4IrGBUet5BUfjdkx0Zc4cPQAmV
 wqddFmbU+c2Ps0YoeEwDn9ljRxpS/UZeWhQFuQaCC5lNK8iTC7qrIbS5TdYx6+Qu92oT
 uTq7KGGsQRD90DpkE6kOqjdEDq73uLwOGiNtcBNAjeEIy0fNzjGgmKd7MtnHnSPWzw0G
 W2EVT7Sucb+xgvdN6aln09QTuE5ZWvEsmqqs7yPXyQ9rkpeAXL5YYpqXWrEV8b4IHJvJ
 xM/U9TNmuPTyoib8JZ7/K0ZGYPwJ03bsc3ptgHhUt9RvC5J3fido5FBWndmFnb10USDC 1g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bqqm49rbs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Oct 2021 02:57:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19H2oxvU152102;
        Sun, 17 Oct 2021 02:57:05 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by aserp3020.oracle.com with ESMTP id 3bqpj28ub2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Oct 2021 02:57:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D/IErJ5OQd6ZvutrwBPqggf6ahhmlCYes8SC7OwwapvDNKUmJ8iyOSM7b8XpIElwp5QyNfu9QXGaLQIpJjyEiu8jVcHqKAWJVRyjhzh+6ms8TZ3kZlp6DJJE7ipdNHHNtkpOTgNpc7umajl+9vE4Zc6K2qTxWVWr+DTduuEJ3yucXWL3iKVU7RVOx3vrKG3ersGPkOFyPO0WR362h7bbh1Tbaf/J6Sp2oHDIpdrwIZbjCuP1vT0KLdlAgvwMyvdQikNX02RQ1y0EDNN09zh9Sh4goQkGwlCjcLBCQ8dUFZLaXDpSx4Ufbgk45QZVKwKzf0Qu63oAOtLj9oHw4+bP1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3tD9b8ps3XA2yr7x34HAsjd20M5WiJi6MTpTJ/2txQY=;
 b=Hz7aXfgtqy/kiWLGNzHKFh3nGkGZ+pnIJdmQ6xta+6knkaOBNahL+Vlqpr9nfVfOU8BpTqUxZC3FYUjVjSkJ3G6hum6ORttStgM38JIMAECKV6CedVdLSjjZCcdO1ONNGqwRBQA3hvl/5kc9D+Axe4T8b2HB9b1GKy8rthXsXv40LRtW5gATa4ttyfXPLkwyChm8hGBcI0cwhzLV4WWV+/IAaWrR3Hk3VR3/tn9r9erfz20JdgZjYXHA00kcKtRdhFr1gNQs/gnz8e3ZcV9paikmmMjBFuErYaDyOjJ98tSy8136GDNLHraN5O6+cGXqgT3e8T7YbSKyZI4eFTgayQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3tD9b8ps3XA2yr7x34HAsjd20M5WiJi6MTpTJ/2txQY=;
 b=MNAW1i2uXmlAphoS6gobyT8JBu259kUOK+0nQhg/eqoLPYdmD38YlOXQpJQLV1szasht5hAjDqc9QsjRiFvFxwn0IhjR1uNWvsr2TZa6hmV5W1h34HOEX+o5FLPBzARy/wFWII/X7zwHKAjLD+qzJmDpNynYlBNIs0rTWfYPi4Q=
Authentication-Results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5611.namprd10.prod.outlook.com (2603:10b6:510:f9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Sun, 17 Oct
 2021 02:57:03 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4608.018; Sun, 17 Oct 2021
 02:57:03 +0000
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <alice.chao@mediatek.com>,
        <jonathan.hsu@mediatek.com>, <peter.wang@mediatek.com>,
        <powen.kao@mediatek.com>, <cc.chou@mediatek.com>,
        <tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
        <chaotian.jing@mediatek.com>, <qilin.tan@mediatek.com>,
        <lin.gui@mediatek.com>, <gray.jia@mediatek.com>
Subject: Re: [PATCH v2 0/3] scsi: ufs-mediatek: Fix some defects in MediaTek
 UFS driver
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1zgr8e4uh.fsf@ca-mkp.ca.oracle.com>
References: <20211016005802.7729-1-stanley.chu@mediatek.com>
Date:   Sat, 16 Oct 2021 22:57:00 -0400
In-Reply-To: <20211016005802.7729-1-stanley.chu@mediatek.com> (Stanley Chu's
        message of "Sat, 16 Oct 2021 08:57:59 +0800")
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0122.namprd03.prod.outlook.com
 (2603:10b6:208:32e::7) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.5) by BLAPR03CA0122.namprd03.prod.outlook.com (2603:10b6:208:32e::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Sun, 17 Oct 2021 02:57:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed5e4697-5485-43d4-4209-08d99119cbc0
X-MS-TrafficTypeDiagnostic: PH0PR10MB5611:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB561141BB38F1835ED213E2D78EBB9@PH0PR10MB5611.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OCq/Wy8xQSlYB3xSfZFU47ADDcxqMXbNlu3WxfaKt2cyvG/ICKzsjp8EtLU2Sl+no6JE27JxCkq+MC3p4jalQDSuV/oJf+NStTzm/mJKBcNCYbYlQVBBgEsoa6+jkDWkR473Ti43Mdaw6Lr/QsQx068WgtFTW7A0oPppIgirymxXpK8SKRXpgEXFXXiD2cV4jORzdl4i32Wkla98jOvxDD7k98ID2fzavevsjfQTf1aug1k+LrU+0B/0Tq5WLK0tpaz1lZum/34e4U148P5KgFMw2VRkQq30A2aUVKVA6YOD4eoAoMFAQNNoN5Dra3XhR4TdUoJ9bYNz5mAC5Atqux11SVOYTMIIHxadSQ5lASenASkkXPUuxFugReQH1sF2lH3DpuzFTlIbDWmcGLmtRAe1sCE4mUzoRQHetTsAEJ3Z8zDQMg/KXot94JE0Rr8hHCtV/YmgZ8zqElV6XvRU3QI7LeaJ5nV10MgHLPX+T1nDEIqm7kcXYZC8uRwWSCVc3bsuBx73krcqHFUB4q0BuNF6sLgcOtO7PsChsaEQWEGguv2T2/x92kvls/soeMCW/GYIMR5xgCfBk9aRVd81bBpn4hzMPEfCUFGzYthxe2j2gOYB7agSlVtxxteG3UO4aY4nesqiegfqeeEm/PuWdfINxJkaraERz9EWnLfZ1kQ0TiU+szNqSdGeChT7m25v
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38350700002)(38100700002)(956004)(54906003)(66476007)(7416002)(86362001)(8676002)(66556008)(186003)(6916009)(7696005)(508600001)(2906002)(52116002)(66946007)(36916002)(316002)(26005)(55016002)(4326008)(5660300002)(8936002)(558084003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LkEVtEMNkasRTFELyoG9b40tgOfrNyIV5GtTBmzGwYPc16kbDOYMqxvZHkPj?=
 =?us-ascii?Q?tlytZO6zFmPUzwfBT/3hQjksZpzbaFErdD72EVJDiOqvJcS0leCSDq7bIBnV?=
 =?us-ascii?Q?68d9rB7Jeu4MxoM+kmJJ29suBQ1drHKCvEySH8BZLPNFBBm3zvlgowv4+zvU?=
 =?us-ascii?Q?Qxl3uAVAYOcvzfptMAIFNk73qkHeZ9GIbD8dTAqFUtMbqlRHqI1oFHCkAhSL?=
 =?us-ascii?Q?JkRS4ZfM9ckqvf2Yxv7GJb+s4XaVb9wFH52i8msDQpCODVLyhCp9miP7egyM?=
 =?us-ascii?Q?HlqmSe2vpSzPo84aSQN66RXR1yb9alcFMTTTyiIetwwMtfUPD7eu7iSNSaSh?=
 =?us-ascii?Q?VXGzj0lcTTqs5w6F9h37jYmSFD+vbIUoEbR7YOXcEoLKu4i/0gOD+f7BJA3z?=
 =?us-ascii?Q?6lrV1CywymLGQ/Wxo8bBqqQvCPOuxYrnYO2yuD71nlDMzoT3TC1dfyDJ7rpH?=
 =?us-ascii?Q?5L14EwHr5g/G25eYaK9l/Q7A82Y2Mnbw/JIrzeX3/KXFP2/wKQvgFmYC9MJk?=
 =?us-ascii?Q?+VGy5JgJFYyyMGB5OEXBkeupidR2BnLzsMRCtBRlSNlbmi7YW9dpvXM8XaAt?=
 =?us-ascii?Q?TcBgEmOoOgwDIi5GJHtpL0zgSrl013bJ0yBV5Ig2r3TJDzgBjzzeNa9zqMb+?=
 =?us-ascii?Q?BuiAEbSoshuFyHdY0JGTvAPggVpJzHIvZi+vt+7Fizucy222sHHOccJZ5cfV?=
 =?us-ascii?Q?3aI0UjevwJJpR1WQFcfFHA/o9dqPOnakOFvWu6cQ9UynhJDN20qCXQdWX3RT?=
 =?us-ascii?Q?WLA2u4Q/omjeL7NYlLuE+K35urhyuCseu8Stdb2Z4VTLUL9elvSoad0Jhp9c?=
 =?us-ascii?Q?Vp/Fayx4j6LZflHIIimpla7vZf4hjbm3i/FKPf0xRS3qT5/s2TjFfK9pkYyc?=
 =?us-ascii?Q?Ev0HCjEwfsVw8/GTUX57/2+asJ1ABvxX3PMNHACtzaZsBjD7VCU2puUqC5Mj?=
 =?us-ascii?Q?ofdK82M+Ce2ufxouEKVxi9o0PfRIbdrZRj8I5E0of3UyUZc0yWVf6Hwmt413?=
 =?us-ascii?Q?ILyatZ7h21Qaul1a0sSd6TzkEclFyKSFydclAMh+yAQARmMfP3fS9alGo4UY?=
 =?us-ascii?Q?Gv1G7XyKJyfp6OkG+OsCmbaQposPlwNK4bfa4gzhumvmtStDvxrHIa+BK1jY?=
 =?us-ascii?Q?MePUYAkxMIwYsu5vEzIqI3qTS6QzCKgwlfsPrf9RoWw4Gr6fYACt8wvzY1iZ?=
 =?us-ascii?Q?go9NSdmupWuAvom8OTbBuHHRYCQltfYlQ9qu1fGzjQCWinewidsevyJBYqrT?=
 =?us-ascii?Q?PtMAcH29KmbH+rHp7+mspvXqeDw9RYGPfRR1PslT5JZ/c9n+t28+MQWh6rhL?=
 =?us-ascii?Q?S3hiTR3tXf5pb0Zcu09dww7U?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed5e4697-5485-43d4-4209-08d99119cbc0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2021 02:57:02.9255
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1T/jAqg16jUJvvcgYfxCsYm3nbxfQ8NBKXItkE8NZThx6ujKy5J2/MJdZrdJZ31LOpdKs0uwd+4/0VWmS6ZR/lOftea+FANVSevD412pPAI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5611
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10139 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=897 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110170019
X-Proofpoint-GUID: Pj3cujL6EtaLLjZPzfms3EIBQY7SbwbV
X-Proofpoint-ORIG-GUID: Pj3cujL6EtaLLjZPzfms3EIBQY7SbwbV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Stanley,

> This series fixes some defects in MediaTek UFS drivers.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
