From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: SCSI Hardware Handler and slow failover with large number of LUNS
Date: Sat, 04 Apr 2009 14:30:36 -0700
Message-ID: <1238880636.11478.8.camel@chandra-ubuntu>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:53597 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbZDDVab (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Apr 2009 17:30:31 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n34LSGZh027474
	for <linux-scsi@vger.kernel.org>; Sat, 4 Apr 2009 15:28:16 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n34LUTJX131792
	for <linux-scsi@vger.kernel.org>; Sat, 4 Apr 2009 15:30:29 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n34LUS61027517
	for <linux-scsi@vger.kernel.org>; Sat, 4 Apr 2009 15:30:29 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dm-devel <dm-devel@redhat.com>, Linux SCSI Mailing list <linux-scsi@vger.kernel.org>
Cc: "Moger, Babu" <Babu.Moger@lsi.com>

Hello All,

During testing with the latest SCSI DH Handler on a rdac storage, Babu
found that the failover time with 100+ luns takes about 15 minutes,
which is not good.

We found that the problem is due to the fact that we serialize activate
in dm on the work queue.

We can solve the problem in rdac handler in 2 ways
 1. batch up the activates (mode_selects) and send few of them.
 2. Do mode selects in async mode.

Just wondering if anybody had seen the same problem in other storages
(EMC, HP and Alua). 

Please share your experiences, so we can come up with a solution that
works for all hardware handlers.

regards,

chandra

