From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 5/5] dm: implement REQ_FLUSH/FUA support
Date: Thu, 19 Aug 2010 19:32:04 +0900
Message-ID: <4C6D0824.3070908@ct.jp.nec.com>
References: <1281977523-19335-1-git-send-email-tj@kernel.org> <1281977523-19335-6-git-send-email-tj@kernel.org> <20100816190203.GA22299@redhat.com> <4C6A5780.2090100@kernel.org> <20100817140734.GA30768@redhat.com> <4C6ABE12.40705@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4C6ABE12.40705@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, Mike Snitzer <snitzer@redhat.com>
Cc: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com, hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
List-Id: linux-scsi@vger.kernel.org

Hi Tejun, Mike,

On 08/18/2010 01:51 AM +0900, Tejun Heo wrote:
> On 08/17/2010 04:07 PM, Mike Snitzer wrote:
>> NOTE: NEC has already given some preliminary feedback to hch in the
>> "[PATCH, RFC 2/2] dm: support REQ_FLUSH directly" thread:
>> https://www.redhat.com/archives/dm-devel/2010-August/msg00026.html
>> https://www.redhat.com/archives/dm-devel/2010-August/msg00033.html
> 
> Hmmm... I think both issues don't exist in this incarnation of
> conversion although I'm fairly sure there will be other issues.  :-)

The same issue is still there for request-based dm.  See below.


>>>     A related question: Is dm_wait_for_completion() used in
>>>     process_flush() safe against starvation under continuous influx of
>>>     other commands?
>> As for your specific dm_wait_for_completion() concern -- I'll defer to
>> Mikulas.  But I'll add: we haven't had any reported starvation issues
>> with DM's existing barrier support.  DM uses a mempool for its clones,
>> so it should naturally throttle (without starvation) when memory gets
>> low.
> 
> I see but single pending flush and steady write streams w/o saturating
> the mempool would be able to stall dm_wait_for_completeion(), no?  Eh
> well, it's a separate issue, I guess.

Your understanding is correct, dm_wait_for_completion() for flush
will stall in such cases for request-based dm.
That's why I mentioned below in
https://www.redhat.com/archives/dm-devel/2010-August/msg00026.html.

    In other words, current request-based device-mapper can't handle
    other requests while a flush request is in progress.

In flush request handling, request-based dm uses dm_wait_for_completion()
to wait for the completion of cloned flush requests, depending on
the fact that there should be only flush requests in flight owning
to the block layer sequencing.

It's not a separate issue and we need to resolve it at least.
I'm still considering how I can fix the request-based dm.

Thanks,
Kiyoshi Ueda
