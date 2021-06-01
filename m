Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB05FC4708F
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 18:00:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9AEF613BD
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 18:00:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231918AbhFASB5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Jun 2021 14:01:57 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58380 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbhFASB5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2021 14:01:57 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 151Hxedp138628;
        Tue, 1 Jun 2021 18:00:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=ihNsYZRZU1c8GG75rb7+Xj3gvtYHeB4G/EoJF99paKU=;
 b=i+0bm6TuDAXAjTikoNIHzTJh291v7q/+P6rvPqJF8PxK8Vq+Xht3XF5qtU5fyuf3skVl
 Kt74Wl3+rTsaKZPG6MZRQ3GF+vLU3pbA4AYmTVCYBcZjkjL4CcaDXDkFKkTF5pVY+lGP
 W9XVZitmb3OVpLnqgoQNrOtUCLCa8HwJ4TPCXvGsIxUno242SX+KwikyEin01WC6D0/P
 WYav4eu7VPRkMKmVa83iDlE/EYNHbwKri8/yGIZPbWkk3XGzUfbuW7pzUaZp+MyecuiY
 LTju/Z75NFLFq2fzWqz40qf2x5t3EEwPPiO8kAM+/WbaP2c/ICxnzI8cOdlR2tPNhqTU KQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 38udjmpbh8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Jun 2021 18:00:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 151HsbWb126933;
        Tue, 1 Jun 2021 18:00:12 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by userp3020.oracle.com with ESMTP id 38uycrgb26-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Jun 2021 18:00:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TzKv147kDvq0ze7krb6vAfrWYcwsod2Y2izSeN0wIyAtp3Eugg3jJc41wd6Bzjyw92hM6gw3fSau2OQo+uJsP4b8880R3xtkYl09C6x7KJKEZNCNKBpQrtYgvd69pyHwzEOVNU6ZOBWzSEIzRMUTjzt1TOzbSbCWHRCMpjK9J6SqcbjeI6+DcgGbPy+Zoc+B/wJx2ZwSOCw2aLcZeuN6583pvkGvFb+Blghv2n41WEmEtHPoc7WjKwaGk4iW0trvRffcZFeLZvSuZz3y1xwYLdNLtMIsyzMsDwGWVws4qQDyK5QGqoYcCdRGxskZ7jCg9GBHoa3UCOlE4VAWY8Ez6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ihNsYZRZU1c8GG75rb7+Xj3gvtYHeB4G/EoJF99paKU=;
 b=QTlXAcxKAVlnAZLJUqIBlIKoqGcxvOfO9sROE+u/Ntxz7eVQpFcFgPgF0/sQVOggYzDAHXdFTp3lgp601WKV336HIxEC9TNG84SYHKu8gmgg4CzXEJCq82TrUBSNnC3Oqdr6kL6WcVfZaSWykQT9NssKjEaSQuD7ltK4N1UM28Y/Gj003Kyh/OpRPX2+IkrPcbvhu1MNu4WDFwfQFRoFMYEX/I1s0xE4TsU6217Dakt5Ft88PCSI5WeqfOLKXLNqQAq/rBweM+8GFYHoExg6edI9URfXgALT81zsWIb4iQ6MdCupYKnlanRnfC3TaIOVMS2FpyTtlN1ffVDtRe99Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ihNsYZRZU1c8GG75rb7+Xj3gvtYHeB4G/EoJF99paKU=;
 b=nt24NUQDIpsoFFrKoKL03IUxriDYjRFbaLoeGLf3oL+7rjH7kfMoPXFjLBgE+sG7hSD5ri5H3cUhORQJOXy2oYsIz3+gVT4HNbYNTYZIIWrK4w/OtFwadhUSneGG1sK3uwG1HAaOO92DvvK3PY1r0Zq0f9/XpKzdeagRDkgrfuQ=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2558.namprd10.prod.outlook.com (2603:10b6:805:48::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Tue, 1 Jun
 2021 18:00:08 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3%6]) with mapi id 15.20.4173.030; Tue, 1 Jun 2021
 18:00:07 +0000
Subject: Re: [PATCH 2/2] libfc: Corrected the condition check and invalid
 argument passed
To:     Javed Hasan <jhasan@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20210601172156.31942-1-jhasan@marvell.com>
 <20210601172156.31942-3-jhasan@marvell.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <6ae1223d-b8f0-56ec-c6f8-490a0a937eaf@oracle.com>
