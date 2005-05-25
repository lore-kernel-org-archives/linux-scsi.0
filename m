From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH RFC 1/2] add transport scan callout to fix sysfs layout when scanning from userspace
Date: Tue, 24 May 2005 17:30:44 -0700
Message-ID: <20050525003044.GA6564@us.ibm.com>
References: <1116711431.6285.28.camel@mina> <20050524230143.GA6407@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:46249 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S262186AbVEYAbu
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2005 20:31:50 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j4P0VnmD667540
	for <linux-scsi@vger.kernel.org>; Tue, 24 May 2005 20:31:49 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j4P0VnGO130100
	for <linux-scsi@vger.kernel.org>; Tue, 24 May 2005 18:31:49 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id j4P0VmUo025256
	for <linux-scsi@vger.kernel.org>; Tue, 24 May 2005 18:31:48 -0600
Content-Disposition: inline
In-Reply-To: <20050524230143.GA6407@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, James Smart <James.Smart@Emulex.Com>

On Tue, May 24, 2005 at 04:01:43PM -0700, Patrick Mansfield wrote:

> I was trying FC to see if it caused problems, instead of a different
> layout, no devices are found at all :-(

The qla2xxx_slave_alloc() is returning -ENXIO, and we don't output any
printks in that case for qla2xxx. I added a couple qla_printk's and got
lots of:

	qla2300 0000:01:0c.0: no rport for <7:0:0:0>

For:

	echo "- - -"  > /sys/class/scsi_host/hostX/scan

A change similar change what Mike C. did for iSCSI is needed for FC
transport, or any transport that has a "device" between the host and
target. For qla, we need to eventually call its slave_alloc() with a
target under an rport (so starget_to_rport() gets the rport).

Having a transportt->scan seems a bit high level, I have no better
suggestion, there should be a way to make this generic for all transports.

It is easy for iSCSI since it has a one-to-one mapping of scsi_host to
scsi_target: AFAICT you just call scsi_scan_target() once. FC has to
iterate over all rports, and call scsi_scan_target() for all targets, or
find the rport that matches the id.

Where is iscsi_register_transport? A current git tree? I should probably
be using that tree, still trying to get up to speed on git.

qla2xxx debug patch, but we should always print something when 
returning -ENXIO:

--- linux-2.6.12-rc4/drivers/scsi/qla2xxx/orig-qla_os.c	Fri May  6 22:20:31 2005
+++ linux-2.6.12-rc4/drivers/scsi/qla2xxx/qla_os.c	Tue May 24 16:58:14 2005
@@ -992,8 +992,12 @@ qla2xxx_slave_alloc(struct scsi_device *
 	fc_port_t *fcport;
 	int found;
 
-	if (!rport)
+	if (!rport) {
+		qla_printk(KERN_WARNING, ha,
+		    "no rport for <%d:%d:%d:%d>\n",
+		    sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
 		return -ENXIO;
+	}
 
 	found = 0;
 	list_for_each_entry(fcport, &ha->fcports, list) {
@@ -1003,8 +1007,12 @@ qla2xxx_slave_alloc(struct scsi_device *
 			break;
 		}
 	}
-	if (!found)
+	if (!found) {
+		qla_printk(KERN_WARNING, ha,
+		    "no device at <%d:%d:%d:%d>\n",
+		    sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
 		return -ENXIO;
+	}
 
 	sdev->hostdata = fcport;
 


