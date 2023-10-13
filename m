Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DEA9CDB47E
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Oct 2023 06:18:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbjJMGSM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Oct 2023 02:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjJMGSL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Oct 2023 02:18:11 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86EB995
        for <linux-scsi@vger.kernel.org>; Thu, 12 Oct 2023 23:18:09 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 2411A2188E;
        Fri, 13 Oct 2023 06:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1697177888; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tMzqj+tzqjzHGTqL8cjCJH80aNm1jETIjyJBPOqhvGs=;
        b=AEY0/lfnQmdocrkRslgne81d1Vwn8Z+xjlb3BdHbGJwIQoHhXxbFbtMDByhRHfQRcxlNMi
        v7Jbba8TcxIHD1wl7G+0MtzgR1zdHBjuaPotYlqR9IBQ+PeZRzq/aCFkPfqlr63iqqvmb9
        R1w3zpvd4UBU2U4LUlrkaLLeSVRkXB8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1697177888;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tMzqj+tzqjzHGTqL8cjCJH80aNm1jETIjyJBPOqhvGs=;
        b=7Cfr3atLa2IqtzxzvAfsmlDWSiwrgUKN97qG6SkTFem1QAA58+NNThZb7yK2HQMJQ0Tiyt
        VLEz9bv/qNGIVVCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B4155138EF;
        Fri, 13 Oct 2023 06:18:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id x4pQKh/hKGWINAAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 13 Oct 2023 06:18:07 +0000
Message-ID: <d216bb05-3f30-4662-9a38-23c5caab2e41@suse.de>
Date:   Fri, 13 Oct 2023 08:18:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/15] zfcp: do not wait for rports to become unblocked
 after host reset
Content-Language: en-US
To:     Benjamin Block <bblock@linux.ibm.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Steffen Maier <maier@linux.ibm.com>
References: <20231002154927.68643-1-hare@suse.de>
 <20231002154927.68643-2-hare@suse.de>
 <20231012135452.GB31157@p1gen4-pw042f0m.fritz.box>
 <58658f0c-c5e9-4321-8bd1-13223472eb1b@suse.de>
 <20231012174908.GC31157@p1gen4-pw042f0m.fritz.box>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20231012174908.GC31157@p1gen4-pw042f0m.fritz.box>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out1.suse.de;
        none
X-Spamd-Result: default: False [-7.09 / 50.00];
         ARC_NA(0.00)[];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         XM_UA_NO_VERSION(0.01)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         BAYES_HAM(-3.00)[100.00%];
         MIME_GOOD(-0.10)[text/plain];
         NEURAL_HAM_LONG(-3.00)[-1.000];
         RCPT_COUNT_FIVE(0.00)[6];
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

On 10/12/23 19:49, Benjamin Block wrote:
> On Thu, Oct 12, 2023 at 04:23:47PM +0200, Hannes Reinecke wrote:
>> On 10/12/23 15:54, Benjamin Block wrote:
>>> On Mon, Oct 02, 2023 at 05:49:13PM +0200, Hannes Reinecke wrote:
>>>> zfcp_scsi_eh_host_reset_handler() would call fc_block_rport() to
>>>> wait for all rports to become unblocked after host reset.
>>>> But after host reset it might happen that the port is gone, hence
>>>> fc_block_rport() might fail due to a missing port.
>>>> But that's a perfectly legal operation; on FC remote ports might
>>>> come and go.
>>>> In the same vein FC HBAs are able to deal with ports being temporarily
>>>> blocked, so really there is not point in waiting for all ports
>>>> to become unblocked during host reset.
>>>
>>> But in scsi_transport_fc.c we have this documented:
>>>
>>>       * fc_block_scsi_eh - Block SCSI eh thread for blocked fc_rport
>>>       * @cmnd: SCSI command that scsi_eh is trying to recover
>>>       *
>>>       * This routine can be called from a FC LLD scsi_eh callback. It
>>>       * blocks the scsi_eh thread until the fc_rport leaves the
>>>       * FC_PORTSTATE_BLOCKED, or the fast_io_fail_tmo fires. This is
>>>       * necessary to avoid the scsi_eh failing recovery actions for blocked
>>>                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>>       * rports which would lead to offlined SCSI devices.
>>>         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>>
>>> So I don't understand what the real expectation by the SCSI EH call back for
>>> host reset is then.
>>>
>>> Is it that all objects (host/target ports/luns) are operational again once we
>>> return to the EH thread, or is it ok that some parts are still being
>>> recovered (as with our host reset handler, rports might still be blocked after
>>> `zfcp_erp_wait()` finishes, because of how this is organized internally).
>>>
>>> If it's the later, I'd think this change is fine. But then I'd wonder why this
>>> function exists in the first place? Is it because in other EH steps it's more
>>> important that rports are ready after the step (e.g. because a TUR is send
>>> after, and if that fails, things get escalate unnecessarily)?
>>>
>>
>> Thing is, fc_block_scsi_eh() is assumed to be called from eh callbacks
>> _before_ any TMFs are to be sent.
>> Typically you would call them in eh_device_reset() or eh_target_reset()
>> to ensure that you can sent TMFs in the first place; no point in attempting
>> to send TMFs is the port is blocked.
> 
> Ok. Interesting. We don't really care about the state of the rport when
> sending TMFs or Aborts, as those commands are sent outside the normal
> queuecommand flow (we just check "internal bits"), in case of Aborts we even
> hand this off to firmware. Consequently we don't really care about their state
> before trying to send either.
> 
Interesting. All others do care about the state of the rport, as for
them sending commands to a blocked rport will just cause
the TMF to fail.

