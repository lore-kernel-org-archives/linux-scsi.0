From: "Mark Harvey" <mark_harvey@symantec.com>
Subject: RE: [PATCH 02/10] scsi: fix integer as NULL pointer warnings
Date: Thu, 1 May 2008 14:50:48 -0700
Message-ID: <B3E98EAC5926D5498DDD341AE4B7D21C03BCBACA@TUS1XCHCLUPIN06.enterprise.veritas.com>
References: <1209593020.24729.112.camel@brick> <1209594551.3774.37.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:38111 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbYEAVv5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 May 2008 17:51:57 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1209594551.3774.37.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of James Bottomley
Sent: Thursday, May 01, 2008 8:29 AM
To: Harvey Harrison
Cc: Andrew Morton; LKML; linux-scsi
Subject: Re: [PATCH 02/10] scsi: fix integer as NULL pointer warnings

On Wed, 2008-04-30 at 15:03 -0700, Harvey Harrison wrote:
> drivers/scsi/FlashPoint.c:906:9: warning: Using plain integer as NULL
pointer
> drivers/scsi/FlashPoint.c:907:53: warning: Using plain integer as NULL
pointer
> drivers/scsi/FlashPoint.c:922:1: warning: Using plain integer as NULL
pointer
> drivers/scsi/aha152x.c:3585:60: warning: Using plain integer as NULL
pointer
> drivers/scsi/aha152x.c:3845:56: warning: Using plain integer as NULL
pointer
> drivers/scsi/qla1280.c:2814:37: warning: Using plain integer as NULL
pointer
> drivers/scsi/atp870u.c:750:47: warning: Using plain integer as NULL
pointer
> drivers/scsi/3w-9xxx.c:1281:36: warning: Using plain integer as NULL
pointer
> drivers/scsi/3w-9xxx.c:1293:36: warning: Using plain integer as NULL
pointer
> drivers/scsi/3w-9xxx.c:1301:35: warning: Using plain integer as NULL
pointer
> drivers/scsi/hptiop.c:447:10: warning: Using plain integer as NULL
pointer
> drivers/scsi/hptiop.c:457:10: warning: Using plain integer as NULL
pointer
> drivers/scsi/hptiop.c:479:24: warning: Using plain integer as NULL
pointer
> drivers/scsi/hptiop.c:483:22: warning: Using plain integer as NULL
pointer
> drivers/scsi/hptiop.c:1213:23: warning: Using plain integer as NULL
pointer
> drivers/scsi/hptiop.c:1214:23: warning: Using plain integer as NULL
pointer
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> James, please look at the FlashPoint.c changes in particular.

Could you please Cc linux-scsi?  That way interested parties get to
check their drivers.

The flashpoint initialiser changes look wrong:  {0} is a conventional
notation for zero initialise this structure.  Sparse should probably be
taught to recognise that.

James


