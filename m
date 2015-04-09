From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 4/9] snic:Add snic target discovery
Date: Thu, 09 Apr 2015 14:59:18 +0200
Message-ID: <552677A6.3030602@suse.de>
References: <1428580189-22785-1-git-send-email-nmusini@cisco.com> <1428580189-22785-5-git-send-email-nmusini@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46612 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235AbbDIM7U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Apr 2015 08:59:20 -0400
In-Reply-To: <1428580189-22785-5-git-send-email-nmusini@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Narsimhulu Musini <nmusini@cisco.com>, JBottomley@Parallels.com, linux-scsi@vger.kernel.org, hch@infradead.org
Cc: Sesidhar Baddela <sebaddel@cisco.com>

Hi Narsimhulu,

please find some comments inline.

On 04/09/2015 01:49 PM, Narsimhulu Musini wrote:
> snic_disc.h contains snic target structure definition.
>=20
> snic_disc.c contains target discovery, setup, lookup, and cleanup
>=20
> snic_ctl.c contains retrieval of snic capabilities includes
> max ios, size, SGs per request, and max concurrent requests.
>=20
> Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
> Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
> ---
> * v3
> - Cleaned up redundant comment.
>=20
>  drivers/scsi/snic/snic_ctl.c  | 276 +++++++++++++++++++
>  drivers/scsi/snic/snic_disc.c | 602 ++++++++++++++++++++++++++++++++=
++++++++++
>  drivers/scsi/snic/snic_disc.h | 124 +++++++++
>  3 files changed, 1002 insertions(+)
>  create mode 100644 drivers/scsi/snic/snic_ctl.c
>  create mode 100644 drivers/scsi/snic/snic_disc.c
>  create mode 100644 drivers/scsi/snic/snic_disc.h
>=20
> diff --git a/drivers/scsi/snic/snic_ctl.c b/drivers/scsi/snic/snic_ct=
l.c
> new file mode 100644
> index 0000000..4bc55be
> --- /dev/null
> +++ b/drivers/scsi/snic/snic_ctl.c
> @@ -0,0 +1,276 @@
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
> +#include <linux/pci.h>
> +#include <linux/slab.h>
> +
> +#include <linux/interrupt.h>
> +#include <linux/workqueue.h>
> +#include <linux/spinlock.h>
> +#include <linux/mempool.h>
> +#include <scsi/scsi_tcq.h>
> +#include <linux/ctype.h>
> +
> +#include "snic_io.h"
> +#include "snic.h"
> +#include "cq_enet_desc.h"
> +#include "snic_fwint.h"
> +
> +/*
> + * snic_handle_link : Handles link flaps.
> + */
> +void
> +snic_handle_link(struct work_struct *work)
> +{
> +	struct snic *snic =3D container_of(work, struct snic, link_work);
> +
> +	if (snic->config.xpt_type !=3D SNIC_DAS) {
> +		SNIC_HOST_INFO(snic->shost, "Link Event Received.\n");
> +		SNIC_ASSERT_NOT_IMPL(1);
> +
> +		return;
> +	}
> +
> +	snic->link_status =3D vnic_dev_link_status(snic->vdev);
> +	snic->link_down_cnt =3D vnic_dev_link_down_cnt(snic->vdev);
> +	SNIC_HOST_INFO(snic->shost, "Link Event: Link %s.\n",
> +		       ((snic->link_status) ? "Up" : "Down"));
> +}
> +
> +
> +/*
> + * snic_ver_enc : Encodes version str to int
> + * version string is similar to netmask string
> + */
> +static int
> +snic_ver_enc(const char *s)
> +{
> +	int v[4] =3D {0};
> +	int  i =3D 0, x =3D 0;
> +	char c;
> +	const char *p =3D s;
> +
> +	/* validate version string */
> +	if ((strlen(s) > 15) || (strlen(s) < 7))
> +		goto end;
> +
> +	while ((c =3D *p++)) {
> +		if (c =3D=3D '.') {
> +			i++;
> +			continue;
> +		}
> +
> +		if (i > 4 || !isdigit(c))
> +			goto end;
> +
> +		v[i] =3D v[i] * 10 + (c - '0');
> +	}
> +
> +	/* validate sub version numbers */
> +	for (i =3D 3; i >=3D 0; i--)
> +		if (v[i] > 0xff)
> +			goto end;
> +
> +	x |=3D (v[0] << 24) | v[1] << 16 | v[2] << 8 | v[3];
> +
> +end:
> +	if (x =3D=3D 0) {
> +		SNIC_ERR("Invalid version string [%s].\n", s);
> +
> +		return -1;
> +	}
> +
> +	return x;
> +} /* end of snic_ver_enc */
> +
> +/*
> + * snic_qeueue_exch_ver_req :
> + *
> + * Queues Exchange Version Request, to communicate host information
> + * in return, it gets firmware version details
> + */
> +int
> +snic_queue_exch_ver_req(struct snic *snic)
> +{
> +	struct snic_req_info *rqi =3D NULL;
> +	struct snic_host_req *req =3D NULL;
> +	int ret =3D 0;
> +
> +	SNIC_HOST_INFO(snic->shost, "Exch Ver Req Preparing...\n");
> +
> +	rqi =3D snic_req_init(snic, 0);
> +	if (!rqi) {
> +		SNIC_HOST_ERR(snic->shost,
> +			      "Queuing Exch Ver Req failed, err =3D %d\n",
> +			      ret);
> +
> +		ret =3D -ENOMEM;
> +		goto error;
> +	}
> +
> +	req =3D rqi_to_req(rqi);
> +
> +	/* Initialize snic_host_req */
> +	snic_io_hdr_enc(&req->hdr, SNIC_REQ_EXCH_VER, 0, SCSI_NO_TAG,
> +			snic->config.hid, 0, (u64)rqi);
> +	req->u.exch_ver.drvr_ver =3D snic_ver_enc(SNIC_DRV_VERSION);
> +	req->u.exch_ver.os_type =3D SNIC_OS_LINUX;
> +
> +	snic_handle_untagged_req(snic, rqi);
> +
> +	ret =3D snic_queue_wq_desc(snic, req, sizeof(*req));
> +	if (ret) {
> +		snic_release_untagged_req(snic, rqi);
> +		SNIC_HOST_ERR(snic->shost,
> +			      "Queuing Exch Ver Req failed, err =3D %d\n",
> +			      ret);
> +		goto error;
> +	}
> +
> +	SNIC_HOST_INFO(snic->shost, "Exch Ver Req is issued. ret =3D %d\n",=
 ret);
> +
> +error:
> +	return ret;
> +} /* end of snic_queue_exch_ver_req */
> +
> +/*
> + * snic_io_exch_ver_cmpl_handler
> + */
> +int
> +snic_io_exch_ver_cmpl_handler(struct snic *snic, struct snic_fw_req =
*fwreq)
> +{
> +	struct snic_req_info *rqi =3D NULL;
> +	u8 typ, hdr_stat;
> +	u32 cmnd_id, hid, max_sgs;
> +	u64 ctx =3D 0;
> +	unsigned long flags;
> +	int ret =3D 0;
> +
> +	SNIC_HOST_INFO(snic->shost, "Exch Ver Compl Received.\n");
> +	snic_io_hdr_dec(&fwreq->hdr, &typ, &hdr_stat, &cmnd_id, &hid, &ctx)=
;
> +	SNIC_BUG_ON(snic->config.hid !=3D hid);
> +	rqi =3D (struct snic_req_info *) ctx;
> +
> +	if (hdr_stat) {
> +		SNIC_HOST_ERR(snic->shost,
> +			      "Exch Ver Completed w/ err status %d\n",
> +			      hdr_stat);
> +
> +		goto exch_cmpl_end;
> +	}
> +
> +	spin_lock_irqsave(&snic->snic_lock, flags);
> +	snic->fwinfo.fw_ver =3D fwreq->u.exch_ver_cmpl.version;
> +	snic->fwinfo.hid =3D fwreq->u.exch_ver_cmpl.hid;
> +	snic->fwinfo.max_concur_ios =3D fwreq->u.exch_ver_cmpl.max_concur_i=
os;
> +	snic->fwinfo.max_sgs_per_cmd =3D fwreq->u.exch_ver_cmpl.max_sgs_per=
_cmd;
> +	snic->fwinfo.max_io_sz =3D fwreq->u.exch_ver_cmpl.max_io_sz;
> +	snic->fwinfo.max_tgts =3D fwreq->u.exch_ver_cmpl.max_tgts;
> +	snic->fwinfo.io_tmo =3D fwreq->u.exch_ver_cmpl.io_timeout;
> +
> +	SNIC_HOST_INFO(snic->shost,
> +		       "vers %u hid %u max_concur_ios %u max_sgs_per_cmd %u max_io=
_sz %u max_tgts %u fw tmo %u\n",
> +		       fwreq->u.exch_ver_cmpl.version,
> +		       fwreq->u.exch_ver_cmpl.hid,
> +		       fwreq->u.exch_ver_cmpl.max_concur_ios,
> +		       fwreq->u.exch_ver_cmpl.max_sgs_per_cmd,
> +		       fwreq->u.exch_ver_cmpl.max_io_sz,
> +		       fwreq->u.exch_ver_cmpl.max_tgts,
> +		       fwreq->u.exch_ver_cmpl.io_timeout);
> +
> +	SNIC_HOST_INFO(snic->shost,
> +		       "HBA Capabilities =3D 0x%x\n",
> +		       fwreq->u.exch_ver_cmpl.hba_cap);
> +
> +	/* Updating SGList size */
> +	max_sgs =3D snic->fwinfo.max_sgs_per_cmd;
> +	if (max_sgs && max_sgs < SNIC_MAX_SG_DESC_CNT) {
> +		snic->shost->sg_tablesize =3D max_sgs;
> +		SNIC_HOST_INFO(snic->shost, "Max SGs set to %d\n",
> +			       snic->shost->sg_tablesize);
> +	} else if (max_sgs > snic->shost->sg_tablesize) {
> +		SNIC_HOST_INFO(snic->shost,
> +			       "Target type %d Supports Larger Max SGList %d than driver'=
s Max SG List %d.\n",
> +			       snic->config.xpt_type, max_sgs,
> +			       snic->shost->sg_tablesize);
> +	}
> +
> +	if (snic->shost->can_queue > snic->fwinfo.max_concur_ios)
> +		snic->shost->can_queue =3D snic->fwinfo.max_concur_ios;
> +
> +	snic->shost->max_sectors =3D snic->fwinfo.max_io_sz >> 9;
> +	if (snic->fwinfo.wait)
> +		complete(snic->fwinfo.wait);
> +
> +	spin_unlock_irqrestore(&snic->snic_lock, flags);
> +
> +exch_cmpl_end:
> +	snic_release_untagged_req(snic, rqi);
> +
> +	SNIC_HOST_INFO(snic->shost, "Exch_cmpl Done, hdr_stat %d.\n", hdr_s=
tat);
> +
> +	return ret;
> +} /* end of snic_io_exch_ver_cmpl_handler */
> +
> +/*
> + * snic_get_conf
> + *
> + * Synchronous call, and Retrieves snic params.
> + */
> +int
> +snic_get_conf(struct snic *snic)
> +{
> +	DECLARE_COMPLETION_ONSTACK(wait);
> +	unsigned long flags;
> +	int ret;
> +	int nr_retries =3D 3;
> +
> +	SNIC_HOST_INFO(snic->shost, "Retrieving snic params.\n");
> +	spin_lock_irqsave(&snic->snic_lock, flags);
> +	memset(&snic->fwinfo, 0, sizeof(snic->fwinfo));
> +	snic->fwinfo.wait =3D &wait;
> +	spin_unlock_irqrestore(&snic->snic_lock, flags);
> +
> +	/* Additional delay to handle HW Resource initialization. */
> +	msleep(50);
> +
> +	/*
> +	 * Exch ver req can be ignored by FW, if HW Resource initialization
> +	 * is in progress, Hence retry.
> +	 */
> +	do {
> +		ret =3D snic_queue_exch_ver_req(snic);
> +		if (ret)
> +			return ret;
> +
> +		wait_for_completion_timeout(&wait, msecs_to_jiffies(2000));
> +		spin_lock_irqsave(&snic->snic_lock, flags);
> +		ret =3D (snic->fwinfo.fw_ver !=3D 0) ? 0 : -ETIMEDOUT;
> +		if (ret)
> +			SNIC_HOST_ERR(snic->shost,
> +				      "Failed to retrieve snic params,\n");
> +
> +		/* Unset fwinfo.wait, on success or on last retry */
> +		if (ret =3D=3D 0 || nr_retries =3D=3D 1)
> +			snic->fwinfo.wait =3D NULL;
> +
> +		spin_unlock_irqrestore(&snic->snic_lock, flags);
> +	} while (ret && --nr_retries);
> +
> +	return ret;
> +} /* end of snic_get_info */
> diff --git a/drivers/scsi/snic/snic_disc.c b/drivers/scsi/snic/snic_d=
isc.c
> new file mode 100644
> index 0000000..b6b6cca
> --- /dev/null
> +++ b/drivers/scsi/snic/snic_disc.c
> @@ -0,0 +1,602 @@
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
> +#include <linux/mempool.h>
> +
> +#include <scsi/scsi_tcq.h>
> +
> +#include "snic_disc.h"
> +#include "snic.h"
> +#include "snic_io.h"
> +
> +
> +/* snic target types */
> +static const char * const snic_tgt_type_str[] =3D {
> +	[SNIC_TGT_DAS] =3D "DAS",
> +	[SNIC_TGT_SAN] =3D "SAN",
> +};
> +
> +static inline const char *
> +snic_tgt_type_to_str(int typ)
> +{
> +	return ((typ > SNIC_TGT_NONE && typ <=3D SNIC_TGT_SAN) ?
> +		 snic_tgt_type_str[typ] : "Unknown");
> +}
> +
> +static const char * const snic_tgt_state_str[] =3D {
> +	[SNIC_TGT_STAT_INIT]	=3D "INIT",
> +	[SNIC_TGT_STAT_ONLINE]	=3D "ONLINE",
> +	[SNIC_TGT_STAT_OFFLINE]	=3D "OFFLINE",
> +	[SNIC_TGT_STAT_DEL]	=3D "DELETION IN PROGRESS",
> +};
> +
> +const char *
> +snic_tgt_state_to_str(int state)
> +{
> +	return ((state >=3D SNIC_TGT_STAT_INIT && state <=3D SNIC_TGT_STAT_=
DEL) ?
> +		snic_tgt_state_str[state] : "UNKNOWN");
> +}
> +
> +/*
> + * Initiate report_tgt req desc
> + */
> +static void
> +snic_report_tgt_init(struct snic_host_req *req, u32 hid, u8 *buf, u3=
2 len,
> +		     u64 rsp_buf_pa, u64 ctx)
> +{
> +	struct snic_sg_desc *sgd =3D NULL;
> +
> +
> +	snic_io_hdr_enc(&req->hdr, SNIC_REQ_REPORT_TGTS, 0, SCSI_NO_TAG, hi=
d,
> +			1, ctx);
> +
> +	req->u.rpt_tgts.sg_cnt =3D 1;
> +	sgd =3D req_to_sgl(req);
> +	sgd[0].addr =3D cpu_to_le64(rsp_buf_pa);
> +	sgd[0].len =3D cpu_to_le32(len);
> +	sgd[0]._resvd =3D 0;
> +	req->u.rpt_tgts.sg_addr =3D (u64) sgd;
> +}
> +
> +/*
> + * snic_queue_report_tgt_req: Queues report target request.
> + */
> +static int
> +snic_queue_report_tgt_req(struct snic *snic)
> +{
> +	struct snic_req_info *rqi =3D NULL;
> +	u32 ntgts, buf_len =3D 0;
> +	u8 *buf =3D NULL;
> +	dma_addr_t pa =3D 0;
> +	int ret =3D 0;
> +
> +	rqi =3D snic_req_init(snic, 1);
> +	if (!rqi) {
> +		ret =3D -ENOMEM;
> +		goto error;
> +	}
> +
> +	if (snic->fwinfo.max_tgts)
> +		ntgts =3D min_t(u32, snic->fwinfo.max_tgts, snic->shost->max_id);
> +	else
> +		ntgts =3D snic->shost->max_id;
> +
> +	/* Allocate Response Buffer */
> +	SNIC_BUG_ON(ntgts =3D=3D 0);
> +	buf_len =3D ntgts * sizeof(struct snic_tgt_id) + SNIC_SG_DESC_ALIGN=
;
> +
> +	buf =3D kzalloc(buf_len, GFP_KERNEL|GFP_DMA);
> +	if (!buf) {
> +		snic_req_free(snic, rqi);
> +		SNIC_HOST_ERR(snic->shost, "Resp Buf Alloc Failed.\n");
> +
> +		ret =3D -ENOMEM;
> +		goto error;
> +	}
> +
> +	SNIC_BUG_ON((((unsigned long)buf) % SNIC_SG_DESC_ALIGN) !=3D 0);
> +
> +	pa =3D pci_map_single(snic->pdev, buf, buf_len, PCI_DMA_FROMDEVICE)=
;
> +	if (pci_dma_mapping_error(snic->pdev, pa)) {
> +		kfree(buf);
> +		snic_req_free(snic, rqi);
> +		SNIC_HOST_ERR(snic->shost,
> +			      "Rpt-tgt rspbuf %p: PCI DMA Mapping Failed\n",
> +			      buf);
> +		ret =3D -EINVAL;
> +
> +		goto error;
> +	}
> +
> +
> +	SNIC_BUG_ON(pa =3D=3D 0);
> +	rqi->sge_va =3D (u64) buf;
> +
> +	snic_report_tgt_init(rqi->req,
> +			     snic->config.hid,
> +			     buf,
> +			     buf_len,
> +			     (u64)pa,
> +			     (u64)rqi);
> +
> +	snic_handle_untagged_req(snic, rqi);
> +
> +	ret =3D snic_queue_wq_desc(snic, rqi->req, rqi->req_len);
> +	if (ret) {
> +		pci_unmap_single(snic->pdev, pa, buf_len, PCI_DMA_FROMDEVICE);
> +		kfree(buf);
> +		rqi->sge_va =3D 0;
> +		snic_release_untagged_req(snic, rqi);
> +		SNIC_HOST_ERR(snic->shost, "Queuing Report Tgts Failed.\n");
> +
> +		goto error;
> +	}
> +
> +	SNIC_DISC_DBG(snic->shost, "Report Targets Issued.\n");
> +
> +	return ret;
> +
> +error:
> +	SNIC_HOST_ERR(snic->shost,
> +		      "Queuing Report Targets Failed, err =3D %d\n",
> +		      ret);
> +	return ret;
> +} /* end of snic_queue_report_tgt_req */
> +
> +/* call into SML */
> +static void
> +snic_scsi_scan_tgt(struct work_struct *work)
> +{
> +	struct snic_tgt *tgt =3D container_of(work, struct snic_tgt, scan_w=
ork);
> +	struct Scsi_Host *shost =3D dev_to_shost(&tgt->dev);
> +	unsigned long flags;
> +
> +	SNIC_HOST_INFO(shost, "Scanning Target id 0x%x\n", tgt->id);
> +	scsi_scan_target(&tgt->dev,
> +			 tgt->channel,
> +			 tgt->scsi_tgt_id,
> +			 SCAN_WILD_CARD,
> +			 1);
> +
> +	spin_lock_irqsave(shost->host_lock, flags);
> +	tgt->flags &=3D ~SNIC_TGT_SCAN_PENDING;
> +	spin_unlock_irqrestore(shost->host_lock, flags);
> +} /* end of snic_scsi_scan_tgt */
> +
> +/*
> + * snic_tgt_lookup :
> + */
> +static struct snic_tgt *
> +snic_tgt_lookup(struct snic *snic, struct snic_tgt_id *tgtid)
> +{
> +	struct list_head *cur, *nxt;
> +	struct snic_tgt *tgt =3D NULL;
> +
> +	list_for_each_safe(cur, nxt, &snic->disc.tgt_list) {
> +		tgt =3D list_entry(cur, struct snic_tgt, list);
> +		if (tgt->id =3D=3D tgtid->tgt_id)
> +			return tgt;
> +		tgt =3D NULL;
> +	}
> +
> +	return tgt;
> +} /* end of snic_tgt_lookup */
> +
> +/*
> + * snic_tgt_dev_release : Called on dropping last ref for snic_tgt o=
bject
> + */
> +void
> +snic_tgt_dev_release(struct device *dev)
> +{
> +	struct snic_tgt *tgt =3D dev_to_tgt(dev);
> +
> +	SNIC_HOST_INFO(snic_tgt_to_shost(tgt),
> +		       "Target Device ID %d (%s) Permanently Deleted.\n",
> +		       tgt->id,
> +		       dev_name(dev));
> +
> +	SNIC_BUG_ON(!list_empty(&tgt->list));
> +	kfree(tgt);
> +}
> +
> +/*
> + * snic_tgt_del : work function to delete snic_tgt
> + */
> +static void
> +snic_tgt_del(struct work_struct *work)
> +{
> +	struct snic_tgt *tgt =3D container_of(work, struct snic_tgt, del_wo=
rk);
> +	struct Scsi_Host *shost =3D snic_tgt_to_shost(tgt);
> +
> +	if (tgt->flags & SNIC_TGT_SCAN_PENDING)
> +		scsi_flush_work(shost);
> +
> +	/* Block IOs on child devices, stops new IOs */
> +	scsi_target_block(&tgt->dev);
> +
> +	/* Cleanup IOs */
> +	snic_tgt_scsi_abort_io(tgt);
> +
> +	/* Unblock IOs now, to flush if there are any. */
> +	scsi_target_unblock(&tgt->dev, SDEV_TRANSPORT_OFFLINE);
> +
> +	/* Delete SCSI Target and sdevs */
> +	scsi_remove_target(&tgt->dev);  /* ?? */
> +	device_del(&tgt->dev);
> +	put_device(&tgt->dev);
> +} /* end of snic_tgt_del */
> +
> +/* snic_tgt_create: checks for existence of snic_tgt, if it doesn't
> + * it creates one.
> + */
> +static struct snic_tgt *
> +snic_tgt_create(struct snic *snic, struct snic_tgt_id *tgtid)
> +{
> +	struct snic_tgt *tgt =3D NULL;
> +	unsigned long flags;
> +	int ret;
> +
> +	tgt =3D snic_tgt_lookup(snic, tgtid);
> +	if (tgt) {
> +		/* update the information if required */
> +		return tgt;
> +	}
> +
> +	tgt =3D kzalloc(sizeof(*tgt), GFP_KERNEL);
> +	if (!tgt) {
> +		SNIC_HOST_ERR(snic->shost, "Failure to allocate snic_tgt.\n");
> +		ret =3D -ENOMEM;
> +
> +		return tgt;
> +	}
> +
> +	INIT_LIST_HEAD(&tgt->list);
> +	tgt->id =3D tgtid->tgt_id;
> +	tgt->channel =3D 0;
> +
> +	SNIC_BUG_ON(tgtid->tgt_type > SNIC_TGT_SAN);
> +	tgt->tdata.typ =3D tgtid->tgt_type;
> +
> +	/*
> +	 * Plugging into SML Device Tree
> +	 */
> +	tgt->tdata.disc_id =3D 0;
> +	tgt->state =3D SNIC_TGT_STAT_INIT;
> +	device_initialize(&tgt->dev);
> +	tgt->dev.parent =3D get_device(&snic->shost->shost_gendev);
> +	tgt->dev.release =3D snic_tgt_dev_release;
Why do you use your own scsi target instantiation here?
If it's equivalent to the scsi target than you should rather use the
'scsi_target' structure here and attach driver-specific information
to either hostdata or starget_data.

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
