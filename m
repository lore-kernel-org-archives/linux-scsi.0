From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH] sd: Unregister integrity profile
Date: Wed, 15 Apr 2015 12:22:17 +0300
Message-ID: <552E2DC9.9020200@dev.mellanox.co.il>
References: <552D45B5.1040801@dev.mellanox.co.il> <1429044983-3584-1-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:38849 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668AbbDOJWV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Apr 2015 05:22:21 -0400
Received: by wiun10 with SMTP id n10so52381146wiu.1
        for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2015 02:22:20 -0700 (PDT)
In-Reply-To: <1429044983-3584-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: stable@vger.kernel.org.#.v3.17+

On 4/14/2015 11:56 PM, Martin K. Petersen wrote:
> The new integrity code did not correctly unregister the profile for SD
> disks. Call blk_integrity_unregister() when we release a disk.
>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Reported-by: Sagi Grimberg <sagig@dev.mellanox.co.il>
> CC: stable@vger.kernel.org # v3.17+

Has it been there this long? I wander how we didn't step on
this sooner...

> ---
>   drivers/scsi/sd.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 6b78476d04bb..3290a3ed5b31 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3100,6 +3100,7 @@ static void scsi_disk_release(struct device *dev)
>   	ida_remove(&sd_index_ida, sdkp->index);
>   	spin_unlock(&sd_index_lock);
>
> +	blk_integrity_unregister(disk);
>   	disk->private_data = NULL;
>   	put_disk(disk);
>   	put_device(&sdkp->device->sdev_gendev);
>

Always nice to post a trace, go home, and find the fix in
the next morning...

Thanks Martin!

Tested-by: Sagi Grimberg <sagig@mellanox.com>
