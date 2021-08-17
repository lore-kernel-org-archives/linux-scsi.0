Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08FE0C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 14:11:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E208760551
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 14:11:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237629AbhHQOLf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 10:11:35 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:38226 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230412AbhHQOLe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 10:11:34 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D2CBC1FF46;
        Tue, 17 Aug 2021 14:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629209460; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2ZByJTnof7TZ/+KDfE0p7n/uEtjPHuJ1of701iR2u34=;
        b=iyCCFd2FYkMM2M1Wrr79em0jxfKRbUbFzA50bsTmQ4WkgUJgoOYKrar7awjJ1wxdXajwyP
        rlsOmwHPX5iKybmjgp4Giyhlmfq5d9hh/GDlguHGfeMvNfubVHv4YMKxA5IoeW8Cgs67oZ
        dqkBvhPC3TSigQxybpPgi9ebY3ArUkg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629209460;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2ZByJTnof7TZ/+KDfE0p7n/uEtjPHuJ1of701iR2u34=;
        b=S3nVDj+Z8x/t6l7K+rmarHUvCBYzUcHp62kp4QfLRRGpfsOkbReLft6VRiskaZWl/8kdZx
        IQfnoT2eruLUMXCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BB44913A91;
        Tue, 17 Aug 2021 14:11:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id jYXDLHTDG2GdMgAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 17 Aug 2021 14:11:00 +0000
Subject: Re: [PATCH 08/51] zfcp: open-code fc_block_scsi_eh() for host reset
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
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <30e9ee6e-0ce5-63ea-ba3b-a89a1f6c1705@suse.de>
Date:   Tue, 17 Aug 2021 16:10:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <c9e8ad26-f78c-94d3-5c39-8e7ac15a165a@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/17/21 4:03 PM, Steffen Maier wrote:
> On 8/17/21 2:54 PM, Hannes Reinecke wrote:
>> On 8/17/21 1:53 PM, Benjamin Block wrote:
>>> On Tue, Aug 17, 2021 at 11:14:13AM +0200, Hannes Reinecke wrote:
>>>> @@ -383,9 +385,24 @@ static int
>>>> zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
>>>>       }
>>>>       zfcp_erp_adapter_reopen(adapter, 0, "schrh_1");
>>>>       zfcp_erp_wait(adapter);
>>>> -    fc_ret = fc_block_scsi_eh(scpnt);
>>>> -    if (fc_ret)
>>>> -        ret = fc_ret;
>>>> +retry_rport_blocked:
>>>> +    spin_lock_irqsave(host->host_lock, flags);
>>>> +    list_for_each_entry(port, &adapter->port_list, list) {
>>>
>>> You need to take the `adapter->port_list_lock` to iterate over the
>>> `port_list`.
>>>
>>> i.e.: read_lock_irqsave(&adapter->port_list_lock, flags);
>>>
>>>> +        struct fc_rport *rport = port->rport;
>>>> +
>>>> +        if (rport->port_state == FC_PORTSTATE_BLOCKED) {
>>>> +            if (rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT)
>>>> +                ret = FAST_IO_FAIL;
>>>> +            else
>>>> +                ret = NEEDS_RETRY;
>>>> +            break;
>>>> +        }
>>>> +    }
>>>> +    spin_unlock_irqrestore(host->host_lock, flags);
>>>> +    if (ret == NEEDS_RETRY) {
>>>> +        msleep(1000);
>>>> +        goto retry_rport_blocked;
>>>> +    }
>>>
>>> I really can't say I like this open coded FC code in the driver at all.
>>>
>>> Is there a reason we can't use `fc_block_rport()` for all the rports of
>>> the adapter?
> 
> Waiting for all rports to unblock in host_reset has been on my todo list
> since we prepared the eh callbacks to get rid of scsi_cmnd with v4.18
> commits:
> 674595d8519f ("scsi: zfcp: decouple our scsi_eh callbacks from scsi_cmnd")
> 42afc6527d43 ("scsi: zfcp: decouple TMFs from scsi_cmnd by using
> fc_block_rport")
> 26f5fa9d47c1 ("scsi: zfcp: decouple SCSI setup of TMF from scsi_cmnd")
> 39abb11aca00 ("scsi: zfcp: decouple FSF request setup of TMF from
> scsi_cmnd")
> e0116c91c7d8 ("scsi: zfcp: split FCP_CMND IU setup between SCSI I/O and
> TMF again")
> 266883f2f7d5 ("scsi: zfcp: decouple TMF response handler from scsi_cmnd")
> 822121186375 ("scsi: zfcp: decouple SCSI traces for scsi_eh / TMF from
> scsi_cmnd")
> 
> But the synchronization is non-trivial as Benjamin's question shows.
> There are also considerations about lock order, etc.
> 
> I'm busy with other things, so don't hold your breath until I can review
> and test the code; I don't want any regression in that recovery code.
> 
>>> We already do use it for other EH callbacks in the same file, and you
>>> already look up the rports in the adapters rport-list; so using that on
>>> the rports in the loop, instead of open-coding it doesn't seem bad? Or
>>> is there a locking problem?
>>>
>>> We might waste a few cycles with that, but frankly, this is all in EH
>>> and after adapter reset.. all performance concerns went our of the
>>> window with that already.
>>>
>>
>> Question would be why we need to call fc_block_rport() at all in host
>> reset.
>> To my understanding a host reset is expected to do a full resync of the
>> SAN topology, so the expectation is that after zfcp_erp_wait() the port
>> list is stable (ie the HBA has finished processing all RSCNs related to
>> the SAN resync).
> 
> There is more to do in zfcp than in other FC HBA drivers, e.g. LUN open
> recoveries and how they related to rport unblock:
> v4.10 6f2ce1c6af37 ("scsi: zfcp: fix rport unblock race with LUN
> recovery").
> The rport unblock is async to our internal recovery. zfcp_erp_wait()
> only waits for the latter by design.
> 
>> So can't we just drop the fc_block_rport() call here?
> 
> I don't think so.
> 
>> All the other FC drivers do fine without that ...
> 
> It would have been nice to have a common interface for all scsi_eh
> scopes. I.e. fc_block_host(struct Scsi_Host*) like we already have for
> fc_block_scsi_eh(struct scsi_cmnd*) and fc_block_rport(struct fc_rport*)
> [the latter having been introduced at the time of above eh callback
> preparations].
> But if zfcp is the only one needing it for host_reset, having the code
> only in zfcp seems fine to me.
> 
> 
Right. Just wanted to clarify that.
If we need to use fc_block_rport() in host reset so be it; just wanted
to clarify if this _really_ is the case (and not just some copy'n'paste
stuff).
I'll be reworking the patch to call fc_block_rport().

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
