Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8E5FC07E9A
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 01:59:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE441601FE
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 01:59:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233505AbhGMCCR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jul 2021 22:02:17 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:22260 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230000AbhGMCCQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Jul 2021 22:02:16 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16D1vKvt029405;
        Tue, 13 Jul 2021 01:59:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=yb51RAFrVJNj5WPBpt1sIWE+A9IBwq9izM+M+lMLBmE=;
 b=f+usWD2F0/Ku4N/f0Z0tgliAJM49WcGlgx8A89CKV0/yi3EPINqmjVUAJF0sEO4lcS2W
 9LQm/4mTcxX1pTXZnIK5kiVzRTEeOhgONhZcYnTzLHsRJJ2+yIDz9PmKvZCyCW9Nzzlv
 LeeSyHMJIUGFAbhau0uUBUjA+c9P/FC7ikVhc2cgBgrwltifSfjrsGMnD+8fZ7zGiOfR
 kC9oaEqWEOwGlQBRckCV/Cn3bFDYQLgsA6DMOYnWufT1F4I7zOFgpkHYtmcspp1DUUW9
 HswBaCt7+euKdanblcPSNhA4M3I3ep/UfeEXAtBq6dvRWmHfUMyYYUmO7K86zD6pgdYF DA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39rnxdhf08-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Jul 2021 01:59:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16D1ssxu012820;
        Tue, 13 Jul 2021 01:59:24 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by userp3020.oracle.com with ESMTP id 39qnaw6bvw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Jul 2021 01:59:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=So9Jc03prCg6pWxrRa+hWumoXMXIj3I2HhhbodWPA5hY6O+psQG6oY5JJV/qkIp8sEsSwgnM1HjmePIqILDoLcYAlmju4vQYZlgmkISwvXTL1Qil2AYwFIZxYKzys+j4CUaCi+AcF7C6fUZaDvSX1TZJLTxvAqWfk54U3qZ64iIqTOUaR5XoRdFrlcIgdUUZylSkGwqM5tHdvPFQKGNCr5spav70V//zjwAHBLYW19te+gt4tWRSVZxjAE8MPu3dwoa97RxeEi0KWAkCJyGhr1A2tVNM8TEIMRrjKJZfwu1I/PBQbVyPb9byu0uw6mgOg/Hyu2lZsEsucCBySkMXlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yb51RAFrVJNj5WPBpt1sIWE+A9IBwq9izM+M+lMLBmE=;
 b=GudPlL4sbbUd2C9PRr5QLyUqBjo16u6sN8C24syGaQT9m43tkFRbnBVn3kCrwZaCi1L86+wA6X92bXzYxx0Fy8qidtYfuFdYEY9kUrBXEqopPE37a2jXT+V4BF4984EugtwjxV2/h61Xsbpo/A5CRcDnUTZ6QF02WTltO2SmxkL21d/Wj7nH0P0L77t1mahh0N1EPVojuZ+JL4jPTobubeCnF/ZkISwxRILQlPPInqWKSw1JEuPttM+LqPPX+TGCvgtTSERBvMPE6zuD6nB3g1dqYjOBAGPdkvGac6pQ88uCIz6eroitNVs8L07OeY1Xl8szIN4Yq+MfdYPKZcYK2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yb51RAFrVJNj5WPBpt1sIWE+A9IBwq9izM+M+lMLBmE=;
 b=fAGnvYvN0OI9mu8EaUw9KIWdmOKZscrA6TykAwm8gyEcMArB2qgDuWw8NsQZ7Di6EtUvIAACxt89/WTD5K00+/+hNDf//tLicST+tWnlTMe+rH7soanES9cSEge4vfn0NSD5fvkCgXgz3yhwr0TQ3tBGaUNbarxgHNQYjggOPe4=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4519.namprd10.prod.outlook.com (2603:10b6:510:37::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21; Tue, 13 Jul
 2021 01:59:22 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%7]) with mapi id 15.20.4308.027; Tue, 13 Jul 2021
 01:59:22 +0000
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        thenzl@redhat.com
Subject: Re: [PATCH] mpt3sas: Move IOC state to Ready state during shutdown
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15yxf5623.fsf@ca-mkp.ca.oracle.com>
References: <20210705145951.32258-1-sreekanth.reddy@broadcom.com>
Date:   Mon, 12 Jul 2021 21:59:19 -0400
In-Reply-To: <20210705145951.32258-1-sreekanth.reddy@broadcom.com> (Sreekanth
        Reddy's message of "Mon, 5 Jul 2021 20:29:50 +0530")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0401CA0001.namprd04.prod.outlook.com
 (2603:10b6:803:21::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN4PR0401CA0001.namprd04.prod.outlook.com (2603:10b6:803:21::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19 via Frontend Transport; Tue, 13 Jul 2021 01:59:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ae6e5d4b-3366-4734-e0d0-08d945a1d5b1
X-MS-TrafficTypeDiagnostic: PH0PR10MB4519:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4519015B0EA4F3EB211A80278E149@PH0PR10MB4519.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4TvKB5nmWt47EzXEvnj8aKehtQ0ETVS6KymdlHWqCW/jA81WupJzTu8Edxtebfu2Mcgd0v2vP9Exr0LPSDddUuCO4E4vzUPSCrl5dcCNHOCQqrDu89//YLvdVbZk9yYFfQibdzxTrpAY4/tUNJW9lpEwCWapJJdk87/DljDMQ1Ejz/GDJTZaSEe1nXNEWXZPe4hDWOEJbp9x1oamKLMy5GCuSgcgMXkj/i+HLAIKtUiaLumN7TivRp3ygMxf7f8xgkzHaJ15F6q/VEkf/Ab0MPY/mKhZsEmN0P3jzGJOa/icO+Lwu/PDQu34oHQq5cJ8Yp9lcJNCTCu9STmZyk/hBnetX/WhiNrYYIIcTOdS4FIiG5oZraNL9Rl3kd4PnTyYfCeP1t1Rj7ZlnHYZ+X31vIdwbMgx2rw/TatiUSSeoWP/44NR2cGS4yxPxU4HwGFKeJoSNNwOKfr2A2DQXOenTTpuGPrh3g8yWU72bMjtxMvXa6Y6KTWcyWmuoioNp2vOzA48PcCHLUKGIRfoQKwb1GLgaiziYobAOjbpk6uthR+79V9M7KeXiLB3uhwhQoarTcMpZxoeBh/H59BKrNZQBZ3YN8oR4XSqn+XKIbl5/Kotpcz7inZlS8An2OfzOSjg6yvHqwdd7ZYaH09zLqpzDd83u+YnO4Gj/9oxkjnc93fke+jVWxWRXUJJHNz9QNWIahKSl2GftS0DFN5nMwjpZ2myBmQ/RWCEbKcTiB2ONxI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(136003)(376002)(396003)(39860400002)(478600001)(6666004)(316002)(36916002)(186003)(7696005)(52116002)(558084003)(38100700002)(38350700002)(2906002)(26005)(8936002)(8676002)(66476007)(4326008)(5660300002)(66946007)(55016002)(6916009)(66556008)(956004)(86362001)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iMoCqJc/8/ZzgQ2qgZT7IbxkYAOk4l07jDfykr3wwuRnRLSwrpU+ULnm7lq8?=
 =?us-ascii?Q?SVRJkYsWvKk/Het56iuIU49m7lWx6SJxeudgNbJE50n+W0UIcmeVu62FG+pl?=
 =?us-ascii?Q?NHpKlzykAn0++rCw05OB0aezvTUdUjRIewYy7aB0KnlagG/D5g49Hod25Flc?=
 =?us-ascii?Q?rshwZhXSVTEUCnvmUPkGW7YF+6sCgiaw8J5KAWmBQjRqOPgF1yYvqswDdHm+?=
 =?us-ascii?Q?a+DGPE0pNGY9ybb4z7/OeaPLijcU4mswhj1SUI6D6mEQNzuZbEnv/Vtcjqd3?=
 =?us-ascii?Q?5pUqoZx1lrhHK43j0dTShtm3IRiSk3kAIh1IzV0AaW4crS7KDvX0j7GCHA7N?=
 =?us-ascii?Q?cuuu6w92r34GWYkUHN8DTWCmgem75RXQPNkVP2DzgsapRIlH3tbtMI/GCVRf?=
 =?us-ascii?Q?yvZOYEeGxdkxgAOp93LXPUzKWG77Tyso8vziia7M/YjaKMkEmo+hCKBhypCw?=
 =?us-ascii?Q?caciO6PFqwXhwApk6nka1uhxyha8pRI0fMmJnYB7Wxw0LocxbM1EViXsbs7c?=
 =?us-ascii?Q?asHufU2hZ7/syjph+WukSV6aDBOaJg5axE64IpIe8HwiCmsOSH9WbIvwwRA4?=
 =?us-ascii?Q?NY8jOjst0BN93KneT5NIEmZljAb0a/9cSMAjnqPeioZGwrsjhz0ccYrKtdlV?=
 =?us-ascii?Q?H6Z23sFptXmv8mKviHyfyQOYYpxmTHEBj4xLU7pqzu8R58OfablL0WsCqJLS?=
 =?us-ascii?Q?XsiP4m/uZaBcvHixSb+cgf/TiolbjwtHP58T/goIiVUFBrWV2Cpm9PMFB6IS?=
 =?us-ascii?Q?tW4VED1cTvrWFS+DgEvTZV3abKFvU4VOzzTRHu69gS2WVjDpnW8JI6O93B0Y?=
 =?us-ascii?Q?1hyTIgGiVDAkApVer3rJNrIvqIkTti4hhBsgTGCP2ZgQ8lgoqloXb/1JYXmB?=
 =?us-ascii?Q?bKTHsHaT+es5FeqrHjeCQrOAkudyB5KKTkFSKgVijjsepvxNfn6cfFAqVCh0?=
 =?us-ascii?Q?sjfDuTP/RX9EUv4sbFQwpH2gpaTpoBUYh+mC/R6PCcQYPkECC9VsUfPTpEjK?=
 =?us-ascii?Q?xlWJZ5O4R5vlfBhzaxRIzqEZEdvYVk7GdRMl4imtN1niGSxPaXVWCbpb99LP?=
 =?us-ascii?Q?ZnJwxWtVIpnEEcwVr+Z87EYUerp0Dhpowo5dyO/goTOphH/xdC0QZaebtV7Z?=
 =?us-ascii?Q?KAT0emDZO3+KcAr+pEWK9V7UVPOD3SynNfXCaxHK3Tc/TIw+F54WX9kOkUQj?=
 =?us-ascii?Q?yyefQ4cZN4T4JBtj77YK21GmH+vBksaf6q0q6g8nQ9V08O5oFoqSSKF4J7EH?=
 =?us-ascii?Q?TGJsxBDDoYzAQPb2vMoOL5TSBmuTLiAltPGFQx00oXL9Q7yEXrGoZ4dfLZ7s?=
 =?us-ascii?Q?yKfxo1nBlyoBYLDkSDZ0J1pq?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae6e5d4b-3366-4734-e0d0-08d945a1d5b1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2021 01:59:22.7976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IYVI52gCr+ai3ZXPjYjVvfR/U4sFApWYFfGiugF1ZE0ZljBW+Tt/ZkUIMhdkf4FfLCLekB3ulCJL9KTtMePeDoiY4TdRKjZ7g2S4v1XhFFY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4519
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10043 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107130010
X-Proofpoint-GUID: 5O0gwIhD0zppjoPVL9LhIdpKdp9kZMHp
X-Proofpoint-ORIG-GUID: 5O0gwIhD0zppjoPVL9LhIdpKdp9kZMHp
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Sreekanth!

> During shutdown just move the IOC state to Ready state by issuing MUR.

This patch needs a justification. Why is it preferable to move to Ready
state at shutdown?

-- 
Martin K. Petersen	Oracle Linux Engineering
