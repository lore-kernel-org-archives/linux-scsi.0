From: Lan Tran <transter@gmail.com>
Subject: Re: BUG: SCSI INQUIRY thru SCSI_IOCTL_SEND_COMMAND returns no errno for disconnected device
Date: Fri, 8 Oct 2004 16:43:52 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <ac71172a04100816436c59c5c3@mail.gmail.com>
References: <ac71172a04093012437c353f83@mail.gmail.com>
	 <20041001163131.GA23156@beaverton.ibm.com>
Reply-To: Lan Tran <transter@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.192]:41052 "EHLO mproxy.gmail.com")
	by vger.kernel.org with ESMTP id S266221AbUJHXoP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2004 19:44:15 -0400
Received: by mproxy.gmail.com with SMTP id 80so62275rnk
        for <linux-scsi@vger.kernel.org>; Fri, 08 Oct 2004 16:43:52 -0700 (PDT)
In-Reply-To: <20041001163131.GA23156@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Jens Axboe <axboe@suse.de>, linux-scsi@vger.kernel.org, johntsai@us.ibm.com, tranlan@us.ibm.com

Thanks Patrick for the tip! After trying out SG_IO, it works, as long
as we use Mike C's patch.

Lan

On Fri, 1 Oct 2004 09:31:31 -0700, Patrick Mansfield <patmans@us.ibm.com> wrote:
> On Thu, Sep 30, 2004 at 12:43:47PM -0700, Lan Tran wrote:
> > We have a SAN system set up, where our host is connected to IBM ESS
> > storage and SVC storage. When we disconnect ALL FC cables between the
> > host and storage devices, and then send a SCSI INQUIRY using the
> > SCSI_IOCTL_SEND_COMMAND ioctl to the
> > sd devices, the ioctl does not return with a failure code. Instead, it
> > returns with a zero-length buffer.
> >
> > Is there a reason why we would get a zeroed-length buffer instead of
> > an error return code?
> 
> SCSI_IOCTL_SEND_COMMAND is deprecated, you should be using SG_IO instead.
> 
> There was a bug with SG_IO, it does not correctly set all of the status
> bytes, a patch has been submitted a few times, Mike C's patch
> fixed problems compared to ones I posted earlier, this patch:
> 
>         http://marc.theaimsgroup.com/?l=linux-scsi&m=108617935710955&w=2
> 
> It looks like SCSI_IOCTL_SEND_COMMAND has a similiar issue, in that it
> only checks the low byte of the results, so for example a DID_NO_CONNECT
> returned by the qlogic or emulex driver would be ignored.
> 
> See drivers/block/scsi_ioctl.c near the end of sg_scsi_ioctl, this:
> 
>         err = rq->errors & 0xff;        /* only 8 bit SCSI status */
> 
> Compare that to code in drivers/scsi/scsi_ioctl.c near the end of
> scsi_ioctl_send_command, where the entire result is checked, not just the
> SCSI byte.
> 
> -- Patrick Mansfield
>
