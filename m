From: James Smart <James.Smart@Emulex.Com>
Subject: Re: fc_remote_port_delete and returning SCSI commands from LLD
Date: Fri, 23 Oct 2009 10:47:47 -0400
Message-ID: <4AE1C213.9090607@emulex.com>
References: <20091020144027.GA17717@schmichrtp.de.ibm.com> <4ADF35BF.8050100@emulex.com> <20091023074746.GB5930@schmichrtp.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:45952 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbZJWOrq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Oct 2009 10:47:46 -0400
In-Reply-To: <20091023074746.GB5930@schmichrtp.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



Christof Schmitt wrote:
> On Wed, Oct 21, 2009 at 12:24:31PM -0400, James Smart wrote:
>> But - this process is a coordinated effort between the driver and the 
>> upper layers, and where the driver doesn't get helped by the transport 
>> (the blocked state) it had better mimic the return codes at the different 
>> points, and perhaps more, so that bad things don't happen.
> 
> "mimic the return codes" refers to fc_remote_port_chkready? Like
> returning DID_IMM_RETRY when the rport is going to be BLOCKED, but
> fc_remote_port_delete did not run yet?

Yes

Although, now that I look at chkready again, I'm surprised it didn't have one 
of Mike's TRANSPORT_DISRUPTED status's being returned.

> And, at least in zfcp, the notification from the hardware about I/O
> completion to the call to scsi_done runs in softirq context. Calling
> fc_remote_port_delete from this context is no good thing as you
> mentioned and i don't see a good way to synchronize the
> fc_remote_port_add/delete calls when going this way.

Should be ways to do it, as it's "just code in the LLDD". But I'm sure, the 
implementation is never that simple.

> 
> So far i see two possible solutions:
> 
> 1) When the error is detected in softirq context, do not call
>    scsi_done. Defer this call to the error handling thread/workqueue
>    that will first call fc_remote_port_delete and then return all
>    affected SCSI commands.
> 
> 2) Have an LLD internal flag indicating "transitioning to rport
>    blocked state", check for this in queuecommand and return
>    DID_IMM_RETRY as fc_remote_port_chkready does. As soon as
>    fc_remote_port_delete has been called, fc_remote_port_chkready will
>    do the right thing.
> 
> It looks to me that 2) might be a short-term solution while 1) looks
> like a proper way of handling interruptions on the host level in the
> long term.

True - depends on how successful (2) alone is. Both should be done, but if (2) 
at least exists, it significantly helps.

> 
> Anyway, thanks for the input.
> 
> I am tempted to summarize this for scsi_fc_transport.txt to have the
> important requirements in one place. But this depends on the available
> time, so no promises.

If you do - great!  It's been needed for a long time.

-- james s
