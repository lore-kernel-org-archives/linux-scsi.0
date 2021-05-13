Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4187C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 17:37:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AF0261206
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 17:37:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbhEMRiV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 13:38:21 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44666 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbhEMRiS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 May 2021 13:38:18 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14DHUeRj088787;
        Thu, 13 May 2021 17:37:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=U1oJ417iTjXappnSvFRN+aDwaCDbp5GvohrbH5vjXlg=;
 b=Wve7sgpyYc5Dokwk8PfToAGdpcC09fEz3iJgZ/TrpIFi6wOO9Tv4UwORPNgDV0KpSenA
 eUHniWO4ssveJ0CsjWQCf3noi8uDaRiGxg1piBFBjFmC+AE8QJA5vdS3ETdPOnYIT6VT
 H8jp9+KFInWYfDLyn7cqnWW4MZb5EbKTcbgC15NHdWymS8w8seoG/YXizeJDjtV61afi
 sw8xceX9v+jAhy5Qjmih1S49Jz2IWxlWznOHEavX8aUvB0eD/LKPhPWwEOc+nvGISHqX
 aZd8vzzJ+KelkhsTUfSBg7P6ywtni35tWhVfZV97mzj5vrBrwXLZsU9dI5rS+ssiR0Rp gw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 38gpnxtbyb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 May 2021 17:37:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14DHUoJT003456;
        Thu, 13 May 2021 17:37:05 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by aserp3020.oracle.com with ESMTP id 38gppbw2a8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 May 2021 17:37:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H0w/X3nJqRgMotVpwB0NvC/hKaTnY3JSsUPccazjdCKyPUf3FFKoUWXI6Y05XL0xkJmJdoUcuANOM9E3GWVALplzQBWpJBuBJ284ZrrLH1zqWirKsDj1vz6yS83MTeuSYTK+2Wm3hyQL9nXPXqKwmVskyee2NhNqUFTEe84IZR0Odp5OyUw/QFq6S+737cEYaGZVM11SxT+hvkgpwQRdPsAbn3FbX3/LiLUFpeWRtdS08TGJ4U4YKaFfcZ08OlODuRvTCCZYUCzatQEW6bev1aAQkHgoI2YTKfFUZHGN+Bq6wm2aoIwPr8D9E8H8km7GyU9ujlRg9hKX0yZ8gffXdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U1oJ417iTjXappnSvFRN+aDwaCDbp5GvohrbH5vjXlg=;
 b=Tg+utIUZonu6rulMH5+mm6V0zAM40sof1u90giKRaEU0b2BSuCIDsv9n4FciQ3/B1jpZUQ79fKo9wz7R3+I93zBPnchTnCcVHtyxpybSYo3KEV4cAbI/uEW8EHHjs5AzhCQgm/PzX96MexklFX/yGU3a5sdUyMtMC9axIDNMVUy+XiW0fjUZvn+npSFuKWvw2L4Qg+6ujL8kAeWtw4SMoOP9AFN8yJfRN4EqOqR/bfNdEvya+sagdDIhxVFv3Ttlz29yyCSFc0jA25FVN6WxxBkg6w8XRE6PUE7h6fp+pBMZvVTysuAvL7sF97hgUNK8D5VT8RrhSmEH5DwF9azkXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U1oJ417iTjXappnSvFRN+aDwaCDbp5GvohrbH5vjXlg=;
 b=nuWhYZCRfzxoqSTSNIIKsnmlOY77D0bkU9LmCZlpHSLNY/BsYuSa/+O3XoFrT9BynYEhTCIg6e6SGYk/DKAWUpJpg+e7SIQLiPoG0L10ATmBZg790X4+aG0NqJyxFP8KY5HXjiWmXS2TANHgQKBBDqkDf52TdwexyQrN5JXFVdE=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4163.namprd10.prod.outlook.com (2603:10b6:a03:20f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Thu, 13 May
 2021 17:37:02 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4108.031; Thu, 13 May 2021
 17:37:02 +0000
Subject: Re: [PATCH] scsi: target: Avoid smp_processor_id() in preemptible
 code
To:     Bart Van Assche <bvanassche@acm.org>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
References: <20210513044944.1572404-1-shinichiro.kawasaki@wdc.com>
 <d25b35e2-5ed6-4a00-56f4-71f31463ba1a@oracle.com>
 <58bd8a10-a3a1-3d87-0342-f6d49f5fe808@acm.org>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <8b78d77c-2d27-8a5b-7b98-95302fbe9ebc@oracle.com>
Date:   Thu, 13 May 2021 12:37:00 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <58bd8a10-a3a1-3d87-0342-f6d49f5fe808@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR11CA0055.namprd11.prod.outlook.com
 (2603:10b6:5:14c::32) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by DM6PR11CA0055.namprd11.prod.outlook.com (2603:10b6:5:14c::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Thu, 13 May 2021 17:37:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e53f839-019e-4ea4-a701-08d91635b7fa
X-MS-TrafficTypeDiagnostic: BY5PR10MB4163:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB4163F8FDB7DB9BF63AD1319BF1519@BY5PR10MB4163.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:576;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u0/np1abP4mLYlvKKBb9iMGIuB18DYjli+IGOuSzCH29TIUkyS3OZTrLXjXkqUQ1BJdNH+EzPiXUxmoD+2OT7XuAFfdm4yGyNVf0maaxivvnkMri+CS9mlN4B6FU3eDUqcw6jxLjMl2a0URPg4fj/z71fFsdplgerNQSU/1/ZA6auNizbvdMGU4oWamRmqYI5XRa0bM8eFgrc4KbaO47ECYzVpAryK3yIsjNOrAYaD55YPtK187s6QFj61wDEfwlrHkyIruSuSW81ezODBvk8/bEZV2JxJQEq/oWdWdYWyDb7XtZ62FU1swqcKjXsEG3ExFIWsTnoL4cHlnQQpHe05Z7ImjJHPTTyJvM1avlPk7wVlozRJ4HdvgDO1Nt8aBsnt3UbqrXxywlmRrSM6lN7tFCWcQJM56knEim6s1JRD2n/5Y62Jm+1H0FKONAWJCcxxVJ7R3WGa1oYwFxnQH3sNY26ZUbOPzo7rC6HMUS5Mkt8n6rRc76/7qJfIYgFudC0RMw318dLONLRv4HZ2Pd2kprzYUX60pXXDQLcnNYbUMo7PKX2nWpyrnwSxTuvwXBuszyvwjnAY5HnAeIu+Qod4Jl1rPqg6J+Abh8E/xQT6dbjVvg39URqWi6AoKPgaS3j91VMzO+j11JyqzjOC6n8I+vVU87XBi+uur47PbRA/4sNln73jw/8PTaMNh/sPsFwl/mi4uH74jSkQSnEd4HqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(376002)(366004)(346002)(396003)(66556008)(66476007)(66946007)(4744005)(36756003)(31696002)(86362001)(26005)(478600001)(2616005)(186003)(16576012)(316002)(16526019)(53546011)(54906003)(2906002)(83380400001)(4326008)(31686004)(8936002)(6486002)(110136005)(5660300002)(8676002)(956004)(38100700002)(6706004)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?V2xTQm1hREoyaTdwT0RrK1dhZTRoUjZMWjlPaEhJaFdYbDRGSFJhdUc0S3BH?=
 =?utf-8?B?d1ovdjNUbkVlQVRQb3crUU9hNDRNUGVGbm1PUVBxUlFxUDlYN0FHVFNrZkhU?=
 =?utf-8?B?ZnNaOGx3Y0pNalJJdnNrbHc0UzQydi9yQXJoZFJHUUh0N1RiN3FGSTYwQ0I1?=
 =?utf-8?B?alI4N2JDMWFmcWJQanlyQ0FLRlplYUk3TkdvaE5LcHdvZ0pKendpb01McENK?=
 =?utf-8?B?dHMrdXowVjlPc0kyU1NsR04rMmZvZGU0SzQrOEtyYW9TQVB3YnBJbG9zV1Zn?=
 =?utf-8?B?OTVqT29EbG12dXlYVSsvZUp1dkFEditxaXBWNkJQdHg1eWxHN281MzhURVpU?=
 =?utf-8?B?R2FoOUhnemhZNExMeEQvMlUveE1rZkFyNTg3TGYvSkZ0dWlNU0R2R0ZRTE5l?=
 =?utf-8?B?bG14T2x2ZTdRTDVUOERpSng4VVZ2VmxKNDFncUVNSStpdHZCUDE4OHVQSmJM?=
 =?utf-8?B?U3hDVmU3aU1LQStNT2RuU2FPRTdLYmtqQjVXNU5FcFE1RUk3NFJDdzJtU3Uv?=
 =?utf-8?B?UmcxbXdmc3V6R3R1Z0ZWWGwvZXZDS2xlekRESFNYeEE5enFBQUNPSTY3UTBR?=
 =?utf-8?B?K2RTdjFhZFE0anplVldYcUtnOXJJbWhPZlF6MXJEUnpSZUVoaHk4MVNsSlhL?=
 =?utf-8?B?WlkxV0U1YURYL1JhU1ZnVTAxb2JmcjAzeUxVK3hTUVR1YjdDMFcwM0ljei96?=
 =?utf-8?B?UytYZGpUUnA4QVY1dS9CRldFUWFGVlNTa05XckZsaG9vTW1jOC9TMUJwc3V4?=
 =?utf-8?B?OVcweWJYUjJHRGJZTHBzZHpZcGlxb1JDM0RUUzhlYmN0THJoSkluNDFrK00w?=
 =?utf-8?B?OEloSjNjdHF5RnpWeGFpTm5ydmFjZ3Y1RzJGOHRPK2Rad0o2R2RrRmplT0Jh?=
 =?utf-8?B?a0psWjRHYVQweEFUK0NGUGNKNTF6TnNCS1NoYWxZSTVOS0VtVHNXb2dwOVF2?=
 =?utf-8?B?NDBieDRrYUVFODJPZXlVeUJHRitnUFNpQ0JpaytMM1c2OXBIK2FRUTJOcitR?=
 =?utf-8?B?T0hrQmV3eHNhK3NXSmNnWm1jaENQOUQ2UnR0Q0UvbXovQUVKb2RqaldZd2Mx?=
 =?utf-8?B?Ym12ck1BT1FNRGxoVEJvVjlEdUgveFVOY1MxOEFxdVJBdTFLeDc1RTBqQXcy?=
 =?utf-8?B?STJFbmEzUWlHU1RXa3IvNEQ5WGViMzJZaWRPQkw5SURvVzlOODFVNTRKSHpL?=
 =?utf-8?B?ZkM1aEU3cXdzUGFhZEdjWk1Na3RRS1poazVhd1B3L05ROThmSzZRa0ppYmNC?=
 =?utf-8?B?U0RjVk1xU2t5UkgyKzBSeDcyMlF1UXFKcDRlYTh5dWsrZjVlL2laSi85WlVk?=
 =?utf-8?B?NE54QVpMb0RQWnFNcitoMWk5d1BhbXh2NFJ3WEhGMnBWRnJYR1RTTnNqV0U1?=
 =?utf-8?B?WnhyVHNpeDh5NU5nYUZGUm05ZE5YNUl2WjViQUk0WW5CMERnZWh5elY5Q3E0?=
 =?utf-8?B?UGpKdHdDa2Vhck9VeU9zYVo3aG5NR2p0ZGVESXBJWHZTc21XM0wreWp1R3ZS?=
 =?utf-8?B?aVdOVDZBMUE5MW1CY2pKN0JHVW1Qb2ZnUVJiZjM3OTdtZ1Z2amt6aklhMjN0?=
 =?utf-8?B?QVVZM0J1T3ZGSWtqS3hBdkI0MnZDL0NLdEdYbEl1NU5Pa05MRzRYUzFkYmVz?=
 =?utf-8?B?a1pTcjdta3BoRmxvejZldExCbjQzcU5wVHM1amNsOWowRWZuZ2V5M2dhbnhl?=
 =?utf-8?B?MnBEb1JyYmYwQ2hCdXpWZlJtbXYwRGJuTjZjUzAvck5XZFFsQzFjMG16WU95?=
 =?utf-8?Q?UYaRkD5BjwgQ7sMnsySLHsrseadmtntk1VQAmWC?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e53f839-019e-4ea4-a701-08d91635b7fa
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2021 17:37:02.7329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CRrEUVrhiC6Qu2ySu2SEVZZAIEFuulGKk8OpKkJrBenJ931bUPmaSnaX6S84RM+fDr9IDfNZ9vvDSTUEtnwCUxfEvqX0EhJyGlw4EvTRpyo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4163
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9983 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105130122
X-Proofpoint-GUID: a40WjK4J4R86R4-WODxVieGSTQ5kq0Xb
X-Proofpoint-ORIG-GUID: a40WjK4J4R86R4-WODxVieGSTQ5kq0Xb
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9983 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 adultscore=0 priorityscore=1501 phishscore=0 malwarescore=0 spamscore=0
 impostorscore=0 mlxlogscore=999 mlxscore=0 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105130122
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/13/21 11:03 AM, Bart Van Assche wrote:
> On 5/13/21 8:36 AM, Mike Christie wrote:
>> Is there something else that's used normally? raw_smp_processor_id?
> 
> +1 for raw_smp_processor_id() since my understanding is that
> SCF_USE_CPUID is a performance optimization only and correctness of the
> target code is not affected if the running thread is moved to another
> CPU core by the scheduler.
> 

Ok.

Shin'ichiro if we all are in agreement then I made the same mistake in
iblock_plug_device. I can send a patch for that, or if you want to get
your patch commit count up, feel free to when you resend this patch.

