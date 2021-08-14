Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32E9CC4338F
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Aug 2021 12:35:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0876960EE5
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Aug 2021 12:35:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbhHNMfm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 14 Aug 2021 08:35:42 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:55590 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbhHNMfk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Aug 2021 08:35:40 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 054E91FDA6;
        Sat, 14 Aug 2021 12:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628944511; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0mSLRG4xDh73yGpT5sZqSuFSCGEpnHG4QqeLtGAJFSk=;
        b=OJLfPIOlAMT9RiExgo0tp08cwdLVDY69jfF957PcCwowIcmKgonUjPdmbkVFGkGX5h3bGr
        /OmboTwBT22nzRF/Mbb+ay+MDijm19u2cNKg93dN6u6tg8Iu8mGJ/yZM44UoFhtPChgXng
        D7+d1wuYDsAncWiR28MEqJ+lxo87HZE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628944511;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0mSLRG4xDh73yGpT5sZqSuFSCGEpnHG4QqeLtGAJFSk=;
        b=q6zCyHElYT9TcjjFWV2mXyhGHAVUjHtrTMkSOWGxmRFnwYtC98ziQdSzdOik1dQBkAq4WB
        u77jn2RP7fev0ABA==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id AFA9C13733;
        Sat, 14 Aug 2021 12:35:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id tAvMKX64F2GDPQAAGKfGzw
        (envelope-from <hare@suse.de>); Sat, 14 Aug 2021 12:35:10 +0000
Subject: Re: [PATCH 2/3] scsi: fnic: Stop setting scsi_cmnd.tag
To:     Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     John Garry <john.garry@huawei.com>, satishkh@cisco.com,
        sebaddel@cisco.com, kartilak@cisco.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1628862553-179450-1-git-send-email-john.garry@huawei.com>
 <1628862553-179450-3-git-send-email-john.garry@huawei.com>
 <3e5d1bd4-cee9-7fd0-93a4-58d808e198f6@acm.org>
 <20210814073948.GA21536@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <b6216e3f-5339-18e4-ca31-61c7968efbb1@suse.de>
Date:   Sat, 14 Aug 2021 14:35:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210814073948.GA21536@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/14/21 9:39 AM, Christoph Hellwig wrote:
> On Fri, Aug 13, 2021 at 08:17:45PM -0700, Bart Van Assche wrote:
>> On 8/13/21 6:49 AM, John Garry wrote:
>>> It is never read. Setting it and the request tag seems dodgy
>>> anyway.
>>
>> This is done because there is code in the SCSI error handler that may
>> allocate a SCSI command without allocating a tag. See also
>> scsi_ioctl_reset().
> 
> Yes.  Hannes had a great series to stop passing the pointless scsi_cmnd
> to the reset methods.  Hannes, any chance you coul look into
> resurrecting that?
> 
Sure.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
