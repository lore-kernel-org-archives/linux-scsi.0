Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94BD6FA3742
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Oct 2022 16:07:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbiJ1QHd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Oct 2022 12:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbiJ1QGv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Oct 2022 12:06:51 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9C621DE3E3;
        Fri, 28 Oct 2022 09:06:09 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29SEfSc0011135;
        Fri, 28 Oct 2022 16:05:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=C5LQZzhEQ3IsvA2KseNr6r33oHJ/pvKyVaOiO3pqU0U=;
 b=KTe4G7FtBKrAoBrJqUjHl2qMXPm7Y9ivYCrxkvPB6i3sARes4sJd3VVnKmgBOfpzET8W
 FNj1NOUiMcJkzFEqJRztF7xJcCaCCR90/+f0epK5r0uFGpKPebvdj1RuArZWB0x3ojBa
 u0Z0DWU7ORAN0xPLZ36U4y9xtOQbYgUmf792mhQMFMxQf8iitK9mtPNa+W99nWNdg895
 RjIPzoVtkCVG253IiiiDbgb/m4VwJrt/Cm8OelXzEuZr0f38kcjLWBPP7/R1lHYcsPiO
 sDNk2jRYVwqwQD0lgYxHm4AkIfRem/cub4gm2ziiMmHNK14cx9lgCMCxefQlt4pHvNL/ tA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfahedsks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Oct 2022 16:05:45 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29SEerbE026441;
        Fri, 28 Oct 2022 16:05:44 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kfagr8aj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Oct 2022 16:05:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mhyOpFX6IGheMo8vlwqCe02B3sXLWMt3E1g9dRVjbcoynrEP9wU7/LIg/0BjEU39kAZusvoXjWToyknx2cMCJEm6hRJpqHAkPuUYw2xqHZ13bqab03EcOT0wLy7ZPsneKxBDMU6tMqlfLuvHowEtEoaXeMq4zfu0L+X6S0PXKfJSgv/xm62cibX2XXox18pF0nLAkIeYFQPSOkiJWxmHk9H+ua1TxmYVFHIzPlhzoZcSIBwzZLiD+maFmvNA/iUh/wBcGHYzBORyMP33z0O9zCjw+XAiTwgVpikJU1zPYUpRM/11H2BkbGmEYrocvz0GiPZhK9gVzS1G0OurOKx1ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C5LQZzhEQ3IsvA2KseNr6r33oHJ/pvKyVaOiO3pqU0U=;
 b=dQYbrkNVZJDrEzohZt15E99Ql1fD3/Wrm3LczX3P8aasV7+3zs8tnFkWXUF+HB480D8svMj+0Cu51cgyHUCsIi0lMKajscy9PtZTDPArmj5tS5gl1fYREy3eMiTHU3V4u10Gd+GLX5DEpA+JupyCmHDGUfv+arRdRszaBeRl/jFceKMYr5LgMsg7FjPLSvLs9s7IQCaX48Ock6PF5Ek/S4wXNXNxWxlXQJzp7pjywCgUiLUXasOqlyMgoZlGRJyLmXNAttrs6yR2SyV+pS1m1u4WYRu+wRhzbw2UvQDdgwXE5zC9w3J7CZ0CCUCx5FnWiSIJ34G/qK3DRaXX7obPOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C5LQZzhEQ3IsvA2KseNr6r33oHJ/pvKyVaOiO3pqU0U=;
 b=sDdxEGPlMegxxBprhsXdkIm8QRtOHunimhoJKgY/IKd0QiAeGgKGIHPshPkDO2VV7sL4+uIrKqXwKpfNYuIl0iDHNtvkRMXNvs1SLdRtEb20xRILOYDYRcMSRyB9fbwEhX7TipSvVIrwWXk+vvEAJ+5AwJL1+XMG+OdZtP1bN2I=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MN2PR10MB4272.namprd10.prod.outlook.com (2603:10b6:208:1dc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Fri, 28 Oct
 2022 16:05:42 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5769.015; Fri, 28 Oct 2022
 16:05:41 +0000
Message-ID: <8b8b052e-fbb6-3693-4fb4-4642c8c590d3@oracle.com>
Date:   Fri, 28 Oct 2022 11:05:39 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH v3 10/19] nvme: Move NVMe and Block PR types to an array
Content-Language: en-US
To:     Keith Busch <kbusch@kernel.org>
Cc:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        target-devel@vger.kernel.org
References: <20221026231945.6609-1-michael.christie@oracle.com>
 <20221026231945.6609-11-michael.christie@oracle.com>
 <Y1qhXQYOpEUk2uqF@kbusch-mbp.dhcp.thefacebook.com>
 <a74266ce-3839-5d2f-abc4-cb30045d811c@oracle.com>
 <75564e1d-3169-cd50-ea17-53ef96a3a35e@oracle.com>
 <Y1q86YvRtZPBJDck@kbusch-mbp.dhcp.thefacebook.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <Y1q86YvRtZPBJDck@kbusch-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR07CA0031.namprd07.prod.outlook.com
 (2603:10b6:610:20::44) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|MN2PR10MB4272:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b1bb137-fafa-485c-2192-08dab8fe4325
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uN/IMJkl3M621aLiNBfr98XfScyhYcKeAPhBUsqFUg0ppKhWy1NB0cG6kgHHuiie2Z/I6tE7UC2g2e5lY1tiukzjCxVHOSgvlHsBl02FJcjJV2ZWbAAgTQpIaEx2ySRR67yuhrwwDXX8p8VvqMierZJ5BnyHPpNXHb2MIdTpVb1UzJj+zeq5+sIs3h/Rbp4A+mrliqa9iSKe2ty38PRp+F/t/bmksypxLoqFOeizJtnU4MF+bZAqQpidRDFA9Gk30GsHTJkm4i6jbX8w8zWFHYaRZ2bhBYW/+kSUtPM8UcAZta0SYhQ/lNoHTIRg3LlhZbluhZdGuvqQaZCYMLb5fDmKs8J0LkxJcB+K43xoCGM6MoJf3axSuFvytEvo1aP5IWsaMLRzUiwZLqz9z3SGERcp1i8Uyh0GuWtsoWsLS2iq4U9Hs7rlaKMtea0Yll/xu7QMhfBs8GbAVIgZoqM+p6qZbnJIWf6xafVuTKSC+5ouIEghpHLqC5EFbdYrGf8qzKTF/L/EXI+BnNEUSt8XsGnt1MIvGyU5dRcEMrX8QlpMo2sItoYvRe87kN3jaJLLlTFNvrzsQx17g+UCcUmOHAiQN3DKGHBcrOPovR821J2ZUQ6GNnAakpysMPZ2B9QjKTZ9dhHX2J/quK68H7f19JOZ4Qx5kE0ReUICZwnVqEKcIvUllhMES5jHO1TNs9skLhJTIv7MUIQ8I5OjrzUBx5QzT98veQO3A6X363xBBcX7w0Gl4d9QeNfaBABSAtfx1NhR/TiFFA5tByGuPBBY1YNkEhuqSGP50EMnz8STnoo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(396003)(346002)(39860400002)(376002)(451199015)(31686004)(83380400001)(36756003)(4744005)(7416002)(5660300002)(2906002)(38100700002)(86362001)(31696002)(2616005)(186003)(6512007)(53546011)(26005)(6486002)(478600001)(316002)(6916009)(41300700001)(8936002)(66946007)(4326008)(8676002)(66476007)(66556008)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OFg0VkFTZFlGMFpodGJCSGRiMDF0cVJ1cFFOWTBZeEV6elpnemVObE9nVDgz?=
 =?utf-8?B?Y0hNOXpuSng4QnhpV2hLTmMxbGhaaFBiWEtSWFFLbWNiWjdvNVFXMkk1Qks1?=
 =?utf-8?B?cU5HQ1NMRTI4K3BwU2hFYStxQ3dNTGNHbXh6U3d0aitRVlJGYndMSGd6UkQr?=
 =?utf-8?B?ditqa0pEbW5PMmV2NUtya3RnZ1J6T0lOTTlDZmJ0STRqQk1BTkJRdmx2OE9W?=
 =?utf-8?B?LzkyeDJ1akRsUVRTQjk1cisyWW0vZ1BBOWx6Vy8yUVdrQWJ3RTJ0OUgvYWRQ?=
 =?utf-8?B?bmlnVHZBdDd1a0draXZVRllGVmhqQU5iY0NyMGdTdkptQmExU2tzcldWVEs2?=
 =?utf-8?B?dHVveVRoM09GZ05JWklhZGlybFFWYUhxS2dOZzZ0aDlLNzdiSDRkdjFkWnhE?=
 =?utf-8?B?ajA4WTZybVhaK2FaRlpTdzh0Smo2ZmRVQXQrYno0UklWWmQ4eEpqSllJWmc0?=
 =?utf-8?B?VFhmTDRtRjBZVmtKc2NiMFJia0xVRE1rMGJZS081b21kZHdoNUJ6UDFtSjVJ?=
 =?utf-8?B?dUEvZTVJaDhmckYwbGR4Y0dMTStvaCt5MEZzSm12NnJTVnF1R3ZKdVZ6Z3g2?=
 =?utf-8?B?Tm5mLytxRk9ZekNjZldEQ2NacjJrMVJPY3lid010QTBWWEd0UEd4ZmNmSVph?=
 =?utf-8?B?Rk1Ga1Jjcit3K3p1cTNNaFdMSTYwaXFNbFVydXoxVE4xdGcrZWFkYkZ0TFJk?=
 =?utf-8?B?aTQ3ZDBZZXc5Q2t1SzFDZGtaV2xKTjRmaUxIdy92dVlITVpIUFJHM2FFS2ZJ?=
 =?utf-8?B?L0hYTVFPNTk3MHZOUHAxYjNXL29XSnQvbm9oaTNJNTdHNlJIdGw2eThmQXlh?=
 =?utf-8?B?NDRzVHZYZnpmeHRsYjRGcWlJdTZnaS9LTktxWWZxUmVXV1hNODRkbGFHcDBi?=
 =?utf-8?B?enJMZ1lWcDE5K2dONEpyTHlmZWhPRnhNRFhZYXlxZkh6QTNEaEdORDdHeDZo?=
 =?utf-8?B?ajkzVGMzdi9MaFB2ajErMVB5d0g2SFBMTk1LTk51RGFNczgzZTFtL2NYTU5m?=
 =?utf-8?B?NkhRTWUySStIcUpJb211TWNET2Nncm1abGJFbld2c1ArT0QxNVpDVTdqTjNt?=
 =?utf-8?B?RjBpZ3pFQUx4djdjZ1E3a0p3R0hJOUdLTklLMjBNYmYrbkRRUG9KRDVvWTB1?=
 =?utf-8?B?SW51bWFmQitubXhMUHlVaEdlZTd4OC9jUkNjSnhBSjM2ME5xVGZtWjRUYUtv?=
 =?utf-8?B?QXJaV0NlaFI4NGU5c2cyT2R0dnhBY2N0a2h4RnpVSUNWdXJWTStMcW1Xem9Z?=
 =?utf-8?B?QWRwbWZ1UklieWordWpFdThmdnJEUGFsOXBLQnA3QWlhTlVsWC9LN0d4QkNG?=
 =?utf-8?B?ZVptVnkwak1DNzVsNlZMUTlMMFNFZnBQcld4eUp5UnVSbjdTd0oyZTJGZHd6?=
 =?utf-8?B?RU9yYnlmSThMQ2w5VFNVTndPNVM2amlHeDc5QkpLZnNaNG5kWm1nMVl5VzRN?=
 =?utf-8?B?MjFIUWZrcVJXNDRtVHYxdk1ZdDZiMWsvVE93WWxIYWFrQms1UVFiTTlEdmk2?=
 =?utf-8?B?NE5oYlNCY21pNkFLSitBNEdJcGVLanF2STUwb09ZaVZSUjN1dHpXRk9jTm10?=
 =?utf-8?B?Q2VGV3RLcWlZRk9saEw1RkRtVTEvYnNldzFESExKdVhGc1FNQ0VxdDFGVGdS?=
 =?utf-8?B?WnZpZWpHUHZPN2hIbWVmOHRROStwR216R2duS24yc3NiVVRNdU13R2NzT3Y5?=
 =?utf-8?B?UTZlbTNoWmVJeDVqTkdBclRqbUxyV1NpSVBFb3FBaDJOOTRDQWZpdXlyNVFR?=
 =?utf-8?B?MXVmNDBkaHJDem5BSGRYYkhxdUM5OUNiS2ZOQjNFZTJDNWM3cTFVNDJBU3Vu?=
 =?utf-8?B?T2w0emY3QkwyeEF0ZTFKUXQ3UEt5ZDRZUGVSVjg5WWlhdHlCTlZDWGpjeTdj?=
 =?utf-8?B?emY2TjVsa2YyWlUzMER6QnhIVm42cDY0bXJ1VlR6N0pTeFZDa0RIQ25sNEh3?=
 =?utf-8?B?blNHWHIrTFZiRXQvR3NnQ3R6V09lVFRBYjk5c0hRaVhaemRhdExCRXhXS3pD?=
 =?utf-8?B?UlM0MFFrTXN4TVdKZkFMbm1INUhvRFM1YkFnTjJKREowVDU2WW1TYmpIem80?=
 =?utf-8?B?aWxsWjAzVTNkcXJxYlpmdGpRdEorZlRFNGRUS1FQTWMybmNKdCtidlZGLzZj?=
 =?utf-8?B?OVZRRnhtSnlxUjZyaEpwc0F5dm5mM09mdFNXeXdlY3NkR0J4K2pTMUtFNVp6?=
 =?utf-8?B?UGc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b1bb137-fafa-485c-2192-08dab8fe4325
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2022 16:05:41.6244
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L/Ih7g63+aP0zcZMS26jMJy/sRkZmgNR1mKSUKl6trcrXu4zdyhRAwrAU+am6DD5pBtWMOyyICwYgZ5jZEQ/KlRtuRvb0s+DvPekQSwvbB4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4272
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-28_07,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 phishscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2210280101
X-Proofpoint-GUID: CQM7FddTPAPLn9CsFP4F0NbohvPCHNxV
X-Proofpoint-ORIG-GUID: CQM7FddTPAPLn9CsFP4F0NbohvPCHNxV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/27/22 12:16 PM, Keith Busch wrote:
> On Thu, Oct 27, 2022 at 12:13:06PM -0500, michael.christie@oracle.com wrote:
>> Oh wait there was also a
>>
>> 3. The pr_types come from userspace so if it passes us 10
>> and we just do:
>>
>> types[pr_type]
>>
>> then we would crash due an out of bounds error.
>>
>> Similarly I thought there could be a bad target that does the
>> same thing.
> 
> Well, you'd of course have to check the boundaries before accessing if
> you were to implement this scheme. :)

Yeah :) Sorry I didn't write that reply well. I was more trying to say
that we would still need a wrapper function to check the bounds, so either
we have 2 arrays and 2 helper functions or 1 array and 2 helper functions.

I'll see what other people's opinions are and just do what you guys end up
preferring.