[ .. ]
>>> My impression from look at the code that follows `scsi_try_host_reset()` in
>>> `scsi_error.c` really is, it rather expects things to be ready to be used
>>> after, right there and then (admittedly, this is probably already today
>>> problematic, as things might go back to not working concurrently because of
>>> some fabric event.. but anyway, we can life with that off-chance it seems).
>>>
>>> Or do I miss something?
>>>
>>
>> Ah, right. True, when the rports are not ready (ie still being blocked)
>> sending a TEST UNIT READY will fail, with probably unintended consequences.
>>
>> But: if host reset would return FAST_IO_FAIL everything would be dandy
> 
> Ok, so that would mean, we finish all commands left in the EH work_q with
> `scsi_eh_finish_cmd()`, and not populate the local `check_list` at all, which
> in turns means, we don't do anything in `scsi_eh_test_devices()` (no state
> checks, not TURs).
> 
>> as then we would just check if the devices are online (by virtue of
>> scsi_eh_flush_done_q() in scsi_unjam_host()), which they really should
>> as no-one should have set them offline by then.
> 
> When returning to `scsi_unjam_host()` directly after we return from
> `scsi_eh_host_reset()` we call into `scsi_eh_flush_done_q()` and go over all
> commands that are now in the done-queue (everything, if host reset returned
> FAST_IO_FAIL).
> 
> In there we delete the commands from the EH list, and then check whether we
> ought to retry the command on the same SDEV or return it to some upper layer
> (i.e. hopefully dm-multipath for our installations).
> 
> The former depends on whether the SDEV is online again. If everything is fine
> in the SAN (not cable pulled or something), I think this should be the case,
> but IFF we assume the rport is still blocked because the async registration
> (`zfcp_scsi_rport_work()`) hasn't finished yet (the original point for using
> `fc_block_scsi_eh()`), then the SDEV might still be in state
> SDEV_TRANSPORT_OFFLINE.
>      This can happen during adapter recovery (where we block, IOW call
> `fc_remote_port_delete()` on all rports) if fast-io-fail-tmo runs out, and
> `fc_terminate_rport_io()` is called.
>      That is undone when we call `fc_remote_port_add()` to 'unblock' the rport.
> This would then set all SDEVs into RUNNING again. And there we have the
> interaction with `fc_block_scsi_eh()` again.
> 
Yes, but that is perfectly fine, and in fact exactly as things should
work. Once a device is in SDEV_TRANSPORT_OFFLINE it means that the
underlying rport has been deleted after dev_loss_tmo has expired.
If that happened during SCSI EH, well, tough luck. I/O would have
been aborted even without SCSI EH here.
All fine by me.

> Hmm. I think I could life with both though. If someone drives I/O directly on
> the SDEV, and it fails after EH because of some unfortunate timing, that's bad
> luck, and something was actually wrong in the SAN if fast-io-fail-tmo runs out
> during recovery. They ought to use dm-multipath.
>      And if they do, the commands are re-issued from that layer. I think that
> should be fine.
> 
> So I think we can work with returning FAST_IO_FAIL from
> `zfcp_scsi_eh_host_reset_handler()`, and removing the call to
> `fc_block_scsi_eh()`.
>      We (Steffen and/or I) might still want to look into some other solution
> for only returning from that when we know the async rport registrations have
> ran at least once after adapter recovery. But as far as your patchset goes, I
> don't think that is a gate.
> 
Thanks a lot. Modification to zfcp have been bogging me down for quite some
while, glad that we've found this rather easy solution.

Will be sending an updated version.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

