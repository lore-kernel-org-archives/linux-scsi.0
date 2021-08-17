Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27920C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 12:55:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C3CD60F5C
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 12:55:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236658AbhHQM4C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 08:56:02 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:36086 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbhHQMz7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 08:55:59 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D320121F86;
        Tue, 17 Aug 2021 12:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629204925; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=znC/QIGmozTXNGBITxF9za/cyeBcHohNO0LGZzIcoBs=;
        b=FObmYga7PDjarnAtrEAUIt9sjGg3eVYhkCCHhnFNZiSPvqFxj4AZS1tiKufFU1YglvisiG
        HF+Yjviz3Ggf4K51NA8J/IJb4AQ9LtveySEhWpKK86Ov5khm1z0usZpDzClycNvLmGTErP
        f4DO+CGNKDW2SFuf9YkBtFz5anPa2TE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629204925;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=znC/QIGmozTXNGBITxF9za/cyeBcHohNO0LGZzIcoBs=;
        b=pBLNJCVt0o8f8g0QKOz0chAYAPSdtMSSuRRLDcyRjQHKEodgu1HrjII1mbeBT10nhhLQn0
        8T7IrzqyuM3fuaBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BC90513A98;
        Tue, 17 Aug 2021 12:55:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id xKazLb2xG2GVGQAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 17 Aug 2021 12:55:25 +0000
Subject: Re: [PATCHv2 00/51] SCSI EH argument reshuffle part II
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210817091456.73342-1-hare@suse.de>
 <20210817121307.GA30436@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <1b9ad85c-407d-0877-964c-5f685d8cc702@suse.de>
Date:   Tue, 17 Aug 2021 14:55:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210817121307.GA30436@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/17/21 2:13 PM, Christoph Hellwig wrote:
> First, thanks for resurrecting the series.
> 
> Second, this giant patchbomb is almost impossible to review.  It might
> make sense to resend what is the prep patches without the prototype
> changes after the first round of review - maybe we can squeeze those
> into 5.15 still and do the heavy lifting with another series per
> actually changes method or so.
> 
Sure, can do.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
