Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FE10C54EB4
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Jan 2023 19:34:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbjAXTep (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Jan 2023 14:34:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233149AbjAXTeb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2023 14:34:31 -0500
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C8D7B440;
        Tue, 24 Jan 2023 11:34:17 -0800 (PST)
Received: by mail-pj1-f54.google.com with SMTP id z1-20020a17090a66c100b00226f05b9595so15076984pjl.0;
        Tue, 24 Jan 2023 11:34:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KGu7yck6Sa5Ksbn+4OpWAFiSwPP176/mxa8gUHqZqyI=;
        b=Bce2ING39w0wjN6uAyXatj4bYiG9FaGKBM0jNgILFxkjgUoJZBDM+F2g2X0sMk1tTe
         8lofzVfx2oLHB/CjfiJREIMrnBqoITsINRgMK+icUg9dzknx70ERPP6eqr17FxSKV7ua
         /C8tHss77g82kSd+pksXoLfDOdXDPhhjgyck3YiPvfzkPOPLiaOwFIJWH+cCnIaQnhwY
         BplFpgUIx/3d+KCTzxwFTKaFSGL7kRjd1lMFe1DhFQCYo8wEM3TnZkshNdI2fcRoCKP2
         Vwhla9fyqiQJGGl1Sri1VfSQsZtJMFp8AVehqLZmU9naVzOeHle0gzpvwILmTrcxxiSf
         w36w==
X-Gm-Message-State: AO0yUKWQFSXSWhmv96ULoHx1q95hHhtz86bi1OMtox9nvgAN98YbLZJr
        sWAkVBx7xbvB96xJVrkX+CI=
X-Google-Smtp-Source: AK7set8XbDa2VAm+4M91PjlsLQRleJRFFfMPa/DTNTqxbe5aq36bIrzFpfwTd+7jLIXnWuVL/CASZg==
X-Received: by 2002:a17:90b:1b03:b0:22b:efa5:d05 with SMTP id nu3-20020a17090b1b0300b0022befa50d05mr3289605pjb.40.1674588856760;
        Tue, 24 Jan 2023 11:34:16 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:c69a:cf2c:dc2d:7829? ([2620:15c:211:201:c69a:cf2c:dc2d:7829])
        by smtp.gmail.com with ESMTPSA id f6-20020a637546000000b004d4547cc0f7sm1756884pgn.18.2023.01.24.11.34.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jan 2023 11:34:16 -0800 (PST)
Message-ID: <0b161eb1-5c55-f969-9bbb-887f3a9a4302@acm.org>
Date:   Tue, 24 Jan 2023 11:34:14 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v3 05/18] scsi: support retrieving sub-pages of mode pages
Content-Language: en-US
To:     Niklas Cassel <niklas.cassel@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20230124190308.127318-1-niklas.cassel@wdc.com>
 <20230124190308.127318-6-niklas.cassel@wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230124190308.127318-6-niklas.cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/24/23 11:02, Niklas Cassel wrote:
> From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> 
> Allow scsi_mode_sense() to retrieve sub-pages of mode pages by adding
> the subpage argument. Change all the current caller sites to specify
> the subpage 0.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
