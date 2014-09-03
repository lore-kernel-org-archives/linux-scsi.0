From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 22/22] sd: Reduce logging output
Date: Wed, 03 Sep 2014 09:58:39 +0200
Message-ID: <5406CA2F.7070800@suse.de>
References: <1409247216-76074-1-git-send-email-hare@suse.de> <1409247216-76074-23-git-send-email-hare@suse.de> <20140831222923.GN16432@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57102 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbaICH6l (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Sep 2014 03:58:41 -0400
In-Reply-To: <20140831222923.GN16432@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, Robert Elliot <elliot@hp.com>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>

On 09/01/2014 12:29 AM, Christoph Hellwig wrote:
> On Thu, Aug 28, 2014 at 07:33:36PM +0200, Hannes Reinecke wrote:
>> There is no need to print out the command result verbatim;
>> that will be done by the scsi stack if required.
>> Here we just should log the result in short if requested.
>=20
> Is there any good reason to keep this logging in sd at all?
>=20
Mainly orthogonality.
SCSI_LOG_HL(QUEUE|COMPLETE) is meant for ULDs to print out
some extra logging.
So as sd.c already uses SCSI_LOG_HLQUEUE to print information
about I/O start it should also be using SCSI_LOG_HLCOMPLETE
upon I/O finish.
And should preferable record the same information at both
instances so that any admin can match them together.

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
