From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] fc transport: pre-emptively terminate i/o upon	dev_loss_tmo
Date: Wed, 22 Apr 2009 14:18:29 -0500
Message-ID: <49EF6D85.6060404@cs.wisc.edu>
References: <1240423291.27035.3.camel@ogier>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:52358 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071AbZDVTSi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Apr 2009 15:18:38 -0400
In-Reply-To: <1240423291.27035.3.camel@ogier>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org, "ralphw@linux.vnet.ibm.com" <ralphw@linux.vnet.ibm.com>, Abhijeet Joglekar <ajoglekar@nuovasystems.com>

James Smart wrote:
> Mike, Ralph,
>=20
> See if this helps. It compiles, but I haven't tested it.
>=20
> This modifies the final deletion steps, after dev_loss_tmo has fired,
> such that we keep a flag indicating we're deleting, and we only clear
> the flag once the additional steps that we had to perform w/o lock,
> are complete.  Then, in fc_remote_port_add(), when we fall into the
> case of using the rports for the bindings, which corresponds to the
> "open" unlocked code area, we stall and wait for the delete to
> finish before completing the rest of the add.
> =EF=BB=BF
> I'm a little nervous about the delay in fc_remote_port_add, but it
> should be quick, and our callees should be in a context that it's
> allowed.
>=20

I think we can just revert the patch if you want. I do not think it is=20
needed for the fnic driver anymore. It was needed because fnic needed=20
the rport port id to be set when terminate_rport_io was called right? I=
=20
do not think it is needed now, because it looks like the driver will=20
look that up from another code path now.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
