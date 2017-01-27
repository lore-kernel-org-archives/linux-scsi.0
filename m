From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: split scsi passthrough fields out of struct request
	V3
Date: Fri, 27 Jan 2017 18:58:53 +0000
Message-ID: <1485543514.4267.23.camel@sandisk.com>
References: <1485534918-18239-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1485534918-18239-1-git-send-email-hch@lst.de>
Content-Language: en-US
Content-ID: <789162A303B8CB44ADCB77B713CAEB5D@sandisk.com>
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

On Fri, 2017-01-27 at 17:34 +0100, Christoph Hellwig wrote:
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
> Changes since V2:
>  - remove req->cmd tracing
>  - minor spelling fixes
> 
> Changes since V1:
>  - fix handling of a NULL sense pointer in __scsi_execute
>  - clean up handling of the flush flags in the block layer and MD
>  - additional small cleanup in dm-rq

Hello Christoph,

Version 3 of the patch with title "block: split scsi_request out of
struct request" (commit 3c30af6ebe12) differs significantly from v2
of that patch that has been posted on several mailing lists. E.g. v2
moves __cmd[], cmd and cmd_len from struct request into struct
scsi_request but v3 not. Which version do you want us to review?

Thanks,

Bart.
