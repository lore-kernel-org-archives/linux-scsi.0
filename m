From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] minimal SAS transport class
Date: Tue, 23 Aug 2005 10:57:16 -0700
Message-ID: <20050823175716.GA6914@us.ibm.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A4B@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:55241 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S932254AbVHWR5h
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Aug 2005 13:57:37 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e35.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j7NHvXSh302866
	for <linux-scsi@vger.kernel.org>; Tue, 23 Aug 2005 13:57:33 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j7NHv20I412066
	for <linux-scsi@vger.kernel.org>; Tue, 23 Aug 2005 11:57:02 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id j7NHvVjT003298
	for <linux-scsi@vger.kernel.org>; Tue, 23 Aug 2005 11:57:32 -0600
Content-Disposition: inline
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A4B@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: luben_tuikov@adaptec.com, hch@lst.de, jejb@steeleye.com, ltuikov@yahoo.com, Eric.Moore@lsil.com, andrew.patterson@hp.com, linux-scsi@vger.kernel.org

On Tue, Aug 23, 2005 at 12:16:45PM -0400, James.Smart@Emulex.Com wrote:
> > As others stated, id is already a tag/label. You should be 
> > able to pass
> > whatever id you want to scsi_scan_target, like the FC ID 
> > (port_id), and
> > then we also want an abstract iterator in fc transport for the id for
> > usage in scsi_scan.c:scsi_scan_channel. Then you can lose all the
> > fc_host->next_target_id code.
> 
> All nice and well, but....
> 
> How did this help things ?  The issue was the device with a changing
> target id. If the device comes back at the same address each and
> every time, ok. But, with FC, the Port ID is temporal. It can change
> on a loop init, fabric reconfig, or with a user cable swap (kicked
> the cable and replugged).
> 
> If the port id changes during run time, what are you to do ? What if
> a new port is seen at the old port id, how do you now deal with the
> name conflict ? You know apps are going to key off the physical bus
> address being the target - if it changes, this becomes very problematic.

I thought by "the target id is logical for everything but SPI" you meant
that FC enumerated the scsi_device id.

I didn't mean to address problems with persistent names, just map the
scsi_device id to an FC value. We can't keep all the values in the h:c:i:l
constant.

udev (currently, and per Hannes' email in sles9) creates /dev entries with
persistent id's. That does not help if you change scsi_device id values,
or (effectively) remove and add back the same scsi_device. dm-mp should
(eventually?) support that scenario - multipath is really 0 or more paths ...

-- Patrick Mansfield
