From: "Narsimhulu Musini (nmusini)" <nmusini@cisco.com>
Subject: Re: [PATCH v2 3/9] snic:Add meta request,  handling of meta
 requests.
Date: Thu, 2 Apr 2015 07:53:53 +0000
Message-ID: <D142F2D8.1D3BC%nmusini@cisco.com>
References: <1426093299-4511-1-git-send-email-nmusini@cisco.com>
 <1426093299-4511-4-git-send-email-nmusini@cisco.com>
 <55128EC9.9080602@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alln-iport-7.cisco.com ([173.37.142.94]:43436 "EHLO
	alln-iport-7.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbbDBHxy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Apr 2015 03:53:54 -0400
In-Reply-To: <55128EC9.9080602@suse.de>
Content-Language: en-US
Content-ID: <6E7F5C0B0155E145824990828275EB6D@emea.cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>

Hi Hannes,

  Thank you for reviewing the patch. Please find responses inline.
I will incorporate the comments and suggestions in next patch submittal=
=2E



On 25/03/15 4:02 pm, "Hannes Reinecke" <hare@suse.de> wrote:

>Hi Narsimhulu,
>
>On 03/11/2015 06:01 PM, Narsimhulu Musini wrote:
>> snic_io.h contains meta request structure definition
>> meta request contains high level information about firmware requests=
=2E
>> such as request information, size, SGLs.
>>=20
>> snic_io.c contains interfaces to handle meta request, firmware
>>acknowledgment,
>> and high level generic queueing interface.
>>=20
>> Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
>> Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
>
>Please find some comments inline.
>
>> ---
>>  drivers/scsi/snic/snic_io.c | 546
>>++++++++++++++++++++++++++++++++++++++++++++
>>  drivers/scsi/snic/snic_io.h | 111 +++++++++
>>  2 files changed, 657 insertions(+)
>>  create mode 100644 drivers/scsi/snic/snic_io.c
>>  create mode 100644 drivers/scsi/snic/snic_io.h
>>=20
>> diff --git a/drivers/scsi/snic/snic_io.c b/drivers/scsi/snic/snic_io=
=2Ec
>> new file mode 100644
>> index 0000000..fe38c0b
>> --- /dev/null
>> +++ b/drivers/scsi/snic/snic_io.c
>> @@ -0,0 +1,546 @@
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
>> +#include <linux/pci.h>
>> +#include <linux/slab.h>
>> +
>> +#include <linux/interrupt.h>
>> +#include <linux/workqueue.h>
>> +#include <linux/spinlock.h>
>> +#include <linux/mempool.h>
>> +#include <scsi/scsi_tcq.h>
>> +
>> +#include "snic_io.h"
>> +#include "snic.h"
>> +#include "cq_enet_desc.h"
>> +#include "snic_fwint.h"
>> +#include "snic_os.h"
>> +
>> +static void
>> +snic_wq_cmpl_frame_send(struct vnic_wq *wq,
>> +			    struct cq_desc *cq_desc,
>> +			    struct vnic_wq_buf *buf,
>> +			    void *opaque)
>> +{
>> +	struct snic *snic =3D vnic_dev_priv(wq->vdev);
>> +
>> +	SNIC_BUG_ON(buf->os_buf =3D=3D NULL);
>> +
>> +	if (snic_log_level & SNIC_DESC_LOGGING)
>> +		SNIC_HOST_INFO(snic->shost,
>> +			       "Ack received for snic_host_req %p.\n",
>> +			       buf->os_buf);
>> +
>> +	SNIC_TRC(snic->shost->host_no, 0, 0,
>> +		 ((u64)(buf->os_buf) - sizeof(struct snic_req_info)), 0, 0, 0);
>> +	pci_unmap_single(snic->pdev, buf->dma_addr, buf->len,
>>PCI_DMA_TODEVICE);
>> +	buf->os_buf =3D NULL;
>> +}
>> +
>> +static int
>> +snic_wq_cmpl_handler_cont(struct vnic_dev *vdev,
>> +			  struct cq_desc *cq_desc,
>> +			  u8 type,
>> +			  u16 q_num,
>> +			  u16 cmpl_idx,
>> +			  void *opaque)
>> +{
>> +	struct snic *snic =3D vnic_dev_priv(vdev);
>> +	unsigned long flags;
>> +
>> +	SNIC_BUG_ON(q_num !=3D 0);
>> +
>> +	spin_lock_irqsave(&snic->wq_lock[q_num], flags);
>> +	vnic_wq_service(&snic->wq[q_num],
>> +			cq_desc,
>> +			cmpl_idx,
>> +			snic_wq_cmpl_frame_send,
>> +			NULL);
>> +	spin_unlock_irqrestore(&snic->wq_lock[q_num], flags);
>> +
>> +	return 0;
>> +} /* end of snic_cmpl_handler_cont */
>> +
>> +int
>> +snic_wq_cmpl_handler(struct snic *snic, int work_to_do)
>> +{
>> +	unsigned int work_done =3D 0;
>> +	unsigned int i;
>> +
>> +	snic->s_stats.misc.last_ack_time =3D jiffies;
>> +	for (i =3D 0; i < snic->wq_count; i++) {
>> +		work_done +=3D vnic_cq_service(&snic->cq[i],
>> +						work_to_do,
>> +						snic_wq_cmpl_handler_cont,
>> +						NULL);
>> +	}
>> +
>> +	return work_done;
>> +} /* end of snic_wq_cmpl_handler */
>> +
>> +void
>> +snic_free_wq_buf(struct vnic_wq *wq, struct vnic_wq_buf *buf)
>> +{
>> +
>> +	struct snic_host_req *req =3D buf->os_buf;
>> +	struct snic *snic =3D vnic_dev_priv(wq->vdev);
>> +	struct snic_req_info *rqi =3D NULL;
>> +	unsigned long flags;
>> +
>> +	pci_unmap_single(snic->pdev, buf->dma_addr, buf->len,
>>PCI_DMA_TODEVICE);
>> +
>> +	rqi =3D req_to_rqi(req);
>> +	spin_lock_irqsave(&snic->spl_cmd_lock, flags);
>> +	if (list_empty(&rqi->list)) {
>> +		spin_unlock_irqrestore(&snic->spl_cmd_lock, flags);
>> +		goto end;
>> +	}
>> +
>> +	SNIC_BUG_ON(rqi->list.next =3D=3D NULL); /* if not added to spl_cm=
d_list
>>*/
>> +	list_del_init(&rqi->list);
>> +	spin_unlock_irqrestore(&snic->spl_cmd_lock, flags);
>> +
>> +	if (rqi->sge_va) {
>> +		snic_pci_unmap_rsp_buf(snic, rqi);
>> +		kfree((void *)rqi->sge_va);
>> +		rqi->sge_va =3D 0;
>> +	}
>> +	snic_req_free(snic, rqi);
>> +	SNIC_HOST_INFO(snic->shost, "snic_free_wq_buf .. freed.\n");
>> +
>> +end:
>> +	return;
>> +}
>> +
>> +/* Criteria to select work queue in multi queue mode */
>> +static int
>> +snic_select_wq(struct snic *snic)
>> +{
>> +	/* No multi queue support for now */
>> +	BUILD_BUG_ON(SNIC_WQ_MAX > 1);
>> +
>> +	return 0;
>> +}
>> +
>> +int
>> +snic_queue_wq_desc(struct snic *snic, void *os_buf, u16 len)
>> +{
>> +	dma_addr_t pa =3D 0;
>> +	unsigned long flags;
>> +	struct snic_fw_stats *fwstats =3D &snic->s_stats.fw;
>> +	long act_reqs;
>> +	int q_num =3D 0;
>> +
>> +	snic_print_desc(__func__, os_buf, len);
>> +
>> +	/* Map request buffer */
>> +	pa =3D pci_map_single(snic->pdev, os_buf, len, PCI_DMA_TODEVICE);
>> +	if (pci_dma_mapping_error(snic->pdev, pa)) {
>> +		SNIC_HOST_ERR(snic->shost, "qdesc: PCI DMA Mapping Fail.\n");
>> +
>> +		return -ENOMEM;
>> +	}
>> +
>> +	q_num =3D snic_select_wq(snic);
>> +
>> +	spin_lock_irqsave(&snic->wq_lock[q_num], flags);
>> +	if (!vnic_wq_desc_avail(snic->wq)) {
>> +		pci_unmap_single(snic->pdev, pa, len, PCI_DMA_TODEVICE);
>> +		spin_unlock_irqrestore(&snic->wq_lock[q_num], flags);
>> +		atomic64_inc(&snic->s_stats.misc.wq_alloc_fail);
>> +		SNIC_DBG("host =3D %d, WQ is Full\n", snic->shost->host_no);
>> +
>> +		return -ENOMEM;
>> +	}
>> +
>> +	snic_queue_wq_eth_desc(&snic->wq[q_num], os_buf, pa, len, 0, 0, 1)=
;
>> +	spin_unlock_irqrestore(&snic->wq_lock[q_num], flags);
>> +
>> +	/* Update stats */
>> +	act_reqs =3D atomic64_inc_return(&fwstats->actv_reqs);
>> +	if (act_reqs > atomic64_read(&fwstats->max_actv_reqs))
>> +		atomic64_set(&fwstats->max_actv_reqs, act_reqs);
>> +
>> +	return 0;
>> +} /* end of snic_queue_wq_desc() */
>> +
>> +/*
>> + * snic_handle_untagged_req: Adds snic specific requests to
>>spl_cmd_list.
>> + * Purpose : Used during driver unload to clean up the requests.
>> + */
>> +void
>> +snic_handle_untagged_req(struct snic *snic, struct snic_req_info *r=
qi)
>> +{
>> +	unsigned long flags;
>> +
>> +	INIT_LIST_HEAD(&rqi->list);
>> +
>> +	spin_lock_irqsave(&snic->spl_cmd_lock, flags);
>> +	list_add_tail(&rqi->list, &snic->spl_cmd_list);
>> +	spin_unlock_irqrestore(&snic->spl_cmd_lock, flags);
>> +}
>> +
>> +static struct snic_host_req *
>> +snic_req_align(struct snic_host_req *req)
>> +{
>> +	unsigned long sgl_ptr;
>> +
>> +	sgl_ptr =3D (unsigned long) req;
>> +	/* Cache sgl list allocated address before alignment */
>> +	if (sgl_ptr % SNIC_SG_DESC_ALIGN) {
>> +		req =3D (struct snic_host_req *)
>> +			   ((sgl_ptr + SNIC_SG_DESC_ALIGN - 1) &
>> +			    ~(SNIC_SG_DESC_ALIGN - 1));
>> +
>> +	}
>> +
>> +	return req;
>> +}
>> +
>> +/*
>> + * snic_req_init:
>> + * Allocates snic_req_info + snic_host_req + sgl data, and initiali=
zes.
>> + */
>> +struct snic_req_info *
>> +snic_req_init(struct snic *snic, int sg_cnt)
>> +{
>> +	u8 typ;
>> +	struct snic_req_info *rqi =3D NULL;
>> +
>> +	typ =3D (sg_cnt <=3D SNIC_REQ_CACHE_DFLT_SGL) ?
>> +		SNIC_REQ_CACHE_DFLT_SGL : SNIC_REQ_CACHE_MAX_SGL;
>> +
>> +	rqi =3D mempool_alloc(snic->req_pool[typ], GFP_ATOMIC);
>> +	if (!rqi) {
>> +		atomic64_inc(&snic->s_stats.io.alloc_fail);
>> +		SNIC_HOST_ERR(snic->shost,
>> +			      "Failed to allocate memory from snic req pool id =3D %d\n"=
,
>> +			      typ);
>> +		return rqi;
>> +	}
>> +
>> +	memset(rqi, 0, sizeof(*rqi));
>> +	rqi->rq_pool_type =3D typ;
>> +	rqi->start_time =3D jiffies;
>> +	rqi->req =3D (struct snic_host_req *) (rqi + 1);
>> +	rqi->req_len =3D sizeof(struct snic_host_req);
>> +	rqi->snic =3D snic;
>> +
>> +	BUILD_BUG_ON((sizeof(struct snic_req_info) % SNIC_SG_DESC_ALIGN) !=
=3D
>>0);
>> +	BUILD_BUG_ON((sizeof(struct snic_host_req) % SNIC_SG_DESC_ALIGN) !=
=3D
>>0);
>> +
>> +	rqi->req =3D snic_req_align(rqi->req);
>> +
>Any reason why you can't allocate aligned requests directly from the
>mempool?
Thanks for pointing this,  I overlooked at it.
I will remove the aligning code.


>
>> +	if (sg_cnt =3D=3D 0)
>> +		goto end;
>> +
>> +	rqi->req_len +=3D (sg_cnt * sizeof(struct snic_sg_desc));
>> +
>> +	if (sg_cnt > atomic64_read(&snic->s_stats.io.max_sgl))
>> +		atomic64_set(&snic->s_stats.io.max_sgl, sg_cnt);
>> +
>> +	SNIC_BUG_ON(sg_cnt > SNIC_MAX_SG_DESC_CNT);
>> +	atomic64_inc(&snic->s_stats.io.sgl_cnt[sg_cnt - 1]);
>> +
>> +end:
>> +	memset(rqi->req, 0, rqi->req_len);
>> +
>> +	/* pre initialization of init_ctx to support req_to_rqi */
>> +	rqi->req->hdr.init_ctx =3D (u64) rqi;
>> +
>> +	SNIC_SCSI_DBG(snic->shost, "Req_alloc:rqi =3D %p allocatd.\n", rqi=
);
>> +
>> +	return rqi;
>> +} /* end of snic_req_init */
>> +
>> +/*
>> + * snic_abort_req_init : Inits abort request.
>> + */
>> +struct snic_host_req *
>> +snic_abort_req_init(struct snic *snic, struct snic_req_info *rqi)
>> +{
>> +	struct snic_host_req *req =3D NULL;
>> +
>> +	SNIC_BUG_ON(!rqi);
>> +
>> +	/* If abort to be issued second time, then reuse */
>> +	if (rqi->abort_req)
>> +		return rqi->abort_req;
>> +
>> +
>> +	req =3D mempool_alloc(snic->req_pool[SNIC_REQ_TM_CACHE], GFP_ATOMI=
C);
>> +	if (!req) {
>> +		SNIC_HOST_ERR(snic->shost, "abts:Failed to alloc tm req.\n");
>> +		WARN_ON_ONCE(1);
>> +
>> +		return NULL;
>> +	}
>> +
>> +	rqi->abort_req_unaligned =3D req;
>> +	rqi->abort_req =3D snic_req_align(req);
>Same here.
Sure, I will remove aligning code.
>
>> +	req =3D rqi->abort_req;
>> +	memset(req, 0, sizeof(struct snic_host_req));
>> +	/* pre initialization of init_ctx to support req_to_rqi */
>> +	req->hdr.init_ctx =3D (u64) rqi;
>> +
>> +	return req;
>> +} /* end of snic_abort_req_init */
>> +
>> +/*
>> + * snic_dr_req_init : Inits device reset req
>> + */
>> +struct snic_host_req *
>> +snic_dr_req_init(struct snic *snic, struct snic_req_info *rqi)
>> +{
>> +	struct snic_host_req *req =3D NULL;
>> +
>> +	SNIC_BUG_ON(!rqi);
>> +
>> +	req =3D mempool_alloc(snic->req_pool[SNIC_REQ_TM_CACHE], GFP_ATOMI=
C);
>> +	if (!req) {
>> +		SNIC_HOST_ERR(snic->shost, "dr:Failed to alloc tm req.\n");
>> +		WARN_ON_ONCE(1);
>> +
>> +		return NULL;
>> +	}
>> +
>> +	SNIC_BUG_ON(rqi->dr_req_unaligned !=3D NULL);
>> +	rqi->dr_req_unaligned =3D req;
>> +	rqi->dr_req =3D snic_req_align(req);
>And here.
Sure, I will remove aligning code.

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
