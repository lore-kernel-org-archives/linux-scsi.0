From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] zfcp: fix sense_buffer access bug
Date: Mon, 28 Jan 2008 18:29:12 +0900
Message-ID: <20080128182912W.fujita.tomonori@lab.ntt.co.jp>
References: <20080127124124H.tomof@acm.org>
	<20080128074624.GA4622@schmichrtp.de.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama555.ecl.ntt.co.jp ([129.60.39.106]:38323 "EHLO
	tama555.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbYA1J31 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Jan 2008 04:29:27 -0500
In-Reply-To: <20080128074624.GA4622@schmichrtp.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: christof.schmitt@de.ibm.com
Cc: tomof@acm.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Mon, 28 Jan 2008 08:46:25 +0100
Christof Schmitt <christof.schmitt@de.ibm.com> wrote:

> On Sun, Jan 27, 2008 at 12:41:50PM +0900, FUJITA Tomonori wrote:
> > The commit de25deb18016f66dcdede165d07654559bb332bc changed
> > scsi_cmnd.sense_buffer from a static array to a dynamically allocated
> > buffer. We can't access to sense_buffer in '&cmd->sense_buffer' way.
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > ---
> >  drivers/s390/scsi/zfcp_fsf.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
> > index fe57941..a9a147d 100644
> > --- a/drivers/s390/scsi/zfcp_fsf.c
> > +++ b/drivers/s390/scsi/zfcp_fsf.c
> > @@ -4224,10 +4224,10 @@ zfcp_fsf_send_fcp_command_task_handler(struct zfcp_fsf_req *fsf_req)
> > 
> >  		ZFCP_LOG_TRACE("%i bytes sense data provided by FCP\n",
> >  			       fcp_rsp_iu->fcp_sns_len);
> > -		memcpy(&scpnt->sense_buffer,
> > +		memcpy(scpnt->sense_buffer,
> >  		       zfcp_get_fcp_sns_info_ptr(fcp_rsp_iu), sns_len);
> >  		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_TRACE,
> > -			      (void *) &scpnt->sense_buffer, sns_len);
> > +			      (void *)scpnt->sense_buffer, sns_len);
> >  	}
> > 
> >  	/* check for overrun */
> 
> ACK for fixing the access to the sense buffer.
> 
> We are working internally on cleaning up the zfcp messages. With this
> change, the 'trace' and 'hex dump' messages will disappear. So, could
> you simply remove the ZFCP_HEX_DUMP message above, instead of fixing
> it?

I can but James has already merged the above patch to scsi-misc. So it
would be more convenient for everyone if you could rebase your
patchset on top of scsi-misc?
