From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 1/3] scsi_dh: Add modalias support for SCSI targets
Date: Tue, 07 Apr 2009 16:41:50 -0700
Message-ID: <1239147710.14988.14.camel@chandra-ubuntu>
References: <20090318013615.26548.36303.sendpatchset@chandra-ubuntu>
	 <20090318013621.26548.10529.sendpatchset@chandra-ubuntu>
	 <ac3eb2510903181130s5dd1b1caje579d765fd338f6f@mail.gmail.com>
	 <1237403902.14147.25.camel@chandra-ubuntu>
	 <1237488880.26341.15.camel@chandra-ubuntu>  <49C3DF49.8050408@redhat.com>
	 <1237846429.14853.6.camel@chandra-ubuntu>
	 <1238798590.20924.0.camel@chandra-ubuntu>
	 <1239137973.29492.12.camel@mulgrave>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:58459 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbZDGXlk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2009 19:41:40 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n37Nae3j004663
	for <linux-scsi@vger.kernel.org>; Tue, 7 Apr 2009 17:36:40 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n37Nfd1U228972
	for <linux-scsi@vger.kernel.org>; Tue, 7 Apr 2009 17:41:39 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n37Nfcgi011150
	for <linux-scsi@vger.kernel.org>; Tue, 7 Apr 2009 17:41:39 -0600
In-Reply-To: <1239137973.29492.12.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, Peter Jones <pjones@redhat.com>

Thanks for the response James.
On Tue, 2009-04-07 at 20:59 +0000, James Bottomley wrote:
> On Fri, 2009-04-03 at 15:43 -0700, Chandra Seetharaman wrote:
> > Hi James,
> > 
> > Do you still have any concerns (after Peter's response) ?
> 
> Yes, the basic concerns still remain:
> 
>      1. You're forcing autoload now even if the user isn't running
>         dm ... this is going to cause problems with non-dm based path
>         handlers

As I mentioned in an earlier email, the purpose of moving the device
handler to SCSI layer from dm layer was to make sure that the device
in-differences are taken care of.

For example, the lsi rdac storage is active/passive and we do want the
SCSI layer to handle appropriately so that the I/O is not tried
repeatedly in the passive path. With the device handler in SCSI layer we
were able to handle it properly, thereby reducing the boot time nicely.

So, for all practical purposes these device handlers serve a purpose by
themselves, even without dm-multipath ever needing to use it.

What dm-multipath does by way of calling scsi_dh_activate can also be
done by the interface Hannes added to the sysfs.

>      2. autoloading in this fashion is essentially trying to work around
>         a problem in the initrd tools.  The kernel isn't the right place
>         to implement the fix.

I defer this question to Peter :)

> 
> The risks of this approach seem very high, and the rewards pretty small.
> 
> James
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

