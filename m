From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [usb-storage] USB storage devices and SAT
Date: Mon, 04 Aug 2008 11:31:58 +0300
Message-ID: <4896BE7E.3050405@panasas.com>
References: <489656EC.5000602@torque.net> <20080804022152.GJ4322@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:32697 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752054AbYHDIcU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Aug 2008 04:32:20 -0400
In-Reply-To: <20080804022152.GJ4322@one-eyed-alien.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>

Matthew Dharm wrote:
> On Mon, Aug 04, 2008 at 03:10:04AM +0200, Douglas Gilbert wrote:
>> Alan Stern has already noted to another smartmontools developer
>> that such a change is likely to break some USB storage devices.
>> Perhaps the maximum sense buffer size could be optionally
>> specified per usb storage device. Alternatively the usb mass
>> storage logic could make some dynamic decisions itself.
> 
> To clarify: A great many devices choke (fatally) if asked for sense data
> other than 18 bytes.  Since the first TEST_UNIT_READY will likely require
> sense data, almost every device sees REQUEST_SENSE.
> 
> Personally, I hate having to make dynamic decisions in usb-storage.  The
> more we try to do there, the more likely we are to get it wrong.
> 
> If you've got an app that is sending a command, and you KNOW that command
> should produce >18 bytes of sense data, then there should be a way to
> specify to the SCSI core (and thus get passed to usb-storage) that sense
> data of >18 bytes should be requested.
> 

What?!! The number 18 comes totally from USB land at:
drivers/usb/storage/transport.c:601 via call to scsi_eh_prep_cmnd
Otherwise the entire kernel including scsi-ml and all user applications
request 96 bytes of sense, always.

So there is nothing the SCSI core or application can do about it. 
It is USB fix time I'm afraid.

> Matt
> 

The SAT layer will have to override transport.c/usb_stor_invoke_transport
somehow and make do for bigger REQUEST_SENSE. Or a sense_size param per host,
or per command.

Boaz
