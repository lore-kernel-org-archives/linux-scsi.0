Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A92F6C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Oct 2021 01:12:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E82360F0F
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Oct 2021 01:12:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233030AbhJKBOC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Oct 2021 21:14:02 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:58919 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232586AbhJKBOC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 10 Oct 2021 21:14:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1633914721;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LNO5meDfxuI2gdyykBg6+I5tU7y2sEzFySU8S/9sjyI=;
        b=PxibNnhkDo4f7yoiGDoG7hwSLkI1bS1cNyLVb7OWUN4h6d9TthgDvJkIFS6ombqZ8Vcup3
        hJmph83xYVyV5+ZXpPMpYKCS8bGPo3IjdDlZEBjI7y7X25mn0rWGHb+Ioeasu13951S7tP
        JxG305TeKtbAAuTRl3KUnKPn0Rc91bY=
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05lp2108.outbound.protection.outlook.com [104.47.18.108])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-14-nM1Gs7nhMzq6jNK4OYsQjw-1; Mon, 11 Oct 2021 03:11:59 +0200
X-MC-Unique: nM1Gs7nhMzq6jNK4OYsQjw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WW8b54tjcxaZ4KBKNp+OCZGssk0BagVX8Z4xQ1OWHit2HsP8WtS/BP4B3cIqYh+o+tSfD24jG+TyI1LpVPaDfqjlkJbnjVWCR3+ppv5YKwgjtJ2TBgjFI2XEdyIeNSsOxGIhL2Jk16tp+HecVvGTBhKZE5+XRvFe0RAfkSWoIkELOd4OFQbPZ+hpEwcsfMzNBi/acd2zZt6qpovKgmQXub+/nTeuzB7Fo5LvFG5bLUWnIS0fp97TM/1J+aPhThaRfKq54CN5u6uJzjF26OoYas+lXbImiC7TRL4romS1iQwofAuDcBx79NKju+kOD2QBVBm7ctfKM+7P/faE2RR1WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LNO5meDfxuI2gdyykBg6+I5tU7y2sEzFySU8S/9sjyI=;
 b=YFCnG/VnmwkTDUD15vD4uMwxWWpqaD2kWPq4AWkrbpGrDugtsLXWMVo/s4Vd8WBE7dNmwAw1IMwJPNKJKcIVUfrIqOxndIidefRtisISV8KyTnR7ME2QxDQecVusVRx/jP/jksHGcj9ygNzp/3Er6ZGi8t/81MVGB+ZQ9hg0iDi6bpnDxgiWvrQ4So7HfvLcMVfUmcwOfcM2x0tzult20zQ6etnBVt88U7Xm68K2fXTapbFIJPVmAJ1oxv9Y3Gdeb4DGQCoDmDFTUyfi7hQfTzM81VNQyQRmhEdzo8j8zAF3/hN6nNDCoOyIsHDmWuVZD2ASwIMTnjI0cHYnLkxSHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM6PR04MB5640.eurprd04.prod.outlook.com (2603:10a6:20b:a3::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.22; Mon, 11 Oct
 2021 01:11:59 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::a555:3b27:dc03:8fcb]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::a555:3b27:dc03:8fcb%6]) with mapi id 15.20.4587.026; Mon, 11 Oct 2021
 01:11:59 +0000
Subject: Re: [PATCH 1/1] scsi: iscsi: Fix set_param handling
To:     Mike Christie <michael.christie@oracle.com>, fengli@smartx.com,
        gulam.mohamed@oracle.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
