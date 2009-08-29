From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [Bug 8213] Race: a lock is expected before calling
 BusLogic_WriteOutgoingMailbox, but it is not held in some case and it is
 held in other cases
Date: Sat, 29 Aug 2009 16:13:51 +0000
Message-ID: <1251562431.27956.2.camel@mulgrave.site>
References: <bug-8213-11613@http.bugzilla.kernel.org/>
	 <200908290929.n7T9TvY9003029@demeter.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:33854 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973AbZH2QN6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Aug 2009 12:13:58 -0400
In-Reply-To: <200908290929.n7T9TvY9003029@demeter.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Sat, 2009-08-29 at 09:29 +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> i`m curious how this report sits here unnoticed for so long. does that still
> apply? 

It predates the time we placed SCSI bugs directly on the mailing list
and buslogic has no maintainer, so no-one noticed

> WRT MAINTAINERS file, there seems no special maintainer for buslogic driver.
> i`d bring that up on linux-scsi ML.

If I look at the original report:


> Block comment before function BusLogic_WriteOutgoingMailbox says "The Host
> Adapter's Lock should already have been acquired by the caller."
> 
> 
> But in the following call chain, NO lock is acquired:
> BusLogic_WriteOutgoingMailbox	<- BusLogic_QueueCommand
> <- scsi_log_send
> <- scsi_dispatch_cmd
> <- scsi_request_fn

This analysis is incorrect.  scsi_log_send() doesn't call queuecommand;
all it does is print out the queuecommand value as a function pointer,
so no lock is needed.

> In some others such as:
> BusLogic_WriteOutgoingMailbox	<- BusLogic_QueueCommand <- scsi_send_eh_cmnd
> BusLogic_WriteOutgoingMailbox	<- BusLogic_QueueCommand <- scsi_dispatch_cmd
> BusLogic_WriteOutgoingMailbox	<- BusLogic_QueueCommand <- scsi_log_send <-
> scsi_send_eh_cmnd
> 
> a lock IS held.

Right, *every* actual invocation of queuecommand holds the lock, so this
bug report is invalid.

James


