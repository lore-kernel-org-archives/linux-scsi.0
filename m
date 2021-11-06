Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7FB2C433F5
	for <linux-scsi@archiver.kernel.org>; Sat,  6 Nov 2021 17:45:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89C7E61058
	for <linux-scsi@archiver.kernel.org>; Sat,  6 Nov 2021 17:45:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234707AbhKFRrq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 6 Nov 2021 13:47:46 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:56419 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234709AbhKFRrp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Nov 2021 13:47:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1636220702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4LIyE8qUYUAbVuFrf/7dYxaILYNyxQu90zrS/mar/qk=;
        b=ngag7BXBM9VoUWTI3lG7tp81SdXRY4SEDLltrJ5CfzEYcOVC9YnmCAxiIkCiSs5uwrhnZ/
        2eE1bnFohE+k7jyWKQTwlJDfxM+oM+/A1QHP7ec5pl8FCc3OQuCs9NItk1KEWjTcTabkDD
        ljMk7VLOuhoWemeoJ6lq2uXo9pKhHPU=
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur01lp2053.outbound.protection.outlook.com [104.47.1.53]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-22-uVKrt56tO0C8W-FCpUzM2w-1; Sat, 06 Nov 2021 18:45:01 +0100
X-MC-Unique: uVKrt56tO0C8W-FCpUzM2w-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hSmQLRq7s+rCSpW9J/KaCnMncGGi6htS79QwquBDQnMKCEQGhKNKxVnMotC08fo+FEXWUOlSe1oeRniNivZwMak7p8djsXyTPot+AwRALnuB3MBfnXyWxp/YN8oLt45W5ptCBnRnA0EzyEkC2uwd3YZEIXSt8s6bUm/k79IWio1jtUpky41EUwLemDXEB2nE6i7rmBv6RESUDjpgoMS4K9HXaFAwuHesL1ypYmbbAubXuF9jD98NaSyCur3riOhrAmQeK6eVD0ZZvA19nzQInRKJAxbwH16nEchipmYOUQlqlEAuq/HEeBHJTsV2z4qWT+Bh4jQ4IPmDCn2r5ue6Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4LIyE8qUYUAbVuFrf/7dYxaILYNyxQu90zrS/mar/qk=;
 b=eyp9COUdjetAocGgKE21alTtUlWv73SVrF9qrpsEiquXWGU79f/PdQ/jKHZK+XJA680uI6ca7leYde54lBF/1eAbz/ReZI594Y+lFw7hxVUte+wEqGpt+flk+BVdrDo+A7fnxywfsgpmOogSPnKheTJsCYa3J9OUfM+gOPFilVWfEoIqpOw/kAqpMxUyax6Xi0NBRcGfADxyz0w4pLhJXbQgwPBDiTbHwZcAMr9+KskYqcoSMhf0+pWbtLbueDzmdaaTls18QEuB2/ggxupb6HaVjaHIdqya4tNWEnxG4WiZFy8eLvDOZvoh8RS1/JzAx4QyXj8o/A0IS7V1EKEONQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM5PR0401MB2658.eurprd04.prod.outlook.com (2603:10a6:203:37::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10; Sat, 6 Nov
 2021 17:44:59 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::a555:3b27:dc03:8fcb]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::a555:3b27:dc03:8fcb%6]) with mapi id 15.20.4669.015; Sat, 6 Nov 2021
 17:44:59 +0000
Subject: Re: [PATCH 1/2] iscsi: Unblock session then wake up error handler
To:     Mike Christie <michael.christie@oracle.com>, cleech@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
References: <20211105221048.6541-1-michael.christie@oracle.com>
 <20211105221048.6541-2-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <a104170c-d8e1-3071-7379-8d77554f987b@suse.com>
