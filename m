Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DC4BC761A6
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Mar 2023 17:12:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbjC3RMY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Mar 2023 13:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbjC3RMU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Mar 2023 13:12:20 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B3E5199E
        for <linux-scsi@vger.kernel.org>; Thu, 30 Mar 2023 10:12:19 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32UEEc0E021616;
        Thu, 30 Mar 2023 17:12:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=bdoKpHt8qFe5wUen3JnnO9+jU9MpSZT7ngmnHcFkszA=;
 b=ElpIZf6bnzrcPsJnY0X1vivn8Bs3eVSQTyx2gwluIaXL9V9GBvUUY7fT5ZMvZfChp0EW
 8B7SuX8yOiztFwqMTXgnE8GNRNa6cWiCvyhRMBClvLBG+bjVh3vzF3N8J5dHVd+zvisX
 JNY7umjQvZQ5IxDodVKjK/b0Tw4qDpZQ1u4exT4MkV1uMfcxENMWYPVUa+h4GrK+At4N
 Bf1b/UeyI+2+RoNvsiD1Oq/Yrq0HgafrgaTcSQHMbiStIxhnJvS7mzvmgWuWYPceybkl
 RtZCiW8uGN22fBBlnaopyt6KBWeJUN2QxCdGMaXbnq2mh98PNINRUrobWTP9rRqo2GZh ZA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pmpc93fss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Mar 2023 17:12:16 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32UG8w2r010971;
        Thu, 30 Mar 2023 17:12:11 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3phqdg9h72-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Mar 2023 17:12:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mLE37MP0BOtJB3h0OC6r8rqpMT6STL2+E1kGMoj2eKBodQDGVTe/IEhCvrOsbdQWD7NO4qz+/7/FtGyty+m2okbvoyf6ahBEnRHGAskfbOak2Dyxp8PbZCD3aKKi3uF9yOJRW7M6DOb652akqCBlqrQnVdT0DqiG1Ka4rPuFuYu7lkd4r+hlitIvPFpH804oRgx2fKxTGabRojgnUExSHBNWWakQ5/Tu9jHxveOH0fdXJOXBdS8L76CPat7LuYRtr9E6tVISTni31K6ZLnfoRn0DYUiGlmHpHRrf5bpZpJ7zEawPq1vV7EC36+S8ryy2/4gqG0fJ0iaUDwGV3xq+6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bdoKpHt8qFe5wUen3JnnO9+jU9MpSZT7ngmnHcFkszA=;
 b=DPjULQXb9vGgQfiKyxh5X1qIRFOvjkZvUzIm7LAKCHOhA3BHC5m9KU+llRgytLxctEi3euXxeE7O9DRHea19WgthTesQ8FdFVIW813V9FGOt2ounrAxvgtWXkaS4gRQ9vzHQ1rU3LrU3RVG4JcAhKDEN+n/yUvIZazE7QZOTufhLpixpO6caxp3ifI9jhJJUTC+SZFwLbw40+SNlbqv7ikE2LBQMsT/RjJcHCH3dPXF75JgSkQjs6ovyMd2TMG7rgT17Xg+IUaThlV5EE08RJCPsu67kxxStwfkY3Ix+wxrd++V1ylV2n/AVCrNBaNeYoRmotV0kptg0zaYO7U0uXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bdoKpHt8qFe5wUen3JnnO9+jU9MpSZT7ngmnHcFkszA=;
 b=nalCIBtzOOYLJTE0amI1CfWfpN8Vm70nKeqUXXwpu+PdaT5RU5+yG5VSlwLsAtf1ZCn8S6I/L/sHrUvAzqY8a0ICBd0zUZVff/BQFwtFWaP3QE6KOD8B7v50mlrrX4qDrE2f16zQjSR3CeD0NAduYrpuJpFtnSHLQmuPPec/xrc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 30 Mar
 2023 17:12:08 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::dcf6:889b:21f3:7425]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::dcf6:889b:21f3:7425%6]) with mapi id 15.20.6222.035; Thu, 30 Mar 2023
 17:12:08 +0000
