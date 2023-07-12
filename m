Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03A90EB64D9
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Jul 2023 11:12:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232757AbjGLLMP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Jul 2023 07:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbjGLLMO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2023 07:12:14 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 420BB10FC
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 04:12:13 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36C6sBpO015223;
        Wed, 12 Jul 2023 11:12:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=mTff4XnrSg+t/vx/ccIb3zzNgC4z1ddVqMDtjxKUpUs=;
 b=yCIutQpJHiijNGMrwrzWub+L7z9kjuLQU7p1M49jzNd6VE3/Cs0f7Ovcxy+/ST0HnLJc
 J8o0QeyBbGSII9XX0rOQGyqcv6F42QL9a1Cif6419TFtDED5rAUyXgaDWpR+RWEao0jG
 9nLI5JuGrgynLqcuqEViX5xn8+dAaHBPn97G+6vzJJ0jEjMuvQsK5Bg1vk8azYkkSCrs
 vH0aTLm4H6ZWeGLlhgPHsEmsi3xRGhDTRGChyKWHow/2+3/OMSeSum1tliJA5UFFWe3y
 0xtq52Tq5fFoC00xM83P48FURiE1R8eKvThgGytZpYktMnomh2BGDusBELujI3lx7MOD Rg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rr5h15kxv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jul 2023 11:12:02 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36C9mXfN008401;
        Wed, 12 Jul 2023 11:12:01 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx8cn70h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jul 2023 11:12:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MqPD6nNsBkYAeklJygEwqGxDr9/RBOsTpI5Kbba0THEFo+6FZCPoDlBL6syxUl5sZV+8qrpejoj+UXr+gcEgYWuOhOa3OpXmUFCKW5PlE2j6yieB0Gym8YRP3Jm3AjbQYLK+iq0Hn4PNAcOwWQzMIlxPzW8hYmGwoBjVXbMhwy2SpelZls3pF0m1LNQsyokh+96Da2pFyCptydqx/68hqjPEBxs0RZNh0zoSTdoxFd7VZDzY+Snr5R93p0WSHrBb+zEGmr0byzYsICtT6995lU1m5ymIaHz/vO8fR40LYHqcazEfUGa+yBjGTXo7CuEZokctJFYapFVcB9NFLUYxIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mTff4XnrSg+t/vx/ccIb3zzNgC4z1ddVqMDtjxKUpUs=;
 b=EiKBbrfA2c64gx1Re+hhpsO2U5Sdx2Al2Ow/hqeujT2j8KWJsUu2PKQwzhm0T1nK6O+unxLm80U06UAi0Tcvw3oTsgzhRyXpU/bvxSEbRPgaAzHc9y+yIv/J5qQesiQtPFiLMO6+RGzIm0a1GfggeAiYIqWX/6XtWVr3mbQ4AbnCvmDURlvIvo/mMzMS1EJEXQnw7WGT1q4QkyMI5w7DbSgLYmfFmVxdxueZdOc3J2YOsW2B+P6IJANX8uAlpamO55t2wIZztrVlAq3sQFJqqdqfYhZQSJAgino583wZWKhE9w0W5zVKmmTzEfKZsNyeqHGlgH2sLlM1DJEopiR2fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mTff4XnrSg+t/vx/ccIb3zzNgC4z1ddVqMDtjxKUpUs=;
 b=WUALMjtvhll56eXc7FV869DRKswvsMRiIlHPPnn3LJuJeMyX0/9Hf45EFT2i2o+SGWv2acAlzsttpqmiqf0bK+SE4KL2QYhcg2CNxOJGkdbjyQ6P8KOBlm3p6Kj2gZKuWqS4u2NgAR1Ox8Bvr3s+let2BkGtooy74mgCxOg5kRI=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA1PR10MB6050.namprd10.prod.outlook.com (2603:10b6:208:38a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.30; Wed, 12 Jul
 2023 11:11:59 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::e38:5b81:b87f:c1eb]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::e38:5b81:b87f:c1eb%7]) with mapi id 15.20.6565.028; Wed, 12 Jul 2023
 11:11:58 +0000
