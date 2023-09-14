Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1FB1EEAA5D
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Sep 2023 17:29:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233045AbjINR3K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Sep 2023 13:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbjINR3J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Sep 2023 13:29:09 -0400
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 898AE1FF0;
        Thu, 14 Sep 2023 10:29:05 -0700 (PDT)
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1c3d6d88231so10451705ad.0;
        Thu, 14 Sep 2023 10:29:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694712545; x=1695317345;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m6DLKsW8i0nk7aHfr9VUWBKV1qwJQQArv0YzYEa+Kyg=;
        b=hQLpZnBW0EuehnfIeJ1ZsAzQvHCbU0LAZUuE5a3yksP3w/4XVkIu0bqV/LwtprUhWH
         OpTnbX0qZ3WKU7pyvNwaFXTkEbN3cEoip7cd+8Vp8vHyRl0qPj0PgmQrK/m/LW3FeR+q
         A5hBbSeihb+nV6U7vEB5tRiT8oafEiyclXu4wVuHuznpYviCALwq2jR2Q9ek+7H7qEZg
         V6AJkpqRZ0qx0f4bIOpsBqCE2LtqdTybuXNwgE2FUw5EU1uCzVS+KVGQBEvMG/zN2RQ3
         G1ih8OVR1xC1nLsY6EB5E/yEqxTBNKXVXldG7Rxh9dvh98Sg90UwYBct35Ot0lFUnrpY
         xcdw==
X-Gm-Message-State: AOJu0YzXGiqKRmC42/m3i+7I+9Qtw5AQY9zwcAu8jMimqidToG61eY2d
        PJvSJgAjflLwcAfv6yJlJ7Q=
X-Google-Smtp-Source: AGHT+IH4UMU7Y/3syt17Ubs5BbbfVifQsmuh5VfzVDynqSgkUv1jYpxvab2bpYEurzgC+izpLGzPvA==
X-Received: by 2002:a17:902:d2c4:b0:1c0:d575:d28 with SMTP id n4-20020a170902d2c400b001c0d5750d28mr6793942plc.50.1694712544914;
        Thu, 14 Sep 2023 10:29:04 -0700 (PDT)
Received: from ?IPV6:2601:647:5f00:5f5:4a46:e57b:bee0:6bc6? ([2601:647:5f00:5f5:4a46:e57b:bee0:6bc6])
        by smtp.gmail.com with ESMTPSA id 13-20020a170902c10d00b001bc445e2497sm1847620pli.79.2023.09.14.10.29.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Sep 2023 10:29:04 -0700 (PDT)
Message-ID: <313c7915-9ed7-4ab2-8657-e6a33329aaab@acm.org>
Date:   Thu, 14 Sep 2023 10:29:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/19] scsi: Remove scsi device no_start_on_resume flag
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
References: <20230911040217.253905-1-dlemoal@kernel.org>
 <20230911040217.253905-9-dlemoal@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230911040217.253905-9-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/10/23 21:02, Damien Le Moal wrote:
> The scsi device flag no_start_on_resume is not set by any scsi low
> level driver. Remove it.

Please consider mentioning that this patch reverts commit
0a8589055936 ("ata,scsi: do not issue START STOP UNIT on resume").

Thanks,

Bart.

