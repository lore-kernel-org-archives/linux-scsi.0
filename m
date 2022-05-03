Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B902C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 20:04:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235141AbiECUIa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 16:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbiECUI2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 16:08:28 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F5F8403CE
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 13:04:55 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 243HOXDj024988;
        Tue, 3 May 2022 20:04:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=BLX+j9v6bPN04fTv6CgwQVIsJu7UEY4vQhI2farC/iA=;
 b=eMtjB8l72cVtCSNpZoboFlWzbPbDB9OcgSFtpNqPwMVQlKN/SW472l2d6LMua9nxGvst
 j95w9j6SR78Si/MuyXJnbQeImybsMVZXDRfHgJHs8LASgAeDoJiw3Z41CTYAn/GEYImM
 Pm+/VHi4PJPn82L95SELnk/iOAnoFmJwTUFsSmX6Oz6wKoOM2F5SUHeLWBge7TKn54Hx
 f2oXU3W2HyW9cW+wdORxIk8bf4b0efDJbvglaO22co4QuY/VUSHoLdkgfO6AwT/r1RHr
 cFGfZ6/dow8Cardt7o2xdF/ko47WWbIOh/jZ8yoAxLrzKgF6gjhbi14gubftON4bS2n0 tg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fruw2eqjc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 20:04:47 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 243JinNw014590;
        Tue, 3 May 2022 20:04:46 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fruj2q51y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 20:04:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hEubIZT7sfMxdR5YFeXX6ODYs0XrwPIe1RWfexJoqu1dDPS9ILOz/yuF69hi1Y81sw2jmm1on9zy5JprX6yzdsrr7zsutC+ZYTieXQoJvaL13umlwvVPawpuDqIPS7S2JzgTJIUozEx2iUTHdvU8O85YyMYHMzPncW8ybpwWDPyF8JnAn1OY3QedodXKhcz/32P+zPW6wy0BbSazwJm0Zpz+7XOr2gq/4UGXOkqOdwtQu1JRyCgWEUrU63l94p8S2xQWoN9I/69Q/nXJGEwc3bRD9QNzE1MrKOPUTDwqlipLnshfiUSIeBgid5yIa6FgBybt5Neh73qJKIrPFrarCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BLX+j9v6bPN04fTv6CgwQVIsJu7UEY4vQhI2farC/iA=;
 b=TBHD+G5a/EvloeBmLku+awU8qYViSMxEc2Ygvp/UB79GvMwxftHq7uCLHJZSdFXlk0nzQxPxFjf2pHT8FfJsQ5uedZl7rbwE75HEutvTj9dJni6QttcDjzH+5Gvxgdv+djAgOL1MBzrYgLH+Xn91MyqVaFiU7j1hEG+Op0KOWykkjvlmXtVsIRfo4zfX1wF2s9Nnib2Q4+QoV8X/FFV/+xeKt1faQD4cDLb9Bf01TWIknlSBaJAK3gnzdRI376xpFqGdo0tTeD8kVr1Wg2Sx8td3d9xnRxwY2ZmDfZU/KF1fZOITuGbXrJNAPbm0NWsLefhkLz//RsibxLacYXNOIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BLX+j9v6bPN04fTv6CgwQVIsJu7UEY4vQhI2farC/iA=;
 b=XTlKeDdPzAYDFUWZBzFDQpmbngejQiZbLIcmbq0u8xSSJSgOC5CVvo6kdMiTOBlE+zRocjelOIAC+Up7ClihEU8hxtBV7XWPm0WGQpvQXibIMoiJO5yVr/SoPFBfjX4U+V+GvsRAIM4n57u5rBrCQz1ORSIp3MlwTIIE4gV9ddE=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB3993.namprd10.prod.outlook.com (2603:10b6:5:1f6::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5206.24; Tue, 3 May 2022 20:04:44 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3cb2:a04:baff:8586]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3cb2:a04:baff:8586%2]) with mapi id 15.20.5186.028; Tue, 3 May 2022
 20:04:44 +0000
Message-ID: <13376f8f-b203-d2cd-d8bf-782d276325b2@oracle.com>
Date:   Tue, 3 May 2022 13:04:41 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH 03/11] libiscsi: use cls_session as argument for target
 and session reset
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
References: <20220502215953.5463-1-hare@suse.de>
 <20220502215953.5463-6-hare@suse.de>
