Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C77B8C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 04:04:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B02F61361
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 04:04:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232344AbhKSEHm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Nov 2021 23:07:42 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:38634 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232098AbhKSEHj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Nov 2021 23:07:39 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AJ2k9Q4031693;
        Fri, 19 Nov 2021 04:04:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=36EE5hsvPZZ/P3JjvpBQh5E4maY7vU3WZab/i3vdDhI=;
 b=UedAKHSrOAPzGclZZTd/Ts9Bs5zKfSFTLMG1CNpvIcXTJugsc1QSdE+P0g+lT//gxmjG
 6AIPSRZWchj88i3jyliO4ftt/nCJcHnyo57XFNcfvyzhNqdK+6SuVSM4GsRGUY1joQ0c
 QQeYLSjHw/HWdgERBDOL7oUVaj8wzaoMajueDlCr66yLCNth2m7yrOrouBTzEq5z0c0u
 wk9SBc9OBYIN8TlUBb6IbNpvBW0adCktz8t0Zkk9iouO0dzZrOzhwUGPdx0WTNC0jSyU
 tcYumakZBz9XpEyJkb3UvLmA0/hoXeV3nnhPvIyOSia5vkIp9qcP6MpS+L4o+HahbSCP DA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cd2ajufm6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 04:04:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AJ40mEk027427;
        Fri, 19 Nov 2021 04:04:17 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2041.outbound.protection.outlook.com [104.47.73.41])
        by aserp3020.oracle.com with ESMTP id 3ca569ncxu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 04:04:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nm2svgCvfjjfhMInEvgjtKxszNSkZuNsnP39SHPMH166BSjma5u3QBLE3KQfarLMP2FMXkVyQ/y/DCZgZXMJHUU9/q+dCmcejMv7oG4KVSfsFI+1WKkVrxkQU8BZEsJiAt5q2+kshBn7FEa/inB1YnB5ZqoEvEn4hYG7frYrW5iL6Krwpai1oCeYBpTfFFeUcOJqwB/u6ho7QDjndHfG3DuoO7kUS2FU+OUR/Gme+wYk66kRDAP7x2qTwocp+IFSSKKRo5clX9yd64+Ardd7H+JyAKav1nZroE8wNSk+qXpL6h3gN2e8hDOLR34evIP5aPZ8HgN7qpIJslwKL6Nq9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=36EE5hsvPZZ/P3JjvpBQh5E4maY7vU3WZab/i3vdDhI=;
 b=Zytxs05l3MMq9eVf0uzeLxg6LIrm0Sujg3QNg8KFIAhc18qc/Prhshy4rYAUwtlWvif1TNTP42cdrEKVdK78ts0Q0pOAM5bu+9QI/giwGVC8mN81m7SdYk4I/e9qopC1JfIDuaC1xp+xiygS30Yh0/czyuV8pCwfgZte6iImLZ6acviL3AcGw0KgZRdkt62SCGvkoPAkdKSO/HGiOj3WM7RH/6LlElkyWDr37rq6rt90ZCCnAXVoCmAw19pF45t4xVoFZ0+5cBkU2Y9DtxKciRbi/2XmX6FURFk0K1/A7vM3pGwDtces9Dcw2r6sEmhfOtnPyTYGJIYMGYQ1donRSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=36EE5hsvPZZ/P3JjvpBQh5E4maY7vU3WZab/i3vdDhI=;
 b=elu30j6PxOg9rSC9NQCEZW4GqH19EC18l+clQkepwKsR7s/iBspaYKELVxl6pmS9p3aZKdxp1pYWyiSoax1JOGuLedZRNkx6pVlPMlW+XV1rGVYP9V0kHxqNLlcSVGNleSP19SjANFNjEfaHB5qROcLEMWe2byNhozNi1AK8Xoo=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5436.namprd10.prod.outlook.com (2603:10b6:510:e2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.17; Fri, 19 Nov
 2021 04:04:15 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4713.022; Fri, 19 Nov 2021
 04:04:15 +0000
To:     chenxiang <chenxiang66@hisilicon.com>
Cc:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <john.garry@huawei.com>
Subject: Re: [PATCH 00/15] Add runtime PM support for libsas
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mtm06beg.fsf@ca-mkp.ca.oracle.com>
References: <1637117108-230103-1-git-send-email-chenxiang66@hisilicon.com>
Date:   Thu, 18 Nov 2021 23:04:14 -0500
In-Reply-To: <1637117108-230103-1-git-send-email-chenxiang66@hisilicon.com>
        (chenxiang's message of "Wed, 17 Nov 2021 10:44:53 +0800")
Content-Type: text/plain
X-ClientProxiedBy: SA9P223CA0003.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:806:26::8) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.14) by SA9P223CA0003.NAMP223.PROD.OUTLOOK.COM (2603:10b6:806:26::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Fri, 19 Nov 2021 04:04:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 241b3180-7ec1-42c6-3d99-08d9ab11a70f
X-MS-TrafficTypeDiagnostic: PH0PR10MB5436:
X-Microsoft-Antispam-PRVS: <PH0PR10MB54360E4A211665B14D8866128E9C9@PH0PR10MB5436.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:416;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RJ62gofntDo0bcUTkUVXPjiwA2AW7XuvLFwoNhq+uQHLWIkzf3Kl02xrWFlEBJSksm0nBWTm3kQXwMv7NHtCXsHEqGVztXHz5AhmYAm7jyGEjfO5gdffQjArKAjekn+DlxwH5uoN9hWYHx6+r8rt+NwRPl+p4MomzFAE6rh9QgNaf623ae4tdjzW89gtsd6OgOk1JCOxorCjAfnOb+IsBRUntb28MadcfZgwElip5nIxdIVKIVC/49PqHAtAQYBku/8i4YJqF/114KfCKJCy9K+A/il5jNiyRz75uPdQuvmJr5zXYcGYf50spnIWKyXNc8cpboBa2ijtQjXMslzwb5moscWNxlEg+Jw2Xvvht42vFan3I2/cB5O9wcDm6p7Vmr/w0gUzxbNULCjxCfUGNnoBd1Fu8kutvIO1xWMvODhCxSmduuS5iCjimnlSquRY7VXRSlpZa2ovo/bD422aBdiQSItUQfsyQxKSQ91eqpgPkz4/09o5oGqifEdAjMDmmtLbW1uV49qtx5ewRAF0juYwISd5ERQrmlMIjWtwy01uAznzg/tp11NG4S4zNNw0V5E4msUgAivneHg7lNjj67wcOiLSiXdrvZ1mBIf3309ikadCwL88C1gjY1rtuQ81cOytmZjseivolTUE+csqHRjqw41JSgmTf/XX8UkO/IRYOPJMp38o5YuQ+QdhMz86J8Gw0b++DD2jxHUFmmpn8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(54906003)(316002)(6916009)(38100700002)(86362001)(83380400001)(508600001)(956004)(26005)(8936002)(558084003)(4326008)(66946007)(36916002)(7696005)(55016002)(2906002)(8676002)(38350700002)(52116002)(66476007)(66556008)(5660300002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gGoWrMOhK5Zo4Ee+t0L9DT9DiSyUDNpwwZxMmGtgH5KnsTthUkpk+8Zd3Pdw?=
 =?us-ascii?Q?6xgEgdVnhiB0uAyUwnvAB0CIihWdw9L2YSeTQFeOyi5t9Tw3MjXNlB3q/ekc?=
 =?us-ascii?Q?bsEZEeQ8mjWU2oa+yGLq7rXVPFuNZjtPUKt+tBfKqzH6PjgQXT5rpwCIFv2k?=
 =?us-ascii?Q?/QtPbLcEPz1ji5qdgsN3vPgKSqmps7SGrSEt76RwlcH8ofS1KLefGi2lbYfd?=
 =?us-ascii?Q?v9H7HbYaWajKIwXxh9xTNQ/nO3e8cyWB5GCOTiCIpemXnegLg1NfkUM0ZuDc?=
 =?us-ascii?Q?U+1CzBrUs70EzuYeksk5GflQkbvpHJizv3fDEZMZxYzu00YegleMjU5dEOGM?=
 =?us-ascii?Q?4/eiwVFW4Zq5yDVRachnrvtXISXkIaFCbW4b5eSm+TQDk3T8TZ6WM+OLuyI6?=
 =?us-ascii?Q?HwelbcnEXPVhsbWNWdAAteu4uQvlZqrb4++GF+DFn2z78SvlQNYLPhxvpbSp?=
 =?us-ascii?Q?DtHTbNdRfVKr8FE0ItBVwLXy1cinnQZAPPdFym7Aq35GyVm91SCUTaR1kYk1?=
 =?us-ascii?Q?/0hD+Co4CyBmMa2HwGCjQ2q09mdIRTihiUNecgPflf8T8sJD/FG2efWDCbvV?=
 =?us-ascii?Q?wTHkqtRoz/SKrLZDOgpkhJpDXEFjiLJBsEqdbWb6s/GI7Kx1G/rvCJCbi/ke?=
 =?us-ascii?Q?pCz73sK3OxDyyxvb7qqDNmesEvLOGDbkZ2Oao20QP1eFVL/XTP/8LizwaPhJ?=
 =?us-ascii?Q?J4liXkb+9Gq4bVb2rxzMuy2iTt6ZtYzr65iYxvWZkenxdZ/bu85RsluvJ0yL?=
 =?us-ascii?Q?IXque23dPvr+oNuiR1TTFoUH9V5TuoCZf7D0w06Aw72S+E08cYW3XdaCtvoS?=
 =?us-ascii?Q?EjUjIgxeK4xlAhuDBKoMTYjuRcFQ9ZaChGkZzWJwbrHwA8CO8iiKweXm9wD+?=
 =?us-ascii?Q?xWCCXpmu5T5dds5Cgof1fwhRZMbWPjsoHUVaOTg7/DCPOXNJb/S0pJoCQjjD?=
 =?us-ascii?Q?4b2uGnli/B/OUAM+4JQWw9IyA141uWGZHcWmU0dS+ahymJqrWcj5yCyYxrKQ?=
 =?us-ascii?Q?EPc1sTfU2LXs7pYgeW0PE9xqQa/6ZphNi54e9y7CXyhetiCAsStP0b2s2q9w?=
 =?us-ascii?Q?reIMFEBGMXz8E4l+cV23mzA0pXsKAMgyepr+qySVQPkEAh3KS4pokB5MCrf8?=
 =?us-ascii?Q?TfN2VJ5L2Y/JOgR0NHSFbO4AhW9zMJAL8PtysMOabAl/1v01mDX+HS5rDjyh?=
 =?us-ascii?Q?dR/5pS7qag2Zgskki2TF00CP2gMEYevoyXVNGu5KidKWWNH9oL95jGQW/Li1?=
 =?us-ascii?Q?v7A7zpt/o00YQG+ciiDjvl6gJi7NpZLfkjQagrRT72A2HkeDjxEorwObhnzp?=
 =?us-ascii?Q?uddmjUH9WvTKAadRCOYA4jcm+2y9IzPPSiizB+YHJf9QhO5SYBUyk/0+EZOZ?=
 =?us-ascii?Q?mf8ae7f44pYZXa5yc9ufGtlQ+DuWd0iogDWBhPxxaDlv2oZLsHfkATVtsQSR?=
 =?us-ascii?Q?ercEbKGD4kXK6LpxbkFOp63W/f1cXNQ8kj1pUeZR53g1KwqV0Uxw60ahGLON?=
 =?us-ascii?Q?gKDgMUyMVYhEBVjaGqfdVh5i6wki0SDaoE5Gw2gH8e339hXSKSNxOpzFozHM?=
 =?us-ascii?Q?cGiMCJEK12FmDzNnKoufZkbFGLp/H4aDgj6T5b7oROCi45WXBXg/DLmMV89Q?=
 =?us-ascii?Q?P4Pog3lTQmz7fbPv/M1rtGYe9ZX9Bsqp9VlnRNsZMnqGfYeNlb2xSTTvSds8?=
 =?us-ascii?Q?e/cbmw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 241b3180-7ec1-42c6-3d99-08d9ab11a70f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 04:04:15.6219
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j2lut45UCC0gth8rjcz8c+AXttiwl6oA7jpyd4AHLx+Jz7oq8+I1EeWUo7055A3pVcYBD02joCiSRbf5lecVr6Z9jkFnH0lkETas/MlBP78=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5436
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10172 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111190019
X-Proofpoint-GUID: Z1MylD5mwx6Hei2m-3KmnKD9ntDdWkxx
X-Proofpoint-ORIG-GUID: Z1MylD5mwx6Hei2m-3KmnKD9ntDdWkxx
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> Right now hisi_sas driver has already supported runtime PM, and it
> works well on base functions.

The commit messages for this series need work.

-- 
Martin K. Petersen	Oracle Linux Engineering
