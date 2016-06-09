From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH] aic7xxx: fix wrong return values
Date: Wed, 8 Jun 2016 21:04:46 -0400 (EDT)
Message-ID: <253299636.41281731.1465434286176.JavaMail.zimbra@redhat.com>
References: <1465424582-5801-1-git-send-email-luisbg@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx6-phx2.redhat.com ([209.132.183.39]:41585 "EHLO
	mx6-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbcFIBGY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jun 2016 21:06:24 -0400
In-Reply-To: <1465424582-5801-1-git-send-email-luisbg@osg.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luis de Bethencourt <luisbg@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, hare@suse.com, jejb@linux.vnet.ibm.com, martin petersen <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, javier@osg.samsung.com



----- Original Message -----
> From: "Luis de Bethencourt" <luisbg@osg.samsung.com>
> To: linux-kernel@vger.kernel.org
> Cc: hare@suse.com, jejb@linux.vnet.ibm.com, "martin petersen" <martin.petersen@oracle.com>,
> linux-scsi@vger.kernel.org, javier@osg.samsung.com, "Luis de Bethencourt" <luisbg@osg.samsung.com>
> Sent: Wednesday, June 8, 2016 6:23:02 PM
> Subject: [PATCH] aic7xxx: fix wrong return values
> 
> Convention of error codes says to return them as negative values.
> 
> Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
> ---
>  drivers/scsi/aic7xxx/aic7770_osm.c     |  6 +++---
>  drivers/scsi/aic7xxx/aic79xx_core.c    | 24 ++++++++++++------------
>  drivers/scsi/aic7xxx/aic79xx_osm.c     |  8 ++++----
>  drivers/scsi/aic7xxx/aic79xx_osm_pci.c | 16 ++++++++--------
>  drivers/scsi/aic7xxx/aic79xx_pci.c     |  2 +-
>  drivers/scsi/aic7xxx/aic7xxx_core.c    | 26 +++++++++++++-------------
>  drivers/scsi/aic7xxx/aic7xxx_osm.c     |  8 ++++----
>  drivers/scsi/aic7xxx/aic7xxx_osm_pci.c | 12 ++++++------
>  drivers/scsi/aic7xxx/aic7xxx_pci.c     |  4 ++--
>  9 files changed, 53 insertions(+), 53 deletions(-)
> 
> diff --git a/drivers/scsi/aic7xxx/aic7770_osm.c
> b/drivers/scsi/aic7xxx/aic7770_osm.c
> index 3d401d0..50f030d 100644
> --- a/drivers/scsi/aic7xxx/aic7770_osm.c
> +++ b/drivers/scsi/aic7xxx/aic7770_osm.c
> @@ -51,7 +51,7 @@ aic7770_map_registers(struct ahc_softc *ahc, u_int port)
>  	 * Lock out other contenders for our i/o space.
>  	 */
>  	if (!request_region(port, AHC_EISA_IOSIZE, "aic7xxx"))
> -		return (ENOMEM);
> +		return -ENOMEM;
>  	ahc->tag = BUS_SPACE_PIO;
>  	ahc->bsh.ioport = port;
>  	return (0);
> @@ -87,10 +87,10 @@ aic7770_probe(struct device *dev)
>  	sprintf(buf, "ahc_eisa:%d", eisaBase >> 12);
>  	name = kstrdup(buf, GFP_ATOMIC);
>  	if (name == NULL)
> -		return (ENOMEM);
> +		return -ENOMEM;
>  	ahc = ahc_alloc(&aic7xxx_driver_template, name);
>  	if (ahc == NULL)
> -		return (ENOMEM);
> +		return -ENOMEM;
>  	error = aic7770_config(ahc, aic7770_ident_table + edev->id.driver_data,
>  			       eisaBase);
>  	if (error != 0) {
> diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c
> b/drivers/scsi/aic7xxx/aic79xx_core.c
> index 109e2c9..bf850d8 100644
> --- a/drivers/scsi/aic7xxx/aic79xx_core.c
> +++ b/drivers/scsi/aic7xxx/aic79xx_core.c
> @@ -6422,7 +6422,7 @@ ahd_init_scbdata(struct ahd_softc *ahd)
>  	scb_data->maxhscbs = ahd_probe_scbs(ahd);
>  	if (scb_data->maxhscbs == 0) {
>  		printk("%s: No SCB space found\n", ahd_name(ahd));
> -		return (ENXIO);
> +		return -ENXIO;
>  	}
>  
>  	ahd_initialize_hscbs(ahd);
> @@ -6501,7 +6501,7 @@ ahd_init_scbdata(struct ahd_softc *ahd)
>  
>  error_exit:
>  
> -	return (ENOMEM);
> +	return -ENOMEM;
>  }
>  
>  static struct scb *
> @@ -7076,7 +7076,7 @@ ahd_init(struct ahd_softc *ahd)
>  	ahd->stack_size = ahd_probe_stack_size(ahd);
>  	ahd->saved_stack = kmalloc(ahd->stack_size * sizeof(uint16_t), GFP_ATOMIC);
>  	if (ahd->saved_stack == NULL)
> -		return (ENOMEM);
> +		return -ENOMEM;
>  
>  	/*
>  	 * Verify that the compiler hasn't over-aggressively
> @@ -7115,7 +7115,7 @@ ahd_init(struct ahd_softc *ahd)
>  			       /*maxsegsz*/AHD_MAXTRANSFER_SIZE,
>  			       /*flags*/BUS_DMA_ALLOCNOW,
>  			       &ahd->buffer_dmat) != 0) {
> -		return (ENOMEM);
> +		return -ENOMEM;
>  	}
>  #endif
>  
> @@ -7143,7 +7143,7 @@ ahd_init(struct ahd_softc *ahd)
>  			       /*nsegments*/1,
>  			       /*maxsegsz*/BUS_SPACE_MAXSIZE_32BIT,
>  			       /*flags*/0, &ahd->shared_data_dmat) != 0) {
> -		return (ENOMEM);
> +		return -ENOMEM;
>  	}
>  
>  	ahd->init_level++;
> @@ -7153,7 +7153,7 @@ ahd_init(struct ahd_softc *ahd)
>  			     (void **)&ahd->shared_data_map.vaddr,
>  			     BUS_DMA_NOWAIT,
>  			     &ahd->shared_data_map.dmamap) != 0) {
> -		return (ENOMEM);
> +		return -ENOMEM;
>  	}
>  
>  	ahd->init_level++;
> @@ -7194,7 +7194,7 @@ ahd_init(struct ahd_softc *ahd)
>  
>  	/* Allocate SCB data now that buffer_dmat is initialized */
>  	if (ahd_init_scbdata(ahd) != 0)
> -		return (ENOMEM);
> +		return -ENOMEM;
>  
>  	if ((ahd->flags & AHD_INITIATORROLE) == 0)
>  		ahd->flags &= ~AHD_RESET_BUS_A;
> @@ -7644,7 +7644,7 @@ ahd_default_config(struct ahd_softc *ahd)
>  	if (ahd_alloc_tstate(ahd, ahd->our_id, 'A') == NULL) {
>  		printk("%s: unable to allocate ahd_tmode_tstate.  "
>  		       "Failing attach\n", ahd_name(ahd));
> -		return (ENOMEM);
> +		return -ENOMEM;
>  	}
>  
>  	for (targ = 0; targ < AHD_NUM_TARGETS; targ++) {
> @@ -7723,7 +7723,7 @@ ahd_parse_cfgdata(struct ahd_softc *ahd, struct
> seeprom_config *sc)
>  	if (ahd_alloc_tstate(ahd, ahd->our_id, 'A') == NULL) {
>  		printk("%s: unable to allocate ahd_tmode_tstate.  "
>  		       "Failing attach\n", ahd_name(ahd));
> -		return (ENOMEM);
> +		return -ENOMEM;
>  	}
>  
>  	for (targ = 0; targ < max_targ; targ++) {
> @@ -7967,7 +7967,7 @@ ahd_suspend(struct ahd_softc *ahd)
>  
>  	if (LIST_FIRST(&ahd->pending_scbs) != NULL) {
>  		ahd_unpause(ahd);
> -		return (EBUSY);
> +		return -EBUSY;
>  	}
>  	ahd_shutdown(ahd);
>  	return (0);
> @@ -10126,7 +10126,7 @@ ahd_wait_seeprom(struct ahd_softc *ahd)
>  		ahd_delay(5);
>  
>  	if (cnt == 0)
> -		return (ETIMEDOUT);
> +		return -ETIMEDOUT;
>  	return (0);
>  }
>  
> @@ -10227,7 +10227,7 @@ ahd_wait_flexport(struct ahd_softc *ahd)
>  		ahd_delay(5);
>  
>  	if (cnt == 0)
> -		return (ETIMEDOUT);
> +		return -ETIMEDOUT;
>  	return (0);
>  }
>  
> diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c
> b/drivers/scsi/aic7xxx/aic79xx_osm.c
> index 2588b8f..1dc4977 100644
> --- a/drivers/scsi/aic7xxx/aic79xx_osm.c
> +++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
> @@ -940,7 +940,7 @@ ahd_dma_tag_create(struct ahd_softc *ahd, bus_dma_tag_t
> parent,
>  
>  	dmat = kmalloc(sizeof(*dmat), GFP_ATOMIC);
>  	if (dmat == NULL)
> -		return (ENOMEM);
> +		return -ENOMEM;
>  
>  	/*
>  	 * Linux is very simplistic about DMA memory.  For now don't
> @@ -969,7 +969,7 @@ ahd_dmamem_alloc(struct ahd_softc *ahd, bus_dma_tag_t
> dmat, void** vaddr,
>  	*vaddr = pci_alloc_consistent(ahd->dev_softc,
>  				      dmat->maxsize, mapp);
>  	if (*vaddr == NULL)
> -		return (ENOMEM);
> +		return -ENOMEM;
>  	return(0);
>  }
>  
> @@ -1232,7 +1232,7 @@ ahd_linux_register_host(struct ahd_softc *ahd, struct
> scsi_host_template *templa
>  	template->name = ahd->description;
>  	host = scsi_host_alloc(template, sizeof(struct ahd_softc *));
>  	if (host == NULL)
> -		return (ENOMEM);
> +		return -ENOMEM;
>  
>  	*((struct ahd_softc **)host->hostdata) = ahd;
>  	ahd->platform_data->host = host;
> @@ -1327,7 +1327,7 @@ ahd_platform_alloc(struct ahd_softc *ahd, void
> *platform_arg)
>  	ahd->platform_data =
>  	    kzalloc(sizeof(struct ahd_platform_data), GFP_ATOMIC);
>  	if (ahd->platform_data == NULL)
> -		return (ENOMEM);
> +		return -ENOMEM;
>  	ahd->platform_data->irq = AHD_LINUX_NOIRQ;
>  	ahd_lockinit(ahd);
>  	ahd->seltime = (aic79xx_seltime & 0x3) << 4;
> diff --git a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
> b/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
> index 8466aa7..db58ad9 100644
> --- a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
> +++ b/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
> @@ -259,12 +259,12 @@ ahd_linux_pci_reserve_io_regions(struct ahd_softc *ahd,
> resource_size_t *base,
>  	 */
>  	*base2 = pci_resource_start(ahd->dev_softc, 3);
>  	if (*base == 0 || *base2 == 0)
> -		return (ENOMEM);
> +		return -ENOMEM;
>  	if (!request_region(*base, 256, "aic79xx"))
> -		return (ENOMEM);
> +		return -ENOMEM;
>  	if (!request_region(*base2, 256, "aic79xx")) {
>  		release_region(*base, 256);
> -		return (ENOMEM);
> +		return -ENOMEM;
>  	}
>  	return (0);
>  }
> @@ -280,10 +280,10 @@ ahd_linux_pci_reserve_mem_region(struct ahd_softc *ahd,
>  	int	error = 0;
>  
>  	if (aic79xx_allow_memio == 0)
> -		return (ENOMEM);
> +		return -ENOMEM;
>  
>  	if ((ahd->bugs & AHD_PCIX_MMAPIO_BUG) != 0)
> -		return (ENOMEM);
> +		return -ENOMEM;
>  
>  	start = pci_resource_start(ahd->dev_softc, 1);
>  	base_page = start & PAGE_MASK;
> @@ -291,17 +291,17 @@ ahd_linux_pci_reserve_mem_region(struct ahd_softc *ahd,
>  	if (start != 0) {
>  		*bus_addr = start;
>  		if (!request_mem_region(start, 0x1000, "aic79xx"))
> -			error = ENOMEM;
> +			error = -ENOMEM;
>  		if (!error) {
>  			*maddr = ioremap_nocache(base_page, base_offset + 512);
>  			if (*maddr == NULL) {
> -				error = ENOMEM;
> +				error = -ENOMEM;
>  				release_mem_region(start, 0x1000);
>  			} else
>  				*maddr += base_offset;
>  		}
>  	} else
> -		error = ENOMEM;
> +		error = -ENOMEM;
>  	return (error);
>  }
>  
> diff --git a/drivers/scsi/aic7xxx/aic79xx_pci.c
> b/drivers/scsi/aic7xxx/aic79xx_pci.c
> index cc9bd26..d597dc9 100644
> --- a/drivers/scsi/aic7xxx/aic79xx_pci.c
> +++ b/drivers/scsi/aic7xxx/aic79xx_pci.c
> @@ -360,7 +360,7 @@ ahd_pci_config(struct ahd_softc *ahd, const struct
> ahd_pci_identity *entry)
>  
>  	error = ahd_reset(ahd, /*reinit*/FALSE);
>  	if (error != 0)
> -		return (ENXIO);
> +		return -ENXIO;
>  
>  	ahd->pci_cachesize =
>  	    ahd_pci_read_config(ahd->dev_softc, CSIZE_LATTIME,
> diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c
> b/drivers/scsi/aic7xxx/aic7xxx_core.c
> index 64ab9ea..a08179d 100644
> --- a/drivers/scsi/aic7xxx/aic7xxx_core.c
> +++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
> @@ -4466,7 +4466,7 @@ ahc_softc_init(struct ahc_softc *ahc)
>  	if (ahc->scb_data == NULL) {
>  		ahc->scb_data = kzalloc(sizeof(*ahc->scb_data), GFP_ATOMIC);
>  		if (ahc->scb_data == NULL)
> -			return (ENOMEM);
> +			return -ENOMEM;
>  	}
>  
>  	return (0);
> @@ -4782,14 +4782,14 @@ ahc_init_scbdata(struct ahc_softc *ahc)
>  	scb_data->scbarray = kzalloc(sizeof(struct scb) * AHC_SCB_MAX_ALLOC,
>  				GFP_ATOMIC);
>  	if (scb_data->scbarray == NULL)
> -		return (ENOMEM);
> +		return -ENOMEM;
>  
>  	/* Determine the number of hardware SCBs and initialize them */
>  
>  	scb_data->maxhscbs = ahc_probe_scbs(ahc);
>  	if (ahc->scb_data->maxhscbs == 0) {
>  		printk("%s: No SCB space found\n", ahc_name(ahc));
> -		return (ENXIO);
> +		return -ENXIO;
>  	}
>  
>  	/*
> @@ -4904,7 +4904,7 @@ ahc_init_scbdata(struct ahc_softc *ahc)
>  
>  error_exit:
>  
> -	return (ENOMEM);
> +	return -ENOMEM;
>  }
>  
>  static void
> @@ -5339,7 +5339,7 @@ ahc_init(struct ahc_softc *ahc)
>  			       /*maxsegsz*/AHC_MAXTRANSFER_SIZE,
>  			       /*flags*/BUS_DMA_ALLOCNOW,
>  			       &ahc->buffer_dmat) != 0) {
> -		return (ENOMEM);
> +		return -ENOMEM;
>  	}
>  #endif
>  
> @@ -5367,7 +5367,7 @@ ahc_init(struct ahc_softc *ahc)
>  			       /*nsegments*/1,
>  			       /*maxsegsz*/BUS_SPACE_MAXSIZE_32BIT,
>  			       /*flags*/0, &ahc->shared_data_dmat) != 0) {
> -		return (ENOMEM);
> +		return -ENOMEM;
>  	}
>  
>  	ahc->init_level++;
> @@ -5376,7 +5376,7 @@ ahc_init(struct ahc_softc *ahc)
>  	if (ahc_dmamem_alloc(ahc, ahc->shared_data_dmat,
>  			     (void **)&ahc->qoutfifo,
>  			     BUS_DMA_NOWAIT, &ahc->shared_data_dmamap) != 0) {
> -		return (ENOMEM);
> +		return -ENOMEM;
>  	}
>  
>  	ahc->init_level++;
> @@ -5404,7 +5404,7 @@ ahc_init(struct ahc_softc *ahc)
>  	/* Allocate SCB data now that buffer_dmat is initialized */
>  	if (ahc->scb_data->maxhscbs == 0)
>  		if (ahc_init_scbdata(ahc) != 0)
> -			return (ENOMEM);
> +			return -ENOMEM;
>  
>  	/*
>  	 * Allocate a tstate to house information for our
> @@ -5414,14 +5414,14 @@ ahc_init(struct ahc_softc *ahc)
>  	if (ahc_alloc_tstate(ahc, ahc->our_id, 'A') == NULL) {
>  		printk("%s: unable to allocate ahc_tmode_tstate.  "
>  		       "Failing attach\n", ahc_name(ahc));
> -		return (ENOMEM);
> +		return -ENOMEM;
>  	}
>  
>  	if ((ahc->features & AHC_TWIN) != 0) {
>  		if (ahc_alloc_tstate(ahc, ahc->our_id_b, 'B') == NULL) {
>  			printk("%s: unable to allocate ahc_tmode_tstate.  "
>  			       "Failing attach\n", ahc_name(ahc));
> -			return (ENOMEM);
> +			return -ENOMEM;
>  		}
>  	}
>  
> @@ -5660,7 +5660,7 @@ ahc_suspend(struct ahc_softc *ahc)
>  
>  	if (LIST_FIRST(&ahc->pending_scbs) != NULL) {
>  		ahc_unpause(ahc);
> -		return (EBUSY);
> +		return -EBUSY;
>  	}
>  
>  #ifdef AHC_TARGET_MODE
> @@ -5671,7 +5671,7 @@ ahc_suspend(struct ahc_softc *ahc)
>  	 */
>  	if (ahc->pending_device != NULL) {
>  		ahc_unpause(ahc);
> -		return (EBUSY);
> +		return -EBUSY;
>  	}
>  #endif
>  	ahc_shutdown(ahc);
> @@ -6908,7 +6908,7 @@ ahc_loadseq(struct ahc_softc *ahc)
>  			printk("\n%s: Program too large for instruction memory "
>  			       "size of %d!\n", ahc_name(ahc),
>  			       ahc->instruction_ram_size);
> -			return (ENOMEM);
> +			return -ENOMEM;
>  		}
>  
>  		/*
> diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c
> b/drivers/scsi/aic7xxx/aic7xxx_osm.c
> index fc6a831..78433f6 100644
> --- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
> +++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
> @@ -835,7 +835,7 @@ ahc_dma_tag_create(struct ahc_softc *ahc, bus_dma_tag_t
> parent,
>  
>  	dmat = kmalloc(sizeof(*dmat), GFP_ATOMIC);
>  	if (dmat == NULL)
> -		return (ENOMEM);
> +		return -ENOMEM;
>  
>  	/*
>  	 * Linux is very simplistic about DMA memory.  For now don't
> @@ -864,7 +864,7 @@ ahc_dmamem_alloc(struct ahc_softc *ahc, bus_dma_tag_t
> dmat, void** vaddr,
>  	*vaddr = pci_alloc_consistent(ahc->dev_softc,
>  				      dmat->maxsize, mapp);
>  	if (*vaddr == NULL)
> -		return ENOMEM;
> +		return -ENOMEM;
>  	return 0;
>  }
>  
> @@ -1096,7 +1096,7 @@ ahc_linux_register_host(struct ahc_softc *ahc, struct
> scsi_host_template *templa
>  	template->name = ahc->description;
>  	host = scsi_host_alloc(template, sizeof(struct ahc_softc *));
>  	if (host == NULL)
> -		return (ENOMEM);
> +		return -ENOMEM;
>  
>  	*((struct ahc_softc **)host->hostdata) = ahc;
>  	ahc->platform_data->host = host;
> @@ -1215,7 +1215,7 @@ ahc_platform_alloc(struct ahc_softc *ahc, void
> *platform_arg)
>  	ahc->platform_data =
>  	    kzalloc(sizeof(struct ahc_platform_data), GFP_ATOMIC);
>  	if (ahc->platform_data == NULL)
> -		return (ENOMEM);
> +		return -ENOMEM;
>  	ahc->platform_data->irq = AHC_LINUX_NOIRQ;
>  	ahc_lockinit(ahc);
>  	ahc->seltime = (aic7xxx_seltime & 0x3) << 4;
> diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
> b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
> index 0fc14da..8bca7f4 100644
> --- a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
> +++ b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
> @@ -346,13 +346,13 @@ static int
>  ahc_linux_pci_reserve_io_region(struct ahc_softc *ahc, resource_size_t
>  *base)
>  {
>  	if (aic7xxx_allow_memio == 0)
> -		return (ENOMEM);
> +		return -ENOMEM;
>  
>  	*base = pci_resource_start(ahc->dev_softc, 0);
>  	if (*base == 0)
> -		return (ENOMEM);
> +		return -ENOMEM;
>  	if (!request_region(*base, 256, "aic7xxx"))
> -		return (ENOMEM);
> +		return -ENOMEM;
>  	return (0);
>  }
>  
> @@ -369,16 +369,16 @@ ahc_linux_pci_reserve_mem_region(struct ahc_softc *ahc,
>  	if (start != 0) {
>  		*bus_addr = start;
>  		if (!request_mem_region(start, 0x1000, "aic7xxx"))
> -			error = ENOMEM;
> +			error = -ENOMEM;
>  		if (error == 0) {
>  			*maddr = ioremap_nocache(start, 256);
>  			if (*maddr == NULL) {
> -				error = ENOMEM;
> +				error = -ENOMEM;
>  				release_mem_region(start, 0x1000);
>  			}
>  		}
>  	} else
> -		error = ENOMEM;
> +		error = -ENOMEM;
>  	return (error);
>  }
>  
> diff --git a/drivers/scsi/aic7xxx/aic7xxx_pci.c
> b/drivers/scsi/aic7xxx/aic7xxx_pci.c
> index 22d5a94..40e1c9b 100644
> --- a/drivers/scsi/aic7xxx/aic7xxx_pci.c
> +++ b/drivers/scsi/aic7xxx/aic7xxx_pci.c
> @@ -806,7 +806,7 @@ ahc_pci_config(struct ahc_softc *ahc, const struct
> ahc_pci_identity *entry)
>  
>  	error = ahc_reset(ahc, /*reinit*/FALSE);
>  	if (error != 0)
> -		return (ENXIO);
> +		return -ENXIO;
>  
>  	if ((ahc->features & AHC_DT) != 0) {
>  		u_int sfunct;
> @@ -2387,7 +2387,7 @@ static int
>  ahc_raid_setup(struct ahc_softc *ahc)
>  {
>  	printk("RAID functionality unsupported\n");
> -	return (ENXIO);
> +	return -ENXIO;
>  }
>  
>  static int
> --
> 2.5.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Patch looks simple as the change is straightforward.
However can you make the code consistent, some have parenthesis in return, some not.
How did this work before though if it was returning non-negative to the caller or upper layer
Has this been tested to work with the changes

Reviewed-by Laurence Oberman <loberman@redhat.com>
