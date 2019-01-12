From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: isci: initialize shost fully before calling scsi_add_host()
Date: Fri, 11 Jan 2019 21:34:19 -0500
Message-ID: <yq1lg3qy578.fsf@oracle.com>
References: <20190108205043.3122-1-logang@deltatee.com>
        <20190109184105.GB22070@lst.de>
        <8d96b40d-fc83-9218-9479-3de423594ddb@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8d96b40d-fc83-9218-9479-3de423594ddb@huawei.com> (John Garry's
        message of "Thu, 10 Jan 2019 09:11:44 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: Christoph Hellwig <hch@lst.de>, Logan Gunthorpe <logang@deltatee.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Intel SCU Linux support <intel-linux-scu@intel.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>, chenxiang <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org


John,

> So how about just drop these APIs and let the user set the shost
> protection parameters directly, like other shost parameters,

The protection interfaces here obviously predate the block layer
allocation changes that made this particular issue pop up.

> which should make it a bit clearer when these should be set,
> i.e. before scsi_add_host()?

In general, I am not so keen on the somewhat messy intersection between
the host parameters and the host template. The static host templates
made lots of sense in the days of Seagate ST01 and fixed hardware
capabilities.  But reality is that most modern controllers have to query
firmware interfaces to figure out what their actual capabilities are.

So in this case I think that accessor functions are actually better
because they allow us to print a big fat warning when you twiddle
something you shouldn't post-initialization. So that's something I think
we could--and should--improve.

-- 
Martin K. Petersen	Oracle Linux Engineering
