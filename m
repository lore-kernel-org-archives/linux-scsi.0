From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 0/3] scsi_dh: Make scsi_dh_activate asynchronous
Date: Mon, 27 Apr 2009 19:52:30 -0700
Message-ID: <20090428025230.11108.88559.sendpatchset@chandra-ubuntu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:59871 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbZD1Cvi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2009 22:51:38 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n3S2k1Al007320
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2009 20:46:01 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n3S2pbW5079904
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2009 20:51:37 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n3S2pbDl002806
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2009 20:51:37 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dm-devel@redhat.com, babu.moger@lsi.com, michaelc@cs.wisc.edu, Chandra Seetharaman <sekharan@us.ibm.com>

Hello All,

Currently, device handlers process path activation in series. This leads
to a lot of time delay when more than 100 luns are involved. For example,
with lsi rdac 100+ luns take about 12-15 minutes. This was found by Moger
Babu of LSI.

This time delay can be avoided if we can do the activations asynchronously.
By making scsi_dh_activate() async, we can give the device handlers an
oppurtunity to decide on how to send the device activation down the wire
to make the turn around time faster. They can send the commands
asynchronously or send them in batches.

I brought up this issue on th emailing list few days back
(http://marc.info/?l=linux-scsi&m=123888063818755&w=2).

This set of patches applies cleanly on 2.6.30-rc3 and is tested on the same.

Please review and provide comments.

This set of patched adds asynchronous support only to rdac handler. WIll be
sending patches to support other handlers too.

Thanks & Regards,

chandra

