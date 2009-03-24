From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: eh_abort_handler and calling scsi_done
Date: Tue, 24 Mar 2009 12:41:38 +0100
Message-ID: <20090324114137.GA8616@schmichrtp.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.17.161]:37966 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143AbZCXLlk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Mar 2009 07:41:40 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate1.de.ibm.com (8.13.1/8.13.1) with ESMTP id n2OBfcGN019144
	for <linux-scsi@vger.kernel.org>; Tue, 24 Mar 2009 11:41:38 GMT
Received: from d12av04.megacenter.de.ibm.com (d12av04.megacenter.de.ibm.com [9.149.165.229])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n2OBfctR4092128
	for <linux-scsi@vger.kernel.org>; Tue, 24 Mar 2009 12:41:38 +0100
Received: from d12av04.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av04.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n2OBfc6m027419
	for <linux-scsi@vger.kernel.org>; Tue, 24 Mar 2009 12:41:38 +0100
Received: from schmichrtp.de.ibm.com (schmichrtp.mainz.de.ibm.com [9.155.23.46])
	by d12av04.megacenter.de.ibm.com (8.12.11.20060308/8.12.11) with SMTP id n2OBfcuN027416
	for <linux-scsi@vger.kernel.org>; Tue, 24 Mar 2009 12:41:38 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I am investigating what is required from a LLD when SCSI commands time
out and the SCSI EH calls the eh_abort_handler. The documentation in
scsi_eh.txt states:

    <<scsi_eh_abort_cmds>>

	This action is taken for each timed out command.
	hostt->eh_abort_handler() is invoked for each scmd.  The
	handler returns SUCCESS if it has succeeded to make LLDD and
	all related hardware forget about the scmd.

>From this and from looking at the code, i would conclude:

1) If the LLD returns FAILED from the eh_abort_handler, then the
   command is still allowed to be active in the LLD and the LLD can
   call scsi_done any time later (probably latest when the
   eh_host_reset_handler flushes everything that is still pending).

2) While the abort is pending, but before returning SUCCESS from
   eh_abort_handler, the LLD can still call scsi_done for the SCSI
   command to be aborted (the SCSI command might be returned with a
   status "aborted" if the abort succeeds, or "good" if it was
   completed just before the abort reached the storage system).

Is this correct? Are there any more limitations a SCSI LLD has to be
aware of?

--
Christof Schmitt
