From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 5/9] block: Implement support for zoned block devices
Date: Mon, 19 Sep 2016 21:18:52 -0700
Message-ID: <d04b2ad1-f7e2-1296-4967-bd0b772b42bb@sandisk.com>
References: <1474320454-5264-1-git-send-email-damien.lemoal@hgst.com>
 <1474320454-5264-6-git-send-email-damien.lemoal@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0084.outbound.protection.outlook.com ([104.47.33.84]:14462
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751040AbcITETD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Sep 2016 00:19:03 -0400
In-Reply-To: <1474320454-5264-6-git-send-email-damien.lemoal@hgst.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Cc: martin.petersen@oracle.com, axboe@kernel.dk, hare@suse.de, shaun.tancheff@seagate.com

On 09/19/16 14:27, Damien Le Moal wrote:
> +	/*
> +	 * Make sure bi_size does not overflow because
> +	 * of some weird very large zone size.
> +	 */
> +	if (nr_sects && (unsigned long long)nr_sects << 9 > UINT_MAX)
> +		return -EINVAL;
> +
> +	bio = bio_alloc(gfp_mask, 1);
> +	if (!bio)
> +		return -ENOMEM;
> +
> +	bio->bi_iter.bi_sector = sector;
> +	bio->bi_iter.bi_size = nr_sects << 9;
> +	bio->bi_vcnt = 0;
> +	bio->bi_bdev = bdev;
> +	bio_set_op_attrs(bio, op, 0);

Hello Damien and Hannes,

nr_sects is cast to unsigned long long for the overflow test but not 
when assigning bi_size. To me this looks like an inconsistency. Please 
make both expressions consistent.

Thanks,

Bart.
