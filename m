From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 27/36] scsi_dh_alua: Use workqueue for RTPG
Date: Fri, 02 Oct 2015 07:59:11 +0200
Message-ID: <560E1D2F.9050808@suse.de>
References: <1443523658-87622-1-git-send-email-hare@suse.de> <1443523658-87622-28-git-send-email-hare@suse.de> <560DC309.90100@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33931 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbbJBF7O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Oct 2015 01:59:14 -0400
In-Reply-To: <560DC309.90100@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 10/02/2015 01:34 AM, Bart Van Assche wrote:
> On 09/29/2015 03:48 AM, Hannes Reinecke wrote:
>> +static void alua_rtpg_work(struct work_struct *work)
>> +{
>> +    struct alua_port_group *pg =3D
>> +        container_of(work, struct alua_port_group, rtpg_work.work);
>> +    struct scsi_device *sdev;
>> +    LIST_HEAD(qdata_list);
>> +    int err =3D SCSI_DH_OK;
>> +    struct alua_queue_data *qdata, *tmp;
>> +    unsigned long flags;
>> +
>> +    spin_lock_irqsave(&pg->lock, flags);
>> +    sdev =3D pg->rtpg_sdev;
>> +    if (!sdev) {
>> +        WARN_ON(pg->flags & ALUA_PG_RUN_RTPG ||
>> +            pg->flags & ALUA_PG_RUN_STPG);
>> +        spin_unlock_irqrestore(&pg->lock, flags);
>> +        return;
>> +    }
>> +    pg->flags |=3D ALUA_PG_RUNNING;
>> +    if (pg->flags & ALUA_PG_RUN_RTPG) {
>> +        spin_unlock_irqrestore(&pg->lock, flags);
>> +        err =3D alua_rtpg(sdev, pg);
>> +        spin_lock_irqsave(&pg->lock, flags);
>> +        if (err =3D=3D SCSI_DH_RETRY) {
>> +            pg->flags &=3D ~ALUA_PG_RUNNING;
>> +            spin_unlock_irqrestore(&pg->lock, flags);
>> +            queue_delayed_work(kaluad_wq, &pg->rtpg_work,
>> +                       pg->interval * HZ);
>> +            return;
>> +        }
>> +        pg->flags &=3D ~ALUA_PG_RUN_RTPG;
>> +        if (err !=3D SCSI_DH_OK)
>> +            pg->flags &=3D ~ALUA_PG_RUN_STPG;
>> +    }
>> +    if (pg->flags & ALUA_PG_RUN_STPG) {
>> +        spin_unlock_irqrestore(&pg->lock, flags);
>> +        err =3D alua_stpg(sdev, pg);
>> +        spin_lock_irqsave(&pg->lock, flags);
>> +        pg->flags &=3D ~ALUA_PG_RUN_STPG;
>> +        if (err =3D=3D SCSI_DH_RETRY) {
>> +            pg->flags |=3D ALUA_PG_RUN_RTPG;
>> +            pg->interval =3D 0;
>> +            pg->flags &=3D ~ALUA_PG_RUNNING;
>> +            spin_unlock_irqrestore(&pg->lock, flags);
>> +            queue_delayed_work(kaluad_wq, &pg->rtpg_work,
>> +                       pg->interval * HZ);
>> +            return;
>> +        }
>> +    }
>> +
>> +    list_splice_init(&pg->rtpg_list, &qdata_list);
>> +    pg->rtpg_sdev =3D NULL;
>> +    spin_unlock_irqrestore(&pg->lock, flags);
>> +
>> +    list_for_each_entry_safe(qdata, tmp, &qdata_list, entry) {
>> +        list_del(&qdata->entry);
>> +        if (qdata->callback_fn)
>> +            qdata->callback_fn(qdata->callback_data, err);
>> +        kfree(qdata);
>> +    }
>> +    spin_lock_irqsave(&pg->lock, flags);
>> +    pg->flags &=3D ~ALUA_PG_RUNNING;
>> +    spin_unlock_irqrestore(&pg->lock, flags);
>> +    scsi_device_put(sdev);
>> +    kref_put(&pg->kref, release_port_group);
>> +}
>=20
> With this patch series applied kmemleak reports several leaks that
> were not reported without this patch. Is scsi_device_put() +
> kref_put() always called before this function returns without
> requeueing the work item ? Shouldn't the return value of
> queue_delayed_work() be checked ? The leaks reported by kmemleak are:
>=20
Yes, you are right. I need to check queue_delayed_work() and issue
a scsi_device_put()/kref_put() if the item is already queued.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
