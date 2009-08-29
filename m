From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 8213] Race: a lock is expected before calling
 BusLogic_WriteOutgoingMailbox, but it is not held in some case and it is held
 in other cases
Date: Sat, 29 Aug 2009 16:14:03 GMT
Message-ID: <200908291614.n7TGE3Di011302@demeter.kernel.org>
References: <bug-8213-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:36999 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbZH2QOB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Aug 2009 12:14:01 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n7TGE3Lp011303
	for <linux-scsi@vger.kernel.org>; Sat, 29 Aug 2009 16:14:03 GMT
In-Reply-To: <bug-8213-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=8213





--- Comment #4 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2009-08-29 16:14:02 ---
Reply-To: James.Bottomley@suse.de

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

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.