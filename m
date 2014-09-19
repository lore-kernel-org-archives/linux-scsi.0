From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 4/4] target: Add a user-passthrough backstore
Date: Fri, 19 Sep 2014 14:14:39 -0700
Message-ID: <1411161279.23258.26.camel@haakon3.risingtidesystems.com>
References: <1410822750-10717-1-git-send-email-agrover@redhat.com>
	 <1410822750-10717-5-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:39503 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757837AbaISVOu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Sep 2014 17:14:50 -0400
In-Reply-To: <1410822750-10717-5-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de, shli@kernel.org, linux-kernel@vger.kernel.org, rjones@redhat.com

Hi Andy,

A few comments are inline below.

On Mon, 2014-09-15 at 16:12 -0700, Andy Grover wrote:
> Add a LIO storage engine that presents commands to userspace for execution.
> This would allow more complex backstores to be implemented out-of-kernel,
> and also make experimentation a-la FUSE (but at the SCSI level -- "SUSE"?)
> possible.
> 
> It uses a mmap()able UIO device per LUN to share a command ring and data
> area. The commands are raw SCSI CDBs and iovs for in/out data. The command
> ring is also reused for returning scsi command status and optional sense
> data.
> 
> This implementation is based on Shaohua Li's earlier version but heavily
> modified. Differences include:
> 
> * Shared memory allocated by kernel, not locked-down user pages
> * Single ring for command request and response
> * Offsets instead of embedded pointers
> * Generic SCSI CDB passthrough instead of per-cmd specialization in ring
>   format.
> * Uses UIO device instead of anon_file passed in mailbox.
> * Optional in-kernel handling of some commands.
> 

Shaohua, do you have any comments are these changes..?  It's not clear
that all of these changes are beneficial, so I'd really like to hear
input given your the original author of this code.

> The main reason for these differences is to permit greater resiliency
> if the user process dies or hangs.
> 
> Things not yet implemented (on purpose):
> 
> * Zero copy. The data area is flexible enough to allow page flipping or
>   backend-allocated pages to be used by fabrics, but it's not clear these
>   are performance wins. Can come later.
> * Out-of-order command completion by userspace. Possible to add by just
>   allowing userspace to change cmd_id in rsp cmd entries, but currently
>   not supported.
> * No locks between kernel cmd submission and completion routines. Sounds
>   like it's possible, but this can come later.
> * Sparse allocation of mmaped area. Current code vmallocs the whole thing.
>   If the mapped area was larger and not fully mapped then the driver would
>   have more freedom to change cmd and data area sizes based on demand.
> 
> Current code open issues:
> 
> * The use of idrs may be overkill -- we maybe can replace them with a
>   simple counter to generate cmd_ids, and a hash table to get a cmd_id's
>   associated pointer.
> * Use of a free-running counter for cmd ring instead of explicit modulo
>   math. This would require power-of-2 cmd ring size.
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  drivers/target/Kconfig                 |    5 +
>  drivers/target/Makefile                |    1 +
>  drivers/target/target_core_transport.c |    4 +
>  drivers/target/target_core_user.c      | 1169 ++++++++++++++++++++++++++++++++
>  include/uapi/linux/Kbuild              |    1 +
>  include/uapi/linux/target_core_user.h  |  142 ++++
>  6 files changed, 1322 insertions(+)
>  create mode 100644 drivers/target/target_core_user.c
>  create mode 100644 include/uapi/linux/target_core_user.h
> 

<SNIP>

> +
> +/* Core requires execute_rw be set, but just return unsupported */
> +static sense_reason_t
> +tcmu_retry_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
> +	      enum dma_data_direction data_direction)
> +{
> +	return TCM_UNSUPPORTED_SCSI_OPCODE;
> +}
> +
> +static struct sbc_ops tcmu_retry_ops = {
> +	.execute_rw		= tcmu_retry_rw,
> +};
> +
> +static void tcmu_work(struct work_struct *work)
> +{
> +	struct tcmu_cmd *cmd = container_of(work, struct tcmu_cmd, work);
> +	struct se_cmd *se_cmd = cmd->se_cmd;
> +
> +	target_execute_cmd(se_cmd);
> +	kmem_cache_free(tcmu_cmd_cache, cmd);
> +}
> +
> +static void tcmu_emulate_cmd(struct tcmu_cmd *cmd)
> +{
> +	struct se_cmd *se_cmd = cmd->se_cmd;
> +	sense_reason_t ret;
> +	unsigned long flags;
> +
> +	/* Re-run parsing to set execute_cmd to value for possible emulation */
> +	se_cmd->execute_cmd = NULL;
> +
> +	/*
> +	 * Can't optionally call generic_request_failure if flags indicate it's
> +	 * still being handled by us.
> +	*/
> +	spin_lock_irqsave(&se_cmd->t_state_lock, flags);
> +	se_cmd->transport_state &= ~CMD_T_BUSY|CMD_T_SENT;
> +	spin_unlock_irqrestore(&se_cmd->t_state_lock, flags);
> +
> +	ret = sbc_parse_cdb(se_cmd, &tcmu_retry_ops);
> +	if (ret == TCM_NO_SENSE && se_cmd->execute_cmd) {
> +		schedule_work(&cmd->work);
> +	} else {
> +		/* Can't emulate. */
> +		transport_generic_request_failure(se_cmd, ret);
> +		kmem_cache_free(tcmu_cmd_cache, cmd);
> +	}
> +}

