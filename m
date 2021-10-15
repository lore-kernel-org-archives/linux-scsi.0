Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3743C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 18:07:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D15461211
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 18:07:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242543AbhJOSJl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Oct 2021 14:09:41 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:42635 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237801AbhJOSJk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 Oct 2021 14:09:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1634321253;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vGptAujuvsSW7jBveB3x0Znj8lJc/cMBLq8jwSduA9A=;
        b=jLkcGeZ0+pBUUq/fhDj7MIbgoJDe0k3tOPcKhfxQyftHhKwhh4AUAY2aYXP3/UlK8x2V5s
        xe0rWosvSyAyioBTCJE+R0D0nOTPbSk6Vg5VaRIIe1Po6rJhLAeQYzfOc6MOgBf9Rg3xzI
        Yf+LMQxsxACwByLSwa0RsbS8zC5nnTw=
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur02lp2050.outbound.protection.outlook.com [104.47.6.50]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-9-Jsh1Ub1BM2qSma5qKx_P7A-1;
 Fri, 15 Oct 2021 20:07:32 +0200
X-MC-Unique: Jsh1Ub1BM2qSma5qKx_P7A-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dg1SHhKoH544v4gvRWIfVCaV7RQk+veJZWSM13hb5RlFfxFqnoieRylN6aWEyjMdStdtIW8Q2nS4o8IoSa4C6yX0OvsDa965dV1hgK0yMmQIESCaJVNCKE7Sjyf0daEFX4iKcEeqZ/HMgAxH5ghsa0R4NbswX556Q/J9o5U2Cp/6dPa7WVn3GUw3CgVgxiHMdqQPgHTXJNu4yotbe+OOknaKdxUG98TSx8dTgeoVZPuZNOt1lVk14I3sPg9mBp+PGL1UACrphOpOZCJSPBXIYdHZtDobCmuQPMh6YG8pC+skGTqkjPqZSVa/bQFiAyc2uPdk787uUnMGZl2jwHMOtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vGptAujuvsSW7jBveB3x0Znj8lJc/cMBLq8jwSduA9A=;
 b=Tr8htTJf8Kr6aSdkfw/RWaJa3T6k/d8ep9Q9Q6MTyLlvLsF79cHJfjgPMeWg5JukvuXdV6T3w7OQ3YH/h1APTkp5UET4vjgjUzKkQMTmqmOLgr6aAWcBcNN9OXTFCqtJr0AqSKGbxedyddaE9nNENfroJLus3LR6beuCuldmaWi+uH9jOAyS5hNGn/jpoo4hHRr98xlV1sU8hUBTypeibl69DdLeulVKLzEczbIknd7+Uc1tcQhQH2E4yUNg0JLKQSOXxehjAMJOS7mqMLdoGaAp/5xu3PRWbG4apSwrD3qySKu4oOV9IDCSqjWqepXGvLBV401rIewXkQZMIsMc0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM6PR04MB6471.eurprd04.prod.outlook.com (2603:10a6:20b:ff::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Fri, 15 Oct
 2021 18:07:30 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::a555:3b27:dc03:8fcb]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::a555:3b27:dc03:8fcb%6]) with mapi id 15.20.4587.030; Fri, 15 Oct 2021
 18:07:30 +0000
Subject: Re: [PATCH net-next] scsi: fcoe: use netif_is_bond_master() instead
 of open code
