From: "Rajat  Jain, Noida" <rajatj@noida.hcltech.com>
Subject: RE: Debug out from SCSI layers
Date: Fri, 4 Feb 2005 02:07:36 +0530
Message-ID: <267988DEACEC5A4D86D5FCD780313FBB04117CE2@exch-03.noida.hcltech.com>
Mime-Version: 1.0
Content-Type: text/plain
Received: from ngate.noida.hcltech.com ([202.54.110.230]:489 "EHLO
	ngate.noida.hcltech.com") by vger.kernel.org with ESMTP
	id S263105AbVBCUkg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Feb 2005 15:40:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Dupuis, Chad" <chad.dupuis@hp.com>, linux-scsi@vger.kernel.org


An excerpt from the net ... Didn't ever personally try it though.

-------------------------------------------------------
Description of new logging facility

The logging facility will make it much easier to troubleshoot problems in
the field. The basic idea is that it is possible to request debugging
information be enabled at any given instant in time, which will be placed
into the kernel log file. The general idea is that there are a number of
different facilities within the kernel, each of which can generate messages
at varying levels of verbosity. When you have specific problems in one area,
you can turn on highly verbose logging for the messages in that subsystem,
and leave the rest off, or put some of the others at lower levels of
verbosity.

Each of the different facilities have names.  The valid names are: all,
none, timeout, scan, mlqueue, mlcomplete, llqueue, llcomplete, hlqueue,
hlcomplete, and ioctl.  Each facility can have a verbosity level from 0 to
7, where 0 indicates completely quiet, and 7 represents maximum verbosity.

There are two fundamental ways of turning this on - one is via the LILO
command line:

scsi_logging=N
 

where N is a number that represents the logging mask. There isn't a really
good symbolic way of describing what you are really turning on from the
kernel command line - you are essentially specifying a 32 bit quantity that
has all of the logging levels stored in it. The easiest way to find the
number you actually want is by setting the desired logging level from the
/proc filesystem, and then recording the logging mask that is reported.

The other way to turn on logging is via the /proc filesystem. A shell
command like:

# echo "scsi log timeout 5" > /proc/scsi/scsi
 

will set the verbosity level to 5 for events related to timeout handling. If
you are lazy and unsure where the problem is, you can set all of the
facilities to the maximum verbosity level with the following command:

# echo "scsi log all" > /proc/scsi/scsi
 

Similarly, it is possible to turn off all logging with the following
command:

# echo "scsi log none" > /proc/scsi/scsi
 

Note - there is a kernel configuration option (CONFIG_SCSI_LOGGING) that can
be used to enable/disable logging. The presence of the logging code
shouldn't present any noticeable run-time overhead, as the testing to see
whether a given facility is at a sufficiently high logging level is all done
inline without any function calls. The only noticeable effect of having the
logging enabled is that the kernel will be slightly larger, as a number of
printk() and other statements will need to be present.
 

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Dupuis, Chad
Sent: Friday, February 04, 2005 1:58 AM
To: linux-scsi@vger.kernel.org
Subject: Debug out from SCSI layers

Hi,

Is there a way to make the SCSI layers (midlayer, sd, etc.) print out a some
debug output to /var/log/messages so that one can see what's going on in
those driver real time?

Thanks,
Chad
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the
body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html
