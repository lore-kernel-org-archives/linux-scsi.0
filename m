From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 0/4] scsi_dh: Make scsi_dh_activate asynchronous
Date: Tue, 29 Sep 2009 19:08:11 -0700
Message-ID: <20090930020811.11455.59565.sendpatchset@chandra-ubuntu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:42812 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbZI3CHu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Sep 2009 22:07:50 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n8U21aUt027652
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2009 20:01:36 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n8U27qpt091852
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2009 20:07:52 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n8U27put020635
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2009 20:07:51 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dm-devel@redhat.com, babu.moger@lsi.com, michaelc@cs.wisc.edu, Benoit_Arthur@emc.com, Eddie.Williams@steeleye.com, berthiaume_wayne@emc.com, Chandra Seetharaman <sekharan@us.ibm.com>

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

I brought up this issue on the mailing list
(http://marc.info/?l=linux-scsi&m=123888063818755&w=2) and provided a
set of patch a loooong while back http://marc.info/?l=linux-scsi&m=124088712709821&w=2

This set of patches applies cleanly on 2.6.31 and I tested the rdac handler
on the same.

Please review and provide comments.

This set of patched adds asynchronous support for rdac, hp, and alua handlers.

Didn't add async support for EMC for the following reasons:
 - EMC handler is getting more hairy (when I try to move to _nowait())
 - I do not know if EMC has a special command to group them (like rdac).
 - I wasn't sure if EMC has this problem in the first place ( I did not get
   any response from EMC).
Can somebody from EMC comment, please.

Thanks & Regards,

chandra

