Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC20EC48BCF
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 03:22:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B38AD61418
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 03:22:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhFJDYU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 23:24:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50008 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbhFJDYT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2021 23:24:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15A3H9Oc196357;
        Thu, 10 Jun 2021 03:22:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=smjqdgeIrbkNRsAguGapSxCHO12ynPgGPiNMa2g1oH8=;
 b=soSSBAWpuLrhEZ+2QeEjQVkPlPSwL7BohKpdLkeUZuWQyqhVT21aOyfmkKR7pwkAfFcK
 LoxuBmcDQ8wc+EC3hlGGOkuMTgXLkMMiHZkaezHZHTPQVYP1Gj2Z9Jy77jEsjdD266DR
 tZEeWoZ38mFXGT0u4Q/8QQVXa6v+z7QX0gNHpp8eAIvUkIGi44M/o9wjzvM6enLz+o91
 ODyC5hfm4TQEb0dVmruq61M46XL7H5mrULnhbkUOagHTzt47rcrleQ2KB2vK2BZIYUz7
 fkcfhB9r9m7kZke+gMqpakmsRzm28RF0z7BH1AMFB6Iv1p8UJ14gc4h3qAkpxS8wY7JJ hA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 39017njqqp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 03:22:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15A3AeDj112800;
        Thu, 10 Jun 2021 03:22:12 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by aserp3020.oracle.com with ESMTP id 3922wwwvms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 03:22:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ecxYz/vXVKMBoYE451jO5FNX3vq1IA9hAGy7jsV7oDdav3FEL/QoVkUqITJIWGQEKaTbaWhznP+5NukBgz5smTO9HRtUtcfnVtFH8W4iKFp02CiqjEpjIml1xQxUv5m8Wr60AGKLGzveQcvP7daibTZ3PZRWMNmkO8YGwIOfNQA0mxYeHxdNOofcdGcPw46sU7dc9AfgeC6xSbuqjCjOxVnl8Glk1iTVsY+kOpBkspTIvp1JsiEzc7S7/M6aMtWitgk8ICqB3+upquZGPvvz6FKTyKQM7Pb3M5gkGHXFkNvxX1mRQE1TXoE8y+z31TpPH95V1Olu0a5weGV1eLEGew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=smjqdgeIrbkNRsAguGapSxCHO12ynPgGPiNMa2g1oH8=;
 b=ac2wNQ+ciOCBrW5Y3yX8YLB7Te1s8yNLGM8rdvUjAzMsg94GMeRWomoUaanV7iTuRa6UhBsSGWNmt8T7Hc8RHSQ+fTOlJZjNGpC0WO7W7VfPeq1Fgk1+14cllZZ0OKW7kx7qgbaMMId/w7qu3tNrrU88yJfcXdGDYrXruHbaV/YGMsZOXVD1PRRGKotfAgKb7ieez1TGQknQhHQkdhyEmT9cEIYKVn5OcukxgalE0hdM+7WMBvlcujdhJFf/EqRVvhINQZsM+rLdQUYIpnxu3oELOArsjRKu3Jw/feeyqPDuH4lhZvwWfUOki1yA6E+MdMJcJ06wKck7KQqPO7Xnyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=smjqdgeIrbkNRsAguGapSxCHO12ynPgGPiNMa2g1oH8=;
 b=zFdo4vStK2clf/IdABNEoRtmwH6qNldFNEGogmGry1HpMcE+BqO2jB9pQB8nWucq0XXOBk4Hk1iLHc74AVcLv+obdiBYYlPO0RFym0c7+DPEvkFYKQqj5+zrkfpoXw6gdWI1TyOHgkWhm7MSHufEBhGRVocGDmUqDLyB4iuLyfM=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Thu, 10 Jun
 2021 03:22:10 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4219.022; Thu, 10 Jun 2021
 03:22:10 +0000
