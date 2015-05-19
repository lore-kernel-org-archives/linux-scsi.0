From: Don Brace <Don.Brace@pmcs.com>
Subject: RE: [PATCH] hpsa: dont meddle with hw which isn't ours (cciss)
Date: Tue, 19 May 2015 19:00:37 +0000
Message-ID: <07F70BBF6832E34FA1C923241E8833AB486AA2AD@BBYEXM01.pmc-sierra.internal>
References: <1427981154-27659-1-git-send-email-thenzl@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:55122 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752143AbbESTAj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 May 2015 15:00:39 -0400
In-Reply-To: <1427981154-27659-1-git-send-email-thenzl@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Scott Teel <Scott.Teel@pmcs.com>, Justin Lindley <Justin.Lindley@pmcs.com>, Kevin Barnett <Kevin.Barnett@pmcs.com>



> -----Original Message-----
> From: Tomas Henzl [mailto:thenzl@redhat.com]
> Sent: Thursday, April 02, 2015 8:26 AM
> To: linux-scsi@vger.kernel.org
> Cc: Don Brace; Scott Teel; Justin Lindley; Kevin Barnett
> Subject: [PATCH] hpsa: dont meddle with hw which isn't ours (cciss)
> 
> The hpsa driver touches the hardware before checking the pci-id table.
> This way, especially in kdump, it may confuse the proper driver (cciss).
> 
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> ---
>  drivers/scsi/hpsa.c | 21 +++++++++++----------
>  1 file changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index bddb33d30f..c33a077636 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -6737,7 +6737,7 @@ static int controller_reset_failed(struct CfgTable
> __iomem *cfgtable)
>  /* This does a hard reset of the controller using PCI power management
>   * states or the using the doorbell register.
>   */
> -static int hpsa_kdump_hard_reset_controller(struct pci_dev *pdev)
> +static int hpsa_kdump_hard_reset_controller(struct pci_dev *pdev, u32
> board_id)
>  {
>  	u64 cfg_offset;
>  	u32 cfg_base_addr;
> @@ -6748,7 +6748,6 @@ static int hpsa_kdump_hard_reset_controller(struct
> pci_dev *pdev)
>  	int rc;
>  	struct CfgTable __iomem *cfgtable;
>  	u32 use_doorbell;
> -	u32 board_id;
>  	u16 command_register;
> 
>  	/* For controllers as old as the P600, this is very nearly
> @@ -6764,11 +6763,6 @@ static int hpsa_kdump_hard_reset_controller(struct
> pci_dev *pdev)
>  	 * using the doorbell register.
>  	 */
> 
> -	rc = hpsa_lookup_board_id(pdev, &board_id);
> -	if (rc < 0) {
> -		dev_warn(&pdev->dev, "Board ID not found\n");
> -		return rc;
> -	}
>  	if (!ctlr_is_resettable(board_id)) {
>  		dev_warn(&pdev->dev, "Controller not resettable\n");
>  		return -ENODEV;
> @@ -7413,7 +7407,7 @@ static void hpsa_hba_inquiry(struct ctlr_info *h)
>  	}
>  }
> 
> -static int hpsa_init_reset_devices(struct pci_dev *pdev)
> +static int hpsa_init_reset_devices(struct pci_dev *pdev, u32 board_id)
>  {
>  	int rc, i;
>  	void __iomem *vaddr;
> @@ -7449,7 +7443,7 @@ static int hpsa_init_reset_devices(struct pci_dev
> *pdev)
>  	iounmap(vaddr);
> 
>  	/* Reset the controller with a PCI power-cycle or via doorbell */
> -	rc = hpsa_kdump_hard_reset_controller(pdev);
> +	rc = hpsa_kdump_hard_reset_controller(pdev, board_id);
> 
>  	/* -ENOTSUPP here means we cannot reset the controller
>  	 * but it's already (and still) up and running in
> @@ -7927,11 +7921,18 @@ static int hpsa_init_one(struct pci_dev *pdev, const
> struct pci_device_id *ent)
>  	struct ctlr_info *h;
>  	int try_soft_reset = 0;
>  	unsigned long flags;
> +	u32 board_id;
> 
>  	if (number_of_controllers == 0)
>  		printk(KERN_INFO DRIVER_NAME "\n");
> 
> -	rc = hpsa_init_reset_devices(pdev);
> +	rc = hpsa_lookup_board_id(pdev, &board_id);
> +	if (rc < 0) {
> +		dev_warn(&pdev->dev, "Board ID not found\n");
> +		return rc;
> +	}
> +
> +	rc = hpsa_init_reset_devices(pdev, board_id);
>  	if (rc) {
>  		if (rc != -ENOTSUPP)
>  			return rc;
> --
> 1.9.3

Signed-off-by: Don Brace <don.brace@pmcs.com>
