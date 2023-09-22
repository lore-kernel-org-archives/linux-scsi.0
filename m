Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1D94E7D0BB
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Sep 2023 02:16:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbjIVCQX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Sep 2023 22:16:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjIVCQX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Sep 2023 22:16:23 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C565E8
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2023 19:16:14 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38LIslWb031538;
        Fri, 22 Sep 2023 02:16:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=7hIisNj8Nqmx5WqeXaCavHryQahD1PC6wTZ2rryIrt4=;
 b=WEtzXMYu71a61AhD2WysIw0iTM4K2YIKXZDYjbseB3uZNU8uvDOHvIL8GMLKDtyM/joR
 JdsggzwHphRlwM3QDg6fr1Xc4JCZqYeQyrtxCX2kBqzpgMamg54ziqksqqSs0phAb9jE
 KV8HyQMT+Ap76RmSr+JOTorPHFEpUeGtNUiiv9TlWoGsQ/0J6dx5P1i4z9K+EnGwlfAF
 sc1pnJkwIW19zqAgkzIe5tAtObExELI9j6uShkjFC6pOuA0/pJ13aaG+eoFJoFKaYF2x
 rL11x2d4zhwM2YGnfT/sOWEzA6e7SA4upnKxVBVyNppZurXl0ILeKREUyIuJzsiQQGWd Lg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t8tt08mdm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Sep 2023 02:16:11 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38LMrfSs000940;
        Fri, 22 Sep 2023 02:16:10 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2043.outbound.protection.outlook.com [104.47.56.43])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t8u2n57ju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Sep 2023 02:16:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mYixF3vRby7mzhAgsi5+Cpb50hdbds9q4mGeV8ZOiSgvrv22/wQ2XZ+BmllWQqQEkYUctbQI9LEGEfLqfGYmoGm+qlOxrGPdWVb9LT7XF97ecdK0jyI3Jt/H/HP6IfezmtkUMzgDJpi0VNvDcbphIJTiRBLe/O+v0cgejSC7j3XSf1DUVt1H7zjFoFxTNAWjG6srFSnpmCC6gLhpmfwWmRe7j2hhVZQjiEsFwkCTEX0K/Dxc5QS8PfiF77is+6RsK0rt/tCNQOmj4j3BvtPVMxmL+V8ffJwLR1gV71Rxz9DqC+8A4RdwsEByzW5GGPKZQsBQEE418bBDgBqj6kf6ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7hIisNj8Nqmx5WqeXaCavHryQahD1PC6wTZ2rryIrt4=;
 b=Fhem1fPuyKUhwKBAJ4kMxThFImtD6Esf9EX8qqfM8/viAlK7MwzkcBGLrkCozrLXws1vz6omrT1UmgswxKz1ryA7ukGRwowtFIp/M/uuoSnlCAMPB2zb6URaDTW/yb0K6vlOymZycX5iO3mvJS9VdIqVke+15W7KGrTsQk5jnDAzZznnfA6XKF+pwPrWEbvrF16ksEPb0MlaSMUq4ds+C9jnDV/oN/Klbgzb30tGXKhEKGt47gQvZSWoRHNqRvu7cn9SnqvFejcgn1Y2bV6CIbgI5Gq+2zee7/qTLPr1d8/DTH+NeXx+c9/KYMSUbjQiETjm9Xh6cWlD/xB6xZ9cVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7hIisNj8Nqmx5WqeXaCavHryQahD1PC6wTZ2rryIrt4=;
 b=XsElZb8mZTNwak2PWTKZyCpZKzGDX2RZ9xQfaNkwBO0I5gIrMmCp1c6k5GzoB5dkFYGllIzWjoTFtoZtAHBiswAczKxiqOo9XiI3/ETJNVk/HVVZdSvpx4V2qBQDHijZxPLbgMDQrY3ypdSZY04iDt8NIq1LO4D3/f/a9Y9qkY8=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by LV3PR10MB7981.namprd10.prod.outlook.com (2603:10b6:408:21e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.20; Fri, 22 Sep
 2023 02:16:08 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%7]) with mapi id 15.20.6813.017; Fri, 22 Sep 2023
 02:16:08 +0000
