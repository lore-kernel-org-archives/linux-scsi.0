From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: Broken pci_block_user_cfg_access interface
Date: Mon, 29 Aug 2011 18:58:35 +0300
Message-ID: <20110829155835.GB7480@redhat.com>
References: <20110829150552.GA6851@redhat.com>
 <4E5BB358.3060705@siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4E5BB358.3060705@siemens.com>
Sender: linux-pci-owner@vger.kernel.org
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Brian King <brking@us.ibm.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, "Hans J. Koch" <hjk@hansjkoch.de>, Greg Kroah-Hartman <gregkh@suse.de>, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, kvm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Aug 29, 2011 at 05:42:16PM +0200, Jan Kiszka wrote:
> On 2011-08-29 17:05, Michael S. Tsirkin wrote:
> > So how about something like the following?
> > Compile tested only, and I'm not sure I got the
> > ipr and iov error handling right.
> > Comments?
> 
> This still doesn't synchronize two callers of pci_block_user_cfg_access
> unless one was reset. We may not have such a scenario yet, but that's
> how the old code started as well...
> 
> And it makes the interface more convoluted (from 10000 meter, why should
> pci_block_user_cfg_access return an error if reset is running?).

Well I made the error EIO but it really is something like
EAGAIN which means 'I would block if I could, but I was
asked not to'.

