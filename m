Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3355AC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Mar 2022 17:46:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240925AbiCNRrk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Mar 2022 13:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239687AbiCNRrj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Mar 2022 13:47:39 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10FFADEEC
        for <linux-scsi@vger.kernel.org>; Mon, 14 Mar 2022 10:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1647279987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S37DRiLVK56TJ3STZzcyNsDzWGcW5zcAbA4KbM8Zh2c=;
        b=Vdw2gHPcswZy+qY2PutdyUPRFzAi6sXHdH7fraDCtOT6eDBcXXsCqt0ZoGKqpoZFZrzAAy
        Pd/HU4JJiRKnMP0fdgnZShwWUj5MbDiW58HzaNf9nZN7iQ7kGUhhGsbRcBzJNvijDr2/41
        soBeuD6jK93w04vRMQES/v5Ef1PY2AA=
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05lp2107.outbound.protection.outlook.com [104.47.18.107]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-41-cDZp4L8fM1yMk6O9_sOccg-1; Mon, 14 Mar 2022 18:46:26 +0100
X-MC-Unique: cDZp4L8fM1yMk6O9_sOccg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MMegBUx7SrKCWdk/TcvjkxnXFmIFZuXfl5T75Iisz6bX6x1ziDFAHNQyoKz/2RKWQC0t4zMDOqPZF2nAqv8o/+sfqYT3ChtRnHqyQPC6lLcaXpJNLHqReYw+rMdEr9Y22T04yMuTGDIY2xR5l+H7g7IG1wYuERWOrlYGYHLDcHRWEBMKrrH5BDSiksoDNO7X8iFwe9+4B9L5Qm8VS7m+Jeoj4by1h9TffudPJRHFiIBdWFbhT+bZwqIcfxWkpXsnEGDNWQvQB7FT8FcDtG7dc0thLD2jwTo/TnO3q4kMxmUbD0Kfq0hEOwhpmYNNtRzOifX8lshPWATAsmaXJ40hIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S37DRiLVK56TJ3STZzcyNsDzWGcW5zcAbA4KbM8Zh2c=;
 b=SekhD/9/rQ6PlSWfCe2FKelXS6wkR/lYv6asBtGRXAfvGQk2nG1WCk35mTuHLxiyFGLrtKLf0pkxbxjCaJZb9tcvM1WslSz009IAHud8/Xr61qLlC2aa+fm5nmY+l8b5do+WzFrS1TRqUd6BrBHijr4NztFcberAt1D5XvZ0KP28+Q1Pl8q4vtWNkij8D7XsP6KGvB56+SXEMY++Vc8UkQATCQUvdpp0YWMD5CZtmavKb6J0gdqweh+yVjnDU3tSqMrep9drX2uajDE0LekUWt4++8Lk/2smjtaV85FO7YabdxWxRtO+Wm7qfiMmUZpjIPYdKdYe+0bYsFB8ObeORw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from HE1PR04MB3098.eurprd04.prod.outlook.com (2603:10a6:7:20::28) by
 AM6PR04MB4773.eurprd04.prod.outlook.com (2603:10a6:20b:10::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5061.28; Mon, 14 Mar 2022 17:46:25 +0000
Received: from HE1PR04MB3098.eurprd04.prod.outlook.com
 ([fe80::213a:cd92:6fd4:7fe0]) by HE1PR04MB3098.eurprd04.prod.outlook.com
 ([fe80::213a:cd92:6fd4:7fe0%3]) with mapi id 15.20.5061.028; Mon, 14 Mar 2022
 17:46:25 +0000
Message-ID: <58281379-0f5f-c47d-3045-c297976c0e28@suse.com>
Date:   Mon, 14 Mar 2022 10:46:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 12/12] scsi: iscsi: Fix race between recovery and task
 xmit.
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, cleech@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
References: <20220308002747.122682-1-michael.christie@oracle.com>
 <20220308002747.122682-13-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
