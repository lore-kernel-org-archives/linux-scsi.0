From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: [GIT PATCH v4 0/2] libsas: eh reworks (ata-eh vs discovery, races, ...)
Date: Fri, 13 Jan 2012 08:57:25 +0800
Message-ID: <9095644D6BEB42D8ADE7EB255D282AE8@usish.com.cn>
References: <20120110073647.4563.7504.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:39698 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756490Ab2AMA6y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jan 2012 19:58:54 -0500
In-Reply-To: <20120110073647.4563.7504.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Dan Williams' <dan.j.williams@intel.com>, linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org

Hi Dan,

Thanks for your fix, I do test this with new patchset, this works good for
me.
Only one thing confuse me, kernel sometimes print cmd timed out when disk
attached.
Like :
"
[  312.732468] sd 4:0:11:0: [sdl] command ffff88032c6eaa00 timed out
[  312.753114] sd 4:0:13:0: [sdn] command ffff88032c6eb000 timed out
[  312.753257] sd 4:0:4:0: [sde] command ffff88032903e800 timed out
[  312.753266] sd 4:0:14:0: [sdo] command ffff880329284c00 timed out
[  312.755304] sd 4:0:1:0: [sdb] command ffff8801b4b80600 timed out
[  312.797458] sd 4:0:15:0: [sdp] command ffff880329285900 timed out
"
Although, this is no harm.

