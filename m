Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A55DC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Feb 2022 13:03:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237315AbiBWNDc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Feb 2022 08:03:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236296AbiBWNDb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Feb 2022 08:03:31 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1D669319C
        for <linux-scsi@vger.kernel.org>; Wed, 23 Feb 2022 05:03:03 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5C3C0212C0;
        Wed, 23 Feb 2022 13:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1645621382; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MoZvMaxVOffZVBdpnHbyUd8NIzb2YaUuzDozGkrRJS0=;
        b=HbdbBDcLce6T4LvxGfaPHiyIhbb04WOBCIOhUn0d+kgii43ospDlolF47kJybDimQSFryq
        b7ZFCZS8wxsI6xfVAMfUDf5O+yr23qFvcuiWBPk/QCZCh+kXwNsTbYB0KjucEPYnh/BDhP
        4feseRcphkTjtgYyJhIVlCT96thi2pg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1645621382;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MoZvMaxVOffZVBdpnHbyUd8NIzb2YaUuzDozGkrRJS0=;
        b=mTXzthnr12vY+yEjt7As2Y4ONf2KCZaoSjsVvJeqnpHl2k+sMw6GxSLCk2uarpyW+RsDT/
        V0GyQX6K7Dx4hzBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2FE0913D65;
        Wed, 23 Feb 2022 13:03:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id YSVqC4YwFmIuHQAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 23 Feb 2022 13:03:02 +0000
Message-ID: <8cb8268e-d058-cc75-423b-969631496d75@suse.de>
Date:   Wed, 23 Feb 2022 14:03:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCHv2 00/51] SCSI EH argument reshuffle part II
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210817091456.73342-1-hare@suse.de>
 <20210817121307.GA30436@lst.de>
 <1b9ad85c-407d-0877-964c-5f685d8cc702@suse.de> <20220223124956.GA4373@lst.de>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220223124956.GA4373@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/23/22 13:49, Christoph Hellwig wrote:
> On Tue, Aug 17, 2021 at 02:55:25PM +0200, Hannes Reinecke wrote:
>> On 8/17/21 2:13 PM, Christoph Hellwig wrote:
>>> First, thanks for resurrecting the series.
>>>
>>> Second, this giant patchbomb is almost impossible to review.  It might
>>> make sense to resend what is the prep patches without the prototype
>>> changes after the first round of review - maybe we can squeeze those
>>> into 5.15 still and do the heavy lifting with another series per
>>> actually changes method or so.
>>>
>> Sure, can do.
> 
> Do you have another chunk of these patches ready?  It would be so nice
> to see the EH code finally cleaned up..

Sure. Against which tree?
The SCSI pointer and scsi_request removal will have an impact onto these 
patches I guess, so I'd rather code against those patches folded in.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
