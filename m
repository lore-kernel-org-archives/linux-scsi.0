From: Laurent Riffard <laurent.riffard@free.fr>
Subject: Re: [Bugme-new] [Bug 7667] New: BUG at drivers/scsi/scsi_lib.c:1118
 caused by "pktsetup dvd /dev/sr0"
Date: Tue, 12 Dec 2006 23:37:11 +0100
Message-ID: <457F2F17.3000009@free.fr>
References: <200612112159.kBBLxmep005850@fire-2.osdl.org> <20061211141029.9a0b0376.akpm@osdl.org> <20061212103842.GA9619@lst.de> <20061212132600.GA19912@lst.de> <457EBAE3.6090609@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp12.orange.fr ([193.252.22.20]:9069 "EHLO smtp12.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932515AbWLLWhM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Dec 2006 17:37:12 -0500
In-Reply-To: <457EBAE3.6090609@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@osdl.org>, Peter Osterlund <petero2@telia.com>, linux-scsi@vger.kernel.org, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>, Adrian Bunk <bunk@stusta.de>

Le 12.12.2006 15:21, Boaz Harrosh a =C3=A9crit :
> Christoph Hellwig wrote:
>> On Tue, Dec 12, 2006 at 11:38:42AM +0100, Christoph Hellwig wrote:
>>> This is because the packet driver tries to send down read/write
>>> BLOCK_PC commands that don't use a bio and do not use sg lists.
>>> As part of the patch you mentioned I added strict assertations for =
that
>>> case because the scsi layer doesn't handle those anymore.
>>>
>>> The right fix is to replace all the packet_command stuff in the pac=
ket
>>> driver by scsi_execute() which needs to be lifted from scsi code to
>>> the block code for that.  I'll prepare a patch this weekend unless
>>> someone beets me in doing that work.
>> Please try the patch below to fix the bug for now.  It's not the
>> full way to a generic execute block pc infrastcuture but should fix
>> the bug for the time beeing:
>>
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>>
>> Index: linux-2.6/drivers/block/pktcdvd.c
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> --- linux-2.6.orig/drivers/block/pktcdvd.c	2006-12-12 11:30:45.00000=
0000 +0100
>> +++ linux-2.6/drivers/block/pktcdvd.c	2006-12-12 14:23:37.000000000 =
+0100
>> @@ -765,47 +765,34 @@
>>   */
>>  static int pkt_generic_packet(struct pktcdvd_device *pd, struct pac=
ket_command *cgc)
>>  {
>> -	char sense[SCSI_SENSE_BUFFERSIZE];
>> -	request_queue_t *q;
>> +	request_queue_t *q =3D bdev_get_queue(pd->bdev);
>>  	struct request *rq;
>> -	DECLARE_COMPLETION_ONSTACK(wait);
>> -	int err =3D 0;
>> +	int ret =3D 0;
>> =20
>> -	q =3D bdev_get_queue(pd->bdev);
>> +	rq =3D blk_get_request(q, (cgc->data_direction =3D=3D CGC_DATA_WRI=
TE) ?
>> +			     WRITE : READ, __GFP_WAIT);
>> +
>> +	if (cgc->buflen) {
>> +		if (blk_rq_map_kern(q, rq, cgc->buffer, cgc->buflen, __GFP_WAIT))
>> +			goto out;
>> +	}
>> +
>> +	rq->cmd_len =3D COMMAND_SIZE(rq->cmd[0]);
>> +	memcpy(rq->cmd, cgc->cmd, CDROM_PACKET_SIZE);
>> +	if (sizeof(rq->cmd) > CDROM_PACKET_SIZE)
>> +		memset(rq->cmd + CDROM_PACKET_SIZE, 0, sizeof(rq->cmd) - CDROM_PA=
CKET_SIZE);
>> =20
>> -	rq =3D blk_get_request(q, (cgc->data_direction =3D=3D CGC_DATA_WRI=
TE) ? WRITE : READ,
>> -			     __GFP_WAIT);
>> -	rq->errors =3D 0;
>> -	rq->rq_disk =3D pd->bdev->bd_disk;
>> -	rq->bio =3D NULL;
>> -	rq->buffer =3D NULL;
>>  	rq->timeout =3D 60*HZ;
>> -	rq->data =3D cgc->buffer;
>> -	rq->data_len =3D cgc->buflen;
>> -	rq->sense =3D sense;
>> -	memset(sense, 0, sizeof(sense));
>> -	rq->sense_len =3D 0;
>>  	rq->cmd_type =3D REQ_TYPE_BLOCK_PC;
>>  	rq->cmd_flags |=3D REQ_HARDBARRIER;
>>  	if (cgc->quiet)
>>  		rq->cmd_flags |=3D REQ_QUIET;
>> -	memcpy(rq->cmd, cgc->cmd, CDROM_PACKET_SIZE);
>> -	if (sizeof(rq->cmd) > CDROM_PACKET_SIZE)
>> -		memset(rq->cmd + CDROM_PACKET_SIZE, 0, sizeof(rq->cmd) - CDROM_PA=
CKET_SIZE);
>> -	rq->cmd_len =3D COMMAND_SIZE(rq->cmd[0]);
>> -
>> -	rq->ref_count++;
>> -	rq->end_io_data =3D &wait;
>> -	rq->end_io =3D blk_end_sync_rq;
>> -	elv_add_request(q, rq, ELEVATOR_INSERT_BACK, 1);
>> -	generic_unplug_device(q);
>> -	wait_for_completion(&wait);
>> -
>> -	if (rq->errors)
>> -		err =3D -EIO;
>> =20
>> +	blk_execute_rq(rq->q, pd->bdev->bd_disk, rq, 0);
>> +	ret =3D rq->errors;
>> +out:
>>  	blk_put_request(rq);
>> -	return err;
>> +	return ret;
>>  }
>> =20
>>  /*
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> I'm afraid this might not be enough because of code in drivers/ide/id=
e-cd.c. It does IO off of request->data.
>=20
> [background]
> pkt_generic_packet and ton of other places mainly cd(s), floppy(s), a=
nd other ide code paths,
> are using what I call BLACK requests. They put some data on request->=
buffer or request->data
> stick it in the Q and than advance on them later down the ladder. Rem=
ove of "buffer" and "data" from
> struct request will reveal all these places. At one time I had plans =
to do just that. But 1/2 way through I gave
> up, it is too risky, too much Hardware that I don't have, that needs =
checking.
>=20
> below patch combined with your patch might get a bit closer for this =
code path.
> At struct request I have changed the name of "data" member to "user_d=
ata". than changed the code paths that used
> "data" as IO to use request->buffer instead. This is just as bad but =
is a more common practice.
>=20
> I suspect there is a problem with what I did in scsi_lib.c Christoph =
please check me out with the new BUG_ON.
> Mainly what you need from below is only the code in ide-cd.c.
> (And there are 3-4 places that do exactly like pkt_generic_packet, th=
ough I'm not sure they end up through SCSI.
> At first I thought this code doesn't either)
>=20
[patch snipped]

Christoph's patch fixed the BUG, while Boaz's patch didn't fix anything=
=20
(both tested with kernel 2.6.16-rc6-mm2).=20

Please note I don't use ide-cd, I use libata+pata_via+sr_mod.

Boaz, when you wrote "below patch combined with your patch...", did you=
 mean=20
your patch should be applied on top of Christoph's one ? In this case, =
it fails with:
   patching file drivers/block/pktcdvd.c
   Hunk #1 FAILED at 778.
   1 out of 1 hunk FAILED -- rejects in file drivers/block/pktcdvd.c

--=20
laurent
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
