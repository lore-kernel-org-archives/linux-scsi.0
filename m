Return-Path: <SRS0=SaCo=ZM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7FAAC432C0
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 03:20:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABC262240E
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 03:20:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lQAjyjOF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727549AbfKTDUi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Nov 2019 22:20:38 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:35017 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727579AbfKTDUi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Nov 2019 22:20:38 -0500
Received: by mail-qt1-f195.google.com with SMTP id n4so27417632qte.2
        for <linux-scsi@vger.kernel.org>; Tue, 19 Nov 2019 19:20:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=Ytpodh3Kx5RryZ4ZgwA/JNxwaP9zyvhq/QftDIZYRNY=;
        b=lQAjyjOFYmrK0kf9WOwVs1PCweQqM5PQdARsurtM8BpkHfiHiZMFxjTrPmk34UxEAY
         aMMjIhjvthBC33ah6uLpDCdGX9OuIm+E7r1GcM9Al87X4iVstzXpTh+u1+utp+pQvLei
         CNV0FkyM5MbtC7V4QcvS6e39hbCJvnTYDmWd238J0fF16sAtWSppW+MsDlTcZ1eqVJR5
         aFP+sH1eOju2b4f2xW1C1ZhCPyb/TnMWNdXnti9+wugBE4p708pvN1mO3JL4PPMcg0Oa
         HJf0nsaWmrheI7I3tcGoZSytT1zhcjgo1q9rnSJotQax5gT+GYgAgluos05yEixW+HDr
         4M5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Ytpodh3Kx5RryZ4ZgwA/JNxwaP9zyvhq/QftDIZYRNY=;
        b=RZqoUx5eC8smpOjXgVs6MCbN2OT7qRvgztmc4LNBxi+Pkr0wZIcBxtKwteymrDf0C8
         f7B1iyi9XFoxoQJJRF+oJL6KBMfiOQGOfcIZN8sye2rXsRwuhH71TE3fV8+uqK82I0Y+
         8l6WEUOD+QJ/qms7rMgOGhxyc/cb+tAOoyrjoFRyMqF72x68herbykzDHfGiBpVhyPaH
         YIt4k2M12Z0Njr+kpg3ElncjOe9RXN6dKQmaPKYktGi1wZc/gbRpI52oafKLl1D9V+i+
         LqHgXQ9BpaYctgBGIXJwqRaW+LMUH1rN5ojpezbi3dWF+l9uykP7CydfzZov4e6ikSsZ
         mzLA==
X-Gm-Message-State: APjAAAWU66tl4Js/372J3Ltusb6/pftUMc3YJFFYIsM8oyHY7sE7yqsG
        ijOHpOKDn3q23PvocSNoz0Wal9Uk
X-Google-Smtp-Source: APXvYqwBbbFtKcn6Jx/0uv1nxeWm2brHulmjhp1zNtnPY5a+zeo/R8MCl/AzS9Dc8J/l8f3mc0H7sg==
X-Received: by 2002:ac8:5390:: with SMTP id x16mr636837qtp.42.1574220036691;
        Tue, 19 Nov 2019 19:20:36 -0800 (PST)
Received: from chad-VirtualBox (pool-96-230-166-208.prvdri.fios.verizon.net. [96.230.166.208])
        by smtp.gmail.com with ESMTPSA id t20sm12776631qtq.55.2019.11.19.19.20.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 19:20:36 -0800 (PST)
Message-ID: <3fa3e132b5c127326ba77a459460c08539fb8445.camel@gmail.com>
Subject: Re: [PATCH] scsi_debug: check if the max_queue parameter is valid
From:   cdupuis1@gmail.com
To:     Maurizio Lombardi <mlombard@redhat.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, jejb@linux.ibm.com,
        dgilbert@interlog.com
Date:   Tue, 19 Nov 2019 22:20:35 -0500
In-Reply-To: <20191119154059.9440-1-mlombard@redhat.com>
References: <20191119154059.9440-1-mlombard@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Sanity check makes sense.

