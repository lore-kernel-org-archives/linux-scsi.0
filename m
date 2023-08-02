Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF01CC001DF
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Aug 2023 20:18:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232071AbjHBUSs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Aug 2023 16:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbjHBUSr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Aug 2023 16:18:47 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E27E32698
        for <linux-scsi@vger.kernel.org>; Wed,  2 Aug 2023 13:18:43 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 372HInJS030227;
        Wed, 2 Aug 2023 20:18:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=kuM6zu5qn74aauyaim/G/4m7Jz4p3bJde210LAjHPO4=;
 b=egaYhF2c6FVob4nA5P9WDpfDJrtO1X+CNv0K6yZi6OUshC8oCvcTp/w2qWf65FD2LGb6
 ifmLHAmEhN6jiMT2rtVqKdZLN9ogY/guo23HlPyXZPTpwGtO2DqIvdNgry5XGZMxJkco
 vPKpBBc3YMjaLUv5fS+seoW4MH1CjBEQ2o5GhCDs5BGFKlCX5WX9mr+IMDl7OqrqTzOB
 /pqCENKGEUpA0tHkPC2lkXh+npNw5b1JsvL6KnERoWN/88nZ2BLoxa3g6ty8N/AuQMtk
 4iWiNjle4b9BAyvMQSPJ0KI3i9VhwT3cL4sdFZPjUhvf9L7XQIJ+3LJbzsORon7QvRWY jA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s4tcu04j7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Aug 2023 20:18:41 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 372IYRHx015759;
        Wed, 2 Aug 2023 20:18:40 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s4s78neju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Aug 2023 20:18:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=coI/jzvX5bXFMATivOnNYIxqiAViw2aI12qHVyAnHS7irOSDBOb0Cfc32UnBG24bkWFRm9+jUywe4m/wntu27DdlxppWMsmOtzBOeDN98nfhuRh+HsUhKNkobMLpqXVQqYRWt7Y56d0WtbO2enGMWK56geYzuITNwBd+KeSZOeaNiKDVkR/S/NAp66D8Uh72BC0q5E+bI8P3AEzQry6CMG2zvmV4NGyIYq9l2BSOp7USYVyhRsFRt+TJiJhOAzMxSghblFmCH/83vOjp5gXVrdp8G9ng4hMp2nlHWAKvI/fvUi37WNnK3x7/OWh0xfJpTCRlkvUmsZc+gdm3y/KqTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kuM6zu5qn74aauyaim/G/4m7Jz4p3bJde210LAjHPO4=;
 b=TSKLo6QNod9nCn5stQGuTGqsuvXmqVSECA3cfWReUwks3FrOHxMJjgJXYcdC+6BAzyUCzqxomy4EBJ92Jy27/6W7z8jnkv/6j7JZcWHpkGE7i3GNa/1PKopbnNq6ffcMU2vz+wCBgnYYwGXXBtMGy0Bhq7h14AC2npXcAu53jokBFlodnFRnXCMIbPwLt6c126u8SQpjHa/aJSn270o9HMIDgUtOOQ5rycNKobKuwKmaytGbzQx2ZZs0rJ4V39DJ13yZwSM3hMPuWw4rAMKAA+vSaZnkOavzEepUsX7DePtHhyOSO6QtFOAsCrQ9DkVfzz1o9IyhrtwHg1mbROUq6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kuM6zu5qn74aauyaim/G/4m7Jz4p3bJde210LAjHPO4=;
 b=rQiwQF/fZItR72BK+T0/xnNYgGwZhn6baeF5HwYdOMaf8G++qafZqDqxVVvtxPfa61sWxdk/VtD2xaB3FJrh1SnG7bhvdig3C4MLkxD2hjBD4UxcDjaOfeyRQGgPYIJNYequRdCxYU30uXdIIWRMxg1znJXvRLN18GJSkCLFfbI=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by MN2PR10MB4174.namprd10.prod.outlook.com (2603:10b6:208:1dd::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.45; Wed, 2 Aug
 2023 20:18:37 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::31b3:ba23:4678:9f5f]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::31b3:ba23:4678:9f5f%7]) with mapi id 15.20.6631.045; Wed, 2 Aug 2023
 20:18:37 +0000
