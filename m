Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2273C07545
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Oct 2023 17:40:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234862AbjJXRk2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Oct 2023 13:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234865AbjJXRk0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Oct 2023 13:40:26 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7336910DC
        for <linux-scsi@vger.kernel.org>; Tue, 24 Oct 2023 10:40:24 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 1086A21C0D;
        Tue, 24 Oct 2023 17:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1698169220; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ePHmJNdvmqGrGkmFMukkLnY154aLxO6GM0XF1Mwr+P4=;
        b=SbIupJByVqpjAYZkiKiHEXzpYOZpRXiAmT64IhbD90CX+KnOoIBgI1iDUTBsjlgJljTiUe
        VqW+6IVX05FOqfLsL2LWtRk0zB5GLlqI7QQHMAKXEWpoe4D5CV7SqMbtWBwuqjWhWLRydP
        Gjj+XSXNePvHqwdhVpaX+hg1jrjfz1g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1698169220;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ePHmJNdvmqGrGkmFMukkLnY154aLxO6GM0XF1Mwr+P4=;
        b=ou8RRctUPRRuOlqJA1jYKJrzjcYvE8u/2gQzJ3oEOdRXOSonbkHOYe3ySlTa165QYcTs0K
        GFDxIWBXVKPOx8DA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 555AE13A97;
        Tue, 24 Oct 2023 17:40:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id hdL8EIABOGXmDgAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 24 Oct 2023 17:40:16 +0000
Message-ID: <a5a2dee0-4d85-4d45-a982-cdbd88addc45@suse.de>
Date:   Tue, 24 Oct 2023 19:40:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv8 00/10] scsi: EH rework, main part
Content-Language: en-US
To:     Benjamin Block <bblock@linux.ibm.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20231023092837.33786-1-hare@suse.de>
 <20231024173028.GB1917450@p1gen4-pw042f0m.boeblingen.de.ibm.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20231024173028.GB1917450@p1gen4-pw042f0m.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Authentication-Results: smtp-out1.suse.de;
        none
X-Spamd-Result: default: False [-6.35 / 50.00];
         ARC_NA(0.00)[];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         XM_UA_NO_VERSION(0.01)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         BAYES_HAM(-2.26)[96.52%];
         MIME_GOOD(-0.10)[text/plain];
         NEURAL_HAM_LONG(-3.00)[-1.000];
         RCPT_COUNT_FIVE(0.00)[5];
         DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
         NEURAL_HAM_SHORT(-1.00)[-1.000];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         RCVD_TLS_ALL(0.00)[];
         MID_RHS_MATCH_FROM(0.00)[]
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/24/23 19:30, Benjamin Block wrote:
> Hey Hannes,
> 
> On Mon, Oct 23, 2023 at 11:28:27AM +0200, Hannes Reinecke wrote:
>> Hi all,
>>
>> (taking up an old thread:)
>> here's now the main part of my EH rework.
>> It modifies the reset callbacks for SCSI EH such that
>> each callback (eh_host_reset_handler, eh_bus_reset_handler,
>> eh_target_reset_handler, eh_device_reset_handler) only
>> references the actual entity it needs to work on
>> (ie 'Scsi_Host', (scsi bus), 'scsi_target', 'scsi_device'),
>> and the 'struct scsi_cmnd' is dropped from the argument list.
>> This simplifies the handler themselves as they don't need to
>> exclude some 'magic' command, and we don't need to allocate
>> a mock 'struct scsi_cmnd' when issuing a reset via SCSI ioctl.
>>
>> The entire patchset can be found at:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/hare/scsi-devel.git
>> branch eh-rework.v8
> 
> This doesn't exist (yet?). I also tried to somehow get both part 2 of the
> preparations and this series applied on some tree, but failed.
> Preparations part 2 seems to be based on some form of Linus' master tree, and
> this on Martin's staging tree?
> Maybe I'm just unlucky :D
> 
Maybe you are.
Pushed now, please try again.

Cheers,

Hannes

