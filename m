From: Brian King <brking@us.ibm.com>
Subject: Re: [RFC] IBM Power RAID driver (ipr)
Date: Wed, 21 Jan 2004 14:49:42 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <400EE5E6.9080709@us.ibm.com>
References: <40085EDA.4010802@us.ibm.com> <20040119183400.A4182@infradead.org> <400C3E70.9040702@us.ibm.com> <20040120133858.A15671@infradead.org> <400D5A28.1000301@us.ibm.com> <20040120180151.A18616@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.106]:57822 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S266010AbUAUUuX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jan 2004 15:50:23 -0500
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:

>>>Given all the mess these invisble devices create I think they shouldn't
>>>be invisble but rather exported as a second pseudo-channel on the host.
>>
>>Ok. That would solve a lot of problems. I will report these devices in 
>>as scsi disk devices. They will respond like normal SCSI disks, except 
>>when issued media commands (read/write) it will fail with data protect 
>>(07) sense data.
> 
> 
> Now reading this again it might be better to use the "fake" as in not
> registered with the device model devices I mentioned below for this.

How about a flag in the scsi_device struct that an LLD could set in
slave_configure, which would prevent upper layer drivers from binding
to it? Then these devices could be found through the normal scsi scan
and would have nice sysfs entries and sg devices for them. Not sure what
we would call the flag... psuedo_device, fake_device? Then upper level
drivers could check this flag, or if we didn't like that we could move
the upper layer binding logic into scsi_bus_match and keep it all
in one place.


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

