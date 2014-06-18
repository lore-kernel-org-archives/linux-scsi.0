From: Jens Axboe <axboe@kernel.dk>
Subject: Re: scsi-mq
Date: Tue, 17 Jun 2014 20:44:58 -0700
Message-ID: <53A10B3A.6050705@kernel.dk>
References: <1402580946-11470-1-git-send-email-hch@lst.de> <53A05068.4080702@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <53A05068.4080702@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Bart Van Assche <bvanassche@fusionio.com>, Robert Elliot <Elliott@hp.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2014-06-17 07:27, Bart Van Assche wrote:
> On 06/12/14 15:48, Christoph Hellwig wrote:
>> Bart and Robert have helped with some very detailed measurements that they
>> might be able to send in reply to this, although these usually involve
>> significantly reworked low level drivers to avoid other bottle necks.
>
> In case someone would like to see the results of the measurements I ran,
> these results can be found here:
> https://docs.google.com/file/d/0B1YQOreL3_FxUXFMSjhmNDBNNTg.
>
> Two important conclusions from the data in that PDF document are as follows:
> - A small but significant performance improvement for the traditional
>    SCSI mid-layer (use_blk_mq=N).
> - A very significant performance improvement for multithreaded
>    workloads with use_blk_mq=Y. As an example, the number of I/O
>    operations per second reported for the random write test increased
>    with 170%. That means 2.7 times the performance
>    of use_blk_mq=N.

Thanks for posting these numbers, Bart. The CPU utilization and IOPS 
speak a very clear message. The only mystery is why the singe threaded 
performance is down. That we need to get sort, but it's not a show 
stopper for inclusion.

If you run the single threaded tests and watch for queue depths, is 
there a difference between blk-mq=y/scsi-mq and the stock kernel?

> I think this means the scsi-mq patches are ready for wider use.

I would agree. James, I haven't seen any comments from you on this yet. 
I've run various bits of scsi-mq testing as well, and no ill effects 
seen. On top of that, Christophs patches are nicely separated and have 
general benefits even for the non-blk-mq cases. Time to shove them into 
the queue for the next merge window?

-- 
Jens Axboe
