From: Jeff Garzik <jeff@garzik.org>
Subject: Re: block/bsg.c
Date: Tue, 17 Jul 2007 19:37:53 -0400
Message-ID: <469D52D1.1000803@garzik.org>
References: <20070716165706.348f6bbf.akpm@linux-foundation.org>	 <20070717063810.GY5195@kernel.dk>	 <20070717121821.3212cd60.akpm@linux-foundation.org>	 <20070717132233.ed11362c.akpm@linux-foundation.org> <1184710755.3378.30.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S936432AbXGQXiL@vger.kernel.org>
In-Reply-To: <1184710755.3378.30.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> @@ -1052,9 +1054,10 @@ int generic_ide_ioctl(ide_drive_t *drive, struct file *file, struct block_device
>  	int err, (*setfunc)(ide_drive_t *, int);
>  	u8 *val;
>  
> -	err = scsi_cmd_ioctl(file, bdev->bd_disk->queue, bdev->bd_disk, cmd, p);
> -	if (err != -ENOTTY)
> -		return err;
> +	switch (cmd) {
> +	case SG_IO:
> +		return scsi_cmd_ioctl(file, bdev->bd_disk->queue, bdev->bd_disk, cmd, p);
> +	}
>  
>  	switch (cmd) {
>  	case HDIO_GET_32BIT:	    val = &drive->io_32bit;	 goto read_val;


At that point you might as well use an 'if'.

But overall -- agreed.  ACK.

	Jeff
