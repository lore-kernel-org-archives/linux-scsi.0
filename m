From: Jens Axboe <axboe@suse.de>
Subject: Re: Using scsi_cmd->request->nr_hw_segments within a LLDD...
Date: Wed, 22 Sep 2004 08:57:27 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040922065727.GB2299@suse.de>
References: <B179AE41C1147041AA1121F44614F0B0012AD913@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:17111 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S267864AbUIVG7q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Sep 2004 02:59:46 -0400
Content-Disposition: inline
In-Reply-To: <B179AE41C1147041AA1121F44614F0B0012AD913@AVEXCH02.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Sep 21 2004, Andrew Vasquez wrote:
> 
> All,
> 
> Back in March the qla2xxx driver began to use the value in
> cmd->request->nr_hw_segments as a guestimate during the calucation of
> the number of driver-request-queue entries that would be needed to
> fullfill a given command-request.  Here's an URL to thread which
> prompted the change:
> 
> 	http://marc.theaimsgroup.com/?l=linux-scsi&m=107940832718154&w=2
> 
> Recently we've had a number of problem reports which appear to
> indicate that the value specified within the variable is
> un-initialized and/or set to some bogus value.
> 
> Here's the relevant code the driver uses in qla2x00_start_scsi():
> 
> 	/* Calculate the number of request entries needed. */
> 	req_cnt = (ha->calc_request_entries)(cmd->request->nr_hw_segments);
> 	if (ha->req_q_cnt < (req_cnt + 2)) {
> 		cnt = RD_REG_WORD_RELAXED(ISP_REQ_Q_OUT(ha, reg));
> 		if (ha->req_ring_index < cnt)
> 			ha->req_q_cnt = cnt - ha->req_ring_index;
> 		else
> 			ha->req_q_cnt = ha->request_q_length -
> 			    (ha->req_ring_index - cnt);
> 	}
> 	if (ha->req_q_cnt < (req_cnt + 2))
> 		goto queuing_error;
> 
> The 'req_cnt' derived value in several instances is greater than 4000.
> 
> So, can an LLDD depend on the value being set to a proper value
> during all I/O submission paths -- BIO as well as IOCTL?
> 
> If not, then what should a device driver writer use as an alternative?

Would this by any chance be from request initiated with SG_IO? This
problem should be fixed in 2.6.9-rcX, are you still seeing it?

->nr_hw_segments was not initialized for some paths earlier, so it
contained random crap.

-- 
Jens Axboe

