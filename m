Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12CA8C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Mar 2022 20:17:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbiCCUSn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Mar 2022 15:18:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbiCCUSl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Mar 2022 15:18:41 -0500
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A4A68F88
        for <linux-scsi@vger.kernel.org>; Thu,  3 Mar 2022 12:17:54 -0800 (PST)
Received: by mail-pj1-f43.google.com with SMTP id 15-20020a17090a098f00b001bef0376d5cso6073277pjo.5
        for <linux-scsi@vger.kernel.org>; Thu, 03 Mar 2022 12:17:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fDzGQq3UyIAGvmr6S9V7iVW58neYr25RNl7QJHQttBg=;
        b=dDlpUkXR1TFKW/0Y3x1YvqL1N3wwP196BM9aTp/udopTGFVm9RikhLnokfXc7ape5E
         xltTNtIsBiCUVy8NnjgUzw1uxUteKz5RHPF3BYho81MHj4SJ+fY84H5rTI077HG+FDXW
         kudAXoJkc4tr+GDhKccoXl8yjAImEImC3adGGLThlugNm7MOxeIIS6DjtEWR0Ir4S/3w
         A/myI3Mmn0VheBpEuQL9KFD13wClZa/2JsNZYT+f/PYtgeEB6ZvqHEMBz+ag2GlyL9/c
         DS+NllZK3ZqOeCY075UQb4WXgSUjuBRXEKo06MGYL/rBeWURQiZoWZjq0ubkJd/WtcfO
         niEw==
X-Gm-Message-State: AOAM530IzKrTEv7mXE5CXHqVF7fNwsELvZFYC5TIID0EgS7uQ2GsjQDI
        eeqFENZGkACdUGhSi3TUkp4=
X-Google-Smtp-Source: ABdhPJyi5BSpHHIcG7GQhE+cbs84YySkOHWvEoaGyrGxl39oRyGR4TuCn7dAQknOWEJu/lhiOx7VsA==
X-Received: by 2002:a17:902:8498:b0:14d:cca6:741 with SMTP id c24-20020a170902849800b0014dcca60741mr37767990plo.16.1646338673634;
        Thu, 03 Mar 2022 12:17:53 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id oo16-20020a17090b1c9000b001b89e05e2b2sm3034941pjb.34.2022.03.03.12.17.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Mar 2022 12:17:52 -0800 (PST)
Message-ID: <8459576c-3f04-14d1-24d2-0edfd814a454@acm.org>
Date:   Thu, 3 Mar 2022 12:17:50 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 08/14] scsi: sd: Optimal I/O size should be a multiple of
 reported granularity
Content-Language: en-US
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Bernhard Sulzer <micraft.b@gmail.com>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
 <20220302053559.32147-9-martin.petersen@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220302053559.32147-9-martin.petersen@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/1/22 21:35, Martin K. Petersen wrote:
> +	if (min_xfer_bytes && opt_xfer_bytes & (min_xfer_bytes - 1)) {
> +		sd_first_printk(KERN_WARNING, sdkp,
> +				"Optimal transfer size %u bytes not a " \
> +				"multiple of preferred minimum block " \
> +				"size (%u bytes)\n",
> +				opt_xfer_bytes, min_xfer_bytes);
> +		return false;
> +	}

Hmm ... what guarantees that min_xfer_bytes is a power of two? Did I perhaps 
overlook something?

Thanks,

Bart.
