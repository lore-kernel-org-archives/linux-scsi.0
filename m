From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Apple Xserve RAID and qlogic ISP2312 (qla2300)
Date: Thu, 28 Oct 2004 09:42:10 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041028164210.GA16905@beaverton.ibm.com>
References: <20041027233321.GA842@astral.ro> <20041028143734.GA16358@beaverton.ibm.com> <20041028153522.GC1915@astral.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.102]:18090 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261721AbUJ1Qmc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Oct 2004 12:42:32 -0400
Content-Disposition: inline
In-Reply-To: <20041028153522.GC1915@astral.ro>
List-Id: linux-scsi@vger.kernel.org
To: Catalin Muresan <catalin.muresan@astral.ro>, James Bottomley <James.Bottomley@steeleye.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org, bogdan.luca@astral.ro

On Thu, Oct 28, 2004 at 06:35:22PM +0300, Catalin Muresan wrote:

Ok, that should have been lun 5.

>  > > Oct 28 01:59:37 zerg-b kernel: scsi_scan_host_selected: <0:4294967295:4294967295:4294967295>
>  > > Oct 28 01:59:37 zerg-b kernel: scsi scan: INQUIRY to host 0 channel 0 id 0 lun 0
>  > > Oct 28 01:59:37 zerg-b kernel: scsi scan: 1st INQUIRY failed with code 0x10000
>  > 
>  > The 0x10000 is a DID_NO_CONNECT, generally the adapter can't talk to
>  > the target at all.
> 
> 	I don't know what the SCSI spec has to say about this, but by
> looking at the code it should respond with SCSI_SCAN_TARGET_PRESENT.

Hmmm ... my interpretation of DID_NO_CONNECT was that the adapter cannot
talk to the target at all.

You should be able to send an INQUIRY to any LUN on a target, the HBA
really shouldn't block it.

Given that, it is correct for the scan to give SCSI_SCAN_TARGET_PRESENT
on a DID_NO_CONNECT.

So, it looks like the qlogic is giving a DID_NO_CONNECT when it should
not. We could hack around this in scsi_scan.c but that might be bad.

James or Andrew what do you think?

Catalin - does the device support REPORT LUNS? Do you have that
configured? It would avoid this problem.

> 	my goal is to have a kernel with which I can boot from FC, but i see
> that can be done only with an ugly patch(for now) or with tricks from
> initrd.

What tricks and ugly patch? I haven't tried boot via qlogic on an HS20.

-- Patrick Mansfield
