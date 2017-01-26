From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH 05/16] dm: always defer request allocation to
 the owner of the request_queue
Date: Thu, 26 Jan 2017 04:23:00 +0000
Message-ID: <6b3a7fb3-f8f6-4605-b153-e193b3d2b500@ce.jp.nec.com>
References: <1485185361-29786-1-git-send-email-hch@lst.de>
	<1485185361-29786-6-git-send-email-hch@lst.de>
	<20170124100538.GA6991@redhat.com> <20170124142054.GA26473@lst.de>
	<20170124163951.GA9172@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170124163951.GA9172@redhat.com>
Content-Language: ja-JP
Content-ID: <53783E249627D549AB718B4BE5579FAB@gisp.nec.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@fb.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 01/25/17 01:39, Mike Snitzer wrote:
> On Tue, Jan 24 2017 at  9:20am -0500, Christoph Hellwig <hch@lst.de> wrote:
>> On Tue, Jan 24, 2017 at 05:05:39AM -0500, Mike Snitzer wrote:
>>> possible and is welcomed cleanup.  The only concern I have is that using
>>> get_request() for the old request_fn request_queue eliminates the
>>> guaranteed availability of requests to allow for forward progress (on
>>> path failure or for the purposes of swap over mpath, etc).  This isn't a
>>> concern for blk-mq because as you know we have a fixed set of tags (and
>>> associated preallocated requests).
>>>
>>> So I'm left unconvinced old request_fn request-based DM multipath isn't
>>> regressing in how request resubmission can be assured a request will be
>>> available when needed on retry in the face of path failure.
>>
>> Mempool only need a size where we can make guaranteed requests, so for
>> get_request based drivers under dm the theoretical minimum size would be
>> one as we never rely on a second request to finish the first one,
>> and each request_queue has it's own mempool(s) to start with.
> 
> Fair enough.  Cc'ing Junichi just in case he sees anything we're
> missing.

DM multipath could not use blk_get_request() because the function
was not callable from interrupt-disabled context. E.g. request_fn.

However, since the current code no longer calls blk_get_request()
from such a context, the change should be ok.

-- 
Jun'ichi Nomura, NEC Corporation / NEC Solution Innovators, Ltd.
