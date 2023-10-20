Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E64FC001DF
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Oct 2023 05:55:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376326AbjJTFzP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Oct 2023 01:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346971AbjJTFzK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Oct 2023 01:55:10 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E6A010DD
        for <linux-scsi@vger.kernel.org>; Thu, 19 Oct 2023 22:55:05 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B242C1FD76;
        Fri, 20 Oct 2023 05:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1697781302; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tdKPsEKS6ipak0vEqpYsymsWXZw4li8khMBkMGhp+3E=;
        b=rMjsES+TD7NQB5ZRIekhgA+UR4aMetu2S1dyFQ3JpjJA5QDonZBkoRtTIzDj6Nw2GZJjsY
        XaEsmUjr9Z7O0Fy/OyJ5IiOMxZlvCpuw72IMXPCZNevrb281Xx/jEBV5j0ymgmUNhkDvQA
        2xkxe/wScs0zxJbOmt5thO2PWPNm510=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1697781302;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tdKPsEKS6ipak0vEqpYsymsWXZw4li8khMBkMGhp+3E=;
        b=QYvw0xJ/fKn7bwUASXiy63IjoSTSijKof7mau3+12OWan0tnErwyrpPNoDb3vrExldv9Eb
        m0JLlAwVS3NB56AQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 71927138E2;
        Fri, 20 Oct 2023 05:55:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 2dxZGjYWMmX2ZQAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 20 Oct 2023 05:55:02 +0000
Message-ID: <7890ef89-669f-466b-a3e0-94f8beb01009@suse.de>
Date:   Fri, 20 Oct 2023 07:55:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/9] scsi: set host byte after EH completed
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20231016121542.111501-1-hare@suse.de>
 <20231016121542.111501-6-hare@suse.de>
 <df55e6b2-8da1-4c20-8881-9792775ff392@oracle.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <df55e6b2-8da1-4c20-8881-9792775ff392@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out2.suse.de;
        none
X-Spamd-Result: default: False [-5.57 / 50.00];
         ARC_NA(0.00)[];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         XM_UA_NO_VERSION(0.01)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         BAYES_HAM(-1.48)[91.58%];
         MIME_GOOD(-0.10)[text/plain];
         NEURAL_HAM_LONG(-3.00)[-1.000];
         RCPT_COUNT_FIVE(0.00)[5];
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

On 10/19/23 22:30, Mike Christie wrote:
> On 10/16/23 7:15 AM, Hannes Reinecke wrote:
>> @@ -1671,7 +1682,8 @@ static int scsi_eh_target_reset(struct Scsi_Host *shost,
>>   			if (rtn == SUCCESS)
>>   				list_move_tail(&scmd->eh_entry, &check_list);
>>   			else if (rtn == FAST_IO_FAIL)
>> -				scsi_eh_finish_cmd(scmd, done_q);
>> +				__scsi_eh_finish_cmd(scmd, done_q,
>> +						     DID_TRANSPORT_DISRUPTED);
>>   			else
>>   				/* push back on work queue for further processing */
>>   				list_move(&scmd->eh_entry, work_q);
>> @@ -1736,8 +1748,9 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
>>   			list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
>>   				if (channel == scmd_channel(scmd)) {
>>   					if (rtn == FAST_IO_FAIL)
>> -						scsi_eh_finish_cmd(scmd,
>> -								   done_q);
>> +						__scsi_eh_finish_cmd(scmd,
>> +								     done_q,
>> +								     DID_TRANSPORT_DISRUPTED);
>>   					else
>>   						list_move_tail(&scmd->eh_entry,
>>   							       &check_list);
>> @@ -1780,9 +1793,9 @@ static int scsi_eh_host_reset(struct Scsi_Host *shost,
>>   		if (rtn == SUCCESS) {
>>   			list_splice_init(work_q, &check_list);
>>   		} else if (rtn == FAST_IO_FAIL) {
>> -			list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
>> -					scsi_eh_finish_cmd(scmd, done_q);
>> -			}
>> +			list_for_each_entry_safe(scmd, next, work_q, eh_entry)
>> +				__scsi_eh_finish_cmd(scmd, done_q,
>> +						     DID_TRANSPORT_DISRUPTED);
>>   		} else {
>>   			SCSI_LOG_ERROR_RECOVERY(3,
>>   				shost_printk(KERN_INFO, shost,
> 
> For FAST_IO_FAIL I think you want to use DID_TRANSPORT_FAILFAST  because when
> drivers return that, they normally have hit their fast io fail timer or have
> hit a hard transport issue like the port is offline. For example for FC drivers
> they do:
> 
Ah, yes, you are right. Will be modifying that.

> err = fc_block_rport(rport);
> if (err)
> 	return err;
>   
> where fc_block_rport does:
> 
> if (rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT)
> 	return FAST_IO_FAIL;
> 
> and then for fc_remote_port_chkready we return DID_TRANSPORT_FAILFAST
> when FC_RPORT_FAST_FAIL_TIMEDOUT is set.
> 
> So using DID_TRANSPORT_FAILFAST would align the return values for that
> state.
> 
> One question I had is why you added those checks for target and host
> reset but not scsi_eh_bus_device_reset because drivers will do something
> similar to above where they call fc_block_rport for that callout as
> well.
> 
That's done in one of the later patches where I convert the loop in
scsi_eh_bus_device_reset().

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

