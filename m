Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86C74C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Jan 2022 03:20:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344268AbiASDUT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Jan 2022 22:20:19 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:24744 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240542AbiASDUS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Jan 2022 22:20:18 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20INxWBr011214;
        Wed, 19 Jan 2022 03:20:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=3uDFwjjscTKqMAOrlPcoH+mDlK4g2KFPNxf3aXmSDQg=;
 b=ulyLAVrFr3+IY9wq7XliUsxR5O4B2h1hc6wi+u8QeoT7FeDCSyJYSdgHlQ0NeJWN02B2
 cifp0NDpYvvvRrtQNc2DBLGM0eYFK76qNU+dJ3BZXCI0Ah+8eTMsSLxlNg84vhNkFCX0
 ErIHHgmvi+o8+5BHG9pUPkz/T+UecZQlK0Jh0bYNhEUTG1qUvqgH0ZZ0xRcTa+q7QKbW
 6i+rJoWCjyXxtxRnQmsG10Zv2ERDecpeSVHPwOI8x3NjtJ4SiUEGi21j1kLEwXdgTSTi
 oaJFy080lb67Nag71muMUZZm0tOf/54gkUSRMOxaKe2Uhl/sEflvb9+qJYaD8VNpC451 Qw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dnbrnurr0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jan 2022 03:20:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20J3G3tp146931;
        Wed, 19 Jan 2022 03:20:16 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by userp3020.oracle.com with ESMTP id 3dkqqpkrr0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jan 2022 03:20:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GCUVdjlZf3Ra+Uc2JuoNUduCX+ahnmIu3tuRItbrRcj2SQXjfeVUArunJRir65m+kaEAYk2TPDxPJKBPvXkxayG0xbR2xEIHWwNo97dkadQZ7bcc/sWDcj69SEYMYixPFN1ezR7UZUACrrQII2ym78kXxEehSMpIXiS37PQ0URi/fUh/pMxoHGAxxs1kzDxIdw0RA1HbJCIx8nNbCOV0OShKQy/hRumVcobNvwr4LnGJ2cpepaximhq5nayuUNVdAQ+RqjizcqMMdDIc5ZhBymTGvM21p9ce4AsX2Zp+AQINAlbPN/+fz9k++DNH38VGWyC2TfdLJrcDK3JbqlY7Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3uDFwjjscTKqMAOrlPcoH+mDlK4g2KFPNxf3aXmSDQg=;
 b=A+916DaCJI3tDV5ACiD9ZOzRLivrMq82dilfgyXsca7q5ENY0bo2pN/Mb9y73G7nhnC2f0oFitCxN1CronIw+niFTWxDnLqu64A9q9MzTtJFFTjjIznDZafyXPsqT0f/eicywJllJP81OhPtZIhy8LJd4LGVj0oj8yEpGblRrUT3rLFCjOO0rdOIIsWTl3ZQkMbbc86HbbUU6kIA9EOjXF+DArbI3A7SOVqpD/22UG4lxHpuvQPMgPvYIMiuhWUgLdwAY7e45kf3SFoYX/D3ICX1kLQDAh5B1yyBAlBGA5iSMDFNG01HoASkUHS7q5MPRBBrb+NfqgJ1rtFK9w6ltg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3uDFwjjscTKqMAOrlPcoH+mDlK4g2KFPNxf3aXmSDQg=;
 b=dMzWUkXIhsrI9wZGaAedDXZnHZAoiKRlPZCXEWeyJ0mnBP2ud+S+5/jmKP/uHEKDiXhJphQVBz48B5aV7/kYfmvqVhi3wcVQXyZp8KM/DGrQyR3fOt3CVWoc2QWbtlpfx5ZJBzyi6kM44mrkTTs1n5fkXYoaKO/tM83n4nScZJU=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH2PR10MB4277.namprd10.prod.outlook.com (2603:10b6:610:7b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Wed, 19 Jan
 2022 03:20:14 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1053:7ae3:932b:f166]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1053:7ae3:932b:f166%7]) with mapi id 15.20.4888.014; Wed, 19 Jan 2022
 03:20:14 +0000
