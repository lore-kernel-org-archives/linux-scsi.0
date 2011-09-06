From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [RFC] pci: Rework config space blocking services
Date: Tue, 6 Sep 2011 10:00:54 +0300
Message-ID: <20110906055810.GA13286@redhat.com>
References: <20110829150552.GA6851@redhat.com>
 <4E5BB358.3060705@siemens.com>
 <4E5BDEAB.5000405@siemens.com>
 <20110829191858.GA9415@redhat.com>
 <4E608A51.70509@siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4E608A51.70509@siemens.com>
Sender: linux-pci-owner@vger.kernel.org
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Brian King <brking@us.ibm.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, "Hans J. Koch" <hjk@hansjkoch.de>, Greg Kroah-Hartman <gregkh@suse.de>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 02, 2011 at 09:48:33AM +0200, Jan Kiszka wrote:
> On 2011-08-29 21:18, Michael S. Tsirkin wrote:
> > On Mon, Aug 29, 2011 at 08:47:07PM +0200, Jan Kiszka wrote:
> >> On 2011-08-29 17:42, Jan Kiszka wrote:
> >>> I still don't get what prevents converting ipr to allow plain mutex
> >>> synchronization. My vision is:
> >>>  - push reset-on-error of ipr into workqueue (or threaded IRQ?)
> >>
> >> I'm starting to like your proposal: I had a look at ipr, but it turned
> >> out to be anything but trivial to convert that driver. It runs its
> >> complete state machine under spin_lock_irq, and the functions calling
> >> pci_block/unblock_user_cfg_access are deep inside this thing. I have no
> >> hardware to test whatever change, and I feel a bit uncomfortable asking
> >> Brian to redesign his driver that massively.
> >>
> >> So back to your idea: I would generalize pci_block_user_cfg_access to
> >> pci_block_cfg_access. It should fail when some other site already holds
> >> the access lock, but it should remain non-blocking - for the sake of ipr.
> > 
> > It would be easy to have blocking and non-blocking variants.
> > 
> > But
> > - I have no idea whether supporting sysfs config/reset access
> >   while ipr is active makes any sense - I know we need it for uio.
> > - reset while uio handles interrupt needs to block, not fail I think
> > 
> 
> Here is a preview following those ideas. I'll look into generic INTx
> masking services now and, if that works out and no concerns are raised,
> I'll post it all.
> 
> Jan

Hopefully as separate patches :)

No real concerns, some nitpicking comments below.

> -----8<-----
> 
> pci_block_user_cfg_access was designed for the use case that a single
> context, the IPR driver, temporarily delays user space accesses to the
> config space via sysfs. This assumption became invalid by the time
> pci_dev_reset was added as locking instance. Today, if you run two loops
> in parallel that reset the same device via sysfs, you end up with a
> kernel BUG as pci_block_user_cfg_access detect the broken assumption.
> 
> This reworks the pci_block_user_cfg_access to a sleeping service
> pci_block_cfg_access and an atomic variant called
> pci_block_cfg_access_in_atomic. The former not only blocks user space
> access as before but also waits if access was already blocked. The
> latter service just returns an error code in this case, allowing the
> caller to resolve the conflict instead of raising a BUG.

I'm not sure I understand the point of the API renaming -
the new names seem less clear than the original, to me.
Regular config access isn't blocked by this API - it still only
blocks user config accesses, we simply allow
multiple block calls in parallel now.

If we keep the old name, simply allow blocking
and add an atomic variant, the patch will be much smaller.


> 
> ---
>  drivers/pci/access.c          |   76 +++++++++++++++++++++++++++--------------
>  drivers/pci/iov.c             |   12 +++---
>  drivers/pci/pci.c             |    4 +-
>  drivers/scsi/ipr.c            |   24 +++++++++----
>  drivers/uio/uio_pci_generic.c |   10 +++--
>  include/linux/pci.h           |   14 +++++---
>  6 files changed, 89 insertions(+), 51 deletions(-)

Below might be easier to review if it is split in two:
1. rename ucfg to cfg all over, tweak whitespace
2. allow multiple block calls, add in_atomic and update
   in_atomic callers

