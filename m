Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39D3EC761AF
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Mar 2023 12:37:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232600AbjC1Mhh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Mar 2023 08:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232866AbjC1Mhb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Mar 2023 08:37:31 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D49ABA274
        for <linux-scsi@vger.kernel.org>; Tue, 28 Mar 2023 05:37:08 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32SCT7G8031786;
        Tue, 28 Mar 2023 12:35:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=vI+/IG+8VJEbGHlRfysoDF0jiYBEZEVSecZbqO1z+bs=;
 b=jY4qjVkHKotR6ADaDVCiRvevZNNrDwfPQ7aOxANNGYW9v3KOvX9detstsx9BnKToLyjK
 A9FFf9KKlSbD1B0YwxVrQwnpy/0z9kAP225kURYJr00s33ccETvmWE+wfUNCHyvgpk3e
 crP/stOQKgyTSstBXfTwZOB3sz/J2+8JTq8O17UtIPSiS8VIJcY4IKQLEIMC1phoqKbX
 6AZPihbuikl8iCifwn0u50spWoFBHvD1wWu87hvG/4HBJTc5mp2Hdkk4Nk6t26h1L6hD
 6teIJWvgypamIWqDmCznc+yhtaxy7VsOPDT5BTogBD31GDwyw63Bx2cWRpe1YHr2nz4p eg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pm097r0r4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Mar 2023 12:35:53 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32SBxUK0027740;
        Tue, 28 Mar 2023 12:35:52 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3phqd6b0uu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Mar 2023 12:35:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jFOdq4SBG79q6EeKGcWYAz09QnTvfIpiGGal2VC4eIWlT7X1nUkMog5CvHUQOjcKt75ksol8G+nrxfnA5wZ8q1iDgVQ6st5iRd/xWSlOBtmOfYn+SLDQCd6jex1GoFO09QvB8fG36Z72d1LHNCDHohXy+mHiM9TM/yPKxC5XzuZixWQEBZNbnPo6sLjKd9igYp3VcDeQp4OyTM/KBuq4M0e1/UH0tqwI90KkuSctllUKLfePmM/3DO9MDIcWXh7uLSXgSze+HozX+8qFtkfiGA1/HgS/n3wriBBJYsjhAfCSNoHuxHFES1KjHqXFNqXchmENlDPjz7n1+fy3A2ZZ3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vI+/IG+8VJEbGHlRfysoDF0jiYBEZEVSecZbqO1z+bs=;
 b=E5vFmtHPgG9So3Jaw30tJ/wnWGGQaUCOoF2r4R8meOuWoxCZfdikBrmxJD/otvvIZQwjxJbygkRR1+jekKEMgZruhVdK8p1/WC2y2EUKcd2wgG8tsf/vrLdlfi0Pn3hDzDRfHu2Kxa+0JCmFVicpOrt/JeH/dyjCD8tcsRltm4LmZ7HDJSoDIqvPyLD9IX2cexZVDPg3LBQ2f9x3+Mq0ZAvpSPkplR1WbpK+4Ly1P6RdNlGu1sxV0RblVJ7yDy/6QMmrS86aOKqFDBc3/810BhPq+El82w2SSigatk5Roy64iRMZsH3tIOxOa6dpaL82B0lCaYNZSIR5Ziym1kMIfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vI+/IG+8VJEbGHlRfysoDF0jiYBEZEVSecZbqO1z+bs=;
 b=UR6yVIxBNbuVqZ6UsqcD+d4W5d62cjI53tcTMWKxkRSD/NoEbpWw8sPDUQKzcWJgyixal/Ipua2yopBQ8heIVAIWNBQrDww+hVTEhP2GbkoHAA/z5qynRnp8ewzEER9+/8GUlU1oIZLxP/SrWxX5n0yIyWVIMz+ISU/4Q7tJf1A=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DM4PR10MB6112.namprd10.prod.outlook.com (2603:10b6:8:b7::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.30; Tue, 28 Mar 2023 12:35:50 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::7276:bc4c:17a0:7267]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::7276:bc4c:17a0:7267%5]) with mapi id 15.20.6222.033; Tue, 28 Mar 2023
 12:35:50 +0000
