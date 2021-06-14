Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DED7DC48BE6
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Jun 2021 07:21:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B980461075
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Jun 2021 07:21:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232494AbhFNHXf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Jun 2021 03:23:35 -0400
Received: from mail-ed1-f46.google.com ([209.85.208.46]:36475 "EHLO
        mail-ed1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232454AbhFNHXf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jun 2021 03:23:35 -0400
Received: by mail-ed1-f46.google.com with SMTP id w21so45031864edv.3
        for <linux-scsi@vger.kernel.org>; Mon, 14 Jun 2021 00:21:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZUfFKoeo6FRQMco/dPmn7H+ldhTvrhPeV2iUfINpVsI=;
        b=cnTql8VMTA0JXqAE6gA4jBlrUAsWibx2opDxJGFCPSwMluMZi1Zim8WfwiI566Vgbq
         ZQXZ/gt4x3ETPfnpOV6NKLRZREVw2etDmsbZzM1ASMOqFJ8wXiLFNYY84gmSoRBaTFCJ
         uBOlouXUuugVOQCGzr3VmXAK9TwL88qYztqxJgOqRKIfD5FBX3uS8pYMZOqKO9KPHbNL
         ElbdajXN5urbWM1y77THZyRl2060bOhIkDRBisB81d9aGkGv8/P3T3Z7ca9F+NS6bTwF
         Ig4r2ycBrOQqKEHSg/rJtZPOehHpq6VxKY+v/4mZ08ya7ma6J2HaQY3jjUGOifKvh9Qt
         kgrw==
X-Gm-Message-State: AOAM530OSIAunXU+5NHBrgaXYgUMepXriYjvNmWYYD6vb1JQAJY6Ioe5
        vs4jxcN2izPWPiJKk4E8p5kHZ5I1M8U=
X-Google-Smtp-Source: ABdhPJyu1Wq+HXtWVfMkVRLj0/L6Gnx/mav7yAYqYcroYI4+GRksgF3KRQK31K5I1kmoOvPO/tuCfA==
X-Received: by 2002:a05:6402:1a4b:: with SMTP id bf11mr15383018edb.286.1623655291803;
        Mon, 14 Jun 2021 00:21:31 -0700 (PDT)
Received: from ?IPv6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id ot30sm6526127ejb.61.2021.06.14.00.21.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jun 2021 00:21:31 -0700 (PDT)
Subject: Re: [PATCH 1/2] virtio_scsi: do not overwrite SCSI status
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210610135833.46663-1-hare@suse.de>
From:   Jiri Slaby <jirislaby@kernel.org>
Message-ID: <1a1dcd2f-7be1-8206-c1da-76f9c4e98dc4@kernel.org>
Date:   Mon, 14 Jun 2021 09:21:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210610135833.46663-1-hare@suse.de>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10. 06. 21, 15:58, Hannes Reinecke wrote:
> When a sense code is present we should not override the scsi status;
> the driver already sets it based on the response from the hypervisor.
> 
> Fixes:  464a00c9e0ad ("scsi: core: Kill DRIVER_SENSE")
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Tested-by: Jiri Slaby <jirislaby@kernel.org>

> ---
>   drivers/scsi/virtio_scsi.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index fd69a03d6137..43177a62916a 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -161,7 +161,6 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
>   		       min_t(u32,
>   			     virtio32_to_cpu(vscsi->vdev, resp->sense_len),
>   			     VIRTIO_SCSI_SENSE_SIZE));
> -		set_status_byte(sc, SAM_STAT_CHECK_CONDITION);
>   	}
>   
>   	sc->scsi_done(sc);
> 


-- 
js
suse labs
