From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 7/8] SCSI: add a field to scsi_device to count open file
 references
Date: Wed, 05 Mar 2008 20:28:27 +0100
Message-ID: <47CEF45B.2080701@s5r6.in-berlin.de>
References: <Pine.LNX.4.44L0.0803051259070.5634-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:41453 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088AbYCET2i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Mar 2008 14:28:38 -0500
In-Reply-To: <Pine.LNX.4.44L0.0803051259070.5634-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Greg KH <greg@kroah.com>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern wrote:
> On Tue, 4 Mar 2008, Stefan Richter wrote:
>> [drivers/scsi/scsi.c]
>>
>>   int scsi_device_get(struct scsi_device *sdev)
>>   {
...
>> +	if (sdev->host->hostt->slave_sdev_get)
>> +		err = sdev->host->hostt->slave_sdev_get(sdev);
...
>> and equivalent additions to scsi_device_put().
> 
> On second thought, I'm not so sure this would work the way I want.  
> scsi_device_get() ends up being called for all sorts of extra things 
> unrelated to device opens.  For instance, scsi_probe_and_add_lun() 
> calls it whenever a new LUN is discovered.

True.

> Would it be acceptable to add a similar pair of callbacks to the host
> template, invoked by the upper-level driver's open and release
> routines?

This would actually be nice for that sbp2 thing which I mentioned as well.
-- 
Stefan Richter
-=====-==--- --== --=-=
http://arcgraph.de/sr/
