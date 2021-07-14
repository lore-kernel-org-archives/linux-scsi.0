Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06A34C07E95
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 01:17:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D64CC61289
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 01:17:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237298AbhGNBUm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jul 2021 21:20:42 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:52578 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237244AbhGNBUm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Jul 2021 21:20:42 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16E1HZRK030208;
        Wed, 14 Jul 2021 01:17:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Klckdz9Ozcro4K+qnbqd8KnYPGsisoM9NfcOBUTHXDc=;
 b=LoDxEcUVeI/n2T375o6b4o8y+xoHwdQ7TLpvZ1XIDC9qMc7ckZRLA1LKQk2suLVi0Zds
 uiEskjpIPTUmbIL4mUbct86pkab94KeoX+A0MyR/cn96ltLPsHISxMyF6wM5tswpCW0l
 bhcUVxAIvFQmh8USYGSJI+F54+MDa6VA3Rmgel4N+FX2BUHWZYVeUQ18PzAKMB2aXb4i
 jBgxcztmVpdNJzapKnEWxGhhMFlU4iaEm+OUT6oYJ7J0eHnQ18IuRfd/7d/RZG4lSaiE
 6XSdlH3fKZ6tZc04PORnaW7ayIDCqRNUwAtCH9um5/IjG/RNCHqazIJU4OM0+b2UHi0O 0g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39sbtuhabt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jul 2021 01:17:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16E1FCqn092491;
        Wed, 14 Jul 2021 01:17:38 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2046.outbound.protection.outlook.com [104.47.51.46])
        by userp3020.oracle.com with ESMTP id 39qnb1d3fb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jul 2021 01:17:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N0XMBNoQziZ+4TN6umDaSqnxR4voVTnFo8NNzDHMs0Y6zXpDj7Txt3cwYLNV//VALb4z8p4ENlVr9oUP6h4gLfPxWs550CobdYosxBm3X5dXTdI7dkTuUEuu8F6Jv2b7afj7Od2Lvfg6JCswgShuQDrF1DbeNubWXnspFECsT9/Rn3ShezZKnOR3bnZEtEQObJPISjQJDJHC3XhCdxt2Hr8Z1BWt2MIC6OFs6xurRhcJDpyNYOzT+Kng2hW2aWZeEvPmPX6aqIiNkDZ40ZPix5iIP3AJe8W2WY6snpaPUEAyVF+WwbEMYYYKtBMhYEuqLHPwIP4IC99nMdxzHPdbiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Klckdz9Ozcro4K+qnbqd8KnYPGsisoM9NfcOBUTHXDc=;
 b=g9q1bRkB6YgI4p+yGuCYWlwvY+0fXC0zk6DC7NMzdPVBS5vFi0Ite1tYjjNLtDb1CWI+Uu7GlcH/0WOTsS4efzXLVBcd76Up2M5VqZG6qqknO7vATdCCdRFih4pjUkiqFGSWHmNgLQvBVWrJY/V16dNGV6/PL68ttnpCNRqeM9j/F8kp6+Shx0XcdxUqs0LXz/cxW0TGJVAcIK1M0TpL+PAOVNXuaeKZs804pumJeUtsoR0H80UKk0rGIkA7imq18IVxM+yxMwGojZKKdX7HoruiUPgSB49UFjZp7BnlDcPNJ4iUlNkqmxfYakg1jAjTwXJ7lGwFu259QBWXdl8q1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Klckdz9Ozcro4K+qnbqd8KnYPGsisoM9NfcOBUTHXDc=;
 b=AafIzylHXa3GJ4zAHD1CYIFuSnus2Emlvn5hrHamOp759kKv/PtH3GXofzffO290gBVCKs2qs7d5EYXGCSpg72iWjAXTPV7LYHK09FM3xo45z1dGcW7Z7EKylO+FIQ/btM6DivIska7uXZsW7/WXm1VZMFYO9d0T++ItnpoBJlQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4722.namprd10.prod.outlook.com (2603:10b6:303:9e::12)
 by CO1PR10MB4451.namprd10.prod.outlook.com (2603:10b6:303:96::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Wed, 14 Jul
 2021 01:17:34 +0000
Received: from CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::f8c1:a59:f070:5a5f]) by CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::f8c1:a59:f070:5a5f%3]) with mapi id 15.20.4308.027; Wed, 14 Jul 2021
 01:17:34 +0000
Subject: Re: [smartpqi updates V2 PATCH 9/9] smartpqi: update version to
 2.1.10-020
To:     Don Brace <don.brace@microchip.com>, hch@infradead.org,
        martin.peterson@oracle.com, jejb@linux.vnet.ibm.com,
        linux-scsi@vger.kernel.org
Cc:     Kevin.Barnett@microchip.com, scott.teel@microchip.com,
        Justin.Lindley@microchip.com, scott.benesh@microchip.com,
        gerry.morong@microchip.com, mahesh.rajashekhara@microchip.com,
        mike.mcgowen@microchip.com, murthy.bhat@microchip.com,
        balsundar.p@microchip.com, joseph.szczypek@hpe.com,
        jeff@canonical.com, POSWALD@suse.com, mwilck@suse.com,
        pmenzel@molgen.mpg.de, linux-kernel@vger.kernel.org
