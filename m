From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 0/10][RFC] linux-iscsi driver
Date: Mon, 10 Jan 2005 14:56:25 -0800
Message-ID: <41E30819.50607@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:61147 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S262626AbVAJW4h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jan 2005 17:56:37 -0500
Received: from [192.168.1.7] ([199.108.226.254])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id j0AMuVfm024958
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jan 2005 16:56:32 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The patches attached in the next mails are a temporarily forked
(just waiting to merge and test some stuff) version of
the linux-iscsi driver from http://sourceforge.net/projects/linux-iscsi/.
One large patch can be found here
http://www.cs.wisc.edu/~michaelc/iscsi/current/10-1-2005-scsi-misc/
And, the userspace tools for this forked version are here
http://www.cs.wisc.edu/~michaelc/iscsi/current/10-1-2005-scsi-misc/linux-iscsi-4.0.1.10.1.tar.gz
All patches were made against scsi-misc.2.6 becuase we need
__scsi_print_sense.

We have cleaned up most of the old and duplicated code from previous
versions and have worked to better integrate ourselves with scsi-ml.
At this point, we would like to request more review comments and suggestions.
We also have some outstanding issues that we require suggestions on.

1. IOCTL vs sysfs - Currently, we have killed all but one IOCL cmd.
This last IOCTL is for creation of iSCSI sessions. The reason for
the difficulty in converting it, is becuase the iSCSI session is tied
to the SCSI host, so initially we do not have a place (not completely
true, see C below) to attach sysfs attributes needed to pass in the
setup indo.

We basically follow this sequence:

- usersapace discovers targets and uses the ioctl to pass setup info
to driver
- driver then calls scsi_ahost_alloc() <- allocates session struct in hostdata
- establishes a session (transport connection)
- calls scsi_add_host()

Some possible solutions are:

A. We could do scsi_add_host before we establish a session, but
then we would have a host without a transport connection initially
(our queuecommand would have to handle this (it does already more
or less) or we could block the host during this setup). Is this
acceptable?

B. Add our own LLD bus or class. The class would not be related to
the transport class since this is a driver specific problem. For the bus idea,
we could attempt to add a new scsi bus for all virtual LLDs like software
iscsi and scsi_debug, or we could try to make the current scsi bus handle
driver model drivers from the LLD's as well as the upper layer drivers.

C. Add our attributes to the module /sys/module/iscsi-sfnet. This would
require the driver to have some global tmp pointer that is used for the
current session being setup since there is only one place
(unless we do our own kobject stuff and add more dirs under /sys/module/iscsi-sfnet)
to put the setup attrs (host would not be created yet like above).

D. IOCL.


2. remove driver session/host list - we currently have a list
of sessions used for driver rmmod and ioctl update (the latter can
be moved to sysfs). We are not sure what to use as a replacement
for this list. We have the driver model class or bus option
above.

3. block layer tags usage - The driver requires tags (initiator
task tags) for iSCSI operations like login and Nops (iscsi pings) as
well as SCSI-ml initiated operations like reads or writes. The block
layer tags will not work for us, becuase for login we do not have a
queue yet, but James has stated that other drivers like qla2xxx
would be better off with host level tags and if those are available
at scsi_host_alloc time we would like to use them instead of
implementing our own.


Thanks, for any help and comments

Mike Christie
