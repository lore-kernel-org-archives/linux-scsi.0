From: James Smart <James.Smart@emulex.com>
Subject: Re: Error handling on FC devices
Date: Thu, 29 Nov 2012 11:02:29 -0500
Message-ID: <50B78715.2060109@emulex.com>
References: <50AA290F.8000105@suse.de>  <50B3EDEA.40008@emulex.com> <1354046601.4420.14.camel@localhost.localdomain> <94D0CD8314A33A4D9D801C0FE68B40294CCFD463@G9W0745.americas.hpqcorp.net> <50B5B8C4.1040503@suse.de>
Reply-To: <James.Smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:10084 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437Ab2K2QCe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Nov 2012 11:02:34 -0500
In-Reply-To: <50B5B8C4.1040503@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "emilne@redhat.com" <emilne@redhat.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

Always possible - but....   Our f/w works at the FCP level and below, 
which means it doesn't know/do SCSI commands - e.g what the cdb within 
the FCP CMD frame is; know anything about SCSI device classes and state; 
etc. And it shouldn't be required to do so. Anytime this has been there 
in the past, it's been problematic.

if we want to do this - we should add it to the midlayer/transport.

-- james  s


On 11/28/2012 2:09 AM, Hannes Reinecke wrote:
> On 11/27/2012 09:29 PM, Elliott, Robert (Server Storage) wrote:
>> There is a new command in SPC-4 called REMOVE I_T NEXUS that is 
>> intended to help
> > that situation.  REMOVE I_T NEXUS lets the application client use a 
> good I_T nexus
> > to abort commands that were being processed on a bad I_T nexus, so 
> it can safely
> > re-issue those commands on the good I_T nexus without worrying that 
> the original
> > commands might resume.
>>
>> In contrast:
>> - the ABORT TASK, ABORT TASK SET, and CLEAR TASK SET must use the 
>> same I_T nexus
> >   as the commands being aborted, so are not viable if that I_T nexus 
> is bad
>> - LOGICAL UNIT RESET aborts commands from every I_T nexus, so in 
>> addition to
> >   aborting commands from the bad I_T nexus it also affects commands 
> on the
> >   good I_T nexus
>>
> Hmm. Nice in principle, but the problem here is that we cannot 
> guarantee the nexus is still intact.
> So one would need to implement this in the HBA firmware; the firmware 
> would need to be able to process the TMF, and do the appropriate 
> things for the FC stack like dropping the rport etc.
>
> Good idea, though.
>
> James, Andrew, Chad?
> Any chance of having a firmware supporting REMOVE IT-NEXUS ?
>
> Cheers,
>
> Hannes

