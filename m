From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/3] scsi: improved eh timeout handler
Date: Mon, 04 Nov 2013 14:36:01 +0100
Message-ID: <5277A2C1.6020407@suse.de>
References: <1383224573-113346-1-git-send-email-hare@suse.de> <1383224573-113346-3-git-send-email-hare@suse.de> <20131031154905.GA10451@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49196 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018Ab3KDNgH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Nov 2013 08:36:07 -0500
In-Reply-To: <20131031154905.GA10451@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>

On 10/31/2013 04:49 PM, Christoph Hellwig wrote:
> Looks reasonable to me, but a few minor nitpicks:
>=20
>> +	spin_lock_irqsave(sdev->host->host_lock, flags);
>> +	if (scsi_host_eh_past_deadline(sdev->host)) {
>=20
> I don't have the implementation of scsi_host_eh_past_deadline in my
> local tree, but do we really need the host lock for it?
>=20
Yes. The eh_deadline variable might be set from an interrupt context
or from userland, so we need to protect access to it.

>> +int
>> +scsi_abort_command(struct scsi_cmnd *scmd)
>=20
> Seems like this should be static and not exported in the current vers=
ion
> of the code?
>=20
Yep. Will be doing so.

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
