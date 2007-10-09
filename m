From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH] aic94xx: Use request_firmware() to provide SAS address
	if the adapter lacks one
Date: Tue, 9 Oct 2007 10:06:43 -0700
Message-ID: <20071009170643.GE16003@tree.beaverton.ibm.com>
References: <20071008212553.GI16752@tree.beaverton.ibm.com> <20071008224832.GB11993@plap3.qlogic.org> <20071008235009.GB16003@tree.beaverton.ibm.com> <20071009001240.GA13922@plap3.qlogic.org> <470B9E50.2090205@emulex.com> <20071009164147.GB19854@plap3.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:59901 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773AbXJIRGG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Oct 2007 13:06:06 -0400
Content-Disposition: inline
In-Reply-To: <20071009164147.GB19854@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James Smart <James.Smart@Emulex.Com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Alexis Bruemmer <alexisb@us.ibm.com>, James Bottomley <james.bottomley@steeleye.com>

On Tue, Oct 09, 2007 at 09:41:47AM -0700, Andrew Vasquez wrote:
> On Tue, 09 Oct 2007, James Smart wrote:
> 
> >  Why do you prefer request_firmware() vs something over sysfs ?
> > 
> >  Does environments like the kdump kernel also have access to data needed
> >  by request_firmware() ?

Assuming the driver-loading parts of the kdump kernel's initrd are the
same (udev, bunch of modules, firmwares, etc) as the regular kernel's
initrd, this shouldn't be a problem.

In the specific case of aic94xx, one needs request_firmware() and
associated infrastructure to load firmware blobs into the controller in
order to issue any I/O at all.

> There's already much in the way of automation and infrastructure
> present in supporting the request_firwmare() interfaces (perhaps not
> the best of names) which can provide for a level of flexibility beyond
> a basic 'soft_port_name' interface.
> 
> Though I don't see why both can't coexist cleanly -- I take it the use
> case you are considering is: software recognizes no valid WWPN
> available, query via request_firmware() fails, software halts
> initialization (rather than fail), and awaits the admin to poke
> '0x123456.. > /sys/.../fc_host/soft_port_name', causing a ping to the
> driver and continuation of initialization with requested portname?

Hmm... could we use such a sysfs attribute to reassign adapter WWNs at
arbitrary times?  Is that even a good idea?

--D