Message-ID: <f58993fb-61cb-f376-1e19-863e74b87bb4@oracle.com>
Date:   Wed, 12 Jul 2023 12:11:53 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v9 03/33] scsi: Add scsi_failure field to scsi_exec_args
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20230711214620.87232-1-michael.christie@oracle.com>
 <20230711214620.87232-4-michael.christie@oracle.com>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230711214620.87232-4-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0027.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ae::17) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA1PR10MB6050:EE_
X-MS-Office365-Filtering-Correlation-Id: 32415271-345e-471b-8f2c-08db82c8cf22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G+/6/jExeS9Maz8M1El8C9TYSRHiSKJea9V0euyJucq1Lst0ZclWjjBmYiwWLejL/BGgMuLUI0cu4fMWDKgE5qP/mAhg7/Y088bWA/GqxvoMKd4+dxvEjgIQj08xGQ1ypdK2E0urQQFje1Vv8bHcnueql9jsGfkgy3EsuLq642ZMq2pHduUHLGaq4e68dKy/IahgOReG6tUY4xgi7q08EceHNN8DI+4UE7gDj2dCVzvtXHCedaIu75tdDHvkrTg+FbZz7ggjOm55axTH7FLfW6NEOustOUJ9RE/zxoxdp5b0Yj5QU1qvWowG6GsB+JHfgVq8Qb1Ze6X2SvJNnvuX71OxYRWnAOo2y+UkD2/Y1562V7l2UNnfZoFBpuRVhWqf8nIBvi8kncB+Tijs4TtzhUqspH97u13sXinYVvUOWXjoksgaWmldRZF9Tva7Z4kW9W/9WvnS6Rikah3ZSOKH8ZTI6UUvDRYBCeuru5ViFQfE5jnrqNoBrU/mnwfySTTvtMAD5vhiJShXcCCh5DM34Z29QZnoOSn/lgXHIDWsgbmvaa6pr94feeTMNXEtwHLyWkBjIxgH4QOo0nQ0EHr8pbReNwG3t9L1FnHMJ5CX8WL61UFG3x7lr9kfd7UlbzCmH9ii+iolfEEPNfMUPX3umQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(136003)(39860400002)(366004)(376002)(451199021)(86362001)(38100700002)(31696002)(31686004)(36756003)(6666004)(36916002)(6486002)(26005)(6506007)(186003)(6512007)(53546011)(478600001)(2616005)(2906002)(316002)(5660300002)(66556008)(66946007)(66476007)(8936002)(8676002)(4744005)(83380400001)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aFFNUDBmTzBBcnd5c1JIRWNxYm1RSkFPVkdGaU45ZHFaa1RIdHVUYW9Tam81?=
 =?utf-8?B?ZkVUQ2VaM0FIcGkwRGR1enI4VkZOQlIzREN5cE1tTjdMRkdGdTZILzdEVktv?=
 =?utf-8?B?aHRuc0swdWx2QUV3dVRZdkJVZ0p4UG85SzdJSis1Y2lpb0R6TGVoTXdBSlRz?=
 =?utf-8?B?Vjlva3hiSDV6bTA3SzFDaHRZNXN6UzNYaTNUNEFDRFBpY1lPRHZ6dzVIQWNS?=
 =?utf-8?B?UGljMitOLzB3VjRTVUhmdktGdWpEQmw4b29PWkNxTFNQWlNPSzF0Q1NEVFlR?=
 =?utf-8?B?dHRhcEFZNGNCTnhiNkRqNnQ5N3hCNm5TajNVMFZmdmVmMCtMdXM0bDE2a0Fr?=
 =?utf-8?B?NUtjTW1wYmI5YjY0QUxyb2NTSjN6Vi9ya1lKSVRmMWpaM1N2Y3FaQWVxUGVa?=
 =?utf-8?B?OVQ5Z0xucFJ1MFVadTFRV2gydzJVakhQZFRZV2J2RW5GU3I0OEJVZXNFVjh4?=
 =?utf-8?B?OGRuZjlWSEhTYjlGRTR1VHJWVXM3Q1VCZnRuSWsrSklpd2VXN2V5Qm41WXpN?=
 =?utf-8?B?ZkpncEtDY0ZIeDU0RDRyQlJXUksyK1NiL3FxcDEzcWhNZnU0WldJT25WRGF1?=
 =?utf-8?B?TEtNd3lWbUZ4OTZPelFaeHA4NXIwNXNqQWNGbUhwKzVsU3ZwUFBoYVU4bXRB?=
 =?utf-8?B?ZENoSDh6SlRNdVVOL1F1Mll1eEtqelJGQ0xNK0xwTHIyQWkzQjNlc00wM2tp?=
 =?utf-8?B?V0prVHpYYysrYS8rR3dCN3J6VlF6V09qT0NzbllRNmcvUUdMelpuUjRUWHdj?=
 =?utf-8?B?Sm1XaU4zMjVSOEY2NWNRWWRwUXh2S0dLWWFqTXNlY29GTXVtR1lNRm8yeXR6?=
 =?utf-8?B?TnRsNmQ0MUlWVW95QzRPVzJ4R0JWTUwvM0h3MnlqdE12YnNMaUNnNDBpUEx4?=
 =?utf-8?B?VHRjeFBoY3dLeXRlZGdlc0JVZndWMjJ4Ri9wek4yMkFsTlhmcDdvbDArZDBs?=
 =?utf-8?B?dUgxMUM1SXNBaldwWWJOOHEzaUY0Ly9pMklIOE9heVN0ci9nNmRhRWd5V2g1?=
 =?utf-8?B?MGRJK05zUzJlN3I2ZldkVWduWnJOZi9ObDlXLzdRV3p3K1NqY290b2JjZmZE?=
 =?utf-8?B?Q2pqdW1lTm1SWmFXUUVHc0ZpSjFnclU1TUNVR1NwTjYvbHBJMWY0bGZMcFp2?=
 =?utf-8?B?dXBBVjdrejM5K3pUZE5aS2dkYVNvUUZQTExsOFFmOTlZQm92U1BsYzRrSG5K?=
 =?utf-8?B?ZjZGN1VJbDV4QlIvN0VHMFNCTmcxYTBzcklTdDAxNTFZK0U4MXpFT1U4ZGV6?=
 =?utf-8?B?UVV2WVcrNXpMd2FNYzh6ZDQzbHlPOGM2dkN5Nm5hOWJKSzBMQS91MU5iME5z?=
 =?utf-8?B?N0ZFcTEwN2FwT1BOeWhQVlZCZ1ZmcE11UmFKcWpBRlBhdTJyNUZEWm5TbjdI?=
 =?utf-8?B?TGVLd3RjQ3krREFFYVNDSGhXWVMxeGQ2Zkw4R3pUOTFwNTFHVHBJUzF5OFJp?=
 =?utf-8?B?ODcrdFo3WFpFQmw3QzdkS0cvUzZkbW5Bd3JTeDBFNVpvMFBXMk9HN0Y1U2JU?=
 =?utf-8?B?M2kxL1VPNEdIRHprNFdyVmh5QklBN2R4VlVCbmE0Q1RxM1dCV2Rnazd5azFM?=
 =?utf-8?B?dFh4VUlyeFhuOCt0RkJaK0FoV2grcHFCZjRGUHE2bEtLaFM4SktsVWp1S01K?=
 =?utf-8?B?RVVzVjBXcExhTHJ0UjlSRjRFdXRhSEFkdzJFSWhmTTFCc1U5Z1dwdDNyYkV3?=
 =?utf-8?B?dUJJWC9CNHhWTElxNkxJMjJFL052TzV6L0R6eHNqWlArc09aRjRIZlA5UlR2?=
 =?utf-8?B?OUQxSm9BM3VoNkFCL0dlQlFwdFo3RFNocko2RGdoRitvcm9KOFIwSW5XRnpW?=
 =?utf-8?B?c2NCS3NYT0dLenlJcWg3Sk56RnFHZ1V0cW1tRk4rb241aVBNam8yWEJQUk5w?=
 =?utf-8?B?MzQvSHJsNmtna240bm1EZGZVREdPSWJnN0VPSEViNzloU2dOREZPTG4yVXRJ?=
 =?utf-8?B?NXY1ZmYzL2E1ekgwV0t5djFkLzBxTzBoaXJSSFMwZ0diWmU0c2JucWVqQ2V3?=
 =?utf-8?B?RVhhWlJ4T1Jjdks4QS9lN3BXUDRnb3dRVDlTdzFYb3hFei9xeE5XM0J1L3hW?=
 =?utf-8?B?aDVGQmVYVWVjbFhJTTFsSDNoa0FaVC8zVFlLck94WEU2OHBXMjRLVXpIc2E1?=
 =?utf-8?Q?hI1apdiW7z5ZkQ6+ODZ8nVlRP?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: GYaaPbY5qECRgplieqgBYDApX+V0gzJ4pAtd0M80VMCtDpr0MRRPFKcP5xD910Sn50dKYZAHXivgW6lDCJrXjJ4egF6T7REKr+QQHmUqELnkqyj/8HSidcCLakeEDs5EFRLHHBGMAlW78lrXNZzUr5eepYQMm0gQO3iItX5ZdeZZDnXeZSOVvbpwNnyUmjvkyAH/zS7yaOAM20YSVcRFxbc4w84WP20xEOO6N0zU7wqt1WMFApv8BV2c6lMyz1+JUTwYscsIsiiLeAD25SRz6x+6NHSbfmuaI9R+YW1oEGkJvC7GlPnHyu+F4/lBYn1jNkoHwMrsKBeq4lrPjckAq65q1rDtqJoQ8X056WTvMJoKAR40pEQpFwLDofyje4KgMvpc4ySObNcAo/xTEPHLvsjPczfegkcjznOoVazDdOnOWgo+SjqyoxzB+9/A8pIj8pnJhsgHT4aX77t00Wis7c30r/ZHCfNQcDt/HsyHPEVfmx+tUkzAKsG//TCdJZ6c+ER12MvyKccubo7xvDkvber8TiVIseKDXHf25w9X0XJXwUHhBAs5zj2CXxhIVj+dkJjzSYOrzn9Q7/xGrEeyEkFYCCEUz86V8NRFFBoDxjai5JyDHE0dxBQqYaPnKLqn31WnNiNkdUDO3zxvd+xX/j6htUd1qmu5HBVhDzNqYXlEr2iAuTn4drHl5VIT/MCtlKupvO92ByKL2/k7Y/A7/uUxK7YwJ2Btge3TIGjnI1tlSdlEps6F+ZV3hftnTpbcWs+4tVtIrsmAvFt/yhDt3wpLh/WMpRGHD26h7Ku5gFj4hVwGoDhO+xmR/x+Qr0hMVbZTEGTOdFo9gyFqSl35d+RZnJF2pEQ2w+6PkiN2k0j/yowa4Nqg8LaKbiA1UwXF
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32415271-345e-471b-8f2c-08db82c8cf22
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2023 11:11:58.6701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vUYBgVxsgNtWC5BZLo0Wx+2GCtaziKV5wzsOXkg1mlEaxsETplij3UdJFIYNgCxC6Mq+QlVrDwWkOCqQZtZqcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6050
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-12_06,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=969
 adultscore=0 suspectscore=0 mlxscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2307120099
X-Proofpoint-ORIG-GUID: T5L5VYxH9DF32RTXqF26xMQaKnubf9S9
X-Proofpoint-GUID: T5L5VYxH9DF32RTXqF26xMQaKnubf9S9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/07/2023 22:45, Mike Christie wrote:
> Allow SCSI execution callers to pass in a list of failures they want
> retried.
> 
> Signed-off-by: Mike Christie<michael.christie@oracle.com>
> Reviewed-by: Martin Wilck<mwilck@suse.com>
> Reviewed-by: Bart Van Assche<bvanassche@acm.org>
> Reviewed-by: Christoph Hellwig<hch@lst.de>
> ---

Reviewed-by: John Garry <john.g.garry@oracle.com>
