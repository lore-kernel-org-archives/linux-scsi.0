Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69604E7E643
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Sep 2023 14:51:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234866AbjIZOvf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Sep 2023 10:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjIZOve (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Sep 2023 10:51:34 -0400
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7ADA10E;
        Tue, 26 Sep 2023 07:51:27 -0700 (PDT)
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-690bd8f89baso6902453b3a.2;
        Tue, 26 Sep 2023 07:51:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695739887; x=1696344687;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3BwbRp2F/tb5cUm85OuYg9OjMFBfBS+G/rpfZCqPJh0=;
        b=umVOsSCGenv9SanSqt5Vn1jtsWglGdYT92cAg4RkK4XdO8rK19cqb302CXUv0Dum3/
         lfdlhJoAtdPpKChqk0xbz0nKP90GNzU4YPoMKNyaViYoxMWhzy431qn5u/CzZ66YL1Fy
         yfUspkdfvsSlrOJZRemQutqTVHNnXmz3huGoR9PquDdONWzu5XhI2hwD2xTewYf2QwxY
         jMdYh0ozqMMvkfYvjF3sV7r8xH9KjnHs5J8U5EU6xnHDKRN1Q36u6Ppj93xqATapO+bx
         EONutcSVYgM4CAbDp/QY2EAkomas1Q06hE3nOg7QNef0Bsj1FTsRjAPEs5XdzklmBnIY
         YYDw==
X-Gm-Message-State: AOJu0Yz8mQG+w3npXl06RQIq6SG7oDM+lndSn8jYPWpXnFJ2HnlpAOrQ
        /S7TBbihdyv18xwJdlnzxqU=
X-Google-Smtp-Source: AGHT+IHPiZlm81hL02gpKTxE1NWNnr0uPiUccnw7pTgT6eRWpvETqTVHqKx9A/QBSzcx9VbsIZDhsw==
X-Received: by 2002:a05:6a20:2583:b0:14c:c393:6af with SMTP id k3-20020a056a20258300b0014cc39306afmr8524674pzd.0.1695739886948;
        Tue, 26 Sep 2023 07:51:26 -0700 (PDT)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net. [73.231.117.72])
        by smtp.gmail.com with ESMTPSA id g23-20020aa78197000000b00684ca1b45b9sm10310701pfi.149.2023.09.26.07.51.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Sep 2023 07:51:26 -0700 (PDT)
Message-ID: <8acc0983-79f2-4704-9963-e8e7f2dc03ed@acm.org>
Date:   Tue, 26 Sep 2023 07:51:24 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 09/23] scsi: sd: Do not issue commands to suspended
 disks on shutdown
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
 <20230923002932.1082348-10-dlemoal@kernel.org>
 <ca064bd3-2496-4d79-b68c-beff775228c3@acm.org>
 <2b3ceca3-9e1c-7266-1f60-19e5f032c3e3@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <2b3ceca3-9e1c-7266-1f60-19e5f032c3e3@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/25/23 23:00, Damien Le Moal wrote:
> It seems that you are suggesting that we should use some information 
> from the scsi_device->power structure to detect the suspended 
> state...

Yes, that's indeed what I'm suggesting.

> But as mentioned before, these are PM internal and should not be 
> touched without the device lock held. So the little "suspended" flag 
> simplifies things a lot.

Hmm ... I think there is plenty of code in the Linux kernel that reads
variables that can be modified by another thread without using locking.
Hasn't the READ_ONCE() macro been introduced for this purpose? Anyway, I
don't have a strong opinion about whether to read directly from the
scsi_device->power data structure or whether to introduce the new
'suspended' member.

Thanks,

Bart.
