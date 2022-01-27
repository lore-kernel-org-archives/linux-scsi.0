Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B8EBC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Jan 2022 20:23:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244247AbiA0UXH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Jan 2022 15:23:07 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:37802 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237950AbiA0UXF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jan 2022 15:23:05 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id DE93E21709;
        Thu, 27 Jan 2022 20:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1643314983; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SVm8997DjNMwDI21VCkNecCNpTNF5IPazMgfFtRBUT8=;
        b=E7TI3Zg55si8VTjxEqYqZbAPyyTineyU3J2zTCoopUJvvOI+TzXxfJK50IvVjLhvrUU7Ut
        LMVImsnq69G4AuYcZUiPtFCbAI5hPT7+r369bWflCYLUjXbFWhRAzbfQ0DgBAmNQzzKxVN
        Z/0DVesUcPrTRsjs3pil1tTxMWb4CQo=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9308C13C7C;
        Thu, 27 Jan 2022 20:23:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Lc5mISf/8mEMZQAAMHmgww
        (envelope-from <mwilck@suse.com>); Thu, 27 Jan 2022 20:23:03 +0000
Message-ID: <d623c8be9062fd07fa9f5c1d8c9f921e2857ab37.camel@suse.com>
Subject: Re: [RFC PATCH] scsi: make "access_state" sysfs attribute always
 visible
From:   Martin Wilck <mwilck@suse.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
Cc:     linux-scsi@vger.kernel.org
Date:   Thu, 27 Jan 2022 21:23:02 +0100
In-Reply-To: <4aa8727e-a183-a1f9-8291-624ecb5e6d25@acm.org>
References: <20220125162441.2226-1-mwilck@suse.com>
         <4aa8727e-a183-a1f9-8291-624ecb5e6d25@acm.org>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2022-01-27 at 09:28 -0800, Bart Van Assche wrote:
> On 1/25/22 08:24, mwilck@suse.com wrote:
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
> 
> Isn't this something that should be fixed in the sysfs code rather
> than 
> in the SCSI core? If this issue affects SCSI I assume that it will
> also 
> affect other sysfs users.

Well, there's sysfs_update_groups() which could be used for this
purpose in principle, I suppose. But there's no API for calling it in
the driver core (there is no device_update_groups() or or
device_update_attrs()), probably for good reason. 
Making the attribute visible even if there's no device handler is
simpler, and less error-prone.

IOW, I agree with Hannes.

Regards,
Martin


