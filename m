Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D911DC04A94
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Aug 2023 19:53:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbjHBTxB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Aug 2023 15:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231788AbjHBTw3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Aug 2023 15:52:29 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A09E5C
        for <linux-scsi@vger.kernel.org>; Wed,  2 Aug 2023 12:52:28 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 372HJAxH002372;
        Wed, 2 Aug 2023 19:52:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=guy0K8aiR6eORSmKhucEuIl21Yz1d4+47t1PmeJG+Wk=;
 b=doKWMHJFK4qVsDNj/kHj9vg1YLuhpdW77qIfQWVVPvrPGW7X+PkZRiJjzr1sXfYxobz4
 TanQYXz5pgnK8EHnJ5bz/hDt4CqUGBo0WBJcmeOT1swAKLvT4MU3W/h5k1aC43Xs2UQy
 pXPZAqpDpv8Ohrv9yGMDXDFInLVhr691rG7rKFROs+OxEfCuvwjD80pHmTFqSo619g/6
 SJrxF2sz7rxba//K0bnFSACUS6n3q/ZKfjQzzj6PQ+BJCs6aWnmh866ytXzlERTnvs1t
 2BfljKyHrc3/g4zXJxO1lcS1lPm/dn/+TUvaxYcaFZZUlPvxpmst7Y0oEK20v3MoM/8J YQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s4uav04ks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Aug 2023 19:52:26 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 372IOh5u004002;
        Wed, 2 Aug 2023 19:52:25 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2043.outbound.protection.outlook.com [104.47.74.43])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s4s7ee5ww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Aug 2023 19:52:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CX/CJPjuLD8ajbBq4KlMhfsPC5xy1bkWRp/aHEjJPXt9AKXJTpbhBK1mOi8DG31rstsxzluljEbJvEILXukBxtrBjQiENeldvlBCuy9eN44R9+angAl1/m34HWb/mKMyrKJ9HpUsnR5CUafhn7uD6f0m9Ts4saGRfH2G1oyeh+NPjX72rV2dR5MwuHxi6ZlLflF4Tt7npn+knULaQxoOIOiUHhev40dae+Fsktyp3GtwtFyGuJmw8fpUL0CeYiuWpVpbGnPN0f3keFNZVQa0jYeFSwaOCp2ka6kpSVeFSXe2iZh8hjBpkXaKU77uTusQApp4x8p22Fc3mAq0qIqFFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=guy0K8aiR6eORSmKhucEuIl21Yz1d4+47t1PmeJG+Wk=;
 b=HyBTHLB76cWgKHFZ8dDBMXaggoYxBFR2+AMdUc14N2FifBFVj6OaDqF8OpCcBaOh0hSGd1ZCSRFej3fW5u6sSbxNbzNuyG9eEsZSV1wPlGIno3IWjfACnAOflvP3IbX1xPLgy8AiweT1MQtzB51tveqHu5YZ8Oo1R026KUyUXrpybhCWFh22kt4Lhj/5e37YO7HEtgLle2sTWn2D9fQVyJIjcu4onfEaxaEOIHfc1XpCRTw27iCOOQs7d+/bxOvJW3JZtqAKuC0ovAc63priieCiULqlIdVArXryVesIXAuqf/n5q1oD7Y2ZFCkCd+lOJ+VTvyH867WA105175O+Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=guy0K8aiR6eORSmKhucEuIl21Yz1d4+47t1PmeJG+Wk=;
 b=gAFb1yJPe4ccx1Y3ju+58qaG0sCVRsI2E3KCQY8hnBQiS+XfEWjmsYMWAMbccadvLhGsDk6Y8rXR9evtDRj6r3X32baeCqu98yMWYmpHclf2AfQnczzZ1i1MMVOAS6CVQuLCrvLuRHJgwBi4BmnK1Q/aLc45ZpQccnUAIcQdHGE=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA1PR10MB7830.namprd10.prod.outlook.com (2603:10b6:806:3b1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.45; Wed, 2 Aug
 2023 19:52:23 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::31b3:ba23:4678:9f5f]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::31b3:ba23:4678:9f5f%7]) with mapi id 15.20.6631.045; Wed, 2 Aug 2023
 19:52:23 +0000
Message-ID: <893cf6b8-6a56-866f-6aa5-1347f6f71a43@oracle.com>
Date:   Wed, 2 Aug 2023 12:52:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 04/10] qla2xxx: Add logs for SFP temperature monitoring
Content-Language: en-US
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        agurumurthy@marvell.com, sdeodhar@marvell.com
References: <20230801114057.27039-1-njavali@marvell.com>
 <20230801114057.27039-5-njavali@marvell.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <20230801114057.27039-5-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR06CA0013.namprd06.prod.outlook.com
 (2603:10b6:5:120::26) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2943:EE_|SA1PR10MB7830:EE_
