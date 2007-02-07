From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [patch] Re: SCSI logging sucks
Date: Wed, 7 Feb 2007 15:35:30 -0800
Message-ID: <20070207153530.70412bc3.randy.dunlap@oracle.com>
References: <45CA0716.5060803@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:46516 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161480AbXBGXjc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Feb 2007 18:39:32 -0500
In-Reply-To: <45CA0716.5060803@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, jejb <james.bottomley@steeleye.com>

On Wed, 07 Feb 2007 12:06:30 -0500 Chuck Ebbert wrote:

> SCSI logging isn't documented very well, and what little there is
> has a problem:
> 
> In Documentation/kernel-parameters.txt we have:
> 
>         scsi_logging=   [SCSI]
> 
> but it's really "scsi_logging_level", as seen here in drivers/scsi/scsi.c:
> 
>  module_param(scsi_logging_level, int, S_IRUGO|S_IWUSR);
>  MODULE_PARM_DESC(scsi_logging_level, "a bit mask of logging levels");

Patch for Documentation/kernel-parameters.txt is below.
Want more/different?


Is this part of drivers/scsi/Kconfig correct??

"""
config SCSI_LOGGING
	bool "SCSI logging facility"
	depends on SCSI
	---help---
	  This turns on a logging facility that can be used to debug a number
	  of SCSI related problems.

	  If you say Y here, no logging output will appear by default, but you
	  can enable logging by saying Y to "/proc file system support" and
	  "Sysctl support" below and executing the command

	  echo "scsi log token [level]" > /proc/scsi/scsi

	  at boot time after the /proc file system has been mounted.

	  There are a number of things that can be used for 'token' (you can
	  find them in the source: <file:drivers/scsi/scsi.c>), and this
	  allows you to select the types of information you want, and the
	  level allows you to select the level of verbosity.
"""


> Not exactly helpful. And the sysctl is called:
> 
>     /proc/sys/dev/scsi/logging_level
> 
> Using scsi_logging.h, I came up with this:
> 
>                 0000 0000 0000 0000 0000 0000 0000 0000
>        0x7                                          111  Error
>       0x38                                      11 1     Timeout
>      0x1c0                                  1 11         Scan
>      0xe00                               111             Midlevel queue
>     0x7000                           111                 Midlevel
> completions
>    0x38000                       11 1                    Lowlevel queue
>   0x1c0000                   1 11                        Lowlevel
> completions
>   0xe00000                111                            Highlevel queue
>  0x7000000            111                                Highlevel
> completions
> 0x38000000        11 1                                   IOCTL
> 
> but I'm not sure if it's right.
> 
> And the actual implementation looks backwards, at least for highlevel
> events. You need to set the level to 800000 to see driver loads and
> that means wading through tons of extraneous crap.  The logging
> should show more verbosity at the higher numbers, not start
> out with the most verbose output at the low numbers.


From: Randy Dunlap <randy.dunlap@oracle.com>

Minor corrections and additions to 'scsi_logging_level', as pointed out
by Chuck Ebbert.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/kernel-parameters.txt |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- linux-2620-work.orig/Documentation/kernel-parameters.txt
+++ linux-2620-work/Documentation/kernel-parameters.txt
@@ -1444,7 +1444,10 @@ and is between 256 and 4096 characters. 
 			Format: <vendor>:<model>:<flags>
 			(flags are integer value)
 
-	scsi_logging=	[SCSI]
+	scsi_logging_level=	[SCSI] a bit mask of logging levels
+			See drivers/scsi/scsi_logging.h for bits.  Also
+			settable via sysctl at dev.scsi.logging_level
+			(/proc/sys/dev/scsi/logging_level).
 
 	scsi_mod.scan=	[SCSI] sync (default) scans SCSI busses as they are
 			discovered.  async scans them in kernel threads,