Date:   Tue, 1 Jun 2021 13:00:05 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210601172156.31942-3-jhasan@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2606:b400:8004:44::27]
X-ClientProxiedBy: BY3PR03CA0018.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::23) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2606:b400:2001:92:8000::a72] (2606:b400:8004:44::27) by BY3PR03CA0018.namprd03.prod.outlook.com (2603:10b6:a03:39a::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Tue, 1 Jun 2021 18:00:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a0cab4ff-2eb8-408d-a4ac-08d92527176c
X-MS-TrafficTypeDiagnostic: SN6PR10MB2558:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR10MB2558345CB635E65CAC5143FFE63E9@SN6PR10MB2558.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CFoQaPxgkcoQtH82E0kWkP1G3fipEptpdjPkDO7ImR908aBNjfn9XKwqh/IOnlEEVduYam7DCBCW/qjfz3Md8vo41zu6PLgHdZ/pQWnhhKWEMKVZMC7St/a/x8jNKSF8VyTlxLnxWDC+Cnk0A+vDWU5DpCDLHHmM9R2s6yhsW5HCRTumS+o7jP/HasRulTqFfvZFvj9c58WCn9LLy4FVEPSK8KdFiAmqdTttx0wgFGUq3E5Xwldmimkb2lVqMYz9HLg9JbaYF3JNFZpXxym5ax1WplLgu658VX0Xb7wW7e5VBT65ElC6ibuX3TYykNEeR+1MSFBaPuyEXc8k/j6lNtp5C1RTAWHFLwf8EyzBtAF3ygS/1sT+XO/owBatYGlx8kdBnosdE0kgVxPsDRYjP3DDOZWBjlCvMLBNkIMhkw7cjLlWgT1mOWrCZE3jyRC/Qaa+eVKXGLfsrscUnOm0LUGQObHkLizDNZd5bPmHzKEbw+N54tP72A685dKrX254j+Y6yZqk9gaRjpIcHiloP8blGClVDchAKbBJ70tfoKSMBkNRc+O6ml62lOoXBxSn+Cat/YaJjHsg3Qr0CDT9AsgJFgUzaeUz9Qljv2ZqN+g9fPwjXzxrMtDcpWYodSxMx6y40Faku91jykS6b6FGaW0lQ3AOb6O1Sl4zVYysOXEE0MhzZ3B22te4lfZ0iYJU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(31686004)(66556008)(66476007)(498600001)(66946007)(8676002)(86362001)(4326008)(36916002)(38100700002)(6636002)(31696002)(53546011)(2616005)(6486002)(44832011)(83380400001)(186003)(16526019)(8936002)(2906002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Z3hmeERVMmxQeU5GTktUaU1TVXhPMFNsTW42Yjc0Wm1JUXQ3WDlIMlI0U3RG?=
 =?utf-8?B?RzJSNTZHczJBSE5YalBuN3p1S0EwNk4vc25YejBOYTJucWgwZ1ZCWEtYSjNo?=
 =?utf-8?B?WVdubjh3MWlSdU1LcHhvV00vTHcyNlZRbFZITGxNWnEySERvTkNvWWRZMzAy?=
 =?utf-8?B?NmxzMStmdzBGVFFMWlNLckZRcDU5YnFPUk85NVVER3pFa3htNlZiWHAxb3VG?=
 =?utf-8?B?RVJPRGN0OE5kblFMVXphb0huL1pSVTBiL2U5TjR5cHYvRlBZR01JcFhHVmx4?=
 =?utf-8?B?WUVab3MyMG5RY0o4c0dHOXQzZ1F2Y2J0ZjhHVG12dXR2SElVMWdwZk9QYmlo?=
 =?utf-8?B?Zzl3VitXVWRza2hFeHhaRmFHZ1Voa21SeW9hVFl1L2pZN0VGS0FiWTNvaTBD?=
 =?utf-8?B?K1B0Y1ltRjVQYlhPTzdjWDhsc3BINERRQVNMZnlyVGl3dm9GSmF0QjdrbzZK?=
 =?utf-8?B?STFPV2hVUVlLUHArQmNUWkhHZWJoNmppRXBON0dVOTFkdklCbmEzZVBNMS9u?=
 =?utf-8?B?NjBFWFVqbXhNZERZaWRPUWtDTkRvL0dHWDRKMEtUVWNaVHZ5TUNZY3hXQmor?=
 =?utf-8?B?bVNIWTNrTlBEZ0g1Rkd4amJUblhzNlBManhsSDhHZFVRK3BEek9NZ2kvLzE4?=
 =?utf-8?B?dGdJS3NRYTRCVUY4UFllQlVOQy9pRTYyT3FtNWRtOTcyYjM3QWNoL2hqVlBZ?=
 =?utf-8?B?NXdlOEU4NGJuMWNoOUNJL2tKaGxjMThQR242UmQ3aE5qcHpDWjlYQVhCL0RM?=
 =?utf-8?B?TmhqdW9sU2UrTWM1aGVvWjlmeGc3S0l1Zi9pVlRuU0RVMS9KOVRKVXlJNDVa?=
 =?utf-8?B?bUdWbHlXZ0tGWjYvdnpQOXRNMThBYVhEZ1duQ0ZnREdaMUF0K0VNU1dXWURF?=
 =?utf-8?B?MkF4UXdDUlNaTnFsQjFHMDZQTlQ3d0RqRkYxaWorUGN6Si9WYi8zUDdrTWNa?=
 =?utf-8?B?NkZ5SHpFalFmbGEyOWh5ZW9BU3VkMDhQb3U1UVVhcnh4bGRod25HaGtjZmhM?=
 =?utf-8?B?aWFVdjNCaUQwT0thQUhZZ2xtTjRKYlF6YlBSdWF0d1ZodlBqbVg4OXg2d1Va?=
 =?utf-8?B?a2dPT3hiYVBaVW0zTEhQcm1SazF5bi9YbkwwbUtKQ09DSGZkekNFQ1o1WjRM?=
 =?utf-8?B?Zlhya2FtUmpWN051ODRwbnlESXc1bzErSVU0U3JTZ2dWc2t3Wlo3NExQNGVD?=
 =?utf-8?B?TWM0UXpZKzZwWngxUlI0aG5GM1VKQ1FpZTVpL0tacW1WSmZJQXBkNUdxclp2?=
 =?utf-8?B?VlY4N3FBRDNxSzQxUmk1NnhKZWxpSmtnUHF2YXpYbWNINXFtNjZxOTBsd2Yv?=
 =?utf-8?B?OTA5K0YwSkc5bEFuL0hOVEpXWFB5NjNZTS9reTMrdFIxbDUrNmNhK2RQaFNQ?=
 =?utf-8?B?bFJxYmVzT3pDZ2pGWmJqaGlvUEE1Y2Jpck01SHhHZXZUSXEzanFJb3RvZVNl?=
 =?utf-8?B?MWRaWTZESWFaMVNoUDRjUnJ5bnUxYjFjVTF3YnFlKzNXbnR6Uko4ZVlTalJ4?=
 =?utf-8?B?RGM2MFdLdkpvYjAyYzhrN21udFJ1cGJqenJROFZYWnFKd2N5R1dGWkxkMXUw?=
 =?utf-8?B?OTRxUnFjZlJlYTVvcnpJcHBSekRBc0crWGY4VHorQ2tsN0dwRzk1ZEZGN0JL?=
 =?utf-8?B?YlYxelE0azEvMHhwbXNKdmk2YVpubDlvWTVIUzBqQ0RCbHhxNzlXV1ZYd0hv?=
 =?utf-8?B?cEF3T25uWjhBMXNGOUErS2swNnlXcW14VisyTy9PNlNQQkNLTktwV3I0azVm?=
 =?utf-8?B?YUEyZ3E5czY0aGp5cExoTzRSbW1GNmdIbFBDNDdKa0prNU02Uyt4b1BKbmVF?=
 =?utf-8?B?Qkh0d1JseFVrN0d6eFVlQT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0cab4ff-2eb8-408d-a4ac-08d92527176c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2021 18:00:07.8582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2JLWdXDeirNtbZBIGlsfievpQ5Flk5u2U+x7euJ1dvDey1Uxp7h+/L5pJJJ3Krtk14/T76dtZNe4fR/KC43eUm8NSNp9ZT9H8Jol5UK9sdQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2558
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10002 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106010121
X-Proofpoint-GUID: DNMsTonooE2djVPR0g20AK-iSDirXFxY
X-Proofpoint-ORIG-GUID: DNMsTonooE2djVPR0g20AK-iSDirXFxY
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10002 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106010121
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 6/1/21 12:21 PM, Javed Hasan wrote:
>   -In correct condition check was leading to data corruption
>    and so the invalid argument.
> 
> Signed-off-by: Javed Hasan <jhasan@marvell.com>
> 
> ---
>   drivers/scsi/libfc/fc_encode.h | 8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/libfc/fc_encode.h b/drivers/scsi/libfc/fc_encode.h
> index 602c97a651bc..9ea4ceadb559 100644
> --- a/drivers/scsi/libfc/fc_encode.h
> +++ b/drivers/scsi/libfc/fc_encode.h
> @@ -166,9 +166,11 @@ static inline int fc_ct_ns_fill(struct fc_lport *lport,
>   static inline void fc_ct_ms_fill_attr(struct fc_fdmi_attr_entry *entry,
>   				    const char *in, size_t len)
>   {
> -	int copied = strscpy(entry->value, in, len);
> -	if (copied > 0)
> -		memset(entry->value, copied, len - copied);
> +	int copied;
> +
> +	copied = strscpy((char *)&entry->value, in, len);
> +	if (copied > 0 && (copied + 1) < len)
> +		memset((entry->value + copied + 1), 0, len - copied - 1);
>   }
>   
>   /**
> 

This should have Oracle Linux Engineering

Fixes: 8fd9efca86d08 ("scsi: libfc: Work around -Warray-bounds warning") 
  Cc: Stable@vger.kernel.org.

otherwise looks good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
