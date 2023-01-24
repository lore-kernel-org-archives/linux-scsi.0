Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 799F4C25B50
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Jan 2023 19:40:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234777AbjAXTkq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Jan 2023 14:40:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234904AbjAXTka (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2023 14:40:30 -0500
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C971A539A4;
        Tue, 24 Jan 2023 11:39:48 -0800 (PST)
Received: by mail-pl1-f174.google.com with SMTP id d3so15757277plr.10;
        Tue, 24 Jan 2023 11:39:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kDL4p+gAqIJ0zf+lHYPlo0w+EgIWocywUmyz2FmL37o=;
        b=bGeBXGxTNSUIf/Pm9Qllr/d5cf+widBnefANri/Rv6fUBMahgY4SpdVMOeIlrR5dck
         PKmeUs9bJSIPUftfuFDs5eyZ9UcXCBz/g71/dAPOkYkdfLyjEwBbTGgpiskhop5mcgUZ
         N/Jpk30TnlDvm9rk/H8JZ3fCi59QnN1UdfuqEa9eDSOQWMCISL88RKfkBCFE7+vKR/b/
         ljFkQ3vH8ZIjSf6+ll0a/R36GjF2BpY3uUPH3jy2dVbnEt0uRxGYK2np7yyZMqZv4zZ3
         MsklvHpYQKwVvVGPOuD53pt2rlLGm045UBAVP3cTsmmrn5CBWNZjnaava9+wHTfgHP2Z
         rwQw==
X-Gm-Message-State: AFqh2krI8oRXLe50nRugJkuEpO2h23mnyL0d5C2Ofhzf7Z1bOF3ikS3S
        8yHljfO/WfHQg8pH8v/pElU=
X-Google-Smtp-Source: AMrXdXtFl9o1fmVUUVbqCkBbZa+BW5Kn4XbP8QQIeUQ1bV0m5IbjlNJyxsctTVV3cv+A0O8/9VZ3iQ==
X-Received: by 2002:a17:90b:80f:b0:220:bad8:b4e7 with SMTP id bk15-20020a17090b080f00b00220bad8b4e7mr30523011pjb.7.1674589188267;
        Tue, 24 Jan 2023 11:39:48 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:c69a:cf2c:dc2d:7829? ([2620:15c:211:201:c69a:cf2c:dc2d:7829])
        by smtp.gmail.com with ESMTPSA id gk1-20020a17090b118100b0022bf2d8d6a8sm1636355pjb.3.2023.01.24.11.39.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jan 2023 11:39:47 -0800 (PST)
Message-ID: <4791cc56-12b1-a294-8e66-f38bfb054613@acm.org>
Date:   Tue, 24 Jan 2023 11:39:45 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v3 07/18] scsi: sd: detect support for command duration
 limits
Content-Language: en-US
To:     Niklas Cassel <niklas.cassel@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20230124190308.127318-1-niklas.cassel@wdc.com>
 <20230124190308.127318-8-niklas.cassel@wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230124190308.127318-8-niklas.cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/24/23 11:02, Niklas Cassel wrote:
> +static const char *sd_cdl_perf_name(u8 val)
> +{
> +	switch (val) {
> +	case 0x00:
> +		return "0";
> +	case 0x01:
> +		return "0.5";
> +	case 0x02:
> +		return "1.0";
> +	case 0x03:
> +		return "1.5";
> +	case 0x04:
> +		return "2.0";
> +	case 0x05:
> +		return "2.5";
> +	case 0x06:
> +		return "3";
> +	case 0x07:
> +		return "4";
> +	case 0x08:
> +		return "5";
> +	case 0x09:
> +		return "8";
> +	case 0x0A:
> +		return "10";
> +	case 0x0B:
> +		return "15";
> +	case 0x0C:
> +		return "20";
> +	default:
> +		return "?";
> +	}
> +}
> +
> +static const char *sd_cdl_policy_name(u8 policy)
> +{
> +	switch (policy) {
> +	case 0x00:
> +		return "complete-earliest";
> +	case 0x01:
> +		return "continue-next-limit";
> +	case 0x02:
> +		return "continue-no-limit";
> +	case 0x0d:
> +		return "complete-unavailable";
> +	case 0x0e:
> +		return "abort-recovery";
> +	case 0x0f:
> +		return "abort";
> +	default:
> +		return "?";
> +	}
> +}

I think that the above two functions can be made shorter by using 
look-up arrays and designated initialzers.

Thanks,

Bart.
