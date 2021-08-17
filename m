Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52C6DC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 14:05:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3196F60232
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 14:05:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237688AbhHQOF4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 10:05:56 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:37554 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235588AbhHQOFw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 10:05:52 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 7C6701FF46;
        Tue, 17 Aug 2021 14:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629209118; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kd4EqDOpodM7vNv1w7K9y4Jl578sZJLBVxYShkrxOYQ=;
        b=TF4Pb/UzDwgEaGTOyzvzKe3MScLycJWTeQTT02vMtNdUOV7M/xNAhDs1ElRm8otATy8KMz
        4ns4AFye8k/17T5ort+Op5mWxUQgD58pfnTdd4QC+On8GUA7G6Yfo2TEDUHYJkNebqUwGF
        4mLb3VRb91KoAUFj0VoGzb4SjkOwbaw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629209118;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kd4EqDOpodM7vNv1w7K9y4Jl578sZJLBVxYShkrxOYQ=;
        b=xrwmaG/Vq1XRFaoEHXSoMN7v3jI5ivtmVIvnHsWfawMrFh3IDnN2fcgWYeEr3Q4GHSaCrE
        zjqAY0GujBNCRmDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5DA3413A91;
        Tue, 17 Aug 2021 14:05:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id w60pFh7CG2EJMQAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 17 Aug 2021 14:05:18 +0000
Subject: Re: [PATCH 06/51] qla1280: separate out host reset function from
 qla1280_error_action()
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
References: <20210817091456.73342-1-hare@suse.de>
 <20210817091456.73342-7-hare@suse.de> <20210817122216.GE30436@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <0b8c8cfb-8c55-55a8-7c31-76c4453c28cb@suse.de>
Date:   Tue, 17 Aug 2021 16:05:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210817122216.GE30436@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/17/21 2:22 PM, Christoph Hellwig wrote:
> On Tue, Aug 17, 2021 at 11:14:11AM +0200, Hannes Reinecke wrote:
>> There's not much in common between host reset and all other error
>> handlers, so use a separate function here.
> 
> This loses the search in the internal queueing list.  Which is probably
> fine, but needs to be explained.
> 
Yeah, correct, I misread the comment.
Will be adding a 'qla1280_wait_for_pending_commands()'.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
