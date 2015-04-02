From: "Narsimhulu Musini (nmusini)" <nmusini@cisco.com>
Subject: Re: [PATCH v2 5/9] snic:add SCSI handling, AEN, and fwreset handling
Date: Thu, 2 Apr 2015 08:06:43 +0000
Message-ID: <D142F38C.1D3C8%nmusini@cisco.com>
References: <1426093299-4511-1-git-send-email-nmusini@cisco.com>
 <1426093299-4511-6-git-send-email-nmusini@cisco.com>
 <55129590.4000608@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcdn-iport-8.cisco.com ([173.37.86.79]:48059 "EHLO
	rcdn-iport-8.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbbDBIGs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Apr 2015 04:06:48 -0400
In-Reply-To: <55129590.4000608@suse.de>
Content-Language: en-US
Content-ID: <9AE402375D1172448D6823EF87E171C1@emea.cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>

Hi Hannes,

  Thank you for reviewing the patch. Please find responses inline.
I will incorporate the comments and suggestions in next patch submittal=
=2E



On 25/03/15 4:31 pm, "Hannes Reinecke" <hare@suse.de> wrote:

>Hi Narsimhulu,
>
>On 03/11/2015 06:01 PM, Narsimhulu Musini wrote:
>> snic_scsi.c contains scsi handling, includes queuing io, abort, lun
>>reset,
>> and host reset. Also it handles asynchronous event notifications fro=
m
>>FW.
>>=20
>> v2
>> Changed queuecommand to lock-free version.
>> Converted custom error codes to standard error codes.
>>=20
>> Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
>> Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
>> ---
>>  drivers/scsi/snic/snic_scsi.c | 2631
>>+++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 2631 insertions(+)
>>  create mode 100644 drivers/scsi/snic/snic_scsi.c
>>=20
>> diff --git a/drivers/scsi/snic/snic_scsi.c
>>b/drivers/scsi/snic/snic_scsi.c
>> new file mode 100644
>> index 0000000..f82ff02
>> --- /dev/null
>> +++ b/drivers/scsi/snic/snic_scsi.c
>> @@ -0,0 +1,2631 @@
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
>> +#include <linux/mempool.h>
>> +#include <linux/errno.h>
>> +#include <linux/init.h>
>> +#include <linux/workqueue.h>
>> +#include <linux/pci.h>
>> +#include <linux/spinlock.h>
>> +#include <linux/delay.h>
>> +#include <linux/gfp.h>
>> +#include <scsi/scsi.h>
>> +#include <scsi/scsi_host.h>
>> +#include <scsi/scsi_device.h>
>> +#include <scsi/scsi_cmnd.h>
>> +#include <scsi/scsi_tcq.h>
>> +#include <scsi/scsi_dbg.h>
>> +
>> +#include "snic_io.h"
>> +#include "snic.h"
>> +#include "snic_os.h"
>> +
>> +const char *snic_state_str[] =3D {
>> +	[SNIC_INIT]	=3D "SNIC_INIT",
>> +	[SNIC_ERROR]	=3D "SNIC_ERROR",
>> +	[SNIC_ONLINE]	=3D "SNIC_ONLINE",
>> +	[SNIC_OFFLINE]	=3D "SNIC_OFFLINE",
>> +	[SNIC_FWRESET]	=3D "SNIC_FWRESET",
>> +};
>> +
>> +static const char * const snic_req_state_str[] =3D {
>> +	[SNIC_IOREQ_NOT_INITED]	=3D "SNIC_IOREQ_NOT_INITED",
>> +	[SNIC_IOREQ_PENDING]	=3D "SNIC_IOREQ_PENDING",
>> +	[SNIC_IOREQ_ABTS_PENDING] =3D "SNIC_IOREQ_ABTS_PENDING",
>> +	[SNIC_IOREQ_ABTS_COMPLETE] =3D "SNIC_IOREQ_ABTS_COMPELTE",
>> +	[SNIC_IOREQ_LR_PENDING]	=3D "SNIC_IOREQ_LR_PENDING",
>> +	[SNIC_IOREQ_LR_COMPLETE] =3D "SNIC_IOREQ_LR_COMPELTE",
>> +	[SNIC_IOREQ_COMPLETE]	=3D "SNIC_IOREQ_CMD_COMPELTE",
>> +};
>> +
>> +/* snic cmd status strings */
>> +static const char * const snic_io_status_str[] =3D {
>> +	[SNIC_STAT_IO_SUCCESS]	=3D "SNIC_STAT_IO_SUCCESS", /* 0x0 */
>> +	[SNIC_STAT_INVALID_HDR] =3D "SNIC_STAT_INVALID_HDR",
>> +	[SNIC_STAT_OUT_OF_RES]	=3D "SNIC_STAT_OUT_OF_RES",
>> +	[SNIC_STAT_INVALID_PARM] =3D "SNIC_STAT_INVALID_PARM",
>> +	[SNIC_STAT_REQ_NOT_SUP]	=3D "SNIC_STAT_REQ_NOT_SUP",
>> +	[SNIC_STAT_IO_NOT_FOUND] =3D "SNIC_STAT_IO_NOT_FOUND",
>> +	[SNIC_STAT_ABORTED]	=3D "SNIC_STAT_ABORTED",
>> +	[SNIC_STAT_TIMEOUT]	=3D "SNIC_STAT_TIMEOUT",
>> +	[SNIC_STAT_SGL_INVALID] =3D "SNIC_STAT_SGL_INVALID",
>> +	[SNIC_STAT_DATA_CNT_MISMATCH] =3D "SNIC_STAT_DATA_CNT_MISMATCH",
>> +	[SNIC_STAT_FW_ERR]	=3D "SNIC_STAT_FW_ERR",
>> +	[SNIC_STAT_ITMF_REJECT] =3D "SNIC_STAT_ITMF_REJECT",
>> +	[SNIC_STAT_ITMF_FAIL]	=3D "SNIC_STAT_ITMF_FAIL",
>> +	[SNIC_STAT_ITMF_INCORRECT_LUN] =3D "SNIC_STAT_ITMF_INCORRECT_LUN",
>> +	[SNIC_STAT_CMND_REJECT] =3D "SNIC_STAT_CMND_REJECT",
>> +	[SNIC_STAT_DEV_OFFLINE] =3D "SNIC_STAT_DEV_OFFLINE",
>> +	[SNIC_STAT_NO_BOOTLUN]	=3D "SNIC_STAT_NO_BOOTLUN",
>> +	[SNIC_STAT_SCSI_ERR]	=3D "SNIC_STAT_SCSI_ERR",
>> +	[SNIC_STAT_NOT_READY]	=3D "SNIC_STAT_NOT_READY",
>> +	[SNIC_STAT_FATAL_ERROR]	=3D "SNIC_STAT_FATAL_ERROR",
>> +};
>> +
>> +static void snic_scsi_cleanup(struct snic *, int);
>> +
>> +const char *
>> +snic_state_to_str(unsigned int state)
>> +{
>> +	if (state >=3D ARRAY_SIZE(snic_state_str) || !snic_state_str[state=
])
>> +		return "Unknown";
>> +
>> +	return snic_state_str[state];
>> +}
>> +
>> +static const char *
>> +snic_io_status_to_str(unsigned int state)
>> +{
>> +	if ((state >=3D ARRAY_SIZE(snic_io_status_str)) ||
>> +	     (!snic_io_status_str[state]))
>> +		return "Unknown";
>> +
>> +	return snic_io_status_str[state];
>> +}
>> +
>> +static const char *
>> +snic_ioreq_state_to_str(unsigned int state)
>> +{
>> +	if (state >=3D ARRAY_SIZE(snic_req_state_str) ||
>> +			!snic_req_state_str[state])
>> +		return "Unknown";
>> +
>> +	return snic_req_state_str[state];
>> +}
>> +
>> +static inline spinlock_t *
>> +snic_io_lock_hash(struct snic *snic, struct scsi_cmnd *sc)
>> +{
>> +	u32 hash =3D snic_cmd_tag(sc) & (SNIC_IO_LOCKS - 1);
>> +
>> +	return &snic->io_req_lock[hash];
>> +}
>> +
>> +static inline spinlock_t *
>> +snic_io_lock_tag(struct snic *snic, int tag)
>> +{
>> +	return &snic->io_req_lock[tag & (SNIC_IO_LOCKS - 1)];
>> +}
>> +
>> +/* snic_release_req_buf : Releases snic_req_info */
>> +static void
>> +snic_release_req_buf(struct snic *snic,
>> +		   struct snic_req_info *rqi,
>> +		   struct scsi_cmnd *sc)
>> +{
>> +	struct snic_host_req *req =3D rqi_to_req(rqi);
>> +
>> +	/* Freeing cmd without marking completion, not okay */
>> +	SNIC_BUG_ON(!((CMD_STATE(sc) =3D=3D SNIC_IOREQ_COMPLETE) ||
>> +		      (CMD_STATE(sc) =3D=3D SNIC_IOREQ_ABTS_COMPLETE) ||
>> +		      (CMD_FLAGS(sc) & SNIC_DEV_RST_NOTSUP) ||
>> +		      (CMD_FLAGS(sc) & SNIC_IO_INTERNAL_TERM_ISSUED) ||
>> +		      (CMD_FLAGS(sc) & SNIC_DEV_RST_TERM_ISSUED) ||
>> +		      (CMD_FLAGS(sc) & SNIC_SCSI_CLEANUP) ||
>> +		      (CMD_STATE(sc) =3D=3D SNIC_IOREQ_LR_COMPLETE)));
>> +
>> +	SNIC_SCSI_DBG(snic->shost,
>> +		      "Rel_req:sc %p:tag %x:rqi %p:ioreq %p:abt %p:dr %p: state
>>%s:flags 0x%x\n",
>> +		      sc, snic_cmd_tag(sc), rqi, rqi->req, rqi->abort_req,
>> +		      rqi->dr_req, snic_ioreq_state_to_str(CMD_STATE(sc)),
>> +		      CMD_FLAGS(sc));
>> +
>> +	if (req->u.icmnd.sense_addr)
>> +		pci_unmap_single(snic->pdev,
>> +				 req->u.icmnd.sense_addr,
>> +				 SCSI_SENSE_BUFFERSIZE,
>> +				 PCI_DMA_FROMDEVICE);
>> +
>> +	scsi_dma_unmap(sc);
>> +
>> +	snic_req_free(snic, rqi);
>> +} /* end of snic_release_req_buf */
>> +
>> +/*
>> + * snic_queue_icmnd_req : Queues snic_icmnd request
>> + */
>> +static int
>> +snic_queue_icmnd_req(struct snic *snic,
>> +		     struct snic_req_info *rqi,
>> +		     struct scsi_cmnd *sc,
>> +		     int sg_cnt)
>> +{
>> +	struct scatterlist *sg;
>> +	struct snic_sg_desc *sgd;
>> +	dma_addr_t pa =3D 0;
>> +	struct scsi_lun lun;
>> +	int flags =3D 0;
>> +	int ret =3D 0;
>> +	unsigned int i;
>> +
>> +	if (sg_cnt) {
>> +		flags =3D SNIC_ICMND_ESGL;
>> +		sgd =3D (struct snic_sg_desc *) req_to_sgl(rqi->req);
>> +
>> +		for_each_sg(scsi_sglist(sc), sg, sg_cnt, i) {
>> +			sgd->addr =3D cpu_to_le64(sg_dma_address(sg));
>> +			sgd->len =3D cpu_to_le32(sg_dma_len(sg));
>> +			sgd->_resvd =3D 0;
>> +			sgd++;
>> +		}
>> +	}
>> +
>> +	pa =3D pci_map_single(snic->pdev,
>> +			    sc->sense_buffer,
>> +			    SCSI_SENSE_BUFFERSIZE,
>> +			    PCI_DMA_FROMDEVICE);
>> +
>> +	if (pci_dma_mapping_error(snic->pdev, pa)) {
>> +		SNIC_HOST_ERR(snic->shost,
>> +			      "QIcmnd:PCI Map Failed for sns buf %p tag %x\n",
>> +			      sc->sense_buffer, snic_cmd_tag(sc));
>> +		ret =3D -ENOMEM;
>> +
>> +		return ret;
>> +	}
>> +
>> +	int_to_scsilun(sc->device->lun, &lun);
>> +	if (sc->sc_data_direction =3D=3D DMA_FROM_DEVICE)
>> +		flags |=3D SNIC_ICMND_RD;
>> +	if (sc->sc_data_direction =3D=3D DMA_TO_DEVICE)
>> +		flags |=3D SNIC_ICMND_WR;
>> +
>> +	/* Initialize icmnd */
>> +	snic_icmnd_init(rqi->req,
>> +			snic_cmd_tag(sc),
>> +			snic->config.hid, /* hid */
>> +			(u64)rqi,
>> +			flags, /* command flags */
>> +			rqi->tgt_id,
>> +			lun.scsi_lun,
>> +			sc->cmnd,
>> +			sc->cmd_len,
>> +			scsi_bufflen(sc),
>> +			sg_cnt,
>> +			(u64)req_to_sgl(rqi->req),
>> +			pa, /* sense buffer pa */
>> +			SCSI_SENSE_BUFFERSIZE);
>> +
>> +	ret =3D snic_queue_wq_desc(snic, rqi->req, rqi->req_len);
>> +	if (ret)
>> +		SNIC_HOST_ERR(snic->shost,
>> +			      "QIcmnd: Queuing Icmnd Failed. ret =3D %d\n",
>> +			      ret);
>> +
>> +	return ret;
>> +} /* end of snic_queue_icmnd_req */
>> +
>> +/*
>> + * snic_issue_scsi_req : Prepares IO request and Issues to FW.
>> + */
>> +static int
>> +snic_issue_scsi_req(struct snic *snic,
>> +		      struct snic_tgt *tgt,
>> +		      struct scsi_cmnd *sc)
>> +{
>> +	struct snic_req_info *rqi =3D NULL;
>> +	int sg_cnt =3D 0;
>> +	int ret =3D 0;
>> +	u32 tag =3D snic_cmd_tag(sc);
>> +	u64 cmd_trc =3D 0, cmd_st_flags =3D 0;
>> +	spinlock_t *io_lock =3D NULL;
>> +	unsigned long flags;
>> +
>> +	CMD_STATE(sc) =3D SNIC_IOREQ_NOT_INITED;
>> +	CMD_FLAGS(sc) =3D SNIC_NO_FLAGS;
>> +	sg_cnt =3D scsi_dma_map(sc);
>> +	if (sg_cnt < 0) {
>> +		SNIC_TRC((u16)snic->shost->host_no, tag, (u64)sc, 0,
>> +			 sc->cmnd[0], sg_cnt, CMD_STATE(sc));
>> +
>> +		SNIC_HOST_ERR(snic->shost, "issue_sc:Failed to map SG List.\n");
>> +		ret =3D -ENOMEM;
>> +
>> +		goto issue_sc_end;
>> +	}
>> +
>> +	rqi =3D snic_req_init(snic, sg_cnt);
>> +	if (!rqi) {
>> +		scsi_dma_unmap(sc);
>> +		ret =3D -ENOMEM;
>> +
>> +		goto issue_sc_end;
>> +	}
>> +
>> +	rqi->tgt_id =3D tgt->id;
>> +	rqi->sc =3D sc;
>> +
>> +	CMD_STATE(sc) =3D SNIC_IOREQ_PENDING;
>> +	CMD_SP(sc) =3D (char *) rqi;
>> +	cmd_trc =3D SNIC_TRC_CMD(sc);
>> +	CMD_FLAGS(sc) |=3D (SNIC_IO_INITIALIZED | SNIC_IO_ISSUED);
>> +	cmd_st_flags =3D SNIC_TRC_CMD_STATE_FLAGS(sc);
>> +	io_lock =3D snic_io_lock_hash(snic, sc);
>> +
>> +	/* create wq desc and enqueue it */
>> +	ret =3D snic_queue_icmnd_req(snic, rqi, sc, sg_cnt);
>> +	if (ret) {
>> +		SNIC_HOST_ERR(snic->shost,
>> +			      "issue_sc: icmnd qing Failed for sc %p, err %d\n",
>> +			      sc, ret);
>> +
>> +		spin_lock_irqsave(io_lock, flags);
>> +		rqi =3D (struct snic_req_info *) CMD_SP(sc);
>> +		CMD_SP(sc) =3D NULL;
>> +		CMD_STATE(sc) =3D SNIC_IOREQ_COMPLETE;
>> +		CMD_FLAGS(sc) &=3D ~SNIC_IO_ISSUED; /* turn off the flag */
>> +		spin_unlock_irqrestore(io_lock, flags);
>> +
>> +		if (rqi)
>> +			snic_release_req_buf(snic, rqi, sc);
>> +
>> +		SNIC_TRC(snic->shost->host_no, tag, (u64)sc, 0, 0, 0,
>> +			 SNIC_TRC_CMD_STATE_FLAGS(sc));
>> +	} else {
>> +		u32 io_sz =3D scsi_bufflen(sc) >> 9;
>> +		u32 qtime =3D jiffies - rqi->start_time;
>> +		struct snic_io_stats *iostats =3D &snic->s_stats.io;
>> +
>> +		if (io_sz > atomic64_read(&iostats->max_io_sz))
>> +			atomic64_set(&iostats->max_io_sz, io_sz);
>> +
>> +		if (qtime > atomic64_read(&iostats->max_qtime))
>> +			atomic64_set(&iostats->max_qtime, qtime);
>> +
>> +		SNIC_SCSI_DBG(snic->shost,
>> +			      "issue_sc:sc %p, tag %d queued to WQ.\n",
>> +			      sc, tag);
>> +
>> +		SNIC_TRC(snic->shost->host_no, tag, (u64)sc, (u64)rqi, sg_cnt,
>> +			 cmd_trc, cmd_st_flags);
>> +	}
>> +
>> +issue_sc_end:
>> +
>> +	return ret;
>> +} /* end of snic_issue_scsi_req */
>> +
>> +
>> +/*
>> + * snic_queuecommand
>> + * Routine to send a scsi cdb to LLD
>> + * Called with host_lock held and interrupts disabled
>> + */
>> +int
>> +snic_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc)
>> +{
>> +	struct snic_tgt *tgt =3D NULL;
>> +	struct snic *snic =3D shost_priv(shost);
>> +	int ret;
>> +
>> +	tgt =3D starget_to_tgt(scsi_target(sc->device));
>> +	ret =3D snic_tgt_chkready(tgt);
>> +	if (ret) {
>> +		SNIC_HOST_ERR(shost, "Tgt %p id %d Not Ready.\n", tgt, tgt->id);
>> +		atomic64_inc(&snic->s_stats.misc.tgt_not_rdy);
>> +		sc->result =3D ret;
>> +		sc->scsi_done(sc);
>> +
>> +		return 0;
>> +	}
>> +
>> +	if (snic_get_state(snic) !=3D SNIC_ONLINE) {
>> +		SNIC_HOST_ERR(shost, "snic state is %s\n",
>> +			      snic_state_str[snic_get_state(snic)]);
>> +
>> +		return SCSI_MLQUEUE_HOST_BUSY;
>> +	}
>> +	atomic_inc(&snic->ios_inflight);
>> +
>> +	SNIC_SCSI_DBG(shost, "sc %p Tag %d (sc %0x) lun %lld in snic_qcmd\=
n",
>> +		      sc, snic_cmd_tag(sc), sc->cmnd[0], sc->device->lun);
>> +
>> +#ifdef SNIC_DEBUG
>> +	scsi_print_command(sc);
>> +#endif
>> +
>> +	ret =3D snic_issue_scsi_req(snic, tgt, sc);
>> +	if (ret) {
>> +		SNIC_HOST_ERR(shost, "Failed to Q, Scsi Req w/ err %d.\n", ret);
>> +		ret =3D SCSI_MLQUEUE_HOST_BUSY;
>> +	} else
>> +		snic_stats_update_active_ios(&snic->s_stats);
>> +
>> +	atomic_dec(&snic->ios_inflight);
>> +
>> +	return ret;
>> +} /* end of snic_queuecommand */
>> +
>> +/*
>> + * snic_process_abts_pending_state:
>> + * caller should hold IO lock
>> + */
>> +static void
>> +snic_proc_tmreq_pending_state(struct snic *snic,
>> +			      struct scsi_cmnd *sc,
>> +			      u8 cmpl_status)
>> +{
>> +	int state =3D CMD_STATE(sc);
>> +
>> +	if (state =3D=3D SNIC_IOREQ_ABTS_PENDING)
>> +		CMD_FLAGS(sc) |=3D SNIC_IO_ABTS_PENDING;
>> +	else if (state =3D=3D SNIC_IOREQ_LR_PENDING)
>> +		CMD_FLAGS(sc) |=3D SNIC_DEV_RST_PENDING;
>> +	else
>> +		SNIC_BUG_ON(1);
>> +
>> +	switch (cmpl_status) {
>> +	case SNIC_STAT_IO_SUCCESS:
>> +		CMD_FLAGS(sc) |=3D SNIC_IO_DONE;
>> +		break;
>> +
>> +	case SNIC_STAT_ABORTED:
>> +		CMD_FLAGS(sc) |=3D SNIC_IO_ABORTED;
>> +		break;
>> +
>> +	default:
>> +		SNIC_BUG_ON(1);
>> +	}
>> +}
>> +
>> +/*
>> + * snic_process_io_failed_state:
>> + * Processes IO's error states
>> + */
>> +static void
>> +snic_process_io_failed_state(struct snic *snic,
>> +			     struct snic_icmnd_cmpl *icmnd_cmpl,
>> +			     struct scsi_cmnd *sc,
>> +			     u8 cmpl_stat)
>> +{
>> +	int res =3D 0;
>> +
>> +	switch (cmpl_stat) {
>> +	case SNIC_STAT_TIMEOUT:		/* Req was timedout */
>> +		atomic64_inc(&snic->s_stats.misc.io_tmo);
>> +		res =3D DID_TIME_OUT;
>> +		break;
>> +
>> +	case SNIC_STAT_ABORTED:		/* Req was aborted */
>> +		atomic64_inc(&snic->s_stats.misc.io_aborted);
>> +		res =3D DID_ERROR;
>> +		break;
>> +
>> +	case SNIC_STAT_DATA_CNT_MISMATCH:/* Recv/Sent more/less data than =
exp
>>*/
>> +		atomic64_inc(&snic->s_stats.misc.data_cnt_mismat);
>> +		scsi_set_resid(sc, icmnd_cmpl->resid);
>> +		res =3D DID_ERROR;
>> +		break;
>> +
>> +	case SNIC_STAT_OUT_OF_RES: /* Out of resources to complete request=
 */
>> +		atomic64_inc(&snic->s_stats.fw.out_of_res);
>> +		res =3D DID_REQUEUE;
>> +		break;
>> +
>> +	case SNIC_STAT_IO_NOT_FOUND:	/* Requested I/O was not found */
>> +		atomic64_inc(&snic->s_stats.io.io_not_found);
>> +		res =3D DID_ERROR;
>> +		break;
>> +
>> +	case SNIC_STAT_SGL_INVALID:	/* Req was aborted to due to sgl error=
*/
>> +		atomic64_inc(&snic->s_stats.misc.sgl_inval);
>> +		res =3D DID_ERROR;
>> +		break;
>> +
>> +	case SNIC_STAT_FW_ERR:		/* Req terminated due to FW Error */
>> +		atomic64_inc(&snic->s_stats.fw.io_errs);
>> +		res =3D DID_ERROR;
>> +		break;
>> +
>> +	case SNIC_STAT_SCSI_ERR:	/* FW hits SCSI Error */
>> +		atomic64_inc(&snic->s_stats.fw.scsi_errs);
>> +		res =3D DID_ERROR;
>> +		break;
>> +
>> +	case SNIC_STAT_INVALID_HDR:	/* Hdr contains invalid data */
>> +	case SNIC_STAT_INVALID_PARM:	/* Some param in req is invalid */
>> +	case SNIC_STAT_REQ_NOT_SUP:	/* Req type is not supported */
>> +	case SNIC_STAT_CMND_REJECT:	/* Req rejected */
>> +	case SNIC_STAT_DEV_OFFLINE:	/* Device offline */
>> +	case SNIC_STAT_NOT_READY:	/* XPT yet to initialize */
>> +	case SNIC_STAT_FATAL_ERROR:	/* XPT Error */
>> +	default:
>> +		SNIC_SCSI_DBG(snic->shost,
>> +			      "Invalid Hdr/Param or Req Not Supported or Cmnd Rejected o=
r
>>Device Offline. or Unknown\n");
>> +		res =3D DID_ERROR;
>> +		break;
>> +	}
>> +
>> +	SNIC_HOST_ERR(snic->shost, "fw returns failed status %s flags 0x%x=
\n",
>> +		      snic_io_status_to_str(cmpl_stat), CMD_FLAGS(sc));
>> +
>> +	/* Set sc->result */
>> +	sc->result =3D (res << 16) | icmnd_cmpl->scsi_status;
>> +} /* end of snic_process_io_failed_state */
>> +
>> +/*
>> + * snic_tmreq_pending : is task management in progress.
>> + */
>> +static int
>> +snic_tmreq_pending(struct scsi_cmnd *sc)
>> +{
>> +	int state =3D CMD_STATE(sc);
>> +
>> +	return ((state =3D=3D SNIC_IOREQ_ABTS_PENDING) ||
>> +			(state =3D=3D SNIC_IOREQ_LR_PENDING));
>> +}
>> +
>> +/*
>> + * snic_process_icmnd_cmpl_status:
>> + * Caller should hold io_lock
>> + */
>> +static int
>> +snic_process_icmnd_cmpl_status(struct snic *snic,
>> +			       struct snic_icmnd_cmpl *icmnd_cmpl,
>> +			       u8 cmpl_stat,
>> +			       struct scsi_cmnd *sc)
>> +{
>> +	u8 scsi_stat =3D icmnd_cmpl->scsi_status;
>> +	u64 xfer_len =3D 0;
>> +	int ret =3D 0;
>> +
>> +	/* Mark the IO as complete */
>> +	CMD_STATE(sc) =3D SNIC_IOREQ_COMPLETE;
>> +
>> +	if (likely(cmpl_stat =3D=3D SNIC_STAT_IO_SUCCESS)) {
>> +		sc->result =3D (DID_OK << 16) | scsi_stat;
>> +
>> +		xfer_len =3D scsi_bufflen(sc);
>> +
>> +		/* Update SCSI Cmd with resid value */
>> +		scsi_set_resid(sc, icmnd_cmpl->resid);
>> +
>> +		if (icmnd_cmpl->flags & SNIC_ICMND_CMPL_UNDR_RUN) {
>> +			xfer_len -=3D icmnd_cmpl->resid;
>> +			atomic64_inc(&snic->s_stats.misc.io_under_run);
>> +		}
>> +
>> +		if (icmnd_cmpl->scsi_status =3D=3D SAM_STAT_TASK_SET_FULL)
>> +			atomic64_inc(&snic->s_stats.misc.qfull);
>> +
>> +		ret =3D 0;
>> +	} else {
>> +		snic_process_io_failed_state(snic, icmnd_cmpl, sc, cmpl_stat);
>> +		atomic64_inc(&snic->s_stats.io.fail);
>> +		SNIC_HOST_ERR(snic->shost,
>> +			      "icmnd_cmpl: IO Failed : Hdr Status %s flags 0x%x\n",
>> +			      snic_io_status_to_str(cmpl_stat), CMD_FLAGS(sc));
>> +		ret =3D 1;
>> +	}
>> +
>> +	return ret;
>> +} /* end of snic_process_icmnd_cmpl_status */
>> +
>> +
>> +/*
>> + * snic_icmnd_cmpl_handler
>> + * Routine to handle icmnd completions
>> + */
>> +static void
>> +snic_icmnd_cmpl_handler(struct snic *snic, struct snic_fw_req *fwre=
q)
>> +{
>> +	u8 typ, hdr_stat;
>> +	u32 cmnd_id, hid;
>> +	u64 ctx;
>> +	struct scsi_cmnd *sc =3D NULL;
>> +	struct snic_icmnd_cmpl *icmnd_cmpl =3D NULL;
>> +	struct snic_host_req *req =3D NULL;
>> +	struct snic_req_info *rqi =3D NULL;
>> +	unsigned long flags, start_time;
>> +	spinlock_t *io_lock;
>> +	u8 sc_stat =3D 0;
>> +
>> +	snic_io_hdr_dec(&fwreq->hdr, &typ, &hdr_stat, &cmnd_id, &hid, &ctx=
);
>> +	icmnd_cmpl =3D &fwreq->u.icmnd_cmpl;
>> +	sc_stat =3D icmnd_cmpl->scsi_status;
>> +
>> +	SNIC_SCSI_DBG(snic->shost,
>> +		      "Icmnd_cmpl: type =3D %x, hdr_stat =3D %x, cmnd_id =3D %x, =
hid =3D
>>%x,i ctx =3D %llx\n",
>> +		      typ, hdr_stat, cmnd_id, hid, ctx);
>> +
>> +	if (cmnd_id >=3D snic->max_tag_id) {
>> +		SNIC_HOST_ERR(snic->shost,
>> +			      "Icmnd_cmpl:Tag Error:Out of Range Tag %d, hdr status =3D =
%s\n",
>> +			      cmnd_id, snic_io_status_to_str(hdr_stat));
>> +		return;
>> +	}
>> +
>> +	sc =3D scsi_host_find_tag(snic->shost, cmnd_id);
>> +	WARN_ON_ONCE(!sc);
>> +
>> +	if (!sc) {
>> +		atomic64_inc(&snic->s_stats.io.sc_null);
>> +		SNIC_HOST_ERR(snic->shost,
>> +			      "Icmnd_cmpl: Scsi Cmnd Not found, sc =3D NULL Hdr Status =3D=
 %s
>>tag =3D 0x%x fwreq =3D 0x%p\n",
>> +			      snic_io_status_to_str(hdr_stat),
>> +			      cmnd_id,
>> +			      fwreq);
>> +
>> +		SNIC_TRC(snic->shost->host_no, cmnd_id, 0,
>> +			 ((u64)hdr_stat << 16 |
>> +			  (u64)sc_stat << 8 | (u64)icmnd_cmpl->flags),
>> +			 fwreq, icmnd_cmpl->resid, ctx);
>> +
>> +		return;
>> +	}
>> +
>> +
>> +#ifdef SNIC_DEBUG
>> +	scsi_print_result(sc);
>> +#endif
>> +
>> +	io_lock =3D snic_io_lock_hash(snic, sc);
>> +
>> +	spin_lock_irqsave(io_lock, flags);
>> +	rqi =3D (struct snic_req_info *) CMD_SP(sc);
>> +	SNIC_SCSI_DBG(snic->shost,
>> +		      "Icmnd_cmpl:lun %lld sc %p cmd %xtag %d flags %xrqi %p\n",
>> +		      sc->device->lun, sc, sc->cmnd[0], snic_cmd_tag(sc),
>> +		      CMD_FLAGS(sc), rqi);
>> +
>> +	SNIC_BUG_ON(rqi !=3D (struct snic_req_info *)ctx);
>> +	WARN_ON_ONCE(req);
>
>Now that is curious.
>'ctx' already points to the 'snic_req_info', so why do we need to
>have this double lookup here?
>'scsi_host_find_tag' above already will tell us if the command is
>valid; the tag map is managed by the driver, after all, so the
>driver will guarantee that a busy tag will not be reused.
>
>Why can't we do away with the 'CMD_SP' reference and get the
>scsi command via tag lookup?
>That would simplify the code by quite a bit ...

Yes, tag look up is more preferred way. The additional lookup is added =
to
catch driver and firmware synchronisation issues if there are any.

>
>> +	if (!rqi) {
>> +		atomic64_inc(&snic->s_stats.io.req_null);
>> +		CMD_FLAGS(sc) |=3D SNIC_IO_REQ_NULL;
>> +		spin_unlock_irqrestore(io_lock, flags);
>> +
>> +		SNIC_HOST_ERR(snic->shost,
>> +			      "Icmnd_cmpl:Host Req Not Found(null), Hdr Status %s, Tag
>>0x%x, sc 0x%p flags 0x%x\n",
>> +			      snic_io_status_to_str(hdr_stat),
>> +			      cmnd_id, sc, CMD_FLAGS(sc));
>> +		return;
>> +	}
>> +
>> +	rqi =3D (struct snic_req_info *) ctx;
>> +	start_time =3D rqi->start_time;
>> +
>> +	/* firmware completed the io */
>> +	rqi->io_cmpl =3D 1;
>> +
>> +	/*
>> +	 * if SCSI-ML has already issued abort on this command,
>> +	 * ignore completion of the IO. The abts path will clean it up
>> +	 */
>> +	if (unlikely(snic_tmreq_pending(sc))) {
>> +		snic_proc_tmreq_pending_state(snic, sc, hdr_stat);
>> +		spin_unlock_irqrestore(io_lock, flags);
>> +
>> +		snic_stats_update_io_cmpl(&snic->s_stats);
>> +
>> +		/* Expected value is SNIC_STAT_ABORTED */
>> +		if (likely(hdr_stat =3D=3D SNIC_STAT_ABORTED))
>> +			return;
>> +
>> +		SNIC_SCSI_DBG(snic->shost,
>> +			      "icmnd_cmpl:TM Req Pending(%s), Hdr Status %s sc 0x%p scsi
>>status %x resid %d flags 0x%x\n",
>> +			      snic_ioreq_state_to_str(CMD_STATE(sc)),
>> +			      snic_io_status_to_str(hdr_stat),
>> +			      sc, sc_stat, icmnd_cmpl->resid, CMD_FLAGS(sc));
>> +
>> +		SNIC_TRC(snic->shost->host_no, cmnd_id, sc,
>> +			 jiffies_to_msecs(jiffies - start_time), fwreq,
>> +			 SNIC_TRC_CMD(sc), SNIC_TRC_CMD_STATE_FLAGS(sc));
>> +
>> +		return;
>> +	}
>> +
>> +	if (snic_process_icmnd_cmpl_status(snic, icmnd_cmpl, hdr_stat, sc)=
) {
>> +#ifdef SNIC_DEBUG
>> +		scsi_print_command(sc);
>> +#endif
>> +		SNIC_HOST_ERR(snic->shost,
>> +			      "icmnd_cmpl:IO Failed, sc 0x%p Tag %d Cmd %x Hdr Status %s
>>flags 0x%x\n",
>> +			      sc, sc->cmnd[0], cmnd_id,
>> +			      snic_io_status_to_str(hdr_stat), CMD_FLAGS(sc));
>> +	}
>> +
>> +	/* Break link with the SCSI Command */
>> +	CMD_SP(sc) =3D NULL;
>> +	CMD_FLAGS(sc) |=3D SNIC_IO_DONE;
>> +
>
>And then we wouldn't have to modify the CMD_SP() here ...
>
>> +	spin_unlock_irqrestore(io_lock, flags);
>> +
>> +	/* For now, consider only successful IO. */
>> +	snic_calc_io_process_time(snic, rqi);
>> +
>> +	snic_release_req_buf(snic, rqi, sc);
>> +
>> +	SNIC_TRC(snic->shost->host_no, cmnd_id, (u64)sc,
>> +		 jiffies_to_msecs(jiffies - start_time), (u64)fwreq,
>> +		 SNIC_TRC_CMD(sc), SNIC_TRC_CMD_STATE_FLAGS(sc));
>> +
>> +
>> +	if (sc->scsi_done)
>> +		sc->scsi_done(sc);
>> +
>> +	snic_stats_update_io_cmpl(&snic->s_stats);
>> +} /* end of snic_icmnd_cmpl_handler */
>> +
>> +static void
>> +snic_proc_dr_cmpl_locked(struct snic *snic,
>> +			 struct snic_fw_req *fwreq,
>> +			 u8 cmpl_stat,
>> +			 u32 cmnd_id,
>> +			 struct scsi_cmnd *sc)
>> +{
>> +	struct snic_req_info *rqi =3D (struct snic_req_info *) CMD_SP(sc);
>> +	u32 start_time =3D rqi->start_time;
>> +
>> +	CMD_LR_STATUS(sc) =3D cmpl_stat;
>> +
>> +	SNIC_SCSI_DBG(snic->shost, "itmf_cmpl: Cmd State =3D %s\n",
>> +		      snic_ioreq_state_to_str(CMD_STATE(sc)));
>> +
>> +	if (CMD_STATE(sc) =3D=3D SNIC_IOREQ_ABTS_PENDING) {
>> +		CMD_FLAGS(sc) |=3D SNIC_DEV_RST_ABTS_PENDING;
>> +
>> +		SNIC_TRC(snic->shost->host_no, cmnd_id, sc,
>> +			 jiffies_to_msecs(jiffies - start_time),
>> +			 fwreq, 0, SNIC_TRC_CMD_STATE_FLAGS(sc));
>> +
>> +		SNIC_SCSI_DBG(snic->shost,
>> +			      "itmf_cmpl: Terminate Pending Dev Reset Cmpl Recvd.id %x,
>>status %s flags 0x%x\n",
>> +			      (int)(cmnd_id & SNIC_TAG_MASK),
>> +			      snic_io_status_to_str(cmpl_stat),
>> +			      CMD_FLAGS(sc));
>> +
>> +		return;
>> +	}
>> +
>> +
>> +	if (CMD_FLAGS(sc) & SNIC_DEV_RST_TIMEDOUT) {
>> +		SNIC_TRC(snic->shost->host_no, cmnd_id, sc,
>> +			 jiffies_to_msecs(jiffies - start_time),
>> +			 fwreq, 0, SNIC_TRC_CMD_STATE_FLAGS(sc));
>> +
>> +		SNIC_SCSI_DBG(snic->shost,
>> +			      "itmf_cmpl:Dev Reset Completion Received after timeout. id=
 %d
>>cmpl status %s flags 0x%x\n",
>> +			      (int)(cmnd_id & SNIC_TAG_MASK),
>> +			      snic_io_status_to_str(cmpl_stat),
>> +			      CMD_FLAGS(sc));
>> +
>> +		return;
>> +	}
>> +
>> +	CMD_STATE(sc) =3D SNIC_IOREQ_LR_COMPLETE;
>> +	CMD_FLAGS(sc) |=3D SNIC_DEV_RST_DONE;
>> +
>> +	SNIC_SCSI_DBG(snic->shost,
>> +		      "itmf_cmpl:Dev Reset Cmpl Recvd id %d cmpl status %s flags
>>0x%x\n",
>> +		      (int)(cmnd_id & SNIC_TAG_MASK),
>> +		      snic_io_status_to_str(cmpl_stat),
>> +		      CMD_FLAGS(sc));
>> +
>> +	if (rqi->dr_done)
>> +		complete(rqi->dr_done);
>> +} /* end of snic_proc_dr_cmpl_locked */
>> +
>> +/*
>> + * snic_update_abort_stats : Updates abort stats based on completio=
n
>>status.
>> + */
>> +static void
>> +snic_update_abort_stats(struct snic *snic, u8 cmpl_stat)
>> +{
>> +	struct snic_abort_stats *abt_stats =3D &snic->s_stats.abts;
>> +
>> +	SNIC_SCSI_DBG(snic->shost, "Updating Abort stats.\n");
>> +
>> +	switch (cmpl_stat) {
>> +	case  SNIC_STAT_IO_SUCCESS:
>> +		break;
>> +
>> +	case SNIC_STAT_TIMEOUT:
>> +		atomic64_inc(&abt_stats->fw_tmo);
>> +		break;
>> +
>> +	case SNIC_STAT_IO_NOT_FOUND:
>> +		atomic64_inc(&abt_stats->io_not_found);
>> +		break;
>> +
>> +	default:
>> +		atomic64_inc(&abt_stats->fail);
>> +		break;
>> +	}
>> +}
>> +
>> +static int
>> +snic_process_itmf_cmpl(struct snic *snic,
>> +		       struct snic_fw_req *fwreq,
>> +		       u32 cmnd_id,
>> +		       u8 cmpl_stat,
>> +		       struct scsi_cmnd *sc)
>> +{
>> +	struct snic_req_info *rqi =3D NULL;
>> +	u32 tm_tags =3D 0;
>> +	spinlock_t *io_lock =3D NULL;
>> +	unsigned long flags;
>> +	u32 start_time =3D 0;
>> +	int ret =3D 0;
>> +
>> +	io_lock =3D snic_io_lock_hash(snic, sc);
>> +	spin_lock_irqsave(io_lock, flags);
>> +	rqi =3D (struct snic_req_info *) CMD_SP(sc);
>> +	WARN_ON_ONCE(!rqi);
>> +
>> +	if (!rqi) {
>> +		atomic64_inc(&snic->s_stats.io.req_null);
>> +		spin_unlock_irqrestore(io_lock, flags);
>> +		CMD_FLAGS(sc) |=3D SNIC_IO_ABTS_TERM_REQ_NULL;
>> +		SNIC_HOST_ERR(snic->shost,
>> +			      "itmf_cmpl: rqi is null,Hdr stat =3D %s Tag =3D 0x%x sc =3D=
 0x%p
>>flags 0x%x\n",
>> +			      snic_io_status_to_str(cmpl_stat), cmnd_id, sc,
>> +			      CMD_FLAGS(sc));
>> +
>> +		return ret;
>> +	}
>> +
>> +	/* Extract task management flags */
>> +	tm_tags =3D cmnd_id & ~(SNIC_TAG_MASK);
>> +
>> +	start_time =3D rqi->start_time;
>> +	cmnd_id &=3D (SNIC_TAG_MASK);
>> +
>> +	switch (tm_tags) {
>> +	case SNIC_TAG_ABORT:
>> +		/* Abort only issued on cmd */
>> +		snic_update_abort_stats(snic, cmpl_stat);
>> +
>> +		if (CMD_STATE(sc) !=3D SNIC_IOREQ_ABTS_PENDING) {
>> +			/* This is a late completion. Ignore it. */
>> +			ret =3D -1;
>> +			spin_unlock_irqrestore(io_lock, flags);
>> +			break;
>> +		}
>> +
>> +		CMD_STATE(sc) =3D SNIC_IOREQ_ABTS_COMPLETE;
>> +		CMD_ABTS_STATUS(sc) =3D cmpl_stat;
>> +		CMD_FLAGS(sc) |=3D SNIC_IO_ABTS_TERM_DONE;
>> +
>> +		SNIC_SCSI_DBG(snic->shost,
>> +			      "itmf_cmpl:Abort Cmpl Recvd.Tag 0x%x Status %s flags 0x%x\=
n",
>> +			      cmnd_id,
>> +			      snic_io_status_to_str(cmpl_stat),
>> +			      CMD_FLAGS(sc));
>> +
>> +		/*
>> +		 * If scsi_eh thread is blocked waiting for abts complete,
>> +		 * signal completion to it. IO will be cleaned in the thread,
>> +		 * else clean it in this context.
>> +		 */
>> +		if (rqi->abts_done) {
>> +			complete(rqi->abts_done);
>> +			spin_unlock_irqrestore(io_lock, flags);
>> +
>> +			break; /* jump out */
>> +		}
>> +
>> +		CMD_SP(sc) =3D NULL;
>> +		sc->result =3D (DID_ERROR << 16);
>> +		SNIC_SCSI_DBG(snic->shost,
>> +			      "itmf_cmpl: Completing IO. sc %p flags 0x%x\n",
>> +			      sc, CMD_FLAGS(sc));
>> +
>> +		spin_unlock_irqrestore(io_lock, flags);
>> +
>> +		snic_release_req_buf(snic, rqi, sc);
>> +
>> +		if (sc->scsi_done) {
>> +			SNIC_TRC(snic->shost->host_no, cmnd_id, sc,
>> +				 jiffies_to_msecs(jiffies - start_time),
>> +				 fwreq,
>> +				 SNIC_TRC_CMD(sc),
>> +				 SNIC_TRC_CMD_STATE_FLAGS(sc));
>> +
>> +			sc->scsi_done(sc);
>> +		}
>> +
>> +		break;
>> +
>> +	case SNIC_TAG_DEV_RST:
>> +	case SNIC_TAG_DEV_RST | SNIC_TAG_IOCTL_DEV_RST:
>> +		snic_proc_dr_cmpl_locked(snic, fwreq, cmpl_stat, cmnd_id, sc);
>> +		spin_unlock_irqrestore(io_lock, flags);
>> +		ret =3D 0;
>> +
>> +		break;
>> +
>> +	case SNIC_TAG_ABORT | SNIC_TAG_DEV_RST:
>> +		/* Abort and terminate completion of device reset req */
>> +
>> +		CMD_STATE(sc) =3D SNIC_IOREQ_ABTS_COMPLETE;
>> +		CMD_ABTS_STATUS(sc) =3D cmpl_stat;
>> +		CMD_FLAGS(sc) |=3D SNIC_DEV_RST_DONE;
>> +
>> +		SNIC_SCSI_DBG(snic->shost,
>> +			      "itmf_cmpl:dev reset abts cmpl recvd. id %d status %s flag=
s
>>0x%x\n",
>> +			      cmnd_id, snic_io_status_to_str(cmpl_stat),
>> +			      CMD_FLAGS(sc));
>> +
>> +		if (rqi->abts_done)
>> +			complete(rqi->abts_done);
>> +
>> +		spin_unlock_irqrestore(io_lock, flags);
>> +
>> +		break;
>> +
>> +	default:
>> +		spin_unlock_irqrestore(io_lock, flags);
>> +		SNIC_HOST_ERR(snic->shost,
>> +			      "itmf_cmpl: Unknown TM tag bit 0x%x\n", tm_tags);
>> +
>> +		SNIC_HOST_ERR(snic->shost,
>> +			      "itmf_cmpl:Unexpected itmf io stat %s Tag =3D 0x%x flags
>>0x%x\n",
>> +			      snic_ioreq_state_to_str(CMD_STATE(sc)),
>> +			      cmnd_id,
>> +			      CMD_FLAGS(sc));
>> +		ret =3D -1;
>> +		SNIC_BUG_ON(1);
>> +
>> +		break;
>> +	}
>> +
>> +	return ret;
>> +} /* end of snic_process_itmf_cmpl_status */
>> +
>> +/*
>> + * snic_itmf_cmpl_handler.
>> + * Routine to handle itmf completions.
>> + */
>> +static void
>> +snic_itmf_cmpl_handler(struct snic *snic, struct snic_fw_req *fwreq=
)
>> +{
>> +	struct scsi_cmnd  *sc =3D NULL;
>> +	struct snic_req_info *rqi =3D NULL;
>> +	struct snic_itmf_cmpl *itmf_cmpl =3D NULL;
>> +	u64 ctx;
>> +	u32 cmnd_id;
>> +	u32 hid;
>> +	u8 typ;
>> +	u8 hdr_stat;
>> +
>> +	snic_io_hdr_dec(&fwreq->hdr, &typ, &hdr_stat, &cmnd_id, &hid, &ctx=
);
>> +	SNIC_SCSI_DBG(snic->shost,
>> +		      "Itmf_cmpl: %s: type =3D %x, hdr_stat =3D %x, cmnd_id =3D %=
x, hid =3D
>>%x,ctx =3D %llx\n",
>> +		      __func__, typ, hdr_stat, cmnd_id, hid, ctx);
>> +
>> +	itmf_cmpl =3D &fwreq->u.itmf_cmpl;
>> +	SNIC_SCSI_DBG(snic->shost,
>> +		      "Itmf_cmpl: nterm %u , flags 0x%x\n",
>> +		      itmf_cmpl->nterminated, itmf_cmpl->flags);
>> +
>> +	/* spl case, dev reset issued through ioctl */
>> +	if (cmnd_id & SNIC_TAG_IOCTL_DEV_RST) {
>> +		rqi =3D (struct snic_req_info *) ctx;
>> +		sc =3D rqi->sc;
>> +
>> +		goto ioctl_dev_rst;
>> +	}
>> +
>> +	if ((cmnd_id & SNIC_TAG_MASK) >=3D snic->max_tag_id) {
>> +		SNIC_HOST_ERR(snic->shost,
>> +			      "Itmf_cmpl: Tag 0x%x out of Range,HdrStat %s\n",
>> +			      cmnd_id, snic_io_status_to_str(hdr_stat));
>> +		SNIC_BUG_ON(1);
>> +
>> +		return;
>> +	}
>> +
>> +	sc =3D scsi_host_find_tag(snic->shost, cmnd_id & SNIC_TAG_MASK);
>> +	WARN_ON_ONCE(!sc);
>> +
>Same issue here.
>Why can't you rely on the tag to get the command?
>Then you wouldn't have to to the triple indirection
>
>rqi->sc->rpi
>
>_and_ you would be insulated against command timeouts, where
>'sc' might become invalid ...
Yes, all the time driver relies on tag to get scsi command. But there a=
re
few instances, where scsi command is not associated with a tag. For
example lun reset or host reset are issued through ioctl. In the
exceptional case, where scsi command is not associated with a valid tag=
,
then driver uses this triple redirection. It is common code to handle
tagged and untagged commands.

>
>> +ioctl_dev_rst:
>> +	if (!sc) {
>> +		atomic64_inc(&snic->s_stats.io.sc_null);
>> +		SNIC_HOST_ERR(snic->shost,
>> +			      "Itmf_cmpl: sc is NULL - Hdr Stat %s Tag 0x%x\n",
>> +			      snic_io_status_to_str(hdr_stat), cmnd_id);
>> +
>> +		return;
>> +	}
>> +
>> +	snic_process_itmf_cmpl(snic, fwreq, cmnd_id, hdr_stat, sc);
>> +} /* end of snic_itmf_cmpl_handler */
>> +
>> +
>> +
>> +static void
>> +snic_hba_reset_scsi_cleanup(struct snic *snic, struct scsi_cmnd *sc=
)
>> +{
>> +	struct snic_stats *st =3D &snic->s_stats;
>> +	long act_ios =3D 0, act_fwreqs =3D 0;
>> +
>> +	SNIC_SCSI_DBG(snic->shost, "HBA Reset scsi cleanup.\n");
>> +	snic_scsi_cleanup(snic, snic_cmd_tag(sc));
>> +
>> +	/* Update stats on pending IOs */
>> +	act_ios =3D atomic64_read(&st->io.active);
>> +	atomic64_add(act_ios, &st->io.compl);
>> +	atomic64_sub(act_ios, &st->io.active);
>> +
>> +	act_fwreqs =3D atomic64_read(&st->fw.actv_reqs);
>> +	atomic64_sub(act_fwreqs, &st->fw.actv_reqs);
>> +}
>> +
>> +/*
>> + * snic_hba_reset_cmpl_handler :
>> + *
>> + * Notes :
>> + * 1. Cleanup all the scsi cmds, release all snic specific cmds
>> + * 2. Issue Report Targets in case of SAN targets
>> + */
>> +static int
>> +snic_hba_reset_cmpl_handler(struct snic *snic, struct snic_fw_req=20
>>*fwreq)
>> +{
>> +	u64 ctx;
>> +	u32 cmnd_id;
>> +	u32 hid;
>> +	u8 typ;
>> +	u8 hdr_stat;
>> +	struct scsi_cmnd *sc =3D NULL;
>> +	struct snic_req_info *rqi =3D NULL;
>> +	spinlock_t *io_lock =3D NULL;
>> +	unsigned long flags, gflags;
>> +	int ret =3D 0;
>> +
>> +	SNIC_HOST_INFO(snic->shost,
>> +		       "reset_cmpl:HBA Reset Completion received.\n");
>> +
>> +	snic_io_hdr_dec(&fwreq->hdr, &typ, &hdr_stat, &cmnd_id, &hid, &ctx=
);
>> +	SNIC_SCSI_DBG(snic->shost,
>> +		      "reset_cmpl: type =3D %x, hdr_stat =3D %x, cmnd_id =3D %x, =
hid =3D %x,=20
>>ctx =3D %llx\n",
>> +		      typ, hdr_stat, cmnd_id, hid, ctx);
>> +
>> +	/* spl case, host reset issued through ioctl */
>> +	if (cmnd_id =3D=3D SCSI_NO_TAG) {
>> +		rqi =3D (struct snic_req_info *) ctx;
>> +		sc =3D rqi->sc;
>> +
>> +		goto ioctl_hba_rst;
>> +	}
>> +
>> +	if (cmnd_id >=3D snic->max_tag_id) {
>> +		SNIC_HOST_ERR(snic->shost,
>> +			      "reset_cmpl: Tag 0x%x out of Range,HdrStat %s\n",
>> +			      cmnd_id, snic_io_status_to_str(hdr_stat));
>> +		SNIC_BUG_ON(1);
>> +
>> +		return 1;
>> +	}
>> +
>> +	sc =3D scsi_host_find_tag(snic->shost, cmnd_id);
>> +ioctl_hba_rst:
>> +	if (!sc) {
>> +		atomic64_inc(&snic->s_stats.io.sc_null);
>> +		SNIC_HOST_ERR(snic->shost,
>> +			      "reset_cmpl: sc is NULL - Hdr Stat %s Tag 0x%x\n",
>> +			      snic_io_status_to_str(hdr_stat), cmnd_id);
>> +		ret =3D 1;
>> +
>> +		return ret;
>> +	}
>> +
>> +	io_lock =3D snic_io_lock_hash(snic, sc);
>> +	spin_lock_irqsave(io_lock, flags);
>> +
>> +	if (!snic->remove_wait) {
>> +		spin_unlock_irqrestore(io_lock, flags);
>> +		SNIC_HOST_ERR(snic->shost,
>> +			      "reset_cmpl:host reset completed after timout\n");
>> +		ret =3D 1;
>> +
>> +		return ret;
>> +	}
>> +
>> +	rqi =3D (struct snic_req_info *) CMD_SP(sc);
>> +	WARN_ON_ONCE(!rqi);
>> +
>See above.
>
>If possible I would avoid keeping direct references to the scsi
>command in the firmware request structure; the scsi command might
>timeout while the firmware request is in flight, leaving the
>firmware request with a stale pointer.
>I would rather use the tag in the firmware request and use
>the tag lookup to get to the command.
 You are correct. But there are few instances, where scsi command is no=
t=20
associated with a tag. For example lun reset or host reset are issued=20
through ioctl. In the exceptional case, where scsi command is not=20
associated with a valid tag, driver accesses the scsi command directly.

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