So the idea of allowing the in-kernel CDB emulation to run after
user-space has returned unsupported opcode is problematic for a couple
of different reasons.

First, if the correct feature bits in standard INQUIRY + EVPD INQUIRY,
etc are not populated by user-space to match what in-kernel CDB
emulation actually supports, this can result in potentially undefined
results initiator side.

Also for example, if user-space decided to emulate only a subset of PR
operations, and leaves the rest of it up to the in-kernel emulation,
there's not really a way to sync current state between the two, which
also can end up with undefined results.

So that said, I think a saner approach would be two define two modes of
operation for TCMU:

   *) Passthrough Mode: All CDBs are passed to user-space, and no 
      in-kernel emulation is done in the event of an unsupported
      opcode response.

   *) I/O Mode: I/O related CDBs are passed into user-space, but
      all control CDBs continue to be processed by in-kernel emulation.
      This effectively limits operation to TYPE_DISK, but with this mode
      it's probably OK to assume this. 

This seems like the best trade-off between flexibility when everything
should be handled by user-space, vs. functionality when only block
remapping of I/O is occurring in user-space code.

> +static int tcmu_check_expired_cmd(int id, void *p, void *data)
> +{
> +	struct tcmu_cmd *cmd = p;
> +
> +	if (test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags))
> +		return 0;
> +
> +	if (!time_after(cmd->deadline, jiffies))
> +		return 0;
> +
> +	set_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags);
> +	target_complete_cmd(cmd->se_cmd, SAM_STAT_CHECK_CONDITION);
> +	cmd->se_cmd = NULL;
> +

AFAICT this is leaking tcmu_cmd..

Where does tcmu_cmd get released for expired commands..?

> +	return 0;
> +}
> +
> +static void tcmu_device_timedout(unsigned long data)
> +{
> +	struct tcmu_dev *udev = (struct tcmu_dev *)data;
> +	unsigned long flags;
> +	int handled;
> +
> +	handled = tcmu_handle_completions(udev);
> +
> +	pr_warn("%d completions handled from timeout\n", handled);
> +
> +	spin_lock_irqsave(&udev->commands_lock, flags);
> +	idr_for_each(&udev->commands, tcmu_check_expired_cmd, NULL);
> +	spin_unlock_irqrestore(&udev->commands_lock, flags);
> +
> +	/*
> +	 * We don't need to wakeup threads on wait_cmdr since they have their
> +	 * own timeout.
> +	 */
> +}
> +
> +static int tcmu_attach_hba(struct se_hba *hba, u32 host_id)
> +{
> +	struct tcmu_hba *tcmu_hba;
> +
> +	tcmu_hba = kzalloc(sizeof(struct tcmu_hba), GFP_KERNEL);
> +	if (!tcmu_hba)
> +		return -ENOMEM;
> +
> +	tcmu_hba->host_id = host_id;
> +	hba->hba_ptr = tcmu_hba;
> +
> +	return 0;
> +}
> +
> +static void tcmu_detach_hba(struct se_hba *hba)
> +{
> +	kfree(hba->hba_ptr);
> +	hba->hba_ptr = NULL;
> +}
> +
> +static struct se_device *tcmu_alloc_device(struct se_hba *hba, const char *name)
> +{
> +	struct tcmu_dev *udev;
> +
> +	udev = kzalloc(sizeof(struct tcmu_dev), GFP_KERNEL);
> +	if (!udev)
> +		return NULL;
> +
> +	udev->name = kstrdup(name, GFP_KERNEL);
> +	if (!udev->name) {
> +		kfree(udev);
> +		return NULL;
> +	}
> +
> +	udev->hba = hba;
> +
> +	init_waitqueue_head(&udev->wait_cmdr);
> +	spin_lock_init(&udev->cmdr_lock);
> +
> +	idr_init(&udev->commands);
> +	spin_lock_init(&udev->commands_lock);
> +
> +	setup_timer(&udev->timeout, tcmu_device_timedout,
> +		(unsigned long)udev);
> +
> +	kref_init(&udev->ref);
> +

udev->ref is unnecessary. 

> +	return &udev->se_dev;
> +}

