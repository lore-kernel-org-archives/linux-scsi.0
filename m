From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Report luns [was: Apple Xserve RAID and qlogic ISP2312 (qla2300)]
Date: Wed, 10 Nov 2004 15:19:49 +1000
Message-ID: <4191A4F5.2040300@torque.net>
References: <20041027233321.GA842@astral.ro> <20041028143734.GA16358@beaverton.ibm.com> <20041028153522.GC1915@astral.ro> <20041028164210.GA16905@beaverton.ibm.com> <20041028172143.GA20949@praka.san.rr.com> <20041029085800.GF6671@astral.ro> <20041029180633.GA27267@beaverton.ibm.com> <20041101105611.GJ22603@astral.ro> <20041101194845.GA27913@us.ibm.com> <41903031.3050205@torque.net> <4190DCE0.1070606@adaptec.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:49104 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261890AbUKJFTw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Nov 2004 00:19:52 -0500
In-Reply-To: <4190DCE0.1070606@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, linux-scsi@vger.kernel.org

Luben Tuikov wrote:
> Douglas Gilbert wrote:
> 
>> So if that fails scsi_scan.c might issue a REPORT LUNS command to
>> this lun: 0xc101 which is the value of the REPORT LUNS well-known lu.
> 
>  > Note that this is a 16 bit quantity (not 64 bit as I said in a
> 
>> previous post about luns). For simplicity let us assume that
>> that it is at the top level. [If a device returns HiSup=1 in its
>> standard INQUIRY response then it claims to support a 4 level
>> hierarchy in its luns (with 16 bits in each level).]
> 
> 
> And also supports REPORT LUNS.
> 
> So in either case, we send REPORT LUNS to LUN 0 and if
> this fails to REPORT LUNS W-LUN (0xC101...).
> 
> Since the standard says that depending on the transport
> protocol LUNs are either 16 or 64 bit values, how do
> we decide this from SCSI Core/app. client?  Wouldn't it
> be better to just send 64 bits with bytes 2 to 7 all 0-ed?
> 
> So in general SCSI Core always uses 64 bits and the LLDD
> decides between 16 and 64 bits, since the transport could
> be messier.
> 
>> So if a modern SCSI enclosure or bridge uses well known lus
>> rather than the lun 0 hack, how will applications in linux
>> access them? They are certainly not block devices.
> 
> 
> Ah, good question.  No, they cannot be block devices since
> they are not mountable.  But they are _addressable_ devices.
> 
> If it is decided to not create a new OS type, then those
> could be char devices on the bus, and accessed via sg.
> 
> If it is decided to create a new OS type, then 'a' would
> be appropriate to denote addressable devices, again
> being accessed via sg.  Do you think expanders could
> be represented by those device types too?

Luben,
I liked the way bsg had a single char device and used
a bind mechanism. However it is only possible to bind
to an existing block device.

SAS expanders (or at least their SMP target ports) are
a similar problem to W-LUNs. Namely we have no way to
"talk" to them from the user space currently in Linux.
SMP is not a SCSI command set (but it is close). Even if
sg could issue SMP commands, I'm not sure the scsi mid
level would be helpful when error conditions occurred
(e.g. SMP command timeout).

As for the addressability problem, sockets and connect
calls come to mind.

Doug Gilbert

