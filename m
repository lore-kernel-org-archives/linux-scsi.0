Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D34BC07545
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Oct 2023 05:43:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232308AbjJXFnQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Oct 2023 01:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232011AbjJXFnP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Oct 2023 01:43:15 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E8C10D;
        Mon, 23 Oct 2023 22:43:13 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 42DE221220;
        Tue, 24 Oct 2023 05:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1698126192; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M3q/wHoucHzK03Le3y+14uam2vn5MVvx1mT8tW+PXkI=;
        b=WqbG4lyEHmOraqyPq1VSdPmW2qI8prUIdp8i7Wym5hz1ntXkQx103WTALQTgHNGDUMkNYs
        qY8YCoUtVuyBthmHxPfgthexZ9c3eGn1tbU75nVICaCmcs71ySJz70UHLvhM/GsMf0FGHs
        XSHnPuA+nAUwCHEX7KPcaO4LI2K+9LI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1698126192;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M3q/wHoucHzK03Le3y+14uam2vn5MVvx1mT8tW+PXkI=;
        b=iwN0Xd4zyR4vTT0/Hn8PFqkGOZK57z3UVgvwxBJJu0YOViuUT7QOLfcBNT3BIAhdzXy5gZ
        KtvR6SPlRxJdT5AA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 104E21391F;
        Tue, 24 Oct 2023 05:43:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id P924AnBZN2VCDQAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 24 Oct 2023 05:43:12 +0000
Message-ID: <ce187671-ea90-4d97-b323-70f275c09649@suse.de>
Date:   Tue, 24 Oct 2023 07:43:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: blktests: running nvme and srp tests with real RDMA hardware
Content-Language: en-US
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc:     Daniel Wagner <dwagner@suse.de>, Sagi Grimberg <sagi@grimberg.me>,
        Bart Van Assche <bvanassche@acm.org>
References: <vaijnbobhxyz4nkk2csv3nfhnpeupbudakcn3qgmo7o6vii4x5@rfnfdll6iloo>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <vaijnbobhxyz4nkk2csv3nfhnpeupbudakcn3qgmo7o6vii4x5@rfnfdll6iloo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out1.suse.de;
        none
X-Spamd-Result: default: False [-6.13 / 50.00];
         ARC_NA(0.00)[];
         TO_DN_EQ_ADDR_SOME(0.00)[];
         XM_UA_NO_VERSION(0.01)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         BAYES_HAM(-2.04)[95.29%];
         MIME_GOOD(-0.10)[text/plain];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         NEURAL_HAM_LONG(-3.00)[-1.000];
         DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
         NEURAL_HAM_SHORT(-1.00)[-1.000];
         RCPT_COUNT_SEVEN(0.00)[7];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         RCVD_TLS_ALL(0.00)[];
         MID_RHS_MATCH_FROM(0.00)[]
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/24/23 04:59, Shinichiro Kawasaki wrote:
> Hello blktests users,
> 
> As of today, software RDMA driver "siw" or "rdma_rxe" is used to run "nvme"
> group with nvme_trtype=rdma or "srp" (scsi rdma protocol) group. Now it is
> suggested to run the test groups with real RDMA hardware to run tests in
> more realistic conditions. A GitHub pull request is under review to support
> it [1]. If you are interested in, please take a look and comment.
> 
> [1] https://github.com/osandov/blktests/pull/86

Just commented on it. What we really need is the functionality to run 
against pre-configured controllers (ie specify the controller NQN and 
NSID and do not call into nvmetcli); when running on real HW we 
typically cannot control the target, so we need to be able to specify
a preconfigured namespace.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

