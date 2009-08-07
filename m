From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: QLA2200 causes kernel bug
Date: Fri, 7 Aug 2009 14:11:50 -0700
Message-ID: <20090807211150.GL18590@plap4-2.local>
References: <6e4c20e70908060828xd4a6a8fh801e1d456c39a5f@mail.gmail.com> <20090806164925.GO2453@plap4-2.local> <6e4c20e70908061012y3fa907aduca4f706cf5ccaa5a@mail.gmail.com> <6e4c20e70908062040x39d8d0b3p90e674ec5925c5ac@mail.gmail.com> <20090807070147.GA13292@plap4-2.local> <6e4c20e70908071219v56f52c2te3b331a229fe9706@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:4077 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbZHGVLu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Aug 2009 17:11:50 -0400
Content-Disposition: inline
In-Reply-To: <6e4c20e70908071219v56f52c2te3b331a229fe9706@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Georgiou <tageorgiou@gmail.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, 07 Aug 2009, Thomas Georgiou wrote:

> I am not sure what is happening at 1840.
> 
> The current topology is royal (the machine in this backtrace)
> connected via 2 fibre channel connections directly to a Powervault
> 224F jbod.  This is then connected via 2 connections again to another
> 224F, which is then connected to another machine, fiord (which also
> has had problems).
> 
> I had royal connected to one 224f with 2 connections and did not
> connect that jbod to anything else, and it worked with no problems for
> the time it was connected like that (2 days).
> 

Ok, so it looks like there's two problems, first, I'd suggest you talk
with your JBOD vendor to see if this daisychained configuration is
supported?  Is the JBOD acting as a mini-hub in this configuration?
Either way, as can be seen from the logs, your storage device is
continually LIP/LIP-resetting causing intermitent and visiblity/loss
to your storage, often times for long enough to have the midlayer
begin its reaping of scsi-devices.  Given the low-seed value
for dev-loss-tmo (set via your qlport_down_retry usage), after
numerous LIPs you run into the second issue: the BUG_ON() triggering
within the FC-transport -- deferred execution of rport reaping in
fc_timeout_deleted_rport().

> I have also tried connecting fiord and royal to two powervault 51f
> switches in a redundant configuration and then the switches to the
> 224Fs.  This also generated problems and was where most of the
> backtraces in the bug reports came from.

Just for completeness, could you gather a similar set of driver logs
with error-logging enabled within this configuration?

> I have set qlport_down_retry=1 for faster failover.

Increasing it may help to avoid problem (2).

> Should I unset
> it?  A constant stream of RESETs is not expected.

Regards,
Andrew Vasquez
