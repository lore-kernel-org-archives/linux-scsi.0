From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] 2.6.25-rc4-git3 - inquiry cmd issued via /dev/sg? device
 causes infinite loop in 2.6.24
Date: Mon, 17 Mar 2008 13:08:39 -0500
Message-ID: <47DEB3A7.1030600@cs.wisc.edu>
References: <47D7035F.5000700@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:47874 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762AbYCQSIx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Mar 2008 14:08:53 -0400
In-Reply-To: <47D7035F.5000700@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: Douglas Gilbert <dougg@torque.net>, linux-scsi <linux-scsi@vger.kernel.org>, Jeremy Higdon <jeremy@sgi.com>, James Bottomley <James.Bottomley@SteelEye.com>

Michael Reed wrote:
> -		++blk_size;	/* don't know why */
> -/* round request up to next highest SG_SECTOR_SZ byte boundary */

I think we can remove this code. This was asked before, and here is 
Doug's reply:
http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg11757.html

It was probaly due to some weirdness in that the scatterlist that sg.c 
made used to be sent directly to the LLD (now it is only used to 
hold/organize the pages/segments that the sg and st driver manages in 
their internal reserves), or maybe it had something to do with that and 
dma alignment problems or something. I really have no idea, but the 
block layer SG IO code has not been rounding up in its indirect path and 
it has been fine.

