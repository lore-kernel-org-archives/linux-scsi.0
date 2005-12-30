From: mark@markschaefer.org
Subject: Re: Booting from or using a Compaq RA4100 Array
Date: Fri, 30 Dec 2005 09:39:39 -0500 (EST)
Message-ID: <2633.198.208.159.18.1135953579.squirrel@www.markschaefer.org>
References: <1135801791.9541.12.camel@gateway.markschaefer.org>
    <200512290845.17192@bilbo.math.uni-mannheim.de>
    <62187.24.3.12.198.1135893081.squirrel@www.markschaefer.org>
    <200512292302.50743@bilbo.math.uni-mannheim.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host79.host79-server.com ([66.49.184.32]:12186 "EHLO
	host79.host79-server.com") by vger.kernel.org with ESMTP
	id S932131AbVL3Ojm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Dec 2005 09:39:42 -0500
In-Reply-To: <200512292302.50743@bilbo.math.uni-mannheim.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: linux-scsi@vger.kernel.org

Eike,

     The RA4100 tries to implement a zoning-style partitioning, called
Selective Storage Presentation (SSP).  Basically, you can create LUNs
on the RAID and point them to a specific FC cards - although they
have to be seen by the 4100 when you're configuring it.  That's why
the REPORT_LUN command can return non-contiguous LUNs (as the comment
indicates).

     So, what the cpqfc driver is doing is reporting the 4100 LUNs to the
kernel as 0,1,2,... although on the drive, they may physically be the
first, third and seventh logical drives (in addition to the wacky
addressing).  It then has to create a mapping array that interprets
the kernel/drive LUNs.

     If I had my pick on SCSI architecture, I'd prefer to standardize the
low-level drivers and put all of the hard-drive/raid specific code in
the mid layer drivers, like what has been done with lpfc.  There is a
lot of garbage code in drivers like cpqfc doing exactly what
scsi_scan and other mid-layer drivers are doing.

     I'd volunteer one of the units for testing, but I assume shipping
would be more than the unit is worth. :(  I'd be happy to test any
bits you want to send, though.

Mark

