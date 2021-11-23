Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F41C8C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Nov 2021 18:04:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239626AbhKWSH4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Nov 2021 13:07:56 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:30961 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229674AbhKWSH4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 Nov 2021 13:07:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1637690686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3l0IOsCNAyyyZHZmEFtuA+JxSk/HlzuaDcNxP0bDN30=;
        b=WRfiqd8YhWU0SFiZORGsrDf4VM3N8hrXu/Gbq0nWkIBpNw4CX4SFAGVd7G8ta2NJHp2Ldo
        nFoB9yO7P4vbbcGenhLw9vSLLxyXfCkhtXY08egFYGv3JR5gyn5R7w1D+bUchFILlnCQOZ
        LoyrrDJPhdVNnWdoAagjLq1UHODXot8=
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05lp2108.outbound.protection.outlook.com [104.47.18.108]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-20-YTt2nIfbPb-OgaEwHCrXvw-1; Tue, 23 Nov 2021 19:04:46 +0100
X-MC-Unique: YTt2nIfbPb-OgaEwHCrXvw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n36TLNSwMV2nlGUShHhhxpZz56qPzOQYf5FmUZl8j76GlcY1WHVgINMcLqUUV3Lk+vTtq4DDL4FN1qCpvw43Uk2kXxktKw/DVX4JC8Hki8jRV04ZEtJeKXSiJ4S6WG6ONyEkpf+wRK6FjV4g/jG1IX2XvPw9Sz70L5Ymix5CFS3qBCmOo2Sl+WLabp6+w84ctSzZkigUAT8iRpnnFjMIB0rMHtIh03DABTamljPV2XhXQO14xNiEssvxCqQ4VIrtj0I+52rcfzWtVTmVfpiztrnUgQz27YGEJRNeyZmno124094V3Gh3OMUhfizaEeee/uYNVD2fOyHKRvjVWiYe6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3l0IOsCNAyyyZHZmEFtuA+JxSk/HlzuaDcNxP0bDN30=;
 b=loxbTAHVQbWlmDjxuLD0KRMnuE4P5Ojh8FwV2vpBmA8R6RIQmLeDxfxAHshNB0A+WlL0WXskoJh/UFDgJr+OZ+O6ZpynRd7xXl/S5wQyCz+5/1U8IfiNLhGI1txHWpnnT9TbpHcjbcTxf7u6uLOmcKwaxqg0wutuDMdl/ye/424oOIBwxHrAczmsk/jNVOiUHex+r4Ujz2A6yjv1Bj6D+Eb5RbMZUUMhejoM2CYcgdbEuCX1OrrYWmCF52DrXsdeMnqXaNqEFX5OShsOI4rid3x/1EQCe4xkKngWo/4cyBcAuX//XP3ipXm4QS2IZcJTvAKNWTk/tDkuDufm4RvmgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM6PR0402MB3702.eurprd04.prod.outlook.com (2603:10a6:209:1c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.24; Tue, 23 Nov
 2021 18:04:44 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::a555:3b27:dc03:8fcb]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::a555:3b27:dc03:8fcb%6]) with mapi id 15.20.4713.026; Tue, 23 Nov 2021
 18:04:44 +0000
Subject: Re: [PATCH] qedi: Fix cmd_cleanup_cmpl counter mismatch issue.
To:     Manish Rangankar <mrangankar@marvell.com>,
        martin.petersen@oracle.com, cleech@redhat.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20211123122115.8599-1-mrangankar@marvell.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <39215f3e-b7f4-cc20-fd6b-8999367e0e36@suse.com>
