Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD294C4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Dec 2022 10:12:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiLIKMo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Dec 2022 05:12:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiLIKMn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2022 05:12:43 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDD59AE76
        for <linux-scsi@vger.kernel.org>; Fri,  9 Dec 2022 02:12:40 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B97nY6F003546;
        Fri, 9 Dec 2022 10:12:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=qbnkrxzAJiJR1hhdZdXy3hEl/nuZYM0OoXqcN01u0Ag=;
 b=OzaX4U4FSMZsA36ye0ts4/S6KtghQMJo1NMIOBx/DjEBThCO/LAXswnz0jl5s5EZz7Hv
 ouPyXuKxBJ6CVCW1ZSlgtMO2b6Z4Crqm+lmKyb5L5MQibdsKYrulx0GdAZcZePbykcF6
 kF5VHcYd9+ghcCPDxygNYIfvztJmdbnfOKOfzfheZHm3fL/wixH4Pk4L033l9+Sh52RW
 PajUFqxzs8SSbB2URIW9E6nD2bTTi/1inYsetPHNfxI3T9DKvvrf994hl0LMGTE/YY6y
 2Mvd9LP+XHSnxJCZM0Aj/A1GR7N//yx3wuxbiDA2paen+HCg69hp104YD4tAlpJ9uBvp pw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mauf8mr2v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 10:12:26 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B99EweG019625;
        Fri, 9 Dec 2022 10:12:25 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3maa8k4t1t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 10:12:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MllphUzukasjG9YBL+q0jMJ72CTKX9EMkw/LoiOLgjAEy59Wnvm08ruAZAn8+EjXxduARUQow/AmLq0PtkcNqChybqv9FxxUsvtXxoZskdFTJ6NZ/VUME00hPxDC0qLFQG1f2WN8gn61Daupxlm/OlYqHXFNhfON/bxI717UNhXbOtZuV4ntS7wkq0iZxvTO6VM9NpbXJLFdhQHbjpKRFP9AoOCCD+Frfh0lOnIt2rNkq6oaGa7Q51TOYHoCTcW/sKiP/+nnHXo7HlhhMp58gtGugNtOe7cfe5L81xlpdPZjxA6t6SB7C/eFaryR0AFhG2Qg33UZjxbhq5jubvrxQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qbnkrxzAJiJR1hhdZdXy3hEl/nuZYM0OoXqcN01u0Ag=;
 b=mGwAVb6TMXxuCnRlljdjyjNsjGZOAeCZXvaSCovbG+bs+uGD6WIl0KvM3r7cFKI1Nr/Dd3W/tiJT1yqvR8PgmKCbOLaPZRf6SiNBr39XL99DgovzRapHgLzPgKrLGrTLtV7vGdj3I7Tykz0/6oL0FSuVmWxeGrfZhrjRBTb5Kw/juchOMdVNnlJpuTCOWjlAt9G54/rFe8UL0EEObv8N/NNk0H6kZ95SwWhxaLmeaxKNWse2z4zIwkd/tztPdtv/SmHURtUGVhKWxgGPRos5ftCuT95L0QpyJ6tooHfqy84WyvShMqTxDiY6lW8TJ+35AnyWyksKyUFjf8XHOromjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qbnkrxzAJiJR1hhdZdXy3hEl/nuZYM0OoXqcN01u0Ag=;
 b=LuMlnSca76nqRrt5fZtWt1rtCaa/p0feSJ1iz8PHeJD9NaDn1XA2pztkAjYvEOxt4StZ1aFsP4dtTBZhcIs66HNFDRZAadWxOA6RBbOz5v89TajBrrKstTFAO+jHniBIlzNPOnxNM0dSVFR8qg8ufWv0Rx1bYx+kLWDxQ+523Ro=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS7PR10MB5135.namprd10.prod.outlook.com (2603:10b6:5:38e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Fri, 9 Dec
 2022 10:12:23 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d%9]) with mapi id 15.20.5880.018; Fri, 9 Dec 2022
 10:12:23 +0000
Message-ID: <c0aa17dd-e56a-be01-16e5-fd11f096900a@oracle.com>
Date:   Fri, 9 Dec 2022 10:12:18 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 08/15] scsi: sd: Convert to scsi_execute_args
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20221209061325.705999-1-michael.christie@oracle.com>
 <20221209061325.705999-9-michael.christie@oracle.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221209061325.705999-9-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP265CA0035.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5c::23) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS7PR10MB5135:EE_
