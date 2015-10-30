From: Hannes Reinecke <hare@suse.de>
Subject: Re: Blk-mq/scsi-mq Tuning
Date: Fri, 30 Oct 2015 14:38:19 +0100
Message-ID: <563372CB.9050206@suse.de>
References: <D256A425.229C0%chad.dupuis@qlogic.com> <56331FFB.9010703@suse.de>
 <alpine.OSX.2.00.1510300919390.2511@administrators-macbook-pro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35819 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758943AbbJ3NiW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Oct 2015 09:38:22 -0400
In-Reply-To: <alpine.OSX.2.00.1510300919390.2511@administrators-macbook-pro.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: "bvanassche@acm.org" <bvanassche@acm.org>, "hch@lst.de" <hch@lst.de>, linux-scsi <linux-scsi@vger.kernel.org>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Nilesh Javali <nilesh.javali@qlogic.com>

On 10/30/2015 02:25 PM, Chad Dupuis wrote:
>=20
>=20
> On Fri, 30 Oct 2015, Hannes Reinecke wrote:
>=20
>> On 10/28/2015 09:11 PM, Chad Dupuis wrote:
>>> Hi Folks,
>>>
>>> We=B9ve begun to explore blk-mq and scsi-mq and wanted to know if t=
here
>>> were
>>> any best practices in terms of block layer settings.  We=B9re looki=
ng
>>> specifically at the FCoE and iSCSI protocols.
>>>
>>> A little background on the queues in our hardware first: we have a =
per
>>> connection transmit queue and multiple, global receive queues.  The
>>> transmit queues are not pegged to a particular CPU.  The receive qu=
eues
>>> are pegged to the first N CPUs where N is the number of receive que=
ues.
>>> We set the nr_hw_queues in the scsi_host_template to N as well.
>>>
>> Weelll ... I think you'll run into issues here.
>> The whole point of the multiqueue implementation is that you can tag=
 the
>> submission _and_ completion queue to a single CPU, thereby eliminati=
ng
>> locking.
>> If you only peg the completion queue to a CPU you'll still have
>> contention on the submission queue, needing to take locks etc.
>>
>> Plus you will _inevitably_ incur cache misses, as the completion wil=
l
>> basically never occur on the same CPU which did the submissoin.
>> Hence the context needs to be bounced to the CPU holding the complet=
ion
>> queue, or you'll need to do a IPI to inform the submitting CPU.
>> But if you do that you're essentially doing single-queue submission,
>> so I doubt we're seeing that great improvements.
>=20
> This was why I was asking if there was a blk-mq API to be able to set
> CPU affinity for the hardware context queues so I could steer the
> submissions to the CPUs that my receive queues are on (even if they a=
re
> allowed to float).
>=20
But what would that achieve?
Each of the hardware context queues would still having to use the
same submission queue, so you'd have to have some serialisation
with spinlocks et.al. during submission. Which is what blk-mq
tries to avoid.
Am I wrong?

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