To:     John Garry <john.garry@huawei.com>
Cc:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: Re: [PATCH 0/5] hisi_sas: Some error handling improvements
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1czsuflpk.fsf@ca-mkp.ca.oracle.com>
References: <1623058179-80434-1-git-send-email-john.garry@huawei.com>
Date:   Wed, 09 Jun 2021 23:22:06 -0400
In-Reply-To: <1623058179-80434-1-git-send-email-john.garry@huawei.com> (John
        Garry's message of "Mon, 7 Jun 2021 17:29:34 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN6PR01CA0013.prod.exchangelabs.com (2603:10b6:805:b6::26)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN6PR01CA0013.prod.exchangelabs.com (2603:10b6:805:b6::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22 via Frontend Transport; Thu, 10 Jun 2021 03:22:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f0636629-7fb0-4d8e-1c63-08d92bbeeef8
X-MS-TrafficTypeDiagnostic: PH0PR10MB5433:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB54339F62DA1BBAC710BCD7E58E359@PH0PR10MB5433.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 938UlbZ7RfIUWjvBJX3kit4YoReIzAWXuZBIq/9Yez711G5MUOmXgr8nywTzYyuGi/uhUqErYjTZKAdyBmnKUH22xw1/Iec2bG6pv1mrkk6+b8i4nUfdqn46nI0B7cmqxiK9Sh1A0480DbrUeu1kniyBTpZjJ7jI5JDnuzzWGHcNJ/llvy+3I62lkOlStF1jsauokEFIpKQuCAaRymnAbqkxxYVyqri451YDr/NKEvD/qZPFMPUdRmqyrosbTFbSfPyZbWUIS74+mFSvZrnmErDNSXTznmBog+46Qkdxx2xy/X+1NS+PrzQClm3NefKVSqugs/+py0bLkuHmg/s5IdMeVDzAwY5j27dQoNsfluxjuWdCAr8dkvpX/BluNCsAycRdBkPN9vfeQglyNsRdv3mDakZSLVl+o69eUIk4qhANdtm9FoAaSqbKKKa8v6fl9X7buMpMxj0eYTFHPWKfoG++oSo9Us8EoWJc+F5A3Mnc8U6jYKeXdcjw4pm4fmhhLHVJLm6ps0YLQsXf9RAwdQ3NmGuKJjWq8rXEopgpwbvC4DlvQ8Ce9sM1GVgg+wsKHJuSfIJqJTArMoCzD5FtCS7rZM9UIncgxqkVkZ9Rb4NwevigbvWNj3/Dt79b/dsACb1hVHvG6Hf0V0hT8L1wOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(39860400002)(366004)(396003)(346002)(83380400001)(66556008)(7696005)(36916002)(52116002)(8936002)(55016002)(16526019)(186003)(6666004)(2906002)(478600001)(26005)(38100700002)(8676002)(956004)(66476007)(66946007)(86362001)(4326008)(54906003)(38350700002)(5660300002)(316002)(4744005)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3H1mnX39gxk/B/vlpQZLmCABVj7AY2bXRZNQsi7Xb+C85tmEStvCGAJCYz20?=
 =?us-ascii?Q?QtlZBEuOXq0J0NEGsGUOdzQRZV+qhRhpx1nThElKPwycYmwj2PMNg73ll9mL?=
 =?us-ascii?Q?ZEor1v3wUCNOAS+intYW3OJ6f6KQPvsWTaBfQyBVFc8GzO1NLWjo34urhkca?=
 =?us-ascii?Q?B9nit///l/UwqhycmQ/9Fh27PhvvhQ6cBwxnxl23WVMR/qpYkmx+tsgD5z/t?=
 =?us-ascii?Q?a8rlSPa8ALjSLAcLr223CNP0XkCyVnCefK2l9K5qrMGu0wk/Wpy/IU8snlui?=
 =?us-ascii?Q?HSTjQRBFrF2qPIYs546gT41ldz9FDgbvfH5/OQabg5Q1VEKo5oRRgKRFF3M+?=
 =?us-ascii?Q?b9+WfR/jeLK2VjsMIMtOEUrHI0DkDhsdqqk+M/LomRy+tImATR0s0LGDBV9E?=
 =?us-ascii?Q?+yu0TM8PMlbi53aUJflXO/aNnAvJH+uHsYfB3mlW+RoTHHOQTUOZaBPq+1NQ?=
 =?us-ascii?Q?g+4BnquZsWFP7Og0/+altuOsT+K9n9jgnKyYhZ+yMornULRXZye/lQcOfe2R?=
 =?us-ascii?Q?8xT8b0N+xG+qbD1UC+uRVpenMRbOJQdKvEEggi711v+3ZMtQwOWwT4E50Lgn?=
 =?us-ascii?Q?xjpJaRVPfgOEG1Se9N7/YnTP7c/StLBql/+MV7w1yxJh+CYwgM8fRBgGzsLn?=
 =?us-ascii?Q?xPnAey/ynziaC0xmyGL+APWuzIv/gO+r7srGntynt4bCEn1iLs9BcR0c8AY0?=
 =?us-ascii?Q?GPN66Ns9DrEcXK4yjQiJe2+W8WfZJTPr1O+xl41ihmgu97nWV+WIZKqjIPyH?=
 =?us-ascii?Q?KN1YQNcBWSo66Ik7IJWsD7NL2GIKGpL1D0zRs1ovIIYhDGAy7rpZWztkX65v?=
 =?us-ascii?Q?L6tcPGapV1Uu4Q+AL09wg1/221PsOfAeTacoSORKFqf86LnMufOjNtEhJxPp?=
 =?us-ascii?Q?AOPyUnIRNhrj8RJyG3yL8nmzgVQ13CTBek5+NQlQ889wzTpQXY3UhZ+wnxZs?=
 =?us-ascii?Q?pddR3FGLgyFeHme2LOdSVxclAhKHANo5GJXoKyB7xQLo68m1tmaPeweaE6X9?=
 =?us-ascii?Q?jg7Lt56SMcVNBPNhQNCRXGJYIpXoXT9y6oGkus0sbWH6kUuvV5Cn6+OYbyas?=
 =?us-ascii?Q?H8PxKRHsi30gUVTakkOUZbGAgl0YTEOc7wcdutZ9VmZQNMEtMAcmZvhHUD1l?=
 =?us-ascii?Q?aouwZdu4YRcjyBvuf7P0V80uifGen3u48HeoM20BdJfezWQOq4MuZeIk7XhO?=
 =?us-ascii?Q?KcZM8bdzPYZ8Ob2lpWeVh4+AyiB3Y8QIb2J6F2DnxbMay1GB79El9JpPXnDe?=
 =?us-ascii?Q?KFGBa/uWISNIGN1MmjSZAaPiqgqM3ibxJyqp7U9+B3w5x0l8+SOKhvua6/kn?=
 =?us-ascii?Q?hsz+mBes7hGCRFXUxaOIf86F?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0636629-7fb0-4d8e-1c63-08d92bbeeef8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 03:22:10.3759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v53mTlENr5417cf5dQuBlTeIsLcFAvry+YLb/2qJgjQb+j5RvgWq3jFx2xWQPyJGUC+eZ92pgd35ajW5I3C/Ic+WKPvuGhIgKinCs98tWgo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5433
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10010 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106100019
X-Proofpoint-GUID: L0ba15sq-7UFyKnF_2TukO_K1tVNtySd
X-Proofpoint-ORIG-GUID: L0ba15sq-7UFyKnF_2TukO_K1tVNtySd
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10010 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 impostorscore=0 suspectscore=0 clxscore=1015
 mlxscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106100019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


John,

> This series contains a few error handling improvements, generally
> speed-ups:
> - Put a limit on link resets retries
> - Always reset controller for internal abort - it was only occurring
>   as part of final host adapter reset in error handling process
> - Speed up error handling when internal abort occurs

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
