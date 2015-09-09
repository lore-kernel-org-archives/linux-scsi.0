From: Chang Limin <changlimin@h3c.com>
Subject: Re: LSI SAS2008 SATA TRIM not working
Date: Wed, 9 Sep 2015 01:45:57 +0000 (UTC)
Message-ID: <loom.20150909T034002-827@post.gmane.org>
References: <1391730975.3449.16.camel@sonic.justonedata.com> <1391805990.2761.4.camel@sonic.justonedata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42660 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbbIIBza (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Sep 2015 21:55:30 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <lnx-linux-scsi@m.gmane.org>)
	id 1ZZUbG-0004uC-OC
	for linux-scsi@vger.kernel.org; Wed, 09 Sep 2015 03:55:27 +0200
Received: from 60.191.123.55 ([60.191.123.55])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Wed, 09 Sep 2015 03:55:02 +0200
Received: from changlimin by 60.191.123.55 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Wed, 09 Sep 2015 03:55:02 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Kurt Miller <kurt <at> intricatesoftware.com> writes:

> 
> On Thu, 2014-02-06 at 18:56 -0500, Kurt Miller wrote:
> > Various sources indicate that LSI's SAS2008 controllers support TRIM
> > when running their IT firmware (LSI [1] and this list [2]). However, I
> > have not been able to get it working with Dell PERC H200 or H310 cross
> > flashed into LSI IT firmware. Currently I'm testing with Samsung 840 EVO
> > SATA SSDs. I have tried various LSI IT firmware versions (P14, P16, P18)
> > and various Linux distributions (Ubuntu 13.10, Ubuntu 12.04, Ubuntu 14
> > beta, RHEL 7 beta, Fedora 19).
> >
> > Is TRIM working for anyone using LSI SAS2008 controllers?
> 
> It turns out yes, TRIM is working for LSI SAS2008 controllers. However,
> the Samsung 840 EVO's are not compatible with it and are also missing
> from the LSI compatibility list for the controller [1]. When I got my
> hands on an SSD that is on the list, TRIM worked as expected.
> 
> [1] http://www.lsi.com/downloads/Public/Host%20Bus%20Adapters/Host%20Bus
> %20Adapters%20Common%20Files/LSI_6Gb_SAS_SATA_HBA_Compatibility_List.pdf
> 
> Regards,
> -Kurt
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo <at> vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

I find the Hitachi HUS110 disk storage also does not support fstrim, 
actually it supports unmap. 
The reason is the lbpme in 'sg_readcap -16' return 0, but the unmap in 
'sg_vpd -p 0xb2' return 1. 
Maybe the storage is not fully compatible to the SCSI standard.

# sg_readcap -16 /dev/dm-2
Read Capacity results:
   Protection: prot_en=0, p_type=0, p_i_exponent=0
   Logical block provisioning: lbpme=0, lbprz=1

# sg_vpd --page=0xb2 /dev/dm-2
Logical block provisioning VPD page (SBC):
  Unmap command supported (LBPU): 1
  Write same (16) with unmap bit supported (LBWS): 1


