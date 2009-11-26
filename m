From: Hannes Reinecke <hare@suse.de>
Subject: Re: [dm-devel] [PATCH] multipath: Evaluate request result and sense
 code
Date: Thu, 26 Nov 2009 08:54:53 +0100
Message-ID: <4B0E344D.8000004@suse.de>
References: <20091119122503.413AD3A174@ochil.suse.de> <4B09A661.10102@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47070 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759185AbZKZHys (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Nov 2009 02:54:48 -0500
In-Reply-To: <4B09A661.10102@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: device-mapper development <dm-devel@redhat.com>, James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

Mike Christie wrote:
> Hannes Reinecke wrote:
>>  /*
>> + * Evaluate scsi return code
>> + */
>> +static int eval_scsi_error(int result, char *sense, int sense_len)
>> +{
>> +    struct scsi_sense_hdr sshdr;
>> +    int r =3D DM_ENDIO_REQUEUE;
>> +
>> +    if (host_byte(result) !=3D DID_OK)
>=20
>=20
> For values like DID_NO_CONNECT or DID_TRANSPORT FAILFAST, I think it
> makes sense to fail the path. Not in this patch, but a new one, would=
 we
> want to modify dm-mpath so that we do not fail the path for errors li=
ke
> DID_ABORT or DID_SOFT_ERROR, DID_RESET or DID_ERROR?
Yeah, well, this patch was made to model the existing behaviour closely
so as the patch submission was not blocked by irrelevant side discussio=
ns ...

But yes, of course we should be a bit more selective on how to respond
to the various error codes. But this requires some more discussion with
the various vendors as things like 'DID_ERROR' have different meanings
for different HBAs ...

But this should be done once we agreed on the principle, ie on _how_
to pass the error codes up the the multipathing layer.

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
