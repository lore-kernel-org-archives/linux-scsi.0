Return-Path: <SRS0=1vX0=6G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F0D9C55185
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 23:11:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48D0F2076E
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 23:11:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbgDVXLr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 19:11:47 -0400
Received: from mail-pg1-f172.google.com ([209.85.215.172]:39872 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbgDVXLr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2020 19:11:47 -0400
Received: by mail-pg1-f172.google.com with SMTP id o10so1884524pgb.6;
        Wed, 22 Apr 2020 16:11:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VgodplEC7ajdBNrlyzFg2CSQ/6ap7hDD5IEkP8m53O8=;
        b=Q8cDJxo2QBrUfbAjK677orgbMGqof38VEBCj5rWdoVLR0cXLVpNLKVisqj3zwXy3kZ
         jgXXD9DYHdfR5vpbQg/8pYPbc6ohqnhIaIRWMl1EetVAjR2Nx6Of/Izb+HJ8mi5tPqub
         AR4puc+2lsQomhDHdB1tmz+tNceTduMKHgPhu856o0bfbvVAI6bh5cJCnaSXztpMo2PW
         FKWZM5l5ZcLgN/OwQr2y9BZMb6f36izu8sgagbqatAs+45O07Jb4CsdK3zP1kxZiNMzc
         kZhBT9zMocPV09q4tR9mPFglGJUk24oQY4hc7PLaYdf2HKlv14y9MJF5qIjr8i6YS8gA
         aWJA==
X-Gm-Message-State: AGi0PuaeWToxZrTJlIvYcAL82gDU9FimFDVo6drZfFpoUjcEHX7AKyPZ
        cu6DwZ3H6pp6q25/L11kNpFxq1ZtdbA=
X-Google-Smtp-Source: APiQypL2lsr0pC3V9CassJAzt/eBy0ApidEdFXosKyUCf5QRzZT8s9N/aX1FPBozJ61x0A0MRnEB9A==
X-Received: by 2002:a62:dd4e:: with SMTP id w75mr903817pff.221.1587597104550;
        Wed, 22 Apr 2020 16:11:44 -0700 (PDT)
Received: from [100.124.12.67] ([104.129.198.228])
        by smtp.gmail.com with ESMTPSA id b1sm548368pfa.202.2020.04.22.16.11.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2020 16:11:43 -0700 (PDT)
Subject: Re: [PATCH v2 1/5] scsi; ufs: add device descriptor for Host
 Performance Booster
To:     huobean@gmail.com, alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, tomas.winkler@intel.com, cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200416203126.1210-1-beanhuo@micron.com>
 <20200416203126.1210-2-beanhuo@micron.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <6e092ac1-7e7d-3f12-8c81-b88369f1f621@acm.org>
Date:   Wed, 22 Apr 2020 16:11:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200416203126.1210-2-beanhuo@micron.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/16/20 1:31 PM, huobean@gmail.com wrote:
> +	if (desc_buf[DEVICE_DESC_PARAM_UFS_FEAT] & 0x80) {

Please introduce a symbolic name instead of using the number 0x80 directly.

> +		hba->dev_info.hpb_control_mode =
> +			desc_buf[DEVICE_DESC_PARAM_HPB_CTRL_MODE];
> +		hba->dev_info.hpb_ver =
> +			(u16) (desc_buf[DEVICE_DESC_PARAM_HPB_VER] << 8) |
> +			desc_buf[DEVICE_DESC_PARAM_HPB_VER + 1];

Please use get_unaligned_be16() instead of open-coding it.

Thanks,

Bart.
