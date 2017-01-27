From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: split scsi passthrough fields out of struct request
	V2
Date: Fri, 27 Jan 2017 21:27:53 +0000
Message-ID: <1485552454.4267.29.camel@sandisk.com>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1485365126-23210-1-git-send-email-hch@lst.de>
Content-Language: en-US
Content-ID: <5144945CD29A954580DDD3E65EC16223@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "hch@lst.de" <hch@lst.de>, "axboe@fb.com" <axboe@fb.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "j-nomura@ce.jp.nec.com" <j-nomura@ce.jp.nec.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2017-01-25 at 18:25 +0100, Christoph Hellwig wrote:
> this series splits the support for SCSI passthrough commands from the
> main struct request used all over the block layer into a separate
> scsi_request structure that drivers that want to support SCSI passthough
> need to embedded as the first thing into their request-private data,
> similar to how we handle NVMe passthrough commands.
> 
> To support this I've added support for that the private data after
> request structure to the legacy request path instead, so that it can
> be treated the same way as the blk-mq path.  Compare to the current
> scsi_cmnd allocator that actually is a major simplification.
> 
> Changes since V1:
>  - fix handling of a NULL sense pointer in __scsi_execute
>  - clean up handling of the flush flags in the block layer and MD
>  - additional small cleanup in dm-rq

Hello Christoph,

A general comment: patch "block: allow specifying size for extra
command data" is a very welcome improvement but unfortunately also
introduces an inconsistency among block drivers. This patch series
namely creates two kinds of block drivers:
- Block drivers that use the block layer core to allocate
  request-private data. These block drivers set request.cmd_size
  to a non-zero value and do not need request.special.
- Block drivers that allocate request-private data themselves.
  These block drivers set request.cmd_size to zero and use
  request.special to translate a request pointer into the private
  data pointer.

Have you considered to convert all block drivers to the new
approach and to get rid of request.special? If so, do you already
have plans to start working on this? I'm namely wondering wheter I
should start working on this myself.

Thanks,

Bart.
