Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88791C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Mar 2021 15:09:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 463D361A18
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Mar 2021 15:09:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbhCZPIr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Mar 2021 11:08:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:51458 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230016AbhCZPIh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Mar 2021 11:08:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 08D56AD8D;
        Fri, 26 Mar 2021 15:08:36 +0000 (UTC)
Subject: Re: Isssues with very large LUN count servers and booting becoming
 more and more of a problem
To:     Laurence Oberman <loberman@redhat.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Ewan Milne <emilne@redhat.com>,
        "Van Assche, Bart" <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>
References: <fa08c1edd1aeede6d5c8109b8a473120cca5e35b.camel@redhat.com>
 <0d042d7604e57b8cdd3fe4a0a6914e6ab1d7c85c.camel@redhat.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <582d9b45-0d4b-d888-d648-9a59263e633d@suse.de>
Date:   Fri, 26 Mar 2021 16:08:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <0d042d7604e57b8cdd3fe4a0a6914e6ab1d7c85c.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/25/21 1:28 AM, Laurence Oberman wrote:
> On Mon, 2021-03-22 at 17:02 -0400, Laurence Oberman wrote:
>> Hello
>> We have been struggling with this for years.
>> Systems are getting so large now that a system with multi-terabyte
>> memory and 1000's of device paths is becoming common.
>>
>> For example, customers are seeing 16 paths and with a 1000 LUNS thats
>> 16000 multiline console log discovery etc.
>>
>> We land up in Emergency mode and various incatanations of "cant boot"
>> due to console putput slowdown that (while worse on serial consoles)
>> is
>> still huge overhead that can even require us to use watchdog_thresh
>> on
>> the kernel line to prevent the NMI's
>>
>> I started thinking about a new parameter for scsi_mod that could be
>> used by sd and the scsi_dh_alua probing / discovery messaging (that
>> is
>> so noisy), to quieten it down.
>>
>> Before I even put efort into this, I wanted to see if you folks have
>> an
>> appetite for this.
>>
>> We have been blacklisting HBA drivers and using verious printk masks
>> etc to overcome this but a way to mask this within sd.c and
>> scsi_dh_alua.c I think could work better.
>> It would not be the default of course but an option to be added for
>> these huge customers.
>> I would look do do the minimal logging for a device discovery, just
>> so
>> some messaging is there for debug etc and I think it will help.
>>
>> If this is a crazy idea, let me know and I wont pursue it, but I
>> decided to just put it out there.
>>
>> Best Regards
>> Laurence Oberman
>>
> 
> Replying to my own thread with more information
> 
> RFE: Introduce two new macros to manage the crazy amount of boot
> logging we get with the large LUN count systems
> 
> sd_printk_boot_control
> sdev_printk_boot_control
> 
> These macros have an extra parameter boot_log_enable and if its default
> (1) then logs are printed
> adding scsi_mod.scsi_alua_boot_logging=0 will quiet down the logging
> for these huge systems
> 
> With no parameter (default) nothing changes in the logging
> 
> With boot log control and regular console
> 134s to boot and 1987 lines with 80 devices and 2 paths
> 
> With no boot control (default) and regular console
> 170s to boot and about 4000 lines of logging
> 
> The patch inline is not final so I did not send with git given this is
> an RFE.
> t is included to show the changes I was thinking about.
> 
Well, _actually_ it's not just the SCSI drivers; it's just that the scsi 
driver exhibits these issues nicely.

The hope I had was that we can resolve this issue by making printk 
asynchrounous, such that each call to printk() wouldn't block.

The really should give us most what we want; the only issue is what to 
do with those messages which are spooled (but not printed).
For graphical UI this probably doesn't matter as the user will end up 
with a graphical interface sooner or later.

For text console things become tricky; we will need the console to get 
our prompt, but it might still be busy printing out stuff.

Can't we have a 'low priority' output of these messages, and stop 
printing them to the console once 'getty' starts?

Thing is, once 'getty' is up and running the user _can_ log in, so he 
can any debugging he likes from the system console; there the message 
log on the console is less important as the user can get the system log 
via other means.
It only gets important once getty is _not_ up, but then it's less time 
critical as there's nothing the user _can_ do.

Thoughts?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
