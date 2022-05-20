Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF8EDC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 20 May 2022 06:42:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345592AbiETGma (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 May 2022 02:42:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235792AbiETGm2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 May 2022 02:42:28 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C6CB80209
        for <linux-scsi@vger.kernel.org>; Thu, 19 May 2022 23:42:27 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 48BDD21CBC;
        Fri, 20 May 2022 06:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653028946; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rXUa3RZMEjJg3UPMy6qej39IplBP7xLddQJuovQma60=;
        b=MPui2V9Shf9oRICCifL0wPIEPBzolDrCCXehJgnX5DKzNhDmS1XvYL9mT65b3uRcGKX+Ya
        f4ImfFQAw+U5N3mM8FcZ38LE4J83cDx0mugk9wroBOmbQIPgJyYtdgJrtvw+CDFqmFQRE/
        nRhZ48i2paG19QjGVDvlh71S/Ftug6Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653028946;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rXUa3RZMEjJg3UPMy6qej39IplBP7xLddQJuovQma60=;
        b=gejNFejF12cAfS9Jf4On4i2E00s6vyXDmXCaliH9KeqcsOBxwkKFxB0yYqDbBkZ78nA9KO
        cnhNsFxwHgGCdhDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EB53013A5F;
        Fri, 20 May 2022 06:42:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id jNk1NlE4h2IxHQAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 20 May 2022 06:42:25 +0000
Message-ID: <c32603bf-7c63-7971-64a1-28617091bc37@suse.de>
Date:   Fri, 20 May 2022 08:42:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 05/20] mptfc: open-code mptfc_block_error_handler() for
 bus reset
Content-Language: en-US
To:     Ewan Milne <emilne@redhat.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
References: <20220512111236.109851-1-hare@suse.de>
 <20220512111236.109851-6-hare@suse.de>
 <CAGtn9rkeUY0RwHSjEX3wuXvos-FUveqN9M1FeX-_1tRzLmS0Vw@mail.gmail.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <CAGtn9rkeUY0RwHSjEX3wuXvos-FUveqN9M1FeX-_1tRzLmS0Vw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/19/22 10:05, Ewan Milne wrote:
> This change removes the debug log messages that mptfc_block_error_handler()
> would have generated, and also doesn't do the same thing, at all, for each rport
> due to the differences in the logic between fc_block_rport() and
> fc_remote_port_chkready()
> and waiting for ioc->active == 0.
> 
Yes, I'll be adding back the checks for ioc->active.

> Perhaps this is desirable and intentional, if so, could you explain
> this in the commit message?
> 
Removing the debug calls was intentional; if needs be they can be 
activated via scsi_logging_level.

I'll be updating the commit message.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman
