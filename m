Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FD1BCD68F5
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Oct 2023 07:15:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379443AbjJJHPx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Oct 2023 03:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379439AbjJJHPt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Oct 2023 03:15:49 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A904D3
        for <linux-scsi@vger.kernel.org>; Tue, 10 Oct 2023 00:15:48 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id EA6871F749;
        Tue, 10 Oct 2023 07:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1696922146; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kwu44p3NR8YFNGpTWdoY9ZO7KQu8C9cZhOrewu4r+x0=;
        b=2WFYvjLztjGtK55WHfgE99XkFvnp3c34FAJ0FfizypHMl6CPfH9sNF0SUKQgfWd/Oy6HW/
        iV0B9AS/fEOeitd9p/UkyYZHXAe6H0vnfHJS5iqKPmQlFejiFXpeJ73dYyo1BQusaRpPlb
        uvcNVnCqRaGHknRnK+JHCOMZZdYIguI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1696922146;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kwu44p3NR8YFNGpTWdoY9ZO7KQu8C9cZhOrewu4r+x0=;
        b=M3z0zNYK35esMPdGyR6nZ82VjDcDdDUIip+AcQ20Bn5cJFTZipPoGld0s60Ufo7RzYDk2/
        3nBabJp4fy2mjrCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C81701358F;
        Tue, 10 Oct 2023 07:15:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id W+GELyL6JGWUNAAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 10 Oct 2023 07:15:46 +0000
Message-ID: <a06b762d-32b9-448b-96cf-a2957ab1a425@suse.de>
Date:   Tue, 10 Oct 2023 09:15:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Feature Request: Device Manager Fake Trim / Zero Trim
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, charlesfdotz@tutanota.com,
        Dm Devel <dm-devel@lists.linux.dev>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <NgGvkdW--3-9@tutanota.com>
 <6276b986-fe9a-4ac4-9662-a0abf7dc68b4@suse.de>
 <dc7c0122-8077-4aa5-87e6-87404f48a4ce@kernel.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <dc7c0122-8077-4aa5-87e6-87404f48a4ce@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/10/23 08:48, Damien Le Moal wrote:
> On 10/9/23 15:15, Hannes Reinecke wrote:
>> On 10/9/23 02:56, charlesfdotz@tutanota.com wrote:
>>> Hello,
>>>
>>> I would like to request a new device manager layer be added that accepts
>>> trim requests for sectors and instead writes zeros to those sectors.
>>>
>>> This would be useful to deal with SMR (shingled magnetic recording) drives
>>> that do not support trim. Currently after an SMR drive has had enough data
>>> written to it the performance drops dramatically because the disk must
>>> shuffle around data as if it were full and without trim support there is no
>>> way to inform the disk which sectors are no longer used. Currently there's
>>> no way to "fix" or reset this without doing an ATA secure erase despite
>>> many of these disk being sold without informing customers that they were
>>> SMR drives (western digital was sued for selling SMR drives as NAS
>>> drives).
>>>
>> Gosh, no, please don't. SMR drives have a write pointer, and if the zone
>> needs to be reset you just reset the write pointer. Writing zeroes will
>> result in the opposite; the zone continues to be full, and no writes can
>> happen there.
> 
> Yes. And zone reset *is* a trim also since after a zone reset, the sectors in
> the zone cannot be read.
> 
On the same vein: why didn't we hook up 'wp reset' to trim/unmap?
The code says:

         if (sd_is_zoned(sdkp)) {
                 sd_config_discard(sdkp, SD_LBP_DISABLE);
                 return count;
         }

I distinctly remember to enable discards via 'wp reset' in the
original code; what happened to it?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

