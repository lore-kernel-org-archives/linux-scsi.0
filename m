From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 9/13] mpt2sas: T10 DIF Support - EEDP
Date: Wed, 15 Apr 2009 15:53:35 -0700
Message-ID: <660360F4F2570145BD872F298951B17A76B5F27C@cosmail03.lsi.com>
References: <yq1ljq1y2mo.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og116.obsmtp.com ([64.18.2.219]:34750 "EHLO
	exprod7og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756407AbZDOWxn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Apr 2009 18:53:43 -0400
In-Reply-To: <yq1ljq1y2mo.fsf@sermon.lab.mkp.net>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wednesday, April 15, 2009 4:27 PM,  Martin K. Petersen wrote:
> Eric> Yes, I was told by the LSI software test lab, they saw drives
> Eric> returning check condition with these ref tag errors.  I wasn't
> Eric> able to repro that.  What I saw were the IOCSTATUS errors, which
> Eric> is what the code handles in 
> _scsih_eedp_error_handling().  Either
> Eric> way, both cases are covered right?
> 
> Yeah.  With READ the difference is mostly academic.

I forgot to mention how they got the drives to return EEDP errors. They were using sas protocal jammers to inject errors on the bus.

> 
> 
> >> If I understand correctly, your firmware only deals with the Type 2
> >> usage model of the application tag.  And Type 1 + 2 usage of the
> >> reference tag.
> 
> Eric> Our controller firmware support all three types of protection..
> 
> So you can actually set the application tag (and reference tag) on a
> per-sector basis for Type 1 and 3 provided the OS sends down 520-byte
> sectors?
> 

We have a choice of setting the tags on a per IO request basis.  The same tag can apply to all sectors, or you can set some bit telling controller firmware to increment the tag for each sector.    So the bottom line, the current interface I have is not setup for setting each sector from the driver unless I send the normal data having the protection bytes already interleaved in the scatter gather list from the device driver.   (its silly to do that).  

So what I did is good for type1, which is set the ref tag to the lower 32bit of the lba, and the app tag to zero.

For type 3, I asked others for suggestions from a number of co-workers and the software archetic, and they said to set the tags the same way I did for type 1.   Due to my limitations with controller firmware, what do you suggest for type 3?      


> 
> Eric> I wasn't sure whether it needed to be set.  Our controller
> Eric> generates the CRC. I'm not sure whether firmware or hardware
> Eric> implementation.
> 
> Given that it sounds like your next chip rev. will use the same driver
> it should be ok to leave it in place.
> 

Thats the plan I hope.