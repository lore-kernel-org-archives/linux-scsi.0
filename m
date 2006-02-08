From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/3] aic79xx: convert qfrozen to atomic_t
Date: Wed, 08 Feb 2006 10:42:24 +0100
Message-ID: <43E9BD00.6020700@suse.de>
References: <43E851D2.1060306@suse.de> <20060207185732.GA23340@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:37322 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S1030188AbWBHJmh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Feb 2006 04:42:37 -0500
In-Reply-To: <20060207185732.GA23340@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, "emmanuel.fuste" <emmanuel.fuste@laposte.net>

Christoph Hellwig wrote:
> On Tue, Feb 07, 2006 at 08:52:50AM +0100, Hannes Reinecke wrote:
>> This patch converts platform_data->qfrozen to atomic_t.
>> This way we can get rid of ahd_lock / ahd_unlock for the
>> accessor functions; it also fixes some deadlocks in the
>> recovery code (again).
>=20
> While we're at it there's also a qfrozen variable in the ahd_linux_de=
vice
> structure.  Since the driver lost it's internal queueing it and the
> surrounding core are totally unused.
>=20
Not quite sure (yet) whether we can do this.
dev->qfrozen is also used during error recovery to prevent the SCB bein=
g
reused accidentally.

And as the error recovery is totally buggered anyway I'm loath to
dead-fix it even more. I'll have to investigate that.

But the platform->qfrozen flag can indeed be removed. Just calling
scsi_block_request() is enough here.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
