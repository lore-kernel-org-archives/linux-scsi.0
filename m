From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: Memory corruption & SCSI in 2.6.15
Date: Mon, 12 Dec 2005 11:55:40 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0512121149360.15597@g5.osdl.org>
References: <1134371606.6989.95.camel@gaston> <439DC9E4.6030508@us.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:51600 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932183AbVLLT4S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Dec 2005 14:56:18 -0500
In-Reply-To: <439DC9E4.6030508@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Andrew Morton <akpm@osdl.org>, Linux Kernel list <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>, Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>



On Mon, 12 Dec 2005, Brian King wrote:
> 
> Please try the attached patch. There appears to be a double free going on
> in the scsi scan code. There is a direct call to scsi_free_queue and then
> the following put_device calls the release function, which also frees
> the queue.

Indeed, that looks pretty subtle. 

James: Brian's patch looks obviously correct to me (scsi_alloc_sdev() will 
have called scsi_sysfs_device_initialize() which will set up the release 
function to free the queue). 

This code has been like that forever, though, which makes me wonder. Can 
anybody see what has changed to make the bug trigger? Or is there 
something I'm missing?

		Linus
