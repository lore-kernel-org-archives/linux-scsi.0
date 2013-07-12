From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv3 0/9] New EH command timeout handler
Date: Fri, 12 Jul 2013 08:09:52 +0200
Message-ID: <51DF9DB0.7080502@suse.de>
References: <1372688671-85639-1-git-send-email-hare@suse.de> <51DF82B9.8030406@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45631 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480Ab3GLGJ4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Jul 2013 02:09:56 -0400
In-Reply-To: <51DF82B9.8030406@cn.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ren Mingxin <renmx@cn.fujitsu.com>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Bart van Assche <bvanassche@acm.org>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>, Roland Dreier <roland@purestorage.com>

On 07/12/2013 06:14 AM, Ren Mingxin wrote:
> Hi, Hannes:
>=20
> On 07/01/2013 10:24 PM, Hannes Reinecke wrote:
>> With the original SCSI EH I got:
>> # time dd if=3D/dev/zero of=3D/dev/dm-2 bs=3D4k count=3D4k oflag=3Dd=
irect
>> 4096+0 records in
>> 4096+0 records out
>> 16777216 bytes (17 MB) copied, 142.652 s, 118 kB/s
>>
>> real    2m22.657s
>> user    0m0.013s
>> sys    0m0.145s
>>
>> With this patchset I got:
>> # time dd if=3D/dev/zero of=3D/dev/dm-2 bs=3D4k count=3D4k oflag=3Dd=
irect
>> 4096+0 records in
>> 4096+0 records out
>> 16777216 bytes (17 MB) copied, 52.1579 s, 322 kB/s
>>
>> real    0m52.163s
>> user    0m0.012s
>> sys    0m0.145s
>>
>> Test was to disable RSCN on the target port, disable the
>> target port, and then start the 'dd' command as indicated.
>=20
> Do you mean disabling RSCN/port is enough? I'm afraid I couldn't
> reproduce the problem by your steps. Both with and without your
> patchset are the same 'dd' result: 27s. Please let me know where I
> neglected or mistook:
>=20
> 1) I made a dm-multipath target 'dm-0' whose grouping policy was
>    failover;
> 2) Disable RSCN/port via brocade fc switch:
>    SW300:root> portcfg rscnsupr 15 --enable; portDisable 15
> 3) Start the 'dd' command:
>    # time dd if=3D/dev/zero of=3D/dev/dm-0 bs=3D4k count=3D4k oflag=3D=
direct
>    dd: writing `/dev/sde': Input/output error
>    1+0 records in
>    0+0 records out
>    0 bytes (0 B) copied, 27.8588 s, 0.0 kB/s
>=20
>    real    0m27.860s
>    user    0m0.001s
>    sys     0m0.000s

You are aware that you have to disable RSCNs on the _target_ port,
right?
Disabling RSCNs on the _initiator_ ports is a well-tested case, and
the one which actually makes sense (and is even implemented in
QLogic switches).
Disabling RSCNs for the _target_ port, OTOH, has a very questionable
nature (hence QLogic switches don't even allow you to do this).

[ .. ]

> Another question:
>=20
> I also tried to produce timeouts by modifying Yasui's module(please
> see APPENDIX A):
> http://www.spinics.net/lists/linux-scsi/msg35091.html
>=20
> But I got a bug with your this patchset by follwing steps(there was
> not such bug without your patchset):
>=20
> # grep lpfc_template /proc/kallsyms
> ffffffffa00f9240 d lpfc_template    [lpfc]
> # multipath -ll
> ...
> mpathb (36000b5d0006a0000006a14e7000c0000) dm-1 FUJITSU,ETERNUS_DX400
> size=3D50G features=3D'1 queue_if_no_path' hwhandler=3D'0' wp=3Drw
> |-+- policy=3D'round-robin 0' prio=3D130 status=3Dactive
> | `- 2:0:0:1 sdf 8:80  active ready running
> `-+- policy=3D'round-robin 0' prio=3D130 status=3Denabled
>   `- 3:0:0:1 sdh 8:112 active ready running
> # insmod scsi_tmo_mod.ko param=3D0xffffffffa00f9240,2:0:0:1; time dd
> if=3D/dev/zero of=3D/dev/dm-1 bs=3D4k count=3D4k oflag=3Ddirect
> 4096+0 records in
> 4096+0 records out
> 16777216 bytes (17 MB) copied, 151.194 s, 111 kB/s
>=20
> real    2m31.195s
> user    0m0.004s
> sys    0m0.111s
>=20
> Please see logs in APPENDIX B. Do you think this bug is irrelevant to
> your patchset?
>=20
Hmm. No, sadly not.

'cancel_work_sync' cannot be called from an interrupt context;
guess I'll need to convert it to delayed work.

Thanks for testing; will be updating the patchset.

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