To:     MichelleJin <shjy180909@gmail.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     hare@suse.de, linux-scsi@vger.kernel.org
References: <20211015142006.540773-1-shjy180909@gmail.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <1a8eba64-e23a-c30c-89af-45dac00c5813@suse.com>
Date:   Fri, 15 Oct 2021 11:07:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <20211015142006.540773-1-shjy180909@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6P193CA0130.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:85::35) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
Received: from [192.168.20.3] (73.25.22.216) by AM6P193CA0130.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:85::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Fri, 15 Oct 2021 18:07:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1c4a8f4c-59c7-47c1-5fae-08d99006a78c
X-MS-TrafficTypeDiagnostic: AM6PR04MB6471:
X-Microsoft-Antispam-PRVS: <AM6PR04MB64710382C5191AD9B34C6088DAB99@AM6PR04MB6471.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P/91ZRx6ybL0Xg0y/HzDg8CvoQshT8MLDAANDbLTqZhAMvx6qJVTdl7QyoRLMdEFChbOJVHPwt6WqlWnh9qumurvQGrHDb492M+5dqTdza1BGBvV0BTOz+labrrr8s7faxqYpJHd5uH4DYq407W2JFrIhJhjQHkne7vrtXC5Tybh8vUWojvoA3yLCiHqMfQGkkSCnLU+NZ08L19HWghNn9JOWG7BioeTQxpqu3LFYQuSJkivktwbOZ9moshIScDnk6FH/eIYwWuDYxBUyKgdjR04mbsQ7RiXm/VhmSUTPYhU5z4jCKOijTe/34XAieMegTlswKWB6gGjq+p0OnKaTwwf6L3iFROzuyxCtj3BGwFcr4QJraQi4rCyDkFwhMoeSsp/SIA2+Yf/2P60OsZf60pFO8OVTTG9MnP+3PzmgF43t07qxOZ9yzEP9ZjFypoIJUNFxMkCcwNvkI0BUz0t+QJ/5DodRpGa2Rxkg7ANlYX/eqpnv6RxgHAFEy1sONd3oi4wnQfKXwBSfc6bPs9rMiwmvZcaT1AW7ahcO8aJKRa1Bv9EMuwrSkXWpZcX8oXQRut3td9fkS4584Wl3/nMYVQdswnz9v9DpVY6dzDYkgZTTj9iE9Rd6PNLMJuLPNQE/OJkeAZkbB7cXXDA2IOSCRiuV8D1g/b9RGj9CVHEUq8iIq3CWqSd9ecWfPiFnAiUj36GN/4XHRsajXkEOTlXE/hyYiIQtZbYu6Ty6NdnU5U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(31696002)(6486002)(83380400001)(8936002)(36756003)(31686004)(53546011)(8676002)(4326008)(38100700002)(4744005)(16576012)(66476007)(186003)(66556008)(66946007)(2906002)(26005)(5660300002)(86362001)(2616005)(316002)(508600001)(6666004)(956004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cHlYVGE4Q29SK1pPRGU5U21veTlTOWkyT2lNSVNqT2s5VTF4b05xQVJLRlFB?=
 =?utf-8?B?MFkrcS9OYnV2NmFMNWdBRkpDcUlzcUN6eUpUQVdzWXRidm81S0xiSUh2c0pV?=
 =?utf-8?B?SEIveW94VnIzUGpnNDdnRE82YitROWpmQWRaR3QzVlYvKzRiRGMvRmRVM2k1?=
 =?utf-8?B?V3Ezc0U4SnVXbHVoVThFQ3NpOEFJdk9lc0RxalVZdXBsRWVXaXhvVDJiTFdL?=
 =?utf-8?B?TVg2U1BCUVFNWW9pcGFQbGE4KzJ3K21TSzZKdm0zL01MaExkVmRGckJzVTRW?=
 =?utf-8?B?UWZ3cjVyTUhJbUxIYzlLdFlGbjFQT3dJUEhVYk1VWUMzOG9YTlJXK1hsT2M4?=
 =?utf-8?B?QW82ZlpaQjBqY2lKa0NObFU2emFqZTVoRVgyVEFNT1NxTHJZUWxqUHJMNmM5?=
 =?utf-8?B?TVBJWEVNUW5hUTVma1ZlQ0NxWFBlazVJZGh6MFBKZnBBZEVBSlFLMTBxeG5I?=
 =?utf-8?B?bGJsNnJhMHJCTytLOGxYUjNCQWc1VnNjN05Zb21sTzd1NlVTUW1qUndDUDho?=
 =?utf-8?B?Nll6VWR6Qm5UOWVOU2xoMndSVG5XUHg1K2NhYk10K296Rno0VDd5YzU4MWFT?=
 =?utf-8?B?TU5XMVU5RjVGbFdrbUlESXFqWVJDTEVhL24vb01LTWhiUzY5cWl3aXJPQ2cv?=
 =?utf-8?B?dmdvdngyaTBEUGxiVy9GOVBpMGEvb0ROVm5DYktqU3hGNjZFcjAvNU1tbjVo?=
 =?utf-8?B?N2NyQXV2YWJjRlc3ZTZJK0pWbkxTelN1QkNGN0xnMmpHRVkxeXJkK25YU1BB?=
 =?utf-8?B?VEtvT003MDltdXJrVXNDK0RhZUgvNXNpUGgya0dOTGZMTk5KVEpHWXRHaVhh?=
 =?utf-8?B?d1NFSEhOWi9jUHlKellaazhDNXkzZFdlQ2hxOUxzSDVFbnpQSEt6Z0JWQytE?=
 =?utf-8?B?Q3k1UTl0Y0l2a0dzUFpqOWVZQ3M4K0xhU1VROWZ6ZDJrb0ZIOWJkRU1vSUdE?=
 =?utf-8?B?NytJOWtqYTV4WVBLR24wYjBnbGY0dGtueUJqbjE2OWVwQWhiSjl6SmIyRDBn?=
 =?utf-8?B?VVdlRDFwTGxiaXRlVGhHVWZSdTlSY1dJcWNTZUJJNUMvNEFQcWZiWWZYUmNx?=
 =?utf-8?B?ajVqWkxEVDJ2WTQ2T01LSDZJVE93emp4OUF5WkRiQ3BTRjI4VFZNWnhmTWN0?=
 =?utf-8?B?ZitUMDlWRHVwclA1QTJnc2tTdDhYUGgyeVhVRDJva0VWSkEvSlFLUGIybzBD?=
 =?utf-8?B?aUQyTmoyVU5kaEFmZFo3SzhDdVlYQkIvckQ2TTZ6WEhkQ0J3ZHFrZFgwalpZ?=
 =?utf-8?B?bUI1djNJVzRrTzQwV2ZYb05McVJDNGZ2ZzgwemFQQmR4eFFqdEVWSFVCWVdS?=
 =?utf-8?B?djl2dlBwdWVIZHZOazhRSFR4TXd5OUt4U3BZTE9PSXkxWHRqOStBb0xNUVZZ?=
 =?utf-8?B?bENFdTdRNVM1bFNpZnJOVnVuVW9Ga0JBZnA3aGRKZ1FWQzFNRGthMnZWeE9G?=
 =?utf-8?B?QWFLd2d2MkFVcjRrM1FWeGxEUXk1ZTZQWXRkdkRUVkFaOGUxK0puUWRnRVBS?=
 =?utf-8?B?b1MxbmRCbmNjS0J1RytyL28yNHZQbzBXZlZYdTAzQ2xZRzg3SUUvZWpDTnVM?=
 =?utf-8?B?YWVCK1NHN1U2Q1pndnFCQzZmOG5LZHgwWVhFem1NNDlNSmdmWS9WNDNyS0pw?=
 =?utf-8?B?aWZFMWNueXpMWEdIK0VHeGoxaEVuRWFTVW1RTEZ0b01qLzUzajJ1TTZ5eWY4?=
 =?utf-8?B?bkFlRjJJbWZaM2FhaUZzV2l0aTZ3ZGthQ1Z1aUNrdGtUT0xpZ2R6VGdGb09I?=
 =?utf-8?Q?1AwYZx8gQsaA6A2cDBsyXcDkCvYhji1Et+ZdJvp?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c4a8f4c-59c7-47c1-5fae-08d99006a78c
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2021 18:07:30.6143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e+IKgXf18ZXw3V3/ljjTE2o9vhJFc7iIKHO0UfDCq25ExYdGNQ3XyYAPaUCnQPjJEPMHpJeagDVmXX/urTbjJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6471
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/15/21 7:20 AM, MichelleJin wrote:
> 'netdev->priv_flags & IFF_BONDING && netdev->flags & IFF_MASTER'
> is defined as netif_is_bond_master() in netdevice.h.
> So, replace it with netif_is_bond_master() for cleaning code.
> 
> Signed-off-by: MichelleJin <shjy180909@gmail.com>
> ---
>  drivers/scsi/fcoe/fcoe.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
> index 5ae6c207d3ac..6415f88738ad 100644
> --- a/drivers/scsi/fcoe/fcoe.c
> +++ b/drivers/scsi/fcoe/fcoe.c
> @@ -307,7 +307,7 @@ static int fcoe_interface_setup(struct fcoe_interface *fcoe,
>  	}
>  
>  	/* Do not support for bonding device */
> -	if (netdev->priv_flags & IFF_BONDING && netdev->flags & IFF_MASTER) {
> +	if (netif_is_bond_master(netdev)) {
>  		FCOE_NETDEV_DBG(netdev, "Bonded interfaces not supported\n");
>  		return -EOPNOTSUPP;
>  	}
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

