From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: eh_abort_handler and calling scsi_done
Date: Wed, 25 Mar 2009 09:52:35 +0100
Message-ID: <20090325085235.GA4214@schmichrtp.de.ibm.com>
References: <20090324114137.GA8616@schmichrtp.de.ibm.com> <49C8E055.2060108@linux.vnet.ibm.com> <20090324174609.GA13556@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:42274 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757920AbZCYIwt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Mar 2009 04:52:49 -0400
Received: from d06nrmr1806.portsmouth.uk.ibm.com (d06nrmr1806.portsmouth.uk.ibm.com [9.149.39.193])
	by mtagate4.uk.ibm.com (8.14.3/8.13.8) with ESMTP id n2P8qkKI067844
	for <linux-scsi@vger.kernel.org>; Wed, 25 Mar 2009 08:52:46 GMT
Received: from d06av01.portsmouth.uk.ibm.com (d06av01.portsmouth.uk.ibm.com [9.149.37.212])
	by d06nrmr1806.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n2P8qkOF3211448
	for <linux-scsi@vger.kernel.org>; Wed, 25 Mar 2009 08:52:46 GMT
Received: from d06av01.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av01.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n2P8qk8w022424
	for <linux-scsi@vger.kernel.org>; Wed, 25 Mar 2009 08:52:46 GMT
Content-Disposition: inline
In-Reply-To: <20090324174609.GA13556@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org

On Tue, Mar 24, 2009 at 10:46:09AM -0700, Mike Anderson wrote:
> Brian King <brking@linux.vnet.ibm.com> wrote:
> > Your assessment sounds correct to me. The other caveat to note is that
> > if for some reason in your eh_abort_handler you don't think the command
> > is still outstanding, you should return SUCCESS for this as well.
> > 
> > -Brian
> > 
> > Christof Schmitt wrote:
> > > I am investigating what is required from a LLD when SCSI commands time
> > > out and the SCSI EH calls the eh_abort_handler. The documentation in
> > > scsi_eh.txt states:
> > > 
> > >     <<scsi_eh_abort_cmds>>
> > > 
> > > 	This action is taken for each timed out command.
> > > 	hostt->eh_abort_handler() is invoked for each scmd.  The
> > > 	handler returns SUCCESS if it has succeeded to make LLDD and
> > > 	all related hardware forget about the scmd.
> > > 
> > > From this and from looking at the code, i would conclude:
> > > 
> > > 1) If the LLD returns FAILED from the eh_abort_handler, then the
> > >    command is still allowed to be active in the LLD and the LLD can
> > >    call scsi_done any time later (probably latest when the
> > >    eh_host_reset_handler flushes everything that is still pending).
> > > 
> > > 2) While the abort is pending, but before returning SUCCESS from
> > >    eh_abort_handler, the LLD can still call scsi_done for the SCSI
> > >    command to be aborted (the SCSI command might be returned with a
> > >    status "aborted" if the abort succeeds, or "good" if it was
> > >    completed just before the abort reached the storage system).
> > > 
> 
> In cases 1 and 2 above calling scsi_done can be done but will cause
> the request to be stopped in blk_complete_request
> (scsi_done->blk_complete_request) as the timed out handler has
> already taken ownership of the command.

I am not too familiar with the blk completion handling. Would calling
scsi_done for the cases above cause any problems? If there are reasons
not to call scsi_done here, then this could be mentioned in the scsi
documentation file.

--
Christof Schmitt
