From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: [BUG] unable to handle kernel paging request in next-20080516
Date: Fri, 23 May 2008 20:34:25 +0100
Message-ID: <g176e5$6fb$1@ger.gmane.org>
References: <g0mkaf$i1r$1@ger.gmane.org> <20080518021423.3dcf0ddd.akpm@linux-foundation.org> <1211456081.3956.39.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:42942 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757262AbYEWTh7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 May 2008 15:37:59 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1Jzd5P-0002CR-Hk
	for linux-scsi@vger.kernel.org; Fri, 23 May 2008 19:37:55 +0000
Received: from cpc1-cwma5-0-0-cust137.swan.cable.ntl.com ([80.4.12.138])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Fri, 23 May 2008 19:37:55 +0000
Received: from sitsofe by cpc1-cwma5-0-0-cust137.swan.cable.ntl.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Fri, 23 May 2008 19:37:55 +0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

<posted & mailed>

James Bottomley wrote:

> Actually, I think this is a very subtle bug; what I think is happening
> is that after Hannes sysfs changes, we now add scsi_bus_type to the
> target device.  However, scsi_bus_uevent() unconditionally casts from
> dev to a struct scsi_device and then looks at the type entry.  My theory
> is that in this particular config going from struct scsi_target to
> struct device and back to struct scsi_device actually tips us over into
> unmapped space for the -> type deref.
> 
> Hopefully this should fix it by checking the device type before doing
> the deref.

This fixed the problem for me (it was horribly intermittant but I've done
10+ consecutive reboots without seeing an oopos). I changed the patch to
printk everytime the condition was hit and it seems to happen twice per
PATA device - once after each scsi?: pata_via message and then again after
each scsi 0:0:0:0: Direct-Accesss ATA DISKID etc : 0 ANSI: 5 .

The thing I don't understand about your explanation is that it sounds like
the device struct is being round-tripped (but is just being cast to
different things along the way). If this is the case why would this problem
ever arise? Surely if it is really a struct scsi_device underneath there
should be no problem?

-- 
Sitsofe | http://sucs.org/~sits/

