From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: [PATCH] Use a more selective error recovery strategy based on
 device capabilities
Date: Wed, 13 Feb 2013 09:46:13 -0600
Message-ID: <511BB545.7060600@tributary.com>
References: <511A87CA.5010901@tributary.com> <511B8FBF.9000705@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.58]:49828 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934166Ab3BMPqQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Feb 2013 10:46:16 -0500
In-Reply-To: <511B8FBF.9000705@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Linux Scsi <linux-scsi@vger.kernel.org>, "Elliott, Robert (Server Storage)" <Elliott@hp.com>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 2/13/2013 7:06 AM, Hannes Reinecke wrote:

> But unfortunately it failed the reality check; of my zoo of storage arrays
> only NetApp OnTap 8.X and HP P2000 supports the REPORT SUPPORTED TASK
> MANAGEMENT FUNCTIONS command. None of the others (HP EVA, NetApp E-Series,
> EMC Clariion CX-3) do.

	I'm not really surprised. I've had better luck with devices that report
compliance with more recent versions of the specification. Of the those, I
would guess slightly more than 50% support it. That includes tape drives,
changer devices, and raid controllers. Of the ones I've tested that support
it, they almost always report 0xDA for the first byte. Which correspond to
abort task, abort task set, clear task set, lun reset and target reset.

	The patch also includes some "reasonable" defaults based on SCSI version,
which I think vastly improves the overall error handling situation. Querying
the device is just the last little icing.

	But its a chicken and egg thing, the command is optional, hardly anyone sends
it, so few of the device manufactures have implemented it.









-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJRG7VFAAoJEL5i86xrzcy7TjwH/R/V52LW66OPSwWVJHjVcbM/
ZQ7ekWZ48oKy4zQrCjpyKMFXqsH5gsMinoruUhiu/Zt8kmef88jti+aMe1RDyCbp
L2fFc5lUOIpHFkzWXCykq8f9ZDcxIi8cLcCR08S71gTZqo/E0gVqYKEzInXtATCQ
HK9yjX7g3FkzYVl9ASiLeBPUT4/kk7IhN+iagc0S+VY8zBG/+jQC9RykenbnAUU1
YLmWsWmzyWiTshk+vmBBpcikk+EEnB25NXZz6cqDSWGcm/wWq4Mcj9i6KvC9tKSr
PzW+0/T2LtedGCTZKnFgNsn1jMJtjId+soAt5Ho4nZD+BHYcr2iSckzWxX3defs=
=hDMi
-----END PGP SIGNATURE-----
