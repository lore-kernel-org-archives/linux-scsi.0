Return-Path: <SRS0=lyXb=32=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 510C4C2D0B1
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 12:33:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E306214AF
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 12:33:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727637AbgBFMdc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Feb 2020 07:33:32 -0500
Received: from mx2.suse.de ([195.135.220.15]:36814 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727361AbgBFMdc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 6 Feb 2020 07:33:32 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1D06EB1DE;
        Thu,  6 Feb 2020 12:33:31 +0000 (UTC)
Date:   Thu, 6 Feb 2020 13:33:30 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     mwilck@suse.com
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
Message-ID: <20200206123330.sq3ubynw534lqrp7@beryllium.lan>
References: <20200205214422.3657-1-mwilck@suse.com>
 <20200205214422.3657-2-mwilck@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200205214422.3657-2-mwilck@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

On Wed, Feb 05, 2020 at 10:44:20PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Since commit 45235022da99 ("scsi: qla2xxx: Fix driver unload by shutting down chip"),
> it is possible that FC commands are scheduled after the adapter firmware
> has been shut down. IO sent to the firmware in this situation hangs
> indefinitely. Avoid this for the LOGO code path that is typically taken
> when adapters are shut down.
> 
> Fixes: 45235022da99 ("scsi: qla2xxx: Fix driver unload by shutting down chip")
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>

Just to understand it correctly: 45235022da99 ("scsi: qla2xxx: Fix
driver unload by shutting down chip") is saying FW is not able to
shutdown propably and therefore we kill it first and still try to do
some cleanup.

Are you sure you got all the necessary places fixed up?

I tend to say we should add

	if (!ha->flags.fw_started)
		return QLA_FUNCTION_FAILED;

do qla2x00_mailbox_command() and handle the errors one by one. Just an
idea.

Thanks,
Daniel
