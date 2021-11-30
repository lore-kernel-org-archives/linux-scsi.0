Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0997EC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 06:51:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238825AbhK3Gy4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Nov 2021 01:54:56 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:38100 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238824AbhK3Gyz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Nov 2021 01:54:55 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id CD732212C6;
        Tue, 30 Nov 2021 06:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1638255095; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b00+GWWDcpKcyagEKMOLBKxGaFqKPZzkNhnQJidPsZ8=;
        b=aB2Vd1BwWKceCMgrfVlhGe2ifi9gT56tOjuANxh+H5dqz2vEcpy6j1xHJjqfaChWMHI/Lw
        yLMJGX3uJqImxw1wbNqVw1B6A+5tb4ZSQ/V6UUwUcLuAHQqm8iDveKoQuj+A2vQzew07E1
        B/AMi2S0KJIBjfqJi0l+tYkrUxCq6no=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1638255095;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b00+GWWDcpKcyagEKMOLBKxGaFqKPZzkNhnQJidPsZ8=;
        b=Ryp2XjLCcjXiA6zbabDn5TnUnB+jnoh5T109K0nPJu1oB2OFzlANRy6vm9CQswDxdW8v1p
        UzqqzQ623z4RC2AA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A0EE813BA9;
        Tue, 30 Nov 2021 06:51:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 1rH+JffJpWGIVQAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 30 Nov 2021 06:51:35 +0000
Subject: Re: [PATCH 02/15] scsi: add scsi_{get,put}_internal_cmd() helper
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>
References: <20211125151048.103910-1-hare@suse.de>
 <20211125151048.103910-3-hare@suse.de>
 <1eb99f16-5b65-3150-48c6-353b088818ad@acm.org>
 <239804d1-aae7-63ba-c3bf-ca1dd523df6c@suse.de>
 <yq1y256xp5b.fsf@ca-mkp.ca.oracle.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <7dc3ea71-cb0d-2c6d-bcfc-c9e8af61b427@suse.de>
Date:   Tue, 30 Nov 2021 07:51:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <yq1y256xp5b.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/30/21 5:17 AM, Martin K. Petersen wrote:
> 
> Hannes,
> 
>> I have oriented myself at __scsi_execute(), which also has
>> 'data_direction' as an integer.  Presumably to avoid header clutter.
>> Martin?
> 
> Just a vestige from ancient times. I really hate scsi_execute() and its
> 10,000 randomly ordered arguments. The more sanity checking we have in
> that department, the better.
> 
> At some point I proposed having scsi_execute() take a single struct as
> argument to get better input validation. I've lost count how many things
> have been broken because of misordered arguments to this function.
> Backporting patches almost inevitably causes regressions because of this
> interface.
> 
Right. As it so happens, I've already created a patch to include 
<linux/dma-direction.h> here.
But yeah, the arguments to __scsi_execute are patently horrible.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
