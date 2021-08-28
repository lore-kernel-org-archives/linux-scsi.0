Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1A08C4320A
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Aug 2021 02:32:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C0096023E
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Aug 2021 02:32:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233053AbhH1CdO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Aug 2021 22:33:14 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:32290 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232555AbhH1CdO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Aug 2021 22:33:14 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17S1icMf021275;
        Sat, 28 Aug 2021 02:32:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=DbgQ/pZ/hvGvfBglCBpBfwYeCp8spXNNGrS3o1qU93k=;
 b=Jun0vuYOQ8rXdF8Fz0EHudVY3hzNqvznFar63uuiYvPbSiKzj7SLs6vMYLCbPRLNvRin
 e9O8dv7Or/Xww+EoOJmaWIgvLzWdQxKH9cKu5GAAv/DLbP2KLyo5YgPjqnmI+GSwbG3W
 1yvEpdvjR9SzEUoaHJJtYuORLJ4w2Rkr33Qjc+RD97ZdzlD1xAzf/FvqKtwgsBI0AUKo
 einCj5EmA3AxbfL5qT2DU444Cprkx0sUV3Qat5++2L7IsK6ZLQA1HYSVL5e41VPO+kXk
 xTLGt3CWAE5+qiKB6gcrayvZmnpbxiiR8h81UgtmpEdZFON4dijc4ZFEwE1qWTgiP+bJ Fg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=DbgQ/pZ/hvGvfBglCBpBfwYeCp8spXNNGrS3o1qU93k=;
 b=rUa7XRAe8XULo8mlsLvSXSzWLXyPQUchfgjdCc0fUYDuDyIGphCJLBF+paYfB2lHqC/e
 0MzOHhLz2X0YZ2piWP5Spondrl7Hp4e6CCF90RXlLYK7uHEjftEd+4yg3AozzCnLD5li
 GLlSznBJxr2fOTVQaChbSlDhhSFV+cUwyQLoFHp2GcHsXsyVjiHl54ltwn306AqO1OMY
 3IRi/aJSnXkUbRBInmjOTupvubOH+HhdaQeG3Bx8dbPslGbg4QDpG02k+v4EIw+5cqVL
 JrZJBr+mFXvVxeD1chUdL0A15pT1ODrvO5T8/s6IFYTmX6NXZ77sPNyHKcWLYIM1czD9 zQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aqbr200y7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Aug 2021 02:32:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17S2FWlw139434;
        Sat, 28 Aug 2021 02:32:18 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by aserp3030.oracle.com with ESMTP id 3aqb68tanq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Aug 2021 02:32:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g2u+DO+ejPDlm7bdela8+wvMCm5JfutNX8px2QT0wHFF/355Bub9Sq35FI2doKHsOfSYV6U0Ng4uKEWBaP8+J3ouWPNDLW06VefRg+RrsrscDIzIO7pHousbK8PvgcVnCN4MliBCj271ZVmhvRg4/zypsO3Jl0Rmrb1yCCGeQgKc4xpM9bo2pV1z4qV6IGgNeIZIuZpv9QUPpTWhcUKKFGUjJZCVMjayvhksIBZqtNgU6F8JLCmIKGMqrQEzO0BzsGij/H5b6LbxVp4ufZAQ94N/SW4r8Iiy8xmcwqQfb1xVaAkszMlqBsG+JuOG/OhfbgPQtrmOFuFHDpNH0v8X3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DbgQ/pZ/hvGvfBglCBpBfwYeCp8spXNNGrS3o1qU93k=;
 b=lIthGruzvUppjJdxlgiL5wOC5//l5Mp2yRr9efAgUl99H0TbeA57H0nEmk6Kl8qUUXuyYaxzcsscLXuVjq2vMMXyQRBeffnzxZOCrXX9rhZ/V3fWN19A7PKlcNvvQDkunu9rK9jRLg79cyoTEMv4cAkjJTvJUGFSCJ0jp8yIIT9Eaj4PJehEKhF8lY9FcsnCY2LKWpm8mq0aAvw+eZdpi4vpVQBoiN8XFe/FGPrY84tg70bek43QkHa7sBhnW4cQZk40k9i7KBn34PN4UmPHN3KlljaPRiqB/5m0zXPF+mlA0rTQPcM2bYuD9ZQDay816/Z45ZkDbnz/wbhsPLRuXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DbgQ/pZ/hvGvfBglCBpBfwYeCp8spXNNGrS3o1qU93k=;
 b=r6VxkzdlUCFwWRC2v7vkLZBIi/CCs+rEG94g3eSOE9vGfrw6cKSRWG5D05zePAtfd60d2bGgRuhGvq6eY7DTYbIXLIZeM3uaJ1wr3zQhvGSIAw/8sOvCysdP+uT9BJndM6jFXtqMMSSOpMiFgR1eirCPzI3NtdMFb3W+gyycbBI=
