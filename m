Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B633E7F151
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Sep 2023 01:52:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233769AbjI0BwS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Sep 2023 21:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbjI0BuR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Sep 2023 21:50:17 -0400
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 510AE1F9CE;
        Tue, 26 Sep 2023 16:30:54 -0700 (PDT)
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-3ae5ee80c0dso713028b6e.3;
        Tue, 26 Sep 2023 16:30:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695771053; x=1696375853;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qpqjxGv637godH0bTfk5Je3fLHGyFwQagbqNm+b/J+g=;
        b=cB7uCMLQV5fN0R5THJRxQYWgme5LUCzvntv6CW/R3TSiwcg7NLB/AatKaF3xShrEUy
         kmy+epTew2VpHyly1wdrMxn3AG3udJaoawuCqtWZ0H+XBnBQrrgFP5XkYmefA3wTdlIi
         wti2lOc0a9MLMbmpBEDO8neq8zRASNaBikJxp5PV0dSJcs5tx3BuZ9drzd0SJCjBRNwM
         xwh3UxUX7hRFYk7SN3UHsz6A5AGdgdYg3ykAh5DagOiGdZj3LtTNIrgOHurIwNa9KSQ5
         FG/1+2jZOmNJ1qdhYIEdQcS+x3ZF8QtRU+ghW/7vX9969cKmyTd8ilSTTRrGZlKCRPiK
         1R5A==
X-Gm-Message-State: AOJu0YzpwzrIbIZZSfF9bS7sjaLgWlsszX/dCr92F/tvsmoZo+5bIwQz
        oJF28zFYvUbqNFh3ceOuSHA=
X-Google-Smtp-Source: AGHT+IFWLP23MZC43ocbQN2sWQYB3tQQL000/vwi3GFjKFnjygXIOnm9cPVO85UtAkeHFk0cKaq1qQ==
X-Received: by 2002:aca:2101:0:b0:3a3:95f9:c99b with SMTP id 1-20020aca2101000000b003a395f9c99bmr506927oiz.35.1695771053282;
        Tue, 26 Sep 2023 16:30:53 -0700 (PDT)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net. [73.231.117.72])
        by smtp.gmail.com with ESMTPSA id fm1-20020a056a002f8100b00679a4b56e41sm10560926pfb.43.2023.09.26.16.30.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Sep 2023 16:30:52 -0700 (PDT)
Message-ID: <6a47b269-6481-40c3-8b32-90d7d6985401@acm.org>
Date:   Tue, 26 Sep 2023 16:30:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 09/23] scsi: sd: Do not issue commands to suspended
 disks on shutdown
Content-Language: en-US
From:   Bart Van Assche <bvanassche@acm.org>
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
 <20230923002932.1082348-10-dlemoal@kernel.org>
 <ca064bd3-2496-4d79-b68c-beff775228c3@acm.org>
 <2b3ceca3-9e1c-7266-1f60-19e5f032c3e3@kernel.org>
 <8acc0983-79f2-4704-9963-e8e7f2dc03ed@acm.org>
In-Reply-To: <8acc0983-79f2-4704-9963-e8e7f2dc03ed@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/26/23 07:51, Bart Van Assche wrote:
> On 9/25/23 23:00, Damien Le Moal wrote:
>> But as mentioned before, these are PM internal and should not be 
>> touched without the device lock held. So the little "suspended" flag 
>> simplifies things a lot.
> 
> Hmm ... I think there is plenty of code in the Linux kernel that reads
> variables that can be modified by another thread without using locking.
> Hasn't the READ_ONCE() macro been introduced for this purpose? Anyway, I
> don't have a strong opinion about whether to read directly from the
> scsi_device->power data structure or whether to introduce the new
> 'suspended' member.

(replying to my own email)

I think we need the new 'suspended' flag. device_resume(), a function
executed during system-wide resume, executes the following code whether
or not resuming succeeds:

	dev->power.is_suspended = false;

Bart.

