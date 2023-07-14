Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00DD7EB64DC
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jul 2023 06:04:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235063AbjGNGEf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jul 2023 02:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234964AbjGNGEb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2023 02:04:31 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02EAC1BF6
        for <linux-scsi@vger.kernel.org>; Thu, 13 Jul 2023 23:04:29 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8F91B1F8D7;
        Fri, 14 Jul 2023 06:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1689314668; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OtAHehLTFzE7c761bGG8cmQYvnXh4o+2pep+A8vjbsI=;
        b=KNhyu33pgtk8Z0hXV4ggTtKqJOcexIwwc3hc6vmktCcNB59XJq9HVJxVQIvHG4JIm62O+G
        KW98V+/x1VqLYa0xafYBlMD0x416DTYN4rXhIHCzHdzAKHVmvOOqBRXoCiv/TPpM6iS2qd
        cS8MQnqvsJPR3yPs581Zqc6uRmUSAnk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1689314668;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OtAHehLTFzE7c761bGG8cmQYvnXh4o+2pep+A8vjbsI=;
        b=27mEdmWXNetd00Ao9AnmBelA8Up/niy5lhDz/OVQmXMe4p3fWBnc9zgl3rd0H3kElVUngF
        ANBn/dL+sShpiXDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 701F513A15;
        Fri, 14 Jul 2023 06:04:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id vJUuGmzlsGTfEAAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 14 Jul 2023 06:04:28 +0000
Message-ID: <fc9f01f1-deb2-cd05-c7ef-1e08ea1d8d60@suse.de>
Date:   Fri, 14 Jul 2023 08:04:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: Mylex AcceleRAID 170 + myrb/myrs causing crash
Content-Language: en-US
To:     Mike Edwards <medwards@mobile.mirkwood.net>,
        linux-scsi@vger.kernel.org
References: <CALM2zXUDAqAzCQR+sJDwoxxEEnG7cLJ4QazCVscJX-rR49=V2A@mail.gmail.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <CALM2zXUDAqAzCQR+sJDwoxxEEnG7cLJ4QazCVscJX-rR49=V2A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/13/23 21:21, Mike Edwards wrote:
> I spun up an old machine (with an even older Mylex AcceleRAID card, the 
> 170 w/ a bios dated Jan 21, 2000 - yikes!) recently.  While this machine 
> was running an old 4.7 kernel and booted fine, attempting to update it 
> to a modern release of Debian with a 6.1 kernel caused the kernel to 
> hang while booting, with a number of stuck tasks warnings, starting with 
> udev-worker and including kworker kernel processes.
> 
> During troubleshooting, I was able to identify the myrb/myrs drivers 
> which replaced the old DAC960 driver (removed in commit 
> 6956b956934f10c19eca2a1d44f50a3bee860531) as the culprit.  The last 
> kernel to successfully boot on here is 4.19.x, while anything newer 
> exhibits the same stuck processes - and indeed, blacklisting the myrb 
> and myrs drivers allows 6.1 to boot on this machine.
> 
> I know this card is functional, as I do have two drives attached to it, 
> and both it and the drives work fine in 4.19 and older kernels, so the 
> issue seems to be with the newer myrb/myrs drivers.  Is there a chance 
> of fixing the current drivers, or, at worst, reintroducing the old 
> deprecated DAC960 driver back into the kernel?  I'm not absolutely tied 
> to using that driver, other than 'it just works' for this card.

Whee, someone is using it!
I'm not alone!

But sure, of course I'll help.
Can you try install openSUSE Leap on it? Then you can open a bugzilla on 
our side, and we can track and discuss things there. Debugging via 
e-mail tends to be very distracting to others not directly involved.

For starters, a message log might help. And please enable dynamic debug
via

echo 'file drivers/scsi/myrs.c +p' > \
   /sys/kernel/debug/dynamic_debug/control
echo 'file drivers/scsi/myrb.c +p' > \
   /sys/kernel/debug/dynamic_debug/control

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

