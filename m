Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB9F9C4360C
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 21:26:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B27D261288
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 21:26:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346286AbhELVXs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 May 2021 17:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386928AbhELUWw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 May 2021 16:22:52 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B7BC06175F;
        Wed, 12 May 2021 13:21:42 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id r11so4532479edt.13;
        Wed, 12 May 2021 13:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=N4ZAlOgDW9ujpwjPHQr8aGCrSs+JV5Nyhyk5LQI3HKI=;
        b=ru+/i/5bgX9E14YIfBAn6to/vAz91/xUZWO0XKEFx/X+sBzOOoeqikp5lakJoAKrPv
         nDl6zja3All4C2a1JP400GptP9ZmpUqL7LrFqoHV//LUWWpyU6IAuLDpfFEFz9VWjUl1
         MxUyjalMppKimCcBOzUkGlorMXqV4XouSk3jr/7+VzFjrS/pYDDvQr//VS94WUCDCn+O
         tanYrliRgd9U0N8wB9uKX9wwE9EHh8UxzFbWI13OzalrWQTMSW2iSLAjSpA2GhBUs4Kp
         0EzQ+sGomgtyaxA1e4QLc2sY1pXAemkkKSygNRsWk4YY8/r+05oeQb+M5HJDoWlaCsHk
         aOwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=N4ZAlOgDW9ujpwjPHQr8aGCrSs+JV5Nyhyk5LQI3HKI=;
        b=C5P2CW8GHaVlAGcdiVPlXZl5dELN8yjY7H5XuQGHXA9QsiWGgUgC/MIgBnh3VVyqMa
         /gPRQtyMdrjlN5oVhI3CVhQbNxFRJqgc4nSBExwTKat/98fyvUFswAI7Bg3Qv7NGS5hb
         yn9OlYu3XleghCtippKzXTHmHBvnXj+6O2ZvYGTODry/n1G/szwF+GVIk5baw2+o6js7
         ct4tMxDgTF4o7pbZpy7V6pPFiu+k8PirZ6uB/9NlM2wrRURKehPf4lH4sHyr77WwmcUl
         kLlEe05y8SG88NP7DlteAJG+shwE8DFKyfcPLhd8/gNB04h7jcTvqvbDycju4v2L1rs8
         nc9w==
X-Gm-Message-State: AOAM531TywbA8NM2uT4RWv49sYLCTIR8avtwzJ1I9UP7NhBPnnQ4B5UP
        y0inGaeqLn1hpF6T/3yd4osi/5zHcPM=
X-Google-Smtp-Source: ABdhPJy2MoFIbMXHK5sH71DILt+6PkNvgj1tDU2/ZAEvcuIFM+3oPHITB8QNN7PbBDDu475yC4iVEw==
X-Received: by 2002:aa7:cb10:: with SMTP id s16mr45722585edt.313.1620850900900;
        Wed, 12 May 2021 13:21:40 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bec5d.dynamic.kabel-deutschland.de. [95.91.236.93])
        by smtp.googlemail.com with ESMTPSA id z9sm659159edb.51.2021.05.12.13.21.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 13:21:40 -0700 (PDT)
Message-ID: <cb32c4e786ac73681b80b8af556543f08f076687.camel@gmail.com>
Subject: Re: [PATCH v5 1/2] scsi: ufs: Introduce hba performance monitor
 sysfs nodes
From:   Bean Huo <huobean@gmail.com>
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
Date:   Wed, 12 May 2021 22:21:38 +0200
In-Reply-To: <1619058521-35307-2-git-send-email-cang@codeaurora.org>
References: <1619058521-35307-1-git-send-email-cang@codeaurora.org>
         <1619058521-35307-2-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-04-21 at 19:28 -0700, Can Guo wrote:
> +
> 
> +static DEVICE_ATTR_RW(monitor_enable);
> 
> +static DEVICE_ATTR_RW(monitor_chunk_size);
> 
> +static DEVICE_ATTR_RO(read_total_sectors);
> 
> +static DEVICE_ATTR_RO(read_total_busy);
> 
> +static DEVICE_ATTR_RO(read_nr_requests);
> 
> +static DEVICE_ATTR_RO(read_req_latency_avg);
> 
> +static DEVICE_ATTR_RO(read_req_latency_max);
> 
> +static DEVICE_ATTR_RO(read_req_latency_min);
> 
> +static DEVICE_ATTR_RO(read_req_latency_sum);
> 
> +static DEVICE_ATTR_RO(write_total_sectors);
> 
> +static DEVICE_ATTR_RO(write_total_busy);
> 
> +static DEVICE_ATTR_RO(write_nr_requests);
> 
> +static DEVICE_ATTR_RO(write_req_latency_avg);
> 
> +static DEVICE_ATTR_RO(write_req_latency_max);
> 
> +static DEVICE_ATTR_RO(write_req_latency_min);
> 
> +static DEVICE_ATTR_RO(write_req_latency_sum);

Can,

I like this series of patches, which can help me monitor UFS
performance online. I have a suggestion,  how do you think that we add
this to ufs-debugfs. Then we don't need to poll each parameter one by
one, just one interface.

Bean

