Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D38A5C7EE2C
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Aug 2023 16:46:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241812AbjHXQpd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Aug 2023 12:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242708AbjHXQpD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Aug 2023 12:45:03 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7103EE5E;
        Thu, 24 Aug 2023 09:45:01 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 3033E1F88D;
        Thu, 24 Aug 2023 16:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1692895500; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+Nsnu3FVFEf2s//PM+Ab1noHHPFDjezVWOK+iyVWb0A=;
        b=iFVtmC5a7oYjp0vGAd1IQNPyUFDL8Y1gaOshRwYkg7C3QRLu2jMtmRSKeSjeAHrnnqk/ZI
        42SfGP70rN1DZfwH2f1lBbW/hkD7AEJv4cdbXoj8xpe60KaJfjNWlyshT0iraoKjviNOsr
        zgEWuNPRN0AQ1NU9fZrzCFqBPqPyk1A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1692895500;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+Nsnu3FVFEf2s//PM+Ab1noHHPFDjezVWOK+iyVWb0A=;
        b=i8dJgPwkPqF1zkv4F8gzerF1G46/gQiu4F7fSK5yE23eX4/aqB62DOogJTqnV8gCAe+/Lc
        7M6HuB0C1DyO2sAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 61FED1336F;
        Thu, 24 Aug 2023 16:44:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id yVAPCQqJ52QKZgAAMHmgww
        (envelope-from <hare@suse.de>); Thu, 24 Aug 2023 16:44:58 +0000
Message-ID: <5c36ae01-a806-a36b-0196-41c217f78307@suse.de>
Date:   Thu, 24 Aug 2023 18:44:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v11 04/16] scsi: core: Introduce a mechanism for
 reordering requests in the error handler
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
References: <20230822191822.337080-1-bvanassche@acm.org>
 <20230822191822.337080-5-bvanassche@acm.org>
 <3562fc36-4bc2-b4fb-a2ad-1e310baf1b47@suse.de>
 <078d2954-f4af-6678-29ce-d8f65ff1397a@acm.org>
 <741e19ae-d4fd-11f5-7faa-18b888ff769c@kernel.org>
 <6355b575-3f59-93dc-5acf-4726c6e80a15@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <6355b575-3f59-93dc-5acf-4726c6e80a15@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/24/23 16:47, Bart Van Assche wrote:
> On 8/23/23 16:22, Damien Le Moal wrote:
>> The sd driver does have zone append emulation using regular writes. The
>> emulation relies on zone write locking to avoid issues with adapters 
>> that do not
>> have strong ordering guarantees, but that could be adapted to be 
>> removed for UFS
>> devices with write ordering guarantees. This solution would greatly 
>> simplify
>> your series since zone append requests are not subject to zone write 
>> locking at
>> the block layer. So no changes would be needed at that layer.
>>
>> However, that implies that your preferred use case (f2fs) must be 
>> adapted to use
>> zone append instead of regular writes. That in itself may be a bigger-ish
>> change, but in the long run, likely a better one I think as that would be
>> compatible with NVMe ZNS and also future UFS standards defining a zone 
>> append
>> command.
> 
> Hi Damien,
> 
> Thanks for the feedback. I agree that it would be great to have zone append
> support in F2FS. However, I do not agree that switching from regular writes
> to zone append in F2FS would remove the need for sorting SCSI commands 
> by LBA in the SCSI error handler. Even if F2FS would submit zoned writes
> then the following mechanisms could still cause reordering of the zoned
> write after these have been translated into regular writes:
> * The SCSI protocol allows SCSI devices, including UFS devices, to respond
> with a unit attention or the SCSI BUSY status at any time. If multiple 
> write commands are pending and some of the pending SCSI writes are not
> executed because of a unit attention or because of another reason, this
> causes command reordering.

Yes. But the important thing to remember is that with 'zone append' the 
resulting LBA will be returned on completion, they will _not_ be 
specified in the submission. So any command reordering doesn't affect 
the zone append commands as they heven't been written yet.

> * Although the link between the UFS controller and the UFS device is pretty
> reliable, there is a non-zero chance that a SCSI command is lost. If this
> happens the SCSI timeout and error handlers are activated. This can cause
> reordering of write commands.
> 
Again, reordering is not an issue with zone append. With zone append you 
specify in which zone the command should land, and upon completion the 
LBA where the data is written will be returned.

So if there is an error the command has not been written, consequently 
there is no LBA to worry about, and you can reorder at will.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

