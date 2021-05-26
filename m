Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94B69C2B9F7
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 04:07:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61CE961437
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 04:07:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbhEZEJQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 May 2021 00:09:16 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40156 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbhEZEJP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 May 2021 00:09:15 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14Q409Du142193;
        Wed, 26 May 2021 04:07:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=wrkpwB+aeiNGdHXinJ5CAoTPfHtT2q2Qc7HKFMIOCrM=;
 b=HRZ1u9yb8z6DHy2cDTGIIo3dD6xoKCij4aB10QTjAEiO62BgnPBNvC2WdYs18f+ZHQen
 UivCoqDoT+IXMeXW8bd+TZRppOy3orCfZ1BPbw6DHiiLijaH9BFD57kE9SZHXnhcDlTk
 qOMjfcrBk5mP9e3q3eJQB014u0GUZ4UG22EcUFoux4eVcVgY8mHufZm+aaXLTs/yx59c
 NrqhANI6yD1jgnPgqUwx93SpWR4+U7QEIE2H75DPRD9RgwLlnx8+vS5gX988jyhOGwP/
 t0XVqbFOHFqygehLsz48UHpCIzQAYdP35JYF8TWEe5SyPtiRwvlZ7LYqvLZUBj203+Ym iw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 38ptkp7pyk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 04:07:39 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14Q46Eqm028010;
        Wed, 26 May 2021 04:07:39 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by userp3020.oracle.com with ESMTP id 38qbqsvd80-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 04:07:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=czx0XJ2BsyvsmDmzEogb+xVRUD5qaFys52lqt9xRqPNqL1RgEXXQ2WLQSLnHYaKL/cw2zGIelEOfG80ki3Ut5d+39cS1zDpPnTCUdIw+51hW3q+5o/1xdwYwzAAebe8SSSh1EyPcxLz/1G2O7deSywvVBAA/6DP/V77VmK5ng3IhTQUzrzN6Vmb+qR5nUMv7bYAl3L26lm/kJfCE9psdOlHwuwq3bHk8kz2TPTCLl+DcnAyE3zy2cT2p/vitNKgfV/rlwprhnbHN9/Lr1r9PEj5zPJGPqH8m8x3EToy6fW7g46XUx1WZ7cq3XUgWZMl8dg7qAenYkN8v4nILgMiA2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wrkpwB+aeiNGdHXinJ5CAoTPfHtT2q2Qc7HKFMIOCrM=;
 b=eGb2YD/sixoHyJlp33OFzQ9yNrIBe2wwgBV0mZKmoY13ls+A7JXuOcXaude27mfIUdyxgi/+a0XFWDiU+jFB4N3VlrpHBMJW/iDEAAiguSY8I74B1AVg2AbpWN2Xwa7DnLIMRzZawxktfZ270J1fyvs5QcTDyQ3QpzQooKoCcLU5jETSgagWi6NsOfMg1vaJ7pO7oQhmMkznl2VJYXjNx98Ud0kN4VYM+wT6U/FOlGuj7gZyQ/k5XSb1cijH/Ze8hQbNfFHl5ZhImQ777NE7/dqAXbn8Z6mNn9fiGvvSlBqgdZsxYVQIgbNfQ2zT5R30dzlJCbm9tFURFxvqAp+dOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wrkpwB+aeiNGdHXinJ5CAoTPfHtT2q2Qc7HKFMIOCrM=;
 b=yFngh12/fe3tVKImVgvRqVORDOiE5DPUlyHMw7+4JVvQ2h5zaWsXXiHPF8aMYa7MZuIV7fKsjgJMrPLjPFnslLKHDWutCuqySBwRRMs4gPjYA6cMZomFbvlUyL9rPhMnX7yEi2TD0JLj+gHN1GjdNJhG8CKLkLjXM+/4woGF24g=
Authentication-Results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4549.namprd10.prod.outlook.com (2603:10b6:510:37::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Wed, 26 May
 2021 04:07:37 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.027; Wed, 26 May 2021
 04:07:37 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/2] Two additional UFS patches
