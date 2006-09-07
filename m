From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] scsi_transport_sas: make minimum and maximumlinkratesettable quantities
Date: Thu, 7 Sep 2006 15:39:25 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D7030717E@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:12514 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751896AbWIGVjn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Sep 2006 17:39:43 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: dougg@torque.net, linux-scsi <linux-scsi@vger.kernel.org>

On Thursday, September 07, 2006 8:23 AM, James Bottomley wrote:

> 
> Good ... I'm starting to think we might junk all the function 
> callbacks
> and simply have even the HBA configured via SMP (i.e. the driver would
> interpret SMP messages and set the HBA phys appropriately).
> 

Id rather vote for seeing that we keep scsi lld callbacks for hba
properties, and 
smp passthru for expander properties.

Its going to be alot of work to rip out the current code, and to add
code
for hba that snoops smp passthru, and interprets/translate what is meant
for it.
I doubt all smp passthru's directly map to hba properties.

Also, all these KABI breakages are causing me major headaches.   Between
SLES10 and RHEL5 there is a different API due to the wide port support.
I think
adding new callbacks in transport, doesn't necessary mean I have to
implement them
in the lld, which makes my oem supplied drivers and distro's drivers
more 
compatible between kernel rev's, and upstream.

Eric
