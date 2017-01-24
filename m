From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 05/16] dm: always defer request allocation to
 the owner of the request_queue
Date: Tue, 24 Jan 2017 09:29:22 +0100
Message-ID: <b8b5b5ad-f782-2a2e-9a7e-cef8e4b5806b@suse.de>
References: <1485185361-29786-1-git-send-email-hch@lst.de>
	<1485185361-29786-6-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1485185361-29786-6-git-send-email-hch@lst.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@fb.com>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 01/23/2017 04:29 PM, Christoph Hellwig wrote:
> DM already calls blk_mq_alloc_request on the request_queue of the
> underlying device if it is a blk-mq device.  But now that we allow drivers
> to allocate additional data and initialize it ahead of time we need to do
> the same for all drivers.   Doing so and using the new cmd_size
> infrastructure in the block layer greatly simplifies the dm-rq and mpath
> code, and should also make arbitrary combinations of SQ and MQ devices
> with SQ or MQ device mapper tables easily possible as a further step.
> =

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/md/dm-core.h          |   1 -
>  drivers/md/dm-mpath.c         | 132 ++++------------------
>  drivers/md/dm-rq.c            | 251 ++++++++++--------------------------=
------
>  drivers/md/dm-rq.h            |   2 +-
>  drivers/md/dm-target.c        |   7 --
>  drivers/md/dm.c               |  18 +--
>  drivers/md/dm.h               |   3 +-
>  include/linux/device-mapper.h |   3 -
>  8 files changed, 81 insertions(+), 336 deletions(-)
> =

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
