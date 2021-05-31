Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEC7FC4708F
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 09:55:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7E03610A0
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 09:55:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbhEaJ50 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 May 2021 05:57:26 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:48676 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbhEaJ5Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 May 2021 05:57:24 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id DEFED1FD2F;
        Mon, 31 May 2021 09:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622454943; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PsaOqiqoXWrjn0nPj1JATIKpBDJ2qCcY94qyg0GadOw=;
        b=NezQa7NJybwjplXcWX9vrOS2UW9g00TyrtNiCZImeZaK8lAZohe3QRiobS62x0Tny3gwiP
        sSqyKJAWHqE8z+WAeam+AX1O+cFltVNEB7lhrdBICZ9cILT09eq77ouyy39rI+azmE1UDS
        ouLcV67Sn43Xn/aDCj6FTwJFR2/SsUw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622454943;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PsaOqiqoXWrjn0nPj1JATIKpBDJ2qCcY94qyg0GadOw=;
        b=okgtpgith/oJaA98g3skKG1aSJDOVEW9UhEwlSjcEmm1vX7hr+rbFGgiDk+ZAzw05ALHwl
        bx/JgRNCORmf0oBw==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id BBD13118DD;
        Mon, 31 May 2021 09:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622454943; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PsaOqiqoXWrjn0nPj1JATIKpBDJ2qCcY94qyg0GadOw=;
        b=NezQa7NJybwjplXcWX9vrOS2UW9g00TyrtNiCZImeZaK8lAZohe3QRiobS62x0Tny3gwiP
        sSqyKJAWHqE8z+WAeam+AX1O+cFltVNEB7lhrdBICZ9cILT09eq77ouyy39rI+azmE1UDS
        ouLcV67Sn43Xn/aDCj6FTwJFR2/SsUw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622454943;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PsaOqiqoXWrjn0nPj1JATIKpBDJ2qCcY94qyg0GadOw=;
        b=okgtpgith/oJaA98g3skKG1aSJDOVEW9UhEwlSjcEmm1vX7hr+rbFGgiDk+ZAzw05ALHwl
        bx/JgRNCORmf0oBw==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id qm3iLJ+ytGAIaAAALh3uQQ
        (envelope-from <dwagner@suse.de>); Mon, 31 May 2021 09:55:43 +0000
Date:   Mon, 31 May 2021 11:55:43 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Arun Easi <aeasi@marvell.com>
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        linux-kernel@vger.kernel.org, Nilesh Javali <njavali@marvell.com>
Subject: Re: [EXT] [RFC 0/2] Serialize timeout handling and done callback.
Message-ID: <20210531095543.gszkwzrmx4nhpfqn@beryllium.lan>
References: <20210507123103.10265-1-dwagner@suse.de>
 <alpine.LRH.2.21.9999.2105310148300.17918@irv1user01.caveonetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.21.9999.2105310148300.17918@irv1user01.caveonetworks.com>
Authentication-Results: imap.suse.de;
        none
X-Spamd-Result: default: False [0.00 / 100.00];
         ARC_NA(0.00)[];
         DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_NO_TLS_LAST(0.10)[];
         RCVD_COUNT_TWO(0.00)[2];
         RCPT_COUNT_FIVE(0.00)[5]
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Arun,

On Mon, May 31, 2021 at 02:06:24AM -0700, Arun Easi wrote:
> Thanks Daniel for the report and your effort here. Agree, this needs to be 
> fixed.

Good to hear!

> If you do not mind, can I take this from here? This touches quite a 
> number of paths, and I would like to have this go through a full 
> regression cycle before this is merged.

Sure, that is what I hoped for. It is an invasive change and this needs
to be properly tested with a few different setups. Something I can't really
do. So I would be glad if you could pick up the patches and fix them up.

> That said, I had some general comments:
> 
> 1. I see sp->lock was introduced, but could not locate where it was
> used.

I thought I needed it for serializing the kref operations. The lock
itself is not used in the driver. After re-reading the documentation,
the lock is not necessary as kref_put() is able to serialize the ref
counter inc/dec operation correctly. The lock would only be useful to
serialize the kref_put() with something which runs in the driver
concurrently.

> 2. I did not see a release of lock after a successful kref_put_lock, maybe 
>    that piece was missed out.

I think you got it right. The lock is not necessary.

> 3. The sp->done should be invoked only once, and I do not see if this is
>    taken care of.

qla2x00_sp_release() will only be called when the ref counter gets 0.
This makes sure we only call sp->done() once.

> 4. sp->cmd_sp could be a SCSI IO too, where sp is not allocated 
>    separately, so qla2x00_sp_release shall not be called for it.

Okay, didn't realize this.

Thanks,
Daniel
