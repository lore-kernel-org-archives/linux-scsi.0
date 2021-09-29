Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8372C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 03:24:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE77861247
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 03:24:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243957AbhI2D0c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 23:26:32 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:15906 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243927AbhI2D0b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Sep 2021 23:26:31 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18T29IsG027595;
        Wed, 29 Sep 2021 03:24:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=4PSa0e8x93fWh0+QO+oTJhIDgY2jcPQzeHinuLmO6QU=;
 b=jIMd7DLoboGKBaiDwQmXo3Ne/QzeXuPJjoXYHBAZE99lIidNBfzwH0/nZ2YZc/fXAKQ+
 hNcpVRZ67DWA3D+0ZYlkK0WLActjOmcusnLHN4MFAu2hqPpO9LMHixMzXYofKxE5wh+5
 MKNfq/mFy9j11dkE8DJUFENpXiUYu1W2erarRe/3qwjkybPJunGEf/iouuKxVskQz8K5
 EoJ9Xx0HA19dClfyiKQWuahkHasGswjiun2spcYH3O/xO+Mu0/lCEk3juu9x29AIpRZp
 wzYHu8zHJpzdExoXKS7meMjhmagzsPCwr2TMvzhJsP3LoGhuF5zx9z0RNPkIEn6cxxmy JQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bbhvc49vv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 03:24:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18T3GRmv056119;
        Wed, 29 Sep 2021 03:24:31 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by userp3030.oracle.com with ESMTP id 3bc3bj9nv2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 03:24:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UG64FzQ7uqTJYywAUr665UpNKLuvL3RF4dkrQSNE44tWzNOG+XJHayb22+cPyml8IhxhOnYLytXujkPCxkZ+Ggp6LHybSqcRHsc/0/fkmN+VQ+3YJtNzLKErJHWaGtG2KIsobJS/GQ9mRRGgjWcpEMGz9m4wyUiAfGnzjNxphdonof2WNGfV/wrTMeVP7LiW95Ld3f+SfY5VvXfrjJjXpQcj7CJTQbnQCgsCJWcygxmJUH90LWNFofuk0gZPcbMIs2YvvMrH0C2AJ8042NJcBn5ub60IzSwmTEqZW/rOkOQPmOUqQH8W1ungdE/bl6nGZQqPtZSfRTRwp1Qwfa7OBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=4PSa0e8x93fWh0+QO+oTJhIDgY2jcPQzeHinuLmO6QU=;
 b=bj0k42ndmh5WDDghobW3ItU1s3eYLGy9MmlL8H79XyF+vUevnmB+PMd2/+OjG+Q+gWllb3vr/0tr/+ikKUiAxbLs78nO10wfNj89Gjk5QEySi8+T8nrDzNhueKMMQhCg7zwP1jQldCx4eGpuZmjoh/UDnEn0jvlaV4oSXNr7FFn6tqCtTatoqbOXsCJbifRqwNaKqNotMm9B50Uo+gOCs6Uf25g+UMMq8l3zGm8oLH4HzU2hEPDvWzdEW7Olut6JV7rZtD+lRVlOkVfEjIDJL6yn09Z2EYXllnwHC3u7AAdufIQZRNDjhP/voOLmPfJzC66+N/N9sHUMwwNv1PkzmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4PSa0e8x93fWh0+QO+oTJhIDgY2jcPQzeHinuLmO6QU=;
 b=hJRN5Oj6OGadYe/mXfTxvVzhBZkd/hQr3p161NiHCV5p1QKkj7y1Tp0hDom3yhKML6K2Sgb9db/tAy5jwxsW7kwwHc/L3J5iLwDtC9Z+fP5GELLFGTdjffX03m/LUVsYMXkpgMoXTfCxZg/+nOKLFqfv9Ik1B/8MTiTnpLLLYfY=
Authentication-Results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4583.namprd10.prod.outlook.com (2603:10b6:510:43::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Wed, 29 Sep
 2021 03:24:29 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%8]) with mapi id 15.20.4566.014; Wed, 29 Sep 2021
 03:24:29 +0000
