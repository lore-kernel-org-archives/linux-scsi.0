Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A4DCC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Dec 2022 02:59:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236839AbiLNC71 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Dec 2022 21:59:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235717AbiLNC7Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Dec 2022 21:59:25 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED0E13F7F
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2022 18:59:25 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDLOAIg014255;
        Wed, 14 Dec 2022 02:59:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=bLRTdVdbb2NuS6IH8HV0Px84uEBMm3ElgAwBHLQj7dI=;
 b=MTrVmUOsCJd7ZLUlfne7cLiyKhrbeYm4TsCwSQaDgAimKY0BGRlNSBcergTd30QRDUyX
 7zlJQA/Xk3mUnV071vj5tSFUWQztlk2OoQ7p6RyK+lflm5UZ72IrrEDD3LLOpIfZ494H
 2uHyyTFP/b89EFLMCOolhXx5hCiq16E2KHxLTb7qm1GcI3wwCWEahjxzh2ZAb5U+BEHS
 fUbCtHtZt8+2/pCWAgBAnCRm8iAlM++UMWBpn19xwo1D+jMtEzyrTQLyTwuIEOscJteF
 NI2Hk7NSxOeJEV1NBeSkfP8n9Leh+NF+nnm6/FmTEajy9pEim5pB220NGdSMUOXCIK55 Bg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyew8ug9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 02:59:20 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BDNvDct031102;
        Wed, 14 Dec 2022 02:59:12 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3meyet8nb5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 02:59:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FwiBbeR1zr8m87p3UydqCadVNdYKIjAU6ZKoVtnZgYs1kjzmgYk9s54dl8BFsVeYafNwMuECh8V1exHcDd3sYECfbkOGQx1DRR/riHqSSwGkh2rYG6gs7yP3R9C4Or1wujAiot7pS+hDfkZwAD7WdEFZn+a/WLgnJVx4F+fh7YnCFyzkO0uKH0tIeYhvnIg8kEV639RUZ3h+qIMzPJBF09o1HEQtftwpkGhfXBnFM4DSqL5LYwq2K+S85j6aJl6D2RZG7zqx/gLNDE4M4q7cIAAbE0heCULaw3vNXc8fz0MMzQn5q7VvkA8DPITsiha4upqVTOjPoAiFtFo+WXhORg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bLRTdVdbb2NuS6IH8HV0Px84uEBMm3ElgAwBHLQj7dI=;
 b=WGif7/KYQ3xM0UM8vTffiqRYdoGpHezpX/BU6BgM8MHBaWqtAnUxHLANiiAK1GtLNb8NzMuo6yCzgZA7Z18IgJBJWE6eL/2QSXy2i+OjlnBiB+08a2bMAjnbKxJD0LdI1ahB3yv3aeufuwuRQrwpod1wjBlaFyKw1MtYutnmNB1BFI+oNP3BeJW/w0OBTG1p1osPbqgz40ydGdqhPAmIFoe9QJYBSW7bPZ8UoaRafWl/JyqKHz+DuwSmeHEbRMhQLOIDOEAiqK6oUsTUJCwAfIWFsm73F477b9hTEX9A8Dkv52QnnbcrhCTxMP8Pqm4NwRAW2IwJZKUUMZ/8f+3CuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bLRTdVdbb2NuS6IH8HV0Px84uEBMm3ElgAwBHLQj7dI=;
 b=y9b++lbiDXADDQonGWUPMnZnsWg3LrJRHW6C3fLHX9YNCUNYmmfGMbo3fo4o/8Wl3+MbXf0F4BNuX1SvBzmlUkLde58BQlbRIJFYfx8zRvtnZATmaBhN+0PiB28tYnubAqTF5OFOG/r/CWXMwjrg7EFsshvM3OPTXCWGN92xGic=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH2PR10MB4343.namprd10.prod.outlook.com (2603:10b6:610:a9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Wed, 14 Dec
 2022 02:59:03 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::25bc:7f6f:954:ca22]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::25bc:7f6f:954:ca22%2]) with mapi id 15.20.5880.019; Wed, 14 Dec 2022
 02:59:03 +0000
