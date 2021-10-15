Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C787C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 17:54:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 614C860F41
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 17:54:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242341AbhJOR4r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Oct 2021 13:56:47 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:40912 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242303AbhJOR4q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Oct 2021 13:56:46 -0400
Received: by mail-pg1-f171.google.com with SMTP id q5so9234019pgr.7;
        Fri, 15 Oct 2021 10:54:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=uR9uz/OLZele/hv90GFPXJReAhLyZUOecNTgoswKJTo=;
        b=OikXIrEWy11MzZfeU2gXfI9GMF3TAE8x0do2OdDSPweM7O9dJk7ZGxMo27Jw1NrhVk
         oZ6mZtSvoFq8MB5sGw8PwS8tvkiO2GTYV+pvNSL07h7lhAfYUVPNIVfe8rf0988+/PBe
         AWbExGGmEdefYbGOWEDHH8z9jxZbqAoHfZQ6K7blzqniR4weYjC4ApVYkgZKShQWyAJN
         jNaMpaiKZKYzn7OLgUsSu99dZ5F8SRdptOLSvONb8rUzeH7+CcBYdVIQPEST1tJF7xTT
         NZAyVK7sW9yjcCXVSQKgIzu6tjz2AqnRIUlCXdPD8ww4PPee9jlc/hH5GnQMlSG+JHom
         Qzew==
X-Gm-Message-State: AOAM532sYny7hN+cfFal1Ujq5Ay0IxptJtikw/JwYmU7NDNzfNOLFaNo
        fuWQaS1e1GBmCemNxyecyojB7xfNdlQ=
X-Google-Smtp-Source: ABdhPJzl6ayTJdtiiPH0GTkLc6dA9jF/TVYxeu3wirUyYx4iT6g+5fgvZVrqzcyBQ9mdvRXCJ71mSA==
X-Received: by 2002:a63:fc65:: with SMTP id r37mr10273633pgk.28.1634320479541;
        Fri, 15 Oct 2021 10:54:39 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:cbb9:9363:2c17:8891? ([2601:647:4000:d7:cbb9:9363:2c17:8891])
        by smtp.gmail.com with ESMTPSA id u193sm5116561pgc.34.2021.10.15.10.54.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Oct 2021 10:54:38 -0700 (PDT)
Message-ID: <fe7bacf4-aa9a-6742-8382-a7c9b31236a7@acm.org>
Date:   Fri, 15 Oct 2021 10:54:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [PATCH] scsi: sd: fix crashes in sd_resume_runtime
Content-Language: en-US
To:     Miles Chen <miles.chen@mediatek.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Martin Kepplinger <martink@posteo.de>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, wsd_upstream@mediatek.com,
        Stanley Chu <stanley.chu@mediatek.com>
References: <20211015074654.19615-1-miles.chen@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20211015074654.19615-1-miles.chen@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/15/21 00:46, Miles Chen wrote:
> Crash:
> [    4.695171][  T151] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000008
> [    4.710577][  T151] Internal error: Oops: 96000005 [#1] PREEMPT SMP
> [    4.856708][  T151]  die+0x16c/0x59c
> [    4.857191][  T151]  __do_kernel_fault+0x1e8/0x210
> [    4.857833][  T151]  do_page_fault+0xa4/0x654
> [    4.858418][  T151]  do_translation_fault+0x6c/0x1b0
> [    4.859083][  T151]  do_mem_abort+0x68/0x10c
> [    4.859655][  T151]  el1_abort+0x40/0x64
> [    4.860182][  T151]  el1h_64_sync_handler+0x54/0x88
> [    4.860834][  T151]  el1h_64_sync+0x7c/0x80
> [    4.861395][  T151]  sd_resume_runtime+0x20/0x14c
> [    4.862025][  T151]  scsi_runtime_resume+0x84/0xe4
> [    4.862667][  T151]  __rpm_callback+0x1f4/0x8cc
> [    4.863275][  T151]  rpm_resume+0x7e8/0xaa4
> [    4.863836][  T151]  __pm_runtime_resume+0xa0/0x110
> [    4.864489][  T151]  sd_probe+0x30/0x428
> [    4.865016][  T151]  really_probe+0x14c/0x500
> [    4.865602][  T151]  __driver_probe_device+0xb4/0x18c
> [    4.866278][  T151]  driver_probe_device+0x60/0x2c4
> [    4.866931][  T151]  __device_attach_driver+0x228/0x2bc
> [    4.867630][  T151]  __device_attach_async_helper+0x154/0x21c
> [    4.868398][  T151]  async_run_entry_fn+0x5c/0x1c4
> [    4.869038][  T151]  process_one_work+0x3ac/0x590
> [    4.869670][  T151]  worker_thread+0x320/0x758
> [    4.870265][  T151]  kthread+0x2e8/0x35c
> [    4.870792][  T151]  ret_from_fork+0x10/0x20
> 
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Fixes: ed4246d37f3b ("scsi: sd: REQUEST SENSE for BLIST_IGN_MEDIA_CHANGE devices in runtime_resume()")
> Signed-off-by: Miles Chen <miles.chen@mediatek.com>
> ---
>   drivers/scsi/sd.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 523bf2fdc253..fce63335084e 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3683,7 +3683,12 @@ static int sd_resume(struct device *dev)
>   static int sd_resume_runtime(struct device *dev)
>   {
>   	struct scsi_disk *sdkp = dev_get_drvdata(dev);
> -	struct scsi_device *sdp = sdkp->device;
> +	struct scsi_device *sdp;
> +
> +	if (!sdkp)	/* E.g.: runtime resume at the start of sd_probe() */
> +		return 0;
> +
> +	sdp = sdkp->device;
>   
>   	if (sdp->ignore_media_change) {
>   		/* clear the device's sense data */

Fixing this crash by adding a check inside sd_resume_runtime() seems 
wrong to me. sd_probe() namely calls dev_set_drvdata(dev, sdkp) before 
sd_probe() has finished so even with the above patch applied sd_resume() 
can be called before sd_probe() has finished.

With which kernel version has this crash been encountered? The 
scsi_autopm_get_device() / scsi_autopm_put_device() pair added by commit 
6fe8c1dbefd6 ("scsi: balance out autopm get/put calls in 
scsi_sysfs_add_sdev()"; kernel v3.18) should be sufficient to prevent 
the reported crash.

Thanks,

Bart.


