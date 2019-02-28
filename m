From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [PATCH] scsi: smartpqi_init: Reporting 'logical unit failure'
Date: Thu, 28 Feb 2019 20:03:20 +0000
Message-ID: <AT5PR8401MB11696B5DDB2DA774A0E584F4AB750@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
References: <20190227163133.26283-1-e.velu@criteo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190227163133.26283-1-e.velu@criteo.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Erwan Velu <erwanaliasr1@gmail.com>
Cc: Erwan Velu <e.velu@criteo.com>, Don Brace <don.brace@microsemi.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "open list:MICROSEMI SMART ARRAY SMARTPQI DRIVER (smartpqi)" <esc.storagedev@microsemi.com>, "open list:MICROSEMI SMART ARRAY SMARTPQI DRIVER (smartpqi)" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of
> Erwan Velu
> Sent: Wednesday, February 27, 2019 10:32 AM
> Subject: [PATCH] scsi: smartpqi_init: Reporting 'logical unit failure'
> 
> When this HARDWARE_ERROR/0x3e/0x1 case is triggered, the logical volume is offlined.
> When reading the kernel log, the cause why the device got offlined isn't reported to the user.
> This situation makes difficult for admins to estimate _why_ the volume got offlined.
> Reading this part of the code makes clear this is because driver received a HARDWARE_ERROR/0x3e/0x1
> which is a 'logical unit failure'.
> 
> This patch is just about reporting that fact to help admins making a relationship between this event
> and the offlining.
> 
> Signed-off-by: Erwan Velu <e.velu@criteo.com>
> ---
>  drivers/scsi/smartpqi/smartpqi_init.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
> index f564af8949e8..89f37d76735c 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -2764,6 +2764,12 @@ static void pqi_process_raid_io_error(struct pqi_io_request *io_request)
>  				sshdr.sense_key == HARDWARE_ERROR &&
>  				sshdr.asc == 0x3e &&
>  				sshdr.ascq == 0x1) {
> +			struct pqi_ctrl_info *ctrl_info = shost_to_hba(scmd->device->host);
> +			struct pqi_scsi_dev *device = scmd->device->hostdata;
> +
> +			dev_err(&ctrl_info->pci_dev->dev, "received 'logical unit failure' from controller
> for scsi %d:%d:%d:%d\n",
> +							ctrl_info->scsi_host->host_no, device->bus,
> +							device->target, device->lun);
>  			pqi_take_device_offline(scmd->device, "RAID");
>  			host_byte = DID_NO_CONNECT;
>  		}

Be careful printing errors per-IO; you could get thousands of them if things go bad.
The block layer print_req_error() uses printk_ratelimited(KERN_ERR) for that reason,
and the SCSI layer scsi_io_completion_action() maintains a ratelimit on its own.

The dev_err_ratelimited() macro might be a good fit here.


---
Robert Elliott, HPE Persistent Memory
