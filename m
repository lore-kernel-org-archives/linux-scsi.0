Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B78E8C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 12:54:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9192560F41
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 12:54:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236658AbhHQMz0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 08:55:26 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:36064 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbhHQMzX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 08:55:23 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B6E5121F7E;
        Tue, 17 Aug 2021 12:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629204889; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0Z97zM+FltNS76q3FKRyxeP7i1SRAYtMfLttk7AgPIo=;
        b=L8VWCfaoDVJ8tfTk0v10AsV+GcPz1mfyQ+DGhyFMbnfamDhQLKlTi9K2DDfEKYs34/8YE7
        maaxeZneYTvdbJk/H79r30MeOwhnB3xfWgEqqZ8XLmDYZWuioV/2l47faP81HX+TpxZ8Mu
        qQJ3wuZmmNYhdULtT0ootKCp1dZXO8U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629204889;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0Z97zM+FltNS76q3FKRyxeP7i1SRAYtMfLttk7AgPIo=;
        b=0RB/UTd+ZrrhwiTU0OucJLSUdXLHf/Vzmy7ysp8TEGRPiXKzCxmCJmL784lQZfbuq3FXI7
        9sG0oF4LfOmaKODQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A63AD13A98;
        Tue, 17 Aug 2021 12:54:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id IjxsKJmxG2FcGQAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 17 Aug 2021 12:54:49 +0000
Subject: Re: [PATCH 08/51] zfcp: open-code fc_block_scsi_eh() for host reset
To:     Benjamin Block <bblock@linux.ibm.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Steffen Maier <maier@linux.ibm.com>
References: <20210817091456.73342-1-hare@suse.de>
 <20210817091456.73342-9-hare@suse.de>
 <YRujHScPbb1Aokrj@t480-pf1aa2c2.linux.ibm.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <fdf138d0-f730-a985-e5d5-894a14a2c978@suse.de>
Date:   Tue, 17 Aug 2021 14:54:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YRujHScPbb1Aokrj@t480-pf1aa2c2.linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/17/21 1:53 PM, Benjamin Block wrote:
> On Tue, Aug 17, 2021 at 11:14:13AM +0200, Hannes Reinecke wrote:
>> @@ -383,9 +385,24 @@ static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
>>  	}
>>  	zfcp_erp_adapter_reopen(adapter, 0, "schrh_1");
>>  	zfcp_erp_wait(adapter);
>> -	fc_ret = fc_block_scsi_eh(scpnt);
>> -	if (fc_ret)
>> -		ret = fc_ret;
>> +retry_rport_blocked:
>> +	spin_lock_irqsave(host->host_lock, flags);
>> +	list_for_each_entry(port, &adapter->port_list, list) {
> 
> You need to take the `adapter->port_list_lock` to iterate over the `port_list`.
> 
> i.e.: read_lock_irqsave(&adapter->port_list_lock, flags);
> 
>> +		struct fc_rport *rport = port->rport;
>> +
>> +		if (rport->port_state == FC_PORTSTATE_BLOCKED) {
>> +			if (rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT)
>> +				ret = FAST_IO_FAIL;
>> +			else
>> +				ret = NEEDS_RETRY;
>> +			break;
>> +		}
>> +	}
>> +	spin_unlock_irqrestore(host->host_lock, flags);
>> +	if (ret == NEEDS_RETRY) {
>> +		msleep(1000);
>> +		goto retry_rport_blocked;
>> +	}
> 
> I really can't say I like this open coded FC code in the driver at all.
> 
> Is there a reason we can't use `fc_block_rport()` for all the rports of
> the adapter?
> 
> We already do use it for other EH callbacks in the same file, and you
> already look up the rports in the adapters rport-list; so using that on
> the rports in the loop, instead of open-coding it doesn't seem bad? Or
> is there a locking problem? 
> 
> We might waste a few cycles with that, but frankly, this is all in EH
> and after adapter reset.. all performance concerns went our of the
> window with that already.
> 

Question would be why we need to call fc_block_rport() at all in host reset.
To my understanding a host reset is expected to do a full resync of the
SAN topology, so the expectation is that after zfcp_erp_wait() the port
list is stable (ie the HBA has finished processing all RSCNs related to
the SAN resync).
So can't we just drop the fc_block_rport() call here?
All the other FC drivers do fine without that ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
