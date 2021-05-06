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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 600F7C433ED
	for <linux-scsi@archiver.kernel.org>; Thu,  6 May 2021 18:55:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D5DA61289
	for <linux-scsi@archiver.kernel.org>; Thu,  6 May 2021 18:55:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234319AbhEFS4u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 May 2021 14:56:50 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:31942 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234197AbhEFS4s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 May 2021 14:56:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1620327349;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LQI0SUiwhkPP6R+praTIwEeysgLFJBYHzNTlUjcsLUY=;
        b=AlRmVR2VjKk7X+FDujd4FR5N+tjtVAy8zfZ3uVJeI6KMfqG+MnYx/9y2YswY3Z4N3WNLRp
        gXYcL7qV66f83bl95jLt7YJ6hyNsdOTximOTkinpR+LgISjHA9SajaHI9++6Wj960EtGfk
        nsszqyHKGDovpIX443Gw7dZV67cYDDg=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2057.outbound.protection.outlook.com [104.47.14.57]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-3-lsMrfQsfMyGHN_z9sDaUKQ-1;
 Thu, 06 May 2021 20:55:48 +0200
X-MC-Unique: lsMrfQsfMyGHN_z9sDaUKQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jpqo6zQqnKxlbvPTSA8/YfuFbbi2kOqjCVzSADzMXAj2jvUq8wAcZxroYB5RSr5RjMfmgTioEaqjyvqng5WfVyJkAsIPDV/4wcXk14nyXVF1YZtkwz13HO7DacRP7PhgM5jr9KCU0h+bYhX0l6rFS42CUjyJSMuZ9eHHtEy0Q2GOgxl9AIoFQ9Uz0MkTUV3BoJ5hvusVzMk1f0ckiUMoExgH+8tE6AL6E9+2/S7bUY2AN4PbG4HJmpB8XPFkKISSRX224UZRiFk02KBhyTOCxGd3Hw2k3f+XLDM1huCoSOzN1XNP+LkGbmQutLeVUGkgDA17o1XXGdlVv1AaBwPjlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LQI0SUiwhkPP6R+praTIwEeysgLFJBYHzNTlUjcsLUY=;
 b=Ipx1g9a9DVVH8yTs6Q/c9bghhrS7IMz0+j9zq0ndSukfR76w1G7U27utHqKv4qwb9UThsSzBZyF6V88tP8DrBpqx6vqapAWObDV5ELkGSqR3wmgumB/B/bEjvYRe/7aEGDxUDazNEPFnJ+gyrkuQCDfitwHI+grd1IgCuf22czCTw8XlMl4b4VB0bFQyV27el8hJeS4z9e1Zer9RtII8aT/ESsobyD9TLs5RORhjGJGfQrW4IMujgmjQHxNAGuuI4y5/dTlWlv10UF+C2PQC5Qsq6V1YmkWvzk4MFNGCVq5EHjx76P9irhwfKAR/JqemUtofwXSoH9SzoSUDWN2bMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM6PR04MB4104.eurprd04.prod.outlook.com (2603:10a6:209:4e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.27; Thu, 6 May
 2021 18:55:46 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72%7]) with mapi id 15.20.4108.026; Thu, 6 May 2021
 18:55:46 +0000
Subject: Re: [PATCH 110/117] Finalize the switch from 'int' to 'union
 scsi_status'
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Don Brace <don.brace@microchip.com>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Can Guo <cang@codeaurora.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
 <20210420021402.27678-20-bvanassche@acm.org>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <da36945d-fb60-67db-27bb-6016e1a8f651@suse.com>
