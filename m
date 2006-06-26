From: linas@austin.ibm.com (Linas Vepstas)
Subject: Re: Asynchronous scsi scanning, version 9
Date: Mon, 26 Jun 2006 15:58:32 -0500
Message-ID: <20060626205832.GC10505@austin.ibm.com>
References: <20060511143352.GI12272@parisc-linux.org> <20060518172258.GL1604@parisc-linux.org> <20060529031915.GB23405@parisc-linux.org> <447AB2F5.2000700@s5r6.in-berlin.de> <20060529130515.GE23405@parisc-linux.org> <20060531232139.GA3202@us.ibm.com> <447EE81D.2050906@ums.usu.ru> <20060601132315.GD32143@parisc-linux.org> <1151270127.3617.26.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:58046 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932119AbWFZU6f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jun 2006 16:58:35 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k5QKwYVW031845
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Mon, 26 Jun 2006 16:58:34 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.6/NCO/VER7.0) with ESMTP id k5QKwYp7278994
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 26 Jun 2006 16:58:34 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k5QKwWBr028704
	for <linux-scsi@vger.kernel.org>; Mon, 26 Jun 2006 16:58:33 -0400
Content-Disposition: inline
In-Reply-To: <1151270127.3617.26.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-hotplug-devel@lists.sourceforge.net, Stefan Richter <stefanr@s5r6.in-berlin.de>, "Alexander E. Patrakov" <patrakov@ums.usu.ru>, linux-scsi@vger.kernel.org, Patrick Mansfield <patmans@us.ibm.com>

On Sun, Jun 25, 2006 at 04:15:26PM -0500, James Bottomley wrote:
> On Thu, 2006-06-01 at 07:23 -0600, Matthew Wilcox wrote:
> 
> > There's a potential solution to this.  If we add a hook to sys_module_init
> > such that it'll call a specified function before returning, we can make
> > it wait until all scans are done.  This way, userspace never sees the
> > asynchronous scanning behaviour.  But if you have devices of different
> > types, you won't get the overlapping scans.
> 
> How about this solution which works for me with debian on a huge 6 bus
> scsi machine:  it introduces a new module scsi_wait_scan.ko whose sole
> job is to wait for the scans to complete in its init function.  The
> initrd/initramfs sequence now becomes:
> 
> insert all other modules
> modprobe scsi_wait_scan

I guess there's no way of figuring out where the root disk is, and
waiting only for that? 

On large servers, there may be hundreds of attached disks. Anything which 
can parallelize and perform an async scan will help boot times; however, 
waiting for all disks to come on-line when only one is actually needed can 
cause trouble.

In particular, some of the attached disks/scsi chains may be bad, 
in which case one has to wait for a tediously long device/bus/host reset
sequence to complete, and off-line the broken disk.

--linas