To:     Tyrel Datwyler <tyreld@linux.ibm.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        brking@linux.ibm.com, james.bottomley@hansenpartnership.com
Subject: Re: [PATCH v2 00/11] ibmvfc: fixes and generic prep work for NVMeoF
 support
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a5tf3qch.fsf@ca-mkp.ca.oracle.com>
References: <20230921225435.3537728-1-tyreld@linux.ibm.com>
Date:   Thu, 21 Sep 2023 22:16:05 -0400
In-Reply-To: <20230921225435.3537728-1-tyreld@linux.ibm.com> (Tyrel Datwyler's
        message of "Thu, 21 Sep 2023 17:54:24 -0500")
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0021.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|LV3PR10MB7981:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ab6bad5-22dc-4e68-73cf-08dbbb11e1e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I/IZjtw2OlWbpybJ/aHOUohmd/LaVPKWawcRD1fBWvCCZ5BKGjrTM3miDStdr5n+i5y8XGZ+rl1hNBoGrMxrA1UPOpGouJ1IumW8ypRjHmOYTZ0pD0paonNPgoQaxLdQzGQPHrnpp2zQPtFQD2r7NwkVZKjBd3plGNZMPqqjhMuSLiPb6gdVh601P77P3jsXmqRTBuRTWCkpdr+wLpOeAryjpumg9RTu6wSbmgXMRPXFfEYecyA6MzM2HV+b7jkwCa20cKOXrimS3P0zZhUydRu/WIUIJMH8e4tLPm+FJMxQN6BgAzga9os3+ZbG5cOL49Gcy/FTeB92UFPuMQgc/4F09gz9XYS3r21cDwhHXWNIZj2YMOfLKeeJviahxwXUFyGE8mEsgKCVyw5h97aofbMzmrX9ghg0Wo5Hh3YNVGhpZsY0ofUw9m9hO08xQFqvIIPyxSZGTfiTrtS2D0Fewwa7qUx7V70JJcKc9AKMl+fenJUv0njdkRU0xnSRgofv6gWR01QpIhn/s7cDR05lY3aiXm3lrKg5bYE1dx8Z2CB5Vf7OFF6iYn3w2sycN3i6byzXiDk0X5ojLAEg8U4O3ekT/6fPDavRlBksF551IQE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(366004)(136003)(396003)(39860400002)(186009)(1800799009)(451199024)(6512007)(316002)(26005)(38100700002)(66946007)(6916009)(66556008)(66476007)(41300700001)(478600001)(36916002)(6506007)(6486002)(6666004)(2906002)(83380400001)(4744005)(86362001)(8676002)(8936002)(4326008)(5660300002)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pEqXMRAeSSrRRfdm6iwYliy5Es6P5Hn3bRvYeP7H+esYGhRhNmIs1H1hZpAy?=
 =?us-ascii?Q?/LwmyUnOEkp7tePRSEATIqhl8BDYhNTaiNFTcPSf+ZdFYgDf6jQxjONNbUFb?=
 =?us-ascii?Q?iQIOhfQzcMV1wpzUrZoBQ66bVc3AmyWEIe6GDMCpjnn0pgfpMDwrbdtxmg3r?=
 =?us-ascii?Q?FoqGJXKWqkgsyjeJVxU6OFmt68VKQrG9VTCPROfETG/rYa9zdo809KGE3hY+?=
 =?us-ascii?Q?JIr+gxWQKKaAmGGnUHYt4H78kWkBR/2fU8JS/hszJeb3Go7OYbxFOXaou3uk?=
 =?us-ascii?Q?g/TL/WhIU3y5zneYiamu4MsuFdrYzOpBjq/lrQdsV/+UOaz5t3rn84h5CkVM?=
 =?us-ascii?Q?H6w7cW6fptzktqNeo7/9bbORwSEnkvwjIxOBIjE9qeoVE98iTYm/cb530aNY?=
 =?us-ascii?Q?vc4g1t6jli7S7VXORXOGdg3zB1CTKmTaycm8aHnzOqwAJaAt/n5NglLiwiAA?=
 =?us-ascii?Q?Ub8OTHCHOb76TvsCI/zgTRDSC73TW92A4C/rtYXWp1vdTf0u0phbwOBXMrhP?=
 =?us-ascii?Q?oCimJ0VRhyCBhxB1XsZlvquyCrgkQqkWxw0Hhn6eP+qIeJF+9XNh5zuybzry?=
 =?us-ascii?Q?GQyjHgXrVC8sVTsNiZI4lNVkCIQv9wXbDhUHZvGxZoMEFsW29ks7ufbWcyLT?=
 =?us-ascii?Q?l6e/sl4L0/oY4C9/r9ULbY3/OkNhjAeX6WZlZNJvTZ77QIbD14IOIlAgRhcH?=
 =?us-ascii?Q?wGD6tYAU7rNixmn1n2UsTfOpdqbu0tmwO5GafimLiv0SBDkkIGahuHYfbnfj?=
 =?us-ascii?Q?L6T2tQnQxNsw0hopAsTabvb7xKpoQii8FiWdvHcAL+cboYG6K9R4ZNxBh2P0?=
 =?us-ascii?Q?lfBlM4XjH9VjSSAx9jFqtwk8pAypFI+Zar8v6qvHeyDp5XnQE5zII5OPxfu5?=
 =?us-ascii?Q?+p9mIJkq46MvVLQLHhBlnJpHuY1A8eun9EhkmaFCILtKwa76ZCPpP3TMOxtR?=
 =?us-ascii?Q?aoOD6nl2gMA2fGejwGF/2KthMI5g6JV2jWEu40t1kpz4vh6RLKIJL46gaqqV?=
 =?us-ascii?Q?A/3jmmeeVys+aTU7yqHB09UAZDbAmEDX3M/ra/1GaxDaBmCiu8fZmdBC2xdR?=
 =?us-ascii?Q?c/gN8md5v8nSRPFU/rI/zLLW77dODPfsJh3DyUx/VfeQIRqAF1R+kaddDJy3?=
 =?us-ascii?Q?uWp7oy4gH7zZs0Y7mR0Tdg+VADDZTUz8QBHhx3rSwzloXI0xd7yligOP9m7O?=
 =?us-ascii?Q?Kp+iLyr3nVP9m4AuNT3w6LuqDFrOXATXJsiLYL/KPksgQZPNewD1L6ziq/2U?=
 =?us-ascii?Q?8Y8Egqk0n9pgY28ewdIKOzhK6yVxf1M4c9QzcmeFr/C0raFRiQqzEvL3jnpn?=
 =?us-ascii?Q?fZ6KpgBW75kZaxe/OV5a2URC090rGe7lvybXTh1E4aTesP7kyhCPR5uaL+R8?=
 =?us-ascii?Q?fR1Bsb9n3aDbyP7Yd7db19zQFfvreWT7fyxfoSa8VvHA7KSSL90ZSDSe53E4?=
 =?us-ascii?Q?N7ljS1a7jIh45SJ9OV76tnYLw3Bw/f9z7k3rRhemPTX0iBQJsn08Tau6k0ZD?=
 =?us-ascii?Q?GEnENUYdQwRgOOxaeGlYeyC25DhDMg7510WIbzGR8clU+dqrXqWIqdg+TW6h?=
 =?us-ascii?Q?Z8/1vy22rdHokxQZsCTBvYtqhrL/slWm6qH+JvnVdXuSn1pTfKMAPOeZtYVZ?=
 =?us-ascii?Q?3Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: GIdAR6Ifug4NT/ObKori5tOfvL1KurimJIDCeGJlQCWXxpW8eMA9B15V9qnG6eATx6rn2HkwEabZGq3QuiTxNDI3Zc814gRRFUknV0+Ogg4V/MMHZGlxTIUR1xQfvv2OmGSzQqZRduX++t3mLR7jXGQTjAmLe1oJQCT5q+OWIpbVFOItNBX1663eoyq8U/I4oJJwAFCKt1Vrc5CzTudM4bx4OLhrq7GIVyYOFclxrhUzcVjv10j5tyXVypEsUdZNRvwQuqvSq2AiSB9MBW0pVZkGUQNv2DAySqyNLlsbWbN3GTTgrBY4C1MUVbiYoUyX/k4JNrklbg/5PngmnSRB1xXC2aTOlOUOqWrKfm7pfC4NtKnjPIKoymiL5gfExHujDeFPTUHdJkhOi2B3Gy/7JNgJg/EoMgmpxvMdwXfHvfta4BcR3ldineqMCIkzl8P/6TfKEvhowOLqBcC+3XRXLhBZySG+qyvZhKFjYbJsVdo0DdAXdR8TrZNWZFkxCL0WsQJsDK+0S/JJG2uw4w9J3a2yEJ3Nson2S2Epze3U1j3fZEHSZWxCl8HLADVOPi5ro+jXUgj5EMM6A/Kc6caLV8j12eCrJFeH3wJplMDRqGW+SfBGEhm0Zr1z/IVKEfg7KwIFr5whrXwxHfNkmQX8s5eZDHxu3JvCWrFykrdugM496MRWtdcv1Y5nXvrlK14F7Q2tg+NdLEfCSR0b+CzibmlUWvw6cTtkAGNIhtLlLma6zE/TXIdjIfkzH4BqOsDRXznRcjK0upCA96htSAlsCW6wG/GE2EBkXkj+x6F8K2jZr5v8Bk07qYWG5330Ew1VBsVzoWkAFKpRvOiZNQ3Nw4PPrGV+BP575IiMhTK6GnA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ab6bad5-22dc-4e68-73cf-08dbbb11e1e6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2023 02:16:08.2781
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 57BgYTKGoZUrem34L9wpw0o/n2WndMoo+DzfCSfixUNxmyQd0kgXLdTCHUtbM21TMNTIVwPG4H1dCF5zqob8wirtxGH1wat/ewvc63mlDnM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7981
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-22_01,2023-09-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 suspectscore=0 mlxlogscore=837 phishscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309220018
X-Proofpoint-GUID: vCFZFG6khfHNOlQf4sfD7wvgBz0D4Kkw
X-Proofpoint-ORIG-GUID: vCFZFG6khfHNOlQf4sfD7wvgBz0D4Kkw
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Tyrel,

> This series includes a couple minor fixes, generalization of some code
> that is not protocol specific, and a reworking of the way event pool
> buffers are accounted for by the driver. This is a precursor to a
> series to follow that introduces support for NVMeoF protocol with
> ibmvfc.

Applied to 6.7/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
