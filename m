From: Phil Brutsche <phil@brutsche.us>
Subject: Re: Fw: [Bugme-new] [Bug 3651] New: dell poweredge 4600 aacraid PERC
 3/Di Container goes offline
Date: Thu, 28 Oct 2004 13:21:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <418138B6.2010104@brutsche.us>
References: <20041028005302.753a2d52.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl-3-146.novia.net ([216.40.3.146]:29363 "EHLO
	mail.optimumdata.com") by vger.kernel.org with ESMTP
	id S263041AbUJ1SVo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Oct 2004 14:21:44 -0400
Received: from cerias.ad.optimumdata.com ([172.17.1.213])
	by mail.optimumdata.com with esmtpsa (TLSv1:DHE-RSA-AES256-SHA:256)
	(Exim 4.43)
	id 1CNEu6-0002Th-DS
	for linux-scsi@vger.kernel.org; Thu, 28 Oct 2004 13:21:42 -0500
In-Reply-To: <20041028005302.753a2d52.akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Andrew Morton wrote:
> Distribution: Debian Sarge
> Hardware Environment: Dell Poweredge 4600, 5 Disks each 146GB in a Raid 5 in 
> one container, 8 GB RAM, Dual Xenon 2GHz. The Perc 3/Di Controller is on 
> Firmware version 2.80 Build 6092
> Software Environment: aacraid
> Problem Description: 
> The Container on the PERC 3/Di Controller goes offline on heavy I/O Load with 
> the following error message:
> 
> SCSI:0 (0:0): rejecting I/O to offline device
> Buffer I/O error due to I/O error on sda8
> 
> Steps to reproduce:
> 
> I am using bonnie++ to produce I/O load on the only Volume on the Perc 3/Di 
> Controller with the following parameters bonnie++ -d /var/lib/postgres/test -s 
> 16000 -n 150 -r 8000 -u nobody:nogroup

FYI, I have been seeing this as well.

I can trigger this card lockup at will with mkfs.ext3; for other
filesystems, I may need to extract a kernel source .tar.gz in order to
cause a lockup.

aacraid: Host adapter reset request. SCSI hang ?
aacraid: Host adapter appears dead
Device offlined - not ready after error recovery: host 1 channel 0 id 0
lun 0
SCSI error : <1 0 0 0> return code = 0x6000000
end_request: I/O error, dev sdb, sector 1667007
Buffer I/O error on device sdb1, logical block 208368
lost page write due to I/O error on sdb1
scsi1 (0:0): rejecting I/O to offline device
Buffer I/O error on device sdb1, logical block 208369

I am using an Adaptec 2120S with a RAID5 of Seagate U320 drives - yes, I
know about the Seagate firmware timeout problem, these drives are brand
new with firmware rev 0006 and thus aren't affected.

This hardware has no problems with kernel 2.4.x.

-- 

Phil Brutsche
phil@brutsche.us
