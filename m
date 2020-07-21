Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBABEC433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 15:14:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BE1A206E3
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 15:14:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729946AbgGUPOl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 11:14:41 -0400
Received: from verein.lst.de ([213.95.11.211]:52627 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728089AbgGUPOk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Jul 2020 11:14:40 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9AD7268B05; Tue, 21 Jul 2020 17:14:37 +0200 (CEST)
Date:   Tue, 21 Jul 2020 17:14:37 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        "open list:BLOCK LAYER" <linux-block@vger.kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@kernel.dk>,
        "open list:NVM EXPRESS DRIVER" <linux-nvme@lists.infradead.org>,
        "open list:SCSI CDROM DRIVER" <linux-scsi@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Jason Wang <jasowang@redhat.com>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Ajay Joshi <ajay.joshi@wdc.com>,
        Ming Lei <ming.lei@redhat.com>,
        "open list:SONY MEMORYSTICK SUBSYSTEM" <linux-mmc@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Satya Tangirala <satyat@google.com>,
        "open list:NETWORK BLOCK DEVICE (NBD)" <nbd@other.debian.org>,
        Hou Tao <houtao1@huawei.com>, Jens Axboe <axboe@fb.com>,
        "open list:VIRTIO CORE AND NET DRIVERS" 
        <virtualization@lists.linux-foundation.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 02/10] block: virtio-blk: check logical block size
Message-ID: <20200721151437.GB10620@lst.de>
References: <20200721105239.8270-1-mlevitsk@redhat.com> <20200721105239.8270-3-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721105239.8270-3-mlevitsk@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jul 21, 2020 at 01:52:31PM +0300, Maxim Levitsky wrote:
> Linux kernel only supports logical block sizes which are power of two,
> at least 512 bytes and no more that PAGE_SIZE.
> 
> Check this instead of crashing later on.
> 
> Note that there is no need to check physical block size since it is
> only a hint, and virtio-blk already only supports power of two values.
> 
> Bugzilla link: https://bugzilla.redhat.com/show_bug.cgi?id=1664619
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  drivers/block/virtio_blk.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index 980df853ee497..b5ee87cba00ed 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -809,10 +809,18 @@ static int virtblk_probe(struct virtio_device *vdev)
>  	err = virtio_cread_feature(vdev, VIRTIO_BLK_F_BLK_SIZE,
>  				   struct virtio_blk_config, blk_size,
>  				   &blk_size);
> -	if (!err)
> +	if (!err) {
> +		if (!blk_is_valid_logical_block_size(blk_size)) {
> +			dev_err(&vdev->dev,
> +				"%s failure: invalid logical block size %d\n",
> +				__func__, blk_size);
> +			err = -EINVAL;
> +			goto out_cleanup_queue;
> +		}
>  		blk_queue_logical_block_size(q, blk_size);

Hmm, I wonder if we should simply add the check and warning to
blk_queue_logical_block_size and add an error in that case.  Then
drivers only have to check the error return, which might add a lot
less boiler plate code.
