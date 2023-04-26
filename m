Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6BF1C77B60
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Apr 2023 22:04:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239840AbjDZWEw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Apr 2023 18:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231915AbjDZWEv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Apr 2023 18:04:51 -0400
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C31BF2
        for <linux-scsi@vger.kernel.org>; Wed, 26 Apr 2023 15:04:50 -0700 (PDT)
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-51f6461af24so5889320a12.2
        for <linux-scsi@vger.kernel.org>; Wed, 26 Apr 2023 15:04:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682546689; x=1685138689;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uwMKQkVE3d4LDdJESE/TV3C06Mi9CK15ykfytFUm/bg=;
        b=X80sTPU2cfVGcvE4u7Yv7urhaESoH6GI4Wbd8T7tk2/rB3mjvgTaWbiOY7YS3gtTt1
         cqGsrgOt5jpEdWaZDxsWh0OersoNv9N+tIgswWD2+VUUwMGTPL+kbOsIeILYoGJyc1LJ
         5NTMgj03g+95SjCjJqAzcE93JBhaZqmyryLEcvJmJV/2eZYCFP4ozakONjjenM/i6pcz
         /gdlwxyr2ebflK6LQJrp9/EMxOgBIlO3OfIIzMqmWveAhtq3mLb96OWDsuHikT+LjznO
         Z5lIRU0PjHupVp65V0ZVCljog7Y4zsCqehOQmhQ8icua1OKgL+ntq3reBDoCFvlus9wc
         UrhQ==
X-Gm-Message-State: AAQBX9evYLNogCSkRgXEjtv5SY2bOZVtQ/5toQTB8fOssfoN21ioQQdm
        tIIrgK1t9nPIiEr7c9Ip3BY=
X-Google-Smtp-Source: AKy350Zy6zicRaR/6hKvN7eCbsUzT1s1Bo84b4jLsSsKcLetWhqHMRVre/WPd4Vz78c5ioyJ3TIZxA==
X-Received: by 2002:a17:90a:9707:b0:247:8b7d:743f with SMTP id x7-20020a17090a970700b002478b7d743fmr21469056pjo.21.1682546689518;
        Wed, 26 Apr 2023 15:04:49 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:d11f:e31d:1c46:ebd2? ([2620:15c:211:201:d11f:e31d:1c46:ebd2])
        by smtp.gmail.com with ESMTPSA id gt17-20020a17090af2d100b0023a84911df2sm10193466pjb.7.2023.04.26.15.04.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Apr 2023 15:04:48 -0700 (PDT)
Message-ID: <ffb1051c-cd1d-622b-4caf-0733facd475e@acm.org>
Date:   Wed, 26 Apr 2023 15:04:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH 2/4] scsi: ufs: Fix handling of lrbp->cmd
Content-Language: en-US
To:     Bean Huo <huobean@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Santosh Y <santoshsy@gmail.com>
References: <20230425232954.1229916-1-bvanassche@acm.org>
 <20230425232954.1229916-3-bvanassche@acm.org>
 <59bdf91413e75b96c67480823507caaf22ae24cd.camel@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <59bdf91413e75b96c67480823507caaf22ae24cd.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/26/23 05:48, Bean Huo wrote:
> lrbp->cmd will always be non-NULL after this slot in the queue has been
> used once?

Hi Bean,

The reserved slot is used for device commands, UPIU commands and also for
RPMB commands. The other slots are used for SCSI commands. So lrbp->cmd
could be set after the lrbp array has been allocated instead of when a
command is queued. I haven't done that because in the near future I would
like to remove the lrbp->cmd pointer. This is possible by setting the
.cmd_size member in the SCSI host template to sizeof(struct ufshcd_lrb).
Setting that member causes the SCSI core to allocate additional memory
at the end of each struct scsi_cmnd instance.

Thanks,

Bart.
