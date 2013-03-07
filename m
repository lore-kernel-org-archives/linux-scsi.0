From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v2][RFC] scsi_transport_fc: Implement I_T nexus reset
Date: Thu, 07 Mar 2013 16:44:55 -0500
Message-ID: <51390A57.2060706@interlog.com>
References: <1355214219-17343-1-git-send-email-hare@suse.de> <5138E84B.8030803@cs.wisc.edu> <5138F4DF.9010906@tributary.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:52448 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932840Ab3CGVpa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Mar 2013 16:45:30 -0500
In-Reply-To: <5138F4DF.9010906@tributary.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Linton <jlinton@tributary.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>, Krishna C Gudipati <kgudipat@brocade.com>, James Bottomley <jbottomley@parallels.com>

On 13-03-07 03:13 PM, Jeremy Linton wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 3/7/2013 1:19 PM, Mike Christie wrote:
>> What happens for lpfc? It seems __fc_remote_port_delete ends up calling the
>> fast io fail code right away and that sets FC_RPORT_FAST_FAIL_TIMEDOUT. We
>> will then call lpfc_terminate_rport_io which only will send aborts for the
>> commands. We will then call fc_block_scsi_eh above and that returns
>> FAST_IO_FAIL and we will pass that back up to the scsi eh right away.
>
> 	
> 	For lpfc, you never get to the code. Or rather when I was testing it, I
> couldn't find any way to propagate an error beyond the initial
> lpfc_reset_flush_io_context() call in lpfc_device_reset_handler().
>
> 	That call pretty much always returns success indpependent of the remote
> device because the firmware acks the context clear aborts, resulting in the
> outstanding iocb count being zero (independent of both the mid layer status
> and the actual device state).
> 	
> 	Result: all the code beyond the device reset handler never gets called.

Unsurprisingly, I found pretty well the same thing with
megaraid and mpt2sas (SAS) drivers. A big thumbs up from
the drivers if a LU reset was sent when there was
no way through the expander (due to zoning) to the LU (disk)
in question. Further, when that LU (disk) was viewed from
another initiator, no UA condition had been set; more
evidence that the LU reset did not get through.

"Fire and forget" task management functions ...

Doug Gilbert



