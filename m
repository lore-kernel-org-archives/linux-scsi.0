Return-Path: <SRS0=yvfi=XB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 282FAC43331
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Sep 2019 18:31:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 100D720674
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Sep 2019 18:31:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436555AbfIFSbC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Sep 2019 14:31:02 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:33112 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730881AbfIFSbB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Sep 2019 14:31:01 -0400
Received: by mail-ot1-f66.google.com with SMTP id g25so5359165otl.0;
        Fri, 06 Sep 2019 11:31:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=inlyOQUAj9IgrEa/tTn6FC+PgqOBuK2w0K+3C9jmY5A=;
        b=JQwQDjtYLZWP992ll5UVMiS2LzKBYMGWv8gfsVWoNQvMAZjF06y9OZ4GKs0FHpYhwA
         fwxMBKUA4dYJ7EJ+POoS5W8jiIexr6Aez4ABCUFRTfDnl5APQWz4JkjHZQM98oxWt7rA
         u93s8u4Gl3+kzKH/Fv36sPfDE6vVddSqffpmRuVQLVxVLx5XqVokyI5k4/Jm7d/vT/gi
         fgkkmCahRBDag+NJpsIy4tn/OubFL9Iouhd2Wroa0pxkDU+MFdgmlOpZ44iOTSOAfsOf
         SEmPv75W0FE/WITNmioBR64ER29PQEHcHzfcbpJemQXCIS/dALa0MAoYlp7Z92W6aZ+a
         xjxw==
X-Gm-Message-State: APjAAAUqTtX+BwAM5pDJbMtVq0xZv8+PUxNMcOK4xcaIJsBMaaXQTTso
        pn8SFG5BD8ATMmYd8avL9Ng=
X-Google-Smtp-Source: APXvYqxWAkAjBw9LI0HQBqKJ+CxguDMlNik/iXtNNjR5JA1VPQ+boOZQ7WXXD7Me44XzHY7PgXFxsw==
X-Received: by 2002:a9d:66d2:: with SMTP id t18mr8790061otm.355.1567794660729;
        Fri, 06 Sep 2019 11:31:00 -0700 (PDT)
Received: from ?IPv6:2600:1700:65a0:78e0:514:7862:1503:8e4d? ([2600:1700:65a0:78e0:514:7862:1503:8e4d])
        by smtp.gmail.com with ESMTPSA id t30sm1086635otj.40.2019.09.06.11.30.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 11:30:59 -0700 (PDT)
Subject: Re: [PATCH 1/4] softirq: implement IRQ flood detection mechanism
To:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@fb.com>, Hannes Reinecke <hare@suse.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Long Li <longli@microsoft.com>,
        John Garry <john.garry@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-nvme@lists.infradead.org,
        Keith Busch <keith.busch@intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@lst.de>
References: <20190903033001.GB23861@ming.t460p>
 <299fb6b5-d414-2e71-1dd2-9d6e34ee1c79@linaro.org>
 <20190903063125.GA21022@ming.t460p>
 <6b88719c-782a-4a63-db9f-bf62734a7874@linaro.org>
 <20190903072848.GA22170@ming.t460p>
 <dd96def4-1121-afbe-2431-9e516a06850c@linaro.org>
 <6f3b6557-1767-8c80-f786-1ea667179b39@acm.org>
 <2a8bd278-5384-d82f-c09b-4fce236d2d95@linaro.org>
 <20190905090617.GB4432@ming.t460p>
 <6a36ccc7-24cd-1d92-fef1-2c5e0f798c36@linaro.org>
 <20190906014819.GB27116@ming.t460p>
 <ffefcfa0-09b6-9af5-f94e-8e7ddd2eef16@linaro.org>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <6eb2a745-7b92-73ce-46f5-cc6a5ef08abc@grimberg.me>
Date:   Fri, 6 Sep 2019 11:30:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <ffefcfa0-09b6-9af5-f94e-8e7ddd2eef16@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> 
> Ok, so the real problem is per-cpu bounded tasks.
> 
> I share Thomas opinion about a NAPI like approach.

We already have that, its irq_poll, but it seems that for this
use-case, we get lower performance for some reason. I'm not
entirely sure why that is, maybe its because we need to mask interrupts
because we don't have an "arm" register in nvme like network devices
have?