References: <20211010161904.60471-1-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <3e97c682-924d-ffb3-ab92-deae2718865f@suse.com>
Date:   Sun, 10 Oct 2021 18:11:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <20211010161904.60471-1-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0068.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::13) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
Received: from [192.168.20.3] (73.25.22.216) by FR0P281CA0068.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:49::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.5 via Frontend Transport; Mon, 11 Oct 2021 01:11:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 560b354c-031c-4190-4d3b-08d98c541fde
X-MS-TrafficTypeDiagnostic: AM6PR04MB5640:
X-Microsoft-Antispam-PRVS: <AM6PR04MB5640B9455B4029B07FB7DEE3DAB59@AM6PR04MB5640.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:37;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qkbMqcpIGseoEkYbsFpgc3AhytuLfUoSYD+j5TW5W6qw0dUaa3Ko+5TVRfQeBkB+zWgBN2KnmLOE1EopekDd+d9MFUQu+0mJLjgkU+5FJ/DCFjpdsZZ+4pHG9SYc857VuNM/VphucG972ohayw1v44kLzt3Zn2Y2vkFcEqOlv2LtZiPxp4frX2wOThtBfXLhkCQ9eFewpuph6MYJSa+hINuOmB5r57QR93fsclyXlthMcSqFjxiEmUr6Rca+t8rgaFf+GyaxS5kbneHbs+K523WR882bZGUvVHmtGoYPPVuJWugWib3MnIZBRT4mGOv+gehNzV5CsLyijWMHN49GLbRRHxhx4jXKtUp3wVHbGYAqW9To1R/Eu9dGpyeYEwk4weEyRUFam+Kv582Q9u4Hc59/Im0p4UNWvDp8qvvoqq2jsWqW2c5Tp9NjRzLeNhLSJrgELvj0yR7fS9igBwxLCXbjNUrUn4IAbcjIunxYCpV4Xr8RW4Rumq6rOUSwH/ZBvXriRgaRY3e6iNCbmZzwS3VG5b2vHXeN2LQZRfmpm+iB8VOJbCQsk+rAgJ3hNaaIu3N51y3BgayUodSwg1rT8xFwq4CJ8AN2Er3oPA3LIIMYw8CF/TUL8Sr+3B6z8qdBLk8vj+Mcoq/1fOxzmsqZJSncTDsIl56CGml8DWnDTWSwz/Y0GK/Q3AQ11ggQvp0iPduA86Ylx+FO3jrhQiU5/jO1dBdNLWD7zveufVzSJHc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(31696002)(186003)(8676002)(83380400001)(956004)(2616005)(53546011)(66946007)(508600001)(6666004)(6486002)(8936002)(66556008)(66476007)(26005)(2906002)(86362001)(16576012)(5660300002)(36756003)(38100700002)(31686004)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N3VhQWhnSzdqYVFQRlFaeHNpelRrQWlya3Y2TTd5WnFEaTdmYUtKcFE3ZitE?=
 =?utf-8?B?b1N5SWd3NktlVWVtTmxNbDRoSm43R1NSY0lOUFQwWGV3UndlVzRIeGxIWjdM?=
 =?utf-8?B?bnI3V0tKQjBGQWJCdk52Z1VoZDRnY3dmVWZDUzJRL3J0MWxsTk5LejJaTlBu?=
 =?utf-8?B?RGpKbjdjOXZxQzUxa0JiaGtJeUUxNm56NWtBcUZRR2NubklUQUdDd3o1eC9C?=
 =?utf-8?B?VitXRVZwNnJKMjVPZ0F1R0R4dVVCK2h0blNTQ1hIWEtSVkFLWHpsbEhVS2Z3?=
 =?utf-8?B?eitjckt6QjFxWjAxM1pldWFBYjZOalE4c1doNzdFTXZJdE1MMlhqamJpWW04?=
 =?utf-8?B?QlBFakxXcHA5VFdMMGdsblcyY0x4Q0M4dm9pUTdlWVVsOHQ0V1lXWnR2UWJG?=
 =?utf-8?B?Z2M5NWdOMnZta0pIQ3VmT2dDZlNjRUtuZTJxamZ6ZWswL0h4OTNacHpkWDVz?=
 =?utf-8?B?QTVsSmVsQ2JIZGxTWnNaSWpsazN6UVRZVlhFZ2FKZ0RtWkR1MVQzdktxeHJw?=
 =?utf-8?B?dEJLYmxvYks0bjNvQUYyQXB4czQ4WkVRV3BoeXkzOVRGNzBDVzcvMmpYZW5M?=
 =?utf-8?B?cmttZXN4aEdSb3hxNzN4K1pQSUJJN2I3Ym5kRW40OGpQcVlTU1F3M1hrNzYw?=
 =?utf-8?B?NnBNK3ZxcmZuUFNNWHVQTDFIMUVWWXFoSDRaSHBzZGd2UWI4d0NHaThpcklp?=
 =?utf-8?B?bnZTb3JZVlBjSFNVdHg3N21rVTRkYmRBUW4relhxSFhnWHAvaGxGclBqc0sz?=
 =?utf-8?B?NWc2dkRHNU91blRaR2RQOEk5T3pYb1BEbGpBM1VzVW9kbkNZNHpuak42SXNT?=
 =?utf-8?B?WTFZcTAvbFlzTnVPb2FnRnFvbFREN3d2MHhkdzk3V1ZTWGhGQ08waUZSY2Y3?=
 =?utf-8?B?S3pGVzR6VWIrL0w5U0UrWWxqcXFyNHMrVDVSSEZmUmFyM21EM0RPZ1IxYmsr?=
 =?utf-8?B?OW5BM3hYcUk4MkZTcUQxVlpnMklkeE01ektCUnJRcjNRMWk0VHB2b2dzQ0Jt?=
 =?utf-8?B?cDBLd2pnMkRoNVh1R1NaaGxWNDdGMDJxQWFYaDJPUFlNWHk3ekJocVdLVVlB?=
 =?utf-8?B?ZmR2d2pGNlIweDUrUThNMVdXTGVDUURCbnBpZWFZYlRsNnJrL08wUWxsN042?=
 =?utf-8?B?L0ViUmtXRjY3WU5BMnZueGNTUFptcXRmSzA1Y1prUXBTZEUvNlppOVY3TW93?=
 =?utf-8?B?NFpyT2hNOVRzdHYyRGdVek03c21tNDBxWE11Y0c5MTJnRW9PMUYraUJZYVdz?=
 =?utf-8?B?YnQwTDZwSjZZdyt4SlRvNWZBT3QvZkl1eHYyWUFtK0xIT2ZZZE5ZUXlMWXA0?=
 =?utf-8?B?N0hiZm9TdG83Zm5PTjNRU2xzRngvODdoclYyK09UY2dTVE1nVjhjUXY0K08w?=
 =?utf-8?B?NndHZTZra215UU5SN3lUU2RISVgwekYxc2l1RmtCejU4WjdaeHA4dy9MaUZm?=
 =?utf-8?B?TDBVSTM3endEM3B4K29XZ2I0VmM2TkVzb1E4akc2SkdSRGtmSFhnaEtTQ1E0?=
 =?utf-8?B?MVowQTVmcDZtKy9EbWl1M3RheXBkK3NQVi9aQmw1WjE2c00rM2tXd1c3T3By?=
 =?utf-8?B?T0dHbGZ5OVg1Y1Q0V05paXVaSzRsZ25GRTNYVmtiRVExa0h0UExJdklRMWFS?=
 =?utf-8?B?em16Z1VlUUxsTFIxVFlOb2tLNG1DRm0vMWEreDVKS25ibjlKbHRhaGY2b2lp?=
 =?utf-8?B?ZVJsZnVKK1NGaHpGVFZhNVRJREs4NWJtRHlhaU1aWlVXME8zOU04bDM1RzM1?=
 =?utf-8?Q?6Sb3UF03ABsdciubjROgU99zQFf83U9nPMPNui1?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 560b354c-031c-4190-4d3b-08d98c541fde
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2021 01:11:59.1658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Xo0MDt0MYAvrAvMZM229Q8XAfMxzErHp6x1ad3wwtXVHMJ10MqfGOgGDagtuCFK5UDXZ3JJE8yM05eMVlSWog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5640
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/10/21 9:19 AM, Mike Christie wrote:
> In:
> 
> commit 9e67600ed6b8 ("scsi: iscsi: Fix race condition between login and
> sync thread")
> 
> we meant to add a check where before we call set_param we make sure the
> iscsi_cls_connection is bound. The problem is that between versions 4 and
> 5 of the patch the deletion of the unchecked set_param call was dropped
> so we ended up with 2 calls. As a result we can still hit a crash where
> we access the unbound connection on the first call.
> 
> This patch removes that first call.
> 
> Fixes: 9e67600ed6b8 ("scsi: iscsi: Fix race condition between login and
> sync thread")
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/scsi_transport_iscsi.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 922e4c7bd88e..78343d3f9385 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -2930,8 +2930,6 @@ iscsi_set_param(struct iscsi_transport *transport, struct iscsi_uevent *ev)
>  			session->recovery_tmo = value;
>  		break;
>  	default:
> -		err = transport->set_param(conn, ev->u.set_param.param,
> -					   data, ev->u.set_param.len);
>  		if ((conn->state == ISCSI_CONN_BOUND) ||
>  			(conn->state == ISCSI_CONN_UP)) {
>  			err = transport->set_param(conn, ev->u.set_param.param,
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

