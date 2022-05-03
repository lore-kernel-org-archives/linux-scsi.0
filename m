Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CA87C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 18:33:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233768AbiECShG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 14:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232885AbiECShD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 14:37:03 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 635013F88E
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 11:33:24 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id CF0141F74B;
        Tue,  3 May 2022 18:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651602802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cXM+wCQahC7JmUI3kp8MtYudIlJ8gO/Od0hRNXiuZ5Q=;
        b=vnILJgFyzncaRXnW9w1XDNNR+w7y5OSoMUwP2vH240T5NVyBdnJqUitXxdB6gpok4xZTKa
        O7NVjLaFHV2TkStsvSIc6Zam/Jb9FwTszPg43z5Ve+bGbLVXOm1iu79eERf1frQV6elu4P
        hpjQFHLwSFkRzKD85ilMBPh+hPdp8rU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651602802;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cXM+wCQahC7JmUI3kp8MtYudIlJ8gO/Od0hRNXiuZ5Q=;
        b=FJGb5k8lPfoqZo51F05Cd5i3E8/Zny2Uz+XK7ArzDVi6/yzRUZWpfH5I8EIpEcQFVDde2O
        HipurnGFGd2rosBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 135C113AA3;
        Tue,  3 May 2022 18:33:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id KsktNHB1cWIuTwAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 03 May 2022 18:33:20 +0000
Message-ID: <47c32846-7f31-560e-922f-abe315ad3fdc@suse.de>
Date:   Tue, 3 May 2022 11:33:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 01/11] pmcraid: Select device in
 pmcraid_eh_bus_reset_handler()
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
References: <20220502215416.5351-1-hare@suse.de>
 <20220502215416.5351-2-hare@suse.de>
 <245a26dc-3e09-e460-d8dd-5634246ed6d5@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <245a26dc-3e09-e460-d8dd-5634246ed6d5@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/3/22 09:23, Bart Van Assche wrote:
> On 5/2/22 14:54, Hannes Reinecke wrote:
>> The reset code requires a device to be selected, but we shouldn't
>                                                         ^^^^^^^^^^^^
>> rely on the command to provide a device for us. So select the first
>> device on the bus when sending down a bus reset.
> Why is it that we shouldn't rely on the SCSI EH to provide a device? I 
> think this should be explained in the commit message.
> 
Scope.

We should rely on the _device_, we should rely on the _bus_.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
