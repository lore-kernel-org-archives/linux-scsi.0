Return-Path: <SRS0=THiH=4V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E237C3F2D1
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Mar 2020 16:11:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C9E121775
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Mar 2020 16:11:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729386AbgCDQL5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Mar 2020 11:11:57 -0500
Received: from mail-pl1-f176.google.com ([209.85.214.176]:37271 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbgCDQL5 (ORCPT
        <rfc822;Linux-scsi@vger.kernel.org>); Wed, 4 Mar 2020 11:11:57 -0500
Received: by mail-pl1-f176.google.com with SMTP id b8so1207882plx.4
        for <Linux-scsi@vger.kernel.org>; Wed, 04 Mar 2020 08:11:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OfbWj39Lc5Lt7SX5ER1kwwduCXGN5iOIU0hVtYMDbz8=;
        b=TAfX+ut1IGvefWQyow0lDr7EE8OobjrBulnw/LYUNlvtHtRL+FcEh3L3AXQ7CIMEMv
         MFoYHMFLyvHU0IXLpwB1g5YEH+BtJS1AH2a10UEPu/xHcJ1MOl30lkFyTL/Lkn8VqNJm
         f0FgbT+2weW3UirB8eaw1RScicA5NuTqtb3EmV7sHY+V4+fTGfmTn3kA7N+rukMG+dfi
         wxtGNSuFDRS9wgT+OCH52T/mfZ3p3KZz9JE93sRKUoas1v0r3IpI8l+gxVaUgaPkmKdb
         E2My57a29Oj6s0tfz9DrlSUqu1Xk1eG3oHUZ5uHrXCY0+MXPeOmU5rSQgu/psc6yG4AM
         kovg==
X-Gm-Message-State: ANhLgQ1KJKn+jVWBeGWIWl19k82dDzYMvBnefAplN+2+u8p5nBhZEiJQ
        r3noChJxtJMu9yq8D0FHe+A=
X-Google-Smtp-Source: ADFU+vvGabdFQ+k82pYPI9KJktiWvX+pKJCMqC7hTypuQEg9b6hsBh0Mf9q7YOHCqVKJclHJPRUKOw==
X-Received: by 2002:a17:90a:37d0:: with SMTP id v74mr3763406pjb.0.1583338316226;
        Wed, 04 Mar 2020 08:11:56 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id z17sm17078005pfk.110.2020.03.04.08.11.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Mar 2020 08:11:55 -0800 (PST)
Subject: Re: [LSF/MM/BPF TOPIC] Storage: generic completion polling
To:     Hannes Reinecke <hare@suse.de>,
        "lsf-pc@lists.linux-foundation.org" 
        <lsf-pc@lists.linux-foundation.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>,
        Keith Busch <keith.busch@wdc.com>,
        James Smart <james.smart@broadcom.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Kashyap Desai <Kashyap.Desai@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>
References: <6a263bd4-8989-b766-1d33-7b57f4de0c7d@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <048834b9-041e-6d4d-3e2e-1489a72468c9@acm.org>
Date:   Wed, 4 Mar 2020 08:11:53 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <6a263bd4-8989-b766-1d33-7b57f4de0c7d@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/3/20 11:17 PM, Hannes Reinecke wrote:
> there had been quite some discussion around completion polling and the
> fact that for high-performance devices it might be a performance benefit
> [1][2]. And during discussion with other people (hello tglx) the
> reaction always had been "Can't you do NAPI?"
> 
> So the question is: Can we?
> IE is it possible to have a generic framework for handling polled
> completiona and interrupt completions, shifting between them depending
> on the load?
> 
> My idea is to have a sequence like
> completion polling -> interrupt handling -> threaded irq/polling
> IE invoke completion polling directly from the submission path, enable
> interrupts to handle completions from the interrupt handler, and finally
> shift to completion polling again if too many completions are present.
> Clearly this approach involves quite some tunables (like how many
> completions before enabling polling from interrupt context, how long to
> wait for completions before enabling interrupts etc), but I thing it
> would be worthwhile having this as a generic framework as then one could
> start experimenting with the various tunables to see which works best
> for the individual hardware.
> And it would lift the burden from the hardware vendors to implement a
> similar mechanism on their own.

To me the above sounds like a description of the lib/irq_poll mechanism? 
 From the top of lib/irq_poll.c:

/*
  * Functions related to interrupt-poll handling in the block layer. This
  * is similar to NAPI for network devices.
  */

Anyway, I'm interested in participating in the discussion of this topic.

Bart.

