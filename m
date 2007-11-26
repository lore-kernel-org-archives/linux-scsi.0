From: Bernd Schubert <bs@q-leap.de>
Subject: reservation conflicts
Date: Mon, 26 Nov 2007 13:45:56 +0100
Message-ID: <fief64$g9d$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:42374 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752882AbXKZMuF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Nov 2007 07:50:05 -0500
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1IwdPW-0000N7-6X
	for linux-scsi@vger.kernel.org; Mon, 26 Nov 2007 12:50:02 +0000
Received: from ns1.q-leap.de ([153.94.51.193])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Mon, 26 Nov 2007 12:50:02 +0000
Received: from bs by ns1.q-leap.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Mon, 26 Nov 2007 12:50:02 +0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

we have to deal here with troublesome Infortrend devices. These units do
have 2 independent scsi channels, which are unfortunately not so
independent as they should be.
Now we have two different systems (lets say OSS-1 and OSS-2) connected to
each of the scsi-channels and both channels are serving different
partitions on the infortrend-raid units. So in principal whatever happens
on one channel should not effect the other channel.
Unfortunately, if one system (e.g. OSS-2) is rebooted while the other
(OSS-1) is doing i/o, it will cause trouble on the system doing i/o. These
problems are "task aborts", "reservation conflicts", etc.

I don't know how to solve the other problems yet, but i/o errors on
reservation conflicts can be easily prevented using this trivial patch:

--- linux-2.6.22.orig/drivers/scsi/scsi_error.c 2007-11-26
13:26:58.000000000 +0100
+++ linux-2.6.22/drivers/scsi/scsi_error.c      2007-11-26 13:27:26.000000000
+0100
@@ -1321,7 +1321,7 @@ int scsi_decide_disposition(struct scsi_
        case RESERVATION_CONFLICT:
                sdev_printk(KERN_INFO, scmd->device,
                            "reservation conflict\n");
-               return SUCCESS; /* causes immediate i/o error */
+               return ADD_TO_MLQUEUE;
        default:
                return FAILED;
        }


Now I would like to understand why a reservation conflict always does end in
an i/o error?
Almost the same applies to all the other problems we have with these
Infortrend boxes, in 99.999% of the time the boxes work fine, only
sometimes they suffer from hickup, which usually solves itself after a few
seconds. If we could just suspend i/o for that time, 99% of our problems
would be solved.


Cheers,
Bernd

