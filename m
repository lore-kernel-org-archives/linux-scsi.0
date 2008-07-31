From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: RE: [PATCH] cciss: return -EFAULT if copy_from_user() fails
Date: Thu, 31 Jul 2008 14:12:08 +0000
Message-ID: <0F5B06BAB751E047AB5C87D1F77A778826B3E814F0@GVW0547EXC.americas.hpqcorp.net>
References: <200807311135.48889.knikanth@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0014.houston.hp.com ([15.201.24.17]:25178 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbYGaONJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jul 2008 10:13:09 -0400
In-Reply-To: <200807311135.48889.knikanth@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nikanth Karthikesan <knikanth@suse.de>, LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>
Cc: ISS StorageDev <iss_storagedev@hp.com>, Jens Axboe <jens.axboe@oracle.com>



> -----Original Message-----
> From: Nikanth Karthikesan [mailto:knikanth@suse.de]
> Sent: Thursday, July 31, 2008 1:06 AM
> To: Miller, Mike (OS Dev)
> Cc: ISS StorageDev; Jens Axboe
> Subject: [PATCH] cciss: return -EFAULT if copy_from_user() fails
>
> Return -EFAULT instead of -ENOMEM if copy_from_user() fails.
>
> Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

Acked-by: Mike Miller <mike.miller@hp.com>

>
> ---
>  drivers/block/cciss.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: b/drivers/block/cciss.c
> ===================================================================
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -1134,7 +1134,7 @@ static int cciss_ioctl(struct inode *ino
>                                 if
> (ioc->Request.Type.Direction == XFER_WRITE) {
>                                         if (copy_from_user
>                                             (buff[sg_used],
> data_ptr, sz)) {
> -                                               status = -ENOMEM;
> +                                               status = -EFAULT;
>                                                 goto cleanup1;
>                                         }
>                                 } else {
>
