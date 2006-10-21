From: Martin Peschke <mp3@de.ibm.com>
Subject: [Fwd: [Patch 0/5] I/O statistics through request queues]
Date: Sat, 21 Oct 2006 15:14:09 +0200
Message-ID: <1161436449.3054.125.camel@dyn-9-152-230-71.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:64695 "EHLO
	mtagate5.uk.ibm.com") by vger.kernel.org with ESMTP
	id S1161484AbWJUNON (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Oct 2006 09:14:13 -0400
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate5.uk.ibm.com (8.13.8/8.13.8) with ESMTP id k9LDEChY278600
	for <linux-scsi@vger.kernel.org>; Sat, 21 Oct 2006 13:14:12 GMT
Received: from d06av01.portsmouth.uk.ibm.com (d06av01.portsmouth.uk.ibm.com [9.149.37.212])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k9LDGigE2429148
	for <linux-scsi@vger.kernel.org>; Sat, 21 Oct 2006 14:16:44 +0100
Received: from d06av01.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av01.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k9LDEBZa004972
	for <linux-scsi@vger.kernel.org>; Sat, 21 Oct 2006 14:14:11 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: horst.hummel@de.ibm.com, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, axboe@kernel.dk
Cc: Andrew Morton <akpm@osdl.org>

My apologies... somehow I managed to break the cc list for this posting.
Would you mind having a look at linux-kernel?

Martin

-------- Forwarded Message --------
From: Martin Peschke <mp3@de.ibm.com>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 0/5] I/O statistics through request queues
Date: 	Sat, 21 Oct 2006 14:57:03 +0200

This patch set makes the block layer maintain statistics for request
queues. Resulting data closely resembles the actual I/O traffic to a
device, as the block layer takes hints from block device drivers when a
request is being issued as well as when it is about to complete.

It is crucial (for us) to be able to look at such kernel level data in
case of customer situations. It allows us to determine what kind of
requests might be involved in performance situations. This information
helps to understand whether one faces a device issue or a Linux issue.
Not being able to tap into performance data is regarded as a big minus
by some enterprise customers, who are reluctant to use Linux SCSI
support or Linux.

Statistics data includes:
- request sizes (read + write),
- residual bytes of partially completed requests (read + write),
- request latencies (read + write),
- request retries (read + write),
- request concurrency,

For sample data please have a look at the SCSI stack patch or the DASD
driver patch respectively. This data is only gathered if statistics have
been enabled by users at run time (default is off).

The advantage of instrumenting request queues is that we can cover a
broad range of devices, including SCSI tape devices.
Having the block layer maintain such statistics on behalf of drivers
provides for comparability through a common set of statistics.

A previous approach was to put all the code into the SCSI stack:
http://marc.theaimsgroup.com/?l=linux-kernel&m=115928678420835&w=2
I gathered from feedback that moving that stuff to the block layer
might be preferable.

These patches use the statistics component described in
Documentation/statistics.txt.

Patches are against 2.6.19-rc2-mm2.

[Patch 1/5] I/O statistics through request queues: timeval_to_us()
[Patch 2/5] I/O statistics through request queues: queue instrumentation
[Patch 3/5] I/O statistics through request queues: small SCSI cleanup
[Patch 4/5] I/O statistics through request queues: SCSI
[Patch 5/5] I/O statistics through request queues: DASD

Martin

-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/


