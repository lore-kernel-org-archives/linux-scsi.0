From: Chris Worley <cworley@lnxi.com>
Subject: SCSI Timeout issue w/ QLA2460
Date: 25 Sep 2003 11:36:51 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1064511398.9229.35490.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [208.177.141.226] ([208.177.141.226]:62192 "EHLO
	localhost.lnxi.com") by vger.kernel.org with ESMTP id S261705AbTIYRjk
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2003 13:39:40 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by localhost.lnxi.com (8.11.6/8.11.6) with ESMTP id h8PHaqM09072
	for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2003 11:36:53 -0600
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Background: 2.4.21 korg kernel w/ Qlogic 2460 HBA and Qlogic's driver
(modified for 4096 scatter-gather list size).  Eight servers are
directly connected to a DDN S2A8000 SAN (dual controler, eight FC ports,
2GB file system), no FC switch.

Problem: DDN starts reporting command aborts from server, although no
commands have required an inordinate amount of time to process.  Six
minutes later, the server reports a SCSI error.  The problem is
infrequent, and only happens to one host server at a time, during heavy
load, and has occurred on 6 of 8 hosts.

What I'd like to know:

        o Any insight into what's happening, how to fix it, or how to
        debug it.
        o Why is there such a long period between the SAN seeing aborted
        requests, and the host complaining?
        o Is the SCSI layer resending and re-loosing the same request
        over and over, or are many different requests being lost (in
        general, how do the SAN error messages correlate to the server
        error messages)?
        o Are their any bottlenecks in the SCSI layer that would inhibit
        the number of outstanding requests, and is there any way to
        increase the number of outstanding commands (a performance
        issue... we're only seeing about 20 outstanding commands at peak
        usage, from the SAN perspective, and this SAN is designed to
        handle many more requests simultaneously). 

First, the SAN begins reporting SCSI aborts from the host.  When the
problem occurs, it happens on just one host at a time (but has happened
to many host).  The "port number" maps directly to the host system

> Sep 23 16:50:47 192.168.0.252  Sep 23 16:43:02 192.168.2.206 DMT_45   Command Aborted: SCSI cmd:2A LUN 0 DMT_45 Lane:3 T:230          a:C2ACFADF l: 200 00/00 01,01 W:RDY AB           Anonymous   WWN:210000E08B0A26B7 port:4 lane:3 OX_ID:2058 
> Sep 23 16:50:48 192.168.0.252  Sep 23 16:43:02 192.168.2.206 DMT_49   Command Aborted: SCSI cmd:28 LUN 0 DMT_49 Lane:1 T:230          a:C2ACF9FF l:   8 00/00 02,02 W:RDY AB           Anonymous   WWN:210000E08B0A26B7 port:4 lane:1 OX_ID:2EC8 
> Sep 23 16:51:10 192.168.0.252  Sep 23 16:43:25 192.168.2.206 DMT_45   Command Aborted: SCSI cmd:2A LUN 0 DMT_45 Lane:6 T:229          a:C2ACFADF l: 200 00/00 01,01 W:RDY AB           Anonymous   WWN:210000E08B0A26B7 port:4 lane:6 OX_ID:2568 
> Sep 23 16:51:11 192.168.0.252  Sep 23 16:43:25 192.168.2.206 DMT_49   Command Aborted: SCSI cmd:28 LUN 0 DMT_49 Lane:0 T:230          a:C2ACF9FF l:   8 00/00 02,02 W:RDY AB           Anonymous   WWN:210000E08B0A26B7 port:4 lane:0 OX_ID:2C58 
> Sep 23 16:51:33 192.168.0.252  Sep 23 16:43:48 192.168.2.206 DMT_45   Command Aborted: SCSI cmd:2A LUN 0 DMT_45 Lane:3 T:229          a:C2ACFADF l: 200 00/00 01,01 W:RDY AB           Anonymous   WWN:210000E08B0A26B7 port:4 lane:3 OX_ID:2C88 
> Sep 23 16:51:34 192.168.0.252  Sep 23 16:43:48 192.168.2.206 DMT_49   Command Aborted: SCSI cmd:28 LUN 0 DMT_49 Lane:5 T:230          a:C2ACF9FF l:   8 00/00 02,02 W:RDY AB           Anonymous   WWN:210000E08B0A26B7 port:4 lane:5 OX_ID:2CB8 
> Sep 23 16:51:56 192.168.0.252  Sep 23 16:44:11 192.168.2.206 DMT_45   Command Aborted: SCSI cmd:2A LUN 0 DMT_45 Lane:2 T:230          a:C2ACFADF l: 200 00/00 01,01 W:RDY AB           Anonymous   WWN:210000E08B0A26B7 port:4 lane:2 OX_ID:2CE8 
> Sep 23 16:51:57 192.168.0.252  Sep 23 16:44:11 192.168.2.206 DMT_49   Command Aborted: SCSI cmd:28 LUN 0 DMT_49 Lane:1 T:230          a:C2ACF9FF l:   8 00/00 02,02 W:RDY AB           Anonymous   WWN:210000E08B0A26B7 port:4 lane:1 OX_ID:2D18 
> Sep 23 16:52:19 192.168.0.252  Sep 23 16:44:34 192.168.2.206 DMT_45   Command Aborted: SCSI cmd:2A LUN 0 DMT_45 Lane:4 T:230          a:C2ACFADF l: 200 00/00 01,01 W:RDY AB           Anonymous   WWN:210000E08B0A26B7 port:4 lane:4 OX_ID:2D48 
> Sep 23 16:52:20 192.168.0.252  Sep 23 16:44:34 192.168.2.206 DMT_49   Command Aborted: SCSI cmd:28 LUN 0 DMT_49 Lane:7 T:230          a:C2ACF9FF l:   8 00/00 02,02 W:RDY AB           Anonymous   WWN:210000E08B0A26B7 port:4 lane:7 OX_ID:2D78 
> ...

The SAN vendor adds this to explain the above:

        The command aborts means that the host is canceling the
        outstanding transaction.  The op tells you what the scsi op code
        was for that i/o request.  eg: 28 = read 2a = write.  Lets look
        at "stats delay", and "host status" to see if there is a reason
        why there is a delay.  eg: If we took too long to process an i/o
        request.  If not, it would look like maybe something got locked
        on the host side, causing the i/o to delay, and eventually be
        timed out.

Later, they were able to determine that there isn't any unreasonable
delay on any of the requests coming through the SAN's queue, and, in
fact, their system could be handling many more times the number of
outstanding commands simultaneously (which would lead to better
performance... if anybody knows of anything constraining outstanding
SCSI commands on the kernel side, I'd like to know).

After the DDN starts displaying these errors, I can log into the server
associated with the port: everything looks good... I can browse the file
system without error or delay.  During this time, the DDN continues to
spit out the error message every few seconds (in about bursts of ten
messages at a time).  After about 6 minutes, I get the errors on the
host system:

scsi_io_completion/scsi_lib.c:
> Sep 23 16:58:04 192.168.1.1 kernel: SCSI disk error : host 2 channel 0 id 0 lun 0 return code = 20000 

from scsi_end_request/scsi_lib.c:
> Sep 23 16:58:04 192.168.1.1 kernel:  I/O error: dev 08:41, sector 3266116256 
> Sep 23 16:58:05 192.168.1.1 kernel: SCSI disk error : host 2 channel 0 id 0 lun 0 return code = 20000 
> Sep 23 16:58:05 192.168.1.1 kernel:  I/O error: dev 08:41, sector 3266116032 

Any insight would be appreciated.

Thanks,

Chris



