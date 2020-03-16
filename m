Return-Path: <SRS0=cHy8=5B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBB1EC0044D
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 16:23:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBDEF20658
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 16:23:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732106AbgCPQXL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Mar 2020 12:23:11 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46600 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731545AbgCPQXL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Mar 2020 12:23:11 -0400
Received: by mail-pg1-f195.google.com with SMTP id y30so10009638pga.13;
        Mon, 16 Mar 2020 09:23:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MPeWvE1ynYMgmBjcIfuACly8OXPEjkr9woxJje4Vp+k=;
        b=XBYkQiqU/3fNEv0mCJMB0EUs/YMu5UbaEeejNhsuusc5O/lJ6L8TdZ69VkGVQ+wxc0
         kdBTihwaqbW0NF9YpHCa5tKhXwef1NR3wsUteughjthkbi0C8WKHIBCl8zpAGgeEYkWP
         ZjRXiVZD9INGGMD7Ld929aog49WHAMOgpRXctw927p5CPv+nxmX3BXZuw156BzU8znHO
         Dhm9KwqtFDRZ6YWB7AqvoTynrZy9Wv4OIlnMlzJ3PqZT0BO6GbM/vvPBPsklIsj9p3I9
         /XE30Qspn4i92snqLE/Vs62VmBrEBEpIKHLRmZ9471E9rSddCYFlvsSXYtwoN+ri0O2e
         XFPQ==
X-Gm-Message-State: ANhLgQ18ZKuuFCjtj+2ea7d4H0o10WzWrep+zlFMJGtPSJf1xJ0jfN5j
        GRree7OMPf2BFL727I2ec9o=
X-Google-Smtp-Source: ADFU+vteq0ZXl4bflTQr64JEC/RlOF0r9XRD+1FB4C6nIb76oOWRP1WchB6mng5hWY132x5LhHMaqQ==
X-Received: by 2002:a63:921b:: with SMTP id o27mr659097pgd.364.1584375789493;
        Mon, 16 Mar 2020 09:23:09 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:af99:b4cf:6b17:1075? ([2601:647:4000:d7:af99:b4cf:6b17:1075])
        by smtp.gmail.com with ESMTPSA id z20sm66684pge.62.2020.03.16.09.23.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2020 09:23:08 -0700 (PDT)
Subject: Re: [PATCH v6 3/7] scsi: ufs: introduce common delay function
To:     Stanley Chu <stanley.chu@mediatek.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     beanhuo@micron.com, asutoshd@codeaurora.org, cang@codeaurora.org,
        matthias.bgg@gmail.com, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com
References: <20200316085303.20350-1-stanley.chu@mediatek.com>
 <20200316085303.20350-4-stanley.chu@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <fdf91490-9c7d-df34-1c1f-e03e12855378@acm.org>
Date:   Mon, 16 Mar 2020 09:23:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200316085303.20350-4-stanley.chu@mediatek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/16/20 1:52 AM, Stanley Chu wrote:
> +void ufshcd_wait_us(unsigned long us, unsigned long tolerance, bool can_sleep)
> +{
> +	if (!us)
> +		return;
> +
> +	if (us < 10 || !can_sleep)
> +		udelay(us);
> +	else
> +		usleep_range(us, us + tolerance);
> +}
> +EXPORT_SYMBOL_GPL(ufshcd_wait_us);

I don't like this function because I think it makes the UFS code harder 
to read instead of easier. The 'can_sleep' argument is only set by one 
caller which I think is a strong argument to remove that argument again 
and to move the code that depends on that argument from the above 
function into the caller. Additionally, it is not possible to comprehend 
what a ufshcd_wait_us() call does without looking up the function 
definition to see what the meaning of the third argument is.

Please drop this patch.

Thanks,

Bart.

