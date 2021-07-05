Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6B8FC07E9C
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jul 2021 13:11:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA9D0613FC
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jul 2021 13:11:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbhGENOK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Jul 2021 09:14:10 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:48982 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbhGENOJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jul 2021 09:14:09 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D14FE1FE7F;
        Mon,  5 Jul 2021 13:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1625490691; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5ZDKiqoQQ6Yq9IjrWOV+/xJ+X1cvH5LjKAXJnqar+i8=;
        b=lfgaGR8m1Uvar/aco6idU/TH+Ds5ER1QA/207vREM4mAVpOVawbklT41UptTD/BbaD0oF6
        wXfRT7EiFk96WCmfM5yIukEK0LWq60fg11FMPZdLu5XZc9SnBgk5DX45QG28wG5UVqySof
        JRerra161SiLQ++5YFgDTC/1y5JZqwM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1625490691;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5ZDKiqoQQ6Yq9IjrWOV+/xJ+X1cvH5LjKAXJnqar+i8=;
        b=1+KLmnvCd2Q1dkgR0SNka6z+nR6LDThrH4vs3QqcwV6ZHtfNojzPoSM74r8xVBC+O2KviV
        0cI9jzfL7mrUQ2AA==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 5D3EE13790;
        Mon,  5 Jul 2021 13:11:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id +jCSFQMF42CrKgAAGKfGzw
        (envelope-from <hare@suse.de>); Mon, 05 Jul 2021 13:11:31 +0000
Subject: Re: [dm-devel] [PATCH v5 3/3] dm mpath: add CONFIG_DM_MULTIPATH_SG_IO
 - failover for SG_IO
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Martin Wilck <mwilck@suse.com>, Christoph Hellwig <hch@lst.de>
Cc:     Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org,
        Daniel Wagner <dwagner@suse.de>, emilne@redhat.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        nkoenig@redhat.com, Bart Van Assche <Bart.VanAssche@sandisk.com>,
        Alasdair G Kergon <agk@redhat.com>
References: <20210628151558.2289-1-mwilck@suse.com>
 <20210628151558.2289-4-mwilck@suse.com> <20210701075629.GA25768@lst.de>
 <de1e3dcbd26a4c680b27b557ea5384ba40fc7575.camel@suse.com>
 <20210701113442.GA10793@lst.de>
 <003727e7a195cb0f525cc2d7abda3a19ff16eb98.camel@suse.com>
 <e6d76740-e0ed-861a-ef0c-959e738c3ef5@redhat.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <5909eff8-82fb-039e-41d3-1612c22498a9@suse.de>
Date:   Mon, 5 Jul 2021 15:11:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <e6d76740-e0ed-861a-ef0c-959e738c3ef5@redhat.com>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/5/21 3:02 PM, Paolo Bonzini wrote:
> On 02/07/21 16:21, Martin Wilck wrote:
>>> SG_IO gives you raw access to the SCSI logic unit, and you get to
>>> keep the pieces if anything goes wrong.
>>
>> That's a very fragile user space API, on the fringe of being useless
>> IMO.
> 
> Indeed.  If SG_IO is for raw access to an ITL nexus, it shouldn't be
> supported at all by mpath devices.  If on the other hand SG_IO is for
> raw access to a LUN, there is no reason for it to not support failover.
> 
Or we look at IO_URING_OP_URING_CMD, to send raw cdbs via io_uring.
And delegate SG_IO to raw access to an ITL nexus.
Doesn't help with existing issues, but should get a clean way forward.

... I think I've even tendered a topic at LSF for this ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
