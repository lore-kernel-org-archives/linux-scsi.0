Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A43FCC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Oct 2022 08:13:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbiJLINU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Oct 2022 04:13:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbiJLINR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Oct 2022 04:13:17 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480499F745
        for <linux-scsi@vger.kernel.org>; Wed, 12 Oct 2022 01:13:11 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E4DCF1F381;
        Wed, 12 Oct 2022 08:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1665562389; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yL4ai681mvPraLoQJ7YtVQs3D5DR+YV0vFzdPPc9C6Y=;
        b=j4hwieBm+SXoUbSe5nWck16vXmaM6Y8uN4v2ZAhQ8Q69wEp1Dfwop4z//PFmjjG6V/uEBo
        9C+BepHZSDjcyWbwBdMw7t+HpgD05Mv5KBxhCS0NqePB9Vo0z/uQnk++3arn1nUD/H+Eav
        26YF3Jn1+Kuk5HFmBE7QeYf8J9K4Zfo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1665562389;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yL4ai681mvPraLoQJ7YtVQs3D5DR+YV0vFzdPPc9C6Y=;
        b=vhprPYUBzl0ODrK3JZZOfZF35I4xSbDY1BCvQxi14SBF1dIbtqxbXb3tav2rColzcOMx43
        kKGqnwhYLTGXK+Dw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3C07213ACD;
        Wed, 12 Oct 2022 08:13:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id FmKbCBV3RmMxUwAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 12 Oct 2022 08:13:09 +0000
Message-ID: <880f56e7-42a6-2c22-759c-b355ec108e99@suse.de>
Date:   Wed, 12 Oct 2022 10:13:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH] restrict legal sdev_state transitions via sysfs
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        Uday Shankar <ushankar@purestorage.com>,
        linux-scsi@vger.kernel.org
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20220924000241.2967323-1-ushankar@purestorage.com>
 <b5ac4103-87dc-f3ea-a2ef-67b3ef41bf66@oracle.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <b5ac4103-87dc-f3ea-a2ef-67b3ef41bf66@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/30/22 04:57, Mike Christie wrote:
> On 9/23/22 7:02 PM, Uday Shankar wrote:
>> ---
>> Looking for feedback on the "allowed source states" list. The bug I hit
>> is solved by prohibiting transitions out of SDEV_BLOCKED, but I think
>> most others shouldn't be allowed either.
> 
> I think it's ok to be restrictive:
> 
> 1. BLOCKED is just broken. When the transport classes and scsi_lib transition
> out of that state they do a lot more than just set the set. We are leaving
> the kernel in mismatched state where the device state is running but the
> block layerand transport classes are not ready for IO.
> 
> 2. CREATED does not happen. We go into RUNNING then do scsi_sysfs_add_sdev so
> userspace should not see the CREATED state.
> 
> 3. I'm not 100% sure about SDEV_QUIESCE though. It looks like it has similar issues
> as BLOCKED where scsi_device_resume will undo things it did in scsi_device_quiesce,
> so we can't just set the state to RUNNING and expect things to work. I'm not
> sure about the scsi_transport_spi cases.
> 
> It would be best for James or Hannes to comment because they know that code well.
> 
Indeed, you are correct.
The only sensible state transitions to be modified from userland is 
indeed between SDEV_RUNNING and SDEV_OFFLINE.
All other states are in fact part of the SCSI midlayer operations, and 
there a quite strict rules on which state transitions are allowed and 
who should be initiating them.

So yes, I'm fine with this patch.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