>  drivers/scsi/3w-9xxx.c    |    6 +++---
>  drivers/scsi/FlashPoint.c |    7 +++----
>  drivers/scsi/aha152x.c    |    4 ++--
>  drivers/scsi/atp870u.c    |    2 +-
>  drivers/scsi/hptiop.c     |   12 ++++++------
>  drivers/scsi/qla1280.c    |    2 +-
>  6 files changed, 16 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
> index b31faec..626d6e1 100644
> --- a/drivers/scsi/3w-9xxx.c
> +++ b/drivers/scsi/3w-9xxx.c
> @@ -1278,7 +1278,7 @@ static irqreturn_t twa_interrupt(int irq, void
*dev_instance)
>  			error = 0;
>  			/* Check for command packet errors */
>  			if
(full_command_packet->command.newcommand.status != 0) {
> -				if (tw_dev->srb[request_id] != 0) {
> +				if (tw_dev->srb[request_id]) {
>  					error = twa_fill_sense(tw_dev,
request_id, 1, 1);
>  				} else {
>  					/* Skip ioctl error prints */
> @@ -1290,7 +1290,7 @@ static irqreturn_t twa_interrupt(int irq, void
*dev_instance)
>  
>  			/* Check for correct state */
>  			if (tw_dev->state[request_id] != TW_S_POSTED) {
> -				if (tw_dev->srb[request_id] != 0) {
> +				if (tw_dev->srb[request_id]) {
>  					TW_PRINTK(tw_dev->host,
TW_DRIVER, 0x1a, "Received a request id that wasn't posted");
>  					TW_CLEAR_ALL_INTERRUPTS(tw_dev);
>  					goto twa_interrupt_bail;
> @@ -1298,7 +1298,7 @@ static irqreturn_t twa_interrupt(int irq, void
*dev_instance)
>  			}
>  
>  			/* Check for internal command completion */
> -			if (tw_dev->srb[request_id] == 0) {
> +			if (tw_dev->srb[request_id]) {

Swapped the test from zero to non-zero ?

>  				if (request_id !=
tw_dev->chrdev_request_id) {
>  					if (twa_aen_complete(tw_dev,
request_id))
>  						TW_PRINTK(tw_dev->host,
TW_DRIVER, 0x1b, "Error completing AEN during attention interrupt");
> diff --git a/drivers/scsi/FlashPoint.c b/drivers/scsi/FlashPoint.c
> index b898d38..b252ac5 100644
> --- a/drivers/scsi/FlashPoint.c
> +++ b/drivers/scsi/FlashPoint.c
> @@ -903,8 +903,8 @@ static void FPT_autoCmdCmplt(unsigned long p_port,
unsigned char p_card);
>  static void FPT_autoLoadDefaultMap(unsigned long p_port);
>  
>  static struct sccb_mgr_tar_info
FPT_sccbMgrTbl[MAX_CARDS][MAX_SCSI_TAR] =
> -    { {{0}} };
> -static struct sccb_card FPT_BL_Card[MAX_CARDS] = { {0} };
> +    { {{NULL}} };
> +static struct sccb_card FPT_BL_Card[MAX_CARDS] = { {NULL} };
>  static SCCBSCAM_INFO FPT_scamInfo[MAX_SCSI_TAR] = { {{0}} };
>  static struct nvram_info FPT_nvRamInfo[MAX_MB_CARDS] = { {0} };
>  
> @@ -918,8 +918,7 @@ static unsigned char FPT_scamHAString[] =
>  
>  static unsigned short FPT_default_intena = 0;
>  
> -static void (*FPT_s_PhaseTbl[8]) (unsigned long, unsigned char) = {
> -0};
> +static void (*FPT_s_PhaseTbl[8]) (unsigned long, unsigned char) =
{NULL};
>  
>
/*---------------------------------------------------------------------
>   *
> diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
> index f5215fd..0c93a49 100644
> --- a/drivers/scsi/aha152x.c
> +++ b/drivers/scsi/aha152x.c
> @@ -3582,7 +3582,7 @@ static int checksetup(struct aha152x_setup
*setup)
>  	if (i == ARRAY_SIZE(ports))
>  		return 0;
>  
> -	if ( request_region(setup->io_port, IO_RANGE, "aha152x")==0 ) {
> +	if (!request_region(setup->io_port, IO_RANGE, "aha152x")) {
>  		printk(KERN_ERR "aha152x: io port 0x%x busy.\n",
setup->io_port);
>  		return 0;
>  	}
> @@ -3842,7 +3842,7 @@ static int __init aha152x_init(void)
>  			if ((setup_count == 1) && (setup[0].io_port ==
ports[i]))
>  				continue;
>  
> -			if ( request_region(ports[i], IO_RANGE,
"aha152x")==0 ) {
> +			if (!request_region(ports[i], IO_RANGE,
"aha152x")) {
>  				printk(KERN_ERR "aha152x: io port 0x%x
busy.\n", ports[i]);
>  				continue;
>  			}
> diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
> index db6de5e..571b43b 100644
> --- a/drivers/scsi/atp870u.c
> +++ b/drivers/scsi/atp870u.c
> @@ -747,7 +747,7 @@ static void send_s870(struct atp_unit
*dev,unsigned char c)
>  		dev->quhd[c] = 0;
>  	}
>  	workreq = dev->quereq[c][dev->quhd[c]];
> -	if (dev->id[c][scmd_id(workreq)].curr_req == 0) {	
> +	if (!dev->id[c][scmd_id(workreq)].curr_req) {	
>  		dev->id[c][scmd_id(workreq)].curr_req = workreq;
>  		dev->last_cmd[c] = scmd_id(workreq);
>  		goto cmd_subp;
> diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
> index 5b7be1e..bc5fb5c 100644
> --- a/drivers/scsi/hptiop.c
> +++ b/drivers/scsi/hptiop.c
> @@ -444,7 +444,7 @@ static void __iomem *hptiop_map_pci_bar(struct
hptiop_hba *hba, int index)
>  	if (!(pci_resource_flags(pcidev, index) & IORESOURCE_MEM)) {
>  		printk(KERN_ERR "scsi%d: pci resource invalid\n",
>  				hba->host->host_no);
> -		return 0;
> +		return NULL;
>  	}
>  
>  	mem_base_phy = pci_resource_start(pcidev, index);
> @@ -454,7 +454,7 @@ static void __iomem *hptiop_map_pci_bar(struct
hptiop_hba *hba, int index)
>  	if (!mem_base_virt) {
>  		printk(KERN_ERR "scsi%d: Fail to ioremap memory
space\n",
>  				hba->host->host_no);
> -		return 0;
> +		return NULL;
>  	}
>  	return mem_base_virt;
>  }
> @@ -476,11 +476,11 @@ static void hptiop_unmap_pci_bar_itl(struct
hptiop_hba *hba)
>  static int hptiop_map_pci_bar_mv(struct hptiop_hba *hba)
>  {
>  	hba->u.mv.regs = hptiop_map_pci_bar(hba, 0);
> -	if (hba->u.mv.regs == 0)
> +	if (!hba->u.mv.regs)
>  		return -1;
>  
>  	hba->u.mv.mu = hptiop_map_pci_bar(hba, 2);
> -	if (hba->u.mv.mu == 0) {
> +	if (!hba->u.mv.mu) {
>  		iounmap(hba->u.mv.regs);
>  		return -1;
>  	}
> @@ -1210,8 +1210,8 @@ static void hptiop_remove(struct pci_dev
*pcidev)
>  
>  static struct hptiop_adapter_ops hptiop_itl_ops = {
>  	.iop_wait_ready    = iop_wait_ready_itl,
> -	.internal_memalloc = 0,
> -	.internal_memfree  = 0,
> +	.internal_memalloc = NULL,
> +	.internal_memfree  = NULL,
>  	.map_pci_bar       = hptiop_map_pci_bar_itl,
>  	.unmap_pci_bar     = hptiop_unmap_pci_bar_itl,
>  	.enable_intr       = hptiop_enable_intr_itl,
> diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
> index 09ab3ea..d2bc60a 100644
> --- a/drivers/scsi/qla1280.c
> +++ b/drivers/scsi/qla1280.c
> @@ -2811,7 +2811,7 @@ qla1280_64bit_start_scsi(struct scsi_qla_host
*ha, struct srb * sp)
>  
>  	/* Check for room in outstanding command list. */
>  	for (cnt = 0; cnt < MAX_OUTSTANDING_COMMANDS &&
> -		     ha->outstanding_cmds[cnt] != 0; cnt++);
> +		     ha->outstanding_cmds[cnt] != NULL; cnt++);
>  
>  	if (cnt >= MAX_OUTSTANDING_COMMANDS) {
>  		status = 1;

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
