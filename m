From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Fw: SCSI device not spinning up on rw
Date: Tue, 11 Jul 2006 14:19:48 +0200
Message-ID: <44B39764.3030204@s5r6.in-berlin.de>
References: <20060603182302.7136831f.akpm@osdl.org> <44825D9F.9070305@torque.net> <44835AA2.1070809@us.ibm.com> <4484723E.7060906@us.ibm.com> <20060711062049.GA12266@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:54690 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1751239AbWGKMU0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jul 2006 08:20:26 -0400
In-Reply-To: <20060711062049.GA12266@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olh@suse.de>
Cc: Brian King <brking@us.ibm.com>, dougg@torque.net, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, Ruben Faelens <parasietje@gmail.com>

Olaf Hering wrote:
>  On Mon, Jun 05, Brian King wrote:
>>Brian King wrote:
...
>>>Setting sdev->allow_restart in struct scsi_device will cause sense
>>>key/code/qual of 02/04/02 (not ready, initialization command required)
>>>to wake up the scsi error handler and will force scsi core to issue
>>>a start unit command to the disk. I added this a while back to handle
>>>ipr raid arrays which need a start unit command each time the adapter
>>>gets reset.
...
>>Please try the attached patch. It adds a sysfs device attribute "allow_restart".
...
> Is it safe to have this attribute be 1 per default, and let the user
> disable it for problematic drives? The IO errors bother me alot...

Matthew Dharm pointed out that it may confuse USB devices:
http://marc.theaimsgroup.com/?l=linux-scsi&m=107702811830956

Side note: May plan for sbp2 is to switch the flag on only for models 
(or, as it is currently done in -mm, for vendor IDs) which are known to 
need the flag. The flag won't hurt with most SBP-2 HDDs; most of them 
don't need it though. But I am worried about how the unknown few quirky 
ones may react. On the other hand, it is likely that MS's SBP-2 stack is 
behaving like Linux with allow_restart=1. I somehow doubt they have a 
whitelist or blacklist for it.

What about enabling it for all direct access and RBC devices, except USB 
direct access devices? (Or equivalently, enable it for all devices in 
scsi/sd but switch it off again in usb-storage?) Or would that be too 
daring?
-- 
Stefan Richter
-=====-=-==- -=== -=-==
http://arcgraph.de/sr/
