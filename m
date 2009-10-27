From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: fc_remote_port_delete and returning SCSI commands from LLD
Date: Tue, 27 Oct 2009 16:57:49 -0500
Message-ID: <4AE76CDD.7030408@cs.wisc.edu>
References: <20091020144027.GA17717@schmichrtp.de.ibm.com> <4ADF35BF.8050100@emulex.com> <20091023074746.GB5930@schmichrtp.de.ibm.com> <4AE1C213.9090607@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:34156 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755835AbZJ0V5z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Oct 2009 17:57:55 -0400
In-Reply-To: <4AE1C213.9090607@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

James Smart wrote:
> 
> 
> Christof Schmitt wrote:
>> On Wed, Oct 21, 2009 at 12:24:31PM -0400, James Smart wrote:
>>> But - this process is a coordinated effort between the driver and the 
>>> upper layers, and where the driver doesn't get helped by the 
>>> transport (the blocked state) it had better mimic the return codes at 
>>> the different points, and perhaps more, so that bad things don't happen.
>>
>> "mimic the return codes" refers to fc_remote_port_chkready? Like
>> returning DID_IMM_RETRY when the rport is going to be BLOCKED, but
>> fc_remote_port_delete did not run yet?
> 
> Yes
> 
> Although, now that I look at chkready again, I'm surprised it didn't 
> have one of Mike's TRANSPORT_DISRUPTED status's being returned.
> 

We use DID_IMM_RETRY and do not use TRANSPORT_DISRUPTED in 
fc_remote_port_chkready because it would count against the retries which 
we do not want when we hit those state change races. I think 
Andrew/qlogic hit something where during those race windows we could 
exhaust all the retries.