Authentication-Results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5515.namprd10.prod.outlook.com (2603:10b6:510:109::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Sat, 28 Aug
 2021 02:32:16 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4436.027; Sat, 28 Aug 2021
 02:32:16 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        dan.carpenter@oracle.com, krzysztof.kozlowski@canonical.com,
        kwmad.kim@samsung.com, avri.altman@wdc.com,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: ufs-exynos: Fix static checker warning
Date:   Fri, 27 Aug 2021 22:31:59 -0400
Message-Id: <163011776501.12104.777339809255400171.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210819171131.55912-1-alim.akhtar@samsung.com>
References: <CGME20210819170304epcas5p211ae01fc6ba6f5beaf7afaa90dcd5dda@epcas5p2.samsung.com> <20210819171131.55912-1-alim.akhtar@samsung.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR17CA0025.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::38) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by BY5PR17CA0025.namprd17.prod.outlook.com (2603:10b6:a03:1b8::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Sat, 28 Aug 2021 02:32:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6cd89dd-100a-4a5b-466e-08d969cc0cfc
X-MS-TrafficTypeDiagnostic: PH0PR10MB5515:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB551516D3505F7A1C4F9E49F28EC99@PH0PR10MB5515.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eSYGegYde19SHlDdOK5gkICK93ZzXgQAQ4jfvmUqrs3WP9xByn5uoJyUSk31n6Y8CGRm8vfHFfioEKj/OFmwwR4GIjjTRSmU8sjQavB92/3MNEk98oZ7GZ9vY4GIDnVZBChTV3eK6ZRzzF6Zd5g4oOc1DXM9oCVgAQbdvOtTYo3Movd/u8OCI2PnQXu4H56eplCVAeA6emJL2NoWJpA5zEq+7O1QJgpoiKtSC8Z41OLqXSgeBuPPY7HOIq+1z4aH+MHQW2Ct2K4eOAjcc5z81h1FO7r/pRn6/tZu3aS2WioQoI9j+PtoYPZnPpDYu5B6rESuFxEmtfeZ7m6+4D67Ve1XEITya/seJmxVWeEbh1lGmcWQd3uWc/j3IaPPkvatmBH4POXIJp7SnWU4l2Aa04Csc8L2EDJvbJ+ruEgKi1z2O1ClwWEjjWRRdYuYQPfZFOB8NNp3jmHy9a9rg2NNaXT/Jw+7sf1UgM/AnwtdKIP5n5EDkNufHYVR30Ow7q8D0tyuH/R8fX9zIRRWr/AFHHoL3/s7IuAhtpXk0O7Z9+TKB0VfhaJyU9mc2XVyW4klL2BhSufw0TCvg37fMY479lcIIjAgvz4+4C2GuCJvLQuBwXKKxGw0x1XaGybn9PDg4Ej55utpaopuj6Bnu4e4d9J8jJJ080uNjHf+P8PielR6IbpR/ZX5zYqLLN5Db4adGVZH8sbLiNZcV9/eb2kt/knZOvtjeqqgetu6xkgAUaWxzLP2k9/5zMsH6E5sRrURHbxFrsaGiCAz5iB23neeJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6666004)(966005)(5660300002)(2906002)(508600001)(52116002)(38350700002)(38100700002)(4326008)(7696005)(316002)(36756003)(186003)(956004)(2616005)(6486002)(26005)(8936002)(66556008)(4744005)(103116003)(66476007)(66946007)(8676002)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dlZHMjBackxDUHVOcThhUVlzYlFEb3lJNlFhUTluYmJSUnY4QlNIeHdFbnhX?=
 =?utf-8?B?MkN6QTByZzR1QmdyanYwWlFTK0hYeEV2VnhUaWlwQkdLTkZrYmxDc1luREh0?=
 =?utf-8?B?dnR5TUVWUW1KSVRmOUJTbEZRSFp3bENEd3M3bUpPZWs1VUNMNTNLeVJobFZB?=
 =?utf-8?B?c2VUbGN5YXE2L0Njci9hbEl4bXhNWUZpV3V3Z3Z0S1R6YVJ3NmJ5Y1FzL0lu?=
 =?utf-8?B?eE1qaWJXM0d0dlo4K09jV3J1Y0lXOTRqWldFSjBlWTJVb1FLNkFPekFScG9B?=
 =?utf-8?B?aWZkb2Q4c1ZEQ2M0WWVpRUFvK08vRlE1bzZHU3EzODh1RmVnbWZxUENXUlIz?=
 =?utf-8?B?VllKaGpmZnFyK092Ny9RdkdNUldVN2JaY1FodkVJMDVBVEQ5SkdVTldvWkox?=
 =?utf-8?B?TndkL1FCVllrcVNoR3JyeVowNlN5d2g2amlnOGhsSUJGQ1ZHMXA2Zkg4Y016?=
 =?utf-8?B?c3dHaWRyS2dBd2E5amdYZ1UySkdwdzVpRjN3NEo0UnZuSEdNTnk4Tjk1THhi?=
 =?utf-8?B?TUVxZEJneHhEbThLakdpR3VVV0pvaDBNUi9scDh0c296RVE0bXpsVFZBR1Jv?=
 =?utf-8?B?Y2FRWUZoSEFXcXlRVllSMVFkdUhmcmlyY0ZCQW1lQnppenZoMk1BL1hWdXpW?=
 =?utf-8?B?ZUF5M3lHMkdsZzZyOEhyalozVFNqYmtBRlhaTmVvNlRlRDJPU3Rqb2xOclJR?=
 =?utf-8?B?ZEpNcFBiU0h2Wit3T3hSanVFUXYxYklhYXJrMFdrQ002UDhDMGJZak14M2VT?=
 =?utf-8?B?YXgzYTY0eEwyMGpBSUtXVDdZaVlPRWZQSkJibERUT1ZzL0pPTWhkQ2dYeXFH?=
 =?utf-8?B?clFkajhKQU9WTDFVektBd2FldWcvZFQ0dnRkVjcyWFdUTW1PS0Y4dVZPSCts?=
 =?utf-8?B?azhGUjU1cVRreGc5UEFBc2FXbmhCcU9kQTRKMHdBN05lSStLOXN0RTAydWpC?=
 =?utf-8?B?OEZtb0dNWVpFd3B4Tm5OelhaMnVwTXV4dFlqSGlzdVVLL3AwSlVKdjJybzNv?=
 =?utf-8?B?YmRQa0lmNllQcUkyV3U3dzZxRVNGTWk0dE92elVwK3NkZ3BxNFpRRUZidmQ5?=
 =?utf-8?B?VFpmU0swbWZ2d1ZDTE1ud2EvVWkvRDJ5d1J6SElWd0lBVno5aE5xQlRjNkNm?=
 =?utf-8?B?WE5TSUNmSFNnek1kSkRlVnp5ZmYyWlpMczEzSDRtbFZIcEhaeU9ud2hOWGI3?=
 =?utf-8?B?OEtJT2tZZUxTMGp1MFpFaDlYREJxVWl5RFkreUJ4d0czRDN2WDIvTWpTUFg3?=
 =?utf-8?B?Y0xiZnphQzVRbk9yLythYVBZbW1pQmFFWWpzeG90dFJWcWJ6dElrRU5LeWdx?=
 =?utf-8?B?Q1BXbmpRbVFDWW5nbEdUZ3JpYi9oQ01HS1BCdkwxUmdEckpSN2JQWEJ6ZTlQ?=
 =?utf-8?B?dE5lYnJ4eVBsVlZWQThDM20rcVJEampKL2JpeTliNi9tRGNWMnRDWWNyNndS?=
 =?utf-8?B?RjZWZ3RtcEFyODcxRDNaV0pKMmsyZnI4UWtDdnBOUDlhaDV6VEt6bWhLbEpo?=
 =?utf-8?B?Wno3V1ZDZ1RDNmhIUnlWSWErMW4zYmliVWFtVUNady9iT1BsOEdRSGVPMHcw?=
 =?utf-8?B?dmQzaUo1anc5QUcwUlYyemY2VXNLYmc5dVhyaG5zaWtNYlFvY0Zlekcwemkw?=
 =?utf-8?B?MTZPMkppTlFaVXR6ZG5DRXZ1cnExMVBPejUrM3NVWStjYWVUdkh2dmZwcUNn?=
 =?utf-8?B?YTRJVTUxa0ttTnRWbFJhQTRWVUt6SnB1aUNaR0FFbUpKeGxzcEN0cStWRUNz?=
 =?utf-8?Q?nqU85xZpDvLBfj7QQuWbwHxKTfetWLVDwRoCj7m?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6cd89dd-100a-4a5b-466e-08d969cc0cfc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2021 02:32:16.4976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x73NyMrFS47IBeE6kxvv8Lpir2jqm59XVW+fTaiiByODoZ2un6uffBJEVWGi6DlxScji18QPPW+Rc5IEJ7By+vWNgk31etI6at7PlPpdQww=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5515
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108280012
X-Proofpoint-GUID: bEK1bcHKGEWJOeRsvjIZXKSwlZDV7tqU
X-Proofpoint-ORIG-GUID: bEK1bcHKGEWJOeRsvjIZXKSwlZDV7tqU
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 19 Aug 2021 22:41:31 +0530, Alim Akhtar wrote:

> clk_get_rate() returns unsigned long and currently this driver
> stores the return value in u32 type, resulting the below warning:
> 
> Fixed smatch warnings:
> 
>         drivers/scsi/ufs/ufs-exynos.c:286 exynos_ufs_get_clk_info()
>         warn: wrong type for 'ufs->mclk_rate' (should be 'ulong')
> 
> [...]

Applied to 5.15/scsi-queue, thanks!

[1/1] scsi: ufs: ufs-exynos: Fix static checker warning
      https://git.kernel.org/mkp/scsi/c/313bf281f209

-- 
Martin K. Petersen	Oracle Linux Engineering
