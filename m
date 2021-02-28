Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AA6EC433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 20:14:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2199E64EFD
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 20:14:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbhB1UOS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Feb 2021 15:14:18 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:43254 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbhB1UOS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Feb 2021 15:14:18 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11SJxU49153315;
        Sun, 28 Feb 2021 20:13:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=FGkIazi8HoOBFku4J+l2jzV4S8roWg24OerKgx3mfmA=;
 b=i/gZ72XQSr8AsCKR1lNe0gdd7pdbf7HItVpV2qwKznFHuTrhqGrrlJfYJvWFWldK7ewR
 f5jEdNV8UDMohndjSWphET1SzLZUdeBeoI6E8s16xKuy5VuIp86+P7/9DLpxFBGzwO0K
 +IDyhTAZaIC1pH5adQIg2xCEsZtr6QYbfEbbleEs6TCiY4XaQsrofhAEPuuKW5wEPfyn
 EGQ0yp40aalzZdh7LfYv4NPOXkZdtk+6cYhv1DsqtHZtW5htb8r8rUnEvbUCTr14Y976
 yov/EeehCmdq56P23d/acLOq0hIqd0DnnnN+gnKjhNnYhRZXLrS+XuZZHZ7dMU9dZCjP vw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 36ybkb25tf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 28 Feb 2021 20:13:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11SK0pAC023763;
        Sun, 28 Feb 2021 20:13:22 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by userp3030.oracle.com with ESMTP id 37000ups3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 28 Feb 2021 20:13:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UWJE/bEwhFu4yzIZaBBncmHmkmXFQn/aAnLNB9cwMqBR4uLFtiHYTfMfGoFHjF6JLrgE3VOdxdsqY00QLti53ikgCX0I73p/UM2sHVsaofUKu+bqwza3m8IHpinnySMeT2DjHbGJM5atD3E6YA4faBEyyoscRQVfF/IFWlr69b1IXs73r/rcVQga8cUCYzBFBl3bCx7KX0G2vxywlfNXrj5qlGs1GNWet1i4hUdF3OFLohXIX2OAsob6LojighZ77/ofg5V8+mGaCh12atOXDbmTfW9gTaFqfcM1kgQ+hH3cIi7xKXWs91PUraYiQkL7U4lIAFXAUkW01QFbdoqa/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FGkIazi8HoOBFku4J+l2jzV4S8roWg24OerKgx3mfmA=;
 b=eIgNj5zVfy1bA18PYQBHu2A/eXDQDaTg64ZPgYsGCjIl3IuMTtZ6L760xC1+iUYsaIAYEEfQDZYJgbMI2df9904MpUTjKUehZ73xEjxvFENyIlb1YNNCj//lyC+rruqZAv7k2rS37mQ/Vq2ynvUvp6dMH90lkD1Jmx1J1lSoJMNJlWCd6vq8MWciidQqOFzuqcemGxsUJCDJIFgnoXf1ROObnOxqQfvRHocTe3RQU2P77YqSUW+x0peqzaM2Z8m9fHKsu64OAMA0QGgTVzZ6v6OMi2scikOh8rrkne42jV9JcEf3FuWV4KHkjzvHRS1FztH0aELLnAgnziRb1YuR1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FGkIazi8HoOBFku4J+l2jzV4S8roWg24OerKgx3mfmA=;
 b=kx9AmnGF/xbeWcx4DU2lY9ut6kt5z2y0x33vCL7ODZcTe+2zQ+Sz8qfgJ6azLLuVvNlNsEC7/n5EcAmu8DEiVD4Mhb6UhnGtm1AEfgU5eBstBY9UpD8f+X8+CYkI36XOwAxoSzq08NbGbNQd5CPDgvgU1L1vin1BacgKrIbEfbA=
Authentication-Results: bytedance.com; dkim=none (message not signed)
 header.d=none;bytedance.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3577.namprd10.prod.outlook.com (2603:10b6:5:152::16)
 by DM6PR10MB2539.namprd10.prod.outlook.com (2603:10b6:5:ba::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Sun, 28 Feb
 2021 20:13:20 +0000
Received: from DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b]) by DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b%7]) with mapi id 15.20.3868.034; Sun, 28 Feb 2021
 20:13:20 +0000
