From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC] training mpath to discern between SCSI errors
Date: Wed, 25 Aug 2010 14:15:13 -0500
Message-ID: <4C756BC1.1030105@cs.wisc.edu>
References: <20100825155918.GB8509@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100825155918.GB8509@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Tejun Heo <tj@kernel.org>, James.Bottomley@suse.de, Hannes Reinecke <hare@suse.de>, tytso@mit.edu, linux-scsi@vger.kernel.org, jaxboe@fusionio.com, jack@suse.cz, linux-kernel@vger.kernel.org, swhiteho@redhat.com, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, konishi.ryusuke@lab.ntt.co.jp, linux-fsdevel@vger.kernel.org, vst@vlnb.net, rwheeler@redhat.com, Christoph Hellwig <hch@lst.de>, chris.mason@oracle.com, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

On 08/25/2010 10:59 AM, Mike Snitzer wrote:
> On Wed, Aug 25 2010 at  4:00am -0400,
> Kiyoshi Ueda<k-ueda@ct.jp.nec.com>  wrote:
>
>>> I'm not sure how to proceed here.  How much work would
>>> discerning between transport and IO errors take?  If it can't be done
>>> quickly enough the retry logic can be kept around to keep the old
>>> behavior but that already was a broken behavior, so...  :-(
>>
>> I'm not sure how long will it take.
>
> We first need to understand what direction we want to go with this.  We
> currently have 2 options.  But any other ideas are obviously welcome.
>
> 1)
> Mike Christie has a patchset that introduce more specific
> target/transport/host error codes.  Mike shared these pointers but he'd
> have to put the work in to refresh them:
> http://marc.info/?l=linux-scsi&m=112487427230642&w=2
> http://marc.info/?l=linux-scsi&m=112487427306501&w=2
> http://marc.info/?l=linux-scsi&m=112487431524436&w=2
> http://marc.info/?l=linux-scsi&m=112487431524350&w=2
>
> errno.h new EXYZ
> http://marc.info/?l=linux-kernel&m=107715299008231&w=2
>
> add block layer blkdev.h error values
> http://marc.info/?l=linux-kernel&m=107961883915068&w=2
>
> add block layer blkdev.h error values (v2 convert more drivers)
> http://marc.info/?l=linux-scsi&m=112487427230642&w=2
>
> I think that patchset's appoach is fairly disruptive just to be able to
> train upper layers to differentiate (e.g. mpath).  But in the end maybe
> that change takes the code in a more desirable direction?

I think it is more disruptive, but is the cleaner approach in the end.

#2 looks hacky. In upper layers, we will have checks for dasd and other 
AOE and other drivers. And then #2 does not even work for filesystems 
(ext said they need this).



>
> 2)
> Another option is Hannes' approach of having DM consume req->errors and
> SCSI sense more directly.
>
