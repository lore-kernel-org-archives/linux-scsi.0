From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: Using scsi_cmd->request->nr_hw_segments within a LLDD...
Date: Tue, 21 Sep 2004 14:55:34 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B0012AD913@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch01.qlogic.com ([198.70.193.200]:6728 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S268086AbUIUVzf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 17:55:35 -0400
Content-Class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>


All,

Back in March the qla2xxx driver began to use the value in
cmd->request->nr_hw_segments as a guestimate during the calucation of
the number of driver-request-queue entries that would be needed to
fullfill a given command-request.  Here's an URL to thread which
prompted the change:

	http://marc.theaimsgroup.com/?l=linux-scsi&m=107940832718154&w=2

Recently we've had a number of problem reports which appear to
indicate that the value specified within the variable is
un-initialized and/or set to some bogus value.

Here's the relevant code the driver uses in qla2x00_start_scsi():

	/* Calculate the number of request entries needed. */
	req_cnt = (ha->calc_request_entries)(cmd->request->nr_hw_segments);
	if (ha->req_q_cnt < (req_cnt + 2)) {
		cnt = RD_REG_WORD_RELAXED(ISP_REQ_Q_OUT(ha, reg));
		if (ha->req_ring_index < cnt)
			ha->req_q_cnt = cnt - ha->req_ring_index;
		else
			ha->req_q_cnt = ha->request_q_length -
			    (ha->req_ring_index - cnt);
	}
	if (ha->req_q_cnt < (req_cnt + 2))
		goto queuing_error;

The 'req_cnt' derived value in several instances is greater than 4000.

So, can an LLDD depend on the value being set to a proper value
during all I/O submission paths -- BIO as well as IOCTL?

If not, then what should a device driver writer use as an alternative?

Regards,
Andrew Vasquez
