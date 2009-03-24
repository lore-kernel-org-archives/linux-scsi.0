From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: eh_abort_handler and calling scsi_done
Date: Tue, 24 Mar 2009 08:29:57 -0500
Message-ID: <49C8E055.2060108@linux.vnet.ibm.com>
References: <20090324114137.GA8616@schmichrtp.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:39194 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753204AbZCXN3p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Mar 2009 09:29:45 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id n2ODQim0021863
	for <linux-scsi@vger.kernel.org>; Tue, 24 Mar 2009 09:26:44 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n2ODThHE158306
	for <linux-scsi@vger.kernel.org>; Tue, 24 Mar 2009 09:29:43 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n2ODSE9J024411
	for <linux-scsi@vger.kernel.org>; Tue, 24 Mar 2009 09:28:14 -0400
In-Reply-To: <20090324114137.GA8616@schmichrtp.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: linux-scsi@vger.kernel.org

Your assessment sounds correct to me. The other caveat to note is that
if for some reason in your eh_abort_handler you don't think the command
is still outstanding, you should return SUCCESS for this as well.

-Brian

Christof Schmitt wrote:
> I am investigating what is required from a LLD when SCSI commands time
> out and the SCSI EH calls the eh_abort_handler. The documentation in
> scsi_eh.txt states:
> 
>     <<scsi_eh_abort_cmds>>
> 
> 	This action is taken for each timed out command.
> 	hostt->eh_abort_handler() is invoked for each scmd.  The
> 	handler returns SUCCESS if it has succeeded to make LLDD and
> 	all related hardware forget about the scmd.
> 
> From this and from looking at the code, i would conclude:
> 
> 1) If the LLD returns FAILED from the eh_abort_handler, then the
>    command is still allowed to be active in the LLD and the LLD can
>    call scsi_done any time later (probably latest when the
>    eh_host_reset_handler flushes everything that is still pending).
> 
> 2) While the abort is pending, but before returning SUCCESS from
>    eh_abort_handler, the LLD can still call scsi_done for the SCSI
>    command to be aborted (the SCSI command might be returned with a
>    status "aborted" if the abort succeeds, or "good" if it was
>    completed just before the abort reached the storage system).
> 
> Is this correct? Are there any more limitations a SCSI LLD has to be
> aware of?
> 
> --
> Christof Schmitt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


