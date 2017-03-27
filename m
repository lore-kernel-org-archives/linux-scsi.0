From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 2/7] sd: provide a new ata trim provisioning mode
Date: Mon, 27 Mar 2017 22:40:24 +0000
Message-ID: <1490654409.7897.15.camel@sandisk.com>
References: <20170320204319.12628-1-hch@lst.de>
         <20170320204319.12628-3-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:8498 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752502AbdC0WlJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Mar 2017 18:41:09 -0400
In-Reply-To: <20170320204319.12628-3-hch@lst.de>
Content-Language: en-US
Content-ID: <5F69709F6A63CF43B4FE85B383441044@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, "tj@kernel.org" <tj@kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>

On Mon, 2017-03-20 at 16:43 -0400, Christoph Hellwig wrote:
> +	case SD_LBP_ATA_TRIM:
> +		max_blocks =3D 65535 * (512 / sizeof(__le64));
> +		if (sdkp->device->ata_trim_zeroes_data)
> +			q->limits.discard_zeroes_data =3D 1;
> +		break;

Do we need a comment here that explains where the numbers 65535 and
512 come from?

> +	u64 sector =3D blk_rq_pos(rq) >> (ilog2(sdp->sector_size) - 9);
> +	u32 nr_sectors =3D blk_rq_sectors(rq) >> (ilog2(sdp->sector_size) - 9);

Please consider using logical_to_sectors() instead of open-coding this
function.

Thanks,

Bart.=
