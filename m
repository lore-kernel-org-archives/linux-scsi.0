From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 1/3] scsi: Fix a scsi_show_rq() NULL pointer dereference
Date: Thu, 07 Dec 2017 21:46:21 -0500
Message-ID: <yq1374muebm.fsf@oracle.com>
References: <20171206005753.28734-1-bart.vanassche@wdc.com>
        <20171206005753.28734-2-bart.vanassche@wdc.com>
        <20171208014528.GD21488@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:58662 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752276AbdLHCrc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Dec 2017 21:47:32 -0500
In-Reply-To: <20171208014528.GD21488@ming.t460p> (Ming Lei's message of "Fri,
        8 Dec 2017 09:45:29 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Bart Van Assche <bart.vanassche@wdc.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, stable@vger.kernel.org


Ming,

> As I explained in [1], the use-after-free is inevitable no matter if
> clearing 'SCpnt->cmnd' before mempool_free() in sd_uninit_command() or
> not, so we need to comment the fact that cdb may point to garbage
> data, and this function(especially __scsi_format_command() has to
> survive that, so that people won't be surprised when kasan complains
> use-after-free, and guys will be careful when they try to change the
> code in future.

Longer term we really need to get rid of the separate CDB allocation. It
was a necessary evil when I did it. And not much of a concern since I
did not expect anybody sane to use Type 2 (it's designed for use inside
disk arrays).

However, I keep hearing about people using Type 2 drives. Some vendors
source drives formatted that way and use the same SKU for arrays and
standalone servers.

So we should really look into making it possible for a queue to have a
bigger than 16-byte built-in CDB. For Type 2 devices, 32-byte reads and
writes are a prerequisite. So it would be nice to be able to switch a
queue to a larger allocation post creation (we won't know the type until
after READ CAPACITY(16) has been sent).

Last I looked at this it was not entirely trivial given how we tag
things on to the end. But that really is my preferred fix.

-- 
Martin K. Petersen	Oracle Linux Engineering
