Return-Path: <SRS0=r6FR=ZK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94249C432C0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 23:01:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41D1322311
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 23:01:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbfKRXBE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Nov 2019 18:01:04 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45056 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726717AbfKRXBD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Nov 2019 18:01:03 -0500
Received: by mail-pf1-f196.google.com with SMTP id z4so11086116pfn.12
        for <linux-scsi@vger.kernel.org>; Mon, 18 Nov 2019 15:01:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=riq8TYtzbtpxUajb+hhxbp/Q8axCfxMQNldtH+pwqrg=;
        b=hRxCsZvG5Ky43ALdnepUETN72Ca6UUKUBAPXbJgal4Qszy6brUqhr9pbdUXQG7b7YW
         e4JFLUcEeN7T51Cpe5GFOjY2WVA5iws3TuR4SdIkiVIZS1eX/t69nZkFIyUz6TuXibRt
         KcbsP9BOdjaYPmgq9oCIi/xb4IJ2RHGX64u8ke2dvZbap+n/ZWsJbVT9gl1Lmv6d3oIE
         +MNQLMV4ccBYIBPGbnmWF32TUjUnKyRm/9sEmKKfzN9uQlesCKT6a4la3t1SoC6gkV9w
         pWUm8cbNH93YDPuNWU4z7wJOEpFR4jCaGQCGTleGDuHollQOwxmWT804mFtUMkRgw4T8
         9jLA==
X-Gm-Message-State: APjAAAWYVTLBDwwbzz2Co+lGxC2Wg0UDRichHWnT/uORr2vEMlqIrlsH
        a9Fn0Qwomm72NzYhCu2qOsF3voG7
X-Google-Smtp-Source: APXvYqxusbAxw8GFB9ZKPTjcuXAaFdKf/Ob2N/bWxKbYaOYcdtnFgUHD8nfhrVyjZMe0iUb5KwBstg==
X-Received: by 2002:a62:1605:: with SMTP id 5mr1972846pfw.206.1574118061593;
        Mon, 18 Nov 2019 15:01:01 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id a26sm22137884pff.155.2019.11.18.15.01.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Nov 2019 15:01:00 -0800 (PST)
Subject: Re: [PATCH 5/9] aacraid: use midlayer helper to terminate outstanding
 commands
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org,
        Balsundar P <balsundar.p@microsemi.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>
References: <20191118092208.54521-1-hare@suse.de>
 <20191118092208.54521-6-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <3b190413-0f52-afb5-72f0-d2b343ec4181@acm.org>
Date:   Mon, 18 Nov 2019 15:00:59 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191118092208.54521-6-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/18/19 1:22 AM, Hannes Reinecke wrote:
> Use scsi_host_flush_commands() to terminate all outstanding commands
> instead, and change the command result for terminated commands to
> the more common 'DID_RESET' instead of 'QUEUE_FULL'.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
