From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: RE: After memory pressure: can't read from tape anymore
Date: Thu, 2 Dec 2010 22:25:14 +0200 (EET)
Message-ID: <alpine.LNX.2.00.1012022215060.9213@kai.makisara.local>
References: <1290971729.2814.13.camel@larosa>  <alpine.LNX.2.00.1011291857420.7923@kai.makisara.local>  <1291123886.2181.1347.camel@quux.techfak.uni-bielefeld.de>  <4CF521DE.7020800@panasas.com>  <alpine.LNX.2.00.1011301821210.9731@kai.makisara.local>
 <4CF52A03.2000704@panasas.com>  <alpine.LNX.2.00.1011301853300.9731@kai.makisara.local>  <4CF53349.10509@panasas.com>  <alpine.LNX.2.00.1011302139460.9731@kai.makisara.local> <1291196400.2814.34.camel@larosa> <B2FD678A64EAAD45B089B123FDFC3ED709113ABB@inbmail01.lsi.com>
 <alpine.LNX.2.00.1012021807060.9213@kai.makisara.local> <B2FD678A64EAAD45B089B123FDFC3ED709113B13@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs10.mail.saunalahti.fi ([195.197.172.105]:42819 "EHLO
	vs10.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab0LBUZY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Dec 2010 15:25:24 -0500
In-Reply-To: <B2FD678A64EAAD45B089B123FDFC3ED709113B13@inbmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: Lukas Kolbe <lkolbe@techfak.uni-bielefeld.de>, Boaz Harrosh <bharrosh@panasas.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, 2 Dec 2010, Desai, Kashyap wrote:

> 
> 
> > -----Original Message-----
> > From: Kai Makisara [mailto:Kai.Makisara@kolumbus.fi]
...
> > You can't convert write of one block into multiple IOs. If someone
> > wants
> > to write 2 MB blocks, the system must transfer 2 MB in one IO. The
> > choices
> > are:
> 
> I am not sure why single IO cannot be converted into multiple "IO" request.
> If you run below commands
> " sg_dd if=/dev/zero of=/dev/sdb bs=4800000 count=1"
> 
> You will see multiple IOs(requests) are coming to low layer driver. 
> 
Yes, but each one is writing one or more disk blocks of 512 bytes. You 
don't see writes of partial blocks. If the block size of the device is
2  MB, the minimun IO request is 2 MB. (The SCSI commands for sequential 
access devices are different from the commands for block devices, but the 
minimum read/write unit is one block in both cases.)

Kai

P.S. Why is it necessary to use 2 MB blocks? Some people say that it is 
the optimal block size for some current tape drives.
