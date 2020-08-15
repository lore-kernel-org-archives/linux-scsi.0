Return-Path: <SRS0=WC2B=BZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11601C433DF
	for <linux-scsi@archiver.kernel.org>; Sat, 15 Aug 2020 22:21:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C912220657
	for <linux-scsi@archiver.kernel.org>; Sat, 15 Aug 2020 22:21:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="kmRj6xcR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbgHOWVS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 15 Aug 2020 18:21:18 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:43944 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726598AbgHOWVQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 15 Aug 2020 18:21:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1597530072;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=0I029esM3r9x9b6Mbs+E/yD8VaGFw2JN4Vh3il7Z118=;
        b=kmRj6xcR4KsTp4EXvLofiHTJiS19e6AsAgRXCr0WDB6Ji5H8cjqb8qn84JZ/1lb4OJ10cr
        /ZWjrNL36KVk5WhnQn/fgI7jyFnsxsgWkXgecEPxIgTRLO9Xwd5cun/VmjX+r42GUCZEju
        bDMdLBePtBL3RBtFJ0boC9MyWRXMs44=
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur02lp2054.outbound.protection.outlook.com [104.47.5.54]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-8-23klYG7RNlutLFN6xoaVjA-1;
 Sat, 15 Aug 2020 19:19:06 +0200
X-MC-Unique: 23klYG7RNlutLFN6xoaVjA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m7+imx47Ytu8eHC6l1LbCfx2kTKhAei2RFiMytmiPVsLKUbOXXHx3LZHxkQKUjP9ii7nODL70tGuRXsSXNwBHQSH046TFiArvl3X4i8ZH0ZsM4JqjuKyZ0qbMr8crY6ZRz7YyjDNkStnF+ruwC8pu10EmiZnvnnqU4eTLxBppwiNM72MsHj6NvqcZ/5Wmpil3SyLmrOYoEkQy6Zc+8+/z7Pce2N91BV5FrMRkV4h2NwqHFrIOz49tLue6sOErkWsG8wjFjS0HIHhlbOusUcenJP67eMvjdQ7KKajKQ5imr3ryPmKumjbi2vCumL9NlXpl9kIqyHwoQcjT9p0m4sPIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0I029esM3r9x9b6Mbs+E/yD8VaGFw2JN4Vh3il7Z118=;
 b=EhUlRfi1WDkdcQrr0DmKgp+5am1N19CdG6cNVAjob/1XmRlrEWvTm+Ud392uwfewZ3KaNKFpJ7SuF1SLnnYuAj2PDDcZkVngn/UOYItt+ont9QXGXA//eW4wkHA8W0tb/97FLg1F2ZP5oJeY8g3GmBu5h6OhCuqWvzSCqDeobBrul69lUDvD9aEL8dTsGyPNFZm61+HiLzjNsoVnAwH4cBF4EUUgAAwtWlYdMCA2u2l/TZv9bm42XGJTA7/M/YoDz3wUk0FZDKdLFzk4yliRgabCts5NMRjdjb1B4ID08HqFciAcLFTX3BmTKC0bMWwMy3v+6kpfe2s8ZTpi4uzifg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=suse.com;
