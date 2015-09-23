From: Hannes Reinecke <hare@suse.de>
Subject: Re: Question about expected behavior of terminate_rport_io() in
 fc_function_template
Date: Wed, 23 Sep 2015 23:05:33 +0200
Message-ID: <5603141D.20000@suse.de>
References: <20150923170616.GA16814@bblock-ThinkPad-W530>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54600 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755350AbbIWVGm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Sep 2015 17:06:42 -0400
In-Reply-To: <20150923170616.GA16814@bblock-ThinkPad-W530>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Block <bblock@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, "James E.J. Bottomley" <JBottomley@odin.com>

On 09/23/2015 07:06 PM, Benjamin Block wrote:
> Hello,
>=20
> just a short question. If a low-level driver implements the function
> `terminate_rport_io()` in `struct fc_function_template`, and it gets
> called after IO failed, is the low-level driver expected to handle th=
is
> request synchronously or can it just schedule an action that is worke=
d on
> asynchronously to the call to the function?
>=20
Actually, it doesn't matter, as 'terminate_rport_io()' should cause the
driver to about outstanding commands. The main idea behind this is that
the driver clears up any additional state it might have tacked onto the
command. And calling '->done()', obviously.

Main goal is to have outstanding I/O returned to the upper layers, so
that things like multipath can redirect outstanding I/O to other paths
and facilitate quick failover.

> Trouble is, we are seeing problems with SCSI-Commands being used by t=
he
> upper layers when we expect them to still be ours, after we got a cal=
l to
> that function and didn't react upon it immediately. They do not conta=
in
> valid content anymore when they should.
>=20
True; after terminate_rport_io() I/O should have been aborted.
However, the SCSI layer really shouldn't reuse commands before ->done()
has been invoked or the command itself has been aborted.

> I've looked into other implementations and it seems there are both
> version, some LLDs explicitly wait upon completions of requests they
> schedule and others just schedule work-items and return. That may
> already be the answer, but I wanted to make sure I am not missing
> something here. The documentation on it is not really existing, or I
> missed it.
>=20
As indicated, the driver is expected to call ->done() on outstanding
commands when terminate_rport_io() is called.
This smells more like an issue with the driver itself; if I were to
guess I would think that some aborts are not handled correctly ...

But it's hard to know without details. Do you have some message log or
something?

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
