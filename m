From: "Dr. Ernst Molitor" <molitor@uni-bonn.de>
Subject: Linux-2.6.0-test4: Kernel Panic in scsi_host_dev_release
Date: Mon, 25 Aug 2003 22:54:09 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1061844849.486.12.camel@felicia>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout06.sul.t-online.com ([194.25.134.19]:40654 "EHLO
	mailout06.sul.t-online.com") by vger.kernel.org with ESMTP
	id S262328AbTHYUyR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2003 16:54:17 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, "Dr. Ernst Molitor" <molitor@uni-bonn.de>

Dear James E.J. Bottomley, 

while Linux-2.6.0-test3 runs like a charm on my (testbed) box, I ran
into a kernel panic with Linux-2.6.0-test4 (and 2.6.0-test4-bk4). 

The call trace is:

scsi_host_dev_release
device_releases
kobject_cleanup
aha1542_detect
init_this_scsi_driver
do_initcalls
init_workqueues
init
init
kernel_thread_helper

The last line of the panic says: 
<0>Kernel Panic: Attempted to kill init!

Assuming the problem lies with the scsi subsystem, I thought you might
perhaps be able to pinpoint the problem. 

For what my small knowledge of kernel internals is worth, I looked into
the scsi_host_dev_release function new to drivers/scsi/hosts in
2.6.0-test4. This function receives a struct dev * and extracts an
Scsi_Host pointer from it via the dev_to_shost macro, which, in fact, is
syntactical sugar to the container_of macro. 

The predecessor of the scsi_host_dev_release function in 2.6.0-test3 was
scsi_free_shost (which had a parameter of type Scsi_Host *). 

The last line of both functions is identical: kfree is called with the
pointer shost. From a very superficial analysis, I would feel that
freeing *dev rather than *shost would be logical, but I might very well
be way off the real source of the panic I have seen.

If you'd like me to, I could provide the full kernel panic message
(since the system is far from booted when the panic occurrs, I don't
have any trace of this on my disks...). 

Kind regards, 

Yours 

Ernst Molitor

