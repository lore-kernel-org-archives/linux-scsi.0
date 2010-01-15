From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Is this a known problem with the SCSI mid layer?
Date: Fri, 15 Jan 2010 14:02:20 +0100
Message-ID: <4B50675C.8070402@s5r6.in-berlin.de>
References: <364432.14309.qm@web33001.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:48917 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757270Ab0AONCX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jan 2010 08:02:23 -0500
In-Reply-To: <364432.14309.qm@web33001.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Cameron <smcameron@yahoo.com>
Cc: linux-scsi@vger.kernel.org

Stephen Cameron wrote:
> stefanr@s5r6.in-berlin.de wrote:
>> The sg driver's open method takes a reference to the underlying SCSI
>> device representation of the mid layer.  Among else, this step increases
>> the module use count of the respective low-level driver (transport layer
>> driver) so that the SCSI mid layer can be sure that function pointers to
>> driver methods stay valid during the lifetime of the SCSI device
>> representation.
>>
>> This reference taking is of course being reversed when the sg driver
>> finishes its last uses of the underlying SCSI device.  This may be at
>> the respective close() or even later.
>>
>> In short, it is normal, expected, and necessary what you are seeing.
>> -- 
>> Stefan Richter
>>
> 
> I don't think you are correct.  Look more closely at my test cases.
> 
> When I attempt the rmmod, *nothing* has the device open.  The last
> close has already occurred -- albeit *after* the device was
> removed.  

Yep, sorry, I didn't read your report as carefully as necessary.

> In my test, the module *never* becomes rmmod-able.  Doesn't matter
> how long you wait, and nothing will ever decrement the reference
> count.

Did you check that also after, say, several minutes?  I suppose you
already looked at the kernel log for possibly related messages and would
have reported them as well...  Nevertheless, I have seen some cases of
device removal or driver removal where the SCSI layer spent many minutes
(5? 15? I'm not sure anymore) in error handling although the lower layer
had done its best (best but perhaps not well) to report the device as
physically gone.

Did you already test really long after device removal and last close,
along the lines of this?
# while ((i++ < 20)); do rmmod $driver && break; sleep 60; done
-- 
Stefan Richter
-=====-==-=- ---= -====
http://arcgraph.de/sr/
