Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DE0AC05027
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Feb 2023 23:09:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjBHXJq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Feb 2023 18:09:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjBHXJp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2023 18:09:45 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 710053B662
        for <linux-scsi@vger.kernel.org>; Wed,  8 Feb 2023 15:09:39 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 318Kwn1V002969;
        Wed, 8 Feb 2023 23:09:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=P5tx01M5+h6pS0H4OZ0+lWDSjtlrowYu5iV9VFcFLcs=;
 b=QGgJr9/gmPUCn/mUzUED9yZzIWmq6YUwEkih864lsnR4/3E31qFXpDVdtJ5Dyh7s57Wt
 1ADERWovbYxe/lbGEYmMYlTwCIdfGWdX/YoIXp+jOnJQtZ714ErhE98mwCKobL8lO3sq
 ii2hiEtbfcCS4par43CcphUEvnYNdAZBvCy64jreGvH1xMQtLHYwJZB/yPjxKtcKXnqo
 qp9Gj2Jm4WqKZwoKqZc26K9xjztt4vz7tMqsCY0n4jHL/YOkPMaCmUwNs4J4avYSiYy+
 AwBf4LNbWF5egq2RNB18XUzyB86C2FhRSEcU/fI1xhul71M4IlqMgc1uB2nheRquZANA XA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhfwu9fpc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Feb 2023 23:09:36 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 318MUIcw005825;
        Wed, 8 Feb 2023 23:09:36 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdt8df9k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Feb 2023 23:09:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C97uDzMp+ESwfsNGWSOWCLiGsBboSYHuavmhHquvop7TQDSCgI1fQW2goTVDI88M1wxrnQeUFCqtHMCwDHra0zck+HxrZNdItWcIzetcUsj0zaDXmVj/N2fqm8aD+37GhXtc4t+KHyP9PBXS0hMq9JJEXXhbL2jgauGzwHpFgExDEc3H7FRmYXEUgUAIQAL8VQqIQhlwpGszYXBqAeeN0fVxrBxs6J4VmTXlGruR+YkfchAndqiGUHOsJAJC9wDIO9DvXthFY3Z8pVCsgFF9E+dAF9ruZPMKdKCQYDuHdN13xVPur39vCA80+dnZTtR4zslzpDhhxhkttdbYMFxFTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P5tx01M5+h6pS0H4OZ0+lWDSjtlrowYu5iV9VFcFLcs=;
 b=jqwZTJ3OE932QvnCaTxUzlU/sidu2Uvv7w1o3AJVem0jPDrFMW+l4rJudC1cqno3bsuztbk2bl2Lk9pHUMYUpOlt6WkbNCiLnkIoT3/QD9TfcxXJn8xJVJbbKXU9mQ4c/mkDdYhZUZwKFKZ9cw9cEF1vdK4xVJuCVLvR9/+l2EG+k/pTzR++5BUxRoCimzB3RRXFbno+RqQ8PB93TYVp4vxirGOdlHUE1bBb8bheTkwYALvrf748EJUbQv/xsR/muDX5TJ6LsJMjYYhLQJMIToS3IqoVmg1Pp7JoPdpaVmkgjZyvQUDl2kSQxUSnZ3/oQyhGNEuIk2I/ADIuAWBFhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P5tx01M5+h6pS0H4OZ0+lWDSjtlrowYu5iV9VFcFLcs=;
 b=oFzD4vTjRVePnWBFCGmxBQyNMnjmaclfXf0XZMJmPEZ8lJm1dyuRM+H+ty7eEdG3WYZTEF+kDDRoOaIjEeYHJWYQGNYA36s26jZ0rspFP+j5G8Q9RSon50rJ6w94ahOQXck5QLxkXhSgTpiw8vt0cjlcMr1bQU8grWh3v5mPm6w=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MN6PR10MB7491.namprd10.prod.outlook.com (2603:10b6:208:47c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.16; Wed, 8 Feb
 2023 23:09:30 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c7e9:609f:7151:f4a6]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c7e9:609f:7151:f4a6%4]) with mapi id 15.20.6086.018; Wed, 8 Feb 2023
 23:09:30 +0000
To:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc:     linux-scsi@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: Re: [PATCH v4 0/5] scsi: mpi3mr: fix issues found by KASAN
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1y1p7zrey.fsf@ca-mkp.ca.oracle.com>
References: <20230127063500.1278068-1-shinichiro.kawasaki@wdc.com>
Date:   Wed, 08 Feb 2023 18:09:26 -0500
In-Reply-To: <20230127063500.1278068-1-shinichiro.kawasaki@wdc.com>
        (Shin'ichiro Kawasaki's message of "Fri, 27 Jan 2023 15:34:55 +0900")
