From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: Re: Question about expected behavior of terminate_rport_io() in
 fc_function_template
Date: Fri, 25 Sep 2015 15:36:41 +0200
Message-ID: <20150925133641.GA29457@bblock-ThinkPad-W530>
References: <20150923170616.GA16814@bblock-ThinkPad-W530>
 <5603141D.20000@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp07.uk.ibm.com ([195.75.94.103]:41583 "EHLO
	e06smtp07.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932258AbbIYNgw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Sep 2015 09:36:52 -0400
Received: from /spool/local
	by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <bblock@linux.vnet.ibm.com>;
	Fri, 25 Sep 2015 14:36:50 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
	by d06dlp03.portsmouth.uk.ibm.com (Postfix) with ESMTP id 5E73D1B0804B
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2015 14:38:27 +0100 (BST)
Received: from d06av04.portsmouth.uk.ibm.com (d06av04.portsmouth.uk.ibm.com [9.149.37.216])
	by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8PDagu333947700
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2015 13:36:42 GMT
Received: from d06av04.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av04.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8PDagQm029423
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2015 07:36:42 -0600
Received: from bblock-ThinkPad-W530 (dyn-9-152-222-85.boeblingen.de.ibm.com [9.152.222.85])
	by d06av04.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVin) with ESMTP id t8PDafp5029418
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2015 07:36:41 -0600
Content-Disposition: inline
In-Reply-To: <5603141D.20000@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, "James E.J. Bottomley" <JBottomley@odin.com>

Hej Hannes,

thx for the short explanation.

On 23:05 Wed 23 Sep     , Hannes Reinecke wrote:
> On 09/23/2015 07:06 PM, Benjamin Block wrote:
> > Hello,
> >=20
> > just a short question. If a low-level driver implements the functio=
n
> > `terminate_rport_io()` in `struct fc_function_template`, and it get=
s
> > called after IO failed, is the low-level driver expected to handle =
this
> > request synchronously or can it just schedule an action that is wor=
ked on
> > asynchronously to the call to the function?
> >=20
> Actually, it doesn't matter, as 'terminate_rport_io()' should cause t=
he
> driver to about outstanding commands. The main idea behind this is th=
at
> the driver clears up any additional state it might have tacked onto t=
he
> command. And calling '->done()', obviously.
>=20
> Main goal is to have outstanding I/O returned to the upper layers, so
> that things like multipath can redirect outstanding I/O to other path=
s
> and facilitate quick failover.
>

Yeah, that is what I thought as well, after I read the initial patch
that introduced that function to the template and stack. Makes much mor=
e
sense then an implicit rule.

>=20
> > Trouble is, we are seeing problems with SCSI-Commands being used by=
 the
> > upper layers when we expect them to still be ours, after we got a c=
all to
> > that function and didn't react upon it immediately. They do not con=
tain
> > valid content anymore when they should.
> >=20
> True; after terminate_rport_io() I/O should have been aborted.
> However, the SCSI layer really shouldn't reuse commands before ->done=
()
> has been invoked or the command itself has been aborted.
>=20
> > I've looked into other implementations and it seems there are both
> > version, some LLDs explicitly wait upon completions of requests the=
y
> > schedule and others just schedule work-items and return. That may
> > already be the answer, but I wanted to make sure I am not missing
> > something here. The documentation on it is not really existing, or =
I
> > missed it.
> >=20
> As indicated, the driver is expected to call ->done() on outstanding
> commands when terminate_rport_io() is called.
> This smells more like an issue with the driver itself; if I were to
> guess I would think that some aborts are not handled correctly ...
>=20
> But it's hard to know without details. Do you have some message log o=
r
> something?
>=20

It may well be that this is a problem in the driver. I am still working
on it, I have logs but those are very messy because the test load
involves LVM volumes with multiple LUNs and multipathing, and I am
trying to reduce it in order to be better able to debug it.



                                                    Beste Gr=FC=DFe / B=
est regards,
                                                      - Benjamin Block
--=20
Linux on z Systems Development         /         IBM Systems & Technolo=
gy Group
                  IBM Deutschland Research & Development GmbH
                Vorsitzende des Aufsichtsrats: Martina Koederitz
       Gesch=E4ftsf=FChrung: Dirk Wittkopp / Sitz der Gesellschaft: B=F6=
blingen
               Registergericht: Amtsgericht Stuttgart, HRB 243294

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
