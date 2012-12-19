From: "Hiral Patel (hiralpat)" <hiralpat@cisco.com>
Subject: Re: [PATCH 06/10] fnic: New debug flags and debug log messages
Date: Wed, 19 Dec 2012 19:32:32 +0000
Message-ID: <DF334AB4E0858445841A5B5201E1C1B1288D9196@xmb-rcd-x08.cisco.com>
References: <1355911271.2905.4.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcdn-iport-1.cisco.com ([173.37.86.72]:48341 "EHLO
	rcdn-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab2LSTcd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Dec 2012 14:32:33 -0500
In-Reply-To: <1355911271.2905.4.camel@dabdike.int.hansenpartnership.com>
Content-Language: en-US
Content-ID: <1F07E0872D6A604BA9D23EECDE2637AB@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>

Hi James,

I agree with your comment. I missed on duplicate definition, as gcc did=
n=B9t
give me error while compiling.

I just resubmitted patch 06 after removing duplicate definition.

Thanks,
Hiral

On 12/19/12 2:01 AM, "James Bottomley"
<James.Bottomley@HansenPartnership.com> wrote:

>On Mon, 2012-12-17 at 15:29 -0800, Hiral Patel wrote:
>> Added new fnic debug flags for identifying IO state at every stage o=
f
>>IO while debugging
>> and also added more log messages for better debugging capability.
>>=20
>> Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
>> Signed-off-by: Hiral Patel <hiralpat@cisco.com>
>> ---
>>  drivers/scsi/fnic/fnic.h      |   32 ++++++++---
>>  drivers/scsi/fnic/fnic_io.h   |    4 +-
>>  drivers/scsi/fnic/fnic_scsi.c |  121
>>+++++++++++++++++++++++++++++++++++++----
>>  3 files changed, 136 insertions(+), 21 deletions(-)
>>=20
>> diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
>> index 9b62fc3..cba8c0e 100644
>> --- a/drivers/scsi/fnic/fnic.h
>> +++ b/drivers/scsi/fnic/fnic.h
>> @@ -50,6 +50,7 @@
>>  /*
>>   * Tag bits used for special requests.
>>   */
>> +#define BIT(nr)			(1UL << (nr))
>
>There already is a macro for this with exactly the same name in
>linux/bitops.h.  You were using it before this patch (although you
>probably need an explicit #include of it).  Doing a duplicate definiti=
on
>is going to cause compiler problems (I'm not sure why gcc isn't
>complaining even now).
>
>James
>
>>  #define FNIC_TAG_ABORT		BIT(30)		/* tag bit indicating abort */
>>  #define FNIC_TAG_DEV_RST	BIT(29)		/* indicates device reset */
>>  #define FNIC_TAG_MASK		(BIT(24) - 1)	/* mask for lookup */
>> @@ -59,14 +60,29 @@
>>   * Command flags to identify the type of command and for other futu=
re
>>   * use.
>>   */
>> -#define FNIC_NO_FLAGS			0
>> -#define FNIC_CDB_REQ			BIT(1)	/* All IOs with a valid CDB */
>> -#define FNIC_BLOCKING_REQ		BIT(2)	/* All blocking Requests */
>> -#define FNIC_DEVICE_RESET		BIT(3)	/* Device reset request */
>> -#define FNIC_DEV_RST_PENDING		BIT(4)	/* Device reset pending */
>> -#define FNIC_DEV_RST_TIMED_OUT		BIT(5)	/* Device reset timed out */
>> -#define FNIC_DEV_RST_TERM_ISSUED	BIT(6)	/* Device reset terminate *=
/
>> -#define FNIC_DEV_RST_DONE		BIT(7)	/* Device reset done */
>> +#define FNIC_NO_FLAGS                   0
>> +#define FNIC_IO_INITIALIZED             BIT(0)
>> +#define FNIC_IO_ISSUED                  BIT(1)
>> +#define FNIC_IO_DONE                    BIT(2)
>> +#define FNIC_IO_REQ_NULL                BIT(3)
>> +#define FNIC_IO_ABTS_PENDING            BIT(4)
>> +#define FNIC_IO_ABORTED                 BIT(5)
>> +#define FNIC_IO_ABTS_ISSUED             BIT(6)
>> +#define FNIC_IO_TERM_ISSUED             BIT(7)
>> +#define FNIC_IO_INTERNAL_TERM_ISSUED    BIT(8)
>> +#define FNIC_IO_ABT_TERM_DONE           BIT(9)
>> +#define FNIC_IO_ABT_TERM_REQ_NULL       BIT(10)
>> +#define FNIC_IO_ABT_TERM_TIMED_OUT      BIT(11)
>> +#define FNIC_DEVICE_RESET               BIT(12)  /* Device reset
>>request */
>> +#define FNIC_DEV_RST_ISSUED             BIT(13)
>> +#define FNIC_DEV_RST_TIMED_OUT          BIT(14)
>> +#define FNIC_DEV_RST_ABTS_ISSUED        BIT(15)
>> +#define FNIC_DEV_RST_TERM_ISSUED        BIT(16)
>> +#define FNIC_DEV_RST_DONE               BIT(17)
>> +#define FNIC_DEV_RST_REQ_NULL           BIT(18)
>> +#define FNIC_DEV_RST_ABTS_DONE          BIT(19)
>> +#define FNIC_DEV_RST_TERM_DONE          BIT(20)
>> +#define FNIC_DEV_RST_ABTS_PENDING       BIT(21)
>> =20
>>  /*
>>   * Usage of the scsi_cmnd scratchpad.
>> diff --git a/drivers/scsi/fnic/fnic_io.h b/drivers/scsi/fnic/fnic_io=
=2Eh
>> index 3455c34..c35b8f1 100644
>> --- a/drivers/scsi/fnic/fnic_io.h
>> +++ b/drivers/scsi/fnic/fnic_io.h
>> @@ -45,7 +45,8 @@ enum fnic_sgl_list_type {
>>  };
>> =20
>>  enum fnic_ioreq_state {
>> -	FNIC_IOREQ_CMD_PENDING =3D 0,
>> +	FNIC_IOREQ_NOT_INITED =3D 0,
>> +	FNIC_IOREQ_CMD_PENDING,
>>  	FNIC_IOREQ_ABTS_PENDING,
>>  	FNIC_IOREQ_ABTS_COMPLETE,
>>  	FNIC_IOREQ_CMD_COMPLETE,
>> @@ -60,6 +61,7 @@ struct fnic_io_req {
>>  	u8 sgl_type; /* device DMA descriptor list type */
>>  	u8 io_completed:1; /* set to 1 when fw completes IO */
>>  	u32 port_id; /* remote port DID */
>> +	unsigned long start_time; /* in jiffies */
>>  	struct completion *abts_done; /* completion for abts */
>>  	struct completion *dr_done; /* completion for device reset */
>>  };
>> diff --git a/drivers/scsi/fnic/fnic_scsi.c
>>b/drivers/scsi/fnic/fnic_scsi.c
>> index a9f436c..e1e817f 100644
>> --- a/drivers/scsi/fnic/fnic_scsi.c
>> +++ b/drivers/scsi/fnic/fnic_scsi.c
>> @@ -47,6 +47,7 @@ const char *fnic_state_str[] =3D {
>>  };
>> =20
>>  static const char *fnic_ioreq_state_str[] =3D {
>> +	[FNIC_IOREQ_NOT_INITED] =3D "FNIC_IOREQ_NOT_INITED",
>>  	[FNIC_IOREQ_CMD_PENDING] =3D "FNIC_IOREQ_CMD_PENDING",
>>  	[FNIC_IOREQ_ABTS_PENDING] =3D "FNIC_IOREQ_ABTS_PENDING",
>>  	[FNIC_IOREQ_ABTS_COMPLETE] =3D "FNIC_IOREQ_ABTS_COMPLETE",
>> @@ -348,6 +349,8 @@ static inline int fnic_queue_wq_copy_desc(struct
>>fnic *fnic,
>> =20
>>  	if (unlikely(!vnic_wq_copy_desc_avail(wq))) {
>>  		spin_unlock_irqrestore(&fnic->wq_copy_lock[0], intr_flags);
>> +		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
>> +			  "fnic_queue_wq_copy_desc failure - no descriptors\n");
>>  		return SCSI_MLQUEUE_HOST_BUSY;
>>  	}
>> =20
>> @@ -419,7 +422,8 @@ static int fnic_queuecommand_lck(struct scsi_cmn=
d
>>*sc, void (*done)(struct scsi_
>>  	 * caller disabling them.
>>  	 */
>>  	spin_unlock(lp->host->host_lock);
>> -	CMD_FLAGS(sc) =3D FNIC_CDB_REQ;
>> +	CMD_STATE(sc) =3D FNIC_IOREQ_NOT_INITED;
>> +	CMD_FLAGS(sc) =3D FNIC_NO_FLAGS;
>> =20
>>  	/* Get a new io_req for this SCSI IO */
>>  	io_req =3D mempool_alloc(fnic->io_req_pool, GFP_ATOMIC);
>> @@ -466,8 +470,10 @@ static int fnic_queuecommand_lck(struct scsi_cm=
nd
>>*sc, void (*done)(struct scsi_
>> =20
>>  	/* initialize rest of io_req */
>>  	io_req->port_id =3D rport->port_id;
>> +	io_req->start_time =3D jiffies;
>>  	CMD_STATE(sc) =3D FNIC_IOREQ_CMD_PENDING;
>>  	CMD_SP(sc) =3D (char *)io_req;
>> +	CMD_FLAGS(sc) |=3D FNIC_IO_INITIALIZED;
>>  	sc->scsi_done =3D done;
>> =20
>>  	/* create copy wq desc and enqueue it */
>> @@ -489,6 +495,9 @@ static int fnic_queuecommand_lck(struct scsi_cmn=
d
>>*sc, void (*done)(struct scsi_
>>  			fnic_release_ioreq_buf(fnic, io_req, sc);
>>  			mempool_free(io_req, fnic->io_req_pool);
>>  		}
>> +	} else {
>> +		/* REVISIT: Use per IO lock in the final code */
>> +		CMD_FLAGS(sc) |=3D FNIC_IO_ISSUED;
>>  	}
>>  out:
>>  	atomic_dec(&fnic->in_flight);
>> @@ -693,10 +702,12 @@ static void fnic_fcpio_icmnd_cmpl_handler(stru=
ct
>>fnic *fnic,
>>  	struct scsi_cmnd *sc;
>>  	unsigned long flags;
>>  	spinlock_t *io_lock;
>> +	unsigned long start_time;
>> =20
>>  	/* Decode the cmpl description to get the io_req id */
>>  	fcpio_header_dec(&desc->hdr, &type, &hdr_status, &tag);
>>  	fcpio_tag_id_dec(&tag, &id);
>> +	icmnd_cmpl =3D &desc->u.icmnd_cmpl;
>> =20
>>  	if (id >=3D FNIC_MAX_IO_REQ) {
>>  		shost_printk(KERN_ERR, fnic->lport->host,
>> @@ -707,17 +718,28 @@ static void fnic_fcpio_icmnd_cmpl_handler(stru=
ct
>>fnic *fnic,
>> =20
>>  	sc =3D scsi_host_find_tag(fnic->lport->host, id);
>>  	WARN_ON_ONCE(!sc);
>> -	if (!sc)
>> +	if (!sc) {
>> +		shost_printk(KERN_ERR, fnic->lport->host,
>> +			  "icmnd_cmpl sc is null - "
>> +			  "hdr status =3D %s tag =3D 0x%x desc =3D 0x%p\n",
>> +			  fnic_fcpio_status_to_str(hdr_status), id, desc);
>>  		return;
>> +	}
>> =20
>>  	io_lock =3D fnic_io_lock_hash(fnic, sc);
>>  	spin_lock_irqsave(io_lock, flags);
>>  	io_req =3D (struct fnic_io_req *)CMD_SP(sc);
>>  	WARN_ON_ONCE(!io_req);
>>  	if (!io_req) {
>> +		CMD_FLAGS(sc) |=3D FNIC_IO_REQ_NULL;
>>  		spin_unlock_irqrestore(io_lock, flags);
>> +		shost_printk(KERN_ERR, fnic->lport->host,
>> +			  "icmnd_cmpl io_req is null - "
>> +			  "hdr status =3D %s tag =3D 0x%x sc 0x%p\n",
>> +			  fnic_fcpio_status_to_str(hdr_status), id, sc);
>>  		return;
>>  	}
>> +	start_time =3D io_req->start_time;
>> =20
>>  	/* firmware completed the io */
>>  	io_req->io_completed =3D 1;
>> @@ -728,6 +750,31 @@ static void fnic_fcpio_icmnd_cmpl_handler(struc=
t
>>fnic *fnic,
>>  	 */
>>  	if (CMD_STATE(sc) =3D=3D FNIC_IOREQ_ABTS_PENDING) {
>>  		spin_unlock_irqrestore(io_lock, flags);
>> +		CMD_FLAGS(sc) |=3D FNIC_IO_ABTS_PENDING;
>> +		switch (hdr_status) {
>> +		case FCPIO_SUCCESS:
>> +			CMD_FLAGS(sc) |=3D FNIC_IO_DONE;
>> +			FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
>> +				  "icmnd_cmpl ABTS pending hdr status =3D %s "
>> +				  "sc  0x%p scsi_status %x  residual %d\n",
>> +				  fnic_fcpio_status_to_str(hdr_status), sc,
>> +				  icmnd_cmpl->scsi_status,
>> +				  icmnd_cmpl->residual);
>> +			break;
>> +		case FCPIO_ABORTED:
>> +			CMD_FLAGS(sc) |=3D FNIC_IO_ABORTED;
>> +			break;
>> +		default:
>> +			if (hdr_status !=3D FCPIO_SUCCESS ||
>> +				  hdr_status !=3D FCPIO_ABORTED) {
>> +				FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
>> +					  "icmnd_cmpl abts pending "
>> +					  "hdr status =3D %s tag =3D 0x%x sc =3D 0x%p\n",
>> +					  fnic_fcpio_status_to_str(hdr_status),
>> +					  id, sc);
>> +			}
>> +			break;
>> +		}
>>  		return;
>>  	}
>> =20
>> @@ -811,6 +858,7 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct
>>fnic *fnic,
>> =20
>>  	/* Break link with the SCSI command */
>>  	CMD_SP(sc) =3D NULL;
>> +	CMD_FLAGS(sc) |=3D FNIC_IO_DONE;
>> =20
>>  	spin_unlock_irqrestore(io_lock, flags);
>> =20
>> @@ -847,6 +895,7 @@ static void fnic_fcpio_itmf_cmpl_handler(struct
>>fnic *fnic,
>>  	struct fnic_io_req *io_req;
>>  	unsigned long flags;
>>  	spinlock_t *io_lock;
>> +	unsigned long start_time;
>> =20
>>  	fcpio_header_dec(&desc->hdr, &type, &hdr_status, &tag);
>>  	fcpio_tag_id_dec(&tag, &id);
>> @@ -860,17 +909,26 @@ static void fnic_fcpio_itmf_cmpl_handler(struc=
t
>>fnic *fnic,
>> =20
>>  	sc =3D scsi_host_find_tag(fnic->lport->host, id & FNIC_TAG_MASK);
>>  	WARN_ON_ONCE(!sc);
>> -	if (!sc)
>> +	if (!sc) {
>> +		shost_printk(KERN_ERR, fnic->lport->host,
>> +			  "itmf_cmpl sc is null - hdr status =3D %s tag =3D 0x%x\n",
>> +			  fnic_fcpio_status_to_str(hdr_status), id);
>>  		return;
>> -
>> +	}
>>  	io_lock =3D fnic_io_lock_hash(fnic, sc);
>>  	spin_lock_irqsave(io_lock, flags);
>>  	io_req =3D (struct fnic_io_req *)CMD_SP(sc);
>>  	WARN_ON_ONCE(!io_req);
>>  	if (!io_req) {
>>  		spin_unlock_irqrestore(io_lock, flags);
>> +		CMD_FLAGS(sc) |=3D FNIC_IO_ABT_TERM_REQ_NULL;
>> +		shost_printk(KERN_ERR, fnic->lport->host,
>> +			  "itmf_cmpl io_req is null - "
>> +			  "hdr status =3D %s tag =3D 0x%x sc 0x%p\n",
>> +			  fnic_fcpio_status_to_str(hdr_status), id, sc);
>>  		return;
>>  	}
>> +	start_time =3D io_req->start_time;
>> =20
>>  	if ((id & FNIC_TAG_ABORT) && (id & FNIC_TAG_DEV_RST)) {
>>  		/* Abort and terminate completion of device reset req */
>> @@ -894,6 +952,7 @@ static void fnic_fcpio_itmf_cmpl_handler(struct
>>fnic *fnic,
>>  		CMD_STATE(sc) =3D FNIC_IOREQ_ABTS_COMPLETE;
>>  		CMD_ABTS_STATUS(sc) =3D hdr_status;
>> =20
>> +		CMD_FLAGS(sc) |=3D FNIC_IO_ABT_TERM_DONE;
>>  		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
>>  			      "abts cmpl recd. id %d status %s\n",
>>  			      (int)(id & FNIC_TAG_MASK),
>> @@ -926,6 +985,7 @@ static void fnic_fcpio_itmf_cmpl_handler(struct
>>fnic *fnic,
>>  		CMD_LR_STATUS(sc) =3D hdr_status;
>>  		if (CMD_STATE(sc) =3D=3D FNIC_IOREQ_ABTS_PENDING) {
>>  			spin_unlock_irqrestore(io_lock, flags);
>> +			CMD_FLAGS(sc) |=3D FNIC_DEV_RST_ABTS_PENDING;
>>  			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
>>  				"Terminate pending "
>>  				"dev reset cmpl recd. id %d status %s\n",
>> @@ -1031,6 +1091,7 @@ static void fnic_cleanup_io(struct fnic *fnic,
>>int exclude_id)
>>  	unsigned long flags =3D 0;
>>  	struct scsi_cmnd *sc;
>>  	spinlock_t *io_lock;
>> +	unsigned long start_time =3D 0;
>> =20
>>  	for (i =3D 0; i < FNIC_MAX_IO_REQ; i++) {
>>  		if (i =3D=3D exclude_id)
>> @@ -1073,6 +1134,7 @@ static void fnic_cleanup_io(struct fnic *fnic,
>>int exclude_id)
>>  		 * If there is a scsi_cmnd associated with this io_req, then
>>  		 * free the corresponding state
>>  		 */
>> +		start_time =3D io_req->start_time;
>>  		fnic_release_ioreq_buf(fnic, io_req, sc);
>>  		mempool_free(io_req, fnic->io_req_pool);
>> =20
>> @@ -1096,6 +1158,7 @@ void fnic_wq_copy_cleanup_handler(struct
>>vnic_wq_copy *wq,
>>  	struct scsi_cmnd *sc;
>>  	unsigned long flags;
>>  	spinlock_t *io_lock;
>> +	unsigned long start_time =3D 0;
>> =20
>>  	/* get the tag reference */
>>  	fcpio_tag_id_dec(&desc->hdr.tag, &id);
>> @@ -1125,6 +1188,7 @@ void fnic_wq_copy_cleanup_handler(struct
>>vnic_wq_copy *wq,
>> =20
>>  	spin_unlock_irqrestore(io_lock, flags);
>> =20
>> +	start_time =3D io_req->start_time;
>>  	fnic_release_ioreq_buf(fnic, io_req, sc);
>>  	mempool_free(io_req, fnic->io_req_pool);
>> =20
>> @@ -1162,7 +1226,7 @@ static inline int fnic_queue_abort_io_req(stru=
ct
>>fnic *fnic, int tag,
>>  	if (!vnic_wq_copy_desc_avail(wq)) {
>>  		spin_unlock_irqrestore(&fnic->wq_copy_lock[0], flags);
>>  		atomic_dec(&fnic->in_flight);
>> -		shost_printk(KERN_DEBUG, fnic->lport->host,
>> +		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
>>  			"fnic_queue_abort_io_req: failure: no descriptors\n");
>>  		return 1;
>>  	}
>> @@ -1212,7 +1276,7 @@ void fnic_rport_exch_reset(struct fnic *fnic, =
u32
>>port_id)
>>  		}
>> =20
>>  		if ((CMD_FLAGS(sc) & FNIC_DEVICE_RESET) &&
>> -			(!(CMD_FLAGS(sc) & FNIC_DEV_RST_PENDING))) {
>> +			(!(CMD_FLAGS(sc) & FNIC_DEV_RST_ISSUED))) {
>>  			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
>>  			"fnic_rport_exch_reset dev rst not pending sc 0x%p\n",
>>  			sc);
>> @@ -1239,6 +1303,13 @@ void fnic_rport_exch_reset(struct fnic *fnic,
>>u32 port_id)
>>  			"fnic_rport_exch_reset: sc->device is null state is "
>>  			"%s\n", fnic_ioreq_state_to_str(CMD_STATE(sc)));
>> =20
>> +		if (!(CMD_FLAGS(sc) & FNIC_IO_ISSUED)) {
>> +			shost_printk(KERN_ERR, fnic->lport->host,
>> +				  "rport_exch_reset "
>> +				  "IO not yet issued %p tag 0x%x flags "
>> +				  "%x state %d\n",
>> +				  sc, tag, CMD_FLAGS(sc), CMD_STATE(sc));
>> +		}
>>  		old_ioreq_state =3D CMD_STATE(sc);
>>  		CMD_STATE(sc) =3D FNIC_IOREQ_ABTS_PENDING;
>>  		CMD_ABTS_STATUS(sc) =3D FCPIO_INVALID_CODE;
>> @@ -1276,6 +1347,8 @@ void fnic_rport_exch_reset(struct fnic *fnic, =
u32
>>port_id)
>>  			spin_lock_irqsave(io_lock, flags);
>>  			if (CMD_FLAGS(sc) & FNIC_DEVICE_RESET)
>>  				CMD_FLAGS(sc) |=3D FNIC_DEV_RST_TERM_ISSUED;
>> +			else
>> +				CMD_FLAGS(sc) |=3D FNIC_IO_INTERNAL_TERM_ISSUED;
>>  			spin_unlock_irqrestore(io_lock, flags);
>>  		}
>>  	}
>> @@ -1338,7 +1411,7 @@ void fnic_terminate_rport_io(struct fc_rport
>>*rport)
>>  		}
>> =20
>>  		if ((CMD_FLAGS(sc) & FNIC_DEVICE_RESET) &&
>> -			(!(CMD_FLAGS(sc) & FNIC_DEV_RST_PENDING))) {
>> +			(!(CMD_FLAGS(sc) & FNIC_DEV_RST_ISSUED))) {
>>  			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
>>  			"fnic_terminate_rport_io dev rst not pending sc 0x%p\n",
>>  			sc);
>> @@ -1359,6 +1432,13 @@ void fnic_terminate_rport_io(struct fc_rport
>>*rport)
>>  			"state is %s\n",
>>  			fnic_ioreq_state_to_str(CMD_STATE(sc)));
>>  		}
>> +		if (!(CMD_FLAGS(sc) & FNIC_IO_ISSUED)) {
>> +			FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
>> +				  "fnic_terminate_rport_io "
>> +				  "IO not yet issued %p tag 0x%x flags "
>> +				  "%x state %d\n",
>> +				  sc, tag, CMD_FLAGS(sc), CMD_STATE(sc));
>> +		}
>>  		old_ioreq_state =3D CMD_STATE(sc);
>>  		CMD_STATE(sc) =3D FNIC_IOREQ_ABTS_PENDING;
>>  		CMD_ABTS_STATUS(sc) =3D FCPIO_INVALID_CODE;
>> @@ -1396,6 +1476,8 @@ void fnic_terminate_rport_io(struct fc_rport
>>*rport)
>>  			spin_lock_irqsave(io_lock, flags);
>>  			if (CMD_FLAGS(sc) & FNIC_DEVICE_RESET)
>>  				CMD_FLAGS(sc) |=3D FNIC_DEV_RST_TERM_ISSUED;
>> +			else
>> +				CMD_FLAGS(sc) |=3D FNIC_IO_INTERNAL_TERM_ISSUED;
>>  			spin_unlock_irqrestore(io_lock, flags);
>>  		}
>>  	}
>> @@ -1415,8 +1497,9 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
>>  	struct fc_rport *rport;
>>  	spinlock_t *io_lock;
>>  	unsigned long flags;
>> +	unsigned long start_time =3D 0;
>>  	int ret =3D SUCCESS;
>> -	u32 task_req;
>> +	u32 task_req =3D 0;
>>  	struct scsi_lun fc_lun;
>>  	int tag;
>>  	DECLARE_COMPLETION_ONSTACK(tm_done);
>> @@ -1503,6 +1586,10 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
>>  		ret =3D FAILED;
>>  		goto fnic_abort_cmd_end;
>>  	}
>> +	if (task_req =3D=3D FCPIO_ITMF_ABT_TASK)
>> +		CMD_FLAGS(sc) |=3D FNIC_IO_ABTS_ISSUED;
>> +	else
>> +		CMD_FLAGS(sc) |=3D FNIC_IO_TERM_ISSUED;
>> =20
>>  	/*
>>  	 * We queued an abort IO, wait for its completion.
>> @@ -1521,6 +1608,7 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
>>  	io_req =3D (struct fnic_io_req *)CMD_SP(sc);
>>  	if (!io_req) {
>>  		spin_unlock_irqrestore(io_lock, flags);
>> +		CMD_FLAGS(sc) |=3D FNIC_IO_ABT_TERM_REQ_NULL;
>>  		ret =3D FAILED;
>>  		goto fnic_abort_cmd_end;
>>  	}
>> @@ -1529,6 +1617,7 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
>>  	/* fw did not complete abort, timed out */
>>  	if (CMD_STATE(sc) =3D=3D FNIC_IOREQ_ABTS_PENDING) {
>>  		spin_unlock_irqrestore(io_lock, flags);
>> +		CMD_FLAGS(sc) |=3D FNIC_IO_ABT_TERM_TIMED_OUT;
>>  		ret =3D FAILED;
>>  		goto fnic_abort_cmd_end;
>>  	}
>> @@ -1544,12 +1633,13 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
>> =20
>>  	spin_unlock_irqrestore(io_lock, flags);
>> =20
>> +	start_time =3D io_req->start_time;
>>  	fnic_release_ioreq_buf(fnic, io_req, sc);
>>  	mempool_free(io_req, fnic->io_req_pool);
>> =20
>>  fnic_abort_cmd_end:
>>  	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
>> -		      "Returning from abort cmd %s\n",
>> +		      "Returning from abort cmd type %x %s\n", task_req,
>>  		      (ret =3D=3D SUCCESS) ?
>>  		      "SUCCESS" : "FAILED");
>>  	return ret;
>> @@ -1580,6 +1670,8 @@ static inline int fnic_queue_dr_io_req(struct
>>fnic *fnic,
>>  		free_wq_copy_descs(fnic, wq);
>> =20
>>  	if (!vnic_wq_copy_desc_avail(wq)) {
>> +		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
>> +			  "queue_dr_io_req failure - no descriptors\n");
>>  		ret =3D -EAGAIN;
>>  		goto lr_io_req_end;
>>  	}
>> @@ -1651,7 +1743,7 @@ static int fnic_clean_pending_aborts(struct fn=
ic
>>*fnic,
>>  			continue;
>>  		}
>>  		if ((CMD_FLAGS(sc) & FNIC_DEVICE_RESET) &&
>> -			(!(CMD_FLAGS(sc) & FNIC_DEV_RST_PENDING))) {
>> +			(!(CMD_FLAGS(sc) & FNIC_DEV_RST_ISSUED))) {
>>  			FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
>>  				"%s dev rst not pending sc 0x%p\n", __func__,
>>  				sc);
>> @@ -1707,6 +1799,7 @@ static int fnic_clean_pending_aborts(struct fn=
ic
>>*fnic,
>>  				CMD_FLAGS(sc) |=3D FNIC_DEV_RST_TERM_ISSUED;
>>  			spin_unlock_irqrestore(io_lock, flags);
>>  		}
>> +		CMD_FLAGS(sc) |=3D FNIC_IO_INTERNAL_TERM_ISSUED;
>> =20
>>  		wait_for_completion_timeout(&tm_done,
>>  					    msecs_to_jiffies
>> @@ -1717,6 +1810,7 @@ static int fnic_clean_pending_aborts(struct fn=
ic
>>*fnic,
>>  		io_req =3D (struct fnic_io_req *)CMD_SP(sc);
>>  		if (!io_req) {
>>  			spin_unlock_irqrestore(io_lock, flags);
>> +			CMD_FLAGS(sc) |=3D FNIC_IO_ABT_TERM_REQ_NULL;
>>  			continue;
>>  		}
>> =20
>> @@ -1725,6 +1819,7 @@ static int fnic_clean_pending_aborts(struct fn=
ic
>>*fnic,
>>  		/* if abort is still pending with fw, fail */
>>  		if (CMD_STATE(sc) =3D=3D FNIC_IOREQ_ABTS_PENDING) {
>>  			spin_unlock_irqrestore(io_lock, flags);
>> +			CMD_FLAGS(sc) |=3D FNIC_IO_ABT_TERM_DONE;
>>  			ret =3D 1;
>>  			goto clean_pending_aborts_end;
>>  		}
>> @@ -1819,6 +1914,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
>>  	int ret =3D FAILED;
>>  	spinlock_t *io_lock;
>>  	unsigned long flags;
>> +	unsigned long start_time =3D 0;
>>  	struct scsi_lun fc_lun;
>>  	int tag;
>>  	DECLARE_COMPLETION_ONSTACK(tm_done);
>> @@ -1844,7 +1940,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
>>  	if (fc_remote_port_chkready(rport))
>>  		goto fnic_device_reset_end;
>> =20
>> -	CMD_FLAGS(sc) =3D (FNIC_DEVICE_RESET | FNIC_BLOCKING_REQ);
>> +	CMD_FLAGS(sc) =3D FNIC_DEVICE_RESET;
>>  	/* Allocate tag if not present */
>> =20
>>  	tag =3D sc->request->tag;
>> @@ -1891,7 +1987,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
>>  		goto fnic_device_reset_clean;
>>  	}
>>  	spin_lock_irqsave(io_lock, flags);
>> -	CMD_FLAGS(sc) |=3D FNIC_DEV_RST_PENDING;
>> +	CMD_FLAGS(sc) |=3D FNIC_DEV_RST_ISSUED;
>>  	spin_unlock_irqrestore(io_lock, flags);
>> =20
>>  	/*
>> @@ -2009,6 +2105,7 @@ fnic_device_reset_clean:
>>  	spin_unlock_irqrestore(io_lock, flags);
>> =20
>>  	if (io_req) {
>> +		start_time =3D io_req->start_time;
>>  		fnic_release_ioreq_buf(fnic, io_req, sc);
>>  		mempool_free(io_req, fnic->io_req_pool);
>>  	}
>
>

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
