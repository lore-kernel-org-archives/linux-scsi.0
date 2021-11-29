Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22FDDC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Nov 2021 13:06:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343841AbhK2NJc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Nov 2021 08:09:32 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:39458 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346165AbhK2NHb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Nov 2021 08:07:31 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 2ADE11FCA1;
        Mon, 29 Nov 2021 13:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1638191053; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+Za+8QUeIJb2ZRoqFuxNTTJQJcdgrLkv8s+/IKaTCtM=;
        b=S5DFrPm91eXU+7+RgF8fGJRVVnCoy8T9VB1/HigoBXqGefG4vZ6/dsKR5jW/3rwxds3O5i
        HxOcxrjipb4FZShzZfzW+w/OvySirzFsUW9xEpogBpVvicUJyZPAyoylIk8G+cMCG16nmc
        zH/tg0uCpCf9JDsrK7R2SvDZON1SiZ4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1638191053;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+Za+8QUeIJb2ZRoqFuxNTTJQJcdgrLkv8s+/IKaTCtM=;
        b=NJ5e+B4BpIvHbBxH0QxoSi6UnwOHb4pFrM4kHk9kYsiTNI6VP4V+Hk4529B8fDzMraMUJ6
        lpfYAtz3CtAOdMCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C952C13ABC;
        Mon, 29 Nov 2021 13:04:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id cu94IszPpGEZRwAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 29 Nov 2021 13:04:12 +0000
Subject: Re: [PATCH V2] scsi:spraid: initial commit of Ramaxel spraid driver
To:     Yanling Song <songyl@ramaxel.com>, martin.petersen@oracle.com,
        bvanassche@acm.org
Cc:     linux-scsi@vger.kernel.org, yujiang@ramaxel.com
References: <20211126073310.87683-1-songyl@ramaxel.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <99fb2d55-88c0-2911-3b71-7670d386ab1c@suse.de>
Date:   Mon, 29 Nov 2021 14:04:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211126073310.87683-1-songyl@ramaxel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/26/21 8:33 AM, Yanling Song wrote:
> This initial commit contains Ramaxel's spraid module.
> 
> Signed-off-by: Yanling Song <songyl@ramaxel.com>
> 
> Changes from V1:
> 1. Use BSG module to replace with ioctrl
> 2. Use author's email as MODULE_AUTHOR
> 3. Remove "default=m" in drivers/scsi/spraid/Kconfig
> 4. To be changed in the next version:
>     a. Use get_unaligned_be*() in spraid_setup_rw_cmd();
>     b. Use pr_debug() instead of introducing dev_log_dbg().
> 
> ---
>   Documentation/scsi/spraid.rst     |   16 +
>   MAINTAINERS                       |    7 +
>   drivers/scsi/Kconfig              |    1 +
>   drivers/scsi/Makefile             |    1 +
>   drivers/scsi/spraid/Kconfig       |   10 +
>   drivers/scsi/spraid/Makefile      |    7 +
>   drivers/scsi/spraid/spraid.h      |  693 ++++++
>   drivers/scsi/spraid/spraid_main.c | 3328 +++++++++++++++++++++++++++++
>   8 files changed, 4063 insertions(+)
>   create mode 100644 Documentation/scsi/spraid.rst
>   create mode 100644 drivers/scsi/spraid/Kconfig
>   create mode 100644 drivers/scsi/spraid/Makefile
>   create mode 100644 drivers/scsi/spraid/spraid.h
>   create mode 100644 drivers/scsi/spraid/spraid_main.c
> 
Hmm.
This entire thing looks like an NVMe controller which is made to look 
like a SCSI controller.
It even uses most of the NVMe structures.
And from what I've seen there is not much SCSI specific in here; I/O and 
queue setup is pretty much what every NVMe controller does.
So why not make it a true NVMe controller?
Yes, you would need to discuss with the NVMe folks on how a RAID 
controller should look like in NVMe terms.
But overall I guess the driver would be far smaller and possibly easier 
to maintain.

So where's the benefit having it as a SCSI driver (apart from the fact 
that is allows you to side-step having to discuss the interface with 
NVMexpress.org ...)?
Or, to put it the other way round: Is there anything SCSI specific which 
would prevent such an approach?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke <hare@suse.de>
<insert signature here>