X-MS-Office365-Filtering-Correlation-Id: 617f469b-e815-42a9-ac03-08db9391fd57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +umhuOy1lfpjViwWgsnotAvlSJ+4WMcnKxHfav/zFqodmmLepw58mVzp7gUmFJ1HQSbKI93IeJlgc5hkrmgSm66j+n/bcdj1Hh5RWArQucK2ko/tFg13VEbGak88JnIrcNGfUOj6HInWKbYto65YLu4G1lFnbQ3gwNvCXURFGHqDLCX/ZTfYCp0aIpAVMUJPO7NMWExItUl+cv6UYiv4Mv0q9hOltjlsG3ZS2j5wnCo2S3wgkWBjQp3EHlJPm/G4zu63CZYf8v+w82bK91UPpAHBUTg6xFgqwFe8UzhW4rNwLIbqSotgfUXoZuztFeP+w8T49fn6XhcFD0FKjEl6EZz7P+2t6QbiHWUkZ52liQIR5tmAILWIMoNAkf1mZ/RHFqd3QcNPVM5iFNlOHkSS5E8Qk8lIgDnFdqMZTtGG1pcptOlWcm/sGhKAPH4QoSYTs9Z0Dl3ovzYckRWirm/GjmvbacGwVMPTpMOUdwImsgwnqILlyu8+fsAtufnz6OJkeyxYhwz9k+/gNiOI4o+Hw/1/XslJFCYcLLaZ7P/8vhW5MKq4TVYB5X1Tj+F1GY2IgLNHWDktNrnTMQyiGaF//RQLDEu33M6AFcoG9m/Mu5frcC5lga57Fj3lhpOQcSewcMuULo21awMKJb64NuZ2hw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(346002)(39860400002)(136003)(366004)(451199021)(36756003)(86362001)(31696002)(478600001)(6512007)(36916002)(6486002)(8676002)(8936002)(41300700001)(316002)(31686004)(5660300002)(6636002)(44832011)(4326008)(66476007)(66556008)(83380400001)(38100700002)(66946007)(2616005)(186003)(6506007)(2906002)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UG8yZ1AxMUNDWHMrM0xNSUR0dTJDM2grVUt4QlE0cm1VbHlLSmZiaSszYlF3?=
 =?utf-8?B?K3EyNVpNQ2s5ZkNBREduRzNvQURBb1JCcVdqWkIvWk1zb256Rk9ZZS9lTWFV?=
 =?utf-8?B?TFdJN1B6ME9PMWRqNW14SUJFa3RHa1RNa05LMHFzalljYmdNVkZZWXFYRURv?=
 =?utf-8?B?cFRVVzBsWnNrWnZhMmVEVHJldUhXeWVlOTFJMkgvbXBieC9IWVlxU1VJeVZX?=
 =?utf-8?B?aW90ajJITFd5YWxzRzBENkVOdG9MU2pEaWNialB3Y0JVVTZ1R0ZuVXVZdnJJ?=
 =?utf-8?B?WmFNeG0yMnhSTXlaRzNBVXVyUlFpS0EyTDZMVnlVcUxjUUo4bGI4T0Izbnha?=
 =?utf-8?B?YnMxQlAveEtWZGh2K0FpQ3dmY0x2Y3dPd0pDLzVRM1Z2dzV6Z0FEeUxER0pE?=
 =?utf-8?B?T0hndm5rNFNna0w4NjJVY1BJSlh0ZUhuYzFRbXM1Snk4SjVKVmV6aHZ0dUxM?=
 =?utf-8?B?ekhjc1hielBQNjNHNGdIa25pRjB6UmFoKzhUeFU5VmFsWTNkRjVvOFlkUjZN?=
 =?utf-8?B?ZlA3MUhvZWVTaFg3T00xZDBaL3QvZ1lhTXM5UUtQdDMyUDdadk5MRzFQdjJW?=
 =?utf-8?B?WGp5WFV5bnpVTGRqbXFDZHA2Y28yMlp4T0JMWkNUN1RmczhrbSs3SDdpcWpU?=
 =?utf-8?B?WXJsMlNlRXJjRFd0ZFp4OWp2NHRKWlI3QkZ2YjlvQlE3UFBvNnRoUWk2bEJs?=
 =?utf-8?B?Q2xocXd2RGE5bENrNkF2Zmxhd2R1STF4akJodWxtLzV1NzlLZjNVeDBHcHd0?=
 =?utf-8?B?QzdReXJodkpESGhsSTNMUTZ0UlNtSjlIWkZ3ZVNzd1BDLzRuMDJFNzU5ajJy?=
 =?utf-8?B?N1U2SjE5YnBSVnM1eDR5WjlXZ1JYckZON1dxdk96WnpGMzFEY2x4SWI2amlZ?=
 =?utf-8?B?aU52UHZ3T3J1bzFuMk5jYWVWamF2NUxIMzhIUXVuRWlFVTZEMlVrZFl1aXdm?=
 =?utf-8?B?NDVvNWdpU3gyQTRPOWhndDdOTlJ5TlQ4VmZUZGVoZC8ycDR5ZTZoWU1HUGlR?=
 =?utf-8?B?aG82WVQ0KzZkb2NGclFHb1g5dEhhMGRlUFhwOU1qdFRjSHdoN0dPYzBqMy9w?=
 =?utf-8?B?MkNYVHdkSzNlUzlXNU5tYkdVb1VWeGhEd2tXaDVoejRiblMxRTVRemhwZTl3?=
 =?utf-8?B?Y0U4eWU3Q2RST2N3VjlEMklXVE8wVXd6V2taNVhBbnJ2dlhnNDhyd2tXNTJG?=
 =?utf-8?B?SjBLUlJUQ3dQREF1OGpLbHRzT0J4bC9DbGxjcDJqbm1lak54U05SZ0pRRENs?=
 =?utf-8?B?b25YanNGZHNYN1NVbDBVbDU3VHQ3S1B2TlBmOXRwSDBCRWFSL0hUSysvWGE4?=
 =?utf-8?B?V1k2MXJLNEhNcHVYR1QxMjArR0pUK0hyd1Q3b1RtbTVnY3B1Q2lzUVdrT0Rk?=
 =?utf-8?B?YklBQUJmZFpjdFJ5N2hlM1V0R1VFQ3ZuZ3Q1dDNHVVlrenVXdzhyb2JvSjlG?=
 =?utf-8?B?SE9aWlF1dktJUFlRWFBYL0g5WFlxNG5CdCtoMTcxZExUVStkRzNHbVJwMzhv?=
 =?utf-8?B?My9zVmVrU1FWbEJ1SU9vUkN6VUFMbXRDNXU4TC9ZWnJzRnQ3Y2hXNUhnR20r?=
 =?utf-8?B?ZzdlaHpmclI0NlowT2NQVFBtM1NtaDc1QW16anJCeFpPTnVVTGgxcFdFOVFW?=
 =?utf-8?B?dXJEM0NUUEEycmlqUlQ1M0sxUkxOeWV2WDhpeTVNb0orT2dYQzBqRU9yQzdn?=
 =?utf-8?B?WnUxRExWbGNUd0lHTWNZdW9vSC9zbml2a2tsSWRQZDJxTDk2ZjVmNUszbTB1?=
 =?utf-8?B?bHlDbjVOaFlFc2hmNWRpNnBucW9JallSWkZSUFNLa2FpbXNER3dzeGpOUVNS?=
 =?utf-8?B?R0J0dWRpNWhiRjAzZlkyTnZvbEF3Qi9MbmtPZThUU1FkVE1pTC9VdExZWTZU?=
 =?utf-8?B?RU9keHlYSmFKb1FiVGJEb2ZyUmIxOW1PcjVpd3lHcVhiUWthNUFQcDlySSsz?=
 =?utf-8?B?UFdCSmEyVFpRVUY0R3drSWVBK1BwR09VVkh3YkZiK2dySnM3bHZZMzVEeHYz?=
 =?utf-8?B?K3UxM0swZUk0cEU3aFgrUzI1WVZPUFdWaHBJcmtwaVEvYnlRelh1eElDcTZn?=
 =?utf-8?B?amk0V0UrbkpPSDRHM3lLMzBwb2lBZEJkMzV5U1pFSS9QTUwwcko5TUFxSFNr?=
 =?utf-8?B?cVZVeFJHcmZYWmxJd2NRMkJ0UVFkYXFhR0pHRm1DemRTMDdmTklhMzNtdWUv?=
 =?utf-8?Q?7I0hTllLOTVi8zbg6qx8yY4=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 7VGvqTC26S9MB35ljeKs/bsInaKbU8wUrAFymzIbPCCmPCuv7frGJJRUs8UujGhQzEg2+7+FjNFN3oHXYLsib8FR5ywQeTLVg6UYI88MjEpMEvapGB/orQT9FYhRd2tgRh9StaPYm/YCGj+UAu3VJBkGEuhf+4jO185TflqC24H/aBkEHazRfHaUu9LqnUzELcKGkr7qTdYL6AyWRj5ky71b2EjQ5xvFMoSUt3/51MHr+n2fC6XqXLp1RxByhS3ka4Bb+VruveKmLmKc+MZb7YvWgHVknMHFrnIMJkD0mYvgg5tZC0f8Q1q2FqRlVGSl0Yx5Bp6aILgQN1EGDNMFCry8TznjgKAgXoUJ46pfEWFIRHJO9v2bHOV8RsZu95xc0sAZNSov4BekzXHXQtX0yDSE2LLoi75CbSDmrJONiUA4/PeNGc0Yt15rx+D3z6JgbVv6yME2SUVefqQgQrBMzgA0Ev95g2RZQIItNeZ93Q/2xO80OMUK05g1yeLJkZLNIpzbihCXQecrdYuVz1fMtpoYziR7McFV28alPoHsY12wrDJJUy4UXxZbsY7CqANvvNsBMvuH9/yYKyHzIDjnJhsX/kmyKsf/8C/zzu6slzdrPGoH5SNHc4sZudfxanvL/MDQ+zgBzPWp0hUQV0eAzKr7b4raswyV9ycsSzHO4SGkIbq3CYyWo/3neCMQGg7pnu72GTp/vJIj/RWt+6bB6gdpf/B2OOXHHW8viQKRL2wzerBImg9conXz8FZyBrqfxuFFpxiaIncueQ25uMFZvTAMc51uFTjv9YWIgNtMcpQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 617f469b-e815-42a9-ac03-08db9391fd57
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2023 19:52:23.5183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KLS2lfnPD5g/gvHgk8qdJs0JmpP3GlIAF9gWlDESCy0UbvVuDdthjUasKSXEmm8kXxDprGYaZJat20aVV9AP38TB5taX4smKHoXAbWbV2e8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7830
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-02_16,2023-08-01_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308020174
X-Proofpoint-ORIG-GUID: uAfKoZni1MAXKHlLbrXL8ub6jpJNsJGl
X-Proofpoint-GUID: uAfKoZni1MAXKHlLbrXL8ub6jpJNsJGl
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/1/23 04:40, Nilesh Javali wrote:
> From: Bikash Hazarika <bhazarika@marvell.com>
> 
> Add logs for SFP Temperature Alert async event to
> check if laser is enabled/disabled.
> 
> Signed-off-by: Bikash Hazarika <bhazarika@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_isr.c | 18 ++++++++++++++++++
>   1 file changed, 18 insertions(+)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index 867025c89909..e98788191897 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -56,6 +56,22 @@ const char *const port_state_str[] = {
>   	[FCS_ONLINE]		= "ONLINE"
>   };
>   
> +#define SFP_DISABLE_LASER_INITIATED    0x15  /* Sub code of 8070 AEN */
> +#define SFP_ENABLE_LASER_INITIATED     0x16  /* Sub code of 8070 AEN */
> +
> +static inline void display_Laser_info(scsi_qla_host_t *vha,
> +				      u16 mb1, u16 mb2, u16 mb3) {
> +
> +	if (mb1 == SFP_DISABLE_LASER_INITIATED)
> +		ql_log(ql_log_warn, vha, 0xf0a2,
> +		       "SFP temperature (%d C) reached/exceeded the threshold (%d C). Laser is disabled.\n",
> +		       mb3, mb2);
> +	if (mb1 == SFP_ENABLE_LASER_INITIATED)
> +		ql_log(ql_log_warn, vha, 0xf0a3,
> +		       "SFP temperature (%d C) reached normal operating level. Laser is enabled.\n",
> +		       mb3);
> +}
> +
>   static void
>   qla24xx_process_abts(struct scsi_qla_host *vha, struct purex_item *pkt)
>   {
> @@ -1927,6 +1943,8 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
>   		break;
>   
>   	case MBA_TEMPERATURE_ALERT:
> +		if (IS_QLA27XX(ha) || IS_QLA28XX(ha))
> +			display_Laser_info(vha, mb[1], mb[2], mb[3]);
>   		ql_dbg(ql_dbg_async, vha, 0x505e,
>   		    "TEMPERATURE ALERT: %04x %04x %04x\n", mb[1], mb[2], mb[3]);
>   		break;

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering

