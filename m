Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24254C433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 03:59:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED56B61360
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 03:59:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbhDZD77 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Apr 2021 23:59:59 -0400
Received: from mail-vs1-f48.google.com ([209.85.217.48]:43939 "EHLO
        mail-vs1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbhDZD76 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Apr 2021 23:59:58 -0400
Received: by mail-vs1-f48.google.com with SMTP id h19so8992844vsa.10
        for <linux-scsi@vger.kernel.org>; Sun, 25 Apr 2021 20:59:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dv+5YD/LNMb6XGQA1ogVW0MgKR5V97OcDfojjjc5oWA=;
        b=W//CCgUVPQLE7FRsGs4lJgMbr/2JEdgr8fGvFk3BOgk7D89brTBmQTrSAZ0Pwe0GPh
         fZw33sRN+jr8FTtCbJ71sPe/Sb2k5stVLcmXCjWS8qJNdxcnDmwGd0SsqZJZZkmWF84s
         A7/GbPMjTfWw99wpSXXzF+vtefFGZDDs/n2TFdBKdQjhi4WKsxvW9mjxt4wtE2Tpq+kn
         Ay6h41w0UzRoLDDLfCb3rFTnrOd0Yta2/NubnyOoFy/gGbFgITFaSO0K1SrQT0tsKW4c
         Cl+Hqj3Twn7FWymi0JC3gWxHv37JoB/MthH6/U0AV2jD9doLvPYlHvF8CGQ58JPKfajb
         EKxg==
X-Gm-Message-State: AOAM532BjPt9S9U6cv6HHxTyb6lhPbk3iyo7ojYsTkkM2/f7eopfnCTw
        JBp6/t/MnRIbksA2JI7efcuMdlDCHYsnug==
X-Google-Smtp-Source: ABdhPJxLsgS7IQAA5dnUHUbVbhZOZnkaLu2X6eWdEyIxmTMPKByLUzotP+8AiCiK1nFgZkyqiW/20A==
X-Received: by 2002:a17:902:c209:b029:ec:7add:e183 with SMTP id 9-20020a170902c209b02900ec7adde183mr16882292pll.74.1619409104108;
        Sun, 25 Apr 2021 20:51:44 -0700 (PDT)
Received: from [192.168.3.219] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id f10sm13626984pju.27.2021.04.25.20.51.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Apr 2021 20:51:43 -0700 (PDT)
Subject: Re: [PATCH 38/39] target: use standard SAM status types
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210423113944.42672-1-hare@suse.de>
 <20210423113944.42672-39-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <a7bb53fd-0741-185a-6e06-f7077bbbb81d@acm.org>
Date:   Sun, 25 Apr 2021 20:51:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210423113944.42672-39-hare@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/23/21 4:39 AM, Hannes Reinecke wrote:
> diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
> index dac44caf77a3..7e5e4ab3c126 100644
> --- a/drivers/target/target_core_pscsi.c
> +++ b/drivers/target/target_core_pscsi.c
> @@ -1044,7 +1044,7 @@ static void pscsi_req_done(struct request *req, blk_status_t status)
>  	struct se_cmd *cmd = req->end_io_data;
>  	struct pscsi_plugin_task *pt = cmd->priv;
>  	int result = scsi_req(req)->result;
> -	u8 scsi_status = status_byte(result) << 1;
> +	u8 scsi_status = (result & 0xff);

I don't think that the parentheses are necessary in the above
expression. Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
