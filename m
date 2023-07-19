Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7D9FC001B0
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Jul 2023 18:42:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbjGSSmc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Jul 2023 14:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbjGSSm0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jul 2023 14:42:26 -0400
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4672120
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jul 2023 11:42:20 -0700 (PDT)
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1b8ad8383faso57272655ad.0
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jul 2023 11:42:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689792140; x=1692384140;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U+1UR7F2SCotRgiA3pJBlsfkUEKP8pOAFKDeCwUDRgc=;
        b=ksjps19aAf1pHNhbd+U10ioR1khTNUpznUGf2vTOdWH0j0iOGjdkDmQ723md9zEYwK
         2w8FuQh9gwrexAbH6bQoKoGroH7X/kcCAmd9hDznkZUpdqPCI6FFNVj2Wf6baOI50nx0
         VwHDumwr74iUaVAYvS1ozujKXkd1bfuJ7oDok/sBqQ2ad+3YQdSZoVpKtthZI126/xVb
         fuzo84M0XWwiZ9tI2xtzyuMUc7PgbLmozhCGK3uSX5HMfjqg3hZcP8ThDMNfObmQgVBR
         N24ZJAefDIGGvc88tP6kewadCBfps8tX3WUJGMlFJMG8GoLA3l6WYlBvlboME8AReCH9
         PXDQ==
X-Gm-Message-State: ABy/qLZHXpFNJZuNZl7lc3jnHvBwIDm1n0hd3EEnQKX2A1oUILrVPPg4
        pzaCiyqojityfF+DRiCPJ9Q=
X-Google-Smtp-Source: APBJJlFAJI5nD59vVoWPZCZe36UP0189vnDwXEiPrfAjOJ2koCLGHl4+7MC7xbUVYeBZJPwcVmFezQ==
X-Received: by 2002:a17:902:9a83:b0:1b8:b285:ec96 with SMTP id w3-20020a1709029a8300b001b8b285ec96mr16927231plp.23.1689792139686;
        Wed, 19 Jul 2023 11:42:19 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:a2ab:183f:c76c:d30d? ([2620:15c:211:201:a2ab:183f:c76c:d30d])
        by smtp.gmail.com with ESMTPSA id g7-20020a170902740700b001aadd0d7364sm4316471pll.83.2023.07.19.11.42.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jul 2023 11:42:19 -0700 (PDT)
Message-ID: <6e727687-fb78-30d1-5f7e-bbc843fe4ad1@acm.org>
Date:   Wed, 19 Jul 2023 11:42:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v10 08/33] scsi: Use separate buf for START_STOP in
 sd_spinup_disk
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        john.g.garry@oracle.com, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20230714213419.95492-1-michael.christie@oracle.com>
 <20230714213419.95492-9-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230714213419.95492-9-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/14/23 14:33, Mike Christie wrote:
> We currently re-use the cmd buffer for the TUR and START_STOP commands
> which requires us to reset the buffer when retrying. This has us use
> separate buffers for the 2 commands so we can make them const and I think
> it makes it easier to handle for retries but does not add too much extra
> to the stack use.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

