Return-Path: <SRS0=JpCa=WK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA5AAC433FF
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 15:25:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 878A12084F
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 15:25:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726585AbfHNPZp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 11:25:45 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:41794 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbfHNPZp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2019 11:25:45 -0400
Received: by mail-pl1-f195.google.com with SMTP id m9so50669563pls.8
        for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2019 08:25:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5TsxA1uNSmj5/YyMwa1AT/pNzIiK95/3bZtsBDSRzec=;
        b=BA6/GTEahDC+avZfk46YhJIjPLjEYWNkDoIWQbEuARue0kZhb9P1DT8z/KcwmMESqx
         dfZzDadoPUP/aO4Ag2oW6IjymRv5iFBWO47H+IXhHegkBGxgLqJvZGrPBFWdFklE4Prq
         3P5jsU4kwQcwpkHGiJW0LN9k8ZKvqtqjzjcc5FbuvLND8c837QyJm7SPyffh+AhBUVbW
         8xG539n5nRhhQH9aiK8V7XBbndGyCCkeyweDuZRIVL2Ao2EGZkNZn4udGEp6Qt71BMKS
         g7+On81ydGvqRZP/C6yCzK8vaeNOuPsGAwasHCQQQlWpBnNmOL7I0Gfq07WDkX58fl65
         o2qQ==
X-Gm-Message-State: APjAAAVw7vUERouSYTS14N7BMYtaZP6HNECDWU5p4H6ShAzYNiYjEcZS
        olUiSSE5tpTjV+gWU0f8UgvAh7rZ
X-Google-Smtp-Source: APXvYqzJjOcsoswij+KdbfGhFiKC3gsjjVnMtMYfm+7yyKXzMkfrRF9sKNJ25nwToDS4XpoRRbarhQ==
X-Received: by 2002:a17:902:44f:: with SMTP id 73mr23807ple.192.1565796343910;
        Wed, 14 Aug 2019 08:25:43 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id e17sm294437pjt.6.2019.08.14.08.25.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Aug 2019 08:25:43 -0700 (PDT)
Subject: Re: [PATCH] scsi: qla2xxx: replace snprintf with strscpy
To:     Wang Xiayang <xywang.sjtu@sjtu.edu.cn>
Cc:     qla2xxx-upstream@qlogic.com, linux-scsi@vger.kernel.org
References: <20190725054653.30729-1-xywang.sjtu@sjtu.edu.cn>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <80cad672-d727-8e96-4e2c-ffc33ca6ff55@acm.org>
Date:   Wed, 14 Aug 2019 08:25:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190725054653.30729-1-xywang.sjtu@sjtu.edu.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/24/19 10:46 PM, Wang Xiayang wrote:
> As commit a86028f8e3ee ("staging: most: sound: replace snprintf
> with strscpy") suggested, using snprintf without a format specifier
> is potentially risky if a0->vendor_name or a0->vendor_pn mistakenly
> contain format specifiers. In addition, as compared in the
> implementation, strscpy looks more light-weight than snprintf.
> 
> This patch does not incur any functional change.
> 
> Signed-off-by: Wang Xiayang <xywang.sjtu@sjtu.edu.cn>
> ---
>   drivers/scsi/qla2xxx/qla_init.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
> index 4059655639d9..068b54218ff4 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -3461,12 +3461,12 @@ static void qla2xxx_print_sfp_info(struct scsi_qla_host *vha)
>   	int leftover, len;
>   
>   	memset(str, 0, STR_LEN);
> -	snprintf(str, SFF_VEN_NAME_LEN+1, a0->vendor_name);
> +	strscpy(str, a0->vendor_name, SFF_VEN_NAME_LEN+1);
>   	ql_dbg(ql_dbg_init, vha, 0x015a,
>   	    "SFP MFG Name: %s\n", str);
>   
>   	memset(str, 0, STR_LEN);
> -	snprintf(str, SFF_PART_NAME_LEN+1, a0->vendor_pn);
> +	strscpy(str, a0->vendor_pn, SFF_PART_NAME_LEN+1);
>   	ql_dbg(ql_dbg_init, vha, 0x015c,
>   	    "SFP Part Name: %s\n", str);

 From qla_def.h:

/* Refer to SNIA SFF 8247 */
struct sff_8247_a0 {
         [ ... ]
	u8 vendor_name[SFF_VEN_NAME_LEN];	/* offset 20/14h */
	u8 vendor_pn[SFF_PART_NAME_LEN];	/* part number */

So I think that using SFF_PART_NAME_LEN+1 as length limit is wrong.

Himanshu, do you perhaps know whether or not the vendor_name and 
vendor_pn arrays should be '\0'-terminated in struct sff_8247_a0?

Thanks,

Bart.
