From: Douglas Gilbert <dougg@torque.net>
Subject: Report luns [was: Apple Xserve RAID and qlogic ISP2312 (qla2300)]
Date: Tue, 09 Nov 2004 12:49:21 +1000
Message-ID: <41903031.3050205@torque.net>
References: <20041027233321.GA842@astral.ro> <20041028143734.GA16358@beaverton.ibm.com> <20041028153522.GC1915@astral.ro> <20041028164210.GA16905@beaverton.ibm.com> <20041028172143.GA20949@praka.san.rr.com> <20041029085800.GF6671@astral.ro> <20041029180633.GA27267@beaverton.ibm.com> <20041101105611.GJ22603@astral.ro> <20041101194845.GA27913@us.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:10146 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261415AbUKIHo0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2004 02:44:26 -0500
In-Reply-To: <20041101194845.GA27913@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
> [ resending ... not sure if this went out at all ]
> 
> On Mon, Nov 01, 2004 at 12:56:11PM +0200, Catalin Muresan wrote:
> 
>>	I have the attached patch from Andrew which fixes the qla2300 part
>>of the problem (attached) and a patch is still needed for the case where
>>there are LUN0,3 to blacklist the device as BLIST_SPARSELUN.
> 
> 
> No attachment ...
> 
> 
>> > 2) If LUN 0 gets a DID_NO_CONNECT (and we do return the
>> > SCSI_SCAN_NO_RESPONSE), we won't scan anything, via REPORT LUN or via
>> > a sequential scan.
>>
>>	we need to have something on LUN 0 to be able to send REPORT LUN, in
>>this case we don't.
> 
> 
> You don't need storage configured on LUN 0 to send it a REPORT LUN, if
> there is a target there, you can (well should) be able to send it a REPORT
> LUN.
> 
> You do need the driver to allow commands to be issued to LUN 0 (that is
> what the patch should have fixed).
> 
> SCSI spec says:
> 
> 	A SCSI device shall support a REPORT LUNS command that is
> 	addressed to logical unit zero. Support of the REPORT LUNS command
> 	by logical units other than logical unit zero is optional.

Patrick,
That would be SAM or SAM-2. In SAM-3 (and SPC-3) that requirement
has been widened to:
"All SCSI devices shall support LUN 0 (i.e. 00000000 00000000h) or
the REPORT LUNS well-known logical unit". [SAM-3 rev 14 section 4.9.3]

Having recently implemented sg_luns (in sg3_utils) I was surprised
to find a "select" field (byte 2) in REPORT LUN's cdb. When it is 0
(as per scsi_scan.c) the returned lun inventory does _not_ include
any well known lus. When select is 1 the returned lun inventory
only includes well known lus (and when select==2 all lus are
returned). Still this is not going to help in SPC-3 since the
device need not respond to lun 0 at all.

So if that fails scsi_scan.c might issue a REPORT LUNS command to
this lun: 0xc101 which is the value of the REPORT LUNS well-known lu.
Note that this is a 16 bit quantity (not 64 bit as I said in a
previous post about luns). For simplicity let us assume that
that it is at the top level. [If a device returns HiSup=1 in its
standard INQUIRY response then it claims to support a 4 level
hierarchy in its luns (with 16 bits in each level).]

SPC-3 defines 3 well known lus:
   - REPORT LUNS
   - ACCESS CONTROLS [0xc102]
   - TARGET LOG PAGES [0xc103]
and each of these supports a small number of (mandatory) SCSI
commands.

So if a modern SCSI enclosure or bridge uses well known lus
rather than the lun 0 hack, how will applications in linux
access them? They are certainly not block devices.

Doug Gilbert

