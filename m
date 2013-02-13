From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Use a more selective error recovery strategy based on
 device capabilities
Date: Wed, 13 Feb 2013 14:06:07 +0100
Message-ID: <511B8FBF.9000705@suse.de>
References: <511A87CA.5010901@tributary.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41860 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933965Ab3BMNGJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Feb 2013 08:06:09 -0500
In-Reply-To: <511A87CA.5010901@tributary.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Linton <jlinton@tributary.com>
Cc: Linux Scsi <linux-scsi@vger.kernel.org>, "Elliott, Robert (Server Storage)" <Elliott@hp.com>

On 02/12/2013 07:19 PM, Jeremy Linton wrote:
> Ideally, Linux should not be sending task management commands to devi=
ces that
> don't support the given task mgmt operation.
>
> This patch uses the REPORT SUPPORTED TASK MGMT FUNCTIONS command to e=
nable or
> disable error recovery paths for a given device. For older devices, w=
e make an
> educated guess about what kind of error recovery the device supports.=
 This isn't
> going to be 100% accurate as it should probably take the transport as=
 well as
> the SCSI version into account, but it is a start.
>
> While this patch improves the error recovery paths for modern SCSI ne=
tworks, the
> error recovery logic continues to fall through to host reset. It also=
 continues
> to send bus and target resets in cases where they may affect working =
devices. I
> have a partial set of patches which attempt to make intelligent decis=
ions in
> these cases, but they are far more intrusive and at this point not as=
 clear cut.
>
>
> Just in case...
> Signed-off-by: Jeremy Linton <jlinton@tributary.com>

Nice concept.

But unfortunately it failed the reality check; of my zoo of storage=20
arrays only NetApp OnTap 8.X and HP P2000 supports the
REPORT SUPPORTED TASK MANAGEMENT FUNCTIONS command.
None of the others (HP EVA, NetApp E-Series, EMC Clariion CX-3) do.

So implementing this command won't buy us much, as it'll default to=20
the original behaviour for most cases ...

(Not prejudicing any market share here, of course :-)

Too bad.

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
