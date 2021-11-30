Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CABDC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 11:57:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241068AbhK3MAk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Nov 2021 07:00:40 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:60810 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233873AbhK3L7T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Nov 2021 06:59:19 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 577EA1FD54;
        Tue, 30 Nov 2021 11:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1638273359; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h6oUH8GLbx+PmOC2wrA7txDkU2zL7G4wdMnHElZ3hwY=;
        b=bA3P1hUFN64kBRaq3o+dOMvZI3M5GsosQhbxpi+gPgGQDMqq71U8jgEPULdSXGNFDJOLYJ
        KeyoxXmvcmwsSs9uioLGA8KlJdKsoRxzBSdKOOZ05LfrBpiLCe9uwB1nFr+ELlTF71CIZx
        k0LGrHZ7hDEr/BU+LrQDNzYG3iwf71w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1638273359;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h6oUH8GLbx+PmOC2wrA7txDkU2zL7G4wdMnHElZ3hwY=;
        b=k6p0sdYu/gP2KfQdtNv8lANYM/lQePa6MOL7xj/3TxHZ0QkNRw47sT/JzyomJfvuUayu8Z
        d1AZ7DPAlosR53DQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 45C9B13C98;
        Tue, 30 Nov 2021 11:55:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id XCm9EE8RpmH3YwAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 30 Nov 2021 11:55:59 +0000
Subject: Re: [PATCH V2] scsi:spraid: initial commit of Ramaxel spraid driver
To:     Yanling Song <songyl@ramaxel.com>
Cc:     martin.petersen@oracle.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, yujiang@ramaxel.com,
        yanling.song@linux.dev
References: <20211126073310.87683-1-songyl@ramaxel.com>
 <99fb2d55-88c0-2911-3b71-7670d386ab1c@suse.de>
 <20211130113836.1bb8e91c@songyl>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <69541d78-49cd-900a-21ca-b9f56e9dca00@suse.de>
Date:   Tue, 30 Nov 2021 12:55:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20211130113836.1bb8e91c@songyl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/30/21 12:38 PM, Yanling Song wrote:
> On Mon, 29 Nov 2021 14:04:12 +0100
> Hannes Reinecke <hare@suse.de> wrote:
> 
>> On 11/26/21 8:33 AM, Yanling Song wrote:
>>> This initial commit contains Ramaxel's spraid module.
>>>
>>> Signed-off-by: Yanling Song <songyl@ramaxel.com>
>>>
>>> Changes from V1:
>>> 1. Use BSG module to replace with ioctrl
>>> 2. Use author's email as MODULE_AUTHOR
>>> 3. Remove "default=m" in drivers/scsi/spraid/Kconfig
>>> 4. To be changed in the next version:
>>>     a. Use get_unaligned_be*() in spraid_setup_rw_cmd();
>>>     b. Use pr_debug() instead of introducing dev_log_dbg().
>>>
>>> ---
>>>   Documentation/scsi/spraid.rst     |   16 +
>>>   MAINTAINERS                       |    7 +
>>>   drivers/scsi/Kconfig              |    1 +
>>>   drivers/scsi/Makefile             |    1 +
>>>   drivers/scsi/spraid/Kconfig       |   10 +
>>>   drivers/scsi/spraid/Makefile      |    7 +
>>>   drivers/scsi/spraid/spraid.h      |  693 ++++++
>>>   drivers/scsi/spraid/spraid_main.c | 3328
>>> +++++++++++++++++++++++++++++ 8 files changed, 4063 insertions(+)
>>>   create mode 100644 Documentation/scsi/spraid.rst
>>>   create mode 100644 drivers/scsi/spraid/Kconfig
>>>   create mode 100644 drivers/scsi/spraid/Makefile
>>>   create mode 100644 drivers/scsi/spraid/spraid.h
>>>   create mode 100644 drivers/scsi/spraid/spraid_main.c
>>>   
>> Hmm.
>> This entire thing looks like an NVMe controller which is made to look 
>> like a SCSI controller.
>> It even uses most of the NVMe structures.
>> And from what I've seen there is not much SCSI specific in here; I/O
>> and queue setup is pretty much what every NVMe controller does.
>> So why not make it a true NVMe controller?
>> Yes, you would need to discuss with the NVMe folks on how a RAID 
>> controller should look like in NVMe terms.
>> But overall I guess the driver would be far smaller and possibly
>> easier to maintain.
>>
>> So where's the benefit having it as a SCSI driver (apart from the
>> fact that is allows you to side-step having to discuss the interface
>> with NVMexpress.org ...)?
>> Or, to put it the other way round: Is there anything SCSI specific
>> which would prevent such an approach?
>>
> 
> Actually it is a SCSI driver, and it does register a scsi_host_template
> and host does send SCSI commands to our raid controller just like other
> raid controllers. You are right "it looks a lot like NVMe" since we
> believe the communication mechanism of NVME between host and the end
> device is good and it was leveraged when we designed the raid
> controller. That's why it looks like there are some code from NVME
> because the mechanism is the same.
> 
Thank you, but that was precisely my question.

Seeing that the driver is using the NVMe mechanism to communicate
commands between the driver and the hardware, doesn't it make it a NVMe
driver?
Especially as you are sending NVMe commands and not SCSI commands, so
you always will have to re-write the incoming SCSI commands into NVMe
commands, and knowing from experience this is not a good fit.

Hence my question: what exactly is SCSI specific on the hardware side?
Wouldn't an implementation as a NVMe driver be a better fit, as then you
could leverage all the existing code like setup prps, completion
handling etc?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
