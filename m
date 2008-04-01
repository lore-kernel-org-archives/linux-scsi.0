From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [RFC] sysfs attributes for additional zfcp adapter statistics
Date: Tue, 1 Apr 2008 09:52:40 +0200
Message-ID: <20080401075239.GA7682@schmichrtp.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate8.de.ibm.com ([195.212.29.157]:57234 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623AbYDAHwq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Apr 2008 03:52:46 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate8.de.ibm.com (8.13.8/8.13.8) with ESMTP id m317qiQi243980
	for <linux-scsi@vger.kernel.org>; Tue, 1 Apr 2008 07:52:44 GMT
Received: from d12av04.megacenter.de.ibm.com (d12av04.megacenter.de.ibm.com [9.149.165.229])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m317qiot3735580
	for <linux-scsi@vger.kernel.org>; Tue, 1 Apr 2008 09:52:44 +0200
Received: from d12av04.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av04.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m317qiYF011657
	for <linux-scsi@vger.kernel.org>; Tue, 1 Apr 2008 09:52:44 +0200
Received: from localhost (ICON-9-164-144-71.megacenter.de.ibm.com [9.164.144.71])
	by d12av04.megacenter.de.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id m317qhVa011628
	for <linux-scsi@vger.kernel.org>; Tue, 1 Apr 2008 09:52:44 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

For zfcp, we still have the patch from
http://marc.info/?l=linux-scsi&m=119461369332621&w=2
pending that adds the export of additional statistics from the adapter
to sysfs. There were some discussions, whether the attributes should
be added to the SCSI host and devices, but there was no conclusion.

To find a solution that can be merged upstream, here is an overview of
the data currently available and the data that we want to add for the
adapter (The above patch also adds latencies to the SCSI devices, but
i think this should be discussed later).

As short background, on s390, an FCP adapter can be shared by multiple
Linux systems, that is the reason for the two data sets.

Currently, there is in the FC transport class
 - number of input/output/control requests
 - input/output megabytes
for the FCP adapter (== the sum of requests/transferred data for all
systems sharing the adapter).

The new patch adds 
 - number of input/output/control requests
 - input/ouput megabytes
for the current system using the adapter.  The proposal of the
patch was to add the attributes 'requests' and 'megabytes' to the SCSI
host in sysfs. Alternatives i currently see:
 - add attributes to the underlying CCW device (not the adapter)
 - add new attributes to the FC transport class

What is the best way to export the data?

The other two attributes for
 - utilization of channel and adapter and
 - time the connection between Linux and FCP adapter has been active
are not related to any existing attributes, but the question is the
same: Does the proposal for adding the data to the SCSI host make
sense, or should the data be added to the CCW device or the FC host
statistics?

Christof
