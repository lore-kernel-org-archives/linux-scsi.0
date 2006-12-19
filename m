From: Jon Escombe <lists@dresco.co.uk>
Subject: Re: [PATCH] scsi_execute_async() should add to the tail of the  queue
Date: Tue, 19 Dec 2006 18:34:33 +0000
Message-ID: <458830B9.90107@dresco.co.uk>
References: <20061219083507.GA20847@localdomain> <1166522613.3365.1198.camel@laptopd505.fenrus.org> <20061219112649.GG5010@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from doppler.zen.co.uk ([212.23.3.27]:39757 "EHLO doppler.zen.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932901AbWLSTJx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Dec 2006 14:09:53 -0500
In-Reply-To: <20061219112649.GG5010@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Arjan van de Ven <arjan@fenrus.demon.nl>, Dan Aloni <da-x@monatomic.org>, Linux Kernel List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, Elias Oltmanns <eo@nebensachen.de>

Jens Axboe wrote:
 > On Tue, Dec 19 2006, Arjan van de Ven wrote:
 >> On Tue, 2006-12-19 at 10:35 +0200, Dan Aloni wrote:
 >>> Hello,
 >>>
 >>> scsi_execute_async() has replaced scsi_do_req() a few versions ago,
 >>> but it also incurred a change of behavior. I noticed that over-queuing
 >>> a SCSI device using that function causes I/Os to be starved from
 >>> low-level queuing for no justified reason.
 >>>
 >>> I think it makes much more sense to perserve the original behaviour
 >>> of scsi_do_req() and add the request to the tail of the queue.
 >> Hi,
 >>
 >> some things should really be added to the head of the queue, like
 >> maintenance requests and error handling requests. Are you sure this is
 >> the right change? At least I'd expect 2 apis, one for a head and one for
 >> a "normal" queueing...
 >
 > It does sounds broken - head insertion should only be used for careful
 > internal commands, not be the default way user issued commands. Looking
 > at the current users, the patch makes sense to me.
 >

It's worth noting that the hdaps disk protection patches rely on the 
current behaviour to add 'IDLE IMMEDIATE WITH UNLOAD' commands to the 
head of the queue.. Another function, or a new parameter for queue 
position would be needed to retain this functionality - any preference 
for either?

Regards,
Jon.

