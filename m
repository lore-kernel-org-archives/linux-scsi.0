From: Philip R Auld <pauld@egenera.com>
Subject: Re: [dm-devel] Fibre Channel related crash
Date: Thu, 23 Jun 2005 09:52:28 -0400
Message-ID: <20050623135227.GK9070@vienna.egenera.com>
References: <1119361784.24150.47.camel@nalwalovaton> <20050622172832.GA11128@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from roadrunner-base.egenera.com ([63.160.166.46]:10722 "EHLO
	coyote.egenera.com") by vger.kernel.org with ESMTP id S262326AbVFWNwq
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Jun 2005 09:52:46 -0400
Content-Disposition: inline
In-Reply-To: <20050622172832.GA11128@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org


Hi,

Rumor has it that on Wed, Jun 22, 2005 at 10:28:32AM -0700 Patrick Mansfield said:
> You should really run with a stock kernel before reporting problems to
> these lists.
> 
> cc-ing linux-scsi, maybe someone there will give you more info about the
> HSV110.

The HSV110 is and active/passive array. You're probably accessing a LU 
that is not on the controller your talking to. Sending it a start would
work, but, of course, then you can't access it through the other
controller...

I think the multipath tools and device mapper will know how to handle
this device.

Cheers,

Phil
> 
> On Tue, Jun 21, 2005 at 08:49:44AM -0500, William Alberto Lovaton Tovar wrote:
> 
> > Jun 20 13:35:01 dnccor50 kernel:   Vendor: COMPAQ    Model: HSV110 (C)COMPAQ  Rev: 2001
> > Jun 20 13:35:01 dnccor50 kernel:   Type:   Direct-Access                      ANSI SCSI revision: 02
> > Jun 20 13:35:01 dnccor50 kernel: qla2300 0000:07:03.0: scsi(0:0:1:2): Enabled tagged queuing, queue depth 32.
> > Jun 20 13:35:01 dnccor50 kernel: SCSI device sdb: 167772160 512-byte hdwr sectors (85899 MB)
> > Jun 20 13:35:01 dnccor50 kernel: sdb: asking for cache data failed
> > Jun 20 13:35:01 dnccor50 kernel: sdb: assuming drive cache: write through
> > Jun 20 13:35:01 dnccor50 kernel: SCSI device sdb: 167772160 512-byte hdwr sectors (85899 MB)
> > Jun 20 13:35:01 dnccor50 kernel: sdb: asking for cache data failed
> > Jun 20 13:35:01 dnccor50 kernel: sdb: assuming drive cache: write through
> > Jun 20 13:35:01 dnccor50 kernel:  sdb:<6>Device sdb not ready.
> > Jun 20 13:35:01 dnccor50 kernel: end_request: I/O error, dev sdb, sector 0
> 
> It isn't a fibre channel crash.
> 
> The device is (obviously) not ready. Usually, sd during probe spins up the
> device, but the HSV110 is special cased, so we don't spin it up (send a
> START STOP command), and it just keeps telling us it is still not ready.
> 
> Since it's a disk array, I don't know what a START / spinup means for it,
> or why it is not ready. I would guess it has some sort of failure and is
> waiting for you to fix it :)
> 
> You should check the device: verify its settings, check for failures,
> and/or reset it; or maybe send it a START UNIT to the device.
> 
> You can try to dynamically modify the scsi_devinfo/bflags so it sends the
> START STOP during probe: 
> 
> change the devinfo list (won't be reset to the original until you reload
> scsi_mod), I don't know if I have this exactly right:
> 
> 	echo "COMPAQ   :HSV110 (C)COMPAQ:0x0" > /proc/scsi/device_info
> 
> remove and re-scan for the device
> 
> 	echo 1 > /sys/block/sd/device/delete
> 	echo "0 1 2" > /sys/class/scsi_host/host0/scan
> 
> And see what happens ... you should see some "spinning up disk ..."
> messages.
> 
> -- Patrick Mansfield
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Philip R. Auld, Ph.D.  	        	       Egenera, Inc.    
Software Architect                            165 Forest St.
(508) 858-2628                            Marlboro, MA 01752
