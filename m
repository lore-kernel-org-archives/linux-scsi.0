Return-Path: <SRS0=buB8=XH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EEA3C4CEC5
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 13:46:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC8C620856
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 13:46:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731786AbfILNqo convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Sep 2019 09:46:44 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39863 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731283AbfILNqo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Sep 2019 09:46:44 -0400
Received: by mail-pg1-f193.google.com with SMTP id u17so13519835pgi.6
        for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2019 06:46:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MtP0RfUzuHL3kYu6wQIB2IyKy3GyiWExYLlefQaqSxM=;
        b=F+9GATi6kNo5CwF8Pvvonzmdq8W7Myv9qSXtzFeLNWatysgCd4ErhWeF/gQVYow/e7
         fZAWxwW/b/5KqLabbu9yOTeKjmlFSyEud8DSGAV+gV7t0am2seJ9+39Z8SabOCUwFkHV
         yZ4MOobJWkSBFw02ZAer2VwMOZaeVVKhPbjzgbXDfIqE9NgHgmoUMvHHGAwh8sTJ1qd3
         xYjA5yU9UsCdpvv3OU4kNxPb0Fk0i4+ctYmtDkJ4EVzg5e2T37s4AXbjuxT7iWufNHQR
         t+4lAjClRtKRIJpTkatFYy6kVXB0b9ZbUeTK4VuGmdg/O1FZe3w48EiY4A1FyjRqelI3
         0wRA==
X-Gm-Message-State: APjAAAXa0J/sW10cq3iPAwUfYXhhYXACdFDjEYAGkm9AqBp2bj/Bz8oc
        zeW9RES3WGQYCkfLcHifdxE=
X-Google-Smtp-Source: APXvYqxmdAigtAb9pUd7aKFtSeVu9hhQjWy0OIHyx/CmemFWJrp9WOdk6Xv0QiSC31lz7H8JyY+OmQ==
X-Received: by 2002:a17:90a:b38a:: with SMTP id e10mr48202pjr.91.1568296002281;
        Thu, 12 Sep 2019 06:46:42 -0700 (PDT)
Received: from [172.19.249.100] ([38.98.37.138])
        by smtp.gmail.com with ESMTPSA id em21sm22269pjb.31.2019.09.12.06.46.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Sep 2019 06:46:41 -0700 (PDT)
Subject: Re: [PATCH v2 3/3] scsi: ufs-mediatek: enable auto suspend capability
To:     Stanley Chu <stanley.chu@mediatek.com>, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, avri.altman@wdc.com,
        alim.akhtar@samsung.com, pedrom.sousa@synopsys.com,
        sthumma@codeaurora.org, jejb@linux.ibm.com
Cc:     linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, matthias.bgg@gmail.com,
        evgreen@chromium.org, beanhuo@micron.com, marc.w.gonzalez@free.fr,
        subhashj@codeaurora.org, vivek.gautam@codeaurora.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com
References: <1568270135-32442-1-git-send-email-stanley.chu@mediatek.com>
 <1568270135-32442-4-git-send-email-stanley.chu@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <160452c7-c53c-155c-49a9-4365166032a8@acm.org>
Date:   Thu, 12 Sep 2019 14:46:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1568270135-32442-4-git-send-email-stanley.chu@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8BIT
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/12/19 7:35 AM, Stanley Chu wrote:
> Enable auto suspend capability in MediaTek UFS driver.
> 
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> Reviewed-by: Avri Altman <avri.altman@wdc.com>
> ---
>  drivers/scsi/ufs/ufs-mediatek.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
> index 0f6ff33ce52e..b7b177c6194c 100644
> --- a/drivers/scsi/ufs/ufs-mediatek.c
> +++ b/drivers/scsi/ufs/ufs-mediatek.c
> @@ -117,6 +117,11 @@ static int ufs_mtk_setup_clocks(struct ufs_hba *hba, bool on,
>  	return ret;
>  }
>  
> +static void ufs_mtk_set_caps(struct ufs_hba *hba)
> +{
> +	hba->caps |= UFSHCD_CAP_RPM_AUTOSUSPEND;
> +}
> +
>  /**
>   * ufs_mtk_init - find other essential mmio bases
>   * @hba: host controller instance
> @@ -147,6 +152,8 @@ static int ufs_mtk_init(struct ufs_hba *hba)
>  	if (err)
>  		goto out_variant_clear;
>  
> +	ufs_mtk_set_caps(hba);
> +
>  	/*
>  	 * ufshcd_vops_init() is invoked after
>  	 * ufshcd_setup_clock(true) in ufshcd_hba_init() thus

Please inline the ufs_mtk_set_caps() function. Introducing single line
functions like is done in this patch doesn't improve readability.

Thanks,

Bart.

