From: Chuck Ebbert <cebbert@redhat.com>
Subject: SCSI logging sucks
Date: Wed, 07 Feb 2007 12:06:30 -0500
Message-ID: <45CA0716.5060803@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161385AbXBGRFq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Feb 2007 12:05:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

SCSI logging isn't documented very well, and what little there is
has a problem:

In Documentation/kernel-parameters.txt we have:

        scsi_logging=   [SCSI]

but it's really "scsi_logging_level", as seen here in drivers/scsi/scsi.c:

 module_param(scsi_logging_level, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(scsi_logging_level, "a bit mask of logging levels");

Not exactly helpful. And the sysctl is called:

    /proc/sys/dev/scsi/logging_level

Using scsi_logging.h, I came up with this:

                0000 0000 0000 0000 0000 0000 0000 0000
       0x7                                          111  Error
      0x38                                      11 1     Timeout
     0x1c0                                  1 11         Scan
     0xe00                               111             Midlevel queue
    0x7000                           111                 Midlevel
completions
   0x38000                       11 1                    Lowlevel queue
  0x1c0000                   1 11                        Lowlevel
completions
  0xe00000                111                            Highlevel queue
 0x7000000            111                                Highlevel
completions
0x38000000        11 1                                   IOCTL

but I'm not sure if it's right.

And the actual implementation looks backwards, at least for highlevel
events. You need to set the level to 800000 to see driver loads and
that means wading through tons of extraneous crap.  The logging
should show more verbosity at the higher numbers, not start
out with the most verbose output at the low numbers.