Reviewed-by: Chad Dupuis <cdupuis1@gmail.com>

On Tue, 2019-11-19 at 16:40 +0100, Maurizio Lombardi wrote:
> Passing an invalid value to max_queue may cause memory corruption
> or kernel freeze.
> 
> E.g.
> 
> [ 1841.074356] INFO: task rmmod:18774 blocked for more than 120
> seconds.
> [ 1841.074400]       Not tainted 4.18.0-151.el8.ppc64le #1
> [ 1841.074435] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [ 1841.074486] rmmod           D    0 18774  17507 0x00040080
> [ 1841.074549] Call Trace:
> [ 1841.074569] [c0000001eae2b380] [c00000018ae47600]
> 0xc00000018ae47600 (unreliable)
> [ 1841.074622] [c0000001eae2b550] [c00000000001f9a0]
> __switch_to+0x2e0/0x4e0
> [ 1841.074666] [c0000001eae2b5b0] [c000000000d716b4]
> __schedule+0x2c4/0x8e0
> [ 1841.074712] [c0000001eae2b680] [c000000000d71d28]
> schedule+0x58/0x120
> [ 1841.074755] [c0000001eae2b6b0] [c000000000188a44]
> async_synchronize_cookie_domain+0x174/0x360
> [ 1841.074848] [c0000001eae2b780] [d000000002e228b0]
> sd_remove+0x78/0x120 [sd_mod]
> [ 1841.074908] [c0000001eae2b7c0] [c0000000008af084]
> device_release_driver_internal+0x2d4/0x3f0
> [ 1841.074971] [c0000001eae2b810] [c0000000008ac368]
> bus_remove_device+0x128/0x270
> [ 1841.075025] [c0000001eae2b890] [c0000000008a6828]
> device_del+0x298/0x590
> [ 1841.075074] [c0000001eae2b940] [c00000000091dfe0]
> __scsi_remove_device+0x190/0x1f0
> [ 1841.075127] [c0000001eae2b980] [c000000000919bb4]
> scsi_forget_host+0xa4/0xb0
> [ 1841.075180] [c0000001eae2b9b0] [c000000000907a8c]
> scsi_remove_host+0xac/0x3a0
> [ 1841.075241] [c0000001eae2ba40] [d000000002624d9c]
> sdebug_driver_remove+0x44/0x150 [scsi_debug]
> [ 1841.075302] [c0000001eae2bad0] [c0000000008af084]
> device_release_driver_internal+0x2d4/0x3f0
> [ 1841.075364] [c0000001eae2bb20] [c0000000008ac368]
> bus_remove_device+0x128/0x270
> [ 1841.075417] [c0000001eae2bba0] [c0000000008a6828]
> device_del+0x298/0x590
> [ 1841.075461] [c0000001eae2bc50] [c0000000008a6b50]
> device_unregister+0x30/0xa0
> [ 1841.075515] [c0000001eae2bcc0] [d000000002623a8c]
> sdebug_remove_adapter+0xe4/0x130 [scsi_debug]
> [ 1841.075599] [c0000001eae2bd00] [d00000000262eeb8]
> scsi_debug_exit+0x50/0x1348 [scsi_debug]
> [ 1841.075652] [c0000001eae2bd60] [c0000000002453f0]
> sys_delete_module+0x210/0x380
> [ 1841.075706] [c0000001eae2be30] [c00000000000b388]
> system_call+0x5c/0x70
> 
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> ---
>  drivers/scsi/scsi_debug.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 44cb054d5e66..c2779012d968 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -5268,6 +5268,11 @@ static int __init scsi_debug_init(void)
>  		return -EINVAL;
>  	}
>  
> +	if (sdebug_max_queue <= 0 || sdebug_max_queue >
> SDEBUG_CANQUEUE) {
> +		pr_err("max_queue must be > 0 and <= %d\n",
> SDEBUG_CANQUEUE);
> +		return -EINVAL;
> +	}
> +
>  	if (sdebug_guard > 1) {
>  		pr_err("guard must be 0 or 1\n");
>  		return -EINVAL;

