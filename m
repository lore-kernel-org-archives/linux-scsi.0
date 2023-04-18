Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FF1BC77B75
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Apr 2023 18:38:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbjDRSiK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Apr 2023 14:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231228AbjDRSiI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2023 14:38:08 -0400
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9027C9EEB
        for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2023 11:37:56 -0700 (PDT)
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-63b8b19901fso1624433b3a.3
        for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2023 11:37:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681843076; x=1684435076;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0u0QXVhl3Tjl0DKnybYhE52dw2lIL1mQEubjzRvPVxc=;
        b=aArxCLNRvo4ZsrkKoTLtODXy2cLv+dt7O6Ph+oievTw77zeEJcF4vXEgk7XpBBdQCh
         zRbyUn7bJlsLgLUXVDATxT63sq3ob8NDCuHVsSIgKHEX0eoTO61rZbdcJAPBWKhZ/VhT
         NS8+76P5B6fypBsx8aXpPMXNPYqLIUAfTiPrR2Bk70NUW78EPIhuWhf+niQmnAcSJ9Bo
         IXtaynauwqnqFaz4ncfYKfSFVzGH6OnIn8MOC68UIlXNR7GRTREHH/G/OlDr4v4UDFjO
         ux+AsNBMkiun/zR6ye2AzAmF7DsmhCLGIOUGTA0b4qvW6DzxreEjquJ2Cn7EEERuwZRu
         e8yg==
X-Gm-Message-State: AAQBX9cRkKTDRVjJJ9zRpSj7N61mpUwVuboavZO93W7YYdjqUnFFhHPF
        k2yiEv541gFl19SCPAOP+1I=
X-Google-Smtp-Source: AKy350aEgPrTBuNhOO6Kj2TeBMKggG82NQqHmJ6a15CAWjtBdZDeS0AOxN3AsOCA7BQ/gih72Ot13A==
X-Received: by 2002:a05:6a00:24ca:b0:639:a518:3842 with SMTP id d10-20020a056a0024ca00b00639a5183842mr870409pfv.7.1681843075785;
        Tue, 18 Apr 2023 11:37:55 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:5d9b:263d:206c:895a? ([2620:15c:211:201:5d9b:263d:206c:895a])
        by smtp.gmail.com with ESMTPSA id k15-20020aa7820f000000b00631fecabdcfsm9884752pfi.97.2023.04.18.11.37.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 11:37:55 -0700 (PDT)
Message-ID: <4f59864e-d5cb-2590-99a3-2314873216f4@acm.org>
Date:   Tue, 18 Apr 2023 11:37:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v2 1/4] scsi: sd: Let sd_shutdown() fail future I/O
Content-Language: en-US
To:     jejb@linux.ibm.com,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        Mike Christie <michael.christie@oracle.com>,
        Tomas Henzl <thenzl@redhat.com>
References: <20230417230656.523826-1-bvanassche@acm.org>
 <20230417230656.523826-2-bvanassche@acm.org>
 <cdd6b413085dc606c351f3c10ea82774498171e1.camel@linux.ibm.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <cdd6b413085dc606c351f3c10ea82774498171e1.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/18/23 07:36, James Bottomley wrote:
> On Mon, 2023-04-17 at 16:06 -0700, Bart Van Assche wrote:
>> System shutdown happens as follows (see e.g. the systemd source file
>> src/shutdown/shutdown.c):
>> * sync() is called.
>> * reboot(RB_AUTOBOOT/RB_HALT_SYSTEM/RB_POWER_OFF) is called.
>> * If the reboot() system call returns, log an error message.
>>
>> The reboot() system call causes the kernel to call kernel_restart(),
>> kernel_halt() or kernel_power_off(). Each of these functions calls
>> device_shutdown(). device_shutdown() calls sd_shutdown(). After
>> sd_shutdown() has been called the .shutdown() callback of the LLD
>> will be called. Hence, I/O submitted after sd_shutdown() will hang or
>> may even cause a kernel crash.
>>
>> Let sd_shutdown() fail future I/O such that LLD .shutdown() callbacks
>> can be simplified.
> 
> What is the actual reason for this?  What is it you think might be
> submitting I/O after the system gets into this state?  Current
> sd_shutdown is constructed on the premise that it's the last thing that
> ever happens to the device before reboot/power off which is why it
> flushes the cache if necessary and stops the device if required, but
> for most standard devices neither is required because we don't expect
> Linux to go down with pending items in the block queue and for a write
> through disk cache anything that's completed on the block queue is
> safely durable on the device.

Hi James,

.shutdown() callbacks should quiesce I/O but the sd_shutdown() function 
doesn't do this. I see this as a bug.

Regarding your question, I think that sd_check_events() can be called 
while sd_shutdown() is in progress or after sd_shutdown() has finished. 
sd_check_events() may submit a TEST UNIT READY command.

In pci_device_shutdown() one can see that the PCI core clears the bus 
master bit for PCI devices during shutdown. In other words, it is not 
safe to submit I/O or to process completions during invocation of 
shutdown callbacks. I think that also shows that this patch fixes a bug.

Bart.

