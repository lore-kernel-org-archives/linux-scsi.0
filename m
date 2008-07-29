From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: tools support for non-512 byte sector sizes
Date: Wed, 30 Jul 2008 08:41:51 +0900
Message-ID: <20080730084114R.fujita.tomonori@lab.ntt.co.jp>
References: <yq13alsr0g0.fsf@sermon.lab.mkp.net>
	<488F6758.8080907@redhat.com>
	<1217357774.6103.54.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:57728 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100AbYG2Xou (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jul 2008 19:44:50 -0400
In-Reply-To: <1217357774.6103.54.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: rwheeler@redhat.com, martin.petersen@oracle.com, matthew@wil.cx, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jim@meyering.net, linux-kernel@vger.kernel.org, jeff@garzik.org, Matt_Domsch@Dell.com, fujita.tomonori@lab.ntt.co.jp

On Tue, 29 Jul 2008 13:56:14 -0500
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Tue, 2008-07-29 at 14:54 -0400, Ric Wheeler wrote:
> > Martin K. Petersen wrote:
> > >>>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:
> > >>>>>>             
> > >
> > > James> The problem, which ata_ram also suffers, is that the tools we
> > > James> most need to test are the ones for manipulating non volatile
> > > James> characteristics (like partition tables).  We'd really like the
> > > James> disk contents to survive reboot for this ...
> > >
> > > Yeah, I should add that I wanted persistence too.  I went through a
> > > whole stack (well, 5-6 or so) fibre channel drives from various
> > > vendors and attempted to low-level format them to 4KB sectors.  Most
> > > of them laughed in my face.  One of them tried to comply and
> > > irreparably confused its firmware in the process.
> > >
> > > Just yesterday I received a couple of prototype drives in the mail.
> > > I'll ask the vendor whether they support 4KB and if so I'll give them
> > > a whirl.
> > >   
> > Isn't this a great use case for a SCSI target device where our target 
> > can be a software disk on a remote host? What is missing for us to put 
> > something like that together?
> 
> Technically nothing.  Tomo should already have one for the STGT test
> infrastructure (I've cc'd him).

Yeah, stgt also enables you to use a software media changer and a
software DVD drive (and we are working on VTL).

http://stgt.berlios.de/

You can connect to a remote host with iSCSI. FCoE might work since
Mike Christie has used stgt to work on the FCoE initiator driver.

stgt doesn't support non-512 byte sector sizes now but I'll add the
support shortly. I want to try DIF with iSCSI and FCoE.