Received: from HE1PR04MB3098.eurprd04.prod.outlook.com (2603:10a6:7:20::28) by
 HE1PR04MB3098.eurprd04.prod.outlook.com (2603:10a6:7:20::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3261.22; Sat, 15 Aug 2020 17:19:05 +0000
Received: from HE1PR04MB3098.eurprd04.prod.outlook.com
 ([fe80::a12b:db18:7bbf:fde2]) by HE1PR04MB3098.eurprd04.prod.outlook.com
 ([fe80::a12b:db18:7bbf:fde2%6]) with mapi id 15.20.3261.025; Sat, 15 Aug 2020
 17:19:05 +0000
Subject: Re: [PATCH] scsi_debug: fix scp is NULL errors
To:     Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        john.garry@huawei.com
References: <20200813155738.109298-1-dgilbert@interlog.com>
From:   Lee Duncan <lduncan@suse.com>
Autocrypt: addr=lduncan@suse.com; keydata=
 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
 Xd8p+B+giaT8a1b5hWuz85V0
Message-ID: <f24c8825-e03e-434f-64c7-68b2b05d77f1@suse.com>
Date:   Sat, 15 Aug 2020 10:18:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200813155738.109298-1-dgilbert@interlog.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0P190CA0006.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::16) To HE1PR04MB3098.eurprd04.prod.outlook.com
 (2603:10a6:7:20::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by AM0P190CA0006.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:190::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.16 via Frontend Transport; Sat, 15 Aug 2020 17:19:03 +0000
X-Originating-IP: [73.25.22.216]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 67cc478a-bd41-4e1b-7276-08d8413f4fba
X-MS-TrafficTypeDiagnostic: HE1PR04MB3098:
X-Microsoft-Antispam-PRVS: <HE1PR04MB30981BB7A4917874FD5F4A8ADA410@HE1PR04MB3098.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fQ1lVd9U9BVV6NaGC1YFbM9QxhMvUFwS7jZxiHQmEjiTMAUJu+5K3KrZvQUIwrNz1W9+jUiDG4hst8EQZReyMSh84HpfOeIoZK1oTU7XSs8SrwKuB+ZUrX0xyr5azGkzh7YHG/dM48qdcGFNhegEqhNBelpu7XNn3QIK33HE1YddYfHPVMQ91hiV+pdUMu3igLKYjh2a1YzxL/yqfvk1NM+Mz9n+PzrDOy2++UI8DiGqld5dIZKlcxCgRTjdo6/XTJAMBnEIuNE2GR+k7jmM8OvhuQmmuPz9PX47LMbVpiPwg7XhhRW1QW5Sj5sgYrs7fY37ukkVYTzVP5aNxnW6+BX2uQ1VGw7LTFYW4vUogDUlCtGy5R6+1p3qfsduAdNn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR04MB3098.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(39850400004)(366004)(136003)(376002)(346002)(186003)(66946007)(316002)(36756003)(16576012)(8676002)(66476007)(26005)(5660300002)(2906002)(66556008)(86362001)(83380400001)(4326008)(16526019)(53546011)(2616005)(31686004)(6486002)(8936002)(6666004)(478600001)(31696002)(52116002)(956004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: xhy+E8sF42Iyl59AZ55HySSAFjAKmgdVNm9lpcOAJTpVY4QwaFBHnUHMZHwrh5pRf+oH3BKgCVPT/p3DQ199/R3fH0yplFZDlAgybWQ3M9+osb+ZMiPoAArbUX6HgGqT3BKTG8ewHDQQ9p4UgsyiBMdGT2/ps1BzZn8piQaPHaDsXgrBCy/a3CgaF4IJFIZoDedP5bM1fJUbctebQXCT7Xe/1skZBbFv1X2m4e6VOBBbFcEiZ10TYxroFEqXAKw1FVAKNLN8GGzYlVKRYL7NdlnhWgmpVgS69nyrZlyi8KKXGqLjs3a7gmA+am01A6aikFUhmKLZI9aEae66/Gofz+2ifyaPEtiI0lfVDK5Izdi5pxNEgHA4MJdipKinTUxoRIOIW3ODLcVo7IuOkglQQDacPd/4pOAUCpNCC1Zuc+rbkVcvtIfT+7pUIzzF+V0EsGMhRN0dbI1O8TzLysRh5e5df9890+8v+QDm4lHylnviBB13xFyaGDZHthvNm8D9ZCZzrkJwD6Fk5hYaYeulqYytqDptQP/90vCKsRxeXTKIBUT1gq1eh9bN/HuFZkWy4vR/3Ewt343xsonOBRMn01QgoTip3BRPjbVZclpTiMJM0rCeKchwq7iVPsaQIXTfXKqssoQTIfYuXpZIFVQLeg==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67cc478a-bd41-4e1b-7276-08d8413f4fba
X-MS-Exchange-CrossTenant-AuthSource: HE1PR04MB3098.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2020 17:19:05.3316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1+Dm4S/PeFrYaLzz404elEpHhRPgT/Fw7lRIK1ygi8cw4dOol0tr9N/amsNsoh/QqdRY9ZWcRotDL9KxoKg7Uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR04MB3098
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/13/20 8:57 AM, Douglas Gilbert wrote:
> John Garry reported 'sdebug_q_cmd_complete: scp is NULL' failures
> that were mainly seen on aarch64 machines (e.g. RPi 4 with four
> A72 CPUs). The problem was tracked down to a missing critical
> section on a "short circuit" path. Namely, the time to process
> the current command so far has already exceeded the requested
> command duration (i.e. the number of nanoseconds in the ndelay
> parameter).
> 
> The random=1 parameter setting was pivotal in finding this error.
> The failure scenario involved first taking that "short circuit"
> path (due to a very short command duration) and then taking the
> more likely hrtimer_start() path (due to a longer command
> duration). With random=1 each command's duration is taken from
> the uniformly distributed [0..ndelay) interval.
> The fio utility also helped by reliably generating the error
> scenario at about once per minute on a RPi 4 (64 bit OS).
> 
> Reported-by: John Garry <john.garry@huawei.com>
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> ---
>  drivers/scsi/scsi_debug.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index d95822dceeb6..4b4e31af22bd 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -5471,9 +5471,11 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
>  				u64 d = ktime_get_boottime_ns() - ns_from_boot;
>  
>  				if (kt <= d) {	/* elapsed duration >= kt */
> +					spin_lock_irqsave(&sqp->qc_lock, iflags);
>  					sqcp->a_cmnd = NULL;
>  					atomic_dec(&devip->num_in_q);
>  					clear_bit(k, sqp->in_use_bm);
> +					spin_unlock_irqrestore(&sqp->qc_lock, iflags);
>  					if (new_sd_dp)
>  						kfree(sd_dp);
>  					/* call scsi_done() from this thread */
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