> > 
> > ---->
> > Subject: [PATCH] pci: fail block usercfg access on reset
> > 
> > Anyone who wants to block usercfg access will
> > also want to block reset from userspace.
> > On the other hand, reset from userspace
> > should block any other access from userspace.
> > 
> > Finally, make it possible to detect reset in
> > pregress by returning an error status from
> > pci_block_user_cfg_access.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  drivers/pci/access.c          |   45 ++++++++++++++++++++++++++++++++++++----
> >  drivers/pci/iov.c             |   19 ++++++++++++----
> >  drivers/pci/pci.c             |    4 +-
> >  drivers/scsi/ipr.c            |   22 ++++++++++++++++++-
> >  drivers/uio/uio_pci_generic.c |    7 +++++-
> >  include/linux/pci.h           |    6 ++++-
> >  6 files changed, 87 insertions(+), 16 deletions(-)
> > 
> > diff --git a/drivers/pci/access.c b/drivers/pci/access.c
> > index fdaa42a..2492365 100644
> > --- a/drivers/pci/access.c
> > +++ b/drivers/pci/access.c
> > @@ -139,7 +139,7 @@ static noinline void pci_wait_ucfg(struct pci_dev *dev)
> >  		raw_spin_unlock_irq(&pci_lock);
> >  		schedule();
> >  		raw_spin_lock_irq(&pci_lock);
> > -	} while (dev->block_ucfg_access);
> > +	} while (dev->block_ucfg_access || dev->reset_in_progress);
> >  	__remove_wait_queue(&pci_ucfg_wait, &wait);
> >  }
> >  
> > @@ -153,7 +153,8 @@ int pci_user_read_config_##size						\
> >  	if (PCI_##size##_BAD)						\
> >  		return -EINVAL;						\
> >  	raw_spin_lock_irq(&pci_lock);				\
> > -	if (unlikely(dev->block_ucfg_access)) pci_wait_ucfg(dev);	\
> > +	if (unlikely(dev->block_ucfg_access || dev->reset_in_progress)) \
> > +		pci_wait_ucfg(dev);					\
> >  	ret = dev->bus->ops->read(dev->bus, dev->devfn,			\
> >  					pos, sizeof(type), &data);	\
> >  	raw_spin_unlock_irq(&pci_lock);				\
> > @@ -171,8 +172,9 @@ int pci_user_write_config_##size					\
> >  	int ret = -EIO;							\
> >  	if (PCI_##size##_BAD)						\
> >  		return -EINVAL;						\
> > -	raw_spin_lock_irq(&pci_lock);				\
> > -	if (unlikely(dev->block_ucfg_access)) pci_wait_ucfg(dev);	\
> > +	raw_spin_lock_irq(&pci_lock);					\
> > +	if (unlikely(dev->block_ucfg_access || dev->reset_in_progress)) \
> > +		pci_wait_ucfg(dev);					\
> >  	ret = dev->bus->ops->write(dev->bus, dev->devfn,		\
> >  					pos, sizeof(type), val);	\
> >  	raw_spin_unlock_irq(&pci_lock);				\
> > @@ -408,19 +410,24 @@ EXPORT_SYMBOL(pci_vpd_truncate);
> >   * sleep until access is unblocked again.  We don't allow nesting of
> >   * block/unblock calls.
> >   */
> > -void pci_block_user_cfg_access(struct pci_dev *dev)
> > +int pci_block_user_cfg_access(struct pci_dev *dev)
> >  {
> >  	unsigned long flags;
> >  	int was_blocked;
> > +	int in_progress;
> >  
> >  	raw_spin_lock_irqsave(&pci_lock, flags);
> >  	was_blocked = dev->block_ucfg_access;
> >  	dev->block_ucfg_access = 1;
> > +	in_progress = dev->reset_in_progress;
> >  	raw_spin_unlock_irqrestore(&pci_lock, flags);
> >  
> > +	if (in_progress)
> > +		return -EIO;
> >  	/* If we BUG() inside the pci_lock, we're guaranteed to hose
> >  	 * the machine */
> >  	BUG_ON(was_blocked);
> > +	return 0;
> >  }
> >  EXPORT_SYMBOL_GPL(pci_block_user_cfg_access);
> >  
> > @@ -445,3 +452,31 @@ void pci_unblock_user_cfg_access(struct pci_dev *dev)
> >  	raw_spin_unlock_irqrestore(&pci_lock, flags);
> >  }
> >  EXPORT_SYMBOL_GPL(pci_unblock_user_cfg_access);
> > +
> > +void pci_reset_start(struct pci_dev *dev)
> > +{
> > +	int was_started;
> > +
> > +	raw_spin_lock_irq(&pci_lock);
> > +	if (unlikely(dev->block_ucfg_access || dev->reset_in_progress))
> > +		pci_wait_ucfg(dev);
> > +	was_started = dev->reset_in_progress;
> > +	dev->reset_in_progress = 1;
> > +	raw_spin_unlock_irq(&pci_lock);
> > +
> > +	/* If we BUG() inside the pci_lock, we're guaranteed to hose
> > +	 * the machine */
> > +	BUG_ON(was_started);
> > +}
> > +void pci_reset_end(struct pci_dev *dev)
> > +{
> > +	raw_spin_lock_irq(&pci_lock);
> > +
> > +	/* This indicates a problem in the caller, but we don't need
> > +	 * to kill them, unlike a double-reset above. */
> > +	WARN_ON(!dev->reset_in_progress);
> > +
> > +	dev->reset_in_progress = 0;
> > +	wake_up_all(&pci_ucfg_wait);
> > +	raw_spin_unlock_irq(&pci_lock);
> > +}
> > diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
> > index 42fae47..464d9b5 100644
> > --- a/drivers/pci/iov.c
> > +++ b/drivers/pci/iov.c
> > @@ -275,7 +275,7 @@ static void sriov_disable_migration(struct pci_dev *dev)
> >  
> >  static int sriov_enable(struct pci_dev *dev, int nr_virtfn)
> >  {
> > -	int rc;
> > +	int rc, rc1;
> >  	int i, j;
> >  	int nres;
> >  	u16 offset, stride, initial;
> > @@ -340,7 +340,10 @@ static int sriov_enable(struct pci_dev *dev, int nr_virtfn)
> >  	}
> >  
> >  	iov->ctrl |= PCI_SRIOV_CTRL_VFE | PCI_SRIOV_CTRL_MSE;
> > -	pci_block_user_cfg_access(dev);
> > +	rc = pci_block_user_cfg_access(dev);
> > +	if (rc)
> > +		goto err;
> > +
> >  	pci_write_config_word(dev, iov->pos + PCI_SRIOV_CTRL, iov->ctrl);
> >  	msleep(100);
> >  	pci_unblock_user_cfg_access(dev);
> > @@ -371,11 +374,14 @@ failed:
> >  		virtfn_remove(dev, j, 0);
> >  
> >  	iov->ctrl &= ~(PCI_SRIOV_CTRL_VFE | PCI_SRIOV_CTRL_MSE);
> > -	pci_block_user_cfg_access(dev);
> > +	rc1 = pci_block_user_cfg_access(dev);
> > +	if (rc1)
> > +		goto err;
> >  	pci_write_config_word(dev, iov->pos + PCI_SRIOV_CTRL, iov->ctrl);
> >  	ssleep(1);
> >  	pci_unblock_user_cfg_access(dev);
> >  
> > +err:
> >  	if (iov->link != dev->devfn)
> >  		sysfs_remove_link(&dev->dev.kobj, "dep_link");
> >  
> > @@ -384,7 +390,7 @@ failed:
> >  
> >  static void sriov_disable(struct pci_dev *dev)
> >  {
> > -	int i;
> > +	int i, rc;
> >  	struct pci_sriov *iov = dev->sriov;
> >  
> >  	if (!iov->nr_virtfn)
> > @@ -397,11 +403,14 @@ static void sriov_disable(struct pci_dev *dev)
> >  		virtfn_remove(dev, i, 0);
> >  
> >  	iov->ctrl &= ~(PCI_SRIOV_CTRL_VFE | PCI_SRIOV_CTRL_MSE);
> > -	pci_block_user_cfg_access(dev);
> > +	rc = pci_block_user_cfg_access(dev);
> > +	if (rc)
> > +		goto err;
> >  	pci_write_config_word(dev, iov->pos + PCI_SRIOV_CTRL, iov->ctrl);
> >  	ssleep(1);
> >  	pci_unblock_user_cfg_access(dev);
> >  
> > +err:
> >  	if (iov->link != dev->devfn)
> >  		sysfs_remove_link(&dev->dev.kobj, "dep_link");
> >  
> > diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> > index 0ce6742..815efc2 100644
> > --- a/drivers/pci/pci.c
> > +++ b/drivers/pci/pci.c
> > @@ -2959,7 +2959,7 @@ static int pci_dev_reset(struct pci_dev *dev, int probe)
> >  	might_sleep();
> >  
> >  	if (!probe) {
> > -		pci_block_user_cfg_access(dev);
> > +		pci_reset_start(dev);
> >  		/* block PM suspend, driver probe, etc. */
> >  		device_lock(&dev->dev);
> >  	}
> > @@ -2984,7 +2984,7 @@ static int pci_dev_reset(struct pci_dev *dev, int probe)
> >  done:
> >  	if (!probe) {
> >  		device_unlock(&dev->dev);
> > -		pci_unblock_user_cfg_access(dev);
> > +		pci_reset_end(dev);
> >  	}
> >  
> >  	return rc;
> > diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
> > index 8d63630..d322da3 100644
> > --- a/drivers/scsi/ipr.c
> > +++ b/drivers/scsi/ipr.c
> > @@ -7661,7 +7661,9 @@ static int ipr_reset_start_bist(struct ipr_cmnd *ipr_cmd)
> >  	int rc = PCIBIOS_SUCCESSFUL;
> >  
> >  	ENTER;
> > -	pci_block_user_cfg_access(ioa_cfg->pdev);
> > +	rc = pci_block_user_cfg_access(ioa_cfg->pdev);
> > +	if (rc)
> > +		goto err;
> >  
> >  	if (ioa_cfg->ipr_chip->bist_method == IPR_MMIO)
> >  		writel(IPR_UPROCI_SIS64_START_BIST,
> > @@ -7681,6 +7683,13 @@ static int ipr_reset_start_bist(struct ipr_cmnd *ipr_cmd)
> >  
> >  	LEAVE;
> >  	return rc;
> > +
> > +err:
> > +
> > +	ipr_cmd->s.ioasa.hdr.ioasc = cpu_to_be32(IPR_IOASC_PCI_ACCESS_ERROR);
> > +	rc = IPR_RC_JOB_CONTINUE;
> > +	LEAVE;
> > +	return rc;
> >  }
> >  
> >  /**
> > @@ -7715,14 +7724,23 @@ static int ipr_reset_slot_reset(struct ipr_cmnd *ipr_cmd)
> >  {
> >  	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
> >  	struct pci_dev *pdev = ioa_cfg->pdev;
> > +	int rc;
> >  
> >  	ENTER;
> > -	pci_block_user_cfg_access(pdev);
> > +	rc = pci_block_user_cfg_access(pdev);
> > +	if (rc)
> > +		goto err;
> 
> Looks like the target for this jump is missing.
> 
> > +
> >  	pci_set_pcie_reset_state(pdev, pcie_warm_reset);
> >  	ipr_cmd->job_step = ipr_reset_slot_reset_done;
> >  	ipr_reset_start_timer(ipr_cmd, IPR_PCI_RESET_TIMEOUT);
> >  	LEAVE;
> >  	return IPR_RC_JOB_RETURN;
> > +
> > +	ipr_cmd->s.ioasa.hdr.ioasc = cpu_to_be32(IPR_IOASC_PCI_ACCESS_ERROR);
> > +	rc = IPR_RC_JOB_CONTINUE;
> > +	LEAVE;
> > +	return rc;
> >  }
> >  
> >  /**
> > diff --git a/drivers/uio/uio_pci_generic.c b/drivers/uio/uio_pci_generic.c
> > index fc22e1e..a26d35f 100644
> > --- a/drivers/uio/uio_pci_generic.c
> > +++ b/drivers/uio/uio_pci_generic.c
> > @@ -51,6 +51,7 @@ static irqreturn_t irqhandler(int irq, struct uio_info *info)
> >  	irqreturn_t ret = IRQ_NONE;
> >  	u32 cmd_status_dword;
> >  	u16 origcmd, newcmd, status;
> > +	int r;
> >  
> >  	/* We do a single dword read to retrieve both command and status.
> >  	 * Document assumptions that make this possible. */
> > @@ -58,7 +59,9 @@ static irqreturn_t irqhandler(int irq, struct uio_info *info)
> >  	BUILD_BUG_ON(PCI_COMMAND + 2 != PCI_STATUS);
> >  
> >  	spin_lock_irq(&gdev->lock);
> > -	pci_block_user_cfg_access(pdev);
> > +	r = pci_block_user_cfg_access(pdev);
> > +	if (r < 0)
> > +		goto err;
> >  
> >  	/* Read both command and status registers in a single 32-bit operation.
> >  	 * Note: we could cache the value for command and move the status read
> > @@ -83,6 +86,8 @@ static irqreturn_t irqhandler(int irq, struct uio_info *info)
> >  done:
> >  
> >  	pci_unblock_user_cfg_access(pdev);
> > +err:
> > +
> >  	spin_unlock_irq(&gdev->lock);
> >  	return ret;
> >  }
> > diff --git a/include/linux/pci.h b/include/linux/pci.h
> > index 8c230cb..ec3b8fe 100644
> > --- a/include/linux/pci.h
> > +++ b/include/linux/pci.h
> > @@ -322,6 +322,7 @@ struct pci_dev {
> >  	unsigned int    is_hotplug_bridge:1;
> >  	unsigned int    __aer_firmware_first_valid:1;
> >  	unsigned int	__aer_firmware_first:1;
> > +	unsigned int	reset_in_progress:1;
> >  	pci_dev_flags_t dev_flags;
> >  	atomic_t	enable_cnt;	/* pci_enable_device has been called */
> >  
> > @@ -1079,9 +1080,12 @@ int  ht_create_irq(struct pci_dev *dev, int idx);
> >  void ht_destroy_irq(unsigned int irq);
> >  #endif /* CONFIG_HT_IRQ */
> >  
> > -extern void pci_block_user_cfg_access(struct pci_dev *dev);
> > +extern int pci_block_user_cfg_access(struct pci_dev *dev);
> >  extern void pci_unblock_user_cfg_access(struct pci_dev *dev);
> >  
> > +extern void pci_reset_start(struct pci_dev *dev);
> > +extern void pci_reset_end(struct pci_dev *dev);
> > +
> >  /*
> >   * PCI domain support.  Sometimes called PCI segment (eg by ACPI),
> >   * a PCI domain is defined to be a set of PCI busses which share
> 
> I still don't get what prevents converting ipr to allow plain mutex
> synchronization. My vision is:
>  - push reset-on-error of ipr into workqueue (or threaded IRQ?)
>  - require mutex synchronization for common config space access

Meaning pci_user_ read/write config?

>     and the
>    full reset cycle
>  - only exception: INTx status/masking access
>     => use pci_lock + test for reset_in_progress, skip operation if
>        that is the case
> 
> That would allow to drop the whole block_user_cfg infrastructure.
> 
> Jan

We still need to block userspace access while INTx does
the status/masking access, right?




> -- 
> Siemens AG, Corporate Technology, CT T DE IT 1
> Corporate Competence Center Embedded Linux