Date:   Sat, 6 Nov 2021 10:44:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <20211105221048.6541-2-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6P195CA0085.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:86::26) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
Received: from [192.168.20.3] (73.25.22.216) by AM6P195CA0085.EURP195.PROD.OUTLOOK.COM (2603:10a6:209:86::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend Transport; Sat, 6 Nov 2021 17:44:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7d377c24-6e81-40cd-90f3-08d9a14d274b
X-MS-TrafficTypeDiagnostic: AM5PR0401MB2658:
X-Microsoft-Antispam-PRVS: <AM5PR0401MB2658A29AF9C38D3E9B2D3249DA8F9@AM5PR0401MB2658.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bZpu4YEJDAOWrR4aHBUOR8eWYkXbr13Vd7zgDLEiMsbzpFYY22VkSaLRnwjdeSohDbhw5hGlFNgIw94feRp76nHRL0VWnKFmxFlt/FuCgd5s5vPMAHYCAhZVgSO3Uv3FE7Vzjj5S249FMp5F8IQfANN/V5xGMkO1jWJ4mxNOnZl6RKncUp6oYVGWjV7h/idXxW/U/UZ1UscMf8chS/cNAEZH4NuOsSJOHKTYG5A7BkXXt40eZMqRzgQcrdNAQbZepsMn+y2kD6WKH/VGtwNHSV3lmO+/J7/NaFWqfcScrzCfLzv3y4MeiQVBd92q80eFy3G3bQS6zTEvEmw8l6yFOJGHweC/cXb0QM5NGfDXJ7/MxUY778aJaVIC475DXiZSOcjOTXEkXbKNS8tRiyTxzI4WwG44WmTDjpaoDJ/OBw73tCOtHuyJmzsltEKK+ajd0cLzih0lT5NXcdZOfUgH72x6BFX3zWec+FismLnIrqx5DNX1yY9hmMw/vYVoivDTVn+uSVHogvuupS4Ge5G9xf2b5QDClBhWBt4uwZ+ZwKbw21gHmCfpv0jafTwzBM3HaxuwK4DQ0ubRu87MvdBEFnWulxz2EVZCNQN1mQjalg/DFYnnxkMRW6czCxp+KEfBEfYZFxYLIDziLm8iX/CPkap/8gs9QpbIX55mLY06f21NU3RygES/dpkonrnS+l7g+U4BEmXQ3Zhr4BFhAItvIbCaPse2Q3wvsByfDG+VHbI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38100700002)(66946007)(6486002)(508600001)(66556008)(66476007)(53546011)(316002)(6666004)(956004)(31686004)(16576012)(2616005)(83380400001)(5660300002)(8676002)(31696002)(86362001)(2906002)(36756003)(8936002)(26005)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bHhNNTl0UDNXNUFhQ1E1Q01pbWtYanFhVU1qYzd1SXJVQ1ZXNmRVQ09ERHlT?=
 =?utf-8?B?UGp2bHJiM0VuUjFUZUtNM0VvOGxkUm5IRnZSMXJrVlZFV1MrQWk5d0ExRHRh?=
 =?utf-8?B?bGlhb1ZndlhDQzR5NTg5NFh4UDJWdWk0VytnK2FlQ3ZGUms5UE9rQW9GSnlY?=
 =?utf-8?B?LzAzbWhhdEFDNkFOakxzOGlPOTBJT2Y0M3lhd05EeGVtQUthZjhaSDhVQVF4?=
 =?utf-8?B?Z0dBdGpseDlzV3FPalNrUjZQQVdPUHBTVFAvWDZLZnQ2YlU1QWdVT0toM2U3?=
 =?utf-8?B?ekcrc3pxcVo5MFVCVjUyalhWOTZGREFSTXpiL1JpalV1eE5hN0tpWlVZc1VE?=
 =?utf-8?B?dnpZTVB4dW1EU005MVhtT2M4eFV3K2d4VDB1bnVIaHNDYWFJMmhMTkVTYk9V?=
 =?utf-8?B?akpVV3BBcjVCbG12ZTlGUlhuM0drZHlBOGgwa3FOMFN2TGFYQVAxRTJWYm96?=
 =?utf-8?B?L1AxaG9wYTJPcVlSajFPSjI3TzIxR3k4Ry9GL3IrL1lJTEIxenByMm10SE5F?=
 =?utf-8?B?dzFIVGFFaGNWUkNXUHlwbFdUenBMMkVYNWN0Sm85ZlRhWmFUZEhWam1tNlRY?=
 =?utf-8?B?Rmd5MlhHZFExUjZINENDUWFSSHZwU3VyTHVLTUJqaWFJS0c1YTVEODZZVVVC?=
 =?utf-8?B?ckt2Y0VKc2VkdGlNNTJXNU5NMllrc1hYNDQ5MFVOK0I3c2FILzRmUDZCK29p?=
 =?utf-8?B?TDFxdXRtV2JueHo2eWNlMmtmdEZSTjZmV3FaSHkvT2lMNkU2dWFlNEw2cDQ0?=
 =?utf-8?B?UFN3ZzhsQ1YySGlWL1IwL2UyRXo0bTJYWE43WFFERUY1eGZqYm5FcFBwV092?=
 =?utf-8?B?M2hQQjYwZFhZbVJzQ0FZV0FkWGlrbFlYZFgvU0NsdFo2MFNxN1hKenZyMjNw?=
 =?utf-8?B?c2xwM0dKaGpLMGZVcVZ3WFJBRG5rZEF0UUxKdTQ2WDdjTGFrWnppdmdMOXha?=
 =?utf-8?B?cUtkbGFabjN6cmZEWk5XUG9peS9Sa0x6TTFaaEh4THF1bkZJcWpQSS9OdkZK?=
 =?utf-8?B?cncrYmN5L2pDaFo0Q0J1WXFsaUFVbWVTdnAvT2RDaVJDSTZTSWdPYm1FQ1BG?=
 =?utf-8?B?SktYNUQrMjVPd0tQTWRLSjJ4b1RycXJnQWwydUU5Z1EvL0pEdnJ6c0pKV0NU?=
 =?utf-8?B?eW4rSFlHYlMyZU52eVFpSFBwcXEzZ0ZZMzJ1QXRlMXE4bUNmUE5aK2FYZjND?=
 =?utf-8?B?aUpiMXlrWERDZ21LTzM5T1JWUjhydFdZYXlsM1RNYUE3SEhlRUNEZHNLMkZZ?=
 =?utf-8?B?Sjg2OS9LUlczT1BMQkZqSFJiRkdTTVVjSGlnMVRwMDBLTXhvZUxYUnA3N1pu?=
 =?utf-8?B?S1BHS1hLTnd6dC95TDVBODJZM2wyRkxoWXp5WkQ5aEtoMjRzaHZUcTNheW84?=
 =?utf-8?B?U2R4YXZmSi82OGdlT2lEQi9JajZFWFZNTG00VVJqZW5UVWNOYm9hRkNmM2pL?=
 =?utf-8?B?RVRKQXAzZXZkdlhxbDE3WTY4LzFzdGpTTlAwV1h0b05aYXFJa2JPdU84VzJx?=
 =?utf-8?B?R3FjNFNCVWpDSnlQUHRLOEVFWWFHb3FkLzZUZ2Fybnk3U0d3b1NnYm44VWps?=
 =?utf-8?B?RkpnMjhienByZWtac0V4RGdJWTZNN28yQjNNclpyZnZQMHRBY1AxYm5EUG15?=
 =?utf-8?B?ZC91cDlaRkxGUGI4QUJlZ2lpUUl2NUJ2ay9nNVpNRHc1UXY5bitkUnpQMEx0?=
 =?utf-8?B?MlJvQWtMYXZHOFVPSkhTcXJwU3FIc1V5dXp4S0tCcmN5WloyZ1RWaFQyT2ZM?=
 =?utf-8?B?YytxRFloTXhiU0RCUkJQS1ZaNDJPU3BvY3cySkN5dDN6eWFTZDduaWFUWURO?=
 =?utf-8?B?RHR5S0h6Wm5ZUVdHVlNoWjRlUmVLTVdjbDFmaXV4RDJLTnRHMFdwS04yZmxh?=
 =?utf-8?B?Qm04WUtJVDJFSEc1U3UwSitBUjBxeC9yUVM5Y2FXdGN4YldOMWpHRmtqakRo?=
 =?utf-8?B?REFTWktRRTA4LytiNjZPWEIreGFFcE1ldm0vT1NkemtTK29JNWxzbU1rdHRt?=
 =?utf-8?B?djdCd0sxSXV2eWlhdWEwNUl1MkoyVkJJUnhYcWpBazZaNjFtZkdTNXA1SzZO?=
 =?utf-8?B?OGkxZnQ5NkxNZi91OHdBcE0rT3M1RVNHUVoySnZabkpJaGJSa25nc1FwQzU4?=
 =?utf-8?B?c1pRUFdnQUoxeHM3RGtXSk1IUmo5cHdTRmJOdUdUQmlEWXJTdFJNWTFBK0tX?=
 =?utf-8?Q?3kVLHlxjSTdQgQEavHRxo3o=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d377c24-6e81-40cd-90f3-08d9a14d274b
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2021 17:44:59.5132
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rCqtpwBLN2R+7QTF4hZI+C+XCBGb2mj8VpTT+Sb+108i9kDPnkIEVD4tDs7VkVNxK3kIPCIfgJ5T/LrLOO08Ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0401MB2658
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/5/21 3:10 PM, Mike Christie wrote:
> We can race where iscsi_session_recovery_timedout has woken up the error
> handler thread and it's now setting the devices to offline, and
> session_recovery_timedout's call to scsi_target_unblock is also trying to
> set the device's state to transport-offline. We can then get a mix of
> states.
> 
> For the case where we can't relogin we want the devices to be in
> transport-offline so when we have repaired the connection
> __iscsi_unblock_session can set the state back to running. So this patch
> has us set the device state then call into libiscsi to wake up the error
> handler.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/scsi_transport_iscsi.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 78343d3f9385..554b6f784223 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -1899,12 +1899,12 @@ static void session_recovery_timedout(struct work_struct *work)
>  	}
>  	spin_unlock_irqrestore(&session->lock, flags);
>  
> -	if (session->transport->session_recovery_timedout)
> -		session->transport->session_recovery_timedout(session);
> -
>  	ISCSI_DBG_TRANS_SESSION(session, "Unblocking SCSI target\n");
>  	scsi_target_unblock(&session->dev, SDEV_TRANSPORT_OFFLINE);
>  	ISCSI_DBG_TRANS_SESSION(session, "Completed unblocking SCSI target\n");
> +
> +	if (session->transport->session_recovery_timedout)
> +		session->transport->session_recovery_timedout(session);
>  }
>  
>  static void __iscsi_unblock_session(struct work_struct *work)
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

