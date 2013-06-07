From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/4] New SCSI command timeout handler
Date: Fri, 07 Jun 2013 09:31:18 +0200
Message-ID: <51B18C46.8050205@suse.de>
References: <1370511835-50072-1-git-send-email-hare@suse.de> <51B18398.6000508@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41045 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754Ab3FGHbU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Jun 2013 03:31:20 -0400
In-Reply-To: <51B18398.6000508@cn.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ren Mingxin <renmx@cn.fujitsu.com>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Joern Engel <joern@logfs.org>, Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Roland Dreier <roland@purestorage.com>, Bryn Reeves <bmr@redhat.com>, Christoph Hellwig <hch@infradead.org>

On 06/07/2013 08:54 AM, Ren Mingxin wrote:
> Hi, Hannes:
>=20
> On 06/06/2013 05:43 PM, Hannes Reinecke wrote:
>> this is the first step towards a new non-blocking
>> error handler. This patch implements a new command
>> timeout handler which will be sending command aborts
>> inline without engaging SCSI EH.
>>
>> In addition the commands will be returned directly
>> if the command abort succeeded, cutting down recovery
>> times dramatically.
>>
>> With the original scsi error recovery I got:
>> # time dd if=3D/dev/zero of=3D/mnt/test.blk bs=3D512 count=3D2048 of=
lag=3Dsync
>> 2048+0 records in
>> 2048+0 records out
>> 1048576 bytes (1.0 MB) copied, 3.72732 s, 281 kB/s
>>
>> real    2m14.475s
>> user    0m0.000s
>> sys    0m0.104s
>>
>> with this patchset I got:
>> # time dd if=3D/dev/zero of=3D/mnt/test.blk bs=3D512 count=3D2048 of=
lag=3Dsync
>> 2048+0 records in
>> 2048+0 records out
>> 1048576 bytes (1.0 MB) copied, 31.5151 s, 33.3 kB/s
>>
>> real    0m31.519s
>> user    0m0.000s
>> sys    0m0.088s
>>
>> Test was to disable RSCN on the target port, disable the
>> target port, and then start the 'dd' command as indicated.
>>
>> As a proof-of-concept I've also enabled the new timeout
>> handler for virtio, so that things can be tested out
>> more easily.
>=20
> So this 31.5s is tested on virtio disks, right? Much faster than your
> former test via fc.
>=20
No. This was done on HP Proliant /QLogic FC running against HP P2000.

There is a reason why I posted this new patchset :-)

(The old patchset had a bug where it wouldn't abort the TUR send by
multipaths path-checker. Which were causing delays during
switchover. This version now does terminate them properly)
(Incidentally, it was the non-working scsi_noretry_cmd() which
caused this bug :-)

> This approach may not work for some LLDDs as you said, but I wonder
> whether SAS is applicable(whether there will be later patches for
> SAS).
>=20
SAS should be applicable for this, too. I'll check.

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
