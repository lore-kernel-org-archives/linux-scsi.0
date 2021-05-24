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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12F3FC04FF3
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 18:36:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDA1D61414
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 18:36:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232548AbhEXShm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 May 2021 14:37:42 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:50794 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232442AbhEXShl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 May 2021 14:37:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1621881372;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Uo/YREMJRg0oBS6Fm39cQEK/krnvCZSdNwl8PZYQGdM=;
        b=U137lkPsPMy1jQb+L+76qtaL24Qw1yKzVtAmeuMtnLtn/u/Wj5T6JAX8BfMBTpYkFJFfIW
        4SDk6SsEb2MRB8SFQicZWnN2paxQm18alU0E3lB7GiJI96bSvJaIBgLb2sPVaHRxVdmmpM
        BW9w6Y7C/Nfp0cQ8KjgZzpGVahu4/Yg=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2055.outbound.protection.outlook.com [104.47.12.55]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-17-Ledy8CySNuextOuAyQnDbQ-1; Mon, 24 May 2021 20:36:10 +0200
X-MC-Unique: Ledy8CySNuextOuAyQnDbQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HsjK64ML+Veyx/BVE01ebt/u54P/IvqxCtNK0dvtc3Chak/MrvGc/Kv5G8R1I+Bueed6Rq0MLHXw7IspW28B2ZXbjaqMRdKgfaLEra99D52PX/eQuAqTah3XypISWT8brfJgKj9OTH9E5wLYhQu1wbl/rh+s4GzXhNvJl45gE5Isa3EVouMDy9gqnMnhHWyWrSn/ei0ZbMGVsYZwdo4I+ek0l6e6t6nFcN97LwagJwJufCoQvJlPTsJt4wOkxxc7pJGM2xXfAPnCP0wj3rIfytPc2nV9SzUErkJNOfs/rhpEJNWe/uY5kuIzc/oiChwRHOcTVdmisJYeehaM7xHABg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uo/YREMJRg0oBS6Fm39cQEK/krnvCZSdNwl8PZYQGdM=;
 b=UvR6msYJC/lvE7lZeQaUj1IoYVah6H2DQyTUn7LoHUBEFdsmEghCRdyRYQqsiblVMb/5srj/TO0Ccg5D/tRrlJSCTDJUZM49NedX90T1Kcze5cqEinYRnMH7yPdIMs+MXS7ubARLYG4xaUSDESXMhRZkqraLeq6dn1OZVjECYcoVWWzLz567jPs0JvSd6xF8Bp1EorChMF7Yd9CaM/sV5ZZCMIeibahNvdecEeyY3Lm5CyZSzwQBH0vB8YrzpkCnfJynyN/cEHA9UGcRkKYW0eiBrSk2cqtRfsK5/ZXQ1abGq3y2TSA6eRe5j0gMjle66x0/dyTh1uU9BvUr5PsA5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM5PR0401MB2546.eurprd04.prod.outlook.com (2603:10a6:203:38::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Mon, 24 May
 2021 18:36:09 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::d1a5:8072:c01f:3cf1]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::d1a5:8072:c01f:3cf1%3]) with mapi id 15.20.4150.027; Mon, 24 May 2021
 18:36:09 +0000
Subject: Re: [PATCH 11/28] scsi: iscsi: Have abort handler get ref to conn
To:     Mike Christie <michael.christie@oracle.com>, cleech@redhat.com,
        njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
References: <20210523175739.360324-1-michael.christie@oracle.com>
 <20210523175739.360324-12-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <5c402b96-3734-39a2-b1ed-35200c811e23@suse.com>
