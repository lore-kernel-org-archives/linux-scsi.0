Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE38CC433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  5 May 2022 16:20:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243218AbiEEQXp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 May 2022 12:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242718AbiEEQXn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 May 2022 12:23:43 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D79E5C640
        for <linux-scsi@vger.kernel.org>; Thu,  5 May 2022 09:20:03 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id BD055219C6;
        Thu,  5 May 2022 16:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651767601; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OgFqgfP8MRHud4U9AJRy5BrdqJQa1IZS0aB8UAKclec=;
        b=cd9jkWWiPnCmZH5ejV6Sa04WxsSu7uSVO6RCbRDbwrqniFpkMKLy3E0vKuxQxaA7e6hbI1
        xIqv0bR5bu2SLj1SKOEbNEIAAc9b7h+UPcHUmTXrlsj6hWypWiKFBM0s3BrIV1oSZlIpU3
        NKv6LJcRdrXSmAp8MoHuEuZeQXun6sk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651767601;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OgFqgfP8MRHud4U9AJRy5BrdqJQa1IZS0aB8UAKclec=;
        b=Vx9bTm2nhdsmelXhfatWEiTdeLTIATDdkIbH5PnNnFncbCr5KXLQY4PZNob6S/DYLKd17H
        oBqMjcgL7pPlJtCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9E48E13A65;
        Thu,  5 May 2022 16:20:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id VhtrHDD5c2IpZQAAMHmgww
        (envelope-from <hare@suse.de>); Thu, 05 May 2022 16:20:00 +0000
Message-ID: <d0e5679c-a5e7-71db-22f1-66d34798c4d8@suse.de>
Date:   Thu, 5 May 2022 09:19:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 0/7] scsi: EH rework main part
Content-Language: en-US
To:     "chenxiang (M)" <chenxiang66@hisilicon.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20220502215953.5463-1-hare@suse.de>
 <4d4586e1-c25c-5452-2252-cf533842250d@hisilicon.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <4d4586e1-c25c-5452-2252-cf533842250d@hisilicon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/4/22 19:27, chenxiang (M) wrote:
> Hi Hannes and other guys,
> 
> For SCSI EH, i have a question (sorry, it is not related to this 
> patchset): for current flow of SCSI EH, if IOs of one disk is failed
> 
> (if there are many disks under the same scsi host), it will block all 
> the IOs of total scsi host.
> 
> So during SCSI EH, all IOs are blocked even if some disks are normal. 
> That's the place product line sometimes complain about
> 
> as it blocks IO bussiness of some normal disks because of just one bad 
> disk during SCSI EH.
> 
> Is it possible to split the SCSI EH into two parts, the process of 
> recovering the disk and the process of recovering scsi host, at the 
> beginning
> 
If it were so easy.
The biggest problem we're facing in SCSI EH is that basically _all_ 
instances I've seen where EH got engaged were due to a command timeout.

Which means that we've sent a command to the HBA, and never heard from 
it again. Now, it were easy if it would just be the command which has 
vanished, but the problem is that we don't know what happened.
It might be the command being ln transit, the drive might be 
unresponsive, or the HBA has gone off the rails altogether.
So until we've established where the command got lost, we have to assume 
the worst and _have_ to treat the HBA as unreliable.
So initially we shouldn't isolate the device, and hope the failure is 
restricted to the device.
Instead we have to stop I/O to the HBA, establish communication 
(typically by sending a TMF), and only restart operations once we get a 
response back from the HBA.

This is especially true for old SCSI parallel HBA, where quite some 
state is being kept in the HBA structure itself. So if we were to send 
another command we would loas the state of the failed command, and 
wouldn't be able to figure out the root cause on why the command had failed.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
