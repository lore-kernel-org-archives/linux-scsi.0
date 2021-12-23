Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC318C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Dec 2021 05:06:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbhLWFGv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Dec 2021 00:06:51 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:48150 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232123AbhLWFGr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Dec 2021 00:06:47 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BN05sXC015883;
        Thu, 23 Dec 2021 05:06:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Gh1UwOPlI8q4t66oPZBCqL3cXNQUxK0Hl5PDKloTOsQ=;
 b=p5t3IYgHpE/K1CW8sDMzGOs40WPn6ugmk98X7BRqugkeMTxMb9e8xsOsLSJ8g6RyE8Kl
 KjxZ4+pkLEUVlIRjIAn6k1twC4Sz0njG7FsG9EIqACsTckrmxC1LELFHRd3MAney0fHA
 5VGlDFrNawDTqkWCmFx04ExpQoFjB7Lwv1vYcOGpvpe3RpcZf/hTIjJCb7pYaMyQCnhH
 O5iGUel3R7SJa+Sb6PYUArHuNSLTGOI24E5VI8Q7iscCNn5hh5DBTM2vt6xfC8O1TFDk
 +ZPFFDQcKIQ7Yxw5wVkBHDWO63/SbtMz02y6Uw7rCEnuCQcixEljt8m/JQn4tRjdoiRX mQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3d46rm1pj0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Dec 2021 05:06:46 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BN50vA9102198;
        Thu, 23 Dec 2021 05:06:45 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by aserp3020.oracle.com with ESMTP id 3d17f68u0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Dec 2021 05:06:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iwlsRVGotm8yD1Sd/vLv0+/mYJUejZk1bC0RURULzVYg30ZMGY8FjbwY5II3x0jbaePpeztR78tpDTmsHYhsjoK8hKOIy5uAPS82tLtADi/JDW8DUvJ7NVho9S35lcU6knsTh5u4ydPDDuKglSfrSBx7CKubnX/TqsIG5HfoxueDcjrT+QLOO0ydo1QnXae4eOIV3e3bR3ghJ/R/Q2wKX5BgDR2S3eu+VL8beKbxP4IJVAnWhVb0xHi0cLN3gnO9Rj2xqqwRiFaL3TPtRf9mHSReq1LR1GkXaDqEnAOCo9bykhhHRPTXCziL5EuUjErXXOHKxgfJykQAmjhyIU8Imw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gh1UwOPlI8q4t66oPZBCqL3cXNQUxK0Hl5PDKloTOsQ=;
 b=kDOgutdaUbX8u5Z+YpzVeON2k8FpZQr5fs2/BolU1NoDZjV9NYihf+dGdJd0WiJ3Lg9HGhJIzAjz5zGvruINKxxDL0Hgiccff6ARFGX3qbWaxo7JGWb8rQlY4npE2lGGY1MowOGnr+kZQMfOiYIkg3/+13F4w7HslOMV3ucR0jJY5W7+ZjesbC+V4L4l9LgGQ1b9qjYOnME8gNsQVzVLoFxRsxr2XgL1mBDgEwehqj9Cl/8tj7XCP3LFdEFCYAUjnllojcWo9ZIaikzqW9t1W85JqEre/IL1hVjpa2LLKXMchIKQkqxL0TDVv9WzQX1nO5fDFIlqojiNneLB/woDgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gh1UwOPlI8q4t66oPZBCqL3cXNQUxK0Hl5PDKloTOsQ=;
 b=P7HoVOUGYXFPZihlMe3LjOseMps9f4UW7I8PIK8CtJMHWKMZqegqd8bAYB7c1kG4tKv95d+mWU+d4lWZgWPWNHJsIwHhp6dj1L4DgQUvkjhiNphfrVhed7on1ZmzEULz1mr6eq64kBDhJHhZHLZjHGjoQrP5jqQcCajWPARfsvc=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4517.namprd10.prod.outlook.com (2603:10b6:510:36::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19; Thu, 23 Dec
 2021 05:06:43 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::f4fb:f2ea:bda5:441e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::f4fb:f2ea:bda5:441e%8]) with mapi id 15.20.4823.019; Thu, 23 Dec 2021
 05:06:43 +0000
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        mpi3mr-linuxdrv.pdl@broadcom.com
Subject: Re: [PATCH 00/25] mpi3mr: driver fixes and enhancements
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sfujgbad.fsf@ca-mkp.ca.oracle.com>
References: <20211220141159.16117-1-sreekanth.reddy@broadcom.com>
Date:   Thu, 23 Dec 2021 00:06:40 -0500
In-Reply-To: <20211220141159.16117-1-sreekanth.reddy@broadcom.com> (Sreekanth
        Reddy's message of "Mon, 20 Dec 2021 19:41:34 +0530")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0201CA0040.namprd02.prod.outlook.com
 (2603:10b6:803:2e::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60049b91-4c45-48f4-e453-08d9c5d202a7
X-MS-TrafficTypeDiagnostic: PH0PR10MB4517:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB45179AE001AA91FB46B744CA8E7E9@PH0PR10MB4517.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z2wxork6JQQk6L8rX0dkL76uJHFjC6bXR2LGBXS8Xi4UGFX2YS+e7VtfSKMh1LTWokQSoLmOilXVtmcZAUQlgxscbBQwQ++sHfxRCh4upVeSitn/a/t0KjRWd7wuCmDewFVCkEq/gXl4b4Yu88mLK6FpYuJRhAw6EPzxI5G62cPrSeThP/dTuQ//5nPPgRBZniuCbX3TX++BjkEySrEgSuwo3vX3vhuozpcxKDM6RHq0SNdbAgOYqkkfebNjC4aSQqhwzq4LgKSfZzNP5HFNd0IYoPKR+xSmFBzzv0Sl4PBOt6ingijFoR9Iivfx9Mq6cVN2XUYm6O7+jBTKdGZg/5ZokTmkRMqDelp2u6ZHsJiOXCRHkxg5T22zNy6jGq97Dc6SIEkXgF52c28YoetDHWn9nXSBxlGUqqNlyDWEhqPBMaOfdHyea/C0CVnWSVYPYr9VhgO+Dw/8EYkUEDZHWvaaGNlSLFZRTUVrMsnBpRNUELPTwb8iEVgta6e9+INBILfQepjHHTAs+/SuYRSEv4Nxtb41bq4Npim83Gwxo6T2ghotNO9UtKAapaXlbG07Z4OknnZpIEJOZ/GKL3jjs6dGARmSN1hUdTdnMT3S9IJ5dHs2RS4S9ZmpXgl+7Pbt7q4kidS8chOOFV98ePY6VA78cLAEoae1Rjzl13EzHryHRCHZ9UBFeaI2zwihNTfntAPNM9jyjUNCggpCuLXPw+xrH9uSRhqQZy272JQVP3o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6916009)(186003)(6486002)(38350700002)(8676002)(5660300002)(38100700002)(36916002)(4326008)(52116002)(8936002)(6506007)(66476007)(316002)(508600001)(66556008)(558084003)(26005)(86362001)(66946007)(2906002)(6512007)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hNZfu6TVvwYK/j01WLRYmk6QrNsaiIitZI4y0VMYZSAPr6xk0MR6QUl8RSHU?=
 =?us-ascii?Q?OcFYJNkei+ewOU0wEWo5VQe1bpaAK+I8tZWBMOFxyvdvPEKt4JhIDQG0na4P?=
 =?us-ascii?Q?o45Ejau0m0A433u3ivQz/PI8KjpufnNbibitJ0x3l8UxwYTNpTAbJubdOTcL?=
 =?us-ascii?Q?Swi4ynrorjM8u3/yeQ15rakdeQLwHl4kL06hP5k3irUPTx0KfMrVqjT3wsov?=
 =?us-ascii?Q?J47K9DALUk8YAFpb5eG/kH8m96di+brVLWiBA/tW6DR66Wn7+jTDyZrZELQp?=
 =?us-ascii?Q?wB/W0C+0EGiZD64fh6WiAaOyIeIs0bmLBIiwkB51mHmlLSPpsYEYGv3yKtYR?=
 =?us-ascii?Q?F/oYM96Tq6xZEQA/k6aDgo6DAW0SbOYA2y7ATdn0hStOwD1Jrp/+yY9dZeOR?=
 =?us-ascii?Q?U8VD8PXI12bWlI43MpQSCHjS/RdQumzjhz9+pCDNTCi/kKbEZh1ylOfoBpGE?=
 =?us-ascii?Q?y/8ekosGyQWiEbFr55vGqIgXDa+gUJLwx0XzGZMbKRJziYkywopSsJTLkctm?=
 =?us-ascii?Q?EbV03UQE0toO+5iGKq+BoBNed47MU+byK03BXNKpIxlYOazFFX2wVzQ/Ka7y?=
 =?us-ascii?Q?6S5+s6h+69IFVMh34Xyagtz18HZVH1vfnJRkKHFqWG5wgvKO+2rmNyQCtpKz?=
 =?us-ascii?Q?1Ys5gHAEGDOTuJL7u7FLpXDeOq+cDK5RRIXOSc3oPeTeub4XElWrzwtksxxg?=
 =?us-ascii?Q?U9ZK7GTB76+VPSpA8r/ofE8Hct3eO8JRindUf3BCfqv5aGzoL0wS03025AW+?=
 =?us-ascii?Q?s1jO1AJa2QLKQh1rDvSJT6ivs+PN7BEBdi+0bzonEto5giySbetmF84Q2pQS?=
 =?us-ascii?Q?RfIkOwPvL1Ar0H+vvu6dy60wZ97H4yVx60XXd0eWhbsnGMqIlP33GlDA1wQo?=
 =?us-ascii?Q?5VunGtrwhiYDgl4Ou0NWRGXDufRJmxNbL4WMbCMD0WCY6KNIb6u5oTOFdm3g?=
 =?us-ascii?Q?1b97UjY6PM7r8WAQVtgcZkLirjDoMHzodBBBOGCOWrf26UMwGEDzzO9QhGtJ?=
 =?us-ascii?Q?oPNKMp5QZY9/g0Wot1XXrUR2ekuXXcEJmBMtIl0RLyK85ouM88jvcHr3EeCH?=
 =?us-ascii?Q?dT4uUVhMuW8XZIOl5Ij2eGluYyHl7/YOtwcMhviT9WkYB053VIRQxjQtLnTX?=
 =?us-ascii?Q?BmVM43LMhMVltl6F+NwTpracY4yMXYw8T3y/qqugoMdn/ld+Tr+zGmqR+RUo?=
 =?us-ascii?Q?3M/YN2Nx48XjeA9nVBGW8AHoc4TJHaIDIQhwWI+c4Z4RYZnKK/QLDNqJ4+Fo?=
 =?us-ascii?Q?Ui9XttQ5Yt8E9eBIGQZkWpVwbz4tGzw8n0QzbbJM+fbOzRe5f8ZKJCTG/II5?=
 =?us-ascii?Q?IzT+y89+51+ZHnFvR+GIUXqKO+W1kwythorpkhGWHZ2rv1RkdPY1hofbno9I?=
 =?us-ascii?Q?Ku0756ksL/A/wikZaHa6XIcnb8wNeJ5+zaIJqW5841cRPc6DH15qqTf3xXvO?=
 =?us-ascii?Q?i2MvsKVxxAPeqZOr4xZZwYO3LtaleZQ68q3fkTy4cetnVGL4dptPxTaXiuOW?=
 =?us-ascii?Q?BYC8KCsSIu2+0fK9wma1DTStHujiTUKUnmFGu88+/BVMuA26NKsdyjSzqLWp?=
 =?us-ascii?Q?l88gZUxnkuOLN/pR/UoyQ6uqEIXfv3RvoNG4d1p0wch0/ca4UY/g2JFXRVm3?=
 =?us-ascii?Q?PTPKBBXmaXa75PKzJNEl5ZP749IETTrEqtDsnppnxLe6D/McdKQgU+BVnTXk?=
 =?us-ascii?Q?RpS3dQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60049b91-4c45-48f4-e453-08d9c5d202a7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2021 05:06:42.8934
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FhrOjcJjuE2AtS6scGb8HIcqjCoXEC0KxxymVwwHAZqYR1mYXInYc0B2mYETJRatdwKPU1XSz8akVz4scuCO7FzA6Ai4Zy0Ag3+Sv1V2Ybk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4517
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10206 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=760 malwarescore=0
 spamscore=0 phishscore=0 mlxscore=0 bulkscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112230027
X-Proofpoint-GUID: D2DqPmJnAROVVKInzIT2HfeyI6re0HID
X-Proofpoint-ORIG-GUID: D2DqPmJnAROVVKInzIT2HfeyI6re0HID
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sreekanth,

> This patchset contains genenic driver bug fixes and few
> enhancements. 

Applied to 5.17/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
