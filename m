Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F5DFC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jan 2022 14:08:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346936AbiA1OIS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jan 2022 09:08:18 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:52628 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240958AbiA1OIR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jan 2022 09:08:17 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 327AB1F395;
        Fri, 28 Jan 2022 14:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1643378896; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+QoDkL831l/btwTny6a/v/TwTMLU2ro/saqioOCdOXk=;
        b=BqZDw/CnyqMTrdPWPE3xuC+BFR/mjfXfAhqEnNXM5ITo9oEQ7yF7UV1gRvQ0wOyTWayCjd
        p7P3oHTaPVBV/HaosXeLfM4kcXdYkO4RiXFCJ91lkiRQYDy1G7MRREh2Llp109lVYiAiwX
        Pzl8ZcifyT7vZI2UHFU4i3XrqURniuE=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E8EBE13343;
        Fri, 28 Jan 2022 14:08:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 7Vr1Ns/482GOGAAAMHmgww
        (envelope-from <mwilck@suse.com>); Fri, 28 Jan 2022 14:08:15 +0000
Message-ID: <5767765bb2506b707537efe48dfc394c1548f16a.camel@suse.com>
Subject: Re: [RFC PATCH] scsi: make "access_state" sysfs attribute always
 visible
From:   Martin Wilck <mwilck@suse.com>
To:     Julian Wiedmann <jwiedmann.dev@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
Cc:     linux-scsi@vger.kernel.org
Date:   Fri, 28 Jan 2022 15:08:15 +0100
In-Reply-To: <43430aa9-58fb-bd2a-3f18-18518d2b2396@gmail.com>
References: <20220125162441.2226-1-mwilck@suse.com>
         <43430aa9-58fb-bd2a-3f18-18518d2b2396@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2022-01-28 at 14:38 +0200, Julian Wiedmann wrote:
> On 25.01.22 18:24, mwilck@suse.com wrote:
> > From: Martin Wilck <mwilck@suse.com>
> > 
> > If a SCSI device handler module is loaded after some SCSI devices
> > have already been probed (e.g. via request_module() by dm-
> > multipath),
> > the "access_state" and "preferred_path" sysfs attributes remain
> > invisible for
> > these devices, although the handler is attached and live. The
> > reason is
> > that the visibility is only checked when the sysfs attribute group
> > is
> > first created. This results in an inconsistent user experience
> > depending
> > on the load order of SCSI low-level drivers vs. device handler
> > modules.
> > 
> 
> I suppose you looked at sysfs_update_group(), and it's not a good
> fit?

I admit I'm afraid of introducing race conditions when I update the
visibility of attributes of live SCSI devices. I believe that'd be much
harder to get right, and I don't see what's wrong with simply always
making the attribute visible (other than a rather minimal user API
change, which hardly any user will notice).

Martin

