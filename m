From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/2] scsi error: add target reset eh handler
Date: Wed, 26 Dec 2007 21:21:21 -0600
Message-ID: <47731A31.6000008@cs.wisc.edu>
References: <1198037469664-git-send-email-michaelc@cs.wisc.edu>	 <1198037477766-git-send-email-michaelc@cs.wisc.edu> <1198272974.3130.70.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:35114 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852AbXL0DV3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Dec 2007 22:21:29 -0500
In-Reply-To: <1198272974.3130.70.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Tue, 2007-12-18 at 22:11 -0600, michaelc@cs.wisc.edu wrote:
>> From: Mike Christie <michaelc@cs.wisc.edu>
>>
>> Drivers like qla4xxx and bnx2i (and it looks like some fcp drivers too),
>> want to be able to send a lun reset in the eh device handler and then a
>> target reset in some other handler. The old linux-iscsi driver, which did
>> the host per session like open-iscsi did the target reset in the host reset,
>> because the scsi command accounting that scsi_error.c does worked out
>> nicely for software iscsi, but does not work for hardware iscsi well.
>>
>> This patch adds a eh_target_reset_handler any driver can use to send
>> a target reset.
>>
>> The next patch will hook qla4xxx into it, and patches for iscsi_tcp/iser
>> and bnx2i will follow later when bnx2i is closer to getting merged.
> 
> We sort of have a mapping problem here.  In the old ways of the error
> handler, since it was based on SPI and SCSI-2, when it said "device
> reset" what it actually meant was target reset, since that was the only
> message the SPI bus could send.  It was only in the later SCSI-3
> standard that a LUN reset came along.  So, most resent implementations
> (even FC ones) send a target reset for this function.


Ah that is what I thought someone told me a while back, but it confused 
the heck out of me, because while I was looking at the code I saw that 
scsi_eh_bus_device_reset only cleans up the commands for one scsi_device 
and only reports one device as reset (sets was_reset and expecting_cc_ua 
to one), so it looks perfect to send a logical unit reset from.

> 
> So ... where I'm going is that I'm not averse to adding a target reset
> (it has been suggested before), but then we'll have to clean up a lot of
> other drivers.  Alternatively, you could just plumb target reset in to
> the qla2xxx where device reset now is.
>

Doing the target reset in the the device reset handler just does not 
seem nice. scsi_error.c's scsi_eh_bus_device_reset() only calls 
scsi_eh_finish_cmd on the commands for one scsi_device. And the 
eh_device_reset_handler gets called for every device on the target, so
the driver has to either remember that it just sent a target reset for 
another device on the same target or just send a target reset every time 
the device handler is called. qla4xxx also already sends a logical unit 
reset on the device reset callback.

Do we have to clean up all the drivers in one shot while adding the 
target reset callback or can we add the callback and have driver writers 
convert when they are ready like was done with the old and new driver 
loading (scsi_host_template->detect/release vs 
pci_device->probe/remove)? Some drivers like qla2xxx look trivial, but 
for other more difficult drivers I hate changing driver eh paths for hw 
I do not have, because it is difficult to get users to test that code 
path well. With my patch the device reset handler does not change 
behavior, so if a driver sends a target reset from there it has already 
added some LLD level hacks to handle the issues I mention above and will 
be fine. I can port drivers if you want me to though.
