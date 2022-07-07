Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3899AC433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jul 2022 21:36:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236806AbiGGVgG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jul 2022 17:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236313AbiGGVgF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2022 17:36:05 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D635E380
        for <linux-scsi@vger.kernel.org>; Thu,  7 Jul 2022 14:36:03 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 267KCTYW026377;
        Thu, 7 Jul 2022 21:35:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=C0m99i+u/byvu20KC15E260hxH+367GBXbcVXhtSiJ0=;
 b=t8TaF74iiQZKZuKuyMOzYonKL28OXceDO2+XFJ1QdOoDUn6w58qLwpLy3iQ35gHdaQR5
 kEiKlq15alb9m7HD2v2HpeGdvfLce8nCgW4VS+8LJtYyDNrhBTF1ULyqZbaDNbDQ96q6
 +58NxXPoX9DxI/ZFCC1b41795tPuWYijsS9HCEAfovzfiAQc+KQjarKqSDXGA3BsYHr+
 gBwl16YMe0dLs5SaGZDLSun7DNhBHDTEOIPc4uqKDl1ttWXqwY3yIZpJUZoju9gekX9j
 5VEkTv8DhCFhk6RZ4OZkKWvea+ViSVWTdZbA+4H5zBzbAwSlUNQcTUBU5Iy8aXpluA1Y aA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h4ubypft8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jul 2022 21:35:59 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 267LZKLj025747;
        Thu, 7 Jul 2022 21:35:57 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3h4ud66thw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jul 2022 21:35:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y+7XTMS1Ck80/Otb6gxwz1/K5MQjil4aw0fFNpzAA8sJz5Zw82qb6v4cX8CUcIL98m0WvmXURDIZDJfFKX01Z908KzB46GeDyvgDPwwAtB9mlNlR6JXV8w5dRZ8FR1G8oBNWhmi9FVvguS3T2/FR6BvM6UErJn+8qy0atmPAnAnVbyOGCuHDQ9y8kpJgdCkXuePLUipCnD3/haBcNYe0ckkrs4Fi1Ob4wrlSIIxkh6mXtmZe8tCUvRJ4wZuo156rS7i9bPb+0Gk/oD6SDi3Oqm25B2SP2uxbQVyTRjnhwU5P/Xy+fpxlFWZRh+lw9TBdCVZ30dnyzbyAHhKFIqEHlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C0m99i+u/byvu20KC15E260hxH+367GBXbcVXhtSiJ0=;
 b=LgldItMPReTb87QHwgLvT5RzXrz5HzlRY5URE1V3zHZ8FNYdU6b4YoHvcLpTncX8cIfccKzx4dvrRo7ZApGe59UeR5ARv4bGUzb5BUXr3T3IJnYPYn6tfvVOVtehdJJOhFD2ixPCT6gSVTnA2X07YpFQH4j9kegne3jkYPaK/TdfEP+lgU7Ytm3aiEc2NAtSm/jSNMfSsPE2ChYNF0yccfGtjNGyn+OPG8BVwKTylMJpHiKoy7gA+k1QvOeT+07zHQVY5HmdDZq8pphMQfRafcdrDJ5C1QZwmDFNj0Cj+ARQ3NlJAIGNQ+vKMZTfkN1jRpWhTofefNNRTNojvLjFng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C0m99i+u/byvu20KC15E260hxH+367GBXbcVXhtSiJ0=;
 b=ECPjGlPmgGsl9kuvZQmTAC+xRcso4T9Doto39vIQZ1JZj1id1XiHMS34U9tVrY10eOrI+AwFSV1KZfUElOhMW4kdESifDbyYM1OCQlFliDaQxReDmy1m3ETsRabTrnvUAfBd6KbC5HC5G4IPkJe6NY62AA5OhUZtmXtlPa6tY44=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DS7PR10MB4831.namprd10.prod.outlook.com (2603:10b6:5:3ab::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.17; Thu, 7 Jul
 2022 21:35:55 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45%6]) with mapi id 15.20.5395.022; Thu, 7 Jul 2022
 21:35:55 +0000