Subject: Re: [PATCH 00/23] target: code cleanup
To:     Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, bvanassche@acm.org, houpu@bytedance.com
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
From:   michael.christie@oracle.com
Message-ID: <9c0901fe-5955-5bf2-77e9-b12a0d2c4f59@oracle.com>
Date:   Sun, 28 Feb 2021 14:13:18 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
In-Reply-To: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR14CA0010.namprd14.prod.outlook.com
 (2603:10b6:610:60::20) To DM6PR10MB3577.namprd10.prod.outlook.com
 (2603:10b6:5:152::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.5] (73.88.28.6) by CH2PR14CA0010.namprd14.prod.outlook.com (2603:10b6:610:60::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Sun, 28 Feb 2021 20:13:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8dadf010-f036-49e6-8b28-08d8dc254adf
X-MS-TrafficTypeDiagnostic: DM6PR10MB2539:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB2539647FADC3B05B15B5AD37F19B9@DM6PR10MB2539.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1091;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oZII2YJlzjVC74kLyQpZMkCTABLVEnFZVXNXJe9gX5qH6FaxqD3Q8RN5nN2N8sTV0PjGEzmHy/jE4GVtG9U4o65OwMAHoEUXDXAFOE314f2VTvrEKifPAlFQZxOkOkXtgk2tF0NnExZBqslZkfIThOHkty9S0XJEzLoklwiPUSVXH25KTk3PNXAxSe5gybnlti/a1XqHhXAJBBkgF7Xwcl5YQhQRyZ54X36RF7z8yvfQripRBRg0YjVF3xDLE756J7KTSQ8UuRjtlXgLBqVtC4UJB3J+BgvpgUee2fJXIFOflhF0pATzJ9xBsS7p+o9lr6w8gRNRK51qszStT9eObqAGU+pxMWt2DrOpTEaCz4wtZGjz2KyHYuIbaR6QhX//xQRaQc1wuvjqZuakXBZFeib74AsCTx/tVvB/9EPG+vzLSpozUSxOJxtxwXYBQaRDK0zDm3xo9qAsOn/uZddX/65kNhQ8UTwwbButMZotStQGP068rc0DSwXiZx3aCxksC+9uypkiQkvv6C9PD7jHPAP5c9qYGQrmj7h62t8WQ2loxWjSjbOCF9ZeyUpaOwzowqbSuUXLSlexJbTwOvcczbVhgHuege6ii1izdKXzFgo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3577.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(39860400002)(346002)(396003)(478600001)(31686004)(83380400001)(956004)(26005)(186003)(66556008)(53546011)(2616005)(66476007)(6706004)(16526019)(66946007)(8676002)(16576012)(6486002)(9686003)(36756003)(86362001)(31696002)(4326008)(2906002)(8936002)(5660300002)(316002)(4744005)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WE9uV3NMM1NPY2VSRUNFNVJ0VGtlK01nejN5Q01QN1pLeWwyYi9NMUdnUUxS?=
 =?utf-8?B?RGd0Zms3d21FYUJyd0JLN0ZwdjlkNUxyVTg2RjlvRHZ4WHNpQUpQYWdqSGZl?=
 =?utf-8?B?ejJSWE9uN0hObjZlSTBiMHFoeEtsSTBjWk1lSnlmUnUvQjBZejByRUUyZjBr?=
 =?utf-8?B?azdvTVl0cktRR2ZUZVU1dkVtQml1OEt3UjJSSXQ5SGMrTFh5cU1IVCtocDdI?=
 =?utf-8?B?WmlMM3hyR3dOUHppU3NYM2s3ZDdHWHhIZ3Z1RzBzS0dsdy9qYTN4SXQvcUwv?=
 =?utf-8?B?cGIzT3ZoS0dwM3I5U3FpeWFBVkU5VFFDd2psaEQrSWZvaUwwUFpSWUlqdzNC?=
 =?utf-8?B?ZklIVjE2bGJBVjdPSHdVSEhQK25SRGJuZDhGUlBoL3ZxZVpPbW16SGtZYTFQ?=
 =?utf-8?B?RU42TFVXQTRJcnViQ1JGVHIwOGZ1NzJJUk1YaDU5U09UN3hiUHUzQXo1a0Rs?=
 =?utf-8?B?ZTdIalZodnllaDM2YllyL1JqQTFJYTd3b3pualc2K2hJWllzZnBvOTY1MjBO?=
 =?utf-8?B?Y2ZYeHkxK2dZM1hZWk9kTERpVWpvdDF3MUplQ2Fma3VWcllJci9Xc0xHYVd4?=
 =?utf-8?B?Z0kvMVRPNzdENDhoQWpHVTRaYTRVejJYQWhmbHJWNzZBOUV3WVEvbE9wcEg1?=
 =?utf-8?B?QUpSQytvOHZRWXUrMmhhU0dCK2R5NWlHLytqbTgyV3ozeDZIcTN6emVIaHlF?=
 =?utf-8?B?L0Q2S2ZHQmxsc1YzUitLT055Q0UwNEQxakYyUmU3MGFxV05Rd054K3NnNlFy?=
 =?utf-8?B?SFh5cUpnSG5TQUJzdWdsZ0wrMW1hMzBYcExISlJFVWhqcUQrVXZlRE5YN2c0?=
 =?utf-8?B?UkNYeVgrWUEwS1pGeDFRVGVROUVCWmRDenBzTjdzTTEvQURMbmhkc2FXRDZY?=
 =?utf-8?B?Vkt2Vmg1L0puY2ZITUtsc3htZ2hsOGE3NG1iMi9nSmh4a3dWRzVWbjAxQ0ti?=
 =?utf-8?B?K2hITSt3MnA4cUQzZTloYmI3d1Z1TVYweDV2RTV1SUdFaW90c2ZFemNhS1FO?=
 =?utf-8?B?OExUZWpGVkgrWFFpcTRRbnJWTnRobE00V0tuWG1tdkd5NG8vdkdlUndldGEv?=
 =?utf-8?B?ZjF2bVRVVTFvclhiM1JoaHB6QzJXWFhMc2VxeWNaVmUveGlTTDgwYTRkdzJU?=
 =?utf-8?B?VjVhNXNVY0hZdEVLYVJSTCs0M29VYjNXaW9RWWwwUklRcWFmcDVPa0lLV0E5?=
 =?utf-8?B?a2NoR3VGK29ndlU4emxPbjA0ZWp0UURTTFhuYjFSMlVIbkxKS2NrL1owWjN5?=
 =?utf-8?B?VVM4Sm4xUTREZHhocTBwUFc0aEF4dmV5NnVma3RqenFaNWVtUTYxa3Vjd1Jh?=
 =?utf-8?B?ZkVUcmpac2FsNU00amRnT3BZRTFBK251UWlOaXpqWUl3M050TjNtSHR6RjRH?=
 =?utf-8?B?VktDd2NMcVlLODBQbklRemRKQ2hZdC9zYXZES1I2dG9lN2crWkd5NC9Lb1Rw?=
 =?utf-8?B?ZXp4dlA2OGRLQ00yUG94elVvdWVENm9nNEo5YW9mOUk2OGRoVzh6TGtETUZR?=
 =?utf-8?B?UDlVK3o5N2xjNlhCbXZuQVRWV3M2djdzdnB5VnZwWmgzRFVpYkFVQ09lNHFj?=
 =?utf-8?B?WWNsbjNWQ3VuT1JwR3QyR3hsZ056S1FGaFA2V21ZZTF3OGliRW1PaDhyck80?=
 =?utf-8?B?elBTakJZempqa0dMNy81YTB3V1JNVkhWZE40MmhjM3RUMVJTczU2ZHJKdmow?=
 =?utf-8?B?SjR4cVlqQVJhcUVHVHBPRm9xdysxak4rZjBSbEJ5MnBYSGxpVzI5K21yMjlR?=
 =?utf-8?Q?z6wlnCuvTp+Qg0LfW6/tKsICvWFFsDdqGILW9gI?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dadf010-f036-49e6-8b28-08d8dc254adf
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3577.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2021 20:13:20.3088
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4V720x7QbdAH32kQhS/OdgF0OoJn9riprpRhthHdpT+M1uWSBrxdjUFoHFgE6WlfR4UVOTv5OVyRQMAPaAcGasKwHpAlwfTEwhCg0803zS4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2539
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9909 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102280172
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9909 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 suspectscore=0 phishscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1011 mlxlogscore=999 adultscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102280172
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/27/21 11:56 PM, Chaitanya Kulkarni wrote:
> Hi,
> 
> This removes unused macros, various memset, extra variable in the 
> target/iblock for bio get and fixes type mismatch for the same.
> 
> The unused macros warning are found at compile time and they are
> documented in each patch commit log. For memset removal, there are no
> warnings.
> 
> First four patches are target_core_iblock.c cleanup. The next six
> patches are removal of the unused macros followed by elevan patches to 
> remove the memset for local array buffers. The last patch is for
> removing the duplicate memset to initialize the buffer to 0xff.
>  
> I've tested this patch series with creating target bdev backend with
> loop back transport, fio verification job seems to work fine.
> 
> Any feedback is welcome.
> 
> This is generated on today's linux-block for-next.
> 

The patches look ok to me.

Reviewed-by: Mike Christie <michael.christie@oracle.com>
