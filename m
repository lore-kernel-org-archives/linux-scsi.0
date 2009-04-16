From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: queue_depth tracking from LLD
Date: Thu, 16 Apr 2009 11:36:04 +0200
Message-ID: <20090416093604.GA7096@schmichrtp.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:58611 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbZDPJgI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Apr 2009 05:36:08 -0400
Received: from d06nrmr1707.portsmouth.uk.ibm.com (d06nrmr1707.portsmouth.uk.ibm.com [9.149.39.225])
	by mtagate2.uk.ibm.com (8.13.1/8.13.1) with ESMTP id n3G9a6Sv005082
	for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2009 09:36:06 GMT
Received: from d06av02.portsmouth.uk.ibm.com (d06av02.portsmouth.uk.ibm.com [9.149.37.228])
	by d06nrmr1707.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n3G9a60q2932738
	for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2009 10:36:06 +0100
Received: from d06av02.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av02.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n3G9a6pU025011
	for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2009 10:36:06 +0100
Received: from schmichrtp.de.ibm.com (schmichrtp.mainz.de.ibm.com [9.155.23.46] (may be forged))
	by d06av02.portsmouth.uk.ibm.com (8.12.11.20060308/8.12.11) with SMTP id n3G9a6EU025006
	for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2009 10:36:06 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I just came across the SCSI midlayer function scsi_track_queue_full.

If a SCSI command is returned with a status of QUEUE_FULL, then this
is mapped to ADD_TO_MLQUEUE and "device blocked". So, there is already
a mechanism in place. Is a LLD driver expected to additionally call
something like this to decrease the queue depth?

if (status_byte(scmd->result) == QUEUE_FULL)
	scsi_track_queue_full(sdev, sdev->queue_depth - 1))

If a LLD does this, should it also increase the queue depth again when
no more QUEUE_FULL status are seen? To me this looks like a
duplication of the midlayer device blocking, but i assume there is a
reason in having both, scsi_track_queue_full and the device blocking.

--
Christof Schmitt
