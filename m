From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Unplugging of SBP-2 devices still does not work
Date: Sat, 23 Jul 2005 21:58:18 +0200
Message-ID: <42E2A15A.2030609@s5r6.in-berlin.de>
References: <42E29DF5.5090603@s5r6.in-berlin.de>
Reply-To: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:18101 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S261339AbVGWT6c (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Jul 2005 15:58:32 -0400
In-Reply-To: <42E29DF5.5090603@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

I wrote:
> Problem 1) Hot unplugging of SBP-2 hangs ieee1394's nodemgr
[...]
> [unplug disk]
> Jul 23 20:08:53 shuttle kernel: ieee1394: Node changed: 1-01:1023 -> 1-00:1023
> Jul 23 20:08:53 shuttle kernel: ieee1394: Node suspended: ID:BUS[1-00:1023]  GUID[0001d202e0200ef1]
> Jul 23 20:08:53 shuttle kernel: ieee1394: sbp2: sbp2_remove
> Jul 23 20:08:53 shuttle kernel: Synchronizing SCSI cache for disk sda:

I should provide perhaps a little more background about nodemgr. It waits for
events on the FireWire bus. If it detects physical removal of a node, it calls
remove callbacks from IEEE 1394 protocol drivers such as sbp2. That's where
sbp2_remove() kicks in. So it all happens in nodemgr's process context, although
the hang occurs somewhere in the scsi mid or high level, or perhaps in the driver
core when it is called from scsi.

[...]
> Jul 23 21:04:49 shuttle kernel: ieee1394: GUID 0x00301bac00002ba4: 
> bus_info_data[0] = 0x0404912b

Ignore this line. It is normally not logged by ieee1394.
-- 
Stefan Richter
-=====-=-=-= -=== =-===
http://arcgraph.de/sr/
