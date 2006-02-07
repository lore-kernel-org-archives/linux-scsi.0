From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/3] aic79xx: convert qfrozen to atomic_t
Date: Tue, 07 Feb 2006 12:30:55 +0100
Message-ID: <43E884EF.5040704@suse.de>
References: <43E851D2.1060306@suse.de> <20060207110055.GA13539@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39342 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S964835AbWBGLbI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Feb 2006 06:31:08 -0500
In-Reply-To: <20060207110055.GA13539@infradead.org>
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
> Is ahd_freeze_simq called recursively at all?  If not it would be muc=
h
> better to just kill it completely and just rely on the block layer, a=
s
> we do in all the other drivers.
>=20

As in

void
ahd_freeze_simq(struct ahd_softc *ahd)
{
	scsi_block_requests(ahd->platform_data->host);
}

?

Hmm. Looks as if this could work ...

Lemme check.

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
