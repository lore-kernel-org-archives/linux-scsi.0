From: Mike Snitzer <snitzer@redhat.com>
Subject: SCSI's heuristics for enabling WRITE SAME still need work [was: dm
 mpath: disable WRITE SAME if it fails]
Date: Fri, 20 Sep 2013 17:21:42 -0400
Message-ID: <20130920212142.GA17898@redhat.com>
References: <20130919161043.GA27081@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45428 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027Ab3ITVVp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Sep 2013 17:21:45 -0400
Content-Disposition: inline
In-Reply-To: <20130919161043.GA27081@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org

On Thu, Sep 19 2013 at 12:13pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> Workaround the SCSI layer's problematic WRITE SAME heuristics by
> disabling WRITE SAME in the DM multipath device's queue_limits if an
> underlying device disabled it.

...

> This fix doesn't help configurations that have additional devices
> stacked ontop of the mpath device (e.g. LVM created linear DM devices
> ontop).  A proper fix that restacks all the queue_limits from the bottom
> of the device stack up will need to be explored if SCSI will continue to
> use this model of optimistically allowing op codes and then disabling
> them after they fail for the first time.

I really don't think we can afford to keep SCSI's current heuristics for
enabling WRITE SAME, re-stating them for the benefit of others:
1) check if WRITE SAME is supported by sending REPORT SUPPORTED
   OPERATION CODES to the device
2a) if REPORT SUPPORTED OPERATION CODES shows WRITE SAME is supported,
    enable WRITE SAME
2b) if REPORT SUPPORTED OPERATION CODES shows WRITE SAME is not
    supported, disable WRITE SAME
2c) if REPORT SUPPORTED OPERATION CODES isn't supported _and_ the device
    doesn't have an ATA Information VPD page: enable WRITE SAME
    - if/when WRITE SAME does fail, disable it on the failing device

AFAIK the reason for these heuristics is: devices that do support WRITE
SAME cannot properly report as much because they don't support REPORT
SUPPORTED OPERATION CODES -- this lack of RSOC support is apparently
very common?

I can appreciate the idea behind the current heuristics but I think the
prevelence of the other side of the spectrum (SCSI devices that don't
support RSOC or WRITE SAME) was underestimated.  As such we're seeing a
fair amount of WRITE SAME error noise on these systems -- that noise is
itself considered a bug to many.

Also, please see my comment in a related Fedora 19 BZ:
https://bugzilla.redhat.com/show_bug.cgi?id=995271#c23

As I say in that comment:
"A proper fix could be to make SCSI's default be to disable WRITE SAME
for devices that don't properly report they support it.  And possibly
have a whitelist to opt-in to enabling WRITE SAME for select targets."

I'm open to any ideas you might have.

Thanks,
Mike
