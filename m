From: "Heiko Carstens" <Heiko.Carstens@de.ibm.com>
Subject: RE: linux-2.6.0-test11 [BUG] -- scsi_add/remove_device - out of memory
Date: Tue, 13 Jan 2004 10:44:24 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF11CFD4DA.B5836830-ONC1256E1A.00322027-C1256E1A.00356646@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:57476 "EHLO
	mtagate7.de.ibm.com") by vger.kernel.org with ESMTP id S263636AbUAMJoY
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jan 2004 04:44:24 -0500
List-Id: linux-scsi@vger.kernel.org
To: Adam Radford <aradford@3WARE.com>
Cc: linux-scsi@vger.kernel.org

Hi,

yes, now that I had some more time to look into it I found a leak.
Actually the scsi mid layer creates a lot of sysfs attributes but
doesn't remove a single one if a scsi device or a host gets removed.
Since e.g. device_del (as it is called by scsi_remove_device) does
not automatically remove all previously registered sysfs
attributes, we end up with objects that have a reference count > 0
and thus will never be released and eat up memory.

Heiko

To:     Heiko Carstens/Germany/IBM@IBMDE
cc: 
Subject:        RE: linux-2.6.0-test11 [BUG] -- scsi_add/remove_device - out of m emory


Heiko,

Did you figure out where the bug is that is causing the memory leak in the 

scsi layer?  is it in scsi_proc.c? 

-Adam

-----Original Message-----
From: Heiko Carstens [mailto:heiko.carstens@de.ibm.com]
Sent: Wednesday, December 10, 2003 1:12 AM
To: linux-scsi@vger.kernel.org
Subject: linux-2.6.0-test11 [BUG] -- scsi_add/remove_device - out of
memory


Hello all,

it looks to me as if the SCSI stack has a memory leak. If I have the
following
endless loop in our ZFCP LLD we end up within a very short time in an out
of memory situation (tested on an S390 virtual machine with 128MB):

while(1) {
        scsi_add_device(...)
        scsi_remove_device(...);
}

It takes only about 40 iterations to reach the out of memory situation.
The device that gets added and removed does respond to Inquiry commands.
Since I'm not sure what are the pending fixes for the SCSI stack I'm
wondering
if this is a known bug.

Heiko

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


DISCLAIMER: The information contained in this electronic mail transmission
is intended by 3ware for the use of the named individual or entity to 
which
it is directed and may contain information that is confidential or
privileged and should not be disseminated without prior approval from 
3ware 





