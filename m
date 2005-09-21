From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: deadlock while cleaning up after transport timeout for target
Date: Wed, 21 Sep 2005 14:21:11 -0700
Message-ID: <20050921212111.GA5492@us.ibm.com>
References: <C2EEB4E538D3DC48BF57F391F422779321ACC9@SRMANNING.eng.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:2688 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S964933AbVIUVVj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Sep 2005 17:21:39 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j8LLLceq013158
	for <linux-scsi@vger.kernel.org>; Wed, 21 Sep 2005 17:21:38 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j8LLLc5x098962
	for <linux-scsi@vger.kernel.org>; Wed, 21 Sep 2005 17:21:38 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j8LLLbVp000479
	for <linux-scsi@vger.kernel.org>; Wed, 21 Sep 2005 17:21:38 -0400
Content-Disposition: inline
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321ACC9@SRMANNING.eng.emc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "goggin, edward" <egoggin@emc.com>, James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

goggin, edward <egoggin@emc.com> wrote:
> Running with 2.6.13, an EMC Symmetrix target with lpfc and getting
> into a deadlock when the target port times out WHILE starting to scan
> the port via fc_scsi_scan_rport.
> 
> The lpfc_worker thread is stuck waiting for the scsi host's work_q to
> empty in scsi_flush_work.  But this work queue wont empty since the
> inquiry to LUN 0 initiated by the fc_scsi_scan_rport port scan is
> getting retried onto the scsi mid-level request queue, seemingly ad
> infinitum, since lpfc_queuecommand is returning
> SCSI_MLQUEUE_HOST_BUSY whenever a target port infrastructure
> is being dismantled.  This prevents the fc_scsi_scan_rport call from
> finishing which prevents the target's NODEV timeout from being
> completely serviced.  My boot up hangs as a result.
> 

I believe the lpfc driver in 2.6.13 is missing the latest update from
Emulex which is in 2.6.14-rc* (i.e., 8.0.29 vs. 8.0.30). Have you tried a
test run on 2.6.14-rc?

James S can better comment if this fix alone will solve your issue, but it
matches fairly close to the signature I was previously receiving on the
older version of the lpfc driver.

In my testing of port bounce runs, I could not complete a run until I
started using the updated version of the driver.

-andmike
--
Michael Anderson
andmike@us.ibm.com
