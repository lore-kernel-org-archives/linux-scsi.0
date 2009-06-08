From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/6] SCSI: simplify target destruction
Date: Mon, 08 Jun 2009 09:51:47 +0200
Message-ID: <4A2CC313.1030703@suse.de>
References: <Pine.LNX.4.44L0.0905291555370.2648-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:44227 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171AbZFHHvq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Jun 2009 03:51:46 -0400
In-Reply-To: <Pine.LNX.4.44L0.0905291555370.2648-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Kay Sievers <kay.sievers@vrfy.org>, SCSI development list <linux-scsi@vger.kernel.org>

Hi Alan,

Alan Stern wrote:
> This patch (as1249) adds an extra state, STARGET_NEW, to the SCSI
> target state model.  A target is in this state initially and changes
> over to STARGET_CREATED when the hostt->target_alloc() call has been
> made.
>=20
> This simplifies target destruction.  There's no need for a separate
> scsi_target_destroy() function; everything can be handled within
> scsi_target_reap().  The error paths are more robust because now it's
> easy to verify that all the destructors are called along every
> pathway.
>=20
Hmm. Is there a specific reason why we have to keep the ->reap_ref
counter around and cannot use the 'normal' driver core reference
counting for this?
Duplicating refcounting doesn't seem logical to me, given that
we already have a 'struct device' hanging about ...

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