X-MS-Office365-Filtering-Correlation-Id: 55b5c957-faed-4052-d448-08dad9cddd7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lBkcNFMBUGCbc9/9iC98K1gbHlHp6qYBOmDi0mEBGCUq8Ak8Id7BWCRyMvz51L1XWWU9CbNYYhD9NDDnk8h08lw3XtoMIEtIhTQlic4Wf7hQqLGa2j1t9vT1Iozwsupns2hiAUo0KESEMLfjHRH9OcD3HKdLRXKwnEWOwF1V5fTGGyUylXgLRmawYneC2gGpzX2z4pPS1OiDTIuxOb5mA/ZvPRLb3Im3DwE6vsY873u/nQ6XvDs5aONhsUZokILC0DwueslukWZaNYnt9RyKv8ZVlUUoW7S2B4PFdnDL72/IXfwrkHRv/7hn5QkDVvvsh/qvGVeIN6lSPyknut/SxJEDXhVbzvZjO41f0Cz/TAdA3ubBNqubBgTXWBLvSoPiWOn8yApiXaagjPDsw5gXVpbEnaI6Sd/f7vGmW1tTPHRtL1x8E66lDP4lqa+yZd8lCXa5wofddol4294NZbhU1pyy+3Xzyljv78pIehuOLZ6l5QKCncB5/wBtOI8e+ovp+yFhM/TEnW2wYNbieGe1ZIuKSnD0O5yzF6yVxbG9ED4DVmBEBxPCclOXHFuSBsKuD2ZX4ELfEquN4zy0mqjnJADl7ClBYOdk84Foinezb5j7/3dqNs9wx6xFjGTwhNe8TbwBLUxRbatMbtFJ557Sr9KPth2K+TLO8kU/C3Rz0MOa4GbeKUNxwoKebIQitqmIUQkl5GAxxfzRDtgoO9by9WEuoqc27z+dcX8OdbnHlwo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(376002)(39860400002)(136003)(396003)(451199015)(31686004)(86362001)(31696002)(6486002)(53546011)(38100700002)(36916002)(478600001)(26005)(41300700001)(8936002)(6512007)(66476007)(8676002)(6666004)(316002)(66556008)(66946007)(2906002)(186003)(2616005)(558084003)(36756003)(6506007)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eWlOWVl3T01remU1R0laYTY5VjdxaUxKSXhIaFZiOXdaK0ZvMUtqZlI5NHFq?=
 =?utf-8?B?YjlyVTlaQTBxNjZTaGJ5TGxFQkVlWFBQRkhwMWZtd2VwYVVydUlaWUFnckpM?=
 =?utf-8?B?Wi8vd3ZMZXl6MURpSlo3TUhJbHFCMGF1WDR2M21uNXJUWlRoNDBWOXBTalJG?=
 =?utf-8?B?NlFMSDVjeE5Ga2s1YWlRRFRsSVJFZWRVamF2ODdra09HVEl1WkZqcVlud2Nz?=
 =?utf-8?B?SUVUVC9jTUtEL2h1VGJEb25TY2pNYjBTSXgyNFJHM1crUHQ2bUJRamt3ZEIz?=
 =?utf-8?B?aW1MbmJvb1FGK1h6M0NzODEwM0s1S1dlZzk0ZGZoNXUxZDRtRHVnYjM1aGFI?=
 =?utf-8?B?QjJBVHVHamFGcHVsdExpZFQ2bVhMM2V6eU5HRHBqY1NNOFFOWkppWll0L1c2?=
 =?utf-8?B?cERnVzE4NEl5ckxMcVcwaUt2ckZLaUc0QTFjVUhGWkVvcTNpWERsS3RzemxY?=
 =?utf-8?B?VXB6cDRETlVqRGlWZEpLRm9jd29RcWF4b3RVN1ZMdTZKOUV3MnlxdkczWjhB?=
 =?utf-8?B?NWZvUXBiOXgyS2gwWVpFZGVSZ0cwbEtYR1lsUXU2VVhKV2haOTV4M2tuc2xr?=
 =?utf-8?B?RXpETTh1dHI4UGdyamt4ZmRtakV3V0NhRU05eUdRODMxa08rK3lMbmgzV2xV?=
 =?utf-8?B?VlZ0d2VVMkM5UEpaTVMwSEJzSnN3YXRDbXY2SE5Rb3ZSK2dJUTlMWGhxMkQ0?=
 =?utf-8?B?d1BxTForT2tEem0zMWxrNGJLV2htY0dEOG1IRzBKNUlBeGJrTDVncTBlOWV0?=
 =?utf-8?B?aDQ3SmU0MWprWDQySjdxbGdCam15cm9sc1BQb2k4OVRqR3BDS1pIQi9IYS96?=
 =?utf-8?B?NThaUzRMS2FlRmJ5a1Y1cmk1WTNySXVKVEw1Y1FLbDlsRjMvU3VCQlJGVjJo?=
 =?utf-8?B?L2p2WkE1Mk5ZRmcwVFU1aisyTCtrL3VsWGtsc3JORnJwS3VJejhRODNHd3l1?=
 =?utf-8?B?Y0g2MmJSU3NORHhnUjhkSjhVeG5DdkFpVUYxcGVEYTZBSWErSi9sSkU4RXdP?=
 =?utf-8?B?U1pMVThBR3NKTkYyRHd3UnErNVJXRDdKcGFvVGJmWENhbGtwQVZMT2FLMkdl?=
 =?utf-8?B?S1MvL0ZuU21IZXZIUkx1QXk0ampFRUtoalVwSkZGTXZKZGM1ekh4RExWS3Zt?=
 =?utf-8?B?YXFsOTdKRmMweVNxYnYzQzdjS0xmVmFRUXg3SkNDam1OOEdGRW9HcDFzOXpG?=
 =?utf-8?B?TTMxdkIyMzFXU295YmJ0V3FiaGFaeUN5MHlBMFl1NEs4ZGp4ejc2UmZkRyti?=
 =?utf-8?B?UEs4VDBGOHRRRWJ4U3dzRnZUU0EyZmk0N1dxdjdJZFYvKzFtMmVRcVp0ZHlG?=
 =?utf-8?B?eWxwR01Xakd6cFo3MndicHZJcnhiUmpOcHZyNWw0UHJmZzZmM0xBV0Ztb2F1?=
 =?utf-8?B?eVhLZE4xdUZOaHFoNzZpMmIwUFBxUFNUWG9OcVBjbDR0UjFsMWQyUVBPaXVR?=
 =?utf-8?B?RWRGVFRpdDdEdnVCRWVuK2lFTnFOb1l4R1NiZWR5N29UL0drRVpudXluaDhp?=
 =?utf-8?B?RHFiamdyOXp1UUVXcjNGbXFtelNYelEvcnpuRERyOVJkblgxK09nVUVkZkNK?=
 =?utf-8?B?ZFJwODU2T0FyUGEzVGJESzFHS01xRmV6MzhySkd1U0V5YkFWZDA0TTYyVGV3?=
 =?utf-8?B?eDludC8xMlF1eDd4US9mL1hXbkhZck5QRUhKTzB5d04xemlCb3VFTlVEVVNM?=
 =?utf-8?B?YzRpZTVLdXJnSEFiSkhvSGJOM3FoVGRqWFpYZEllb2ZySGUzMmxDZmZJZjZ2?=
 =?utf-8?B?WWQrb1JvSzVwMFJXK05tMHhjdG4wdUlWTUZhL2VzaCtaKzk2RzBjNTRkWlZj?=
 =?utf-8?B?dzVmNkNYS3pINm8wSTNCcHBQRUFDZ3lwQlJlUXQ0bXcxZXFzUlJtU3p0Rkoy?=
 =?utf-8?B?UDR0MHZNT3kxMWRrRW9vVFBLMDVZVDdBQmRFaTk5MnJjY29FcHk1THdYbWhx?=
 =?utf-8?B?Z0cveXo0K1MrVlZ6bnczNklFZkZGK0hlYzFiRVBwazV3WHM2b2pQZGowTHdX?=
 =?utf-8?B?eE9tVVBTVHNrZTlXYUc2bXRTT3lidkxFY2wwakZOVk56VU96NkcxbnFSRk9q?=
 =?utf-8?B?byt0cW1ESEFPd0FPcGVBSkJjMm84aCtYaXBOd2lhdFJUdGlCRjZHVE0vbUNv?=
 =?utf-8?B?b2RHSWNTUmdmSUJCNHNzd0ZldzYvUUZMYzdkVUF5QmdnNWdVbE9XcXZjaC80?=
 =?utf-8?B?RlE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55b5c957-faed-4052-d448-08dad9cddd7c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 10:12:23.6314
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9WFOC0kZCva4NUTTXRgHFfSYd7MwDgtbCbJbBz3QOxQoM8SY79guBKzrqyzhD4lHy98m5UXc9fKF0OuaXnn/FQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5135
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_04,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212090066
X-Proofpoint-ORIG-GUID: j3BlxaP2FumH8DBjdwoSjXxIpvJx9M3G
X-Proofpoint-GUID: j3BlxaP2FumH8DBjdwoSjXxIpvJx9M3G
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/12/2022 06:13, Mike Christie wrote:
> scsi_execute* is going to be removed. Convert sd_mod to use
> scsi_execute_args.
> 
> Signed-off-by: Mike Christie<michael.christie@oracle.com>

Apart from nit:

Reviewed-by: John Garry <john.g.garry@oracle.com>

