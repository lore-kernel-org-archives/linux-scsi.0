From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/2] scsi : fixing the new host byte settings
 (DID_TARGET_FAILURE and DID_NEXUS_FAILURE)
Date: Wed, 25 Jan 2012 17:47:51 -0500
Message-ID: <20120125224751.GA24571@redhat.com>
References: <77471C95FAFD844C8CA02DD4F4C5FE2BEA86@SACEXCMBX02-PRD.hq.netapp.com>
 <20120124230320.GE9784@redhat.com>
 <77471C95FAFD844C8CA02DD4F4C5FE2BF002@SACEXCMBX02-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52884 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806Ab2AYWr5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jan 2012 17:47:57 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0PMlvoh018703
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Wed, 25 Jan 2012 17:47:57 -0500
Content-Disposition: inline
In-Reply-To: <77471C95FAFD844C8CA02DD4F4C5FE2BF002@SACEXCMBX02-PRD.hq.netapp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, Jan 25 2012 at  4:39pm -0500,
Moger, Babu <Babu.Moger@netapp.com> wrote:

> > -----Original Message-----
> > From: Mike Snitzer [mailto:snitzer@redhat.com]
> > Sent: Tuesday, January 24, 2012 5:03 PM
> > To: Moger, Babu
> > Cc: linux-scsi@vger.kernel.org; device-mapper development (dm-
> > devel@redhat.com)
> > Subject: Re: [PATCH 2/2] scsi : fixing the new host byte settings
> > (DID_TARGET_FAILURE and DID_NEXUS_FAILURE)
> > 
> > Hi Babu,
> > 
> > Thanks for finding this.
> > 
> > On Tue, Jan 24 2012 at  3:38pm -0500,
> > Moger, Babu <Babu.Moger@netapp.com> wrote:
> > 
> > > Resubmitting as my previous post had format issues and did not go linux-scsi.
> > >
> > > This patch fixes the host byte settings DID_TARGET_FAILURE and
> > DID_NEXUS_FAILURE.
> > > The function __scsi_error_from_host_byte,  tries to reset the host byte to
> > DID_OK. But that
> > > does not happen because of the OR operation.
> > >
> > > Here is the flow.
> > > scsi_softirq_done-> scsi_decide_disposition -> __scsi_error_from_host_byte
> > 
> > or more accurately:
> > 
> > scsi_softirq_done -> scsi_decide_disposition
> > scsi_softirq_done -> scsi_finish_command -> scsi_io_completion ->
> > __scsi_error_from_host_byte
> > 
> > > Let's take an example with DID_NEXUS_FAILURE. In scsi_decide_disposition,
> > result will be set as
> > > DID_NEXUS_FAILURE (=0x11). Then in __scsi_error_from_host_byte, when we
> > do OR with
> > > DID_OK.  Purpose is to reset it back to DID_OK. But that does not happen.  This
> > patch fixes this issue.
> > 
> > We clearly aren't properly resetting to DID_OK but I'm not seeing an
> > obvious "nasty bug" that is lurking due to this.  Am I missing
> > something?
> 
> Yes. It is causing some issues in our proprietary multipath driver. Normally, our assumption
> is that host status  overrides all other statuses. If host status is set to status other than DID_OK
> then we normally ignore other statuses(like reading the check sense).  We have worked this around.
> My assumption is, most of the user Level code does the same thing.  It might give wrong impression
> about the kind of error.
> 
> One question..  Did the newlines wrapped in this patch  also? 

Looks fine to me.

> > __scsi_error_from_host_byte() is setting error which is passed back up
> > via blk_end_request() and blk_end_request_all().  And in my previous
> > testing I know that corresponding errors are making it out to
> > dm-multipath (e.g. -EREMOTEIO).
> > 
> > Also, your patch header is missing the location where DID_OK is not
> > properly matched (because it wasn't set exclussively due to being
> 
> I am not sure what you meant here.

Well like I said, it is clear that scsi_noretry_cmd() won't match the
DID_OK case in the host_byte select statement.  I was just wondering
where else this improperly set DID_OK was causing a DID_OK match to not
happen.

But the fact that this is impacting your proprietary multipath driver
basically answers my question (I was trying to understand what was
ultimately broken as a result of us improperly resetting to DID_OK).

All said:

Acked-by: Mike Snitzer <snitzer@redhat.com>
