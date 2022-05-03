Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53F7CC433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 14:18:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236977AbiECOWZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 10:22:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236956AbiECOWX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 10:22:23 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC05129830
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 07:18:50 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 81F8A1F38D;
        Tue,  3 May 2022 14:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651587529; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JC+zXCpNxbVxk15z80Ek7UUoPDoMArDqL6PMy5ifHnQ=;
        b=MRH38lFfE1vaIHnawgW/msoB9zLgLLp/xmYmN9Tf2jYJKym1QDs0eZ8lGbPwThBvVUq5wW
        K3dHAsglhqJQA2v4yjsVM+GDELD5XVwXD8Byfw/mlE9hNErbqK8rEAE2NVxzU8oAkmRjWd
        7W48nX26NR9v5Z20MTdpntG7XlQpp2w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651587529;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JC+zXCpNxbVxk15z80Ek7UUoPDoMArDqL6PMy5ifHnQ=;
        b=jchcJusIKuhtFy49s6W4bUZ36kTzcJMWOHNcTDxUr3mQ1wpvL5nRJWiZys4W2BU9r3NBQP
        I7V/cdinX4fC06CQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1860B13AA3;
        Tue,  3 May 2022 14:18:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id kX1hNcc5cWKLYgAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 03 May 2022 14:18:47 +0000
Message-ID: <e7b63eea-b3f0-88b0-6004-864dd543cafc@suse.de>
Date:   Tue, 3 May 2022 07:18:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 13/24] aic7xxx: make BUILD_SCSIID() a function
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
References: <20220502213820.3187-1-hare@suse.de>
 <20220502213820.3187-14-hare@suse.de> <20220503141249.GM22590@lst.de>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220503141249.GM22590@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/3/22 07:12, Christoph Hellwig wrote:
>> +{
>> +	unsigned int scsiid =
>> +		((sdev->id << TID_SHIFT) & TID) |
>> +		((sdev->channel == 0) ? ahc->our_id : ahc->our_id_b) |
>> +		(sdev->channel == 0) ? 0 : TWIN_CHNLB;
>> +	return scsiid;
> 
> This still look weird.  Why not:
> 
> 	unsigned int scsiid = (sdev->id << TID_SHIFT) & TID);
> 
> 	if (sdev->channel == 0) {
> 		scsiid |= ahc->our_id;
> 	else
> 		scsiid |= ahc->our_id_b | TWIN_CHNLB;
> 	return scsiid;
> 
> ?
Yeah, kbuild had been complaining, too.

Will be fixing it up.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
