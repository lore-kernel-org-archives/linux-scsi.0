From: Terrence Martin <tmartin@physics.ucsd.edu>
Subject: Re: Stock 2.6.4 with CONFIG_LBD=y and qla2xxx driver, reportswrongdevice
 size
Date: Wed, 24 Mar 2004 14:28:28 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40620B8C.1080207@physics.ucsd.edu>
References: <200403242207.i2OM7wW19491@dns1.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from newport.ucsd.edu ([132.239.73.89]:6850 "EHLO
	localhost.localdomain") by vger.kernel.org with ESMTP
	id S261170AbUCXW2g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Mar 2004 17:28:36 -0500
In-Reply-To: <200403242207.i2OM7wW19491@dns1.watkins-home.com>
List-Id: linux-scsi@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: 'James Bottomley' <James.Bottomley@SteelEye.com>, 'SCSI Mailing List' <linux-scsi@vger.kernel.org>

Thanks Guy, I think I might just do that, create an MD device out of 3 
equal sized disks.

Where I may have gone wrong and gotten confused is that the Logical 
Drive limit is 64TB. However I have now read, and I assume it is still 
current, that each LUN is only 32bits limiting a LUN to 2TB. You then 
need some sort of additional RAID (hardware or software) presumably to 
map those LUNS to a single disk.

Linux RAID0 should handle this nicely I think.

Thanks

Terrence


Guy wrote:

>Beyond my knowledge...  Wish I was you!  :)
>
>But, if the device has a bug like "bit 33 lopped off".
>If he splits the array into 2 luns/devices then it may be fine.
>Then create the RAID0 with them.
>
>Guy
>
>-----Original Message-----
>From: James Bottomley [mailto:James.Bottomley@SteelEye.com] 
>Sent: Wednesday, March 24, 2004 5:01 PM
>To: Guy
>Cc: 'Terrence Martin'; 'SCSI Mailing List'
>Subject: RE: Stock 2.6.4 with CONFIG_LBD=y and qla2xxx driver,
>reportswrongdevice size
>
>On Wed, 2004-03-24 at 16:53, Guy wrote:
>  
>
>>This is just a guess!!!!!  But I think I am correct.
>>    
>>
>
>The standards are very explicit about what READ CAPACITY(10) should
>return for a >2TB device.  sd detects this and retries with a READ
>CAPACITY(16).
>
>There is no message in the log indicating this happened, so I think the
>device reported an incorrect size to READ CAPACITY(10).  It may have
>reported its size with bit 33 lopped off, but that's still a device
>problem.
>
>James
>
>
>
>  
>

