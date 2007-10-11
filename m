From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Add ALUA hardware handler
Date: Thu, 11 Oct 2007 10:31:43 +0200
Message-ID: <470DDF6F.5090909@suse.de>
References: <470CCBB0.2020904@suse.de> <470D1DAE.1000900@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:41318 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756510AbXJKIbp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Oct 2007 04:31:45 -0400
In-Reply-To: <470D1DAE.1000900@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Alasdair G Kergon <agk@redhat.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, christophe varoqui <christophe.varoqui@free.fr>

Mike Christie wrote:
> Hannes Reinecke wrote:
>> Hi Alasdair,
>>
>> this is a patch to add a SPC-3 hardware handler. SPC-3 ALUA has
>> provisioning for 'explicit' port group state change via the
>> SET TARGET GROUP STATES command, and some newer storage
>> arrays do benefit from this.
>> Eg HP EVAs and newer EMC Clariions already support explicit ALUA.
>>
>> Please apply.
>>
>> Cheers,
>>
>> Hannes
>>
>=20
> Does this also work for adaptec or snap iscsi targets or whatever the=
y
> are called targets?
>=20
Don't know, I don't have one. Care to try?

>=20
>=20
> Just some quick higher level comments
>=20
> +static int submit_std_inquiry(struct alua_handler *h)
> +{
> +    struct request *rq;
> +    unsigned err =3D (DRIVER_ERROR << 24);
> +
> +    rq =3D prepare_req(h, h->inq, TPGS_INQUIRY_SIZE, READ);
>=20
>=20
> I do not think you want to use GFP_KERNEL allocations in this path, s=
o
> all the prepare_req allocs should be changed. GFP_NOIO is probably be=
st.
>=20
Yes, probably.

>=20
> +    if (!rq)
> +        return err;
> +
> +    /* Prepare the command. */
> +    rq->cmd[0] =3D INQUIRY;
> +    rq->cmd[1] =3D 0;
> +    rq->cmd[2] =3D 0;
> +    rq->cmd[4] =3D TPGS_INQUIRY_SIZE;
> +    rq->cmd_len =3D COMMAND_SIZE(INQUIRY);
> +
> +    blk_execute_rq(rq->q, NULL, rq, 1);
>=20
> There is only one workqueue for all the dm devices, so you do not wan=
t
> to do one command (or how many processors there are) at a time and wa=
it
> for each one to complete with blk_execute_rq. You should use the asyn=
c
> one, blk_execute_rq_nowait, like rdac.
>=20
This is actually by design. Problem here is the port group as returned =
by
REPORT TARGET PORT GROUPS does not have any association to the controll=
er
which handles these ports.
So if we were to send all REPORT TARGET PORT GROUPS commands (roughly)
simultaneously we're pretty much guaranteed to hit the same controller
several times; and if we have to do a SET TARGET PORT GROUPS in additio=
n
we'll be having to do loads of retries as the controller might be busy
(if he's transitioning) or reporting an UNIT ATTENTION if the port
group states have been updated. So I'd rather keep it that way so as
to not flood the controller. And then we're only having to send two
commands, so this should okay even sequentially.

And incidentally, rdac implements it's own workqueue per controller
as it's only capable to handle one MODE SELECT command at time.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
