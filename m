Return-Path: <SRS0=HqgQ=WQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73948C3A589
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Aug 2019 14:05:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FB5E22CF7
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Aug 2019 14:05:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729965AbfHTOE7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Aug 2019 10:04:59 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33737 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728248AbfHTOE7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Aug 2019 10:04:59 -0400
Received: by mail-pl1-f194.google.com with SMTP id go14so2815312plb.0;
        Tue, 20 Aug 2019 07:04:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uU0E9BnbCaRlRcxE+6+0us4/0Y9cyL7jBTJ2b+KsM+s=;
        b=WWl3MBiwGsVQuQSGt+5CRyVUpY/VEmVaOpVBtrVCK8mZKJG0z90ZEdRcia0mGzEMqx
         5rmFTJC2yG5g6ENrn33mSU2PENV9uenMfCFJP3UxpaYgRdIILfAQHQ6UKav/+FMO8nT+
         RyzGYS3oFlcT9h5+60IJPKtCWovD/zMjfJbWpwmMqQ7v46yQ9kLOL7BUSWfhYHWUgZE3
         3hjz68QqKU1JZCQ6wIXrJa68qVXOLwIo0WIl4xQ9XsVpDvm7c88wzcYGRW5uXVKDUncg
         60+GNcL8+pf3wBhEMhrJyAfmKaFIVfGNsM3Yw46J778wxYy5fjgPPGvGQTjfOlM7wS1m
         6bYQ==
X-Gm-Message-State: APjAAAU9ZQD/t4AW9T/ycwDRbbiatVZ5fvSb5WLgWNl+sJ2+RCzf9DHd
        5vdDYkseESMXef6q1ixPdvs=
X-Google-Smtp-Source: APXvYqzHIs2+J9/hpuOOW84DIwir/Y9TRxXZmTXss7dEB5WRygZ5nP6SEWygWovMRcUnzgv90JALIQ==
X-Received: by 2002:a17:902:9348:: with SMTP id g8mr28953098plp.18.1566309898854;
        Tue, 20 Aug 2019 07:04:58 -0700 (PDT)
Received: from asus.site (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id w9sm19709886pfn.19.2019.08.20.07.04.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Aug 2019 07:04:53 -0700 (PDT)
Subject: Re: [PATCH v2 1/2] scsi: target/tcm_loop: ignore already deleted scsi
 device
To:     Naohiro Aota <naohiro.aota@wdc.com>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <mchristi@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20190820090429.1961085-1-naohiro.aota@wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <1973f310-ad00-ff88-fe08-a31f81dc5c33@acm.org>
Date:   Tue, 20 Aug 2019 07:02:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190820090429.1961085-1-naohiro.aota@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/20/19 2:04 AM, Naohiro Aota wrote:
> If there is no corresponding scsi_device for a LUN,
> tcm_loop_port_unlink() complains that it "Unable to locate struct
> scsi_device for " the device and keep %tl_tpg_port_count as is. However,
> such situation is legal when we delete a SCSI device using
> /sys/class/scsi_device/${lun}/device/delete. We can safely ignore the
> missing SCSI device case here.
> 
> Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
> ---
>   drivers/target/loopback/tcm_loop.c | 18 +++++++++---------
>   1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
> index 3305b47fdf53..0942f3bd7eec 100644
> --- a/drivers/target/loopback/tcm_loop.c
> +++ b/drivers/target/loopback/tcm_loop.c
> @@ -654,16 +654,16 @@ static void tcm_loop_port_unlink(
>   
>   	sd = scsi_device_lookup(tl_hba->sh, 0, tl_tpg->tl_tpgt,
>   				se_lun->unpacked_lun);
> -	if (!sd) {
> -		pr_err("Unable to locate struct scsi_device for %d:%d:%llu\n",
> -		       0, tl_tpg->tl_tpgt, se_lun->unpacked_lun);
> -		return;
> +	if (sd) {
> +		/*
> +		 * Remove Linux/SCSI struct scsi_device by HCTL
> +		 */
> +		scsi_remove_device(sd);
> +		scsi_device_put(sd);
> +	} else {
> +		pr_debug("Unable to locate struct scsi_device for %d:%d:%llu\n",
> +			 0, tl_tpg->tl_tpgt, se_lun->unpacked_lun);
>   	}
> -	/*
> -	 * Remove Linux/SCSI struct scsi_device by HCTL
> -	 */
> -	scsi_remove_device(sd);
> -	scsi_device_put(sd);
>   
>   	atomic_dec_mb(&tl_tpg->tl_tpg_port_count);

The above patch looks wrong to me. I think this patch does not fix the 
reference leak present in the current code. Have you considered to 
modify tcm_loop_port_link() such that it saves the pointer returned by 
scsi_add_device() and to use that pointer in tcm_loop_port_unlink()?

Bart.

