Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9036EC001DF
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jul 2023 12:01:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233062AbjGYMBt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jul 2023 08:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233013AbjGYMBr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jul 2023 08:01:47 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F239910F8;
        Tue, 25 Jul 2023 05:01:45 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36P7oIVg010863;
        Tue, 25 Jul 2023 12:01:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=wTzPyCr6xy0Wl+BTEvAl+DSGNQ84waJJhAHfJEg49eg=;
 b=Y/oDr8liTjz1j3JqKl7q+g9tkisNYgz0w0E5VrYgN6DZdyNx4HQ3Rw0/c6ps47Mfpk5p
 ZmLoecR/wEMXxpmZfHf0TkcvHJ0fxXSjz/7O+MaBxKftDE6UC6VdJyVs9Wf9aKNbVDa1
 dHLAp4UZHDCEDdFEFapbhWf8jMGjg+d+LCwFN2s0XBP/MyqcMVdC01ckFLWIv24yORIU
 VNTp2Ou74b1rx7aWasm2DAgMI7lbIweDeusXGsKq9Dq72011k91AwFR+k52SBAaDiJSI
 A/BKmJQEjcG7Za77Y3vOGbwr9ht0xXdHsLoca0fh0N/1C9jpsvIq3NisxjNJJC9z/bxs pQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s05w3mvj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jul 2023 12:01:33 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36PA92tP011545;
        Tue, 25 Jul 2023 12:01:33 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s05jaxnmh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jul 2023 12:01:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VsAiL78sgKx7k3OwMsuu+kXi8aCRusuyacR/Wpm5g7az+wUu6tJJ6E0uYgNuiu9wwJvBIhUCvA3FHLdRsQRje2hMSwjc9aYeYOtIyuGsbhfRDE/Cflswo1SFIfYXcNi/Yk3UZBiINPWXYARMiii6YhZGn+2IGRRgYWPHiLunRBZ+hEYE5mixSQy5hkyv3Gf0ERdiE8kQbt/3DucZeWRmeqZi5LtDFqCuJQYJz3EerfiOe6XSDigWR8Ag+r+GEb+WVAB0NdYC3URJcjRDfDIcV4hljk1P75jSlBVWDdyNebqPqs9S/EEgB2HBU+C+oHtWxrBwZzHd3kgGLFqpWADZgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wTzPyCr6xy0Wl+BTEvAl+DSGNQ84waJJhAHfJEg49eg=;
 b=O3n260ok0G4dBXFM5fNULIHGUUFXXFDbgVHhI2sU2YLT3akoBssUlbZd89lX9d3Y/Hxz1+jloYq3/4aaYHttQ8jC4fn4YhmVKOpueb1kXUXKL/xuonP9frPRiGRxrgIdHut3N9ilEFc3C47q/eBLXtX3V9v7Laf/3SW/Ng0DS5vkIh+ERb85EnXK4HV2LHK1kQAv4CXC+uPykepQSbwDRjm7fzunSVBGNOggJj+OTUBJMGD8oUNB4aeGk2dA6OeiA0WVR+neWjCheuF6ImfPEIPafIW4jxD/EBj1BlkSducU6uJ5X6SDsj1ddf4hj5GdjFML+5IByxIEHEF9MqALgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wTzPyCr6xy0Wl+BTEvAl+DSGNQ84waJJhAHfJEg49eg=;
 b=xjrip+PeXdRTMELTTH0jrjKskdR0gYgOYeGBL6iFsANnfvdgp/RyFsfOfJ3Qh/PhtAVkKmoBTSlVvu1J0HBK/tAzhQphTJoF+inAr8VNl8mOvD09At3vbqozk5UfTo4Z89sfLBCCzpMP9n1H+B8DwWEDtoXNuneLo6ZmBRitsCM=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SA1PR10MB7816.namprd10.prod.outlook.com (2603:10b6:806:3a3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.33; Tue, 25 Jul
 2023 12:01:30 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108%7]) with mapi id 15.20.6609.031; Tue, 25 Jul 2023
 12:01:29 +0000
