Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B7F6C49EA5
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Jun 2021 00:03:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26359613B7
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Jun 2021 00:03:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232850AbhFYAFo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Jun 2021 20:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232300AbhFYAFn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jun 2021 20:05:43 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E47C061756
        for <linux-scsi@vger.kernel.org>; Thu, 24 Jun 2021 17:03:22 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id d9so10521618ioo.2
        for <linux-scsi@vger.kernel.org>; Thu, 24 Jun 2021 17:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LEZS9JoMw09Gm+qlZ0T+jdlSVZAZs/1qwoM/RwRLjrM=;
        b=s5ZNzQ6qQMnv9VwYlmXcHhzXF40YmdnJ7K7D6wheABdRVeQBwYgeKgnyQrkoGM8X+7
         c5DsbEmea4YOSqzSOjlLSpsum7jH1JZmx0GFtHFXwPLqab2rqp+6kGYmwmdsYVnJcsw3
         VmzRzB+gcWylTl6J7J0Z3wYzVEQN308ZfO/rlxLxsruntpRvlINx+s8RrmZppAM3eGdc
         xvr8K5jBVw3XYvbw+6pzm7jp1YcLn8++49+jC80z4GPblhhpw1crEEh4ZpDMICsoXY+d
         7cAPyIfuZRNCqZk+G+yGiLDqTM3ezwr4xGMp1MXOGzvU9J7FIXF9k3lrOpJLyvZEgLLo
         hdDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LEZS9JoMw09Gm+qlZ0T+jdlSVZAZs/1qwoM/RwRLjrM=;
        b=uB3ynkQKAZPjHGWbGP052AkyOqE1Hx1VfRvv6sWav6pRA33xYH1OrKL8Zljf8Px5zl
         qQCEtBzSdgusV1eTsrLcqbYf47BZUuS/E+Nimf3KJUt3djqpia04sFv6+ZM/3gzJmk7g
         /z0BiV7hJL4Lf0pGzf1IP4kQhqrsZOAbe1Q73UcZ92pSlCi2JY8qerbpSvySAssnfPXv
         WaDCP02TiNLFMJ9voUyqNTF4JD2vrnE+WLaHEvvZX+lHbZSdlWEqkdBzjtp9PkeEzWLJ
         YpWpr3p/68iA6yBpyddbv8+4LJeQtiMjfmxdHKTkDgxo1ujswXbrIn/F4XFeaME6qTxm
         3/eQ==
X-Gm-Message-State: AOAM530RI4nuiWmDeaRu8kyerzSvY0XaPM1eUCgryS8nDIl1hc4eMp23
        Le4rUURgOkbcQdTkd76SBY0mWYdv8f7ivw==
X-Google-Smtp-Source: ABdhPJw0/Xp1RCS31vv4Uuz/VFRkmnhtABvsNLYT7rf7Oeh/2rSBt4mtR43QC9ija4UIJbQOPA+GwA==
X-Received: by 2002:a02:666d:: with SMTP id l45mr7207315jaf.0.1624579401949;
        Thu, 24 Jun 2021 17:03:21 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id o7sm2776953ilt.1.2021.06.24.17.03.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 17:03:21 -0700 (PDT)
Subject: Re: [PATCH 1/2] block: remove REQ_OP_SCSI_{IN,OUT}
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20210624123935.479229-1-hch@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3a1d7a24-1ec5-fe6c-9666-ad9fc6611fe5@kernel.dk>
Date:   Thu, 24 Jun 2021 18:03:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210624123935.479229-1-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/24/21 6:39 AM, Christoph Hellwig wrote:
> With the legacy IDE driver gone drivers now use either REQ_OP_DRV_*
> or REQ_OP_SCSI_*, so unify the two concepts of passthrough requests
> into a single one.

Applied, thanks.

-- 
Jens Axboe

