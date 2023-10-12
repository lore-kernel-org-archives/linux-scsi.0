Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88C9ECDB46E
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Oct 2023 14:23:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343916AbjJLOX6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Oct 2023 10:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235194AbjJLOXw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Oct 2023 10:23:52 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC993B7
        for <linux-scsi@vger.kernel.org>; Thu, 12 Oct 2023 07:23:50 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 8B91421860;
        Thu, 12 Oct 2023 14:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1697120628; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N/ICQx2dNQe7b5q+hEhrESe2YVblkQOPQjJhj35TWnM=;
        b=NF6S60rJGBASOe2+tv9og2sFIzHoF9VM2bXXmQrRuEazz/dFWjWbJG3EEz/kT5YxvoyQlm
        9hqS02kb+AIEuC2cqHJFCXmbfZVbax/VNFpjn1vw8UjZ9AdhKEoAi4ZEOCr9Foh1yIiq8+
        M3i7SISWORjc7H7TMsG9zfWDIEcQsF0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1697120628;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N/ICQx2dNQe7b5q+hEhrESe2YVblkQOPQjJhj35TWnM=;
        b=1vp5QItGtUd1CJ0YxLpVOLJE8iaYk7LZbhvF9WjX8XIIEiE1Ex3bFxdBsMPzxwdOttbhde
        4ahU9RbXHMTjS/Aw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7B60E139ED;
        Thu, 12 Oct 2023 14:23:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 4BWtHXQBKGUSEwAAMHmgww
        (envelope-from <hare@suse.de>); Thu, 12 Oct 2023 14:23:48 +0000
Message-ID: <58658f0c-c5e9-4321-8bd1-13223472eb1b@suse.de>
Date:   Thu, 12 Oct 2023 16:23:47 +0200
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
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20231012135452.GB31157@p1gen4-pw042f0m.fritz.box>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
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

On 10/12/23 15:54, Benjamin Block wrote:
> Hey Hannes,
> 
> I've got a few questions re the rational for this change.
> 
> On Mon, Oct 02, 2023 at 05:49:13PM +0200, Hannes Reinecke wrote:
>> zfcp_scsi_eh_host_reset_handler() would call fc_block_rport() to
>> wait for all rports to become unblocked after host reset.
>> But after host reset it might happen that the port is gone, hence
>> fc_block_rport() might fail due to a missing port.
>> But that's a perfectly legal operation; on FC remote ports might
>> come and go.
>> In the same vein FC HBAs are able to deal with ports being temporarily
>> blocked, so really there is not point in waiting for all ports
>> to become unblocked during host reset.
> 
> But in scsi_transport_fc.c we have this documented:
> 
>      * fc_block_scsi_eh - Block SCSI eh thread for blocked fc_rport
>      * @cmnd: SCSI command that scsi_eh is trying to recover
>      *
>      * This routine can be called from a FC LLD scsi_eh callback. It
>      * blocks the scsi_eh thread until the fc_rport leaves the
>      * FC_PORTSTATE_BLOCKED, or the fast_io_fail_tmo fires. This is
>      * necessary to avoid the scsi_eh failing recovery actions for blocked
>                  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>      * rports which would lead to offlined SCSI devices.
>        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> So I don't understand what the real expectation by the SCSI EH call back for
> host reset is then.
> 
> Is it that all objects (host/target ports/luns) are operational again once we
> return to the EH thread, or is it ok that some parts are still being
> recovered (as with our host reset handler, rports might still be blocked after
> `zfcp_erp_wait()` finishes, because of how this is organized internally).
> 
> If it's the later, I'd think this change is fine. But then I'd wonder why this
> function exists in the first place? Is it because in other EH steps it's more
> important that rports are ready after the step (e.g. because a TUR is send
> after, and if that fails, things get escalate unnecessarily)?
> 
Thing is, fc_block_scsi_eh() is assumed to be called from eh callbacks
_before_ any TMFs are to be sent.
Typically you would call them in eh_device_reset() or eh_target_reset()
to ensure that you can sent TMFs in the first place; no point in attempting
to send TMFs is the port is blocked.

Your particular case is arguably a mis-use of fc_block_scsi_eh() as
it is called _after_ host reset is initiated, essentially serving as
a completion point to ensure that all rports are back online.

However, for the FC transport implementation rport lifetimes are
decoupled from SCSI Host lifetimes; rports may (and do!) come and
go during the lifetime of a SCSI host. Consequently there is no
difference between a host with all rports blocked (eg during RSCN
processing) and a host just coming on-line after SCSI EH where rports
are still in the process of getting ready.

Hence the use of fc_block_scsi_eh() after host reset is not required,
and we can make our life easier by just dropping the call.

> Oh.. speaking of that, we do send a TUR after host reset as well
> (`scsi_eh_test_devices()`). So doesn't this break then if one or more rports
> are sill blocked after host reset returns?
>      At least `zfcp_scsi_queuecommand()` will bail very early if the rport is
> not ready (we call `fc_remote_port_chkready()` as more or less first thing),
> and so `scsi_send_eh_cmnd()` that is used for the TUR will fail; then it might
> be retried one time, but this is a tight loop without any delay, so I'd guess
> this has a good chance to fail as well.
>      And then we'd offline the whole host as further escalation, which would
> *REALLY* suck (with no automatic recovery no less).
> 
> My impression from look at the code that follows `scsi_try_host_reset()` in
> `scsi_error.c` really is, it rather expects things to be ready to be used
> after, right there and then (admittedly, this is probably already today
> problematic, as things might go back to not working concurrently because of
> some fabric event.. but anyway, we can life with that off-chance it seems).
> 
> Or do I miss something?
> 
Ah, right. True, when the rports are not ready (ie still being blocked)
sending a TEST UNIT READY will fail, with probably unintended consequences.

But: if host reset would return FAST_IO_FAIL everything would be dandy
as then we would just check if the devices are online (by virtue of
scsi_eh_flush_done_q() in scsi_unjam_host()), which they really should
as no-one should have set them offline by then.

So I guess that's the correct way to go.
Will be modifying the patch accordingly.

Thanks for the feedback!

Cheers,

Hannes

