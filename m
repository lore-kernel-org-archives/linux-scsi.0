Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 487D0CDB474
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Oct 2023 08:14:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234622AbjJQIOX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Oct 2023 04:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234469AbjJQIOW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Oct 2023 04:14:22 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C9D993
        for <linux-scsi@vger.kernel.org>; Tue, 17 Oct 2023 01:14:21 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id BCF171FF08;
        Tue, 17 Oct 2023 08:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1697530459; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sYG+TBvPBFJM0XTLqbrxmyMb9VPXTCAaHUj/qFnI+gc=;
        b=KCeTVy3mqnxqq/l3C/R0Sc5x3/zhWLvajch1MBR/fOXa04awE93adCm7E5YIUTKgGt+uE7
        MvLSIrCANlMvnFDX0PSiTA5qMwDCX9fWTrQ7LdUBFQPVF80/4T7M2Nrv2u/AgxvyDC23jl
        +1t296oc4Jc3/UhmKtsk+igwr5y1wek=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1697530459;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sYG+TBvPBFJM0XTLqbrxmyMb9VPXTCAaHUj/qFnI+gc=;
        b=Hmuz2RLg8eLZLexEsGiG2AuMgtKBjN3IXVi2MR5oIl1vl0U3lS1OROm7mHhoqOdPHVlrdX
        RXbL+f6FoT1gdABw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AB06D13597;
        Tue, 17 Oct 2023 08:14:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id okXdKFtCLmVvRgAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 17 Oct 2023 08:14:19 +0000
Message-ID: <af6c6f63-aa40-4045-8079-0f8268d7314b@suse.de>
Date:   Tue, 17 Oct 2023 10:14:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/9] scsi: set host byte after EH completed
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20231016121542.111501-1-hare@suse.de>
 <20231016121542.111501-6-hare@suse.de> <20231017072529.GA11484@lst.de>
Content-Language: en-US
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20231017072529.GA11484@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Authentication-Results: smtp-out2.suse.de;
        none
X-Spamd-Result: default: False [-4.43 / 50.00];
         ARC_NA(0.00)[];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         XM_UA_NO_VERSION(0.01)[];
         FROM_HAS_DN(0.00)[];
         RCPT_COUNT_THREE(0.00)[4];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         NEURAL_HAM_LONG(-3.00)[-1.000];
         BAYES_HAM(-0.34)[76.29%];
         DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
         NEURAL_HAM_SHORT(-1.00)[-1.000];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         RCVD_TLS_ALL(0.00)[];
         MID_RHS_MATCH_FROM(0.00)[]
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/17/23 09:25, Christoph Hellwig wrote:
> On Mon, Oct 16, 2023 at 02:15:38PM +0200, Hannes Reinecke wrote:
>> When SCSI EH completes we should be setting the host byte to
>> DID_ABORT, DID_RESET, or DID_TRANSPORT_DISRUPTED to inform
>> the caller that some EH processing has happened.
> 
> I have a hard time following this commit log.  Yes, we probably
> should.  But so far we haven't, so why is this suddenly a problem?
> 
>> -void scsi_eh_finish_cmd(struct scsi_cmnd *scmd, struct list_head *done_q)
>> +void __scsi_eh_finish_cmd(struct scsi_cmnd *scmd, struct list_head *done_q,
>> +			int host_byte)
>>   {
>> +	if (host_byte)
>> +		set_host_byte(scmd, host_byte);
>>   	list_move_tail(&scmd->eh_entry, done_q);
> 
> What is the point of passing in the host_byte vs just setting it in
> the caller?
> 
Hmm. Sure, could do.

> In fat I'm not even quite sure what the point of the existing helper
> is, as moving the command to the passed in queue doesn't provide
> much of a useful abstraction.
> 
Share your sentiments.
One could open-code it, but if I move the host_byte setting into the
caller this function won't be touched at all.
And it's time to clean up the entire list splice-and-dice game in
SCSI EH once this rework is in; my plan is to move failed commands
onto a per-entity list, and merge them onto the next higher entity
list once an escalation fails.

So maybe shelf it for now, and just open-code the host_byte setting
in the caller.

Cheers,

Hannes

