From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: SCSI partial completions?
Date: Thu, 8 May 2003 22:11:35 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030508221135.B28525@beaverton.ibm.com>
References: <3EBAEEE8.6070201@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.102]:22417 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262299AbTEIFCx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 May 2003 01:02:53 -0400
Content-Disposition: inline
In-Reply-To: <3EBAEEE8.6070201@pobox.com>; from jgarzik@pobox.com on Thu, May 08, 2003 at 07:57:28PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org

On Thu, May 08, 2003 at 07:57:28PM -0400, Jeff Garzik wrote:
> I could have sworn I saw some code in drivers/scsi/scsi*.c that implied 
> partial completions were supported.
> 
> Let's imagine that I receive a Scsi_Cmnd that wants to write N sectors. 
>   Time passes, my error handler kicks in, and I realize that I was only 
> able to write N/2 sectors.
> 
> How do I tell the SCSI layer that N/2 sectors were written successfully?
> 
> Thanks,
> 
> 	Jeff

Like the sd.c code for handling MEDIUM_ERROR? And corresponding code in
scsi_io_completion, where we call scsi_end_request() with requeue (the last
argument) set to 1.

-- Patrick Mansfield
