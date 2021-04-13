Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3FE9C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 17:48:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF19661176
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 17:48:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347321AbhDMRsa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 13:48:30 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36884 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347313AbhDMRsZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 13:48:25 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13DHZ8oZ006187;
        Tue, 13 Apr 2021 17:47:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=n2IKuYnvR3Se7Uu4Stbd06yB9rrXlQJ+15GbGpMCx9k=;
 b=lnqFcdzgyi3gmdzW6EkFkKCgZ7KyBoMl4tyacTd460tqOXzqBfcZNiBMYvudHiKX4oqz
 HoA8m8aBgXCrOTqxo1TBWKokW6Nkva3C0H7MF4MtpiRQJkhBAazCpPu47Rv9+XSZB/ny
 NScWj8Jhkiay5B3QKythdHEHpel1StK5NuFpWGb9UkwVLmzULkmGu6tFlVZdYlCuRHlO
 k91Z/JOrkhRI+5NzMnnQrd06YLIA+4bmPwNQxTXVPylsoJ85T9OvjtOWRYEjqSLncZE1
 FiUu6j5VHMpxhUjGJuscC5n9IxMNK3nnDLsl0pMrSDLAc998e2Gh3uO8b6jRH9rA+4iR 1Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 37u4nnfwuj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 17:47:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13DHZTIb057207;
        Tue, 13 Apr 2021 17:47:58 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2054.outbound.protection.outlook.com [104.47.45.54])
        by userp3020.oracle.com with ESMTP id 37unssq44d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 17:47:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DfYLU7A/6cGMi2pvIwUSSBYi3nHw12xeuuCu34qM8BzZ88msV2sF64H/bBvDv0RfExsZf8tjdyrxUQP6pv/QmlN+EeLe65YKQF8HoToR3KJMQuRCzDoyItHGZ/ngDqiIfArY1gVO0rjsJToLuBstpGewxF/8FXoXSfD+km5gEocO7kJmjQ7RmHEKbaYt+IGR/MrL5MehQVQqMKzutaHOV4ww0oOPw9jYBK8P89vOGVVAKE7RAiqwIi8dh2fH9R5DzHBNBoQ7z+rhRMs9D19w/AiJJswKZ9BHruyQLu69x9qb0/d4WWxRueY67aa70SdzK+bIErY7Mpq9/YExCRG23g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n2IKuYnvR3Se7Uu4Stbd06yB9rrXlQJ+15GbGpMCx9k=;
 b=Xltziz/aBEkNWH49ZPQsP/5AnjDNXKYDHA6vawCOfrqtt4G53ck9HIovRqYmLMqvBhuXtkl6OExcz0wW4rBA8nie50mHf69nyhzBFCfgeME+FD26QvV1MpIxYVpQEdZhyn80ncKPWfSsQ7gKGcQb07D9CAZs5TNp4Mo/JzACMtb6fDOrAnBZDb5JVPJXqz1fl4FkNnu66QZ6MZNg7USWiUj1PeW4hQMtaQpgs5wkMFkiUXIPP23tmDJJMHBzGVFPaNrDCwFh7sqMp+JKknMYe+i19wfPKNJdgReo6kUoG1PDE5Jyk85dUWDJawoLZajyFaHDBAKK9DbNYA7ZlETDxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n2IKuYnvR3Se7Uu4Stbd06yB9rrXlQJ+15GbGpMCx9k=;
 b=lNreyGZjiOA07n0zEnZjmoM1t7+Wz355H58gZSfduvKlJRzB53CTKB4Qg63ZaretwjDFolEQw4QaDgV6sMBas/UJrWZm+J41Lawei3009+k3GsEEIDIrgsA86XUV+s1aCIiDTpLvmergfZSNmyoxIrij277WHTFwI50tKujsa1I=
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2933.namprd10.prod.outlook.com (2603:10b6:a03:88::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Tue, 13 Apr
 2021 17:47:56 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 17:47:56 +0000
Subject: Re: [PATCH 19/20] target: Fix several format specifiers
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <20210413170714.2119-1-bvanassche@acm.org>
 <20210413170714.2119-20-bvanassche@acm.org>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <b75dff73-80c2-23ca-1a6a-09826b39d5b9@oracle.com>
Date:   Tue, 13 Apr 2021 12:47:53 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
In-Reply-To: <20210413170714.2119-20-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR13CA0052.namprd13.prod.outlook.com
 (2603:10b6:5:134::29) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by DM6PR13CA0052.namprd13.prod.outlook.com (2603:10b6:5:134::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.6 via Frontend Transport; Tue, 13 Apr 2021 17:47:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9948ae30-3ed3-4732-f581-08d8fea4452f
X-MS-TrafficTypeDiagnostic: BYAPR10MB2933:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB29332676CEA6BE7930BD30D3F14F9@BYAPR10MB2933.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zCEopJzatoX/CjzPvGoCuUAdUWuQAEiW4OYEJMAD2azmxqrQEHesVUgAjytsbZgxDe8GbwX1dWZgDt1OXdcO9/73dUcQBCMcq68pnJ1WyU4uq8KV2kZ+NxxOigWzSPTlYQhuGveH7rPsCCuPFtZqTaEePHKAEdAS6pX3rnL0MGOQwA1jPGaA5BxcPdibV/6NU+1vto6+n7nziagvQDyeQE+Pu9iHo9MmoYnJ/boYtXw2uXHnKHbysJdu2NepNYamKX6AqwyUNfxprnmhYJoDcivcXDXlORjAvi/8YzIJeHb68FqZVqLT9JMQI3a5G0nMT4s+L4XMnqWdmKe9F8c/CQukTuoAYlJ4+d3J2xuVJoy2hmpd+c2v2zupq+gM+Vsx5ZNikBGVGEeXJlGNbuVCQU8H2vUVuoDRdOzXXXEzVUJdbNZtKhel4Wcid7o7uL5+iiwjw2Y/YDgAIYFm4eG1nUQIVHKAscV+2AXmDRYgjkBMnLJRrLBfsm0joV0oSxKDNJ8DQFKiZ3gn05iLpPuHFnfVxIaDpzK+u+X1cMXZBtAeqawQBAweLXy+hnPpnlcj9x21US7liDUsM3+mm6PQr/3YQ4J2tUuZClh5aN7OxHg+pvVKKKRTD554OlMAhzXIVOSOvntDywSkCDMXuiRRuMOx5lKOyh81EtOSVvJDDs1AKuZMEp3lhXGcfxMC5Ctmapq8qkgNez5ZkETlFbu1TA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(39860400002)(366004)(396003)(346002)(2616005)(66946007)(86362001)(53546011)(316002)(8936002)(66476007)(186003)(83380400001)(110136005)(66556008)(478600001)(16576012)(31696002)(4326008)(26005)(6486002)(16526019)(36756003)(956004)(31686004)(38100700002)(8676002)(2906002)(6706004)(5660300002)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NTlBY1NsdTB1cXdIS3ZtL3E5SnlZaUl4VVBBczloVDBQeThBTDgvY0JtUE9R?=
 =?utf-8?B?T2NMamxycU8zdW1SbHkveEk2VG9pOFVTSDRjenlzeEtKZE9mZC9NUEg4SlJS?=
 =?utf-8?B?bUZSYnB2RUIvdTdSVFdYWGd6V2JMTmt4am5VNVFsazFrRXRUR041QjhER2VH?=
 =?utf-8?B?bDVSaEtFcUgzZjE5RUxJc292Qzd4TlJjTklnZ3lJYTdVbmExckcycjFRZjhw?=
 =?utf-8?B?UWp3MnovbC9aZWNKR1A1QzZqcjJPWGZCbW93RDFPTlFHSmFJblZZdlRiZ2c1?=
 =?utf-8?B?cjFHZnp4YjErcHBQb0JoSDFVRStvNzBhZkZlUFpzSHFiV0tHWUNzakRYM2NO?=
 =?utf-8?B?SVRiTTQxejV5Zm9RNkV6WG1MSVk2c1VVbkRRb1k1UStoL2ViaXpXOTE3UFdC?=
 =?utf-8?B?c0xrTFFkUkFQSzIwZEZxS2txMVU3Y092M0J2UlJObXJDRGxGYkRLZS85WU85?=
 =?utf-8?B?d2VPVTZpK1pzKzhrb1RFV0kzVzh6ckJveElyeFFxczBYckswZm44NHZlNGhj?=
 =?utf-8?B?WTcxYkNsQXlaSjFZRXhPTXpxSXNic0lIWDhMYzB5cldsbzhESlE4UjNBTS9x?=
 =?utf-8?B?TGdzV3phZ1JKVnlkTEswZXo5OXU4RGsvOEgwYkZ4QW91eUU2S2VjeS9WS1hB?=
 =?utf-8?B?VURsR0JWL1lmT3R3aVVIaXIvVVpxZmlBRWF0R0xqWXQ0ZFVHNGNLdEgzRTJ1?=
 =?utf-8?B?Q0pIZHB6WWRkYVBJTHZrbU5LcUhVZlorYzJ4RjR5MSt4dW5wRlNPMGY3ZEJu?=
 =?utf-8?B?dU4yNjdSYlZxaURBbUFuUG1VQzZRem5uZU1iOSswNnlMUTJsR3BlOEFXUzl2?=
 =?utf-8?B?bTM1M0lwZndZY0pOU2EzZ0lhUkdxNERTN1ZzMFBWcnBJOUEwdkF0RHJUSjlG?=
 =?utf-8?B?N1NNOGRpNUwvVDU1NjVhbVM4ZzdNNVNXNE5wTEJ1OTQzelFYcU1tWGtVZGll?=
 =?utf-8?B?Q1ZOTTBUbE9sWmpRTld4OEhoNGRra205Y0MzTEtaOTArL3JKUCtNQTE3YmdE?=
 =?utf-8?B?SXlpdHVxUlJXTzV2bFhFRW9iYlJqSS9TcFZjV21id3RVL1dQdXlaN1VuRjdj?=
 =?utf-8?B?Vkh1OVg2emttYmFMNGJLS2gvMlFwUXg5bWRhR045R283WUhIZUwyU1ljV3lP?=
 =?utf-8?B?NWlkYnk1TVMvZnFtMlhsdzdPUTlEcjdHR1R0dWpRQUp1NE02ZU91dWE3Vzc5?=
 =?utf-8?B?ak5Xb091b055UzFNN2ozdUdCNEI1NlZsMUxsdUV4S0lQdDl5eGwxa0RGMmtm?=
 =?utf-8?B?aVFzeWU0SzJhaEZIZU10TGVUMU9GRVhERG1zZEY0c0ZiSFFDaElIUFlLSWpi?=
 =?utf-8?B?aWJEY3lRcS9IdFp5cEdPTVNhc0lQblgrRzJMR2lXYzdxZ3lpVWZYQklrbUEv?=
 =?utf-8?B?RTlidnk0RGNSL21mSld4NEtwOXE5amhZaGM4SUNnMmVZWnhtM1JGK3pPaG5i?=
 =?utf-8?B?YXJKUGEwR1ZjbGI0ZkdXNlhpaHM5ZS84TndGZUFZUlBZbzZlRWxTUlRSVDd6?=
 =?utf-8?B?MEI5Yk5tbFlIdFBDY05zMzQ1U0FaRGM4blNwb2E2OUtqRU01Q01lZzJwV2pi?=
 =?utf-8?B?dzhsNXJvSG0rdjZyZVBCWDJQakVndzJkRWRyaDVEZk5mL1RGSjZrdGVyYWxi?=
 =?utf-8?B?eVQxNXQzTUltOVdJOVl2WU1KMXQ5SEM3VFZRZHMzanphbWZGKzNoazlHU3A1?=
 =?utf-8?B?ZXF2SW5QNzRVdmpaQi9TRGQ4UUZBUG9LRktSYTN1WlEzRkFqQzJuVnFYRkZT?=
 =?utf-8?Q?7T0R4Gz3kBD3lP6/x8BN5zLI/gXqVD4W+2tqlHq?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9948ae30-3ed3-4732-f581-08d8fea4452f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 17:47:56.3796
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E0q0M/gEAhCSZAz4xImhFhr5ovBrYsBzy2SZOknCeY8wg3v+RDbhAfhL4mZHaYBj36I9gwcmwVbjU4clnP7Rvnu7QvI/S4uzqNyTiAe8adI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2933
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9953 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130120
X-Proofpoint-ORIG-GUID: 5Kd4dav9ZdDVENarInOx2mMzAQQN86ea
X-Proofpoint-GUID: 5Kd4dav9ZdDVENarInOx2mMzAQQN86ea
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9953 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130120
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/13/21 12:07 PM, Bart Van Assche wrote:
> Use format specifier '%u' to format the u32 and int data types instead of
> '%hu'.
> 
> Cc: Mike Christie <michael.christie@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/target/target_core_configfs.c | 6 +++---
>  drivers/target/target_core_pr.c       | 6 ++----
>  2 files changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> index 9cb1ca8421c8..01005a9e5128 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -2746,7 +2746,7 @@ static ssize_t target_tg_pt_gp_alua_access_state_store(struct config_item *item,
>  
>  	if (!tg_pt_gp->tg_pt_gp_valid_id) {
>  		pr_err("Unable to do implicit ALUA on non valid"
> -			" tg_pt_gp ID: %hu\n", tg_pt_gp->tg_pt_gp_valid_id);
> +			" tg_pt_gp ID: %u\n", tg_pt_gp->tg_pt_gp_valid_id);
>  		return -EINVAL;
>  	}
>  	if (!target_dev_configured(dev)) {
> @@ -2798,7 +2798,7 @@ static ssize_t target_tg_pt_gp_alua_access_status_store(
>  
>  	if (!tg_pt_gp->tg_pt_gp_valid_id) {
>  		pr_err("Unable to do set ALUA access status on non"
> -			" valid tg_pt_gp ID: %hu\n",
> +			" valid tg_pt_gp ID: %u\n",
>  			tg_pt_gp->tg_pt_gp_valid_id);
>  		return -EINVAL;
>  	}
> @@ -2853,7 +2853,7 @@ static ssize_t target_tg_pt_gp_alua_support_##_name##_store(		\
>  									\
>  	if (!t->tg_pt_gp_valid_id) {					\
>  		pr_err("Unable to do set " #_name " ALUA state on non"	\
> -		       " valid tg_pt_gp ID: %hu\n",			\
> +		       " valid tg_pt_gp ID: %u\n",			\

Did you just want to drop the tg_pt_gp_valid_id from the messages above?
Instead make the messages stop at non valid tg_pt_gp. Like for the first one:

Unable to do implicit ALUA on non valid tg_pt_gp ID.

It looks like we might have used to print the actual id. That's why we did
the hu and the message looks like we are printing the id "tg_pt_gp ID:".
We are now printing just 0 or 1 but it looks like an id value in the message.

