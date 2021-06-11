Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97380C4743D
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Jun 2021 07:38:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77581611CD
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Jun 2021 07:38:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbhFKHkZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Jun 2021 03:40:25 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:39238 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbhFKHkX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Jun 2021 03:40:23 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 97D9F1FD3F;
        Fri, 11 Jun 2021 07:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623397105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+hn8hFF6kS7TgiimX4lazExB/Xpz2l9Fk1xSoftba0E=;
        b=YyLQbZDYpJlLwC9VvpFn2prQkq4Xaxc72vG1d1+crdihIOUrMLO/G97R9lwY+hxf/fg504
        emCGdG0Valkpavk2QyJwaq71E8fhHufYqEz42SG+zf4VvQx3dqIGwc+nLy85g9G9Trb/cV
        YSDdbB1C32HKV+8LdmSarVLsucu/aYw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623397105;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+hn8hFF6kS7TgiimX4lazExB/Xpz2l9Fk1xSoftba0E=;
        b=FrhmGqBEeVGLHfFtinuniZcv+56jPvF2jyJQfxKiQDS7F4LDAAh4Z4sKKUu/0wxfsq986/
        QpOPuJzg3pNAScAg==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 7CBBD118DD;
        Fri, 11 Jun 2021 07:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623397105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+hn8hFF6kS7TgiimX4lazExB/Xpz2l9Fk1xSoftba0E=;
        b=YyLQbZDYpJlLwC9VvpFn2prQkq4Xaxc72vG1d1+crdihIOUrMLO/G97R9lwY+hxf/fg504
        emCGdG0Valkpavk2QyJwaq71E8fhHufYqEz42SG+zf4VvQx3dqIGwc+nLy85g9G9Trb/cV
        YSDdbB1C32HKV+8LdmSarVLsucu/aYw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623397105;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+hn8hFF6kS7TgiimX4lazExB/Xpz2l9Fk1xSoftba0E=;
        b=FrhmGqBEeVGLHfFtinuniZcv+56jPvF2jyJQfxKiQDS7F4LDAAh4Z4sKKUu/0wxfsq986/
        QpOPuJzg3pNAScAg==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id ZqrdHfESw2ASGAAALh3uQQ
        (envelope-from <hare@suse.de>); Fri, 11 Jun 2021 07:38:25 +0000
Subject: Re: [PATCH 13/24] scsi: Kill DRIVER_SENSE
To:     Jiri Slaby <jirislaby@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        linux-scsi@vger.kernel.org
References: <20191021095322.137969-1-hare@suse.de>
 <20191021095322.137969-14-hare@suse.de>
 <a5551d37-8303-2cbb-f82a-17fea785adad@kernel.org>
 <c48e74e9-4bbb-d892-4976-06bb448f5f6c@suse.de>
 <yq1bl8hn9py.fsf@ca-mkp.ca.oracle.com>
 <e2c75feb-cd87-1681-a5ee-6aed7ee82e11@suse.de>
 <6d5c893d-61c1-fad9-78f5-17b41f19706d@kernel.org>
 <723d9d8b-5dde-839f-efe6-164177f5c1ce@suse.de>
 <b91a17a7-3bfd-b882-ce15-fa9991315293@kernel.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <80a6d6fe-c1ab-e27f-7c01-2946c53ebac8@suse.de>
Date:   Fri, 11 Jun 2021 09:38:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <b91a17a7-3bfd-b882-ce15-fa9991315293@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/11/21 6:50 AM, Jiri Slaby wrote:
> On 10. 06. 21, 16:01, Hannes Reinecke wrote:
>>>> Can you test with this patch?
>>>
>>> Yes, that boots, but is somehow sloooow (hard to tell what is causing
>>> this).
>>>
>>> Anyway, the new print is still there with the patch:
>>> [   11.549986] sd 0:0:0:0: Power-on or device reset occurred
>>>
>>> Cool; one step further.
>> Can you check if the attached patch helps, too?
> 
> No, this doesn't boot:
> [   20.293526] scsi host0: Virtio SCSI HBA
> [   22.236517] scsi 0:0:0:0: Power-on or device reset occurred
> [   22.237986] scsi 0:0:0:0: Power-on or device reset occurred
> 
Ok, thought so.
So it's really looks like the virtio driver is copying stale sense data.

Next try:
Can you take the patch from the mailing list (virtio_scsi: do not 
overwrite SCSI status), and enable SCSI logging level eg via

  scsi.scsi_logging_level=216

on the kernel command line.
That should give us some hint why it's so slow.

Alternatively: which configuration do you use?
Maybe I can reproduce it here locally ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
