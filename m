From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: SCSI's heuristics for enabling WRITE SAME still need work [was: dm mpath: disable WRITE SAME if it fails]
Date: Wed, 25 Sep 2013 20:44:30 -0400
Message-ID: <yq1vc1o9ztd.fsf@sermon.lab.mkp.net>
References: <20130919161043.GA27081@redhat.com>
	<20130920212142.GA17898@redhat.com>
	<yq1eh8jf8wq.fsf@sermon.lab.mkp.net>
	<1379960325.4010.32.camel@localhost.localdomain>
	<52412581.2010909@suse.de> <20130924123449.GA16083@redhat.com>
	<yq1hadaba87.fsf@sermon.lab.mkp.net> <52434D0C.1090008@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48568 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab3IZAom (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Sep 2013 20:44:42 -0400
In-Reply-To: <52434D0C.1090008@fastmail.fm> (Bernd Schubert's message of "Wed,
	25 Sep 2013 22:52:28 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Hannes Reinecke <hare@suse.de>, emilne@redhat.com, device-mapper development <dm-devel@redhat.com>, dgilbert@interlog.com, linux-scsi@vger.kernel.org

>>>>> "Bernd" == Bernd Schubert <bernd.schubert@fastmail.fm> writes:

Hey Bernd,

Bernd> I'm afraid we have another problem. I'm currently working on to
Bernd> get discard working for our LSI2008 HBAs with attached sata-SSDs
Bernd> and the heuristics in sd_read_write_same with based on VPD page
Bernd> 0x89 is not correct for this HBA - its SATL supports write-same

This has nothing to do with the WRITE SAME heuristics.

It's true that depending on wind and whether we might issue WRITE
SAME(10) or (16) with the UNMAP bit set to perform discard operations on
the low level device. But we use a set of different (and somewhat more
reliable) heuristics to decide which command to send down for that
purpose.

For discards to a SATA device to work you need a recent phase LSI
firmware. And you need the target mode firmware (IT). There is no
UNMAP->DSM TRIM translation in the RAID (IR) firmware.

If your SATA SSDs reports DSM TRIM support, the LSI firmware will set
LBPME=1 in READ CAPACITY(16) and the LOGICAL BLOCK PROVISIONING VPD page
will indicate a preference for the UNMAP command (LBPU=1).

Also, LSI firmware is well-behaved in general and will report ILLEGAL
REQUEST when you send down a command that can't be handled.

-- 
Martin K. Petersen	Oracle Linux Engineering
