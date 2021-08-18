Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53F26C4338F
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 11:58:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3964D60462
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 11:58:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235358AbhHRL7L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Aug 2021 07:59:11 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:35034 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235606AbhHRL7K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Aug 2021 07:59:10 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id F0E142202A;
        Wed, 18 Aug 2021 11:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629287914; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lvYO2Gkqhb1OZ71iKcvn+AGcmtClwRwsmq3u+x/WP44=;
        b=M1YdW5krGnbA0vk6GP0bTqobAXsS/2oXEBQrAAVKA51/aV0mlY78MxHSnLalW8p/GRACpL
        7woHFj/Oxo+dkePrTv7h18OKqQsjOLCjGDhIv530cKNzXDyVDCeas2OEnO4GosyXGpMRC3
        8ctWf2wK6+4JQcZsjUbxeztGxfGN6Rg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629287914;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lvYO2Gkqhb1OZ71iKcvn+AGcmtClwRwsmq3u+x/WP44=;
        b=j82tQ0yEyRXgQ6uTIiHxaBKc2fa/tTI4ZOH8EQlIMXkTRTJjORrAmDql/L792Q9Y63vuMD
        +3Ir2cXt9XsZ/nAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DBFB5144F1;
        Wed, 18 Aug 2021 11:58:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id zMMINer1HGEgHgAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 18 Aug 2021 11:58:34 +0000
To:     Steffen Maier <maier@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
References: <20210817091456.73342-1-hare@suse.de>
 <20210817091456.73342-9-hare@suse.de>
 <YRujHScPbb1Aokrj@t480-pf1aa2c2.linux.ibm.com>
 <fdf138d0-f730-a985-e5d5-894a14a2c978@suse.de>
 <c9e8ad26-f78c-94d3-5c39-8e7ac15a165a@linux.ibm.com>
 <30e9ee6e-0ce5-63ea-ba3b-a89a1f6c1705@suse.de>
 <156b07d7-30f1-eeda-ef3c-376f767d8031@linux.ibm.com>
From:   Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 08/51] zfcp: open-code fc_block_scsi_eh() for host reset
Message-ID: <51637216-16ae-f005-8c23-9e40de6b30d2@suse.de>
Date:   Wed, 18 Aug 2021 13:58:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <156b07d7-30f1-eeda-ef3c-376f767d8031@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/18/21 1:00 PM, Steffen Maier wrote:
> On 8/17/21 4:10 PM, Hannes Reinecke wrote:
>> On 8/17/21 4:03 PM, Steffen Maier wrote:
[ .. ]
>>> It would have been nice to have a common interface for all scsi_eh
>>> scopes. I.e. fc_block_host(struct Scsi_Host*) like we already have for
>>> fc_block_scsi_eh(struct scsi_cmnd*) and fc_block_rport(struct fc_rport*)
>>> [the latter having been introduced at the time of above eh callback
>>> preparations].
>>> But if zfcp is the only one needing it for host_reset, having the code
>>> only in zfcp seems fine to me.
>>>
>>>
>> Right. Just wanted to clarify that.
>> If we need to use fc_block_rport() in host reset so be it; just wanted
>> to clarify if this _really_ is the case (and not just some copy'n'paste
>> stuff).
>> I'll be reworking the patch to call fc_block_rport().
> 
> On second thought, I might have been wrong.
> 
> The argument I used with the old commit was that we must not unblock the
> rport too early with regards to zfcp-internal recovery. This is fixed
> within zfcp recovery (erp) code. So after zfcp_erp_wait() in host_reset,
> this is still ensured; and eventually the rport unblock will occur.
> 
> I guess I was rather worried about returning from the host_reset
> callback with the async rport(s) unblock still pending. After all,
> (some) other reset_handler sync with rport unblock. However I cannot
> remember all details right now.
> 
> Before you invest more time into this, maybe just drop this patch from
> the series for now and we solve it later on? I mean it's not necessary
> for the reset_handler function signature change.
> 
Well, actually it is.
With the signature change host_reset is being called with a Scsi_Host
argument, so we cannot identify 'the' rport.
But I've modified the patch to cycle through all rports and call
fc_block_rport() on each of them.
That should be good enough for now.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
