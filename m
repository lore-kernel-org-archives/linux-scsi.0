Return-Path: <SRS0=lyXb=32=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 947C1C2D0B1
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 13:03:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A720217BA
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 13:03:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727478AbgBFNDZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Feb 2020 08:03:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:58426 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727138AbgBFNDY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 6 Feb 2020 08:03:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D844CB436;
        Thu,  6 Feb 2020 13:03:22 +0000 (UTC)
Date:   Thu, 6 Feb 2020 14:03:20 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Martin Wilck <mwilck@suse.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 1/3] scsi: qla2xxx: avoid sending mailbox commands if
 firmware is stopped
Message-ID: <20200206130320.lwac7yxan2p34arc@beryllium.lan>
References: <20200205214422.3657-1-mwilck@suse.com>
 <20200205214422.3657-2-mwilck@suse.com>
 <20200206123330.sq3ubynw534lqrp7@beryllium.lan>
 <fe9c25250ff965078044d128dcdfb0aef936d3cb.camel@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe9c25250ff965078044d128dcdfb0aef936d3cb.camel@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Feb 06, 2020 at 01:50:32PM +0100, Martin Wilck wrote:
> On Thu, 2020-02-06 at 13:33 +0100, Daniel Wagner wrote:
> > Are you sure you got all the necessary places fixed up?
> > 
> > I tend to say we should add
> > 
> > 	if (!ha->flags.fw_started)
> > 		return QLA_FUNCTION_FAILED;
> > 
> > do qla2x00_mailbox_command() and handle the errors one by one. Just
> > an
> > idea.
> 
> I had that idea too. I even tried it out. IIRC it's not that easy. Some
> commands need to be sent to the mailbox even in shut-down state
> (MBC_EXECUTE_FIRMWARE, for example?). I admit I didn't dare going down
> the path you're suggesting, I thought it had quite a potential to cause
> regressions.

Yes, this certainly causing regressions. This patch is using the
blacklist approach which is probably introducing less regression.

But I think for finding all the right spots the white listing approach
is better. Maybe only during development phase. Just an idea.

> Did you mean this as a negative review, or rather an additional
> suggestion?

This patch clearly improves things. So yes, I approve.

Reviewed-by: Daniel Wagner <dwagner@suse.de>

Thanks,
Daniel
