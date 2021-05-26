Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DBCFC2B9F7
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 04:08:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 730EA6143B
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 04:08:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232416AbhEZEJ4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 May 2021 00:09:56 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:61250 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232427AbhEZEJd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 May 2021 00:09:33 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14Q47wxq001219;
        Wed, 26 May 2021 04:07:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=LXAxrmKCL3P01g65TwmHzV1ET6NEhLB0gou1f5R0M3w=;
 b=m1dL49JjhZ6FLGAVvw37QgZm8pRVXzL3A3FrviT5o4T0rSvVu8+Tm4xQFaH4TmHyxnMg
 Mo61PeKdjXAlY/ZrkbJdPFKGar49JQMuPF7ke1sjoMMog/IjDU0cO+YxgS5a5wUuVUwu
 Kjj6Ojco0Ybcohza4Soc+bq4ZZYty62lSwsQyslYs8tlG3oALSI4ngyuIpxLnB3mqs3e
 YKcXCsXQkQ8bf9Gpm2p4T7+iJCQ6NASD6/bF7kvi/OXmPYNRvt+w3BmQ1lK4cbwHrrxd
 6cROtKeBBSmtCGk5lC/RqYEJenzOunBIulRSWDjNq4NSp4umq/CEX9bFFH21bTMM1iyv 7A== 
