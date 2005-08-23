From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] minimal SAS transport class
Date: Tue, 23 Aug 2005 08:42:32 -0700
Message-ID: <20050823154232.GA3464@us.ibm.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A40@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:31721 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S1750784AbVHWPq3
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Aug 2005 11:46:29 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e34.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j7NFjDIO449354
	for <linux-scsi@vger.kernel.org>; Tue, 23 Aug 2005 11:45:23 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j7NFiS0I363730
	for <linux-scsi@vger.kernel.org>; Tue, 23 Aug 2005 09:44:33 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id j7NFiur6003546
	for <linux-scsi@vger.kernel.org>; Tue, 23 Aug 2005 09:44:57 -0600
Content-Disposition: inline
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A40@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: luben_tuikov@adaptec.com, hch@lst.de, jejb@steeleye.com, ltuikov@yahoo.com, Eric.Moore@lsil.com, andrew.patterson@hp.com, linux-scsi@vger.kernel.org

On Sat, Aug 20, 2005 at 12:15:41AM -0400, James.Smart@Emulex.Com wrote:

> - the target id is logical for everything but SPI

> For FC, target ids are typically assigned to devices on a
> 1st-seen-1st-assigned basis. For several reasons, there can be
> changes in port discovery order after link events (cable pulls,
> etc). For 2.4 kernels, the driver typically maintained a mapping
> within the driver to ensure the same device showed up at the same
> target id, even if it disappeared for some amount of time. If FC
> was the boot device, wacky methods were used to ensure the mapping
> persisted boot-to-boot.

As others stated, id is already a tag/label. You should be able to pass
whatever id you want to scsi_scan_target, like the FC ID (port_id), and
then we also want an abstract iterator in fc transport for the id for
usage in scsi_scan.c:scsi_scan_channel. Then you can lose all the
fc_host->next_target_id code.

Printing of them won't be so nice, we should have used hex values in our
device's bus_id.

Hex would also make scsi class/bus_id shorter. 

We can in theory overflow it today: 

	(5 digits per short + 10 digits per int * 3 + 3 :'s) = 38

But BUS_ID_SIZE (KOBJ_NAME_LEN) is 20.

8 byte lun would add on another 10 bytes (if in decimal).

We generally don't have problems since channel is one digit (it should be
a char or bit), id is < 100, and host < 1000 ... lun I'm not sure about:

	(3 + 1 + 2 + 10) + 3 = 19.

i.e. use port_id as the id (8 digits?) and we are more likely to go above 20.

-- Patrick Mansfield
