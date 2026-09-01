Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC63409266
	for <linux-scsi@vger.kernel.org>; Tue,  1 Sep 2026 02:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788228423; cv=none; b=cFiGOvSwE6QJ9O8nHigi2V/lQq85qY75Hy6pDhMVuBnysXJ0vyZW1YhEy6huVoUKDP0YiTuTJgXUe4ZQ7BQUo+TrOZLGR9tdoXzc2YnVUJW4pGQblq7scorjlygX8tCrwxkTvDiscuLgqwdE07lf5FgALN9/X55Uxtwn6FPNs/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788228423; c=relaxed/simple;
	bh=Q+XjPZiBNNfsbqY6/1dgv3PAXGL+ps5gET1k8H6Hf6g=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RhoJeJErgFljy8FDt+qyhg4E7Mf8gX4IjaNbUtLOvrpmIVy4HFmREjRxCUrVKZqIkluWaubkOoDKdtO0E75bxOdE86vcQJ/G5s9yH9G7hKqcPckYxq2lsRB+mdTS3VpAyk1DDCWsYxEqH8KBrOCvmmShnGVG63HXheeSAnHfC9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gRK+ge83; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gRK+ge83"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 613891F00A3D;
	Tue,  1 Sep 2026 02:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788228414;
	bh=lFLbwDzPUOY2qg/JgVC6IxxQu+fbbVz7Wcn6AWG1fDs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gRK+ge83F6UQ1eP+jg3jE1pshOoyEIvJsnkEj+Vgn4XK5sxvQ82i+e5Bs39FzB8b0
	 sdI7amMfB1aawxS2TNjcBES0niefy6QsvU0cZ2jQ4cYMCbbp12XnbLUbA/1+A4pQkd
	 qcuTM1JtaiXmzarrWP1jsR1Y7GZMBSS9tp3Jx0+FO2p9pEemCMFs7F6LrFQfzvKXLE
	 52QCjVXYK/7jugxT/txzjB8SWBT0M2ZzkmzpIobs5UKUF2sISyT5+Yy0s4zjGW9j9i
	 DIBwx1a0qIuKQP3IT5DEZEZGqxS3wfUFsSaXDFFOpjWnQezM+n6j/Rhaq5zhY8dyuJ
	 VJhCbxalPIymQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] scsi: Initial commit of VirtIO PCIe Endpoint Driver
Reply-To: sashiko-reviews@lists.linux.dev
To: alistair23@gmail.com
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260901014650.2728658-3-alistair.francis@wdc.com>
References: <20260901014650.2728658-1-alistair.francis@wdc.com>
 <20260901014650.2728658-3-alistair.francis@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 01 Sep 2026 02:06:53 +0000
Message-Id: <20260901020654.613891F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 13 potential issue=
(s) to consider:
- [Critical] In-flight target commands are not aborted on device reset, cau=
sing them to perform DMA writes to stale physical addresses.
- [Critical] The `poll_vqs_work` delayed work unconditionally reschedules i=
tself, conflicting with teardown cancellation and causing Use-After-Free.
- [High] Out-of-bounds overwrite occurs in `scsit_pci_epf_add_irq_vector` w=
hen all IRQ slots are full.
- [High] Lack of cycle detection in `scsit_pci_epf_walk_chain` allows a mal=
icious host to cause memory exhaustion (OOM) via memory leaks.
- [High] A single unrecoverable DMA mapping failure will permanently stall =
the completion of all commands on the virtqueue and hang driver teardown.
- [High] Removing the Target Portal Group (TPG) via configfs causes a Use-A=
fter-Free if an EPF controller is actively bound to it.
- [High] Task Management Request (TMR) execution synchronously blocks the v=
irtqueue polling workqueue, stalling all queue processing.
- [High] Missing update of `VIRTIO_MSI_QUEUE_VECTOR` on `QUEUE_SEL` change =
causes cross-queue vector corruption.
- [High] Inverted logic in `scsit_pci_epf_poll_vqs_work()` intentionally bu=
sy-spins in a shared workqueue forever after 5 seconds of idle.
- [High] TOCTOU race in legacy virtio register polling causes dropped virtq=
ueue initializations.
- [High] Integer overflow in data length calculation allows bypassing MDTS =
limits and triggers oversized kernel allocations.
- [Medium] DMA channels and mutexes allocated during initialization are lea=
ked on subsequent setup errors.
- [Medium] The configuration polling thread is not pinned to a CPU, despite=
 commit message claims.
