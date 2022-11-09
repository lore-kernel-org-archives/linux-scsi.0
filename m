Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1344AC433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Nov 2022 18:45:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231524AbiKISpx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Nov 2022 13:45:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231535AbiKISpv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2022 13:45:51 -0500
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAAF0CA
        for <linux-scsi@vger.kernel.org>; Wed,  9 Nov 2022 10:45:50 -0800 (PST)
Received: by mail-pg1-f170.google.com with SMTP id s196so16981719pgs.3
        for <linux-scsi@vger.kernel.org>; Wed, 09 Nov 2022 10:45:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PE8fgfdsV2NDsFPYh2OwrW2fNVx4v5zzs4YTVbRg4Sk=;
        b=O85F1OZo64ytyMxhya2n1iemxioKua1E9D4u/Pc8yDJJmodxVXnrXvWHgO0JdijY+4
         XrQF8jkW730OTXMvNMrqlm13Ce2Z++891UrVYHXFNC+jENJyv+zX+WtGAcglA+GoButD
         g2iaBU0Z+o7YuYiPqoKXlYPnmE/seog2BRXHNUVgCoi1ap+8EpuvIx7gwyoLum0TU2G3
         Ay6cVLnaB9eC9ttBcsy+NCT85JrVFlhariEkAn6lHQcWr9wTCshmWSYT8KRYUk5F03uX
         qLA4uU1bF4BeUtDz0weNgF2yLdCzDlz7jg1KxX+bEtETnBxVMWUypfI8jfoSclYHTC1D
         J6kw==
X-Gm-Message-State: ACrzQf03f7/96R7CHe4wW3xfdzlYG5jev44SpbayHrcB0Ya8uGgSICLQ
        ZgwONDN6+t0v178HY2EKjF0=
X-Google-Smtp-Source: AMsMyM5nYkc6FXNE7uZ9JOysd7S2iKHWRCtja6OtIa+X63i3xUOU65+BgYaTzfm0UyflAJvhJHF8/Q==
X-Received: by 2002:a05:6a00:80d:b0:56d:93d8:f42f with SMTP id m13-20020a056a00080d00b0056d93d8f42fmr49971573pfk.14.1668019545544;
        Wed, 09 Nov 2022 10:45:45 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:68b6:5dae:a00c:c3b? ([2620:15c:211:201:68b6:5dae:a00c:c3b])
        by smtp.gmail.com with ESMTPSA id l12-20020a170902f68c00b0017f592a7eccsm9441229plg.298.2022.11.09.10.45.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 10:45:44 -0800 (PST)
Message-ID: <e890a595-811d-bc6f-7225-3fd07bd86da9@acm.org>
Date:   Wed, 9 Nov 2022 10:45:41 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v6 22/35] scsi: Have scsi-ml retry sd_spinup_disk errors
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221104231927.9613-1-michael.christie@oracle.com>
 <20221104231927.9613-23-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221104231927.9613-23-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/4/22 16:19, Mike Christie wrote:
> This simplifies sd_spinup_disk so scsi-ml retries errors for it. Note that
> we retried specifically on a UA and also if scsi_status_is_good returned
> failed which would happen for all check conditions. In this patch we use
> SCMD_FAILURE_STAT_ANY which will trigger for the same conditions as
> when scsi_status_is_good returns false. This will cover all CCs including
> UAs so there is no explicit failures arrary entry for UAs.
> 
> We do not handle the outside loop's retries because we want to sleep
> between tried and we don't support that yet.

tried -> tries? Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

