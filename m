From: "Narsimhulu Musini (nmusini)" <nmusini@cisco.com>
Subject: Re: [PATCH v4 4/9] snic:Add snic target discovery
Date: Tue, 14 Apr 2015 10:15:31 +0000
Message-ID: <D152E343.209D2%nmusini@cisco.com>
References: <1428580189-22785-1-git-send-email-nmusini@cisco.com>
 <1428580189-22785-5-git-send-email-nmusini@cisco.com>
 <552677A6.3030602@suse.de> <D1514FCB.207B3%nmusini@cisco.com>
 <552BD2C3.8010103@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcdn-iport-4.cisco.com ([173.37.86.75]:15689 "EHLO
	rcdn-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434AbbDNKPc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Apr 2015 06:15:32 -0400
In-Reply-To: <552BD2C3.8010103@suse.de>
Content-Language: en-US
Content-ID: <5B5E417244AB754793B8CCD2F4E348ED@emea.cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>
Cc: "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>

Hi Hannes,
    Thank you for reviewing patches. Please find responses inline.

On 13/04/15 7:59 pm, "Hannes Reinecke" <hare@suse.de> wrote:

>On 04/13/2015 07:25 AM, Narsimhulu Musini (nmusini) wrote:
>> Hi Hannes,
>>=20
>>   Thank you for reviewing patches. Please find responses inline.
>>=20
>>=20
>>=20
>> On 09/04/15 6:29 pm, "Hannes Reinecke" <hare@suse.de> wrote:
>>=20
>>>
>>> On 04/09/2015 01:49 PM, Narsimhulu Musini wrote:
>[ .. ]
>>>> +/* snic_tgt_create: checks for existence of snic_tgt, if it doesn=
't
>>>> + * it creates one.
>>>> + */
>>>> +static struct snic_tgt *
>>>> +snic_tgt_create(struct snic *snic, struct snic_tgt_id *tgtid)
>>>> +{
>>>> +	struct snic_tgt *tgt =3D NULL;
>>>> +	unsigned long flags;
>>>> +	int ret;
>>>> +
>>>> +	tgt =3D snic_tgt_lookup(snic, tgtid);
>>>> +	if (tgt) {
>>>> +		/* update the information if required */
>>>> +		return tgt;
>>>> +	}
>>>> +
>>>> +	tgt =3D kzalloc(sizeof(*tgt), GFP_KERNEL);
>>>> +	if (!tgt) {
>>>> +		SNIC_HOST_ERR(snic->shost, "Failure to allocate snic_tgt.\n");
>>>> +		ret =3D -ENOMEM;
>>>> +
>>>> +		return tgt;
>>>> +	}
>>>> +
>>>> +	INIT_LIST_HEAD(&tgt->list);
>>>> +	tgt->id =3D tgtid->tgt_id;
>>>> +	tgt->channel =3D 0;
>>>> +
>>>> +	SNIC_BUG_ON(tgtid->tgt_type > SNIC_TGT_SAN);
>>>> +	tgt->tdata.typ =3D tgtid->tgt_type;
>>>> +
>>>> +	/*
>>>> +	 * Plugging into SML Device Tree
>>>> +	 */
>>>> +	tgt->tdata.disc_id =3D 0;
>>>> +	tgt->state =3D SNIC_TGT_STAT_INIT;
>>>> +	device_initialize(&tgt->dev);
>>>> +	tgt->dev.parent =3D get_device(&snic->shost->shost_gendev);
>>>> +	tgt->dev.release =3D snic_tgt_dev_release;
>>> Why do you use your own scsi target instantiation here?
>>> If it's equivalent to the scsi target than you should rather use th=
e
>>> 'scsi_target' structure here and attach driver-specific information
>>> to either hostdata or starget_data.
>> I got your idea, we followed an approach similar to fc
>>(fc_rport_create()
>> in scsi_transport_fc.c).
>> Both are valid approaches. We opted for current approach, and gone
>>through
>> good amount of testing.
>> I would like to keep the way it is. Please share your thoughts.
>
>scsi_transport_fc() creates its own sysfs hierarchy for the remote
>port, which is inserted between scsi_host and scsi_target:
>
>/sys/devices/pci0000:00/0000:00:03.0/0000:07:00.3/host2/rport-2:0-13/t=
arge
>t2:0:11/2:0:11:7
>
>here, the fc_rport structure corresponds to the FC sysfs hierarchy,
>containing all FC-related sysfs attributes. And as such makes sense
>have a distinct object.
>
>In your case no such hiearchy exists, and there are no additional
>sysfs attributes which would warrant the creation of a distinct object=
=2E
We will add sysfs attributes for targets in future patches. And about
hierarchy, The current approach provides the option, which we would lik=
e
to avail in future.
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
simha
>

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
