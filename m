From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH v2][RFC] scsi_transport_fc: Implement I_T nexus reset
Date: Thu, 07 Mar 2013 14:20:13 -0600
Message-ID: <5138F67D.3070703@cs.wisc.edu>
References: <1355214219-17343-1-git-send-email-hare@suse.de> <5138E84B.8030803@cs.wisc.edu> <5138F4DF.9010906@tributary.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:51429 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755581Ab3CGUVN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Mar 2013 15:21:13 -0500
In-Reply-To: <5138F4DF.9010906@tributary.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Linton <jlinton@tributary.com>
Cc: Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>, Krishna C Gudipati <kgudipat@brocade.com>, James Bottomley <jbottomley@parallels.com>

On 03/07/2013 02:13 PM, Jeremy Linton wrote:
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

Your lpfc patch fixes that right?