References: <20210713210243.40594-1-don.brace@microchip.com>
 <20210713210243.40594-10-don.brace@microchip.com>
From:   John Donnelly <john.p.donnelly@oracle.com>
Message-ID: <137aaec6-ecf3-9344-5783-8dddef135013@oracle.com>
Date:   Tue, 13 Jul 2021 20:17:29 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210713210243.40594-10-don.brace@microchip.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR16CA0024.namprd16.prod.outlook.com
 (2603:10b6:208:134::37) To CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.106] (47.220.66.60) by MN2PR16CA0024.namprd16.prod.outlook.com (2603:10b6:208:134::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Wed, 14 Jul 2021 01:17:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb83a314-46bc-4b17-69d4-08d9466528dc
X-MS-TrafficTypeDiagnostic: CO1PR10MB4451:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR10MB4451F2E7802DA469C49D677FC7139@CO1PR10MB4451.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:296;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s4zrDj0Jz70a5ZcY2e+zg0dwOEoHjSj77R9uthjfO9PqXiLyjdw89QgdxX5bBY3tOe5px2e/jrJ3ptMJwoQ1rpS5gB+rcGxjwZKDfwp29UdmQTOiRZYRLGSLMH7z7oQ2OC7cMjSvTeTw4U+3hXrgaFkM6JQMuDDwhDQKx3eSYv+BGhZisGwJlO0lm4HBDafH7oPrV4+uGTdAHL4bogsH/jMsXmkx/UMRZVJQADHtvYoZZ2M1UYq+CyCCtLuw/Y0zfrZUEOajwHWmX3j4Lc/JdKm4po42f8WLt6hBmPoNrFiv6lezritbSHU3R32RQJbkIBTD1eSoadDK637yCSfnSBi68SS1P5TbImuLIUrznSoBH4tptS4ajXu8p4R0sFdYlLHpZ8/etM57Ni68njbgb8PtPCuoieuYrvgDKYqL+7/++MaKzo10tIVW2NkIdncstg0qpvVrxGFf5rl4oxMWg5hpbgCsHlRTh8kJBXwdQt3dM8uX2nuArBt90zBggSMiumMs3cCUiuFFGOZkXBF4CERyrFNirPGj4uMiikt9Pw/LNLckajSGfXMtqFpaqkiupi2yJCx8utqw45X1GbF9OoRy+063DiKy5VGSyoMek4YtijHbYw2PUKY2dxqI60eFOxLCYc9t8BUEMsHSkVDQyIIu5jcoGt9lpUuLf3m//Ea5cQnJZ+blVypngFMvUx85+6P4nCy8J9o1yjQ4TXnZGc//+4E/UBuuJksCzhlv5V4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4722.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(136003)(346002)(376002)(366004)(83380400001)(7416002)(66476007)(16576012)(66946007)(956004)(2616005)(478600001)(316002)(36756003)(66556008)(6486002)(8936002)(5660300002)(31686004)(186003)(4326008)(86362001)(26005)(2906002)(38100700002)(8676002)(31696002)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TmpTQjBIMEhzUmZ4bWpuM2M5bDVPaHFISmNJM0l3dVdUYXUvTENYUHRUcjU4?=
 =?utf-8?B?aVpVNjZFUzYzeEpFWnVvdjZKS3ZDY016TFNNTVBPNHdUZDNDTXVKWGF6YkR2?=
 =?utf-8?B?QjhReWlQckhFT3g3TXAyUDh4aDZGSVdrcjk3UlcwbkR5M1dBU2M3OWp5eFBu?=
 =?utf-8?B?dTBZQlNkQVdCaVIrL3FPYXFyeVF0V2dqcTM1d2poSVdqT2NUT1lTakkvbUt4?=
 =?utf-8?B?RTQvUXh1b2hGS2RINCtEajFGSDlVQVhObEU5TUhINlA4ZDBIREM0Zy9jL1BZ?=
 =?utf-8?B?SEFibmg3ZnpsVTl5TW5sZVkrOFFjbjdpNGVnWFcyZHJRUTBGaTZSVkRBb1Bq?=
 =?utf-8?B?M2hTUmJmQTRXdENVaGxtYUtIQXZuOUE0OEd0dURvOHdodnU0MHNwVkc3M1Nr?=
 =?utf-8?B?YXRGOGhrK0c1akd2a0ppVDNoc20xWmE4cmlnalhoN0RTVnJ0bTk2c2ZJOWZt?=
 =?utf-8?B?NkYrcTVHelhaM2tPa0U0U0J0WEpZUVd1ZXZVOFROdHRHVXlkak8rN3g1QkRr?=
 =?utf-8?B?K1MvbG5vVTcwSHRReUcvaWdsb1lHcTJlMWpkcStlVXlZd283TVlEdzJJcGtE?=
 =?utf-8?B?VUY1TkdMRUlwelBEczZCRDZaRm5lcXBvSHpPcW55V0VBeHBVV3BhaUdVSUJU?=
 =?utf-8?B?Y2pNL21tZVlOS05USWgxRFA1aUd0YXd3Yjc2cjZYakdlZ2ZxcSs0cG9XVE54?=
 =?utf-8?B?dE1RcVdSdkF3OHQyMzJnQUFRNjk1czBiYlBNWjdpWXUya1I2bGhUVU9idG5x?=
 =?utf-8?B?d0cxRGFaZGZpTjlyUUFYQXd5a3JRMHFjNWVRU2xRMVFpQnd0S3JWeFpUc2Zs?=
 =?utf-8?B?OW8zLzJUYW9IU3c4STFzNm1EaVdXS2x6YzY1S3o1QXlTdHdnL0drbGFjdVcr?=
 =?utf-8?B?d2lrdjYwalNwR2ZSd0Fwb3VwVkljN1RZM2RoTEtkU2RDS0xoYWZNdmk5dndY?=
 =?utf-8?B?bUw4WnJ2MG1Lb2J3aVg2bWVmd3NOWnFJaEgwNTdaSTlTdTVlVmREaE5CaHVT?=
 =?utf-8?B?MVFOTU03RVgvdUNNSXloRWdvNTJsSzNYcFlDQ2xlVnY1N0tXRytDL3BoL05Q?=
 =?utf-8?B?SnBzVk5yeEtZdHRLbkQ4MDV6T0NsTER1SDltbW5JWVcvbldZWVR1bjZSTXNo?=
 =?utf-8?B?SWUxT3IzeUM2akpVWjRNc1ljak9ZMXdLcytxN2cwaDQxOHVKRUVLcVc3TXVW?=
 =?utf-8?B?ME5xWGM5eUVuSFZ3U1NzRkc2dWV5aDZQYjBzcXV0NEtiYjVtRUtHNThvOVhB?=
 =?utf-8?B?bWo0YU02M0RyRno5Vm55L0NnZ1VxbEVDVWM5UGY5cHFqbTYxekRJN05VWVRZ?=
 =?utf-8?B?WTdGZ1BBbDQ5cGswVEZITzg0akR6a1pUeE9BYmx1YldhUmRQQk1NNXJNUkVK?=
 =?utf-8?B?a3pXem1LeGFYTXFZTWdQZU96U3NGTzVpeU1FTUpxaSs2ajBDV1ZkVHhla3Zx?=
 =?utf-8?B?UFd4dUhxNkpjTzVGSEFSR2VkQjcvcjkxaFBWR21veUZnNVdhOEhNTWRkbE9o?=
 =?utf-8?B?SnUzSjdJRHlMY2cvT0UyVmlKOVZKWFdJWTJNTWcrMmRQOWVNakRlZHlGSnMr?=
 =?utf-8?B?UWRQVG9YSEdmSGVJczJ6S3FnVEdmMnJnejZzUjU2L0VPQWVVemQxM0dOL1pO?=
 =?utf-8?B?aUJGVys1WWtPNzRIWUJERUJGOWRDbGdWc3FaVVhRdlJjRGR2bjQ3UE9aejVY?=
 =?utf-8?B?UlNzT0dpS0o0OHFsZVNlWER4eWs4bFRJemFrcHV6czBVbkhmcjZ4eHpiNE82?=
 =?utf-8?Q?cIQ+ivcifEGeIGN7T+S7KlpiT9OQIesExrtU1Ox?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb83a314-46bc-4b17-69d4-08d9466528dc
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4722.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2021 01:17:34.2782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AW7YUH8BykvucXyR1z/sBi4VHTUL9EyYa0TxSrF6I6BSa33P7hlnHgoRw/zWQoKioFqbBxz4JbCojYPHd0EW3cfPMOetb/Oswdw6V0nEI6k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4451
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10044 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107140004
X-Proofpoint-GUID: VxEWW_-HFLL-Ha4NCLJKP3EfVPP7uReq
X-Proofpoint-ORIG-GUID: VxEWW_-HFLL-Ha4NCLJKP3EfVPP7uReq
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/13/21 4:02 PM, Don Brace wrote:
> Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
> Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
> Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
> Reviewed-by: Scott Teel <scott.teel@microchip.com>
> Reviewed-by: Gerry Morong <gerry.morong@microchip.com>
> Signed-off-by: Don Brace <don.brace@microchip.com>

Acked-by :  John Donnelly <john.p.donnelly@oracle.com>

> ---
>   drivers/scsi/smartpqi/smartpqi_init.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
> index ab1c9c483478..c1f0f8da9fe2 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -33,11 +33,11 @@
>   #define BUILD_TIMESTAMP
>   #endif
>   
> -#define DRIVER_VERSION		"2.1.8-045"
> +#define DRIVER_VERSION		"2.1.10-020"
>   #define DRIVER_MAJOR		2
>   #define DRIVER_MINOR		1
> -#define DRIVER_RELEASE		8
> -#define DRIVER_REVISION		45
> +#define DRIVER_RELEASE		10
> +#define DRIVER_REVISION		20
>   
>   #define DRIVER_NAME		"Microchip SmartPQI Driver (v" \
>   				DRIVER_VERSION BUILD_TIMESTAMP ")"
> 

