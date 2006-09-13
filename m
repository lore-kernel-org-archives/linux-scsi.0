From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: lp8000 and 2.6.18-rc6
Date: Wed, 13 Sep 2006 08:33:35 -0700
Message-ID: <20060913153335.GA21698@us.ibm.com>
References: <20060909210856.GC21263@stat.unipd.it> <20060910135631.GD29775@parisc-linux.org> <20060910210444.GC22873@stat.unipd.it> <4504B6AF.3080909@torque.net> <20060911064008.GA26293@stat.unipd.it> <1157994026.3470.3.camel@mulgrave.il.steeleye.com> <20060912064514.GA28121@stat.unipd.it> <1158156671.3462.7.camel@mulgrave.il.steeleye.com> <45081936.4040209@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:48539 "EHLO
	e36.co.us.ibm.com") by vger.kernel.org with ESMTP id S1750947AbWIMPdQ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Sep 2006 11:33:16 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e36.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id k8DFXFFZ007333
	for <linux-scsi@vger.kernel.org>; Wed, 13 Sep 2006 11:33:15 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k8DFXFJC361814
	for <linux-scsi@vger.kernel.org>; Wed, 13 Sep 2006 09:33:15 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k8DFXET3001740
	for <linux-scsi@vger.kernel.org>; Wed, 13 Sep 2006 09:33:15 -0600
Content-Disposition: inline
In-Reply-To: <45081936.4040209@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Alberto Cammozzo <mmzz@stat.unipd.it>, linux-scsi@vger.kernel.org

On Wed, Sep 13, 2006 at 10:44:06AM -0400, Douglas Gilbert wrote:
> James Bottomley wrote:

> No lun 0 either hence the PQual=1 for the inquiry
> response for /dev/sg6 ('sg_inq /dev/sg6'). I suspect
> 'sg_inq /dev/sg7', sg8 and sg9 also have PQual=1.
> There may be a similar pattern to 'sg_luns /dev/sg7',
> sg8 and sg9 as was reported for 'sg_luns /dev/sg6'.
> 
> > So something really strange is going on here ... The linux code should
> > have executed a probe and add luns for the contents of report lun, which
> > should have found the correct set, unless something went wrong during
> > the reporting.
> > 
> > Can you post the full dmesg from the time the Emulex is detected to the
> > time sg attaches?  report luns is supposed to issue a failure message if
> > something goes wrong (additionally, using the latest -mm would be
> > helpful since that prints enhanced inquiry information from scsi-misc).
> 
> Yes dmesg would be useful. Is there something stopping
> the mid level scanning luns where lun>0 (perhaps something
> in the black list)?

Also set scsi log scan before scanning and include that output, so if the
device isn't added because of PQ it should print a message, use:

	sysctl -w dev.scsi.logging_level=0x01c0

-- Patrick Mansfield
