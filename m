Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.189
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792481976;
	b=Cf++yTZaaH+KwEfL/bHdDb8/xMwTsOlywwXYsXnqvNB5VcMzoizn3re/qmwQNCrMbK5S
	 1KzhHqWCENUitCgFiUmFbNyEGEU6Qf5urhFO6SomTl8FIxi+1smYZTjPnNsTlqemdERfs
	 xz7b+5+I10s/EjabqrhfbLKte+8+9Yp9f/kcXu4RY3UXmJLs/urdFUZNkuFg7WnxKTDpi
	 bAKkbL6jmuJe81HP9y23N6KXFYu4O3QRjKQrjccE33wy938VuQ2P91p6CM0TR5ha6BazU
	 Y2YQbtKXWFV5UDwRAjGro30XNCju+/CzsNEXX+hqtC/tshnZSiEzcPxAau7UlVfqi3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792481976;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=1zGO+HS6XqWqoMXi7NdxrkJcFUMvHUc+0QyWCt8YQbs=;
	b=DviVfCEeB8nKmKgs/C+k6mSIyLnVX/ZsLaYLwugig7K9kTygnMzJSeh3wT+ma9Ilr5Ee
	 Wm1kvPr48pBYgytYaG7vZtG+IThcqaSuFkfXWEOL6nN2rvnIqb2flFT5dAVbXj50T/1XF
	 Xb1mp6lWWLJQ072gbNa/IUZp7kPvYonFClMATDdKn2gdQieuz0gZ46eS3gItx607lFLol
	 Xzs6i58469zd+RrCh0yoYC975WUG79LyfrX+3WANXu5RCknjEGd+si5aYHvmxQByQq3nr
	 VbaRszxm1KA67jglikaqOfbUs+VFuv01KIuYdQ8Grl1J8Xr08+vUn60bK9RU6X8NDBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=YfgJpw7T;
	arc=none smtp.remote-ip=91.218.175.189
Received: from mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 422E9606A32E
	for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 07:39:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 422E9606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=YfgJpw7T
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=20TkE5EUd8YHt+v29oUMkAh6L5UeQPp7EcPr9ORP67M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792481973; v=1; x=1793086773;
 b=YfgJpw7ThpO+VG30/4JQmJEBXHf5ozauhPylRtwSHkWAI0sKHbmPEWNEnuIqbYdW+DKIEoc3
 jU13r6TAIDVi1RCWd9L/14RFAWVn2p6Oizff1Ac01TaBaePumxhH+KY899TTyLsMamD9k6Ns+6A
 dmJzHeyGUnkCZYTFtGAis2xU=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id 0b179a5dfc27a0f9;
	Tue, 20 Oct 2026 07:39:33 +0000
X-Mizu-Trace-ID: 0b179a5dfc27a0f9
X-Migadu-Flow: FLOW_OUT
Message-ID: <557f3415-ea6c-4fba-844e-6d59f71f2ca0@linux.dev>
Date: Tue, 20 Oct 2026 08:39:31 +0100
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: sd: Mark the disk dead if runtime resume fails in
 sd_remove()
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 Lianqin Hu <hulianqin@vivo.com>, stable@vger.kernel.org
References: <2c0c76d70f0fe197932836b9bcf8496095135d1b.1792446921.git.bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <2c0c76d70f0fe197932836b9bcf8496095135d1b.1792446921.git.bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/19/26 22:55, Bart Van Assche wrote:
> If a SCSI disk is unplugged while runtime suspended, its request queue
> is still in the pm-only state when sd_remove() is called. The runtime
> resume attempted by scsi_autopm_get_device() fails because the parent
> device, e.g. a USB device in the USB_STATE_NOTATTACHED state, cannot be
> resumed. Hence, sdev_runtime_resume() is not called and the pm-only
> state is not cleared. Next, del_gendisk() calls
> blk_report_disk_dead(disk, false), which calls sync_filesystem(). Any
> bio submitted by the filesystem waits forever in __bio_queue_enter()
> because the queue will never leave the pm-only state and because
> GD_DEAD has not yet been set:
> 
>   __bio_queue_enter+0xb8/0x174
>   blk_mq_submit_bio+0x640/0x7e4
>   [ ... ]
>   exfat_sync_fs+0xa4/0xe0
>   sync_filesystem+0xa8/0xdc
>   fs_bdev_mark_dead+0x30/0x88
>   bdev_mark_dead+0x54/0xc4
>   blk_report_disk_dead+0x8c/0xd4
>   del_gendisk+0xa0/0x2f8
>   sd_remove+0x30/0x60
>   [ ... ]
>   scsi_remove_host+0x88/0x18c
>   usb_stor_disconnect+0x68/0xf4
> 
> Fix this hang by calling blk_mark_disk_dead() if runtime resume fails.
> This sets GD_DEAD, tells the filesystem that the disk has been removed
> without attempting to sync it, and wakes up any bios that are waiting
> in __bio_queue_enter(). Syncing the filesystem is not possible anyway
> if runtime resume failed, so no data is lost that could otherwise have
> been written. If runtime resume succeeds, behavior is not changed.
> 
> Please note that this patch converts temporary runtime resume failures
> into permanent failures. Before this patch, if runtime resume fails
> temporarily, a filesytem sync would be postponed until a later resume
> succeeds.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Tested-by: Lianqin Hu <hulianqin@vivo.com>
> Reported-by: Lianqin Hu <hulianqin@vivo.com>
> Closes: https://lore.kernel.org/all/TYUPR06MB6217DD31B1B3CD09E431CC12D2922@TYUPR06MB6217.apcprd06.prod.outlook.com/
> Fixes: 6f8191fdf41d ("block: simplify disk shutdown")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

FWIW:

Reviewed-by: John Garry <john.garry@linux.dev>


> ---
>   drivers/scsi/sd.c | 10 +++++++++-
>   1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index b0d2542fd317..dc45df819c42 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -4268,7 +4268,15 @@ static void sd_remove(struct scsi_device *sdp)
>   	struct device *dev = &sdp->sdev_gendev;
>   	struct scsi_disk *sdkp = dev_get_drvdata(dev);
>   
> -	scsi_autopm_get_device(sdkp->device);
> +	/*
> +	 * If runtime resume fails, e.g. because the device was unplugged
> +	 * while runtime suspended, the request queue stays in the pm-only
> +	 * state and any I/O submitted by del_gendisk(), e.g. from
> +	 * sync_filesystem(), would wait forever in __bio_queue_enter().
> +	 * Prevent this by marking the disk dead.
> +	 */
> +	if (scsi_autopm_get_device(sdkp->device) < 0)

Does this scsi_autopm_get_device() match with a "put", or does it even 
matter since the device is going away?

> +		blk_mark_disk_dead(sdkp->disk);
>   
>   	device_del(&sdkp->disk_dev);
>   	del_gendisk(sdkp->disk);

