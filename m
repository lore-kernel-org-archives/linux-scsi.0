Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83BA7C432BE
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 15:23:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D38F60FC4
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 15:23:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245495AbhH0PYp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Aug 2021 11:24:45 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:37516 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245487AbhH0PYk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Aug 2021 11:24:40 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 0CFD51FF24;
        Fri, 27 Aug 2021 15:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1630077831; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S7YlrfAQtljtkGG3+7uJ+2F5lI4Bbj2ziQPOyzgCwJw=;
        b=aW6A7VgD/GSPJU/u3jb10U+D9D8R25XNiG4fqz4zGSbGisp4rnZchnL7lUYWHYUTVpxy1T
        RPnCCuqO9skRY4MwWEsU898u0mNFi0lYSibI7b2TtKJab5m8KEYxHLa3xscpwtfNtfyDV4
        CGXdTDRFz8hp/R+JrjnIvIjSl2TSeoA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1630077831;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S7YlrfAQtljtkGG3+7uJ+2F5lI4Bbj2ziQPOyzgCwJw=;
        b=Ds5gtaoeDGXmT7464k+tIwBZ55y/wTsjK1zIQQ48sStyS00aL+2qryMbJosM9/o7Nva0YB
        VhUKXp6hZ0XJJSBQ==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id D96A11394D;
        Fri, 27 Aug 2021 15:23:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id 3RB0NIYDKWFUfQAAGKfGzw
        (envelope-from <hare@suse.de>); Fri, 27 Aug 2021 15:23:50 +0000
Subject: Re: arm scsi drivers
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        John Garry <john.garry@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hannes Reinecke <hare@suse.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
References: <5a72842f-99db-8787-120b-6d85e7884e2d@huawei.com>
 <9552a506-e53a-3fd3-b38e-3cec81e713a6@huawei.com>
 <20210827150938.GU22278@shell.armlinux.org.uk>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <087d1fa0-8796-5b97-36fc-379498f53380@suse.de>
Date:   Fri, 27 Aug 2021 17:23:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210827150938.GU22278@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/27/21 5:09 PM, Russell King (Oracle) wrote:
> I haven't, sorry.
> 
> I have run 5.x kernels on the hardware, and do have a set of patches
> kicking around for the SCSI drivers that do some cleanups. It looks
> like the fixup is pretty simple from the links you've sent - using
> scsi_cmd_to_rq() to get the tag.
> 
> That said, I think I may only had one SCSI drive that came anywhere
> close to supported tagged queuing, so I never put much effort into
> tagged command support. Both acornscsi and fas216 have it disabled
> for this reason, so it's probably easier just to rip the tag code
> out of these drivers.
> 
That's what I figured, too.
And that's what my patches do, killing the tag support from arm drivers 
which had them disabled since the dawn of git history.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
