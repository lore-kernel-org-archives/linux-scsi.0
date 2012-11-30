From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Error handling on FC devices
Date: Fri, 30 Nov 2012 10:54:04 -0600
Message-ID: <50B8E4AC.8@cs.wisc.edu>
References: <50AA290F.8000105@suse.de>  <50B3EDEA.40008@emulex.com> <1354046601.4420.14.camel@localhost.localdomain> <94D0CD8314A33A4D9D801C0FE68B40294CCFD463@G9W0745.americas.hpqcorp.net> <50B5B8C4.1040503@suse.de> <50B78715.2060109@emulex.com> <50B89C2D.8030108@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:35260 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031156Ab2K3RCG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Nov 2012 12:02:06 -0500
In-Reply-To: <50B89C2D.8030108@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James.Smart@emulex.com, "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "emilne@redhat.com" <emilne@redhat.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

On 11/30/2012 05:44 AM, Hannes Reinecke wrote:
> On 11/29/2012 05:02 PM, James Smart wrote:
>> Always possible - but....   Our f/w works at the FCP level and
>> below, which means it doesn't know/do SCSI commands - e.g what the
>> cdb within the FCP CMD frame is; know anything about SCSI device
>> classes and state; etc. And it shouldn't be required to do so.
>> Anytime this has been there in the past, it's been problematic.
>>
>> if we want to do this - we should add it to the midlayer/transport.
>>
> D'accord. Transport layer looks like a good fit.
> 
> What we should be doing is hooking up 'bus_reset' to be equivalent to
> REMOVE I_T NEXUS (SAS is already doing this).

Do you mean the scsi eh bus reset callout and if so does that work on
multiple targets but REMOVE I_T NEXUS only will operate on one at a
time? I think it would be cleaner to add a new callout that works like
the target reset one where the scsi-ml loops over the targets for the
drivers.

> 
> In our case a REMOVE I_T NEXUS would be roughly equivalent to
> scsi_remote_port_delete(); only we should be starting aborting
> outstanding I/O directly and not waiting for fast_fail_tmo
> to kick in.
> 

To abort IO, will you be calling the drivers terminate_rport_io or
dev_loss_tmo_callbk? If so I just wanted to warn you that I noticed that
some drivers will only initiate the aborting/cleanup of IO in there. So
if you call those callouts and expect that when finished scsi-ml can
free the scsi command and pass the request back up, I think we could hit
some races with memory issues.

