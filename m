From: Denny Page <denny@cococafe.com>
Subject: Re: scsi negotiation problem on aic79xx (39320A) in 2.6.14
Date: Fri, 19 May 2006 22:10:13 -0700
Message-ID: <446EA4B5.2030507@cococafe.com>
References: <20051114224512.GF9905@mathom.us> <20060323180909.GD15140@mathom.us> <1143139044.3415.26.camel@mulgrave.il.steeleye.com> <20060324122715.GG15140@mathom.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cococafe.com ([64.142.30.235]:36502 "EHLO
	mail.cococafe.com") by vger.kernel.org with ESMTP id S932176AbWETFKP
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 May 2006 01:10:15 -0400
In-Reply-To: <20060324122715.GG15140@mathom.us>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

James,

The problem that Michael describes appears to be identical to the problem
that I had reported with the HP-460 tape drives.  Same 6.5 min period, fixed
by echo 12.5 and validating.  Perhaps the problem is specific to the card
rather than with the array and tape drive?

Setting the xfer speed in the bios does not appear to affect the result with
the 2.6.16 kernel.

Denny


Michael Stone wrote:
> On Thu, Mar 23, 2006 at 01:37:23PM -0500, James Bottomley wrote:
>> Well, since the driver works normally for most people, it sounds like
>> there's some issue with this configuration.  First of all, look
>> in /sys/class/spi_transport/target2:0:0 and tell me what min_period,
>> max_offset and max_width are.  Then, if min_period is too high, echo
>> 12.5 to it and 1 to revalidate.  Finally, see if you can set the period
>> yourself using the period file.  Also, what does /proc/scsi/aic79xx/2
>> say?  If none of that works, we can try debug the negotiation.
>
> Thanks for the reply, it's finally working. The min_period was 6.5, 
> changing it to 12.5 & revalidating made it properly negotiate 160MB/s 
> instead of asynchronous. max_offset was 254 & max_width was 1. Is 
> there a way to make that permenant beside setting the proc entries on 
> each boot?
>
> Mike Stone
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
