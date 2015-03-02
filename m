From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 6/9] snic:Add low level queuing interfaces
Date: Mon, 02 Mar 2015 14:32:30 +0100
Message-ID: <54F4666E.3020609@suse.de>
References: <1423586616-18177-1-git-send-email-nmusini@cisco.com> <1423586616-18177-7-git-send-email-nmusini@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58142 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511AbbCBNcc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Mar 2015 08:32:32 -0500
In-Reply-To: <1423586616-18177-7-git-send-email-nmusini@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Narsimhulu Musini <nmusini@cisco.com>, JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Sesidhar Baddela <sebaddel@cisco.com>

On 02/10/2015 05:43 PM, Narsimhulu Musini wrote:
> These files contain low level queueing interfaces includes
> hardware queues, and management of hardware features.
>=20
> Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
> Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
> ---
>  drivers/scsi/snic/cq_desc.h       |  77 ++++
>  drivers/scsi/snic/cq_enet_desc.h  |  38 ++
>  drivers/scsi/snic/vnic_cq.c       |  86 ++++
>  drivers/scsi/snic/vnic_cq.h       | 120 +++++
>  drivers/scsi/snic/vnic_cq_fw.h    |  62 +++
>  drivers/scsi/snic/vnic_dev.c      | 895 ++++++++++++++++++++++++++++=
++++++++++
>  drivers/scsi/snic/vnic_dev.h      | 165 +++++++
>  drivers/scsi/snic/vnic_devcmd.h   | 393 +++++++++++++++++
>  drivers/scsi/snic/vnic_intr.c     |  59 +++
>  drivers/scsi/snic/vnic_intr.h     | 127 ++++++
>  drivers/scsi/snic/vnic_resource.h |  68 +++
>  drivers/scsi/snic/vnic_snic.h     |  54 +++
>  drivers/scsi/snic/vnic_stats.h    |  68 +++
>  drivers/scsi/snic/vnic_wq.c       | 236 ++++++++++
>  drivers/scsi/snic/vnic_wq.h       | 187 ++++++++
>  drivers/scsi/snic/wq_enet_desc.h  |  96 ++++
>  16 files changed, 2731 insertions(+)
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
> index 0000000..a529056
> --- /dev/null
> +++ b/drivers/scsi/snic/cq_desc.h
> @@ -0,0 +1,77 @@
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
> +	__le16 completed_index;
> +	__le16 q_number;
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
> +	*q_number =3D le16_to_cpu(desc->q_number) & CQ_DESC_Q_NUM_MASK;
> +	*completed_index =3D le16_to_cpu(desc->completed_index) &
> +		CQ_DESC_COMP_NDX_MASK;
> +}
Now you're getting inconsistent.

Either you care for endianness, in which case you need to protect
_all_ hardware-dependent structure with cpu_to_XX and friends,
or you claim that you're hardware is unique to a given
architecture/machine, in which case you can skip the byte swapping.

But mixing them is not a good idea.

(And that comment is valid for the entire patch).

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
