From: Varun Prakash <varun@chelsio.com>
Subject: Re: [PATCH] csiostor: switch to pci_alloc_irq_vectors
Date: Wed, 5 Apr 2017 21:09:35 +0530
Message-ID: <20170405153933.GA1912@chelsio.com>
References: <1484325046-31032-1-git-send-email-hch@lst.de>
 <yq1h94tgsvd.fsf@oracle.com>
 <20170331065527.GA3024@lst.de>
 <20170403145124.GA1743@chelsio.com>
 <20170404064614.GA9275@lst.de>
 <20170404081943.GA1665@chelsio.com>
 <20170405062656.GA26470@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:4727 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755336AbdDEPjn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Apr 2017 11:39:43 -0400
Content-Disposition: inline
In-Reply-To: <20170405062656.GA26470@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, Apr 05, 2017 at 08:26:57AM +0200, Christoph Hellwig wrote:
> On Tue, Apr 04, 2017 at 01:49:44PM +0530, Varun Prakash wrote:
> > On Tue, Apr 04, 2017 at 08:46:14AM +0200, Christoph Hellwig wrote:
> > > Does this one work better?
> > >
> > 
> > csiostor driver is triggering following warning during module unload.
> 
> Looks like we need to explicitly ignore the CSIO_IM_NONE case in
> csio_free_irqs.  New patch below:
>

Yes, we have to ignore CSIO_IM_NONE case in csio_free_irqs(), but I don't
see any CSIO_IM_NONE specific code in csio_free_irqs().

There is one more issue - this patch changes the order in which
csio_hw_intr_disable() and free_irq() are called.
In the current code first csio_hw_intr_disable() is called then free_irq()
is called, with this patch free_irq() is called without disabling hw
interrupts, this can cause regressions.