Message-ID: <af17886b-5b18-f71f-9fe7-ea929f30b5a6@oracle.com>
Date:   Thu, 30 Mar 2023 12:12:07 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] scsi: sd: mark the scsi device in shutdown as deleted
To:     Tomas Henzl <thenzl@redhat.com>, linux-scsi@vger.kernel.org
References: <20230330164943.11607-1-thenzl@redhat.com>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230330164943.11607-1-thenzl@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0169.namprd03.prod.outlook.com
 (2603:10b6:5:3b2::24) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SJ0PR10MB5834:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c889aab-df64-41f2-6da1-08db3141e4d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 59x1HZiPQ0icDJUpPvQpG+ej5dssyqNIMR6dS1HnhH1eMiI2o2KdW25f9OFk/7lfaG422aeDhQADIomnIa7kugWN7IJ2wC4R7MStWwgLyyrTwUp3LJYZZ6vFK9kIhw8keCNAyGv6X7I3xqBkr/3ZVk5mw8r/MHSZT1rlB7zwKlXlGG19V5v7Winh+NnmbWBlzu/EiD0/tyzomyIYqiVIzV1H42Ro5xY1PNhwwvgO55Q3Vk1r8XSfzcQNOFdaxtJnuy+PxGs/0pNI34+FNmxzCm9mDwCxAtWTK0mt4t/mpwjRbc3UBJOkS13h2wxMh5ry4GsuHSsXzzCM6nyHZSiRoBd8PS6K5Xr+EZ8UgweG5vWDhGKYEh/7zTHbiKqPL9W8ShwmikmXvVG8A3hlNWseMtjKAlJqKnHhV91XovUzNnVN+x7HfInw6jj0hUjOSycC4jotmxXu9bhfjwyifhisMCS+lxaTrNkJbbA0m264YzBtxB8kLowYy5Jgd9KwOQgCgqj/z4fqP4akqQuMAHCotsUSarf19w5pHtd76izXg57bVJLPAJMggl79RNgBHaMs7rvbd3sWuZIWN4DC6yh6ti0KA7nuILkZGguPc5G04gYNzTZ7h9mn9l/uhk9nJrCB126r1p3k+TePErDLUcYdAQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(396003)(136003)(366004)(346002)(451199021)(6506007)(6512007)(316002)(2906002)(8936002)(66476007)(31686004)(186003)(26005)(5660300002)(478600001)(8676002)(6486002)(86362001)(41300700001)(38100700002)(2616005)(36756003)(66556008)(31696002)(83380400001)(53546011)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dWRleC9Xa2hLOERReGoxK2lFb0ZUVit5bEEvUjhkdFMzbys3Q2l6UW1idWk1?=
 =?utf-8?B?MFZWOE44RE9RbmtsbFJVU0hzS3NIYUdmREoxQ0wxM0ZDejUyTDJYZ08xT3Ro?=
 =?utf-8?B?eHl1VGhwbHZaUnlBNTJuSmdQMTlVRlFGZzhxR1VlV1lWbW9mZTVwZzQyKy9o?=
 =?utf-8?B?aE03UWlNcWVyTk9VSVBiOFgxTjYybzdEclZUOXJnQlFjdkF5SDJ2WHpROEtM?=
 =?utf-8?B?THpwZkFZRlAxWW1mbUdZNTRZanY2RGZWOWdtYmFyRnR6NkRmWSszMldYK0Vl?=
 =?utf-8?B?elVIZUM0d3VEcHQxNEg2dlFHM0FJYzd3QUpCblBja3VzRFQ5NzZoa09sSk4v?=
 =?utf-8?B?SWRmaUFadFZpaFA4OEloYSt4WS9oYVhMRzdpSDhlOXFVUHdIK3U0VUZzR2tm?=
 =?utf-8?B?YjR4UnJBc3MyVEJxeitZeithM1VPWS9KczgrcXMvckFnMHdYOWpXUjNjK05Q?=
 =?utf-8?B?L1poc2dLZjRUNE9lY1N0dHNXblVxaWRUVXJiWGpNNXhsRzFTbE0vR3V0d0NV?=
 =?utf-8?B?SlIvcklwUWNseVhVN2ROOXZLcktiekVMKzZPSUlibElhM0lzS0NaZ2pRdFdp?=
 =?utf-8?B?ZUNWWkluWlA3QWFRd2hLQXpLVWhJOGpGeitWTzgwbFhYSys1T1pqeTMrSlRm?=
 =?utf-8?B?MmQvZ1l1aG1JK2Q5ZSsyT1BvcUtLRXVEZzVjVmRyZFdFUHBJTitINDZJbDlv?=
 =?utf-8?B?cVFJRFladkdhQ0luUUJiTGtnNTJseDZUeGx3Q2U0cEJUNlpzaERvZUE3MVNG?=
 =?utf-8?B?K1RQb2Z0bE1LaU8rSUZyNWdYd0ptSUJwTkxTVURwcXY0a1NGZHA5QjFmMUhN?=
 =?utf-8?B?azhwazdISVhzNUVsNTlUdWplQ29uV01EdExXc3krM3BXMEJXY3R3WDFnWGdC?=
 =?utf-8?B?bWR5a2JGM3M0clBkREdMa09ZOThmbGIxUjRRLzQrTGlkbVJmdncwN1NUV2VN?=
 =?utf-8?B?M0VVTzJLckw5b2wrOGp1UkFnZnA0bWx6MENod0g2TnBoVWI0MWZna0sxSzFz?=
 =?utf-8?B?QjdLck9BQ0JSWC9qSjlTTUdXWUZRV0R4WVR2a2F5MkRsNG1jck83dlJiUXhG?=
 =?utf-8?B?SXhOSW0weG1KanozcjdWSTJXSERHcWxUNnBjbGZmTzloenIyV1R2bVVzRzgw?=
 =?utf-8?B?Mi9CaVR0V0U2ZC9PdnVJUEtOMXphNkg5U1huOTFvb1hyZHNUeVQ2UFhMSkFQ?=
 =?utf-8?B?NUtuMktTVlZRb01TLzh2OWprSEpOZE05eWEwbW5xOGFFT3JGSWxGcHU4bUxH?=
 =?utf-8?B?SFdyU20rVkxZOFk5V2ZEaHVrbnJHK3pES0xnWUFZZWxrelpPL1ZkcWREM1B5?=
 =?utf-8?B?TU9wVTcrMzNJam95K2JTYkJGRStUTHRranFDZDY2SklCN0tCeDNvRmxnN1M5?=
 =?utf-8?B?dGxTcWFHUENQQUp6dmFRRHNiSjlEUW8yOEN0bmdnQmZ3RzZuM0NCZUpMRmhn?=
 =?utf-8?B?Q3BjYmlka0Z4cDc5Y2R2dnRzZGpOZ2VqQk01Vk04bDV4ak13VzJZa2tBV2lO?=
 =?utf-8?B?dHVmL2JwQzEwOUU1RHJRWDJDRzVNS2Y1dlEwMW5zWUFpN2ZTUFNFV1QxK21x?=
 =?utf-8?B?L0hGajY0RDd0MGkyT0tZMjVSM0hzZW1YVnlrbGNyMXVNVmlCU0RiMGNXUVFh?=
 =?utf-8?B?T0NCVEc0ZFAydE9mQ0toR002b0pHTHRoQmE4MWZ5VEtucWl2eFZkbTZUSjRN?=
 =?utf-8?B?N0llOWk5VThqQnA2L0VFd29vT251RjNPb3crcThJdVh6emQvWDhrQ2VjKzlI?=
 =?utf-8?B?ajFVcEI4SGdxSDNYcnhLMWNPS2pLODByUWt1LzhBMW9oM3VxK0Jwb1NTZDZq?=
 =?utf-8?B?Zk1rei94bTE5WkdpQlI1cnl0WDR6RHBmWTJNUGRBb0JNczdjUkQwLysrelcx?=
 =?utf-8?B?ZmREZUNDOUJFUEIvYWpZRWpqYjhsQUxMK1k1dE83T2Fnd3lwTEpZbk5CK2dE?=
 =?utf-8?B?bDZiVlVvMjVTbDViWFljajR6WEYrNm9qVDk4eHVDWGxZWjJyVnoyd1BGYjZJ?=
 =?utf-8?B?ckI1cUgrWlArODRwUUQ3RUVDSUlMd21ReWF3SW0zeXNqMlFhZHVGK29BVmtv?=
 =?utf-8?B?VzdIb0YrQUN0NTdOY3FjNXcwOEprNEZ0Mk1KVFNnNjdlazlXS3VKWHNwTHRx?=
 =?utf-8?B?MEJOOEtUd0w3aGlFN1ZoR3ZLamRIaStVZnRyL09SQ2R2akJPM3ZDb0dNbkNG?=
 =?utf-8?B?dmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: NtVaifn42lty/5fRlaUF4BYdlM5kJLUATFRrqtLP7sRt5EyZ9Lqw4l+4NycSKJgtJnhxfyUOBlf7O6T1UL1T5YaTbVX2LyrQhorXUIunF8LRYxsJ4GAwJL6Re6Bzlw+uN7wu4dwEYOctTS03+Iv+9kzzJFYylowm9Bdft29kghnmuvUjotQO+q8nDt2ACozyVPPbb7OewnRbtEYYq2jDBKDhq0xtNGNmixzCOSq6tK+9D4ad/nTY42J8H6XCQFLY68/m5xMAimH4fzjPq99pdB+9W+D74mUwRqXho9xWjuvv5Eown+cltMVD4uHVAs+IhgucX06FTvNqv3OlN0cCNxs1/6gaSl19LNPWdlHNCVgJgbnx0esNIUfBoz/2QsttIBepcuMA+R/1Sc/u30MdzP8cnK8JJWppFHI1Ss1V2LXjTpI6+oAAffteRuoU7wDuw3qcULeMdtZes9IfNnP7hLvQlFz6A7Ibvr6qs4g72p0prFpeJDrsNdestw3Q25UOOKo1bLIIW03uJKDD4ISeXrHLuK3YW4LVS9kwP1uWDhYbBRqjR6Dgj+bQA4OhiqL28MPfFtE4w1vlA7wv4Hf+3Skevh4eUW6TEzTMjZx2dlciFQOwFl8TqapX+7l9t/ilzz6rV8U4UQXdXkFrBhJp1cbpP8ZT44+Tj4fYIs5FCFZbtmiR6IUZ0O3WLuLtBmRu/riK+BZbjYDh6GuYGNmKlxmhSdiAVP0vFDPcBSFbNT5GAF1B2A2G+7lmLms60pL2dtsZQTOqDp/rXi3wZ1b8oGqJ9OD/Y49nshkLXsC1brk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c889aab-df64-41f2-6da1-08db3141e4d1
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 17:12:08.6299
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yXJBtneIN4yhmNDSyy7rNlQcUvtElmCXR0bi8TSTys6YbUOy6ga8Kh6HI8LalJ4TlPSiNFcZeDrBvebzPn0ERO2yGCay+KQXuE+K5j13AWA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5834
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-30_10,2023-03-30_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303300136
X-Proofpoint-GUID: n0bvFsg0wJMAC2jwrOSlo0DgyQ7Vpq01
X-Proofpoint-ORIG-GUID: n0bvFsg0wJMAC2jwrOSlo0DgyQ7Vpq01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/30/23 11:49 AM, Tomas Henzl wrote:
> Set the state to deleted in sd_shutdown so that the attached LLD
> doesn't receive new I/O (can happen when in kexec) later after
> LLD's shutdown function has been called.
> 
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> ---
>  drivers/scsi/sd.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 4f28dd617eca..8095f0302e66 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3694,10 +3694,13 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
>  static void sd_shutdown(struct device *dev)
>  {
>  	struct scsi_disk *sdkp = dev_get_drvdata(dev);
> +	struct scsi_device *sdp;
>  
>  	if (!sdkp)
>  		return;         /* this can happen */
>  
> +	sdp = sdkp->device;
> +
>  	if (pm_runtime_suspended(dev))
>  		return;
>  
> @@ -3710,6 +3713,10 @@ static void sd_shutdown(struct device *dev)
>  		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
>  		sd_start_stop_device(sdkp, 0);
>  	}
> +
> +	mutex_lock(&sdp->state_mutex);
> +	scsi_device_set_state(sdp, SDEV_DEL);
> +	mutex_unlock(&sdp->state_mutex);
>  }

If this is run for device removal what state will be in here?

Are we going to do:
1. __scsi_remove_device sets the state to SDEV_CANCEL at the beginning
of the function
2. device_unregister causes sd_remove to be called and sd_shutdown sets
the state to SDEV_DEL
3. then __scsi_remove_device sets the state to SDEV_DEL at the bottom,
so we get "Illegal state transition" errors printed.

