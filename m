From: Eddie Williams <Eddie.Williams@steeleye.com>
Subject: Re: Patch:  allow devices to restrict start on add
Date: Thu, 22 May 2003 16:10:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200305221610.07839.Eddie.Williams@Steeleye.com>
References: <200305221140.59633.Eddie.Williams@Steeleye.com> <20030522110522.A7240@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:35333 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263202AbTEVUFf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 May 2003 16:05:35 -0400
Received: from aslan (aslan.sc.steeleye.com [172.17.6.51])
	by hancock.sc.steeleye.com (8.11.6/linuxconf) with ESMTP id h4MKIeI16705
	for <linux-scsi@vger.kernel.org>; Thu, 22 May 2003 16:18:40 -0400
In-Reply-To: <20030522110522.A7240@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Thursday 22 May 2003 02:05 pm, Patrick Mansfield wrote:
> Eddie -
>
> On Thu, May 22, 2003 at 11:40:59AM -0400, Eddie Williams wrote:
> > When a SCSI disk is added and it returns a NOT READY the SD driver is
> > automatically sending a START_UNIT command to spin the device up.  While
> > this may be the desired behavior for many if not most devices not all
> > devices either want or need this.  The attached patch provides a
> > mechanism via the
>
> Can you elaborate on "want or need this"? Do they get errors?

The "problem" is that some devices use a start unit to activate a LUN on a 
passive path.  So if the device has 2 paths then as SCSI is scanning down one 
path start units are issued to activate the LUNs on that path.  When SCSI 
scans the next path it issues the starts to activate the LUNs down that path.  
The causes "thrashing."  Perhaps you can imagine what the affect may be if 
there are multiple boxes booting.  This switching of the LUNs from one path 
to another causes IO's to have to be rerouted and thus great disruption to 
the IO activity.

At times I have seen other discussions on this list where there have been 
complaints about automatically issuing START_UNIT.  Perhaps this feature 
would be able to satisfy those concerns as well?  I have not gone through the 
archives to see the particular discussions through.

>
> Is this a clusters issue?

The particular problem I am seeing is a multi-path SAN issue.  Any box 
connected to a SAN that reboots causes start units to get issued down each 
path of a device.


>
> Also you should patch against scsi-misc-2.5, or a recent bk, since hch
> moved all of the devinfo code into scsi_devinfo.c

Yes.  I had taken a snapshot of the kernel a couple of weeks ago but it took a 
while for me to test it out but did not go back and remerge.  I will have 
that out tomorrow.

Eddie