> ---
> From e5a4178cb810be581b6d9b8f48f13b12e88eae74 Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch@lst.de>
> Date: Thu, 12 Jan 2017 11:17:29 +0100
> Subject: csiostor: switch to pci_alloc_irq_vectors
> 
> And get automatic MSI-X affinity for free.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/csiostor/csio_hw.h   |   4 +-
>  drivers/scsi/csiostor/csio_init.c |   9 +--
>  drivers/scsi/csiostor/csio_isr.c  | 127 +++++++++++++-------------------------
>  3 files changed, 51 insertions(+), 89 deletions(-)
> 
> diff --git a/drivers/scsi/csiostor/csio_hw.h b/drivers/scsi/csiostor/csio_hw.h
> index 029bef82c057..a084d83ce70f 100644
> --- a/drivers/scsi/csiostor/csio_hw.h
> +++ b/drivers/scsi/csiostor/csio_hw.h
> @@ -95,7 +95,6 @@ enum {
>  };
>  
>  struct csio_msix_entries {
> -	unsigned short	vector;		/* Assigned MSI-X vector */
>  	void		*dev_id;	/* Priv object associated w/ this msix*/
>  	char		desc[24];	/* Description of this vector */
>  };
> @@ -591,8 +590,9 @@ int csio_enqueue_evt(struct csio_hw *, enum csio_evt, void *, uint16_t);
>  void csio_evtq_flush(struct csio_hw *hw);
>  
>  int csio_request_irqs(struct csio_hw *);
> +void csio_free_irqs(struct csio_hw *);
>  void csio_intr_enable(struct csio_hw *);
> -void csio_intr_disable(struct csio_hw *, bool);
> +void csio_intr_disable(struct csio_hw *);
>  void csio_hw_fatal_err(struct csio_hw *);
>  
>  struct csio_lnode *csio_lnode_alloc(struct csio_hw *);
> diff --git a/drivers/scsi/csiostor/csio_init.c b/drivers/scsi/csiostor/csio_init.c
> index dbe416ff46c2..7e60699c8b55 100644
> --- a/drivers/scsi/csiostor/csio_init.c
> +++ b/drivers/scsi/csiostor/csio_init.c
> @@ -461,8 +461,7 @@ csio_config_queues(struct csio_hw *hw)
>  	return 0;
>  
>  intr_disable:
> -	csio_intr_disable(hw, false);
> -
> +	csio_intr_disable(hw);
>  	return -EINVAL;
>  }
>  
> @@ -575,7 +574,8 @@ static struct csio_hw *csio_hw_alloc(struct pci_dev *pdev)
>  static void
>  csio_hw_free(struct csio_hw *hw)
>  {
> -	csio_intr_disable(hw, true);
> +	csio_free_irqs(hw);
> +	csio_intr_disable(hw);

This changes the order, free_irq() is called without disabling hw interrupts. 

>  	csio_hw_exit_workers(hw);
>  	csio_hw_exit(hw);
>  	iounmap(hw->regstart);
> @@ -1068,7 +1068,8 @@ csio_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
>  	spin_unlock_irq(&hw->lock);
>  	csio_lnodes_unblock_request(hw);
>  	csio_lnodes_exit(hw, 0);
> -	csio_intr_disable(hw, true);
> +	csio_free_irqs(hw);
> +	csio_intr_disable(hw);

Same here.

>  	pci_disable_device(pdev);
>  	return state == pci_channel_io_perm_failure ?
>  		PCI_ERS_RESULT_DISCONNECT : PCI_ERS_RESULT_NEED_RESET;
> diff --git a/drivers/scsi/csiostor/csio_isr.c b/drivers/scsi/csiostor/csio_isr.c
> index 2fb71c6c3b37..a4ad847e9c53 100644
> --- a/drivers/scsi/csiostor/csio_isr.c
> +++ b/drivers/scsi/csiostor/csio_isr.c
> @@ -383,17 +383,15 @@ csio_request_irqs(struct csio_hw *hw)
>  	int rv, i, j, k = 0;
>  	struct csio_msix_entries *entryp = &hw->msix_entries[0];
>  	struct csio_scsi_cpu_info *info;
> +	struct pci_dev *pdev = hw->pdev;
>  
>  	if (hw->intr_mode != CSIO_IM_MSIX) {
> -		rv = request_irq(hw->pdev->irq, csio_fcoe_isr,
> -					(hw->intr_mode == CSIO_IM_MSI) ?
> -							0 : IRQF_SHARED,
> -					KBUILD_MODNAME, hw);
> +		rv = request_irq(pci_irq_vector(pdev, 0), csio_fcoe_isr,
> +				hw->intr_mode == CSIO_IM_MSI ? 0 : IRQF_SHARED,
> +				KBUILD_MODNAME, hw);
>  		if (rv) {
> -			if (hw->intr_mode == CSIO_IM_MSI)
> -				pci_disable_msi(hw->pdev);
>  			csio_err(hw, "Failed to allocate interrupt line.\n");
> -			return -EINVAL;
> +			goto out_free_irqs;
>  		}
>  
>  		goto out;
> @@ -402,22 +400,22 @@ csio_request_irqs(struct csio_hw *hw)
>  	/* Add the MSIX vector descriptions */
>  	csio_add_msix_desc(hw);
>  
> -	rv = request_irq(entryp[k].vector, csio_nondata_isr, 0,
> +	rv = request_irq(pci_irq_vector(pdev, k), csio_nondata_isr, 0,
>  			 entryp[k].desc, hw);
>  	if (rv) {
>  		csio_err(hw, "IRQ request failed for vec %d err:%d\n",
> -			 entryp[k].vector, rv);
> -		goto err;
> +			 pci_irq_vector(pdev, k), rv);
> +		goto out_free_irqs;
>  	}
>  
> -	entryp[k++].dev_id = (void *)hw;
> +	entryp[k++].dev_id = hw;
>  
> -	rv = request_irq(entryp[k].vector, csio_fwevt_isr, 0,
> +	rv = request_irq(pci_irq_vector(pdev, k), csio_fwevt_isr, 0,
>  			 entryp[k].desc, hw);
>  	if (rv) {
>  		csio_err(hw, "IRQ request failed for vec %d err:%d\n",
> -			 entryp[k].vector, rv);
> -		goto err;
> +			 pci_irq_vector(pdev, k), rv);
> +		goto out_free_irqs;
>  	}
>  
>  	entryp[k++].dev_id = (void *)hw;
> @@ -429,51 +427,31 @@ csio_request_irqs(struct csio_hw *hw)
>  			struct csio_scsi_qset *sqset = &hw->sqset[i][j];
>  			struct csio_q *q = hw->wrm.q_arr[sqset->iq_idx];
>  
> -			rv = request_irq(entryp[k].vector, csio_scsi_isr, 0,
> +			rv = request_irq(pci_irq_vector(pdev, k), csio_scsi_isr, 0,
>  					 entryp[k].desc, q);
>  			if (rv) {
>  				csio_err(hw,
>  				       "IRQ request failed for vec %d err:%d\n",
> -				       entryp[k].vector, rv);
> -				goto err;
> +				       pci_irq_vector(pdev, k), rv);
> +				goto out_free_irqs;
>  			}
>  
> -			entryp[k].dev_id = (void *)q;
> +			entryp[k].dev_id = q;
>  
>  		} /* for all scsi cpus */
>  	} /* for all ports */
>  
>  out:
>  	hw->flags |= CSIO_HWF_HOST_INTR_ENABLED;
> -
>  	return 0;
>  
> -err:
> -	for (i = 0; i < k; i++) {
> -		entryp = &hw->msix_entries[i];
> -		free_irq(entryp->vector, entryp->dev_id);
> -	}
> -	pci_disable_msix(hw->pdev);
> -
> +out_free_irqs:
> +	for (i = 0; i < k; i++)
> +		free_irq(pci_irq_vector(pdev, i), hw->msix_entries[i].dev_id);
> +	pci_free_irq_vectors(hw->pdev);
>  	return -EINVAL;
>  }
>  
> -static void
> -csio_disable_msix(struct csio_hw *hw, bool free)
> -{
> -	int i;
> -	struct csio_msix_entries *entryp;
> -	int cnt = hw->num_sqsets + CSIO_EXTRA_VECS;
> -
> -	if (free) {
> -		for (i = 0; i < cnt; i++) {
> -			entryp = &hw->msix_entries[i];
> -			free_irq(entryp->vector, entryp->dev_id);
> -		}
> -	}
> -	pci_disable_msix(hw->pdev);
> -}
> -
>  /* Reduce per-port max possible CPUs */
>  static void
>  csio_reduce_sqsets(struct csio_hw *hw, int cnt)
> @@ -500,10 +478,9 @@ static int
>  csio_enable_msix(struct csio_hw *hw)
>  {
>  	int i, j, k, n, min, cnt;
> -	struct csio_msix_entries *entryp;
> -	struct msix_entry *entries;
>  	int extra = CSIO_EXTRA_VECS;
>  	struct csio_scsi_cpu_info *info;
> +	struct irq_affinity desc = { .pre_vectors = 2 };
>  
>  	min = hw->num_pports + extra;
>  	cnt = hw->num_sqsets + extra;
> @@ -512,50 +489,35 @@ csio_enable_msix(struct csio_hw *hw)
>  	if (hw->flags & CSIO_HWF_USING_SOFT_PARAMS || !csio_is_hw_master(hw))
>  		cnt = min_t(uint8_t, hw->cfg_niq, cnt);
>  
> -	entries = kzalloc(sizeof(struct msix_entry) * cnt, GFP_KERNEL);
> -	if (!entries)
> -		return -ENOMEM;
> -
> -	for (i = 0; i < cnt; i++)
> -		entries[i].entry = (uint16_t)i;
> -
>  	csio_dbg(hw, "FW supp #niq:%d, trying %d msix's\n", hw->cfg_niq, cnt);
>  
> -	cnt = pci_enable_msix_range(hw->pdev, entries, min, cnt);
> -	if (cnt < 0) {
> -		kfree(entries);
> +	cnt = pci_alloc_irq_vectors_affinity(hw->pdev, min, cnt,
> +			PCI_IRQ_MSIX | PCI_IRQ_AFFINITY, &desc);
> +	if (cnt < 0)
>  		return cnt;
> -	}
>  
>  	if (cnt < (hw->num_sqsets + extra)) {
>  		csio_dbg(hw, "Reducing sqsets to %d\n", cnt - extra);
>  		csio_reduce_sqsets(hw, cnt - extra);
>  	}
>  
> -	/* Save off vectors */
> -	for (i = 0; i < cnt; i++) {
> -		entryp = &hw->msix_entries[i];
> -		entryp->vector = entries[i].vector;
> -	}
> -
>  	/* Distribute vectors */
>  	k = 0;
> -	csio_set_nondata_intr_idx(hw, entries[k].entry);
> -	csio_set_mb_intr_idx(csio_hw_to_mbm(hw), entries[k++].entry);
> -	csio_set_fwevt_intr_idx(hw, entries[k++].entry);
> +	csio_set_nondata_intr_idx(hw, k);
> +	csio_set_mb_intr_idx(csio_hw_to_mbm(hw), k++);
> +	csio_set_fwevt_intr_idx(hw, k++);
>  
>  	for (i = 0; i < hw->num_pports; i++) {
>  		info = &hw->scsi_cpu_info[i];
>  
>  		for (j = 0; j < hw->num_scsi_msix_cpus; j++) {
>  			n = (j % info->max_cpus) +  k;
> -			hw->sqset[i][j].intr_idx = entries[n].entry;
> +			hw->sqset[i][j].intr_idx = n;
>  		}
>  
>  		k += info->max_cpus;
>  	}
>  
> -	kfree(entries);
>  	return 0;
>  }
>  
> @@ -593,26 +555,25 @@ csio_intr_enable(struct csio_hw *hw)
>  }
>  
>  void
> -csio_intr_disable(struct csio_hw *hw, bool free)
> +csio_free_irqs(struct csio_hw *hw)
>  {
> -	csio_hw_intr_disable(hw);
> +	if (hw->intr_mode == CSIO_IM_MSIX) {
> +		int i;
>  
> -	switch (hw->intr_mode) {
> -	case CSIO_IM_MSIX:
> -		csio_disable_msix(hw, free);
> -		break;
> -	case CSIO_IM_MSI:
> -		if (free)
> -			free_irq(hw->pdev->irq, hw);
> -		pci_disable_msi(hw->pdev);
> -		break;
> -	case CSIO_IM_INTX:
> -		if (free)
> -			free_irq(hw->pdev->irq, hw);
> -		break;
> -	default:
> -		break;
> +		for (i = 0; i < hw->num_sqsets + CSIO_EXTRA_VECS; i++) {
> +			free_irq(pci_irq_vector(hw->pdev, i),
> +					hw->msix_entries[i].dev_id);
> +		}
> +	} else {
> +		free_irq(pci_irq_vector(hw->pdev, 0), hw);
>  	}
> +}
> +
> +void
> +csio_intr_disable(struct csio_hw *hw)
> +{
> +	csio_hw_intr_disable(hw);
> +	pci_free_irq_vectors(hw->pdev);
>  	hw->intr_mode = CSIO_IM_NONE;
>  	hw->flags &= ~CSIO_HWF_HOST_INTR_ENABLED;
>  }
> -- 
> 2.11.0
> 
