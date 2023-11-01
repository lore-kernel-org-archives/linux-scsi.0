Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 128DEC4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Nov 2023 17:07:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344391AbjKARHh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Nov 2023 13:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231974AbjKARHg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Nov 2023 13:07:36 -0400
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD27A6;
        Wed,  1 Nov 2023 10:07:34 -0700 (PDT)
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1c434c33ec0so56528565ad.3;
        Wed, 01 Nov 2023 10:07:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698858454; x=1699463254;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M+sNYo+81K509h19TdC0judu7XiMCvCmL9yTeAeh1N0=;
        b=ty3nUvPBVEthjThwugAOIgg59HqNOinNwZvm2LMNaavOJhk629QgikgTe/LUYr+W3h
         M4h/c206i1lPIXse6BG5Yoo/n0ZbNyWco4nkhhA0lAzT1n3V1XT4PGbYkKJOb76oX7qx
         wAP1FsDKk6kWES7dCyWD3zkLCfNTzhtH9tUOyk7JQ+3chT1HpA6BSshI340HbY30LvRs
         4Azp6x9v1IkgmLQV6VkL0yQP4ctFSQ5JvkJr4TdqIft0OdcoZKXsMWKugAo71bYlMalq
         M1w5VdzcOPgZni1+1wl7AwO4sB+1rmtPShMYETlvuexXQvaGIkXI6xnTWGjIkay1/PI1
         cGcw==
X-Gm-Message-State: AOJu0YyLxfj1LCwvPtM7reTsOD1gtMoCAqTBX746KZBDGXYIMOOQtz4r
        pOe1g7aMyxVt3yM5puLkgvc=
X-Google-Smtp-Source: AGHT+IEp2rWzcRRdXU+9soFccrPleoTrHw9s7osQ0AjFyBaST6N7rIyat/KkLI7XLa6rNWWyxUrwXQ==
X-Received: by 2002:a17:903:294b:b0:1cc:641a:9bf1 with SMTP id li11-20020a170903294b00b001cc641a9bf1mr5042840plb.5.1698858453773;
        Wed, 01 Nov 2023 10:07:33 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:2312:f48f:8e12:6623? ([2620:15c:211:201:2312:f48f:8e12:6623])
        by smtp.gmail.com with ESMTPSA id iz15-20020a170902ef8f00b001bbb7af4963sm1573118plb.68.2023.11.01.10.07.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Nov 2023 10:07:33 -0700 (PDT)
Message-ID: <ebdbb2eb-0339-40a7-9697-6148fcda81a2@acm.org>
Date:   Wed, 1 Nov 2023 10:07:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: ufs: ufs-sysfs: Expose UFS power info
Content-Language: en-US
To:     Can Guo <quic_cang@quicinc.com>, mani@kernel.org,
        stanley.chu@mediatek.com, adrian.hunter@intel.com,
        beanhuo@micron.com, avri.altman@wdc.com, junwoo80.lee@samsung.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Lu Hongfei <luhongfei@vivo.com>,
        open list <linux-kernel@vger.kernel.org>
References: <1698811243-5024-1-git-send-email-quic_cang@quicinc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1698811243-5024-1-git-send-email-quic_cang@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/31/23 21:00, Can Guo wrote:
> +	return sysfs_emit(buf, "%s\n", hba->pwr_info.hs_rate ?
> +				       ufshcd_ufs_hs_gear_to_string(hba->pwr_info.gear_rx) :
> +				       ufshcd_ufs_pwm_gear_to_string(hba->pwr_info.gear_rx));
> +}

A nit: this is not how kernel code should be indented. I think that
"ufshcd_..." should be aligned with "buf,".

Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
