Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF282C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 16:24:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9222761260
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 16:24:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242606AbhJGQ0D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 12:26:03 -0400
Received: from netrider.rowland.org ([192.131.102.5]:48635 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S241389AbhJGQ0D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 12:26:03 -0400
Received: (qmail 693702 invoked by uid 1000); 7 Oct 2021 12:24:08 -0400
Date:   Thu, 7 Oct 2021 12:24:08 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Hannes Reinecke <hare@suse.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Martin Kepplinger <martin.kepplinger@puri.sm>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH 3/3] scsi: pm: Only runtime resume if necessary
Message-ID: <20211007162408.GA692514@rowland.harvard.edu>
References: <20211006215453.3318929-1-bvanassche@acm.org>
 <20211006215453.3318929-4-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211006215453.3318929-4-bvanassche@acm.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Oct 06, 2021 at 02:54:53PM -0700, Bart Van Assche wrote:
> The following query shows which drivers define callbacks that are called
> by the power management support code in the SCSI core (scsi_pm.c):
> 
> $ git grep -nHEwA16 "$(echo $(git grep -h 'scsi_register_driver(&' |
>       sed 's/.*&//;s/\..*//') | sed 's/ /|/g')" |
>     grep '\.pm[[:blank:]]*=[[:blank:]]'
> drivers/scsi/sd.c-620-		.pm		= &sd_pm_ops,
> drivers/scsi/sr.c-100-		.pm		= &sr_pm_ops,
> drivers/scsi/ufs/ufshcd.c-9765-		.pm = &ufshcd_wl_pm_ops,
> 
> Since unconditionally runtime resuming a device during system resume is
> not necessary, remove that code. Modify the SCSI disk (sd) driver such
> that it follows the same approach as the UFS driver, namely to skip
> system suspend and resume for devices that are runtime suspended. The
> CD-ROM code does not need to be updated since its PM callbacks do not
> affect the device power state.

You may already be aware of this, but in case you aren't...

The PM core already contains some provisions for handling these kinds
of things.  They are described in
Documentation/driver-api/pm/devices.rst.  See particularly the parts
relating to the DPM_FLAG_NO_DIRECT_COMPLETE, DPM_FLAG_SMART_PREPARE,
DPM_FLAG_SMART_SUSPEND, DPM_FLAG_MAY_SKIP_RESUME, and
power.direct_complete flags.

A follow-up patch after this series might be able to take advantage of
these facilities.

Alan Stern

