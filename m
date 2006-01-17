From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH 2/8] fusion - mptsas, increase discovery timout to 300 seconds
Date: Tue, 17 Jan 2006 09:54:36 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F1AAD58@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:13995 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932179AbWAQQyq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jan 2006 11:54:46 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

On Monday, January 16, 2006 8:45 PM, Douglas Gilbert wrote: 

> Moore, Eric wrote:
> > Increase the port enable timeout only for SAS from 30 to 
> 300 seconds.
> > A customer request for the handling large topologies.
> 
> Eric,
> I have seen various reports concerning SAS HBAs taking
> "forever" to initialize/discover (various HBA manufacturers,
> various OSes). Perhaps you could enlighten me why these
> timeouts need to be so large.

The timeout before was already 300 seconds when
there was Integrated RAID firmware detected.  We are not
changing that.  My request is for non-raid SAS firmware, 
which before was 30 seconds.  Some customers having several
expanders, devices, and external raid boxs, find that 30 
seconds is not enough time to complete discovery by the firwmare.
If discovery didn't complete in that small 30 second timeframe, 
the driver didn't load.

I'm not sure what reports your getting about discovery taking
forever.  Was that LSI SAS, or someone else's hardware. 
Please enlighten me on that.


> 
> Also if a SAS domain does not contain a fanout expander,
> doesn't that limit the domain to around 128 or 256
> SCSI devices (sum of scsi initiator and target ports)?
> If so, perhaps the timeout could be one of two values,
> a larger value if a fanout expander was found in
> the most recent discover process.
> 

This is firmware assist hardware.  The port enable is
done only when the driver loads.  From port enable, 
the discovery is done in the firmware.  From the driver side, 
we only know about sas topology once the firmware completed 
their discovery.  So I'm not sure how we would be able to 
set timeout for port enable before discovery.  Because before
that point, the device config pages would not be valid.


Eric Moore




