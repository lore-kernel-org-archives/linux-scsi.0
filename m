From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 6/9] scsi_dh: add generic SPC-3 alua handler
Date: Fri, 27 Jun 2008 16:33:21 +0200
Message-ID: <4864FA31.9020401@suse.de>
References: <20080624100504.7D8C210B5DE@craiglockhart-ipmi.suse.de> <486424BA.8040301@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:46924 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754502AbYF0OdX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2008 10:33:23 -0400
In-Reply-To: <486424BA.8040301@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

Mike Christie wrote:
> Hannes Reinecke wrote:
>> +
>> +static struct request *get_alua_req(struct scsi_device *sdev,
>> +                    void *buffer, unsigned buflen, int rw)
>> +{
>> +    struct request *rq;
>> +    struct request_queue *q =3D sdev->request_queue;
>> +
>> +    rq =3D blk_get_request(q, rw, GFP_KERNEL);
>> +
>> +    if (!rq) {
>> +        sdev_printk(KERN_INFO, sdev,
>> +                "%s: blk_get_request failed\n", __FUNCTION__);
>> +        return NULL;
>> +    }
>> +
>> +    if (buflen && blk_rq_map_kern(q, rq, buffer, buflen, GFP_KERNEL=
)) {
>> +        blk_put_request(rq);
>> +        sdev_printk(KERN_INFO, sdev,
>> +                "%s: blk_rq_map_kern failed\n", __FUNCTION__);
>> +        return NULL;
>> +    }
>> +
>> +    rq->cmd_type =3D REQ_TYPE_BLOCK_PC;
>> +    rq->cmd_flags |=3D REQ_FAILFAST | REQ_NOMERGE;
>> +    rq->retries =3D ALUA_FAILOVER_RETRIES;
>> +    rq->timeout =3D ALUA_FAILOVER_TIMEOUT;
>> +
>> +    return rq;
>> +}
>=20
>=20
> It looks like this can be called from alua_activate, and we cannot us=
e=20
> GFP_KERNEL in the same IO path something could get written to.
>=20
Is something like GFP_ATOMIC more appropriate?

[ .. ]
>> +/*
>> + * alua_std_inquiry - Evaluate standard INQUIRY command
>> + * @sdev: device to be checked
>> + *
>> + * Just extract the TPGS setting to find out if ALUA
>> + * is supported.
>> + */
>> +static int alua_std_inquiry(struct scsi_device *sdev, struct=20
>> alua_dh_data *h)
>> +{
>> +    int err;
>> +
>> +    err =3D submit_std_inquiry(sdev, h);
>> +
>=20
> You could remove the space so it looks like the other code.
>=20
>=20
Sure.

[ .. ]
>> +/*
>> + * alua_bus_attach - Attach device handler
>> + * @sdev: device to be attached to
>> + */
>> +static int alua_bus_attach(struct scsi_device *sdev)
>> +{
>> +    struct scsi_dh_data *scsi_dh_data;
>> +    struct alua_dh_data *h;
>> +    unsigned long flags;
>> +    int err =3D SCSI_DH_OK;
>> +
>> +    scsi_dh_data =3D kzalloc(sizeof(struct scsi_device_handler *)
>> +                   + sizeof(*h) , GFP_KERNEL);
>> +    if (!scsi_dh_data) {
>> +        sdev_printk(KERN_ERR, sdev, "%s: Attach failed\n",
>> +                ALUA_DH_NAME);
>> +        return -ENOMEM;
>> +    }
>> +
>> +    scsi_dh_data->scsi_dh =3D &alua_dh;
>> +    h =3D (struct alua_dh_data *) scsi_dh_data->buf;
>> +    h->tpgs =3D TPGS_MODE_UNINITIALIZED;
>> +    h->state =3D TPGS_STATE_OPTIMIZED;
>> +    h->group_id =3D -1;
>> +    h->rel_port =3D -1;
>> +    h->buff =3D h->inq;
>> +    h->bufflen =3D ALUA_INQUIRY_SIZE;
>> +
>> +    err =3D alua_initialize(sdev, h);
>> +    if (err !=3D SCSI_DH_OK)
>> +        goto failed;
>> +
>> +    spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
>> +    sdev->scsi_dh_data =3D scsi_dh_data;
>> +    spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
>> +
>> +    try_module_get(THIS_MODULE);
>=20
>=20
> Do we need to handle the case where this fails?

I cannot see how this _could_ fail, as this function is provided by
the module, so the very existence of the function depends on the
module. But maybe it's better to check, even so.

I'll send an updated patch.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
