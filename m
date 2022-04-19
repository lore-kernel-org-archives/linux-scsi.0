Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39C0FC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Apr 2022 03:03:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346081AbiDSDGH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Apr 2022 23:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345993AbiDSDGG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Apr 2022 23:06:06 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D3B028E22
        for <linux-scsi@vger.kernel.org>; Mon, 18 Apr 2022 20:03:26 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23INLDfY024754;
        Tue, 19 Apr 2022 03:03:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=qJ3mXOPz5Fk/OQ4e7R/n6xypzLZp4ChZwqQoYpA7XOU=;
 b=qtvG9P6F1B8kg1JzAXFn2Hb7r5JnStMCyhk8/Sx016DJ1N+RvSRqOi86x3M5DZiV5qfQ
 jv9jigCDsWrbOB8uVRNE9A08BThZJAfWgWBvsUSiVMoNsHw84/VTVQ7cqQ4JGbQ9wOFW
 D0MQvI+sdWJMPxiQZm7ZcXLSUj1IbWBYt3AvMGAxyg0t5otS1i1gNaUG25b0imBzKXg2
 6C8sOPtXeyawakpafIRYzsXqQhjMVJKX/WdfZM84hVd1/Cpjrn2IJhKB8GxTEGdz2Avv
 uZkabJ0IrESfOiWn9eoWwb9oNF8I1XwRC4ZBuJI9CKN4rAM7+Tsiw6WzT73u6ub15e07 KA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ffnp9cr80-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Apr 2022 03:03:16 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23J30csM019062;
        Tue, 19 Apr 2022 03:03:15 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2049.outbound.protection.outlook.com [104.47.73.49])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3ffm820cdt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Apr 2022 03:03:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aNriGxJh9r8B4cBS+tsK4MV5qQuTq/oKUQooWhKwe/esD1oYwZ2DCt/iWdH1ZRk7DkrHSxOUK5Qk/KhKNVJCZEMp2ZLGJeDMUfj8RAK7TziKqsVZ/2jLyCSnkTTfnHhLu3Kk86HJP59m/bqZ0IP+YJK8DYVhK9IvbRuTq8xjnEwtktLw+nrgleoS0FULmlBMCWNwfC5MonVRQwM1t59GYwr514hHmDjhfZcfmQTYiATUjqamIjrfT7CjDcZsQ3cURYGb1gFV/TWenEALyFKMqBxsnX+IaHoqu8VEoUidWnX/PZgCusjqNdvrFDJo5X192MWCr7z5P5UDezN1/nD04w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qJ3mXOPz5Fk/OQ4e7R/n6xypzLZp4ChZwqQoYpA7XOU=;
 b=M40zOxLxRTVejO76uskc7xRmg9QgXZCIndiEQDKeTt8Zpcbz6Rc3x0YnWQZpy0Oez96+BKBqWlxD3R5J3ThQVQWnV1BEW2rOQjxefoI3afWmh6PLFlQTrNovQJiAI3jWd9HTy2/Xn1z4QGEWbHL6lxI4ArNcOoVZWZWRTe5e3dRM0Rmxr2AnPn/T3iJgWPaF25T7gygxOaw5vNIyKELchHcsCzx+Lg7C9WChoXWn6PRNSzlyVv2a54UzbCFduGbpZfhc8D+sBqPBeEq5TfGTE8x/Sm7KxSnL7jXw+WcJiqc1+KE6igAhbDG8PnJkbVsGZ8xTuGoOv+CKAX0zHrap7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qJ3mXOPz5Fk/OQ4e7R/n6xypzLZp4ChZwqQoYpA7XOU=;
 b=xCf75x7k0VmVvqslvMj6xbgxk1sCr8UCll6/bMgkDgav+5lg2Fo+cjREFWRpAjN+m6RATwWsYY8vy5aoI3i7nCXRAzw5KjlQnzpmvsY/RpYBc747EXl/7FKRTTUhzb+8GMeXRViTER8NVkYTJhZCesDfCd5TtDWFAYqhmeay30w=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SJ0PR10MB5693.namprd10.prod.outlook.com (2603:10b6:a03:3ec::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Tue, 19 Apr
 2022 03:03:13 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192%7]) with mapi id 15.20.5164.018; Tue, 19 Apr 2022
 03:03:13 +0000
