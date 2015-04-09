From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 6/9] snic:Add low level queuing interfaces
Date: Thu, 09 Apr 2015 15:23:10 +0200
Message-ID: <55267D3E.2060505@suse.de>
References: <1428580189-22785-1-git-send-email-nmusini@cisco.com> <1428580189-22785-7-git-send-email-nmusini@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48997 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613AbbDINXN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Apr 2015 09:23:13 -0400
In-Reply-To: <1428580189-22785-7-git-send-email-nmusini@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Narsimhulu Musini <nmusini@cisco.com>, JBottomley@Parallels.com, linux-scsi@vger.kernel.org, hch@infradead.org
Cc: Sesidhar Baddela <sebaddel@cisco.com>

Hi Narsimhulu,

please find my comment at the bottom.

On 04/09/2015 01:49 PM, Narsimhulu Musini wrote:
> These files contain low level queueing interfaces includes
> hardware queues, and management of hardware features.
>=20
> Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
> Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
> ---
> * v3
> - Cleaned up unused functions.
>=20
> * v2
> - driver supports x86-64 arch, so removed cpu_to_XX API to maintain c=
onsistency.
>=20
>  drivers/scsi/snic/cq_desc.h       |  76 ++++
>  drivers/scsi/snic/cq_enet_desc.h  |  38 ++
>  drivers/scsi/snic/vnic_cq.c       |  86 +++++
>  drivers/scsi/snic/vnic_cq.h       | 120 ++++++
>  drivers/scsi/snic/vnic_cq_fw.h    |  62 ++++
>  drivers/scsi/snic/vnic_dev.c      | 749 ++++++++++++++++++++++++++++=
++++++++++
>  drivers/scsi/snic/vnic_dev.h      | 140 +++++++
>  drivers/scsi/snic/vnic_devcmd.h   | 270 ++++++++++++++
>  drivers/scsi/snic/vnic_intr.c     |  59 +++
>  drivers/scsi/snic/vnic_intr.h     | 119 ++++++
>  drivers/scsi/snic/vnic_resource.h |  68 ++++
>  drivers/scsi/snic/vnic_snic.h     |  54 +++
>  drivers/scsi/snic/vnic_stats.h    |  68 ++++
>  drivers/scsi/snic/vnic_wq.c       | 236 ++++++++++++
>  drivers/scsi/snic/vnic_wq.h       | 187 ++++++++++
>  drivers/scsi/snic/wq_enet_desc.h  |  91 +++++
>  16 files changed, 2423 insertions(+)
>  create mode 100644 drivers/scsi/snic/cq_desc.h
>  create mode 100644 drivers/scsi/snic/cq_enet_desc.h
>  create mode 100644 drivers/scsi/snic/vnic_cq.c
>  create mode 100644 drivers/scsi/snic/vnic_cq.h
>  create mode 100644 drivers/scsi/snic/vnic_cq_fw.h
>  create mode 100644 drivers/scsi/snic/vnic_dev.c
>  create mode 100644 drivers/scsi/snic/vnic_dev.h
>  create mode 100644 drivers/scsi/snic/vnic_devcmd.h
>  create mode 100644 drivers/scsi/snic/vnic_intr.c
>  create mode 100644 drivers/scsi/snic/vnic_intr.h
>  create mode 100644 drivers/scsi/snic/vnic_resource.h
>  create mode 100644 drivers/scsi/snic/vnic_snic.h
>  create mode 100644 drivers/scsi/snic/vnic_stats.h
>  create mode 100644 drivers/scsi/snic/vnic_wq.c
>  create mode 100644 drivers/scsi/snic/vnic_wq.h
>  create mode 100644 drivers/scsi/snic/wq_enet_desc.h
>=20
> diff --git a/drivers/scsi/snic/cq_desc.h b/drivers/scsi/snic/cq_desc.=
h
> new file mode 100644
> index 0000000..630edfa
> --- /dev/null
> +++ b/drivers/scsi/snic/cq_desc.h
> @@ -0,0 +1,76 @@
> +/*
> + * Copyright 2014 Cisco Systems, Inc.  All rights reserved.
> + *
> + * This program is free software; you may redistribute it and/or mod=
ify
> + * it under the terms of the GNU General Public License as published=
 by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES O=
=46
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDE=
RS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN A=
N
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + */
> +
> +#ifndef _CQ_DESC_H_
> +#define _CQ_DESC_H_
> +
> +/*
> + * Completion queue descriptor types
> + */
> +enum cq_desc_types {
> +	CQ_DESC_TYPE_WQ_ENET =3D 0,
> +	CQ_DESC_TYPE_DESC_COPY =3D 1,
> +	CQ_DESC_TYPE_WQ_EXCH =3D 2,
> +	CQ_DESC_TYPE_RQ_ENET =3D 3,
> +	CQ_DESC_TYPE_RQ_FCP =3D 4,
> +};
> +
> +/* Completion queue descriptor: 16B
> + *
> + * All completion queues have this basic layout.  The
> + * type_specific area is unique for each completion
> + * queue type.
> + */
> +struct cq_desc {
> +	u16 completed_index;
> +	u16 q_number;
> +	u8 type_specific[11];
> +	u8 type_color;
> +};
> +
> +#define CQ_DESC_TYPE_BITS        4
> +#define CQ_DESC_TYPE_MASK        ((1 << CQ_DESC_TYPE_BITS) - 1)
> +#define CQ_DESC_COLOR_MASK       1
> +#define CQ_DESC_COLOR_SHIFT      7
> +#define CQ_DESC_Q_NUM_BITS       10
> +#define CQ_DESC_Q_NUM_MASK       ((1 << CQ_DESC_Q_NUM_BITS) - 1)
> +#define CQ_DESC_COMP_NDX_BITS    12
> +#define CQ_DESC_COMP_NDX_MASK    ((1 << CQ_DESC_COMP_NDX_BITS) - 1)
> +
> +static inline void cq_desc_dec(const struct cq_desc *desc_arg,
> +	u8 *type, u8 *color, u16 *q_number, u16 *completed_index)
> +{
> +	const struct cq_desc *desc =3D desc_arg;
> +	const u8 type_color =3D desc->type_color;
> +
> +	*color =3D (type_color >> CQ_DESC_COLOR_SHIFT) & CQ_DESC_COLOR_MASK=
;
> +
> +	/*
> +	 * Make sure color bit is read from desc *before* other fields
> +	 * are read from desc.  Hardware guarantees color bit is last
> +	 * bit (byte) written.  Adding the rmb() prevents the compiler
> +	 * and/or CPU from reordering the reads which would potentially
> +	 * result in reading stale values.
> +	 */
> +	rmb();
> +
> +	*type =3D type_color & CQ_DESC_TYPE_MASK;
> +	*q_number =3D desc->q_number & CQ_DESC_Q_NUM_MASK;
> +	*completed_index =3D desc->completed_index & CQ_DESC_COMP_NDX_MASK;
> +}
> +
> +#endif /* _CQ_DESC_H_ */
> diff --git a/drivers/scsi/snic/cq_enet_desc.h b/drivers/scsi/snic/cq_=
enet_desc.h
> new file mode 100644
> index 0000000..99ecd20
> --- /dev/null
> +++ b/drivers/scsi/snic/cq_enet_desc.h
> @@ -0,0 +1,38 @@
> +/*
> + * Copyright 2014 Cisco Systems, Inc.  All rights reserved.
> + *
> + * This program is free software; you may redistribute it and/or mod=
ify
> + * it under the terms of the GNU General Public License as published=
 by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES O=
=46
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDE=
RS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN A=
N
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + */
> +
> +#ifndef _CQ_ENET_DESC_H_
> +#define _CQ_ENET_DESC_H_
> +
> +#include "cq_desc.h"
> +
> +/* Ethernet completion queue descriptor: 16B */
> +struct cq_enet_wq_desc {
> +	u16 completed_index;
> +	u16 q_number;
> +	u8 reserved[11];
> +	u8 type_color;
> +};
> +
> +static inline void cq_enet_wq_desc_dec(struct cq_enet_wq_desc *desc,
> +	u8 *type, u8 *color, u16 *q_number, u16 *completed_index)
> +{
> +	cq_desc_dec((struct cq_desc *)desc, type,
> +		color, q_number, completed_index);
> +}
> +
> +#endif /* _CQ_ENET_DESC_H_ */
> diff --git a/drivers/scsi/snic/vnic_cq.c b/drivers/scsi/snic/vnic_cq.=
c
> new file mode 100644
> index 0000000..88d4537
> --- /dev/null
> +++ b/drivers/scsi/snic/vnic_cq.c
> @@ -0,0 +1,86 @@
> +/*
> + * Copyright 2014 Cisco Systems, Inc.  All rights reserved.
> + *
> + * This program is free software; you may redistribute it and/or mod=
ify
> + * it under the terms of the GNU General Public License as published=
 by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES O=
=46
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDE=
RS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN A=
N
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + */
> +
> +#include <linux/errno.h>
> +#include <linux/types.h>
> +#include <linux/pci.h>
> +#include "vnic_dev.h"
> +#include "vnic_cq.h"
> +
> +void vnic_cq_free(struct vnic_cq *cq)
> +{
> +	vnic_dev_free_desc_ring(cq->vdev, &cq->ring);
> +
> +	cq->ctrl =3D NULL;
> +}
> +
> +int vnic_cq_alloc(struct vnic_dev *vdev, struct vnic_cq *cq, unsigne=
d int index,
> +	unsigned int desc_count, unsigned int desc_size)
> +{
> +	int err;
> +
> +	cq->index =3D index;
> +	cq->vdev =3D vdev;
> +
> +	cq->ctrl =3D vnic_dev_get_res(vdev, RES_TYPE_CQ, index);
> +	if (!cq->ctrl) {
> +		pr_err("Failed to hook CQ[%d] resource\n", index);
> +
> +		return -EINVAL;
> +	}
> +
> +	err =3D vnic_dev_alloc_desc_ring(vdev, &cq->ring, desc_count, desc_=
size);
> +	if (err)
> +		return err;
> +
> +	return 0;
> +}
> +
> +void vnic_cq_init(struct vnic_cq *cq, unsigned int flow_control_enab=
le,
> +	unsigned int color_enable, unsigned int cq_head, unsigned int cq_ta=
il,
> +	unsigned int cq_tail_color, unsigned int interrupt_enable,
> +	unsigned int cq_entry_enable, unsigned int cq_message_enable,
> +	unsigned int interrupt_offset, u64 cq_message_addr)
> +{
> +	u64 paddr;
> +
> +	paddr =3D (u64)cq->ring.base_addr | VNIC_PADDR_TARGET;
> +	writeq(paddr, &cq->ctrl->ring_base);
> +	iowrite32(cq->ring.desc_count, &cq->ctrl->ring_size);
> +	iowrite32(flow_control_enable, &cq->ctrl->flow_control_enable);
> +	iowrite32(color_enable, &cq->ctrl->color_enable);
> +	iowrite32(cq_head, &cq->ctrl->cq_head);
> +	iowrite32(cq_tail, &cq->ctrl->cq_tail);
> +	iowrite32(cq_tail_color, &cq->ctrl->cq_tail_color);
> +	iowrite32(interrupt_enable, &cq->ctrl->interrupt_enable);
> +	iowrite32(cq_entry_enable, &cq->ctrl->cq_entry_enable);
> +	iowrite32(cq_message_enable, &cq->ctrl->cq_message_enable);
> +	iowrite32(interrupt_offset, &cq->ctrl->interrupt_offset);
> +	writeq(cq_message_addr, &cq->ctrl->cq_message_addr);
> +}
> +
> +void vnic_cq_clean(struct vnic_cq *cq)
> +{
> +	cq->to_clean =3D 0;
> +	cq->last_color =3D 0;
> +
> +	iowrite32(0, &cq->ctrl->cq_head);
> +	iowrite32(0, &cq->ctrl->cq_tail);
> +	iowrite32(1, &cq->ctrl->cq_tail_color);
> +
> +	vnic_dev_clear_desc_ring(&cq->ring);
> +}
> diff --git a/drivers/scsi/snic/vnic_cq.h b/drivers/scsi/snic/vnic_cq.=
h
> new file mode 100644
> index 0000000..fb2dc61
> --- /dev/null
> +++ b/drivers/scsi/snic/vnic_cq.h
> @@ -0,0 +1,120 @@
> +/*
> + * Copyright 2014 Cisco Systems, Inc.  All rights reserved.
> + *
> + * This program is free software; you may redistribute it and/or mod=
ify
> + * it under the terms of the GNU General Public License as published=
 by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES O=
=46
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDE=
RS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN A=
N
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + */
> +
> +#ifndef _VNIC_CQ_H_
> +#define _VNIC_CQ_H_
> +
> +#include "cq_desc.h"
> +#include "vnic_dev.h"
> +
> +/*
> + * These defines avoid symbol clash between fnic and enic (Cisco 10G=
 Eth
> + * Driver) when both are built with CONFIG options =3Dy
> + */
> +#define vnic_cq_service snic_cq_service
> +#define vnic_cq_free snic_cq_free
> +#define vnic_cq_alloc snic_cq_alloc
> +#define vnic_cq_init snic_cq_init
> +#define vnic_cq_clean snic_cq_clean
> +
> +/* Completion queue control */
> +struct vnic_cq_ctrl {
> +	u64 ring_base;			/* 0x00 */
> +	u32 ring_size;			/* 0x08 */
> +	u32 pad0;
> +	u32 flow_control_enable;	/* 0x10 */
> +	u32 pad1;
> +	u32 color_enable;		/* 0x18 */
> +	u32 pad2;
> +	u32 cq_head;			/* 0x20 */
> +	u32 pad3;
> +	u32 cq_tail;			/* 0x28 */
> +	u32 pad4;
> +	u32 cq_tail_color;		/* 0x30 */
> +	u32 pad5;
> +	u32 interrupt_enable;		/* 0x38 */
> +	u32 pad6;
> +	u32 cq_entry_enable;		/* 0x40 */
> +	u32 pad7;
> +	u32 cq_message_enable;		/* 0x48 */
> +	u32 pad8;
> +	u32 interrupt_offset;		/* 0x50 */
> +	u32 pad9;
> +	u64 cq_message_addr;		/* 0x58 */
> +	u32 pad10;
> +};
> +
> +struct vnic_cq {
> +	unsigned int index;
> +	struct vnic_dev *vdev;
> +	struct vnic_cq_ctrl __iomem *ctrl;	/* memory-mapped */
> +	struct vnic_dev_ring ring;
> +	unsigned int to_clean;
> +	unsigned int last_color;
> +};
> +
> +static inline unsigned int vnic_cq_service(struct vnic_cq *cq,
> +	unsigned int work_to_do,
> +	int (*q_service)(struct vnic_dev *vdev, struct cq_desc *cq_desc,
> +	u8 type, u16 q_number, u16 completed_index, void *opaque),
> +	void *opaque)
> +{
> +	struct cq_desc *cq_desc;
> +	unsigned int work_done =3D 0;
> +	u16 q_number, completed_index;
> +	u8 type, color;
> +
> +	cq_desc =3D (struct cq_desc *)((u8 *)cq->ring.descs +
> +		cq->ring.desc_size * cq->to_clean);
> +	cq_desc_dec(cq_desc, &type, &color,
> +		&q_number, &completed_index);
> +
> +	while (color !=3D cq->last_color) {
> +
> +		if ((*q_service)(cq->vdev, cq_desc, type,
> +			q_number, completed_index, opaque))
> +			break;
> +
> +		cq->to_clean++;
> +		if (cq->to_clean =3D=3D cq->ring.desc_count) {
> +			cq->to_clean =3D 0;
> +			cq->last_color =3D cq->last_color ? 0 : 1;
> +		}
> +
> +		cq_desc =3D (struct cq_desc *)((u8 *)cq->ring.descs +
> +			cq->ring.desc_size * cq->to_clean);
> +		cq_desc_dec(cq_desc, &type, &color,
> +			&q_number, &completed_index);
> +
> +		work_done++;
> +		if (work_done >=3D work_to_do)
> +			break;
> +	}
> +
> +	return work_done;
> +}
> +
> +void vnic_cq_free(struct vnic_cq *cq);
> +int vnic_cq_alloc(struct vnic_dev *vdev, struct vnic_cq *cq, unsigne=
d int index,
> +	unsigned int desc_count, unsigned int desc_size);
> +void vnic_cq_init(struct vnic_cq *cq, unsigned int flow_control_enab=
le,
> +	unsigned int color_enable, unsigned int cq_head, unsigned int cq_ta=
il,
> +	unsigned int cq_tail_color, unsigned int interrupt_enable,
> +	unsigned int cq_entry_enable, unsigned int message_enable,
> +	unsigned int interrupt_offset, u64 message_addr);
> +void vnic_cq_clean(struct vnic_cq *cq);
> +#endif /* _VNIC_CQ_H_ */
> diff --git a/drivers/scsi/snic/vnic_cq_fw.h b/drivers/scsi/snic/vnic_=
cq_fw.h
> new file mode 100644
> index 0000000..c2d1bbd
> --- /dev/null
> +++ b/drivers/scsi/snic/vnic_cq_fw.h
> @@ -0,0 +1,62 @@
> +/*
> + * Copyright 2014 Cisco Systems, Inc.  All rights reserved.
> + *
> + * This program is free software; you may redistribute it and/or mod=
ify
> + * it under the terms of the GNU General Public License as published=
 by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES O=
=46
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDE=
RS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN A=
N
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + */
> +
> +#ifndef _VNIC_CQ_FW_H_
> +#define _VNIC_CQ_FW_H_
> +
> +#include "snic_fwint.h"
> +
> +static inline unsigned int
> +vnic_cq_fw_service(struct vnic_cq *cq,
> +		   int (*q_service)(struct vnic_dev *vdev,
> +				    unsigned int index,
> +				    struct snic_fw_req *desc),
> +		   unsigned int work_to_do)
> +
> +{
> +	struct snic_fw_req *desc;
> +	unsigned int work_done =3D 0;
> +	u8 color;
> +
> +	desc =3D (struct snic_fw_req *)((u8 *)cq->ring.descs +
> +		cq->ring.desc_size * cq->to_clean);
> +	snic_color_dec(desc, &color);
> +
> +	while (color !=3D cq->last_color) {
> +
> +		if ((*q_service)(cq->vdev, cq->index, desc))
> +			break;
> +
> +		cq->to_clean++;
> +		if (cq->to_clean =3D=3D cq->ring.desc_count) {
> +			cq->to_clean =3D 0;
> +			cq->last_color =3D cq->last_color ? 0 : 1;
> +		}
> +
> +		desc =3D (struct snic_fw_req *)((u8 *)cq->ring.descs +
> +			cq->ring.desc_size * cq->to_clean);
> +		snic_color_dec(desc, &color);
> +
> +		work_done++;
> +		if (work_done >=3D work_to_do)
> +			break;
> +	}
> +
> +	return work_done;
> +}
> +
> +#endif /* _VNIC_CQ_FW_H_ */
> diff --git a/drivers/scsi/snic/vnic_dev.c b/drivers/scsi/snic/vnic_de=
v.c
> new file mode 100644
> index 0000000..68c63d5
> --- /dev/null
> +++ b/drivers/scsi/snic/vnic_dev.c
> @@ -0,0 +1,749 @@
> +/*
> + * Copyright 2014 Cisco Systems, Inc.  All rights reserved.
> + *
> + * This program is free software; you may redistribute it and/or mod=
ify
> + * it under the terms of the GNU General Public License as published=
 by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES O=
=46
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDE=
RS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN A=
N
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/errno.h>
> +#include <linux/types.h>
> +#include <linux/pci.h>
> +#include <linux/delay.h>
> +#include <linux/if_ether.h>
> +#include <linux/slab.h>
> +#include "vnic_resource.h"
> +#include "vnic_devcmd.h"
> +#include "vnic_dev.h"
> +#include "vnic_stats.h"
> +#include "vnic_wq.h"
> +
> +#define VNIC_DVCMD_TMO	10000	/* Devcmd Timeout value */
> +#define VNIC_NOTIFY_INTR_MASK 0x0000ffff00000000ULL
> +
> +struct devcmd2_controller {
> +	struct vnic_wq_ctrl __iomem *wq_ctrl;
> +	struct vnic_dev_ring results_ring;
> +	struct vnic_wq wq;
> +	struct vnic_devcmd2 *cmd_ring;
> +	struct devcmd2_result *result;
> +	u16 next_result;
> +	u16 result_size;
> +	int color;
> +};
> +
> +struct vnic_res {
> +	void __iomem *vaddr;
> +	unsigned int count;
> +};
> +
> +struct vnic_dev {
> +	void *priv;
> +	struct pci_dev *pdev;
> +	struct vnic_res res[RES_TYPE_MAX];
> +	enum vnic_dev_intr_mode intr_mode;
> +	struct vnic_devcmd __iomem *devcmd;
> +	struct vnic_devcmd_notify *notify;
> +	struct vnic_devcmd_notify notify_copy;
> +	dma_addr_t notify_pa;
> +	u32 *linkstatus;
> +	dma_addr_t linkstatus_pa;
> +	struct vnic_stats *stats;
> +	dma_addr_t stats_pa;
> +	struct vnic_devcmd_fw_info *fw_info;
> +	dma_addr_t fw_info_pa;
> +	u64 args[VNIC_DEVCMD_NARGS];
> +	struct devcmd2_controller *devcmd2;
> +
> +	int (*devcmd_rtn)(struct vnic_dev *vdev, enum vnic_devcmd_cmd cmd,
> +			  int wait);
> +};
> +
> +#define VNIC_MAX_RES_HDR_SIZE \
> +	(sizeof(struct vnic_resource_header) + \
> +	sizeof(struct vnic_resource) * RES_TYPE_MAX)
> +#define VNIC_RES_STRIDE	128
> +
> +void *vnic_dev_priv(struct vnic_dev *vdev)
> +{
> +	return vdev->priv;
> +}
> +
> +static int vnic_dev_discover_res(struct vnic_dev *vdev,
> +	struct vnic_dev_bar *bar, unsigned int num_bars)
> +{
> +	struct vnic_resource_header __iomem *rh;
> +	struct vnic_resource __iomem *r;
> +	u8 type;
> +
> +	if (num_bars =3D=3D 0)
> +		return -EINVAL;
> +
> +	if (bar->len < VNIC_MAX_RES_HDR_SIZE) {
> +		pr_err("vNIC BAR0 res hdr length error\n");
> +
> +		return -EINVAL;
> +	}
> +
> +	rh =3D bar->vaddr;
> +	if (!rh) {
> +		pr_err("vNIC BAR0 res hdr not mem-mapped\n");
> +
> +		return -EINVAL;
> +	}
> +
> +	if (ioread32(&rh->magic) !=3D VNIC_RES_MAGIC ||
> +	    ioread32(&rh->version) !=3D VNIC_RES_VERSION) {
> +		pr_err("vNIC BAR0 res magic/version error exp (%lx/%lx) curr (%x/%=
x)\n",
> +			VNIC_RES_MAGIC, VNIC_RES_VERSION,
> +			ioread32(&rh->magic), ioread32(&rh->version));
> +
> +		return -EINVAL;
> +	}
> +
> +	r =3D (struct vnic_resource __iomem *)(rh + 1);
> +
> +	while ((type =3D ioread8(&r->type)) !=3D RES_TYPE_EOL) {
> +
> +		u8 bar_num =3D ioread8(&r->bar);
> +		u32 bar_offset =3D ioread32(&r->bar_offset);
> +		u32 count =3D ioread32(&r->count);
> +		u32 len;
> +
> +		r++;
> +
> +		if (bar_num >=3D num_bars)
> +			continue;
> +
> +		if (!bar[bar_num].len || !bar[bar_num].vaddr)
> +			continue;
> +
> +		switch (type) {
> +		case RES_TYPE_WQ:
> +		case RES_TYPE_RQ:
> +		case RES_TYPE_CQ:
> +		case RES_TYPE_INTR_CTRL:
> +			/* each count is stride bytes long */
> +			len =3D count * VNIC_RES_STRIDE;
> +			if (len + bar_offset > bar->len) {
> +				pr_err("vNIC BAR0 resource %d out-of-bounds, offset 0x%x + size =
0x%x > bar len 0x%lx\n",
> +					type, bar_offset,
> +					len,
> +					bar->len);
> +
> +				return -EINVAL;
> +			}
> +			break;
> +
> +		case RES_TYPE_INTR_PBA_LEGACY:
> +		case RES_TYPE_DEVCMD:
> +		case RES_TYPE_DEVCMD2:
> +			len =3D count;
> +			break;
> +
> +		default:
> +			continue;
> +		}
> +
> +		vdev->res[type].count =3D count;
> +		vdev->res[type].vaddr =3D (char __iomem *)bar->vaddr + bar_offset;
> +	}
> +
> +	return 0;
> +}
> +
> +unsigned int vnic_dev_get_res_count(struct vnic_dev *vdev,
> +	enum vnic_res_type type)
> +{
> +	return vdev->res[type].count;
> +}
> +
> +void __iomem *vnic_dev_get_res(struct vnic_dev *vdev, enum vnic_res_=
type type,
> +	unsigned int index)
> +{
> +	if (!vdev->res[type].vaddr)
> +		return NULL;
> +
> +	switch (type) {
> +	case RES_TYPE_WQ:
> +	case RES_TYPE_RQ:
> +	case RES_TYPE_CQ:
> +	case RES_TYPE_INTR_CTRL:
> +		return (char __iomem *)vdev->res[type].vaddr +
> +					index * VNIC_RES_STRIDE;
> +
> +	default:
> +		return (char __iomem *)vdev->res[type].vaddr;
> +	}
> +}
> +
> +unsigned int vnic_dev_desc_ring_size(struct vnic_dev_ring *ring,
> +				     unsigned int desc_count,
> +				     unsigned int desc_size)
> +{
> +	/* The base address of the desc rings must be 512 byte aligned.
> +	 * Descriptor count is aligned to groups of 32 descriptors.  A
> +	 * count of 0 means the maximum 4096 descriptors.  Descriptor
> +	 * size is aligned to 16 bytes.
> +	 */
> +
> +	unsigned int count_align =3D 32;
> +	unsigned int desc_align =3D 16;
> +
> +	ring->base_align =3D 512;
> +
> +	if (desc_count =3D=3D 0)
> +		desc_count =3D 4096;
> +
> +	ring->desc_count =3D ALIGN(desc_count, count_align);
> +
> +	ring->desc_size =3D ALIGN(desc_size, desc_align);
> +
> +	ring->size =3D ring->desc_count * ring->desc_size;
> +	ring->size_unaligned =3D ring->size + ring->base_align;
> +
> +	return ring->size_unaligned;
> +}
> +
> +void vnic_dev_clear_desc_ring(struct vnic_dev_ring *ring)
> +{
> +	memset(ring->descs, 0, ring->size);
> +}
> +
> +int vnic_dev_alloc_desc_ring(struct vnic_dev *vdev, struct vnic_dev_=
ring *ring,
> +	unsigned int desc_count, unsigned int desc_size)
> +{
> +	vnic_dev_desc_ring_size(ring, desc_count, desc_size);
> +
> +	ring->descs_unaligned =3D pci_alloc_consistent(vdev->pdev,
> +		ring->size_unaligned,
> +		&ring->base_addr_unaligned);
> +
> +	if (!ring->descs_unaligned) {
> +		pr_err("Failed to allocate ring (size=3D%d), aborting\n",
> +			(int)ring->size);
> +
> +		return -ENOMEM;
> +	}
> +
> +	ring->base_addr =3D ALIGN(ring->base_addr_unaligned,
> +		ring->base_align);
> +	ring->descs =3D (u8 *)ring->descs_unaligned +
> +		(ring->base_addr - ring->base_addr_unaligned);
> +
> +	vnic_dev_clear_desc_ring(ring);
> +
> +	ring->desc_avail =3D ring->desc_count - 1;
> +
> +	return 0;
> +}
> +
> +void vnic_dev_free_desc_ring(struct vnic_dev *vdev, struct vnic_dev_=
ring *ring)
> +{
> +	if (ring->descs) {
> +		pci_free_consistent(vdev->pdev,
> +			ring->size_unaligned,
> +			ring->descs_unaligned,
> +			ring->base_addr_unaligned);
> +		ring->descs =3D NULL;
> +	}
> +}
> +
> +static int _vnic_dev_cmd2(struct vnic_dev *vdev, enum vnic_devcmd_cm=
d cmd,
> +	int wait)
> +{
> +	struct devcmd2_controller *dc2c =3D vdev->devcmd2;
> +	struct devcmd2_result *result =3D dc2c->result + dc2c->next_result;
> +	unsigned int i;
> +	int delay;
> +	int err;
> +	u32 posted;
> +	u32 new_posted;
> +
> +	posted =3D ioread32(&dc2c->wq_ctrl->posted_index);
> +
> +	if (posted =3D=3D 0xFFFFFFFF) { /* check for hardware gone  */
> +		/* Hardware surprise removal: return error */
> +		return -ENODEV;
> +	}
> +
> +	new_posted =3D (posted + 1) % DEVCMD2_RING_SIZE;
> +	dc2c->cmd_ring[posted].cmd =3D cmd;
> +	dc2c->cmd_ring[posted].flags =3D 0;
> +
> +	if ((_CMD_FLAGS(cmd) & _CMD_FLAGS_NOWAIT))
> +		dc2c->cmd_ring[posted].flags |=3D DEVCMD2_FNORESULT;
> +
> +	if (_CMD_DIR(cmd) & _CMD_DIR_WRITE) {
> +		for (i =3D 0; i < VNIC_DEVCMD_NARGS; i++)
> +			dc2c->cmd_ring[posted].args[i] =3D vdev->args[i];
> +	}
> +	/* Adding write memory barrier prevents compiler and/or CPU
> +	 * reordering, thus avoiding descriptor posting before
> +	 * descriptor is initialized. Otherwise, hardware can read
> +	 * stale descriptor fields.
> +	 */
> +	wmb();
> +	iowrite32(new_posted, &dc2c->wq_ctrl->posted_index);
> +
> +	if (dc2c->cmd_ring[posted].flags & DEVCMD2_FNORESULT)
> +		return 0;
> +
> +	for (delay =3D 0; delay < wait; delay++) {
> +		udelay(100);
> +		if (result->color =3D=3D dc2c->color) {
> +			dc2c->next_result++;
> +			if (dc2c->next_result =3D=3D dc2c->result_size) {
> +				dc2c->next_result =3D 0;
> +				dc2c->color =3D dc2c->color ? 0 : 1;
> +			}
> +			if (result->error) {
> +				err =3D (int) result->error;
> +				if (err !=3D ERR_ECMDUNKNOWN ||
> +				    cmd !=3D CMD_CAPABILITY)
> +					pr_err("Error %d devcmd %d\n",
> +						err, _CMD_N(cmd));
> +
> +				return err;
> +			}
> +			if (_CMD_DIR(cmd) & _CMD_DIR_READ) {
> +				/*
> +				 * Adding the rmb() prevents the compiler
> +				 * and/or CPU from reordering the reads which
> +				 * would potentially result in reading stale
> +				 * values.
> +				 */
> +				rmb();
> +				for (i =3D 0; i < VNIC_DEVCMD_NARGS; i++)
> +					vdev->args[i] =3D result->results[i];
> +			}
> +
> +			return 0;
> +		}
> +	}
> +
> +	pr_err("Timed out devcmd %d\n", _CMD_N(cmd));
> +
> +	return -ETIMEDOUT;
> +}
> +
> +static int vnic_dev_init_devcmd2(struct vnic_dev *vdev)
> +{
> +	struct devcmd2_controller *dc2c =3D NULL;
> +	unsigned int fetch_idx;
> +	int ret;
> +	void __iomem *p;
> +
> +	if (vdev->devcmd2)
> +		return 0;
> +
> +	p =3D vnic_dev_get_res(vdev, RES_TYPE_DEVCMD2, 0);
> +	if (!p)
> +		return -ENODEV;
> +
> +	dc2c =3D kzalloc(sizeof(*dc2c), GFP_ATOMIC);
> +	if (!dc2c)
> +		return -ENOMEM;
> +
> +	vdev->devcmd2 =3D dc2c;
> +
> +	dc2c->color =3D 1;
> +	dc2c->result_size =3D DEVCMD2_RING_SIZE;
> +
> +	ret  =3D vnic_wq_devcmd2_alloc(vdev,
> +				     &dc2c->wq,
> +				     DEVCMD2_RING_SIZE,
> +				     DEVCMD2_DESC_SIZE);
> +	if (ret)
> +		goto err_free_devcmd2;
> +
> +	fetch_idx =3D ioread32(&dc2c->wq.ctrl->fetch_index);
> +	if (fetch_idx =3D=3D 0xFFFFFFFF) { /* check for hardware gone  */
> +		/* Hardware surprise removal: reset fetch_index */
> +		fetch_idx =3D 0;
> +	}
> +
> +	/*
> +	 * Don't change fetch_index ever and
> +	 * set posted_index same as fetch_index
> +	 * when setting up the WQ for devcmd2.
> +	 */
> +	vnic_wq_init_start(&dc2c->wq, 0, fetch_idx, fetch_idx, 0, 0);
> +	vnic_wq_enable(&dc2c->wq);
> +	ret =3D vnic_dev_alloc_desc_ring(vdev,
> +				       &dc2c->results_ring,
> +				       DEVCMD2_RING_SIZE,
> +				       DEVCMD2_DESC_SIZE);
> +	if (ret)
> +		goto err_free_wq;
> +
> +	dc2c->result =3D (struct devcmd2_result *) dc2c->results_ring.descs=
;
> +	dc2c->cmd_ring =3D (struct vnic_devcmd2 *) dc2c->wq.ring.descs;
> +	dc2c->wq_ctrl =3D dc2c->wq.ctrl;
> +	vdev->args[0] =3D (u64) dc2c->results_ring.base_addr | VNIC_PADDR_T=
ARGET;
> +	vdev->args[1] =3D DEVCMD2_RING_SIZE;
> +
> +	ret =3D _vnic_dev_cmd2(vdev, CMD_INITIALIZE_DEVCMD2, VNIC_DVCMD_TMO=
);
> +	if (ret < 0)
> +		goto err_free_desc_ring;
> +
> +	vdev->devcmd_rtn =3D &_vnic_dev_cmd2;
> +	pr_info("DEVCMD2 Initialized.\n");
> +
> +	return ret;
> +
> +err_free_desc_ring:
> +	vnic_dev_free_desc_ring(vdev, &dc2c->results_ring);
> +
> +err_free_wq:
> +	vnic_wq_disable(&dc2c->wq);
> +	vnic_wq_free(&dc2c->wq);
> +
> +err_free_devcmd2:
> +	kfree(dc2c);
> +	vdev->devcmd2 =3D NULL;
> +
> +	return ret;
> +} /* end of vnic_dev_init_devcmd2 */
> +
> +static void vnic_dev_deinit_devcmd2(struct vnic_dev *vdev)
> +{
> +	struct devcmd2_controller *dc2c =3D vdev->devcmd2;
> +
> +	vdev->devcmd2 =3D NULL;
> +	vdev->devcmd_rtn =3D NULL;
> +
> +	vnic_dev_free_desc_ring(vdev, &dc2c->results_ring);
> +	vnic_wq_disable(&dc2c->wq);
> +	vnic_wq_free(&dc2c->wq);
> +	kfree(dc2c);
> +}
> +
> +int vnic_dev_cmd(struct vnic_dev *vdev, enum vnic_devcmd_cmd cmd,
> +	u64 *a0, u64 *a1, int wait)
> +{
> +	int err;
> +
> +	memset(vdev->args, 0, sizeof(vdev->args));
> +	vdev->args[0] =3D *a0;
> +	vdev->args[1] =3D *a1;
> +
> +	err =3D (*vdev->devcmd_rtn)(vdev, cmd, wait);
> +
> +	*a0 =3D vdev->args[0];
> +	*a1 =3D vdev->args[1];
> +
> +	return  err;
> +}
> +
> +int vnic_dev_fw_info(struct vnic_dev *vdev,
> +	struct vnic_devcmd_fw_info **fw_info)
> +{
> +	u64 a0, a1 =3D 0;
> +	int wait =3D VNIC_DVCMD_TMO;
> +	int err =3D 0;
> +
> +	if (!vdev->fw_info) {
> +		vdev->fw_info =3D pci_alloc_consistent(vdev->pdev,
> +			sizeof(struct vnic_devcmd_fw_info),
> +			&vdev->fw_info_pa);
> +		if (!vdev->fw_info)
> +			return -ENOMEM;
> +
> +		a0 =3D vdev->fw_info_pa;
> +
> +		/* only get fw_info once and cache it */
> +		err =3D vnic_dev_cmd(vdev, CMD_MCPU_FW_INFO, &a0, &a1, wait);
> +	}
> +
> +	*fw_info =3D vdev->fw_info;
> +
> +	return err;
> +}
> +
> +int vnic_dev_spec(struct vnic_dev *vdev, unsigned int offset, unsign=
ed int size,
> +	void *value)
> +{
> +	u64 a0, a1;
> +	int wait =3D VNIC_DVCMD_TMO;
> +	int err;
> +
> +	a0 =3D offset;
> +	a1 =3D size;
> +
> +	err =3D vnic_dev_cmd(vdev, CMD_DEV_SPEC, &a0, &a1, wait);
> +
> +	switch (size) {
> +	case 1:
> +		*(u8 *)value =3D (u8)a0;
> +		break;
> +	case 2:
> +		*(u16 *)value =3D (u16)a0;
> +		break;
> +	case 4:
> +		*(u32 *)value =3D (u32)a0;
> +		break;
> +	case 8:
> +		*(u64 *)value =3D a0;
> +		break;
> +	default:
> +		BUG();
> +		break;
> +	}
> +
> +	return err;
> +}
> +
> +int vnic_dev_stats_clear(struct vnic_dev *vdev)
> +{
> +	u64 a0 =3D 0, a1 =3D 0;
> +	int wait =3D VNIC_DVCMD_TMO;
> +
> +	return vnic_dev_cmd(vdev, CMD_STATS_CLEAR, &a0, &a1, wait);
> +}
> +
> +int vnic_dev_stats_dump(struct vnic_dev *vdev, struct vnic_stats **s=
tats)
> +{
> +	u64 a0, a1;
> +	int wait =3D VNIC_DVCMD_TMO;
> +
> +	if (!vdev->stats) {
> +		vdev->stats =3D pci_alloc_consistent(vdev->pdev,
> +			sizeof(struct vnic_stats), &vdev->stats_pa);
> +		if (!vdev->stats)
> +			return -ENOMEM;
> +	}
> +
> +	*stats =3D vdev->stats;
> +	a0 =3D vdev->stats_pa;
> +	a1 =3D sizeof(struct vnic_stats);
> +
> +	return vnic_dev_cmd(vdev, CMD_STATS_DUMP, &a0, &a1, wait);
> +}
> +
> +int vnic_dev_close(struct vnic_dev *vdev)
> +{
> +	u64 a0 =3D 0, a1 =3D 0;
> +	int wait =3D VNIC_DVCMD_TMO;
> +
> +	return vnic_dev_cmd(vdev, CMD_CLOSE, &a0, &a1, wait);
> +}
> +
> +int vnic_dev_enable_wait(struct vnic_dev *vdev)
> +{
> +	u64 a0 =3D 0, a1 =3D 0;
> +	int wait =3D VNIC_DVCMD_TMO;
> +	int err =3D 0;
> +
> +	err =3D vnic_dev_cmd(vdev, CMD_ENABLE_WAIT, &a0, &a1, wait);
> +	if (err =3D=3D ERR_ECMDUNKNOWN)
> +		return vnic_dev_cmd(vdev, CMD_ENABLE, &a0, &a1, wait);
> +
> +	return err;
> +}
> +
> +int vnic_dev_disable(struct vnic_dev *vdev)
> +{
> +	u64 a0 =3D 0, a1 =3D 0;
> +	int wait =3D VNIC_DVCMD_TMO;
> +
> +	return vnic_dev_cmd(vdev, CMD_DISABLE, &a0, &a1, wait);
> +}
> +
> +int vnic_dev_open(struct vnic_dev *vdev, int arg)
> +{
> +	u64 a0 =3D (u32)arg, a1 =3D 0;
> +	int wait =3D VNIC_DVCMD_TMO;
> +
> +	return vnic_dev_cmd(vdev, CMD_OPEN, &a0, &a1, wait);
> +}
> +
> +int vnic_dev_open_done(struct vnic_dev *vdev, int *done)
> +{
> +	u64 a0 =3D 0, a1 =3D 0;
> +	int wait =3D VNIC_DVCMD_TMO;
> +	int err;
> +
> +	*done =3D 0;
> +
> +	err =3D vnic_dev_cmd(vdev, CMD_OPEN_STATUS, &a0, &a1, wait);
> +	if (err)
> +		return err;
> +
> +	*done =3D (a0 =3D=3D 0);
> +
> +	return 0;
> +}
> +
> +int vnic_dev_notify_set(struct vnic_dev *vdev, u16 intr)
> +{
> +	u64 a0, a1;
> +	int wait =3D VNIC_DVCMD_TMO;
> +
> +	if (!vdev->notify) {
> +		vdev->notify =3D pci_alloc_consistent(vdev->pdev,
> +			sizeof(struct vnic_devcmd_notify),
> +			&vdev->notify_pa);
> +		if (!vdev->notify)
> +			return -ENOMEM;
> +	}
> +
> +	a0 =3D vdev->notify_pa;
> +	a1 =3D ((u64)intr << 32) & VNIC_NOTIFY_INTR_MASK;
> +	a1 +=3D sizeof(struct vnic_devcmd_notify);
> +
> +	return vnic_dev_cmd(vdev, CMD_NOTIFY, &a0, &a1, wait);
> +}
> +
> +void vnic_dev_notify_unset(struct vnic_dev *vdev)
> +{
> +	u64 a0, a1;
> +	int wait =3D VNIC_DVCMD_TMO;
> +
> +	a0 =3D 0;  /* paddr =3D 0 to unset notify buffer */
> +	a1 =3D VNIC_NOTIFY_INTR_MASK; /* intr num =3D -1 to unreg for intr =
*/
> +	a1 +=3D sizeof(struct vnic_devcmd_notify);
> +
> +	vnic_dev_cmd(vdev, CMD_NOTIFY, &a0, &a1, wait);
> +}
> +
> +static int vnic_dev_notify_ready(struct vnic_dev *vdev)
> +{
> +	u32 *words;
> +	unsigned int nwords =3D sizeof(struct vnic_devcmd_notify) / 4;
> +	unsigned int i;
> +	u32 csum;
> +
> +	if (!vdev->notify)
> +		return 0;
> +
> +	do {
> +		csum =3D 0;
> +		memcpy(&vdev->notify_copy, vdev->notify,
> +			sizeof(struct vnic_devcmd_notify));
> +		words =3D (u32 *)&vdev->notify_copy;
> +		for (i =3D 1; i < nwords; i++)
> +			csum +=3D words[i];
> +	} while (csum !=3D words[0]);
> +
> +	return 1;
> +}
> +
> +int vnic_dev_init(struct vnic_dev *vdev, int arg)
> +{
> +	u64 a0 =3D (u32)arg, a1 =3D 0;
> +	int wait =3D VNIC_DVCMD_TMO;
> +
> +	return vnic_dev_cmd(vdev, CMD_INIT, &a0, &a1, wait);
> +}
> +
> +int vnic_dev_link_status(struct vnic_dev *vdev)
> +{
> +	if (vdev->linkstatus)
> +		return *vdev->linkstatus;
> +
> +	if (!vnic_dev_notify_ready(vdev))
> +		return 0;
> +
> +	return vdev->notify_copy.link_state;
> +}
> +
> +u32 vnic_dev_link_down_cnt(struct vnic_dev *vdev)
> +{
> +	if (!vnic_dev_notify_ready(vdev))
> +		return 0;
> +
> +	return vdev->notify_copy.link_down_cnt;
> +}
> +
> +void vnic_dev_set_intr_mode(struct vnic_dev *vdev,
> +	enum vnic_dev_intr_mode intr_mode)
> +{
> +	vdev->intr_mode =3D intr_mode;
> +}
> +
> +enum vnic_dev_intr_mode vnic_dev_get_intr_mode(
> +	struct vnic_dev *vdev)
> +{
> +	return vdev->intr_mode;
> +}
> +
> +void vnic_dev_unregister(struct vnic_dev *vdev)
> +{
> +	if (vdev) {
> +		if (vdev->notify)
> +			pci_free_consistent(vdev->pdev,
> +				sizeof(struct vnic_devcmd_notify),
> +				vdev->notify,
> +				vdev->notify_pa);
> +		if (vdev->linkstatus)
> +			pci_free_consistent(vdev->pdev,
> +				sizeof(u32),
> +				vdev->linkstatus,
> +				vdev->linkstatus_pa);
> +		if (vdev->stats)
> +			pci_free_consistent(vdev->pdev,
> +				sizeof(struct vnic_stats),
> +				vdev->stats, vdev->stats_pa);
> +		if (vdev->fw_info)
> +			pci_free_consistent(vdev->pdev,
> +				sizeof(struct vnic_devcmd_fw_info),
> +				vdev->fw_info, vdev->fw_info_pa);
> +		if (vdev->devcmd2)
> +			vnic_dev_deinit_devcmd2(vdev);
> +		kfree(vdev);
> +	}
> +}
> +
> +struct vnic_dev *vnic_dev_alloc_discover(struct vnic_dev *vdev,
> +					 void *priv,
> +					 struct pci_dev *pdev,
> +					 struct vnic_dev_bar *bar,
> +					 unsigned int num_bars)
> +{
> +	if (!vdev) {
> +		vdev =3D kzalloc(sizeof(struct vnic_dev), GFP_ATOMIC);
> +		if (!vdev)
> +			return NULL;
> +	}
> +
> +	vdev->priv =3D priv;
> +	vdev->pdev =3D pdev;
> +
> +	if (vnic_dev_discover_res(vdev, bar, num_bars))
> +		goto err_out;
> +
> +	return vdev;
> +
> +err_out:
> +	vnic_dev_unregister(vdev);
> +
> +	return NULL;
> +} /* end of vnic_dev_alloc_discover */
> +
> +/*
> + * fallback option is left to keep the interface common for other vn=
ics.
> + */
> +int vnic_dev_cmd_init(struct vnic_dev *vdev, int fallback)
> +{
> +	int err =3D -ENODEV;
> +	void __iomem *p;
> +
> +	p =3D vnic_dev_get_res(vdev, RES_TYPE_DEVCMD2, 0);
> +	if (p)
> +		err =3D vnic_dev_init_devcmd2(vdev);
> +	else
> +		pr_err("DEVCMD2 resource not found.\n");
> +
> +	return err;
> +} /* end of vnic_dev_cmd_init */
> diff --git a/drivers/scsi/snic/vnic_dev.h b/drivers/scsi/snic/vnic_de=
v.h
> new file mode 100644
> index 0000000..19f3e76
> --- /dev/null
> +++ b/drivers/scsi/snic/vnic_dev.h
> @@ -0,0 +1,140 @@
> +/*
> + * Copyright 2014 Cisco Systems, Inc.  All rights reserved.
> + *
> + * This program is free software; you may redistribute it and/or mod=
ify
> + * it under the terms of the GNU General Public License as published=
 by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES O=
=46
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDE=
RS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN A=
N
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + */
> +
> +#ifndef _VNIC_DEV_H_
> +#define _VNIC_DEV_H_
> +
> +#include "vnic_resource.h"
> +#include "vnic_devcmd.h"
> +
> +/*
> + * These defines avoid symbol clash between fnic and enic (Cisco 10G=
 Eth
> + * Driver) when both are built with CONFIG options =3Dy
> + */
So why did you choose the same name then?
Seeing that you rename them anyway, please use the correct names and do
away with this 'define'.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
