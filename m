Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82FFDC433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 21:09:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E85661435
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 21:09:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240553AbhDUVKE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 17:10:04 -0400
Received: from mail-pg1-f174.google.com ([209.85.215.174]:37876 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234469AbhDUVKE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Apr 2021 17:10:04 -0400
Received: by mail-pg1-f174.google.com with SMTP id p2so15686817pgh.4
        for <linux-scsi@vger.kernel.org>; Wed, 21 Apr 2021 14:09:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=comK6KxWIU/RNWJZiwgW7vA/UPdCtsTqmqGXMrioTbs=;
        b=Phv70/luf05jF+JJOBy1IgtOpL8igiopxQHGOjNJF6UNaumv57uZFVcj3dsK2+oeDE
         /TPdKIYmhEPyh5cAjLenvgEm0eVeSh70mJwyoscoktWHRzQNhsHr92cAFmQfXxZxpGMo
         f3xRqUzHTG8N0xE6Awf0dRY5earNIDqTti1A0UneaFYHPSRBBdWZniORB5/Bu2sTwE9F
         X4j4CJEnPFAaWuFwsbr0dVUhT6AuRawbIpsE4V+sd7Kg3t7Ct62Rfb9byKayijTRl/lv
         angkNhPIhYx7387JsZGykKJv332RJnldkE+hb6PXczhTGNhijolvsYjBp/ssc1zDOEEv
         B/bQ==
X-Gm-Message-State: AOAM531UZGpglBCBTcQT3GuMRL5aPa0HP8PAq169vnoQWpbo557VIuiO
        RgwjusP4jnFuDg/wSS0L52w7sfzcPs7x8g==
X-Google-Smtp-Source: ABdhPJzU88q0bevpepa9H8Ks0gXZVDYjXwamscZz2/YnRajRpKzXINNP4dij21BP/VV1pZv/AIgnxw==
X-Received: by 2002:a17:90b:314:: with SMTP id ay20mr13330649pjb.186.1619039370210;
        Wed, 21 Apr 2021 14:09:30 -0700 (PDT)
Received: from [192.168.51.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id r1sm248962pjo.26.2021.04.21.14.09.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Apr 2021 14:09:29 -0700 (PDT)
Subject: Re: [PATCH 13/42] scsi: add get_{status,host}_byte() accessor
 function
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210421174749.11221-1-hare@suse.de>
 <20210421174749.11221-14-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <857b0e4a-06e5-b240-1075-466b607faaf5@acm.org>
Date:   Wed, 21 Apr 2021 14:09:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210421174749.11221-14-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/21/21 10:47 AM, Hannes Reinecke wrote:
> Add accessor functions for the host and status byte.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   include/scsi/scsi_cmnd.h | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index a1eb7732aa1b..0ac18a7d8ac6 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -316,6 +316,11 @@ static inline void set_status_byte(struct scsi_cmnd *cmd, char status)
>   	cmd->result = (cmd->result & 0xffffff00) | status;
>   }
>   
> +static inline unsigned char get_status_byte(struct scsi_cmnd *cmd)
> +{
> +	return cmd->result & 0xff;
> +}

So in addition to the status_byte() macro, get_status_byte() is 
introduced? That seems like a potential source of confusion to me.

Thanks,

Bart.
