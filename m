From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Write-protect checks
Date: Fri, 09 Dec 2005 09:25:17 +1000
Message-ID: <4398C0DD.50906@torque.net>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F01EE9ECB@otce2k03.adaptec.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:40166 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S932717AbVLHXYJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Dec 2005 18:24:09 -0500
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F01EE9ECB@otce2k03.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Dmitry Antipov <antipov@ru.mvista.com>

Salyzyn, Mark wrote:
> I have an interest in this being checked for fixed media as well, we
> want to expose the underlying physical array components, but read &
> write protected to protect the array contents.

Mark,
How does a device indicate that it is read protected?
[apart from bouncing READ commands with data protect]
SBC-3 has no similar mechanism to the WP bit in the
device specific parameter field returned by MODE SENSE.

IMO sd should check and respect the WP bit for all
devices (whether removable or not). If the sd driver
finds out that a device is read and write protected,
perhaps it should detach itself.

Doug Gilbert

 Christoph asked for us to
> use the scsi layer for this check rather than spoofing it in the driver.
> 
> The other alternative is to add yet another device flag to enforce this.
> 
> Sincerely -- Mark Salyzyn
> 
> 
>>-----Original Message-----
>>From: linux-scsi-owner@vger.kernel.org 
>>[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Alan Stern
>>Sent: Thursday, December 08, 2005 1:22 PM
>>To: SCSI development list; Alan Cox
>>Cc: Dmitry Antipov
>>Subject: Write-protect checks
>>
>>
>>On Thu, 8 Dec 2005, Alan Cox wrote:
>>
>>
>>>On Iau, 2005-12-08 at 11:00 -0500, Alan Stern wrote:
>>>
>>>>module parameter.  For some reason (don't ask me why -- I 
>>
>>don't know) the
>>
>>>>SCSI core doesn't check a disk device's write-protect 
>>
>>status unless the
>>
>>>>device is marked as removable.
>>>
>>>Have you asked the scsi maintainers why this occurs. Having 
>>
>>had a quick
>>
>>>look over the specs I have here I can't see why this is done either.
>>
>>No, I haven't.
>>
>>Okay guys.  Does anyone know why sd.c calls 
>>sd_read_write_protect_flag 
>>only for devices with removable media?
>>
>>Alan Stern
>>
>>-
>>To unsubscribe from this list: send the line "unsubscribe 
>>linux-scsi" in
>>the body of a message to majordomo@vger.kernel.org
>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

