Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6DE9C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 20 May 2022 06:50:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241646AbiETGuD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 May 2022 02:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346028AbiETGuC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 May 2022 02:50:02 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AE5714D7AD
        for <linux-scsi@vger.kernel.org>; Thu, 19 May 2022 23:49:59 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 020CD1FD73;
        Fri, 20 May 2022 06:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653029398; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=94BNlz1HfZVmAZQ2ywNmBfr2ghLsfwJsb4g+6p2K6TQ=;
        b=LK/bsHNrJDv5vWpnuulwjMto9psMTwopvGD/QrXFmHDhjtUezBjHtGzuQ8T4TVD1m9gJR1
        UsBgXq8Urdo+I4+oDFnS6Ps6Qsa68dkBfqoS+PcL2vrf8utvnopsnL9r5LufiSGLb+b6Xm
        fptJGzo6nbK1KqlI2LmcjZAMQ067y/g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653029398;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=94BNlz1HfZVmAZQ2ywNmBfr2ghLsfwJsb4g+6p2K6TQ=;
        b=/jJg90Y4SbsU6iqG5hoSo9KUHJCqJTE9OEa2tPXY6IFzkghjbxj4VuGbTsMhrbYARGLp2W
        GPAJ2qoUu0kdGECQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7337213A5F;
        Fri, 20 May 2022 06:49:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id P8vZGBU6h2IXIAAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 20 May 2022 06:49:57 +0000
Message-ID: <86d7ebc9-bb33-7f11-1e77-38b9f855d04d@suse.de>
Date:   Fri, 20 May 2022 08:49:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 06/20] qedf: use fc rport as argument for
 qedf_initiate_tmf()
Content-Language: en-US
To:     Ewan Milne <emilne@redhat.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Saurav Kashyap <skashyap@marvell.com>
References: <20220512111236.109851-1-hare@suse.de>
 <20220512111236.109851-7-hare@suse.de>
 <CAGtn9rkR02KF8QikQ0J6MskocA6VQ385ajoz36Q7RH32VXBjGg@mail.gmail.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <CAGtn9rkR02KF8QikQ0J6MskocA6VQ385ajoz36Q7RH32VXBjGg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/19/22 11:22, Ewan Milne wrote:
> The patch changes the data type of the 'lun' argument to qedf_flush_active_ios()
> to a u64, but the remaining code still uses a wildcard of -1, perhaps
> this needs a
> #define or enum of a value that is unsigned also?
> 
Ah, no, I went slightly overboard there. That needs to be changed back 
to be an 'int'.

> Removing the call to fc_remote_port_chkready() in qedf_initiate_tmf()
> will result
> in different semantics for whether the TMF will be issued.
> 
Really? 'fc_remote_port_chkready()' just evaluates the port state;
this is also done by fc_block_rport().
So dropping the first shouldn't make a difference.

> Changing the debug logging in qedf_eh_target_reset() and qedf_eh_device_reset()
> might make identifying the target more difficult, although
> qedf_initiate_tmf() will
> also log a message, the rport->scsi_target_id is not the same value as
> the sdev->id.
> 
Sigh. Yes, the error logging is suboptimal.
Will be updating it.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman
