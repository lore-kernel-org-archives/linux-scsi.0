Return-Path: <SRS0=Rxtd=XL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AF8BC49ED7
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Sep 2019 15:16:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66542206C2
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Sep 2019 15:16:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728247AbfIPPQU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Sep 2019 11:16:20 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37990 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbfIPPQT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Sep 2019 11:16:19 -0400
Received: by mail-pl1-f193.google.com with SMTP id w10so25982plq.5
        for <linux-scsi@vger.kernel.org>; Mon, 16 Sep 2019 08:16:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xmsYsESq3U580LOTWkZxGZFs5MZ+7M41QlvsoZWEDCI=;
        b=U0dpPootHnfe9qYO/XI2d3xTFkf42pE14kAASXVd9BAtkoUzf4G/cMsgLFkRJ0NxGu
         05j9FmK13wyeouN+LDJ3ejT+5jCIKy1NJe6UzchILPSqccciETcbFWReo1g+bHehty+r
         j8om8KX2dJsNaRHF9ZyMhp68VcZqg9kIk7gr/02rR5OpllDL7w8THXwK1+AxZr7NrJZ6
         eSTWot5w+/8Y+wpam+wxAse4cnVnXXnM4u2b7t0zXoSH0gYRDTEZ27ctwAVlMaZiwzDy
         CkDiBBwpynOJvVr/1dG0gSYTefcfOmRpdpqL+0uzCYA8xINRzsNyxQZxbWnQIS6k58L1
         Ogzg==
X-Gm-Message-State: APjAAAVjq6oZYGZwF+7QdkXy98X8bbsbOQTE0h+u+P12Z54pcDWGwq+2
        ouIwvUiX90+OP8yFbbcw8Gw=
X-Google-Smtp-Source: APXvYqxHinrcCqICJcc3czDv9zh4ECEAokGbyfTBs0wU8DoJxGiUpHoBY9Ji3BuKcej+3FSC7eSTtA==
X-Received: by 2002:a17:902:b206:: with SMTP id t6mr297219plr.55.1568646978730;
        Mon, 16 Sep 2019 08:16:18 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id 6sm65221065pfa.162.2019.09.16.08.16.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Sep 2019 08:16:17 -0700 (PDT)
Subject: Re: [PATCH v3 1/3] scsi: core: allow auto suspend override by
 low-level driver
To:     Stanley Chu <stanley.chu@mediatek.com>, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, avri.altman@wdc.com,
        alim.akhtar@samsung.com, pedrom.sousa@synopsys.com,
        sthumma@codeaurora.org, jejb@linux.ibm.com
Cc:     linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        matthias.bgg@gmail.com, evgreen@chromium.org, beanhuo@micron.com,
        marc.w.gonzalez@free.fr, subhashj@codeaurora.org,
        vivek.gautam@codeaurora.org, kuohong.wang@mediatek.com,
        peter.wang@mediatek.com, chun-hung.wu@mediatek.com,
        andy.teng@mediatek.com
References: <1568616437-16271-1-git-send-email-stanley.chu@mediatek.com>
 <1568616437-16271-2-git-send-email-stanley.chu@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <bebea62f-8ab0-528f-5634-9b3c06f47ef7@acm.org>
Date:   Mon, 16 Sep 2019 08:16:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1568616437-16271-2-git-send-email-stanley.chu@mediatek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/15/19 11:47 PM, Stanley Chu wrote:
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 202f4d6a4342..495e30adb53f 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -199,7 +199,7 @@ struct scsi_device {
>   	unsigned broken_fua:1;		/* Don't set FUA bit */
>   	unsigned lun_in_cdb:1;		/* Store LUN bits in CDB[1] */
>   	unsigned unmap_limit_for_ws:1;	/* Use the UNMAP limit for WRITE SAME */
> -
> +	unsigned rpm_autosuspend_on:1;	/* Runtime autosuspend */
>   	atomic_t disk_events_disable_depth; /* disable depth for disk events */
    The "_on" part in the variable name "rpm_autosuspend_on" is probably 
redundant and the comment could have been more elaborate. Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
