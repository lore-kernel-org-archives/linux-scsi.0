Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10857C433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 03:48:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D486660FEE
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 03:48:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbhDZDsn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Apr 2021 23:48:43 -0400
Received: from mail-pf1-f169.google.com ([209.85.210.169]:46068 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbhDZDsn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Apr 2021 23:48:43 -0400
Received: by mail-pf1-f169.google.com with SMTP id i190so38040018pfc.12
        for <linux-scsi@vger.kernel.org>; Sun, 25 Apr 2021 20:47:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Hkx/72I582eElwO04BWZ5n3o0BI2RVNZAxi9Eu8OiEE=;
        b=omX2XIsEXhtg3CQtnCoF0Gh9FHLPqdfAeOQyy9E0fUeTIFvGp8vegeNge8cA/c+QPI
         qlNOpN6LR5EooeWweLciPD9fawcBu6eVRoP7zkJKJ3YPFOziUgM07cUA22nHUKu+9BWj
         EV/uAOBIszoVkj2dMdPRuYjN/M5Ukcn6bp8i/Osf+BRAq8nkU61CXPM7KIlM/spiIT5e
         cNXRKIc0CR/i0gziZzxD2A+f6y77/DJzmYkr+65X6lVr4ccyVSZK2B0lXM83IXL/0l2m
         CnXz+shKBwcwYLwWt4vVCtJJoNvaJgzGXyoR8KAHOWsxlUAUl6Xdfhw8m1RXWvp7u+sY
         deqA==
X-Gm-Message-State: AOAM532dg4Hm+s1MIU7NjcGKc53vDV51heugf7lQH88vu0ICKag5zc4i
        /R/zB7dpuwAZ7y0ot7JW70rFjd32uVFA+A==
X-Google-Smtp-Source: ABdhPJy9CdKg4r0/o9/Ob6shGoSbcPFd3iolwEchtZO7NY0WhSyJQ6pio6KtyvaA1evuL7LD3xBRng==
X-Received: by 2002:a05:6a00:1742:b029:275:c27c:6df0 with SMTP id j2-20020a056a001742b0290275c27c6df0mr4386715pfc.32.1619408851047;
        Sun, 25 Apr 2021 20:47:31 -0700 (PDT)
Received: from [192.168.3.219] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id nh10sm2117470pjb.49.2021.04.25.20.47.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Apr 2021 20:47:30 -0700 (PDT)
Subject: Re: [PATCH 15/39] scsi: add get_{status,host}_byte() accessor
 function
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210423113944.42672-1-hare@suse.de>
 <20210423113944.42672-16-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <4711fd13-a8a7-0cc3-c56f-53d65c47d45f@acm.org>
Date:   Sun, 25 Apr 2021 20:47:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210423113944.42672-16-hare@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/23/21 4:39 AM, Hannes Reinecke wrote:
> +static inline unsigned char get_status_byte(struct scsi_cmnd *cmd)
> +{
> +	return cmd->result & 0xff;
> +}
> +
>  static inline void set_msg_byte(struct scsi_cmnd *cmd, char status)
>  {
>  	cmd->result = (cmd->result & 0xffff00ff) | (status << 8);
> @@ -326,6 +331,11 @@ static inline void set_host_byte(struct scsi_cmnd *cmd, char status)
>  	cmd->result = (cmd->result & 0xff00ffff) | (status << 16);
>  }
>  
> +static inline unsigned char get_host_byte(struct scsi_cmnd *cmd)
> +{
> +	return (cmd->result >> 16) & 0xff;
> +}

How about using 'u8' instead of 'unsigned char' to make it more clear
that the returned value is an integer instead of a character? Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
