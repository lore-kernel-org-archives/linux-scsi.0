Return-Path: <SRS0=lyXb=32=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2AC2C2D0B1
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 12:49:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE7EE20661
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 12:49:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727575AbgBFMtI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Feb 2020 07:49:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:46978 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727138AbgBFMtI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 6 Feb 2020 07:49:08 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3C8B7AEC5;
        Thu,  6 Feb 2020 12:49:06 +0000 (UTC)
Message-ID: <fe9c25250ff965078044d128dcdfb0aef936d3cb.camel@suse.com>
Subject: Re: [PATCH v2 1/3] scsi: qla2xxx: avoid sending mailbox commands if
 firmware is stopped
From:   Martin Wilck <mwilck@suse.com>
To:     Daniel Wagner <dwagner@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org
Date:   Thu, 06 Feb 2020 13:50:32 +0100
In-Reply-To: <20200206123330.sq3ubynw534lqrp7@beryllium.lan>
References: <20200205214422.3657-1-mwilck@suse.com>
         <20200205214422.3657-2-mwilck@suse.com>
         <20200206123330.sq3ubynw534lqrp7@beryllium.lan>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.34.3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2020-02-06 at 13:33 +0100, Daniel Wagner wrote:
> Hi Martin,
> 
> On Wed, Feb 05, 2020 at 10:44:20PM +0100, mwilck@suse.com wrote:
> > From: Martin Wilck <mwilck@suse.com>
> > 
> > Since commit 45235022da99 ("scsi: qla2xxx: Fix driver unload by
> > shutting down chip"),
> > it is possible that FC commands are scheduled after the adapter
> > firmware
> > has been shut down. IO sent to the firmware in this situation hangs
> > indefinitely. Avoid this for the LOGO code path that is typically
> > taken
> > when adapters are shut down.
> > 
> > Fixes: 45235022da99 ("scsi: qla2xxx: Fix driver unload by shutting
> > down chip")
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
> 
> Just to understand it correctly: 45235022da99 ("scsi: qla2xxx: Fix
> driver unload by shutting down chip") is saying FW is not able to
> shutdown propably and therefore we kill it first and still try to do
> some cleanup.

Yes, that's what I observed. Mailbox access hangs in this case, as the
mailbox simply won't execute the command and the expected status change
will not happen.

> Are you sure you got all the necessary places fixed up?
> 
> I tend to say we should add
> 
> 	if (!ha->flags.fw_started)
> 		return QLA_FUNCTION_FAILED;
> 
> do qla2x00_mailbox_command() and handle the errors one by one. Just
> an
> idea.

I had that idea too. I even tried it out. IIRC it's not that easy. Some
commands need to be sent to the mailbox even in shut-down state
(MBC_EXECUTE_FIRMWARE, for example?). I admit I didn't dare going down
the path you're suggesting, I thought it had quite a potential to cause
regressions.

Did you mean this as a negative review, or rather an additional
suggestion?

Thanks
Martin