Received: from oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 38r1bdrwsf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 04:07:57 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 14Q47v60187324;
        Wed, 26 May 2021 04:07:57 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by aserp3020.oracle.com with ESMTP id 38rehbs0ea-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 04:07:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HQHfA3SWg7IqJyHFRLSNsb6Q+iDGFFLG+IMUZdzsSOk/xClykO5moHijB7j5WzCJWd8p0TyxbSTtf8mCxUkEA+eQbsVKTnkQv2BCWerahfyhMbzUEvjWf/viPlu4eKflGiFddJKMraCDU6CvsigcYctH7WAxFuSyOd9+Ke7wpjrd3kWtnmMgXf83Sxr/0Xmgscogk6CvHSxJy/W+qgHlpcZgn8NO+R7rTHwHRpA9v/QVmk5DCmSav9NLKvKfH9Asegygkawr8O+kNGCoFkxIlA68jKVay5jG5SkUgJW2LHtiHvIkEfluWlju6zetHSptm5qVvTjUYw6zxF9rmGLcaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LXAxrmKCL3P01g65TwmHzV1ET6NEhLB0gou1f5R0M3w=;
 b=mCooB89ikfZrVsvPpkDOuPYd6Fo8s8v5qADGhhwzg1+VDDM0cH9ykrpFrQEH94pGWGua/IS+Wu8q/rmPOckUZgYYvOgAwAo3//GnujgqlfAT+QSdW33XE0ikZAZS/EPFo3fqQNP+wnS31bJicSGcS8Mnq5Zma3sqoYEu00lr7Cq41+cT6/NBzWLEiiNI1PmGEQb4nWnzLZR6Ngx+Rx23krIQWD7Za6bL00ZSzHZ38CkwBYi3S2fX5/1X+AtSVymvYvrNCuIBameFYQz9V9vBMBAIaXLZ0o2STZLsXr3HkP++WPo7eUpAp5TDLEC80b6dzYPOkVNoRczKPVGVqT2zvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LXAxrmKCL3P01g65TwmHzV1ET6NEhLB0gou1f5R0M3w=;
 b=pv/hjm3k4/5o/VPA9yIH9bhWwjwA28BAQD2JIdyEqLFA7epR/TivB9ko0P4ly3QCYmJHvh1aJ1yXIz92eVVS5tZIhU7X0Eh6ugwda660/RzWeqgSQuX9ho0puC6k2wzdbpA5Uh3xT4z7i/MDXoZY0L8BagGzc+kNA/jBppcIJNw=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4469.namprd10.prod.outlook.com (2603:10b6:510:32::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 26 May
 2021 04:07:56 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.027; Wed, 26 May 2021
 04:07:56 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, zuoqilin1@163.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        zuoqilin <zuoqilin@yulong.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi:bfa: Fix typo
Date:   Wed, 26 May 2021 00:07:33 -0400
Message-Id: <162200196242.11962.253701168331381115.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210521092153.379-1-zuoqilin1@163.com>
References: <20210521092153.379-1-zuoqilin1@163.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN6PR2101CA0004.namprd21.prod.outlook.com
 (2603:10b6:805:106::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN6PR2101CA0004.namprd21.prod.outlook.com (2603:10b6:805:106::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Wed, 26 May 2021 04:07:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d91322a5-93de-4f13-e34b-08d91ffbd73e
X-MS-TrafficTypeDiagnostic: PH0PR10MB4469:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB44696502AA553BCA20B5802F8E249@PH0PR10MB4469.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vo6+yrGnBywHBN2H/OGYl6vbCAjroIR9rQVXAJwsgr8wbrbQ/apI9/5W7J8uz1PMwuOC2KNZT2eis4m6nZcvDwhR4PCtqHbJTbN6U2/cOsxoRHMDmkYJ1oGLN7we0G/ajJCAE9etObcnZSY8XKM0VagX0Ayycf0dMlpIsLfULUNphUmkmVosadITop9Ll9jObgZEPRTm4OpUpqnxiwrjg1pxfn3xZXf0VaXJw0Q7q9J2t8YTpA2+jri5N4+yO8aEsKA8T5E8VsoHkVUNT7g58m8zXDrwKWRieH4P4KQE8bC6BDfGF45fpOgZEJdUmoHABfr1rTXlcoc2qVH8DY/zRVz+XkkQhio2ORL0QjJhHsxsI97XlqOovX8hkyWGVff9Rd5w3WOd+BafTmnV3HwzN+CVZ2zxweWL0ptcpyywqS8yK+jewjN2vpfuzrN1p1/26xo0EYxkaY2JRIkwqDxXNP23EDNy2GHqTXXgDqxrINpLWlBCKx2cr0s5u6+KeP9+Su6tjgFciDt34WRsNeTbVXRil/ILF3XGkMKPfoL/cRtmnEBqzxVOaizaPYO81ZJgWgDBKeuP9Cl+P0YWAVr5iMA2Je6aFSrRMg/wfnljd4OvngLykzv5IxBUE2U4ubF3xAy91+19/VTj7SFaZZUp6ZXkpZbSh2et3eowOGzZs12J1nOl9pXf5Z5Q7AmYNvEzQ3yzoMDyQCDDNKxJyfdQW4O2QaLXQIy6sQDUOcFkoT45xZSSZDLmQZestpvA1nWV1GorNL8GhbKydXA3s1fDoQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(346002)(39860400002)(376002)(136003)(316002)(16526019)(54906003)(186003)(66946007)(4326008)(103116003)(26005)(2616005)(8936002)(956004)(2906002)(66476007)(66556008)(7696005)(38350700002)(52116002)(38100700002)(5660300002)(8676002)(6486002)(86362001)(6666004)(558084003)(478600001)(966005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?V0hrQWdjZWJKZG5hd1lRMFRMdi9vUWFRWFJLRld2MGNzb1RNcEhHM3Q0NE5M?=
 =?utf-8?B?YXdKKzFPWXlvNy81cWFuUUJwWVc4Sm1xUDAyN0ExZmlRc3dsVjJ3NFVHWFdq?=
 =?utf-8?B?RXRCM0pPekp0bFNCUUo0WTJrWmFQVzFVUUpRSy9LY0Nub1lkRjRkU0ZkWkRQ?=
 =?utf-8?B?LzRwQ2dXN3hYMUw3L2NEWmhmc1FoRlYvQkpMSFo5ZWhSYU1sMzZseFZXYUdK?=
 =?utf-8?B?dFZWRE5iMUE3b0ZqY2R2SHJBUXBZS2dBRHh1Y3N0aWRCV3dKbjErdHJlNDNJ?=
 =?utf-8?B?ZnZZM3NNeEE0K0NqeGdoaXdLMnQ5VmN2eWF4ZnhpcUtoVXg3YXJkNXBoTUxh?=
 =?utf-8?B?eFhoRWk4TUtvanVKdHNjS3hzSUZVVVlyK3FUZHdiT3Z0Y0xBeGdYMVRJRWlQ?=
 =?utf-8?B?d2p6SjF3c3R6VjUyS1FEMzhPdHZMZlNhVE9ZczhPZ1lCYVI0U1B4aXdCSTg5?=
 =?utf-8?B?ZkY0bXhML09aV1RYY2FSYVdiQXFsM29zOVdRT2w0REEySllMRHY3MWkwUkdo?=
 =?utf-8?B?MFdUT3l4YUJqbk53Zzg3aGtLTlFBTUNRT3hMdDROYlpiVnUyVktxb05IQ3lD?=
 =?utf-8?B?eVB3NTk3VE5KdmhTRzhocXE4ak5PM1RJb0p3VG5QTy9Nb3YxLzBSYTVIaFky?=
 =?utf-8?B?a3hoaXp1UWJZQ2J4YkNUTzRPbmtZR3hTTlJsT2tUNG9ENkVHWUVudTVLY0JZ?=
 =?utf-8?B?bTBxT1I4Uld1U01FdUhpOXh4eGFtNzVCRTZLZmR5c3BacWpOVk92dzVsU2wr?=
 =?utf-8?B?U0gzb1RVd2QvQ2dMYktqamExQ1J5WU9GTmNzY0x5bVhITFA4OHFQaWVwaWwy?=
 =?utf-8?B?RDJUYmkrUC95UlJlbUxkUTR5V3AxRUU2YXcvaW92VHN6MDkxbjg1eitGQzVR?=
 =?utf-8?B?UE1PWDY4dTRhcTAwR0lDcGZHWVliTnRYQTVzYVh2azNObG1HVmxkcm5Xc2FB?=
 =?utf-8?B?VWJZUWhWdGRLTHBUdDJkT0FxcGhZYnFKYnlMNXhYWE5IWFh0Wi94N1JnVUxm?=
 =?utf-8?B?N3JqbjNtcUFpWGNDY1pSTlJVNjB4TVFBRWdqbk9UMS9YaUNReWR6TUpqZmtx?=
 =?utf-8?B?aVFWdGNCbVJEWlRJZ0lXOVg1Y3ltT20yVXQ3THc4cFBud3FIQzJwMHQ2QXJ2?=
 =?utf-8?B?bTFjVFU4dzZxUzYrNXVsSEk3NHgxaXhLcUJnQ25aTFM4YXNFcDhUNVI3b29Q?=
 =?utf-8?B?bXkvZUF2UFlYZ1pKVmo0VnpLZHhva0hVSWJiM2I1RXk5Rm5Id3hGTlVkbi9C?=
 =?utf-8?B?VmlLc0JBNStBUEUyTjRUdEROeWVPdTZiOFJLekpKV3JiUUU1eHVGMkJoZDlH?=
 =?utf-8?B?bHlwbVlVSnBweTBiVllRTzZ4QzAyM1hHd2l0TC9SM2R3K0JaVk5QZE1FSDlQ?=
 =?utf-8?B?S0d5bUNURWZVcEwwNWtzVGN5RncxWml1d3ZYSTZEeXZNeGNYdVM0SFhJN0Ft?=
 =?utf-8?B?SzdMTnFwdmo4aUVTdzZUWU9TOUR5WFNJWDVEKzdwN1NHalpUZHlnSTNSZ3o4?=
 =?utf-8?B?NWhQN3hHazlOajFJY25UdnEvekRRb1RUQndKaEYrUFp6dGsxUXdrOHVhU0VQ?=
 =?utf-8?B?VUNHazE4TU5WZUEyL1B3U2ErWEpDWmtTTzZyQ3B2eG9aYU11U3czL2pYa3M2?=
 =?utf-8?B?WnUyUWFtckNXSFloOTdUc3R2bzZVbDFYVUpvNzllemdPU3lJVytXdXduakYx?=
 =?utf-8?B?M1lUSmJ2WnpEWnRUVHhqbXc5Skhodk9YSVJmejFIS2tDeGtNek01aFlDT29J?=
 =?utf-8?Q?VD2GPcjCDLXOyEFbDp3cBoduHdvk0RZ/Jvss5I7?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d91322a5-93de-4f13-e34b-08d91ffbd73e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 04:07:56.0520
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 02a33CS/KkvtSmM7Gkho1vlTgbOq/acSGb2hKUCk4hC8rNBFYc/DZ2OQ/X6VlbKc5X4ZlXsbRZgq6dHhR6rcyUt9SlFvFK5tW79a10ZUV5A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4469
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105260026
X-Proofpoint-ORIG-GUID: 5tJPij4r9R1oI1AqL0tLiMPHAbhQdvHi
X-Proofpoint-GUID: 5tJPij4r9R1oI1AqL0tLiMPHAbhQdvHi
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 21 May 2021 17:21:53 +0800, zuoqilin1@163.com wrote:

> Change 'chnage' to 'change'.

Applied to 5.14/scsi-queue, thanks!

[1/1] scsi:bfa: Fix typo
      https://git.kernel.org/mkp/scsi/c/1ecc820db0b9

-- 
Martin K. Petersen	Oracle Linux Engineering
