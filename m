From: James.Smart@Emulex.Com
Subject: RE: [PATCH] minimal SAS transport class
Date: Tue, 23 Aug 2005 12:16:45 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A4B@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:12961 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932204AbVHWQRU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Aug 2005 12:17:20 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: patmans@us.ibm.com
Cc: luben_tuikov@adaptec.com, hch@lst.de, jejb@steeleye.com, ltuikov@yahoo.com, Eric.Moore@lsil.com, andrew.patterson@hp.com, linux-scsi@vger.kernel.org

> As others stated, id is already a tag/label. You should be 
> able to pass
> whatever id you want to scsi_scan_target, like the FC ID 
> (port_id), and
> then we also want an abstract iterator in fc transport for the id for
> usage in scsi_scan.c:scsi_scan_channel. Then you can lose all the
> fc_host->next_target_id code.

All nice and well, but....

How did this help things ?  The issue was the device with a changing
target id. If the device comes back at the same address each and
every time, ok. But, with FC, the Port ID is temporal. It can change
on a loop init, fabric reconfig, or with a user cable swap (kicked
the cable and replugged).

If the port id changes during run time, what are you to do ? What if
a new port is seen at the old port id, how do you now deal with the
name conflict ? You know apps are going to key off the physical bus
address being the target - if it changes, this becomes very problematic.

This approach only works as long as the transport's id fits within
the target id (an int). How would the SAS address(8byte wwn) utilize
such a scheme ?

-- james s
