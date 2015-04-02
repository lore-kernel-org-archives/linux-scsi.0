From: "Narsimhulu Musini (nmusini)" <nmusini@cisco.com>
Subject: Re: [PATCH v2 6/9] snic:Add low level queuing interfaces
Date: Thu, 2 Apr 2015 08:13:50 +0000
Message-ID: <D142F680.1D3FD%nmusini@cisco.com>
References: <1426093299-4511-1-git-send-email-nmusini@cisco.com>
 <1426093299-4511-7-git-send-email-nmusini@cisco.com>
 <55129874.1010604@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alln-iport-8.cisco.com ([173.37.142.95]:43407 "EHLO
	alln-iport-8.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbbDBIN4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Apr 2015 04:13:56 -0400
In-Reply-To: <55129874.1010604@suse.de>
Content-Language: en-US
Content-ID: <D26E6D52BB77CD44BDEFACA8D4D62B3F@emea.cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>

Hi Hannes,

Thank you for reviewing the patch. Please find responses inline.
I will incorporate the comments and suggestions in next patch submittal=
=2E


On 25/03/15 4:43 pm, "Hannes Reinecke" <hare@suse.de> wrote:

>Hi Narsimhulu,
>
>On 03/11/2015 06:01 PM, Narsimhulu Musini wrote:
>> These files contain low level queueing interfaces includes
>> hardware queues, and management of hardware features.
>>=20
>> v2
>> driver supports x86-64 arch, so removed cpu_to_XX API to maintain
>>consistency.
>>=20
>> Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
>> Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
>> ---
>Please find some comments below.
>
>>  drivers/scsi/snic/cq_desc.h       |  77 ++++
>>  drivers/scsi/snic/cq_enet_desc.h  |  38 ++
>>  drivers/scsi/snic/vnic_cq.c       |  86 ++++
>>  drivers/scsi/snic/vnic_cq.h       | 120 +++++
>>  drivers/scsi/snic/vnic_cq_fw.h    |  62 +++
>>  drivers/scsi/snic/vnic_dev.c      | 895
>>++++++++++++++++++++++++++++++++++++++
>>  drivers/scsi/snic/vnic_dev.h      | 165 +++++++
>>  drivers/scsi/snic/vnic_devcmd.h   | 393 +++++++++++++++++
>>  drivers/scsi/snic/vnic_intr.c     |  59 +++
>>  drivers/scsi/snic/vnic_intr.h     | 127 ++++++
>>  drives/scsi/snic/vnic_resource.h |  68 +++
>>  drivers/scsi/snic/vnic_snic.h     |  54 +++
>>  drivers/scsi/snic/vnic_stats.h    |  68 +++
>>  drivers/scsi/snic/vnic_wq.c       | 236 ++++++++++
>>  drivers/scsi/snic/vnic_wq.h       | 187 ++++++++
>>  drivers/scsi/snic/wq_enet_desc.h  |  96 ++++
>>  16 files changed, 2731 insertions(+)
>>  create mode 100644 drivers/scsi/snic/cq_desc.h
>>  create mode 100644 drivers/scsi/snic/cq_enet_desc.h
>>  create mode 100644 drivers/scsi/snic/vnic_cq.c
>>  create mode 100644 drivers/scsi/snic/vnic_cq.h
>>  create mode 100644 drivers/scsi/snic/vnic_cq_fw.h
>>  create mode 100644 drivers/scsi/snic/vnic_dev.c
>>  create mode 100644 drivers/scsi/snic/vnic_dev.h
>>  create mode 100644 drivers/scsi/snic/vnic_devcmd.h
>>  create mode 100644 drivers/scsi/snic/vnic_intr.c
>>  create mode 100644 drivers/scsi/snic/vnic_intr.h
>>  create mode 100644 drivers/scsi/snic/vnic_resource.h
>>  create mode 100644 drivers/scsi/snic/vnic_snic.h
>>  create mode 100644 drivers/scsi/snic/vnic_stats.h
>>  create mode 100644 drivers/scsi/snic/vnic_wq.c
>>  create mode 100644 drivers/scsi/snic/vnic_wq.h
>>  create mode 100644 drivers/scsi/snic/wq_enet_desc.h
>>=20
>> diff --git a/drivers/scsi/snic/cq_desc.h b/drivers/scsi/snic/cq_desc=
=2Eh
>> new file mode 100644
>> index 0000000..a529056
>> --- /dev/null
>> +++ b/drivers/scsi/snic/cq_desc.h
>> @@ -0,0 +1,77 @@
>> +/*
>> + * Copyright 2014 Cisco Systems, Inc.  All rights reserved.
>> + *
>> + * This program is free software; you may redistribute it and/or mo=
dify
>> + * it under the terms of the GNU General Public Lcense as published=
 by
>> + * the Free Software Foundation; version 2 of the License.
>> + *
>> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES =
OF
>> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
>> + * NONINFRNGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDE=
RS
>> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN =
AN
>> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR I=
N
>> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
>> + * SOFTWARE.
>> + */
>> +
>> +#ifndef _CQ_DESC_H_
>> +#define _CQ_DESC_H_
>> +
>> +/*
>> + * Completion queue descriptor types
>> + */
>> +enum cq_desc_types {
>> +	CQ_DESC_TYPE_WQ_ENET =3D 0,
>> +	CQ_DESC_TYPE_DESC_COPY =3D 1,
>> +	CQ_DESC_TYPE_WQ_EXCH =3D 2,
>> +	CQ_DESC_TYPE_RQ_ENET =3D 3,
>> +	CQ_DESC_TYPE_RQ_FCP =3D 4,
>> +};
>> +
>> +/* Completion queue descriptor: 16B
>> + *
>> + * All completion queues have this basic layout.  The
>> + * type_specific area is unique for each completion
>> + * queue type.
>> + */
>> +struct cq_desc {
>> +	__le16 completed_index;
>> +	__le16 q_number;
>> +	u8 type_specific[11];
>> +	u8 type_color;
>> +};
>> +
>> +#define CQ_DESC_TYPE_BITS        4
>> +#define CQ_DESC_TYPE_MASK        ((1 << CQ_DESC_TYPE_BITS) - 1)
>> +#define CQ_DESC_COLOR_MASK       1
>> +#define CQ_DESC_COLOR_SHIFT      7
>> +#define CQ_DESC_Q_NUM_BITS       10
>> +#define CQ_DESC_Q_NUM_MASK       ((1 << CQ_DESC_Q_NUM_BITS) - 1)
>> +#define CQ_DESC_COMP_NDX_BITS    12
>> +#define CQ_DESC_COMP_NDX_MASK    ((1 << CQ_DESC_COMP_NDX_BITS) - 1)
>> +
>> +static inline void cq_desc_dec(const struct cq_desc *desc_arg,
>> +	u8 *type, u8 *color, u16 *q_number, u16 *completed_index)
>> +{
>> +	const struct cq_desc *desc =3D desc_arg;
>> +	const u8 type_color =3D desc->type_color;
>> +
>> +	*color =3D (type_color >> CQ_DESC_COLOR_SHIFT) & CQ_DESC_COLOR_MAS=
K;
>> +
>> +	/*
>> +	 * Make sure color bit is read from desc *before* other fields
>> +	 * are read from desc.  Hardware guarantees color bit is last
>> +	 * bit (byte) written.  Adding the rmb() prevents the compiler
>> +	 * and/or CPU from reordering the reads which would potentially
>> +	 * result in reading stale values.
>> +	 */
>> +	rmb();
>> +
>> +	*type =3D type_color & CQ_DESC_TYPE_MASK;
>> +	*q_number =3D le16_to_cpu(desc->q_number) & CQ_DESC_Q_NUM_MASK;
>> +	*completed_index =3D le16_to_cpu(desc->completed_index) &
>> +		CQ_DESC_COMP_NDX_MASK;
>> +}
>> +
>> +#endif /* _CQ_DESC_H_ */
>> diff --git a/drivers/scsi/snic/cq_enet_desc.h
>>b/drivers/scsi/snic/cq_enet_desc.h
>> new file mode 100644
>> index 0000000..0a1be2e
>> --- /dev/null
>> +++ b/drivers/scsi/snic/cq_enet_desc.h
>> @@ -0,0 +1,38 @@
>> +/*
>> + * Copyright 2014 Cisco Systems, Inc.  All rights reserved.
>> + *
>> + * This program is free software; you may redistribute it and/or mo=
dify
>> + * t under the terms of the GNU General Public License as published=
 by
>> + * the Free Software Foundation; version 2 of the License.
>> + *
>> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES =
OF
>> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
>> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLD=
ERS
>> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN =
AN
>> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR I=
N
>> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
>> + * SOFTWARE.
>> + */
>> +
>> +#ifndef _CQ_ENET_DESC_H_
>> +#define _CQ_ENET_DESC_H_
>> +
>> +#include "cq_desc.h"
>> +
>> +/* Ethernet completion queue descriptor: 16B */
>> +struct cq_enet_wq_desc {
>> +	__le16 completed_index;
>> +	__le16 q_number;
>> +	u8 reserved[11];
>> +	u8 type_color;
>> +};
>> +
>> +static inline void cq_enet_wq_desc_dec(struct cq_enet_wq_desc *desc=
,
>> +	u8 *type, u8 *color, u16 *q_number, u16 *completed_index)
>> +{
>> +	cq_desc_dec((struct cq_desc *)desc, type,
>> +		color, q_number, completed_index);
>> +}
>> +
>> +#endif /* _CQ_ENET_DESC_H_ */
>> diff --git a/drivers/scsi/snic/vnic_cq.c b/drivers/scsi/snic/vnic_cq=
=2Ec
>> new file mode 100644
>> index 0000000..88d4537
>> --- /dev/null
>> +++ b/drivers/scsi/snic/vnic_cq.c
>> @@ -0,0 +1,86 @@
>> +/*
>> + * Copyright 2014 Cisco Systems, Inc.  All rights reserved.
>> + *
>> + * This program is free software; you may redistribute it and/or mo=
dify
>> + * it under the terms of the GNU General Public License as publishe=
d by
>> + * the Free Software Foundation; version 2 of the License.
>> + *
>> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES =
OF
>> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
>> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLD=
ERS
>> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN =
AN
>> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF O IN
>> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
>> + * SOFTWARE.
>> + */
>> +
>> +#include <linux/errno.h>
>> +#include <linux/types.h>
>> +#include <linux/pci.h>
>> +#include "vnic_dev.h"
>> +#include "vnic_cq.h"
>> +
>> +void vnic_cq_free(struct vnic_cq *cq)
>> +{
>> +	vnic_dev_free_desc_ring(cq->vdev, &cq->ring);
>> +
>> +	cq->ctrl =3D NULL;
>> +}
>> +
>> +int vnic_cq_alloc(struct vnic_dev *vdev, struct vnic_cq *cq, unsign=
ed
>>int index,
>> +	unsigned int desc_count, unsigned int desc_size)
>> +{
>> +	int err;
>> +
>> +	cq->index =3D index;
>> +	cq->vdev =3D vdev;
>> +
>> +	cq->ctrl =3D vnic_dev_get_res(vdev, RES_TYPE_CQ, index);
>> +	if (!cq->ctrl) {
>> +		pr_err("Failed to hook CQ[%d] resource\n", index);
>> +
>> +		return -EINVAL;
>> +	}
>> +
>> +	err =3D vnic_dev_alloc_desc_ring(vdev, &cq->ring, desc_count,
>>desc_size);
>> +	if (err)
>> +		return err;
>> +
>> +	return 0;
>> +}
>> +
>> +void vnic_cq_init(struct vnic_cq *cq, unsigned int flow_control_ena=
ble,
>> +	unsigned int color_enable, unsigned int cq_head, unsigned int cq_t=
ail,
>> +	unsigned int cq_tail_color, unsigned int interrupt_enable,
>> +	unsigned int cq_entry_enable, unsigned int cq_message_enable,
>> +	unsigned int interrupt_offset, u64 cq_message_addr)
>> +{
>> +	u64 paddr;
>> +
>> +	paddr =3D (u64)cq->ring.base_addr | VNIC_PADDR_TARGET;
>> +	writeq(paddr, &cq->ctrl->ring_base);
>> +	iowrite32(cq->ring.desc_count, &cq->ctrl->ring_size);
>> +	iowrite32(flow_control_enable, &cq->ctrl->flow_control_enable);
>> +	iowrite32(color_enable, &cq->ctrl->color_enable);
>> +	iowrite32(cq_head, &cq->ctrl->cq_head);
>> +	iowrite32(cq_tail, &cq->ctrl->cq_tail);
>> +	iowrite32(cq_tail_color, &cq->ctrl->cq_tail_color);
>> +	iowrite32(interrupt_enable, &cq->ctrl->interrupt_enable);
>> +	iowrite32(cq_entry_enable, &cq->ctrl->cq_entry_enable);
>> +	iowrite32(cq_message_enable, &cq->ctrl->cq_message_enable);
>> +	iowrite32(interrupt_offset, &cq->ctrl->interrupt_offset);
>> +	writeq(cq_message_addr, &cq->ctrl->cq_message_addr);
>> +}
>> +
>> +void vnic_cq_clean(struct vnic_cq *cq)
>> +{
>> +	cq->to_clean =3D 0;
>> +	cq->last_color =3D 0;
>> +
>> +	iowrite32(0, &cq->ctrl->cq_head);
>> +	iowrite32(0, &cq->ctrl->cq_tail);
>> +	iowrite32(1, &cq->ctrl->cq_tail_color);
>> +
>> +	vnic_dev_clear_desc_ring(&cq->ring);
>> +}
>> diff --git a/drivers/scsi/snic/vnic_cq.h b/drivers/scsi/snic/vnic_cq=
=2Eh
>> new file mode 100644
>> index 0000000..fb2dc61
>> --- /dev/null
>> +++ b/drivers/scsi/snic/vnic_cq.h
>> @@ -0,0 +1,120 @@
>> +/*
>> + * Copyright 2014 Cisco Systems, Inc.  All rights reserved.
>> + *
>> + * This program is free software; you may redistribute it and/or mo=
dify
>> + * it under the terms of the GNU General Public License as publishe=
d by
>> + * the Free Software Foundation; version 2 of the License.
>> + *
>> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES =
OF
>> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
>> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLD=
ERS
>> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN =
AN
>> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR I=
N
>> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
>> + * SOFTWARE.
>> + */
>> +
>> +#ifndef _VNIC_CQ_H_
>> +#define _VNIC_CQ_H_
>> +
>> +#include "cq_desc.h"
>> +#include "vnic_dev.h"
>> +
>> +/*
>>  * These defines avoid symbol clash between fnic and enic (Cisco 10G
>>Eth
>> + * Driver) when both are built with CONFIG options =3Dy
>> + */
>> +#define vnic_cq_service snic_cq_service
>> +#define vnic_cq_free snic_cq_free
>> +#define vnic_cq_alloc snic_cq_alloc
>> +#define vic_cq_init snic_cq_init
>> +#define vnic_cq_clean snic_cq_clean
>> +
>> +/* Completion queue control */
>> +struct vnic_cq_ctrl {
>> +	u64 ring_base;			/* 0x00 *
>> +	u32 ring_size;			/* 0x08 */
>> +	u32 pad0;
>> +	u32 flow_control_enable;	/* 0x10 */
>> +	u32 pad1;
>> +	u32 color_enable;		/* 0x18 */
>> +	u32 pad2;
>> +	u32 cq_head;			/* 0x20 */
>> +	u32 pad3;
>> +	u32 cq_tail;			/* 0x28 */
>> +	u32 pad4;
>> +	u32 cq_tail_color;		/* 0x30 */
>> +	u32 pad5;
>> +	u32 interrupt_enable;		/* 0x38 */
>> +	u32 pad6;
>> +	u32 cq_entry_enable;		/* 0x40 */
>> +	u32 pad7;
>> +	u32 cq_message_enable;		/* 0x48 */
>> +	u32 pad8;
>> +	u32 interrupt_offset;		/* 0x50 */
>> +	u32 pad9;
>> +	u64 cq_message_addr;		/* 0x58 */
>> +	u32 pad10;
>> +};
>That really looks like a 64bit structure read in as 32bit values ...
>If so please use 64bit values here ...
The structure members are aligned to hardware data, I would prefer to k=
eep
it same.

>
>> +
>> +struct vnic_cq {
>> +	unsigned int index;
>> +	struct vnic_dev *vdev;
>> +	struct vnic_cq_ctrl __iomem *ctrl;	/* memory-mapped */
>> +	struct vnic_dev_ring ring;
>> +	unsigned int to_clean;
>> +	unsigned int last_color;
>> +};
>> +
>> +static inline unsigned int vnic_cq_service(struct vnic_cq *cq,
>> +	unsigned int work_to_do,
>> +	int (*q_service)(struct vnic_dev *vdev, struct cq_desc *cq_desc,
>> +	u8 type, u16 q_number, u16 completed_index, void *opaque),
>> +	void *opaque)
>> +{
>> +	struct cq_desc *cq_desc;
>> +	unsigned int work_done =3D 0;
>> +	u16 q_number, completed_index;
>> +	u8 type, color;
>> +
>> +	cq_desc =3D (struct cq_desc *)((u8 *)cq->ring.descs +
>> +		cq->ring.desc_size * cq->to_clean);
>> +	cq_desc_dec(cq_desc, &type, &color,
>> +		&q_number, &completed_index);
>> +
>> +	while (color !=3D cq->last_color) {
>> +
>> +		if ((*q_service)(cq->vdev, cq_desc, type,
>> +			q_number, completed_index, opaque))
>> +			break;
>> +
>> +		cq->to_clean++;
>> +		if (cq->to_clean =3D=3D cq->ring.desc_count) {
>> +			cq->to_clean =3D 0;
>> +			cq->last_color =3D cq->last_color ? 0 : 1;
>> +		}
>> +
>> +		cq_desc =3D (struct cq_desc *)((u8 *)cq->ring.descs +
>> +			cq->ring.desc_size * cq->toclean);
>> +		cq_desc_dec(cq_desc, &type, &color,
>> +			&q_number, &completed_index);
>> +
>> +		work_done++;
>> +		if (work_done >=3D work_to_do)
>> +			break;
>> +	}
>> +
>> +	return work_done;
>> +}
>> +
>> +void vnic_cq_free(struct vnic_cq *cq);
>> +int vnic_cq_alloc(struct vnic_dev *vdev, struct vnic_cq *cq, unsign=
ed
>>int index,
>> +	unsigned int desc_count, unsigned int desc_size);
>> +void vnic_cq_init(struct vnic_cq *cq, unsigned int flow_control_ena=
ble,
>> +	unsigned int color_enable, unsigned int cq_head, unsigned int cq_t=
ail,
>> +	unsigned int cq_tail_color, unsigned int interrupt_enable,
>> +	unsigned int cq_entry_enable, unsigned int message_enable,
>> +	unsigned int interrupt_offset, u64 message_addr);
>> +void vnic_cq_clean(struct vnic_cq *cq);
>> +#endif /* _VNIC_CQ_H_ */
>> diff --git a/drivers/scsi/snic/vnic_cq_fw.h
>>b/drivers/scsi/snic/vnic_cq_fw.h
>> new file mode 100644
>> index 0000000..c2d1bbd
>> --- /dev/null
>> +++ b/drivers/scsi/snic/vnic_cq_fw.h
>> @@ -0,0 +1,62 @@
>> +/*
>> + * Copyright 2014 Cisco Systems, Inc.  All rights reserved.
>> + *
>> + * This program is free software; you may redistribute it and/or mo=
dify
>> + * it under the terms of the GNU General Public License as publishe=
d by
>> + * the Free Software Foundation; version 2 of the License.
>> + *
>> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES =
OF
>> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
>> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLD=
ERS
>> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN =
AN
>> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR I=
N
>> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
>> + * SOFTWARE.
>> + */
>> +
>> +#ifndef _VNIC_CQ_FW_H_
>> +#define _VNIC_CQ_FW_H_
>> +
>> +#include "snic_fwint.h"
>> +
>> +static inline unsigned int
>> +vnic_cq_fw_service(struct vnic_cq *cq,
>> +		   int (*q_service)(struct vnic_dev *vdev,
>> +				    unsigned int index,
>> +				    struct snic_fw_req *desc),
>> +		   unsigned int work_to_do)
>> +
>> +{
>> +	struct snic_fw_req *desc;
>> +	unsigned int work_done =3D 0;
>> +	u8 color;
>> +
>> +	desc =3D (struct snic_fw_req *)((u8 *)cq->ring.descs +
>> +		cq->ring.desc_size * cq->to_clean);
>> +	snic_color_dec(desc, &color);
>> +
>> +	while (color !=3D cq->last_color) {
>> +
>> +		if ((*q_service)(cq->vdev, cq->index, desc))
>> +			break;
>> +
>> +		cq->to_clean++;
>> +		if (cq->to_clean =3D=3D cq->ring.desc_count) {
>> +			cq->to_clean =3D 0;
>> +			cq->last_color =3D cq->last_color ? 0 : 1;
>> +		}
>> +
>> +		desc =3D (struct snic_fw_req *)((u8 *)cq->ring.descs +
>> +			cq->ring.desc_size * cq->to_clean);
>> +		snic_color_dec(desc, &color);
>> +
>> +		work_done++;
>> +		if (work_done >=3D work_to_do)
>> +			break;
>> +	}
>> +
>> +	return work_done;
>> +}
>> +
>> +#endif /* _VNIC_CQ_FW_H_ */
>> diff --git a/drivers/scsi/snic/vnic_dev.c b/drivers/scsi/snic/vnic_d=
ev.c
>> new file mode 100644
>> index 0000000..72363dc
>> --- /dev/null
>> +++ b/drivers/scsi/snic/vnic_dev.c
>> @@ -0,0 +1,895 @@
>> +/*
>> + * Copyright 2014 Cisco Systems, Inc.  All rights reserved.
>> + *
>> + * This program is free software; you may redistribute it and/or mo=
dify
>> + * it under the terms of the GNU General Public License as publishe=
d by
>> + * the Free Software Foundation; version 2 of the License.
>> + *
>> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES =
OF
>> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
>> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLD=
ERS
>> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN =
AN
>> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR I=
N
>> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
>> + * SOFTWARE.
>> + */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/errno.h>
>> +#include <linux/types.h>
>> +#include <linux/pci.h>
>> +#include <linux/delay.h>
>> +#include <linux/if_ether.h>
>> +#include <linux/slab.h>
>> +#include "vnic_resource.h"
>> +#include "vnic_devcmd.h"
>> +#include "vnic_dev.h"
>> +#inclde "vnic_stats.h"
>> +#include "vnic_wq.h"
>> +
>> +#define SNIC_DVCMD_TMO	10000	/* Devcmd Timeout value */
>> +
>> +struct devcmd2_controller {
>> +	struct vnic_wq_ctrl __iomem *wq_ctrl;
>> +	struct vnic_dev_ring results_ring;
>> +	struct vnic_wq wq;
>> +	struct vnic_devcmd2 *cmd_ring;
>> +	struct devcmd2_result *result;
>> +	u16 next_result;
>> +	u16 result_size;
>> +	int color;
>> +};
>> +
>> +struct vnic_res {
>> +	void __iomem *vaddr;
>> +	unsigned int count;
>> +};
>> +
>> +struct vnic_dev {
>> +	void *priv;
>> +	struct pci_dev *pdev;
>> +	struct vnic_res res[RES_TYPE_MAX];
>> +	enum vnic_dev_intr_mode intr_mode;
>> +	struct vnic_devcmd __iomem *devcmd;
>> +	struct vnic_devcmd_notify *notify;
>> +	struct vnic_devcmd_notify notify_copy;
>> +	dma_addr_t notify_pa;
>> +	u32 *linkstatus;
>> +	dma_addr_t linkstatus_pa;
>> +	struct vnic_stats *stats;
>> +	dma_addr_t stats_pa;
>> +	struct vnic_devcmd_fw_info *fw_info;
>> +	dma_addr_t fw_info_pa;
>> +	u64 args[VNIC_DEVCMD_NARGS];
>> +	struct devcmd2_controller *devcmd2;
>> +
>> +	int (*devcmd_rtn)(struct vnic_dev *vdev, enum vnic_devcmd_cmd cmd,
>> +			  int wait);
>> +};
>> +
>> +#define VNIC_MAX_RES_HDR_SIZE \
>> +	(sizeof(struct vnic_resource_header) + \
>> +	sizeof(struct vnic_resource) * RES_TYPE_MAX)
>> +#define NIC_RES_STRIDE	128
>> +
>> +void *vnic_dev_priv(struct vnic_dev *vdev)
>> +{
>> +	return vdev->priv;
>> +}
>> +
>> +static int vnic_dev_discover_res(struct vnic_dev *vdev,
>> +	struct vnic_dev_bar *bar, unsigned int num_bars)
>> +{
>> +	struct vnic_resource_header __iomem *rh;
>> +	struct vnic_resource __iomem *r;
>> +	u8 type;
>> +
>> +	if (num_bars =3D=3D 0)
>> +		return -EINVAL;
>> +
>> +	if (bar->len < VNIC_MAX_RES_HDR_SIZE) {
>> +		pr_err("vNIC BAR0 res hdr length error\n");
>> +
>> +		return -EINVAL;
>> +	}
>> +
>> +	rh =3D bar->vaddr;
>> +	if (!rh) {
>> +		pr_err("vNIC BAR0 res hdr not mem-mapped\n");
>> +
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (ioread32(&rh->magic) !=3D VNIC_RES_MAGIC ||
>> +	    ioread32(&rh->version) !=3D VNIC_RES_VERSION) {
>> +		pr_err("vNIC BAR0 res magic/version error exp (%lx/%lx) curr
>>(%x/%x)\n",
>> +			VNIC_RES_MAGIC, VNIC_RES_VERSION,
>> +			ioread32(&rh->magic), ioread32(&rh->version));
>> +
>> +		return -EINVAL;
>> +	}
>> +
>> +	r =3D (struct vnic_resource __iomem *)(rh + 1);
>> +
>> +	while ((type =3D ioread8(&r->type)) !=3D RES_TYPE_EOL) {
>> +
>> +		u8 bar_num =3D ioread8(&r->bar);
>> +		u32 bar_offset =3D ioread32(&r->bar_offset);
>> +		u32 count =3D ioread32(&r->count);
>> +		u32 len;
>> +
>> +		r++;
>> +
>> +		if (bar_num >=3D num_bars)
>> +			continue;
>> +
>> +		if (!bar[bar_num].len || !bar[bar_num].vaddr)
>> +			continue;
>> +
>> +		switch (type) {
>> +		case RES_TYPE_WQ:
>> +		case RES_TYPE_RQ:
>> +		case RES_TYPE_CQ:
>> +		case RES_TYPE_INTR_CTRL:
>> +			/* each count is stride bytes long */
>> +			len =3D count * VNIC_RES_STRIDE;
>> +			if (len + bar_offset > bar->len) {
>> +				pr_err("vNIC BAR0 resource %d out-of-bounds, offset 0x%x + size
>>0x%x > bar len 0x%lx\n",
>> +					type, bar_offset,
>> +					len,
>> +					bar->len);
>> +
>> +				return -EINVAL;
>> +			}
>> +			break;
>> +
>> +		case RES_TYPE_INTR_PBA_LEGACY:
>> +		case RES_TYPE_DEVCMD:
>> +		case RES_TYPE_DEVCMD2:
>> +			len =3D count;
>> +			break;
>> +
>> +		default:
>> +			continue;
>> +		}
>> +
>> +		vdev->res[type].count =3D count;
>> +		vdev->res[type].vaddr =3D (char __iomem *)bar->vaddr + bar_offset=
;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +unsigned int vnic_dev_get_res_count(struct vnic_dev *vdev,
>> +	enum vnic_res_type type)
>> +{
>> +	return vdev->res[type].count;
>> +}
>> +
>> +void __iomem *vnic_dev_get_res(struct vnic_dev *vdev, enum
>>vnic_res_type type,
>> +	unsigned int index)
>> +{
>> +	if (!vdev->res[type].vaddr)
>> +		return NULL;
>> +
>> +	switch (type) {
>> +	case RES_TYPE_WQ:
>> +	case RES_TYPE_RQ:
>> +	case RES_TYPE_CQ:
>> +	case RES_TYPE_INTR_CTRL:
>> +		return (char __iomem *)vdev->res[type].vaddr +
>> +					index * VNIC_RES_STRIDE;
>> +
>> +	default:
>> +		return (char __iomem *)vdev->res[type].vaddr;
>> +	}
>> +}
>> +
>> +unsigned int vnic_dev_desc_ring_size(struct vnic_dev_ring *ring,
>> +				     unsigned int desc_count,
>> +				     unsigned int desc_size)
>> +{
>> +	/* The base address of the desc rings must be 512 byte aligned.
>> +	 * Descriptor count is aligned to groups of 32 descriptors.  A
>> +	 * count of 0 means the maximum 4096 descriptors.  Descriptor
>> +	 * size is aligned to 16 bytes.
>> +	 */
>> +
>> +	unsigned int count_align =3D 32;
>> +	unsigned int desc_align =3D 16;
>> +
>> +	ring->base_align =3D 512;
>> +
>> +	if (desc_count =3D=3D 0)
>> +		desc_count =3D 4096;
>> +
>> +	ring->desc_count =3D ALIGN(desc_count, count_align);
>> +
>> +	ring->desc_size =3D ALIGN(desc_size, desc_align);
>> +
>> +	ring->size =3D ring->desc_count * ring->desc_size;
>> +	ring->size_unaligned =3D ring->size + ring->base_align;
>> +
>> +	return ring->size_unaligned;
>> +}
>> +
>> +void vnic_dev_clear_desc_ring(struct vnic_dev_ring *ring)
>> +{
>> +	memset(ring->descs, 0, ring->size);
>> +}
>> +
>> +int vnic_dev_alloc_desc_ring(struct vnic_dev *vdev, struct
>>vnic_dev_ring *ring,
>> +	unsigned int desc_count, unsigned int desc_size)
>> +{
>> +	vnic_dev_desc_ring_size(ring, desc_count, desc_size);
>> +
>> +	ring->descs_unaligned =3D pci_alloc_consistent(vdev->pdev,
>> +		ring->size_unaligned,
>> +		&ring->base_addr_unaligned);
>> +
>> +	if (!ring->descs_unaligned) {
>> +		pr_err("Failed to allocate ring (size=3D%d), aborting\n",
>> +			(int)ring->size);
>> +
>> +		return -ENOMEM;
>> +	}
>> +
>> +	ring->base_addr =3D ALIGN(ring->base_addr_unaligned,
>> +		ring->base_align);
>> +	ring->descs =3D (u8 *)ring->descs_unaligned +
>> +		(ring->base_addr - ring->base_addr_unaligned);
>> +
>> +	vnic_dev_clear_desc_ring(ring);
>> +
>> +	ring->desc_avail =3D ring->desc_count - 1;
>> +
>> +	return 0;
>> +}
>> +
>> +void vnic_dev_free_desc_ring(struct vnic_dev *vdev, struct
>>vnic_dev_ring *ring)
>> +{
>> +	if (ring->descs) {
>> +		pci_free_consistent(vdev->pdev,
>> +			ring->size_unaligned,
>> +			ring->descs_unaligned,
>> +			ring->base_addr_unaligned);
>> +		ring->descs =3D NULL;
>> +	}
>> +}
>> +
>> +static int _vnic_dev_cmd2(struct vnic_dev *vdev, enum vnic_devcmd_c=
md
>>cmd,
>> +	int wait)
>> +{
>> +	struct devcmd2_controller *dc2c =3D vdev->devcmd2;
>> +	struct devcmd2_result *result =3D dc2c->result + dc2c->next_result=
;
>> +	unsigned int i;
>> +	int delay;
>> +	int err;
>> +	u32 posted;
>> +	u32 new_posted;
>> +
>> +	posted =3D ioread32(&dc2c->wq_ctrl->posted_index);
>> +
>> +	if (posted =3D=3D 0xFFFFFFFF) { /* check for hardware gone  */
>> +		/* Hardware surprise removal: return error */
>> +		return -ENODEV;
>> +	}
>> +
>> +	new_posted =3D (posted + 1) % DEVCMD2_RING_SIZE;
>> +	dc2c->cmd_ring[posted].cmd =3D cmd;
>> +	dc2c->cmd_ring[posted].flags =3D 0;
>> +
>> +	if ((_CMD_FLAGS(cmd) & _CMD_FLAGS_NOWAIT))
>> +		dc2c->cmd_ring[posted].flags |=3D DEVCMD2_FNORESULT;
>> +
>> +	if (_CMD_DIR(cmd) & _CMD_DIR_WRITE) {
>> +		for (i =3D 0; i < VNIC_DEVCMD_NARGS; i++)
>> +			dc2c->cmd_ring[posted].args[i] =3D vdev->args[i];
>> +	}
>> +	/* Adding write memory barrier prevents compiler and/or CPU
>> +	 * reordering, thus avoiding descriptor posting before
>> +	 * descriptor is initialized. Otherwise, hardware can read
>> +	 * stale descriptor fields.
>> +	 */
>> +	wmb();
>> +	iowrite32(new_posted, &dc2c->wq_ctrl->posted_index);
>> +
>> +	if (dc2c->cmd_ring[posted].flags & DEVCMD2_FNORESULT)
>> +		return 0;
>> +
>> +	for (delay =3D 0; delay < wait; delay++) {
>> +		udelay(100);
>> +		if (result->color =3D=3D dc2c->color) {
>> +			dc2c->next_result++;
>> +			if (dc2c->next_result =3D=3D dc2c->result_size) {
>> +				dc2c->next_result =3D 0;
>> +				dc2c->color =3D dc2c->color ? 0 : 1;
>> +			}
>> +			if (result->error) {
>> +				err =3D (int) result->error;
>> +				if (err !=3D ERR_ECMDUNKNOWN ||
>> +				    cmd !=3D CMD_CAPABILITY)
>> +					pr_err("Error %d devcmd %d\n",
>> +						err, _CMD_N(cmd));
>> +
>> +				return err;
>> +			}
>> +			if (_CMD_DIR(cmd) & _CMD_DIR_READ) {
>> +				/*
>> +				 * Adding the rmb() prevents the compiler
>> +				 * and/or CPU from reordering the reads which
>> +				 * would potentially result in reading stale
>> +				 * values.
>> +				 */
>> +				rmb();
>> +				for (i =3D 0; i < VNIC_DEVCMD_NARGS; i++)
>> +					vdev->args[i] =3D result->results[i];
>> +			}
>> +
>> +			return 0;
>> +		}
>> +	}
>> +
>> +	pr_err("Timed out devcmd %d\n", _CMD_N(cmd));
>> +
>> +	return -ETIMEDOUT;
>> +}
>> +
>> +static int vnic_dev_init_devcmd2(struct vnic_dev *vdev)
>> +{
>> +	struct devcmd2_controller *dc2c =3D NULL;
>> +	unsigned int fetch_idx;
>> +	int ret;
>> +	void __iomem *p;
>> +
>> +	if (vdev->devcmd2)
>> +		return 0;
>> +
>> +	p =3D vnic_dev_get_res(vdev, RES_TYPE_DEVCMD2, 0);
>> +	if (!p)
>> +		return -ENODEV;
>> +
>> +	dc2c =3D kzalloc(sizeof(*dc2c), GFP_ATOMIC);
>> +	if (!dc2c)
>> +		return -ENOMEM;
>> +
>> +	vdev->devcmd2 =3D dc2c;
>> +
>> +	dc2c->color =3D 1;
>> +	dc2c->result_size =3D DEVCMD2_RING_SIZE;
>> +
>> +	ret  =3D vnic_wq_devcmd2_alloc(vdev,
>> +				     &dc2c->wq,
>> +				     DEVCMD2_RING_SIZE,
>> +				     DEVCMD2_DESC_SIZE);
>> +	if (ret)
>> +		goto err_free_devcmd2;
>> +
>> +	fetch_idx =3D ioread32(&dc2c->wq.ctrl->fetch_index);
>> +	if (fetch_idx =3D=3D 0xFFFFFFFF) { /* check for hardware gone  */
>> +		/* Hardware surprise removal: reset fetch_index */
>> +		fetch_idx =3D 0;
>> +	}
>> +
>> +	/*
>> +	 * Don't change fetch_index ever and
>> +	 * set posted_index same as fetch_index
>> +	 * when setting up the WQ for devcmd2.
>> +	 */
>> +	vnic_wq_init_start(&dc2c->wq, 0, fetch_idx, fetch_idx, 0, 0);
>> +	vnic_wq_enable(&dc2c->wq);
>> +	ret =3D vnic_dev_alloc_desc_ring(vdev,
>> +				       &dc2c->results_ring,
>> +				       DEVCMD2_RING_SIZE,
>> +				       DEVCMD2_DESC_SIZE);
>> +	if (ret)
>> +		goto err_free_wq;
>> +
>> +	dc2c->result =3D (struct devcmd2_result *) dc2c->results_ring.desc=
s;
>> +	dc2c->cmd_ring =3D (struct vnic_devcmd2 *) dc2c->wq.ring.descs;
>> +	dc2c->wq_ctrl =3D dc2c->wq.ctrl;
>> +	vdev->args[0] =3D (u64) dc2c->results_ring.base_addr |
>>VNIC_PADDR_TARGET;
>> +	vdev->args[1] =3D DEVCMD2_RING_SIZE;
>> +
>> +	ret =3D _vnic_dev_cmd2(vdev, CMD_INITIALIZE_DEVCMD2, SNIC_DVCMD_TM=
O);
>> +	if (ret < 0)
>> +		goto err_free_desc_ring;
>> +
>> +	vdev->devcmd_rtn =3D &_vnic_dev_cmd2;
>> +	pr_info("DEVCMD2 Initialized.\n");
>> +
>> +	return ret;
>> +
>> +err_free_desc_ring:
>> +	vnic_dev_free_desc_ring(vdev, &dc2c->results_ring);
>> +
>> +err_free_wq:
>> +	vnic_wq_disable(&dc2c->wq);
>> +	vnic_wq_free(&dc2c->wq);
>> +
>> +err_free_devcmd2:
>> +	kfree(dc2c);
>> +	vdev->devcmd2 =3D NULL;
>> +
>> +	return ret;
>> +} /* end of vnic_dev_init_devcmd2 */
>> +
>> +static void vnic_dev_deinit_devcmd2(struct vnic_dev *vdev)
>> +{
>> +	struct devcmd2_controller *dc2c =3D vdev->devcmd2;
>> +
>> +	vdev->devcmd2 =3D NULL;
>> +	vdev->devcmd_rtn =3D NULL;
>> +
>> +	vnic_dev_free_desc_ring(vdev, &dc2c->results_ring);
>> +	vnic_wq_disable(&dc2c->wq);
>> +	vnic_wq_free(&dc2c->wq);
>> +	kfree(dc2c);
>> +}
>> +
>> +int vnic_dev_cmd(struct vnic_dev *vdev, enum vnic_devcmd_cmd cmd,
>> +	u64 *a0, u64 *a1, int wait)
>> +{
>> +	int err;
>> +
>> +	memset(vdev->args, 0, sizeof(vdev->args));
>> +	vdev->args[0] =3D *a0;
>> +	vdev->args[1] =3D *a1;
>> +
>> +	err =3D (*vdev->devcmd_rtn)(vdev, cmd, wait);
>> +
>> +	*a0 =3D vdev->args[0];
>> +	*a1 =3D vdev->args[1];
>> +
>> +	return  err;
>> +}
>> +
>> +int vnic_dev_fw_info(struct vnic_dev *vdev,
>> +	struct vnic_devcmd_fw_info **fw_info)
>> +{
>> +	u64 a0, a1 =3D 0;
>> +	int wait =3D SNIC_DVCMD_TMO;
>> +	int err =3D 0;
>> +
>> +	if (!vdev->fw_info) {
>> +		vdev->fw_info =3D pci_alloc_consistent(vdev->pdev,
>> +			sizeof(struct vnic_devcmd_fw_info),
>> +			&vdev->fw_info_pa);
>> +		if (!vdev->fw_info)
>> +			return -ENOMEM;
>> +
>> +		a0 =3D vdev->fw_info_pa;
>> +
>> +		/* only get fw_info once and cache it */
>> +		err =3D vnic_dev_cmd(vdev, CMD_MCPU_FW_INFO, &a0, &a1, wait);
>> +	}
>> +
>> +	*fw_info =3D vdev->fw_info;
>> +
>> +	return err;
>> +}
>> +
>> +int vnic_dev_spec(struct vnic_dev *vdev, unsigned int offset, unsig=
ned
>>int size,
>> +	void *value)
>> +{
>> +	u64 a0, a1;
>> +	int wait =3D SNIC_DVCMD_TMO;
>> +	int err;
>> +
>> +	a0 =3D offset;
>> +	a1 =3D size;
>> +
>> +	err =3D vnic_dev_cmd(vdev, CMD_DEV_SPEC, &a0, &a1, wait);
>> +
>> +	switch (size) {
>> +	case 1:
>> +		*(u8 *)value =3D (u8)a0;
>> +		break;
>> +	case 2:
>> +		*(u16 *)value =3D (u16)a0;
>> +		break;
>> +	case 4:
>> +		*(u32 *)value =3D (u32)a0;
>> +		break;
>> +	case 8:
>> +		*(u64 *)value =3D a0;
>> +		break;
>> +	default:
>> +		BUG();
>> +		break;
>> +	}
>> +
>> +	return err;
>> +}
>> +
>> +int vnic_dev_stats_clear(struct vnic_dev *vdev)
>> +{
>> +	u64 a0 =3D 0, a1 =3D 0;
>> +	int wait =3D SNIC_DVCMD_TMO;
>> +
>> +	return vnic_dev_cmd(vdev, CMD_STATS_CLEAR, &a0, &a1, wait);
>> +}
>> +
>> +int vnic_dev_stats_dump(struct vnic_dev *vdev, struct vnic_stats
>>**stats)
>> +{
>> +	u64 a0, a1;
>> +	int wait =3D SNIC_DVCMD_TMO;
>> +
>> +	if (!vdev->stats) {
>> +		vdev->stats =3D pci_alloc_consistent(vdev->pdev,
>> +			sizeof(struct vnic_stats), &vdev->stats_pa);
>> +		if (!vdev->stats)
>> +			return -ENOMEM;
>> +	}
>> +
>> +	*stats =3D vdev->stats;
>> +	a0 =3D vdev->stats_pa;
>> +	a1 =3D sizeof(struct vnic_stats);
>> +
>> +	return vnic_dev_cmd(vdev, CMD_STATS_DUMP, &a0, &a1, wait);
>> +}
>> +
>> +int vnic_dev_close(struct vnic_dev *vdev)
>> +{
>> +	u64 a0 =3D 0, a1 =3D 0;
>> +	int wait =3D SNIC_DVCMD_TMO;
>> +
>> +	return vnic_dev_cmd(vdev, CMD_CLOSE, &a0, &a1, wait);
>> +}
>> +
>> +int vnic_dev_enable(struct vnic_dev *vdev)
>> +{
>> +	u64 a0 =3D 0, a1 =3D 0;
>> +	int wait =3D SNIC_DVCMD_TMO;
>> +
>> +	return vnic_dev_cmd(vdev, CMD_ENABLE, &a0, &a1, wait);
>> +}
>> +
>> +int vnic_dev_enable_wait(struct vnic_dev *vdev)
>> +{
>> +	u64 a0 =3D 0, a1 =3D 0;
>> +	int wait =3D SNIC_DVCMD_TMO;
>> +	int err =3D 0;
>> +
>> +	err =3D vnic_dev_cmd(vdev, CMD_ENABLE_WAIT, &a0, &a1, wait);
>> +	if (err =3D=3D ERR_ECMDUNKNOWN)
>> +		return vnic_dev_cmd(vdev, CMD_ENABLE, &a0, &a1, wait);
>> +
>> +	return err;
>> +}
>> +
>> +int vnic_dev_disable(struct vnic_dev *vdev)
>> +{
>> +	u64 a0 =3D 0, a1 =3D 0;
>> +	int wait =3D SNIC_DVCMD_TMO;
>> +
>> +	return vnic_dev_cmd(vdev, CMD_DISABLE, &a0, &a1, wait);
>> +}
>> +
>> +int vnic_dev_open(struct vnic_dev *vdev, int arg)
>> +{
>> +	u64 a0 =3D (u32)arg, a1 =3D 0;
>> +	int wait =3D SNIC_DVCMD_TMO;
>> +
>> +	return vnic_dev_cmd(vdev, CMD_OPEN, &a0, &a1, wait);
>> +}
>> +
>> +int vnic_dev_open_done(struct vnic_dev *vdev, int *done)
>> +{
>> +	u64 a0 =3D 0, a1 =3D 0;
>> +	int wait =3D SNIC_DVCMD_TMO;
>> +	int err;
>> +
>> +	*done =3D 0;
>> +
>> +	err =3D vnic_dev_cmd(vdev, CMD_OPEN_STATUS, &a0, &a1, wait);
>> +	if (err)
>> +		return err;
>> +
>> +	*done =3D (a0 =3D=3D 0);
>> +
>> +	return 0;
>> +}
>> +
>> +int vnic_dev_soft_reset(struct vnic_dev *vdev, int arg)
>> +{
>> +	u64 a0 =3D (u32)arg, a1 =3D 0;
>> +	int wait =3D SNIC_DVCMD_TMO;
>> +
>> +	return vnic_dev_cmd(vdev, CMD_SOFT_RESET, &a0, &a1, wait);
>> +}
>> +
>> +int vnic_dev_soft_reset_done(struct vnic_dev *vdev, int *done)
>> +{
>> +	u64 a0 =3D 0, a1 =3D 0;
>> +	int wait =3D SNIC_DVCMD_TMO;
>> +	int err;
>> +
>> +	*done =3D 0;
>> +
>> +	err =3D vnic_dev_cmd(vdev, CMD_SOFT_RESET_STATUS, &a0, &a1, wait);
>> +	if (err)
>> +		return err;
>> +
>> +	*done =3D (a0 =3D=3D 0);
>> +
>> +	return 0;
>> +}
>> +
>> +int vnic_dev_hang_notify(struct vnic_dev *vdev)
>> +{
>> +	u64 a0, a1;
>> +	int wait =3D SNIC_DVCMD_TMO;
>> +
>> +	return vnic_dev_cmd(vdev, CMD_HANG_NOTIFY, &a0, &a1, wait);
>> +}
>> +
>> +int vnic_dev_mac_addr(struct vnic_dev *vdev, u8 *mac_addr)
>> +{
>> +	u64 a0, a1;
>> +	int wait =3D SNIC_DVCMD_TMO;
>> +	int err, i;
>> +
>> +	for (i =3D 0; i < ETH_ALEN; i++)
>> +		mac_addr[i] =3D 0;
>> +
>> +	err =3D vnic_dev_cmd(vdev, CMD_MAC_ADDR, &a0, &a1, wait);
>> +	if (err)
>> +		return err;
>> +
>> +	for (i =3D 0; i < ETH_ALEN; i++)
>> +		mac_addr[i] =3D ((u8 *)&a0)[i];
>> +
>> +	return 0;
>> +}
>> +
>> +void vnic_dev_packet_filter(struct vnic_dev *vdev, int directed, in=
t=20
>>multicast,
>> +	int broadcast, int promisc, int allmulti)
>> +{
>> +	u64 a0, a1 =3D 0;
>> +	int wait =3D SNIC_DVCMD_TMO;
>> +	int err;
>> +
>> +	a0 =3D (directed ? CMD_PFILTER_DIRECTED : 0) |
>> +	     (multicast ? CMD_PFILTER_MULTICAST : 0) |
>> +	     (broadcast ? CMD_PFILTER_BROADCAST : 0) |
>> +	     (promisc ? CMD_PFILTER_PROMISCUOUS : 0) |
>> +	     (allmulti ? CMD_PFILTER_ALL_MULTICAST : 0);
>> +
>> +	err =3D vnic_dev_cmd(vdev, CMD_PACKET_FILTER, &a0, &a1, wait);
>> +	if (err)
>> +		pr_err("Can't set packet filter\n");
>> +}
>> +
>> +void vnic_dev_add_addr(struct vnic_dev *vdev, u8 *addr)
>> +{
>> +	u64 a0 =3D 0, a1 =3D 0;
>> +	int wait =3D SNIC_DVCMD_TMO;
>> +	int err;
>> +	int i;
>> +
>> +	for (i =3D 0; i < ETH_ALEN; i++)
>> +		((u8 *)&a0)[i] =3D addr[i];
>> +
>> +	err =3D vnic_dev_cmd(vdev, CMD_ADDR_ADD, &a0, &a1, wait);
>> +	if (err)
>> +		pr_err("Can't add addr [%02x:%02x:%02x:%02x:%02x:%02x], %d\n",
>> +			addr[0], addr[1], addr[2], addr[3], addr[4], addr[5],
>> +			err);
>> +}
>> +
>> +void vnic_dev_del_addr(struct vnic_dev *vdev, u8 *addr)
>> +{
>> +	u64 a0 =3D 0, a1 =3D 0;
>> +	int wait =3D SNIC_DVCMD_TMO;
>> +	int err;
>> +	int i;
>> +
>> +	for (i =3D 0; i < ETH_ALEN; i++)
>> +		((u8 *)&a0)[i] =3D addr[i];
>> +
>> +	err =3D vnic_dev_cmd(vdev, CMD_ADDR_DEL, &a0, &a1, wait);
>> +	if (err)
>> +		pr_err("Can't del addr [%02x:%02x:%02x:%02x:%02x:%02x], %d\n",
>> +			addr[0], addr[1], addr[2], addr[3], addr[4], addr[5],
>> +			err);
>> +}
>> +
>> +int vnic_dev_notify_set(struct vnic_dev *vdev, u16 intr)
>> +{
>> +	u64 a0, a1;
>> +	int wait =3D SNIC_DVCMD_TMO;
>> +
>> +	if (!vdev->notify) {
>> +		vdev->notify =3D pci_alloc_consistent(vdev->pdev,
>> +			sizeof(struct vnic_devcmd_notify),
>> +			&vdev->notify_pa);
>> +		if (!vdev->notify)
>> +			return -ENOMEM;
>> +	}
>> +
>> +	a0 =3D vdev->notify_pa;
>> +	a1 =3D ((u64)intr << 32) & 0x0000ffff00000000ULL;
>> +	a1 +=3D sizeof(struct vnic_devcmd_notify);
>> +
>Please use a define here instead of a magic number.
Sure, I will define macro for it.
>
>> +	return vnic_dev_cmd(vdev, CMD_NOTIFY, &a0, &a1, wait);
>> +}
>> +
>> +void vnic_dev_notify_unset(struct vnic_dev *vdev)
>> +{
>> +	u64 a0, a1;
>> +	int wait =3D SNIC_DVCMD_TMO;
>> +
>> +	a0 =3D 0;  /* paddr =3D 0 to unset notify buffer */
>> +	a1 =3D 0x0000ffff00000000ULL; /* intr num =3D -1 to unreg for intr=
 */
>Same here.
Sure, I will define macro for it.

>
>> +	a1 +=3D sizeof(struct vnic_devcmd_notify);
>> +
>> +	vnic_dev_cmd(vdev, CMD_NOTIFY, &a0, &a1, wait);
>> +}
>> +
>> +static int vnic_dev_notify_ready(struct vnic_dev *vdev)
>> +{
>> +	u32 *words;
>> +	unsigned int nwords =3D sizeof(struct vnic_devcmd_notify) / 4;
>> +	unsigned int i;
>> +	u32 csum;
>> +
>> +	if (!vdev->notify)
>> +		return 0;
>> +
>> +	do {
>> +		csum =3D 0;
>> +		memcpy(&vdev->notify_copy, vdev->notify,
>> +			sizeof(struct vnic_devcmd_notify));
>> +		words =3D (u32 *)&vdev->notify_copy;
>> +		for (i =3D 1; i < nwords; i++)
>> +			csum +=3D words[i];
>> +	} while (csum !=3D words[0]);
>> +
>> +	return 1;
>> +}
>> +
>> +int vnic_dev_init(struct vnic_dev *vdev, int arg)
>> +{
>> +	u64 a0 =3D (u32)arg, a1 =3D 0;
>> +	int wait =3D SNIC_DVCMD_TMO;
>> +
>> +	return vnic_dev_cmd(vdev, CMD_INIT, &a0, &a1, wait);
>> +}
>> +
>> +u16 vnic_dev_set_default_vlan(struct vnic_dev *vdev, u16=20
>>new_default_vlan)
>> +{
>> +	u64 a0 =3D new_default_vlan, a1 =3D 0;
>> +	int wait =3D SNIC_DVCMD_TMO;
>> +	int old_vlan =3D 0;
>> +
>> +	old_vlan =3D vnic_dev_cmd(vdev, CMD_SET_DEFAULT_VLAN, &a0, &a1, wa=
it);
>> +
>> +	return (u16)old_vlan;
>> +}
>> +
>> +int vnic_dev_link_status(struct vnic_dev *vdev)
>> +{
>> +	if (vdev->linkstatus)
>> +		return *vdev->linkstatus;
>> +
>> +	if (!vnic_dev_notify_ready(vdev))
>> +		return 0;
>> +
>> +	return vdev->notify_copy.link_state;
>> +}
>> +
>> +u32 vnic_dev_port_speed(struct vnic_dev *vdev)
>> +{
>> +	if (!vnic_dev_notify_ready(vdev))
>> +		return 0;
>> +
>> +	return vdev->notify_copy.port_speed;
>> +}
>> +
>> +u32 vnic_dev_msg_lvl(struct vnic_dev *vdev)
>> +{
>> +	if (!vnic_dev_notify_ready(vdev))
>> +		return 0;
>> +
>> +	return vdev->notify_copy.msglvl;
>> +}
>> +
>> +u32 vnic_dev_mtu(struct vnic_dev *vdev)
>> +{
>> +	if (!vnic_dev_notify_ready(vdev))
>> +		return 0;
>> +
>> +	return vdev->notify_copy.mtu;
>> +}
>> +
>> +u32 vnic_dev_link_down_cnt(struct vnic_dev *vdev)
>> +{
>> +	if (!vnic_dev_notify_ready(vdev))
>> +		return 0;
>> +
>> +	return vdev->notify_copy.link_down_cnt;
>> +}
>> +
>> +void vnic_dev_set_intr_mode(struct vnic_dev *vdev,
>> +	enum vnic_dev_intr_mode intr_mode)
>> +{
>> +	vdev->intr_mode =3D intr_mode;
>> +}
>> +
>> +enum vnic_dev_intr_mode vnic_dev_get_intr_mode(
>> +	struct vnic_dev *vdev)
>> +{
>> +	return vdev->intr_mode;
>> +}
>> +
>> +void vnic_dev_unregister(struct vnic_dev *vdev)
>> +{
>> +	if (vdev) {
>> +		if (vdev->notify)
>> +			pci_free_consistent(vdev->pdev,
>> +				sizeof(struct vnic_devcmd_notify),
>> +				vdev->notify,
>> +				vdev->notify_pa);
>> +		if (vdev->linkstatus)
>> +			pci_free_consistent(vdev->pdev,
>> +				sizeof(u32),
>> +				vdev->linkstatus,
>> +				vdev->linkstatus_pa);
>> +		if (vdev->stats)
>> +			pci_free_consistent(vdev->pdev,
>> +				sizeof(struct vnic_stats),
>> +				vdev->stats, vdev->stats_pa);
>> +		if (vdev->fw_info)
>> +			pci_free_consistent(vdev->pdev,
>> +				sizeof(struct vnic_devcmd_fw_info),
>> +				vdev->fw_info, vdev->fw_info_pa);
>> +		if (vdev->devcmd2)
>> +			vnic_dev_deinit_devcmd2(vdev);
>> +		kfree(vdev);
>> +	}
>> +}
>> +
>> +struct vnic_dev *vnic_dev_alloc_discover(struct vnic_dev *vdev,
>> +					 void *priv,
>> +					 struct pci_dev *pdev,
>> +					 struct vnic_dev_bar *bar,
>> +					 unsigned int num_bars)
>> +{
>> +	if (!vdev) {
>> +		vdev =3D kzalloc(sizeof(struct vnic_dev), GFP_ATOMIC);
>> +		if (!vdev)
>> +			return NULL;
>> +	}
>> +
>> +	vdev->priv =3D priv;
>> +	vdev->pdev =3D pdev;
>> +
>> +	if (vnic_dev_discover_res(vdev, bar, num_bars))
>> +		goto err_out;
>> +
>> +	return vdev;
>> +
>> +err_out:
>> +	vnic_dev_unregister(vdev);
>> +
>> +	return NULL;
>> +} /* end of vnic_dev_alloc_discover */
>> +
>> +/*
>> + * fallback option is left to keep the interface common for other=20
>>vnics.
>> + */
>> +int vnic_dev_cmd_init(struct vnic_dev *vdev, int fallback)
>> +{
>> +	int err =3D -ENODEV;
>> +	void __iomem *p;
>> +
>> +	p =3D vnic_dev_get_res(vdev, RES_TYPE_DEVCMD2, 0);
>> +	if (p)
>> +		err =3D vnic_dev_init_devcmd2(vdev);
>> +	else
>> +		pr_err("DEVCMD2 resource not found.\n");
>> +
>> +	return err;
>> +} /* end of vnic_dev_cmd_init */
>> diff --git a/drivers/scsi/snic/vnic_dev.h b/drivers/scsi/snic/vnic_d=
ev.h
>> new file mode 100644
>> index 0000000..502bce5
>> --- /dev/null
>> +++ b/drivers/scsi/snic/vnic_dev.h
>> @@ -0,0 +1,165 @@
>> +/*
>> + * Copyright 2014 Cisco Systems, Inc.  All rights reserved.
>> + *
>> + * This program is free software; you may redistribute it and/or mo=
dify
>> + * it under the terms of the GNU General Public License as publishe=
d by
>> + * the Free Software Foundation; version 2 of the License.
>> + *
>> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES =
OF
>> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
>> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLD=
ERS
>> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN =
AN
>> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR I=
N
>> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
>> + * SOFTWARE.
>> + */
>> +
>> +#ifndef _VNIC_DEV_H_
>> +#define _VNIC_DEV_H_
>> +
>> +#include "vnic_resource.h"
>> +#include "vnic_devcmd.h"
>> +
>> +/*
>> + * These defines avoid symbol clash between fnic and enic (Cisco 10=
G=20
>>Eth
>> + * Driver) when both are built with CONFIG options =3Dy
>> + */
>> +#define vnic_dev_priv snic_dev_priv
>> +#define vnic_dev_get_res_count snic_dev_get_res_count
>> +#define vnic_dev_get_res snic_dev_get_res
>> +#define vnic_dev_desc_ring_size snic_dev_desc_ring_siz
>> +#define vnic_dev_clear_desc_ring snic_dev_clear_desc_ring
>> +#define vnic_dev_alloc_desc_ring snic_dev_alloc_desc_ring
>> +#define vnic_dev_free_desc_ring snic_dev_free_desc_ring
>> +#define vnic_dev_cmd snic_dev_cmd
>> +#define vnic_dev_fw_info snic_dev_fw_info
>> +#define vnic_dev_spec snic_dev_spec
>> +#define vnic_dev_stats_clear snic_dev_stats_clear
>> +#define vnic_dev_stats_dump snic_dev_stats_dump
>> +#define vnic_dev_hang_notify snic_dev_hang_notify
>> +#define vnic_dev_packet_filter snic_dev_packet_filter
>> +#define vnic_dev_add_addr snic_dev_add_addr
>> +#define vnic_dev_del_addr snic_dev_del_addr
>> +#define vnic_dev_mac_addr snic_dev_mac_addr
>> +#define vnic_dev_notify_set snic_dev_notify_set
>> +#define vnic_dev_notify_unset snic_dev_notify_unset
>> +#define vnic_dev_link_status snic_dev_link_status
>> +#define vnic_dev_port_speed snic_dev_port_speed
>> +#define vnic_dev_msg_lvl snic_dev_msg_lvl
>> +#define vnic_dev_mtu snic_dev_mtu
>> +#define vnic_dev_link_down_cnt snic_dev_link_down_cnt
>> +#define vnic_dev_close snic_dev_close
>> +#define vnic_dev_enable snic_dev_enable
>> +#define vnic_dev_enable_wait snic_dev_enable_wait
>> +#define vnic_dev_disable snic_dev_disable
>> +#define vnic_dev_open snic_dev_open
>> +#define vnic_dev_open_done snic_dev_open_done
>> +#define vnic_dev_init snic_dev_init
>> +#define vnic_dev_soft_reset snic_dev_soft_reset
>> +#define vnic_dev_soft_reset_done snic_dev_soft_reset_done
>> +#define vnic_dev_set_intr_mode snic_dev_set_intr_mode
>> +#define vnic_dev_get_intr_mode snic_dev_get_intr_mode
>> +#define vnic_dev_unregister snic_dev_unregister
>> +
>> +#ifndef VNIC_PADDR_TARGET
>> +#define VNIC_PADDR_TARGET	0x0000000000000000ULL
>> +#endif
>> +
>> +#ifndef readq
>> +static inline u64 readq(void __iomem *reg)
>> +{
>> +	return ((u64)readl(reg + 0x4UL) << 32) | (u64)readl(reg);
>> +}
>> +
>> +static inline void writeq(u64 val, void __iomem *reg)
>> +{
>> +	writel(val & 0xffffffff, reg);
>> +	writel(val >> 32, reg + 0x4UL);
>> +}
>Please use 'lower_32_bits' and 'upper_32_bits' here.
Sure, I will use the API

>
>> +#endif
>> +
>> +enum vnic_dev_intr_mode {
>> +	VNIC_DEV_INTR_MODE_UNKNOWN,
>> +	VNIC_DEV_INTR_MODE_INTX,
>> +	VNIC_DEV_INTR_MODE_MSI,
>> +	VNIC_DEV_INTR_MODE_MSIX,
>> +};
>> +
>> +struct vnic_dev_bar {
>> +	void __iomem *vaddr;
>> +	dma_addr_t bus_addr;
>> +	unsigned long len;
>> +};
>> +
>> +struct vnic_dev_ring {
>> +	void *descs;
>> +	size_t size;
>> +	dma_addr_t base_addr;
>> +	size_t base_align;
>> +	void *descs_unaligned;
>> +	size_t size_unaligned;
>> +	dma_addr_t base_addr_unaligned;
>> +	unsigned int desc_size;
>> +	unsigned int desc_count;
>> +	unsigned int desc_avail;
>> +};
>> +
>> +struct vnic_dev;
>> +struct vnic_stats;
>> +
>> +void *vnic_dev_priv(struct vnic_dev *vdev);
>> +unsigned int vnic_dev_get_res_count(struct vnic_dev *vdev,
>> +				    enum vnic_res_type type);
>> +void __iomem *vnic_dev_get_res(struct vnic_dev *vdev, enum=20
>>vnic_res_type type,
>> +			       unsigned int index);
>> +unsigned int vnic_dev_desc_ring_size(struct vnic_dev_ring *ring,
>> +				     unsigned int desc_count,
>> +				     unsigned int desc_size);
>> +void vnic_dev_clear_desc_ring(struct vnic_dev_ring *ring);
>> +int vnic_dev_alloc_desc_ring(struct vnic_dev *vdev, struct=20
>>vnic_dev_ring *ring,
>> +			     unsigned int desc_count, unsigned int desc_size);
>> +void vnic_dev_free_desc_ring(struct vnic_dev *vdev,
>> +			     struct vnic_dev_ring *ring);
>> +int vnic_dev_cmd(struct vnic_dev *vdev, enum vnic_devcmd_cmd cmd,
>> +		 u64 *a0, u64 *a1, int wait);
>> +int vnic_dev_fw_info(struct vnic_dev *vdev,
>> +		     struct vnic_devcmd_fw_info **fw_info);
>> +int vnic_dev_spec(struct vnic_dev *vdev, unsigned int offset,
>> +		  unsigned int size, void *value);
>> +int vnic_dev_stats_clear(struct vnic_dev *vdev);
>> +int vnic_dev_stats_dump(struct vnic_dev *vdev, struct vnic_stats=20
>>**stats);
>> +int vnic_dev_hang_notify(struct vnic_dev *vdev);
>> +void vnic_dev_packet_filter(struct vnic_dev *vdev, int directed, in=
t=20
>>multicast,
>> +			    int broadcast, int promisc, int allmulti);
>> +void vnic_dev_add_addr(struct vnic_dev *vdev, u8 *addr);
>> +void vnic_dev_del_addr(struct vnic_dev *vdev, u8 *addr);
>> +int vnic_dev_mac_addr(struct vnic_dev *vdev, u8 *mac_addr);
>> +int vnic_dev_notify_set(struct vnic_dev *vdev, u16 intr);
>> +void vnic_dev_notify_unset(struct vnic_dev *vdev);
>> +int vnic_dev_link_status(struct vnic_dev *vdev);
>> +u32 vnic_dev_port_speed(struct vnic_dev *vdev);
>> +u32 vnic_dev_msg_lvl(struct vnic_dev *vdev);
>> +u32 vnic_dev_mtu(struct vnic_dev *vdev);
>> +u32 vnic_dev_link_down_cnt(struct vnic_dev *vdev);
>> +int vnic_dev_close(struct vnic_dev *vdev);
>> +int vnic_dev_enable(struct vnic_dev *vdev);
>> +int vnic_dev_enable_wait(struct vnic_dev *vdev);
>> +int vnic_dev_disable(struct vnic_dev *vdev);
>> +int vnic_dev_open(struct vnic_dev *vdev, int arg);
>> +int vnic_dev_open_done(struct vnic_dev *vdev, int *done);
>> +int vnic_dev_init(struct vnic_dev *vdev, int arg);
>> +u16 vnic_dev_set_default_vlan(struct vnic_dev *vdev,
>> +				u16 new_default_vlan);
>> +struct vnic_dev *vnic_dev_alloc_discover(struct vnic_dev *vdev,
>> +					 void *priv, struct pci_dev *pdev,
>> +					 struct vnic_dev_bar *bar,
>> +					 unsigned int num_bars);
>> +int vnic_dev_soft_reset(struct vnic_dev *vdev, int arg);
>> +int vnic_dev_soft_reset_done(struct vnic_dev *vdev, int *done);
>> +void vnic_dev_set_intr_mode(struct vnic_dev *vdev,
>> +			    enum vnic_dev_intr_mode intr_mode);
>> +enum vnic_dev_intr_mode vnic_dev_get_intr_mode(struct vnic_dev *vde=
v);
>> +void vnic_dev_unregister(struct vnic_dev *vdev);
>> +int vnic_dev_cmd_init(struct vnic_dev *vdev, int fallback);
>> +#endif /* _VNIC_DEV_H_ */
>> diff --git a/drivers/scsi/snic/vnic_devcmd.h=20
>>b/drivers/scsi/snic/vnic_devcmd.h
>> new file mode 100644
>> index 0000000..627fe04
>> --- /dev/null
>> +++ b/drivers/scsi/snic/vnic_devcmd.h
>> @@ -0,0 +1,393 @@
>> +/*
>> + * Copyright 2014 Cisco Systems, Inc.  All rights reserved.
>> + *
>> + * This program is free software; you may redistribute it and/or mo=
dify
>> + * it under the terms of the GNU General Public License as publishe=
d by
>> + * the Free Software Foundation; version 2 of the License.
>> + *
>> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES =
OF
>> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
>> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLD=
ERS
>> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN =
AN
>> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR I=
N
>> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
>> + * SOFTWARE.
>> + */
>> +
>> +#ifndef _VNIC_DEVCMD_H_
>> +#define _VNIC_DEVCMD_H_
>> +
>> +#define _CMD_NBITS      14
>> +#define _CMD_VTYPEBITS	10
>> +#define _CMD_FLAGSBITS  6
>> +#define _CMD_DIRBITS	2
>> +
>> +#define _CMD_NMASK      ((1 << _CMD_NBITS)-1)
>> +#define _CMD_VTYPEMASK  ((1 << _CMD_VTYPEBITS)-1)
>> +#define _CMD_FLAGSMASK  ((1 << _CMD_FLAGSBITS)-1)
>> +#define _CMD_DIRMASK    ((1 << _CMD_DIRBITS)-1)
>> +
>> +#define _CMD_NSHIFT     0
>> +#define _CMD_VTYPESHIFT (_CMD_NSHIFT+_CMD_NBITS)
>> +#define _CMD_FLAGSSHIFT (_CMD_VTYPESHIFT+_CMD_VTYPEBITS)
>> +#define _CMD_DIRSHIFT   (_CMD_FLAGSSHIFT+_CMD_FLAGSBITS)
>> +
>> +/*
>> + * Direction bits (from host perspective).
>> + */
>> +#define _CMD_DIR_NONE   0U
>> +#define _CMD_DIR_WRITE  1U
>> +#define _CMD_DIR_READ   2U
>> +#define _CMD_DIR_RW     (_CMD_DIR_WRITE | _CMD_DIR_READ)
>> +
>> +/*
>> + * Flag bits.
>> + */
>> +#define _CMD_FLAGS_NONE 0U
>> +#define _CMD_FLAGS_NOWAIT 1U
>> +
>> +/*
>> + * vNIC type bits.
>> + */
>> +#define _CMD_VTYPE_NONE  0U
>> +#define _CMD_VTYPE_ENET  1U
>> +#define _CMD_VTYPE_FC    2U
>> +#define _CMD_VTYPE_SCSI  4U
>> +#define _CMD_VTYPE_ALL   (_CMD_VTYPE_ENET | _CMD_VTYPE_FC |=20
>>_CMD_VTYPE_SCSI)
>> +
>> +/*
>> + * Used to create cmds..
>> +*/
>> +#define _CMDCF(dir, flags, vtype, nr)  \
>> +	(((dir)   << _CMD_DIRSHIFT) | \
>> +	((flags) << _CMD_FLAGSSHIFT) | \
>> +	((vtype) << _CMD_VTYPESHIFT) | \
>> +	((nr)    << _CMD_NSHIFT))
>> +#define _CMDC(dir, vtype, nr)    _CMDCF(dir, 0, vtype, nr)
>> +#define _CMDCNW(dir, vtype, nr)  _CMDCF(dir, _CMD_FLAGS_NOWAIT, vty=
pe,=20
>>nr)
>> +
>> +/*
>> + * Used to decode cmds..
>> +*/
>> +#define _CMD_DIR(cmd)            (((cmd) >> _CMD_DIRSHIFT) &=20
>>_CMD_DIRMASK)
>> +#define _CMD_FLAGS(cmd)          (((cmd) >> _CMD_FLAGSSHIFT) &=20
>>_CMD_FLAGSMASK)
>> +#define _CMD_VTYPE(cmd)          (((cmd) >> _CMD_VTYPESHIFT) &=20
>>_CMD_VTYPEMASK)
>> +#define _CMD_N(cmd)              (((cmd) >> _CMD_NSHIFT) & _CMD_NMA=
SK)
>> +
>> +enum vnic_devcmd_cmd {
>> +	CMD_NONE                =3D _CMDC(_CMD_DIR_NONE, _CMD_VTYPE_NONE, =
0),
>> +
>> +	/* mcpu fw info in mem: (u64)a0=3Dpaddr to struct vnic_devcmd_fw_i=
nfo */
>> +	CMD_MCPU_FW_INFO        =3D _CMDC(_CMD_DIR_WRITE, _CMD_VTYPE_ALL, =
1),
>> +
>> +	/* dev-specific block member:
>> +	 *    in: (u16)a0=3Doffset,(u8)a1=3Dsize
>> +	 *    out: a0=3Dvalue */
>> +	CMD_DEV_SPEC            =3D _CMDC(_CMD_DIR_RW, _CMD_VTYPE_ALL, 2),
>> +
>> +	/* stats clear */
>> +	CMD_STATS_CLEAR         =3D _CMDCNW(_CMD_DIR_NONE, _CMD_VTYPE_ALL,=
 3),
>> +
>> +	/* stats dump in mem: (u64)a0=3Dpaddr to stats area,
>> +	 *                    (u16)a1=3Dsizeof stats area */
>> +	CMD_STATS_DUMP          =3D _CMDC(_CMD_DIR_WRITE, _CMD_VTYPE_ALL, =
4),
>> +
>> +	/* set Rx packet filter: (u32)a0=3Dfilters (see CMD_PFILTER_*) */
>> +	CMD_PACKET_FILTER       =3D _CMDCNW(_CMD_DIR_WRITE, _CMD_VTYPE_ALL=
, 7),
>> +
>> +	/* hang detection notification */
>> +	CMD_HANG_NOTIFY         =3D _CMDC(_CMD_DIR_NONE, _CMD_VTYPE_ALL, 8=
),
>> +
>> +	/* MAC address in (u48)a0 */
>> +	CMD_MAC_ADDR            =3D _CMDC(_CMD_DIR_READ,
>> +					_CMD_VTYPE_ENET | _CMD_VTYPE_FC, 9),
>> +
>> +	/* disable/enable promisc mode: (u8)a0=3D0/1 */
>> +/***** XXX DEPRECATED *****/
>> +	CMD_PROMISC_MODE        =3D _CMDCNW(_CMD_DIR_WRITE, _CMD_VTYPE_ENE=
T,=20
>>10),
>> +
>> +	/* disable/enable all-multi mode: (u8)a0=3D0/1 */
>> +/***** XXX DEPRECATED *****/
>A new driver and already deprecated?
>Odd.
>Maybe it should be removed altogether?
Sure, I will remove it.
>
>> +	CMD_ALLMULTI_MODE       =3D _CMDCNW(_CMD_DIR_WRITE, _CMD_VTYPE_ENE=
T,=20
>>11),
>> +
>> +	/* add addr from (u48)a0 */
>> +	CMD_ADDR_ADD            =3D _CMDCNW(_CMD_DIR_WRITE,
>> +					_CMD_VTYPE_ENET | _CMD_VTYPE_FC, 12),
>> +
>> +	/* del addr from (u48)a0 */
>> +	CMD_ADDR_DEL            =3D _CMDCNW(_CMD_DIR_WRITE,
>> +					_CMD_VTYPE_ENET | _CMD_VTYPE_FC, 13),
>> +
>> +	/* add VLAN id in (u16)a0 */
>> +	CMD_VLAN_ADD            =3D _CMDCNW(_CMD_DIR_WRITE, _CMD_VTYPE_ENE=
T,=20
>>14),
>> +
>> +	/* del VLAN id in (u16)a0 */
>> +	CMD_VLAN_DEL            =3D _CMDCNW(_CMD_DIR_WRITE, _CMD_VTYPE_ENE=
T,=20
>>15),
>> +
>> +	/* nic_cfg in (u32)a0 */
>> +	CMD_NIC_CFG             =3D _CMDCNW(_CMD_DIR_WRITE, _CMD_VTYPE_ALL=
, 16),
>> +
>> +	/* union vnic_rss_key in mem: (u64)a0=3Dpaddr, (u16)a1=3Dlen */
>> +	CMD_RSS_KEY             =3D _CMDC(_CMD_DIR_WRITE, _CMD_VTYPE_ENET,=
 17),
>> +
>> +	/* union vnic_rss_cpu in mem: (u64)a0=3Dpaddr, (u16)a1=3Dlen */
>> +	CMD_RSS_CPU             =3D _CMDC(_CMD_DIR_WRITE, _CMD_VTYPE_ENET,=
 18),
>> +
>> +	/* initiate softreset */
>> +	CMD_SOFT_RESET          =3D _CMDCNW(_CMD_DIR_NONE, _CMD_VTYPE_ALL,=
 19),
>> +
>> +	/* softreset status:
>> +	 *    out: a0=3D0 reset complete, a0=3D1 reset in progress */
>> +	CMD_SOFT_RESET_STATUS   =3D _CMDC(_CMD_DIR_READ, _CMD_VTYPE_ALL, 2=
0),
>> +
>> +	/* set struct vnic_devcmd_notify buffer in mem:
>> +	 * in:
>> +	 *   (u64)a0=3Dpaddr to notify (set paddr=3D0 to unset)
>> +	 *   (u32)a1 & 0x00000000ffffffff=3Dsizeof(struct vnic_devcmd_noti=
fy)
>> +	 *   (u16)a1 & 0x0000ffff00000000=3Dintr num (-1 for no intr)
>> +	 * out:
>> +	 *   (u32)a1 =3D effective size
>> +	 */
>> +	CMD_NOTIFY              =3D _CMDC(_CMD_DIR_RW, _CMD_VTYPE_ALL, 21)=
,
>> +
>> +	/* UNDI API: (u64)a0=3Dpaddr to s_PXENV_UNDI_ struct,
>> +	 *           (u8)a1=3DPXENV_UNDI_xxx */
>> +	CMD_UNDI                =3D _CMDC(_CMD_DIR_WRITE, _CMD_VTYPE_ENET,=
 22),
>> +
>> +	/* initiate open sequence (u32)a0=3Dflags (see CMD_OPENF_*) */
>> +	CMD_OPEN		=3D _CMDCNW(_CMD_DIR_WRITE, _CMD_VTYPE_ALL, 23),
>> +
>> +	/* open status:
>> +	 *    out: a0=3D0 open complete, a0=3D1 open in progress */
>> +	CMD_OPEN_STATUS		=3D _CMDC(_CMD_DIR_READ, _CMD_VTYPE_ALL, 24),
>> +
>> +	/* close vnic */
>> +	CMD_CLOSE		=3D _CMDC(_CMD_DIR_NONE, _CMD_VTYPE_ALL, 25),
>> +
>> +	/* initialize virtual link: (u32)a0=3Dflags (see CMD_INITF_*) */
>> +	CMD_INIT		=3D _CMDCNW(_CMD_DIR_READ, _CMD_VTYPE_ALL, 26),
>> +
>> +	/* variant of CMD_INIT, with provisioning info
>> +	 *     (u64)a0=3Dpaddr of vnic_devcmd_provinfo
>> +	 *     (u32)a1=3Dsizeof provision info */
>> +	CMD_INIT_PROV_INFO	=3D _CMDC(_CMD_DIR_WRITE, _CMD_VTYPE_ENET, 27),
>> +
>> +	/* enable virtual link */
>> +	CMD_ENABLE		=3D _CMDCNW(_CMD_DIR_WRITE, _CMD_VTYPE_ALL, 28),
>> +
>> +	/* enable virtual link, waiting variant. */
>> +	CMD_ENABLE_WAIT		=3D _CMDC(_CMD_DIR_WRITE, _CMD_VTYPE_ALL, 28),
>> +
>> +	/* disable virtual link */
>> +	CMD_DISABLE		=3D _CMDC(_CMD_DIR_NONE, _CMD_VTYPE_ALL, 29),
>> +
>> +	/* stats dump all vnics on uplink in mem: (u64)a0=3Dpaddr (u32)a1=3D=
uif */
>> +	CMD_STATS_DUMP_ALL	=3D _CMDC(_CMD_DIR_WRITE, _CMD_VTYPE_ALL, 30),
>> +
>> +	/* init status:
>> +	 *    out: a0=3D0 init complete, a0=3D1 init in progress
>> +	 *         if a0=3D0, a1=3Derrno */
>> +	CMD_INIT_STATUS		=3D _CMDC(_CMD_DIR_READ, _CMD_VTYPE_ALL, 31),
>> +
>> +	/* INT13 API: (u64)a0=3Dpaddr to vnic_int13_params struct
>> +	 *            (u8)a1=3DINT13_CMD_xxx */
>> +	CMD_INT13               =3D _CMDC(_CMD_DIR_WRITE, _CMD_VTYPE_FC, 3=
2),
>> +
>> +	/* logical uplink enable/disable: (u64)a0: 0/1=3Ddisable/enable */
>> +	CMD_LOGICAL_UPLINK      =3D _CMDCNW(_CMD_DIR_WRITE, _CMD_VTYPE_ENE=
T,=20
>>33),
>> +
>> +	/* undo initialize of virtual link */
>> +	CMD_DEINIT		=3D _CMDCNW(_CMD_DIR_NONE, _CMD_VTYPE_ALL, 34),
>> +
>> +	/* check fw capability of a cmd:
>> +	 * in:  (u32)a0=3Dcmd
>> +	 * out: (u32)a0=3Derrno, 0:valid cmd, a1=3Dsupported VNIC_STF_* bi=
ts */
>> +	CMD_CAPABILITY      =3D _CMDC(_CMD_DIR_RW, _CMD_VTYPE_ALL, 36),
>> +
>> +	/* persistent binding info
>> +	 * in:  (u64)a0=3Dpaddr of arg
>> +	 *      (u32)a1=3DCMD_PERBI_XXX */
>> +	CMD_PERBI       =3D _CMDC(_CMD_DIR_RW, _CMD_VTYPE_FC, 37),
>> +
>> +	/* Interrupt Assert Register functionality
>> +	 * in: (u16)a0=3Dinterrupt number to assert
>> +	 */
>> +	CMD_IAR         =3D _CMDCNW(_CMD_DIR_WRITE, _CMD_VTYPE_ALL, 38),
>> +
>> +	/* initiate hangreset, like softreset after hang detected */
>> +	CMD_HANG_RESET      =3D _CMDC(_CMD_DIR_NONE, _CMD_VTYPE_ALL, 39),
>> +
>> +	/* hangreset status:
>> +	 *    out: a0=3D0 reset complete, a0=3D1 reset in progress */
>> +	CMD_HANG_RESET_STATUS   =3D _CMDC(_CMD_DIR_READ, _CMD_VTYPE_ALL, 4=
0),
>> +
>> +	/*
>> +	 * Set hw ingress packet vlan rewrite mode:
>> +	 * in:  (u32)a0=3Dnew vlan rewrite mode
>> +	 * out: (u32)a0=3Dold vlan rewrite mode */
>> +	CMD_IG_VLAN_REWRITE_MODE =3D _CMDC(_CMD_DIR_RW, _CMD_VTYPE_ENET, 4=
1),
>> +
>> +	/*
>> +	 * in:  (u16)a0=3Dbdf of target vnic
>> +	 *      (u32)a1=3Dcmd to proxy
>> +	 *      a2-a15=3Dargs to cmd in a1
>> +	 * out: (u32)a0=3Dstatus of proxied cmd
>> +	 *      a1-a15=3Dout args of proxied cmd */
>> +	CMD_PROXY_BY_BDF =3D  _CMDC(_CMD_DIR_RW, _CMD_VTYPE_ALL, 42),
>> +
>> +	/*
>> +	 * As for BY_BDF except a0 is index of hvnlink subordinate vnic
>> +	 * or SR-IOV virtual vnic
>> +	 */
>> +	CMD_PROXY_BY_INDEX =3D    _CMDC(_CMD_DIR_RW, _CMD_VTYPE_ALL, 43),
>> +
>> +	/*
>> +	 * For HPP toggle:
>> +	 * adapter-info-get
>> +	 * in:  (u64)a0=3Dphsical address of buffer passed in from caller.
>> +	 *      (u16)a1=3Dsize of buffer specified in a0.
>> +	 * out: (u64)a0=3Dphsical address of buffer passed in from caller.
>> +	 *      (u16)a1=3Dactual bytes from VIF-CONFIG-INFO TLV, or
>> +	 *              0 if no VIF-CONFIG-INFO TLV was ever received. */
>> +	CMD_CONFIG_INFO_GET =3D _CMDC(_CMD_DIR_RW, _CMD_VTYPE_ALL, 44),
>> +
>> +	/*
>> +	 * INT13 API: (u64)a0=3Dpaddr to vnic_int13_params struct
>> +	 *            (u32)a1=3DINT13_CMD_xxx
>> +	 */
>> +	CMD_INT13_ALL =3D _CMDC(_CMD_DIR_WRITE, _CMD_VTYPE_ALL, 45),
>> +
>> +	/*
>> +	 * Set default vlan:
>> +	 * in: (u16)a0=3Dnew default vlan
>> +	 *     (u16)a1=3Dzero for overriding vlan with param a0,
>> +	 *             non-zero for resetting vlan to the default
>> +	 * out: (u16)a0=3Dold default vlan
>> +	 */
>> +	CMD_SET_DEFAULT_VLAN =3D _CMDC(_CMD_DIR_RW, _CMD_VTYPE_ALL, 46),
>> +
>> +	/*
>> +	 * Initialization for the devcmd2 interface.
>> +	 * in: (u64) a0=3Dhost result buffer physical address
>> +	 * in: (u16) a1=3Dnumber of entries in result buffer
>> +	 */
>> +	CMD_INITIALIZE_DEVCMD2 =3D _CMDC(_CMD_DIR_WRITE, _CMD_VTYPE_ALL, 5=
7)
>> +};
>> +
>> +/* flags for CMD_OPEN */
>> +#define CMD_OPENF_OPROM		0x1	/* open coming from option rom */
>> +
>> +/* flags for CMD_INIT */
>> +#define CMD_INITF_DEFAULT_MAC	0x1	/* init with default mac addr */
>> +
>> +/* flags for CMD_PACKET_FILTER */
>> +#define CMD_PFILTER_DIRECTED		0x01
>> +#define CMD_PFILTER_MULTICAST		0x02
>> +#define CMD_PFILTER_BROADCAST		0x04
>> +#define CMD_PFILTER_PROMISCUOUS		0x08
>> +#define CMD_PFILTER_ALL_MULTICAST	0x10
>> +
>> +enum vnic_devcmd_status {
>> +	STAT_NONE =3D 0,
>> +	STAT_BUSY =3D 1 << 0,	/* cmd in progress */
>> +	STAT_ERROR =3D 1 << 1,	/* last cmd caused error (code in a0) */
>> +};
>> +
>> +enum vnic_devcmd_error {
>> +	ERR_SUCCESS =3D 0,
>> +	ERR_EINVAL =3D 1,
>> +	ERR_EFAULT =3D 2,
>> +	ERR_EPERM =3D 3,
>> +	ERR_EBUSY =3D 4,
>> +	ERR_ECMDUNKNOWN =3D 5,
>> +	ERR_EBADSTATE =3D 6,
>> +	ERR_ENOMEM =3D 7,
>> +	ERR_ETIMEDOUT =3D 8,
>> +	ERR_ELINKDOWN =3D 9,
>> +};
>> +
>> +struct vnic_devcmd_fw_info {
>> +	char fw_version[32];
>> +	char fw_build[32];
>> +	char hw_version[32];
>> +	char hw_serial_number[32];
>> +};
>> +
>> +struct vnic_devcmd_notify {
>> +	u32 csum;		/* checksum over following words */
>> +
>> +	u32 link_state;		/* link up =3D=3D 1 */
>> +	u32 port_speed;		/* effective port speed (rate limit) */
>> +	u32 mtu;		/* MTU */
>> +	u32 msglvl;		/* requested driver msg lvl */
>> +	u32 uif;		/* uplink interface */
>> +	u32 status;		/* status bits (see VNIC_STF_*) */
>> +	u32 error;		/* error code (see ERR_*) for first ERR */
>> +	u32 link_down_cnt;	/* running count of link down transitions */
>> +};
>> +#define VNIC_STF_FATAL_ERR	0x0001	/* fatal fw error */
>> +
>> +struct vnic_devcmd_provinfo {
>> +	u8 oui[3];
>> +	u8 type;
>> +	u8 data[0];
>> +};
>> +
>> +/*
>> + * Writing cmd register causes STAT_BUSY to get set in status regis=
ter.
>> + * When cmd completes, STAT_BUSY will be cleared.
>> + *
>> + * If cmd completed successfully STAT_ERROR will be clear
>> + * and args registers contain cmd-specific results.
>> + *
>> + * If cmd error, STAT_ERROR will be set and args[0] contains error=20
>>code.
>> + *
>> + * status register is read-only.  While STAT_BUSY is set,
>> + * all other register contents are read-only.
>> + */
>> +
>> +/* Make sizeof(vnic_devcmd) a power-of-2 for I/O BAR. */
>> +#define VNIC_DEVCMD_NARGS 15
>> +struct vnic_devcmd {
>> +	u32 status;			/* RO */
>> +	u32 cmd;			/* RW */
>> +	u64 args[VNIC_DEVCMD_NARGS];	/* RW cmd args (little-endian) */
>> +};
>> +
>> +
>> +/*
>> + * Version 2 of the interface.
>> + *
>> + * Some things are carried over, notably the vnic_devcmd_cmd enum.
>> + */
>> +
>> +/*
>> + * Flags for vnic_devcmd2.flags
>> + */
>> +
>> +#define DEVCMD2_FNORESULT       0x1     /* Don't copy result to hos=
t */
>> +
>> +#define VNIC_DEVCMD2_NARGS      VNIC_DEVCMD_NARGS
>> +struct vnic_devcmd2 {
>> +	u16 pad;
>> +	u16 flags;
>> +	u32 cmd;                /* same command #defines as original */
>> +	u64 args[VNIC_DEVCMD2_NARGS];
>> +};
>> +
>> +#define VNIC_DEVCMD2_NRESULTS   VNIC_DEVCMD_NARGS
>> +struct devcmd2_result {
>> +	u64 results[VNIC_DEVCMD2_NRESULTS];
>> +	u32 pad;
>> +	u16 completed_index;    /* into copy WQ */
>> +	u8  error;              /* same error codes as original */
>> +	u8  color;              /* 0 or 1 as with completion queues */
>> +};
>> +
>> +#define DEVCMD2_RING_SIZE   32
>> +#define DEVCMD2_DESC_SIZE   128
>> +
>> +#define DEVCMD2_RESULTS_SIZE_MAX   ((1 << 16) - 1)
>> +
>> +#endif /* _VNIC_DEVCMD_H_ */
>> diff --git a/drivers/scsi/snic/vnic_intr.c=20
>>b/drivers/scsi/snic/vnic_intr.c
>> new file mode 100644
>> index 0000000..fbbfd90
>> --- /dev/null
>> +++ b/drivers/scsi/snic/vnic_intr.c
>> @@ -0,0 +1,59 @@
>> +/*
>> + * Copyright 2014 Cisco Systems, Inc.  All rights reserved.
>> + *
>> + * This program is free software; you may redistribute it and/or mo=
dify
>> + * it under the terms of the GNU General Public License as publishe=
d by
>> + * the Free Software Foundation; version 2 of the License.
>> + *
>> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES =
OF
>> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
>> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLD=
ERS
>> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN =
AN
>> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR I=
N
>> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
>> + * SOFTWARE.
>> + */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/errno.h>
>> +#include <linux/types.h>
>> +#include <linux/pci.h>
>> +#include <linux/delay.h>
>> +#include "vnic_dev.h"
>> +#include "vnic_intr.h"
>> +
>> +void vnic_intr_free(struct vnic_intr *intr)
>> +{
>> +	intr->ctrl =3D NULL;
>> +}
>> +
>> +int vnic_intr_alloc(struct vnic_dev *vdev, struct vnic_intr *intr,
>> +	unsigned int index)
>> +{
>> +	intr->index =3D index;
>> +	intr->vdev =3D vdev;
>> +
>> +	intr->ctrl =3D vnic_dev_get_res(vdev, RES_TYPE_INTR_CTRL, index);
>> +	if (!intr->ctrl) {
>> +		pr_err("Failed to hook INTR[%d].ctrl resource\n",
>> +			index);
>> +		return -EINVAL;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +void vnic_intr_init(struct vnic_intr *intr, unsigned int=20
>>coalescing_timer,
>> +	unsigned int coalescing_type, unsigned int mask_on_assertion)
>> +{
>> +	iowrite32(coalescing_timer, &intr->ctrl->coalescing_timer);
>> +	iowrite32(coalescing_type, &intr->ctrl->coalescing_type);
>> +	iowrite32(mask_on_assertion, &intr->ctrl->mask_on_assertion);
>> +	iowrite32(0, &intr->ctrl->int_credits);
>> +}
>> +
>> +void vnic_intr_clean(struct vnic_intr *intr)
>> +{
>> +	iowrite32(0, &intr->ctrl->int_credits);
>> +}
>> diff --git a/drivers/scsi/snic/vnic_intr.h=20
>>b/drivers/scsi/snic/vnic_intr.h
>> new file mode 100644
>> index 0000000..25da8d2
>> --- /dev/null
>> +++ b/drivers/scsi/snic/vnic_intr.h
>> @@ -0,0 +1,127 @@
>> +/*
>> + * Copyright 2014 Cisco Systems, Inc.  All rights reserved.
>> + *
>> + * This program is free software; you may redistribute it and/or mo=
dify
>> + * it under the terms of the GNU General Public License as publishe=
d by
>> + * the Free Software Foundation; version 2 of the License.
>> + *
>> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES =
OF
>> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
>> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLD=
ERS
>> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN =
AN
>> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR I=
N
>> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
>> + * SOFTWARE.
>> + */
>> +
>> +#ifndef _VNIC_INTR_H_
>> +#define _VNIC_INTR_H_
>> +
>> +#include <linux/pci.h>
>> +#include "vnic_dev.h"
>> +
>> +/*
>> + * These defines avoid symbol clash between fnic and enic (Cisco 10=
G=20
>>Eth
>> + * Driver) when both are built with CONFIG options =3Dy
>> + */
>> +#define vnic_intr_unmask snic_intr_unmask
>> +#define vnic_intr_mask snic_intr_mask
>> +#define vnic_intr_return_credits snic_intr_return_credits
>> +#define vnic_intr_credits snic_intr_credits
>> +#define vnic_intr_return_all_credits snic_intr_return_all_credits
>> +#define vnic_intr_legacy_pba snic_intr_legacy_pba
>> +#define vnic_intr_free snic_intr_free
>> +#define vnic_intr_alloc snic_intr_alloc
>> +#define vnic_intr_init snic_intr_init
>> +#define vnic_intr_clean snic_intr_clean
>> +
>> +#define VNIC_INTR_TIMER_MAX		0xffff
>> +
>> +#define VNIC_INTR_TIMER_TYPE_ABS	0
>> +#define VNIC_INTR_TIMER_TYPE_QUIET	1
>> +
>> +/* Interrupt control */
>> +struct vnic_intr_ctrl {
>> +	u32 coalescing_timer;		/* 0x00 */
>> +	u32 pad0;
>> +	u32 coalescing_value;		/* 0x08 */
>> +	u32 pad1;
>> +	u32 coalescing_type;		/* 0x10 */
>> +	u32 pad2;
>> +	u32 mask_on_assertion;		/* 0x18 */
>> +	u32 pad3;
>> +	u32 mask;			/* 0x20 */
>> +	u32 pad4;
>> +	u32 int_credits;		/* 0x28 */
>> +	u32 pad5;
>> +	u32 int_credit_return;		/* 0x30 */
>> +	u32 pad6;
>> +};
>Again, one of those curious structures which _look_ like 64bit
>values ...
The structure members are aligned to hardware data, I would prefer to k=
eep=20
it same.

>
>> +
>> +struct vnic_intr {
>> +	unsigned int index;
>> +	struct vnic_dev *vdev;
>> +	struct vnic_intr_ctrl __iomem *ctrl;	/* memory-mapped */
>> +};
>> +
>> +static inline void
>> +vnic_intr_unmask(struct vnic_intr *intr)
>> +{
>> +	iowrite32(0, &intr->ctrl->mask);
>> +}
>> +
>> +static inline void
>> +vnic_intr_mask(struct vnic_intr *intr)
>> +{
>> +	iowrite32(1, &intr->ctrl->mask);
>> +}
>> +
>> +static inline void
>> +vnic_intr_return_credits(struct vnic_intr *intr,
>> +			 unsigned int credits,
>> +			 int unmask,
>> +			 int reset_timer)
>> +{
>> +#define VNIC_INTR_UNMASK_SHIFT		16
>> +#define VNIC_INTR_RESET_TIMER_SHIFT	17
>> +
>> +	u32 int_credit_return =3D (credits & 0xffff) |
>> +		(unmask ? (1 << VNIC_INTR_UNMASK_SHIFT) : 0) |
>> +		(reset_timer ? (1 << VNIC_INTR_RESET_TIMER_SHIFT) : 0);
>> +
>> +	iowrite32(int_credit_return, &intr->ctrl->int_credit_return);
>> +}
>> +
>> +static inline unsigned int
>> +vnic_intr_credits(struct vnic_intr *intr)
>> +{
>> +	return ioread32(&intr->ctrl->int_credits);
>> +}
>> +
>> +static inline void
>> +vnic_intr_return_all_credits(struct vnic_intr *intr)
>> +{
>> +	unsigned int credits =3D vnic_intr_credits(intr);
>> +	int unmask =3D 1;
>> +	int reset_timer =3D 1;
>> +
>> +	vnic_intr_return_credits(intr, credits, unmask, reset_timer);
>> +}
>> +
>> +static inline u32
>> +vnic_intr_legacy_pba(u32 __iomem *legacy_pba)
>> +{
>> +	/* read PBA without clearing */
>> +	return ioread32(legacy_pba);
>> +}
>> +
>> +void vnic_intr_free(struct vnic_intr *);
>> +int vnic_intr_alloc(struct vnic_dev *, struct vnic_intr *, unsigned=
=20
>>int);
>> +void vnic_intr_init(struct vnic_intr *intr,
>> +		    unsigned int coalescing_timer,
>> +		    unsigned int coalescing_type,
>> +		    unsigned int mask_on_assertion);
>> +void vnic_intr_clean(struct vnic_intr *);
>> +
>> +#endif /* _VNIC_INTR_H_ */
>> diff --git a/drivers/scsi/snic/vnic_resource.h=20
>>b/drivers/scsi/snic/vnic_resource.h
>> new file mode 100644
>> index 0000000..9713d68
>> --- /dev/null
>> +++ b/drivers/scsi/snic/vnic_resource.h
>> @@ -0,0 +1,68 @@
>> +/*
>> + * Copyright 2014 Cisco Systems, Inc.  All rights reserved.
>> + *
>> + * This program is free software; you may redistribute it and/or mo=
dify
>> + * it under the terms of the GNU General Public License as publishe=
d by
>> + * the Free Software Foundation; version 2 of the License.
>> + *
>> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES =
OF
>> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
>> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLD=
ERS
>> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN =
AN
>> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR I=
N
>> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
>> + * SOFTWARE.
>> + */
>> +
>> +#ifndef _VNIC_RESOURCE_H_
>> +#define _VNIC_RESOURCE_H_
>> +
>> +#define VNIC_RES_MAGIC		0x766E6963L	/* 'vnic' */
>> +#define VNIC_RES_VERSION	0x00000000L
>> +
>> +/* vNIC resource types */
>> +enum vnic_res_type {
>> +	RES_TYPE_EOL,			/* End-of-list */
>> +	RES_TYPE_WQ,			/* Work queues */
>> +	RES_TYPE_RQ,			/* Receive queues */
>> +	RES_TYPE_CQ,			/* Completion queues */
>> +	RES_TYPE_RSVD1,
>> +	RES_TYPE_NIC_CFG,		/* Enet NIC config registers */
>> +	RES_TYPE_RSVD2,
>> +	RES_TYPE_RSVD3,
>> +	RES_TYPE_RSVD4,
>> +	RES_TYPE_RSVD5,
>> +	RES_TYPE_INTR_CTRL,		/* Interrupt ctrl table */
>> +	RES_TYPE_INTR_TABLE,		/* MSI/MSI-X Interrupt table */
>> +	RES_TYPE_INTR_PBA,		/* MSI/MSI-X PBA table */
>> +	RES_TYPE_INTR_PBA_LEGACY,	/* Legacy intr status */
>> +	RES_TYPE_RSVD6,
>> +	RES_TYPE_RSVD7,
>> +	RES_TYPE_DEVCMD,		/* Device command region */
>> +	RES_TYPE_PASS_THRU_PAGE,	/* Pass-thru page */
>> +	RES_TYPE_SUBVNIC,		/* subvnic resource type */
>> +	RES_TYPE_MQ_WQ,			/* MQ Work queues */
>> +	RES_TYPE_MQ_RQ,			/* MQ Receive queues */
>> +	RES_TYPE_MQ_CQ,			/* MQ Completion queues */
>> +	RES_TYPE_DEPRECATED1,		/* Old version of devcmd 2 */
>> +	RES_TYPE_DEPRECATED2,		/* Old version of devcmd 2 */
>> +	RES_TYPE_DEVCMD2,		/* Device control region */
>> +
>> +	RES_TYPE_MAX,			/* Count of resource types */
>> +};
>> +
>> +struct vnic_resource_header {
>> +	u32 magic;
>> +	u32 version;
>> +};
>> +
>> +struct vnic_resource {
>> +	u8 type;
>> +	u8 bar;
>> +	u8 pad[2];
>> +	u32 bar_offset;
>> +	u32 count;
>> +};
>> +
>> +#endif /* _VNIC_RESOURCE_H_ */
>> diff --git a/drivers/scsi/snic/vnic_snic.h=20
>>b/drivers/scsi/snic/vnic_snic.h
>> new file mode 100644
>> index 0000000..514d39f
>> --- /dev/null
>> +++ b/drivers/scsi/snic/vnic_snic.h
>> @@ -0,0 +1,54 @@
>> +/*
>> + * Copyright 2014 Cisco Systems, Inc.  All rights reserved.
>> + *
>> + * This program is free software; you may redistribute it and/or mo=
dify
>> + * it under the terms of the GNU General Public License as publishe=
d by
>> + * the Free Software Foundation; version 2 of the License.
>> + *
>> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES =
OF
>> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
>> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLD=
ERS
>> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN =
AN
>> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR I=
N
>> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
>> + * SOFTWARE.
>> + */
>> +
>> +#ifndef _VNIC_SNIC_H_
>> +#define _VNIC_SNIC_H_
>> +
>> +#define VNIC_SNIC_WQ_DESCS_MIN              64
>> +#define VNIC_SNIC_WQ_DESCS_MAX              1024
>> +
>> +#define VNIC_SNIC_MAXDATAFIELDSIZE_MIN      256
>> +#define VNIC_SNIC_MAXDATAFIELDSIZE_MAX      2112
>> +
>> +#define VNIC_SNIC_IO_THROTTLE_COUNT_MIN     1
>> +#define VNIC_SNIC_IO_THROTTLE_COUNT_MAX     1024
>> +
>> +#define VNIC_SNIC_PORT_DOWN_TIMEOUT_MIN     0
>> +#define VNIC_SNIC_PORT_DOWN_TIMEOUT_MAX     240000
>> +
>> +#define VNIC_SNIC_PORT_DOWN_IO_RETRIES_MIN  0
>> +#define VNIC_SNIC_PORT_DOWN_IO_RETRIES_MAX  255
>> +
>> +#define VNIC_SNIC_LUNS_PER_TARGET_MIN       1
>> +#define VNIC_SNIC_LUNS_PER_TARGET_MAX       1024
>> +
>> +/* Device-specific region: scsi configuration */
>> +struct vnic_snic_config {
>> +	u32 flags;
>> +	u32 wq_enet_desc_count;
>> +	u32 io_throttle_count;
>> +	u32 port_down_timeout;
>> +	u32 port_down_io_retries;
>> +	u32 luns_per_tgt;
>> +	u16 maxdatafieldsize;
>> +	u16 intr_timer;
>> +	u8 intr_timer_type;
>> +	u8 _resvd2;
>> +	u8 xpt_type;
>> +	u8 hid;
>> +};
>> +#endif /* _VNIC_SNIC_H_ */
>> diff --git a/drivers/scsi/snic/vnic_stats.h=20
>>b/drivers/scsi/snic/vnic_stats.h
>> new file mode 100644
>> index 0000000..370a37c
>> --- /dev/null
>> +++ b/drivers/scsi/snic/vnic_stats.h
>> @@ -0,0 +1,68 @@
>> +/*
>> + * Copyright 2014 Cisco Systems, Inc.  All rights reserved.
>> + *
>> + * This program is free software; you may redistribute it and/or mo=
dify
>> + * it under the terms of the GNU General Public License as publishe=
d by
>> + * the Free Software Foundation; version 2 of the License.
>> + *
>> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES =
OF
>> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
>> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLD=
ERS
>> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN =
AN
>> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR I=
N
>> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
>> + * SOFTWARE.
>> + */
>> +
>> +#ifndef _VNIC_STATS_H_
>> +#define _VNIC_STATS_H_
>> +
>> +/* Tx statistics */
>> +struct vnic_tx_stats {
>> +	u64 tx_frames_ok;
>> +	u64 tx_unicast_frames_ok;
>> +	u64 tx_multicast_frames_ok;
>> +	u64 tx_broadcast_frames_ok;
>> +	u64 tx_bytes_ok;
>> +	u64 tx_unicast_bytes_ok;
>> +	u64 tx_multicast_bytes_ok;
>> +	u64 tx_broadcast_bytes_ok;
>> +	u64 tx_drops;
>> +	u64 tx_errors;
>> +	u64 tx_tso;
>> +	u64 rsvd[16];
>> +};
>> +
>> +/* Rx statistics */
>> +struct vnic_rx_stats {
>> +	u64 rx_frames_ok;
>> +	u64 rx_frames_total;
>> +	u64 rx_unicast_frames_ok;
>> +	u64 rx_multicast_frames_ok;
>> +	u64 rx_broadcast_frames_ok;
>> +	u64 rx_bytes_ok;
>> +	u64 rx_unicast_bytes_ok;
>> +	u64 rx_multicast_bytes_ok;
>> +	u64 rx_broadcast_bytes_ok;
>> +	u64 rx_drop;
>> +	u64 rx_no_bufs;
>> +	u64 rx_errors;
>> +	u64 rx_rss;
>> +	u64 rx_crc_errors;
>> +	u64 rx_frames_64;
>> +	u64 rx_frames_127;
>> +	u64 rx_frames_255;
>> +	u64 rx_frames_511;
>> +	u64 rx_frames_1023;
>> +	u64 rx_frames_1518;
>> +	u64 rx_frames_to_max;
>> +	u64 rsvd[16];
>> +};
>> +
>> +struct vnic_stats {
>> +	struct vnic_tx_stats tx;
>> +	struct vnic_rx_stats rx;
>> +};
>> +
>> +#endif /* _VNIC_STATS_H_ */
>> diff --git a/drivers/scsi/snic/vnic_wq.c b/drivers/scsi/snic/vnic_wq=
=2Ec
>> new file mode 100644
>> index 0000000..b323c10
>> --- /dev/null
>> +++ b/drivers/scsi/snic/vnic_wq.c
>> @@ -0,0 +1,236 @@
>> +/*
>> + * Copyright 2014 Cisco Systems, Inc.  All rights reserved.
>> + *
>> + * This program is free software; you may redistribute it and/or mo=
dify
>> + * it under the terms of the GNU General Public License as publishe=
d by
>> + * the Free Software Foundation; version 2 of the License.
>> + *
>> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES =
OF
>> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
>> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLD=
ERS
>> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN =
AN
>> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR I=
N
>> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
>> + * SOFTWARE.
>> + */
>> +
>> +#include <linux/errno.h>
>> +#include <linux/types.h>
>> +#include <linux/pci.h>
>> +#include <linux/delay.h>
>> +#include <linux/slab.h>
>> +#include "vnic_dev.h"
>> +#include "vnic_wq.h"
>> +
>> +static inline int vnic_wq_get_ctrl(struct vnic_dev *vdev, struct=20
>>vnic_wq *wq,
>> +	unsigned int index, enum vnic_res_type res_type)
>> +{
>> +	wq->ctrl =3D vnic_dev_get_res(vdev, res_type, index);
>> +	if (!wq->ctrl)
>> +		return -EINVAL;
>> +
>> +	return 0;
>> +}
>> +
>> +static inline int vnic_wq_alloc_ring(struct vnic_dev *vdev, struct=20
>>vnic_wq *wq,
>> +	unsigned int index, unsigned int desc_count, unsigned int desc_siz=
e)
>> +{
>> +	return vnic_dev_alloc_desc_ring(vdev, &wq->ring, desc_count,=20
>>desc_size);
>> +}
>> +
>> +static int vnic_wq_alloc_bufs(struct vnic_wq *wq)
>> +{
>> +	struct vnic_wq_buf *buf;
>> +	unsigned int i, j, count =3D wq->ring.desc_count;
>> +	unsigned int blks =3D VNIC_WQ_BUF_BLKS_NEEDED(count);
>> +
>> +	for (i =3D 0; i < blks; i++) {
>> +		wq->bufs[i] =3D kzalloc(VNIC_WQ_BUF_BLK_SZ, GFP_ATOMIC);
>> +		if (!wq->bufs[i]) {
>> +			pr_err("Failed to alloc wq_bufs\n");
>> +
>> +			return -ENOMEM;
>> +		}
>> +	}
>> +
>> +	for (i =3D 0; i < blks; i++) {
>> +		buf =3D wq->bufs[i];
>> +		for (j =3D 0; j < VNIC_WQ_BUF_DFLT_BLK_ENTRIES; j++) {
>> +			buf->index =3D i * VNIC_WQ_BUF_DFLT_BLK_ENTRIES + j;
>> +			buf->desc =3D (u8 *)wq->ring.descs +
>> +				wq->ring.desc_size * buf->index;
>> +			if (buf->index + 1 =3D=3D count) {
>> +				buf->next =3D wq->bufs[0];
>> +				break;
>> +			} else if (j + 1 =3D=3D VNIC_WQ_BUF_DFLT_BLK_ENTRIES) {
>> +				buf->next =3D wq->bufs[i + 1];
>> +			} else {
>> +				buf->next =3D buf + 1;
>> +				buf++;
>> +			}
>> +		}
>> +	}
>> +
>> +	wq->to_use =3D wq->to_clean =3D wq->bufs[0];
>> +
>> +	return 0;
>> +}
>> +
>> +void vnic_wq_free(struct vnic_wq *wq)
>> +{
>> +	struct vnic_dev *vdev;
>> +	unsigned int i;
>> +
>> +	vdev =3D wq->vdev;
>> +
>> +	vnic_dev_free_desc_ring(vdev, &wq->ring);
>> +
>> +	for (i =3D 0; i < VNIC_WQ_BUF_BLKS_MAX; i++) {
>> +		kfree(wq->bufs[i]);
>> +		wq->bufs[i] =3D NULL;
>> +	}
>> +
>> +	wq->ctrl =3D NULL;
>> +
>> +}
>> +
>> +int vnic_wq_devcmd2_alloc(struct vnic_dev *vdev, struct vnic_wq *wq=
,
>> +	unsigned int desc_count, unsigned int desc_size)
>> +{
>> +	int err;
>> +
>> +	wq->index =3D 0;
>> +	wq->vdev =3D vdev;
>> +
>> +	err =3D vnic_wq_get_ctrl(vdev, wq, 0, RES_TYPE_DEVCMD2);
>> +	if (err) {
>> +		pr_err("Failed to get devcmd2 resource\n");
>> +
>> +		return err;
>> +	}
>> +
>> +	vnic_wq_disable(wq);
>> +
>> +	err =3D vnic_wq_alloc_ring(vdev, wq, 0, desc_count, desc_size);
>> +	if (err)
>> +		return err;
>> +
>> +	return 0;
>> +}
>> +
>> +int vnic_wq_alloc(struct vnic_dev *vdev, struct vnic_wq *wq, unsign=
ed=20
>>int index,
>> +	unsigned int desc_count, unsigned int desc_size)
>> +{
>> +	int err;
>> +
>> +	wq->index =3D index;
>> +	wq->vdev =3D vdev;
>> +
>> +	err =3D vnic_wq_get_ctrl(vdev, wq, index, RES_TYPE_WQ);
>> +	if (err) {
>> +		pr_err("Failed to hook WQ[%d] resource\n", index);
>> +
>> +		return err;
>> +	}
>> +
>> +	vnic_wq_disable(wq);
>> +
>> +	err =3D vnic_wq_alloc_ring(vdev, wq, index, desc_count, desc_size)=
;
>> +	if (err)
>> +		return err;
>> +
>> +	err =3D vnic_wq_alloc_bufs(wq);
>> +	if (err) {
>> +		vnic_wq_free(wq);
>> +
>> +		return err;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +void vnic_wq_init_start(struct vnic_wq *wq, unsigned int cq_index,
>> +	unsigned int fetch_index, unsigned int posted_index,
>> +	unsigned int error_interrupt_enable,
>> +	unsigned int error_interrupt_offset)
>> +{
>> +	u64 paddr;
>> +	unsigned int count =3D wq->ring.desc_count;
>> +
>> +	paddr =3D (u64)wq->ring.base_addr | VNIC_PADDR_TARGET;
>> +	writeq(paddr, &wq->ctrl->ring_base);
>> +	iowrite32(count, &wq->ctrl->ring_size);
>> +	iowrite32(fetch_index, &wq->ctrl->fetch_index);
>> +	iowrite32(posted_index, &wq->ctrl->posted_index);
>> +	iowrite32(cq_index, &wq->ctrl->cq_index);
>> +	iowrite32(error_interrupt_enable, &wq->ctrl->error_interrupt_enabl=
e);
>> +	iowrite32(error_interrupt_offset, &wq->ctrl->error_interrupt_offse=
t);
>> +	iowrite32(0, &wq->ctrl->error_status);
>> +
>> +	wq->to_use =3D wq->to_clean =3D
>> +		&wq->bufs[fetch_index / VNIC_WQ_BUF_BLK_ENTRIES(count)]
>> +			[fetch_index % VNIC_WQ_BUF_BLK_ENTRIES(count)];
>> +}
>> +
>> +void vnic_wq_init(struct vnic_wq *wq, unsigned int cq_index,
>> +	unsigned int error_interrupt_enable,
>> +	unsigned int error_interrupt_offset)
>> +{
>> +	vnic_wq_init_start(wq, cq_index, 0, 0, error_interrupt_enable,
>> +			   error_interrupt_offset);
>> +}
>> +
>> +unsigned int vnic_wq_error_status(struct vnic_wq *wq)
>> +{
>> +	return ioread32(&wq->ctrl->error_status);
>> +}
>> +
>> +void vnic_wq_enable(struct vnic_wq *wq)
>> +{
>> +	iowrite32(1, &wq->ctrl->enable);
>> +}
>> +
>> +int vnic_wq_disable(struct vnic_wq *wq)
>> +{
>> +	unsigned int wait;
>> +
>> +	iowrite32(0, &wq->ctrl->enable);
>> +
>> +	/* Wait for HW to ACK disable request */
>> +	for (wait =3D 0; wait < 100; wait++) {
>> +		if (!(ioread32(&wq->ctrl->running)))
>> +			return 0;
>> +		udelay(1);
>> +	}
>> +
>> +	pr_err("Failed to disable WQ[%d]\n", wq->index);
>> +
>> +	return -ETIMEDOUT;
>> +}
>> +
>> +void vnic_wq_clean(struct vnic_wq *wq,
>> +	void (*buf_clean)(struct vnic_wq *wq, struct vnic_wq_buf *buf))
>> +{
>> +	struct vnic_wq_buf *buf;
>> +
>> +	BUG_ON(ioread32(&wq->ctrl->enable));
>> +
>> +	buf =3D wq->to_clean;
>> +
>> +	while (vnic_wq_desc_used(wq) > 0) {
>> +
>> +		(*buf_clean)(wq, buf);
>> +
>> +		buf =3D wq->to_clean =3D buf->next;
>> +		wq->ring.desc_avail++;
>> +	}
>> +
>> +	wq->to_use =3D wq->to_clean =3D wq->bufs[0];
>> +
>> +	iowrite32(0, &wq->ctrl->fetch_index);
>> +	iowrite32(0, &wq->ctrl->posted_index);
>> +	iowrite32(0, &wq->ctrl->error_status);
>> +
>> +	vnic_dev_clear_desc_ring(&wq->ring);
>> +}
>> diff --git a/drivers/scsi/snic/vnic_wq.h b/drivers/scsi/snic/vnic_wq=
=2Eh
>> new file mode 100644
>> index 0000000..843e9fd
>> --- /dev/null
>> +++ b/drivers/scsi/snic/vnic_wq.h
>> @@ -0,0 +1,187 @@
>> +/*
>> + * Copyright 2014 Cisco Systems, Inc.  All rights reserved.
>> + *
>> + * This program is free software; you may redistribute it and/or mo=
dify
>> + * it under the terms of the GNU General Public License as publishe=
d by
>> + * the Free Software Foundation; version 2 of the License.
>> + *
>> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES =
OF
>> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
>> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLD=
ERS
>> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN =
AN
>> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR I=
N
>> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
>> + * SOFTWARE.
>> + */
>> +
>> +#ifndef _VNIC_WQ_H_
>> +#define _VNIC_WQ_H_
>> +
>> +#include <linux/pci.h>
>> +#include "vnic_dev.h"
>> +#include "vnic_cq.h"
>> +
>> +/*
>> + * These defines avoid symbol clash between fnic and enic (Cisco 10=
G=20
>>Eth
>> + * Driver) when both are built with CONFIG options =3Dy
>> + */
>> +#define vnic_wq_desc_avail snic_wq_desc_avail
>> +#define vnic_wq_desc_used snic_wq_desc_used
>> +#define vnic_wq_next_desc fni_cwq_next_desc
>> +#define vnic_wq_post snic_wq_post
>> +#define vnic_wq_service snic_wq_service
>> +#define vnic_wq_free snic_wq_free
>> +#define vnic_wq_alloc snic_wq_alloc
>> +#define vnic_wq_init snic_wq_init
>> +#define vnic_wq_error_status snic_wq_error_status
>> +#define vnic_wq_enable snic_wq_enable
>> +#define vnic_wq_disable snic_wq_disable
>> +#define vnic_wq_clean snic_wq_clean
>> +
>> +/* Work queue control */
>> +struct vnic_wq_ctrl {
>> +	u64 ring_base;			/* 0x00 */
>> +	u32 ring_size;			/* 0x08 */
>> +	u32 pad0;
>> +	u32 posted_index;		/* 0x10 */
>> +	u32 pad1;
>> +	u32 cq_index;			/* 0x18 */
>> +	u32 pad2;
>> +	u32 enable;			/* 0x20 */
>> +	u32 pad3;
>> +	u32 running;			/* 0x28 */
>> +	u32 pad4;
>> +	u32 fetch_index;		/* 0x30 */
>> +	u32 pad5;
>> +	u32 dca_value;			/* 0x38 */
>> +	u32 pad6;
>> +	u32 error_interrupt_enable;	/* 0x40 */
>> +	u32 pad7;
>> +	u32 error_interrupt_offset;	/* 0x48 */
>> +	u32 pad8;
>> +	u32 error_status;		/* 0x50 */
>> +	u32 pad9;
>> +};
>Same here ...
The structure members are aligned to hardware data, I would prefer to k=
eep=20
it same.

>
>Cheers,
>
>Hannes
>--=20
>Dr. Hannes Reinecke		               zSeries & Storage
>hare@suse.de			               +49 911 74053 688
>SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
>GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
>HRB 21284 (AG N=FCrnberg)
Thanks
Narsimhulu
>

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
