From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Protect against overflow in dev_loss_tmo
Date: Wed, 17 Mar 2010 10:40:56 +0100
Message-ID: <4BA0A3A8.8050905@suse.de>
References: <20100309091848.4C7412BD8B@ochil.suse.de> <4B9657CD.6000805@emulex.com> <20100316130454.GA15772@schmichrtp.mainz.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35017 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946Ab0CQJk6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Mar 2010 05:40:58 -0400
In-Reply-To: <20100316130454.GA15772@schmichrtp.mainz.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: James Smart <james.smart@emulex.com>, James Bottomley <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Christof Schmitt wrote:
> On Tue, Mar 09, 2010 at 09:14:37AM -0500, James Smart wrote:
>> I don't ever expect to see large dev_loss_tmo values, but the patch =
is fine.
>>
>> Acked-by: James Smart <james.smart@emulex.com>
>>
>> -- james s
>>
>>
>> Hannes Reinecke wrote:
>>> The rport structure defines dev_loss_tmo as u32, which is
>>> later multiplied with HZ to get the actual timeout value.
>>> This might overflow for large dev_loss_tmo values. So we
>>> should be better using u64 as intermediate variables here
>>> to protect against overflow.
>>>
>>> Signed-off-by: Hannes Reinecke <hare@suse.de>
> [...]
>=20
> I guess this is the intended use to prevent the dev_loss_tmo from
> removing the SCSI devices:
> http://git.kernel.org/?p=3Dlinux/kernel/git/hare/multipath-tools.git;=
a=3Dcommitdiff;h=3Db9903e2e8a6cdc5042897719fbae6c9346820bbf;hp=3Ded1dc6=
164fe530d146cfe65d4f99e44ec9b54b95
>=20
> But does this raise the question again how to run SCSI EH with remote
> port failures?
>=20
> The SCSI FC LLDs call fc_block_scsi_eh to wait until the fc_rport
> leaves the state FC_PORTSTATE_BLOCKED. This effectively prevents SCSI
> devices from being taken offline when there is a command timeout and
> the fc_rport is BLOCKED. With the large dev_loss_tmo, the dev_loss_tm=
o
> never expires and a problem with a single remote port can block the
> host error handler.
>=20
I was under the impression that terminate_rport_io() would cancel/termi=
nate
all outstanding I/O, while any new I/O would be blocked due to FC_PORTS=
TATE_BLOCKED.

A device would only be taken offline if the full error recovery is run,
something we cannot do (reliably) if the path is down, so from that
point of view it totally reasonable to defer the error recovery here.

However, I'm curious as how one could get into that state while
the port is blocked.
The only way I can imagine is that an I/O has started before the
port entered FC_PORTSTATE_BLOCKED, and would return (with error)
before terminate_rport_io has been called.
So eh would be delayed due to fc_block_scsi_eh().
But I would have assumed that terminate_rport_io() would terminate
even this failing I/O with DID_TRANSPORT_FAILFAST (or somesuch),
thus avoiding proper eh altogether.

Am I wrong here?

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
