From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: RE: [PATCH 2/2] scsi : fixing the new host byte settings
 (DID_TARGET_FAILURE and DID_NEXUS_FAILURE)
Date: Wed, 25 Jan 2012 21:39:55 +0000
Message-ID: <77471C95FAFD844C8CA02DD4F4C5FE2BF002@SACEXCMBX02-PRD.hq.netapp.com>
References: <77471C95FAFD844C8CA02DD4F4C5FE2BEA86@SACEXCMBX02-PRD.hq.netapp.com>
 <20120124230320.GE9784@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:53632 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295Ab2AYVkQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jan 2012 16:40:16 -0500
In-Reply-To: <20120124230320.GE9784@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "device-mapper development (dm-devel@redhat.com)" <dm-devel@redhat.com>

> -----Original Message-----
> From: Mike Snitzer [mailto:snitzer@redhat.com]
> Sent: Tuesday, January 24, 2012 5:03 PM
> To: Moger, Babu
> Cc: linux-scsi@vger.kernel.org; device-mapper development (dm-
> devel@redhat.com)
> Subject: Re: [PATCH 2/2] scsi : fixing the new host byte settings
> (DID_TARGET_FAILURE and DID_NEXUS_FAILURE)
> 
> Hi Babu,
> 
> Thanks for finding this.
> 
> On Tue, Jan 24 2012 at  3:38pm -0500,
> Moger, Babu <Babu.Moger@netapp.com> wrote:
> 
> > Resubmitting as my previous post had format issues and did not go linux-scsi.
> >
> > This patch fixes the host byte settings DID_TARGET_FAILURE and
> DID_NEXUS_FAILURE.
> > The function __scsi_error_from_host_byte,  tries to reset the host byte to
> DID_OK. But that
> > does not happen because of the OR operation.
> >
> > Here is the flow.
> > scsi_softirq_done-> scsi_decide_disposition -> __scsi_error_from_host_byte
> 
> or more accurately:
> 
> scsi_softirq_done -> scsi_decide_disposition
> scsi_softirq_done -> scsi_finish_command -> scsi_io_completion ->
> __scsi_error_from_host_byte
> 
> > Let's take an example with DID_NEXUS_FAILURE. In scsi_decide_disposition,
> result will be set as
> > DID_NEXUS_FAILURE (=0x11). Then in __scsi_error_from_host_byte, when we
> do OR with
> > DID_OK.  Purpose is to reset it back to DID_OK. But that does not happen.  This
> patch fixes this issue.
> 
> We clearly aren't properly resetting to DID_OK but I'm not seeing an
> obvious "nasty bug" that is lurking due to this.  Am I missing
> something?

Yes. It is causing some issues in our proprietary multipath driver. Normally, our assumption
is that host status  overrides all other statuses. If host status is set to status other than DID_OK
then we normally ignore other statuses(like reading the check sense).  We have worked this around.
My assumption is, most of the user Level code does the same thing.  It might give wrong impression
about the kind of error.

One question..  Did the newlines wrapped in this patch  also? 

> 
> __scsi_error_from_host_byte() is setting error which is passed back up
> via blk_end_request() and blk_end_request_all().  And in my previous
> testing I know that corresponding errors are making it out to
> dm-multipath (e.g. -EREMOTEIO).
> 
> Also, your patch header is missing the location where DID_OK is not
> properly matched (because it wasn't set exclussively due to being

I am not sure what you meant here.

> or'd).  Looks like scsi_noretry_cmd() will be made more efficient
> because it will match DID_OK immediately.  Any other locations?  Would
> be good to call them out.
> 
> Mike
