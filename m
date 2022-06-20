Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 500C9C43334
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jun 2022 07:35:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239408AbiFTHfz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jun 2022 03:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239405AbiFTHfz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jun 2022 03:35:55 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EE79F5A9;
        Mon, 20 Jun 2022 00:35:54 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 66D2E21B33;
        Mon, 20 Jun 2022 07:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1655710552; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AAYmwKHLmdsyED+9DmAfmzQLxK8/jhfLZ0iw/+kLyhI=;
        b=oiTKE0zmCBDOKay5BjslmJPgfVKSVb8KD+Z75CVhg4+pre9WFpF1rqcTs0chU973eQztAP
        ynAy0KDwYCyI8LG0pOwBbpPfrgO3CewqTeISxnX/22wT2INuRJugNkFE8XTbqY3uiqG6AC
        7QvnYnTMkpDjQp44Otu82z1JVAALYAc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1655710552;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AAYmwKHLmdsyED+9DmAfmzQLxK8/jhfLZ0iw/+kLyhI=;
        b=UkJsOo2OWez5Wv9U57159Et9aid2ViTIwQSm07gcnOEb7Pk/jsgJqb50VnRmm8MxUbLPbA
        rm8r13PSXxKjskDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 57B7A134CA;
        Mon, 20 Jun 2022 07:35:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ymMgFVgjsGKQCgAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 20 Jun 2022 07:35:52 +0000
Message-ID: <4bf6388f-3727-24b6-1aa5-1de454e3c5d0@suse.de>
Date:   Mon, 20 Jun 2022 09:35:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: Do we still need the scsi IPR driver ?
Content-Language: en-US
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Brian King <brking@us.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
References: <a5a3527c-d662-5bd1-e1dd-ad4930d10b3a@opensource.wdc.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <a5a3527c-d662-5bd1-e1dd-ad4930d10b3a@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/20/22 06:48, Damien Le Moal wrote:
> 
> Polling people here: Do we still need the scsi IPR driver for IBM Power
> Linux RAID adapters (IBM iSeries: 5702, 5703, 2780, 5709, 570A, 570B
> adapters) ?
> 
> The reason I am asking is because this driver is the *only* libsas/ata
> driver that does not define a ->error_handler port operation. If this
> driver is removed, or if it is modified to use a ->error_handler operation
> to handle failed commands, then a lot of code simplification can be done
> in libata, which I am trying to do to facilitate the processing of some
> special error completion for commands using a command duration limit.
> 
> Thoughts ?
> 
We certainly don't, I've looked through our pool for any machines and 
draw a blank.
And I'm reasonably certain that none of our customers is using one of 
them old machines, neither; IBM tends to be very particular about 
obsolete machines :-)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
