From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Report luns [was: Apple Xserve RAID and qlogic ISP2312 (qla2300)]
Date: Tue, 9 Nov 2004 13:10:55 -0800
Message-ID: <20041109211055.GA11459@us.ibm.com>
References: <20041028143734.GA16358@beaverton.ibm.com> <20041028153522.GC1915@astral.ro> <20041028164210.GA16905@beaverton.ibm.com> <20041028172143.GA20949@praka.san.rr.com> <20041029085800.GF6671@astral.ro> <20041029180633.GA27267@beaverton.ibm.com> <20041101105611.GJ22603@astral.ro> <20041101194845.GA27913@us.ibm.com> <41903031.3050205@torque.net> <4190DCE0.1070606@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.103]:2217 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261689AbUKIVLD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2004 16:11:03 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.12.10/8.12.9) with ESMTP id iA9LB1aJ512794
	for <linux-scsi@vger.kernel.org>; Tue, 9 Nov 2004 16:11:02 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id iA9LB14l285082
	for <linux-scsi@vger.kernel.org>; Tue, 9 Nov 2004 16:11:01 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.12.11) with ESMTP id iA9LAxZt014838
	for <linux-scsi@vger.kernel.org>; Tue, 9 Nov 2004 16:11:01 -0500
Content-Disposition: inline
In-Reply-To: <4190DCE0.1070606@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org

> Douglas Gilbert wrote:
> >So if that fails scsi_scan.c might issue a REPORT LUNS command to
> >this lun: 0xc101 which is the value of the REPORT LUNS well-known lu.
> > Note that this is a 16 bit quantity (not 64 bit as I said in a
> >previous post about luns). For simplicity let us assume that
> >that it is at the top level. [If a device returns HiSup=1 in its
> >standard INQUIRY response then it claims to support a 4 level
> >hierarchy in its luns (with 16 bits in each level).]
> 
> And also supports REPORT LUNS.
> 
> So in either case, we send REPORT LUNS to LUN 0 and if
> this fails to REPORT LUNS W-LUN (0xC101...).

Do we also have to change to send the INQUIRY to the well known LUN?

And then someday add black and white list flags and code for them ...

Why is stuff like this even added to the standard??? Why not use LUN 0
(all zeroes) or at worst have one well known LUN like the all f's?

The hierarchical LUN stuff and the various address modes are dumb, just
treat the LUN as a tag/identifier (similiar to a TCP/IP network port) and
leave the interpretation of it up to the target device (or at worst the
transport).

-- Patrick Mansfield