To:     Sven Hugi <hugi.sven@gmail.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: Samsung t5 / t3 problem with ncq trim
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1tue0mn3l.fsf@ca-mkp.ca.oracle.com>
References: <CAFrqyV4COFCGCRN3bXjoSnudMtr0JhhFviUj8QtEZfJq4ZxinA@mail.gmail.com>
Date:   Tue, 18 Jan 2022 22:20:12 -0500
In-Reply-To: <CAFrqyV4COFCGCRN3bXjoSnudMtr0JhhFviUj8QtEZfJq4ZxinA@mail.gmail.com>
        (Sven Hugi's message of "Tue, 18 Jan 2022 16:22:17 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0501CA0066.namprd05.prod.outlook.com
 (2603:10b6:803:41::43) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2aca2889-f8f4-4753-8d5f-08d9dafa9b9e
X-MS-TrafficTypeDiagnostic: CH2PR10MB4277:EE_
X-Microsoft-Antispam-PRVS: <CH2PR10MB42770A6E0933958C7C325FD98E599@CH2PR10MB4277.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZkAKCxdDzsxE5l5QBqRsqGztNKbdmShym/GQLQG8l+JbhIYCWLglQhwf/2XUgJ1KkEt1BkN2chpSkhw1GfujO7vtpeb7r2m3kTi0as84ByC336ZEl+B+yxshdikLm53hViNRQ73j2n+OjWGc0fGOEYa2nW9pqKUNeH8olzqwrhartqWsFZ6rIR4YHcUXeb3Ib5CYqFm6txrWyYp7iOgyn68z1V5E1B4AOznMhEOdv1U/zsqqfKk4EVVR+V6yselz7xXhOcIi3UJ9hERz7U67A8B6k+EtQZGAPzKS1dhYwU9EHoKELlpcgHsp/MKXAtlVHEeVXOPmVL5f9IZ+6+eLt6jubkQGrxwI5yImWxluOf7RiHftEJsWuIB8XRh0IPTHULyO0oKm1r3J7/NfoCLUUsu4jwGRW48XnM3uaxP5qZPsvM4wZbHCoEUBqW/JrTwreq8VKe+riqwPRWHX3L7aQs2DmYT2n+GjH7MBFQkOSB/GwTI6hb9NzTEWgV7Ff9GQZm0gOECe0Ea3e5vsGcktcYZgJwH979S3Ug/t+8+d/7pLqkHpZF4EU1AxPyVJqb0wroydBD9oaVMZavpm4EDvnrgN7lGc4gw3ZcUq/G59SLKceVU6XmglRPRmMsc8dBNfLkYgHwKI6VeqDI3o7vJdgo3CgzBtkDBHZd5PzCUhgoFc3XPcb9wyNhQ1o3Q7GHjhl+2X83EatSGB+iVhLc46zA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66946007)(186003)(316002)(4326008)(5660300002)(66556008)(38100700002)(26005)(66476007)(86362001)(38350700002)(8936002)(558084003)(6916009)(508600001)(6512007)(2906002)(36916002)(52116002)(6506007)(8676002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+ykMETr/q4c8NHzQax2uOma/IErmcfupbYeneTFJbceLFhRkeD5dzkjhREcK?=
 =?us-ascii?Q?n99fg5EON7j4RWrvfZ4t9Rjjpg+m0M+6gl8YmPzSJNiBevQ9Egr8NUscf01l?=
 =?us-ascii?Q?sypVrRifoNnP6HTdwFJs1SUTPn0onUPznTowGqXrqBzvnbhMl/iTf01kDLZc?=
 =?us-ascii?Q?qzrAHlFoBVVZZfFp6Zt7G6tQWMpmjIcZoV5RrJ91WzAZ3iMWGGx6o3+nUNcy?=
 =?us-ascii?Q?HxN4Za7ieGvoucXr+Glgf1Fpm3JDO7ZTBlDC8ix1IvVyyZp01t7nGpkiHNNN?=
 =?us-ascii?Q?RPyQZ12z/cQzhcMja0vK6+KDrqJdSNjii/2IqLx920P3JqbIoRXVbf64Tmmj?=
 =?us-ascii?Q?7ZPKxDPEfyBNUGooPb0eI8qdHqE71jzQpWIE+1g2M7DCEqzKfZnb7djfNZJW?=
 =?us-ascii?Q?Oo5ukPWaNfo9yftAL50xdkz97+Bi7q8KZdhm6brvtP+1wzWyDOU+AcimryUo?=
 =?us-ascii?Q?d4jeqmqm2zKrynTP8ISINoKgZpURczkvQgomtG7aPVvKIpR7xaHU6FtfXLfk?=
 =?us-ascii?Q?kWwVgBrRs+ZxD+Vn8gLtvA0nAYXrcBYBXl8R9k93FMAc6pvHqU6fVUsqYRTx?=
 =?us-ascii?Q?8a9WaqnYmIiQNhznrB+cZqTNdFqR1+ABDRCJMHQ6fPwKCi2OdvwfZM7N96Wf?=
 =?us-ascii?Q?FNInBbRhNc0KY7ga4QEhD/e9FxeWU6X531kRxNr4nr/Wq/gx3ArzwmCCv9fN?=
 =?us-ascii?Q?1BOdIk4EdYz/lJCrDwFPQ5X2MfUtHi1AwfntGGgn1S1qSg4xXHgWTGLkMbVV?=
 =?us-ascii?Q?SUZ8NTzzlHzym0r4/tRivka8hXQGWvGSYHzeqkeBF1loIKqLX7/KkbnH9RHM?=
 =?us-ascii?Q?Rxu71XywXs9H5LL0Jrt/OVOyMzFcF+Vt31iEoJtOqk+ivVmFP2ZawEd+bJPo?=
 =?us-ascii?Q?Mvff9LrfpAsKdvAjvd1mlMmoiVeMHbCFzULACB0K6uByuu1uJ9I6++yrjZ9a?=
 =?us-ascii?Q?QiA5yZquSn9Cvj41sFarcBzsEjFu1Ln6dgQRBtkYlR9PdgpDZ1tjiyJoDFua?=
 =?us-ascii?Q?5JbOFdvzmiCgLBzKo9GTWiG9z4/diLTCRwQ4SU8jvXuAtYjxpQy/SRbnN1Ds?=
 =?us-ascii?Q?UlxtSdmB9wRjIkhpz26Nth8ELSsOP0uDjUJAiiN3KhvRMrzyGpp3oVIyD3CU?=
 =?us-ascii?Q?qCAnxb4NcN4lVipCN0HOtLZv1sukhqTOo3S5dUch8gEC063WRZiT2mB7VOZ+?=
 =?us-ascii?Q?jax1U/J6n1j08byV0HxTsXE04GwO9qXlr6IXgTUGAmlRpCWHZLiM8hiHdiHm?=
 =?us-ascii?Q?AzhXXscd+gGfXe4z7OkIug6XECtX2628RC66lBaryMXJzuRCQuQzmpsZpZ4b?=
 =?us-ascii?Q?wpkAuFTeBg5XJUASzhQicVaNmjSGEcC7sys+QAxJkNgPEqMSkQ+KRaFryRFe?=
 =?us-ascii?Q?JvHzTeANe1VP37i1LdhN5jbkDKsEhIlbi5XdxDDTm1d8LK9z9aZfX16/mKHW?=
 =?us-ascii?Q?EWNOzAqwFbcMavmfHhS5logNGwPmrQNZW1RgsGgy9AJ2xn0NaXaJiKL7ODLk?=
 =?us-ascii?Q?rQQ+wWL3X3F6qksQ0uAejSaeqknXDwPwcR1sdzUTKH62W1B4TMisTKt2UrV+?=
 =?us-ascii?Q?e+DXJ1RNTxybY2KLclDLeeH9RfEtH7w2Ny1kerLJrhgFgohWNMz212w99cFX?=
 =?us-ascii?Q?Qe0msLVmKemzUvonjWqIvA2CTYENi89o8N+72tUK8h46j7zwKcqna+Q2yZ+8?=
 =?us-ascii?Q?hGpBYg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2aca2889-f8f4-4753-8d5f-08d9dafa9b9e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2022 03:20:13.9361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aXnfAsEO1fI8+qp/ptVf93NjyLfnF5SPCBb41c/0xp6srZJM4vXjUXb9ps5m2+iKqiesxqMndV7eOjjfB/Gq5spM2h6cg/JIaJ5XCBJNFlU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4277
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10231 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201190014
X-Proofpoint-GUID: 8oDndiNckcT4cUyVKfK7xbAAN9fBB_5d
X-Proofpoint-ORIG-GUID: 8oDndiNckcT4cUyVKfK7xbAAN9fBB_5d
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sven,

> So, it seams, that there is a problem with the samsung t5 and t3,

What, specifically, is the problem?

-- 
Martin K. Petersen	Oracle Linux Engineering