--

commit 1a946d7846a58534cb9d2163d0e106bf9f96907f
Author: Alistair Francis <alistair.francis@wdc.com>
Subject: scsi: Initial commit of VirtIO PCIe Endpoint Driver

This patch introduces a virtio-scsi target driver built on top of the PCI
Endpoint Function (EPF) framework. It exposes a virtio-scsi PCI device to
the remote host backed by configfs-configured LUNs.

>  2. We have to pin scsit_pci_epf_poll_cfg_thread() on a CPU in order to
>     respond fast enough to the host. This means we effectivly burn a CPU

[Severity: Medium]
The commit message claims the polling thread is pinned to a CPU, but looking
at scsit_pci_epf_start_ctrl(), kthread_run() is used without any CPU affini=
ty
assignment. Is this description accurate?

diff --git a/drivers/scsi/virtio-scsi-pci-epf.c b/drivers/scsi/virtio-scsi-=
pci-epf.c
--- /dev/null
+++ b/drivers/scsi/virtio-scsi-pci-epf.c
@@ -0,0 +1,3099 @@
[ ... ]
> +static struct scsit_pci_epf_irq_vector *
> +scsit_pci_epf_add_irq_vector(struct scsit_pci_epf_ctrl *ctrl, u16 vector)
> +{
> +	struct scsit_pci_epf_irq_vector *iv;
> +	int i;
> +
> +	mutex_lock(&ctrl->irq_lock);
> +
> +	iv =3D scsit_pci_epf_find_irq_vector(ctrl, vector);
> +	if (iv) {
> +		iv->ref++;
> +		goto unlock;
> +	}
> +
> +	for (i =3D 0; i < ctrl->nr_vqs; i++) {
> +		iv =3D &ctrl->irq_vectors[i];
> +		if (!iv->ref)
> +			break;
> +	}
> +
> +	if (WARN_ON_ONCE(!iv))
> +		goto unlock;
> +
> +	iv->ref =3D 1;
> +	iv->vector =3D vector;

[Severity: High]
Does this code corrupt memory when all IRQ slots are full?

When the host dynamically changes a queue's vector during runtime, and
the array eventually fills up, the loop will complete without hitting
the break statement. This leaves the iv pointer pointing to the last
element of the array (&ctrl->irq_vectors[ctrl->nr_vqs - 1]).

Since iv is non-NULL, the WARN_ON_ONCE(!iv) check is bypassed, and
the active vector at the end of the array is silently overwritten.

[ ... ]
> +static int scsit_pci_epf_walk_chain(struct scsit_pci_epf_ctrl *ctrl,
> +				    struct scsit_pci_epf_vq *vq,
> +				    u16 head_idx,
> +				    struct scsit_pci_epf_chain *out)
> +{
> +	struct vring_desc desc, *descs =3D NULL;
> +	unsigned int n =3D 0, i =3D 0, cap_ro =3D 8, cap_wo =3D 8;
> +	bool in_indirect =3D false;
> +	int ret;
[ ... ]
> +		if (flags & VRING_DESC_F_WRITE) {
> +			if (out->nr_wo =3D=3D cap_wo) {
> +				cap_wo *=3D 2;
> +				out->wo =3D krealloc_array(out->wo, cap_wo,
> +						sizeof(*out->wo), GFP_KERNEL);
> +				if (!out->wo) {
> +					ret =3D -ENOMEM;
> +					goto err;
> +				}

[Severity: High]
Can a malicious host cause a memory leak leading to kernel OOM here?

If krealloc_array fails (for example, when capacity reaches maximum sizes
due to a cyclic descriptor chain), it returns NULL, which overwrites the
original out->wo array pointer. The error path then calls
scsit_pci_epf_chain_free(), which will execute kfree(NULL), permanently
leaking the previous allocations.

> +			}
> +			out->wo[out->nr_wo++] =3D desc;
> +			out->wo_len +=3D le32_to_cpu(desc.len);
> +		} else {
> +			/* Read-only descriptors must precede write-only. */
> +			if (out->nr_wo) {
> +				ret =3D -EINVAL;
> +				goto err;
> +			}
> +			if (out->nr_ro =3D=3D cap_ro) {
> +				cap_ro *=3D 2;
> +				out->ro =3D krealloc_array(out->ro, cap_ro,
> +						sizeof(*out->ro), GFP_KERNEL);
> +				if (!out->ro) {
> +					ret =3D -ENOMEM;
> +					goto err;
> +				}
> +			}
> +			out->ro[out->nr_ro++] =3D desc;
> +			out->ro_len +=3D le32_to_cpu(desc.len);

[Severity: High]
Could this summation overflow the 32-bit integer, allowing a bypass of
MDTS limits?

If the host supplies a crafted indirect descriptor chain of massive size,
the accumulated desc.len values can wrap around a 32-bit u32. This
wrapped value would subsequently bypass the data_length > ctrl->mdts
safety check in scsit_pci_epf_alloc_cmd_data_buf(), leading the driver
to attempt allocating excessive amounts of kernel memory.

> +		}
> +
> +		if (!(flags & VRING_DESC_F_NEXT))
> +			break;
> +
> +		if (in_indirect) {
> +			i =3D le16_to_cpu(desc.next);
> +			if (i >=3D n) {
> +				ret =3D -EINVAL;
> +				goto err;
> +			}
> +			desc =3D descs[i];
> +		} else {
> +			u16 next =3D le16_to_cpu(desc.next);
> +
> +			ret =3D scsit_pci_epf_read_desc(vq, next, &desc);

[Severity: High]
Is it possible for the host to provide a cyclic descriptor chain?

The loop unconditionally follows the next pointer without any cycle detecti=
on
or depth limit. A cyclic chain would cause the loop to continuously expand
the arrays until memory exhaustion occurs.

[ ... ]
> +static void scsit_pci_epf_handle_status(struct scsit_pci_epf_ctrl *ctrl,
> +					u8 new_status)
> +{
> +	u8 old_status =3D ctrl->device_status;
> +
> +	if (new_status =3D=3D old_status)
> +		return;
> +
> +	ctrl->device_status =3D new_status;
> +
> +	if (new_status =3D=3D 0) {
> +		scsit_pci_epf_driver_stop(ctrl);
> +		ctrl->driver_features =3D 0;
> +		ctrl->driver_feature_select =3D 0;
> +		scsit_pci_epf_init_bar_regs(ctrl);
> +		return;
> +	}

[Severity: Critical]
Does this reset handler properly abort in-flight asynchronous SCSI commands?

The reset handler tears down the endpoint state but does not appear to
synchronize with or abort executing TCM commands. If the host resets and
quickly re-initializes the device, a previously in-flight TCM command might
complete and pass the SCSIT_PCI_EPF_VQ_LIVE check in
scsit_pci_epf_used_work(). This could cause the driver to perform DMA
writes to stale physical addresses mapped before the reset.

[ ... ]
> +static void scsit_pci_epf_poll_cfg_iter(struct scsit_pci_epf_ctrl *ctrl)
> +{
> +	u32 guest_features, queue_pfn;
> +	u16 queue_sel, queue_vec;
> +	u8 status;
[ ... ]
> +	queue_sel =3D scsit_pci_epf_bar_read16(ctrl, VIRTIO_PCI_QUEUE_SEL);
> +	if (queue_sel !=3D ctrl->queue_select) {
> +		ctrl->queue_select =3D queue_sel;
> +
> +		if (queue_sel < ctrl->nr_vqs)
> +			scsit_pci_epf_bar_write16(ctrl, VIRTIO_PCI_QUEUE_NUM,
> +				SCSIT_PCI_EPF_MAX_QUEUE_DEPTH);
> +		else
> +			scsit_pci_epf_bar_write16(ctrl, VIRTIO_PCI_QUEUE_NUM,
> +						  0);
> +
> +		/*
> +		 * Reset QUEUE_PFN to zero so a subsequent host
> +		 * get_queue_enable() check (read QUEUE_PFN after writing
> +		 * QUEUE_SEL) sees "queue not yet enabled".
> +		 */
> +		scsit_pci_epf_bar_write32(ctrl, VIRTIO_PCI_QUEUE_PFN, 0);
> +	}

[Severity: High]
Could this zeroing of QUEUE_PFN introduce a TOCTOU race with the host?

If the polling thread is slightly delayed and executes after the host has
written both QUEUE_SEL and QUEUE_PFN, it will observe the QUEUE_SEL
change, zero out the QUEUE_PFN, and subsequently read back 0. This clobbers
the valid configuration provided by the host and prevents the virtqueue from
ever being mapped.

> +
> +	/*
> +	 * Capture host-written QUEUE_PFN for the currently-selected queue.
> +	 * Zero the BAR register immediately after capture so the next
> +	 * QUEUE_SEL+QUEUE_PFN read sequence by the host doesn't see a
> +	 * stale value.
> +	 */
> +	queue_pfn =3D scsit_pci_epf_bar_read32(ctrl, VIRTIO_PCI_QUEUE_PFN);
> +	if (queue_pfn) {
> +		if (ctrl->queue_select < ctrl->nr_vqs) {
> +			scsit_pci_epf_set_queue_pfn(ctrl, ctrl->queue_select,
> +						    queue_pfn);
> +		}
> +		scsit_pci_epf_bar_write32(ctrl, VIRTIO_PCI_QUEUE_PFN, 0);
> +	}
> +
> +	queue_vec =3D scsit_pci_epf_bar_read16(ctrl, VIRTIO_MSI_QUEUE_VECTOR);
> +	if (ctrl->queue_select < ctrl->nr_vqs &&
> +	    (queue_vec =3D=3D VIRTIO_MSI_NO_VECTOR ||
> +	     queue_vec < ctrl->scsi_epf->nr_vectors))
> +		ctrl->vqs[ctrl->queue_select].vector =3D queue_vec;

[Severity: High]
Does this logic correctly handle updates to the queue vector?

When the host changes QUEUE_SEL, the physical BAR's VIRTIO_MSI_QUEUE_VECTOR
is not updated to reflect the newly selected queue's current vector. As a
result, this code reads a stale multiplexed register (holding the vector for
the previously selected queue) and overwrites the internal state of the new=
ly
selected queue with incorrect data.

[ ... ]
> +static void scsit_pci_epf_exec_cmd_work(struct work_struct *work)
> +{
> +	struct scsit_pci_epf_cmd *cmd =3D
> +		container_of(work, struct scsit_pci_epf_cmd, work);
> +	struct scsit_pci_epf_ctrl *ctrl =3D cmd->ctrl;
> +	struct se_cmd *se_cmd =3D &cmd->se_cmd;
> +	struct scsit_pci_epf_nexus *nexus;
> +	u64 lun;
> +	int ret;
> +
> +	if (!ctrl->link_up || !ctrl->tpg) {
> +		cmd->resp.response =3D VIRTIO_SCSI_S_TRANSPORT_FAILURE;
> +		goto fail;
> +	}
> +
> +	nexus =3D ctrl->tpg->nexus;

[Severity: High]
Is it safe to access ctrl->tpg here without verifying the reference?

If the Target Portal Group (TPG) is removed concurrently via configfs,
scsit_pci_epf_drop_tpg() frees the structure without verifying if an
active EPF controller is bound to it. This worker could then dereference
the dangling ctrl->tpg pointer, leading to a Use-After-Free.

[ ... ]
> +static void scsit_pci_epf_used_work(struct work_struct *work)
> +{
> +	struct scsit_pci_epf_vq *vq =3D
> +		container_of(work, struct scsit_pci_epf_vq, used_work.work);
> +	struct scsit_pci_epf_ctrl *ctrl =3D vq->ctrl;
> +	struct scsit_pci_epf_cmd *cmd;
> +	unsigned long flags;
> +	bool live;
> +	int ret, n =3D 0;
> +
> +	for (;;) {
> +		spin_lock_irqsave(&vq->lock, flags);
> +		cmd =3D list_first_entry_or_null(&vq->complete_list,
> +					       struct scsit_pci_epf_cmd, link);
> +		if (cmd)
> +			list_del_init(&cmd->link);
> +		spin_unlock_irqrestore(&vq->lock, flags);
> +
> +		if (!cmd)
> +			break;
> +
> +		live =3D test_bit(SCSIT_PCI_EPF_VQ_LIVE, &vq->flags) &&
> +		       ctrl->link_up;
> +
> +		if (live) {
> +			ret =3D scsit_pci_epf_post_response(cmd);
> +			if (ret) {
> +				/* Re-queue and retry shortly. */
> +				spin_lock_irqsave(&vq->lock, flags);
> +				list_add(&cmd->link, &vq->complete_list);
> +				spin_unlock_irqrestore(&vq->lock, flags);
> +				queue_delayed_work(system_highpri_wq,
> +					&vq->used_work,
> +					SCSIT_PCI_EPF_USED_RETRY_INTERVAL);
> +				return;
> +			}
> +		}

[Severity: High]
Does this error handling path assume all DMA mapping failures are transient?

If scsit_pci_epf_post_response() returns an error due to a deterministic
and permanent failure (such as an invalid descriptor length causing bounds
to be exceeded), re-queueing the command will create an infinite retry loop.
This stalls the completion of all commands on the virtqueue and can cause
a system hang during driver teardown when waiting for ctrl->n_inflight.

[ ... ]
> +static void scsit_pci_epf_dispatch_tmr(struct scsit_pci_epf_cmd *cmd)
> +{
> +	struct scsit_pci_epf_ctrl *ctrl =3D cmd->ctrl;
> +	struct scsit_pci_epf_nexus *nexus;
> +	struct se_cmd *se_cmd =3D &cmd->se_cmd;
> +	u8 tm_type;
> +	u64 lun;
> +	int rc;
[ ... ]
> +	rc =3D target_submit_tmr(se_cmd, nexus->se_sess, cmd->sense_buf,
> +			       lun, NULL, tm_type, GFP_KERNEL,
> +			       le64_to_cpu(cmd->tmf_req.tag),
> +			       TARGET_SCF_ACK_KREF);
> +	if (rc < 0) {
> +		cmd->tmf_resp.response =3D VIRTIO_SCSI_S_FUNCTION_REJECTED;
> +		goto fail;
> +	}
> +
> +	wait_for_completion(&cmd->done);

[Severity: High]
Does executing the Task Management Request synchronously block virtqueue
polling?

wait_for_completion(&cmd->done) creates a synchronous block inside the
primary virtqueue polling thread. While waiting for the TMR (like a LUN Res=
et)
to fully complete in the backend, no other virtqueues can be polled or
processed, leading to a stall in queue processing.

[ ... ]
> +static void scsit_pci_epf_poll_vqs_work(struct work_struct *work)
> +{
> +	struct scsit_pci_epf_ctrl *ctrl =3D
> +		container_of(work, struct scsit_pci_epf_ctrl, poll_vqs.work);
> +	struct scsit_pci_epf_vq *vq;
> +	unsigned long limit =3D jiffies;
> +	unsigned long last =3D 0;
> +	int i, nr_active;
> +
> +	while (ctrl->link_up && ctrl->running) {
> +		nr_active =3D 0;
> +		for (i =3D 0; i < ctrl->nr_vqs; i++) {
> +			vq =3D &ctrl->vqs[i];
> +			if (i =3D=3D SCSIT_PCI_EPF_VQ_EVENT)
> +				continue;
> +			if (scsit_pci_epf_process_vq(ctrl, vq) > 0)
> +				nr_active++;
> +		}
> +
> +		if (time_is_before_jiffies(limit + secs_to_jiffies(1))) {
> +			cond_resched();
> +			limit =3D jiffies;
> +			continue;
> +		}
> +
> +		if (nr_active) {
> +			last =3D jiffies;
> +			continue;
> +		}
> +
> +		if (time_is_before_jiffies(last + SCSIT_PCI_EPF_VQ_POLL_IDLE))
> +			break;
> +
> +		cpu_relax();
> +	}

[Severity: High]
Does this loop inadvertently busy-spin the CPU when idle?

The logic appears inverted. If the virtqueues have been completely idle for
5 seconds, time_is_before_jiffies(last + 5s) returns false. The code will
not break out of the loop and instead calls cpu_relax(), causing the system
worker thread to enter a permanent 100% CPU busy-spin loop forever.

> +
> +	schedule_delayed_work(&ctrl->poll_vqs, SCSIT_PCI_EPF_VQ_POLL_INTERVAL);
> +}

[Severity: Critical]
Is it safe to unconditionally reschedule this delayed work?

During driver teardown, cancel_delayed_work_sync() is used to stop this
work. However, if the worker is actively running and aborts its loop, it wi=
ll
unconditionally re-arm the timer here. This runaway timer can fire after the
module is unloaded, causing a Use-After-Free crash.

[ ... ]
> +static int scsit_pci_epf_epc_init(struct pci_epf *epf)
> +{
> +	struct scsit_pci_epf *scsi_epf =3D epf_get_drvdata(epf);
> +	struct scsit_pci_epf_ctrl *ctrl =3D &scsi_epf->ctrl;
> +	int ret;
[ ... ]
> +	ret =3D pci_epc_write_header(epf->epc, epf->func_no, epf->vfunc_no,
> +				   epf->header);
> +	if (ret) {
> +		dev_err(&epf->dev,
> +			"Failed to write configuration header (err=3D%d)\n", ret);
> +		goto out_destroy_ctrl;
> +	}
> +
> +	ret =3D pci_epc_set_bar(epf->epc, epf->func_no, epf->vfunc_no,
> +			      &epf->bar[BAR_0]);
> +	if (ret) {
> +		dev_err(&epf->dev, "Failed to set BAR 0 (err=3D%d)\n", ret);
> +		goto out_destroy_ctrl;
> +	}
> +
> +	ret =3D scsit_pci_epf_init_irq(scsi_epf);
> +	if (ret)
> +		goto out_clear_bar;
> +
> +	if (!scsi_epf->epc_features->linkup_notifier)
> +		scsit_pci_epf_start_ctrl(ctrl);
> +
> +	return 0;
> +
> +out_clear_bar:
> +	scsit_pci_epf_clear_bar(scsi_epf);
> +out_destroy_ctrl:
> +	scsit_pci_epf_destroy_ctrl(&scsi_epf->ctrl);
> +	return ret;
> +}

[Severity: Medium]
Do these error paths leak the DMA channels allocated earlier?

scsit_pci_epf_init_dma() is called prior to pci_epc_write_header(), but
neither out_destroy_ctrl nor out_clear_bar invokes
scsit_pci_epf_deinit_dma(). Repeated probe failures could permanently
exhaust DMA resources.

[ ... ]
> +static void scsit_pci_epf_drop_tpg(struct se_portal_group *se_tpg)
> +{
> +	struct scsit_pci_epf_tpg *tpg =3D to_scsit_pci_epf_tpg(se_tpg);
> +
> +	mutex_lock(&scsit_pci_epf_tpgs_mutex);
> +	list_del_init(&tpg->list);
> +	mutex_unlock(&scsit_pci_epf_tpgs_mutex);
> +
> +	scsit_pci_epf_drop_nexus(tpg);
> +	core_tpg_deregister(&tpg->se_tpg);
> +	kfree(tpg);
> +}

[Severity: High]
Does this safely handle an actively bound EPF controller?

The TPG is forcefully freed without verifying if the EPF controller holds
a reference to it (ctrl->tpg =3D=3D tpg). This allows configfs deletion to
trigger a Use-After-Free for actively running endpoints.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901014650.2728=
658-1-alistair.francis@wdc.com?part=3D2