Date:   Tue, 23 Nov 2021 10:04:39 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <20211123122115.8599-1-mrangankar@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6PR10CA0056.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:209:80::33) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
Received: from [192.168.20.3] (73.25.22.216) by AM6PR10CA0056.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:80::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Tue, 23 Nov 2021 18:04:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4fd96e7f-3c4c-4754-fe08-08d9aeabbaa6
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3702:
X-Microsoft-Antispam-PRVS: <AM6PR0402MB37022AFC6082F22FC4C9D0F5DA609@AM6PR0402MB3702.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sIv7Ehs9yO5vW3uGcwc/BIhBAM13DPt9Y6Keol9use4sqzY6wgoLwx36Sdv8VKivJz4aTPQ2J1v53L8irQVGRoW+p+qiKJOUM9rQCvX2gOHcXW15Tsf+kBtKD3EqNjFVsqo7zuKqyK5nAtQb8J15YJXKlY3bgTznPALVZg7bY53p958u7jgU86JArQ1Fj4PgtBC487m1nbfntjvmn+VGX45/+23jF7kTQm6klu0VJjOG3phs3KhNaHSolMhyj1zl71hqqzJheyYc+ux0M9AY2ZLxtD0CSzWCkhVeoA6ZgS+6nYxNNRizNaNCvNRi79VYKNnhOMiAlaQgIM5+JRLPbUNanb4IeT5XgDUvuRh1E3AL0XfOOpzZCrN+ChsJSBgYwV48ZtlcT4VzV5O5X1+GkD+EvGo/rUcBUcoxS0fMSM11nL0wOhmHDsS9CWla+nx7YNx9VMow4Wi86LuVrxhmeNzwldiRj3giVje+e4WDn4IGt8RZxn0Wt4PgAhTjWVRKvTNHYwlxYARYHueYrZ2vC1ll+JYna/0fuuoJ4XKKhmJZeeWGVx1Kh0syjQu93fkrzO7gpWXi0HmZFJF79RpJ9fVNRA1akFGNpJjzNsQ1Uk7vGMmbXnHxLpW/+HtO26/D5nvJusaEgLGIyChjbCLYaI3EAzCAPpwlJfN4Z4N2Nl27KJ9z2u4Rtm7DxK+jHOT/ETXCrh4QYQUowKMtFR/gkNdWa3HwicMeWKYDFMKwJXY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(186003)(26005)(8936002)(4326008)(31686004)(8676002)(36756003)(2616005)(6486002)(16576012)(956004)(86362001)(38100700002)(508600001)(53546011)(66946007)(66556008)(66476007)(31696002)(5660300002)(6666004)(2906002)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y3hsN0ZqTW43NzRlZWxRWUFFazVyWHk1NFBRVmZjTXQ5YXJYVFB3d3Q0Qmwz?=
 =?utf-8?B?Y1U1SFVmbzh4SzNrbzFoMlE3VklYT0o4d0ZFditkby91ZStxM3ZYaVF0R0R2?=
 =?utf-8?B?NDNpUEdwa29BWERucnFjcWNISElMUHFZV1NaTzJuZ0l2ZTZjL2FDT3Zhb0ZX?=
 =?utf-8?B?YitrQTNjbXJPTU10T3VVbWhXbHFINmNCam1hSjVsNUZTVmJvalVHejdOY2tm?=
 =?utf-8?B?bjBmQzNITFczSjRqMmRiWG1nTU9veDFlQUhkeG5jNVE3VzBsU0dTTS9BV2E4?=
 =?utf-8?B?eFFDWHJqTnBYZW4yTVhzUHUzaDFFeWRJOEthOXd1am1UdXpTQWlNOHBPWWNO?=
 =?utf-8?B?V2RuUzNpQWZkN01xSUR3eGxNR0JMa0dCc1kvYnVqVVFDeUZqejF0TnRGWk1k?=
 =?utf-8?B?a3Z0Tk9KTDQwNndtZ202ZGhqeEhUVGptS0IvM2J4S3pXcnFDR0FtTjdGYWIv?=
 =?utf-8?B?eU04VDVFbXdXbzFTOGhKZVo3aEU5VGZnMCsweTdzek9aRmx4SVZFd1FzRkUz?=
 =?utf-8?B?TGFLeTV3OGxoUzNxeHRyNmNMUUxTdnNOSFdTaFdIQ3E3eFpjdHVzbGhEVUo1?=
 =?utf-8?B?VDNMS2VIdS8rMHE5dWRlMmRqYk5DZkZLckpjZXpudWVkTUxiRXZ0Qm5oWmcz?=
 =?utf-8?B?V3B2RlBkL2tuWEs4TFBpMXN5OU9ZRzVWbEYyRzVwbXFqS29pTDF0Vm1BdXYv?=
 =?utf-8?B?RUFjQUI2VktlWm9ZRm5SRlhjSWVIa0J2akl5bng1SkdOb1BrZC8rZUR2N1p5?=
 =?utf-8?B?UmN4Z1NVcVNwVkxQZUQzMkV0bUxCRy9RQm1ReXJHQmlCZUJxc3FnYjYvSTY1?=
 =?utf-8?B?amYwRXlmSTFHb05pRXIySy9YQysrYVdHOFQyOEpmMHA1eS9zV3lQakp1aVJq?=
 =?utf-8?B?a0Ezdi9YMDNaRGJqTk9oUnJkczFVQ3lsMXlFeEt0Z2dvWHpyRlNlWW1sWWFM?=
 =?utf-8?B?eDVuWWVWblE5c29BbHlsUnd2MmFVOGZJazFPZWdQczludzgxYytpYWQ3Ynh1?=
 =?utf-8?B?V2hRU2hMOWpQRUp3RGdqQ3RDV1dvaGFFbm96eitkUnpuRW02SjAwbmRsM2R1?=
 =?utf-8?B?RDdzYXpNN2tycXkyZUhaSWpqOGpOc0hKVWJHbERvQVljT3d5bmlPZEJVM1lw?=
 =?utf-8?B?K2JZMjJIRHJvUFhWRGRRaDZvTFZvMmZmSHBjTk1OWm1lcEJZRkF2NVF3bVN4?=
 =?utf-8?B?OW9UZUladTRmQzZnZFhBVjgxVTJRY1RmRVVEeTQ4RE1WRUFhWjBZZDc4K1JJ?=
 =?utf-8?B?Z2xlRWVqY0RZVUFSRlhzbHFwd1FWaU05ME4xbWs5UnRDeE8xYVdWOE5USm91?=
 =?utf-8?B?NEJsZVU0eTBBZkE3SXl1ZkpONVlFamtWVitYSUJwc2prOERVeEttUmMvWUpj?=
 =?utf-8?B?N2pRSlVrZTNidEh2RkpKK09DQ2R1Q1BKNitsTkdpbk15ZitHQ0dtM3ZzTmI3?=
 =?utf-8?B?cjBDa1ZSTEVxL0hMWHE5Tzd3V21US09naGZpS2xLU014MHZONEZ1MDA5U3hI?=
 =?utf-8?B?NGJKVHlKcHVkdm9wLzArSVZUbHF0dlpWWUdiTHF2LzZGMFRoYW1wWFdtdU1T?=
 =?utf-8?B?VVNaRzNnUG12eVZNRnJzWDJIZjZPOUtyV2JVWHQwMDVCTE9HSlFiYTUraHAz?=
 =?utf-8?B?NWt1YWR1dEUyOGh2UjIxa0dzYWhtNXRQVkh5UUdsaDlWbDI3L0RkSit4VFk1?=
 =?utf-8?B?eVpsaVkydjVMSFp0RXpzNVQzK0FvNzQyUzViVHVubjVma0FZRERyYjNZTDZw?=
 =?utf-8?B?dXRoamFiS0pxajRTcjhPbTI2cDFBMkxpY2RXSGZJNGFZdFFKTU9Ja3IxOWhS?=
 =?utf-8?B?dFZCbi9yWHZCRm9KSDN2TU1nNGR2alFoNnlLbGZMZ3R3c21GUEdjb2I4c3Nq?=
 =?utf-8?B?Um1YUEVmTStmUUlBODJ1dENJR2MxRDdQVkMxcnNHUklReFRGQWZkYUpqRHFw?=
 =?utf-8?B?c1N2YVdMK3UyZ0toMjNINEM2SWJMcklzOXY1UVhDNzdYU1V1Q3htTEhmKzU3?=
 =?utf-8?B?ZkhHaTYzYzJBTW0wYVprVkdyQXBCTE05VWl2cjJVSEdsM01xYjhWY1p6bGRW?=
 =?utf-8?B?VTJUUHJadUE1dmFJczR2MmE0QWtxeGhoQ3A1NlZqdW1UMDQrRVJPMkg2Ky9o?=
 =?utf-8?B?bnZINElrTVNNTmc5a0pWT3ljUnh2S3B1SUtQek5uQThDVTNCK3c3OUcrQlNR?=
 =?utf-8?Q?vIf3KYRR1AzMS/HmXhXSn9A=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fd96e7f-3c4c-4754-fe08-08d9aeabbaa6
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2021 18:04:44.5341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rv2bLsj59epNz6kvJvtIl0modylnhmFQWiz2LoTYK1QyyIVG55v96x4K/APq2V7MoIa522GvTWBgYzcLQKnzPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3702
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/23/21 4:21 AM, Manish Rangankar wrote:
> When issued LUN reset under heavy i/o, we hit the qedi WARN_ON
> because of a mismatch in firmware i/o cmd cleanup request count
> and i/o cmd cleanup response count received. The mismatch is
> because of the race caused by the postfix increment of
> cmd_cleanup_cmpl.
> 
> [qedi_clearsq:1295]:18: fatal error, need hard reset, cid=0x0
> WARNING: CPU: 48 PID: 110963 at drivers/scsi/qedi/qedi_fw.c:1296 qedi_clearsq+0xa5/0xd0 [qedi]
> CPU: 48 PID: 110963 Comm: kworker/u130:0 Kdump: loaded Tainted: G        W
> Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385 Gen10, BIOS A40 04/15/2020
> Workqueue: iscsi_conn_cleanup iscsi_cleanup_conn_work_fn [scsi_transport_iscsi]
> RIP: 0010:qedi_clearsq+0xa5/0xd0 [qedi]
>  RSP: 0018:ffffac2162c7fd98 EFLAGS: 00010246
>  RAX: 0000000000000000 RBX: ffff975213c40ab8 RCX: 0000000000000000
>  RDX: 0000000000000000 RSI: ffff9761bf816858 RDI: ffff9761bf816858
>  RBP: ffff975247018628 R08: 000000000000522c R09: 000000000000005b
>  R10: 0000000000000000 R11: ffffac2162c7fbd8 R12: ffff97522e1b2be8
>  R13: 0000000000000000 R14: ffff97522e1b2800 R15: 0000000000000001
>  FS:  0000000000000000(0000) GS:ffff9761bf800000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 00007f1a34e3e1a0 CR3: 0000000108bb2000 CR4: 0000000000350ee0
>  Call Trace:
>   qedi_ep_disconnect+0x533/0x550 [qedi]
>   ? iscsi_dbg_trace+0x63/0x80 [scsi_transport_iscsi]
>   ? _cond_resched+0x15/0x30
>   ? iscsi_suspend_queue+0x19/0x40 [libiscsi]
>   iscsi_ep_disconnect+0xb0/0x130 [scsi_transport_iscsi]
>   iscsi_cleanup_conn_work_fn+0x82/0x130 [scsi_transport_iscsi]
>   process_one_work+0x1a7/0x360
>   ? create_worker+0x1a0/0x1a0
>   worker_thread+0x30/0x390
>   ? create_worker+0x1a0/0x1a0
>   kthread+0x116/0x130
>   ? kthread_flush_work_fn+0x10/0x10
>   ret_from_fork+0x22/0x40
>  ---[ end trace 5f1441f59082235c ]---
> 
> Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
> ---
>  drivers/scsi/qedi/qedi_fw.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
> index 84a4204a2cb4..2eed2c6cf424 100644
> --- a/drivers/scsi/qedi/qedi_fw.c
> +++ b/drivers/scsi/qedi/qedi_fw.c
> @@ -813,10 +813,11 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
>  
>  check_cleanup_reqs:
>  	if (qedi_conn->cmd_cleanup_req > 0) {
> -		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_TID,
> -			  "Freeing tid=0x%x for cid=0x%x\n",
> -			  cqe->itid, qedi_conn->iscsi_conn_id);
> -		qedi_conn->cmd_cleanup_cmpl++;
> +		++qedi_conn->cmd_cleanup_cmpl;
> +		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM,
> +			  "Freeing tid=0x%x for cid=0x%x cleanup count=%d\n",
> +			  cqe->itid, qedi_conn->iscsi_conn_id,
> +			  qedi_conn->cmd_cleanup_cmpl);
>  		wake_up(&qedi_conn->wait_queue);
>  	} else {
>  		QEDI_ERR(&qedi->dbg_ctx,
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

