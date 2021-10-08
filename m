Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F61DC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 01:32:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AF3861073
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 01:32:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbhJHBd7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 21:33:59 -0400
Received: from netrider.rowland.org ([192.131.102.5]:53599 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S229524AbhJHBd7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 21:33:59 -0400
Received: (qmail 707257 invoked by uid 1000); 7 Oct 2021 21:32:03 -0400
Date:   Thu, 7 Oct 2021 21:32:03 -0400
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
Message-ID: <20211008013203.GA707101@rowland.harvard.edu>
References: <20211006215453.3318929-1-bvanassche@acm.org>
 <20211006215453.3318929-4-bvanassche@acm.org>
 <20211007162408.GA692514@rowland.harvard.edu>
 <7d4a6e84-dc20-5447-04c3-f1a2bb4abca8@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d4a6e84-dc20-5447-04c3-f1a2bb4abca8@acm.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Oct 07, 2021 at 01:34:31PM -0700, Bart Van Assche wrote:
> On 10/7/21 9:24 AM, Alan Stern wrote:
> > On Wed, Oct 06, 2021 at 02:54:53PM -0700, Bart Van Assche wrote:
> > > The following query shows which drivers define callbacks that are called
> > > by the power management support code in the SCSI core (scsi_pm.c):
> > > 
> > > $ git grep -nHEwA16 "$(echo $(git grep -h 'scsi_register_driver(&' |
> > >        sed 's/.*&//;s/\..*//') | sed 's/ /|/g')" |
> > >      grep '\.pm[[:blank:]]*=[[:blank:]]'
> > > drivers/scsi/sd.c-620-		.pm		= &sd_pm_ops,
> > > drivers/scsi/sr.c-100-		.pm		= &sr_pm_ops,
> > > drivers/scsi/ufs/ufshcd.c-9765-		.pm = &ufshcd_wl_pm_ops,
> > > 
> > > Since unconditionally runtime resuming a device during system resume is
> > > not necessary, remove that code. Modify the SCSI disk (sd) driver such
> > > that it follows the same approach as the UFS driver, namely to skip
> > > system suspend and resume for devices that are runtime suspended. The
> > > CD-ROM code does not need to be updated since its PM callbacks do not
> > > affect the device power state.
> > 
> > You may already be aware of this, but in case you aren't...
> > 
> > The PM core already contains some provisions for handling these kinds
> > of things.  They are described in
> > Documentation/driver-api/pm/devices.rst.  See particularly the parts
> > relating to the DPM_FLAG_NO_DIRECT_COMPLETE, DPM_FLAG_SMART_PREPARE,
> > DPM_FLAG_SMART_SUSPEND, DPM_FLAG_MAY_SKIP_RESUME, and
> > power.direct_complete flags.
> > 
> > A follow-up patch after this series might be able to take advantage of
> > these facilities.
> 
> Hi Alan,
> 
> Thanks for the feedback. I was not yet aware of these flags. Since using
> these flags would make patch 3/3 only a few lines shorter and would make it
> harder to review for anyone who is not familiar with the DPM flags, I'm
> considering to keep patch 3/3 as is (this means not using the DPM flags).

Sure.  That's why I suggested doing it as a follow-up patch.

But if you don't want to write one, that's understandable.  Sometimes I 
think the multitude of PM flags is somewhat over-engineered.  (Even 
though I'm guilty of adding to it...)

Note, however, that this works for SCSI only because SCSI devices don't 
have power-manageable children.  If they did, you could run into a 
situation where the child device wanted to go back to full power during 
a system resume, but was unable to do so because its parent SCSI device 
was still in runtime suspend.  That's the sort of potential problem the 
PM flags were meant to address.  (In fact, you might want to add 
comments to this effect in the sd and UFS drivers' resume routines.)

Alan Stern
