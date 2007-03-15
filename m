From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH 2/4] scsi: add transport host byte errors
Date: Thu, 15 Mar 2007 09:20:43 -0400
Message-ID: <45F9482B.4050100@emulex.com>
References: <11739019681346-git-send-email-michaelc@cs.wisc.edu> <11739019693216-git-send-email-michaelc@cs.wisc.edu> <11739019703157-git-send-email-michaelc@cs.wisc.edu>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:46863 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933546AbXCONU5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Mar 2007 09:20:57 -0400
In-Reply-To: <11739019703157-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org



michaelc@cs.wisc.edu wrote:
> fast_io_fail_tmo
> iscsi: session recovery_tmo
> fc: rport fast_io_fail_tmo
> 
> The difference is that when the timer fires, for iscsi we unblock the
> queue and fail commands in the blocked queue. FC just fails IO running
> in the driver/fw/hw. The IO in the blocked queue sits there until dev_loss_tmo.

True - FC contacted the LLDD to terminate i/o, who has no notion of any io
that has yet to be sent to it via queuecommand(). Blocked i/o sits until
dev_loss_tmo, as that is when the sdev gets torn down. Perhaps a block layer call
should be created, that the FC transport can call, to terminate the blocked
queue.  Thoughts ?

> dev_loss_tmo
> iscsi: none yet (we are working on it :))
> fc: dev_loss_tmo
> 
> Currently, if there is a transport problem the iscsi drivers will return
> outstanding commands (commands being exeucted by the driver/fw/hw) with
> DID_BUS_BUSY and block the session so no new commands can be queued.
> Commands that are caught between the failure handling and blocking are
> failed with DID_IMM_RETRY or one of the scsi ml queuecommand return values.
> When the recovery_timeout fires, the iscsi drivers then fail IO with
> DID_NO_CONNECT.
> 
> For fcp, some drivers will fail some outstanding IO (disk but possibly not
> tape) with DID_BUS_BUSY or some other value that causes a retry and hits
> the scsi_error.c failfast check, block the rport, and commands caught in the
> race are failed with DID_IMM_RETRY. Other drivers, will hold onto all IO
> and wait for the terminate_rport_io or dev_loss_tmo_callbk to be called.
> In this case lpfc, could return the IO with DID_ERROR.

Note: Variability in behavior has to be allowed as both implementations are
within FC specification. Also, the "everything killed" scenario is a valid
worst case behavior that can always occur. The "it's not killed immediately"
scenario is an optimization towards best-case behavior (with better FC-MI-2
compliance).

Lpfc returns DID_ERROR as the io requests had been queued to the adapter,
may have gone out on the wire, and may have changed media. They were terminated
early based on the respective timeout. Thus, a BUSY status, which implies
no media change, is deemed inappropriate.  Based on the conversation, you
are implying that the layer above, which asked for the fastfail may want to
distinguish between an io terminated due to the fastfail timeout vs an io
that failed due to a real error. Easy enough to do - we just need a new
return status.  And, I see, that's what the patch below does.

So far, so good....

-- james s

