From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/2] scsi : fixing the new host byte settings
 (DID_TARGET_FAILURE and DID_NEXUS_FAILURE)
Date: Tue, 24 Jan 2012 18:03:20 -0500
Message-ID: <20120124230320.GE9784@redhat.com>
References: <77471C95FAFD844C8CA02DD4F4C5FE2BEA86@SACEXCMBX02-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981Ab2AXXD1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jan 2012 18:03:27 -0500
Content-Disposition: inline
In-Reply-To: <77471C95FAFD844C8CA02DD4F4C5FE2BEA86@SACEXCMBX02-PRD.hq.netapp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moger, Babu" <Babu.Moger@netapp.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "device-mapper development (dm-devel@redhat.com)" <dm-devel@redhat.com>

Hi Babu,

Thanks for finding this.

On Tue, Jan 24 2012 at  3:38pm -0500,
Moger, Babu <Babu.Moger@netapp.com> wrote:

> Resubmitting as my previous post had format issues and did not go linux-scsi.
> 
> This patch fixes the host byte settings DID_TARGET_FAILURE and DID_NEXUS_FAILURE.
> The function __scsi_error_from_host_byte,  tries to reset the host byte to DID_OK. But that
> does not happen because of the OR operation. 
> 
> Here is the flow.
> scsi_softirq_done-> scsi_decide_disposition -> __scsi_error_from_host_byte

or more accurately:

scsi_softirq_done -> scsi_decide_disposition
scsi_softirq_done -> scsi_finish_command -> scsi_io_completion -> __scsi_error_from_host_byte

> Let's take an example with DID_NEXUS_FAILURE. In scsi_decide_disposition, result will be set as
> DID_NEXUS_FAILURE (=0x11). Then in __scsi_error_from_host_byte, when we do OR with 
> DID_OK.  Purpose is to reset it back to DID_OK. But that does not happen.  This patch fixes this issue. 

We clearly aren't properly resetting to DID_OK but I'm not seeing an
obvious "nasty bug" that is lurking due to this.  Am I missing
something?

__scsi_error_from_host_byte() is setting error which is passed back up
via blk_end_request() and blk_end_request_all().  And in my previous
testing I know that corresponding errors are making it out to
dm-multipath (e.g. -EREMOTEIO).

Also, your patch header is missing the location where DID_OK is not
properly matched (because it wasn't set exclussively due to being
or'd).  Looks like scsi_noretry_cmd() will be made more efficient
because it will match DID_OK immediately.  Any other locations?  Would
be good to call them out.

Mike