Message-ID: <982d5c0d-1548-0739-d7d6-96a7834709ef@oracle.com>
Date:   Tue, 28 Mar 2023 13:35:44 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] scsi: libsas: abort all inflight requests when device is
 gone
To:     Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, hare@suse.com, hch@lst.de,
        bvanassche@acm.org, jinpu.wang@cloud.ionos.com,
        damien.lemoal@opensource.wdc.com,
        Xingui Yang <yangxingui@huawei.com>
References: <20230328111524.1657878-1-yanaijie@huawei.com>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230328111524.1657878-1-yanaijie@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0376.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::21) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DM4PR10MB6112:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ff458c5-f44e-4bfc-5e66-08db2f88f652
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r8sAd9cO4ujBFI1a8N9FtDRbvcUWkCMNIGr6Fn8VSb7wjugOqqqUhRcXTHIZeW/Fg+6T3tgCCa8Q4nMXnCw/RScbNEw6GN6mDi6ljD4TDiwI4549540Imwbr48ckcIlcgFMM6VWdwn/sVqHpc9K0LJ0orriRnoYihk6zzSHlTiJFG720CoTfp1Rarez9e5K2CLEn2HmF8IaWycgmq61tJAFXmpOyPCETnGvgsMyTn3z3pGCfF8yNvONyH01zWM7cH75RMVTekymTL4EjTvqmeOe7ahuOcCZZTFMaLA6BFNQOUrdb9qwKXLBfGspZCY8wQJjzwbkSaAtkrqSU0N/cmu7U2NWUbDczl/40PGbUjkG+l6uGZ0iyJj0L3xjsSdzcRHWYBBAQU/FWvSntMJF3HNrdAKdVEeDT6bQv7L2+p48Py2NXvMPYdV4yX6aP9qW1BiFxyyQLSXae/Si92Q8KRBFzI+1OHmqfsfEMGyDNKtPAyGLqxQNH2RPMp0a5n1+mjlAP12PKxb0rC11PqYpGRIInVOgfZIO91mEWpdKTB4wTfES4H+0tA7G8JB012CxeiWJiZAF2S0MODNgvh7v/0lO2KVZbzfaJEEVikwcACiijJWPX7lz5NHeFLZhXPcZyp0B1Ur1/UAI81kYp959jxezQ6kqh/fuG49vEq/93/hVVFSEBzMPayGPCe0EORige
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(39860400002)(396003)(346002)(376002)(451199021)(53546011)(26005)(6512007)(6506007)(41300700001)(186003)(6666004)(66899021)(966005)(6486002)(36916002)(83380400001)(2616005)(31686004)(478600001)(316002)(38100700002)(4326008)(66476007)(66946007)(66556008)(8676002)(2906002)(31696002)(36756003)(86362001)(5660300002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cE0ya21tc1lEdmtPeDJxbWQ2L080RVJUMGVDYnF1SVJ2NTZhdFE1d2dEMFYv?=
 =?utf-8?B?MEZ5TlFzcGxRcFpJRUw4OWdGQUR6QUlPVzhQdktFLzZ5NWpkcWhIWlV0ekxK?=
 =?utf-8?B?cTdCZEgrSGl2OUM4bHZKUDVVVVVXY1lrckcwY1pZUGcrTHY0Z3hPNFU2djJB?=
 =?utf-8?B?dHdaZm1wbGtqRVdwNUNMNHA1VENnVkFoTjFTbFJyemNBa0dGd3ZLTUJsN1Q2?=
 =?utf-8?B?V1BUdTVCLzRlRXJBNGEzNmltRkpLZWdwMVlhTm1pYlFnZzN3OWMyTGZxN1RK?=
 =?utf-8?B?SjBkQkhOZElNMFRmQk9oZ3pqSFdnSm9BVnFNcGxsYmpxMDVMU1dQWUg2M1Nm?=
 =?utf-8?B?VlhGM1dnRWQ0K2VYeEZZbHBNaGNka3ByWVVSdzZ6bE53VWYwZlZsVTlRMC82?=
 =?utf-8?B?WGtWczhneG8ybmJhWUFQOUJrSXVJNEFzNDRXc3FiRWc4UGJCKzRTY0lLUUlq?=
 =?utf-8?B?djdZbHRGb2ZhQS9xYkVseTM1UFkwbzJYaGFEbGthRmx3NHhSa012ZDZvYzVu?=
 =?utf-8?B?Vi9xUjhGMTJsbFYrRW9KdlhMUjlDbkRwUlVuWjk5dmJwdVVwTytwY2RnN25E?=
 =?utf-8?B?TFNJSFVmYlpubjJhVUd2UmRSMFlqeU02dCtMQ25yMzFodFExcyswNWJPLzJH?=
 =?utf-8?B?NlpjUFYxUzFyVldyc3E3dGpIL2NaOHVhbTJ2aXFTUmtwUjBxdkRVTlg2ZDhs?=
 =?utf-8?B?Z01KcUc5MFR0amxhS1BISjVYVDB3TzRKekZEbnp2SDQrZ0NxaVZwN3VoMUFB?=
 =?utf-8?B?Nm0xY3ZPYzJ5N2FhWjNBekd6SUZZekxoZnhKb0M0cXp2VUtKeEQ0d2NiaUV4?=
 =?utf-8?B?WmNmbnI3VHdEVnJVVXM2MXNtaldDMjg4ZzUvcEZGZENYZ21JWXVOcTcveDJW?=
 =?utf-8?B?M1paSjNOWloxY1RxMUd4NGl5TysrSVVFQ3EyYWJRRWJxM1ZZT1VQRDNuaERn?=
 =?utf-8?B?a1ZZVCtUZk4zRmFvL1lVTkpZTmc1bXcrRXppczZwS2V5T2t1RFFBcm54RlJB?=
 =?utf-8?B?bWtJWmRMdmU1OHVGK0hZeS9FanFPY3QzYUFFYzMrUGxrdlB6OVRhUi82NzNZ?=
 =?utf-8?B?RVNlRnYwdk9SVnZxNW9DdXd1WDMrMHhrQWczUUZZOWY4N1FYTFB0N1hRWEEr?=
 =?utf-8?B?UUk5N0RmTC9aWlhoU2dMQW5DM2tYMlNQUFFyNW9WNTZWMlhqeUJFS2RITWJG?=
 =?utf-8?B?U1A4ZUNZQkV3T3NKaEVXenpvTVZtdkJWS2hWcHlBN0M4TGJXU2w4VUFKSFY3?=
 =?utf-8?B?WXJzNDdOTldnTEZsYnpDbkJ3YnZSb1pRUmd1UHo2cXZWdWdpam16WGdoUFN2?=
 =?utf-8?B?Vy9tT1NQNk9sNkRmQVBpTEdsRURtNzdhbG90UkZ2N3owTk5zYm9LS3AzL0JO?=
 =?utf-8?B?WUVtMTBCenBZcmJBL2JSdVF3NS9nTWt4dmNpUTFFdEJ5NnhIaVBrM1Jwelc4?=
 =?utf-8?B?dmJaSVdPY3pTTVVRWHBuRnppWC9qYjArSEN3NlRKVkN4RVJnRkJhZ3ptcmpZ?=
 =?utf-8?B?eS8va3pKK2pHb2FaNjN5b0p0T1VUUUhBcThwQ1htNXQzNkFlSzgvdjZHZXBt?=
 =?utf-8?B?RmZrcHVDNkR6QzhhcEV0M0VvMHcxQWUzTGlVcGlzNlBIY3BQMnVzUFlnV0h4?=
 =?utf-8?B?NVhFcU4rS0VJSG54UVJrS2tZRjNUSWJrcUFSd05rZWJoV2x6dm9GcmxLWnRJ?=
 =?utf-8?B?S0c5OG1KZENrRUdhMDhxTkc5Umo1ZDBha1lTWXQ0OXBUVUo2enZhZ2JFLzhK?=
 =?utf-8?B?R0dqOWVEeWVpeVMzUGJxRTNEWnNEc3VZUmtzUnBUczdMckJ4RVpYTHpaSDF2?=
 =?utf-8?B?TDBVRHlIUHpCTTBQLzdnSDgxT1FGTmhkWlZaMFNtaGhyblZPQXhsc2VZanBT?=
 =?utf-8?B?SmNiQ0FwWWNqWjFzYms5WEF5MGxFSlo4a0RCbFh1NHdnZUdGUE1ja1hJeFF3?=
 =?utf-8?B?Mlg1UFZ0Q28vU0JIR0NDOTQ0M2dvK2pIb3lOUkZ4ay9yT3Y0a1ZUbmcxZVRm?=
 =?utf-8?B?dnRscUN1QmxVemFQQjUxYlA4bGQ1THRkZGs5KzU5L3dBRXBEdHJmOTA3Y3ZP?=
 =?utf-8?B?THQ0Uy9lckZlSjY2QTZLc0s2SXdFVlJiakg5V0RaYlFTSTFCQWI0bUluN0Ra?=
 =?utf-8?Q?AO+INF3yqSz03utEUFLXdenl0?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?QVFjUFYvZ09Fc0ZkOTdoWndTZWNaMHA1OEd5MExOVTI5QzRSWGZYKy9VTnFO?=
 =?utf-8?B?OG5yT0RBVEdmRUhiNndNN3lEOHRJM0pPSElsaWtLNWZDUnRsV29Ga3o2UGJK?=
 =?utf-8?B?ejNpTDRRb3ZpWkJtb2VBNmU5NnBHWHFDcjZIRXJhM0NxRzFjQlhWVWdIYzZ4?=
 =?utf-8?B?dGJMM2E1MC94cGVxMkFKeUFidm1WYnVnUHNPYkhLeEo0amhEc2Q4WFJDOFV6?=
 =?utf-8?B?YVRISUdkem1scGUrbDk5bk01UjA0eUduOWEvTjBVZm1qcTRmQXBIaExObHpy?=
 =?utf-8?B?NUp3SmpHM0lCYUF2MGVNc09PVDMwWjhPSGNlWkEveVI5RUlXblJnQTVBK3hk?=
 =?utf-8?B?OTVIcGdNd0lXOElXalV1Qm5LK1cwai9kN1hkR2MwYUlWcXp5R2h2TXhuWlFF?=
 =?utf-8?B?Tm83dkVaOEJQQmpNNmJRZldJOFBocGFWTTNPWWJjc0Z5cnRNQXNXcDl4R1M5?=
 =?utf-8?B?eE9yV3VLQUYrMjJ2ZGt3WnRYbGpNWUkybGFUUENUV1gvcDZpNVZyNEFTQjRy?=
 =?utf-8?B?MC8vK09ERkxpTWVNUFRySUJKZllmMnFxQ2MyWFo4VjQ4TjlxdEtJNERmQjRn?=
 =?utf-8?B?NEpsRHEwMzBuWmdGYzQwR2swaVZobFJnR1EyWTNtSE80b1lETGN3cTdqYWtq?=
 =?utf-8?B?djE3MlNOcjRDMjRPTUxhUldkUGE3SnVFRGdrUEIwNEd3ZE1VRjZ4VXIxY2Qw?=
 =?utf-8?B?alIramFZVTBTMmpyR2o1UktvNGhqejRHSGVmYVpYekZjMms4Vk1YL2RrMVlK?=
 =?utf-8?B?ZzVaajlWNUpNb1RLZW5LVlNsVFFsQi8rSTRqQnYzRU42TnU3Y1Jtdnd1UDNm?=
 =?utf-8?B?QXVhMzJJdWNLVzBDSWNFRktLVnlHZ0wzV3NZUVpnMzVoYVJXdnd1T2hWNlRK?=
 =?utf-8?B?WlNhSkFadmdBUEFJdXljbTA5ckNZV3h6aURRMVl1MUdoRkpIQkJjZkNnSHZH?=
 =?utf-8?B?cVNMdVlCdGtLVm9HK3N1a2RZbmRnSTJrUVFxTEZNUjBQS3FMRER4b0Y2SUtG?=
 =?utf-8?B?ejZxUjhOUzRaeVl1Q0l5ZFd6VzVENmt5dTErSDlOcWtVYVVNdFFpcGNwSWw0?=
 =?utf-8?B?QUFRd3VsY0VlUkhCNjJkRWRKMm91QnJySlVZMkVJdUd4U2dlbmlUb0prWk9s?=
 =?utf-8?B?dURWL2I4WXByd3Y5RTcxT0tYSjBkRkdmSG4ySmpxb3ZjS3hRSEEwYWQ3MzYv?=
 =?utf-8?B?bUtFd0lwajFpR3dkYXJjRmM2bVJkc3hMUHJaYTk4Ullnb3BYTit6ZEN6YVlu?=
 =?utf-8?B?RFI2cGlpSmdwZzVyd2ZhUGRBK0w1bFVPNmVwemdwSjk5SFpHUGFrMWtTY0g4?=
 =?utf-8?Q?dDzI7Lpdj6RwI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ff458c5-f44e-4bfc-5e66-08db2f88f652
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 12:35:50.0077
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LWDCxHDAuVm/IorZDoSYHBFmA+ByygLoxgAkN5Hqy780myvsMku5xo5WxuhDoMYj3x4M3denmGYtbfuIzJROBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6112
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-28_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2303280100
X-Proofpoint-GUID: XKsDe9-IyebIIANb5koVHuXF-Vvw2VhF
X-Proofpoint-ORIG-GUID: XKsDe9-IyebIIANb5koVHuXF-Vvw2VhF
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 28/03/2023 12:15, Jason Yan wrote:
> When a disk is removed with inflight IO, the userspace application need
> to wait for 30 senconds(depends on the timeout configuration) to getback
> from the kernel. Xingui tried to fix this issue by aborting the ata link
> for SATA devices[1]. However this approach left the SAS devices unresolved.
> 
> This patch try to fix this issue by aborting all inflight requests while
> the device is gone. This is implemented by itering the tagset.
> 
> [1] https://lore.kernel.org/lkml/234e04db-7539-07e4-a6b8-c6b05f78193d@opensource.wdc.com/T/
> 
> Cc: Xingui Yang <yangxingui@huawei.com>
> Cc: John Garry <john.g.garry@oracle.com>
> Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Cc: Hannes Reinecke <hare@suse.com>
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> ---
>   drivers/scsi/libsas/sas_discover.c | 20 ++++++++++++++++++++
>   1 file changed, 20 insertions(+)
> 
> diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
> index 72fdb2e5d047..d2be67f348e0 100644
> --- a/drivers/scsi/libsas/sas_discover.c
> +++ b/drivers/scsi/libsas/sas_discover.c
> @@ -360,8 +360,28 @@ static void sas_destruct_ports(struct asd_sas_port *port)
>   	}
>   }
>   
> +static bool sas_abort_cmd(struct request *req, void *data)
> +{
> +	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
> +	struct domain_device *dev = data;
> +
> +	if (dev == cmd_to_domain_dev(cmd))
> +		blk_abort_request(req);

I suppose that this is ok, but we're not dealing with libsas "internal" 
commands or libata internal commands, though. What about them?

I suppose my series here would help:

https://lore.kernel.org/linux-scsi/1666693096-180008-1-git-send-email-john.garry@huawei.com/

Along with Part II

> +	return true;
> +}
> +
> +static void sas_abort_domain_cmds(struct domain_device *dev)
> +{
> +	struct sas_ha_struct *sas_ha = dev->port->ha;
> +	struct Scsi_Host *shost = sas_ha->core.shost;
> +	blk_mq_tagset_busy_iter(&shost->tag_set, sas_abort_cmd, dev);

blk_mq_queue_tag_busy_iter() would be nicer to use here, but it's not 
exported - I am not advocating exporting it either. And we don't have 
direct access to the scsi device pointer (from which we can look up the 
request queue pointer), either.

> +}
> +
>   void sas_unregister_dev(struct asd_sas_port *port, struct domain_device *dev)
>   {
> +	if (test_bit(SAS_DEV_GONE, &dev->state))
> +		sas_abort_domain_cmds(dev);

This code is common to expanders. Should we really be calling this for 
an expander, even if it is harmless (as it does nothing currently)?

And we also seem to be calling this for rphy "which never saw 
sas_rphy_add" (see code comment, not shown below), which is 
questionable. Should we really do that?

> +
>   	if (!test_bit(SAS_DEV_DESTROY, &dev->state) &&
>   	    !list_empty(&dev->disco_list_node)) {
>   		/* this rphy never saw sas_rphy_add */

