From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH] Hidden scsi devices
Date: Thu, 22 Jan 2004 14:13:52 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40102F00.2050701@us.ibm.com>
References: <OF8847A70B.4AA684AE-ONC1256E23.00571E7C-C1256E23.0058163C@de.ibm.com>	<4010034A.3040903@us.ibm.com> <1074792163.2149.12.camel@mulgrave>	<4010096D.4030205@us.ibm.com> <1074793813.2149.32.camel@mulgrave> 	<20040122194307.GH2611@beaverton.ibm.com> <1074800777.1798.31.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.101]:45033 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S266469AbUAVUN5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jan 2004 15:13:57 -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mike Anderson <andmike@us.ibm.com>, Martin Peschke3 <MPESCHKE@de.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Thu, 2004-01-22 at 14:43, Mike Anderson wrote:
> 
>>Trying to understand the scope of support for the LLDD. While just
>>changing the device_type would be a small change, intercepting future
>>inquiry commands to ensure all future device_types returned this new
>>value would be larger. 
>>
>>Is your comment to change the device type to stop binding also include
>>this intercept capability.
> 
> 
> No, this was just thinking about a short term fix in the driver (without
> having to propagate it through the mid layer).  Lying to the mid layer
> always ends up being more trouble than it's worth.
> 
> 
>>It would seem that if in the future we would want some user space binding
>>control that adding this LLDD device_type modification would be more
>>code to clean out vs just not setting a no bind bit anymore.
> 
> 
> Yes, I think this is the correct future direction as well.

Ok. Scratch this patch and I will override the SCSI device type in
the scsi_device struct in my slave_configure routine to 0x0C.
Actual inquiry commands to the device will return type 0x00 - disk.


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

