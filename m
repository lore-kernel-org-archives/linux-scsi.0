From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: SMART Status Query
Date: Tue, 03 Feb 2009 17:04:49 +0100
Message-ID: <49886B21.8080801@s5r6.in-berlin.de>
References: <1233643011.8067.21.camel@localhost.localdomain>	 <4987FB23.7040600@s5r6.in-berlin.de> <1233670976.2065.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:33725 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbZBCQEz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Feb 2009 11:04:55 -0500
In-Reply-To: <1233670976.2065.1.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sean Bruno <sean.bruno@dsl-only.net>
Cc: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

Sean Bruno wrote:
> On Tue, 2009-02-03 at 09:06 +0100, Stefan Richter wrote:
>> Sean Bruno wrote:
>> > I tried "smartctl -a /dev/sdd" and was presented with:
>> > [sean@home-desk ~]$ sudo smartctl -a /dev/sdc
>> > smartctl version 5.38 [x86_64-redhat-linux-gnu] Copyright (C) 2002-8
>> > Bruce Allen
>> > Home page is http://smartmontools.sourceforge.net/
>> > 
>> > Device: ST380811 AS               Version: 3.AA
>> > Serial number:             5PS13NWB
>> > Device type: disk
>> > Local Time is: Mon Feb  2 22:36:07 2009 PST
>> > Device does not support SMART
>> > 
>> > Error Counter logging not supported
>> > Device does not support Self Test logging
>> 
>> AFAIK SMART requires "ATA pass-through", i.e. the tunneling of ATA
>> commands through SCSI.
>> 
>> The FireWire drivers happily send any command to the target which the
>> Linux kernel or an application emits.  The missing piece here is ATA
>> pass-through support in the firmware of the FireWire-to-SATA bridge chip
>> of the drive enclosure.
>> 
>> I have not yet heard of FireWire-to-SATA bridges which do support ATA
>> pass-through.
> 
> That makes sense, unfortunate, but not unexpected.
> 
> Can you tell me how my system is getting the Seagate drive information
> then?  I've looked over the data available to me on the Firewire bus,
> and don't see where it's being pulled from.

According to a quick look at the smartmontools source, these data come
from the SCSI INQUIRY command.

FireWire firmwares insert all sorts of data into their INQUIRY
responses.  Sometimes the response is hardcoded by the firmware author,
sometimes it is built from data which were transparently obtained from
the attached SATA disk --- like with your Seagate disk.
-- 
Stefan Richter
-=====-==--= --=- ---==
http://arcgraph.de/sr/
