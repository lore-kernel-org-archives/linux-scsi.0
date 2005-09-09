From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH 1/5] SCSI scanning and removal fixes
Date: Fri, 9 Sep 2005 09:47:43 -0700
Message-ID: <20050909164743.GC29128@us.ibm.com>
References: <1126280249.4799.21.camel@mulgrave> <Pine.LNX.4.44L0.0509091146170.5557-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:61351 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751432AbVIIQtd
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Sep 2005 12:49:33 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e31.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j89GnODC096454
	for <linux-scsi@vger.kernel.org>; Fri, 9 Sep 2005 12:49:26 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j89Gm7WS356672
	for <linux-scsi@vger.kernel.org>; Fri, 9 Sep 2005 10:48:07 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id j89Gm7q0002431
	for <linux-scsi@vger.kernel.org>; Fri, 9 Sep 2005 10:48:07 -0600
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0509091146170.5557-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern <stern@rowland.harvard.edu> wrote:
> The conundrum I'm facing is how to make sure that when scsi_remove_host
> returns, the mid-layer is no longer sending anything to the host.  Sure,
> no new commands will be issued once the state is set to DEL (or
> DEL_RECOVERY).  But what about commands/resets that were already in
> progress at that time?  (Especially if they were issued before
> scsi_remove_host was called.)  The routine shouldn't return until they
> have completed.  This applies to commands coming from either the
> high-level driver or from the error handler.
> 

I do not understand why we would not want to wait on the eh thread and
shut it down before returning from scsi_remove_host. In the end we are
really going to wait on this action anyways.

Currently scsi_send_eh_cmnd does not go through scsi_dispatch_cmd and eh_*
calls have no checks besides SUCCESS and FAILED. The scsi_send_eh_cmnd
should be updated to follow the same model that scsi_dispatch_cmd uses and
the eh_* calls good be improved if we allowed another return code that the
LLDDs could use to indicate that no device was present. These would only
be an optimization to reduce the wait time on the eh thread and if not
implemented would just increase the wait time.


-andmike
--
Michael Anderson
andmike@us.ibm.com
