From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: eh_abort_handler and calling scsi_done
Date: Tue, 24 Mar 2009 10:46:09 -0700
Message-ID: <20090324174609.GA13556@linux.vnet.ibm.com>
References: <20090324114137.GA8616@schmichrtp.de.ibm.com> <49C8E055.2060108@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:42905 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755385AbZCXRqM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Mar 2009 13:46:12 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e9.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id n2OHaxIb008183
	for <linux-scsi@vger.kernel.org>; Tue, 24 Mar 2009 13:36:59 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n2OHkA3n163050
	for <linux-scsi@vger.kernel.org>; Tue, 24 Mar 2009 13:46:10 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n2OHkAY5015693
	for <linux-scsi@vger.kernel.org>; Tue, 24 Mar 2009 13:46:10 -0400
Content-Disposition: inline
In-Reply-To: <49C8E055.2060108@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org

Brian King <brking@linux.vnet.ibm.com> wrote:
> Your assessment sounds correct to me. The other caveat to note is that
> if for some reason in your eh_abort_handler you don't think the command
> is still outstanding, you should return SUCCESS for this as well.
> 
> -Brian
> 
> Christof Schmitt wrote:
> > I am investigating what is required from a LLD when SCSI commands time
> > out and the SCSI EH calls the eh_abort_handler. The documentation in
> > scsi_eh.txt states:
> > 
> >     <<scsi_eh_abort_cmds>>
> > 
> > 	This action is taken for each timed out command.
> > 	hostt->eh_abort_handler() is invoked for each scmd.  The
> > 	handler returns SUCCESS if it has succeeded to make LLDD and
> > 	all related hardware forget about the scmd.
> > 
> > From this and from looking at the code, i would conclude:
> > 
> > 1) If the LLD returns FAILED from the eh_abort_handler, then the
> >    command is still allowed to be active in the LLD and the LLD can
> >    call scsi_done any time later (probably latest when the
> >    eh_host_reset_handler flushes everything that is still pending).
> > 
> > 2) While the abort is pending, but before returning SUCCESS from
> >    eh_abort_handler, the LLD can still call scsi_done for the SCSI
> >    command to be aborted (the SCSI command might be returned with a
> >    status "aborted" if the abort succeeds, or "good" if it was
> >    completed just before the abort reached the storage system).
> > 

In cases 1 and 2 above calling scsi_done can be done but will cause the
request to be stopped in blk_complete_request (scsi_done->blk_complete_request) as the timed out handler has already taken ownership of the command.

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