In-Reply-To: <20220308002747.122682-13-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS8PR04CA0126.eurprd04.prod.outlook.com
 (2603:10a6:20b:127::11) To HE1PR04MB3098.eurprd04.prod.outlook.com
 (2603:10a6:7:20::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 784129e0-3a44-469a-80d0-08da05e28f60
X-MS-TrafficTypeDiagnostic: AM6PR04MB4773:EE_
X-Microsoft-Antispam-PRVS: <AM6PR04MB47734002DCBA650902373053DA0F9@AM6PR04MB4773.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jJBkxcbUon4q8yjT15yvzYE3uuDVnppzOPli/CHpMHqkp3hnxkQkwzuo023mAqm8ugH4dV1EmSbSTQjSCyylGHbqXWx3NSHkk96wKpR+C3X3Zba4iqIyWsBg5oTwqHTGYqgSV+kevnqa+0OUf4Rkp8Vlw2LuDVGqsGRQBIYI2wqtir0qLdVMIadHB6LSoUPuh3cJoLANm195VbXAMxCHA5FgfMPFEu+fwTOso0Q3uZiO2vQ04rnTgLpTQBv4FywUuDS4UCPv/7oPNQhahp6dhzRxWhD8xme8jikoOoulMvGtIVjlbQ8lpWDXoTVB959xOz3a7vTRvwf9dUuBhkgh2IjlcUqqvcxzMsk3L5Muwox/mPlLHqw8iE+7lObaEh29ZIleLu7CiFxEwf5Bk9QTPc/o4TBYd+JlXL2Yn1ZeOIUE2Cc+NoItLXh6hxE0EGuPPwQN3Tm6f50VAqpl5o+c3mWrsIeXuRZYyFbBFSF8fB32r353rpQyRPbtuhvUHgs4XZHBeMTUR4i0ii+iDb0HrvYMgUYQAhSotTLYHKYbbrImo7x7P/gov6X9li2oklGqgdPGQA5oqypEHyN3s7aUDrdf1W8vAzjsd6XepS/0zxdC+f+rxhXFi4M9leKniywUrM1oW0GOPxGYtW7RNmuHaLjj6tmphi8otjQwH1LDf7EuM7viWwZuTWN2xTJZZ254n+fgGLIvrpFXtVx4/5ZvM/FifQ1bRWzshK7NG29hCPk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR04MB3098.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(8936002)(2616005)(83380400001)(5660300002)(38100700002)(6666004)(26005)(508600001)(6486002)(186003)(86362001)(36756003)(31696002)(31686004)(2906002)(316002)(6506007)(66556008)(8676002)(66476007)(53546011)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cnhibkpvM0sxT1o1bmQrYi9nNS9Sbk5tQjB4QUtzV1hEYTJGNmUxUjJHVElL?=
 =?utf-8?B?YjllVThJTGh4UEhONmJUaldscnlqRTg3ZmppVzFZZHhKQ0tybjFNSzRWekV5?=
 =?utf-8?B?SCtmTzJxN2I2TTlVOWRGOUo5QWpLNGtqbWlYRS9Va0taOWl0anZQWnl3SUxh?=
 =?utf-8?B?Q1duQTlrR1lCdVJQY0JRaTdXb09zUUl3THg4dXdmbDFoTUpFRTRydVpyeFRk?=
 =?utf-8?B?dmFxTEtYTFFrQ1JrK0RaM3pGc3pDcHJTSy83dTBiTnVud1h2aGRVNEh5ZlNl?=
 =?utf-8?B?N1pyakxpNzZ6QzJtTGJsdjJ0SlBycUdOVTVmUE9obHpNVnBqUWY5bmNvQTRs?=
 =?utf-8?B?b2FrVzBMclA0SFhkVHJaV0RMMnpYNEVTSlNoMjB5K2hpMWF1d0MyNUNnK0l5?=
 =?utf-8?B?dGNOb0pZdjZ5MGk2OHNQOVBZRXFRakVxMzhoMjNRdzM1UlFsejZXWWxQdWVZ?=
 =?utf-8?B?dTZ4ZkZTeDhWQWYvT1hvWnpMOWgrTmJIV1pZL3Q0a1l5Qi9vUFg1YU1LOURD?=
 =?utf-8?B?VmFtRkRId3hDOUdyMkxrSE1OUGswbmQxYUNtalpSa2hYSGNVVmJwbTdlR0Fu?=
 =?utf-8?B?UUlOTzJlQWVBOUhzTVdVT0YwbFJCQjcvMVUzOWQyYlhZRC9tYVc1dkY5WWJI?=
 =?utf-8?B?RXhnd1YwdTdDNURIZERSa1FWb0p6KzJ0QnBlNE55RllVd0tUR0d6V2s0bkM3?=
 =?utf-8?B?MEZuSUR2bmdXWE9tSE15eEw2U2JHOTJoSmIvYXo3QzBtMWlrWVBzVGY1U1I1?=
 =?utf-8?B?WjRIdUcwWmxvZ3R1UkNzZmZxUktyUENXdDNQMDdCL3FRT0hPZEtldkplNkda?=
 =?utf-8?B?V3RZYUpSanMwNkV3WGtWK1hZaGpoV1o5VkhacFY4R3FhQ3REZ1JYNVZIMmho?=
 =?utf-8?B?NVJaOEtBclRyWWl4S3I1YjlQNGNpa1hHWUJYRlk0NXd2aHRZUTZ4WHFIL2wy?=
 =?utf-8?B?SkYzRkJUS0V0T0h5UmRUanNwOEdXdHp5d2ZELzk1eFk4SlcwL2NnSEpkTnlW?=
 =?utf-8?B?ZHRkdGZseUFja3ZiVTZQVnYvQ2o4RW9qU3l0RTJKbDUzSmZEeUtzMXErbTVE?=
 =?utf-8?B?R0NZQmJ0OWxEUEdpay91YTl3enZUY1JFdmNxNWxwblVuTlV0QWtydnJyTEkz?=
 =?utf-8?B?NjVLN1dYWTRzc3ptOEJHVEFFc2FWM3UwNFgrTTFLdTBnY0F0cmVBbkNrQmRG?=
 =?utf-8?B?T2NUZU1RdnFCQTIvWUxOVHdwMHBNb0FpVVRPdFNpZkxLdGFyenNtTEk1VGtp?=
 =?utf-8?B?OWVhSlhuNDZuNjJidUJSSnBSbWsyMWxJZWpxVTA3VzhGNm1JZGkrZGFab3RD?=
 =?utf-8?B?V1ZhaDBWUVo0dW56UHNibnZ3b1l0SnppNVdUOVFybTVYNW5Id0hmWHJEa1pZ?=
 =?utf-8?B?b05VdGtxeGZnUkJlTTBXbmdaVUZCZjQxakhFL2lGRXk0Zi9qZ3J6OTZPd2dT?=
 =?utf-8?B?cUdGODZUQzNiRXpMV0YxT2hDT0NzK01ZQ3lkVGVyaDRxekJKMGdsOWRHc25Z?=
 =?utf-8?B?SzNZdFBYYk93V1Q3MHhFWTRsbkVXQ2t1YkRYbEVpR0lXcW4zQXBYS3B2V3Bu?=
 =?utf-8?B?R1NJZjdjMENpMmNGWkRob2hOVlNQajBMSVJOZWQxMmNITEduNHcyVHVIRzRS?=
 =?utf-8?B?QzdpaDdtK1VoeVFrTmdXKzd4VnYzS1V1OWRFUUh5WG96bnJCODhkcE9Qbktm?=
 =?utf-8?B?aUJ1L3pYODNtT0tUKzlIbVNyaWNrRElMR2RXRFlSWWY0L3NicHJYZjhlTlI0?=
 =?utf-8?B?aVFIcDVwNUtPR1piaURHc1UyT0NpbUhDSlVuSmdrcUJqdVNuV3dWNGxwR2N6?=
 =?utf-8?B?eEo4L3p3czVqMkZ5TngzUlBPU0NCSUtJbjZRc2t1a3pqY2FmeGVMMlVMTFdu?=
 =?utf-8?B?S1MxRWhvYWhIak5nc1FDQ0NLM0FJM2xuNDhkaFF6cG9Wc2tZcThpRWxtSkpw?=
 =?utf-8?Q?hlYYLgHgCWdCgorypljDFoqz+tt6BZhp?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 784129e0-3a44-469a-80d0-08da05e28f60
X-MS-Exchange-CrossTenant-AuthSource: HE1PR04MB3098.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2022 17:46:25.5372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yyXbvVFaHITuHUbS04fvJnqE/9DmSPxh3zRg29Br/9ZiojQ0XBRUke4zga/f3Z13b1TUbZLaUYz+d8FuTxtqew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4773
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/7/22 16:27, Mike Christie wrote:
> set_bit doesn't provide a barrier, so we can hit race where we've called
> iscsi_suspend_tx and didn't see a work queued, and then a work is queued
> and run and doesn't see the suspend bit is set. We will then call into the
> driver when they might have already cleaned up their xmit related code.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/scsi/libiscsi.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index a165d4d10cea..b79739b41b10 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -2020,10 +2020,14 @@ EXPORT_SYMBOL_GPL(iscsi_suspend_queue);
>    */
>   void iscsi_suspend_tx(struct iscsi_conn *conn)
>   {
> -	struct Scsi_Host *shost = conn->session->host;
> +	struct iscsi_session *session = conn->session;
> +	struct Scsi_Host *shost = session->host;
>   	struct iscsi_host *ihost = shost_priv(shost);
>   
> +	spin_lock_bh(&session->frwd_lock);
>   	set_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
> +	spin_unlock_bh(&session->frwd_lock);
> +
>   	if (ihost->workq)
>   		flush_work(&conn->xmitwork);
>   }

Reviewed-by: Lee Duncan <lduncan@suse.com>