Message-ID: <c1e8facb-9e40-5bfb-ea05-7ea5e31c537a@oracle.com>
Date:   Tue, 25 Jul 2023 13:01:24 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v3 9/9] ata: remove deprecated EH callbacks
Content-Language: en-US
To:     Niklas Cassel <nks@flawful.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sergey Shtylyov <s.shtylyov@omp.ru>
Cc:     Hannes Reinecke <hare@suse.com>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>,
        linux-doc@vger.kernel.org
References: <20230721163229.399676-1-nks@flawful.org>
 <20230721163229.399676-10-nks@flawful.org>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230721163229.399676-10-nks@flawful.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4PR07CA0003.eurprd07.prod.outlook.com
 (2603:10a6:205:1::16) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SA1PR10MB7816:EE_
X-MS-Office365-Filtering-Correlation-Id: 577933d3-f220-44a3-8bb5-08db8d06e14f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O7O2vuwsRl2k23knuNpZQS+8NB9Am0O/fd4UmvRZlGrQ5h/yqunbUa1tAJrkguroSUrpkI3l1tMxUsxXLrmg2BmopIOw7tSUD2ThgWcV2p9bLPyXrm812ncZeUJ0Nk9CZ0hfoEVSmzM4ZxOWQiI5/3znIrfinLFlADxaPfayGawVy87hqNW2fVntRcDdkdD0xaeQE76ETzn6t8uE0lPxxzixsQkKn2Phi+QmYGmjwif55f5Rc5+NkUwFKVHmC4Hk6gXrZWnnXgxU9MV2TJVIFOmUwjeVBY/MGzKrdTZDsUgzky4nekUK1OI77QXWakJeJ2QEocsJWW1ImJmsiqXbtPUDMHVN/0wEgxJqODsnIDIb9NDu32/XBYzGsE11ZvCp1XstA6jh8P30CDkmJG0krpaL58RVOWhoTqbYvlkDI89Nyl4mLQo+tGzeN4pfuncfwtYqfbPb3d0srk6LrhMgxXC+CEUCQneKs6m2ueRBQfXoNybcsHQ811TqL/pR+jw/5mdLaefwAdVb+oTmXoY6H6glXAaO+OsI5DaT+bJ9VZCgelSHQQtppDuOWZO4GpvZ7gJWuq3pa9l3AkS4yMidPCQhgxpkfAUEVahPWkOIDIut2GTopaHQxe4oWBEqN0sGfE9Gd6BI+VKy4UZc6vwepg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(396003)(39860400002)(136003)(376002)(451199021)(31686004)(38100700002)(31696002)(86362001)(36756003)(478600001)(54906003)(2616005)(110136005)(26005)(6506007)(53546011)(186003)(4326008)(66946007)(66556008)(316002)(41300700001)(8936002)(8676002)(66476007)(5660300002)(6666004)(36916002)(6512007)(2906002)(4744005)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aW5PT1UxV3JSc2J4SlFyL1BFRUZucmxKa3EvSmZITFEwMWwyYkF0VDdZeHdq?=
 =?utf-8?B?TlpROVIrWmVxaU1oV0NOck90VkVqY2FveUJOSlZ3dy9OVElpeWwyWm1Namxy?=
 =?utf-8?B?UWFpS0ZrZmlobmFrMWcyU0drRlFJNHRnUGdmV2dYZ0tBY0NBZlFIbXlnWnQr?=
 =?utf-8?B?SmN0UmtSMEpnQzVUT2g0b1dCK2dJby8zOWRBQmxqUmJySzhPQVN2OXlPWFpm?=
 =?utf-8?B?Q0FWZ3l5Y3c5RE10NXVkMmxuSnU2ejFCQlhRalg4dVByRjdPNkJKRlZzM3FU?=
 =?utf-8?B?Zll6NzYyOGxHK1FVc1JEWGhSeW5PUFZVOW00ekpFYzFPYnBSeFJudWg1NkZy?=
 =?utf-8?B?OGRNUWt2Y0FnQ1BwcndCUmVYYWlUQ0NtTDVPc2ZPcFMrNXoxNm5RSFpuYThj?=
 =?utf-8?B?Z1dDSGRhSzd5TW94NUZIc1N2RkxZYy84YWhVaGs5T2dYWG8vRnpJOWh6eUpt?=
 =?utf-8?B?a1ptRmhEcUdrbWtIMC9lcWJ4clhoVWNRQko1Sk1ETzE1RVkxb09BVUYvOXNu?=
 =?utf-8?B?QmJYenRIR1UwWW80ajRSekcyMkFRQ2RWazRlWm5FUkRZc3hnMHJJYmZiczhi?=
 =?utf-8?B?cTdsRVRXcXJtcjNiS3dqRVllelNCbUhWM0VHV0R5MGNzcGh0enNhVWZJL3Vv?=
 =?utf-8?B?a3RJWXlVMVVkOGxMVFlkQjdKYUxucTE1VUF0dkdOWHFsWUdRSGtSM0EwVHZH?=
 =?utf-8?B?TGUxNDdiNWVBSEx1a0RWTTA4NXJObW1RS2hNNHR3UjA1M29SSzhBWi82TVZI?=
 =?utf-8?B?YWZaWmdDaHVmOEdKQklVZ2dSL3VQZitMVTJaZ2pKaGxDRGo4TEZJdFh1OHNa?=
 =?utf-8?B?WEFueXpTblFBcTVlRDlUWGEvYzAxcG1mYlJiWnBxUWh2aG9nUm5IdzNPVVA0?=
 =?utf-8?B?UzF1NFc3Unc1QjcxQjgzS0M3OWM4TEpGYzlxNlNtZlpUVkpUa2FDNDhja3V2?=
 =?utf-8?B?UFBCem9US1FRR2JBRDR2bURoVWNoTFNUY01kRlVFRDd1QStzRWwyd0tRaGxC?=
 =?utf-8?B?dnl6VUltWUtOdUpxczIxOGtDRjFyamZWMDB6djFuaHcyWEt4K0FHeTdQWmxC?=
 =?utf-8?B?ZFpvSXNLYlZPTU1rUk9kTWU5SGVEWHBobkNZS09DRnV2UmpUS0hEdVdnMm5O?=
 =?utf-8?B?aWY1RmNiMUU3UDNIUXhydGRIL3p4S1pNcEkzWlJZWE1QUk5EbzRBZHEwMzho?=
 =?utf-8?B?OFVlQm1sb1BDRnc3MWN4VTdCWUw0K0xyaUY5akJBVkNHK3IzZm1ibW5QMlBZ?=
 =?utf-8?B?S3RxSVRDZGFwWWtpVlRBUkR0d2p6bEpzclFjSE1nUXorVlZLRXJPaVFFMGU3?=
 =?utf-8?B?ZThQWHBFQVpzL2FuWEJWWGhxMEYycFlPR2tLb2svbEMyZ2ZvNWJuNjNxNHVC?=
 =?utf-8?B?U2NWVzRaMHg1QUN0citNY0dhYU9xWlFlN2tPOHFaY0VKL0txQ3hXdHVoZmFr?=
 =?utf-8?B?VUYxaFFSRjROdWVOQXJRMkp5bSs3R0o1dlQ3d2pGWnlrRmJpYUE2NENOTURD?=
 =?utf-8?B?TmVFdUtTL2orc1dBWlFHM3JDRUxzZGJWYWdMRjZpMmRrL1VyZS80dzQzNCtz?=
 =?utf-8?B?SlRxR2p3cTBHejFISWZMdWVSdnQ1RkN4OVNMaXl0c1dscVZLR1BRSy9TdGJW?=
 =?utf-8?B?aU9jY0w0M0NmT2Jhb25FN0RHRVNVaVFOTDFOWHQ4RDF1QWZSZktuU01mMlhx?=
 =?utf-8?B?ZC9NTmlqbVpLTXo4dFFmMXA1SzRBZ2ptekg2VmUvUVRtVE9meXIvaFVQVXdh?=
 =?utf-8?B?RldaU1NsQStVcWRlNFA0UFJlNDFPSHRORFQxZHFpcEN2TWpXaXpLd0ZpWDFs?=
 =?utf-8?B?ZElmRndUQ3pxQXBjSUd6MFg0N0k1TnZqVDNqalFUQnF0TXBFNG1TQ2x5WURG?=
 =?utf-8?B?a056YSthbS82blhJTXR6ejE3aGJ6VWdoNEh0TVRmaW5BVndCNGwyUnYrcWFy?=
 =?utf-8?B?L3h4SUV1K21pTzNLTEJ0MmM4VkxQUjErekIwUnZVczdMUjZ6VEFqc3B6cUlK?=
 =?utf-8?B?WlNTMW40cGJkRTBaNUpIY3h0MXIyZlc0dFFBRXlabnkxeFpNTHVGdFZpR2dO?=
 =?utf-8?B?SnNFcjFxOHB3SnhQM3JtaHlXZjdPOWluOHRYbzNaVVgrVTdnNlk2VkRKblhk?=
 =?utf-8?B?N1VKaWtKQWtjWVNOT0VDejl6d0EyWGpNM0pXaGM1aDVueVJJNGEraXNRL1N3?=
 =?utf-8?B?OEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: fVYWCjjpN8xFcybEZsJqGsCUy6We4PddI2m+CMMTgDo8x8Sn2bOSQw3tuia0aeSYRsfHSLqiCyX7ZCflRW4ZqN5aXTIalcO1ZrW6TjZmJMeJCFT0uzq2KmQJCPC3EBwIgcXKDRH2qMpVytToefjEqLekm1BU1UcapIugfhWsKYJfW0R1UmAxWaY8qkeY/e9ci01RURikcRSIR9YvcAVvdC07sOWsNxUq/JrgW7nBiDuKJTemwa3dE5IXW0HAZFfOxpQHyvasTfdjRuorSr/BL/iF31gRdpbi3fGizEwivllCS3EqXja9P7HIt6Xvm16DKDQzrgRqlLNP80i7MNEQrngv4pJLShAmhqEr4i9jO0PDirW+cNwMVPN7dp6WcuGCk7kz/QpyTrAzhzL8FSWq4OlKwiKNMx94l0ha5aspu4tQ/kQX1JujN7z4VqyPB96HO++I3Wmy/U4ioTLbZ9G+5sNmLkN71jkGAQRqyW0X+PQSAFHVb0LiWQu/12+WSbluoOyBzzgEmXhr3V9n0iNa8RF1Kau07Qbkmz49FVrrHrt9mAsvc4udnwiutOZy7mip1PXUpqDCX4bFTMfmH5QCxUaivQNDVFoIvIbEMFT/fjAOgtWiinKoJj0h4RCd19Fl2/wbUwRKNReY7k8hKDjQt/56pJcYjA5Ql2o8upHo0SSp70GIpma/VWvW1Ilf6V3V2Ifrrhyo1kbGpMUGrI4A0rmssBWnQinPiAHOM3/wL58EfEu9cyQtB2xW7+38+J1lUiYJ+7ttbvHb+2xE34GFWe+fGiU4g2N4lDoKKFJVCLeIwDIkTAG8cobc9jMoGa2MQE6mW5LOAyz3kwOX04t6vi6tdFck+raUlDw1bcx75SnRtZXTUaESvr2kTzzUR5SRAwXZS9AQKOGmyzhBhndOi22mG5hBNSsRCL+DXhqAXf4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 577933d3-f220-44a3-8bb5-08db8d06e14f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2023 12:01:29.5474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RPFg9Mj7jiusWcQCWPNh+zW+PAnqBMSgNNfKzACABmu/Gbkml7n/hZLQm1fsnZsCtKKeqKpYuLna3v1rJ8ugqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7816
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-25_06,2023-07-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307250105
X-Proofpoint-GUID: N4t3kYh-m3m_ZBToYEHAVBcfT5-rUoGr
X-Proofpoint-ORIG-GUID: N4t3kYh-m3m_ZBToYEHAVBcfT5-rUoGr
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 21/07/2023 17:32, Niklas Cassel wrote:
> From: Niklas Cassel<niklas.cassel@wdc.com>
> 
> Now when all libata drivers have migrated to use the error_handler
> callback, remove the deprecated phy_reset and eng_timeout callbacks.
> 
> Also remove references to non-existent functions sata_phy_reset and
> ata_qc_timeout from Documentation/driver-api/libata.rst.
> 
> Signed-off-by: Niklas Cassel<niklas.cassel@wdc.com>

Reviewed-by: John Garry <john.g.garry@oracle.com>