Date:   Mon, 24 May 2021 11:36:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
In-Reply-To: <20210523175739.360324-12-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: AM0PR10CA0077.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:15::30) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by AM0PR10CA0077.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:15::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26 via Frontend Transport; Mon, 24 May 2021 18:36:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 92ce654e-e270-4e5e-557f-08d91ee2cc46
X-MS-TrafficTypeDiagnostic: AM5PR0401MB2546:
X-Microsoft-Antispam-PRVS: <AM5PR0401MB25461B3FBA77997AD7920008DA269@AM5PR0401MB2546.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BVl19y9Ayu9VcAFV5JhC5A5VuT3iVJ9GB96ZlX6ursuiA2zfK6BInVfp+YkW9Orw05uMg6UM/YPyEKX9o8tpE2hrGyhRpKPCvvgylbvY3Xhzo7zjmeEQ//oCSYFdEJCzanP2L8W3NGfCPAOxybVBH6l8WnjlRmXHtoHHVtMyjJI69Nnz/AZPsS4dCBfxK4A2hScDQdJS2hVOlf5YMGnST8pC64YmcMsUF1nDp4QtrAgJMHALINyGT7c59beCadtenBJMUq2HU+6XAMpq/x+aNP+dVRoiq5lksLDGpAxyRM46bUtQ81qStf/ZgYfSsbQMHtoF7vjeNrRP9I8DfWUQYUj28vsnoVSF8MUUByV0qWec+TCinahue5qKTlzcHkgxLE21JSYfE0axq9ZIhyd1JiH7L34ziCA9C0/YRYAeZItKZRKuPSY1+Ts4jqEo03WL3Y8F/J3UxUSFCwZW5oIfy2PO8+aBhjL2uldq6PcmaXBMSXGSef+h1mNdV/sy3hSl7MSqycmVj6LL/Qm1xI55nK1fy9DQyRLM76/BunZcOHRghB8FRh9iz8q1jY3SWRKhObZ4fgRhiNXmVLC36T5DzS9X62tbxAyAeFB7OdVZpUlozandnNBNJHMoEv9A6YPsVRXeo3P9+XPd0MxSDS46c5zhDg9raCm/q2jT/T810wSFutRvQ6V+dQXQqRA+PnYp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(376002)(366004)(39860400002)(136003)(6486002)(5660300002)(2616005)(186003)(38100700002)(36756003)(16526019)(53546011)(16576012)(316002)(26005)(31696002)(6666004)(66476007)(66946007)(2906002)(86362001)(31686004)(8676002)(8936002)(83380400001)(478600001)(66556008)(956004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TjRBTkx3Y3BNUHlrbHdvMUNnOUc5Q1IxTHpxeHh5SU9CdXQxanNjRXdLUi9v?=
 =?utf-8?B?cXhOcEZ5Y1JMcy9rYkx3c2lmS0RFV05aSnplT1ZsQUlad3lJUzFUTmJtb1JB?=
 =?utf-8?B?bzlPRUlJZ1A5T2g4YzlGamZkNGZKVkUvMkY3d0pRRkVRbTJSQ1hyT2pLNFps?=
 =?utf-8?B?cDR3aTBvQmFaRkRIb0ZwZzBaOVp4b21JTXRISjJjOTZ3bEY5YlVMQy9BWEY4?=
 =?utf-8?B?OFNTNkJ3d2dFUnRDN0lURTlCL2RaaDNFMlNWbGE3MHllbjhuUVJhVkNtb3R2?=
 =?utf-8?B?U2liQW9CalpMOHhpcUdZWE5oUG5wTFVkTk9QRDNhNUFYU2t2YnlTUzBJRDJi?=
 =?utf-8?B?TzMyandWR0pUM0pWRGh3WVVsLzVHcmJRU0VHeHE2Z1NYUUZHWi9BRkhiN0Nr?=
 =?utf-8?B?UDZEOE82N09FN25TeDdseGRlUUFQcEtBVFBzbVJPYjQyRit2RnN0R20vdlFW?=
 =?utf-8?B?YytMZ0FkWEJaLzVlOU9qSUxGN0pvRSthdnEyblBMbUplWEVpeHB6L2d3cWRM?=
 =?utf-8?B?ekdEbTY4MkVyUjlUaUpVaGZoOHBmWkNZK1VtYVJLNjdkQm5NVmVFRkhMKzBt?=
 =?utf-8?B?dm41WE5QY3Rpb01lMFFoRHZONUs4Qk9PUEMyeVVzaVhIYjIyR3JZbk11Tkdx?=
 =?utf-8?B?VkNDRkE4TDhDRGFJMXhoNDdSbC9kV1B6NCtidlpvZFBweEwvME8rMmJySGVX?=
 =?utf-8?B?a0VPOERSK24wY3huRFBrYm9FdFVDN3JxMVIyL0FQSGZsNU9NV1FnbGQrQlVL?=
 =?utf-8?B?aUFvekF1U3RuNEp2eXNVWW5HWGRmNTVtMTRJVDBBM2h6TktKdkF5bDlsQmZS?=
 =?utf-8?B?dXhjZmhGZWNSYUlXekE0WnpmanVFbzJXcUdHRXV1NzFFQXYrbmxVc2NlVzRp?=
 =?utf-8?B?TWJ4WkhKRUJlb21YNEYzMzlJQklGUVI0YktST25oUTlDeUNoYXYycHhqSGk4?=
 =?utf-8?B?QnpKRkV5ZWRSeUFWSHB4L2pZTTF0cDNTbGJIb0FFdDhKajVhQzJ0RlJiSHZ1?=
 =?utf-8?B?cW9kQ3l4dHkvTVk5blZFYlIvNGRIUkFrcFFEUW4wR3FzQzJuSkpRTVFmVElp?=
 =?utf-8?B?ekxtQVNyVDV0M1k5MHpWZXM1L2hldW8yODVZaEszQThsc2YyeWpiUHJxUG9p?=
 =?utf-8?B?QmpWZU1rZDh1WjNaM0lsRmRodE5hRERpR1NkWHIvczRtSDM3cHdoVTNqZGQx?=
 =?utf-8?B?R3E5REE0dWVQZFZRZkJIUytvcGVTL2ljOVZuNWZYVDZ6ZXp1ekJEQzlFL1RF?=
 =?utf-8?B?U2lrdTQ4bFNiMVlydlVLV0JNSVlpQ0pnVUl6N2FFUmp5NmVkMWFpUzJYT0ZC?=
 =?utf-8?B?dXhHalVEQ0J6QzJXZmh6RDhSRkU0RHlrY3VoVW5xekZNaWcrOUI4YzBRemJz?=
 =?utf-8?B?cjRQMnAvb1hsdDJaMkZVM0I0THFLWmZoYUdLYXNKUDhFZzJPOXRJQkJpalpN?=
 =?utf-8?B?S0lnNVY3SjlpQWNLTGpLczZjZlVTWFR0Q2dEcGhldlB0RXhXYmpyQ0k2OFFw?=
 =?utf-8?B?b3NuMFJXOWd1ZEdpQUZUSW1MMDZEaFJXMHgyYUh3WjNNRGNnbTdmRjBBdnJU?=
 =?utf-8?B?eGxaNUNCRWg2Um9lV29IRnJZZnkzQXIvSzJiU1dtMmRLdWxvS0FIakxiZFBM?=
 =?utf-8?B?cmtyd0ZvSEFGbVgzYUJ4WGRYVUpraGFTNzV3YWRlKzhHbXlKbUdqYWMrdjFo?=
 =?utf-8?B?YVhlRlQ4Q0R5Vk1aWWI5c2JPSFR3QzRkbXUzUkNkWVQ0bDZtQ3hrYVBEVElD?=
 =?utf-8?Q?6bM8vJPsBLNo18NPtceJNFs6KwFzpikDM8Xw1q3?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92ce654e-e270-4e5e-557f-08d91ee2cc46
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2021 18:36:08.9218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZmG3RamtqUgoFJUKo7cAbzQiXkz3Dbke5gnTL8zKO13l+ANHD/ETDfDG28xFwWocYGw8mb3BCQSp25hyBG72jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0401MB2546
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/23/21 10:57 AM, Mike Christie wrote:
> If scsi-ml is aborting a task when we are tearing down the conn we could
> free the conn while the abort thread is accessing the conn. This has the
> abort handler get a ref to the conn so it won't be freed from under it.
> 
> Note: this is not needed for device/target reset because we are holding
> the eh_mutex when accessing the conn.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/libiscsi.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index ab39d7f65bbb..6ca3d35a3d11 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -2285,6 +2285,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
>  	}
>  
>  	conn = session->leadconn;
> +	iscsi_get_conn(conn->cls_conn);
>  	conn->eh_abort_cnt++;
>  	age = session->age;
>  
> @@ -2295,9 +2296,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
>  		ISCSI_DBG_EH(session, "sc completed while abort in progress\n");
>  
>  		spin_unlock(&session->back_lock);
> -		spin_unlock_bh(&session->frwd_lock);
> -		mutex_unlock(&session->eh_mutex);
> -		return SUCCESS;
> +		goto success;
>  	}
>  	ISCSI_DBG_EH(session, "aborting [sc %p itt 0x%x]\n", sc, task->itt);
>  	__iscsi_get_task(task);
> @@ -2364,6 +2363,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
>  	ISCSI_DBG_EH(session, "abort success [sc %p itt 0x%x]\n",
>  		     sc, task->itt);
>  	iscsi_put_task(task);
> +	iscsi_put_conn(conn->cls_conn);
>  	mutex_unlock(&session->eh_mutex);
>  	return SUCCESS;
>  
> @@ -2373,6 +2373,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
>  	ISCSI_DBG_EH(session, "abort failed [sc %p itt 0x%x]\n", sc,
>  		     task ? task->itt : 0);
>  	iscsi_put_task(task);
> +	iscsi_put_conn(conn->cls_conn);
>  	mutex_unlock(&session->eh_mutex);
>  	return FAILED;
>  }
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