To:     Anders Roxell <anders.roxell@linaro.org>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com, jdelvare@suse.com,
        linux@roeck-us.net, avri.altman@wdc.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hwmon@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCHv2] scsi: ufs: Kconfig: SCSI_UFS_HWMON depens on HWMON=y
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18rzgf4in.fsf@ca-mkp.ca.oracle.com>
References: <DM6PR04MB6575F2F6841B0573560E10ADFCA49@DM6PR04MB6575.namprd04.prod.outlook.com>
        <20210927084615.1938432-1-anders.roxell@linaro.org>
Date:   Tue, 28 Sep 2021 23:24:26 -0400
In-Reply-To: <20210927084615.1938432-1-anders.roxell@linaro.org> (Anders
        Roxell's message of "Mon, 27 Sep 2021 10:46:15 +0200")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0100.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::41) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.46) by BYAPR07CA0100.namprd07.prod.outlook.com (2603:10b6:a03:12b::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Wed, 29 Sep 2021 03:24:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a40d9232-1e7f-44bb-b38d-08d982f8a573
X-MS-TrafficTypeDiagnostic: PH0PR10MB4583:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4583CF14FB8B4849737669058EA99@PH0PR10MB4583.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CePcnPZHs3lU78tQoduop+TCcAqw3yJ8NZ3KyH7bb7duImza6L0ln4LEEMF1ZAo/EvEXJmMUscl7mI5uCwrVrbR3dLzsxt+Zes7aZqkcoeybi4m+uhiSTSvi6gxjBM7gsOqyVTPVoJaKMMAAPwoYnxZE8W8ntcEV1/TM+QUUZPo6NxNjRG7d2OuybXbINVip1ikSeW86uKfnTLxUaDXCL76XpOyvXNRncRI/wmZUtc5bLfo9GVnBTvE9uIQDuFlbQUYbc3ZmwiJdDwbF6ZMbTBbEoI+ldCxXJBmAIeSxpmqzW/WQVBm9tqf/NIVYcSvF/qjwSOe0Ym0LaRAMyKR7UUvdAqxnXI4ii4opXay0d1ei1+Cv7h6v8V/4CgPhPrnAZ1VBZ1c/JKuxkYrOPNo0F2BOwz8RvxHPaeqbbDqDOcVhi3PS5ICm/IeU2M35YCyY+hLryNlr8/pFljhAdfas/w+1ENNwvtIuQ+fAhXmVSA3sj6DUeZrY9KjAnV5AsOJp+u631V9/U5dac7oPHgrCPoANdZd//ORwHOr58keFxzSQBkw4+ZjNlExy43jyRDqdcI0xpuKHaVtxTx2baH8qk7novRvMPc+/HsbE2bKcVm+IHntA4VucQ4d0HeBfreRZZYjhErs9Xf9eAi+4XOXV1Ee0PltigXrNtfFwrZPHNB3S41Dm0eo9d5uY8VMJgczvPurc1ttZy8oo6sZ7SZLzwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(86362001)(4326008)(6916009)(316002)(38100700002)(38350700002)(66946007)(508600001)(2906002)(8936002)(66476007)(956004)(26005)(8676002)(5660300002)(52116002)(36916002)(186003)(7696005)(558084003)(55016002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Gx0Tp9JcvlAUE7Xe5cf/Zc3H3ahgLCnXecrSIaWqoVM88t3j+YZ54BXVSbPY?=
 =?us-ascii?Q?Ja6GsDROD3E5YsH/jXZOf+Pdpx0sRv8kuRO3P1rvPO1e4qYUxJ35MNyHrj0y?=
 =?us-ascii?Q?KIpI0liKr7fwk6yKxRjrmyqvCEyFQM/ipaOoQpkz2/ciNQeuuv/X5kgXADrv?=
 =?us-ascii?Q?NQcrNFu2WZoJqQAsXyy3a6uut71sW1S5LUJyIk/rHeBOWuffQyi9cg/agjI7?=
 =?us-ascii?Q?G0TTVkRyfEkRaPzpsOUGF4Pe2z3PW/jFWwl+HYxsfeGMZ46hLTelhEl/WTFl?=
 =?us-ascii?Q?hF9QEVthatXwMAMbBfiGLmjf8bfBKNbD65URe+I9noTMYKNolIDBMjzMdPUY?=
 =?us-ascii?Q?kV0PNjRxXuG9KM9mRLLMyFWph8GN2yEPd3WeQN+UUuhsl77fipnkSp0KH3/v?=
 =?us-ascii?Q?ucgxHTbT0MlR1i/QgOOc9nSY/djKuAtBRGQpBRTBbPYhzFrF5/Umc/iFZN5E?=
 =?us-ascii?Q?rGMtqcMyyRbqsyn/e92XTF8y7pY8gcDA5ZgcXRTxtS9g2dpHr1KiELyqW7j1?=
 =?us-ascii?Q?J9l7odRCyQwBReuV6KcG2XXLXKL3mG5D65wx+Zw3pddDW6R277JZEJD/DzW9?=
 =?us-ascii?Q?mJmn2D9PaAvZRswJYb7WYj8lLYT7iD043ErfZBA/ROVWgKJsLEId4RAGM2No?=
 =?us-ascii?Q?27LmAUTBNGP8J6RXy0ASvPGq2FX2y9Z8s5TWc02XL0vV/vOq1oY+8gQEECGD?=
 =?us-ascii?Q?WqNGWiC2BKaIKgino/KHVgkq71z49CPTRl4CnM9aW58DSmF19Eqn8rdy2E//?=
 =?us-ascii?Q?dn+qck4PskmFGsxq8usaBHAWb19MNrux9oerFu/y0C4HrEOcmdur6mPqK5Ki?=
 =?us-ascii?Q?Rbrqcsz7siJ7eJGWbP1h1ZCfp1Qy9NnW/gsFaz05azOBmIWs1AdifnidyntF?=
 =?us-ascii?Q?Sm4Bzi/IeQZucM8TwW0IM9hN0us6pHqPcKY7opPYsKo3/aLQVeQGykRF3hhJ?=
 =?us-ascii?Q?LyftZwxRrdkwjowmAz5AharpcYNypT02Nsl8uyOAHyDzpFeFyu9eguOPh+5h?=
 =?us-ascii?Q?Wlpg6k3fcObjcnTURVidUZGkzmYy/Yu4YAQ8mjpO8+5dwWe0zd9tRqyJJe0B?=
 =?us-ascii?Q?AXovPVHAQNkisAltrnzafILmkGfZWHgqOySODh/6HZZcz7PCVKvnvZYOjdmI?=
 =?us-ascii?Q?koLZwg3w8k6X9wJZViLKNIFedRTMPjD9bsDgt4n8Dayz7n8gMRpIBEf7jFl7?=
 =?us-ascii?Q?8vturHUC0sw5v+7GEztVz1rBqj71qHQ/nrFvQPzjfw9OYYMXeYSniBmF1ucq?=
 =?us-ascii?Q?8QjyyysqSpS5eMmsWuom4hZudjczBzqVn2kuAWfCJ9Mu3MNu99tHmG/yV+SG?=
 =?us-ascii?Q?KceFdcaR3ad7foKdy13yLM3F?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a40d9232-1e7f-44bb-b38d-08d982f8a573
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 03:24:28.9805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BsV0dWx058LKOaziMuSRZJFcol6brtdZai1BKWcYsV7dIJzEAjvXRSFOA+GSE+hUtLHkDQcFSA3Sx2964IXjT6xusWDOhoxSxIxBZZb/Ohc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4583
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10121 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=826 suspectscore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109290018
X-Proofpoint-ORIG-GUID: fwHNy-MM3Slw1509QAeFa8ex2l3IUhIj
X-Proofpoint-GUID: fwHNy-MM3Slw1509QAeFa8ex2l3IUhIj
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Anders,

> Since fragment 'SCSI_UFS_HWMON' can't be build as a module,
> 'SCSI_UFS_HWMON' has to depend on 'HWMON=y'.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
