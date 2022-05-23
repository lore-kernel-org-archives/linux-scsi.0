Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4D5CC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 23 May 2022 12:25:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235356AbiEWMZN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 May 2022 08:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235333AbiEWMZJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 May 2022 08:25:09 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38961FF8
        for <linux-scsi@vger.kernel.org>; Mon, 23 May 2022 05:25:08 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E6D581F383;
        Mon, 23 May 2022 12:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653308706; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C6s0IIS88G0Ze+OjZIoCSWYi4Jan7LqXRFCrNGKtbeE=;
        b=QKLqtwT7IAIBis9kUrjHGFZCEVFRbPBHXsaAc1rplFZkFzmQDic0pqAJC3BJRTSCbr8D/Z
        3nokNoTZRmaHOYC0Dnb+GHSHMc9I08jyUcbGYA3aTt06qCjB5xvLpZJLe8nve9MyTG2LC1
        KKCxMmsEDuf4sswU42HX2a2gKRWdZ/4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653308706;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C6s0IIS88G0Ze+OjZIoCSWYi4Jan7LqXRFCrNGKtbeE=;
        b=uvj6CqkJsKJfe3/8FyUrqE2MYUehNqB6sCugB4tQKBQP1jsJSW54517biwDSCyjaV2RtVw
        Nv+ktFZvoLydoRBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A342113AA5;
        Mon, 23 May 2022 12:25:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id fIa9JCJ9i2L+OQAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 23 May 2022 12:25:06 +0000
Message-ID: <f103023f-0ef7-076c-52ea-f8bbca0fd49f@suse.de>
Date:   Mon, 23 May 2022 14:25:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 04/20] mptfusion: correct definitions for
 mptscsih_dev_reset()
Content-Language: en-US
To:     Ewan Milne <emilne@redhat.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
References: <20220512111236.109851-1-hare@suse.de>
 <20220512111236.109851-5-hare@suse.de>
 <CAGtn9rnkZ1Y6-H7N_VkgmsDfWURiRBm1-kjnhLYxSk7un08CyQ@mail.gmail.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <CAGtn9rnkZ1Y6-H7N_VkgmsDfWURiRBm1-kjnhLYxSk7un08CyQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/19/22 19:27, Ewan Milne wrote:
> This patch appears to change the EH activity from issuing a target
> reset to a LUN reset only
> (since it does not add an entry in the host templates for
> .eh_target_reset_handler to invoke
> the new mptscsih_target_reset() function, nor does any other patch in
> the series).
> 
> Is this going to work properly, and without escalating to a host reset
> which might not have happened before?
> 
You are correct, the drivers need to be changed to refer to target_reset 
now. Will be fixing it with the next version.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