From:   michael.christie@oracle.com
In-Reply-To: <20220502215953.5463-6-hare@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0110.namprd04.prod.outlook.com
 (2603:10b6:806:122::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5fe2984e-393f-49c0-e8f3-08da2d402aca
X-MS-TrafficTypeDiagnostic: DM6PR10MB3993:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB39932568B6BEAFCA5EFF6CDBF1C09@DM6PR10MB3993.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SDpym9GIBomRCw705LQQDkHkCuHQyQzhvkrRLZUI3JhxEvrSZCmD3bMmqD9sLbjsl/bvM/eSPo8xslox3flWQpqEWU6MoLLfi08Yaje4aHtyCpMDy3u4lz7NiQUv7OQN/PZoavuYz0sKyarHrdPQWuiD5z3ZdNczlbqxOHcMrXmZ2UkKiB3Ao0PCi4XWJ3lXXGwfSgxC1Wyq/UOqMCBY+qbIlooD6iRD+T1f0/hO4kYPnIXU2RXXlv4vV/coJum/k+PUEHqvbXR85mLm8svNB3RD6jwKG2oWqgoCCB0EnYfWrmaCCYd9ddCy/SrcbksKy+I5b/urLrpkIWWTQdmyWe7r42wYIC1F7XlC4gzLzanIzz9pjfdyaSFY/M8TxPJx1RqCTjT4b6K3z+1/1MjCF8WI5uXn/c3vuPPOAv9GAZUPwsP2Xsaw9DFOrZUYj1OyOIpc4PKcEcV3RyiQvJIBI0kY9HXbcBYBoqnu9yp2XSCnP0HORFhaQonMKprHm+AXV9vKWcEW4kNW5jPYAEIDi3xCL1V+Ph9XkiMKrYI3m2opSHPdwm9sRtajYA1GV/eDDXL7xJsQqhhnsOO8QDTxaMwRcnMjHRgkNT31tN4b55tssBHPlkKPU0UJidqpxaLufKnBQANvQrdnH7vnkjjF2GlCaZzumCblry3il90rrzX6KN9ZQhfdkwwRZR949qW9/yqsYXk59o6/f4mPcX3cwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(110136005)(6506007)(9686003)(6512007)(31686004)(26005)(5660300002)(54906003)(53546011)(6666004)(8936002)(2616005)(186003)(508600001)(36756003)(6486002)(4744005)(66946007)(8676002)(38100700002)(4326008)(66476007)(66556008)(2906002)(86362001)(83380400001)(31696002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aWR0MWNXNUlPRjdkalZIcVYyaVVxQ2Y1dEJuN0p4SkJsbHFCMkJudGJCYWpE?=
 =?utf-8?B?OVdvd2dNSG1qeWRxY1FaaFEzSWl4eFh4dVJmcmRwTCtIWUtCQSt6SjZ2dHl5?=
 =?utf-8?B?Nzc3TFM4SjRGTlNMSUQrZ2pvNnNWMjNPaTdNcllxVkxhQ3FRS3pFbkpsOURP?=
 =?utf-8?B?ZnlxNkkwTzl4UDVsRjFKN1ZBWVljbXZuNTVqOEdiR3o0Tk1TSHh5RVMwQ002?=
 =?utf-8?B?ek1PemZnRjFDdThZclJpeTVJbk83U0tJM2xTWkxVTFQ5QW1hRzhsazdoeWIw?=
 =?utf-8?B?WU1Sb3ZWRUlGU3hibVVuSVJad0NUbjBrTmhkQXJrejFPVXJBTEhzYzBDR0dY?=
 =?utf-8?B?NlREam53Wjdwa0E3ZTRQTEc0ajVZM1lLVjJwaThkZWNEeERYNDAybnVhSWtt?=
 =?utf-8?B?YzZSTEloYXJzZzV1dEFOSW5iSHRnSUhlNWxWelU1RHZuRXFrMzQzUVQ3Umpp?=
 =?utf-8?B?MERldWgxak9iWWlFQXNVZzFodFMxZHZ0NE9EWGNWaVV5S2pUM1V4T2VBeWJC?=
 =?utf-8?B?RkdEWHJSR1ZxV2E0NmwyWG9EcnQyRDQ3OFM1eUY0eUtOM29zVFBlU1RwY2Nr?=
 =?utf-8?B?UHhiTUVWRzM2WXZJeUExcmpVa1k1Ni9QcW1jUTVMc3RVNU9wQWdxeFVzeUJP?=
 =?utf-8?B?N05yNGxFZUxmYlQzMklsSEdlRWRmWnV6dGFvOUpTcytnYlR4S1hpTURKckVs?=
 =?utf-8?B?VVVacFpjY0dZb2FIOXdtOHVzMlM4MVNYdWk2U3BOUW5ZZk1xRm1EVW5YTitq?=
 =?utf-8?B?N3pTOWpyakVZdVM1RDl4NDRuMVE3YlA1Tm9pbFJBVmlYV050VFNrQjVwUlRJ?=
 =?utf-8?B?Q1plWWJYMHNQVHhMWGtqb0kvYmw2emV3V1drNjk4N1lOdlRJakdPayt5RTE4?=
 =?utf-8?B?OEpBR1hqdUpTYmh2dW9WTnFWSWpRN1hoU0dlaEh4MlBia3IxYkhYa3V3K3Nw?=
 =?utf-8?B?TU1SQ3N1WlhWMUtSWTRkTnZXMFIwQUdrUWw3WndQM29jR3g5VWx4KzQzTlNV?=
 =?utf-8?B?bnVEOG44NlpWT2lITlN6Mkd5UEQ2bTlQbGZJV1JUY3ZEazNzaXhIc21yaTdY?=
 =?utf-8?B?b29BOThnY1UvNkJObzd4aVhpeDlBaEY2TzRYbzNZU29veDVGQytCWFNVNCtm?=
 =?utf-8?B?SjNzZTFNSHpLM1JwblBTb3NlWDEvYlZPWHhEcTM1QXE3dDZ0a0t5WE9JWXNT?=
 =?utf-8?B?V2lneFJ1SEREcDJCMTUrYjJLaXZUSHVPUUhkSkNGVDhxM0hma0cwSHZhMVBt?=
 =?utf-8?B?eThiU3BPSkozUk1MTVB2cDE0dytEekxoQ1EwSUpDcSs3SFo0K0dVK2dCbWUx?=
 =?utf-8?B?aWs1TlgwRFVQZDk0TzQ2WHRRSXJkVUlVdXBEM3pmaW16NGhlclZRaXZUL3Ey?=
 =?utf-8?B?emk1UXNZNzZkak9yMjJ3RDYxT3VTSWJRYnl6TG1ZWXAyNHp3VGRPMitDaVpO?=
 =?utf-8?B?MXRUOTFtcmVmY09obmQzcHpsRGRTdStjNnJIV2VXWUFybXJGSC9yc1Zvc2lZ?=
 =?utf-8?B?d2t2eEQxQ25yY3h2aVZCSVZlTTdCMXEyc3FjY3V2ajZ6R01jNEt4Tys0VlJZ?=
 =?utf-8?B?aUZwNWpGQ2ZQZ0RCdHU3ci9oOUlIQVU5OHlzbFZxWjYzaEw3bUJLSHZEN2tv?=
 =?utf-8?B?M3c3T1pGcDExalNqbnVoS0Z2bTJmQkR3ZlgzaWIwSHVJdEloaC9sSDVJS3RC?=
 =?utf-8?B?bklxZklHTEptdCtEa2J0NS9xcHJiYnMvQnEyQmtlM1ZNbkpOdjFWbUoyUTds?=
 =?utf-8?B?Tng3L2dYaWNTRmR4d0MxVGJpVmM5Rll3OHFkVDJsYkhwV3hraThDL2tWOEZh?=
 =?utf-8?B?MjlpV3lDa0IwYmhVZVpaVHZ2NFV2ZG9ZOUE4YW1WK3ZDZW1aVHgweVdDSTFk?=
 =?utf-8?B?TTBadlVWWitLZFdjN1NVekhua2RJaC9MMW5zSjUxazAwemcyVVR2NDdpQ2R3?=
 =?utf-8?B?cWowdithRURxcURkeEgvYURyWm5QdjJ2YUxMWVV0NUVjNjE2WWNVMVI3R1M2?=
 =?utf-8?B?NlQ1UWlTZ2U4am1wR1NXQ25UaGJhZXhWT053TTc3bE0xVlJKeUovOGd0M3Qw?=
 =?utf-8?B?c2VMWTVmemRxb0h3MUwrM0ttT0prWFZxZjR1c205b2FzTWNFZ2g4WWRPUjB5?=
 =?utf-8?B?OFUyRUtjTnpMYTRIalNqeUtEV1RDbmN0NWY5M0tmd1ozbDFOMGtqUldHOWN5?=
 =?utf-8?B?V2w3bFBZb3BwYi9jYlVBM0l6cElTY01SdU11SFk5QTZqUVBTK1dvSU0rejZI?=
 =?utf-8?B?UjNoanJwY3kxVUUwNno1SDhNZ1oydEQwYXNSblZqZWVvVkw5UmFQbGw4SjNx?=
 =?utf-8?B?bWpOamhUTXNHckpQTnVyZDZlUkErYjZHeXphbERONDFJTlFoTGVxWHVvWWVu?=
 =?utf-8?Q?HGMOUmWGKQdwh+nQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fe2984e-393f-49c0-e8f3-08da2d402aca
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 20:04:44.8100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s0yzidojyI/4bc+0U8WMOt5QQVlWfEBRnw/mzc908uTepU9TM5pykDIYFThXn9vUlBWYJx64nZOXTJGYnz9x0mmG5wd9v4EN4kGwBGcFXdw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3993
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-03_08:2022-05-02,2022-05-03 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205030124
X-Proofpoint-GUID: ypluFx6KU522ZmIhS6f5uUVQw22SEtJL
X-Proofpoint-ORIG-GUID: ypluFx6KU522ZmIhS6f5uUVQw22SEtJL
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/2/22 2:59 PM, Hannes Reinecke wrote:
> iscsi_eh_target_reset() and iscsi_eh_session_reset() only depend
> on the cls_session, so use that as an argument.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/be2iscsi/be_main.c | 10 +++++++++-
>  drivers/scsi/libiscsi.c         | 21 +++++++++------------
>  include/scsi/libiscsi.h         |  2 +-
>  3 files changed, 19 insertions(+), 14 deletions(-)
> 

Reviewed-by: Mike Christie <michael.christie@oracle.com>