To:     Sumit Saxena <sumit.saxena@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        sathya.prakash@broadcom.com, kashyap.desai@broadcom.com,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>
Subject: Re: [PATCH] scsi: increase max device queue_depth to 4096
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wnfl93ms.fsf@ca-mkp.ca.oracle.com>
References: <20220414103601.140687-1-sumit.saxena@broadcom.com>
Date:   Mon, 18 Apr 2022 23:03:11 -0400
In-Reply-To: <20220414103601.140687-1-sumit.saxena@broadcom.com> (Sumit
        Saxena's message of "Thu, 14 Apr 2022 06:36:01 -0400")
Content-Type: text/plain
X-ClientProxiedBy: SA9PR13CA0146.namprd13.prod.outlook.com
 (2603:10b6:806:27::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d74311d-fde9-4466-1768-08da21b124a9
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5693:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB56932FA03A722467C1444BA08EF29@SJ0PR10MB5693.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O6ny+JZjGUTc9urOblGgCoh+yRExa+sIL41iwj7uAIJQFaWETvhYfVV/e/pbZ0yc9THEOuFqaw9yhbzZvFpRT88Svz0/uHMttlozzcGybCHD8xyKnyprUBbVMwQnGoD4Q4GdxXZhOatoL8/sgQQQEGLKHkaa+mH0otA/S691j17rY4ZFJS0P/d6QhOZSIjkKWcHvoZGkVmi8KRt2j5vDoXQswCvqQ2i1iW1qMQaHgK1NLHl6tHc/GZVDJ3ce0YfI+Zj7FhItZpwrZ7d1dmlnO4RBB0AunIZDObBGqT0lENkr1F1oHG2CYWPHDZxYXbeqFj4xG6b4j3M2++z+ImBvtux3EOOK5GmK0WiXIQvSMiLWDjCTBdVYvqjmrMry+//GvSDifVD50lJjZ+gcXaY/eoHxx/JW2jbnkRJm4R+IKmCQ3xrw5MVPMl6/KO1SM/wIVOyCTxCA/UawypmDz9rVdPk4Ls+hCScOf1zCGde/CwdOrBtrSIqEsWZRDzB5XJjK3fjunJVZgUHswLx5OFd8RFyehw9OkJh79plq92+UtFk0Ob8A4GVkPGwvA81G8ELP4xHDz0obPJIxbpNX06u0phvR7KmRaItSApjHUO+fnxV8EpwvFunKDS/k8N00+uixPdZR1AxTLHNgNBEoS0OmRwYMmEq1uQ+6AFN6EAntPxiUh3IGIg2ObN8F+Amg5KDa1VGrxj3PNG4e0sNUSpLuKQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36916002)(316002)(86362001)(5660300002)(66476007)(8676002)(4326008)(38350700002)(38100700002)(2906002)(6512007)(4744005)(6916009)(54906003)(8936002)(66556008)(52116002)(6506007)(6486002)(83380400001)(66946007)(26005)(186003)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?s+Iq+kWb0NyfoGnjz4UKA4UzBy2Ny88aq1MS+KgeOxRFvkoskB7SAmzH8AKv?=
 =?us-ascii?Q?diIc6LfIGX6mOBPlh+tM2ZZHtnujNXLf6g3vKaZJ07F5aGCPQH8LVdxedlXl?=
 =?us-ascii?Q?/pKrLZXI0E852A2rH71S03jAhKtyuzad7KIR9NJXN+mOKcLH/Q3YRauTFKUA?=
 =?us-ascii?Q?RtIvk4D4k1uxyyfJXeItHxcISVl2u0COXB3+ST6BzCFnECpSKkug4lSnVPKM?=
 =?us-ascii?Q?6nbEFPJD6AlQQnJcMNp8abTfgFcEkqeHrMcl9M1tdZ+v7hkGM15XnGS+uOy4?=
 =?us-ascii?Q?rzgMzIPCBAp7nc3sRIeJGF1ozSHXzu0bEJnlWysM4okVCIFKLNLA9OOde02K?=
 =?us-ascii?Q?+J9kTqMO83F/EY3T3hvbIVOdJVdWeXT3MScVN6Y4u0duVnymEn/vOwoSu6yL?=
 =?us-ascii?Q?VK3c08QLfStw4XIM8JGbAlgGOdvSxhdThPT38VcRUCSSevUey6ASGjgM/tKC?=
 =?us-ascii?Q?di3hIw4TZgyXuynLZrDiMAnRG/kCjiMpa2H8yKkT+2m9+9j47+izEK83UAlq?=
 =?us-ascii?Q?bL++VK7bYjfoywGRGSdim4iGlOazAd7XpucRo2hIiMASwnAcNBhv+C7mO7YI?=
 =?us-ascii?Q?32uO4PsbjD59nzAxzH2U6haKc/VEelLyhJYHjbrkQquzEetrr/ZrH8HlxsEe?=
 =?us-ascii?Q?fyrQQ9HKKdatQ4fsu6+MmEE5J96gs7zRIfvkN/1/VcSWwJ5ve4NjO7XNBume?=
 =?us-ascii?Q?sTXwuM4mM8zIj3lx9H7CbWJ6ZJj+Yb2xwLCUwICEByM5d9mDFLy/xqaoT4mR?=
 =?us-ascii?Q?d4LOVmuG9fBHOVc2GfQrnjiCKUU2sKvAbf+FN8xHdzx6hQKQ88HM5jZvPOCT?=
 =?us-ascii?Q?9VSbh21hmay15lfFf5P6EbwkC887FcfRg4N+JQC9P7IQr4IXmQplXySSo1Ad?=
 =?us-ascii?Q?raEFLF3NcWowiGuaLsIR9OzaKHkOA++Y3KbeqdDGfBG1OIVF2ZrE2H522trm?=
 =?us-ascii?Q?a+CcsmGr4iwGY8YVaedXT1oXCzh8xVMd3d/sZoEILqlg+7M3Q3S5QGwKnqge?=
 =?us-ascii?Q?fuKw0wWjNACbYVbKuUMkHLuZFkTAKUzCOSNcGS30ga3HAO4aveHY7HOaqzQ3?=
 =?us-ascii?Q?uAS8HnGkqLjQtY3hnsxs3KSS75C0GW4LaSwJVl+XcDQKyuOUG9jKByhoRaWD?=
 =?us-ascii?Q?+UAHQ1uL8eZ+QKHzjzRTOk4+nwQFSQ63Lm1xk3PH+64BZzg7aCweCjyumXfc?=
 =?us-ascii?Q?M7lpiw3U0ebOFRh38SfYQnw+HhnZqB5mH1d3tM4cddw+p9UfcmG7JNjz8HnX?=
 =?us-ascii?Q?CURcV+xvcfz8lUzN6X1B2wtYjQByYVIXmOpGg5P2v326j1pG8bpJM8SyHF2h?=
 =?us-ascii?Q?cHNFLKtarxvXaxXddtI4w5u9T0v3X2sa2V9xAPSa+b9mpzvHrTfpvnZxopRF?=
 =?us-ascii?Q?7+kdw34wk4UmH+G+m6CYtay+TPGPEUZOT5uZiyqJoAzQvIQ8lzC91HCTwJAX?=
 =?us-ascii?Q?OG0xomzulYzrIlOTNCbUxqdg1aZw8Hawvhymny5bgZacvngy5J5newel27fh?=
 =?us-ascii?Q?LyG/HkG+jAUmF9UcJWTAiyTvruhCdMHFYTUqMWzLR2E5xdRyIR4oES3nvT3N?=
 =?us-ascii?Q?u/yvsJMe7Ul6mD2qw3WQqLIa2qem//ySaa/iPnU+m5VVektH0VAWC6Q9EzDt?=
 =?us-ascii?Q?qV8ftCecXkNIWenRaxLpOCEZbfJqNtZJm3x0CIJVYwGIn6LfqKm6TG/dTuZ8?=
 =?us-ascii?Q?3/vdN4DtLYIBaUbg0JGkPoDY/a58q6g+u5+sSZIE7qCX+lxk7YjKr3F5oF3S?=
 =?us-ascii?Q?Phzb6mqHs7yRmDeNxXOP73rns5kZUxo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d74311d-fde9-4466-1768-08da21b124a9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 03:03:13.5116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1egPUdCoAvzbQ66Es63wJ0bmGs3kC2W/9i5CpLdJLKDEigO7KOpMSTdIcPet3eTIe9zR81VRNTowsLNWVLGA9LwTRn0qAbb/PbaBdcnkxZc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5693
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-19_01:2022-04-15,2022-04-19 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=981 adultscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204190013
X-Proofpoint-ORIG-GUID: 67HNnZP0rBsn9SXpbW-Na8YJsI3eS-_L
X-Proofpoint-GUID: 67HNnZP0rBsn9SXpbW-Na8YJsI3eS-_L
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sumit,

> Maximum SCSI device queue depth limited to 1024 is not sufficient for
> RAID volumes configured behind Broadcom RAID controllers.  For a 16
> drives RAID volume with 1024 device QD, per drive 64 IOs(1024/16) can
> be issued which is not good enough to achieve performance target.

Applied to 5.19/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