Date:   Thu, 6 May 2021 11:55:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
In-Reply-To: <20210420021402.27678-20-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: PR3P193CA0046.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:102:51::21) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by PR3P193CA0046.EURP193.PROD.OUTLOOK.COM (2603:10a6:102:51::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.26 via Frontend Transport; Thu, 6 May 2021 18:55:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 04e5de23-9771-4f97-e376-08d910c08ea6
X-MS-TrafficTypeDiagnostic: AM6PR04MB4104:
X-Microsoft-Antispam-PRVS: <AM6PR04MB41043B6284D7660A681D0E09DA589@AM6PR04MB4104.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y4/CGxvgSILm/fksTjz+buZvh6cgvGv/riXq7shCBYqRt1QGaUPC3kwGUd7rvvIa+sjoAvAqA/UnKmH0kOU81vHtSFvcQn9RIkQQdI/dcPxD7PhjHL+/5H3rqaL60xa60KMdZhRaNQ4fbfKRME/mEr5NPAT9JYgBpZuhofXIXjjeTTqc/jLKwifsx525zN82PzTespNXeLxfI33ijxkCLN5U+wB9bvp08jGVIGVSffuXnR1RizJ3Di217EDDvXD4o0HLwFIkYfzj2bzQrIbwzhu63xikSwwc2QOTiz0mo14yJ6zkqGOm/nEjj7Amp7iAR6IFILrwcGQ3x3GAKPqVg1IEBdGwsKVo8jHABS4duO3hBGTvli+eanuZ+Bl8o7RubruqeSbO/3thdAj9NiJgCSAsIkRjBI1Gkt334R3T7vS+Q4BiADpA/fx7JVGWiv+4VGGSgFnbvsfPrkgIUK1h5SriSc1gu2YU0w8nXW/tsgC0TP4/TspF97Bk0mugiurAbV2Z9/GwpQlSwP5MQBfwVK8K50rp6LcITHf1xzs9xGSFAZuLLsVANZezVbVRXtZm0BZgc0Wfv6fyZwPSMnf6K+W5BRWYiphEnMiIt5qQ7zpEmK7/KkbcIYB6NwFlXQEpfRXDy2PnWxVrVBb16GFXhzP84lFc2CtzaYBj5fjFUb0wKVUIvtyYJoANvtb3+bGLQ6FmOmsCC1VlzHnQM2DGV7vMglpdkDytnRxPJaMry9Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(346002)(396003)(366004)(7416002)(26005)(956004)(16526019)(4326008)(6666004)(86362001)(2906002)(31696002)(38100700002)(38350700002)(8676002)(54906003)(110136005)(186003)(478600001)(8936002)(52116002)(2616005)(5660300002)(36756003)(6486002)(83380400001)(53546011)(31686004)(16576012)(66946007)(66476007)(66556008)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SVlLMmU0NDhXc1lnSEpjMWlML0MwZFcybHhKRlZoYXN1QVJERlk4bTVTRjY2?=
 =?utf-8?B?eC9SQy93VW5wWnBJSmZiR0tzWVRmYlpaYWdZS1BKQ0JRREc5N3M4bmR5SHdT?=
 =?utf-8?B?RXVaYzRmRDFZL1BRTkdwSDhRK3g5cndDUHJIakFXeStaZFR0elliL3IxWTk0?=
 =?utf-8?B?VTUwSE1IOEJvMWZESEdtcCtYWW93TnB5TVErR3FYeVJHR2pzbXlESEo3enVE?=
 =?utf-8?B?bWVoN1E0Ti9TeHZSb1JiV3NScXJnZklLSStlWnlpRy91Wm9US3dvTTAwaTVp?=
 =?utf-8?B?cmVwakZySnBsRHFKSFRZTTQzbldTbk1pY1dJeTcvb1p1UjJCUlZEa0NRUFNR?=
 =?utf-8?B?bHVqYUtCamlveUZQeFdPcFlvTGRsTnZSaUpsdkhCU1dEUmx6bFUzejV4MTRV?=
 =?utf-8?B?TlkzN1lZajJ0WXR6eXBjaXgyajF6SEpUWXNmVlEvVWRmUkk4S05McEJhNVBU?=
 =?utf-8?B?TFgyL2U3eW4wbHZtOVROV0VhenUzWEF5NUtzUkczSy9Vd3lvcnhKdWJwUmpX?=
 =?utf-8?B?c3UrSDdyWERHVmdsV2k2T2lxZEtZaThWT1Awa0d4d3l2RXZ4WUUzVGpKeG1u?=
 =?utf-8?B?R0hSZHdVLzg3NVZDODVKSGkrOTJadldZelBtZ1Z0UThiZjBUUG1lbUlsVmJE?=
 =?utf-8?B?ZDI3Mmh1ZGVLOUEvMnhWUVhTRHVQZWRXdmc1NzlrcGJqSXU2OEMvR05CTkp6?=
 =?utf-8?B?ZWs5WXJqVE5tanVTSm9rM2dQdG5WTDhBUlBrZnhFMnpDcHFQZHp0MG43R3ZK?=
 =?utf-8?B?UTkzbTMxUStMeUN6cm5EZ0RETWxmNE9uT1BRaWwyQko1VExhV0Q5dGpIeG1Q?=
 =?utf-8?B?enBzdmZHb0EzVkx2YjlMMzZqRTBnWFh0UEFqeWJhY2JiUTlvdE8zUTR5dFYz?=
 =?utf-8?B?RTAyM2llY3NQdGZwbk8rdm1iZWtWalhiN3A2SUFiamVYYVNvZmQ3T1NqMFpJ?=
 =?utf-8?B?S2lMSitucXI2UVBFM3JYcDBpZkFicEd0YzY3bll2S0ozQ3RxMXg2UVpEaGty?=
 =?utf-8?B?VmYxTXhEazZ6c2hmZjVwUWdwVTc4cXEvZUQxR25Qd0YyOWdMNTFYL2pZd0Nr?=
 =?utf-8?B?aFZNNUJQRUs1T3NaWlJWcmFOSDFHYzlWM0pRUU0wV1FldmpkMkdLU0lURGNv?=
 =?utf-8?B?WXRGV1dGam82Z3NWdmt6WUxIY0FjMWVjOFBRNVVwKzVoQUVRa29lSlBZVjFr?=
 =?utf-8?B?bDV6ZXZMTGZFOVFOM3ltU21lb2wydC9SUFYyRTNRMjVQK3R1YWRKc2pKY2hQ?=
 =?utf-8?B?Nk5GVURsTXA0cWNTSDNhb1ZPNUkyUHRUNDY4VGV3UnVPZnBkNGM2M3ptYTRL?=
 =?utf-8?B?RXhvU2hCdlFiTmJiTW5WeXFlWXpNOHVaMEpGdWZITkltODRaNDBxUjBrU0o1?=
 =?utf-8?B?Y2s2bEp6cHJFOUVCYzNyRGEzZGkyZHBEVE5scmpWbnlQK0luLzNaa1hpbmMx?=
 =?utf-8?B?UlhKQXI5V0RKMnJTOVlaeWJvSjZMaWFXdWZYVEJzUS80NEJXaEZhS21CRVZK?=
 =?utf-8?B?SzJxUE5DdTQ3ZjBvMzYvNGVzN0M4Zk9TRGZzS2pQUGUvMmU2ODBVMU1rQmg0?=
 =?utf-8?B?aEZianNhclJXTzlKd2NJdnNSVDE5TmxSWjUvMWpILytCQS9ocDNVU2IrM1RP?=
 =?utf-8?B?VkhGd2w4WkxuQlczZHJlRlMvdWJXZGt6ai9FL25GTWt0UCsyY3AzQ1Z6Njhh?=
 =?utf-8?B?Uzl4a0FMVnA1WFcvaTA4cjJISzFrZVliRVBHZTVzVzNKQ3FKZTNJdy9pa0p3?=
 =?utf-8?Q?2Wa2R1SR/F7wjgcQpLdpWOkZd+fWWy3FVCU3JOg?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04e5de23-9771-4f97-e376-08d910c08ea6
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2021 18:55:46.4791
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m0aQn/kDTi2hQbt3kcIJQXqTtd+1aEN9lYD5TbBIrSt9ZHlXVJ+YorelGG6vXotk7HPLRfFEkihMOF1jD3n/dQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4104
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/19/21 7:13 PM, Bart Van Assche wrote:
> A previous patch changed 'int result;' into a union and introduced the
> scsi_status member in that union. Now that the conversion from type
> 'int' into 'union scsi_status' is complete, remove the 'result' member.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: John Garry <john.garry@huawei.com>
> Cc: Lee Duncan <lduncan@suse.com>
> Cc: Can Guo <cang@codeaurora.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  include/linux/bsg-lib.h          | 5 +----
>  include/scsi/scsi_bsg_iscsi.h    | 7 ++-----
>  include/scsi/scsi_cmnd.h         | 5 +----
>  include/scsi/scsi_eh.h           | 5 +----
>  include/scsi/scsi_request.h      | 5 +----
>  include/uapi/scsi/scsi_bsg_fc.h  | 5 +----
>  include/uapi/scsi/scsi_bsg_ufs.h | 7 ++-----
>  7 files changed, 9 insertions(+), 30 deletions(-)
> 
> diff --git a/include/linux/bsg-lib.h b/include/linux/bsg-lib.h
> index f934afc45760..6143a54454db 100644
> --- a/include/linux/bsg-lib.h
> +++ b/include/linux/bsg-lib.h
> @@ -53,10 +53,7 @@ struct bsg_job {
>  	struct bsg_buffer request_payload;
>  	struct bsg_buffer reply_payload;
>  
> -	union {
> -		int		  result; /* do not use in new code */
> -		union scsi_status status;
> -	};
> +	union scsi_status status;
>  	unsigned int reply_payload_rcv_len;
>  
>  	/* BIDI support */
> diff --git a/include/scsi/scsi_bsg_iscsi.h b/include/scsi/scsi_bsg_iscsi.h
> index d18e7e061927..e384df88fab1 100644
> --- a/include/scsi/scsi_bsg_iscsi.h
> +++ b/include/scsi/scsi_bsg_iscsi.h
> @@ -76,17 +76,14 @@ struct iscsi_bsg_request {
>  /* response (request sense data) structure of the sg_io_v4 */
>  struct iscsi_bsg_reply {
>  	/*
> -	 * The completion result. Result exists in two forms:
> +	 * The completion status. Result exists in two forms:
>  	 * if negative, it is an -Exxx system errno value. There will
>  	 * be no further reply information supplied.
>  	 * else, it's the 4-byte scsi error result, with driver, host,
>  	 * msg and status fields. The per-msgcode reply structure
>  	 * will contain valid data.
>  	 */
> -	union {
> -		uint32_t	  result; /* do not use in new code */
> -		union scsi_status status;
> -	};
> +	union scsi_status status;
>  
>  	/* If there was reply_payload, how much was recevied ? */
>  	uint32_t reply_payload_rcv_len;
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index 539be97b0a7d..b616e1d8af9a 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -141,10 +141,7 @@ struct scsi_cmnd {
>  					 * to be at an address < 16Mb). */
>  
>  	/* Status code from lower level driver */
> -	union {
> -		int		  result; /* do not use in new code. */
> -		union scsi_status status;
> -	};
> +	union scsi_status status;
>  	int flags;		/* Command flags */
>  	unsigned long state;	/* Command completion state */
>  
> diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
> index dcd66bb9a1ba..406e22887d96 100644
> --- a/include/scsi/scsi_eh.h
> +++ b/include/scsi/scsi_eh.h
> @@ -33,10 +33,7 @@ extern int scsi_ioctl_reset(struct scsi_device *, int __user *);
>  
>  struct scsi_eh_save {
>  	/* saved state */
> -	union {
> -		int		  result; /* do not use in new code */
> -		union scsi_status status;
> -	};
> +	union scsi_status status;
>  	unsigned int resid_len;
>  	int eh_eflags;
>  	enum dma_data_direction data_direction;
> diff --git a/include/scsi/scsi_request.h b/include/scsi/scsi_request.h
> index 83f5549cc74c..41b8f9f6a349 100644
> --- a/include/scsi/scsi_request.h
> +++ b/include/scsi/scsi_request.h
> @@ -11,10 +11,7 @@ struct scsi_request {
>  	unsigned char	__cmd[BLK_MAX_CDB];
>  	unsigned char	*cmd;
>  	unsigned short	cmd_len;
> -	union {
> -		int		  result; /* do not use in new code */
> -		union scsi_status status;
> -	};
> +	union scsi_status status;
>  	unsigned int	sense_len;
>  	unsigned int	resid_len;	/* residual count */
>  	int		retries;
> diff --git a/include/uapi/scsi/scsi_bsg_fc.h b/include/uapi/scsi/scsi_bsg_fc.h
> index 419db719fe8e..6d095aefc265 100644
> --- a/include/uapi/scsi/scsi_bsg_fc.h
> +++ b/include/uapi/scsi/scsi_bsg_fc.h
> @@ -295,10 +295,7 @@ struct fc_bsg_reply {
>  	 *    will contain valid data.
>  	 */
>  #ifdef __KERNEL__
> -	union {
> -		__u32		  result; /* do not use in new kernel code */
> -		union scsi_status status;
> -	};
> +	union scsi_status status;
>  #else
>  	__u32 result;
>  #endif
> diff --git a/include/uapi/scsi/scsi_bsg_ufs.h b/include/uapi/scsi/scsi_bsg_ufs.h
> index 3dfe5a5a0842..1c282ab144f6 100644
> --- a/include/uapi/scsi/scsi_bsg_ufs.h
> +++ b/include/uapi/scsi/scsi_bsg_ufs.h
> @@ -92,7 +92,7 @@ struct ufs_bsg_request {
>  /* response (request sense data) structure of the sg_io_v4 */
>  struct ufs_bsg_reply {
>  	/*
> -	 * The completion result. Result exists in two forms:
> +	 * The completion status. Exists in two forms:
>  	 * if negative, it is an -Exxx system errno value. There will
>  	 * be no further reply information supplied.
>  	 * else, it's the 4-byte scsi error result, with driver, host,
> @@ -100,10 +100,7 @@ struct ufs_bsg_reply {
>  	 * will contain valid data.
>  	 */
>  #ifdef __KERNEL__
> -	union {
> -		__u32		  result; /* do not use in new kernel code */
> -		union scsi_status status;
> -	};
> +	union scsi_status status;
>  #else
>  	__u32 result;
>  #endif
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

