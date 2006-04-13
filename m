From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: HBA self selection
Date: Thu, 13 Apr 2006 13:42:25 -0700
Message-ID: <20060413204225.GB6828@us.ibm.com>
References: <5CCF5F0F2514664CBE20FD24BCE17614044BF8@cceexc17.americas.cpqcorp.net> <20060413152419.GD24104@parisc-linux.org> <1144950427.3474.39.camel@mulgrave.il.steeleye.com> <5CCF5F0F2514664CBE20FD24BCE17614044BFD@cceexc17.americas.cpqcorp.net> <1144958819.3474.54.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:36298 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S932465AbWDMUm3
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Apr 2006 16:42:29 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e33.co.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k3DKgSa5003776
	for <linux-scsi@vger.kernel.org>; Thu, 13 Apr 2006 16:42:29 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k3DKcvQC260118
	for <linux-scsi@vger.kernel.org>; Thu, 13 Apr 2006 14:38:57 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id k3DKgSiO008161
	for <linux-scsi@vger.kernel.org>; Thu, 13 Apr 2006 14:42:28 -0600
Content-Disposition: inline
In-Reply-To: <1144958819.3474.54.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "Cameron, Steve" <Steve.Cameron@hp.com>, Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

James Bottomley <James.Bottomley@SteelEye.com> wrote:
> On Thu, 2006-04-13 at 13:35 -0500, Cameron, Steve wrote:
> > If it's a bad idea for general usage... maybe some 
> > way to permit it on a per scsi host basis?  Maybe a 
> > way to enable/disable this feature thru sysfs or 
> > something, with the default being disabled?
> > 
> > Otherwise our SNMP agents won't be able to know that
> > fans failed, overtemp etc. in the storage box.
> 
> Erm, as I read the MSA30 documentation, it has fourteen drive bays.
> That means it has 14 targets plus the processor, so since 16 is the
> addressing capacity of a wide SPI bus, there doesn't seem to be a need
> to have the initiator and the processor at the same ID ... what's the
> reason they have to be?

One could be leaving room for another initiator in a multi-initiator
environment.

To answer the previous question. Since single bit selection is not
supported the peripheral bay can monitor the bus looking for this
condition. Once it sees this state and tries to validate it with some
timing it can assume that the the initiator wants to select the peripheral
bay. It normally does not support disconnects as it is only sending back
SES like data.

-andmike
--
Michael Anderson
andmike@us.ibm.com
