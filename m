From: Jeremy Higdon <jeremy@classic.engr.sgi.com>
Subject: Re: request_buffer versus buffer in Scsi_Cmnd
Date: Fri, 27 Sep 2002 18:50:59 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <10209271850.ZM105071@classic.engr.sgi.com>
References: <200209270915.CAA96467@classic.engr.sgi.com>
	<20020927162938.GA1366@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: Mike Anderson <andmike@us.ibm.com>
        "Re: request_buffer versus buffer in Scsi_Cmnd" (Sep 27,  9:29am)
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Sep 27,  9:29am, Mike Anderson wrote:
> 
> Jeremy Higdon [jeremy@classic.engr.sgi.com] wrote:
> > I notice that the qlogicfc driver calls pci_map_sg with the request_buffer
> > field and pci_unmap_sg with the buffer field.
> > 
> > >From looking at the code in drivers/scsi/scsi*, it would appear that they
> > are mostly the same, and the fact that qlogicfc works would seem to confirm
> > that.  However, the fact that there are two different fields leads me
> > to ask what the difference is supposed to be.
> > 
> 
> There are a few fields in the Scsi_Cmnd that are duplicated to contain
> the original values that the scsi cmd was submitted with mostly for retry.
> 
> Some Pairs:
> 	request_buffer, buffer
> 	request_bufflen, bufflen
> 	use_sg, old_use_sg
> 	etc.
> 
> a few more are listed in the scsi_retry_command.
> 
> -andmike
> --
> Michael Anderson
> andmike@us.ibm.com
> 
>-- End of excerpt from Mike Anderson

Okay, thanks.  It sounds as though we should never use the buffer field,
then.  It also sounds as though the qlogicfc code is a bug, but that
it won't bite unless buffer and request_buffer are different (would that
be for a Request Sense after check condition, which qlogicfc would
never need?).

jeremy
