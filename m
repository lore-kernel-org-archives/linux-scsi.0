From: Hannes Reinecke <hare@suse.de>
Subject: Re: IBM request to allow unprivledged ioctls [Was: Revert "dm mpath:
 fix stalls when handling invalid ioctls"]
Date: Mon, 02 Nov 2015 16:29:03 +0100
Message-ID: <5637813F.7070401@suse.de>
References: <20151029131810.GA26841@redhat.com> <5634DF67.7060302@redhat.com> <20151031181312.GA11587@redhat.com> <5635115B.7080805@redhat.com> <20151031224707.GA12805@redhat.com> <56371095.6020400@suse.de> <20151102133119.GA23234@redhat.com> <56376B8C.5010001@suse.de> <20151102141243.GB23234@redhat.com> <563774F1.7090806@suse.de> <20151102151446.GB23665@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40382 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932117AbbKBP3G (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Nov 2015 10:29:06 -0500
In-Reply-To: <20151102151446.GB23665@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, hch@lst.de, Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org

On 11/02/2015 04:14 PM, Mike Snitzer wrote:
> On Mon, Nov 02 2015 at  9:36am -0500,
> Hannes Reinecke <hare@suse.de> wrote:
[ .. ]
>> From b0d5848e91cfc3b97adb49121085c994b707eac3 Mon Sep 17 00:00:00 20=
01
>> From: Hannes Reinecke <hare@suse.de>
>> Date: Mon, 2 Nov 2015 15:33:58 +0100
>> Subject: [PATCH] dm-mpath: Retry ioctl if paths need to be initializ=
ed
>>
>> If paths need to be initialized (m->queue_io is set) we should
>> be starting the initialization and retry the ioctl to retrieve
>> the final status.
>> At the same time, we should _not_ wait for queue_if_no_path
>> to go away as this might take forever, resulting in the
>> ioctl to be stuck.
>=20
> I understand your goal.. but the patch is a bit incomplete.
>=20
> In your patch the activation is still in progress; so there is no
> bdev.. so it'll yield false positives still.
>=20
Right.

> And DM core has retry via -ENOTCONN.. yet you're adding it to
> multipath_ioctl (meaning nothing will use DM core's retry logic now).
>=20
Yeah, I've just noticed.

> Also, you still haven't established what it is about
> scsi_verify_blk_ioctl() that you see as beneficial.  If we return EAG=
AIN
> to userspace that should "fix" the udev worker issue (so no need for
> extra ioctl verification.. which you're clearly still implicitly
> overloading with the hopes that it is more generally applicable than
> just being concerned about whether an ioctl is valid against a
> partition).
>=20
Personally, I would happily drop the call to scsi_verify_blk_ioctl
altogether; it'll be called via sd_ioctl() later on anyway.
And if we don't have valid/accessible paths I'd rather return an
error code indicating that instead of trying to figure out what the
error would be if we would have had a valid path.

If we can agree on that everything would become _so much_ easier...

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