To:     Niklas Cassel <niklas.cassel@wdc.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        John Garry <john.g.garry@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2] scsi_error: do not queue pointless abort workqueue
 functions
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1lenaeln8.fsf@ca-mkp.ca.oracle.com>
References: <20221206131346.2045375-1-niklas.cassel@wdc.com>
Date:   Tue, 13 Dec 2022 21:58:59 -0500
In-Reply-To: <20221206131346.2045375-1-niklas.cassel@wdc.com> (Niklas Cassel's
        message of "Tue, 6 Dec 2022 14:13:45 +0100")
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0400.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::15) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CH2PR10MB4343:EE_
X-MS-Office365-Filtering-Correlation-Id: 67e8351f-14cb-422e-9d6b-08dadd7f27f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fIJhZutU3vSQ2KXlz2N8WFOPCNRvssXdMqvIN9S4k4xUSPQ7TSkGA63NGwKNlZc92STToHd3k0HJEuD1TreVDI1Wp5xRBQCfU1QofmuA8+hLlFsb4CK1LoRNCFrQ0Td/vSOzYKQP0c5mHWMUHqpBoiSXcYd4MyoxPDn6ObRXtKwyR/HPPlGQDM1kNW2swvy4093heVwptT5/xGV0fVfmQzfkfXJfTbn0B6boZEv3Y3BtWZOQ5CYeJijDM6moMr6OgB13l/eOOguXXhOx10M3xfNAuafg8imbNUkY+gErhS7iTzUEVCn88cMenMXZcNz2CuzYtLIFFs0WAztNZublDCZBikZYMgRlK6j1xPdJNRAcsbtA43IgoDQO5uxWvKKwyienQSdeVnPmzVP4iYjwdTPp907mdLRvZi/PxFelFvFjQvxjB7kINpYxBj3pjo6iffBSrKkZ79EeTlShUL5m8+xVkP8DFOc4yOlwiqRhv7J4WcGBkl+qgf7iO/2EIT/FH9L5yLrjJMVb5ruiFczvw0suxAMsfRZ8c+hRmtbHMiAiRr9aFDEwgqVq0OcjQo5i3q/Q5WLaCMP76CILf4ae7T2VEgRFSwezy7wp0OFmXKw+ORlm3GNUZbeU4uVyle7E+Efww5xAIkGGZl/5ssEUIg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(346002)(396003)(366004)(39860400002)(451199015)(6506007)(36916002)(6512007)(26005)(186003)(2906002)(478600001)(6666004)(6486002)(54906003)(316002)(6916009)(38100700002)(8676002)(66476007)(4326008)(66946007)(66556008)(8936002)(41300700001)(4744005)(5660300002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VP7v5iuSIGUwkyd8PgdR1q06286C0xdCl/QZkTQa8QGFfBeSOew54dmM5j0S?=
 =?us-ascii?Q?QmRQOtCikqeuBCcYwkDA00xyB33ahg+ZmSOOUuUKciJyMPNiEuhdpMMvU9Dz?=
 =?us-ascii?Q?SxfT3kTFFGp7WCM40hzn5p33iRry1MBi2TsbejHimtc9ESnrha3LIQktNz9S?=
 =?us-ascii?Q?csinBFKXez58oUozi10RGeuPbFtp34jOrgoYqXQCyLBun7w9a+v11qlCKf3B?=
 =?us-ascii?Q?K1NAz+hpKJgCSw78WJHZKgDhw75YwCAK6T7yhFSWQDk582RgdjcJxbSY1l/a?=
 =?us-ascii?Q?kBGslm04QaWseveRkBr06hUaIcPTeueQg1wusr8iBAACtdpwfnivsi9MYlAw?=
 =?us-ascii?Q?/53Kn8leXRAnnHXEQq9X+vn8gqK0Eads6IaGUhV5d2j5dqbTvNuGv6YQDqWt?=
 =?us-ascii?Q?vOhkZHlnCOcQX2jf/NoJPSa9+xYzy1Z/gTz1t3vWHPUoasj4/O71Qw8GmIRI?=
 =?us-ascii?Q?3ZPw1laFl2hZDVvqpZ8R43XTWHQW1BDi15yWB3ppipF/NQOKSXb/gyJxGRbv?=
 =?us-ascii?Q?rEslPdN9dWWCfG5vIYgihcISr3vp5ujB0D63QL/BeAjK7tHnn8WaUNjir4Bv?=
 =?us-ascii?Q?ZCCv+GSaTvk1nOBKfhIGGdac//9wYVE5+8PKsOsLjuaRu8FX4qznrqIZmgCb?=
 =?us-ascii?Q?VE9/2hJ3wPVWpgH7cObukoH8NQ6g3TtItyMZi6PNF/7XKqyuTM0F8Dj2NJWZ?=
 =?us-ascii?Q?e+KVSkOLfxiS8d5yr7n7OBr01Yio3KA7XPBPSxLMkjzGAqit7pnZT9VKA+KL?=
 =?us-ascii?Q?a2rtDhgDAk8iBWsTJHwHruhrRO8W2Z2zIZOlOAj6Eui7M2nuhIO4mM5zyij0?=
 =?us-ascii?Q?Q26QUOhZiY6RzsC7ilNPUEw1EVOEPcC0Kfzue7V9LaFqOJu67knEnUdybIR6?=
 =?us-ascii?Q?o/dIXh03eqg/zpwpCKjO8oZ6BcHNB89RPsgO1dSjSNL28nn2BfaRBXYRcdNf?=
 =?us-ascii?Q?HbcAheyevvhrjeKxTtlAws2IK+7NaowYXbR4hRwZ1Grbcad2uZ+CyZWEDg4m?=
 =?us-ascii?Q?6s+J8Lre1cls/lMucZnoOQVdH2JTChuLbA3yb0qPTWlqepJMtXvI0d+alStr?=
 =?us-ascii?Q?uBmnOwHn1Ho4RB9fo10kZgh+liiKGCIkMRsFyVtFvm0EisGWIJUOKI9mcHep?=
 =?us-ascii?Q?7VV2u0l4foWxR5lJpehC6M8RlPxaQp55k9ombdU1JwwWJOQ4A6O2/6Ko4Sk4?=
 =?us-ascii?Q?rAqbZi+IrrrXzuz3BuVbeYRIhXL67FvXk20ezDuGo2gx8APbZteH9WhQ4iX4?=
 =?us-ascii?Q?iOKpE/kG+f/E3PUHySlf3qeMv+RzlbGqXSzQ53F4RAE4XFXIjrwEYSU4zOUE?=
 =?us-ascii?Q?rOmAkUnm8W78QFSaCxRyRoumI1eFrmbyNO9aiTSd4J806cX3De8AiyqO8MQf?=
 =?us-ascii?Q?KbK54uqFBSIIWE2PkcTON3NF5oKkwMuo4vx7DP0BhaHAYE16D/rRoBA/nA1A?=
 =?us-ascii?Q?R/4fimeG3pqW/UwKVWAtxYnoRSDg9hbYhawNQoYX0Qui5XCZIXC1DhffTcUQ?=
 =?us-ascii?Q?BLQaYdfroK1bAEalBdEixS+dc+BGaTMVTbubC9B6RRNztkkLxwNYRfy86fp2?=
 =?us-ascii?Q?6zMy67w5gmv5pEg01ZK1N+i71ejl2/aa1tZ0pbDrhN4pZ0UB5adz2/G9bsh0?=
 =?us-ascii?Q?4A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67e8351f-14cb-422e-9d6b-08dadd7f27f6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 02:59:03.1154
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AXB+4BQXkFug9pLJpSsRTDA737suwhALA38Po8MOXqSA8WsfI/AKO5/afU7jBIZfadiDFjANTFmCzi8KglzVtWQUi2fA5NEqjcRyJbt4bBI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4343
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 spamscore=0
 mlxlogscore=903 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212140021
X-Proofpoint-GUID: rJ_dG0kg9VrZ-eR5dvwkHVHjVtam7NqT
X-Proofpoint-ORIG-GUID: rJ_dG0kg9VrZ-eR5dvwkHVHjVtam7NqT
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Niklas,

> If a host template doesn't implement the .eh_abort_handler() there is
> no point in queueing the abort workqueue function; all it does is
> invoking SCSI EH anyway.  So return 'FAILED' from scsi_abort_command()
> if the .eh_abort_handler() is not implemented and save us from having
> to wait for the abort workqueue function to complete.

Applied to 6.2/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
