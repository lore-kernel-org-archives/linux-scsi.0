From: walter harms <wharms@bfs.de>
Subject: Re: [PATCH] scsi_dh_emc: fix uninitialized return value ret
Date: Tue, 31 Jan 2017 13:34:52 +0100
Message-ID: <5890846C.50406@bfs.de>
References: <20170131122205.24482-1-colin.king@canonical.com>
Reply-To: wharms@bfs.de
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170131122205.24482-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@fb.com>, Hannes Reinecke <hare@suse.de>, Shaun Tancheff <shaun.tancheff@seagate.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



Am 31.01.2017 13:22, schrieb Colin King:
> From: Colin Ian King <colin.king@canonical.com>
> 
> ret is uninitialized on a successful execution of clarrion_std_inquiry
> and a garbage return value is being returted.  Fix this by setting ret
> to zero on the success exit path.
> 
> Found by CoverityScan, CID#1398889 ("Uninitialized scaler variable")
> 
> Fixes: b78205c93297b8219 ("scsi_dh_emc: switch to scsi_execute_req_flags()")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/scsi/device_handler/scsi_dh_emc.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
> index 4a7679f..6647da2 100644
> --- a/drivers/scsi/device_handler/scsi_dh_emc.c
> +++ b/drivers/scsi/device_handler/scsi_dh_emc.c
> @@ -376,6 +376,7 @@ static int clariion_std_inquiry(struct scsi_device *sdev,
>  	sdev_printk(KERN_INFO, sdev,
>  		    "%s: detected Clariion %s, flags %x\n",
>  		    CLARIION_NAME, sp_model, csdev->flags);
> +	err = 0;
>  out:
>  	return err;
>  }



I am not sure IMHO err is set in the first line  err = send_inquiry_cmd(sdev, 0, csdev);

but this looks strange:
  if (!strlen(sp_model) || !strncmp(sp_model, "FC",2))
IMHO we can drop strlen() and the compare should be agaist:
 #define emc_default_str "FC (Legacy)"

just my 2 cents,

re,
 wh
