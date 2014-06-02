From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v2 6/6] scsi_debug: allow huge transfer length for read/write
 commands
Date: Mon, 02 Jun 2014 13:06:13 -0400
Message-ID: <538CAF05.6080505@interlog.com>
References: <1401717409-5236-1-git-send-email-akinobu.mita@gmail.com> <1401717409-5236-7-git-send-email-akinobu.mita@gmail.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:58958 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbaFBRGS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Jun 2014 13:06:18 -0400
In-Reply-To: <1401717409-5236-7-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>, linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <JBottomley@parallels.com>

On 14-06-02 09:56 AM, Akinobu Mita wrote:
> This change enables to test read/write commands with huge transfer
> length such as 1GB.  For example:
>
> 	# modprobe scsi_debug dev_size_mb=1024 clustering=1 opts=1
> 	# cat /sys/block/$DEV/queue/max_hw_sectors_kb > \
> 		/sys/block/$DEV/queue/max_sectors_kb
> 	# fio --name=test --rw=write --bs=1g --size=1g --filename=/dev/$DEV \
> 		--mem=mmaphuge  --direct=1
>
> The data type of max_sectors in scsi_host_template has been extended
> to unsigned int by the previous change.  So we can increase it from
> 0xffff to 0xffffffff to allow such huge transfer length.
>
> Also, this increases sg_tablesize and max_segment_size, otherwise the
> maximum transfer length is limited to 64MB.
> (sg_tablesize * max_segment_size = 256 * 256KB)
>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: Douglas Gilbert <dgilbert@interlog.com>
> Cc: linux-scsi@vger.kernel.org

Acked by: Douglas Gilbert <dgilbert@interlog.com>