To:     Nilesh Javali <njavali@marvell.com>
Cc:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v4 1/4] scsi: qla2xxx: Remove unused del_sess_list field
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1v8s84ne7.fsf@ca-mkp.ca.oracle.com>
References: <4b3c4c8f-02b0-4d95-85ef-9368b5557cbf@I-love.SAKURA.ne.jp>
Date:   Thu, 07 Jul 2022 17:35:51 -0400
In-Reply-To: <4b3c4c8f-02b0-4d95-85ef-9368b5557cbf@I-love.SAKURA.ne.jp>
        (Tetsuo Handa's message of "Sun, 3 Jul 2022 07:02:43 +0900")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0007.namprd21.prod.outlook.com
 (2603:10b6:a03:114::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 875e2918-a6b6-4df3-9079-08da6060aca4
X-MS-TrafficTypeDiagnostic: DS7PR10MB4831:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hUtJbZD/ubqx+8+yBbDozZHDg1SjD5ptJ7WMYGREkYEAzGnwaVUyjbBDXDtU4Cz2FdpqnriNHxg/zjHwZzCTDeSzodK+9SL9iURirYOZygDUU4eX12BC9yZKmOijb9oHr73K2TTEYBHb96QkCPRRii+5K0OnHuEmcRyXYrMDrmlGanDVe6KFLsWw/D9v/tdQYOFtCDM4UCcqroDv11P2xX467bqHBfgIDYkFamvorbgW38E/QjfkQW3SmfZXKg5Rp6/qe0T5buQsR5A9Bi7H0wJXpiS48cg2iozwFgHjmNFvAbpwlUkUetEjDA+KKxwM6lzV3A71YbKuqxBlP2cbLRag/+8JkD1isLoUfuR5cFve+5cG+E/h2TsaAh9Z5r8+0Rk32rdCtzMfsBMnoCQL8Z0jpoeSa+lV9o0mStB/WLTX9g1lgmuLfXplOk0VsA0XsKkvBy3u3reYUPxNS51zNwr2e3X+Q5FCwjOokhytZQCAsNyUuYUTn+UgzN1V+ApfSfMFngFCPgzRwxMmzjzVzaec0bmAU1h+LsHWlj7sU6HMuo149tL3ETFCeEZL0T+T4sHNcWrJ9cFp58RlQM5J/iKZzHuIklb7k3sbuh1Rx9eIJeq5PDkwiJ1Hvc9zPXr+ghfMvb1W2fAwPnZKjaVtV9sjKeVBzV15yAnL21elzwzsZ3xg5vkrB3Tozf8q7Z6ORktXRIo2Ky1wU+DfcWtEwgnPL5rv2+2DZ0Q8Ce5NHzqkQQefTxZCZgCF9QFpFitz9tIIX1KaSQIAmM2YnOD93cCb52GTLpwWmMw8C8imkfJnkKLHRlxe6Kq+Xq1nK1T+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(39860400002)(366004)(136003)(376002)(396003)(66556008)(2906002)(38100700002)(66476007)(54906003)(66946007)(6916009)(86362001)(38350700002)(316002)(8936002)(8676002)(4326008)(558084003)(52116002)(6512007)(6486002)(26005)(5660300002)(41300700001)(6506007)(478600001)(36916002)(186003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w898syVqjUjk1JgAcz0qLIKV4s8oKuOiJxLPJ7hZ1EwkaijrlReshSUKxDs+?=
 =?us-ascii?Q?wyeWffJEOdVd0gP9GxJaui/veRwOTVIo/CuC3rdTJy2dQbnjl39+GGQQPkRe?=
 =?us-ascii?Q?nwATHoL9cTeS4MROXJdv7LSXVDqibUE6ZYEiQDm5RWs2CVD+HA6mCTAajEXT?=
 =?us-ascii?Q?ssPglDD+TrOiWeXni9N4oUPTkFbc6mLCXreDKAjzJGL16FDEedXXUVea7Y9C?=
 =?us-ascii?Q?fKgVnL8s/cL41MTxIAORUB1e5fMXkn93Dmq94X6s6Ex9FYQf+nFMH0rRAMPY?=
 =?us-ascii?Q?sIySwFIabJ4C5dubmKjtVAnFukPItbC0tvjWjmVRLPB5qV+D23KXTlJs0TQD?=
 =?us-ascii?Q?NWDb5jxIzNDn+TD1Zk0KAgQGY2A5khJdb/s5CwlvRBE0rqy2mNP+occ3T6cv?=
 =?us-ascii?Q?R8Vm/OyuejpL0XOp9DyRcf8xvVQWOTUn6fuaR+hzhBMKEFf3af9Vw1Yfth3Y?=
 =?us-ascii?Q?7oV9ZreE9tqOnnkBRG53fPN+j1pHYnXazuoA0HinGnhUOTF14rT5GdtjIogf?=
 =?us-ascii?Q?Te9NUAnmDgN4TuKcugwH4Ul3HmLpUqAUHo27qxCis4LdWaTbmmQgZWFZI3BS?=
 =?us-ascii?Q?FAM46KpASlRCfqFbJmDTo0Qfjr1x3AzeTZ0DDJXrE3mmUv28NrXN/dMIUu/B?=
 =?us-ascii?Q?r4vDsl5eEO91kVouR6d+RljHb29kpsyT8i7UdQ2Fg4/PP8DuuqqLMCY7fvJo?=
 =?us-ascii?Q?mpzykFJUtVxXaTWg2G9G4PsKoRAkaxmMsYmMwttPfLKdh9NJPWLVDJhiFNGr?=
 =?us-ascii?Q?/xkiWF5T+Y0RgNtFWOvZCFJMdkfYrN+lV4c+tJ6y+Z7fU5zWdCxnBLbucsRC?=
 =?us-ascii?Q?UhT1a5ZdqxK5Dodmv3iw8thlUKToyYcdANQUC40df33F6ngohktvcZzXsODo?=
 =?us-ascii?Q?tE833U0wGb9gLWfW3FKwNUmac9WBYTfgWXvkvGTW/cgZNZe2/TaFCVoGRzCG?=
 =?us-ascii?Q?E0gtK+u3MVIdMiFcOVJ2Mh5mRHFVQGGTBhZ6TtH/pHQx4CdRwGkk8+BixUgk?=
 =?us-ascii?Q?G2StnUPXuVcD+QsJJ9jtn1X/GBBh5lAdkjRVDxlD2Zr0BTI6vfC2Y7ss91HL?=
 =?us-ascii?Q?yqQT7dZqvjbWb7JrbUo9TU58sposKS7pKv5eMuLtHugyFA/SZBbVgbu8Ujbj?=
 =?us-ascii?Q?eblNz9K3x34ejgaGr9QChhDFGPx9cOcGsQPQ6DwDaB+6yeppGFQTPtxzSp9B?=
 =?us-ascii?Q?MWQkXVvWUpRjueNQACmUidH6D9GS9tf0IMeOo1HK2Dd0t4Ava3NG89DgDG6p?=
 =?us-ascii?Q?FZae34oI1iVfZz6RuUV+9t/mMCL9gzGqkLQrIZulBpMl1IsN4HlqhFzvpEhR?=
 =?us-ascii?Q?hRpk/9k3HVNBiDmDt1Ir1V/i3oAMXsx+O012BzanS6mXUJTgjzyFEeahGBVD?=
 =?us-ascii?Q?r0MvOMt2zC+y1AaveOsDU5QX9eOjE5Tj5BQf0ix53C1euEXQfpoe8zje27dH?=
 =?us-ascii?Q?auFbwl+K2KSZI2yDR9J2OwF4cSTwyy8ahd1KYyfHtSV9bG7oabQ+mjmv0Lsl?=
 =?us-ascii?Q?mQ+pDNzZJJ5DMQbKkX/sJvdSJ3J0NyPEC4n2llhknFMVNWmmtZOd7r+ij/Qi?=
 =?us-ascii?Q?FOrB69HglPVk5PG8q8VJoeE9IdopqVLbxuqzMqxWAruSa3wZ0pnUPO75IqsX?=
 =?us-ascii?Q?3A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 875e2918-a6b6-4df3-9079-08da6060aca4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2022 21:35:55.8438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e2F6WjVnE8Q4VOC9y4XVRKZPHFWmKhT9pY37ElnNjOZ5POOq+3vDt+DJpfAsDQaQSZNlwv84eJLa3numFLAQYzEsPje3cWRSvKGIZEqQiso=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4831
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-07_17:2022-06-28,2022-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207070085
X-Proofpoint-GUID: zbTwXjDTRBHd_hDqsmdoHaStY3wsqxR8
X-Proofpoint-ORIG-GUID: zbTwXjDTRBHd_hDqsmdoHaStY3wsqxR8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Nilesh,

> "struct qla_tgt"->del_sess_list is no longer used since commit
> 726b85487067d7f5 ("qla2xxx: Add framework for async fabric discovery").

Please review and test this series. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
