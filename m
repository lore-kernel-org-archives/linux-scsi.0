From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Patch: change the serial_number for error-handler commands
Date: Wed, 21 May 2003 15:53:04 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030521225304.GB1791@beaverton.ibm.com>
References: <3ECA9D46.7010301@rogers.com> <Pine.LNX.4.44L0.0305202110520.4914-100000@netrider.rowland.org> <20030521180308.GD1116@beaverton.ibm.com> <1053551960.1805.8.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:51871 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S262288AbTEUWiB
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2003 18:38:01 -0400
Content-Disposition: inline
In-Reply-To: <1053551960.1805.8.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Luben Tuikov <tluben@rogers.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley [James.Bottomley@SteelEye.com] wrote:
> This patch looks OK to me, except that I don't see a good reason to go
> to a per host serial number.  The SCSI commands are so short lived that
> the current global serial number seems adequate (and saves us 4 bytes
> per device).
> 
> On locking grounds, though it does look better to move it into the host
> structure (probably make explicit by documenting that the host lock
> needs to be held accessing the method).
> 
I made the change on locking simplification a global lock to protect
this value in the IO path sounded wrong. The overhead should be the
same on single adapter systems, but would increase by 4 bytes for every
adapter (real and pseudo).

> This:
> 
> +static inline unsigned long scsi_get_next_serial(struct Scsi_Host
> *shost)
> +{
> +        return (++shost->serial_number) ? shost->serial_number : 1;
> +}
> +
> 
> Will hand out two 1 serial numbers when we start at zero or wrap.
> 
> Shouldn't that be
> 
> static inline unsigned long scsi_get_next_serial(struct Scsi_Host
> *shost)
> {
> 	if(++shost->serial_number == 0)
> 		++shost->serial_number;
> 
>         return shost->serial_number;
> }
> 
> ?

Yes in the original patch snippet above 1 was passed out twice. In a
previous response to this thread I indicated it should be like below or
functionally similar to the code you have above.

return (++shost->serial_number) ? shost->serial_number : ++shost->serial_number; 

-andmike
--
Michael Anderson
andmike@us.ibm.com

