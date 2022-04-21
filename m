Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EFF8C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Apr 2022 16:24:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbiDUQ1i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Apr 2022 12:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbiDUQRJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Apr 2022 12:17:09 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77EB22B241
        for <linux-scsi@vger.kernel.org>; Thu, 21 Apr 2022 09:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1650557656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3jFuuRcMOWARClLbPYeAu1kEse383mNkSyTKJ0u8lhY=;
        b=DuV5wQLqN1/Q1LAYveRx/JNQ0prGYQc599LDIZxnh8Lb3kHqoYXFdKpO9//u2dVJHIAKEs
        Z/IMtSQzzdcyn/gcsDzRAZFrqUoJ1bus7MOTSAAG5XHagURLq6FsZcamdgGxj/buWgOevp
        Z5SUipA4BU1DF2C/DT8HQ1XCjGy/NCY=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2050.outbound.protection.outlook.com [104.47.14.50]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-5-L3uMhAvUOK2Xzmg7qUa8Hw-1; Thu, 21 Apr 2022 18:14:15 +0200
X-MC-Unique: L3uMhAvUOK2Xzmg7qUa8Hw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YK0zqrBp2K4CW673Z8VqeK0Vh5M0wEO3ezAAOUVlN5f+BM+Ic9EOvUoW7ucFh1Ac49nwOV5Lwo8V05McpFy7ZgfJsE9VrvftT86/byFXLEDhHG31uRxfr+t6dw3q43qxQwIOleenfNiXvNT8oWEN2TT2SQk+ZE9iDjeSAVCU5nGRGna6CkLsCGfMsC5wvUvDIIZ9BJhpFdlaiBIeqDHLLwoIRyOEnuyAFEXxa3xFf4vbEq5nT/HTOtlqOU/yrJLQsXZx60mbWOZmIs6i0Hn6XsJUO7JgK2XjWN3NtKzMXvEzoFkGNGC/z9WZ3xbbxJUb/zPbTJLWC5k1FYl88uN6iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3jFuuRcMOWARClLbPYeAu1kEse383mNkSyTKJ0u8lhY=;
 b=LaX9btRLzZ0gZh86dUsVdkjgCgesj5A5LkzxZBVEOZlDYSqI86GZ5OER29LvosNiV7J9EDpKHUbRhEHvV5exEFQZxUu/irDrPqH+AxJTWKLkLCKU0LS+Spa8dyi1RkHBAi7B06HGVfqHGlgRUqLX/9p7TKbaFe92t9Nmn4UaHRF15IVtypo/5YK1+wRD+lqHuFfNGCuIOPL/6hPoldwOODd0X4U4MpsPd0Hwy5oVzvJcV1YIraOEaSD5tpWT1w9GrizhleHrXX2M0/E18bHi+72RGfFDcl36FQo1oTHrjOkpBaWpiiIR1uoclBmL7PeVPqOOvBJ3+Z8ZGeN3p0qSKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from HE1PR04MB3098.eurprd04.prod.outlook.com (2603:10a6:7:20::28) by
 VI1PR04MB5104.eurprd04.prod.outlook.com (2603:10a6:803:5a::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.14; Thu, 21 Apr 2022 16:14:13 +0000
Received: from HE1PR04MB3098.eurprd04.prod.outlook.com
 ([fe80::c5c8:ad82:8f82:2a3e]) by HE1PR04MB3098.eurprd04.prod.outlook.com
 ([fe80::c5c8:ad82:8f82:2a3e%5]) with mapi id 15.20.5186.013; Thu, 21 Apr 2022
 16:14:13 +0000
Message-ID: <b4e1edb5-ff1d-2215-611b-0bc778f1c7a9@suse.com>
Date:   Thu, 21 Apr 2022 09:14:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] scsi: iscsi: fix harmless double shift bug
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Mike Christie <michael.christie@oracle.com>
Cc:     Chris Leech <cleech@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <YmFyWHf8nrrx+SHa@kili>
From:   Lee Duncan <lduncan@suse.com>
In-Reply-To: <YmFyWHf8nrrx+SHa@kili>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR04CA0121.eurprd04.prod.outlook.com
 (2603:10a6:20b:531::26) To HE1PR04MB3098.eurprd04.prod.outlook.com
 (2603:10a6:7:20::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af3ca721-b5e0-44c9-afff-08da23b1f9bf
X-MS-TrafficTypeDiagnostic: VI1PR04MB5104:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB51047E442792D9FBE7616559DAF49@VI1PR04MB5104.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pCLPOnz7Glkf7teAxE4VXm6qFbD/EU2xMuHU4uaAW3OidyvaGLU+bJlrNEXBV18+XSa3QacDE8GvQbFVv4lZJaaRZQd2D48g9NQyyQ7/DW//dTYhx1B2ItumoLMqNFNyA2aegQY6mapdJFL8MyPpeG5WetAjqZKt1ZeizwKol4yWssDNdej48gNj3Ry8rgvUytduqDQmTthx32ZMP4lSpZMXpcqFrKVvg+oMm091idvzMqi2DXJP28eGigdsqhx7U8y9OAh6XtcdPGytyRXKtP/cqxx35asFyq3mAX30wwTsL38ZMxlv1jUnSezUpFtLOS2VLPTBiQJ4BXHlkDuRj1vOkkoPDEylw2ov/J9Sgb2270h44JYm0jiIhqsw3RgpK0OLkbi4AwKBGROuxANf6AV60DstC8LQlWTWcQp3/yMDuRmeAcdo4gPeCocoSqU+VTnslbWb/Rb7eHn5wdsqTPLH1Taa0BuDATd340gca9nsaefbblU0L9eQIG6mijkmv3dRfNZe45tIeQ7VEM8NDHEt6Mr9kGVZUoTR+mkNzlFJqHTUX2P7G9Tr51lcfQAgiEIjf/oS4pj8aWoyKLOijCWPbu1e2aicNneHurK661a+rUKUWP894Hdb9LBSivI7djnE5cwr5B1003zYKWaaFW04FcVOQ/UIaOFBl8WuxLAjCc+F6osvYz3X0bvum+ET70Axd4s/DiCnb3+26anA0KIAUoZR4f/stoikrWpfQhE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR04MB3098.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(6512007)(36756003)(66946007)(4326008)(8676002)(31686004)(110136005)(66476007)(54906003)(66556008)(2616005)(53546011)(6506007)(5660300002)(38100700002)(83380400001)(2906002)(508600001)(86362001)(6486002)(186003)(31696002)(26005)(6666004)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RFc2Nk0vOHZvOGhDL2pXRmhEZXRuenlNT1krVkdlL1MyRUp4bzJieldQbUFL?=
 =?utf-8?B?OUxLNHhwTVo0Qk1CNGhuRkJ0OUs5aDJ2SzFBbS9kd1hJbE1Rb0Jqc2gxZG9R?=
 =?utf-8?B?Tmlab1dqaTdIS3B4YzVKQ1JiWnMyOXM1V1h6ZlVEd3Z5U0Z3bEhCL0xPOFRB?=
 =?utf-8?B?bHRFaTA4WWJEY1JsU3Zxem9DWkw0dnJYN1piaU82bDVORU9jK2plWklQanpy?=
 =?utf-8?B?T29SSlFqRlNzUzFQRUxEbmUwb3J1VjZjR1VqUkhwaWJtU1dvWmViSDk5cm5V?=
 =?utf-8?B?NjhiMk5nSklsYlRjYUpxU1RXa1VRTUVTMGI2TjhpSnljTlJKZXpuNzVpWS9S?=
 =?utf-8?B?Sk9WSXFDcGJ6eDFSWHhXYWt3cVBabGlWZlhUTE5aci9nZDZET3lwMmMrY0kw?=
 =?utf-8?B?OUdmVDZYTFROazZXNml4RkRlWjZzVTdtdkJqc1ZjQkVCNG1LT2tyanNkaGsw?=
 =?utf-8?B?bkJtZFRIUGRuUjdZZzNCdXkxTWNlZTRnZXNNZmpCTSt2WCtMRmJVRDY2MEYx?=
 =?utf-8?B?MjF1QzZzL0xVVTRZVzdmcUtxeXhKZVd1ZXF5SlB4R3VvVW1LUkpHNDQ5elAz?=
 =?utf-8?B?NFNBd0JLTWo5K3NFWTgzc214cWlBZXh6b2c3VVNUMHRNTTc5Y29VbjJYMElp?=
 =?utf-8?B?elVjOFB5a1FMbTNacHkycXhWbmZadUNydnZEWDJWWXUvcXRrM3I5a2ZFWW5Z?=
 =?utf-8?B?VURvWlRKMUV0VTFkWmx4Umd4aWVCKzlmNHUvWTJaYzNpZFl0ajNRaXl2Tjl6?=
 =?utf-8?B?dWtmTGxpYlZIZXZYK1N5ZExKdlNNMzZmaFJuMmMzRlE1ZHEyc0NmUXlFSWtY?=
 =?utf-8?B?TnpFcTh1NTdodjROYU1HVmplVEtXYXV0cmxXQU5oNVJZNUZ5WGt3djZaOFhm?=
 =?utf-8?B?QXYrUXNGTlRDdytGN29tUW42MVpCZlA0WTk0ajhXdUE2dkNlbGNpazJZNk8y?=
 =?utf-8?B?ZjZyd05GUm14aVUrZHhuM0FyT25yMlE1U2ZSelBLU0FBdWtZSndMWDBTbFo3?=
 =?utf-8?B?U2VNMERSZlFSRkpRUGdMRzNaVURLWFU2L0hRVFlWM2VDZC9lWWwyN3hEQVc5?=
 =?utf-8?B?Und3ZnFrNDZ2R1NLL1NUcWQxZHhLTXNUM3BIcklWeGx2VUc0aHQxSWd1YXdu?=
 =?utf-8?B?TGlZL2JNcmFOZzVZRjJOM1g4NzVWMS9OZkxuQWg4c1JPekJXZkx3V2NIK1Ry?=
 =?utf-8?B?Y2libUdOdzJvZGQxRU1CREplTEtUcE04ZTJyNVJXMFhZZ0U1RnBzekorbHdx?=
 =?utf-8?B?c2x2TVpFMHU2T0dTSURQSU91bXZpSytnbUdYZ1IxY3UzUndocjhoQzNrdlBQ?=
 =?utf-8?B?SjVPdEFwTzFrK3pxTURXYXhCakloWWMybStMVURpbTU1d3FKdFN4TlBlUStz?=
 =?utf-8?B?Z25jL29tdDlGMFVnM3VKRS9SMXVqa0ZWaExqMkpVcUx1K1NCci9vZDVqUUFp?=
 =?utf-8?B?UUEvQTdqRGNuREExOVg1OG96R2xzZU8vQjgzU3VSczdISEVjMnJzelpmaXUr?=
 =?utf-8?B?M3M3c0lHRW41UzdHRTVaQTB0RFlkNFVjOFozVWs3TEJiM2h2WWY4UXF2N3ZT?=
 =?utf-8?B?a0Zxd1FNR3JIK1pBalcyaStWV0pOK2VYbktLZWtDVUFFWHZwR0ZpejFaSFNx?=
 =?utf-8?B?WVdZVSt2ZmlxZEJaREI5eGR1YW00eWNRelVTakF5SDhja0dxSkVBdzdRS1FY?=
 =?utf-8?B?U1hXMkRPSm5GcWxvVGRsUzJYb3pXYUdqcitGVzZ1eitKSXpDR002cnVMYUpI?=
 =?utf-8?B?WWNUSFJVcEoxSE01M3VobUg3V1FTdW5MYXAzVGJvY2FSK2VXV1MrR1RMTE9G?=
 =?utf-8?B?VVVpUkdMb2s0emd1Nk9qZHhzM05WYTVsTllncW1FNEcvcGJzbFV3TjEzOEtt?=
 =?utf-8?B?YVdBZGhyTklUUTRnU25tSnFvZGplODNjSFAreVhHNHh0WGdMck8vU1RBQXJB?=
 =?utf-8?B?bWRlaFFaSzBxUXBUcnB6Q0lVRGd6emxHdVYvMnEzeDNyZE5zZUJ2N3h1Vm9M?=
 =?utf-8?B?bHBTN2ZSajIyNmxKZHUrcWNvWHdpTkZNd1BPb0FSWk9HWHUvbStlRUhDWlVs?=
 =?utf-8?B?MzNvOWw0aDY1dHZ6YnN2UHpvQXA2eWJiQ2hRUlkyTVJha3lNdktrdWNWR0E0?=
 =?utf-8?B?c0JwN0lrSU4vNlpTTFdXTHRKaDdGL1VCVlpISDJ6WDgzb3l4a0haTzM2TWNB?=
 =?utf-8?B?cUtMVkpXRFpVVEN5ZUJ5TVB6TjZjZUJ1aWVNMEZTRWNKYVAxL0t1bGJhREFs?=
 =?utf-8?B?NGw0NzE2enU4M3F0eDcxUkRxdmFQcFZkaDBmQXNIQ3pZSGozRTVPZm1pWHph?=
 =?utf-8?B?S0pLWHlhUzFQR1JZazR3TTFJOE10R0h5QkE5b0lCNjMxbzc5eXlzZz09?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af3ca721-b5e0-44c9-afff-08da23b1f9bf
X-MS-Exchange-CrossTenant-AuthSource: HE1PR04MB3098.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2022 16:14:13.6212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5BM0/Pc9TLnMi3lmZEZni4Nosy4wu4pn+8AzGah+zZi9McbunRvBQhdkYpFPhxu7i0q/QHLNe4KIMxEcOgRW/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5104
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/21/22 08:03, Dan Carpenter wrote:
> These flags are supposed to be bit numbers.  Right now they cause a
> double shift bug where we use BIT(BIT(2)) instead of BIT(2).
> Fortunately, the bit numbers are small and it's done consistently so it
> does not cause an issue at run time.
> 
> Fixes: 5bd856256f8c ("scsi: iscsi: Merge suspend fields")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>   include/scsi/libiscsi.h | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
> index d0a24779c52d..c0703cd20a99 100644
> --- a/include/scsi/libiscsi.h
> +++ b/include/scsi/libiscsi.h
> @@ -54,9 +54,9 @@ enum {
>   #define ISID_SIZE			6
>   
>   /* Connection flags */
> -#define ISCSI_CONN_FLAG_SUSPEND_TX	BIT(0)
> -#define ISCSI_CONN_FLAG_SUSPEND_RX	BIT(1)
> -#define ISCSI_CONN_FLAG_BOUND		BIT(2)
> +#define ISCSI_CONN_FLAG_SUSPEND_TX	0
> +#define ISCSI_CONN_FLAG_SUSPEND_RX	1
> +#define ISCSI_CONN_FLAG_BOUND		2
>   
>   #define ISCSI_ITT_MASK			0x1fff
>   #define ISCSI_TOTAL_CMDS_MAX		4096

Reviewed-by: Lee Duncan <lduncan@suse.com>