Message-ID: <c4c4e605-1d59-7394-c7b2-0112e4f839c2@oracle.com>
Date:   Wed, 2 Aug 2023 13:18:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 10/10] qla2xxx: Update version to 10.02.09.100-k
Content-Language: en-US
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        agurumurthy@marvell.com, sdeodhar@marvell.com
References: <20230801114057.27039-1-njavali@marvell.com>
 <20230801114057.27039-11-njavali@marvell.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <20230801114057.27039-11-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0078.namprd11.prod.outlook.com
 (2603:10b6:806:d2::23) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2943:EE_|MN2PR10MB4174:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c3aa180-d648-4b26-4809-08db9395a766
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K1mVWV+QS6l+ohrPU/gSMrP4+dwciOfkF9qYmbunx8XIs3s6AaggqPnvoq/omwOYWl3GVVnFBL0e1RMM22IHhMCBWu/RENczLE3lP2nOWgbl+KeGwn20OZqBd5cQ3LbIdNvokh6+ZtIq2bGvglUgqRkXvN8GwFPmirO89/d3ZMTKk8wRq3PTkNQqHj6QHBRsep1c/qq3SGSv8GVtNACyQtkbbfffBd9WE8QeRwYGngHqIhuN6c+MUNUSg8bZx6Wv14/Z2KRxKgRD7a2cKPkvMdoBNzR+CcWwKMK0xo3atwSjd+BtQ3zwz7YX7ZBbIvHWHg/iqlRqMnKoEDnQDFnD25TP8CyLKKc8lUtKoi28DXCS/AVG7v2tW6VbOhUFSoFQe9PWThVQtJNJstGSFfn7JX2oPnk/QQz6TjGJubuS2iI6WTiYBtakpKHaZd/eM7U5lhGb196AKI6b+pZzJk03l3Vn817EoZPjQmrC0dUWlXw4lmshXnR3pKyj8rJotLnHXFDHJHxtZVXamcZjRNWArGNR4je+hJNwsjxsrMD7UJSCQIQnYzm0xsJzyGLTTdwjYsRthgewf+tpmbUH0KctlCCSs+EGM6s0zClsCdHcV7gPrGYLTmokzVpSXnPY7sL+wPMRSt8VRFN32QpVCg5xLw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(136003)(366004)(39860400002)(346002)(451199021)(8676002)(8936002)(31686004)(4744005)(41300700001)(5660300002)(2906002)(44832011)(83380400001)(2616005)(186003)(86362001)(478600001)(66946007)(316002)(53546011)(6506007)(36916002)(38100700002)(6666004)(66476007)(66556008)(31696002)(6486002)(4326008)(6636002)(6512007)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y1FvWkxHN29LdkdQU1p5bGp3TU9iYStkc1Z2aXkrcEdPdkpNOGowbzBLRmti?=
 =?utf-8?B?VW5XZXZTdVdENGU1cUszMnM0d1d1V004Tk5QYWRIeWEvRjBTUEVPTFpjcXps?=
 =?utf-8?B?dHNCTXpOSVcrV3VyT0F6d0FLNjBPcUY3K1lYdFltUVc1VHJDVWpFMmZJSFB0?=
 =?utf-8?B?bllMemJjUDk3dmd0WEt6aURXdldyMWErS2VhcXFwMTdsdndFRVR0b2hFTUJS?=
 =?utf-8?B?aG82TXNOb2VVelBRUHlJRXFlK1RYZWVQK2NFODBxejhrdHpCTW9rMWI4U3d1?=
 =?utf-8?B?L0lVU1hrREU1OHp1OXh0dDVXZ0ExSzlBbEFFS0ZJNWZDeUR1RXNnN0tIdHdy?=
 =?utf-8?B?TW5ZSFpobStxL0RUUW1YK2lMU3A5Z3crOFR1c1JjWVFIUHdKVXRJUHVKaUp5?=
 =?utf-8?B?RU54UTdoU2N5Y0tGcytQZUxXaEVmT013eDI4U2lYaldaMHF1WUZKUXR4M2p2?=
 =?utf-8?B?TWxGc2loYThKdVU2cGJKeDFuS3dWTWlPTjBHdTlCY3ZaVWEzRlJOMmJvVXFI?=
 =?utf-8?B?OWsxaXZWSXlFN05DUFVRdjl2OXRXdWpMeUlISVM2TGJ4ZHRIMXlwYzRNMmFL?=
 =?utf-8?B?NmJFWStreGlSTjV4bkFOTTJqKzY1RG1VSkJxMWZWcVlobUVMM0hhaXVVRTd6?=
 =?utf-8?B?c1JkZW4rQzViMWl2RXRjU1ZlWDVpT055RVpidkhST0t5ejh3Q2VZSkFza1hw?=
 =?utf-8?B?TTZjTHFsaEorajNBd05FMlhLNzFIYkhTaG1ZVjBDMkxoSFQ0Mi9rYUpjT09S?=
 =?utf-8?B?elMxbUN0Z3hxY0twcDhYUE0xYmZnSVZES0xuaFkyQ1pIR2EyN0p6ZUcrbWFr?=
 =?utf-8?B?R0FVdEpxeHUvL0VaSVc3UlpTVnNrQXFHdGtza2lwWWt5RW5pbnozK0FPTzZm?=
 =?utf-8?B?M3hZVTdSZXpGWnBHNkphdVk3VkJHUzN5RGtzTkRucEJnOTB4UTRWTFhIOC9S?=
 =?utf-8?B?K0ZjYWlxVEU3VE8yY2JnZmliL0dNUTJyOE9qQm1ScVFTTmpzdEJKcnNXTUh4?=
 =?utf-8?B?K0Q3ditOVUdQSTFlNCtJZ3NzV20zM1BPK2Uvd0lTblcxa1hXUlRFU0pBNWpr?=
 =?utf-8?B?KzdKbWwzaW5MK0ZVdGxsZU00S053YUx3c1lUc2NGb09xcWgwZXUvSnpvV2pi?=
 =?utf-8?B?VlBzS0FZQytJcHp3YVI4WHZaMzZ0WGwwUjUrdkMxSmtubE5NckJYcTZmSXkv?=
 =?utf-8?B?b1UweURhNC9zZ2NRZWJRcmpzWWQ0dmo0SFZiWmo4ck92OXUrSG00WUMwY0lU?=
 =?utf-8?B?R0MrMTVyZEdyaCs5TDVPSG54Z3F6VThrbHkvNVZpYXo0YS9rdE9ZaHlVMU9j?=
 =?utf-8?B?c3hNVGxhU1l6aDYyYkhkaFlxbFc0NDNWcktQUzBDVDhTZW1BYkVKa2VwM1V1?=
 =?utf-8?B?VW9KaHNSOFFoSjI2VG9rZFRMeEpyUVltNUc3NThWQjBNSTFBa29BWUFjaGJV?=
 =?utf-8?B?ZTZKaUFjY2R5NEZKRjk1Y1BEZTZybStCTHlGVklCeWJhWEw4bW1vdGo1MkFR?=
 =?utf-8?B?T2hDWm9JU3I5RnBFQWY1NVRTcEtQUzQzWUsyWVFXSlZBUHRXSVN3cWp0QkpD?=
 =?utf-8?B?azhOdnRGbkRoM3c3aFFxRlY3M05lV2NoamlRSDJPWTZrUGRXOFlKNjZXVjlV?=
 =?utf-8?B?Smp6YmpNb2VwY3F4SWp6U3F2blVaa2xvSDUrUFhMTVZCVHI1NnNzOFM5LzNv?=
 =?utf-8?B?Vm5WU1Z3SDU5akd2NnNEY2lhbktRN2w2bFpRaUtnYjhXK0V0SE4xU1BOemlm?=
 =?utf-8?B?OVlUVW1ZMWdPVHpXWTFodDh1VFZudWxQVTFWeFdPV1RpZVhiZEtlSytud3BL?=
 =?utf-8?B?SGxqOW01UmRweFU0UTlxckZGakREZ3JxNzhHUW1STU5waUFBUTkydTE1bElZ?=
 =?utf-8?B?OEZ1Rmd5Z3dEWGRSMm9HMHFkS3BYMmtrR0R3UG9QbHZwQ2hYeXFGQThWZThI?=
 =?utf-8?B?Tm9iaGh4Skt6ektYZHZMNUphVGdtZTZHVFBkMmZnaVhqZlp0c0FmQzJIYTVP?=
 =?utf-8?B?NFpPZ0tLb21qb1ZFWXVkWU5xWldjekM5V1ZabzNNTEZPNWcvV3dxZHMrb2tM?=
 =?utf-8?B?MkVOdWhpOWQxRWdBTUo4TGJVOTRjM0dyT0x5K1c0N1piTFcvMXJlRGVTaWRE?=
 =?utf-8?B?Tk5uamZNa2VYeE53dnhRQk51OTV5SjBRV0R5b1JEclZ6cjExVG1nQXEvM3dh?=
 =?utf-8?Q?BrnmAl9qbxdVjmFJeJ12PhE=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: hTbFEj/4CjFiSRYNXCO+uTJLylp/XEZM36jhVdgLTXM2fw74bHr1tGAVd3lBQ9owqwD1g3ef0ANJHCmm0AGVdEWXBfprOdRCO2ZfNxM1dEuk436UIM6EyJtVyX48c12+ocxqv5O0GwTm9S27jQTNdOsoBye00S3lKyo/VEXz+7gaiHmAtzQuBEcWmM+X9w1AwGpQ1PMWg4L3Izfb7QGM6JP8c67aZ266TtA3fPnGuK1/TXqwQ/WCu36Y4OILGXu4k6hksV8TXZCjcC2liwZ6xxKNZBGVSYHSCACO/fgJA0hNgVPK6JjMnBB/aOIIASNuKjW605qV6vWA49zh4i+1j9gav1Jp2kkyhm1ky891/oZfNrvnV6TolU5FljirrSGCEO1W7yOrKqKV7YVsKO0FFHF5oRbI+3CaOWK6oNbZCPDXiEwp6zqbRhftKPic9aTMUwVCb3o7QsfbiOwbuQsN9KwVfuj+bah01ttBu/NxYqm8G9lpHZ4z1Bc2Ow1SMC2597wi4Y+XyXIN8IuzM5j2KKfEC5VPhf2sSgwU5g1qnLvz3mg0rzsUVAoCbh1IhbIy+DHVq/IrqRJDJYP87D8xs6YDtzghgsuZ5NLGtCiZkcBCQxCzAKKaRh39fngrXwEGWqAZndj2K4RzITZEC6Z2l26fQou9wrJGeRM1ibSQnmBBik9M7i1EHFElPnshjhT7OEhRMXDW9mc22B+MmhsfneMjQDkv2lOnfALuq3awjwDtXIIzWwyA4cAM1m79DDtg6EfbtTlfD0ghRqCAoj0PRQpwDMKX+XZ4/j2XmHL4Hf8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c3aa180-d648-4b26-4809-08db9395a766
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2023 20:18:37.3212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: llS9ZyqgGNZGd6Gk3OG4brStgeTFfj5xXMdB6zqIBo3wiOZXgoK668/cbY+c2FxP+Ux+d8pSQ1phljfJor8OX62aw5MqjymrhYhVRpuGU4g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4174
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-02_17,2023-08-01_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 bulkscore=0 suspectscore=0 spamscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308020178
X-Proofpoint-GUID: 9JTAWfDvY3KrEf85kPpnS3K9LyjnsrPc
X-Proofpoint-ORIG-GUID: 9JTAWfDvY3KrEf85kPpnS3K9LyjnsrPc
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/1/23 04:40, Nilesh Javali wrote:
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_version.h | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
> index 81bdf6b03241..d903563e969e 100644
> --- a/drivers/scsi/qla2xxx/qla_version.h
> +++ b/drivers/scsi/qla2xxx/qla_version.h
> @@ -6,9 +6,9 @@
>   /*
>    * Driver version
>    */
> -#define QLA2XXX_VERSION      "10.02.08.500-k"
> +#define QLA2XXX_VERSION      "10.02.09.100-k"
>   
>   #define QLA_DRIVER_MAJOR_VER	10
>   #define QLA_DRIVER_MINOR_VER	2
> -#define QLA_DRIVER_PATCH_VER	8
> -#define QLA_DRIVER_BETA_VER	500
> +#define QLA_DRIVER_PATCH_VER	9
> +#define QLA_DRIVER_BETA_VER	100

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering

