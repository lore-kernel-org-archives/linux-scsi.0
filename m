From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 1/2] block: Zoned block device single-threaded submission
Date: Fri, 4 Aug 2017 15:54:51 +0000
Message-ID: <1501862088.2757.11.camel@wdc.com>
References: <20170804075237.2089-1-damien.lemoal@wdc.com>
         <20170804075237.2089-2-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:14097 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752389AbdHDPzk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Aug 2017 11:55:40 -0400
In-Reply-To: <20170804075237.2089-2-damien.lemoal@wdc.com>
Content-Language: en-US
Content-ID: <891700E92CB9B840ADF550539C7B17E2@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "hch@lst.de" <hch@lst.de>, "hare@suse.de" <hare@suse.de>

On Fri, 2017-08-04 at 16:52 +0900, Damien Le Moal wrote:
> From: Hannes Reinecke <hare@suse.de>
>=20
> The scsi_request_fn() dispatch function internally unlocks the request
> queue before submitting a request to the underlying LLD. This can
> potentially lead to write request reordering if the context executing
> scsi_request_fn() is preempted before the request is submitted to the
> LLD and another context start the same function execution.
>=20
> This is not a problem for regular disks but leads to write I/O errors
> on host managed zoned block devices and reduce the effectivness of
> sequential write optimizations for host aware disks.
> (Note: the zone write lock in place in the scsi command init code will
> prevent multiple writes from being issued simultaneously to the same
> zone to avoid HBA level reordering issues, but this locking mechanism
> is ineffective to prevent reordering at the dispatch level)
>=20
> Prevent this from happening by limiting the number of context that can
> simultaneously execute the queue request_fn() function to a single
> thread.
>=20
> A similar patch was originally proposed by Hannes Reinecke in a first
> set of patches implementing ZBC support but ultimately not included in
> the final support implementation. See commit 92f5e2a295
> "block: add flag for single-threaded submission" in the tree
> https://git.kernel.org/pub/scm/linux/kernel/git/hare/scsi-devel.git/log/?=
h=3Dzac.v3
>=20
> Authorship thus goes to Hannes.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>  block/blk-core.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>=20
> diff --git a/block/blk-core.c b/block/blk-core.c
> index dbecbf4a64e0..cf590cbddcfd 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -371,7 +371,14 @@ inline void __blk_run_queue_uncond(struct request_qu=
eue *q)
>  	 * running such a request function concurrently. Keep track of the
>  	 * number of active request_fn invocations such that blk_drain_queue()
>  	 * can wait until all these request_fn calls have finished.
> +	 *
> +	 * For zoned block devices, do not allow multiple threads to
> +	 * dequeue requests as this can lead to write request reordering
> +	 * during the time the queue is unlocked.
>  	 */
> +	if (blk_queue_is_zoned(q) && q->request_fn_active)
> +		return;
> +
>  	q->request_fn_active++;
>  	q->request_fn(q);
>  	q->request_fn_active--;

Hello Damien,

Since serialization of request queue processing is only needed for ZBC and
since all ZBC devices use the SCSI core, could this serialization have been
achieved by modifying the SCSI core, e.g. by adding the following before th=
e
for-loop in scsi_request_fn():

        if (blk_queue_is_zoned(q) && q->request_fn_active > 1)
                return;

Thanks,

Bart.=
