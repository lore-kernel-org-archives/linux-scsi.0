From: Hannes Reinecke <hare@suse.de>
Subject: Re: question on block-layer timeout change
Date: Wed, 17 Dec 2008 08:33:27 +0100
Message-ID: <4948AB47.6090505@suse.de>
References: <3568BBCB98C00041A9E622952FD5F24EA11C9F3A@cosmail03.lsi.com> <20081112072919.GB12192@linux.vnet.ibm.com> <3568BBCB98C00041A9E622952FD5F24EA1226673@cosmail03.lsi.com> <20081114171823.GA16575@us.ibm.com> <3568BBCB98C00041A9E622952FD5F24EA135D754@cosmail03.lsi.com> <4940F367.506@suse.de> <3568BBCB98C00041A9E622952FD5F24EA13B99A3@cosmail03.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:42030 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608AbYLQHd3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Dec 2008 02:33:29 -0500
In-Reply-To: <3568BBCB98C00041A9E622952FD5F24EA13B99A3@cosmail03.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Shi, Harris" <Harris.Shi@lsi.com>
Cc: "malahal@us.ibm.com" <malahal@us.ibm.com>, Mike Anderson <andmike@linux.vnet.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>

Hi Harris,

Shi, Harris wrote:
> Hannes,=20
>=20
> Just let you know that the same panic is still there in SLES11RC1. Ph=
ilip should
> be able to help us to report it in Novell Bugzilla.=20
>
Ah. It might be related to the wrong scsi_device_online() check (cf my =
patch
'Check for deleted device in scsi_device_online()' earlier on this list=
).
Problem is that the error handler just checks with scsi_device_online()=
 if
a command can be sent down the wire.
And so for a failed/deleted devices the error handler just barfs at ran=
dom
places.
Can you check if this patch resolves the issue?

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
