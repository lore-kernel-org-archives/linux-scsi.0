From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/6] libata: Do not retry commands with valid autosense
Date: Mon, 03 Aug 2015 20:21:19 +0200
Message-ID: <55BFB11F.30309@suse.de>
References: <1438347728-106434-1-git-send-email-hare@suse.de> <1438347728-106434-2-git-send-email-hare@suse.de> <20150802154415.GA31100@mtj.duckdns.org> <55BF18ED.3000002@suse.de> <20150803150428.GE32599@mtj.duckdns.org> <20150803151826.GG32599@mtj.duckdns.org> <1438616563.2173.16.camel@HansenPartnership.com> <20150803155513.GI32599@mtj.duckdns.org> <55BF9B32.6030304@suse.de> <20150803170159.GB24594@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45770 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754325AbbHCSVX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Aug 2015 14:21:23 -0400
In-Reply-To: <20150803170159.GB24594@mtj.duckdns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On 08/03/2015 07:01 PM, Tejun Heo wrote:
> Hello, Hannes.
>=20
> On Mon, Aug 03, 2015 at 06:47:46PM +0200, Hannes Reinecke wrote:
>> At the moment NCQ autosense is mostly used to provide the host with =
more
>> details for a failed I/O. The typical case here is (no small surpris=
e)
>> ZAC disks, which use autosense to inform the host about
>> a malformed I/O.
>>
>> It is _not_ being used as a replacement for existing error behaviour=
,
>> (ie link errors are not being signalled with that; how could they
>> if there is no link?); in fact, during testing I"ve seen both, autos=
ense
>=20
> Hmmm?  Devices can report link error via TF bits and you're bypassing
> TF analysis completley if sense data is present.
>=20
But sense data will never be present for a link error ... and I'm not
disabling that.

>> I/O failures and normal I/O failures for which autosense is
>> not set, and the normal error handling kicks in.
>>
>> It's not that I've disable the original error handler completely,
>> it's only bypassed for I/O failure where a sense code is provided.
>> And the drive surely knows which error occurs, so we'd be daft not b=
e
>> using that.
>=20
> The patches are altering EH actions in a very subtle way depending on
> *how* an error is reported, not *what* is reported, which is a pretty
> silly thing to do.  It makes things a lot more confusing to follow an=
d
> predict.  I really don't think this is an acceptable behavior.
>=20
But if we were judging on _what_ is being reported we would have to kno=
w
which  sense code the drive will be reporting, in effect carrying
a massive table of possible sense codes, and map this to the actions.
Do you really want to go that way?

>> So I think disabling autosense completely is a bit extreme...
>=20
> Please restructure the feature so that it doesn't interfere with the
> usual EH behavior.  e.g. leave the EH actions alone unless explicitly
> necessary but report detailed error information upwards.  If the extr=
a
> error information can be helpful in determining what EH actions to
> take, factoring in that information can be helpful too but I'm not to=
o
> convinced that'd make a huge difference.
>=20
It does if we can avoid the retry on the libata layer.

> Also, please consider that ATA_QCFLAG_SENSE_VALID handling assumes
> that the reporting device is an ATAPI device and the command in
> question is not a regular IO one.  That's why EH ignores AC_ERR_DEV o=
r
> AC_ERR_OTHER if ATA_QCFLAG_SENSE_VALID is set.  This doesn't work out
> for the new ATA usage at all.
>=20
I've just mapped onto ATA_QCFLAGS_SENSE_VALID as I've found this to
reasonably close to what I've been needing.
If that's the wrong choice of course I can modify this.

> For now, I've reverted the changes as this is actively detrimental.
>=20
Oh. So you've tested this on a device with autosense enabled?
I haven't seen any negative effects with this patchset, autosense
enabled or not.

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