> 
> diff --git a/drivers/pci/access.c b/drivers/pci/access.c
> index fdaa42a..640522a 100644
> --- a/drivers/pci/access.c
> +++ b/drivers/pci/access.c
> @@ -127,20 +127,20 @@ EXPORT_SYMBOL(pci_write_vpd);
>   * We have a bit per device to indicate it's blocked and a global wait queue
>   * for callers to sleep on until devices are unblocked.
>   */
> -static DECLARE_WAIT_QUEUE_HEAD(pci_ucfg_wait);
> +static DECLARE_WAIT_QUEUE_HEAD(pci_cfg_wait);
>  
> -static noinline void pci_wait_ucfg(struct pci_dev *dev)
> +static noinline void pci_wait_cfg(struct pci_dev *dev)
>  {
>  	DECLARE_WAITQUEUE(wait, current);
>  
> -	__add_wait_queue(&pci_ucfg_wait, &wait);
> +	__add_wait_queue(&pci_cfg_wait, &wait);
>  	do {
>  		set_current_state(TASK_UNINTERRUPTIBLE);
>  		raw_spin_unlock_irq(&pci_lock);
>  		schedule();
>  		raw_spin_lock_irq(&pci_lock);
> -	} while (dev->block_ucfg_access);
> -	__remove_wait_queue(&pci_ucfg_wait, &wait);
> +	} while (dev->block_cfg_access);
> +	__remove_wait_queue(&pci_cfg_wait, &wait);
>  }
>  
>  /* Returns 0 on success, negative values indicate error. */
> @@ -153,7 +153,8 @@ int pci_user_read_config_##size						\
>  	if (PCI_##size##_BAD)						\
>  		return -EINVAL;						\
>  	raw_spin_lock_irq(&pci_lock);				\
> -	if (unlikely(dev->block_ucfg_access)) pci_wait_ucfg(dev);	\
> +	if (unlikely(dev->block_cfg_access))				\
> +		pci_wait_cfg(dev);					\
>  	ret = dev->bus->ops->read(dev->bus, dev->devfn,			\
>  					pos, sizeof(type), &data);	\
>  	raw_spin_unlock_irq(&pci_lock);				\
> @@ -172,7 +173,8 @@ int pci_user_write_config_##size					\
>  	if (PCI_##size##_BAD)						\
>  		return -EINVAL;						\
>  	raw_spin_lock_irq(&pci_lock);				\
> -	if (unlikely(dev->block_ucfg_access)) pci_wait_ucfg(dev);	\
> +	if (unlikely(dev->block_cfg_access))				\
> +		pci_wait_cfg(dev);					\
>  	ret = dev->bus->ops->write(dev->bus, dev->devfn,		\
>  					pos, sizeof(type), val);	\
>  	raw_spin_unlock_irq(&pci_lock);				\
> @@ -401,36 +403,58 @@ int pci_vpd_truncate(struct pci_dev *dev, size_t size)
>  EXPORT_SYMBOL(pci_vpd_truncate);
>  
>  /**
> - * pci_block_user_cfg_access - Block userspace PCI config reads/writes
> + * pci_block_cfg_access - Block PCI config reads/writes

This comment seems confusing. We don't in fact block all config
reads writes. Instead we block userspace accesses and
concurrent block requests.

>   * @dev:	pci device struct
>   *
> - * When user access is blocked, any reads or writes to config space will
> - * sleep until access is unblocked again.  We don't allow nesting of
> - * block/unblock calls.
> + * When access is blocked, any userspace reads or writes to config space
> + * and concurrent block requests will sleep until
> + * access is unblocked again.
>   */
> -void pci_block_user_cfg_access(struct pci_dev *dev)
> +void pci_block_cfg_access(struct pci_dev *dev)
>  {
>  	unsigned long flags;
> -	int was_blocked;
> +
> +	might_sleep();
> +
> +	raw_spin_lock_irqsave(&pci_lock, flags);
> +	if (dev->block_cfg_access)
> +		pci_wait_cfg(dev);
> +	dev->block_cfg_access = 1;
> +	raw_spin_unlock_irqrestore(&pci_lock, flags);

Above can sleep so irq must be enabled, thus
it can be raw_spin_lock_irq, right?

> +}
> +EXPORT_SYMBOL_GPL(pci_block_cfg_access);
> +
> +/**
> + * pci_block_cfg_access_in_atomic - Block PCI config reads/writes from atomic
> + *                                  context
> + * @dev:	pci device struct
> + *
> + * Same as pci_block_cfg_access, but will fail with -EBUSY if access is
> + * already blocked.

Mention return value on success? Callers seem to rely on it being 0.

> + */
> +int pci_block_cfg_access_in_atomic(struct pci_dev *dev)


I would rename this pci_block_cfg_access_atomic: tell
the user what it does, not where it should be called
from. Compare with kmap_atomic, which fails if it needs to block.

> +{
> +	unsigned long flags;
> +	int err = 0;
>  
>  	raw_spin_lock_irqsave(&pci_lock, flags);
> -	was_blocked = dev->block_ucfg_access;
> -	dev->block_ucfg_access = 1;
> +	if (dev->block_cfg_access)
> +		err = -EBUSY;
> +	else
> +		dev->block_cfg_access = 1;
>  	raw_spin_unlock_irqrestore(&pci_lock, flags);
>  
> -	/* If we BUG() inside the pci_lock, we're guaranteed to hose
> -	 * the machine */
> -	BUG_ON(was_blocked);
> +	return err;
>  }
> -EXPORT_SYMBOL_GPL(pci_block_user_cfg_access);
> +EXPORT_SYMBOL_GPL(pci_block_cfg_access_in_atomic);
>  
>  /**
> - * pci_unblock_user_cfg_access - Unblock userspace PCI config reads/writes
> + * pci_unblock_cfg_access - Unblock PCI config reads/writes
>   * @dev:	pci device struct
>   *
> - * This function allows userspace PCI config accesses to resume.
> + * This function allows PCI config accesses to resume.
>   */
> -void pci_unblock_user_cfg_access(struct pci_dev *dev)
> +void pci_unblock_cfg_access(struct pci_dev *dev)
>  {
>  	unsigned long flags;
>  
> @@ -438,10 +462,10 @@ void pci_unblock_user_cfg_access(struct pci_dev *dev)
>  
>  	/* This indicates a problem in the caller, but we don't need
>  	 * to kill them, unlike a double-block above. */
> -	WARN_ON(!dev->block_ucfg_access);
> +	WARN_ON(!dev->block_cfg_access);
>  
> -	dev->block_ucfg_access = 0;
> -	wake_up_all(&pci_ucfg_wait);
> +	dev->block_cfg_access = 0;
> +	wake_up_all(&pci_cfg_wait);
>  	raw_spin_unlock_irqrestore(&pci_lock, flags);
>  }
> -EXPORT_SYMBOL_GPL(pci_unblock_user_cfg_access);
> +EXPORT_SYMBOL_GPL(pci_unblock_cfg_access);
> diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
> index 42fae47..a061847 100644
> --- a/drivers/pci/iov.c
> +++ b/drivers/pci/iov.c
> @@ -340,10 +340,10 @@ static int sriov_enable(struct pci_dev *dev, int nr_virtfn)
>  	}
>  
>  	iov->ctrl |= PCI_SRIOV_CTRL_VFE | PCI_SRIOV_CTRL_MSE;
> -	pci_block_user_cfg_access(dev);
> +	pci_block_cfg_access(dev);
>  	pci_write_config_word(dev, iov->pos + PCI_SRIOV_CTRL, iov->ctrl);
>  	msleep(100);
> -	pci_unblock_user_cfg_access(dev);
> +	pci_unblock_cfg_access(dev);
>  
>  	iov->initial = initial;
>  	if (nr_virtfn < initial)
> @@ -371,10 +371,10 @@ failed:
>  		virtfn_remove(dev, j, 0);
>  
>  	iov->ctrl &= ~(PCI_SRIOV_CTRL_VFE | PCI_SRIOV_CTRL_MSE);
> -	pci_block_user_cfg_access(dev);
> +	pci_block_cfg_access(dev);
>  	pci_write_config_word(dev, iov->pos + PCI_SRIOV_CTRL, iov->ctrl);
>  	ssleep(1);
> -	pci_unblock_user_cfg_access(dev);
> +	pci_unblock_cfg_access(dev);
>  
>  	if (iov->link != dev->devfn)
>  		sysfs_remove_link(&dev->dev.kobj, "dep_link");
> @@ -397,10 +397,10 @@ static void sriov_disable(struct pci_dev *dev)
>  		virtfn_remove(dev, i, 0);
>  
>  	iov->ctrl &= ~(PCI_SRIOV_CTRL_VFE | PCI_SRIOV_CTRL_MSE);
> -	pci_block_user_cfg_access(dev);
> +	pci_block_cfg_access(dev);
>  	pci_write_config_word(dev, iov->pos + PCI_SRIOV_CTRL, iov->ctrl);
>  	ssleep(1);
> -	pci_unblock_user_cfg_access(dev);
> +	pci_unblock_cfg_access(dev);
>  
>  	if (iov->link != dev->devfn)
>  		sysfs_remove_link(&dev->dev.kobj, "dep_link");
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 0ce6742..3c6ce05 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -2959,7 +2959,7 @@ static int pci_dev_reset(struct pci_dev *dev, int probe)
>  	might_sleep();
>  
>  	if (!probe) {
> -		pci_block_user_cfg_access(dev);
> +		pci_block_cfg_access(dev);
>  		/* block PM suspend, driver probe, etc. */
>  		device_lock(&dev->dev);
>  	}
> @@ -2984,7 +2984,7 @@ static int pci_dev_reset(struct pci_dev *dev, int probe)
>  done:
>  	if (!probe) {
>  		device_unlock(&dev->dev);
> -		pci_unblock_user_cfg_access(dev);
> +		pci_unblock_cfg_access(dev);
>  	}
>  
>  	return rc;
> diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
> index 8d63630..7fc3861 100644
> --- a/drivers/scsi/ipr.c
> +++ b/drivers/scsi/ipr.c
> @@ -7640,7 +7640,7 @@ static int ipr_reset_restore_cfg_space(struct ipr_cmnd *ipr_cmd)
>  static int ipr_reset_bist_done(struct ipr_cmnd *ipr_cmd)
>  {
>  	ENTER;
> -	pci_unblock_user_cfg_access(ipr_cmd->ioa_cfg->pdev);
> +	pci_unblock_cfg_access(ipr_cmd->ioa_cfg->pdev);
>  	ipr_cmd->job_step = ipr_reset_restore_cfg_space;
>  	LEAVE;
>  	return IPR_RC_JOB_CONTINUE;
> @@ -7661,7 +7661,8 @@ static int ipr_reset_start_bist(struct ipr_cmnd *ipr_cmd)
>  	int rc = PCIBIOS_SUCCESSFUL;
>  
>  	ENTER;
> -	pci_block_user_cfg_access(ioa_cfg->pdev);
> +	if (pci_block_cfg_access_in_atomic(ioa_cfg->pdev) != 0)
> +		goto error;

if (pci_block_cfg_access_in_atomic(ioa_cfg->pdev))
to be consistent in style with the rest of ipr.

>  
>  	if (ioa_cfg->ipr_chip->bist_method == IPR_MMIO)
>  		writel(IPR_UPROCI_SIS64_START_BIST,
> @@ -7674,7 +7675,8 @@ static int ipr_reset_start_bist(struct ipr_cmnd *ipr_cmd)
>  		ipr_reset_start_timer(ipr_cmd, IPR_WAIT_FOR_BIST_TIMEOUT);
>  		rc = IPR_RC_JOB_RETURN;
>  	} else {
> -		pci_unblock_user_cfg_access(ipr_cmd->ioa_cfg->pdev);
> +		pci_unblock_cfg_access(ipr_cmd->ioa_cfg->pdev);
> +error:
>  		ipr_cmd->s.ioasa.hdr.ioasc = cpu_to_be32(IPR_IOASC_PCI_ACCESS_ERROR);
>  		rc = IPR_RC_JOB_CONTINUE;
>  	}
> @@ -7715,14 +7717,20 @@ static int ipr_reset_slot_reset(struct ipr_cmnd *ipr_cmd)
>  {
>  	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
>  	struct pci_dev *pdev = ioa_cfg->pdev;
> +	int rc = IPR_RC_JOB_RETURN;
>  
>  	ENTER;
> -	pci_block_user_cfg_access(pdev);
> -	pci_set_pcie_reset_state(pdev, pcie_warm_reset);
> -	ipr_cmd->job_step = ipr_reset_slot_reset_done;
> -	ipr_reset_start_timer(ipr_cmd, IPR_PCI_RESET_TIMEOUT);
> +	if (pci_block_cfg_access_in_atomic(pdev) == 0) {
> +		pci_set_pcie_reset_state(pdev, pcie_warm_reset);
> +		ipr_cmd->job_step = ipr_reset_slot_reset_done;
> +		ipr_reset_start_timer(ipr_cmd, IPR_PCI_RESET_TIMEOUT);
> +	} else {
> +		ipr_cmd->s.ioasa.hdr.ioasc =
> +			cpu_to_be32(IPR_IOASC_PCI_ACCESS_ERROR);
> +		rc = IPR_RC_JOB_CONTINUE;
> +	}

Above is unusual.
if (pci_block_cfg_access_in_atomic(pdev)) {
	...
	rc = IPR_RC_JOB_RETURN;
} else {
	...
	rc = IPR_RC_JOB_CONTINUE;
}

would be clearer.


>  	LEAVE;
> -	return IPR_RC_JOB_RETURN;
> +	return rc;
>  }
>  
>  /**
> diff --git a/drivers/uio/uio_pci_generic.c b/drivers/uio/uio_pci_generic.c
> index fc22e1e..642f7fa 100644
> --- a/drivers/uio/uio_pci_generic.c
> +++ b/drivers/uio/uio_pci_generic.c
> @@ -58,7 +58,8 @@ static irqreturn_t irqhandler(int irq, struct uio_info *info)
>  	BUILD_BUG_ON(PCI_COMMAND + 2 != PCI_STATUS);
>  
>  	spin_lock_irq(&gdev->lock);
> -	pci_block_user_cfg_access(pdev);
> +	if (pci_block_cfg_access_in_atomic(pdev) != 0)

if (pci_block_cfg_access_in_atomic(pdev))
would be more in style with the rest of uio.

> +		goto error;
>  
>  	/* Read both command and status registers in a single 32-bit operation.
>  	 * Note: we could cache the value for command and move the status read
> @@ -82,7 +83,8 @@ static irqreturn_t irqhandler(int irq, struct uio_info *info)
>  	ret = IRQ_HANDLED;
>  done:
>  
> -	pci_unblock_user_cfg_access(pdev);
> +	pci_unblock_cfg_access(pdev);
> +error:
>  	spin_unlock_irq(&gdev->lock);
>  	return ret;
>  }
> @@ -95,7 +97,7 @@ static int __devinit verify_pci_2_3(struct pci_dev *pdev)
>  	u16 orig, new;
>  	int err = 0;
>  
> -	pci_block_user_cfg_access(pdev);
> +	pci_block_cfg_access(pdev);
>  	pci_read_config_word(pdev, PCI_COMMAND, &orig);
>  	pci_write_config_word(pdev, PCI_COMMAND,
>  			      orig ^ PCI_COMMAND_INTX_DISABLE);
> @@ -118,7 +120,7 @@ static int __devinit verify_pci_2_3(struct pci_dev *pdev)
>  	/* Now restore the original value. */
>  	pci_write_config_word(pdev, PCI_COMMAND, orig);
>  err:
> -	pci_unblock_user_cfg_access(pdev);
> +	pci_unblock_cfg_access(pdev);
>  	return err;
>  }
>  
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 8c230cb..3414b74 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -305,7 +305,7 @@ struct pci_dev {
>  	unsigned int	is_added:1;
>  	unsigned int	is_busmaster:1; /* device is busmaster */
>  	unsigned int	no_msi:1;	/* device may not use msi */
> -	unsigned int	block_ucfg_access:1;	/* userspace config space access is blocked */
> +	unsigned int	block_cfg_access:1;	/* config space access is blocked */
>  	unsigned int	broken_parity_status:1;	/* Device generates false positive parity */
>  	unsigned int	irq_reroute_variant:2;	/* device needs IRQ rerouting variant */
>  	unsigned int 	msi_enabled:1;
> @@ -1079,8 +1079,9 @@ int  ht_create_irq(struct pci_dev *dev, int idx);
>  void ht_destroy_irq(unsigned int irq);
>  #endif /* CONFIG_HT_IRQ */
>  
> -extern void pci_block_user_cfg_access(struct pci_dev *dev);
> -extern void pci_unblock_user_cfg_access(struct pci_dev *dev);
> +extern void pci_block_cfg_access(struct pci_dev *dev);
> +extern int pci_block_cfg_access_in_atomic(struct pci_dev *dev);
> +extern void pci_unblock_cfg_access(struct pci_dev *dev);
>  
>  /*
>   * PCI domain support.  Sometimes called PCI segment (eg by ACPI),
> @@ -1277,10 +1278,13 @@ static inline void pci_release_regions(struct pci_dev *dev)
>  
>  #define pci_dma_burst_advice(pdev, strat, strategy_parameter) do { } while (0)
>  
> -static inline void pci_block_user_cfg_access(struct pci_dev *dev)
> +static inline void pci_block_cfg_access(struct pci_dev *dev)
>  { }
>  
> -static inline void pci_unblock_user_cfg_access(struct pci_dev *dev)
> +static inline int pci_block_cfg_access_in_atomic(struct pci_dev *dev)
> +{ return 0; }
> +
> +static inline void pci_unblock_cfg_access(struct pci_dev *dev)
>  { }
>  
>  static inline struct pci_bus *pci_find_next_bus(const struct pci_bus *from)
> -- 
> 1.7.3.4
