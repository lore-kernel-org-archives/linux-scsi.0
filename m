From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: fastfail operation and retries
Date: Tue, 19 Apr 2005 19:19:53 +0200
Message-ID: <20050419171953.GA8444@lion28.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:3743 "EHLO
	mtagate1.de.ibm.com") by vger.kernel.org with ESMTP id S261240AbVDSRTE
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Apr 2005 13:19:04 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate1.de.ibm.com (8.12.10/8.12.10) with ESMTP id j3JHJ30Q140424
	for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2005 17:19:03 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j3JHIxSH262396
	for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2005 19:19:03 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.12.11) with ESMTP id j3JHIxZr020849
	for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2005 19:18:59 +0200
Received: from lion28.boeblingen.de.ibm.com (lion28.boeblingen.de.ibm.com [9.152.242.26])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.12.11) with ESMTP id j3JHIxwh020846
	for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2005 19:18:59 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI <linux-scsi@vger.kernel.org>

Hi,

I have question(s) regarding the fastfail operation of the SCSI stack.

Performing multipath-tests with an IBM ESS I encountered problems.
During certain operations on an ESS (quiesce/resume and such) requests
on all paths fail temporarily with an data underrun (resid is set in
the FCP-response).  In another situation abort sequences happen (see
FC-FS).

In both cases it is not a path failure but the device (ESS) reports
error conditions temporarily (some seconds).

Now on error on the first path the multipath layer initiates failover
to other available path(s) where requests will immediately fail.

Using linux-2.4 and LVM such problems did not occure. There were
enough retries (5 for each path) to handle such situations.

Now if the FASTFAIL flag is set the SCSI stack prevents retries for
failed SCSI commands.

Problem is that the multipath layer cannot distinguish between path
and device failures (and won't do any retries for the failed request
on the same path anyway).

How can an lld force the SCSI stack to retry a failed scsi-command
(without using DID_REQUEUE or DID_IMM_RETRY, which both do not change
the retry counter).

What about a DID_FORCE_RETRY ?  Or is there any outlook when there
will be a better interface between the SCSI stack and the multipath
layer to properly handle retries.


Regards,

Andreas