<SNIP>

> +static int tcmu_configure_device(struct se_device *dev)
> +{
> +	struct tcmu_dev *udev = TCMU_DEV(dev);
> +	struct tcmu_hba *hba = udev->hba->hba_ptr;
> +	struct uio_info *info;
> +	struct tcmu_mailbox *mb;
> +	size_t size;
> +	size_t used;
> +	int ret = 0;
> +	char *str;
> +
> +	info = &udev->uio_info;
> +
> +	size = snprintf(NULL, 0, "tcm-user/%u/%s/%s", hba->host_id, udev->name, udev->dev_config);
> +	size += 1; /* for \0 */
> +	str = kmalloc(size, GFP_KERNEL);
> +	if (!str)
> +		return -ENOMEM;
> +
> +	used = snprintf(str, size, "tcm-user/%u/%s", hba->host_id, udev->name);
> +
> +	if (udev->dev_config[0])
> +		snprintf(str + used, size - used, "/%s", udev->dev_config);
> +
> +	info->name = str;
> +
> +	udev->mb_addr = vzalloc(TCMU_RING_SIZE);
> +	if (!udev->mb_addr) {
> +		kfree(info->name);
> +		return -ENOMEM;
> +	}
> +
> +	/* mailbox fits in first part of CMDR space */
> +	udev->cmdr_size = CMDR_SIZE - CMDR_OFF;
> +	udev->data_off = CMDR_SIZE;
> +	udev->data_size = TCMU_RING_SIZE - CMDR_SIZE;
> +
> +	mb = udev->mb_addr;
> +	mb->version = 1;
> +	mb->cmdr_off = CMDR_OFF;
> +	mb->cmdr_size = udev->cmdr_size;
> +
> +	WARN_ON(!PAGE_ALIGNED(udev->data_off));
> +	WARN_ON(udev->data_size % PAGE_SIZE);
> +
> +	info->version = "1";
> +
> +	info->mem[0].name = "tcm-user command & data buffer";
> +	info->mem[0].addr = (phys_addr_t) udev->mb_addr;
> +	info->mem[0].size = TCMU_RING_SIZE;
> +	info->mem[0].memtype = UIO_MEM_VIRTUAL;
> +
> +	info->irqcontrol = tcmu_irqcontrol;
> +	info->irq = UIO_IRQ_CUSTOM;
> +
> +	info->mmap = tcmu_mmap;
> +	info->open = tcmu_open;
> +	info->release = tcmu_release;
> +
> +	ret = uio_register_device(tcmu_root_device, info);
> +	if (ret) {
> +		kfree(info->name);
> +		vfree(udev->mb_addr);
> +		return ret;
> +	}
> +
> +	/* Other attributes can be configured in userspace */
> +	dev->dev_attrib.hw_block_size = 4096;

Assuming 4k hw_block_size by default is problematic for initiators that
don't support it.

Switch to 512 blocksize by default to be safe.

> +	dev->dev_attrib.hw_max_sectors = 128;
> +	dev->dev_attrib.hw_queue_depth = 128;
> +
> +	tcmu_netlink_event(TCMU_CMD_ADDED_DEVICE, udev->uio_info.name,
> +			   udev->uio_info.uio_dev->minor);
> +
> +	return ret;
> +}
> +
> +static int tcmu_check_pending_cmd(int id, void *p, void *data)
> +{
> +	struct tcmu_cmd *cmd = p;
> +
> +	if (test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags))
> +		return 0;
> +	return -EINVAL;
> +}
> +
> +static void tcmu_free_device(struct se_device *dev)
> +{
> +	int i;
> +	struct tcmu_dev *udev = TCMU_DEV(dev);
> +
> +	del_timer_sync(&udev->timeout);
> +
> +	vfree(udev->mb_addr);
> +
> +	/* upper layer should drain all requests before calling this */
> +	spin_lock_irq(&udev->commands_lock);
> +	i = idr_for_each(&udev->commands, tcmu_check_pending_cmd, NULL);
> +	idr_destroy(&udev->commands);
> +	spin_unlock_irq(&udev->commands_lock);
> +	WARN_ON(i);
> +
> +	tcmu_netlink_event(TCMU_CMD_REMOVED_DEVICE, udev->uio_info.name,
> +			   udev->uio_info.uio_dev->minor);
> +
> +	uio_unregister_device(&udev->uio_info);
> +
> +	kfree(udev->uio_info.name);
> +
> +	kfree(udev->name);
> +
> +	kref_put(&udev->ref, tcmu_destroy_device);
> +}
> +

The udev->ref here looks unnecessary, just release udev now.


