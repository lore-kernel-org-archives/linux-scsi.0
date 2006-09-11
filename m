From: mmzz@stat.unipd.it (Alberto Cammozzo)
Subject: Re: lp8000 and 2.6.18-rc6
Date: Mon, 11 Sep 2006 11:51:09 +0200
Message-ID: <20060911095109.GA4953@stat.unipd.it>
References: <20060909210856.GC21263@stat.unipd.it> <20060910135631.GD29775@parisc-linux.org> <20060910210444.GC22873@stat.unipd.it> <4504B6AF.3080909@torque.net> <1157941050.3467.21.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [147.162.35.208] ([147.162.35.208]:44704 "EHLO
	stavromula.stat.unipd.it") by vger.kernel.org with ESMTP
	id S932221AbWIKJv2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Sep 2006 05:51:28 -0400
Received: from localhost (argabuthon.stat.unipd.it [147.162.35.209])
	by stavromula.stat.unipd.it (Postfix) with ESMTP id 8E8D71AF5752D
	for <linux-scsi@vger.kernel.org>; Mon, 11 Sep 2006 11:51:18 +0200 (CEST)
Received: from stavromula.stat.unipd.it ([147.162.35.208])
	by localhost (argabuthon.stat.unipd.it [147.162.35.209]) (amavisd-new, port 10024)
	with ESMTP id 27350-04 for <linux-scsi@vger.kernel.org>;
	Mon, 11 Sep 2006 11:51:09 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1157941050.3467.21.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Sun, Sep 10, 2006 at 09:17:30PM -0500, James Bottomley wrote:
> On Sun, 2006-09-10 at 21:06 -0400, Douglas Gilbert wrote:
> > Type 0 is for disks, strange that sd didn't pick up
> > those devices on host 7. Could you fetch the sg3_utils
> > package, build it and try 'sg_inq /dev/sg6'. The output
> > may be interesting.
> 
> That would be characteristic of a zoned array returning PQ not connected
> (or not present) as James Smart suggested ...
> 
> sg_inq would confirm this theory.

	Thank you James, 

	Eventually we managed to solve the problem: 

	Debian sarge has an old rescan-scsi-bus.sh version based on /proc
	instead of /sys. 

	newer lpfc module in 2.6.18 kernels doesn't fill /proc/scsi/HOSTADAPTER, 
	so older rescan-scsi-bus don't even try to map new devices.

	Summarizing: to make partitions visible with lpfc drivers 
	for Emulex LP8000 HBA under 2.6.18 kernels, use newer rescan-scsi-bus 
	http://www.garloff.de/kurt/linux/rescan-scsi-bus.sh

	Thank you everyone for support and the nice work.

	Alberto


-- 
Alberto Cammozzo
System/Network Manager
Universita` di Padova -IT
