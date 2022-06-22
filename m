Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4C3AC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jun 2022 10:49:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234685AbiFVKti (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jun 2022 06:49:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiFVKth (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jun 2022 06:49:37 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39D0A3BA54
        for <linux-scsi@vger.kernel.org>; Wed, 22 Jun 2022 03:49:36 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C4D8D1F8CF;
        Wed, 22 Jun 2022 10:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1655894974; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8JVpMsqcjUOls5EVCPc1/0YEcBeqGLH66vc/7LH5uSQ=;
        b=YLwj9HKAebtMt2ObsMHy3RNtT+1seb3ol4v2vahOvAp9xbxhkHGf9vjKsvEtbbDg9b6/KS
        sq3mw/O7lAVxmUnX6LDy5roXBSryQmQFG6A+2cHJVuhPMxwaKPxnPBwxWIMkAalHir9MpR
        y9dd1O5IKbw5aQIxl4w7jqIEjCAKo2o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1655894974;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8JVpMsqcjUOls5EVCPc1/0YEcBeqGLH66vc/7LH5uSQ=;
        b=i8fnI5bExokzS7ssF6cwxxTwmLA0UsoUo5NlQVwxgpb/mw1prXI9JD7NogIzYDKPPIfqwM
        bpWKQz6pMaflJSCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9F35E134A9;
        Wed, 22 Jun 2022 10:49:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 2/gCJr7zsmJ5VwAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 22 Jun 2022 10:49:34 +0000
Message-ID: <aabbe36e-1791-78b1-ec1e-8a95fbd29895@suse.de>
Date:   Wed, 22 Jun 2022 12:49:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 1/2] scsi: add BLIST_RETRY_SCAN to ignore errors during
 scanning
Content-Language: en-US
To:     Martin Wilck <mwilck@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>
References: <20220615164149.3092-1-mwilck@suse.com>
 <20220615164149.3092-2-mwilck@suse.com>
 <yq15yktjw77.fsf@ca-mkp.ca.oracle.com>
 <d409f1856e46c3df951eaac9eed14844c66961fa.camel@suse.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <d409f1856e46c3df951eaac9eed14844c66961fa.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/22/22 10:16, Martin Wilck wrote:
> On Tue, 2022-06-21 at 22:02 -0400, Martin K. Petersen wrote:
>>
>> Martin,
>>
>>> @@ -1531,9 +1536,10 @@ static int scsi_report_lun_scan(struct
>>> scsi_target *starget, blist_flags_t bflag
>>>                                      " allowed by the host
>>> adapter\n", lun);
>>>                  } else {
>>>                          int res;
>>> +                       blist_flags_t bflags = BLIST_RETRY_SCAN;
>>
>> I'm not a big fan of using the bflag as carrier of "I was reported
>> and
>> therefore must exist".
>>
>> Also: Why isn't patch #2 sufficient?
> 
> I think it is. I can resubmit just #2 if you prefer and Hannes agrees.
> 
I'm fine with just adding #2; #1 is really just there to provide the 
original behaviour. Device probing is one of the most arcane areas
in the SCSI stack due to all the various quirks etc and I didn't want
to change anything here.

But if it's okay, it's okay :-)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
