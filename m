Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 080DBEB64D0
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jun 2023 14:06:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242823AbjFMOGG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jun 2023 10:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242743AbjFMOFK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jun 2023 10:05:10 -0400
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F4326AF;
        Tue, 13 Jun 2023 07:04:37 -0700 (PDT)
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1b3dd3ca7adso13351645ad.3;
        Tue, 13 Jun 2023 07:04:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686665033; x=1689257033;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q/9A+Z+TgBVYDrCZ3bWX8OfhcX85V5t+oh8ZXWenYUo=;
        b=BzKh0FjnEJTXb/bwkQl+2eDHw1mtrOfo6L9WvRpXa01jcyoxncTfdgz45Us6dNGpGY
         NV6UyjAgmWJ9qSaOV8g93z+MTNaPBRw+S2fO4I4GnQoIagXxK1TM7tJTSqAFaLR0vCwa
         ZW0w60yGNfvwM4yhk2PA2as9Uw3Nl++L8ipR1EIKpNsjVe18rN+5zCvXxqN+k9cThzWY
         B/aeUWJ/+hsSdXMhae7momTg999dya5tOoudTizbSOpagsFNkPgXGEEBRfz3eoIy1r4Q
         Vs5ruBrLKMzJwJq6e/OG+OZjVFYEVIlpG0jy2hbdKSRVt20edlgVjRIvpE3AqK1DT66V
         mFRg==
X-Gm-Message-State: AC+VfDzDf0j7bi5q7UHIhPkPjmfk1nI5ABrsgCbyftllrS+XiaicUNHq
        LWOcLrzmI8ZBn6Xulbt6jko=
X-Google-Smtp-Source: ACHHUZ4rfrN+RJYRgVtgWDG7pEqn3MZ/a3YF3vqreAxqV1jZNhQ+2PJ6IE1h+2ZcMlIuYY+zii+0PA==
X-Received: by 2002:a17:902:f687:b0:1a6:6fe3:df8d with SMTP id l7-20020a170902f68700b001a66fe3df8dmr13407929plg.8.1686665032684;
        Tue, 13 Jun 2023 07:03:52 -0700 (PDT)
Received: from [192.168.3.219] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id j13-20020a170902da8d00b001b06c106844sm10324024plx.151.2023.06.13.07.03.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jun 2023 07:03:52 -0700 (PDT)
Message-ID: <488689a7-e68e-bd68-2cb2-f2f67baa176d@acm.org>
Date:   Tue, 13 Jun 2023 07:03:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v5] scsi: ufs: wb: Add explicit flush_threshold sysfs
 attribute
Content-Language: en-US
To:     Lu Hongfei <luhongfei@vivo.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Daniil Lunev <dlunev@chromium.org>,
        Bean Huo <beanhuo@micron.com>,
        Peter Wang <peter.wang@mediatek.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER" 
        <linux-scsi@vger.kernel.org>
Cc:     opensource.kernel@vivo.com
References: <20230613022240.16595-1-luhongfei@vivo.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230613022240.16595-1-luhongfei@vivo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/12/23 19:22, Lu Hongfei wrote:
> +	/* The range of values for wb_flush_threshold is (0,10] */
> +	if (wb_flush_threshold > UFS_WB_BUF_REMAIN_PERCENT(100) ||
> +		wb_flush_threshold == 0) {

For future patches, please align split lines as is done elsewhere in the 
kernel. This means aligning "wb_flush_threshold == 0" with 
"wb_flush_threshold > ...". Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
