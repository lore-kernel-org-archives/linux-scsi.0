From: Tameen Khan <tameen@andiamo.com>
Subject: is there some kernel patch for setting scsi queue depth to
  more than 255 ?
Date: Thu, 05 Jun 2003 22:25:08 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4.3.2.7.2.20030605220847.02730288@andiamo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-core-3.cisco.com ([171.68.223.137]:5849 "EHLO
	sj-core-3.cisco.com") by vger.kernel.org with ESMTP id S265304AbTFFFOC
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Jun 2003 01:14:02 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: ibc@andiamo.com, ccheyada@cisco.com

goal is to get more than 255 (~500) queue depth from one linux hba to a 
target device.

I am using a qla2342 hba on a linux 2.3.18-14smp kernel. Am using the sg 
driver to generate IO.

the qlogic driver has a option insmod ql2xmaxqdepth=xx which
basically sets the variable queue_depth of Scsi_Device structure defined in 
scsi.h
This is an unsigned char so obviously it has a maximum value of 255.
I tried changing this to unsigned int in scsi.h.... I set the default value 
of queue_depth parameter
in qla2x00.c to 300.
The kernel and driver compiled, the driver works fine, except I still get a
maximum queue depth of 255 on the trace. (The sg_scsi_id_t:d_queue_depth 
value as
reported by ioctl SG_GET_SCSI_ID is 300 !!! ) So what is the bottleneck now ?

Does anyone have an explanation/ suggession ?
Is this doable at all ?

Any feedback will be appreciated
Thanks
Tameen

