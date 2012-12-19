From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/2] Change type-2 dif to use rq embedded 32 byte cdb
Date: Wed, 19 Dec 2012 11:55:30 -0500
Message-ID: <yq1fw327zi5.fsf@sermon.lab.mkp.net>
References: <201212191034.qBJAY3gk007148@d01av04.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31798 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755645Ab2LSQ5X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Dec 2012 11:57:23 -0500
In-Reply-To: <201212191034.qBJAY3gk007148@d01av04.pok.ibm.com> (Scott
	Guthridge's message of "Wed, 19 Dec 2012 05:34:03 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Scott Guthridge <guthridg@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

>>>>> "Scott" == Scott Guthridge <guthridg@us.ibm.com> writes:

Scott,

Scott> I don't know if the reason that "sd" went with the mempool for
Scott> 32-byte commands was binary compatibility with modules, concerns
Scott> about memory usage on small/embedded systems, or both.  

The latter. Type 2 is an edge case and we didn't want to penalize
everybody on the planet by doubling the default command size.


Scott> All of the SCSI drives we're seeing now come from the vendor
Scott> formatted with PI type 2.  Linux automatically detects the format
Scott> and uses PI, so it's no longer a corner case -- it's now the
Scott> normal case.

Drives don't come as Type 2 by default. You have to ask for them to be
formatted that way. All the drives we ship at Oracle are Type 1.

The main reason I'm objecting to the use of Type 2 is that the
protection scheme offered is a poor match for a general purpose OS. If
you look closely at how we treat Type 2 device you'll see that in
reality we drive them as if they were Type 1. I.e. the expected initial
reference tag is set to the LBA. This renders the additional
functionality offered by Type 2 useless and so effectively you get a
Type 1 drive with the cost of a bigger CDB. Plus there are several HBAs
out there that do not even support 32-byte CDBs.


Scott> What we are looking for is simply to be able to send 32-byte
Scott> pass-through commands.

That works today, though. If you send a passthrough command that's
bigger than BLK_MAX_CDB we'll allocate a separate cmd buffer and pin it
to the request. Much like sd does.


Scott> But if a pass-through command sent to the device happened to be a
Scott> 32-byte read with RDPROTECT=3, for example, then the drive will
Scott> return the PI interleaved with the data -- it's this raw
Scott> pass-through functionality that we need.

Also shouldn't be a problem.

-- 
Martin K. Petersen	Oracle Linux Engineering
