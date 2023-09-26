Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1477EE7E65A
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Sep 2023 18:10:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbjIZSKw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Sep 2023 14:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjIZSKu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Sep 2023 14:10:50 -0400
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D261DBF;
        Tue, 26 Sep 2023 11:10:44 -0700 (PDT)
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-690bd59322dso7008690b3a.3;
        Tue, 26 Sep 2023 11:10:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695751844; x=1696356644;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DqFfp5GipyKXlBy6Nw6mCcsJwNrc5zxPXYNSiS83opg=;
        b=w22YdNhPTPiuWOpkFwsAJH9xCU1TdcFWsLOB/sHrVS2kGv77bmdjDhIdb+O6i2zpeZ
         RQ4ro+YcPpswFYCBtBP+/MBiteVqZaTWck7Xi5rRFCez/DaWSnyCHEWrDibwm5NHC3t3
         kGX1w1bThcQgpbJsbtQCTq/biLVXvyt4NrODgaPaFEcpJOp/3NzcjXk1FswUMVjR8kG8
         1RU6HOo53T78BYjY+D5IzvbEmUPLVSEQILccMRsOQAy9k1BSXOM2bPKo/81rW4iP7LMQ
         ueaiQNk6G1kZHqMxAw07iGk/L9kYdKWyXQKdgjdf8kX6O388Z19J1hBfvV5mJFoC7WvQ
         T28w==
X-Gm-Message-State: AOJu0YzjgUkY/FgYs2x7N1vL2odi8qb1PH4sL/HQZCz6W6qXzjTig6tN
        3XcVy1gHQzm1TQxe1Ph5JWA=
X-Google-Smtp-Source: AGHT+IE574Ss8QW5sE1QdRfucYw4lZxRFrBXh2QF5xU52Wx49gcggIOXRMMuQzcYMNKfyw9Gd/89eA==
X-Received: by 2002:a05:6a20:6a03:b0:14c:910d:972d with SMTP id p3-20020a056a206a0300b0014c910d972dmr9405170pzk.12.1695751844182;
        Tue, 26 Sep 2023 11:10:44 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:a80d:6f65:53d4:d1bf? ([2620:15c:211:201:a80d:6f65:53d4:d1bf])
        by smtp.gmail.com with ESMTPSA id t9-20020a170902e84900b001c631236505sm1766160plg.228.2023.09.26.11.10.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Sep 2023 11:10:43 -0700 (PDT)
Message-ID: <9f3648bd-1c6f-4263-b845-33cd45b3ff4e@acm.org>
Date:   Tue, 26 Sep 2023 11:10:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 06/23] scsi: Do not attempt to rescan suspended devices
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
References: <20230923002932.1082348-1-dlemoal@kernel.org>
 <20230923002932.1082348-7-dlemoal@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230923002932.1082348-7-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/22/23 17:29, Damien Le Moal wrote:
> scsi_rescan_device() takes a scsi device lock before executing a device
> handler and device driver rescan methods. Waiting for the completion of
> any command issued to the device by these methods will thus be done with
> the device lock held. As a result, there is a risk of deadlocking within
> the power management code if scsi_rescan_device() is called to handle a
> device resume with the associated scsi device not yet resumed.
> 
> Avoid such situation by checking that the target scsi device is in the
> running state, that is, fully capable of executing commands, before
> proceeding with the rescan and bailout returning -EWOULDBLOCK otherwise.
> With this error return, the caller can retry rescaning the device after
> a delay.
> 
> The state check is done with the device lock held and is thus safe
> against incoming suspend power management operations.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
