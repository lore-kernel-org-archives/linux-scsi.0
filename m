Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B4CFC48BDF
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Jun 2021 12:45:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55F2861437
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Jun 2021 12:45:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbhFOMrH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Jun 2021 08:47:07 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:41198 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbhFOMrH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Jun 2021 08:47:07 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 7FC2C1FD56;
        Tue, 15 Jun 2021 12:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623761102; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XMLy3P3r+VlLUUHhwskgoX942PdqXEESFfG3fvULCD8=;
        b=2Mozp5bJq3MA/X67SirbGyP5IA00MxUvkXZ+3EvsByc275bZNVvf2Gm7yKzOb+nvUfvbGG
        bFj4jjWcUa1TQSXkNxhz0itFy6XX0UT1dwttHBrRB1p93pUlhX99RI3eF+3r+K8/Y+sokw
        PJqB7TQ8ZZqyO8kteUaMU17T3WpMp3A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623761102;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XMLy3P3r+VlLUUHhwskgoX942PdqXEESFfG3fvULCD8=;
        b=W4AkorRdCumgHH3mktzxM9pHXvBoxTVgjriufaZ/OaI5mMrWLhaYTTqH+a0j4TJ7L6Op+9
        z3ncwouyVjmTmxBw==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 650B4118DD;
        Tue, 15 Jun 2021 12:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623761102; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XMLy3P3r+VlLUUHhwskgoX942PdqXEESFfG3fvULCD8=;
        b=2Mozp5bJq3MA/X67SirbGyP5IA00MxUvkXZ+3EvsByc275bZNVvf2Gm7yKzOb+nvUfvbGG
        bFj4jjWcUa1TQSXkNxhz0itFy6XX0UT1dwttHBrRB1p93pUlhX99RI3eF+3r+K8/Y+sokw
        PJqB7TQ8ZZqyO8kteUaMU17T3WpMp3A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623761102;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XMLy3P3r+VlLUUHhwskgoX942PdqXEESFfG3fvULCD8=;
        b=W4AkorRdCumgHH3mktzxM9pHXvBoxTVgjriufaZ/OaI5mMrWLhaYTTqH+a0j4TJ7L6Op+9
        z3ncwouyVjmTmxBw==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id 902zF86gyGDddgAALh3uQQ
        (envelope-from <dwagner@suse.de>); Tue, 15 Jun 2021 12:45:02 +0000
Date:   Tue, 15 Jun 2021 14:45:02 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: Re: [PATCH v2 02/15] lpfc: Fix auto sli_mode and its effect on
 CONFIG_PORT for SLI3
Message-ID: <20210615124502.yzmudtm22pjzwqxj@beryllium.lan>
References: <20210104180240.46824-1-jsmart2021@gmail.com>
 <20210104180240.46824-3-jsmart2021@gmail.com>
 <20210607110630.kwn74yfrbsrrrhsm@beryllium.lan>
 <06b1d757-9046-8b94-265b-c6c760cd8749@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06b1d757-9046-8b94-265b-c6c760cd8749@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi James,

On Mon, Jun 07, 2021 at 08:12:22AM -0700, James Smart wrote:
> ouch - What you are describing is likely true, but sli-2 firmware is
> *extremely* old - 2 decades or more. If a change wont work first shot, it
> likely won't be worth the effort to try to fix it. Other functionality may
> be hanging on by a thread.  That adapter certainly runs SLI-3 (even that is
> 10-15 yrs old), so the best solution is a fw upgrade that picks up the sli3
> interface. Is that possible?

I forwarded the info.

> Given that the error message you quoted was a failure of interrupt, that may
> be a clue. It may well be the adapter has sli3 firmware and it's failing on
> setting the interrupt vector type.  The older adapters supported MSI and
> INTx. SLI-2 may have been limited to INTx only. There used to be hiccups in
> some platforms with MSI support (platform said it did, but was broken) which
> is why the driver had "set it, test it, revert it" logic. I believe the
> driver has a lpfc_use_msi module parameter that when set to 0 should use
> only INTx, which may be what the sli2 downgrade is effectively doing. Try
> setting that and seeing if the card loads the sli3 image and runs.

I haven't heard back yet if the lpfc_use_msi=0 setting fixes the problem
(waiting for the next maintenance window for the experiment).

Thanks,
Daniel