Date:   Wed, 26 May 2021 00:07:15 -0400
Message-Id: <162200196244.11962.14466842167663973658.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519202058.12634-1-bvanassche@acm.org>
References: <20210519202058.12634-1-bvanassche@acm.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN6PR2101CA0004.namprd21.prod.outlook.com
 (2603:10b6:805:106::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN6PR2101CA0004.namprd21.prod.outlook.com (2603:10b6:805:106::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Wed, 26 May 2021 04:07:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d63d44d-2ab5-466c-eac7-08d91ffbcbfb
X-MS-TrafficTypeDiagnostic: PH0PR10MB4549:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45499E05B19CF036C68029D68E249@PH0PR10MB4549.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I+GTwz4223SgFtM5rrWoob0R7MiLWjqUew3Q+LVcjJggFQCf3Dam9rvIp1UhhqORMmGPSW0Z9DRJ5k6Vi/KIJYxITUZKoiXZDy56lfDUvPjGbIdh8PW0o5lI13Ayu0ij10YJKBslIyuFJkoMsWhpNGmklIGYGLPMB54X0G16K6rH89zaqIB2Tk4YRaZSaL0RMVFhtBRdrO3ccxx1j0rNAeYffh2gAxIBgsr0c0MjNQyNoZFvGsZT+OsgPDvLPjjuvWMNS4lpKaHpfWEqvzraDlaMgKnP9rVFyKTDf1JTvJiL4IHZcBrjYITCq/jqoNI95bus7qNFse6QkdMyNMfOkXM9N4it379HekorseM/+UVIBgPNxrK3vqXr5Ixudng6hUuftaElBdohCHCbLpK4boOos+e8QiKaZS8QwZ82aroMnr8F3S5IzysfEOFwvJVqR6fZkJxf24wbLpaSlvo7QBxz7CUiDdEWsdsxx7IvskfnjzkynwaGKIszbFfgVrqeWjjfsw3R+ESFc65F1IsrCQkgt8a5abn6+4D5+/wOhRDU9g4dBTSJU/Pe+K6FAgRsgmzlaCv54v7jpDMr7+YFzLR0UCehB58Je2ft3evfZ1qlRuVLqxZkxlK0NLaXaRjomyN6gcUd2Y4YfTTn8u31PuHEZiRcRCFJhCskhmDV9pURra4Tv5fIJMQDG6FmcDezKm0tM6bSsLA2OsGGJIkxgGc3C3p/eq1qWrn4WjE85wqbHDykbZyM39SpogTWv0cUlvwmIr9zSf8qmsvxInIGJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(39860400002)(376002)(136003)(478600001)(66556008)(38350700002)(2616005)(38100700002)(86362001)(103116003)(4744005)(52116002)(66476007)(83380400001)(66946007)(54906003)(4326008)(956004)(5660300002)(6666004)(26005)(36756003)(966005)(316002)(7696005)(186003)(2906002)(6916009)(6486002)(16526019)(8936002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OGJnNjlHUWxZM05ORUxqc21kOW9TMERuRGU3Z3N1bTlBNDNFdEhqVmo4Vm0z?=
 =?utf-8?B?amxJTXBRb011UVhYSVBFVC94bVhOc2FSeU5DYytvRnVsV3VCL3Bjb1V1QTFp?=
 =?utf-8?B?YmVGSHhqVzZFREhlQWNEU05lTXRLekdEOWk1VUxJeTNQclBTR3QrYjJFRzVO?=
 =?utf-8?B?bldzTW85UWtCd20zMFp0eFdvNlNNd0dlS0puWjJwZnc5WERneURzMkxXQkR6?=
 =?utf-8?B?NjhtME5VbUJxamEwK05TdFBPSEpMSmNsb1FmUjFodjRzamZBbkFRVml6Y1d0?=
 =?utf-8?B?NmZ4a01rTkdhczRrSGZURTB0elppS0Rid0ZaUGpXTm1lR2RmT3Vuc0ZxNmN3?=
 =?utf-8?B?VEEvYTlvWWZIT1dRa21DWFNaaDVWQlR0bTFtR0RSSk5VaUc3WVJoU3VwZkNM?=
 =?utf-8?B?MkdZMFo4K3ZwU2xJeE5oSllCQ043SDFhcUgzelYxM0dlTzJ3dGRGUXJLTFRI?=
 =?utf-8?B?K3I5RlFGZFIweGt2QTlKUEFEVXJKVzdrS25WdnlSdUViaFJIZG55a1ZwR05z?=
 =?utf-8?B?K1JFQmhkU01ZYUZ5WFVTczFWTktsbEFQYzdrUzZnR3FCY0lwcFY0ZEsrUUdO?=
 =?utf-8?B?UnY5a3h3VmJoK1VGaWxIQUQveE5GRmJZS1RDS0xKZEcwbHNFMVkyZ0RKREZr?=
 =?utf-8?B?OWZWQlVTczVrVUgrZlByMzloeVpTdCtZeDJMQzhFa3NFVHpEaDZZNUVBWS94?=
 =?utf-8?B?QkhHK3lva2JsWS82bW1aUjBhNUlwSEFPVE9naEovNjZYbGEvQS9SSUlJOUxK?=
 =?utf-8?B?Sm9rb3ppYlpxV3FMbnZ3WUZiNkpTWHNWVUQ0M09OT1VOaEkvbjBJNXJ5YU1S?=
 =?utf-8?B?bFN2Y2ZSdm02ZTdYajUyVDRlcFZBWGpmeXV5eG4ycGg1eEJYQzlzbStnWlRO?=
 =?utf-8?B?citMZWpySEtiQitWVi9JdWxwOEc2Rm1MTXZPb01oQXZlUnRralhVQUFRcUVQ?=
 =?utf-8?B?UGxndmVNVHROeklXeFl4c1BuY3dOeTN5a25KSlQ0RG5FTFdCdUdYNGFEUlRK?=
 =?utf-8?B?V05TbU1kcFg1V0pCVWtLUkovYmtUSGl0Tmk3MjNnaHBSSFBBRjFkV0MwVGF3?=
 =?utf-8?B?b214ZnRaemtDR2RiRjBTM0ROZjIwS0NVRkxRU082K0EyQ3F6c0pYT3NCUFFC?=
 =?utf-8?B?L2hKMjExUzFLd0FqM1E2Rm5VeU93NjdiaHlyQmh3UzY3c0o2VUtxY3FUMkh1?=
 =?utf-8?B?THZWcU8xZk9FZVcrUWhOZGFQQWhHOEwxRExqUjRSdnVIVXBieEhJbmh3UVNZ?=
 =?utf-8?B?VU9pU2luM3JjQVZaSE9BaTlMZ1FBSjFnaTFReGNsNVJtNzJiRlRWRFJZd1ZR?=
 =?utf-8?B?UTZ4ZzhWK25leVNoNk01bjJFRndmcXBnQkdFaXdkVnFDRWQ3TG03cCtXSkl0?=
 =?utf-8?B?b2ljSS9Qb0toeVUvK3krL0IraHFWT25vcFZKckRQYmR4T1JLdXBJQ2s1NU00?=
 =?utf-8?B?TURnbHFIYkxZa0UxeXdlcTN6MDN2YURUa09QKzhxeW13TXJBK2c4OXRVWWNB?=
 =?utf-8?B?SGhlalp5UXc0WUxLajNjZEs1ZkJlVzhsMGJQbkh1REh4UENYU2xCNUU5RXJw?=
 =?utf-8?B?UHhMZS95ay96MHNRZHR6STVOZlFkSUNQWllDR29nL1J3MEh4TnR1UlNZWUdU?=
 =?utf-8?B?UjYyWXhSa29YV05Fb2FUN0twaEdnTDhkci9HY1dFYjZOaGE0aTRWRHhTNjRn?=
 =?utf-8?B?RUlMUnNPUWorZWVEN2lLMjJKUHJzTGw3aE9WaW1zMCtFalJrOE1YQnlQdm5S?=
 =?utf-8?Q?qRTVSIRJQl9hDqvVdhmRb6kkEH30qG3XIUNygED?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d63d44d-2ab5-466c-eac7-08d91ffbcbfb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 04:07:37.2209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +wzDvDA6wzjPySh0WvJwvUtHQaaWynw3/3zsOwfyYWqNDpPNKmgoWSdI27b6dwjY9HqxolyXARZXshDdNeD4Gcrf35JwrqsbvyC64ndTieI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4549
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105260026
X-Proofpoint-GUID: YhWIVKC2FSxpgDbcmGpmOQlVybO-as3_
X-Proofpoint-ORIG-GUID: YhWIVKC2FSxpgDbcmGpmOQlVybO-as3_
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105260025
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 19 May 2021 13:20:56 -0700, Bart Van Assche wrote:

> There are two UFS patches in this series. One bug fix and one cleanup patch.
> Please consider the bug fix for kernel v5.13 and the cleanup patch for kernel
> v5.14.
> 
> Thanks,
> 
> Bart.
> 
> [...]

Applied to 5.14/scsi-queue, thanks!

[1/2] ufs: Suppress false positive unhandled interrupt messages
      (no commit info)
[2/2] ufs: Use designated initializers in ufs_pm_lvl_states[]
      https://git.kernel.org/mkp/scsi/c/e2ac7ab281c0

-- 
Martin K. Petersen	Oracle Linux Engineering
