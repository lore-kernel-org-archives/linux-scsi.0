Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AD6BC433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 03:15:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 734486507E
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 03:15:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234765AbhCPDPN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Mar 2021 23:15:13 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:60768 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232165AbhCPDPM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Mar 2021 23:15:12 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12G3AGmq168369;
        Tue, 16 Mar 2021 03:15:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=2ZOpaFQhAe7TrkZZLaJkqZjEfJxk+O+D6PK99UZMoDo=;
 b=ka3LdF2vmiomSHbAIm1cguWptYSSziaVf+p0P6gAZ/ukXY/89w94T7qobnCplDBz0jW4
 Vp9ieN4DOUqI3v5PR/luCTt7YA0L1fkPjkRxWdlZBzuSu8CDZSbM4l/gAjowI8T4+S6g
 CeZ5MH9Wwg/sgsFSjCbM7ZDtHyRGDdqG+xPtVDIHM3VT6OxlFFA2MCax2hCVF3sAJMYZ
 DchETrc/e6/pUOr8/GvbspvwynqyNDH6hH4ppxPVBMoDyyWuYukSsrP+ScIpsyownwz7
 6Y/BCJC5Kb/h9q0/eNrZlNJQn4ONhbffCs7M01HNGhtAmPcuSA77T7VuX6SBwnd0hPuG 6Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 378jwbe7tc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 03:15:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12G39dpp138133;
        Tue, 16 Mar 2021 03:15:10 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by aserp3020.oracle.com with ESMTP id 3797a0nb5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 03:15:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mh2yRG8JDO2kkSRIY3dlh/khyfIJ5xNvy20gTCMmQHqKPr/PIbCfKd4MgUFzOEPQJpnxMV4njeoCuM7lSfzOuHurWYGgWmMjvwx0o3vPcFyVss7KlAMXZ54wsKUUfrsBfYfSGYynPZaYFdLiAOyUjez3yHGihm1uVHOZDkagbwSX1NnQgop5A/43GTV9Z0va6LEQ3/eFZptytOKXKIMbZHQhAB1Xv4KirzH8OLs78B6NIuZ8bekKXg5QTaQwK39bt9ggT18p77HW5K5Q3upGWpuC8rtsLnfn/ITN9rmVwQj4j9F9V0uRkLSFH22wR19PVvJ6TphpV0UXQuBe+63dWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ZOpaFQhAe7TrkZZLaJkqZjEfJxk+O+D6PK99UZMoDo=;
 b=af9KC+0uxr1soZNa04b8qgpyjbJL7pOFqDugppOTDovtR5P8dTxCTL5tlNX8io3l/ix8mvicUAS6ByMOqv1kXn0ZCorImKd9s6EL5M6rKp4P5v8h5J6taty41yHbYj8NcZVwMeQCPn9mrcVvuvavleD5sfK5KAR8MuknhAzuOeDgTyJAOKB4Luli9vXDOKfRC0+OOyI1T7TwXYLwZ6tgTXv17meEbnS2eZHY66i8s2JrHJyBfY7ZcDxXW0F62lCMPi+5ol3aE8Bd0ECbHSFhikddfDZqX7609/5CB7uTNnk+auXcyOB0oErD9HyOPKWeDuE5+OqN7y+ik6IXZqKdqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ZOpaFQhAe7TrkZZLaJkqZjEfJxk+O+D6PK99UZMoDo=;
 b=m8OaU/AnSQIElu2xvj0ePQ1+TH5I5EKt4c/j2netGamGxShgsi5zeQBMO4D8xR7qfS71tdCThONuRvGLGHu0Ov+S+DutF7MtePcuqiL71IqidE8OrJivPuKVaROSVrLwr09Dl+PQbuljxkwU3GTfGYZRDxDsnCCfmwzXNi796Zo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4709.namprd10.prod.outlook.com (2603:10b6:510:3d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 03:15:07 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 03:15:07 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        Bodo Stroesser <bostroesser@gmail.com>,
        Mike Christie <michael.christie@oracle.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: target: tcmu: Use GFP_NOIO while handling cmds or holding cmdr_lock
Date:   Mon, 15 Mar 2021 23:14:53 -0400
Message-Id: <161586054341.25014.9194443981639418304.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210305190009.32242-1-bostroesser@gmail.com>
References: <20210305190009.32242-1-bostroesser@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: CY4PR02CA0012.namprd02.prod.outlook.com
 (2603:10b6:903:18::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by CY4PR02CA0012.namprd02.prod.outlook.com (2603:10b6:903:18::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend Transport; Tue, 16 Mar 2021 03:15:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c2cf78b-6704-4d08-1fab-08d8e829b302
X-MS-TrafficTypeDiagnostic: PH0PR10MB4709:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4709ED362498CF1268A361968E6B9@PH0PR10MB4709.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p+LiORtE6h2Y5+q/8S/N7Nbwe8ZP5Vs85CeHlDfp2BpVhKxKLKRtzJJ1byZWhLi+U83JrUzehSw3/uCHcVj4pE+WaSVW0GIb/K4Af6+iSMLHcT4lFVbB3IYSfWAdPU9YlZbRp/wVLNlOuH0CwdeMnaUGqpSX69J0GOH/N48xK6tP1AOjmXhMvRbjJlKFXzsuj6bq4O+IuDiaQOgFtTOC1q8E/huh7uXGL6h28cQFMt0D4qyp0uVEZ42RQzLEdeB9K0hLefBrKmOxI6LLePYxL9NdcWWxtRvCsRF1NCFvHyYlFT6MnL2flZeHyssQqDU+iSY3d46YFokacJLi8XYj5uqEzt1VqriyGOTXiGrZ6GszUwvnTKXjCXS4aeUwaCXzpJ70TmWXatBP/Mt8zpDT5DjJ0zoipu4or8CcGu4VSK6sf8EfU7FCtS+kRAV/YDjaAiQsLTpuIdBJ+UnZU15+JgnL6uvgnfOzGwXxdg0o/4N5qgskp3GC550HbccJx02CmJt9ewXKbE8GibrgBejiSLvLfB8BV94c1lFEVO2+LXJtcwewOwPOcouYqvvBXCptRhelG99SaUZf0G345IOkrixKNRdKIIPGhQyeivpIUKlJiOg0qElVv4oGN+GfHLOdJssqf7XdJ5gGilne8OBSbg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(366004)(136003)(396003)(2616005)(26005)(478600001)(956004)(4326008)(83380400001)(6486002)(186003)(66946007)(103116003)(4744005)(107886003)(316002)(110136005)(5660300002)(966005)(8936002)(86362001)(8676002)(16526019)(6666004)(2906002)(36756003)(7696005)(6636002)(52116002)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SXVxa0U4dXpRM25MSlVHc3dIRDVFQzE1ZTZrOERlem1GVmwzN0xBYjdUR3d1?=
 =?utf-8?B?dG9KRUhzbXlqZHVLNGZqNURwclMwOUJlM3cvakZVUjhtbjFSMit5N09OMTVH?=
 =?utf-8?B?eEY5MmZvamh1YUVsbDZJRElNWnhFMzl0ZDUzeTI0T1FkV0sxTTd5VkkyUTZn?=
 =?utf-8?B?blhwVzZ1TE44L0xEejB3NklEb1dVQitOOWE0VEkyV3BoRFR3cm5uMWdEZ1N4?=
 =?utf-8?B?T3VYdE9sTXlQQjZiaHNISHo4WkJ5djhKVndDN0lYR0w3TitzamJEY3RRR2E0?=
 =?utf-8?B?ODNhR1kxSklvRy83RSs5SExUWjZFdEJ1cXcra2Z0aTVLbm5CdUZ3UTl6SDh3?=
 =?utf-8?B?UkRCMW9ZYU5kNzhnQjhaSHA2NGFoVkpBQVp3NElVWXJiQnhrVE1CZkZQNEF3?=
 =?utf-8?B?MmxLWFV2Lzd1UVNYdWUzVjB6dklySWRYdFJsaGFmM1hTY3N3WXVaZjNKclhQ?=
 =?utf-8?B?RlRSVjhheXdKMFF6Z3FITXQzc1ZrOEx1MGFOd2w4cklUZ3dvaUsvTjBPeXZn?=
 =?utf-8?B?NU1rRWY4WDFXYXJETzRVT0E5VndYbGw5MHlmZWg2NFU5ZDJsclJYclhkYTI1?=
 =?utf-8?B?QTg0dFAzQzgyaENNdDJEdDM2QUluMXNGZEJITzBPVTdncUpTakVXY3hDdU15?=
 =?utf-8?B?TlR2RzFSRGlLMVZoZHJOd2kzWURBdGV3VkxyMlR4YlNTYzJ0aXpIT0FNbFNW?=
 =?utf-8?B?SEhHR3Q4WUpOVkk3c0k2S095WFp4dmhqcndjSkdDazNpdWN1N2twVzF0WVRr?=
 =?utf-8?B?UEUrd2dQRXpMV3YyK0RHdUk3MEY3SW5Lc1NzcjlYVGJxOHlvOHU1N0w5aXlG?=
 =?utf-8?B?dkgwRUVvV3Vvb3loS3J6d3JWV2c1UWNYREVqamZnNFltem43dHJsM0VOQU5X?=
 =?utf-8?B?WVMxS0l6MWpEK3poeTN4dng1MnZZaGtLTzc1K1hKSTRQK29pZFM4MVg2eXEy?=
 =?utf-8?B?ek5pbFgxVDZmcktoNXJxbXJCQU83QUV1cTZIWFN4T2Z3NWxOcHZ5RkJwaVlw?=
 =?utf-8?B?WWpnc2RuZ0lEY3M0NEExb29taVVmMTArdktJUFVpeGpRT1AyY3FqZXJJZXZP?=
 =?utf-8?B?bVRReExvbU1JRVJuemJxWnNPVFB5aG1SRDJub3I5aUxCcEExYWJjaGxYTFU2?=
 =?utf-8?B?aWQwT1hrTGl0dW9iTXVTTEZQU2tpdjRZL0o2MEh1b2h2MEhTSFJ2a2toS3RN?=
 =?utf-8?B?K3haYkk3dHlYVUlYUk12Z21aeFIrN1Y3a2NXNTVuMm10V3k0VlZjaHpaZ0VR?=
 =?utf-8?B?bXBWRWYrZjRiYlc2UVZGL0FIa0hPaEV1T1V4OGhMdEZ5SmlPME9jbFJuTk1I?=
 =?utf-8?B?MUg4WU1XSUw0UU9yU251K2ZHaUJnSGVhN05tLzEzcitVRkw0c3QwUzd2UnZT?=
 =?utf-8?B?am9hbGVSRUppQ0pZN2czWWN4Q3JCVFFaYkxscTFtVi9NOHZsRTJVbkMxZlFk?=
 =?utf-8?B?bmszZDBlMFJwTTNwVzFSNVE1ZmY5OU1jV3ZYWTZrQ0dCVld5VWFNQTlNQkpW?=
 =?utf-8?B?c3RxcUVOQ2NHK1owWlZ6eldXOXhmMmhncklnWVNSS3VudzdUSnhJZ2pGR3RD?=
 =?utf-8?B?bFdlczZkamdBN2lUdGxMdmVZYWNwalN4VitreXo5Q3NIODk3ZTdkWFpIZVV0?=
 =?utf-8?B?cXg4bjZIZjcvVE4vOW5mZ3ZJaWxHb2U1RjhreGJkam1vU0VjSWJsTURUelhE?=
 =?utf-8?B?K0FyODlnSHg4ZHkzcEY4Tm5kUzZDc09YaGg1NWZNTlNhZmNsWWtrcWlDQmpW?=
 =?utf-8?Q?ck+1nVgRxAQrplUnMz9+/dvn3gVfTcAx5t5DnvO?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c2cf78b-6704-4d08-1fab-08d8e829b302
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2021 03:15:06.9420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DEjxweJEx8iiRljW3yquy4IO8f5s86smTs0rYuu0bJa+liZVUxENBt+cFOl7yjaP4LGir29o2ue8VLT1e52aMLL972leEnopjSy+6i5LFOs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4709
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9924 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 mlxlogscore=938 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103160021
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9924 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 spamscore=0 mlxscore=0 bulkscore=0 suspectscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 adultscore=0 phishscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103160021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 5 Mar 2021 20:00:09 +0100, Bodo Stroesser wrote:

> Especially when using tcmu with tcm_loop, memory allocations with
> GFP_KERNEL for a LUN can cause write back to the same LUN.
> 
> So we have to use GFP_NOIO when allocation is done while handling
> commands or while holding cmdr_lock.

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: target: tcmu: Use GFP_NOIO while handling cmds or holding cmdr_lock
      https://git.kernel.org/mkp/scsi/c/1080782f13e3

-- 
Martin K. Petersen	Oracle Linux Engineering
