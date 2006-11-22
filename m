From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH 5/5] lpfc : Make Emulex lpfc driver legacy
	I/O port free
Date: Wed, 22 Nov 2006 10:44:46 -0500
Message-ID: <4564706E.9060900@emulex.com>
References: <4564051C.3080908@jp.fujitsu.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <e1000-devel-bounces@lists.sourceforge.net>
In-Reply-To: <4564051C.3080908@jp.fujitsu.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/e1000-devel>,
	<mailto:e1000-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=e1000-devel>
List-Post: <mailto:e1000-devel@lists.sourceforge.net>
List-Help: <mailto:e1000-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/e1000-devel>,
	<mailto:e1000-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: e1000-devel-bounces@lists.sourceforge.net
Errors-To: e1000-devel-bounces@lists.sourceforge.net
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andrew Morton <akpm@osdl.org>, Grant Grundler <grundler@parisc-linux.org>, linux-scsi@vger.kernel.org, e1000-devel@lists.sourceforge.net, Greg KH <greg@kroah.com>, Linux Kernel list <linux-kernel@vger.kernel.org>, Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>, linux-pci@atrey.karlin.mff.cuni.cz
List-Id: linux-scsi@vger.kernel.org

ACK  :)

(I thought this had already gone in a while ago)

-- james s

Hidetoshi Seto wrote:
> This patch makes Emulex lpfc driver legacy I/O port free.
> 
> Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> 
> ---
>  drivers/scsi/lpfc/lpfc_init.c |   10 ++++++----
>  1 files changed, 6 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6.19-rc6/drivers/scsi/lpfc/lpfc_init.c
> ===================================================================
> --- linux-2.6.19-rc6.orig/drivers/scsi/lpfc/lpfc_init.c
> +++ linux-2.6.19-rc6/drivers/scsi/lpfc/lpfc_init.c
> @@ -1453,10 +1453,11 @@
>  	int error = -ENODEV, retval;
>  	int i;
>  	uint16_t iotag;
> +	int bars = pci_select_bars(pdev, IORESOURCE_MEM);
> 
> -	if (pci_enable_device(pdev))
> +	if (pci_enable_device_bars(pdev, bars))
>  		goto out;
> -	if (pci_request_regions(pdev, LPFC_DRIVER_NAME))
> +	if (pci_request_selected_regions(pdev, bars, LPFC_DRIVER_NAME))
>  		goto out_disable_device;
> 
>  	host = scsi_host_alloc(&lpfc_template, sizeof (struct lpfc_hba));
> @@ -1759,7 +1760,7 @@
>  	phba->host = NULL;
>  	scsi_host_put(host);
>  out_release_regions:
> -	pci_release_regions(pdev);
> +	pci_release_selected_regions(pdev, bars);
>  out_disable_device:
>  	pci_disable_device(pdev);
>  out:
> @@ -1773,6 +1774,7 @@
>  	struct Scsi_Host   *host = pci_get_drvdata(pdev);
>  	struct lpfc_hba    *phba = (struct lpfc_hba *)host->hostdata;
>  	unsigned long iflag;
> +	int bars = pci_select_bars(pdev, IORESOURCE_MEM);
> 
>  	lpfc_free_sysfs_attr(phba);
> 
> @@ -1816,7 +1818,7 @@
>  	iounmap(phba->ctrl_regs_memmap_p);
>  	iounmap(phba->slim_memmap_p);
> 
> -	pci_release_regions(phba->pcidev);
> +	pci_release_selected_regions(phba->pcidev, bars);
>  	pci_disable_device(phba->pcidev);
> 
>  	idr_remove(&lpfc_hba_index, phba->brd_no);
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-------------------------------------------------------------------------
Take Surveys. Earn Cash. Influence the Future of IT
Join SourceForge.net's Techsay panel and you'll get the chance to share your
opinions on IT & business topics through brief surveys - and earn cash
http://www.techsay.com/default.php?page=join.php&p=sourceforge&CID=DEVDEV
