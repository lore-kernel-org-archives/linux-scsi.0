Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FEA1EB64DC
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jul 2023 15:18:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235338AbjGNPSI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jul 2023 11:18:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235272AbjGNPSH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2023 11:18:07 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9695A2117
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 08:18:06 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 53054220CB;
        Fri, 14 Jul 2023 15:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1689347885; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=youB5mhiPVso3WYcSOoWoyLodOlEzVwOxfcBChn7cNo=;
        b=TVLjXJaKmwBr+3eQuRrOzM+I2Yt+d8qywYZ5sldagM2nCqGZPgGNUE3mSqX2llotALtVPD
        VS7KLqlKMzsM0I4CSK2UI2SkQafYmiH9YIENFGgkVB8ZXAvhi8LhRf7OJgx9CoCI/Beb8X
        k+oGNpm9zYyBhZXbZBy0oHe9RJIiGPI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1689347885;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=youB5mhiPVso3WYcSOoWoyLodOlEzVwOxfcBChn7cNo=;
        b=GyhTavp5Y6kIIsTyX1luBQsjxiRSzBgVzZcFyP+xdvyFEJT2cTNEpyoTvRrw2eAkq3GYK9
        CNe4Dps+AU1FoaDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4786613A15;
        Fri, 14 Jul 2023 15:18:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id uNQIES1nsWRgNgAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 14 Jul 2023 15:18:05 +0000
Message-ID: <4a0b76f5-9980-7976-bed1-801a98ecb7d8@suse.de>
Date:   Fri, 14 Jul 2023 17:18:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: Mylex AcceleRAID 170 + myrb/myrs causing crash
Content-Language: en-US
To:     Mike Edwards <medwards@mobile.mirkwood.net>
Cc:     linux-scsi@vger.kernel.org
References: <CALM2zXUDAqAzCQR+sJDwoxxEEnG7cLJ4QazCVscJX-rR49=V2A@mail.gmail.com>
 <fc9f01f1-deb2-cd05-c7ef-1e08ea1d8d60@suse.de>
 <CALM2zXX9LfshDUaFpKL5KURQy7p8J=5KpSi_foVaC1BfAB9sJg@mail.gmail.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <CALM2zXX9LfshDUaFpKL5KURQy7p8J=5KpSi_foVaC1BfAB9sJg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/14/23 17:03, Mike Edwards wrote:
> I can try openSUSE Leap, certainly.
> 
> However, those debugging statements are going to be hard - the process
> lockup occurs at initial module load, before init really starts doing
> much of anything.  I've even tried passing init=/bin/bash on the
> commandline, with no luck - I never made it to a shell before things
> went south.  For the same reason, there are no logs to speak of, alas
> - but I can try seeing if I can get a serial console going, as that
> will let me dump output.
> 
> I'll verify that the driver in OpenSUSE Leap has the same issue, and
> will open a bug report when it (almost certainly!) dies the same way.
> 
You can try with the live system from the ISO image; that will load the 
modules only afterwards, so you should be able to see some messages there.

And I think there is even a magic commandline sequence to enable dynamic 
debug...

Cheers,

Hannes

