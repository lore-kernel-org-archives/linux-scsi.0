Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D46B5C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 15:53:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B946860698
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 15:53:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350456AbhERPy3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 11:54:29 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54052 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350458AbhERPyZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 11:54:25 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14IFTCJP114620;
        Tue, 18 May 2021 15:52:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=UQlWTQshOFWbyW9tuCin5a85NfLwjB3DlDaxvN9I1vY=;
 b=gEu6ChiTzshzhHDqlKvI0bV1v51VXnKGtK2jLlMrPAeU+3AlugblhHA6AwRY4oU3PhJ6
 /c9rvqcMbnPqIcswAUHLU/7Oai4LorzJh+BJZ+U0JdgRxqKXFAlv1Sjj88WeFoTFKQDj
 CZxSlCpqEsUeNcV2yEnr8tkVNmRYCCSuH0hw4soxft/CArHDhXsHHBeo5Ux553sfrQhV
 b3vtr9EYxb1AitnSdQ7sah0x50qCxzEMlmnvgnqyNf2dHgifQhy6VlaNKpwI1Qjh3JY1
 gcM1a4/Sr2SWB5cmN4q+7uNWEDgvnCbV6kOnmPkct9FzcvAvf8Ah3iePGfcqN4mz21/6 Aw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 38j5qr6w51-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 May 2021 15:52:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14IFUX5v087438;
        Tue, 18 May 2021 15:52:56 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by userp3030.oracle.com with ESMTP id 38megjkmc0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 May 2021 15:52:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hwfbJlNFkaCzsK7Nmvew5eYNAZwBb4gb79Jy6nMGk9SpPQZkoVPsu2runszFmdj2CmxYZyK2mpq3egO5UotUiOh2dsLVolJDmuYTS4kVZ895y9U8k1rTxQ5wA29TYIIOx1+c7Ze13H3ve1blNhnst2Nvt5y41F7FtrVY7VaqcJVaGPNVJhY6o6Luj49Q4i91qpW/QokEM4dd3upIg/AIZNyxk2Yq3JMkASiv8qjBXLcPdYxCnvnEg6wtYaWOgpCEb5RtvGJsUmCTzMH8Bj0BrTdVPcln0DOOK0l/OoIQtnrF3EZiGcizlKGCFJCVez01f2O11kOCSiq9DgdYGT9opg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UQlWTQshOFWbyW9tuCin5a85NfLwjB3DlDaxvN9I1vY=;
 b=mezpIZ0V6kRGIfN5mw4rIxXNMQWwW1A6Ll23AMBCOVX7vb0wSmQzqZAToZl6H6gpPDvzbfGk+uC9cq90humok0IwBBE5GeNo0RcmhZonFPBhhDALkdCJYTOkmMfaNs8AhyLt6YrpNc141Ptu6su8Rze+sEhVU/rmNa1R1a8e/bWCxx1b/CTlaEQ53fdu8c0ohQgRjgBhHCp/RoO0Elt2mXQIfxZsVPyr5tOgrWUqzO3/96A0UN2PXqnI4OfsLZPs62QeTBJxpBfsYf89fTlVmFQ4LDpkHI1Wg11v4KP/h90m6v2EkpyBIMsYfxuJGYJq6PXInyrC9dfvTbP2fkxRaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UQlWTQshOFWbyW9tuCin5a85NfLwjB3DlDaxvN9I1vY=;
 b=LTDDuUA4CXes4S/KkmJoAsVU3PoeCnij3mmP9BkcqrtmSPAtItfjDyBw8+Xyquwnw8bdL15IfX/MRpAth6YOb5BGyd1GEwlk6s/c9EfZPnZKOLOvWi/a4VYT1xKkfzmR+53Z7+YwVdIklKJasccELZ6dnqPFBF4tfhTzuM/1X7w=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2717.namprd10.prod.outlook.com (2603:10b6:805:46::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Tue, 18 May
 2021 15:52:53 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3%6]) with mapi id 15.20.4129.032; Tue, 18 May 2021
 15:52:53 +0000
Subject: Re: [PATCH -next] scsi: qedf: use vzalloc() instead of
 vmalloc()/memset(0)
