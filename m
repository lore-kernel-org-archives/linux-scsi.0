From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/3] scsi_dh: Add modalias support for SCSI targets
Date: Wed, 8 Apr 2009 01:22:33 +0200
Message-ID: <20090407232233.GE24591@pentland.suse.de>
References: <20090318013615.26548.36303.sendpatchset@chandra-ubuntu> <20090318013621.26548.10529.sendpatchset@chandra-ubuntu> <ac3eb2510903181130s5dd1b1caje579d765fd338f6f@mail.gmail.com> <1237403902.14147.25.camel@chandra-ubuntu> <1237488880.26341.15.camel@chandra-ubuntu> <49C3DF49.8050408@redhat.com> <1237846429.14853.6.camel@chandra-ubuntu> <1238798590.20924.0.camel@chandra-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45596 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759637AbZDGXWf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Apr 2009 19:22:35 -0400
Content-Disposition: inline
In-Reply-To: <1238798590.20924.0.camel@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sekharan@linux.vnet.ibm.com
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Kay Sievers <kay.sievers@vrfy.org>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, Peter Jones <pjones@redhat.com>

Hi Chandra,

On Fri, Apr 03, 2009 at 03:43:10PM -0700, Chandra Seetharaman wrote:
> Hi James,
>=20
> Do you still have any concerns (after Peter's response) ?
>=20
> If not, Can you accept the patches, please.
>=20
The problem here is that module autoloading doesn't work for
device_handler. We have to have the callbacks in place _before_
driver probing starts as we might need to intercept the I/O
requests and/or errors. When using modalias the module loading
will be too late and the hooks will only be established after
the probing has already happened.
(The module autoloading is an asynchronous call in device_add(),
where we don't write for it to succeed. So probing will continue
and we woulnd't have the callbacks in place when probing=20
starts).

So adding the modalias will be of a purely informational value
which I doubt is worth it.

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
