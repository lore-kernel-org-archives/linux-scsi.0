From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 11/17] scsi_dh_alua: simplify sense code handling
Date: Mon, 11 May 2015 16:52:14 +0200
Message-ID: <5550C21E.1040103@suse.de>
References: <1430743343-47174-1-git-send-email-hare@suse.de> <1430743343-47174-12-git-send-email-hare@suse.de> <20150511065802.GH30516@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56282 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847AbbEKOwQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 May 2015 10:52:16 -0400
In-Reply-To: <20150511065802.GH30516@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On 05/11/2015 08:58 AM, Christoph Hellwig wrote:
> On Mon, May 04, 2015 at 02:42:17PM +0200, Hannes Reinecke wrote:
>> Most sense code is already handled in the generic
>> code, so we shouldn't be adding special cases here.
>> However, when doing so we need to check for
>> unit attention whenever we're sending an internal
>> command.
>=20
> Shouldn't we move handling of all these sense codes to common code?  =
They
> are part of the generic SPC list of sense codes, so splitting them up
> into two functions is rather confusing.
>=20
Sigh. This is one of the sore topics with the SCSI stack.

The default sense code handling is correct only for filesystem
I/O; BLOCK_PC callers are expected to handle all errors themselves.
Which typically is a pain as one always forgets the one or the
other issue.

The device handlers have a callout into that generic function
to handle and device handler specific sense codes.

So with that I do agree that calling alua_check_sense() here
is dubious as it should have been run from the generic path already.

Will be checking and fixing it up.

>> @@ -474,6 +440,8 @@ static int alua_rtpg(struct scsi_device *sdev, s=
truct alua_port_group *pg, int w
>>  		}
>> =20
>>  		err =3D alua_check_sense(sdev, &sense_hdr);
>> +		if (sense_hdr.sense_key =3D=3D UNIT_ATTENTION)
>> +			err =3D ADD_TO_MLQUEUE;
>=20
> And this really should be a separate patch.
>=20
Okay, will be doing so.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
