Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F9BAC11F64
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 10:35:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EA3C61278
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 10:35:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236062AbhGAKi0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Jul 2021 06:38:26 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:39896 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235300AbhGAKi0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jul 2021 06:38:26 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 351C01FFA0;
        Thu,  1 Jul 2021 10:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625135754; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ft13fxfaq+vFNUYsJWnztOSrWoHkkiIkb2aF5X3Kcms=;
        b=vEe8bhuFkTzizUsgkcm4zX7b189HGOo9Y1kRuoIQ9SG+OSavN0IBk6DiFGei8GvBRLfhGy
        tDomB5++/4+3fDwfP5HMPtrlzrr2K9OmTA73BvEri+EeWZ1n10RyoTnlyn/Yz3nVz7GeDy
        MvquFDmOnT6u7WiRkKtx36eBmkf2sKw=
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id BA31211CC0;
        Thu,  1 Jul 2021 10:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625135754; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ft13fxfaq+vFNUYsJWnztOSrWoHkkiIkb2aF5X3Kcms=;
        b=vEe8bhuFkTzizUsgkcm4zX7b189HGOo9Y1kRuoIQ9SG+OSavN0IBk6DiFGei8GvBRLfhGy
        tDomB5++/4+3fDwfP5HMPtrlzrr2K9OmTA73BvEri+EeWZ1n10RyoTnlyn/Yz3nVz7GeDy
        MvquFDmOnT6u7WiRkKtx36eBmkf2sKw=
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id THvwK4ma3WCtXQAALh3uQQ
        (envelope-from <mwilck@suse.com>); Thu, 01 Jul 2021 10:35:53 +0000
Message-ID: <de1e3dcbd26a4c680b27b557ea5384ba40fc7575.camel@suse.com>
Subject: Re: [PATCH v5 3/3] dm mpath: add CONFIG_DM_MULTIPATH_SG_IO -
 failover for SG_IO
From:   Martin Wilck <mwilck@suse.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Mike Snitzer <snitzer@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, dm-devel@redhat.com,
        Hannes Reinecke <hare@suse.de>,
        Daniel Wagner <dwagner@suse.de>, linux-block@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Benjamin Marzinski <bmarzins@redhat.com>, nkoenig@redhat.com,
        emilne@redhat.com
Date:   Thu, 01 Jul 2021 12:35:53 +0200
In-Reply-To: <20210701075629.GA25768@lst.de>
References: <20210628151558.2289-1-mwilck@suse.com>
         <20210628151558.2289-4-mwilck@suse.com> <20210701075629.GA25768@lst.de>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Do, 2021-07-01 at 09:56 +0200, Christoph Hellwig wrote:
> On Mon, Jun 28, 2021 at 05:15:58PM +0200, mwilck@suse.com wrote:
> > The qemu "pr-helper" was specifically invented for it. I
> > believe that this is the most important real-world scenario for
> > sending
> > SG_IO ioctls to device-mapper devices.
> 
> pr-helper obviously does not SG_IO on dm-multipath as that simply
> does
> not work.
> 
> More importantly - if you want to use persistent reservations use the
> kernel ioctls for that.  These work on SCSI, NVMe and device mapper
> without any extra magic.

This set is not about persistent reservations. Sorry if my mentioning
pr-helper made this impression. It was only meant to emphasize the fact
that qemu SCSI passthrough using SG_IO is an important use case.

> Failing over SG_IO does not make sense.  It is an interface
> specically
> designed to leave all error handling to the userspace program using
> it,
> and we should not change that for one specific error case.  If you
> want the kernel to handle errors for you, use the proper interfaces.
> In this case this is the persistent reservation ioctls.  If they miss
> some features that qemu needs we should add those.

I respectfully disagree. Users of dm-multipath devices expect that IO
succeeds as long as there's at least one healthy path. This is a
fundamental property of multipath devices. Whether IO is sent
"normally" or via SG_IO doesn't make a difference wrt this expectation.

The fact that qemu implements SCSI passthrough this way shows that this
is not just a naïve user expectation, but is shared by experienced
developers as well. AFAICS, we can't simply move the path error
detection and retry logic into user space qemu, because user space
doesn't have information about the status of the multipath map; not to
mention that doing this would be highly inefficient.

I agree that in principle, SG_IO error handling should be left to user
space. But in this specific case, it makes sense to handle just the
"path error vs. target error" distinction in the kernel. All else is of
course still handled by user space.

Regards,
Martin




