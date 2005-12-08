From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: linux kernel panic when ejecting ieee1394 ipod
Date: Thu, 08 Dec 2005 20:25:52 +0100
Message-ID: <439888C0.4060508@s5r6.in-berlin.de>
References: <200512072358.15398.adq_dvb@lidskialf.net> <200512080119.48740.adq@lidskialf.net> <200512080159.10913.adq_dvb@lidskialf.net> <200512080209.17757.adq_dvb@lidskialf.net> <43979E1A.30801@s5r6.in-berlin.de> <20051208173429.GA2666@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:18615 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1750907AbVLHT2p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Dec 2005 14:28:45 -0500
In-Reply-To: <20051208173429.GA2666@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Andrew de Quincey <adq_dvb@lidskialf.net>, linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Bryan Olmstead <olmstead@b2mail.net>

Patrick Mansfield wrote:
> On Thu, Dec 08, 2005 at 03:44:42AM +0100, Stefan Richter wrote:
>>What if you replace WRITE by READ in 
>>drivers/scsi/scsi_ioctl.c::scsi_cmd_ioctl()::case CDROMEJECT ?

(unless blk_get_request() knows another flag which comes closer to 
DMA_NONE than READ)

> You must mean block/scsi_ioctl.c? i.e.:

Yes, actually. %-)

> diff -uprN -X /home/patman/dontdiff linux-2.6.15-rc5-git1/block/scsi_ioctl.c mod- linux-2.6.15-rc5-git1/block/scsi_ioctl.c
> --- /home/linux/views/linux-2.6.15-rc5-git1/block/scsi_ioctl.c	2005-12-03 22:51:54.000000000 -0800
> +++ linux-2.6.15-rc5-git1/block/scsi_ioctl.c	2005-12-08 09:31:52.000000000 -0800
> @@ -566,7 +566,7 @@ int scsi_cmd_ioctl(struct file *file, st
>  		case CDROMCLOSETRAY:
>  			close = 1;
>  		case CDROMEJECT:
> -			rq = blk_get_request(q, WRITE, __GFP_WAIT);
> +			rq = blk_get_request(q, READ, __GFP_WAIT);
>  			rq->flags |= REQ_BLOCK_PC;
>  			rq->data = NULL;
>  			rq->data_len = 0;

This should also go to -stable.

BTW, a kernel oops after "eject /mnt/ipod" under 2.6.12 (though no 
panic) was also reported by Bryan Olmstead on July 16 2005. 
http://marc.theaimsgroup.com/?l=linux1394-user&m=112152701817435
 From the multiple problems reported there, everything except the eject 
issue has been fixed in the meantime.
-- 
Stefan Richter
-=====-=-=-= ==-- -=---
http://arcgraph.de/sr/
