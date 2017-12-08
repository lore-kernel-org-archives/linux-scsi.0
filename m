From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH v2 1/3] scsi: Fix a scsi_show_rq() NULL pointer
 dereference
Date: Fri, 8 Dec 2017 16:44:56 +0800
Message-ID: <20171208084455.GF21488@ming.t460p>
References: <20171206005753.28734-1-bart.vanassche@wdc.com>
 <20171206005753.28734-2-bart.vanassche@wdc.com>
 <20171208014528.GD21488@ming.t460p>
 <yq1374muebm.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1374muebm.fsf@oracle.com>
Sender: stable-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bart.vanassche@wdc.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Martin,

On Thu, Dec 07, 2017 at 09:46:21PM -0500, Martin K. Petersen wrote:
> 
> Ming,
> 
> > As I explained in [1], the use-after-free is inevitable no matter if
> > clearing 'SCpnt->cmnd' before mempool_free() in sd_uninit_command() or
> > not, so we need to comment the fact that cdb may point to garbage
> > data, and this function(especially __scsi_format_command() has to
> > survive that, so that people won't be surprised when kasan complains
> > use-after-free, and guys will be careful when they try to change the
> > code in future.
> 
> Longer term we really need to get rid of the separate CDB allocation. It
> was a necessary evil when I did it. And not much of a concern since I
> did not expect anybody sane to use Type 2 (it's designed for use inside
> disk arrays).
> 
> However, I keep hearing about people using Type 2 drives. Some vendors
> source drives formatted that way and use the same SKU for arrays and
> standalone servers.
> 
> So we should really look into making it possible for a queue to have a
> bigger than 16-byte built-in CDB. For Type 2 devices, 32-byte reads and
> writes are a prerequisite. So it would be nice to be able to switch a
> queue to a larger allocation post creation (we won't know the type until
> after READ CAPACITY(16) has been sent).

I am wondering why you don't make __cmd[] in scsi_request defined as 32bytes?
Even for some hosts with thousands of tag, the memory waste is still not
too much.

Or if you prefer to do post creation, we have sbitmap_queue now, which can
help to build a pre-allocated memory pool easily, and its allocation/free is
pretty efficient.

Thanks,
Ming
