Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61B0AC61DA4
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Jan 2023 13:35:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236454AbjA3Nfl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Jan 2023 08:35:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236584AbjA3Nfh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jan 2023 08:35:37 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23A0E2C645
        for <linux-scsi@vger.kernel.org>; Mon, 30 Jan 2023 05:35:36 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D3C681FF2D;
        Mon, 30 Jan 2023 13:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1675085734; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/FRhollML0JGwrRPfmMQ7QrRb1EMsEJpwHunaTpzpcM=;
        b=0q2DPiFj9szlmdLsJ2JO+ajUAFiVMXgwjS8n6iKo4FqszLwOKwUDwtERtGXnK8WPyGgUyk
        KyuVzf+uVwyHREklm19GC56wosaBWtOmte0yDgk68xVJZ72gFItZQAUmZKCI6C7TBwHc9j
        KlE2ykdlyxmqlKxcybqtUoKYUUdVurc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1675085734;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/FRhollML0JGwrRPfmMQ7QrRb1EMsEJpwHunaTpzpcM=;
        b=QmwMwcauk1Jn4QM6kNl12dld/HUPU2V9pxPrQhrv5qnxkx7TzlnqP/4DOwPeXauaFexRCL
        jxU4PD/tRI1XnSCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C2C5513A06;
        Mon, 30 Jan 2023 13:35:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id CHUyL6bH12PpYQAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 30 Jan 2023 13:35:34 +0000
Message-ID: <083141cd-3b79-7c54-9464-df36c06cc59a@suse.de>
Date:   Mon, 30 Jan 2023 14:35:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: The PQ=1 saga
Content-Language: en-US
To:     Brian Bunker <brian@purestorage.com>, linux-scsi@vger.kernel.org
Cc:     Martin Wilck <mwilck@suse.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>
References: <yq1lelrleqr.fsf@ca-mkp.ca.oracle.com>
 <4f9794d2-00ed-22da-2b4b-e8afa424bf17@acm.org>
 <d0ac216445c33e9bf98e8c850f4d900acf0787bd.camel@suse.com>
 <9545766a-298d-1358-46f0-64ccfaf30ca0@suse.de>
 <6A8AA317-32B0-48F4-82DC-82B65A221A9F@purestorage.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <6A8AA317-32B0-48F4-82DC-82B65A221A9F@purestorage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/27/23 20:57, Brian Bunker wrote:
> I was doing some more testing of this since it has been a while since I
> ran these tests. It looks like reverting this will make the particular situation
> that I am worried about even worse. I will put the detail in.
> 
> With this in place (before you revert it). When SCSI devices are discovered
> and some have a PQ=1 because they are in an unavailable ALUA state:
> 
> Jan 27 12:05:29 localhost kernel: scsi 7:0:0:1: scsi scan: peripheral device type of 31, no device added
> 
> I don’t know if this intentional with the patch or not but any devices with PQ=1
> will not create SCSI devices. The logging is deceptive too since the device type
> Is 0 and not 31. In my case I have two paths to LUN 1. One is ALUA AO and the
> other in ALUA unavailable.
> 
> With this patch in I only get an sd device and an sg device for the AO path.
> The other path to LUN 1 gets no devices created because it is caught in the
> If condition logged above.
> 
> Because there are no SCSI devices created, when the ALUA state returns
> to an active state, a SCSI rescan, which I can trigger from the target will result
> in the devices getting created since the initial scan never created devices.
> 
> Jan 27 12:26:04 localhost kernel: scsi 7:0:0:1: scsi scan: INQUIRY pass 1 length 36
> Jan 27 12:26:04 localhost kernel: scsi 7:0:0:1: scsi scan: INQUIRY successful with code 0x0
> Jan 27 12:26:04 localhost kernel: scsi 7:0:0:1: scsi scan: INQUIRY pass 2 length 96
> Jan 27 12:26:04 localhost kernel: scsi 7:0:0:1: scsi scan: INQUIRY successful with code 0x0
> Jan 27 12:26:04 localhost kernel: scsi 7:0:0:1: Direct-Access     PURE     FlashArray       8888 PQ: 0 ANSI: 6
> 
> Things are good with both paths to LUN 1 showing up. It is not optimal since the
> target has to trigger a LUN scan on the initiator affecting all paths to those target
> ports.
> 
> With the revert of this, things are a little different, but the way they had been in
> the past.
> 
> Jan 27 13:41:19 localhost kernel: sd 7:0:1:1: Asymmetric access state changed
> Jan 27 13:41:56 localhost kernel: scsi 7:0:1:1: alua: Detached
> Jan 27 13:42:22 localhost kernel: scsi 7:0:1:1: scsi scan: INQUIRY pass 1 length 36
> Jan 27 13:42:22 localhost kernel: scsi 7:0:1:1: scsi scan: INQUIRY successful with code 0x0
> Jan 27 13:42:22 localhost kernel: scsi 7:0:1:1: scsi scan: INQUIRY pass 2 length 96
> Jan 27 13:42:22 localhost kernel: scsi 7:0:1:1: scsi scan: INQUIRY successful with code 0x0
> Jan 27 13:42:22 localhost kernel: scsi 7:0:1:1: Direct-Access     PURE     FlashArray       8888 PQ: 1 ANSI: 6
> Jan 27 13:42:22 localhost kernel: scsi 7:0:1:1: alua: supports implicit TPGS
> Jan 27 13:42:22 localhost kernel: scsi 7:0:1:1: alua: device naa.624a9370acc31b042de141460001141c port group 0 rel port a
> Jan 27 13:42:22 localhost kernel: scsi 7:0:1:1: Attached scsi generic sg7 type 0
> 
> Now an sg device is created but not an sd device. This means that there will be
> no way for this device to get an sd device created once the ALUA state goes into
> an active state.
> 
> The same thing done on the target that worked above no longer does:
> 
> Jan 27 13:47:48 localhost kernel: scsi 7:0:1:1: scsi scan: device exists on 7:0:1:1
> 
> To get around this, the existing disk must be deleted so it is not caught in the rescan
> check. This cannot be controlled on the target, but it will require manual intervention
> on the initiator.
> 
> So the question becomes how should initial scan work when a LUN has a PQ=1 set.
> It is a valid, by spec with ALUA state unavailable but doesn’t seem to be
> handled. Why allow an sg device but not an sd one on initial scan in this case? There
> are probably many ways to fix this. I think the simplest is to allow sd device creation
> on LUNs were PQ=1, and only restrict PQ=3. I am not sure the side effect of this on other
> targets. The other approach which will no longer work after the revert is to trigger a
> rescan from the target. This is sub-optimal since it is disruptive. Any approach involving
> the ALUA device handler will not help since there is no device to transition if it is
> discovered with PQ=1.
> 
Sheesh.

There _is_ an easy solution for this, and that is to not use PQ=1 in 
conjunction with ALUA unavailable :-)

Hiding PQ=1 devices did serve the purpose for linux as we still cannot 
to a 'real' rescan of a SCSI device; the 'vendor' and 'model' string is 
pretty much fixed for the lifetime of the device, alongside with the 
entire standard inquiry data. So if anything changes here we have to 
delete the device before we can properly read it.

(which also means that I'll have to retract my earlier comment about 
this being a good idea ...)

And in the absence of that hiding PQ=1 devices is the best we can do.
The alternative would be to implement a 'real' device rescan; but that 
was too daunting a challenge to be undertaken until now.
Things did change in the meantime, so maybe it's time to revisit that.

But really, we should ask vendors to _not_ use PQ=1 when using ALUA. I 
fail to see the benefit of this as both have roughly the same meaning; 
if you have ALUA unavailable you can't access the device, hence it's 
completely irrelevant what PQ says. And same for the other way round: if 
PQ=1 is set really the only ALUA state which makes sense is 'unavailable'.

Sadly it's not so easy to fix things up in the SCSI stack, as the PQ 
setting is evaluated during scanning, and the ALUA state way back later.

Cheers,

Hannes