Jack
> 
> The latest version of the patch kit is available here:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git
> libsas-eh-reworks-v4
> 
> Changes since v3: http://marc.info/?l=linux-scsi&m=132581455214789&w=2
> 
> 1/ null pointer regression smp_execute_task: make sure device is not
>    removed from the domain while eh is in flight.  Fix up the logic that
>    defers domain_device destruction to its own context.  Folded into:
>    "libsas: prevent domain rediscovery competing with ata error handling"
>    plus a small prep patch: "libsas: convert dev->gone to flags"
> 
> 2/ lockdep regression in smp_execute_task: failed to release the lock
>    before returning.  Folded into: "libsas: check for 'gone' expanders in
>    smp_execute_task()"
> 
> 3/ unnecessary locking in isci_ata_check_ready().  Folded into: "isci:
>    ->lldd_ata_check_ready handler"
> 
> 4/ two new fixes follow in separate mails
>    [PATCH v4 1/2] libsas: pre-clean commands that won the eh vs completion
race
>    [PATCH v4 2/2] libsas: feed the scsi_block_when_processing_errors()
meter
> 
> Incremental diff: libsas-eh-reworks-v3..libsas-eh-reworks-v4
> 
> diff --git a/drivers/scsi/isci/port.c b/drivers/scsi/isci/port.c
> index e795645..eca9ba0 100644
> --- a/drivers/scsi/isci/port.c
> +++ b/drivers/scsi/isci/port.c
> @@ -1681,10 +1681,7 @@ int isci_ata_check_ready(struct domain_device *dev)
>  	if (test_bit(IPORT_RESET_PENDING, &iport->state))
>  		goto out;
> 
> -	/* snapshot active phy mask */
> -	spin_lock_irqsave(&ihost->scic_lock, flags);
>  	rc = !!iport->active_phy_mask;
> -	spin_unlock_irqrestore(&ihost->scic_lock, flags);
>   out:
>  	isci_put_device(idev);
> 
> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
> index f90fdcf..a062adc 100644
> --- a/drivers/scsi/libsas/sas_ata.c
> +++ b/drivers/scsi/libsas/sas_ata.c
> @@ -195,7 +195,7 @@ static unsigned int sas_ata_qc_issue(struct
ata_queued_cmd
> *qc)
>  	spin_unlock(ap->lock);
> 
>  	/* If the device fell off, no sense in issuing commands */
> -	if (dev->gone)
> +	if (test_bit(SAS_DEV_GONE, &dev->state))
>  		goto out;
> 
>  	task = sas_alloc_task(GFP_ATOMIC);
> @@ -327,7 +327,7 @@ static int sas_ata_hard_reset(struct ata_link *link,
> unsigned int *class,
>  	struct domain_device *dev = ap->private_data;
>  	struct sas_internal *i = dev_to_sas_internal(dev);
> 
> -	if (dev->gone)
> +	if (test_bit(SAS_DEV_GONE, &dev->state))
>  		return -ENODEV;
> 
>  	res = i->dft->lldd_I_T_nexus_reset(dev);
> @@ -663,6 +663,11 @@ static void async_sas_ata_eh(void *data,
async_cookie_t
> cookie)
> 
>  	ata_port_printk(ap, KERN_DEBUG, "sas eh calling libata port error
> handler");
>  	ata_scsi_port_error_handler(ha->core.shost, ap);
> +
> +	/* tell scsi_block_when_processing_errors() waiters that we are
> +	 * still making forward progress
> +	 */
> +	wake_up(&ha->core.shost->host_wait);
>  }
> 
>  void sas_ata_strategy_handler(struct Scsi_Host *shost)
> diff --git a/drivers/scsi/libsas/sas_discover.c
> b/drivers/scsi/libsas/sas_discover.c
> index 0b7555d..dfb0250 100644
> --- a/drivers/scsi/libsas/sas_discover.c
> +++ b/drivers/scsi/libsas/sas_discover.c
> @@ -269,17 +269,22 @@ static void sas_destruct_devices(struct work_struct
> *work)
> 
>  	clear_bit(DISCE_DESTRUCT, &port->disc.pending);
> 
> -	list_for_each_entry_safe(dev, n, &port->destroy_list, dev_list_node)
{
> +	list_for_each_entry_safe(dev, n, &port->destroy_list,
disco_list_node)
> {
> +		list_del_init(&dev->disco_list_node);
> +
>  		sas_remove_children(&dev->rphy->dev);
>  		sas_rphy_delete(dev->rphy);
>  		dev->rphy = NULL;
>  		sas_unregister_common_dev(port, dev);
> +
> +		sas_put_device(dev);
>  	}
>  }
> 
>  void sas_unregister_dev(struct asd_sas_port *port, struct domain_device
> *dev)
>  {
> -	if (!list_empty(&dev->disco_list_node)) {
> +	if (!test_bit(SAS_DEV_DESTROY, &dev->state) &&
> +	    !list_empty(&dev->disco_list_node)) {
>  		/* this rphy never saw sas_rphy_add */
>  		list_del_init(&dev->disco_list_node);
>  		sas_rphy_free(dev->rphy);
> @@ -287,13 +292,9 @@ void sas_unregister_dev(struct asd_sas_port *port,
struct
> domain_device *dev)
>  		sas_unregister_common_dev(port, dev);
>  	}
> 
> -	if (dev->rphy) {
> +	if (dev->rphy && !test_and_set_bit(SAS_DEV_DESTROY, &dev->state)) {
>  		sas_rphy_unlink(dev->rphy);
> -
> -		spin_lock_irq(&port->dev_list_lock);
> -		list_move_tail(&dev->dev_list_node, &port->destroy_list);
> -		spin_unlock_irq(&port->dev_list_lock);
> -
> +		list_move_tail(&dev->disco_list_node, &port->destroy_list);
>  		sas_discover_event(dev->port, DISCE_DESTRUCT);
>  	}
>  }
> diff --git a/drivers/scsi/libsas/sas_expander.c
> b/drivers/scsi/libsas/sas_expander.c
> index e47599b..68a80a0 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -74,8 +74,10 @@ static int smp_execute_task(struct domain_device *dev,
void
> *req, int req_size,
> 
>  	mutex_lock(&dev->ex_dev.cmd_mutex);
>  	for (retry = 0; retry < 3; retry++) {
> -		if (dev->gone)
> -			return -ECOMM;
> +		if (test_bit(SAS_DEV_GONE, &dev->state)) {
> +			res = -ECOMM;
> +			break;
> +		}
> 
>  		task = sas_alloc_task(GFP_KERNEL);
>  		if (!task) {
> @@ -1794,7 +1796,7 @@ static void sas_unregister_ex_tree(struct
asd_sas_port
> *port, struct domain_devi
>  	struct domain_device *child, *n;
> 
>  	list_for_each_entry_safe(child, n, &ex->children, siblings) {
> -		child->gone = 1;
> +		set_bit(SAS_DEV_GONE, &child->state);
>  		if (child->dev_type == EDGE_DEV ||
>  		    child->dev_type == FANOUT_DEV)
>  			sas_unregister_ex_tree(port, child);
> @@ -1815,7 +1817,7 @@ static void sas_unregister_devs_sas_addr(struct
> domain_device *parent,
>  			&ex_dev->children, siblings) {
>  			if (SAS_ADDR(child->sas_addr) ==
>  			    SAS_ADDR(phy->attached_sas_addr)) {
> -				child->gone = 1;
> +				set_bit(SAS_DEV_GONE, &child->state);
>  				if (child->dev_type == EDGE_DEV ||
>  				    child->dev_type == FANOUT_DEV)
>  					sas_unregister_ex_tree(parent->port,
child);
> diff --git a/drivers/scsi/libsas/sas_port.c
> b/drivers/scsi/libsas/sas_port.c
> index 36e2905..31adcd1 100644
> --- a/drivers/scsi/libsas/sas_port.c
> +++ b/drivers/scsi/libsas/sas_port.c
> @@ -168,7 +168,7 @@ void sas_deform_port(struct asd_sas_phy *phy, int
gone)
> 
>  	if (port->num_phys == 1) {
>  		if (dev && gone)
> -			dev->gone = 1;
> +			set_bit(SAS_DEV_GONE, &dev->state);
>  		sas_unregister_domain_devices(port);
>  		sas_port_delete(port->port);
>  		port->port = NULL;
> diff --git a/drivers/scsi/libsas/sas_scsi_host.c
> b/drivers/scsi/libsas/sas_scsi_host.c
> index 59a227d..731c892 100644
> --- a/drivers/scsi/libsas/sas_scsi_host.c
> +++ b/drivers/scsi/libsas/sas_scsi_host.c
> @@ -208,7 +208,7 @@ int sas_queuecommand(struct Scsi_Host *host, struct
> scsi_cmnd *cmd)
>  	int res = 0;
> 
>  	/* If the device fell off, no sense in issuing commands */
> -	if (dev->gone) {
> +	if (test_bit(SAS_DEV_GONE, &dev->state)) {
>  		cmd->result = DID_BAD_TARGET << 16;
>  		goto out_done;
>  	}
> @@ -249,8 +249,8 @@ out_done:
> 
>  static void sas_eh_finish_cmd(struct scsi_cmnd *cmd)
>  {
> -	struct sas_task *task = TO_SAS_TASK(cmd);
>  	struct sas_ha_struct *sas_ha = SHOST_TO_SAS_HA(cmd->device->host);
> +	struct sas_task *task = TO_SAS_TASK(cmd);
> 
>  	/* At this point, we only get called following an actual abort
>  	 * of the task, so we should be guaranteed not to be racing with
> @@ -267,9 +267,9 @@ static void sas_eh_finish_cmd(struct scsi_cmnd *cmd)
> 
>  static void sas_eh_defer_cmd(struct scsi_cmnd *cmd)
>  {
> -	struct sas_task *task = TO_SAS_TASK(cmd);
> -	struct domain_device *dev = task->dev;
> +	struct domain_device *dev = cmd_to_domain_dev(cmd);
>  	struct sas_ha_struct *ha = dev->port->ha;
> +	struct sas_task *task = TO_SAS_TASK(cmd);
> 
>  	if (!dev_is_sata(dev)) {
>  		sas_eh_finish_cmd(cmd);
> @@ -530,8 +530,9 @@ static int sas_eh_handle_sas_errors(struct Scsi_Host
> *shost,
>  	struct sas_internal *i = to_sas_internal(shost->transportt);
>  	unsigned long flags;
>  	struct sas_ha_struct *ha = SHOST_TO_SAS_HA(shost);
> +	LIST_HEAD(done);
> 
> -Again:
> +	/* clean out any commands that won the completion vs eh race */
>  	list_for_each_entry_safe(cmd, n, work_q, eh_entry) {
>  		struct domain_device *dev = cmd_to_domain_dev(cmd);
>  		struct sas_task *task;
> @@ -545,7 +546,12 @@ Again:
>  		spin_unlock_irqrestore(&dev->done_lock, flags);
> 
>  		if (!task)
> -			continue;
> +			list_move_tail(&cmd->eh_entry, &done);
> +	}
> +
> + Again:
> +	list_for_each_entry_safe(cmd, n, work_q, eh_entry) {
> +		struct sas_task *task = TO_SAS_TASK(cmd);
> 
>  		list_del_init(&cmd->eh_entry);
> 
> @@ -649,15 +655,16 @@ Again:
>  			goto clear_q;
>  		}
>  	}
> + out:
> +	list_splice_tail(&done, work_q);
>  	list_splice_tail_init(&ha->eh_ata_q, work_q);
>  	return list_empty(work_q);
> -clear_q:
> +
> + clear_q:
>  	SAS_DPRINTK("--- Exit %s -- clear_q\n", __func__);
>  	list_for_each_entry_safe(cmd, n, work_q, eh_entry)
>  		sas_eh_finish_cmd(cmd);
> -
> -	list_splice_tail_init(&ha->eh_ata_q, work_q);
> -	return list_empty(work_q);
> +	goto out;
>  }
> 
>  void sas_scsi_recover_host(struct Scsi_Host *shost)
> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
> index feb61a8..55bab86 100644
> --- a/include/scsi/libsas.h
> +++ b/include/scsi/libsas.h
> @@ -174,7 +174,11 @@ struct sata_device {
>  	struct ata_taskfile tf;
>  };
> 
> -/* ---------- Domain device ---------- */
> +enum {
> +	SAS_DEV_GONE,
> +	SAS_DEV_DESTROY,
> +};
> +
>  struct domain_device {
>  	spinlock_t done_lock;
>          enum sas_dev_type dev_type;
> @@ -191,7 +195,7 @@ struct domain_device {
>  	struct sas_phy *phy;
> 
>          struct list_head dev_list_node;
> -	struct list_head disco_list_node;
> +	struct list_head disco_list_node; /* awaiting probe or destruct */
> 
>          enum sas_protocol    iproto;
>          enum sas_protocol    tproto;
> @@ -209,7 +213,7 @@ struct domain_device {
>          };
> 
>          void *lldd_dev;
> -	int gone;
> +	unsigned long state;
>  	struct kref kref;
>  };
> 
> 
> The following changes since commit
5c41dc3a79150e93e5d050871a10b761be8281a1:
> 
>   [SCSI] lpfc 8.3.28: Update driver version to 8.3.28 (2011-12-15 10:57:45
> +0400)
> 
> are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git
> libsas-eh-reworks-v4
> 
> Dan Williams (36):
>       libsas: remove unused ata_task_resp fields
>       libsas: kill sas_slave_destroy
>       libsas: fix domain_device leak
>       libsas: fix leak of dev->sata_dev.identify_[packet_]device
>       libsas: replace event locks with atomic bitops
>       libsas: convert ha->state to flags
>       libsas: introduce sas_drain_work()
>       libsas: remove ata_port.lock management duties from lldds
>       libsas: convert dev->gone to flags
>       libsas: prevent domain rediscovery competing with ata error handling
>       libsas: use ->set_dmamode to notify lldds of NCQ parameters
>       libsas: kill invocation of scsi_eh_finish_cmd from sas_ata_task_done
>       libsas: close error handling vs sas_ata_task_done() race
>       libsas: prevent double completion of scmds from eh
>       libsas: fix timeout vs completion race
>       libsas: let libata handle command timeouts
>       libsas: defer SAS_TASK_NEED_DEV_RESET commands to libata
>       libsas: use libata-eh-reset for sata rediscovery fis transmit
failures
>       libsas: perform sas-transport resets in shost->workq context
>       libsas: execute transport link resets with libata-eh via host
workqueue
>       libsas: sas_phy_enable via transport_sas_phy_reset
>       libsas: async ata-eh
>       libsas: poll for ata device readiness after reset
>       libsas: don't mark expanders as gone when a child device is removed
>       libsas: check for 'gone' expanders in smp_execute_task()
>       libsas: fix sas_find_local_phy(), take phy references
>       libsas: don't recover 'gone' devices in sas_ata_hard_reset()
>       isci: kill iphy->isci_port lookups
>       isci: kill isci_port->status
>       isci: fix interpretation of "hard" reset
>       isci: stop interpreting ->lldd_lu_reset() as an ata soft-reset
>       isci: ->lldd_ata_check_ready handler
>       isci: remove bus and reset handlers
>       isci: remove IDEV_EH hack to disable "discovery-time" ata resets
>       libsas: pre-clean commands that won the eh vs completion race
>       libsas: feed the scsi_block_when_processing_errors() meter
> 
> Jeff Skirvin (2):
>       libsas: Remove redundant phy state notification calls.
>       libsas: add mutex for SMP task execution
> 
>  Documentation/scsi/libsas.txt       |   15 -
>  drivers/ata/libata-eh.c             |    1 +
>  drivers/ata/libata.h                |    1 -
>  drivers/scsi/aic94xx/aic94xx.h      |    2 +
>  drivers/scsi/aic94xx/aic94xx_dev.c  |   38 ++-
>  drivers/scsi/aic94xx/aic94xx_init.c |    5 +-
>  drivers/scsi/aic94xx/aic94xx_tmf.c  |    9 +-
>  drivers/scsi/isci/host.c            |    8 +-
>  drivers/scsi/isci/host.h            |   19 +-
>  drivers/scsi/isci/init.c            |   13 +-
>  drivers/scsi/isci/phy.c             |   18 +-
>  drivers/scsi/isci/phy.h             |    1 -
>  drivers/scsi/isci/port.c            |  217 ++++++------
>  drivers/scsi/isci/port.h            |   11 +-
>  drivers/scsi/isci/remote_device.c   |   32 +--
>  drivers/scsi/isci/remote_device.h   |    7 +-
>  drivers/scsi/isci/request.c         |  198 +----------
>  drivers/scsi/isci/request.h         |    9 +-
>  drivers/scsi/isci/task.c            |  158 ++-------
>  drivers/scsi/isci/task.h            |   40 --
>  drivers/scsi/libsas/sas_ata.c       |  692
> +++++++++++++++--------------------
>  drivers/scsi/libsas/sas_discover.c  |  152 +++++++--
>  drivers/scsi/libsas/sas_event.c     |   89 +++++-
>  drivers/scsi/libsas/sas_expander.c  |  113 ++++--
>  drivers/scsi/libsas/sas_init.c      |  192 +++++++++-
>  drivers/scsi/libsas/sas_internal.h  |   73 ++--
>  drivers/scsi/libsas/sas_phy.c       |   12 +-
>  drivers/scsi/libsas/sas_port.c      |   26 +-
>  drivers/scsi/libsas/sas_scsi_host.c |  320 +++++++---------
>  drivers/scsi/mvsas/mv_init.c        |    1 -
>  drivers/scsi/mvsas/mv_sas.c         |   11 +-
>  drivers/scsi/pm8001/pm8001_init.c   |    1 -
>  drivers/scsi/pm8001/pm8001_sas.c    |   29 +-
>  drivers/scsi/scsi_transport_sas.c   |   59 +++-
>  include/linux/libata.h              |    1 +
>  include/scsi/libsas.h               |   67 ++--
>  include/scsi/sas_ata.h              |   26 +-
>  include/scsi/scsi_transport_sas.h   |   12 +-
>  38 files changed, 1321 insertions(+), 1357 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

