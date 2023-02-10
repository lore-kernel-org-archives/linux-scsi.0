Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D2A6C636D7
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Feb 2023 17:51:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232545AbjBJRvH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Feb 2023 12:51:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232505AbjBJRvG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Feb 2023 12:51:06 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA7D81CAE3
        for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2023 09:51:04 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id r3so5277874edq.13
        for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2023 09:51:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZZoGnf8hIKo84j4HT8NEM3V52KGtILFDG33e+pT8T+s=;
        b=CH2qdtMco72if9jO/A2PrcywEXRtss0yiGQF3qoVoYDXS/r25dhT5vYP09HOiFnp4n
         V0PIu37iMmoLaCo+l0hnTFtzYLhPOdCChXRFFem1HWQyqJDxBsczcNBA+V7mGaK7kvij
         IbqR04Rwlp4569WUjerrqXUtP/WrcwnhvlzL2p+2b6Muh8acuBJTW8nAkbsMxmUdINLV
         qind4yFZ0bqhHxTjauL+aC9QnsmFo1kr3wCrd/sSkh/oaPHyQU5jzA+1JONr60WaE/uw
         Vw1A8rMNBNjFuBKWfNEqGZCdquYZ7awTSJo4hRmd1Qu/mNEl3uDN5CZJjQrN1AL9YYQC
         5TGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZZoGnf8hIKo84j4HT8NEM3V52KGtILFDG33e+pT8T+s=;
        b=De+h0WyB4brIDDyrp/LpW7CKUGZG0tTRrKNItAfQaoSgHTf/OjId4TjiFaNxTkXWOT
         k/cEToj0GsGc1/jSNhvm06y6R6ywgVxDTup1qjRYu7Bakmm9aG4O47bq28kPes26b1qp
         QmidysikQw6RoVNrnocrN2QPe+Qa2IqX9TeOTb4wonMb6nHu6cYGi06uxgwpkpVuIo7K
         ZugNOD+iSfa61v2s2wdI06hBGqG8exKpy7ByeXaiQOODAVCL/SHXmCbL4k7SdqThv9VK
         dAWCEOf1CqV/Tb2Uluy0bywUm/y0/sTWqqOkqCxA0/6d+4IAZ0MSF4d7Oz2T0DKMWOQ/
         wjIg==
X-Gm-Message-State: AO0yUKV943iy7MDUpvBFFCn4h1YD/BUz5WtVVrce4APkuVu+Wn4Nrof8
        zVdsEus+hpzB+/jmnXuTLYVP1QQue4DW7A==
X-Google-Smtp-Source: AK7set+4BZY1YYMt0ZVFE1JORnqy5Z3mJFPZHhAthgzbg1mDDUU7e4CMMGiBuE7jY/9uTA29RIEpTw==
X-Received: by 2002:a50:8d5e:0:b0:4aa:a9d5:1651 with SMTP id t30-20020a508d5e000000b004aaa9d51651mr17230331edt.21.1676051463490;
        Fri, 10 Feb 2023 09:51:03 -0800 (PST)
Received: from [10.176.235.173] ([137.201.254.41])
        by smtp.gmail.com with ESMTPSA id y4-20020a50ce04000000b004a27046b7a7sm2566761edi.73.2023.02.10.09.51.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Feb 2023 09:51:02 -0800 (PST)
Message-ID: <3bd48609-c194-61a6-7a2e-90b9e0d76fc6@gmail.com>
Date:   Fri, 10 Feb 2023 18:51:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] scsi: ufs: initialize devfreq synchronously
Content-Language: en-US
To:     Adrien Thierry <athierry@redhat.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
References: <20230209211456.54250-1-athierry@redhat.com>
From:   Bean Huo <huobean@gmail.com>
In-Reply-To: <20230209211456.54250-1-athierry@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Adrien,

On 09.02.23 10:14 PM, Adrien Thierry wrote:
>   
> -	/* Initialize devfreq after UFS device is detected */
> -	if (ufshcd_is_clkscaling_supported(hba)) {
> -		memcpy(&hba->clk_scaling.saved_pwr_info.info,
> -			&hba->pwr_info,
> -			sizeof(struct ufs_pa_layer_attr));
> -		hba->clk_scaling.saved_pwr_info.is_valid = true;
> -		hba->clk_scaling.is_allowed = true;
> -
> -		ret = ufshcd_devfreq_init(hba);
> -		if (ret)
> -			goto out;
> -
> -		hba->clk_scaling.is_enabled = true;
> -		ufshcd_init_clk_scaling_sysfs(hba);
> -	}
> -
>   	ufs_bsg_probe(hba);
>   	ufshpb_init(hba);
>   	scsi_scan_host(hba->host);
> @@ -8290,7 +8277,8 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
>   	if (ret) {
>   		pm_runtime_put_sync(hba->dev);
>   		ufshcd_hba_exit(hba);
> -	}
> +	} else
> +		hba->is_initialized = true;

after moving devfreq initialization out of the async routine, still has deadlock issue?


>   }
>   
>   static enum scsi_timeout_action ufshcd_eh_timed_out(struct scsi_cmnd *scmd)
> @@ -9896,12 +9884,30 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>   	 */
>   	ufshcd_set_ufs_dev_active(hba);
>   
> +	/* Initialize devfreq */
> +	if (ufshcd_is_clkscaling_supported(hba)) {
> +		memcpy(&hba->clk_scaling.saved_pwr_info.info,
> +			&hba->pwr_info,
> +			sizeof(struct ufs_pa_layer_attr));
> +		hba->clk_scaling.saved_pwr_info.is_valid = true;
> +		hba->clk_scaling.is_allowed = true;
> +
> +		err = ufshcd_devfreq_init(hba);
> +		if (err)
> +			goto out_power_off;
> +
> +		hba->clk_scaling.is_enabled = true;
> +		ufshcd_init_clk_scaling_sysfs(hba);
> +	}
