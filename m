Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E47CC04A94
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Aug 2023 03:25:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232654AbjHNDYO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Aug 2023 23:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232772AbjHNDYD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Aug 2023 23:24:03 -0400
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B17B610C1;
        Sun, 13 Aug 2023 20:24:00 -0700 (PDT)
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-76571dae5feso262218285a.1;
        Sun, 13 Aug 2023 20:24:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691983440; x=1692588240;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z+UU4gR9rUzPq4L20TBiuWiYuC5B8UIizqaLWp9AlzU=;
        b=GnBXT8w9lN8eE+CRQKaPh+4p9IWcP5gGItsA4Q9spj+o20MDupgQeMCPPhGJCJQq1x
         0XUS9kvvEcMs+jaT2qJQtsAPiJNgvZ9tYYx8KUhpGquPKuAj7+zKk6vQBxWqC/IQU/eS
         3zKmr/lF918oaX4mAyohovga2B/Ca/9o4oa9UIh8O7b9TzbcU0JrMgN60LhhGWg4W7UW
         +jAdK9MYGpZlQeLHImRGvcUfx7jYc9rQBoF1vrXqgUH+G/CVyHIs0I4p2/D2QYatL6uj
         V3ptkTT6pQ4PUncwBIJKvcHB4zSMCmWNfkOsD/kqyRdJg0XTyyVELk0IVWIRDmJ+Ya2V
         COYg==
X-Gm-Message-State: AOJu0Yz09G6xpN9hpw2h71ozwcajaEHO7k6cGm92OGAHjJTUe/c7tuaH
        Wzbau/s0x6zOhw8WwXBXluI=
X-Google-Smtp-Source: AGHT+IFm6HmGl84O/ZAWcjqJ1LTOgx4c16VHuOUtrf9fo45hgd1jdIewDMyHZwVqiAPHNdr8KsC0Rw==
X-Received: by 2002:a05:620a:d5c:b0:765:a7c3:69ab with SMTP id o28-20020a05620a0d5c00b00765a7c369abmr7841750qkl.45.1691983439642;
        Sun, 13 Aug 2023 20:23:59 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id a20-20020a62bd14000000b00686e00313easm6851094pff.157.2023.08.13.20.23.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Aug 2023 20:23:59 -0700 (PDT)
Message-ID: <ee3e2f36-1089-f95c-8145-ea91d5912fde@acm.org>
Date:   Sun, 13 Aug 2023 20:23:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.1
Subject: Re: [PATCH v8 3/9] scsi: core: Call .eh_prepare_resubmit() before
 resubmitting
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230811213604.548235-1-bvanassche@acm.org>
 <20230811213604.548235-4-bvanassche@acm.org>
 <29cca660-4e66-002c-7378-2d2df5c79a08@kernel.org>
 <057e08f2-7349-bcad-c21d-11586c059fac@acm.org>
 <02d18d6a-ece5-f8f6-0c6c-4468c86c9ea1@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <02d18d6a-ece5-f8f6-0c6c-4468c86c9ea1@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/13/23 19:41, Damien Le Moal wrote:
> But at the very least, may be mention in the commit message that you also add
> the unit tests associated with the change ?

Hi Damien,

I will mention this in the patch description when I repost this patch.

> Another remark: we'll need this sorting only for devices that are zoned and do
> not need zone write locking. For other cases (most cases in fact), we don't and
> this could have some performance impact (e.g. fast RAID systems). Is there a way
> to have this eh_prepare_resubmit to do nothing for regular devices to avoid that ?

The common case is that all commands passed to the SCSI error handler
are associated with the same ULD. For this case list_sort() iterates
once over the list with commands that have to be resubmitted because
all eh_prepare_resubmit pointers are identical. The code introduced
in the next patch requires O(n^2) time with n the number of commands
passed to the error handler. I expect this time to be smaller than the
time needed to wake up the error handler if n < 100. Waking up the
error handler involves expediting the grace period (call_rcu_hurry())
and a context switch. I expect that these two mechanisms combined will
take more time than the list_sort() call if the number of commands that
failed is below 100. In other words, I don't think that
scsi_call_prepare_resubmit() will slow down error handling measurably
for the cases we care about.

Do you perhaps want me to change the code in the next patch such that
it takes O(n) time instead of O(n^2) time in case no zoned devices are
involved?

Thanks,

Bart.