Content-Type: text/plain
X-ClientProxiedBy: DM5PR07CA0104.namprd07.prod.outlook.com
 (2603:10b6:4:ae::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|MN6PR10MB7491:EE_
X-MS-Office365-Filtering-Correlation-Id: 29a8e7a1-8863-44a8-5ce4-08db0a2987d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z6GZNY60imozE/a4oOLjGywmAjMk9XCCqqrJ+DsvGCMvnJcO8roW+Yybq1fM7QcNCqFpsnu6ZSoVVHbkz5/OV1d/yi/0ELNpiT+n9kza8dRui18fm1dJzQQ/ceYohLzGHOJsBDgX/taNhbHhTT6wgyoNiWpzV2dOKeopNjpS/ywfONeKRenXxpZnc5UsVUI7KcJsNH0DeazjifPrHw6P4TgsV6BMubeLxo1UTdcWZEHkX7F0/JC30pWdiUwH3oXbscttFS7nCHNDmm0Idz67wjC1CR8r3YnpivOTPcaPGmSStsCR04OobYz4+495t9G9m7KSV9hqt2+xwRWyuR6YViA7W21Z2w/Et13L9tt2NwYYE90qio4P4cNSGWfyUfYwa7Ci0puPnoS7hhQGHW1E0s/K60FXW3hVz68H/AnUgE/pTYJJcjoWI77U642N7oEZ2AeBK8qjnJwc7D9AlY7j1K8Kiolag473Xy6+J+/3/96gv+/dxW6DK2Y+Qs37h8/WaYtWeSe0R1/87xr3XZ52PneHPgXOtHfUS68VyXrbhlho4WcI0TXWO7BFm/JV/J6KCX+GT0FAiD8td1s1ISF+Z0w+WLJ8yqatl4NNqAc1RoYfYQ4ReITwg36jjkVsaoZLhre6ea+rN/RQ7ADFCGVJfz0PW5k8kHAn1LX5OZEatc1oH1BXaTDV5hEQRd2eXvA1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(136003)(366004)(346002)(39860400002)(451199018)(41300700001)(66556008)(66946007)(6916009)(4326008)(8676002)(66476007)(2906002)(86362001)(38100700002)(5660300002)(8936002)(4744005)(36916002)(6486002)(26005)(6512007)(186003)(478600001)(6666004)(6506007)(316002)(83380400001)(54906003)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mu6iHa5uO1qavebxLPiH9MKzuahOZ8M2uHzv+wRGyLwnMIPtrdlIaS2a05mT?=
 =?us-ascii?Q?W9gLmlRSlUQcO9IyV5xjQ01G7rvrJEsEIl/YO7mC2vol07MvKCYq3LNscJv2?=
 =?us-ascii?Q?ILFCQ8qsbbA1NDhoXAHm0LJIcTFCRSdpjdZfqVUGIPJOpevBo4g4980dtiKI?=
 =?us-ascii?Q?vz04LfkRDmHqff0s2DGkBRnA72bLwuStgiG7gcjCCQ+eP9M+qGRO8mvoIhuc?=
 =?us-ascii?Q?d28QYhCq8SM6+AFLMrumsszT8neqG92NU9W4Vz9YV5txYZpbt8Zxd8muXTX+?=
 =?us-ascii?Q?EE7zsSY7Wcub+ncnVd0q7zkfj6MtpwdlL/Nt/IqDoHLJNRyzfJAZr21fCIF1?=
 =?us-ascii?Q?s1Y5PplaKxiKqDd1uZtEBn+JvJFLB4vb3M4ZdT97GqHYybn+GqtUoYJEl+Nq?=
 =?us-ascii?Q?zPiftuMz52+s6NRHXN4ACRqTeM6jW41g8TbCVn8HZgMoN4Cbq6vY95Wp+s08?=
 =?us-ascii?Q?65InR3O1xG35SEeTagOip2k5GmZWqHvq18iKpe5MXJSgAyjEajyVyT43z/dp?=
 =?us-ascii?Q?KQmwJ1NjJZU7a+C1u584mVHfJh1tjJ0b0wiu8VLlPraWeVel5iJtCwtPrmVp?=
 =?us-ascii?Q?s6hfwKsRYyjxBjmb72a7ZSd4zVlWABKAYkKjL5Uc2BIX5Ri5XzWgThK+IsjK?=
 =?us-ascii?Q?w5J2CniMtq/FpUufluFPcV6ozTpvHP5SR27pjHFWy/rIe5lSuCKI4Nnh/mr5?=
 =?us-ascii?Q?YxTWYqZbDwzZUA22VzmKfvhu+1EM62T9ctUIHtMzmAm5d5aMKFGwfM5r/veC?=
 =?us-ascii?Q?PnJRzqe0Z4IawkprSYVkwmuMIuvarGt1VlAeXCNshMSbetsFu5Y64y7S4xnU?=
 =?us-ascii?Q?TgB5pgjnXI0aGehX8EG29sioSivYxFG5D3eDXJ3lJxf+zOsve/kUvKwcd7Tl?=
 =?us-ascii?Q?yAXYTSOYOgnZnNAoRz/49EanmYIz6ly+/33fdINCZID8S5krAFkokvSH1x5K?=
 =?us-ascii?Q?3AP+dnDSMf/mHsZ7YWP/zXh+9/dPe+6b6JE5PqbxasweArc0oqyhBSlw9M18?=
 =?us-ascii?Q?DAN045oZkVnzJhZA8NIJIiyHtYl7+SqnzrNEYc+jubptCLbiDlfjF+lsr+xs?=
 =?us-ascii?Q?YK6MkGisCfxTazP7+vkALFQrW6iGW8AUZ4dIMExiB5hUxsiWJQnVNb4drIHZ?=
 =?us-ascii?Q?p/XmyLRPU7FkxsWRCgM712WKkLs64ucSn6KxgJ4LuCdWeXmoUMQFQ/62hYHN?=
 =?us-ascii?Q?9jvvnn6AhNDR0CKHAWSIHA8DWyVuHEaw8IY9hUPV3ZMQrBy2RMh9nA+U+7ec?=
 =?us-ascii?Q?LJSIrC7D3VwLwim3G6xRBWMAFUJzshc1tQeeMTKG5FQ3WQZUNL7RJaWo8tQj?=
 =?us-ascii?Q?DMmDfwiwQ8rf+7n4PjW9dEK8wxTzTDHbxO6igKTwmfqCpxuQVUcFBsGlJ5WH?=
 =?us-ascii?Q?wjA56Yimes6N3fv66pWimUW+shgCAmWYqkR++LXRKRXO251HEO1WXVu4Mmq3?=
 =?us-ascii?Q?ri0oqHk+t9WrAXX8eIMIokrYl0oRt/opoS014DzW5x03bAZYD4XGIqZbtjpo?=
 =?us-ascii?Q?N77jrctgCoiE996xnCLGVgdlNyC4VrXNItWarMV0dNlmL9tCbO6E+BNFdd+o?=
 =?us-ascii?Q?FmF/k4NhkdkI2lU33W8iu8iZ5VL/EABsveEA07j320kk5Q0jrULCIAV/D0iv?=
 =?us-ascii?Q?FA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: LOVEVrbWbDyQ+shkvqo5UGpcRd5Qri56N5+FiFeNt0QeDQ05iv/bquYuYcMBUYAPDS8SuWyk58+E5bEf9LxkYZ1tdY1qdlIDCTsLnfv0erlKeHkFvYMvAnsOpVURrrsXiHSqBfWhrNgj2qrJoP+4SrOgq+gpGQw3luLaY+/Rifo+T0G8kvicaIXORMmucTxzFyCPf0Gv8hvZUXEt9Q84hBAf4U9Uzyy4g+gv4uZyjfSgNAgqLxdDWYBpI5Ib9g2HZLL9Tc0UXqVBxyc7ayGBBhklIrXK8ugdmj2e1zyoaom6Dbz2ULRKP/zJQqG+3MA5zEGcTYPVTloLItjrsYH77JKNF5Hc5ZL8xyUYIH6EIy3t/DTHp4pLJK2qz6dAA9Vf1ri8ZPcTlMmF9P8Ltmo7IFSpfRx0ft8fXxL5DWNg82UfVsj5kOyXqHriL4DPpcf24oCDxkA7IhRTLwN7u1roXacNf3GDPTPq2NlBtyZoUdkci+tcqQ+xIoAnrL5KR5jOz6p0PFxtaafUWArRbq69fb75x+5nMk0s1pqt2Z+QRmhOmusHWoK98wmf8xW4RmiKWFMmC5FcMMnP9fn3DLI4FtOBh/yrSlE9ttCGf9Iu0yX8Cf1lMPI7TzAk0S+9QmIruM5GnOeYPixoZ71jYUefoE55rWcAAVjPZcSf0aGbVXhoi4TSjOuJ7KbMSQvLUX/nPCU8W1DIcPeCkLA3hk3bIQObUKqOuS2LuBUsPlXCOwBhWLYsJwLqwZ77si3LzuTRsVYWNkAakAIy5nyLdupGLClZ4ePRho+FqZ5Ygh0ZJyzg+1KtWSYrSQ6fN5kNSv3NXSgVyssI8maLz6QFKLkWTb5FAMHgsvBjcFMirCQBIu6rmITN0u0exs2mVxwMxGrY
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29a8e7a1-8863-44a8-5ce4-08db0a2987d4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 23:09:29.6501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i3dhMQgLKBsHBCEMQEROoucz4MWKs+iOnwsikyjzFiPdUnndkTGqggyYDOqiehsjCvZiXKmJ6P7DQ4LpFjw12HdRAX1one95XuXUnapsuzA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB7491
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-08_09,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=887 adultscore=0 phishscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302080196
X-Proofpoint-GUID: XTCW_XNITFgwiWQd_Qz_ZxvzVP1zWE9u
X-Proofpoint-ORIG-GUID: XTCW_XNITFgwiWQd_Qz_ZxvzVP1zWE9u
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> While I downloaded new firmware to eHBA-9600 on KASAN enabled kernel,
> I observed three BUGs. The first three patches resolve one of the BUGs
> and related two more issues found during the review. The following two
> patches resolve the two left BUGs respectively.

Broadcom: Please review and test. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
