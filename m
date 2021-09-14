Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24329C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 04:41:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 069FC6112E
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 04:41:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239356AbhINEmZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 00:42:25 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:41460 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239328AbhINEmZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Sep 2021 00:42:25 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18E37ARg020204;
        Tue, 14 Sep 2021 04:40:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Ak2eDe40sPIEEPrnXEl7Tl7CmliEMFmP95+Wt/ygxpk=;
 b=mbVjgng9/t52Pp+ohY7JV+5B6NwS9kuzffubzNMTZz0sJNrCczEO4nys304nUsqZmqdL
 6o2QhiFajocHUb5NONPKRtxvMJ8ZslpFvyIJ6WJQkeOAdXcxObHggj5k3mHOe1m/hfJO
 6PsXJrjLTuJh8WCA5cRKcbZGmmLeKI37MmpdkOS6W4TXpIyXzIDoVA59zJfnnVcGEPcH
 USCPZTcWa4idqtSx+QmAqIxZUohmnQjNWJybcEF/W05Fg+UynYyKKOvmQhoknbChqtba
 6EuG+UTvNCYDZnmna5NmBdj0QZLXAbC4Uc9475LKg9lQwrTjJMuoxgr/DzMe9kJavFt1 nA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Ak2eDe40sPIEEPrnXEl7Tl7CmliEMFmP95+Wt/ygxpk=;
 b=YqXSmLckrgmjy8T4aFnUbbLVTXu1C+VCDcM9bchGGZ2jOHn5YckfFvC/tIThdB1aI5dk
 QhK+MIPXKkE3o8SJ6mK7FF5rfvVDAEyNDiHQpE9ezyWKJwHlSKPbvehBv1jjqO6i3CsB
 DjW1/vEEixMxtHEyRgBZmwFA5KhFtBH+SPcrwt248hGoN8BMSlK42eqYrjndlnJhE0YC
 7oam9xGmlpO4L+O9hieybX69H4sTRkYXsgoJMWRDmmKtDJ007sXF/i2q8gBof2c3/c9x
 /vybx8Gd0L2W7QTjWg24goTdkT5gpEn1XqXzLmpU8FZpSYeMWb+ClptUIpCGIYRUl+s1 9Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b2kj5r62t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 04:40:57 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18E4ZRvM061807;
        Tue, 14 Sep 2021 04:40:55 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by userp3020.oracle.com with ESMTP id 3b167remju-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 04:40:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B0XTAFXtt8EIaeYBdyqDzWpUs+4b1/XrGD8NPi3S0evDxf31AwqdvZVP6MvgWgQPTQ6CmUbhSqE+RPqUDTh0fAztYNhT+X+N2HcKxdPvLWdLZq6mdnmkQ7U5b2RSbervuMwnrZ3x3I/O4DRtbeX3YsyzJaXxUEWK6dm/+qMIy4QUVApV00qfYMgSUduXjzRPzOhslfJFtf7lzgyOKKc2zzrVU4RH3s/RGo4C80nVEZ0UbetV7YSUGDGC2Yu9pQUqnUUz+3IhdsBBTbgXaXcXGyGktzQRl7c3IKDyDHSENYHNdDUJSHmsVqd5v9fEZUZK9y78IJFz8Y1rpnfXRXvaQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Ak2eDe40sPIEEPrnXEl7Tl7CmliEMFmP95+Wt/ygxpk=;
 b=dkoHyKfRA4UYW2OaygqL/esQncYZvyFHSSpv2iuyD6Jr7Mcl4MyKTecWFOnW06fQVoxcpigNuREuUncy8EULwYqlP4CB3FOD4etY4tUu4gcZHpZMMLYz0Ye5fDiOYxVBiwVTztbULZ0VBJSZWpOxBHr20N4Dqthe9RuPQ5Q//CzBvCVqzLFY79wntauSAm7VKntEYKEgr7ja6de01lJpPstBV28H5wTYoW5BpQ4IEdrwhgkjWHVzDMQtTmGkSp3mjn5asbtpFrDvd3EUE2Y5ZZDAkf8d/U+BBQUCL6LHRajCAE4Zzqa4YF5tqRl/D+UZMMvGwDm171gc30riybaJBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ak2eDe40sPIEEPrnXEl7Tl7CmliEMFmP95+Wt/ygxpk=;
 b=XzEMx/ZKb0E149pyaKEOxrjpBKTUD5di6ZGOMrjv4JR5yEGsVZGzSm/Vnz2d3oVJYt3ITHN9qP2Hy/iMLfL8n3VYFGJDfDupI3dutTePkDJSYanfI9hdJsRDb6hplogZDVjWv+5Or2rjovG2Kjj/N21wX9owrGO91pQS0iiWarc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4502.namprd10.prod.outlook.com (2603:10b6:510:31::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Tue, 14 Sep
 2021 04:40:54 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 04:40:54 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Zenghui Yu <yuzenghui@huawei.com>, linux-kernel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        johan@kernel.org, fujita.tomonori@lab.ntt.co.jp, hch@lst.de,
        gregkh@linuxfoundation.org, wanghaibin.wang@huawei.com,
        axboe@kernel.dk
Subject: Re: [PATCH v2] scsi: bsg: Fix device unregistration
Date:   Tue, 14 Sep 2021 00:40:49 -0400
Message-Id: <163159443486.11082.13793603628764579473.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210911105306.1511-1-yuzenghui@huawei.com>
References: <20210911105306.1511-1-yuzenghui@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0104.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::19) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR13CA0104.namprd13.prod.outlook.com (2603:10b6:a03:2c5::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.9 via Frontend Transport; Tue, 14 Sep 2021 04:40:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1fd9c421-ed45-4d7e-c270-08d97739d643
X-MS-TrafficTypeDiagnostic: PH0PR10MB4502:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB450203928471EC5E9BF3944A8EDA9@PH0PR10MB4502.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /FFZeZnERhHaIE3ff37bi+hWfkmufPTst88YKrBMcwiD9mWf5/jvlK8whdT+DX3RQit7wu7R8ZgfewGkGgAEEX3BqingiAuYINevmtKG6tqkrCczsa2iQPCBJCn2n6RQIBZlYluyTKp/mhuX2IehOlQTqqlewAAJ1Dzi8zA1pCmhiutl552mP/JXx+LqVzGVrLT/v4VozwGm0jcDiNs9h697/OpdGw2iKkDosDrDvg+tU/LI/Pvb/lCedrUw/XCxpFN5/vFQWXY/F74bzH8Gs95kif+eYYFFcJ0rvmfgTfLOPChHs89iWL0P4ng+GXMBngVjyhco0M0H7Yu7tSm1rrpvTjoqXIkSqEBQxjccn/2CYShcuzTh+xLnKD5ZCBDi0PSzcA2pb7XyMHaYHOGDO6oRjdQWFveBFOZ3YLuh/VkB1Ymf8bVWDbIpOFF4YwN0mjAv24shUFELXBb0UgT1NG+NlvT2vYeAxCr7WChPOwOFcxoIBE9M4V8qQ2QtKHSopQuoX+ZzOAojOxHmm4lVuRe6uNp7eeCga9zcaAZARDxNVzH+uXPfiZsUM1HmZnxxe+iLR035bQiGxy3Lt7233/K/0Mz3UwpzCxMIW7FmbKx2rIJPcE8kaAWu9PpVRwGiJXC1Pt8xBRBosl6KXXN1fjAlgvRgozZ+/xrVS2ACCwbRJk58FU4sSxa4dJbmJXCdJnp3VBm/wkYw2sAqq6eZyLCstpYGMVhqp93MtspSHcl3bumA6TgO3uuP0x30l7hWasxpvYvOc9qPEod6a+hUZg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(396003)(39860400002)(366004)(376002)(4326008)(186003)(26005)(4744005)(2616005)(966005)(7696005)(52116002)(5660300002)(103116003)(36756003)(6486002)(2906002)(316002)(38100700002)(86362001)(66556008)(66476007)(478600001)(6666004)(38350700002)(66946007)(956004)(8676002)(8936002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bzlwQm5ZUmpkUjV0YTBoMnpJUnRVRWRUNEFlNCtCczZMMUFOZlhsSnFkTzZG?=
 =?utf-8?B?SEZLUDBsWFlxSTg1QTkwc1l6RkxrMVJ2b2pVN0gyZCtpYmlKRjFSTlNDbTFw?=
 =?utf-8?B?b2V5Y2dady9BRldMTHFIVC80bXJXMkRNQWU2NGF3U2VKSW9uWHRJOGVvUSt4?=
 =?utf-8?B?UHlibVJLME9uN2xUN2dMc1ZwYk8vdjY5ZjBhT1E2QklQS0xxZVlxNVk3VFBC?=
 =?utf-8?B?Zy9aZUxIc2tXOHdmMnROWFpEM2M1UEdGR21JRGlKN3JvazZIdWNobHlobWRR?=
 =?utf-8?B?cXdOb0JxTFMxQld6TVlHdnZ2ZTNXUTVJTjV3RG5DT3gvNTZQMTF5UWZWbXZ0?=
 =?utf-8?B?THVPYzRMZm93ZUtpak0xaDUrOUVFWkZWTFdzbHZEaWJhY2JKWGRNYlBQTmVQ?=
 =?utf-8?B?N0NRUk1UNWpIZTk4U3JoYWd2VWxGMitkdld6SDZWcHZYUE9MSnNUQnpyWGQ3?=
 =?utf-8?B?aFd0UEo2RUg1VDdFMU4yb2dpNUU2Yms4Y2NWUnFtQ0lqMWRvd1dzT1AvY3hD?=
 =?utf-8?B?NTJZZ3V1c1A1R1BxUjB0V2U3Zk91NlBYaEUyUDlOSmdpb1d2Q1FUSFMrd2tC?=
 =?utf-8?B?TmlMZzNSbUhydjgwbmNGK3MraVdlTTR6NnppTllBL2ZxWnV1b21rVnBmcTdD?=
 =?utf-8?B?eDBkU2s5VUpsMWpIVzJiRXp2d2xhSUtZT0dTQVBUUjkvRy94a05sTWVPd2J3?=
 =?utf-8?B?aXcyekxNMUM0b0tkLzdVdzM5NUp0Tm5TQmp2aW1SaWdoQVA2Z25QL2ltSHpO?=
 =?utf-8?B?NytzUzZCYmQwYk96cWQyY2RNK3YyUnJ3ZTlwVHZqZDdzNmd5bzZlNU5semd6?=
 =?utf-8?B?U05Sa0xZazNVaitSc2V5dVlwWmFLVGtKdGtQeklxTndsMlhkWVgvWnV5WWlx?=
 =?utf-8?B?QTF0YzIzRzRBQ0hFYVhxMHdiV3AxWkRCdmw4VzVtWElCSXlkRVFZTHJNZDNF?=
 =?utf-8?B?ZkxDWVlCL0xRTDBMb0lpRk9wSDk4NEhObFJpUnNqWkJIemx1MlhtVm9lRERL?=
 =?utf-8?B?RFJ5YnprZnplRE82Nis4OVdNbjE4ZWtTZTJja0VhMFk3Q0plczhGUlo5dldx?=
 =?utf-8?B?MG9WS1I3Ylc0MW5IaCs2d01GdFZ6VnJMcjFDOXJ6K24xMnk0T1luYXlubXBY?=
 =?utf-8?B?KzMvMzcwZUx1eUNUODExYnAyS3lodk5ndFVKSzVqRjlDZktXQUU4djVSRjdW?=
 =?utf-8?B?ZFB0eUNpRy9yTzhieVZOL3ZVRExWU2Y2RGU0SVAzZmhZK08zcDl0VjNldVJx?=
 =?utf-8?B?UXVoZDhpc3R0cmlaQytZb2lHNGEwWUlUTGtad0VYZDd3MmkrWjVmUVI5cW44?=
 =?utf-8?B?ZExzVkd0dXEyTllzZktPc0FkU2p5emNJU0RIUlJFbjJTZnNqNFR4OVl1SzZB?=
 =?utf-8?B?bXRManQ5aHVCbEx4T3dFTVNEUnpOcWNkQUwxTnEvM1lER29TY2RuaDBiR2J4?=
 =?utf-8?B?cEJVeVZ6ZEVnalc4cGdKdWNCTnhwanViRWFJQk9SeFBKTjhpZ3FKZkNRMzVt?=
 =?utf-8?B?VUxNcFZVSmtzU1dFNDR1ZW5UeEp5Z3VjendTbCs1UmErKzQ2eW4zdkxLdk8y?=
 =?utf-8?B?Vk5BRERhNHkrS25YbFJ1d0V3azcxSlQwYW55bGIra2Rwd2pURFBycG5aeE5I?=
 =?utf-8?B?enZ0ZHhyNmh0eXE5WjhiN0lmNTdXdFJNMDFYOGk1bEMwcWhMRlE3NStrUEY5?=
 =?utf-8?B?ME1OU01xUEgxdFpQbnNnUzAvRkptTWxFZEh0OEdFeVZMcXMwRndxWVZWblpr?=
 =?utf-8?Q?DI8urbc1g131mrh9TWTIacpP5C/8MbIcCzNmo9w?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fd9c421-ed45-4d7e-c270-08d97739d643
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2021 04:40:54.3292
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 61QEDV/XFiSWFY7YJPZB6clmq8OhdXupGbqKIhouzKfb4idrJJKbPvbGNv4RmbHfgolnMQJjrgaCsr1qP9nVgAo1BH61Ll0s7tkJn/goE4w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4502
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10106 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 phishscore=0 mlxlogscore=927 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109140026
X-Proofpoint-ORIG-GUID: -3lxiwhJRkWrhApT7lBE0eGa9-gQjJ91
X-Proofpoint-GUID: -3lxiwhJRkWrhApT7lBE0eGa9-gQjJ91
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 11 Sep 2021 18:53:06 +0800, Zenghui Yu wrote:

> We use device_initialize() to take refcount for the device but forget to
> put_device() on device teardown, which ends up leaking private data of the
> driver core, dev_name(), etc. This is reported by kmemleak at boot time if
> we compile kernel with DEBUG_TEST_DRIVER_REMOVE.
> 
> Note that adding the missing put_device() is _not_ sufficient to fix device
> unregistration. As we don't provide the .release() method for device, which
> turned out to be typically wrong and will be complained loudly by the
> driver core.
> 
> [...]

Applied to 5.15/scsi-fixes, thanks!

[1/1] scsi: bsg: Fix device unregistration
      https://git.kernel.org/mkp/scsi/c/1a0db7744e45

-- 
Martin K. Petersen	Oracle Linux Engineering
