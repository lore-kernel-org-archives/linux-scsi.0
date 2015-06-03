From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: linux-next: build failure after merge of the target-updates tree
Date: Wed, 03 Jun 2015 15:33:32 -0700
Message-ID: <1433370812.2251.140.camel@HansenPartnership.com>
References: <20150603181607.70cef830@canb.auug.org.au>
	 <1433361639.2251.111.camel@HansenPartnership.com>
	 <1433369576.18125.7.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <1433369576.18125.7.camel@haakon3.risingtidesystems.com>
Sender: linux-next-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2015-06-03 at 15:12 -0700, Nicholas A. Bellinger wrote:
> On Wed, 2015-06-03 at 13:00 -0700, James Bottomley wrote:
> > On Wed, 2015-06-03 at 18:16 +1000, Stephen Rothwell wrote:
> > > Hi Nicholas,
> > > 
> > > After merging the target-updates tree, today's linux-next build (x86_64
> > > allmodconfig) failed like this:
> > > 
> > > drivers/target/target_core_fabric_lib.c: In function 'target_get_pr_transport_id_len':
> > > drivers/target/target_core_fabric_lib.c:364:7: error: 'SCSI_PROTOCOL_FCP' undeclared (first use in this function)
> > >   case SCSI_PROTOCOL_FCP:
> > >        ^
> > > drivers/target/target_core_fabric_lib.c:364:7: note: each undeclared identifier is reported only once for each function it appears in
> > > drivers/target/target_core_fabric_lib.c:365:7: error: 'SCSI_PROTOCOL_SBP' undeclared (first use in this function)
> > >   case SCSI_PROTOCOL_SBP:
> > >        ^
> > > drivers/target/target_core_fabric_lib.c:366:7: error: 'SCSI_PROTOCOL_SRP' undeclared (first use in this function)
> > >   case SCSI_PROTOCOL_SRP:
> > >        ^
> > > drivers/target/target_core_fabric_lib.c:367:7: error: 'SCSI_PROTOCOL_SAS' undeclared (first use in this function)
> > >   case SCSI_PROTOCOL_SAS:
> > >        ^
> > > drivers/target/target_core_fabric_lib.c:369:7: error: 'SCSI_PROTOCOL_ISCSI' undeclared (first use in this function)
> > >   case SCSI_PROTOCOL_ISCSI:
> > >        ^
> > > drivers/target/target_core_fabric_lib.c: In function 'target_get_pr_transport_id':
> > > drivers/target/target_core_fabric_lib.c:388:7: error: 'SCSI_PROTOCOL_SAS' undeclared (first use in this function)
> > >   case SCSI_PROTOCOL_SAS:
> > >        ^
> > > drivers/target/target_core_fabric_lib.c:390:7: error: 'SCSI_PROTOCOL_SBP' undeclared (first use in this function)
> > >   case SCSI_PROTOCOL_SBP:
> > >        ^
> > > drivers/target/target_core_fabric_lib.c:392:7: error: 'SCSI_PROTOCOL_SRP' undeclared (first use in this function)
> > >   case SCSI_PROTOCOL_SRP:
> > >        ^
> > > drivers/target/target_core_fabric_lib.c:394:7: error: 'SCSI_PROTOCOL_FCP' undeclared (first use in this function)
> > >   case SCSI_PROTOCOL_FCP:
> > >        ^
> > > drivers/target/target_core_fabric_lib.c:396:7: error: 'SCSI_PROTOCOL_ISCSI' undeclared (first use in this function)
> > >   case SCSI_PROTOCOL_ISCSI:
> > >        ^
> > > drivers/target/target_core_fabric_lib.c: In function 'target_parse_pr_out_transport_id':
> > > drivers/target/target_core_fabric_lib.c:411:7: error: 'SCSI_PROTOCOL_SAS' undeclared (first use in this function)
> > >   case SCSI_PROTOCOL_SAS:
> > >        ^
> > > drivers/target/target_core_fabric_lib.c:418:7: error: 'SCSI_PROTOCOL_SBP' undeclared (first use in this function)
> > >   case SCSI_PROTOCOL_SBP:
> > >        ^
> > > drivers/target/target_core_fabric_lib.c:419:7: error: 'SCSI_PROTOCOL_SRP' undeclared (first use in this function)
> > >   case SCSI_PROTOCOL_SRP:
> > >        ^
> > > drivers/target/target_core_fabric_lib.c:420:7: error: 'SCSI_PROTOCOL_FCP' undeclared (first use in this function)
> > >   case SCSI_PROTOCOL_FCP:
> > >        ^
> > > drivers/target/target_core_fabric_lib.c:423:7: error: 'SCSI_PROTOCOL_ISCSI' undeclared (first use in this function)
> > >   case SCSI_PROTOCOL_ISCSI:
> > >        ^
> > > 
> > > Caused by commit 2650d71e244f ("target: move transport ID handling to
> > > the core") interacting with commit ba929992522b ("target: Minimize SCSI
> > > header #include directives") from the scsi tree.
> > > 
> > > I have added this merge fix patch for today:
> > > 
> > > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > > Date: Wed, 3 Jun 2015 18:10:46 +1000
> > > Subject: [PATCH] target: explicitly include scsi_proto.h in target_core_fabric_lib.c
> > > 
> > > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > > ---
> > >  drivers/target/target_core_fabric_lib.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > > 
> > > diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
> > > index b05578b5b4a0..cb6497ce4b61 100644
> > > --- a/drivers/target/target_core_fabric_lib.c
> > > +++ b/drivers/target/target_core_fabric_lib.c
> > > @@ -35,6 +35,8 @@
> > >  #include <linux/spinlock.h>
> > >  #include <linux/export.h>
> > >  
> > > +#include <scsi/scsi_proto.h>
> > > +
> > >  #include <target/target_core_base.h>
> > >  #include <target/target_core_fabric.h>
> > 
> > OK, this gives us a cross tree dependency on the SCSI header split
> > patches.  Nic, if you base your tree off this commit in mine, I'll make
> > sure to push early in the merge window.
> > 
> > commit ba929992522b6d1f866b7021bc50da66f8fdd743
> > Author: Bart Van Assche <bart.vanassche@sandisk.com>
> > Date:   Fri May 8 10:11:12 2015 +0200
> > 
> >     target: Minimize SCSI header #include directives
> > 
> 
> Rebasing one subsystem's for-next atop another subsystem's for-next is a
> sure fire way to cause Linus to become irate.

No, he's fine with it (as long as the trees aren't entangled when
submitted). We used to do it all the time with the block and SCSI trees;
it's why the scsi postmerge tree existed.

> But it's not even necessary here anyways, just fold Stephen's patch to
> add scsi_proto.h to target_core_fabric_configfs.c into the original
> change, and be done with it.

I can certainly do that, but other updates to the target tree could
cause this problem to reoccur in different files.

James
