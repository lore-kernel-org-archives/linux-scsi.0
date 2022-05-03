Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D018C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 14:19:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236968AbiECOWv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 10:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236956AbiECOWu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 10:22:50 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E00C2A26A
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 07:19:18 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E29401F747;
        Tue,  3 May 2022 14:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651587556; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U9xY710kSU9Wxyqj5dGDTSXOKe52unzWd3Yy0b/oe08=;
        b=K3BIs9zezy4NeUO+TDyFsdKg1OtqfQE95vi1RrwdKjZYy/eGdpEGHbJQXfS2g7hWBhVxZP
        4vZ6VeB+R/OMNCr/2l5ELEvAT4eqcUmojuTsmje27XeEVg93c7ASKIJMvHFF3mEN7ycRET
        v9frbHpsAvBNiPn65ewPRHEsR7Mb6XY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651587556;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U9xY710kSU9Wxyqj5dGDTSXOKe52unzWd3Yy0b/oe08=;
        b=9GnYCQtHyXksi1MgGTpZxDDOWwbcZxbvS7lIBpayH4ADSxq9hfTFrvaBUT+kgZZNoSNDD1
        OAAHvCr2lru8dPDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A23FC13AA3;
        Tue,  3 May 2022 14:19:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id BPCYG+M5cWLBYgAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 03 May 2022 14:19:15 +0000
Message-ID: <ec918f0a-9452-8536-16fd-4d72bea49224@suse.de>
Date:   Tue, 3 May 2022 07:19:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 14/24] aic79xx: make BUILD_SCSIID() a function
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
References: <20220502213820.3187-1-hare@suse.de>
 <20220502213820.3187-15-hare@suse.de> <20220503141327.GN22590@lst.de>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220503141327.GN22590@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/3/22 07:13, Christoph Hellwig wrote:
> On Mon, May 02, 2022 at 11:38:10PM +0200, Hannes Reinecke wrote:
>> +{
>> +	unsigned int scsiid =
>> +		((sdev_id(sdev) << TID_SHIFT) & TID) | (ahd)->our_id;
>> +
>> +	return scsiid;
> 
> 	return ((sdev_id(sdev) << TID_SHIFT) & TID) | ahd->our_id;
Yep.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
