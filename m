From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 13/14] scsi: add support for a blk-mq based I/O path.
Date: Tue, 19 Aug 2014 18:06:25 +0200
Message-ID: <20140819160625.GA29770@lst.de>
References: <1405678393-11497-1-git-send-email-hch@lst.de> <1405678393-11497-14-git-send-email-hch@lst.de> <885d029677826efe0cfe3803411cbdba@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:57559 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097AbaHSQG3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Aug 2014 12:06:29 -0400
Content-Disposition: inline
In-Reply-To: <885d029677826efe0cfe3803411cbdba@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@avagotech.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Robert Elliott <Elliott@hp.com>, Webb Scales <webbnh@hp.com>, linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 03:51:42AM +0530, Kashyap Desai wrote:
> I read  this comment and find that very few drivers are using this
> cmd_list.  I think if we remove this cmd_list, performance will scale as I
> am seeing major contention in this lock.
> Just thought to ping you to see if this is known limitation for now or any
> plan to change this lock in near future ?

Removing the lock entirely and pushing the list into the two drivers
using it is on my TODO list.  Bart actually suggested keeping the code in the
SCSI core and having a flag to enabled.  Given that I'm too busy to get my full
version done in time, it might be a good idea if someone picks up Barts
idea.  Can you send me a patch to add a enable_cmd_list flag to the host
template and only enable it for aacraid and dpt_i2o?

