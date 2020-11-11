Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 283D4C56201
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 08:17:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 983C1206E3
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 08:17:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Td+lnN/p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725973AbgKKIRU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Nov 2020 03:17:20 -0500
Received: from mx2.suse.de ([195.135.220.15]:54922 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbgKKIRU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Nov 2020 03:17:20 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1605082639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SGNMWGSyzrXXNn9z3ZeuYny0fmKgFw9UJyQopJXlgo0=;
        b=Td+lnN/pCrfQbvCfI7s+ExElgGtCmKQ0UxtUnEE9ueLMexgWX6sIQ4pOvJEfKgkxarFTfk
        vIdDO/3yFlVJ43Nai3HdoDsXh1gKMU2HVaJ0GxEL39shK2VIHSkOYbax51/b69jTrdd1CF
        b1teE36d2aGEdvwCFo3lgs3SMI0QjRI=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9037DB013;
        Wed, 11 Nov 2020 08:17:18 +0000 (UTC)
Message-ID: <f28d600615f05050ecf52a0ec338127a09a2f821.camel@suse.com>
Subject: Re: [PATCH 1/2] scsi: scsi_vpd_lun_id(): fix designator priorities
From:   Martin Wilck <mwilck@suse.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>
Cc:     linux-scsi@vger.kernel.org,
        James Bottomley <jejb@linux.vnet.ibm.com>
Date:   Wed, 11 Nov 2020 09:17:14 +0100
In-Reply-To: <64c0efe0-e6dd-d706-4e50-f21bcbc58e23@suse.de>
References: <20201029170846.14786-1-mwilck@suse.com>
         <yq1eel0ha2c.fsf@ca-mkp.ca.oracle.com>
         <64c0efe0-e6dd-d706-4e50-f21bcbc58e23@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.36.5 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-11-11 at 07:54 +0100, Hannes Reinecke wrote:
> On 11/11/20 4:05 AM, Martin K. Petersen wrote:
> > Martin,
> > 
> > > The current code would use the first descriptor, because it's
> > > longer
> > > than the NAA descriptor. But this is wrong, the kernel is
> > > supposed to
> > > prefer NAA descriptors over T10 vendor ID. Designator length
> > > should
> > > only be used to compare designators of the same type.
> > > 
> > > This patch addresses the issue by separating designator priority
> > > and
> > > length.
> > 
> > I am concerned that we're going to break existing systems since
> > their
> > /dev/disk/by-* names might change as a result of this. Thoughts?
> > 
> No, this shouldn't happen. With the standard udev rules we're
> creating 
> symlinks for all possible VPD designators, so they don't change.

Right. On distributions using either udev's scsi_id or the standard
rules shipped with sg3_utils for determining WWIDs, nothing should
change.

With this patch, the kernel's logic would eventually match the logic of
the udev rules, which is a good thing. In the long run, we could
finally ditch the complexity of the udev rules and rely on the kernel
to get the wwid right. That would be a big step forward for device
identification, wrt both reliablity and speed.

Only distributions using non-standard udev rules (generating
/dev/disk/by-wwid from the "wwid" attribute) would be affected. I don't
know if any such distribution currently exist, I haven't seen one. Even
those would only be affected in certain cases like the one I showed in
the commit message.

If this truly worries you, we could introduce a new sysfs attribute
besides "wwid". But I suppose that would rather confuse people. I
strongly believe we should have a sysfs attribute that reliably
provides the "right" WWID to user space.

Regards,
Martin



