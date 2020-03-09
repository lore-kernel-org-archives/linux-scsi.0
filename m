Return-Path: <SRS0=qdS7=42=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA5ACC10F25
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Mar 2020 19:37:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B054624676
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Mar 2020 19:37:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbgCIThF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Mar 2020 15:37:05 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33524 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbgCIThE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Mar 2020 15:37:04 -0400
Received: by mail-pg1-f195.google.com with SMTP id m5so5192348pgg.0
        for <linux-scsi@vger.kernel.org>; Mon, 09 Mar 2020 12:37:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4c1oZpcOmzJcrnLQx2GB52okx6ta1gSfkwqQTe3GRHc=;
        b=AKi7VdNx4V6QElPJ45DfGOSYuq1IDygjZEkP9+JjZYIFi6A2C1nQgkVpy7xJCDREYK
         R17KVWPdGjBFt/h1fGCG493a1JAgW8XEsjSK3MtFbapVbAgvXR3Cquc5d6fEOeGkt7ju
         0NNCdHJzPtG/5UXEF67jVTlz/CNuB8pHEeNP6HBa/dZHyOqBK+WwMd+fWgyuDRAl52R8
         o16BJjmodmmV8a50qNXL9HUgDjbhZgouBAF2xj/jALHpdD1epXEJ6+DNTUq9nKJAYE4j
         8doKiekFkGIftJCYvlEgACTlMhtvEw2YZNQG7qTq/zEOywaDSyYCuseBVhLFuGg8Czrf
         u/eg==
X-Gm-Message-State: ANhLgQ3iCDQvzjHfpIQHk2OQsTYyD84zfQtjpXllj/WNev/oQzXdfbal
        nr1mI6H4oH2a1OP5JWdFoe8gHUHq
X-Google-Smtp-Source: ADFU+vuMPBF4GCR3ioW/7Bf0z1/zm9O5tlJXjxolLdFBAWggWKA5PRIJOYhtQcN5+6rbH49YoGOSlg==
X-Received: by 2002:a63:5847:: with SMTP id i7mr17524614pgm.127.1583782622513;
        Mon, 09 Mar 2020 12:37:02 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id h2sm340733pjc.7.2020.03.09.12.37.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2020 12:37:01 -0700 (PDT)
Subject: Re: [PATCH] scsi: avoid repetitive logging of device offline messages
To:     "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
References: <20200309181416.10665-1-emilne@redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <b7f3c0d1-0f08-83e2-6df5-8b6a02201ba6@acm.org>
Date:   Mon, 9 Mar 2020 12:36:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200309181416.10665-1-emilne@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/9/20 11:14 AM, Ewan D. Milne wrote:
> Large queues of I/O to offline devices that are eventually
> submitted when devices are unblocked result in a many repeated
> "rejecting I/O to offline device" messages.  These messages
> can fill up the dmesg buffer in crash dumps so no useful
> prior messages remain.  In addition, if a serial console
> is used, the flood of messages can cause a hard lockup in
> the console code.
> 
> Introduce a flag indicating the message has already been logged
> for the device, and reset the flag when scsi_device_set_state()
> changes the device state.
> 
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> ---
>   drivers/scsi/scsi_lib.c    | 8 ++++++--
>   include/scsi/scsi_device.h | 2 ++
>   2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 610ee41..d3a6d97 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1240,8 +1240,11 @@ scsi_prep_state_check(struct scsi_device *sdev, struct request *req)
>   		 * commands.  The device must be brought online
>   		 * before trying any recovery commands.
>   		 */
> -		sdev_printk(KERN_ERR, sdev,
> -			    "rejecting I/O to offline device\n");
> +		if (!sdev->offline_already) {
> +			sdev->offline_already = 1;
> +			sdev_printk(KERN_ERR, sdev,
> +				    "rejecting I/O to offline device\n");
> +		}
>   		return BLK_STS_IOERR;
>   	case SDEV_DEL:
>   		/*
> @@ -2340,6 +2343,7 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
>   		break;
>   
>   	}
> +	sdev->offline_already = 0;
>   	sdev->sdev_state = state;
>   	return 0;
>   
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index f8312a3..72987a0 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -204,6 +204,8 @@ struct scsi_device {
>   	unsigned unmap_limit_for_ws:1;	/* Use the UNMAP limit for WRITE SAME */
>   	unsigned rpm_autosuspend:1;	/* Enable runtime autosuspend at device
>   					 * creation time */
> +	unsigned offline_already:1;	/* Device offline message logged */
> +
>   	atomic_t disk_events_disable_depth; /* disable depth for disk events */
>   
>   	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */

Bitfields are troublesome in multithreaded software. Has it been 
considered to use rate-limiting instead of introducing a new bitfield 
member?

Thanks,

Bart.


