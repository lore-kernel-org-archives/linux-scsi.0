From: Michael Stone <mstone@mathom.us>
Subject: Re: scsi negotiation problem on aic79xx (39320A) in 2.6.14
Date: Fri, 24 Mar 2006 07:27:17 -0500
Message-ID: <20060324122715.GG15140@mathom.us>
References: <20051114224512.GF9905@mathom.us>
 <20060323180909.GD15140@mathom.us>
 <1143139044.3415.26.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vms048pub.verizon.net ([206.46.252.48]:7665 "EHLO
	vms048pub.verizon.net") by vger.kernel.org with ESMTP
	id S1422724AbWCXM1X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Mar 2006 07:27:23 -0500
Received: from osgiliath.mathom.us ([151.200.254.241])
 by vms048.mailsrvcs.net (Sun Java System Messaging Server 6.2-4.02 (built Sep
 9 2005)) with ESMTPA id <0IWM007FNT9KO4A4@vms048.mailsrvcs.net> for
 linux-scsi@vger.kernel.org; Fri, 24 Mar 2006 06:27:20 -0600 (CST)
In-reply-to: <1143139044.3415.26.camel@mulgrave.il.steeleye.com>
Content-disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Mar 23, 2006 at 01:37:23PM -0500, James Bottomley wrote:
>Well, since the driver works normally for most people, it sounds like
>there's some issue with this configuration.  First of all, look
>in /sys/class/spi_transport/target2:0:0 and tell me what min_period,
>max_offset and max_width are.  Then, if min_period is too high, echo
>12.5 to it and 1 to revalidate.  Finally, see if you can set the period
>yourself using the period file.  Also, what does /proc/scsi/aic79xx/2
>say?  If none of that works, we can try debug the negotiation.

Thanks for the reply, it's finally working. The min_period was 6.5, 
changing it to 12.5 & revalidating made it properly negotiate 160MB/s 
instead of asynchronous. max_offset was 254 & max_width was 1. Is there 
a way to make that permenant beside setting the proc entries on each 
boot?

Mike Stone