To:     Yang Yingliang <yangyingliang@huawei.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, skashyap@marvell.com
References: <20210518132018.1312995-1-yangyingliang@huawei.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <3b03d6f8-fa69-e8ec-98ca-7a0319afe0dd@oracle.com>
Date:   Tue, 18 May 2021 10:52:51 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210518132018.1312995-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [70.114.128.235]
X-ClientProxiedBy: SN4PR0501CA0086.namprd05.prod.outlook.com
 (2603:10b6:803:22::24) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.28] (70.114.128.235) by SN4PR0501CA0086.namprd05.prod.outlook.com (2603:10b6:803:22::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.11 via Frontend Transport; Tue, 18 May 2021 15:52:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 63a0cc7d-9aa2-4c0c-68c0-08d91a14fefd
X-MS-TrafficTypeDiagnostic: SN6PR10MB2717:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR10MB2717DEA22C35D60A458D66BDE62C9@SN6PR10MB2717.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:407;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TLO/Cjj3YB/TYEBVsJpJgpTr2odF9yylXxgnVIpihPSCXIKEKtQMSZobrODGCqfIDnuFmyTZiKOXdNcqF+BVzwPobkGH2Bdl89131shEkde0GqYyU9P6pe3yoq6HTQlFsSE7g1N1di4wcr7CLTzUiOg02t634/Yga5hnBBXpZ38ziemPXUD1xshHwBk9M9FROmga/vBTNSVJSOhqRWMZ8Oo0nfFNMFDaJa9aNqz8LCJ5Q4SzDgW3MP32EcVmRDoo0Sm8+IVQRF1PZDMzgWddhEp2leVBJxw8Tp5Uu2Rg6Cfcajd4yNDp9lWyqOm157YNi2Clu7V+c6TlyGte0hZHiGub3sLahhN2Z4K2fWWcileXf177QqgzJ9JwZlSaZFpIwz7C/Y6Q25PZsvWYbi+am+cGbw/vdfO0mF6oqTDMw7E8/y7cXvtlgv0q4rSoY5/Y5m/MKopf7oN5jou+4BSS39z5A/fGoMl+l3/ya2SeDXY/BcGcvvmFBwRNEcTs5qJON8kyInSNN/c0+Y1HYUiAVhikPvH1DUCuNDatgCD713L03K4o8MDySEWQ8YL13g237hAW5J4PKOxoZoxGMq9vM7B7Zp0QqrIjuuIR9fGcf8kXDUDAtZd7wp/RDUvZiNSGrOKdFBdCQviaCQVSznUsJ+7qFmGyapMY3T66fr0NmhhT1l4FUKvFeZQEY2GKMNNK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(346002)(376002)(39860400002)(16576012)(31686004)(8676002)(36756003)(316002)(2906002)(956004)(5660300002)(4744005)(478600001)(86362001)(36916002)(31696002)(83380400001)(66946007)(66476007)(66556008)(8936002)(38100700002)(186003)(16526019)(53546011)(44832011)(6486002)(26005)(4326008)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bEp4NXEzeU0zM013NUg0T2ZkTlZmeTJpL1Z2dHJMVGFlM2UyMm1jKzBpWFNG?=
 =?utf-8?B?c1hlN3hWTmNJcE9ycWdSYm9qOS9MVzk3a0U1Vnl5YjQ1RWJvMDdCOXd0Vnhw?=
 =?utf-8?B?d2tBKzZmOU11aUE4dkxtWUhoNjd6cTVPQ1g2MFAxTENXeGU1Rm93QlczNnlM?=
 =?utf-8?B?SW5OR3JmR3dvOGtTWktyczA0NHJDMlg0b05ibUZxVU9QanYzeEQ0YjE5NWNS?=
 =?utf-8?B?KzB2ZWRYQVhiN1l3K2tsQjNrdVZxdC9sNnNrOWN0UmExdzhnUHduUXNiUHBZ?=
 =?utf-8?B?U2hRU0lFMlljT0ZOSnFRQmFPbWpaT3NHdURvdXg4QTRxblU3VytqY044dnJi?=
 =?utf-8?B?SkdWZjRCT0RLTjdxZzkvTzVxanBDbVNQdzV5RzNWT0dmMFkyMGZiQTdNN1BO?=
 =?utf-8?B?d3lJTUtKcHV5VktnYlRTOTBCWnp6VThXWXVveGRDSnJSQ0MvZ1BxVnE5YUxt?=
 =?utf-8?B?WHpmeE5CZnRLZS9Qa0lMWjRIV3F2blV0bCtWc2huRmg4V1J0bGxhaEJrK0NN?=
 =?utf-8?B?Z2FzRytWMzdYMjdCSml3ZTE4NkJJdmJTK2VSZFptekY0RnBZczJKeWVRTEpp?=
 =?utf-8?B?dWE4YnFnMUR4cjVIMVJ4N1pkSDNQdjJVcE5PLzhZOFFpYTNiVFlOWWhMbVlT?=
 =?utf-8?B?ekZOQjdSTzBIZ2x1WC91L3BBVFlGMm9SNkxxc0txSE5zRWVXR1pqNjRYTkFp?=
 =?utf-8?B?RDZDSk95R3FqQnArVGJMcU02Qzk1Qy9wbmZ6b1dJbmRpTldTZkphZTVLSVlG?=
 =?utf-8?B?WWI0bDc3Z1VqRElNTUV2MW14bWhaNnFwN081cUlSdUdKd3pEQnM2Q0hVVjAr?=
 =?utf-8?B?dVR2L2dTeUs3ZDZiTXNLUVZvbm1WQlBJRGJUdy9RajA0ZFlkb1BGSjJaRDJ6?=
 =?utf-8?B?RW9rb25iMllWRkxVQlh4N0NOVllMeVI3TDBTUW1BOU5XMFpBNFhPVUFjaWVz?=
 =?utf-8?B?bkJOZW9RL25DUFpWSnYvTUQ2MGIvLzZZa3JXZ2huSWs4cStmd3c0MVNFaXM5?=
 =?utf-8?B?UCtpdk5tY1ZUaS9wdW8yaTlmenZZdUlqNUhUc0N4bEpzNXErL0hIbTNxYXNk?=
 =?utf-8?B?bHpaRnNONFNtcGpKWmZxZ0dHZFc5Tm45ancvak5ZeDdYK3crOXlERDNlc3lv?=
 =?utf-8?B?ZFJ0NE1wM3lWM3pabzFheHpHd3Bac2pzRjl3Q1Jmcm9ad0VqTmo4WHFIQU1k?=
 =?utf-8?B?YW5adkE2UXJsSGx0NUU5N0ZtUGFrbUZHVk1udkNESGNoVkZTMVRBNy9NUW5k?=
 =?utf-8?B?TFJYZ2wvME1DVVcvRHVrcmh3NmI1YUJvT0oxa3N2VWYwQXIxWkZ0c0hDK3pG?=
 =?utf-8?B?K1Z1NXJTUjZYQzZRa2N3ZjRkMnJDZ3cvSUMvRWtsY3YzVVd0QVM3REE5Ny9R?=
 =?utf-8?B?dWdvWm9JUTkxOVlkMEcvREJ3ZS9uaTJOeXBlc09KMEpmVEtOOFhFUWZBc2wv?=
 =?utf-8?B?bUVpRkV1OGR5Tk03aTVoRDk5dlVYR1Z4YmlrSGQrNU94M1p3aTVpTUlpeVNH?=
 =?utf-8?B?anRUeTJ0b3Awa3k4cXhhSisvRzJ6eTJuZUh2eU5tdkVqajBmM2hBSU80ZVVw?=
 =?utf-8?B?Q2Y4eGsyQS9SbUpycEliL2pwbTVzWk5aaDg2cDdma3ZmVThCM3FhQkR6T1Zh?=
 =?utf-8?B?S3ByZjBoQ3FPQkFCQ0laZVl0aE9xb3hpcXdqZCswOG1IKzRHanQwUG9lMytn?=
 =?utf-8?B?dDB2ZkZoTDQ0dXRZT3dZTENkNW1VVUxzbVlIelhLZjZHU1FPYzM1ejhleEVj?=
 =?utf-8?Q?sYtIwIw/39pjH18JWciv4uC30fzfjQqWK2LTgIw?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63a0cc7d-9aa2-4c0c-68c0-08d91a14fefd
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2021 15:52:53.0473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IlHpMZgtlY9aQ7EPHBt51zB8ZIoRol63+M0MUulsi7Iyv3+BMRX+kyJRGoWbJ4LQZ9aaHgLjmIgDY2qQjFPVLl+ED9Y9zKNdZ9SWC8ZfKSE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2717
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9988 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105180111
X-Proofpoint-GUID: 7Wd1Yj73lKELgv2r1uaQ7iEZpl5MuHcT
X-Proofpoint-ORIG-GUID: 7Wd1Yj73lKELgv2r1uaQ7iEZpl5MuHcT
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9988 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 priorityscore=1501 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105180111
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 5/18/21 8:20 AM, Yang Yingliang wrote:
> Use vzalloc() instead of vmalloc() and memset(0) to simpify
> the code.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>   drivers/scsi/qedf/qedf_dbg.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/qedf/qedf_dbg.c b/drivers/scsi/qedf/qedf_dbg.c
> index e0387e495261..0d2aed82882a 100644
> --- a/drivers/scsi/qedf/qedf_dbg.c
> +++ b/drivers/scsi/qedf/qedf_dbg.c
> @@ -106,11 +106,10 @@ qedf_dbg_info(struct qedf_dbg_ctx *qedf, const char *func, u32 line,
>   int
>   qedf_alloc_grc_dump_buf(u8 **buf, uint32_t len)
>   {
> -		*buf = vmalloc(len);
> +		*buf = vzalloc(len);
>   		if (!(*buf))
>   			return -ENOMEM;
>   
> -		memset(*buf, 0, len);
>   		return 0;
>   }
>   
> 

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
