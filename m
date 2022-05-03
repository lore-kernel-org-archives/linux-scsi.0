Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D16EC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 14:32:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237086AbiECOgK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 10:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236693AbiECOgJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 10:36:09 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F10423134F
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 07:32:36 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 947EF1F747;
        Tue,  3 May 2022 14:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651588354; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NSpNXLV3+Gz23UvDsHwKuGnelcs8Jgy5BtfHR7uCH1M=;
        b=AvfwR33f5Q/s7NDYZbGJU9JVTJYIsXnCi21ECSoeIRQFRAnKkQfeoOmJVBOfMbySYoBOfm
        ffKAK2nVqrRSMeJrQrAo91QpTH9svGf4QJphkS74ZGUzqVbQ9pvx8nEzFJXH+GddzDnLcg
        bP5yM/YmpOxzPCoPFkX/iri+/r2DV0w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651588354;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NSpNXLV3+Gz23UvDsHwKuGnelcs8Jgy5BtfHR7uCH1M=;
        b=FeOPfod0rvhsR/T82HQSH3ouLgXKFQ0wDNHl9/t9kmBNHBpjntNApypMqlbNKr+dKHK3gz
        ZYTezGmng8ereBAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 503DF13AA3;
        Tue,  3 May 2022 14:32:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id E3GwAgE9cWL/aAAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 03 May 2022 14:32:33 +0000
Message-ID: <41b449e5-9a76-99bb-6b26-bfc69ad6d92c@suse.de>
Date:   Tue, 3 May 2022 07:32:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 06/11] bfa: Do not use scsi command to signal TMF status
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
References: <20220502215416.5351-1-hare@suse.de>
 <20220502215416.5351-7-hare@suse.de> <20220503142708.GF24492@lst.de>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220503142708.GF24492@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/3/22 07:27, Christoph Hellwig wrote:
> On Mon, May 02, 2022 at 11:54:11PM +0200, Hannes Reinecke wrote:
>> The bfa driver hijacks the scsi command to signal the TMF status,
>> which will no longer work if the TMF handler will be converted.
>> So rework TMF handling to not use a scsi command but rather add
>> new TMF fields to the per-device structure.
> 
> This looks ok, but also a little sketchy.  Given how unmaintained the
> bfa driver is, maybe it is time just drop it?

Hmm. Opens up interesting possibilities.

While I still have a couple of them, I can't say that I'm actively using 
them. (Quite the contrary, actually.)
And these are FCoE cards to boot, so one actually needs an FCoE switch 
to get them to work. And those have gone out of fashion lately, so the 
driver indeed is bordering on being obsolete.

But not quite, so I'm not sure.

We could ask Broadcom, though; nominally it's their driver after all...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
