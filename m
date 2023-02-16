Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D2A2C636CC
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Feb 2023 11:50:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbjBPLuI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Feb 2023 06:50:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjBPLuG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Feb 2023 06:50:06 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA1E521F6;
        Thu, 16 Feb 2023 03:50:05 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E40661FDBA;
        Thu, 16 Feb 2023 11:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1676548203; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=cIuZZv8iM/NkFizmH1+gWXDdUrKjD8edb98BH6cUsto=;
        b=woNFO/+rcBvTR11vdvqG449Px0/xWkE5PDY58oLgVf6jeB0wZFBGnLmKCZd+fH4FVZnAGM
        0yx7TzuzAVc5gbdVBI8Z0o/RDlgCsRdYNPvz6PPwTRyjKNEbjZHym5y3bZKbIm/33HLBkb
        AF74NYIIp5htv12etzk35UWNc6sZbm8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1676548203;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=cIuZZv8iM/NkFizmH1+gWXDdUrKjD8edb98BH6cUsto=;
        b=tvPBo68FsV0hAnte+WNjluTNImszSxAwHBq74Ai8MQ4UdtJXKjov8PbfxB6T0zzNJVQ0Kf
        CN6QijNdMEw2F6CA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D7586131FD;
        Thu, 16 Feb 2023 11:50:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id lVNUNGsY7mPhLwAAMHmgww
        (envelope-from <hare@suse.de>); Thu, 16 Feb 2023 11:50:03 +0000
Message-ID: <3d3369f1-7ebe-b3b8-804c-ff2b97ec679d@suse.de>
Date:   Thu, 16 Feb 2023 12:50:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Content-Language: en-US
To:     "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        lsf-pc@lists.linuxfoundation.org
From:   Hannes Reinecke <hare@suse.de>
Subject: [LSF/MM/BPF BOF] Userspace command abouts
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

it has come up in other threads, so it might be worthwhile to have its 
own topic:

Userspace command aborts

As it stands we cannot abort I/O commands from userspace.
This is hitting us when running in a virtual machine:
The VM sets a timeout when submitting a command, but that
information can't be transmitted to the VM host. The VM host
then issues a different command (with another timeout), and
again that timeout can't be transmitted to the attached devices.
So when the VM detects a timeout, it will try to issue an abort,
but that goes nowhere as the VM host has no way to abort commands
from userspace.
So in the end the VM has to wait for the command to complete, causing
stalls in the VM if the host had to undergo error recovery or something.

With io_uring or CDL we now have some mechanism which look as if they
would allow us to implement command aborts.
So this BoF will be around discussions on how aborts from userspace 
could be implemented, whether any of the above methods are suitable, or 
whether there are other ideas on how that could be done.

Cheers,

Hannes
-- 
Still without a .sig on this computer
